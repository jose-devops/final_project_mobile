import 'package:flutter/material.dart';

class RegisterModalCliente extends StatelessWidget {
  final Function(String nome, String cpf, String telefone, String endereco) onSave;

  const RegisterModalCliente({Key? key, required this.onSave}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Controladores de texto para os campos
    final TextEditingController nomeController = TextEditingController();
    final TextEditingController cpfController = TextEditingController();
    final TextEditingController telefoneController = TextEditingController();
    final TextEditingController enderecoController = TextEditingController();

    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Cadastrar Cliente',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.teal),
            ),
            SizedBox(height: 16),
            // Campo Nome
            TextField(
              controller: nomeController,
              decoration: InputDecoration(
                labelText: 'Nome',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 16),
            // Campo CPF
            TextField(
              controller: cpfController,
              decoration: InputDecoration(
                labelText: 'CPF',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 16),
            // Campo Telefone
            TextField(
              controller: telefoneController,
              decoration: InputDecoration(
                labelText: 'Telefone',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 16),
            // Campo Endereço
            TextField(
              controller: enderecoController,
              decoration: InputDecoration(
                labelText: 'Endereço',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 24),
            // Botões "Salvar" e "Cancelar"
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ElevatedButton(
                  onPressed: () {
                    final nome = nomeController.text;
                    final cpf = cpfController.text;
                    final telefone = telefoneController.text;
                    final endereco = enderecoController.text;

                    if (nome.isNotEmpty && cpf.isNotEmpty && telefone.isNotEmpty && endereco.isNotEmpty) {
                      onSave(nome, cpf, telefone, endereco); // Chama a função de salvar
                      Navigator.of(context).pop(); // Fecha o modal
                    } else {
                      // Exibe erro se algum campo estiver vazio
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Por favor, preencha todos os campos')),
                      );
                    }
                  },
                  child: Text('Salvar'),
                ),
                ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).pop(); // Fecha o modal
                  },
                  child: Text('Cancelar'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.grey, // Cor para o botão "Cancelar"
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
