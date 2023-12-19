import 'dart:async';
import 'package:floor/floor.dart';
import 'package:sqflite/sqflite.dart' as sqflite;
import 'package:terceira_prova/dao/pokemon_dao.dart';
import 'package:terceira_prova/domain/pokemon.dart';

part 'database.g.dart';
////////// ---------- Questão 2 ---------- //////////

@Database(version: 1, entities: [
  Pokemon
]) // criação da classe de bd AppDatabase, usando floor e que está associada a classe pokemon
abstract class AppDatabase extends FloorDatabase {
  PokemonDao get pokemonDao;
}
