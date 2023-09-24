import 'package:banco/conta.dart';

class Pagamento {
  double valor;
  late DateTime data;
  Conta recebedor;
  Conta credor;


  Pagamento(this.valor, this.recebedor, this.credor, this.data);
}
