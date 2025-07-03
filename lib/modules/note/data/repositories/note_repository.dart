import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:flutter_boilerplate/core/common/failures.dart';
import 'package:flutter_boilerplate/core/extensions/dio_exception_ext.dart';
import 'package:flutter_boilerplate/modules/note/data/data_sources/local/note_local_data_source.dart';
import 'package:flutter_boilerplate/modules/note/data/data_sources/remote/note_remote_data_source.dart';
import 'package:flutter_boilerplate/modules/note/data/models/note_dto.dart';
import 'package:flutter_boilerplate/modules/note/data/models/note_model.dart';
import 'package:flutter_boilerplate/shared/responses/base_response.dart';

class NoteRepository {
  final NoteRemoteDataSource _remoteDataSource;
  final NoteLocalDataSource _localDataSource;

  const NoteRepository(
    this._remoteDataSource,
    this._localDataSource,
  );

  Future<Either<Failure, BaseResponse<NoteModel>>> createNote(
      NoteDto note) async {
    try {
      final result = await _remoteDataSource.create(note);
      await _localDataSource.clearAll();
      return Right(result);
    } on DioException catch (e) {
      return Left(ServerFailure(e.errorResponse));
    }
  }

  Future<Either<Failure, String>> deleteNote(int id) async {
    try {
      final result = await _remoteDataSource.delete(id);
      await _localDataSource.clearAll();
      return Right(result);
    } on DioException catch (e) {
      return Left(ServerFailure(e.errorResponse));
    }
  }

  Future<Either<Failure, List<NoteModel>>> fetchNotes({
    bool refresh = false,
    bool loadMore = false,
    int? page = 1,
    int limit = 10,
  }) async {
    final localResult = await _localDataSource.findAll();
    if (localResult.isNotEmpty && !refresh && !loadMore) {
      return Right(localResult);
    } else {
      try {
        final remoteResult = await _remoteDataSource.fetch(page!, limit);
        if (refresh) {
          await _localDataSource.clearAll();
          await _localDataSource.insertAll(remoteResult.data!);
        }
        return Right(remoteResult.data!);
      } on DioException catch (e) {
        return Left(ServerFailure(e.errorResponse));
      }
    }
  }

  Future<Either<Failure, BaseResponse<NoteModel>>> getNoteById(int id) async {
    try {
      final result = await _remoteDataSource.getById(id);
      return Right(result);
    } on DioException catch (e) {
      return Left(ServerFailure(e.errorResponse));
    }
  }

  Future<Either<Failure, BaseResponse<NoteModel>>> updateNote(
    int id,
    NoteDto note,
  ) async {
    try {
      final result = await _remoteDataSource.update(id, note);
      await _localDataSource.clearAll();
      return Right(result);
    } on DioException catch (e) {
      return Left(ServerFailure(e.errorResponse));
    }
  }
}
