import 'dart:async';
import 'package:floor/floor.dart';
import 'package:terceira_prova/domain/pokemon.dart';

@dao
abstract class PokemonDao {
  @Query('SELECT * FROM Pokemon')
  Future<List<Pokemon>> findAllPokemons(); // listar todos

  @Query('SELECT * FROM Pokemon WHERE id = :id') // listar por id
  Stream<Pokemon?> findPokemonById(int id);

  @Insert(onConflict: OnConflictStrategy.replace) // criar
  Future<void> insertPokemon(Pokemon pokemon);

  @delete
  Future<void> deletePokemon(Pokemon pokemon); // deletar
}
