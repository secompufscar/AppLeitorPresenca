import 'dart:convert';

import 'package:http/http.dart';
import 'package:secomp_leitor/atividades.dart';
import 'package:secomp_leitor/constants.dart';
import 'package:secomp_leitor/presenca.dart';

class ApiService {
  Client client = Client();

  Future<Presenca> lerPresenca(String id, String atividade) async {
    final response = await client.post(
      BASE_URL + "/api/ler-presenca",
      body: json.encode({
        "id_participante": "1",
        "id_atividade": atividade,
        "key": API_KEY,
      }),
      headers: {"Content-Type": "application/json"},
    );

    print("body:" + response.body);

    String body = response.body;
    
    if (response.statusCode == 200) {
      if (body.contains("ERROR")) {
        return Future.error("Ocorreu algum erro");
      } else if (body.contains("INVALID KEY")) {
        return Future.error("Ocorreu algum erro");
      } else
        return Presenca(json.decode(body), id);
    } else {
      return Future.error("Ocorreu algum erro");
    }
  }

  Future<Atividades> getAtividades() async {
    final response = await client.get(BASE_URL + "/api/atividades/10");

    if (response.statusCode == 200) {
      return Atividades(json.decode(response.body));
    } else {
      return Future.error("Ocorreu algum erro");
    }
  }
}
