import 'dart:convert';

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart';
import 'package:langchain/langchain.dart';
import 'package:langchain_openai/langchain_openai.dart';

class PlantInfoService {
  Future<Map<String, dynamic>?> getPlantDetails(String plantName) async {
    final apiKey = dotenv.env['GROQ_API_KEY'];
    if (apiKey == null) {
      print('GROQ API Key not found');
      return null;
    }

    final model = ChatOpenAI(
      apiKey: apiKey,
      baseUrl: "https://api.groq.com/openai/v1",
      defaultOptions: ChatOpenAIOptions(
        model: 'llama-3.3-70b-versatile',
        temperature: 0.2,
        responseFormat: ChatOpenAIResponseFormatJsonObject(),
      ),
    );
    /* 
    '''
    You are an expert botanist and plant encyclopedia. 
    When given a scientific plant name, you provide accurate, 
    concise and well-structured plant information.
    Always respond in the exact format given to you. 
    Do not add extra information outside the format.

    Give the following information on plant: "{plant_name}" 
    You MUST respond ONLY with a valid JSON object matching this structure exactly:
    {{
      "common_name" : "The most common name used for the plant",
      "scientific_name" : "Plants scientific name",
      "rarity" : "Rarity of the plant out of 5",
      "environment" : "In which environment is it found the most give in format like 'ARID/SUNNY'.",
      "medical_uses" : "List of 3 medical uses of the plant in simple language.",
      "edibility" : "If edible then give info on how its used in general in short, if not then or poisonous then mention that",
      "origin" : "origin of the plant",
      "facts" : "2 interesting/quick facts about the plant"
    }}
    '''
    */

    final promptTemplate = ChatPromptTemplate.fromPromptMessages([
      SystemChatMessagePromptTemplate.fromTemplate(
        '''You are an expert botanist and plant encyclopedia. 
      When given a scientific plant name, you provide accurate, 
      concise and well-structured plant information.
      Always respond in the exact format given to you. 
      Do not add extra information outside the format.
      ''',
      ),
      HumanChatMessagePromptTemplate.fromTemplate('''
      Give the following information on plant: "{plant_name}" 
      You MUST respond ONLY with a valid JSON object matching this structure exactly:
      {{
        "common_name" : "The most common english name used in India.",
        "scientific_name" : "Plants scientific name",
        "rarity" : "Rarity of the plant out of 5",
        "environment" : "In which environment is it found the most give in format like 'ARID/SUNNY'.",
        "medical_uses" : "A sentence in 20-25 words mentioning 3 medical uses.",
        "edibility" : "If edible then give info on how its used in general in short, if not then or poisonous then mention that",
        "origin" : "origin of the plant",
        "facts" : "List of 2 interesting/quick facts about the plant"
      }}
      '''),
    ]);

    final chain = promptTemplate.pipe(model).pipe(const StringOutputParser());

    try {
      final String response = await chain.invoke({'plant_name': plantName});
      print(response);
      return jsonDecode(response);
    } catch (e) {
      print("Error fetching from LangChain $e");
      return null;
    }
  }
}
