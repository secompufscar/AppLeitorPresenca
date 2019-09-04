import 'dart:convert';

import 'package:http/http.dart';
import 'package:secomp_leitor/atividades.dart';
import 'package:secomp_leitor/constants.dart';
import 'package:secomp_leitor/inscricao.dart';
import 'package:secomp_leitor/presenca.dart';
import 'package:secomp_leitor/verifica_kit.dart';

class ApiService {
  Client client = Client();

  Future<Inscricao> verificarInscricao(String uuid, String idAtividade) async {
    final response = await client.post(
      BASE_URL + "/api/verifica-inscricao",
      body: json.encode({
        "uuid_participante": uuid,
        "id_atividade": idAtividade,
        "key": API_KEY
      }),
    );

    String body = response.body;
     if (response.statusCode == 200) {
      if (body.contains("ERROR")) {
        return Future.error("Ocorreu algum erro");
      } else if (body.contains("INVALID KEY")) {
        return Future.error("Ocorreu algum erro");
      } else
        return Inscricao(json.decode(body));
    } else {
      return Future.error("Ocorreu algum erro");
    }
  }

  Future<VerificaKit> verificaKit(String uuid) async {
    final response = await client.post(
      BASE_URL + "/api/verifica-kit",
      body: json.encode({
        "uuid_participante": uuid,
        "key": API_KEY
      }),
    );

    String body = response.body;
     if (response.statusCode == 200) {
      if (body.contains("ERROR")) {
        return Future.error("Ocorreu algum erro");
      } else if (body.contains("INVALID KEY")) {
        return Future.error("Ocorreu algum erro");
      } else
        return VerificaKit(json.decode(body));
    } else {
      return Future.error("Ocorreu algum erro");
    }
  }

  Future<Presenca> lerPresenca(String uuid, String atividade, bool force) async {
    final response = await client.post(
      BASE_URL + "/api/ler-presenca",
      body: json.encode({
        "uuid_participante": uuid,
        "id_atividade": atividade,
        "force": force,
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
        return Presenca(json.decode(body), uuid);
    } else {
      return Future.error("Ocorreu algum erro");
    }
  }

  Future<Atividades> getAtividades() async {
    final response = await client.get(BASE_URL + "/api/atividades");

    if (response.statusCode == 200) {
      return Atividades(json.decode(response.body));
    } else {
      return Future.error("Ocorreu algum erro");
    }
  }
}
