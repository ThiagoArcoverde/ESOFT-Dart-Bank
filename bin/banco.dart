import 'dart:io';

import 'package:banco/conta.dart';
import 'package:banco/deposito.dart';
import 'package:banco/financiamento.dart';
import 'package:banco/pagamento.dart';
import 'package:banco/usuario.dart';

void main(List<String> arguments) {
  List<Conta> contas = [];
  bool sair = false;
  while (sair == false) {
    print("= = = = Banco = = = =");
    print("1 - Entrar");
    print("2 - Criar conta");
    print("3 - Sair");
    String? input = stdin.readLineSync();

    switch (input) {
      case '1':
        entrar(contas);
        break;
      case '2':
        criar(contas);
        break;
      case '3':
        sair = true;
        break;
      default:
        print("Opção inválida!");
    }
  }
}

void entrar(List<Conta> contas) {
  print("= = = = Banco = = = =");
  print("Informe seu email");
  String? inputEmail = stdin.readLineSync();
  print("Informe sua senha: ");
  String? inputSenha = stdin.readLineSync();
  Conta contaDoUsuario = contas.firstWhere((conta) =>
      conta.usuario.email == inputEmail && conta.usuario.senha == inputSenha);
  // ignore: unnecessary_null_comparison
  if (contaDoUsuario != null) {
    start(contaDoUsuario, contas);
  } else {
    print("Conta inválida!");
  }
}

