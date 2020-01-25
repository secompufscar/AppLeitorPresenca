import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:secomp_leitor/models/noticia.dart';

class FirestoreService {
  Future<List<Noticia>> loadNoticias() async {
    try {
      final snapshot = Firestore.instance
          .collection('noticias')
          .orderBy('time', descending: true)
          .snapshots();
      List<Noticia> temp = [];
      snapshot.listen((data) {
        data.documents.forEach(
          (doc) => temp.add(
            Noticia(
              doc["text"].toString(),
              doc["time"].toDate(),
            ),
          ),
        );
      });

      Future.delayed(Duration(milliseconds: 500), () {});

      return temp;
    } catch (e) {
      return Future.error("Erro");
    }
  }

  Future<bool> postNoticia(Noticia noticia) async {
    Map<String, dynamic> mapNoticia = {
      "text": noticia.content,
      "time": Timestamp.fromDate(noticia.date)
    };
    try {
      Firestore.instance.collection('noticias').add(mapNoticia);
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<dynamic> deleteNoticia(Noticia noticia) async {
    try {
      DocumentSnapshot ds;
      final snapshots = Firestore.instance
          .collection('noticias')
          .where('text', isEqualTo: noticia.content)
          .snapshots();
      snapshots.listen((data) {
        data.documents.forEach((doc) {
          ds = doc;
        });
      });

      final TransactionHandler deleteTransaction = (Transaction tx) async {
        await tx.delete(ds.reference);
        return {'deleted': true};
      };

      return Firestore.instance
          .runTransaction(deleteTransaction)
          .then((result) => result['deleted'])
          .catchError((error) {
        print('error: $error');
        return false;
      });
    } catch (_) {}
  }
}
