import 'package:floor/floor.dart';

////////// ---------- Questão 2 ---------- //////////
@entity
class Pokemon {
  @PrimaryKey(autoGenerate: true)
  final int id;

  final String nome;
  final String imageUrl; // front_default
  final int peso; // weight
  final int altura; // height
  final String tipo;
  final String? habilidades;
  final int? experiencia;
  final String? forma;

  Pokemon({
    required this.id,
    required this.nome,
    required this.imageUrl,
    required this.peso, // weight
    required this.altura, // height
    required this.tipo,
    this.habilidades,
    this.experiencia,
    this.forma,
  });
}
