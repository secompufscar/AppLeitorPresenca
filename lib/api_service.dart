import 'dart:convert';

import 'package:http/http.dart';
import 'package:secomp_leitor/constants.dart';
import 'package:secomp_leitor/presenca.dart';

class ApiService {
  Client client = Client();

  Future<Presenca> lerPresenca(String id, String atividade) async {
    final response = await client.post(
      BASE_URL + "/api/ler-presenca",
      body: {
        "id_participante": id,
        "id_atividade": atividade,
      },
    );

    if (response.statusCode == 200) {
      if (response.body == "ERROR") {
        throw Exception("Ocorreu algum erro");
      } else if (response.body == "INVALID KEY") {
        throw Exception("Ocorreu algum erro");
      } else if (response.body == "JA_LIDO") {
        return Presenca.lido();
      }

      return Presenca(json.decode(response.body), id);
    } else {
      throw Exception("Ocorreu algum erro");
    }
  }
}
