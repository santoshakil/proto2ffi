// ignore_for_file: camel_case_types
// ignore_for_file: non_constant_identifier_names
// ignore_for_file: constant_identifier_names

import 'dart:ffi' as ffi;
import 'package:ffi/ffi.dart';
import 'dart:typed_data';
import 'dart:io';
import 'dart:convert';

enum OrderSide {
  BUY(0), // Value: 0
  SELL(1); // Value: 1

  const OrderSide(this.value);
  final int value;
}

enum OrderType {
  MARKET(0), // Value: 0
  LIMIT(1), // Value: 1
  STOP(2), // Value: 2
  STOP_LIMIT(3); // Value: 3

  const OrderType(this.value);
  final int value;
}

enum OrderStatus {
  PENDING(0), // Value: 0
  OPEN(1), // Value: 1
  PARTIALLY_FILLED(2), // Value: 2
  FILLED(3), // Value: 3
  CANCELLED(4), // Value: 4
  REJECTED(5); // Value: 5

  const OrderStatus(this.value);
  final int value;
}

const int PRICE_SIZE = 16;
const int PRICE_ALIGNMENT = 8;

final class Price extends ffi.Struct {
  @ffi.Int64()
  external int value;

  @ffi.Uint32()
  external int scale;

  static ffi.Pointer<Price> allocate() {
    return calloc<Price>();
  }
}

const int ORDER_SIZE = 88;
const int ORDER_ALIGNMENT = 8;

final class Order extends ffi.Struct {
  @ffi.Uint64()
  external int order_id;

  @ffi.Uint64()
  external int timestamp_ns;

  external Price price;

  @ffi.Uint64()
  external int quantity;

  @ffi.Uint64()
  external int filled_quantity;

  @ffi.Uint64()
  external int remaining_quantity;

  @ffi.Uint32()
  external int side;

  @ffi.Uint32()
  external int order_type;

  @ffi.Uint32()
  external int status;

  @ffi.Array<ffi.Uint8>(16)
  external ffi.Array<ffi.Uint8> symbol;

  String get symbol_str {
    final bytes = <int>[];
    for (int i = 0; i < 16; i++) {
      if (symbol[i] == 0) break;
      bytes.add(symbol[i]);
    }
    return String.fromCharCodes(bytes);
  }

  set symbol_str(String value) {
    final bytes = utf8.encode(value);
    final len = bytes.length < 15 ? bytes.length : 15;
    for (int i = 0; i < len; i++) {
      symbol[i] = bytes[i];
    }
    if (len < 16) {
      symbol[len] = 0;
    }
  }

  static ffi.Pointer<Order> allocate() {
    return calloc<Order>();
  }
}

const int TRADE_SIZE = 56;
const int TRADE_ALIGNMENT = 8;

final class Trade extends ffi.Struct {
  @ffi.Uint64()
  external int trade_id;

  @ffi.Uint64()
  external int timestamp_ns;

  @ffi.Uint64()
  external int buy_order_id;

  @ffi.Uint64()
  external int sell_order_id;

  external Price price;

  @ffi.Uint64()
  external int quantity;

  static ffi.Pointer<Trade> allocate() {
    return calloc<Trade>();
  }
}

const int ORDERBOOK_SIZE = 4864;
const int ORDERBOOK_ALIGNMENT = 8;

final class OrderBook extends ffi.Struct {
  @ffi.Uint32()
  external int bid_prices_count;

  @ffi.Array<Price>(100)
  external ffi.Array<Price> bid_prices;

  @ffi.Uint32()
  external int bid_quantities_count;

  @ffi.Array<ffi.Uint64>(100)
  external ffi.Array<ffi.Uint64> bid_quantities;

  @ffi.Uint32()
  external int ask_prices_count;

  @ffi.Array<Price>(100)
  external ffi.Array<Price> ask_prices;

  @ffi.Uint32()
  external int ask_quantities_count;

  @ffi.Array<ffi.Uint64>(100)
  external ffi.Array<ffi.Uint64> ask_quantities;

  @ffi.Uint64()
  external int sequence_number;

  @ffi.Uint32()
  external int bid_count;

