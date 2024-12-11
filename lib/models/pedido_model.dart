class Pedido {
  final String? id; // Torna o ID opcional
  final String descricao;
  final double valorTotal;
  final String status;
  final String clienteId;

  Pedido({
    this.id, // ID agora é opcional
    required this.descricao,
    required this.valorTotal,
    required this.status,
    required this.clienteId,
  });

  Map<String, dynamic> toJson() {
    return {
      'descricao': descricao,
      'valorTotal': valorTotal,
      'status': status,
      'clienteId': clienteId,
    };
  }

  static Pedido fromJson(Map<String, dynamic> json) {
    return Pedido(
      id: json['id'],
      descricao: json['descricao'],
      valorTotal: json['valorTotal'],
      status: json['status'],
      clienteId: json['clienteId'],
    );
  }
}
