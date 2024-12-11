import 'package:flutter/material.dart';
import '../../components/client/card_cliente.dart';
import '../../components/client/edit_modal_client.dart';
import '../../components/client/register_modal_client.dart';
import '../../components/navigation/bottom_menu_custom.dart';
import '../../models/cliente_model.dart';
import '../../services/cliente_service.dart';

class ClientesScreen extends StatefulWidget {
  const ClientesScreen({super.key});

  @override
  State<ClientesScreen> createState() => _ClientesScreenState();
}

class _ClientesScreenState extends State<ClientesScreen> {
  final ClienteService _clienteService = ClienteService();
  final List<Cliente> _clientes = []; // Lista de clientes

  // Método para carregar clientes do backend
  Future<void> _carregarClientes() async {
    try {
      final clientes = await _clienteService.fetchClientes();
      print('Clientes carregados: $clientes'); // Adicione esta linha
      setState(() {
        _clientes.clear();
        _clientes.addAll(clientes);
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erro ao carregar clientes: $e')),
      );
    }
  }

  // Método para cadastrar cliente no backend
  Future<void> _cadastrarCliente(String nome, String cpf, String telefone) async {
    final novoCliente = Cliente(nome: nome, cpf: cpf, telefone: telefone); // Não inclua o id
    try {
      final sucesso = await _clienteService.createCliente(novoCliente);
      if (sucesso) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Cliente cadastrado com sucesso!')),
        );
        _carregarClientes(); // Atualiza a lista após o cadastro
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Erro ao cadastrar cliente.')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erro ao cadastrar cliente: $e')),
      );
    }
  }


  Future<void> _editarCliente(String id, String nome, String cpf, String telefone) async {
    final clienteEditado = Cliente(
      id: id,
      nome: nome,
      cpf: cpf,
      telefone: telefone,
    );

    try {
      await _clienteService.updateClient(clienteEditado);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Cliente editado com sucesso!')),
        );

        await _carregarClientes(); // Atualiza a lista de clientes

        // Fecha o modal de edição
        if (Navigator.of(context).canPop()) {
          Navigator.of(context).pop(); // Fecha a janela atual
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Erro ao editar cliente: $e')),
        );
      }
    }
  }








  @override
  void initState() {
    super.initState();
    _carregarClientes(); // Carrega clientes ao iniciar a tela
  }

  void _navigateTo(int index) {
    if (index == 0) {
      // Já está na tela de clientes, não faz nada
    } else if (index == 1) {
      // Navega para a tela de pedidos
      Navigator.pushReplacementNamed(context, '/pedidos');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            // Header com título
            Container(
              height: 100,
              color: Colors.teal,
              child: const Center(
                child: Text(
                  'Lista de Clientes',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
            // Botão Adicionar Cliente
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder: (context) => RegisterModalCliente(
                          onSave: (nome, cpf, telefone, endereco) {
                            _cadastrarCliente(nome, cpf, telefone);
                          },
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.teal,
                      foregroundColor: Colors.white,
                      shape: const CircleBorder(),
                      padding: const EdgeInsets.all(12),
                    ),
                    child: const Icon(Icons.add, size: 30),
                  ),
                ],
              ),
            ),
            // Lista de Clientes ou mensagem de lista vazia
            Expanded(
              child: ListView.builder(
                itemCount: _clientes.length,
                itemBuilder: (context, index) {
                  final cliente = _clientes[index];
                  return ClienteCard(
                    cliente: cliente,
                    onEdit: () {
                      showDialog(
                        context: context,
                        builder: (context) => EditModalCliente(
                          initialNome: cliente.nome,
                          initialCpf: cliente.cpf,
                          initialTelefone: cliente.telefone,
                          onSave: (nome, cpf, telefone) {
                            if (cliente.id != null) {
                              _editarCliente(cliente.id!, nome, cpf, telefone); // Agora trata `id` como String
                              Navigator.of(context).pop();
                            } else {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(content: Text('Erro: ID do cliente não encontrado.')),
                              );
                            }
                          },


                        ),
                      );
                    },
                    onDelete: () async {
                      try {
                        // Exibe um diálogo de confirmação antes de deletar
                        final confirm = await showDialog<bool>(
                          context: context,
                          builder: (context) {
                            return AlertDialog(
                              title: const Text('Confirmação'),
                              content: const Text('Você tem certeza que deseja deletar este cliente?'),
                              actions: [
                                TextButton(
                                  onPressed: () => Navigator.of(context).pop(false), // Cancela
                                  child: const Text('Não'),
                                ),
                                TextButton(
                                  onPressed: () => Navigator.of(context).pop(true), // Confirma
                                  child: const Text('Sim'),
                                ),
                              ],
                            );
                          },
                        );

                        // Se o usuário confirmar
                        if (confirm == true) {
                          await _clienteService.deleteCliente(cliente.id!); // Chama o serviço para deletar
                          await _carregarClientes(); // Recarrega a lista completa
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Cliente deletado com sucesso!')),
                          );
                        }
                      } catch (e) {
                        // Exibe mensagem de erro
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Erro ao deletar cliente: $e')),
                        );
                      }
                    },



                  );
                },
              ),
            ),

          ],
        ),
      ),
      bottomNavigationBar: BottomMenu(
        currentIndex: 0, // Índice para Clientes
        onTabTapped: _navigateTo,
      ),
    );
  }
}