void start(Conta conta, List<Conta> listaDeContas) {
  bool retornar = false;
  while (retornar == false) {
    print("= = = = Banco = = = =");
    print("1 - Saldo");
    print("2 - Realizar depósito");
    print("3 - Realizar pagamento");
    print("4 - Realizar financiamento");
    print("5 - Extrato por período");
    print("6 - Sair");
    String? input = stdin.readLineSync();

    switch (input) {
      case '1':
        print("Saldo atual:${conta.getSaldo()}");
        continuarFluxo();
        break;
      case '2':
        print("Informe o valor que deseja depositar: ");
        String? inputValor = stdin.readLineSync();
        if (inputValor != null) {
          double? valor = double.tryParse(inputValor);
          if (valor != null) {
            Deposito deposito = Deposito(valor);
            conta.addDeposito(deposito);
            print("Deposito realizado com sucesso.");
          } else {
            print("Valor inválido!");
          }
        } else {
          print("Valor inválido.");
        }
        continuarFluxo();
        break;
      case '3':
        print(
            "Informe o email do usuário que você deseja realizar um pagamento: ");
        String? inputUsuarioDestino = stdin.readLineSync();
        if (inputUsuarioDestino != null) {
          try {
            Conta contaDestino = listaDeContas.firstWhere(
                (element) => element.usuario.email == inputUsuarioDestino,
                orElse: () => throw Exception("Conta não encontrada"));
            print("Informe o valor do pagamento: ");
            String? inputValor = stdin.readLineSync();
            if (inputValor != null) {
              double? valor = double.tryParse(inputValor);
              if (valor != null) {
                if (conta.getSaldo() > valor) {
                  Pagamento pagamento =
                      Pagamento(valor, contaDestino, conta, DateTime.now());
                  contaDestino.addSaldo(valor);
                  conta.addPagamento(pagamento);
                  print("Pagamento realizado com sucesso.");
                } else {
                  print("Saldo insuficiente.");
                }
              }
            } else {
              print("Valor inválido.");
            }
          } catch (e) {
            print(e);
          }
        } else {
          print("Usuário não encontrado.");
        }
        continuarFluxo();
        break;
      case '4':
        print("Informe o valor que deseja financiar: ");
        String? inputValor = stdin.readLineSync();
        if (inputValor != null) {
          double? valor = double.tryParse(inputValor);
          if (valor != null) {
            print("Em quantas parcelas deseja realizar o financiamento?");
            String? inputParcelas = stdin.readLineSync();
            if (inputParcelas != null) {
              int? totalDeParcelas = int.tryParse(inputParcelas);
              if (totalDeParcelas != null) {
                Financiamento financiamento =
                    Financiamento(valor, 0.15, totalDeParcelas, DateTime.now());
                conta.addFinanciamento(financiamento);
              } else {
                print("Número de parcelas inválido.");
              }
            } else {
              print("Número de parcelas inválido");
            }
          } else {
            print("Valor inválido");
          }
        } else {
          print("Valor inválido.");
        }
        continuarFluxo();
        break;
      case '5':
        try {
          print("Informe o periodo inicial no formato DD/MM/YYYY");
          String? inputInicio = stdin.readLineSync();
          if (inputInicio != null) {
            List<String> datas = inputInicio.split('/');
            if (datas.length == 3) {
            int? diaInicial = int.tryParse(datas[0]);
            int? mesInicial = int.tryParse(datas[1]);
            int? anoInicial = int.tryParse(datas[2]);
              if (diaInicial != null &&
                  mesInicial != null &&
                  anoInicial != null) {
                var dataInicial = DateTime(anoInicial, mesInicial, diaInicial);
                print("Informe o periodo final no formato DD-MM-YYYY");
                String? inputFinal = stdin.readLineSync();
                if (inputFinal != null) {
                  datas = inputFinal.split('/');
                  if (datas.length == 3) {
                    int? diaFinal = int.tryParse(datas[0]);
                    int? mesFinal = int.tryParse(datas[1]);
                    int? anoFinal = int.tryParse(datas[2]);
                    if (diaFinal != null &&
                        mesFinal != null &&
                        anoFinal != null) {
                      var dataFinal = DateTime(anoFinal, mesFinal, diaFinal);
                      var depositos =
                          conta.getDepositosPorPerido(dataInicial, dataFinal);
                      var pagamentos =
                          conta.getPagamentosPorPerido(dataInicial, dataFinal);
                      var financiamentos = conta.getFinanciamentosPorPerido(
                          dataInicial, dataFinal);
                      print("Pagamentos: ");
                      for (final Pagamento pagamento in pagamentos) {
                        print("${pagamento.valor}  ${pagamento.data}");
                      }

                      print("Depositos: ");
                      for (final Deposito deposito in depositos) {
                        print("${deposito.valor}  ${deposito.data}");
                      }

                      print("Financiamentos: ");
                      for (final Financiamento financiamento
                          in financiamentos) {
                        print(
                            "${financiamento.valor}  ${financiamento.dataSolicitacao}");
                      }
                    } else {
                      print("Data final inválida!");
                    }
                  } else {
                    print("Formato da data final inváldio!");
                  }
                } else {
                  print("Input inválido!");
                }
              } else {
                print("data inicial inválida!");
              }
            } else {
              print("Formato da data inicial inválido!");
            }
          } else {
            print("Input inválido!");
          }
        } catch (e) {
          print(e);
        }
        break;
      case '6':
        int index = listaDeContas.indexWhere((element) =>
            element.usuario.email == conta.usuario.email &&
            element.usuario.senha == conta.usuario.senha);
        listaDeContas[index] = conta;
        retornar = true;
        continuarFluxo();
        break;
      default:
        print("Opção inválida!");
        continuarFluxo();
        break;
    }
  }
}

