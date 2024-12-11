import 'package:flutter/material.dart';

class RegisterModalPedido extends StatefulWidget {
  final List<Map<String, String>> clientes;
  final Function(String descricao, double valorTotal, String status, String clienteId) onSave;

  const RegisterModalPedido({
    Key? key,
    required this.clientes,
    required this.onSave,
  }) : super(key: key);

  @override
  State<RegisterModalPedido> createState() => _RegisterModalPedidoState();
}

class _RegisterModalPedidoState extends State<RegisterModalPedido> {
  final TextEditingController descricaoController = TextEditingController();
  final TextEditingController valorController = TextEditingController();

  String? selectedStatus;
  String? selectedCliente;

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                'Cadastrar Pedido',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
              // Campo Descrição
              TextField(
                controller: descricaoController,
                decoration: const InputDecoration(
                  labelText: 'Descrição',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),
              // Campo Valor Total
              TextField(
                controller: valorController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: 'Valor Total',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),
              // Dropdown de Status
              DropdownButtonFormField<String>(
                value: selectedStatus,
                items: [
                  'PROCESSAMENTO',
                  'ENVIADO',
                  'ENTREGUE',
                  'CANCELADO',
                ].map((status) {
                  return DropdownMenuItem(
                    value: status,
                    child: Text(status),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    selectedStatus = value;
                  });
                },
                decoration: const InputDecoration(
                  labelText: 'Status',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),
              // Dropdown de Clientes
              DropdownButtonFormField<String>(
                value: selectedCliente,
                items: widget.clientes.map((cliente) {
                  return DropdownMenuItem(
                    value: cliente['id'],
                    child: Text(cliente['nome']!),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    selectedCliente = value;
                  });
                },
                decoration: const InputDecoration(
                  labelText: 'Cliente',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: () {
                  final descricao = descricaoController.text;
                  final valorTotal = double.tryParse(valorController.text) ?? 0.0;

                  if (descricao.isEmpty || valorTotal <= 0 || selectedStatus == null || selectedCliente == null) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Preencha todos os campos corretamente')),
                    );
                    return;
                  }

                  widget.onSave(descricao, valorTotal, selectedStatus!, selectedCliente!); // Passa o clienteId como String
                  Navigator.of(context).pop(); // Fecha o modal
                },

                child: const Text('Salvar'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
