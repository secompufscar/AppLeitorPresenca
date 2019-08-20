import 'dart:convert';

import 'package:http/http.dart';
import 'package:secomp_leitor/constants.dart';
import 'package:secomp_leitor/presenca.dart';

class ApiService {
  Client client = Client();

  Future<Presenca> lerPresenca(String id, String atividade) async {
    final response = await client.post(
      BASE_URL + "/api/ler-presenca",
      body: json.encode({
        "id_participante": "1",
        "id_atividade": "1",
        "key": API_KEY,
      }),
      headers: {"Content-Type": "application/json"},

      // body: '{"id_participante": "1", "id_atividade: "1", "key": $API_KEY}',
    );

    if (response.statusCode == 200) {
      if (response.body == "ERROR") {
        throw Exception("Ocorreu algum erro");
      } else if (response.body == "INVALID KEY") {
        throw Exception("Ocorreu algum erro");
      } 
      return Presenca(json.decode(response.body), id);
    } else {
      throw Exception("Ocorreu algum erro");
    }
  }
}
