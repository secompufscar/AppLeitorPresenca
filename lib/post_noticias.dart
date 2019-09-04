import 'package:flutter/material.dart';
import 'package:secomp_leitor/card_noticias.dart';
import 'package:secomp_leitor/firestore.dart';
import 'package:secomp_leitor/noticia.dart';

class PostNoticias extends StatefulWidget {
  @override
  _PostNoticiasState createState() => _PostNoticiasState();
}

class _PostNoticiasState extends State<PostNoticias> {
  FirestoreService _firestore = FirestoreService();
  final TextEditingController _textController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  String getTime(DateTime time) {
    Duration difference = DateTime.now().difference(time);
    if (difference.inSeconds < 60) {
      return "agora";
    } else if (difference.inMinutes < 60) {
      return "há ${difference.inMinutes} min";
    } else if (difference.inHours < 24) {
      return "há ${difference.inHours} horas";
    } else if (difference.inDays == 1) {
      return "há 1 dia";
    } else {
      return "há ${difference.inDays} dias";
    }
  }

  Widget _buildNoticia(Noticia noticia) {
    String time = getTime(noticia.date);
    return NoticiaCard(
      content: noticia.content,
      date: time,
    );
  }

  @override
  Widget build(BuildContext context) {
    void _handleSubmit(String content) async {
      await _firestore.postNoticia(Noticia(content, DateTime.now()));
      _textController.clear();
      _firestore.loadNoticias();
      Navigator.pop(context);
    }

    return SafeArea(
      top: false,
      bottom: true,
      child: Scaffold(
        resizeToAvoidBottomPadding: true, // this avoids the overflow error
        appBar: AppBar(
          title: Text("Notícias"),
        ),
        body: FutureBuilder(
          future: _firestore.loadNoticias(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              List<Noticia> noticias = snapshot.data;
                return ListView.builder(
                  itemCount: noticias.length,
                  itemBuilder: (context, index) =>
                      _buildNoticia(noticias[index]),
                );
            } else if (snapshot.hasError) {
              return GestureDetector(
                onTap: () {
                  setState(() {});
                },
                child: Text("Ocorreu algum erro.\n Toque para recarregar"),
              );
            } else {
              return Center(
                child: CircularProgressIndicator(),
              );
            }
          },
        ),
        floatingActionButton: FloatingActionButton(
          child: Icon(Icons.edit),
          onPressed: () {
            showDialog(
                context: context,
                builder: (context) {
                  return AlertDialog(
                    title: Text("Manda aí"),
                    content: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        TextField(
                            controller: _textController,
                            decoration: InputDecoration(
                              hintText: 'Type a message',
                              border: InputBorder.none,
                            ),
                            onSubmitted: (text) {
                              _handleSubmit(_textController.text);
                            }),
                        SizedBox(width: 8.0),
                        IconButton(
                          icon: Icon(Icons.send),
                          onPressed: () => _handleSubmit(_textController.text),
                        )
                      ],
                    ),
                  );
                });
          },
        ),
      ),
    );
  }
}