  @ffi.Uint32()
  external int ask_count;

  @ffi.Array<ffi.Uint8>(16)
  external ffi.Array<ffi.Uint8> symbol;

  List<Price> get bid_prices_list {
    return List.generate(
      bid_prices_count,
      (i) => bid_prices[i],
      growable: false,
    );
  }

  Price get_next_bid_price() {
    if (bid_prices_count >= 100) {
      throw Exception('bid_prices array full');
    }
    final idx = bid_prices_count;
    bid_prices_count++;
    return bid_prices[idx];
  }

  List<int> get bid_quantities_list {
    return List.generate(
      bid_quantities_count,
      (i) => bid_quantities[i],
      growable: false,
    );
  }

  void add_bid_quantitie(int item) {
    if (bid_quantities_count >= 100) {
      throw Exception('bid_quantities array full');
    }
    bid_quantities[bid_quantities_count] = item;
    bid_quantities_count++;
  }

  List<Price> get ask_prices_list {
    return List.generate(
      ask_prices_count,
      (i) => ask_prices[i],
      growable: false,
    );
  }

  Price get_next_ask_price() {
    if (ask_prices_count >= 100) {
      throw Exception('ask_prices array full');
    }
    final idx = ask_prices_count;
    ask_prices_count++;
    return ask_prices[idx];
  }

  List<int> get ask_quantities_list {
    return List.generate(
      ask_quantities_count,
      (i) => ask_quantities[i],
      growable: false,
    );
  }

  void add_ask_quantitie(int item) {
    if (ask_quantities_count >= 100) {
      throw Exception('ask_quantities array full');
    }
    ask_quantities[ask_quantities_count] = item;
    ask_quantities_count++;
  }

  String get symbol_str {
    final bytes = <int>[];
    for (int i = 0; i < 16; i++) {
      if (symbol[i] == 0) break;
      bytes.add(symbol[i]);
    }
    return String.fromCharCodes(bytes);
  }

  set symbol_str(String value) {
    final bytes = utf8.encode(value);
    final len = bytes.length < 15 ? bytes.length : 15;
    for (int i = 0; i < len; i++) {
      symbol[i] = bytes[i];
    }
    if (len < 16) {
      symbol[len] = 0;
    }
  }

  static ffi.Pointer<OrderBook> allocate() {
    return calloc<OrderBook>();
  }
}

const int MARKETDATA_SIZE = 128;
const int MARKETDATA_ALIGNMENT = 8;

final class MarketData extends ffi.Struct {
  @ffi.Uint64()
  external int timestamp_ns;

  external Price last_price;

  external Price bid_price;

  external Price ask_price;

  @ffi.Uint64()
  external int volume;

  external Price open;

  external Price high;

  external Price low;

  @ffi.Array<ffi.Uint8>(16)
  external ffi.Array<ffi.Uint8> symbol;

  String get symbol_str {
    final bytes = <int>[];
    for (int i = 0; i < 16; i++) {
      if (symbol[i] == 0) break;
      bytes.add(symbol[i]);
    }
    return String.fromCharCodes(bytes);
  }

  set symbol_str(String value) {
    final bytes = utf8.encode(value);
    final len = bytes.length < 15 ? bytes.length : 15;
    for (int i = 0; i < len; i++) {
      symbol[i] = bytes[i];
    }
    if (len < 16) {
      symbol[len] = 0;
    }
  }

  static ffi.Pointer<MarketData> allocate() {
    return calloc<MarketData>();
  }
}

const int RISKLIMITS_SIZE = 40;
const int RISKLIMITS_ALIGNMENT = 8;

final class RiskLimits extends ffi.Struct {
  @ffi.Uint64()
  external int max_position_size;

  @ffi.Uint64()
  external int max_order_value;

  external Price max_price_deviation;

  @ffi.Uint32()
  external int max_orders_per_second;

  static ffi.Pointer<RiskLimits> allocate() {
    return calloc<RiskLimits>();
  }
}

const int POSITION_SIZE = 72;
const int POSITION_ALIGNMENT = 8;

final class Position extends ffi.Struct {
  @ffi.Int64()
  external int quantity;

