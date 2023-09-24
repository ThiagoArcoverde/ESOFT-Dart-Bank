import 'package:banco/conta.dart';
import 'package:banco/usuario.dart';
import 'package:test/test.dart';

void main() {
  group('Conta', () {
    test('Saldo inicial de conta poupança deve ser superior a 50', () {
      final usuario = Usuario("nome", "email", "senha");
      expect(() => Conta(usuario:usuario,tipoDeConta: TipoDeConta.poupanca), throwsException);
    });

    test('Adicionar saldo deve atualizar o saldo da conta', () {
      final usuario = Usuario("nome", "email", "senha");
      final conta = Conta(usuario:usuario,tipoDeConta: TipoDeConta.corrente);
      conta.addSaldo(100.0);
      expect(conta.getSaldo(), equals(100.0));
    });

  });
}

