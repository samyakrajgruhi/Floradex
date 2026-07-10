import 'dart:math';

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:langchain/langchain.dart';
import 'package:langchain_google/langchain_google.dart';
import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;

class Fact {
  final String fact;

  const Fact({required this.fact});

  factory Fact.fromJson(Map<String, dynamic> json) {
    return Fact(fact: json['fact']);
  }
}

class BotanicalFactService {
  Future<String?> fetchDailyFactAI() async {
    final apiKey = dotenv.env['GOOGLE_API_KEY'];
    if (apiKey == null) {
      print('GOOGLE API Key not found');
      return null;
    }

    final model = ChatGoogleGenerativeAI(
      apiKey: apiKey,
      defaultOptions: const ChatGoogleGenerativeAIOptions(
        model: 'gemini-2.5-flash',
<<<<<<< HEAD
        temperature: 0.2,
=======
        temperature: 0.5,
>>>>>>> 10356ec (- Implement Fact Service and Show a new fact everytime the app opens.)
      ),
    );

    final prompt = ChatPromptTemplate.fromPromptMessages([
      SystemChatMessagePromptTemplate.fromTemplate(
        '''You are an expert botanist and plant science educator.

          Your job is to explain botanical information in a way that is accurate, simple,
          and interesting for everyday users. Avoid technical jargon unless it is
          necessary, and when you use it, make the meaning clear through context.

          Prioritize facts that are beginner-friendly, surprising, useful, or memorable.
          Keep the tone clear, warm, and concise. Do not exaggerate, invent claims, or
          present uncertain information as fact.
        ''',
      ),
      HumanChatMessagePromptTemplate.fromTemplate(
        ''' Generate one short botanical fact.

          Requirements:
          - The fact must be simple enough for anyone to understand.
          - Keep it under 20 words.
          - Make it interesting, useful, or surprising.
          - Do not use markdown.
          - Do not add labels like "Fact:".
          - Do not use quotation marks.
          - Return only the fact sentence.

        ''',
      ),
    ]);

    final chain = prompt.pipe(model).pipe(const StringOutputParser());

    try {
      final String response = await chain.invoke({});
      print(response);

      return response.trim();
    } catch (e) {
      print("Error fetching langchain during quickFact generation.");
      return null;
    }
  }

  Future<List<Fact>> loadDailyFactJSON() async {
    final jsonString = await rootBundle.loadString('lib/assets/facts.json');

    final List<dynamic> jsonList = json.decode(jsonString);

    return jsonList.map((e) => Fact.fromJson(e)).toList();
  }

  Future<String?> fetchDailyFactJson() async {
    List<Fact> botanicalFacts = await loadDailyFactJSON();

    if (botanicalFacts.isEmpty) {
      print("Fact List is Empty ");
      return null;
    }

    final random = Random();
    final randomIndex = random.nextInt(botanicalFacts.length);

    return botanicalFacts[randomIndex].fact;
  }
}
