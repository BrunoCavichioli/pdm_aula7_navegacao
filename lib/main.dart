import 'package:flutter/material.dart';
import 'tela_resumo.dart';

void main() {
  runApp(const MeuApp());
}

class MeuApp extends StatelessWidget {
  const MeuApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Aula 7 - Navegação',
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.indigo),
      ),
      home: const TelaContador(),
    );
  }
}

class TelaContador extends StatefulWidget {
  const TelaContador({super.key});

  @override
  State<TelaContador> createState() => _TelaContadorState();
}

class _TelaContadorState extends State<TelaContador> {
  int _quantidade = 1;
  final String _nomeProduto = 'Smartphone Galaxy S24';

  // Nível 2: preço unitário do produto.
  final double _precoUnitario = 150.00;

  double get _valorTotal => _quantidade * _precoUnitario;

  String _formatarMoeda(double valor) {
    return 'R\$ ${valor.toStringAsFixed(2).replaceAll('.', ',')}';
  }

  void _incrementar() {
    setState(() {
      _quantidade++;
    });
  }

  void _decrementar() {
    if (_quantidade > 1) {
      setState(() {
        _quantidade--;
      });
    }
  }

  // Nível 1: redefine a quantidade para o valor inicial.
  void _zerarContador() {
    setState(() {
      _quantidade = 1;
    });
  }

  // Nível 3: aguarda o retorno da TelaResumo e exibe o SnackBar.
  Future<void> _avancarParaResumo() async {
    final bool? confirmado = await Navigator.push<bool>(
      context,
      MaterialPageRoute(
        builder: (context) => TelaResumo(
          item: _nomeProduto,
          quantidade: _quantidade,
          precoUnitario: _precoUnitario,
        ),
      ),
    );

    // Garante que o widget ainda está na árvore antes de usar o context.
    if (!mounted) return;

    if (confirmado == true) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Pedido Confirmado com Sucesso!'),
          behavior: SnackBarBehavior.floating,
          duration: Duration(seconds: 3),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Seleção de Itens'),
        centerTitle: true,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                _nomeProduto,
                style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Preço unitário: ${_formatarMoeda(_precoUnitario)}',
                style: const TextStyle(fontSize: 16, color: Colors.black54),
              ),
              const SizedBox(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  IconButton.filledTonal(
                    onPressed: _decrementar,
                    icon: const Icon(Icons.remove),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24.0),
                    child: Text(
                      '$_quantidade',
                      style: const TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  IconButton.filledTonal(
                    onPressed: _incrementar,
                    icon: const Icon(Icons.add),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Text(
                'Total: ${_formatarMoeda(_valorTotal)}',
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 32),
              ElevatedButton(
                onPressed: _avancarParaResumo,
                child: const Text('Avançar para Resumo'),
              ),
              const SizedBox(height: 12),
              OutlinedButton.icon(
                onPressed: _zerarContador,
                icon: const Icon(Icons.refresh),
                label: const Text('Zerar Contador'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}