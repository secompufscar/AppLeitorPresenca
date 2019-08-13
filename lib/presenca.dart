class Presenca {
  String _id;
  String _nome;
  Status _status;

  Presenca.lido() {
    this._id = "";
    this._nome = "";
    this._status = Status.lido;
  }

  Presenca(Map<String, dynamic> parsedJson, String id) {
    this._id = id;
    this._nome = parsedJson['participante'];
    this._status = Status.ok;
  }

  String get id => _id;
  String get nome => _nome;
  Status get status => _status;
}

enum Status { lido, ok }
