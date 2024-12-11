class Cliente {
  final String? id; // Nullable para casos onde o ID não é necessário, como no cadastro
  final String nome;
  final String cpf;
  final String telefone;

  Cliente({
    this.id,
    required this.nome,
    required this.cpf,
    required this.telefone,
  });

  @override
  String toString() {
    return 'Cliente(id: $id, nome: $nome, cpf: $cpf, telefone: $telefone)';
  }

  factory Cliente.fromJson(Map<String, dynamic> json) {
    return Cliente(
      id: json['id'], // O id já é uma String, não há necessidade de conversão
      nome: json['nome'],
      cpf: json['cpf'],
      telefone: json['telefone'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id, // O id continua como String
      'nome': nome,
      'cpf': cpf,
      'telefone': telefone,
    };
  }

}