void criar(List<Conta> contas) {
  print(Process.runSync("clear", [], runInShell: true).stdout);
  TipoDeConta? tipoDeConta;
  print("Selecione um tipo de conta para criar: ");
  print("1 - Salário");
  print("2 - Corrente");
  print("3 - Poupança");
  print("4 - Conjunta");
  String? input = stdin.readLineSync();

  switch (input) {
    case '1':
      tipoDeConta = TipoDeConta.salario;
      break;
    case '2':
      tipoDeConta = TipoDeConta.corrente;
      break;
    case '3':
      tipoDeConta = TipoDeConta.poupanca;
      break;
    case '4':
      tipoDeConta = TipoDeConta.conjunta;
      break;
    default:
      print("Opção inválida!");
      break;
  }

  if (tipoDeConta == null) {
    continuarFluxo();
  } else if (tipoDeConta != TipoDeConta.conjunta) {
    print("Informe o nome do usuario da conta: ");
    String? inputNomeUsuario = stdin.readLineSync();

    print("Informe o email do usuario da conta: ");
    String? inputEmailusuario = stdin.readLineSync();

    print("Informe o senha do usuario da conta: ");
    String? inputSenhaUsuario = stdin.readLineSync();

    if (inputNomeUsuario != null &&
        inputEmailusuario != null &&
        inputSenhaUsuario != null) {
      var novoUsuario =
          Usuario(inputNomeUsuario, inputEmailusuario, inputSenhaUsuario);

      print("Informe o saldo inicial da conta: ");
      String? inputSaldoInicial = stdin.readLineSync();
      if (inputSaldoInicial != null) {
        double? saldoInicial = double.tryParse(inputSaldoInicial);
        if (saldoInicial != null) {
          if (tipoDeConta == TipoDeConta.poupanca && saldoInicial < 50) {
            print("Saldo inicial inválido!");
            continuarFluxo();
            return;
          }
          var index = contas.indexWhere(
              (element) => element.usuario.email == novoUsuario.email);
          if (index == -1) {
            var novaConta = Conta(
                usuario: novoUsuario,
                tipoDeConta: tipoDeConta,
                saldoInicial: saldoInicial);
            contas.add(novaConta);
            print("Conta criada com sucesso!");
          } else {
            print("Email já cadastrado.");
          }
        } else {
          print("Saldo inválido.");
        }
      } else {
        print("Input inválido.");
      }
    } else {
      print("input inválido.");
    }
  } else {
    print("Informe o nome do usuario da conta: ");
    String? inputNomeUsuario = stdin.readLineSync();

    print("Informe o email do usuario da conta: ");
    String? inputEmailusuario = stdin.readLineSync();

    print("Informe o senha do usuario da conta: ");
    String? inputSenhaUsuario = stdin.readLineSync();

    print("Informe o nome do usuario conjunto da conta: ");
    String? inputNomeUsuarioConjunto = stdin.readLineSync();

    print("Informe o email do usuario conjunto da conta: ");
    String? inputEmailusuarioConjunto = stdin.readLineSync();

    print("Informe o senha do usuario conjunto da conta: ");
    String? inputSenhaUsuarioConjunto = stdin.readLineSync();

    if (inputNomeUsuario != null &&
        inputNomeUsuarioConjunto != null &&
        inputEmailusuario != null &&
        inputEmailusuarioConjunto != null &&
        inputSenhaUsuario != null &&
        inputSenhaUsuarioConjunto != null) {
      var novoUsuario =
          Usuario(inputNomeUsuario, inputEmailusuario, inputSenhaUsuario);
      var novoUsuarioConjunto = Usuario(inputNomeUsuarioConjunto,
          inputEmailusuarioConjunto, inputSenhaUsuarioConjunto);

      print("Informe o saldo inicial da conta: ");
      String? inputSaldoInicial = stdin.readLineSync();
      if (inputSaldoInicial != null) {
        double? saldoInicial = double.tryParse(inputSaldoInicial);
        if (saldoInicial != null) {
          var index = contas.indexWhere(
              (element) => element.usuario.email == novoUsuario.email);
          if (index == -1) {
            var novaConta = Conta(
                usuario: novoUsuario,
                tipoDeConta: tipoDeConta,
                saldoInicial: saldoInicial,
                usuarioConjunto: novoUsuarioConjunto);
            contas.add(novaConta);
            print("Conta criada com sucesso!");
          } else {
            print("Email já cadastrado.");
          }
        } else {
          print("Saldo inválido.");
        }
      } else {
        print("Input inválido.");
      }
    } else {
      print("Input inválido.");
    }
  }
  continuarFluxo();
}

void continuarFluxo() {
  print("Pressione enter para continuar.");
  stdin.readLineSync();
  for (int i = 0; i < 25; i++) {
    print("\n");
  }
}
