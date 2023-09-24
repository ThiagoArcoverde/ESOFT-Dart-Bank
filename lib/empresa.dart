import 'package:banco/usuario.dart';

class Empresa extends Usuario{
  String cnpj;

  Empresa(String nome, String email,String senha, this.cnpj) : super(nome,email, senha);
}