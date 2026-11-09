// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_database.dart';

// ignore_for_file: type=lint
class $ClientesTable extends Clientes with TableInfo<$ClientesTable, Cliente> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ClientesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _nombreMeta = const VerificationMeta('nombre');
  @override
  late final GeneratedColumn<String> nombre = GeneratedColumn<String>(
    'nombre',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _telefonoMeta = const VerificationMeta(
    'telefono',
  );
  @override
  late final GeneratedColumn<String> telefono = GeneratedColumn<String>(
    'telefono',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _direccionMeta = const VerificationMeta(
    'direccion',
  );
  @override
  late final GeneratedColumn<String> direccion = GeneratedColumn<String>(
    'direccion',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [id, nombre, telefono, direccion];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'clientes';
  @override
  VerificationContext validateIntegrity(
    Insertable<Cliente> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('nombre')) {
      context.handle(
        _nombreMeta,
        nombre.isAcceptableOrUnknown(data['nombre']!, _nombreMeta),
      );
    } else if (isInserting) {
      context.missing(_nombreMeta);
    }
    if (data.containsKey('telefono')) {
      context.handle(
        _telefonoMeta,
        telefono.isAcceptableOrUnknown(data['telefono']!, _telefonoMeta),
      );
    } else if (isInserting) {
      context.missing(_telefonoMeta);
    }
    if (data.containsKey('direccion')) {
      context.handle(
        _direccionMeta,
        direccion.isAcceptableOrUnknown(data['direccion']!, _direccionMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Cliente map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Cliente(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      nombre: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}nombre'],
      )!,
      telefono: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}telefono'],
      )!,
      direccion: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}direccion'],
      ),
    );
  }

  @override
  $ClientesTable createAlias(String alias) {
    return $ClientesTable(attachedDatabase, alias);
  }
}

