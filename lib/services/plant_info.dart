import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:langchain/langchain.dart';
import 'package:langchain_google/langchain_google.dart';

class PlantInfoService {
  Future<Map<String, dynamic>?> analyzePlantImage(XFile photo) async {
    final apiKey = dotenv.env['PLANTNET_API_KEY'];

    if (apiKey == null) {
      print('PLANTNET_API_KEY not found'); // close loading
      return null;
    }

    final url = Uri.parse('https://my-api.plantnet.org/v2/identify/all?api-key=$apiKey');
    print("Sending image to Plantnet via Multipart");

    try{
      var request = http.MultipartRequest('POST', url);

      request.files.add(await http.MultipartFile.fromPath('images', photo.path));

      request.files.add(http.MultipartFile.fromString('organs', 'auto'));

      var streamedResponse = await request.send();

      var response = await http.Response.fromStream(streamedResponse);

      if(response.statusCode != 200 && response.statusCode != 201){
        print("Plantnet API Error : ${response.statusCode}");
        print("Resposne body :${response.body}");
        return null;
      }

      final Map<String, dynamic> data = jsonDecode(response.body);

      if(data['results'] == null || data['results'].isEmpty){
        print("No Plant Suggestions found.");
        return null;
      }
      final bestMatchName = data['results'][0]['species']['scientificNameWithoutAuthor'];
      print("Plant Name : $bestMatchName.");

      return await getPlantDetailsFromGemini(bestMatchName);
      
    } catch (e) {
      print("Error communicating with Plantnet API: $e");
      return null;
    }
  }

  Future<Map<String, dynamic>?> getPlantDetailsFromGemini(
    String plantName,
  ) async {
    final apiKey = dotenv.env['GOOGLE_API_KEY'];
    if (apiKey == null) {
      print('GOOGLE API Key not found');
      return null;
    }

    final model = ChatGoogleGenerativeAI(
      apiKey: apiKey,
      defaultOptions: const ChatGoogleGenerativeAIOptions(
        model: 'gemini-2.5-flash',
        temperature: 0.2,
      ),
    );

    final promptTemplate = ChatPromptTemplate.fromPromptMessages([
      SystemChatMessagePromptTemplate.fromTemplate(
        '''You are an expert botanist and plant encyclopedia. 
      When given a scientific or common plant name, you provide accurate, 
      concise and well-structured plant information.
      Always respond in the exact format given to you. 
      Do not add extra information outside the format.
      ''',
      ),
      HumanChatMessagePromptTemplate.fromTemplate('''
      Give the following information on plant: "{plant_name}"
      You MUST respond ONLY with a valid JSON object matching this structure exactly. 
      Format the "common_name" nicely as it will be used as the best match name for the UI header:
      {{
        "common_name" : "The most common english name used in India.",
        "scientific_name" : "Plants scientific name",
        "rarity" : "Rarity of the plant out of 5",
        "environment" : "In which environment is it found the most give in format like 'ARID/SUNNY'.",
        "medical_uses" : ["Short point 1, 5-8 words", "Short point 2, 5-8 words", "Short point 3, 5-8 words"],
        "edibility" : "If edible then give info on how its used in general in short, if not edible or poisonous then mention that",
        "taste" : "If edible, describe what it tastes like in 3-5 words (e.g. 'Bitter, earthy, slightly sweet'). If not edible, use empty string.",
        "harvest_season" : "If edible fruit/vegetable, give the season when it is harvested (e.g. 'Summer (June-August)' or 'Year-round'). If not edible, use empty string.",
        "growth_time" : "If edible fruit/vegetable, give approximate time to grow/harvest (e.g. '90-120 days' or '2-3 years for fruit production'). If not edible, use empty string.",
        "origin" : "origin of the plant",
        "facts" : ["Fact 1, 6-10 words", "Fact 2, 6-10 words", "Fact 3, 6-10 words"]
      }}
      '''),
    ]);

    final chain = promptTemplate.pipe(model).pipe(const StringOutputParser());

    try {
      final String response = await chain.invoke({'plant_name': plantName});
      print(response);

      // Gemini sometimes wraps JSON in markdown blocks like ```json ... ```
      // This cleans it up before parsing if necessary.
      String cleanedResponse = response.trim();
      if (cleanedResponse.startsWith('```json')) {
        cleanedResponse = cleanedResponse.substring(7);
      }
      if (cleanedResponse.startsWith('```')) {
        cleanedResponse = cleanedResponse.substring(3);
      }
      if (cleanedResponse.endsWith('```')) {
        cleanedResponse = cleanedResponse.substring(
          0,
          cleanedResponse.length - 3,
        );
      }

      return jsonDecode(cleanedResponse.trim());
    } catch (e) {
      print("Error fetching from LangChain: $e");
      return null;
    }
  }
}
