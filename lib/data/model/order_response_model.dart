import 'package:ordena_ya/domain/entity/order_response.dart';

class OrderResponseModel {
  final String id;
  final int mesa;
  final int cantidadPersonas;
  final String tipoPedido;
  final List<ProductoSolicitadoModel> productosSolicitados;
  final int cantidadIps;
  final double total;
  final DateTime fechaCreacion;
  final String estadoGeneral;

  OrderResponseModel({
    required this.id,
    required this.mesa,
    required this.cantidadPersonas,
    required this.tipoPedido,
    required this.productosSolicitados,
    required this.cantidadIps,
    required this.total,
    required this.fechaCreacion,
    required this.estadoGeneral,
  });

  factory OrderResponseModel.fromJson(Map<String, dynamic> json) {
    return OrderResponseModel(
      id: json['_id'] ?? '',
      mesa: json['mesa'] ?? 0,
      cantidadPersonas: json['cantidadPersonas'] ?? 0,
      tipoPedido: json['tipoPedido'] ?? '',
      productosSolicitados: (json['productosSolicitados'] as List<dynamic>?)
              ?.map((item) => ProductoSolicitadoModel.fromJson(item))
              .toList() ??
          [],
      cantidadIps: json['cantidadIps'] ?? 0,
      total: (json['total'] ?? 0).toDouble(),
      fechaCreacion: DateTime.tryParse(json['fechaCreacion'] ?? '') ?? DateTime.now(),
      estadoGeneral: json['estadoGeneral'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'mesa': mesa,
      'cantidadPersonas': cantidadPersonas,
      'tipoPedido': tipoPedido,
      'productosSolicitados': productosSolicitados.map((item) => item.toJson()).toList(),
      'cantidadIps': cantidadIps,
      'total': total,
      'fechaCreacion': fechaCreacion.toIso8601String(),
      'estadoGeneral': estadoGeneral,
    };
  }

  OrderResponseEntity toEntity() {
    return OrderResponseEntity(
      id: id,
      mesa: mesa,
      cantidadPersonas: cantidadPersonas,
      tipoPedido: tipoPedido,
      productosSolicitados: productosSolicitados.map((item) => item.toEntity()).toList(),
      cantidadIps: cantidadIps,
      total: total,
      fechaCreacion: fechaCreacion,
      estadoGeneral: estadoGeneral,
    );
  }
}

class ProductoSolicitadoModel {
  final String nombreProducto;
  final int cantidadSolicitada;
  final String mensaje;
  final List<EstadoPorCantidadModel> estadosPorCantidad;

  ProductoSolicitadoModel({
    required this.nombreProducto,
    required this.cantidadSolicitada,
    required this.mensaje,
    required this.estadosPorCantidad,
  });

  factory ProductoSolicitadoModel.fromJson(Map<String, dynamic> json) {
    return ProductoSolicitadoModel(
      nombreProducto: json['nombreProducto'] ?? '',
      cantidadSolicitada: json['cantidadSolicitada'] ?? 0,
      mensaje: json['mensaje'] ?? '',
      estadosPorCantidad: (json['estadosPorCantidad'] as List<dynamic>?)
              ?.map((item) => EstadoPorCantidadModel.fromJson(item))
              .toList() ??
          [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'nombreProducto': nombreProducto,
      'cantidadSolicitada': cantidadSolicitada,
      'mensaje': mensaje,
      'estadosPorCantidad': estadosPorCantidad.map((item) => item.toJson()).toList(),
    };
  }

  ProductoSolicitadoEntity toEntity() {
    return ProductoSolicitadoEntity(
      nombreProducto: nombreProducto,
      cantidadSolicitada: cantidadSolicitada,
      mensaje: mensaje,
      estadosPorCantidad: estadosPorCantidad.map((item) => item.toEntity()).toList(),
    );
  }
}

class EstadoPorCantidadModel {
  final String estado;

  EstadoPorCantidadModel({
    required this.estado,
  });

  factory EstadoPorCantidadModel.fromJson(Map<String, dynamic> json) {
    return EstadoPorCantidadModel(
      estado: json['estado'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'estado': estado,
    };
  }

  EstadoPorCantidadEntity toEntity() {
    return EstadoPorCantidadEntity(
      estado: estado,
    );
  }
}