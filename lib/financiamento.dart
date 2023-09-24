class Financiamento {
  double valor;
  double taxaDeJuros;
  int numeroDeParcelas;
  DateTime dataSolicitacao;
  List<Parcela> parcelas = [];

  Financiamento(this.valor, this.taxaDeJuros, this.numeroDeParcelas, this.dataSolicitacao){
    calcularParcelas();
  }

  void calcularParcelas() {
    double valorParcela = (valor * (1 + taxaDeJuros)) / numeroDeParcelas;
    DateTime dataParcela = dataSolicitacao.add(Duration(days: 30));

    for (int i = 0; i < numeroDeParcelas; i++) {
      parcelas.add(Parcela(valorParcela, dataParcela));
      dataParcela = dataParcela.add(Duration(days: 30));
    }
  }
}

class Parcela {
  double valor;
  DateTime dataVencimento;

  Parcela(this.valor, this.dataVencimento);
}
