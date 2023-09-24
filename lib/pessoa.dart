import 'package:banco/usuario.dart';

class Pessoa extends Usuario{
  String cpf;

  Pessoa(String nome, String email,String senha, this.cpf) : super(nome,email,senha);
}