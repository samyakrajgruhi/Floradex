import 'dart:convert';

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart';
import 'package:langchain/langchain.dart';
import 'package:langchain_google/langchain_google.dart';

class PlantInfoService {
  Future<Map<String, dynamic>?> getPlantDetails(String plantName) async {
    final apiKey = dotenv.env['GOOGLE_API_KEY'];
    if (apiKey == null) {
      print('Google API Key not found');
      return null;
    }

    final model = ChatGoogleGenerativeAI(
      apiKey: apiKey,
      defaultOptions: const ChatGoogleGenerativeAIOptions(
        model: 'gemini-2.0-flash',
        temperature: 0.2,
        responseMimeType: 'application/json',
      ),
    );

    final promptTemplate = PromptTemplate.fromTemplate('''
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
    ''');

    final chain = promptTemplate.pipe(model).pipe(const StringOutputParser());

    try{
      

      final String response = await chain.invoke({'plant_name':plantName});

      return jsonDecode(response);

    }catch(e){
      print("Error fetching from LangChain $e");
      return null;
    }
  }
}
