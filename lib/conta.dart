import 'package:banco/deposito.dart';
import 'package:banco/financiamento.dart';
import 'package:banco/pagamento.dart';
import 'package:banco/usuario.dart';

class Conta{
  late double _saldo;
  Usuario usuario;
  Usuario? usuarioConjunto;
  TipoDeConta tipoDeConta;
  final List<Pagamento> _pagamentos = [];
  final List<Deposito> _depositos = [];
  final List<Financiamento> _financiamentos = [];

  Conta({required this.usuario, required this.tipoDeConta, double saldoInicial = 0.0, this.usuarioConjunto}) {
    if (tipoDeConta == TipoDeConta.poupanca && saldoInicial < 50) {
      throw Exception('Uma conta Poupança deve ter um saldo inicial superior a 50.');
    }
    if(tipoDeConta == TipoDeConta.conjunta && usuarioConjunto == null){
      throw Exception('Uma conta conjunta precisa de dois usuarios.');
    }
    _saldo = saldoInicial;
  }

  double getSaldo(){
    return _saldo;
  }

  void addSaldo(double valor){
    _saldo += valor;
  }

  void addPagamento(Pagamento pagamento){
    if(_saldo > pagamento.valor){
      _saldo -= pagamento.valor;
      _pagamentos.add(pagamento);
    }
    else{
      throw Exception("Saldo insuficiente para realizar pagamento.");
    }
  }

  List<Pagamento> getPagamentos(){
    return _pagamentos;
  }

  void addDeposito(Deposito deposito){
    _saldo += deposito.valor;
    _depositos.add(deposito);
  }

  List<Deposito> getDepositos(){
    return _depositos;
  }

  void addFinanciamento(Financiamento financiamento){
    _financiamentos.add(financiamento);
  }

  List<Financiamento> getFinanciamentos(){
    return _financiamentos;
  }

  List<Pagamento> getPagamentosPorPerido(DateTime dataInicial, DateTime dataFinal){
    return _pagamentos.where((element) => element.data.isAfter(dataInicial) && element.data.isBefore(dataFinal)).toList();
  }

  List<Deposito> getDepositosPorPerido(DateTime dataInicial, DateTime dataFinal){
    return _depositos.where((element) => element.data.isAfter(dataInicial) && element.data.isBefore(dataFinal)).toList();
  }

  List<Financiamento> getFinanciamentosPorPerido(DateTime dataInicial, DateTime dataFinal){
    return _financiamentos.where((element) => element.dataSolicitacao.isAfter(dataInicial) && element.dataSolicitacao.isBefore(dataFinal)).toList();
  }


}

enum TipoDeConta {
  poupanca,
  corrente,
  salario,
  conjunta
}