class Cliente extends DataClass implements Insertable<Cliente> {
  final String id;
  final String nombre;
  final String telefono;
  final String? direccion;
  const Cliente({
    required this.id,
    required this.nombre,
    required this.telefono,
    this.direccion,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['nombre'] = Variable<String>(nombre);
    map['telefono'] = Variable<String>(telefono);
    if (!nullToAbsent || direccion != null) {
      map['direccion'] = Variable<String>(direccion);
    }
    return map;
  }

  ClientesCompanion toCompanion(bool nullToAbsent) {
    return ClientesCompanion(
      id: Value(id),
      nombre: Value(nombre),
      telefono: Value(telefono),
      direccion: direccion == null && nullToAbsent
          ? const Value.absent()
          : Value(direccion),
    );
  }

  factory Cliente.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Cliente(
      id: serializer.fromJson<String>(json['id']),
      nombre: serializer.fromJson<String>(json['nombre']),
      telefono: serializer.fromJson<String>(json['telefono']),
      direccion: serializer.fromJson<String?>(json['direccion']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'nombre': serializer.toJson<String>(nombre),
      'telefono': serializer.toJson<String>(telefono),
      'direccion': serializer.toJson<String?>(direccion),
    };
  }

  Cliente copyWith({
    String? id,
    String? nombre,
    String? telefono,
    Value<String?> direccion = const Value.absent(),
  }) => Cliente(
    id: id ?? this.id,
    nombre: nombre ?? this.nombre,
    telefono: telefono ?? this.telefono,
    direccion: direccion.present ? direccion.value : this.direccion,
  );
  Cliente copyWithCompanion(ClientesCompanion data) {
    return Cliente(
      id: data.id.present ? data.id.value : this.id,
      nombre: data.nombre.present ? data.nombre.value : this.nombre,
      telefono: data.telefono.present ? data.telefono.value : this.telefono,
      direccion: data.direccion.present ? data.direccion.value : this.direccion,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Cliente(')
          ..write('id: $id, ')
          ..write('nombre: $nombre, ')
          ..write('telefono: $telefono, ')
          ..write('direccion: $direccion')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, nombre, telefono, direccion);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Cliente &&
          other.id == this.id &&
          other.nombre == this.nombre &&
          other.telefono == this.telefono &&
          other.direccion == this.direccion);
}

class ClientesCompanion extends UpdateCompanion<Cliente> {
  final Value<String> id;
  final Value<String> nombre;
  final Value<String> telefono;
  final Value<String?> direccion;
  final Value<int> rowid;
  const ClientesCompanion({
    this.id = const Value.absent(),
    this.nombre = const Value.absent(),
    this.telefono = const Value.absent(),
    this.direccion = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  ClientesCompanion.insert({
    required String id,
    required String nombre,
    required String telefono,
    this.direccion = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       nombre = Value(nombre),
       telefono = Value(telefono);
  static Insertable<Cliente> custom({
    Expression<String>? id,
    Expression<String>? nombre,
    Expression<String>? telefono,
    Expression<String>? direccion,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (nombre != null) 'nombre': nombre,
      if (telefono != null) 'telefono': telefono,
      if (direccion != null) 'direccion': direccion,
      if (rowid != null) 'rowid': rowid,
    });
  }

  ClientesCompanion copyWith({
    Value<String>? id,
    Value<String>? nombre,
    Value<String>? telefono,
    Value<String?>? direccion,
    Value<int>? rowid,
  }) {
    return ClientesCompanion(
      id: id ?? this.id,
      nombre: nombre ?? this.nombre,
      telefono: telefono ?? this.telefono,
      direccion: direccion ?? this.direccion,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (nombre.present) {
      map['nombre'] = Variable<String>(nombre.value);
    }
    if (telefono.present) {
      map['telefono'] = Variable<String>(telefono.value);
    }
    if (direccion.present) {
      map['direccion'] = Variable<String>(direccion.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ClientesCompanion(')
          ..write('id: $id, ')
          ..write('nombre: $nombre, ')
          ..write('telefono: $telefono, ')
          ..write('direccion: $direccion, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $VehiculosTable extends Vehiculos
    with TableInfo<$VehiculosTable, Vehiculo> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $VehiculosTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _clienteIdMeta = const VerificationMeta(
    'clienteId',
  );
  @override
  late final GeneratedColumn<String> clienteId = GeneratedColumn<String>(
    'cliente_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES clientes (id) ON DELETE RESTRICT',
    ),
  );
  static const VerificationMeta _matriculaMeta = const VerificationMeta(
    'matricula',
  );
  @override
  late final GeneratedColumn<String> matricula = GeneratedColumn<String>(
    'matricula',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways('UNIQUE'),
  );
  static const VerificationMeta _marcaMeta = const VerificationMeta('marca');
  @override
  late final GeneratedColumn<String> marca = GeneratedColumn<String>(
    'marca',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _modeloMeta = const VerificationMeta('modelo');
  @override
  late final GeneratedColumn<String> modelo = GeneratedColumn<String>(
    'modelo',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _anioMeta = const VerificationMeta('anio');
  @override
  late final GeneratedColumn<int> anio = GeneratedColumn<int>(
    'anio',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _ultimoKilometrajeMeta = const VerificationMeta(
    'ultimoKilometraje',
  );
  @override
  late final GeneratedColumn<int> ultimoKilometraje = GeneratedColumn<int>(
    'ultimo_kilometraje',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    clienteId,
    matricula,
    marca,
    modelo,
    anio,
    ultimoKilometraje,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'vehiculos';
  @override
  VerificationContext validateIntegrity(
    Insertable<Vehiculo> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('cliente_id')) {
      context.handle(
        _clienteIdMeta,
        clienteId.isAcceptableOrUnknown(data['cliente_id']!, _clienteIdMeta),
      );
    } else if (isInserting) {
      context.missing(_clienteIdMeta);
    }
    if (data.containsKey('matricula')) {
      context.handle(
        _matriculaMeta,
        matricula.isAcceptableOrUnknown(data['matricula']!, _matriculaMeta),
      );
    } else if (isInserting) {
      context.missing(_matriculaMeta);
    }
    if (data.containsKey('marca')) {
      context.handle(
        _marcaMeta,
        marca.isAcceptableOrUnknown(data['marca']!, _marcaMeta),
      );
    } else if (isInserting) {
      context.missing(_marcaMeta);
    }
    if (data.containsKey('modelo')) {
      context.handle(
        _modeloMeta,
        modelo.isAcceptableOrUnknown(data['modelo']!, _modeloMeta),
      );
    } else if (isInserting) {
      context.missing(_modeloMeta);
    }
    if (data.containsKey('anio')) {
      context.handle(
        _anioMeta,
        anio.isAcceptableOrUnknown(data['anio']!, _anioMeta),
      );
    } else if (isInserting) {
      context.missing(_anioMeta);
    }
    if (data.containsKey('ultimo_kilometraje')) {
      context.handle(
        _ultimoKilometrajeMeta,
        ultimoKilometraje.isAcceptableOrUnknown(
          data['ultimo_kilometraje']!,
          _ultimoKilometrajeMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_ultimoKilometrajeMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Vehiculo map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Vehiculo(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      clienteId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}cliente_id'],
      )!,
      matricula: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}matricula'],
      )!,
      marca: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}marca'],
      )!,
      modelo: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}modelo'],
      )!,
      anio: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}anio'],
      )!,
      ultimoKilometraje: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}ultimo_kilometraje'],
      )!,
    );
  }

  @override
  $VehiculosTable createAlias(String alias) {
    return $VehiculosTable(attachedDatabase, alias);
  }
}

class Vehiculo extends DataClass implements Insertable<Vehiculo> {
  final String id;
  final String clienteId;
  final String matricula;
  final String marca;
  final String modelo;
  final int anio;
  final int ultimoKilometraje;
  const Vehiculo({
    required this.id,
    required this.clienteId,
    required this.matricula,
    required this.marca,
    required this.modelo,
    required this.anio,
    required this.ultimoKilometraje,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['cliente_id'] = Variable<String>(clienteId);
    map['matricula'] = Variable<String>(matricula);
    map['marca'] = Variable<String>(marca);
    map['modelo'] = Variable<String>(modelo);
    map['anio'] = Variable<int>(anio);
    map['ultimo_kilometraje'] = Variable<int>(ultimoKilometraje);
    return map;
  }

  VehiculosCompanion toCompanion(bool nullToAbsent) {
    return VehiculosCompanion(
      id: Value(id),
      clienteId: Value(clienteId),
      matricula: Value(matricula),
      marca: Value(marca),
      modelo: Value(modelo),
      anio: Value(anio),
      ultimoKilometraje: Value(ultimoKilometraje),
    );
  }

  factory Vehiculo.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Vehiculo(
      id: serializer.fromJson<String>(json['id']),
      clienteId: serializer.fromJson<String>(json['clienteId']),
      matricula: serializer.fromJson<String>(json['matricula']),
      marca: serializer.fromJson<String>(json['marca']),
      modelo: serializer.fromJson<String>(json['modelo']),
      anio: serializer.fromJson<int>(json['anio']),
      ultimoKilometraje: serializer.fromJson<int>(json['ultimoKilometraje']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'clienteId': serializer.toJson<String>(clienteId),
      'matricula': serializer.toJson<String>(matricula),
      'marca': serializer.toJson<String>(marca),
      'modelo': serializer.toJson<String>(modelo),
      'anio': serializer.toJson<int>(anio),
      'ultimoKilometraje': serializer.toJson<int>(ultimoKilometraje),
    };
  }

  Vehiculo copyWith({
    String? id,
    String? clienteId,
    String? matricula,
    String? marca,
    String? modelo,
    int? anio,
    int? ultimoKilometraje,
  }) => Vehiculo(
    id: id ?? this.id,
    clienteId: clienteId ?? this.clienteId,
    matricula: matricula ?? this.matricula,
    marca: marca ?? this.marca,
    modelo: modelo ?? this.modelo,
    anio: anio ?? this.anio,
    ultimoKilometraje: ultimoKilometraje ?? this.ultimoKilometraje,
  );
  Vehiculo copyWithCompanion(VehiculosCompanion data) {
    return Vehiculo(
      id: data.id.present ? data.id.value : this.id,
      clienteId: data.clienteId.present ? data.clienteId.value : this.clienteId,
      matricula: data.matricula.present ? data.matricula.value : this.matricula,
      marca: data.marca.present ? data.marca.value : this.marca,
      modelo: data.modelo.present ? data.modelo.value : this.modelo,
      anio: data.anio.present ? data.anio.value : this.anio,
      ultimoKilometraje: data.ultimoKilometraje.present
          ? data.ultimoKilometraje.value
          : this.ultimoKilometraje,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Vehiculo(')
          ..write('id: $id, ')
          ..write('clienteId: $clienteId, ')
          ..write('matricula: $matricula, ')
          ..write('marca: $marca, ')
          ..write('modelo: $modelo, ')
          ..write('anio: $anio, ')
          ..write('ultimoKilometraje: $ultimoKilometraje')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    clienteId,
    matricula,
    marca,
    modelo,
    anio,
    ultimoKilometraje,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Vehiculo &&
          other.id == this.id &&
          other.clienteId == this.clienteId &&
          other.matricula == this.matricula &&
          other.marca == this.marca &&
          other.modelo == this.modelo &&
          other.anio == this.anio &&
          other.ultimoKilometraje == this.ultimoKilometraje);
}

class VehiculosCompanion extends UpdateCompanion<Vehiculo> {
  final Value<String> id;
  final Value<String> clienteId;
  final Value<String> matricula;
  final Value<String> marca;
  final Value<String> modelo;
  final Value<int> anio;
  final Value<int> ultimoKilometraje;
  final Value<int> rowid;
  const VehiculosCompanion({
    this.id = const Value.absent(),
    this.clienteId = const Value.absent(),
    this.matricula = const Value.absent(),
    this.marca = const Value.absent(),
    this.modelo = const Value.absent(),
    this.anio = const Value.absent(),
    this.ultimoKilometraje = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  VehiculosCompanion.insert({
    required String id,
    required String clienteId,
    required String matricula,
    required String marca,
    required String modelo,
    required int anio,
    required int ultimoKilometraje,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       clienteId = Value(clienteId),
       matricula = Value(matricula),
       marca = Value(marca),
       modelo = Value(modelo),
       anio = Value(anio),
       ultimoKilometraje = Value(ultimoKilometraje);
  static Insertable<Vehiculo> custom({
    Expression<String>? id,
    Expression<String>? clienteId,
    Expression<String>? matricula,
    Expression<String>? marca,
    Expression<String>? modelo,
    Expression<int>? anio,
    Expression<int>? ultimoKilometraje,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (clienteId != null) 'cliente_id': clienteId,
      if (matricula != null) 'matricula': matricula,
      if (marca != null) 'marca': marca,
      if (modelo != null) 'modelo': modelo,
      if (anio != null) 'anio': anio,
      if (ultimoKilometraje != null) 'ultimo_kilometraje': ultimoKilometraje,
      if (rowid != null) 'rowid': rowid,
    });
  }

  VehiculosCompanion copyWith({
    Value<String>? id,
    Value<String>? clienteId,
    Value<String>? matricula,
    Value<String>? marca,
    Value<String>? modelo,
    Value<int>? anio,
    Value<int>? ultimoKilometraje,
    Value<int>? rowid,
  }) {
    return VehiculosCompanion(
      id: id ?? this.id,
      clienteId: clienteId ?? this.clienteId,
      matricula: matricula ?? this.matricula,
      marca: marca ?? this.marca,
      modelo: modelo ?? this.modelo,
      anio: anio ?? this.anio,
      ultimoKilometraje: ultimoKilometraje ?? this.ultimoKilometraje,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (clienteId.present) {
      map['cliente_id'] = Variable<String>(clienteId.value);
    }
    if (matricula.present) {
      map['matricula'] = Variable<String>(matricula.value);
    }
    if (marca.present) {
      map['marca'] = Variable<String>(marca.value);
    }
    if (modelo.present) {
      map['modelo'] = Variable<String>(modelo.value);
    }
    if (anio.present) {
      map['anio'] = Variable<int>(anio.value);
    }
    if (ultimoKilometraje.present) {
      map['ultimo_kilometraje'] = Variable<int>(ultimoKilometraje.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('VehiculosCompanion(')
          ..write('id: $id, ')
          ..write('clienteId: $clienteId, ')
          ..write('matricula: $matricula, ')
          ..write('marca: $marca, ')
          ..write('modelo: $modelo, ')
          ..write('anio: $anio, ')
          ..write('ultimoKilometraje: $ultimoKilometraje, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $MecanicosTable extends Mecanicos
    with TableInfo<$MecanicosTable, Mecanico> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $MecanicosTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _nombreMeta = const VerificationMeta('nombre');
  @override
  late final GeneratedColumn<String> nombre = GeneratedColumn<String>(
    'nombre',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _telefonoMeta = const VerificationMeta(
    'telefono',
  );
  @override
  late final GeneratedColumn<String> telefono = GeneratedColumn<String>(
    'telefono',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [id, nombre, telefono];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'mecanicos';
  @override
  VerificationContext validateIntegrity(
    Insertable<Mecanico> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('nombre')) {
      context.handle(
        _nombreMeta,
        nombre.isAcceptableOrUnknown(data['nombre']!, _nombreMeta),
      );
    } else if (isInserting) {
      context.missing(_nombreMeta);
    }
    if (data.containsKey('telefono')) {
      context.handle(
        _telefonoMeta,
        telefono.isAcceptableOrUnknown(data['telefono']!, _telefonoMeta),
      );
    } else if (isInserting) {
      context.missing(_telefonoMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Mecanico map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Mecanico(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      nombre: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}nombre'],
      )!,
      telefono: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}telefono'],
      )!,
    );
  }

  @override
  $MecanicosTable createAlias(String alias) {
    return $MecanicosTable(attachedDatabase, alias);
  }
}

class Mecanico extends DataClass implements Insertable<Mecanico> {
  final String id;
  final String nombre;
  final String telefono;
  const Mecanico({
    required this.id,
    required this.nombre,
    required this.telefono,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['nombre'] = Variable<String>(nombre);
    map['telefono'] = Variable<String>(telefono);
    return map;
  }

  MecanicosCompanion toCompanion(bool nullToAbsent) {
    return MecanicosCompanion(
      id: Value(id),
      nombre: Value(nombre),
      telefono: Value(telefono),
    );
  }

  factory Mecanico.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Mecanico(
      id: serializer.fromJson<String>(json['id']),
      nombre: serializer.fromJson<String>(json['nombre']),
      telefono: serializer.fromJson<String>(json['telefono']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'nombre': serializer.toJson<String>(nombre),
      'telefono': serializer.toJson<String>(telefono),
    };
  }

  Mecanico copyWith({String? id, String? nombre, String? telefono}) => Mecanico(
    id: id ?? this.id,
    nombre: nombre ?? this.nombre,
    telefono: telefono ?? this.telefono,
  );
  Mecanico copyWithCompanion(MecanicosCompanion data) {
    return Mecanico(
      id: data.id.present ? data.id.value : this.id,
      nombre: data.nombre.present ? data.nombre.value : this.nombre,
      telefono: data.telefono.present ? data.telefono.value : this.telefono,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Mecanico(')
          ..write('id: $id, ')
          ..write('nombre: $nombre, ')
          ..write('telefono: $telefono')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, nombre, telefono);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Mecanico &&
          other.id == this.id &&
          other.nombre == this.nombre &&
          other.telefono == this.telefono);
}

class MecanicosCompanion extends UpdateCompanion<Mecanico> {
  final Value<String> id;
  final Value<String> nombre;
  final Value<String> telefono;
  final Value<int> rowid;
  const MecanicosCompanion({
    this.id = const Value.absent(),
    this.nombre = const Value.absent(),
    this.telefono = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  MecanicosCompanion.insert({
    required String id,
    required String nombre,
    required String telefono,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       nombre = Value(nombre),
       telefono = Value(telefono);
  static Insertable<Mecanico> custom({
    Expression<String>? id,
    Expression<String>? nombre,
    Expression<String>? telefono,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (nombre != null) 'nombre': nombre,
      if (telefono != null) 'telefono': telefono,
      if (rowid != null) 'rowid': rowid,
    });
  }

  MecanicosCompanion copyWith({
    Value<String>? id,
    Value<String>? nombre,
    Value<String>? telefono,
    Value<int>? rowid,
  }) {
    return MecanicosCompanion(
      id: id ?? this.id,
      nombre: nombre ?? this.nombre,
      telefono: telefono ?? this.telefono,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (nombre.present) {
      map['nombre'] = Variable<String>(nombre.value);
    }
    if (telefono.present) {
      map['telefono'] = Variable<String>(telefono.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('MecanicosCompanion(')
          ..write('id: $id, ')
          ..write('nombre: $nombre, ')
          ..write('telefono: $telefono, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $OrdenesTable extends Ordenes with TableInfo<$OrdenesTable, Ordene> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $OrdenesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _vehiculoIdMeta = const VerificationMeta(
    'vehiculoId',
  );
  @override
  late final GeneratedColumn<String> vehiculoId = GeneratedColumn<String>(
    'vehiculo_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES vehiculos (id) ON DELETE RESTRICT',
    ),
  );
  static const VerificationMeta _mecanicoIdMeta = const VerificationMeta(
    'mecanicoId',
  );
  @override
  late final GeneratedColumn<String> mecanicoId = GeneratedColumn<String>(
    'mecanico_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES mecanicos (id) ON DELETE RESTRICT',
    ),
  );
  static const VerificationMeta _fechaEntradaMeta = const VerificationMeta(
    'fechaEntrada',
  );
  @override
  late final GeneratedColumn<DateTime> fechaEntrada = GeneratedColumn<DateTime>(
    'fecha_entrada',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _problemaReportadoMeta = const VerificationMeta(
    'problemaReportado',
  );
  @override
  late final GeneratedColumn<String> problemaReportado =
      GeneratedColumn<String>(
        'problema_reportado',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: true,
      );
  static const VerificationMeta _estadoMeta = const VerificationMeta('estado');
  @override
  late final GeneratedColumn<String> estado = GeneratedColumn<String>(
    'estado',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('recibida'),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    vehiculoId,
    mecanicoId,
    fechaEntrada,
    problemaReportado,
    estado,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'ordenes';
  @override
  VerificationContext validateIntegrity(
    Insertable<Ordene> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('vehiculo_id')) {
      context.handle(
        _vehiculoIdMeta,
        vehiculoId.isAcceptableOrUnknown(data['vehiculo_id']!, _vehiculoIdMeta),
      );
    } else if (isInserting) {
      context.missing(_vehiculoIdMeta);
    }
    if (data.containsKey('mecanico_id')) {
      context.handle(
        _mecanicoIdMeta,
        mecanicoId.isAcceptableOrUnknown(data['mecanico_id']!, _mecanicoIdMeta),
      );
    } else if (isInserting) {
      context.missing(_mecanicoIdMeta);
    }
    if (data.containsKey('fecha_entrada')) {
      context.handle(
        _fechaEntradaMeta,
        fechaEntrada.isAcceptableOrUnknown(
          data['fecha_entrada']!,
          _fechaEntradaMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_fechaEntradaMeta);
    }
    if (data.containsKey('problema_reportado')) {
      context.handle(
        _problemaReportadoMeta,
        problemaReportado.isAcceptableOrUnknown(
          data['problema_reportado']!,
          _problemaReportadoMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_problemaReportadoMeta);
    }
    if (data.containsKey('estado')) {
      context.handle(
        _estadoMeta,
        estado.isAcceptableOrUnknown(data['estado']!, _estadoMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Ordene map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Ordene(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      vehiculoId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}vehiculo_id'],
      )!,
      mecanicoId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}mecanico_id'],
      )!,
      fechaEntrada: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}fecha_entrada'],
      )!,
      problemaReportado: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}problema_reportado'],
      )!,
      estado: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}estado'],
      )!,
    );
  }

  @override
  $OrdenesTable createAlias(String alias) {
    return $OrdenesTable(attachedDatabase, alias);
  }
}

class Ordene extends DataClass implements Insertable<Ordene> {
  final String id;
  final String vehiculoId;
  final String mecanicoId;
  final DateTime fechaEntrada;
  final String problemaReportado;
  final String estado;
  const Ordene({
    required this.id,
    required this.vehiculoId,
    required this.mecanicoId,
    required this.fechaEntrada,
    required this.problemaReportado,
    required this.estado,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['vehiculo_id'] = Variable<String>(vehiculoId);
    map['mecanico_id'] = Variable<String>(mecanicoId);
    map['fecha_entrada'] = Variable<DateTime>(fechaEntrada);
    map['problema_reportado'] = Variable<String>(problemaReportado);
    map['estado'] = Variable<String>(estado);
    return map;
  }

  OrdenesCompanion toCompanion(bool nullToAbsent) {
    return OrdenesCompanion(
      id: Value(id),
      vehiculoId: Value(vehiculoId),
      mecanicoId: Value(mecanicoId),
      fechaEntrada: Value(fechaEntrada),
      problemaReportado: Value(problemaReportado),
      estado: Value(estado),
    );
  }

  factory Ordene.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Ordene(
      id: serializer.fromJson<String>(json['id']),
      vehiculoId: serializer.fromJson<String>(json['vehiculoId']),
      mecanicoId: serializer.fromJson<String>(json['mecanicoId']),
      fechaEntrada: serializer.fromJson<DateTime>(json['fechaEntrada']),
      problemaReportado: serializer.fromJson<String>(json['problemaReportado']),
      estado: serializer.fromJson<String>(json['estado']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'vehiculoId': serializer.toJson<String>(vehiculoId),
      'mecanicoId': serializer.toJson<String>(mecanicoId),
      'fechaEntrada': serializer.toJson<DateTime>(fechaEntrada),
      'problemaReportado': serializer.toJson<String>(problemaReportado),
      'estado': serializer.toJson<String>(estado),
    };
  }

  Ordene copyWith({
    String? id,
    String? vehiculoId,
    String? mecanicoId,
    DateTime? fechaEntrada,
    String? problemaReportado,
    String? estado,
  }) => Ordene(
    id: id ?? this.id,
    vehiculoId: vehiculoId ?? this.vehiculoId,
    mecanicoId: mecanicoId ?? this.mecanicoId,
    fechaEntrada: fechaEntrada ?? this.fechaEntrada,
    problemaReportado: problemaReportado ?? this.problemaReportado,
    estado: estado ?? this.estado,
  );
  Ordene copyWithCompanion(OrdenesCompanion data) {
    return Ordene(
      id: data.id.present ? data.id.value : this.id,
      vehiculoId: data.vehiculoId.present
          ? data.vehiculoId.value
          : this.vehiculoId,
      mecanicoId: data.mecanicoId.present
          ? data.mecanicoId.value
          : this.mecanicoId,
      fechaEntrada: data.fechaEntrada.present
          ? data.fechaEntrada.value
          : this.fechaEntrada,
      problemaReportado: data.problemaReportado.present
          ? data.problemaReportado.value
          : this.problemaReportado,
      estado: data.estado.present ? data.estado.value : this.estado,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Ordene(')
          ..write('id: $id, ')
          ..write('vehiculoId: $vehiculoId, ')
          ..write('mecanicoId: $mecanicoId, ')
          ..write('fechaEntrada: $fechaEntrada, ')
          ..write('problemaReportado: $problemaReportado, ')
          ..write('estado: $estado')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    vehiculoId,
    mecanicoId,
    fechaEntrada,
    problemaReportado,
    estado,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Ordene &&
          other.id == this.id &&
          other.vehiculoId == this.vehiculoId &&
          other.mecanicoId == this.mecanicoId &&
          other.fechaEntrada == this.fechaEntrada &&
          other.problemaReportado == this.problemaReportado &&
          other.estado == this.estado);
}

class OrdenesCompanion extends UpdateCompanion<Ordene> {
  final Value<String> id;
  final Value<String> vehiculoId;
  final Value<String> mecanicoId;
  final Value<DateTime> fechaEntrada;
  final Value<String> problemaReportado;
  final Value<String> estado;
  final Value<int> rowid;
  const OrdenesCompanion({
    this.id = const Value.absent(),
    this.vehiculoId = const Value.absent(),
    this.mecanicoId = const Value.absent(),
    this.fechaEntrada = const Value.absent(),
    this.problemaReportado = const Value.absent(),
    this.estado = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  OrdenesCompanion.insert({
    required String id,
    required String vehiculoId,
    required String mecanicoId,
    required DateTime fechaEntrada,
    required String problemaReportado,
    this.estado = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       vehiculoId = Value(vehiculoId),
       mecanicoId = Value(mecanicoId),
       fechaEntrada = Value(fechaEntrada),
       problemaReportado = Value(problemaReportado);
  static Insertable<Ordene> custom({
    Expression<String>? id,
    Expression<String>? vehiculoId,
    Expression<String>? mecanicoId,
    Expression<DateTime>? fechaEntrada,
    Expression<String>? problemaReportado,
    Expression<String>? estado,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (vehiculoId != null) 'vehiculo_id': vehiculoId,
      if (mecanicoId != null) 'mecanico_id': mecanicoId,
      if (fechaEntrada != null) 'fecha_entrada': fechaEntrada,
      if (problemaReportado != null) 'problema_reportado': problemaReportado,
      if (estado != null) 'estado': estado,
      if (rowid != null) 'rowid': rowid,
    });
  }

  OrdenesCompanion copyWith({
    Value<String>? id,
    Value<String>? vehiculoId,
    Value<String>? mecanicoId,
    Value<DateTime>? fechaEntrada,
    Value<String>? problemaReportado,
    Value<String>? estado,
    Value<int>? rowid,
  }) {
    return OrdenesCompanion(
      id: id ?? this.id,
      vehiculoId: vehiculoId ?? this.vehiculoId,
      mecanicoId: mecanicoId ?? this.mecanicoId,
      fechaEntrada: fechaEntrada ?? this.fechaEntrada,
      problemaReportado: problemaReportado ?? this.problemaReportado,
      estado: estado ?? this.estado,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (vehiculoId.present) {
      map['vehiculo_id'] = Variable<String>(vehiculoId.value);
    }
    if (mecanicoId.present) {
      map['mecanico_id'] = Variable<String>(mecanicoId.value);
    }
    if (fechaEntrada.present) {
      map['fecha_entrada'] = Variable<DateTime>(fechaEntrada.value);
    }
    if (problemaReportado.present) {
      map['problema_reportado'] = Variable<String>(problemaReportado.value);
    }
    if (estado.present) {
      map['estado'] = Variable<String>(estado.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('OrdenesCompanion(')
          ..write('id: $id, ')
          ..write('vehiculoId: $vehiculoId, ')
          ..write('mecanicoId: $mecanicoId, ')
          ..write('fechaEntrada: $fechaEntrada, ')
          ..write('problemaReportado: $problemaReportado, ')
          ..write('estado: $estado, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $TrabajosTable extends Trabajos with TableInfo<$TrabajosTable, Trabajo> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $TrabajosTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _ordenIdMeta = const VerificationMeta(
    'ordenId',
  );
  @override
  late final GeneratedColumn<String> ordenId = GeneratedColumn<String>(
    'orden_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES ordenes (id) ON DELETE CASCADE',
    ),
  );
  static const VerificationMeta _descripcionMeta = const VerificationMeta(
    'descripcion',
  );
  @override
  late final GeneratedColumn<String> descripcion = GeneratedColumn<String>(
    'descripcion',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _precioManoObraMeta = const VerificationMeta(
    'precioManoObra',
  );
  @override
  late final GeneratedColumn<double> precioManoObra = GeneratedColumn<double>(
    'precio_mano_obra',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    ordenId,
    descripcion,
    precioManoObra,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'trabajos';
  @override
  VerificationContext validateIntegrity(
    Insertable<Trabajo> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('orden_id')) {
      context.handle(
        _ordenIdMeta,
        ordenId.isAcceptableOrUnknown(data['orden_id']!, _ordenIdMeta),
      );
    } else if (isInserting) {
      context.missing(_ordenIdMeta);
    }
    if (data.containsKey('descripcion')) {
      context.handle(
        _descripcionMeta,
        descripcion.isAcceptableOrUnknown(
          data['descripcion']!,
          _descripcionMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_descripcionMeta);
    }
    if (data.containsKey('precio_mano_obra')) {
      context.handle(
        _precioManoObraMeta,
        precioManoObra.isAcceptableOrUnknown(
          data['precio_mano_obra']!,
          _precioManoObraMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_precioManoObraMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Trabajo map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Trabajo(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      ordenId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}orden_id'],
      )!,
      descripcion: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}descripcion'],
      )!,
      precioManoObra: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}precio_mano_obra'],
      )!,
    );
  }

  @override
  $TrabajosTable createAlias(String alias) {
    return $TrabajosTable(attachedDatabase, alias);
  }
}

class Trabajo extends DataClass implements Insertable<Trabajo> {
  final String id;
  final String ordenId;
  final String descripcion;
  final double precioManoObra;
  const Trabajo({
    required this.id,
    required this.ordenId,
    required this.descripcion,
    required this.precioManoObra,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['orden_id'] = Variable<String>(ordenId);
    map['descripcion'] = Variable<String>(descripcion);
    map['precio_mano_obra'] = Variable<double>(precioManoObra);
    return map;
  }

  TrabajosCompanion toCompanion(bool nullToAbsent) {
    return TrabajosCompanion(
      id: Value(id),
      ordenId: Value(ordenId),
      descripcion: Value(descripcion),
      precioManoObra: Value(precioManoObra),
    );
  }

  factory Trabajo.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Trabajo(
      id: serializer.fromJson<String>(json['id']),
      ordenId: serializer.fromJson<String>(json['ordenId']),
      descripcion: serializer.fromJson<String>(json['descripcion']),
      precioManoObra: serializer.fromJson<double>(json['precioManoObra']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'ordenId': serializer.toJson<String>(ordenId),
      'descripcion': serializer.toJson<String>(descripcion),
      'precioManoObra': serializer.toJson<double>(precioManoObra),
    };
  }

  Trabajo copyWith({
    String? id,
    String? ordenId,
    String? descripcion,
    double? precioManoObra,
  }) => Trabajo(
    id: id ?? this.id,
    ordenId: ordenId ?? this.ordenId,
    descripcion: descripcion ?? this.descripcion,
    precioManoObra: precioManoObra ?? this.precioManoObra,
  );
  Trabajo copyWithCompanion(TrabajosCompanion data) {
    return Trabajo(
      id: data.id.present ? data.id.value : this.id,
      ordenId: data.ordenId.present ? data.ordenId.value : this.ordenId,
      descripcion: data.descripcion.present
          ? data.descripcion.value
          : this.descripcion,
      precioManoObra: data.precioManoObra.present
          ? data.precioManoObra.value
          : this.precioManoObra,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Trabajo(')
          ..write('id: $id, ')
          ..write('ordenId: $ordenId, ')
          ..write('descripcion: $descripcion, ')
          ..write('precioManoObra: $precioManoObra')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, ordenId, descripcion, precioManoObra);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Trabajo &&
          other.id == this.id &&
          other.ordenId == this.ordenId &&
          other.descripcion == this.descripcion &&
          other.precioManoObra == this.precioManoObra);
}

class TrabajosCompanion extends UpdateCompanion<Trabajo> {
  final Value<String> id;
  final Value<String> ordenId;
  final Value<String> descripcion;
  final Value<double> precioManoObra;
  final Value<int> rowid;
  const TrabajosCompanion({
    this.id = const Value.absent(),
    this.ordenId = const Value.absent(),
    this.descripcion = const Value.absent(),
    this.precioManoObra = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  TrabajosCompanion.insert({
    required String id,
    required String ordenId,
    required String descripcion,
    required double precioManoObra,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       ordenId = Value(ordenId),
       descripcion = Value(descripcion),
       precioManoObra = Value(precioManoObra);
  static Insertable<Trabajo> custom({
    Expression<String>? id,
    Expression<String>? ordenId,
    Expression<String>? descripcion,
    Expression<double>? precioManoObra,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (ordenId != null) 'orden_id': ordenId,
      if (descripcion != null) 'descripcion': descripcion,
      if (precioManoObra != null) 'precio_mano_obra': precioManoObra,
      if (rowid != null) 'rowid': rowid,
    });
  }

  TrabajosCompanion copyWith({
    Value<String>? id,
    Value<String>? ordenId,
    Value<String>? descripcion,
    Value<double>? precioManoObra,
    Value<int>? rowid,
  }) {
    return TrabajosCompanion(
      id: id ?? this.id,
      ordenId: ordenId ?? this.ordenId,
      descripcion: descripcion ?? this.descripcion,
      precioManoObra: precioManoObra ?? this.precioManoObra,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (ordenId.present) {
      map['orden_id'] = Variable<String>(ordenId.value);
    }
    if (descripcion.present) {
      map['descripcion'] = Variable<String>(descripcion.value);
    }
    if (precioManoObra.present) {
      map['precio_mano_obra'] = Variable<double>(precioManoObra.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('TrabajosCompanion(')
          ..write('id: $id, ')
          ..write('ordenId: $ordenId, ')
          ..write('descripcion: $descripcion, ')
          ..write('precioManoObra: $precioManoObra, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $RepuestosTable extends Repuestos
    with TableInfo<$RepuestosTable, Repuesto> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $RepuestosTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _nombreMeta = const VerificationMeta('nombre');
  @override
  late final GeneratedColumn<String> nombre = GeneratedColumn<String>(
    'nombre',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _codigoMeta = const VerificationMeta('codigo');
  @override
  late final GeneratedColumn<String> codigo = GeneratedColumn<String>(
    'codigo',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways('UNIQUE'),
  );
  static const VerificationMeta _precioVentaMeta = const VerificationMeta(
    'precioVenta',
  );
  @override
  late final GeneratedColumn<double> precioVenta = GeneratedColumn<double>(
    'precio_venta',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _existenciasMeta = const VerificationMeta(
    'existencias',
  );
  @override
  late final GeneratedColumn<int> existencias = GeneratedColumn<int>(
    'existencias',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _stockMinimoMeta = const VerificationMeta(
    'stockMinimo',
  );
  @override
  late final GeneratedColumn<int> stockMinimo = GeneratedColumn<int>(
    'stock_minimo',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(5),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    nombre,
    codigo,
    precioVenta,
    existencias,
    stockMinimo,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'repuestos';
  @override
  VerificationContext validateIntegrity(
    Insertable<Repuesto> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('nombre')) {
      context.handle(
        _nombreMeta,
        nombre.isAcceptableOrUnknown(data['nombre']!, _nombreMeta),
      );
    } else if (isInserting) {
      context.missing(_nombreMeta);
    }
    if (data.containsKey('codigo')) {
      context.handle(
        _codigoMeta,
        codigo.isAcceptableOrUnknown(data['codigo']!, _codigoMeta),
      );
    } else if (isInserting) {
      context.missing(_codigoMeta);
    }
    if (data.containsKey('precio_venta')) {
      context.handle(
        _precioVentaMeta,
        precioVenta.isAcceptableOrUnknown(
          data['precio_venta']!,
          _precioVentaMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_precioVentaMeta);
    }
    if (data.containsKey('existencias')) {
      context.handle(
        _existenciasMeta,
        existencias.isAcceptableOrUnknown(
          data['existencias']!,
          _existenciasMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_existenciasMeta);
    }
    if (data.containsKey('stock_minimo')) {
      context.handle(
        _stockMinimoMeta,
        stockMinimo.isAcceptableOrUnknown(
          data['stock_minimo']!,
          _stockMinimoMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Repuesto map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Repuesto(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      nombre: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}nombre'],
      )!,
      codigo: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}codigo'],
      )!,
      precioVenta: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}precio_venta'],
      )!,
      existencias: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}existencias'],
      )!,
      stockMinimo: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}stock_minimo'],
      )!,
    );
  }

  @override
  $RepuestosTable createAlias(String alias) {
    return $RepuestosTable(attachedDatabase, alias);
  }
}

class Repuesto extends DataClass implements Insertable<Repuesto> {
  final String id;
  final String nombre;
  final String codigo;
  final double precioVenta;
  final int existencias;
  final int stockMinimo;
  const Repuesto({
    required this.id,
    required this.nombre,
    required this.codigo,
    required this.precioVenta,
    required this.existencias,
    required this.stockMinimo,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['nombre'] = Variable<String>(nombre);
    map['codigo'] = Variable<String>(codigo);
    map['precio_venta'] = Variable<double>(precioVenta);
    map['existencias'] = Variable<int>(existencias);
    map['stock_minimo'] = Variable<int>(stockMinimo);
    return map;
  }

  RepuestosCompanion toCompanion(bool nullToAbsent) {
    return RepuestosCompanion(
      id: Value(id),
      nombre: Value(nombre),
      codigo: Value(codigo),
      precioVenta: Value(precioVenta),
      existencias: Value(existencias),
      stockMinimo: Value(stockMinimo),
    );
  }

  factory Repuesto.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Repuesto(
      id: serializer.fromJson<String>(json['id']),
      nombre: serializer.fromJson<String>(json['nombre']),
      codigo: serializer.fromJson<String>(json['codigo']),
      precioVenta: serializer.fromJson<double>(json['precioVenta']),
      existencias: serializer.fromJson<int>(json['existencias']),
      stockMinimo: serializer.fromJson<int>(json['stockMinimo']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'nombre': serializer.toJson<String>(nombre),
      'codigo': serializer.toJson<String>(codigo),
      'precioVenta': serializer.toJson<double>(precioVenta),
      'existencias': serializer.toJson<int>(existencias),
      'stockMinimo': serializer.toJson<int>(stockMinimo),
    };
  }

  Repuesto copyWith({
    String? id,
    String? nombre,
    String? codigo,
    double? precioVenta,
    int? existencias,
    int? stockMinimo,
  }) => Repuesto(
    id: id ?? this.id,
    nombre: nombre ?? this.nombre,
    codigo: codigo ?? this.codigo,
    precioVenta: precioVenta ?? this.precioVenta,
    existencias: existencias ?? this.existencias,
    stockMinimo: stockMinimo ?? this.stockMinimo,
  );
  Repuesto copyWithCompanion(RepuestosCompanion data) {
    return Repuesto(
      id: data.id.present ? data.id.value : this.id,
      nombre: data.nombre.present ? data.nombre.value : this.nombre,
      codigo: data.codigo.present ? data.codigo.value : this.codigo,
      precioVenta: data.precioVenta.present
          ? data.precioVenta.value
          : this.precioVenta,
      existencias: data.existencias.present
          ? data.existencias.value
          : this.existencias,
      stockMinimo: data.stockMinimo.present
          ? data.stockMinimo.value
          : this.stockMinimo,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Repuesto(')
          ..write('id: $id, ')
          ..write('nombre: $nombre, ')
          ..write('codigo: $codigo, ')
          ..write('precioVenta: $precioVenta, ')
          ..write('existencias: $existencias, ')
          ..write('stockMinimo: $stockMinimo')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, nombre, codigo, precioVenta, existencias, stockMinimo);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Repuesto &&
          other.id == this.id &&
          other.nombre == this.nombre &&
          other.codigo == this.codigo &&
          other.precioVenta == this.precioVenta &&
          other.existencias == this.existencias &&
          other.stockMinimo == this.stockMinimo);
}

class RepuestosCompanion extends UpdateCompanion<Repuesto> {
  final Value<String> id;
  final Value<String> nombre;
  final Value<String> codigo;
  final Value<double> precioVenta;
  final Value<int> existencias;
  final Value<int> stockMinimo;
  final Value<int> rowid;
  const RepuestosCompanion({
    this.id = const Value.absent(),
    this.nombre = const Value.absent(),
    this.codigo = const Value.absent(),
    this.precioVenta = const Value.absent(),
    this.existencias = const Value.absent(),
    this.stockMinimo = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  RepuestosCompanion.insert({
    required String id,
    required String nombre,
    required String codigo,
    required double precioVenta,
    required int existencias,
    this.stockMinimo = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       nombre = Value(nombre),
       codigo = Value(codigo),
       precioVenta = Value(precioVenta),
       existencias = Value(existencias);
  static Insertable<Repuesto> custom({
    Expression<String>? id,
    Expression<String>? nombre,
    Expression<String>? codigo,
    Expression<double>? precioVenta,
    Expression<int>? existencias,
    Expression<int>? stockMinimo,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (nombre != null) 'nombre': nombre,
      if (codigo != null) 'codigo': codigo,
      if (precioVenta != null) 'precio_venta': precioVenta,
      if (existencias != null) 'existencias': existencias,
      if (stockMinimo != null) 'stock_minimo': stockMinimo,
      if (rowid != null) 'rowid': rowid,
    });
  }

  RepuestosCompanion copyWith({
    Value<String>? id,
    Value<String>? nombre,
    Value<String>? codigo,
    Value<double>? precioVenta,
    Value<int>? existencias,
    Value<int>? stockMinimo,
    Value<int>? rowid,
  }) {
    return RepuestosCompanion(
      id: id ?? this.id,
      nombre: nombre ?? this.nombre,
      codigo: codigo ?? this.codigo,
      precioVenta: precioVenta ?? this.precioVenta,
      existencias: existencias ?? this.existencias,
      stockMinimo: stockMinimo ?? this.stockMinimo,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (nombre.present) {
      map['nombre'] = Variable<String>(nombre.value);
    }
    if (codigo.present) {
      map['codigo'] = Variable<String>(codigo.value);
    }
    if (precioVenta.present) {
      map['precio_venta'] = Variable<double>(precioVenta.value);
    }
    if (existencias.present) {
      map['existencias'] = Variable<int>(existencias.value);
    }
    if (stockMinimo.present) {
      map['stock_minimo'] = Variable<int>(stockMinimo.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('RepuestosCompanion(')
          ..write('id: $id, ')
          ..write('nombre: $nombre, ')
          ..write('codigo: $codigo, ')
          ..write('precioVenta: $precioVenta, ')
          ..write('existencias: $existencias, ')
          ..write('stockMinimo: $stockMinimo, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $RepuestosUsadosTable extends RepuestosUsados
    with TableInfo<$RepuestosUsadosTable, RepuestosUsado> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $RepuestosUsadosTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _ordenIdMeta = const VerificationMeta(
    'ordenId',
  );
  @override
  late final GeneratedColumn<String> ordenId = GeneratedColumn<String>(
    'orden_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES ordenes (id) ON DELETE CASCADE',
    ),
  );
  static const VerificationMeta _repuestoIdMeta = const VerificationMeta(
    'repuestoId',
  );
  @override
  late final GeneratedColumn<String> repuestoId = GeneratedColumn<String>(
    'repuesto_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES repuestos (id) ON DELETE RESTRICT',
    ),
  );
  static const VerificationMeta _cantidadMeta = const VerificationMeta(
    'cantidad',
  );
  @override
  late final GeneratedColumn<int> cantidad = GeneratedColumn<int>(
    'cantidad',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [id, ordenId, repuestoId, cantidad];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'repuestos_usados';
  @override
  VerificationContext validateIntegrity(
    Insertable<RepuestosUsado> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('orden_id')) {
      context.handle(
        _ordenIdMeta,
        ordenId.isAcceptableOrUnknown(data['orden_id']!, _ordenIdMeta),
      );
    } else if (isInserting) {
      context.missing(_ordenIdMeta);
    }
    if (data.containsKey('repuesto_id')) {
      context.handle(
        _repuestoIdMeta,
        repuestoId.isAcceptableOrUnknown(data['repuesto_id']!, _repuestoIdMeta),
      );
    } else if (isInserting) {
      context.missing(_repuestoIdMeta);
    }
    if (data.containsKey('cantidad')) {
      context.handle(
        _cantidadMeta,
        cantidad.isAcceptableOrUnknown(data['cantidad']!, _cantidadMeta),
      );
    } else if (isInserting) {
      context.missing(_cantidadMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  List<Set<GeneratedColumn>> get uniqueKeys => [
    {ordenId, repuestoId},
  ];
  @override
  RepuestosUsado map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return RepuestosUsado(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      ordenId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}orden_id'],
      )!,
      repuestoId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}repuesto_id'],
      )!,
      cantidad: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}cantidad'],
      )!,
    );
  }

  @override
  $RepuestosUsadosTable createAlias(String alias) {
    return $RepuestosUsadosTable(attachedDatabase, alias);
  }
}

class RepuestosUsado extends DataClass implements Insertable<RepuestosUsado> {
  final String id;
  final String ordenId;
  final String repuestoId;
  final int cantidad;
  const RepuestosUsado({
    required this.id,
    required this.ordenId,
    required this.repuestoId,
    required this.cantidad,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['orden_id'] = Variable<String>(ordenId);
    map['repuesto_id'] = Variable<String>(repuestoId);
    map['cantidad'] = Variable<int>(cantidad);
    return map;
  }

  RepuestosUsadosCompanion toCompanion(bool nullToAbsent) {
    return RepuestosUsadosCompanion(
      id: Value(id),
      ordenId: Value(ordenId),
      repuestoId: Value(repuestoId),
      cantidad: Value(cantidad),
    );
  }

  factory RepuestosUsado.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return RepuestosUsado(
      id: serializer.fromJson<String>(json['id']),
      ordenId: serializer.fromJson<String>(json['ordenId']),
      repuestoId: serializer.fromJson<String>(json['repuestoId']),
      cantidad: serializer.fromJson<int>(json['cantidad']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'ordenId': serializer.toJson<String>(ordenId),
      'repuestoId': serializer.toJson<String>(repuestoId),
      'cantidad': serializer.toJson<int>(cantidad),
    };
  }

  RepuestosUsado copyWith({
    String? id,
    String? ordenId,
    String? repuestoId,
    int? cantidad,
  }) => RepuestosUsado(
    id: id ?? this.id,
    ordenId: ordenId ?? this.ordenId,
    repuestoId: repuestoId ?? this.repuestoId,
    cantidad: cantidad ?? this.cantidad,
  );
  RepuestosUsado copyWithCompanion(RepuestosUsadosCompanion data) {
    return RepuestosUsado(
      id: data.id.present ? data.id.value : this.id,
      ordenId: data.ordenId.present ? data.ordenId.value : this.ordenId,
      repuestoId: data.repuestoId.present
          ? data.repuestoId.value
          : this.repuestoId,
      cantidad: data.cantidad.present ? data.cantidad.value : this.cantidad,
    );
  }

  @override
  String toString() {
    return (StringBuffer('RepuestosUsado(')
          ..write('id: $id, ')
          ..write('ordenId: $ordenId, ')
          ..write('repuestoId: $repuestoId, ')
          ..write('cantidad: $cantidad')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, ordenId, repuestoId, cantidad);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is RepuestosUsado &&
          other.id == this.id &&
          other.ordenId == this.ordenId &&
          other.repuestoId == this.repuestoId &&
          other.cantidad == this.cantidad);
}

class RepuestosUsadosCompanion extends UpdateCompanion<RepuestosUsado> {
  final Value<String> id;
  final Value<String> ordenId;
  final Value<String> repuestoId;
  final Value<int> cantidad;
  final Value<int> rowid;
  const RepuestosUsadosCompanion({
    this.id = const Value.absent(),
    this.ordenId = const Value.absent(),
    this.repuestoId = const Value.absent(),
    this.cantidad = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  RepuestosUsadosCompanion.insert({
    required String id,
    required String ordenId,
    required String repuestoId,
    required int cantidad,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       ordenId = Value(ordenId),
       repuestoId = Value(repuestoId),
       cantidad = Value(cantidad);
  static Insertable<RepuestosUsado> custom({
    Expression<String>? id,
    Expression<String>? ordenId,
    Expression<String>? repuestoId,
    Expression<int>? cantidad,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (ordenId != null) 'orden_id': ordenId,
      if (repuestoId != null) 'repuesto_id': repuestoId,
      if (cantidad != null) 'cantidad': cantidad,
      if (rowid != null) 'rowid': rowid,
    });
  }

  RepuestosUsadosCompanion copyWith({
    Value<String>? id,
    Value<String>? ordenId,
    Value<String>? repuestoId,
    Value<int>? cantidad,
    Value<int>? rowid,
  }) {
    return RepuestosUsadosCompanion(
      id: id ?? this.id,
      ordenId: ordenId ?? this.ordenId,
      repuestoId: repuestoId ?? this.repuestoId,
      cantidad: cantidad ?? this.cantidad,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (ordenId.present) {
      map['orden_id'] = Variable<String>(ordenId.value);
    }
    if (repuestoId.present) {
      map['repuesto_id'] = Variable<String>(repuestoId.value);
    }
    if (cantidad.present) {
      map['cantidad'] = Variable<int>(cantidad.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('RepuestosUsadosCompanion(')
          ..write('id: $id, ')
          ..write('ordenId: $ordenId, ')
          ..write('repuestoId: $repuestoId, ')
          ..write('cantidad: $cantidad, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $PagosTable extends Pagos with TableInfo<$PagosTable, Pago> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $PagosTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _ordenIdMeta = const VerificationMeta(
    'ordenId',
  );
  @override
  late final GeneratedColumn<String> ordenId = GeneratedColumn<String>(
    'orden_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES ordenes (id) ON DELETE CASCADE',
    ),
  );
  static const VerificationMeta _cantidadMeta = const VerificationMeta(
    'cantidad',
  );
  @override
  late final GeneratedColumn<double> cantidad = GeneratedColumn<double>(
    'cantidad',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _fechaMeta = const VerificationMeta('fecha');
  @override
  late final GeneratedColumn<DateTime> fecha = GeneratedColumn<DateTime>(
    'fecha',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [id, ordenId, cantidad, fecha];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'pagos';
  @override
  VerificationContext validateIntegrity(
    Insertable<Pago> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('orden_id')) {
      context.handle(
        _ordenIdMeta,
        ordenId.isAcceptableOrUnknown(data['orden_id']!, _ordenIdMeta),
      );
    } else if (isInserting) {
      context.missing(_ordenIdMeta);
    }
    if (data.containsKey('cantidad')) {
      context.handle(
        _cantidadMeta,
        cantidad.isAcceptableOrUnknown(data['cantidad']!, _cantidadMeta),
      );
    } else if (isInserting) {
      context.missing(_cantidadMeta);
    }
    if (data.containsKey('fecha')) {
      context.handle(
        _fechaMeta,
        fecha.isAcceptableOrUnknown(data['fecha']!, _fechaMeta),
      );
    } else if (isInserting) {
      context.missing(_fechaMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Pago map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Pago(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      ordenId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}orden_id'],
      )!,
      cantidad: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}cantidad'],
      )!,
      fecha: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}fecha'],
      )!,
    );
  }

  @override
  $PagosTable createAlias(String alias) {
    return $PagosTable(attachedDatabase, alias);
  }
}

class Pago extends DataClass implements Insertable<Pago> {
  final String id;
  final String ordenId;
  final double cantidad;
  final DateTime fecha;
  const Pago({
    required this.id,
    required this.ordenId,
    required this.cantidad,
    required this.fecha,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['orden_id'] = Variable<String>(ordenId);
    map['cantidad'] = Variable<double>(cantidad);
    map['fecha'] = Variable<DateTime>(fecha);
    return map;
  }

  PagosCompanion toCompanion(bool nullToAbsent) {
    return PagosCompanion(
      id: Value(id),
      ordenId: Value(ordenId),
      cantidad: Value(cantidad),
      fecha: Value(fecha),
    );
  }

  factory Pago.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Pago(
      id: serializer.fromJson<String>(json['id']),
      ordenId: serializer.fromJson<String>(json['ordenId']),
      cantidad: serializer.fromJson<double>(json['cantidad']),
      fecha: serializer.fromJson<DateTime>(json['fecha']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'ordenId': serializer.toJson<String>(ordenId),
      'cantidad': serializer.toJson<double>(cantidad),
      'fecha': serializer.toJson<DateTime>(fecha),
    };
  }

  Pago copyWith({
    String? id,
    String? ordenId,
    double? cantidad,
    DateTime? fecha,
  }) => Pago(
    id: id ?? this.id,
    ordenId: ordenId ?? this.ordenId,
    cantidad: cantidad ?? this.cantidad,
    fecha: fecha ?? this.fecha,
  );
  Pago copyWithCompanion(PagosCompanion data) {
    return Pago(
      id: data.id.present ? data.id.value : this.id,
      ordenId: data.ordenId.present ? data.ordenId.value : this.ordenId,
      cantidad: data.cantidad.present ? data.cantidad.value : this.cantidad,
      fecha: data.fecha.present ? data.fecha.value : this.fecha,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Pago(')
          ..write('id: $id, ')
          ..write('ordenId: $ordenId, ')
          ..write('cantidad: $cantidad, ')
          ..write('fecha: $fecha')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, ordenId, cantidad, fecha);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Pago &&
          other.id == this.id &&
          other.ordenId == this.ordenId &&
          other.cantidad == this.cantidad &&
          other.fecha == this.fecha);
}

class PagosCompanion extends UpdateCompanion<Pago> {
  final Value<String> id;
  final Value<String> ordenId;
  final Value<double> cantidad;
  final Value<DateTime> fecha;
  final Value<int> rowid;
  const PagosCompanion({
    this.id = const Value.absent(),
    this.ordenId = const Value.absent(),
    this.cantidad = const Value.absent(),
    this.fecha = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  PagosCompanion.insert({
    required String id,
    required String ordenId,
    required double cantidad,
    required DateTime fecha,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       ordenId = Value(ordenId),
       cantidad = Value(cantidad),
       fecha = Value(fecha);
  static Insertable<Pago> custom({
    Expression<String>? id,
    Expression<String>? ordenId,
    Expression<double>? cantidad,
    Expression<DateTime>? fecha,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (ordenId != null) 'orden_id': ordenId,
      if (cantidad != null) 'cantidad': cantidad,
      if (fecha != null) 'fecha': fecha,
      if (rowid != null) 'rowid': rowid,
    });
  }

  PagosCompanion copyWith({
    Value<String>? id,
    Value<String>? ordenId,
    Value<double>? cantidad,
    Value<DateTime>? fecha,
    Value<int>? rowid,
  }) {
    return PagosCompanion(
      id: id ?? this.id,
      ordenId: ordenId ?? this.ordenId,
      cantidad: cantidad ?? this.cantidad,
      fecha: fecha ?? this.fecha,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (ordenId.present) {
      map['orden_id'] = Variable<String>(ordenId.value);
    }
    if (cantidad.present) {
      map['cantidad'] = Variable<double>(cantidad.value);
    }
    if (fecha.present) {
      map['fecha'] = Variable<DateTime>(fecha.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('PagosCompanion(')
          ..write('id: $id, ')
          ..write('ordenId: $ordenId, ')
          ..write('cantidad: $cantidad, ')
          ..write('fecha: $fecha, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $ClientesTable clientes = $ClientesTable(this);
  late final $VehiculosTable vehiculos = $VehiculosTable(this);
  late final $MecanicosTable mecanicos = $MecanicosTable(this);
  late final $OrdenesTable ordenes = $OrdenesTable(this);
  late final $TrabajosTable trabajos = $TrabajosTable(this);
  late final $RepuestosTable repuestos = $RepuestosTable(this);
  late final $RepuestosUsadosTable repuestosUsados = $RepuestosUsadosTable(
    this,
  );
  late final $PagosTable pagos = $PagosTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
    clientes,
    vehiculos,
    mecanicos,
    ordenes,
    trabajos,
    repuestos,
    repuestosUsados,
    pagos,
  ];
  @override
  StreamQueryUpdateRules get streamUpdateRules => const StreamQueryUpdateRules([
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'ordenes',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('trabajos', kind: UpdateKind.delete)],
    ),
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'ordenes',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('repuestos_usados', kind: UpdateKind.delete)],
    ),
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'ordenes',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('pagos', kind: UpdateKind.delete)],
    ),
  ]);
}

typedef $$ClientesTableCreateCompanionBuilder = ClientesCompanion Function({
  required String id,
  required String nombre,
  required String telefono,
  Value<String?> direccion,
  Value<int> rowid,
});
typedef $$ClientesTableUpdateCompanionBuilder = ClientesCompanion Function({
  Value<String> id,
  Value<String> nombre,
  Value<String> telefono,
  Value<String?> direccion,
  Value<int> rowid,
});

final class $$ClientesTableReferences
    extends BaseReferences<_$AppDatabase, $ClientesTable, Cliente> {
  $$ClientesTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static MultiTypedResultKey<$VehiculosTable, List<Vehiculo>>
  _vehiculosRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.vehiculos,
    aliasName: 'clientes__id__vehiculos__cliente_id',
  );

  $$VehiculosTableProcessedTableManager get vehiculosRefs {
    final manager = $$VehiculosTableTableManager(
      $_db,
      $_db.vehiculos,
    ).filter((f) => f.clienteId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(_vehiculosRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$ClientesTableFilterComposer
    extends Composer<_$AppDatabase, $ClientesTable> {
  $$ClientesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get nombre => $composableBuilder(
    column: $table.nombre,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get telefono => $composableBuilder(
    column: $table.telefono,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get direccion => $composableBuilder(
    column: $table.direccion,
    builder: (column) => ColumnFilters(column),
  );

  Expression<bool> vehiculosRefs(
    Expression<bool> Function($$VehiculosTableFilterComposer f) f,
  ) {
    final $$VehiculosTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.vehiculos,
      getReferencedColumn: (t) => t.clienteId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$VehiculosTableFilterComposer(
            $db: $db,
            $table: $db.vehiculos,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$ClientesTableOrderingComposer
    extends Composer<_$AppDatabase, $ClientesTable> {
  $$ClientesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get nombre => $composableBuilder(
    column: $table.nombre,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get telefono => $composableBuilder(
    column: $table.telefono,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get direccion => $composableBuilder(
    column: $table.direccion,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$ClientesTableAnnotationComposer
    extends Composer<_$AppDatabase, $ClientesTable> {
  $$ClientesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get nombre =>
      $composableBuilder(column: $table.nombre, builder: (column) => column);

  GeneratedColumn<String> get telefono =>
      $composableBuilder(column: $table.telefono, builder: (column) => column);

  GeneratedColumn<String> get direccion =>
      $composableBuilder(column: $table.direccion, builder: (column) => column);

  Expression<T> vehiculosRefs<T extends Object>(
    Expression<T> Function($$VehiculosTableAnnotationComposer a) f,
  ) {
    final $$VehiculosTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.vehiculos,
      getReferencedColumn: (t) => t.clienteId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$VehiculosTableAnnotationComposer(
            $db: $db,
            $table: $db.vehiculos,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$ClientesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $ClientesTable,
          Cliente,
          $$ClientesTableFilterComposer,
          $$ClientesTableOrderingComposer,
          $$ClientesTableAnnotationComposer,
          $$ClientesTableCreateCompanionBuilder,
          $$ClientesTableUpdateCompanionBuilder,
          (Cliente, $$ClientesTableReferences),
          Cliente,
          PrefetchHooks Function({bool vehiculosRefs})
        > {
  $$ClientesTableTableManager(_$AppDatabase db, $ClientesTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ClientesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ClientesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ClientesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> nombre = const Value.absent(),
                Value<String> telefono = const Value.absent(),
                Value<String?> direccion = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => ClientesCompanion(
                id: id,
                nombre: nombre,
                telefono: telefono,
                direccion: direccion,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String nombre,
                required String telefono,
                Value<String?> direccion = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => ClientesCompanion.insert(
                id: id,
                nombre: nombre,
                telefono: telefono,
                direccion: direccion,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$ClientesTable, Cliente>(table),
                  $$ClientesTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({vehiculosRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [if (vehiculosRefs) db.vehiculos],
              addJoins: null,
              getPrefetchedDataCallback: (items) async {
                return [
                  if (vehiculosRefs)
                    await $_getPrefetchedDataByColumns<
                      Cliente,
                      $ClientesTable,
                      Vehiculo,
                      $VehiculosTable
                    >(
                      currentTable: table,
                      referencedTable: $$ClientesTableReferences
                          ._vehiculosRefsTable(db),
                      managerFromTypedResult: (p0) => $$ClientesTableReferences(
                        db,
                        table,
                        p0,
                      ).vehiculosRefs,
                      currentColumn: 'id',
                      referencedColumn: 'cliente_id',
                      typedResults: items,
                    ),
                ];
              },
            );
          },
        ),
      );
}

typedef $$ClientesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $ClientesTable,
      Cliente,
      $$ClientesTableFilterComposer,
      $$ClientesTableOrderingComposer,
      $$ClientesTableAnnotationComposer,
      $$ClientesTableCreateCompanionBuilder,
      $$ClientesTableUpdateCompanionBuilder,
      (Cliente, $$ClientesTableReferences),
      Cliente,
      PrefetchHooks Function({bool vehiculosRefs})
    >;
typedef $$VehiculosTableCreateCompanionBuilder = VehiculosCompanion Function({
  required String id,
  required String clienteId,
  required String matricula,
  required String marca,
  required String modelo,
  required int anio,
  required int ultimoKilometraje,
  Value<int> rowid,
});
typedef $$VehiculosTableUpdateCompanionBuilder = VehiculosCompanion Function({
  Value<String> id,
  Value<String> clienteId,
  Value<String> matricula,
  Value<String> marca,
  Value<String> modelo,
  Value<int> anio,
  Value<int> ultimoKilometraje,
  Value<int> rowid,
});

final class $$VehiculosTableReferences
    extends BaseReferences<_$AppDatabase, $VehiculosTable, Vehiculo> {
  $$VehiculosTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $ClientesTable _clienteIdTable(_$AppDatabase db) =>
      db.clientes.createAlias('vehiculos__cliente_id__clientes__id');

  $$ClientesTableProcessedTableManager get clienteId {
    final $_column = $_itemColumn<String>('cliente_id')!;

    final manager = $$ClientesTableTableManager(
      $_db,
      $_db.clientes,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_clienteIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static MultiTypedResultKey<$OrdenesTable, List<Ordene>> _ordenesRefsTable(
    _$AppDatabase db,
  ) => MultiTypedResultKey.fromTable(
    db.ordenes,
    aliasName: 'vehiculos__id__ordenes__vehiculo_id',
  );

  $$OrdenesTableProcessedTableManager get ordenesRefs {
    final manager = $$OrdenesTableTableManager(
      $_db,
      $_db.ordenes,
    ).filter((f) => f.vehiculoId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(_ordenesRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$VehiculosTableFilterComposer
    extends Composer<_$AppDatabase, $VehiculosTable> {
  $$VehiculosTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get matricula => $composableBuilder(
    column: $table.matricula,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get marca => $composableBuilder(
    column: $table.marca,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get modelo => $composableBuilder(
    column: $table.modelo,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get anio => $composableBuilder(
    column: $table.anio,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get ultimoKilometraje => $composableBuilder(
    column: $table.ultimoKilometraje,
    builder: (column) => ColumnFilters(column),
  );

  $$ClientesTableFilterComposer get clienteId {
    final $$ClientesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.clienteId,
      referencedTable: $db.clientes,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ClientesTableFilterComposer(
            $db: $db,
            $table: $db.clientes,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<bool> ordenesRefs(
    Expression<bool> Function($$OrdenesTableFilterComposer f) f,
  ) {
    final $$OrdenesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.ordenes,
      getReferencedColumn: (t) => t.vehiculoId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$OrdenesTableFilterComposer(
            $db: $db,
            $table: $db.ordenes,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$VehiculosTableOrderingComposer
    extends Composer<_$AppDatabase, $VehiculosTable> {
  $$VehiculosTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get matricula => $composableBuilder(
    column: $table.matricula,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get marca => $composableBuilder(
    column: $table.marca,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get modelo => $composableBuilder(
    column: $table.modelo,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get anio => $composableBuilder(
    column: $table.anio,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get ultimoKilometraje => $composableBuilder(
    column: $table.ultimoKilometraje,
    builder: (column) => ColumnOrderings(column),
  );

  $$ClientesTableOrderingComposer get clienteId {
    final $$ClientesTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.clienteId,
      referencedTable: $db.clientes,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ClientesTableOrderingComposer(
            $db: $db,
            $table: $db.clientes,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$VehiculosTableAnnotationComposer
    extends Composer<_$AppDatabase, $VehiculosTable> {
  $$VehiculosTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get matricula =>
      $composableBuilder(column: $table.matricula, builder: (column) => column);

  GeneratedColumn<String> get marca =>
      $composableBuilder(column: $table.marca, builder: (column) => column);

  GeneratedColumn<String> get modelo =>
      $composableBuilder(column: $table.modelo, builder: (column) => column);

  GeneratedColumn<int> get anio =>
      $composableBuilder(column: $table.anio, builder: (column) => column);

  GeneratedColumn<int> get ultimoKilometraje => $composableBuilder(
    column: $table.ultimoKilometraje,
    builder: (column) => column,
  );

  $$ClientesTableAnnotationComposer get clienteId {
    final $$ClientesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.clienteId,
      referencedTable: $db.clientes,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ClientesTableAnnotationComposer(
            $db: $db,
            $table: $db.clientes,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<T> ordenesRefs<T extends Object>(
    Expression<T> Function($$OrdenesTableAnnotationComposer a) f,
  ) {
    final $$OrdenesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.ordenes,
      getReferencedColumn: (t) => t.vehiculoId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$OrdenesTableAnnotationComposer(
            $db: $db,
            $table: $db.ordenes,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$VehiculosTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $VehiculosTable,
          Vehiculo,
          $$VehiculosTableFilterComposer,
          $$VehiculosTableOrderingComposer,
          $$VehiculosTableAnnotationComposer,
          $$VehiculosTableCreateCompanionBuilder,
          $$VehiculosTableUpdateCompanionBuilder,
          (Vehiculo, $$VehiculosTableReferences),
          Vehiculo,
          PrefetchHooks Function({bool clienteId, bool ordenesRefs})
        > {
  $$VehiculosTableTableManager(_$AppDatabase db, $VehiculosTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$VehiculosTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$VehiculosTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$VehiculosTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> clienteId = const Value.absent(),
                Value<String> matricula = const Value.absent(),
                Value<String> marca = const Value.absent(),
                Value<String> modelo = const Value.absent(),
                Value<int> anio = const Value.absent(),
                Value<int> ultimoKilometraje = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => VehiculosCompanion(
                id: id,
                clienteId: clienteId,
                matricula: matricula,
                marca: marca,
                modelo: modelo,
                anio: anio,
                ultimoKilometraje: ultimoKilometraje,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String clienteId,
                required String matricula,
                required String marca,
                required String modelo,
                required int anio,
                required int ultimoKilometraje,
                Value<int> rowid = const Value.absent(),
              }) => VehiculosCompanion.insert(
                id: id,
                clienteId: clienteId,
                matricula: matricula,
                marca: marca,
                modelo: modelo,
                anio: anio,
                ultimoKilometraje: ultimoKilometraje,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$VehiculosTable, Vehiculo>(table),
                  $$VehiculosTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({clienteId = false, ordenesRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [if (ordenesRefs) db.ordenes],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (clienteId) {
                      state = state.withJoin(
                        currentTable: table,
                        currentColumn: table.clienteId,
                        referencedTable: $$VehiculosTableReferences
                            ._clienteIdTable(db),
                        referencedColumn: $$VehiculosTableReferences
                            ._clienteIdTable(db)
                            .id,
                      ) as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [
                  if (ordenesRefs)
                    await $_getPrefetchedDataByColumns<
                      Vehiculo,
                      $VehiculosTable,
                      Ordene,
                      $OrdenesTable
                    >(
                      currentTable: table,
                      referencedTable: $$VehiculosTableReferences
                          ._ordenesRefsTable(db),
                      managerFromTypedResult: (p0) =>
                          $$VehiculosTableReferences(db, table, p0).ordenesRefs,
                      currentColumn: 'id',
                      referencedColumn: 'vehiculo_id',
                      typedResults: items,
                    ),
                ];
              },
            );
          },
        ),
      );
}

typedef $$VehiculosTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $VehiculosTable,
      Vehiculo,
      $$VehiculosTableFilterComposer,
      $$VehiculosTableOrderingComposer,
      $$VehiculosTableAnnotationComposer,
      $$VehiculosTableCreateCompanionBuilder,
      $$VehiculosTableUpdateCompanionBuilder,
      (Vehiculo, $$VehiculosTableReferences),
      Vehiculo,
      PrefetchHooks Function({bool clienteId, bool ordenesRefs})
    >;
typedef $$MecanicosTableCreateCompanionBuilder = MecanicosCompanion Function({
  required String id,
  required String nombre,
  required String telefono,
  Value<int> rowid,
});
typedef $$MecanicosTableUpdateCompanionBuilder = MecanicosCompanion Function({
  Value<String> id,
  Value<String> nombre,
  Value<String> telefono,
  Value<int> rowid,
});

final class $$MecanicosTableReferences
    extends BaseReferences<_$AppDatabase, $MecanicosTable, Mecanico> {
  $$MecanicosTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static MultiTypedResultKey<$OrdenesTable, List<Ordene>> _ordenesRefsTable(
    _$AppDatabase db,
  ) => MultiTypedResultKey.fromTable(
    db.ordenes,
    aliasName: 'mecanicos__id__ordenes__mecanico_id',
  );

  $$OrdenesTableProcessedTableManager get ordenesRefs {
    final manager = $$OrdenesTableTableManager(
      $_db,
      $_db.ordenes,
    ).filter((f) => f.mecanicoId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(_ordenesRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$MecanicosTableFilterComposer
    extends Composer<_$AppDatabase, $MecanicosTable> {
  $$MecanicosTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get nombre => $composableBuilder(
    column: $table.nombre,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get telefono => $composableBuilder(
    column: $table.telefono,
    builder: (column) => ColumnFilters(column),
  );

  Expression<bool> ordenesRefs(
    Expression<bool> Function($$OrdenesTableFilterComposer f) f,
  ) {
    final $$OrdenesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.ordenes,
      getReferencedColumn: (t) => t.mecanicoId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$OrdenesTableFilterComposer(
            $db: $db,
            $table: $db.ordenes,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$MecanicosTableOrderingComposer
    extends Composer<_$AppDatabase, $MecanicosTable> {
  $$MecanicosTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get nombre => $composableBuilder(
    column: $table.nombre,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get telefono => $composableBuilder(
    column: $table.telefono,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$MecanicosTableAnnotationComposer
    extends Composer<_$AppDatabase, $MecanicosTable> {
  $$MecanicosTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get nombre =>
      $composableBuilder(column: $table.nombre, builder: (column) => column);

  GeneratedColumn<String> get telefono =>
      $composableBuilder(column: $table.telefono, builder: (column) => column);

  Expression<T> ordenesRefs<T extends Object>(
    Expression<T> Function($$OrdenesTableAnnotationComposer a) f,
  ) {
    final $$OrdenesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.ordenes,
      getReferencedColumn: (t) => t.mecanicoId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$OrdenesTableAnnotationComposer(
            $db: $db,
            $table: $db.ordenes,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$MecanicosTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $MecanicosTable,
          Mecanico,
          $$MecanicosTableFilterComposer,
          $$MecanicosTableOrderingComposer,
          $$MecanicosTableAnnotationComposer,
          $$MecanicosTableCreateCompanionBuilder,
          $$MecanicosTableUpdateCompanionBuilder,
          (Mecanico, $$MecanicosTableReferences),
          Mecanico,
          PrefetchHooks Function({bool ordenesRefs})
        > {
  $$MecanicosTableTableManager(_$AppDatabase db, $MecanicosTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$MecanicosTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$MecanicosTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$MecanicosTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> nombre = const Value.absent(),
                Value<String> telefono = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => MecanicosCompanion(
                id: id,
                nombre: nombre,
                telefono: telefono,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String nombre,
                required String telefono,
                Value<int> rowid = const Value.absent(),
              }) => MecanicosCompanion.insert(
                id: id,
                nombre: nombre,
                telefono: telefono,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$MecanicosTable, Mecanico>(table),
                  $$MecanicosTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({ordenesRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [if (ordenesRefs) db.ordenes],
              addJoins: null,
              getPrefetchedDataCallback: (items) async {
                return [
                  if (ordenesRefs)
                    await $_getPrefetchedDataByColumns<
                      Mecanico,
                      $MecanicosTable,
                      Ordene,
                      $OrdenesTable
                    >(
                      currentTable: table,
                      referencedTable: $$MecanicosTableReferences
                          ._ordenesRefsTable(db),
                      managerFromTypedResult: (p0) =>
                          $$MecanicosTableReferences(db, table, p0).ordenesRefs,
                      currentColumn: 'id',
                      referencedColumn: 'mecanico_id',
                      typedResults: items,
                    ),
                ];
              },
            );
          },
        ),
      );
}

typedef $$MecanicosTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $MecanicosTable,
      Mecanico,
      $$MecanicosTableFilterComposer,
      $$MecanicosTableOrderingComposer,
      $$MecanicosTableAnnotationComposer,
      $$MecanicosTableCreateCompanionBuilder,
      $$MecanicosTableUpdateCompanionBuilder,
      (Mecanico, $$MecanicosTableReferences),
      Mecanico,
      PrefetchHooks Function({bool ordenesRefs})
    >;
typedef $$OrdenesTableCreateCompanionBuilder = OrdenesCompanion Function({
  required String id,
  required String vehiculoId,
  required String mecanicoId,
  required DateTime fechaEntrada,
  required String problemaReportado,
  Value<String> estado,
  Value<int> rowid,
});
typedef $$OrdenesTableUpdateCompanionBuilder = OrdenesCompanion Function({
  Value<String> id,
  Value<String> vehiculoId,
  Value<String> mecanicoId,
  Value<DateTime> fechaEntrada,
  Value<String> problemaReportado,
  Value<String> estado,
  Value<int> rowid,
});

final class $$OrdenesTableReferences
    extends BaseReferences<_$AppDatabase, $OrdenesTable, Ordene> {
  $$OrdenesTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $VehiculosTable _vehiculoIdTable(_$AppDatabase db) =>
      db.vehiculos.createAlias('ordenes__vehiculo_id__vehiculos__id');

  $$VehiculosTableProcessedTableManager get vehiculoId {
    final $_column = $_itemColumn<String>('vehiculo_id')!;

    final manager = $$VehiculosTableTableManager(
      $_db,
      $_db.vehiculos,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_vehiculoIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static $MecanicosTable _mecanicoIdTable(_$AppDatabase db) =>
      db.mecanicos.createAlias('ordenes__mecanico_id__mecanicos__id');

  $$MecanicosTableProcessedTableManager get mecanicoId {
    final $_column = $_itemColumn<String>('mecanico_id')!;

    final manager = $$MecanicosTableTableManager(
      $_db,
      $_db.mecanicos,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_mecanicoIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static MultiTypedResultKey<$TrabajosTable, List<Trabajo>> _trabajosRefsTable(
    _$AppDatabase db,
  ) => MultiTypedResultKey.fromTable(
    db.trabajos,
    aliasName: 'ordenes__id__trabajos__orden_id',
  );

  $$TrabajosTableProcessedTableManager get trabajosRefs {
    final manager = $$TrabajosTableTableManager(
      $_db,
      $_db.trabajos,
    ).filter((f) => f.ordenId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(_trabajosRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$RepuestosUsadosTable, List<RepuestosUsado>>
  _repuestosUsadosRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.repuestosUsados,
    aliasName: 'ordenes__id__repuestos_usados__orden_id',
  );

  $$RepuestosUsadosTableProcessedTableManager get repuestosUsadosRefs {
    final manager = $$RepuestosUsadosTableTableManager(
      $_db,
      $_db.repuestosUsados,
    ).filter((f) => f.ordenId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(
      _repuestosUsadosRefsTable($_db),
    );
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$PagosTable, List<Pago>> _pagosRefsTable(
    _$AppDatabase db,
  ) => MultiTypedResultKey.fromTable(
    db.pagos,
    aliasName: 'ordenes__id__pagos__orden_id',
  );

  $$PagosTableProcessedTableManager get pagosRefs {
    final manager = $$PagosTableTableManager(
      $_db,
      $_db.pagos,
    ).filter((f) => f.ordenId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(_pagosRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$OrdenesTableFilterComposer
    extends Composer<_$AppDatabase, $OrdenesTable> {
  $$OrdenesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get fechaEntrada => $composableBuilder(
    column: $table.fechaEntrada,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get problemaReportado => $composableBuilder(
    column: $table.problemaReportado,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get estado => $composableBuilder(
    column: $table.estado,
    builder: (column) => ColumnFilters(column),
  );

  $$VehiculosTableFilterComposer get vehiculoId {
    final $$VehiculosTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.vehiculoId,
      referencedTable: $db.vehiculos,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$VehiculosTableFilterComposer(
            $db: $db,
            $table: $db.vehiculos,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$MecanicosTableFilterComposer get mecanicoId {
    final $$MecanicosTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.mecanicoId,
      referencedTable: $db.mecanicos,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$MecanicosTableFilterComposer(
            $db: $db,
            $table: $db.mecanicos,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<bool> trabajosRefs(
    Expression<bool> Function($$TrabajosTableFilterComposer f) f,
  ) {
    final $$TrabajosTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.trabajos,
      getReferencedColumn: (t) => t.ordenId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TrabajosTableFilterComposer(
            $db: $db,
            $table: $db.trabajos,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> repuestosUsadosRefs(
    Expression<bool> Function($$RepuestosUsadosTableFilterComposer f) f,
  ) {
    final $$RepuestosUsadosTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.repuestosUsados,
      getReferencedColumn: (t) => t.ordenId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$RepuestosUsadosTableFilterComposer(
            $db: $db,
            $table: $db.repuestosUsados,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> pagosRefs(
    Expression<bool> Function($$PagosTableFilterComposer f) f,
  ) {
    final $$PagosTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.pagos,
      getReferencedColumn: (t) => t.ordenId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$PagosTableFilterComposer(
            $db: $db,
            $table: $db.pagos,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$OrdenesTableOrderingComposer
    extends Composer<_$AppDatabase, $OrdenesTable> {
  $$OrdenesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get fechaEntrada => $composableBuilder(
    column: $table.fechaEntrada,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get problemaReportado => $composableBuilder(
    column: $table.problemaReportado,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get estado => $composableBuilder(
    column: $table.estado,
    builder: (column) => ColumnOrderings(column),
  );

  $$VehiculosTableOrderingComposer get vehiculoId {
    final $$VehiculosTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.vehiculoId,
      referencedTable: $db.vehiculos,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$VehiculosTableOrderingComposer(
            $db: $db,
            $table: $db.vehiculos,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$MecanicosTableOrderingComposer get mecanicoId {
    final $$MecanicosTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.mecanicoId,
      referencedTable: $db.mecanicos,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$MecanicosTableOrderingComposer(
            $db: $db,
            $table: $db.mecanicos,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$OrdenesTableAnnotationComposer
    extends Composer<_$AppDatabase, $OrdenesTable> {
  $$OrdenesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<DateTime> get fechaEntrada => $composableBuilder(
    column: $table.fechaEntrada,
    builder: (column) => column,
  );

  GeneratedColumn<String> get problemaReportado => $composableBuilder(
    column: $table.problemaReportado,
    builder: (column) => column,
  );

  GeneratedColumn<String> get estado =>
      $composableBuilder(column: $table.estado, builder: (column) => column);

  $$VehiculosTableAnnotationComposer get vehiculoId {
    final $$VehiculosTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.vehiculoId,
      referencedTable: $db.vehiculos,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$VehiculosTableAnnotationComposer(
            $db: $db,
            $table: $db.vehiculos,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$MecanicosTableAnnotationComposer get mecanicoId {
    final $$MecanicosTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.mecanicoId,
      referencedTable: $db.mecanicos,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$MecanicosTableAnnotationComposer(
            $db: $db,
            $table: $db.mecanicos,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<T> trabajosRefs<T extends Object>(
    Expression<T> Function($$TrabajosTableAnnotationComposer a) f,
  ) {
    final $$TrabajosTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.trabajos,
      getReferencedColumn: (t) => t.ordenId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TrabajosTableAnnotationComposer(
            $db: $db,
            $table: $db.trabajos,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> repuestosUsadosRefs<T extends Object>(
    Expression<T> Function($$RepuestosUsadosTableAnnotationComposer a) f,
  ) {
    final $$RepuestosUsadosTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.repuestosUsados,
      getReferencedColumn: (t) => t.ordenId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$RepuestosUsadosTableAnnotationComposer(
            $db: $db,
            $table: $db.repuestosUsados,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> pagosRefs<T extends Object>(
    Expression<T> Function($$PagosTableAnnotationComposer a) f,
  ) {
    final $$PagosTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.pagos,
      getReferencedColumn: (t) => t.ordenId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$PagosTableAnnotationComposer(
            $db: $db,
            $table: $db.pagos,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$OrdenesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $OrdenesTable,
          Ordene,
          $$OrdenesTableFilterComposer,
          $$OrdenesTableOrderingComposer,
          $$OrdenesTableAnnotationComposer,
          $$OrdenesTableCreateCompanionBuilder,
          $$OrdenesTableUpdateCompanionBuilder,
          (Ordene, $$OrdenesTableReferences),
          Ordene,
          PrefetchHooks Function({
            bool vehiculoId,
            bool mecanicoId,
            bool trabajosRefs,
            bool repuestosUsadosRefs,
            bool pagosRefs,
          })
        > {
  $$OrdenesTableTableManager(_$AppDatabase db, $OrdenesTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$OrdenesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$OrdenesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$OrdenesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> vehiculoId = const Value.absent(),
                Value<String> mecanicoId = const Value.absent(),
                Value<DateTime> fechaEntrada = const Value.absent(),
                Value<String> problemaReportado = const Value.absent(),
                Value<String> estado = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => OrdenesCompanion(
                id: id,
                vehiculoId: vehiculoId,
                mecanicoId: mecanicoId,
                fechaEntrada: fechaEntrada,
                problemaReportado: problemaReportado,
                estado: estado,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String vehiculoId,
                required String mecanicoId,
                required DateTime fechaEntrada,
                required String problemaReportado,
                Value<String> estado = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => OrdenesCompanion.insert(
                id: id,
                vehiculoId: vehiculoId,
                mecanicoId: mecanicoId,
                fechaEntrada: fechaEntrada,
                problemaReportado: problemaReportado,
                estado: estado,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$OrdenesTable, Ordene>(table),
                  $$OrdenesTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback:
              ({
                vehiculoId = false,
                mecanicoId = false,
                trabajosRefs = false,
                repuestosUsadosRefs = false,
                pagosRefs = false,
              }) {
                return PrefetchHooks(
                  db: db,
                  explicitlyWatchedTables: [
                    if (trabajosRefs) db.trabajos,
                    if (repuestosUsadosRefs) db.repuestosUsados,
                    if (pagosRefs) db.pagos,
                  ],
                  addJoins:
                      <
                        T extends TableManagerState<
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic
                        >
                      >(state) {
                        if (vehiculoId) {
                          state = state.withJoin(
                            currentTable: table,
                            currentColumn: table.vehiculoId,
                            referencedTable: $$OrdenesTableReferences
                                ._vehiculoIdTable(db),
                            referencedColumn: $$OrdenesTableReferences
                                ._vehiculoIdTable(db)
                                .id,
                          ) as T;
                        }
                        if (mecanicoId) {
                          state = state.withJoin(
                            currentTable: table,
                            currentColumn: table.mecanicoId,
                            referencedTable: $$OrdenesTableReferences
                                ._mecanicoIdTable(db),
                            referencedColumn: $$OrdenesTableReferences
                                ._mecanicoIdTable(db)
                                .id,
                          ) as T;
                        }

                        return state;
                      },
                  getPrefetchedDataCallback: (items) async {
                    return [
                      if (trabajosRefs)
                        await $_getPrefetchedDataByColumns<
                          Ordene,
                          $OrdenesTable,
                          Trabajo,
                          $TrabajosTable
                        >(
                          currentTable: table,
                          referencedTable: $$OrdenesTableReferences
                              ._trabajosRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$OrdenesTableReferences(
                                db,
                                table,
                                p0,
                              ).trabajosRefs,
                          currentColumn: 'id',
                          referencedColumn: 'orden_id',
                          typedResults: items,
                        ),
                      if (repuestosUsadosRefs)
                        await $_getPrefetchedDataByColumns<
                          Ordene,
                          $OrdenesTable,
                          RepuestosUsado,
                          $RepuestosUsadosTable
                        >(
                          currentTable: table,
                          referencedTable: $$OrdenesTableReferences
                              ._repuestosUsadosRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$OrdenesTableReferences(
                                db,
                                table,
                                p0,
                              ).repuestosUsadosRefs,
                          currentColumn: 'id',
                          referencedColumn: 'orden_id',
                          typedResults: items,
                        ),
                      if (pagosRefs)
                        await $_getPrefetchedDataByColumns<
                          Ordene,
                          $OrdenesTable,
                          Pago,
                          $PagosTable
                        >(
                          currentTable: table,
                          referencedTable: $$OrdenesTableReferences
                              ._pagosRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$OrdenesTableReferences(db, table, p0).pagosRefs,
                          currentColumn: 'id',
                          referencedColumn: 'orden_id',
                          typedResults: items,
                        ),
                    ];
                  },
                );
              },
        ),
      );
}

typedef $$OrdenesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $OrdenesTable,
      Ordene,
      $$OrdenesTableFilterComposer,
      $$OrdenesTableOrderingComposer,
      $$OrdenesTableAnnotationComposer,
      $$OrdenesTableCreateCompanionBuilder,
      $$OrdenesTableUpdateCompanionBuilder,
      (Ordene, $$OrdenesTableReferences),
      Ordene,
      PrefetchHooks Function({
        bool vehiculoId,
        bool mecanicoId,
        bool trabajosRefs,
        bool repuestosUsadosRefs,
        bool pagosRefs,
      })
    >;
typedef $$TrabajosTableCreateCompanionBuilder = TrabajosCompanion Function({
  required String id,
  required String ordenId,
  required String descripcion,
  required double precioManoObra,
  Value<int> rowid,
});
typedef $$TrabajosTableUpdateCompanionBuilder = TrabajosCompanion Function({
  Value<String> id,
  Value<String> ordenId,
  Value<String> descripcion,
  Value<double> precioManoObra,
  Value<int> rowid,
});

final class $$TrabajosTableReferences
    extends BaseReferences<_$AppDatabase, $TrabajosTable, Trabajo> {
  $$TrabajosTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $OrdenesTable _ordenIdTable(_$AppDatabase db) =>
      db.ordenes.createAlias('trabajos__orden_id__ordenes__id');

  $$OrdenesTableProcessedTableManager get ordenId {
    final $_column = $_itemColumn<String>('orden_id')!;

    final manager = $$OrdenesTableTableManager(
      $_db,
      $_db.ordenes,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_ordenIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$TrabajosTableFilterComposer
    extends Composer<_$AppDatabase, $TrabajosTable> {
  $$TrabajosTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get descripcion => $composableBuilder(
    column: $table.descripcion,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get precioManoObra => $composableBuilder(
    column: $table.precioManoObra,
    builder: (column) => ColumnFilters(column),
  );

  $$OrdenesTableFilterComposer get ordenId {
    final $$OrdenesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.ordenId,
      referencedTable: $db.ordenes,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$OrdenesTableFilterComposer(
            $db: $db,
            $table: $db.ordenes,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$TrabajosTableOrderingComposer
    extends Composer<_$AppDatabase, $TrabajosTable> {
  $$TrabajosTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get descripcion => $composableBuilder(
    column: $table.descripcion,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get precioManoObra => $composableBuilder(
    column: $table.precioManoObra,
    builder: (column) => ColumnOrderings(column),
  );

  $$OrdenesTableOrderingComposer get ordenId {
    final $$OrdenesTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.ordenId,
      referencedTable: $db.ordenes,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$OrdenesTableOrderingComposer(
            $db: $db,
            $table: $db.ordenes,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$TrabajosTableAnnotationComposer
    extends Composer<_$AppDatabase, $TrabajosTable> {
  $$TrabajosTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get descripcion => $composableBuilder(
    column: $table.descripcion,
    builder: (column) => column,
  );

  GeneratedColumn<double> get precioManoObra => $composableBuilder(
    column: $table.precioManoObra,
    builder: (column) => column,
  );

  $$OrdenesTableAnnotationComposer get ordenId {
    final $$OrdenesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.ordenId,
      referencedTable: $db.ordenes,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$OrdenesTableAnnotationComposer(
            $db: $db,
            $table: $db.ordenes,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$TrabajosTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $TrabajosTable,
          Trabajo,
          $$TrabajosTableFilterComposer,
          $$TrabajosTableOrderingComposer,
          $$TrabajosTableAnnotationComposer,
          $$TrabajosTableCreateCompanionBuilder,
          $$TrabajosTableUpdateCompanionBuilder,
          (Trabajo, $$TrabajosTableReferences),
          Trabajo,
          PrefetchHooks Function({bool ordenId})
        > {
  $$TrabajosTableTableManager(_$AppDatabase db, $TrabajosTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$TrabajosTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$TrabajosTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$TrabajosTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> ordenId = const Value.absent(),
                Value<String> descripcion = const Value.absent(),
                Value<double> precioManoObra = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => TrabajosCompanion(
                id: id,
                ordenId: ordenId,
                descripcion: descripcion,
                precioManoObra: precioManoObra,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String ordenId,
                required String descripcion,
                required double precioManoObra,
                Value<int> rowid = const Value.absent(),
              }) => TrabajosCompanion.insert(
                id: id,
                ordenId: ordenId,
                descripcion: descripcion,
                precioManoObra: precioManoObra,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$TrabajosTable, Trabajo>(table),
                  $$TrabajosTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({ordenId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (ordenId) {
                      state = state.withJoin(
                        currentTable: table,
                        currentColumn: table.ordenId,
                        referencedTable: $$TrabajosTableReferences
                            ._ordenIdTable(db),
                        referencedColumn: $$TrabajosTableReferences
                            ._ordenIdTable(db)
                            .id,
                      ) as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$TrabajosTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $TrabajosTable,
      Trabajo,
      $$TrabajosTableFilterComposer,
      $$TrabajosTableOrderingComposer,
      $$TrabajosTableAnnotationComposer,
      $$TrabajosTableCreateCompanionBuilder,
      $$TrabajosTableUpdateCompanionBuilder,
      (Trabajo, $$TrabajosTableReferences),
      Trabajo,
      PrefetchHooks Function({bool ordenId})
    >;
typedef $$RepuestosTableCreateCompanionBuilder = RepuestosCompanion Function({
  required String id,
  required String nombre,
  required String codigo,
  required double precioVenta,
  required int existencias,
  Value<int> stockMinimo,
  Value<int> rowid,
});
typedef $$RepuestosTableUpdateCompanionBuilder = RepuestosCompanion Function({
  Value<String> id,
  Value<String> nombre,
  Value<String> codigo,
  Value<double> precioVenta,
  Value<int> existencias,
  Value<int> stockMinimo,
  Value<int> rowid,
});

final class $$RepuestosTableReferences
    extends BaseReferences<_$AppDatabase, $RepuestosTable, Repuesto> {
  $$RepuestosTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static MultiTypedResultKey<$RepuestosUsadosTable, List<RepuestosUsado>>
  _repuestosUsadosRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.repuestosUsados,
    aliasName: 'repuestos__id__repuestos_usados__repuesto_id',
  );

  $$RepuestosUsadosTableProcessedTableManager get repuestosUsadosRefs {
    final manager = $$RepuestosUsadosTableTableManager(
      $_db,
      $_db.repuestosUsados,
    ).filter((f) => f.repuestoId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(
      _repuestosUsadosRefsTable($_db),
    );
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$RepuestosTableFilterComposer
    extends Composer<_$AppDatabase, $RepuestosTable> {
  $$RepuestosTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get nombre => $composableBuilder(
    column: $table.nombre,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get codigo => $composableBuilder(
    column: $table.codigo,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get precioVenta => $composableBuilder(
    column: $table.precioVenta,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get existencias => $composableBuilder(
    column: $table.existencias,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get stockMinimo => $composableBuilder(
    column: $table.stockMinimo,
    builder: (column) => ColumnFilters(column),
  );

  Expression<bool> repuestosUsadosRefs(
    Expression<bool> Function($$RepuestosUsadosTableFilterComposer f) f,
  ) {
    final $$RepuestosUsadosTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.repuestosUsados,
      getReferencedColumn: (t) => t.repuestoId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$RepuestosUsadosTableFilterComposer(
            $db: $db,
            $table: $db.repuestosUsados,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$RepuestosTableOrderingComposer
    extends Composer<_$AppDatabase, $RepuestosTable> {
  $$RepuestosTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get nombre => $composableBuilder(
    column: $table.nombre,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get codigo => $composableBuilder(
    column: $table.codigo,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get precioVenta => $composableBuilder(
    column: $table.precioVenta,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get existencias => $composableBuilder(
    column: $table.existencias,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get stockMinimo => $composableBuilder(
    column: $table.stockMinimo,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$RepuestosTableAnnotationComposer
    extends Composer<_$AppDatabase, $RepuestosTable> {
  $$RepuestosTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get nombre =>
      $composableBuilder(column: $table.nombre, builder: (column) => column);

  GeneratedColumn<String> get codigo =>
      $composableBuilder(column: $table.codigo, builder: (column) => column);

  GeneratedColumn<double> get precioVenta => $composableBuilder(
    column: $table.precioVenta,
    builder: (column) => column,
  );

  GeneratedColumn<int> get existencias => $composableBuilder(
    column: $table.existencias,
    builder: (column) => column,
  );

  GeneratedColumn<int> get stockMinimo => $composableBuilder(
    column: $table.stockMinimo,
    builder: (column) => column,
  );

  Expression<T> repuestosUsadosRefs<T extends Object>(
    Expression<T> Function($$RepuestosUsadosTableAnnotationComposer a) f,
  ) {
    final $$RepuestosUsadosTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.repuestosUsados,
      getReferencedColumn: (t) => t.repuestoId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$RepuestosUsadosTableAnnotationComposer(
            $db: $db,
            $table: $db.repuestosUsados,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$RepuestosTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $RepuestosTable,
          Repuesto,
          $$RepuestosTableFilterComposer,
          $$RepuestosTableOrderingComposer,
          $$RepuestosTableAnnotationComposer,
          $$RepuestosTableCreateCompanionBuilder,
          $$RepuestosTableUpdateCompanionBuilder,
          (Repuesto, $$RepuestosTableReferences),
          Repuesto,
          PrefetchHooks Function({bool repuestosUsadosRefs})
        > {
  $$RepuestosTableTableManager(_$AppDatabase db, $RepuestosTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$RepuestosTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$RepuestosTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$RepuestosTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> nombre = const Value.absent(),
                Value<String> codigo = const Value.absent(),
                Value<double> precioVenta = const Value.absent(),
                Value<int> existencias = const Value.absent(),
                Value<int> stockMinimo = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => RepuestosCompanion(
                id: id,
                nombre: nombre,
                codigo: codigo,
                precioVenta: precioVenta,
                existencias: existencias,
                stockMinimo: stockMinimo,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String nombre,
                required String codigo,
                required double precioVenta,
                required int existencias,
                Value<int> stockMinimo = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => RepuestosCompanion.insert(
                id: id,
                nombre: nombre,
                codigo: codigo,
                precioVenta: precioVenta,
                existencias: existencias,
                stockMinimo: stockMinimo,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$RepuestosTable, Repuesto>(table),
                  $$RepuestosTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({repuestosUsadosRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [
                if (repuestosUsadosRefs) db.repuestosUsados,
              ],
              addJoins: null,
              getPrefetchedDataCallback: (items) async {
                return [
                  if (repuestosUsadosRefs)
                    await $_getPrefetchedDataByColumns<
                      Repuesto,
                      $RepuestosTable,
                      RepuestosUsado,
                      $RepuestosUsadosTable
                    >(
                      currentTable: table,
                      referencedTable: $$RepuestosTableReferences
                          ._repuestosUsadosRefsTable(db),
                      managerFromTypedResult: (p0) =>
                          $$RepuestosTableReferences(
                            db,
                            table,
                            p0,
                          ).repuestosUsadosRefs,
                      currentColumn: 'id',
                      referencedColumn: 'repuesto_id',
                      typedResults: items,
                    ),
                ];
              },
            );
          },
        ),
      );
}

typedef $$RepuestosTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $RepuestosTable,
      Repuesto,
      $$RepuestosTableFilterComposer,
      $$RepuestosTableOrderingComposer,
      $$RepuestosTableAnnotationComposer,
      $$RepuestosTableCreateCompanionBuilder,
      $$RepuestosTableUpdateCompanionBuilder,
      (Repuesto, $$RepuestosTableReferences),
      Repuesto,
      PrefetchHooks Function({bool repuestosUsadosRefs})
    >;
typedef $$RepuestosUsadosTableCreateCompanionBuilder =
    RepuestosUsadosCompanion Function({
      required String id,
      required String ordenId,
      required String repuestoId,
      required int cantidad,
      Value<int> rowid,
    });
typedef $$RepuestosUsadosTableUpdateCompanionBuilder =
    RepuestosUsadosCompanion Function({
      Value<String> id,
      Value<String> ordenId,
      Value<String> repuestoId,
      Value<int> cantidad,
      Value<int> rowid,
    });

final class $$RepuestosUsadosTableReferences
    extends
        BaseReferences<_$AppDatabase, $RepuestosUsadosTable, RepuestosUsado> {
  $$RepuestosUsadosTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static $OrdenesTable _ordenIdTable(_$AppDatabase db) =>
      db.ordenes.createAlias('repuestos_usados__orden_id__ordenes__id');

  $$OrdenesTableProcessedTableManager get ordenId {
    final $_column = $_itemColumn<String>('orden_id')!;

    final manager = $$OrdenesTableTableManager(
      $_db,
      $_db.ordenes,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_ordenIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static $RepuestosTable _repuestoIdTable(_$AppDatabase db) =>
      db.repuestos.createAlias('repuestos_usados__repuesto_id__repuestos__id');

  $$RepuestosTableProcessedTableManager get repuestoId {
    final $_column = $_itemColumn<String>('repuesto_id')!;

    final manager = $$RepuestosTableTableManager(
      $_db,
      $_db.repuestos,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_repuestoIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$RepuestosUsadosTableFilterComposer
    extends Composer<_$AppDatabase, $RepuestosUsadosTable> {
  $$RepuestosUsadosTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get cantidad => $composableBuilder(
    column: $table.cantidad,
    builder: (column) => ColumnFilters(column),
  );

  $$OrdenesTableFilterComposer get ordenId {
    final $$OrdenesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.ordenId,
      referencedTable: $db.ordenes,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$OrdenesTableFilterComposer(
            $db: $db,
            $table: $db.ordenes,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$RepuestosTableFilterComposer get repuestoId {
    final $$RepuestosTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.repuestoId,
      referencedTable: $db.repuestos,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$RepuestosTableFilterComposer(
            $db: $db,
            $table: $db.repuestos,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$RepuestosUsadosTableOrderingComposer
    extends Composer<_$AppDatabase, $RepuestosUsadosTable> {
  $$RepuestosUsadosTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get cantidad => $composableBuilder(
    column: $table.cantidad,
    builder: (column) => ColumnOrderings(column),
  );

  $$OrdenesTableOrderingComposer get ordenId {
    final $$OrdenesTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.ordenId,
      referencedTable: $db.ordenes,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$OrdenesTableOrderingComposer(
            $db: $db,
            $table: $db.ordenes,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$RepuestosTableOrderingComposer get repuestoId {
    final $$RepuestosTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.repuestoId,
      referencedTable: $db.repuestos,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$RepuestosTableOrderingComposer(
            $db: $db,
            $table: $db.repuestos,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$RepuestosUsadosTableAnnotationComposer
    extends Composer<_$AppDatabase, $RepuestosUsadosTable> {
  $$RepuestosUsadosTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<int> get cantidad =>
      $composableBuilder(column: $table.cantidad, builder: (column) => column);

  $$OrdenesTableAnnotationComposer get ordenId {
    final $$OrdenesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.ordenId,
      referencedTable: $db.ordenes,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$OrdenesTableAnnotationComposer(
            $db: $db,
            $table: $db.ordenes,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$RepuestosTableAnnotationComposer get repuestoId {
    final $$RepuestosTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.repuestoId,
      referencedTable: $db.repuestos,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$RepuestosTableAnnotationComposer(
            $db: $db,
            $table: $db.repuestos,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$RepuestosUsadosTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $RepuestosUsadosTable,
          RepuestosUsado,
          $$RepuestosUsadosTableFilterComposer,
          $$RepuestosUsadosTableOrderingComposer,
          $$RepuestosUsadosTableAnnotationComposer,
          $$RepuestosUsadosTableCreateCompanionBuilder,
          $$RepuestosUsadosTableUpdateCompanionBuilder,
          (RepuestosUsado, $$RepuestosUsadosTableReferences),
          RepuestosUsado,
          PrefetchHooks Function({bool ordenId, bool repuestoId})
        > {
  $$RepuestosUsadosTableTableManager(
    _$AppDatabase db,
    $RepuestosUsadosTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$RepuestosUsadosTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$RepuestosUsadosTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$RepuestosUsadosTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> ordenId = const Value.absent(),
                Value<String> repuestoId = const Value.absent(),
                Value<int> cantidad = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => RepuestosUsadosCompanion(
                id: id,
                ordenId: ordenId,
                repuestoId: repuestoId,
                cantidad: cantidad,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String ordenId,
                required String repuestoId,
                required int cantidad,
                Value<int> rowid = const Value.absent(),
              }) => RepuestosUsadosCompanion.insert(
                id: id,
                ordenId: ordenId,
                repuestoId: repuestoId,
                cantidad: cantidad,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$RepuestosUsadosTable, RepuestosUsado>(table),
                  $$RepuestosUsadosTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({ordenId = false, repuestoId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (ordenId) {
                      state = state.withJoin(
                        currentTable: table,
                        currentColumn: table.ordenId,
                        referencedTable: $$RepuestosUsadosTableReferences
                            ._ordenIdTable(db),
                        referencedColumn: $$RepuestosUsadosTableReferences
                            ._ordenIdTable(db)
                            .id,
                      ) as T;
                    }
                    if (repuestoId) {
                      state = state.withJoin(
                        currentTable: table,
                        currentColumn: table.repuestoId,
                        referencedTable: $$RepuestosUsadosTableReferences
                            ._repuestoIdTable(db),
                        referencedColumn: $$RepuestosUsadosTableReferences
                            ._repuestoIdTable(db)
                            .id,
                      ) as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$RepuestosUsadosTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $RepuestosUsadosTable,
      RepuestosUsado,
      $$RepuestosUsadosTableFilterComposer,
      $$RepuestosUsadosTableOrderingComposer,
      $$RepuestosUsadosTableAnnotationComposer,
      $$RepuestosUsadosTableCreateCompanionBuilder,
      $$RepuestosUsadosTableUpdateCompanionBuilder,
      (RepuestosUsado, $$RepuestosUsadosTableReferences),
      RepuestosUsado,
      PrefetchHooks Function({bool ordenId, bool repuestoId})
    >;
typedef $$PagosTableCreateCompanionBuilder = PagosCompanion Function({
  required String id,
  required String ordenId,
  required double cantidad,
  required DateTime fecha,
  Value<int> rowid,
});
typedef $$PagosTableUpdateCompanionBuilder = PagosCompanion Function({
  Value<String> id,
  Value<String> ordenId,
  Value<double> cantidad,
  Value<DateTime> fecha,
  Value<int> rowid,
});

final class $$PagosTableReferences
    extends BaseReferences<_$AppDatabase, $PagosTable, Pago> {
  $$PagosTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $OrdenesTable _ordenIdTable(_$AppDatabase db) =>
      db.ordenes.createAlias('pagos__orden_id__ordenes__id');

  $$OrdenesTableProcessedTableManager get ordenId {
    final $_column = $_itemColumn<String>('orden_id')!;

    final manager = $$OrdenesTableTableManager(
      $_db,
      $_db.ordenes,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_ordenIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$PagosTableFilterComposer extends Composer<_$AppDatabase, $PagosTable> {
  $$PagosTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get cantidad => $composableBuilder(
    column: $table.cantidad,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get fecha => $composableBuilder(
    column: $table.fecha,
    builder: (column) => ColumnFilters(column),
  );

  $$OrdenesTableFilterComposer get ordenId {
    final $$OrdenesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.ordenId,
      referencedTable: $db.ordenes,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$OrdenesTableFilterComposer(
            $db: $db,
            $table: $db.ordenes,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$PagosTableOrderingComposer
    extends Composer<_$AppDatabase, $PagosTable> {
  $$PagosTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get cantidad => $composableBuilder(
    column: $table.cantidad,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get fecha => $composableBuilder(
    column: $table.fecha,
    builder: (column) => ColumnOrderings(column),
  );

  $$OrdenesTableOrderingComposer get ordenId {
    final $$OrdenesTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.ordenId,
      referencedTable: $db.ordenes,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$OrdenesTableOrderingComposer(
            $db: $db,
            $table: $db.ordenes,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$PagosTableAnnotationComposer
    extends Composer<_$AppDatabase, $PagosTable> {
  $$PagosTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<double> get cantidad =>
      $composableBuilder(column: $table.cantidad, builder: (column) => column);

  GeneratedColumn<DateTime> get fecha =>
      $composableBuilder(column: $table.fecha, builder: (column) => column);

  $$OrdenesTableAnnotationComposer get ordenId {
    final $$OrdenesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.ordenId,
      referencedTable: $db.ordenes,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$OrdenesTableAnnotationComposer(
            $db: $db,
            $table: $db.ordenes,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$PagosTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $PagosTable,
          Pago,
          $$PagosTableFilterComposer,
          $$PagosTableOrderingComposer,
          $$PagosTableAnnotationComposer,
          $$PagosTableCreateCompanionBuilder,
          $$PagosTableUpdateCompanionBuilder,
          (Pago, $$PagosTableReferences),
          Pago,
          PrefetchHooks Function({bool ordenId})
        > {
  $$PagosTableTableManager(_$AppDatabase db, $PagosTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$PagosTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$PagosTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$PagosTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> ordenId = const Value.absent(),
                Value<double> cantidad = const Value.absent(),
                Value<DateTime> fecha = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => PagosCompanion(
                id: id,
                ordenId: ordenId,
                cantidad: cantidad,
                fecha: fecha,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String ordenId,
                required double cantidad,
                required DateTime fecha,
                Value<int> rowid = const Value.absent(),
              }) => PagosCompanion.insert(
                id: id,
                ordenId: ordenId,
                cantidad: cantidad,
                fecha: fecha,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$PagosTable, Pago>(table),
                  $$PagosTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({ordenId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (ordenId) {
                      state = state.withJoin(
                        currentTable: table,
                        currentColumn: table.ordenId,
                        referencedTable: $$PagosTableReferences._ordenIdTable(
                          db,
                        ),
                        referencedColumn: $$PagosTableReferences
                            ._ordenIdTable(db)
                            .id,
                      ) as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$PagosTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $PagosTable,
      Pago,
      $$PagosTableFilterComposer,
      $$PagosTableOrderingComposer,
      $$PagosTableAnnotationComposer,
      $$PagosTableCreateCompanionBuilder,
      $$PagosTableUpdateCompanionBuilder,
      (Pago, $$PagosTableReferences),
      Pago,
      PrefetchHooks Function({bool ordenId})
    >;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$ClientesTableTableManager get clientes =>
      $$ClientesTableTableManager(_db, _db.clientes);
  $$VehiculosTableTableManager get vehiculos =>
      $$VehiculosTableTableManager(_db, _db.vehiculos);
  $$MecanicosTableTableManager get mecanicos =>
      $$MecanicosTableTableManager(_db, _db.mecanicos);
  $$OrdenesTableTableManager get ordenes =>
      $$OrdenesTableTableManager(_db, _db.ordenes);
  $$TrabajosTableTableManager get trabajos =>
      $$TrabajosTableTableManager(_db, _db.trabajos);
  $$RepuestosTableTableManager get repuestos =>
      $$RepuestosTableTableManager(_db, _db.repuestos);
  $$RepuestosUsadosTableTableManager get repuestosUsados =>
      $$RepuestosUsadosTableTableManager(_db, _db.repuestosUsados);
  $$PagosTableTableManager get pagos =>
      $$PagosTableTableManager(_db, _db.pagos);
}
