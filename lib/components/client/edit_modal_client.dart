import 'package:flutter/material.dart';

class EditModalCliente extends StatelessWidget {
  final Function(String nome, String cpf, String telefone) onSave;
  final String initialNome;
  final String initialCpf;
  final String initialTelefone;

  const EditModalCliente({
    Key? key,
    required this.onSave,
    required this.initialNome,
    required this.initialCpf,
    required this.initialTelefone,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final TextEditingController nomeController = TextEditingController(text: initialNome);
    final TextEditingController cpfController = TextEditingController(text: initialCpf);
    final TextEditingController telefoneController = TextEditingController(text: initialTelefone);

    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              'Editar Cliente',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: nomeController,
              decoration: const InputDecoration(
                labelText: 'Nome',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: cpfController,
              decoration: const InputDecoration(
                labelText: 'CPF',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: telefoneController,
              decoration: const InputDecoration(
                labelText: 'Telefone',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () {
                final nome = nomeController.text;
                final cpf = cpfController.text;
                final telefone = telefoneController.text;

                if (nome.isNotEmpty && cpf.isNotEmpty && telefone.isNotEmpty) {
                  onSave(nome, cpf, telefone); // Passa os dados para o callback
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Preencha todos os campos!')),
                  );
                }
              },
              child: const Text('Salvar'),
            ),
          ],
        ),
      ),
    );
  }
}
