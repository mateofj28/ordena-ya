class OrderResponseEntity {
  final String id;
  final int mesa;
  final int cantidadPersonas;
  final String tipoPedido;
  final List<ProductoSolicitadoEntity> productosSolicitados;
  final int cantidadIps;
  final double total;
  final DateTime fechaCreacion;
  final String estadoGeneral;

  OrderResponseEntity({
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

  String get tipoDisplay {
    switch (tipoPedido.toLowerCase()) {
      case 'mesa':
        return 'En el lugar';
      case 'domicilio':
        return 'Domicilio';
      case 'recoger':
        return 'Para recoger';
      default:
        return tipoPedido;
    }
  }

  String get estadoDisplay {
    switch (estadoGeneral.toLowerCase()) {
      case 'recibida':
        return 'Recibida';
      case 'cocinando':
        return 'En cocina';
      case 'lista':
        return 'Lista';
      case 'entregada':
        return 'Entregada';
      case 'cancelada':
        return 'Cancelada';
      default:
        return estadoGeneral;
    }
  }

  int get totalProductos {
    return productosSolicitados.fold(0, (sum, producto) => sum + producto.cantidadSolicitada);
  }
}

class ProductoSolicitadoEntity {
  final String productId;
  final String nombreProducto;
  final double price;
  final int cantidadSolicitada;
  final String mensaje;
  final List<EstadoPorCantidadEntity> estadosPorCantidad;

  ProductoSolicitadoEntity({
    required this.productId,
    required this.nombreProducto,
    required this.price,
    required this.cantidadSolicitada,
    required this.mensaje,
    required this.estadosPorCantidad,
  });

  String get estadoPrincipal {
    if (estadosPorCantidad.isEmpty) return 'Sin estado';
    
    // Contar estados
    final estados = <String, int>{};
    for (final estado in estadosPorCantidad) {
      estados[estado.estado] = (estados[estado.estado] ?? 0) + 1;
    }

    // Determinar estado principal basado en los nuevos estados
    if (estados.containsKey('entregado') && estados['entregado'] == cantidadSolicitada) {
      return 'entregado';
    } else if (estados.containsKey('listo para entregar')) {
      return 'listo para entregar';
    } else if (estados.containsKey('en preparación')) {
      return 'en preparación';
    } else if (estados.containsKey('pendiente')) {
      return 'pendiente';
    }
    
    return 'Sin estado';
  }
}

class EstadoPorCantidadEntity {
  final String estado;

  EstadoPorCantidadEntity({
    required this.estado,
  });
}