class Pedido {
  final int id;
  final String descricao;
  final double valorTotal;
  final String status;
  final int clienteId;

  Pedido({
    required this.id,
    required this.descricao,
    required this.valorTotal,
    required this.status,
    required this.clienteId,
  });

  factory Pedido.fromJson(Map<String, dynamic> json) {
    return Pedido(
      id: json['id'],
      descricao: json['descricao'],
      valorTotal: json['valorTotal'],
      status: json['status'],
      clienteId: json['clienteId'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'descricao': descricao,
      'valorTotal': valorTotal,
      'status': status,
      'clienteId': clienteId,
    };
  }
}