  external Price average_price;

  external Price unrealized_pnl;

  external Price realized_pnl;

  @ffi.Array<ffi.Uint8>(16)
  external ffi.Array<ffi.Uint8> symbol;

  String get symbol_str {
    final bytes = <int>[];
    for (int i = 0; i < 16; i++) {
      if (symbol[i] == 0) break;
      bytes.add(symbol[i]);
    }
    return String.fromCharCodes(bytes);
  }

  set symbol_str(String value) {
    final bytes = utf8.encode(value);
    final len = bytes.length < 15 ? bytes.length : 15;
    for (int i = 0; i < len; i++) {
      symbol[i] = bytes[i];
    }
    if (len < 16) {
      symbol[len] = 0;
    }
  }

  static ffi.Pointer<Position> allocate() {
    return calloc<Position>();
  }
}

const int TRADINGSTATS_SIZE = 40;
const int TRADINGSTATS_ALIGNMENT = 8;

final class TradingStats extends ffi.Struct {
  @ffi.Uint64()
  external int total_orders;

  @ffi.Uint64()
  external int total_trades;

  @ffi.Uint64()
  external int total_volume;

  @ffi.Uint64()
  external int average_latency_ns;

  @ffi.Uint32()
  external int orders_per_second;

  @ffi.Uint32()
  external int trades_per_second;

  static ffi.Pointer<TradingStats> allocate() {
    return calloc<TradingStats>();
  }
}

class FFIBindings {
  static final _dylib = _loadLibrary();

  static ffi.DynamicLibrary _loadLibrary() {
    if (Platform.isAndroid) {
      return ffi.DynamicLibrary.open('libgenerated.so');
    } else if (Platform.isIOS) {
      return ffi.DynamicLibrary.process();
    } else if (Platform.isMacOS) {
      return ffi.DynamicLibrary.open('libgenerated.dylib');
    } else if (Platform.isWindows) {
      return ffi.DynamicLibrary.open('generated.dll');
    } else {
      return ffi.DynamicLibrary.open('libgenerated.so');
    }
  }

  late final price_size = _dylib.lookupFunction<
    ffi.Size Function(),
    int Function()
  >('price_size');

  late final price_alignment = _dylib.lookupFunction<
    ffi.Size Function(),
    int Function()
  >('price_alignment');

  late final order_size = _dylib.lookupFunction<
    ffi.Size Function(),
    int Function()
  >('order_size');

  late final order_alignment = _dylib.lookupFunction<
    ffi.Size Function(),
    int Function()
  >('order_alignment');

  late final trade_size = _dylib.lookupFunction<
    ffi.Size Function(),
    int Function()
  >('trade_size');

  late final trade_alignment = _dylib.lookupFunction<
    ffi.Size Function(),
    int Function()
  >('trade_alignment');

  late final orderbook_size = _dylib.lookupFunction<
    ffi.Size Function(),
    int Function()
  >('orderbook_size');

  late final orderbook_alignment = _dylib.lookupFunction<
    ffi.Size Function(),
    int Function()
  >('orderbook_alignment');

  late final marketdata_size = _dylib.lookupFunction<
    ffi.Size Function(),
    int Function()
  >('marketdata_size');

  late final marketdata_alignment = _dylib.lookupFunction<
    ffi.Size Function(),
    int Function()
  >('marketdata_alignment');

  late final risklimits_size = _dylib.lookupFunction<
    ffi.Size Function(),
    int Function()
  >('risklimits_size');

  late final risklimits_alignment = _dylib.lookupFunction<
    ffi.Size Function(),
    int Function()
  >('risklimits_alignment');

  late final position_size = _dylib.lookupFunction<
    ffi.Size Function(),
    int Function()
  >('position_size');

  late final position_alignment = _dylib.lookupFunction<
    ffi.Size Function(),
    int Function()
  >('position_alignment');

  late final tradingstats_size = _dylib.lookupFunction<
    ffi.Size Function(),
    int Function()
  >('tradingstats_size');

  late final tradingstats_alignment = _dylib.lookupFunction<
    ffi.Size Function(),
    int Function()
  >('tradingstats_alignment');
}
