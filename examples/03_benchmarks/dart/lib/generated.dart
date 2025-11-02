// ignore_for_file: camel_case_types
// ignore_for_file: non_constant_identifier_names
// ignore_for_file: constant_identifier_names

import 'dart:ffi' as ffi;
import 'package:ffi/ffi.dart';
import 'dart:typed_data';
import 'dart:io';
import 'dart:convert';

enum TransactionStatus {
  PENDING(0), // Value: 0
  CONFIRMED(1), // Value: 1
  FAILED(2), // Value: 2
  DROPPED(3); // Value: 3

  const TransactionStatus(this.value);
  final int value;
}

enum ContractType {
  TRANSFER(0), // Value: 0
  SMART_CONTRACT(1), // Value: 1
  TOKEN_MINT(2), // Value: 2
  TOKEN_BURN(3), // Value: 3
  NFT_MINT(4); // Value: 4

  const ContractType(this.value);
  final int value;
}

const int HASH256_SIZE = 32;
const int HASH256_ALIGNMENT = 8;

final class Hash256 extends ffi.Struct {
  @ffi.Array<ffi.Uint8>(32)
  external ffi.Array<ffi.Uint8> data;

  static ffi.Pointer<Hash256> allocate() {
    return calloc<Hash256>();
  }
}

const int ADDRESS_SIZE = 24;
const int ADDRESS_ALIGNMENT = 8;

final class Address extends ffi.Struct {
  @ffi.Array<ffi.Uint8>(20)
  external ffi.Array<ffi.Uint8> data;

  static ffi.Pointer<Address> allocate() {
    return calloc<Address>();
  }
}

const int SIGNATURE_SIZE = 72;
const int SIGNATURE_ALIGNMENT = 8;

final class Signature extends ffi.Struct {
  @ffi.Uint32()
  external int v;

  @ffi.Array<ffi.Uint8>(32)
  external ffi.Array<ffi.Uint8> r;

  @ffi.Array<ffi.Uint8>(32)
  external ffi.Array<ffi.Uint8> s;

  static ffi.Pointer<Signature> allocate() {
    return calloc<Signature>();
  }
}

const int TRANSACTION_SIZE = 4232;
const int TRANSACTION_ALIGNMENT = 8;

final class Transaction extends ffi.Struct {
  @ffi.Uint64()
  external int value;

  @ffi.Uint64()
  external int nonce;

  @ffi.Uint64()
  external int gas_limit;

  @ffi.Uint64()
  external int gas_price;

  @ffi.Uint64()
  external int gas_used;

  @ffi.Uint64()
  external int block_number;

  @ffi.Uint64()
  external int timestamp;

  @ffi.Uint32()
  external int status;

  @ffi.Uint32()
  external int transaction_index;

  @ffi.Array<ffi.Uint8>(32)
  external ffi.Array<ffi.Uint8> hash;

  @ffi.Array<ffi.Uint8>(20)
  external ffi.Array<ffi.Uint8> from_address;

  @ffi.Array<ffi.Uint8>(20)
  external ffi.Array<ffi.Uint8> to_address;

  @ffi.Array<ffi.Uint8>(4096)
  external ffi.Array<ffi.Uint8> data;

  static ffi.Pointer<Transaction> allocate() {
    return calloc<Transaction>();
  }
}

const int BLOCK_SIZE = 248;
const int BLOCK_ALIGNMENT = 8;

final class Block extends ffi.Struct {
  @ffi.Uint64()
  external int block_number;

  @ffi.Uint64()
  external int difficulty;

  @ffi.Uint64()
  external int total_difficulty;

  @ffi.Uint64()
  external int size;

  @ffi.Uint64()
  external int gas_limit;

  @ffi.Uint64()
  external int gas_used;

  @ffi.Uint64()
  external int timestamp;

  @ffi.Uint64()
  external int nonce;

  @ffi.Uint32()
  external int transaction_count;

  @ffi.Array<ffi.Uint8>(32)
  external ffi.Array<ffi.Uint8> hash;

  @ffi.Array<ffi.Uint8>(32)
  external ffi.Array<ffi.Uint8> previous_hash;

  @ffi.Array<ffi.Uint8>(32)
  external ffi.Array<ffi.Uint8> state_root;

  @ffi.Array<ffi.Uint8>(32)
  external ffi.Array<ffi.Uint8> transactions_root;

  @ffi.Array<ffi.Uint8>(32)
  external ffi.Array<ffi.Uint8> receipts_root;

  @ffi.Array<ffi.Uint8>(20)
  external ffi.Array<ffi.Uint8> miner_address;

  static ffi.Pointer<Block> allocate() {
    return calloc<Block>();
  }
}

const int TRANSACTIONRECEIPT_SIZE = 160;
const int TRANSACTIONRECEIPT_ALIGNMENT = 8;

final class TransactionReceipt extends ffi.Struct {
  @ffi.Uint64()
  external int block_number;

  @ffi.Uint64()
  external int gas_used;

  @ffi.Uint64()
  external int cumulative_gas_used;

  @ffi.Uint32()
  external int transaction_index;

  @ffi.Uint32()
  external int status;

  @ffi.Array<ffi.Uint8>(32)
  external ffi.Array<ffi.Uint8> transaction_hash;

  @ffi.Array<ffi.Uint8>(32)
  external ffi.Array<ffi.Uint8> block_hash;

  @ffi.Array<ffi.Uint8>(20)
  external ffi.Array<ffi.Uint8> from_address;

  @ffi.Array<ffi.Uint8>(20)
  external ffi.Array<ffi.Uint8> to_address;

  @ffi.Array<ffi.Uint8>(20)
  external ffi.Array<ffi.Uint8> contract_address;

  static ffi.Pointer<TransactionReceipt> allocate() {
    return calloc<TransactionReceipt>();
  }
}

const int SMARTCONTRACT_SIZE = 24648;
const int SMARTCONTRACT_ALIGNMENT = 8;

final class SmartContract extends ffi.Struct {
  @ffi.Uint64()
  external int balance;

  @ffi.Uint64()
  external int nonce;

  @ffi.Uint64()
  external int created_at_block;

  @ffi.Uint32()
  external int contract_type;

  @ffi.Array<ffi.Uint8>(20)
  external ffi.Array<ffi.Uint8> address;

  @ffi.Array<ffi.Uint8>(20)
  external ffi.Array<ffi.Uint8> creator;

  @ffi.Array<ffi.Uint8>(24576)
  external ffi.Array<ffi.Uint8> bytecode;

  static ffi.Pointer<SmartContract> allocate() {
    return calloc<SmartContract>();
  }
}

const int ACCOUNT_SIZE = 104;
const int ACCOUNT_ALIGNMENT = 8;

final class Account extends ffi.Struct {
  @ffi.Uint64()
  external int balance;

  @ffi.Uint64()
  external int nonce;

  @ffi.Array<ffi.Uint8>(20)
  external ffi.Array<ffi.Uint8> address;

  @ffi.Array<ffi.Uint8>(32)
  external ffi.Array<ffi.Uint8> code_hash;

  @ffi.Array<ffi.Uint8>(32)
  external ffi.Array<ffi.Uint8> storage_root;

  static ffi.Pointer<Account> allocate() {
    return calloc<Account>();
  }
}

const int MERKLEPROOF_SIZE = 32808;
const int MERKLEPROOF_ALIGNMENT = 8;

final class MerkleProof extends ffi.Struct {
  @ffi.Uint32()
  external int siblings_count;

  @ffi.Array<ffi.Uint8>(32768)
  external ffi.Array<ffi.Uint8> siblings;

  @ffi.Uint32()
  external int index;

  @ffi.Array<ffi.Uint8>(32)
  external ffi.Array<ffi.Uint8> leaf;

  List<Uint8List> get siblings_list {
    return List.generate(
      siblings_count,
      (i) => siblings[i],
      growable: false,
    );
  }

  Uint8List get_next_sibling() {
    if (siblings_count >= 32) {
      throw Exception('siblings array full');
    }
    final idx = siblings_count;
    siblings_count++;
    return siblings[idx];
  }

  static ffi.Pointer<MerkleProof> allocate() {
    return calloc<MerkleProof>();
  }
}

const int STATETRANSITION_SIZE = 152;
const int STATETRANSITION_ALIGNMENT = 8;

final class StateTransition extends ffi.Struct {
  @ffi.Uint64()
  external int balance_before;

  @ffi.Uint64()
  external int balance_after;

  @ffi.Uint64()
  external int nonce_before;

  @ffi.Uint64()
  external int nonce_after;

  @ffi.Array<ffi.Uint8>(20)
  external ffi.Array<ffi.Uint8> account_address;

  @ffi.Array<ffi.Uint8>(32)
  external ffi.Array<ffi.Uint8> storage_key;

  @ffi.Array<ffi.Uint8>(32)
  external ffi.Array<ffi.Uint8> storage_value_before;

  @ffi.Array<ffi.Uint8>(32)
  external ffi.Array<ffi.Uint8> storage_value_after;

  static ffi.Pointer<StateTransition> allocate() {
    return calloc<StateTransition>();
  }
}

const int PENDINGTRANSACTIONPOOL_SIZE = 42320024;
const int PENDINGTRANSACTIONPOOL_ALIGNMENT = 8;

final class PendingTransactionPool extends ffi.Struct {
  @ffi.Uint32()
  external int transactions_count;

  @ffi.Array<Transaction>(10000)
  external ffi.Array<Transaction> transactions;

  @ffi.Uint64()
  external int total_gas;

  @ffi.Uint32()
  external int count;

  List<Transaction> get transactions_list {
    return List.generate(
      transactions_count,
      (i) => transactions[i],
      growable: false,
    );
  }

  Transaction get_next_transaction() {
    if (transactions_count >= 10000) {
      throw Exception('transactions array full');
    }
    final idx = transactions_count;
    transactions_count++;
    return transactions[idx];
  }

  static ffi.Pointer<PendingTransactionPool> allocate() {
    return calloc<PendingTransactionPool>();
  }
}

const int BLOCKCHAINSTATE_SIZE = 64;
const int BLOCKCHAINSTATE_ALIGNMENT = 8;

final class BlockchainState extends ffi.Struct {
  @ffi.Uint64()
  external int latest_block_number;

  @ffi.Uint64()
  external int total_difficulty;

  @ffi.Uint64()
  external int chain_id;

  @ffi.Uint64()
  external int pending_transactions;

  @ffi.Array<ffi.Uint8>(32)
  external ffi.Array<ffi.Uint8> latest_block_hash;

  static ffi.Pointer<BlockchainState> allocate() {
    return calloc<BlockchainState>();
  }
}

const int CONSENSUSDATA_SIZE = 102456;
const int CONSENSUSDATA_ALIGNMENT = 8;

final class ConsensusData extends ffi.Struct {
  @ffi.Uint64()
  external int slot_number;

  @ffi.Uint64()
  external int epoch_number;

  @ffi.Uint32()
  external int validator_signatures_count;

  @ffi.Array<ffi.Uint8>(102400)
  external ffi.Array<ffi.Uint8> validator_signatures;

  @ffi.Uint32()
  external int validator_count;

  @ffi.Uint32()
  external int signature_count;

  @ffi.Array<ffi.Uint8>(20)
  external ffi.Array<ffi.Uint8> proposer_address;

  @ffi.Uint8()
  external int is_finalized;

  List<Uint8List> get validator_signatures_list {
    return List.generate(
      validator_signatures_count,
      (i) => validator_signatures[i],
      growable: false,
    );
  }

  Uint8List get_next_validator_signature() {
    if (validator_signatures_count >= 100) {
      throw Exception('validator_signatures array full');
    }
    final idx = validator_signatures_count;
    validator_signatures_count++;
    return validator_signatures[idx];
  }

  static ffi.Pointer<ConsensusData> allocate() {
    return calloc<ConsensusData>();
  }
}

const int TOKENBALANCE_SIZE = 56;
const int TOKENBALANCE_ALIGNMENT = 8;

final class TokenBalance extends ffi.Struct {
  @ffi.Uint64()
  external int balance;

  @ffi.Uint64()
  external int last_updated_block;

  @ffi.Array<ffi.Uint8>(20)
  external ffi.Array<ffi.Uint8> owner_address;

  @ffi.Array<ffi.Uint8>(20)
  external ffi.Array<ffi.Uint8> token_address;

  static ffi.Pointer<TokenBalance> allocate() {
    return calloc<TokenBalance>();
  }
}

const int NFT_SIZE = 312;
const int NFT_ALIGNMENT = 8;

final class NFT extends ffi.Struct {
  @ffi.Uint64()
  external int token_id;

  @ffi.Uint64()
  external int minted_at_block;

  @ffi.Array<ffi.Uint8>(20)
  external ffi.Array<ffi.Uint8> contract_address;

  @ffi.Array<ffi.Uint8>(20)
  external ffi.Array<ffi.Uint8> owner_address;

  @ffi.Array<ffi.Uint8>(256)
  external ffi.Array<ffi.Uint8> metadata_uri;

  String get metadata_uri_str {
    final bytes = <int>[];
    for (int i = 0; i < 256; i++) {
      if (metadata_uri[i] == 0) break;
      bytes.add(metadata_uri[i]);
    }
    return String.fromCharCodes(bytes);
  }

  set metadata_uri_str(String value) {
    final bytes = utf8.encode(value);
    final len = bytes.length < 255 ? bytes.length : 255;
    for (int i = 0; i < len; i++) {
      metadata_uri[i] = bytes[i];
    }
    if (len < 256) {
      metadata_uri[len] = 0;
    }
  }

  static ffi.Pointer<NFT> allocate() {
    return calloc<NFT>();
  }
}

const int GASESTIMATE_SIZE = 40;
const int GASESTIMATE_ALIGNMENT = 8;

final class GasEstimate extends ffi.Struct {
  @ffi.Uint64()
  external int base_fee;

  @ffi.Uint64()
  external int priority_fee;

  @ffi.Uint64()
  external int max_fee;

  @ffi.Uint64()
  external int estimated_gas;

  @ffi.Double()
  external double confidence;

  static ffi.Pointer<GasEstimate> allocate() {
    return calloc<GasEstimate>();
  }
}

const int NETWORKSTATS_SIZE = 64;
const int NETWORKSTATS_ALIGNMENT = 8;

final class NetworkStats extends ffi.Struct {
  @ffi.Uint64()
  external int tps_current;

  @ffi.Uint64()
  external int tps_average;

  @ffi.Uint64()
  external int tps_peak;

  @ffi.Uint64()
  external int block_time_ms;

  @ffi.Uint64()
  external int pending_tx_count;

  @ffi.Double()
  external double network_utilization;

  @ffi.Uint64()
  external int total_accounts;

  @ffi.Uint64()
  external int total_contracts;

  static ffi.Pointer<NetworkStats> allocate() {
    return calloc<NetworkStats>();
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

  late final hash256_size = _dylib.lookupFunction<
    ffi.Size Function(),
    int Function()
  >('hash256_size');

  late final hash256_alignment = _dylib.lookupFunction<
    ffi.Size Function(),
    int Function()
  >('hash256_alignment');

  late final address_size = _dylib.lookupFunction<
    ffi.Size Function(),
    int Function()
  >('address_size');

  late final address_alignment = _dylib.lookupFunction<
    ffi.Size Function(),
    int Function()
  >('address_alignment');

  late final signature_size = _dylib.lookupFunction<
    ffi.Size Function(),
    int Function()
  >('signature_size');

  late final signature_alignment = _dylib.lookupFunction<
    ffi.Size Function(),
    int Function()
  >('signature_alignment');

  late final transaction_size = _dylib.lookupFunction<
    ffi.Size Function(),
    int Function()
  >('transaction_size');

  late final transaction_alignment = _dylib.lookupFunction<
    ffi.Size Function(),
    int Function()
  >('transaction_alignment');

  late final block_size = _dylib.lookupFunction<
    ffi.Size Function(),
    int Function()
  >('block_size');

  late final block_alignment = _dylib.lookupFunction<
    ffi.Size Function(),
    int Function()
  >('block_alignment');

  late final transactionreceipt_size = _dylib.lookupFunction<
    ffi.Size Function(),
    int Function()
  >('transactionreceipt_size');

  late final transactionreceipt_alignment = _dylib.lookupFunction<
    ffi.Size Function(),
    int Function()
  >('transactionreceipt_alignment');

  late final smartcontract_size = _dylib.lookupFunction<
    ffi.Size Function(),
    int Function()
  >('smartcontract_size');

  late final smartcontract_alignment = _dylib.lookupFunction<
    ffi.Size Function(),
    int Function()
  >('smartcontract_alignment');

  late final account_size = _dylib.lookupFunction<
    ffi.Size Function(),
    int Function()
  >('account_size');

  late final account_alignment = _dylib.lookupFunction<
    ffi.Size Function(),
    int Function()
  >('account_alignment');

  late final merkleproof_size = _dylib.lookupFunction<
    ffi.Size Function(),
    int Function()
  >('merkleproof_size');

  late final merkleproof_alignment = _dylib.lookupFunction<
    ffi.Size Function(),
    int Function()
  >('merkleproof_alignment');

  late final statetransition_size = _dylib.lookupFunction<
    ffi.Size Function(),
    int Function()
  >('statetransition_size');

  late final statetransition_alignment = _dylib.lookupFunction<
    ffi.Size Function(),
    int Function()
  >('statetransition_alignment');

  late final pendingtransactionpool_size = _dylib.lookupFunction<
    ffi.Size Function(),
    int Function()
  >('pendingtransactionpool_size');

  late final pendingtransactionpool_alignment = _dylib.lookupFunction<
    ffi.Size Function(),
    int Function()
  >('pendingtransactionpool_alignment');

  late final blockchainstate_size = _dylib.lookupFunction<
    ffi.Size Function(),
    int Function()
  >('blockchainstate_size');

  late final blockchainstate_alignment = _dylib.lookupFunction<
    ffi.Size Function(),
    int Function()
  >('blockchainstate_alignment');

  late final consensusdata_size = _dylib.lookupFunction<
    ffi.Size Function(),
    int Function()
  >('consensusdata_size');

  late final consensusdata_alignment = _dylib.lookupFunction<
    ffi.Size Function(),
    int Function()
  >('consensusdata_alignment');

  late final tokenbalance_size = _dylib.lookupFunction<
    ffi.Size Function(),
    int Function()
  >('tokenbalance_size');

  late final tokenbalance_alignment = _dylib.lookupFunction<
    ffi.Size Function(),
    int Function()
  >('tokenbalance_alignment');

  late final nft_size = _dylib.lookupFunction<
    ffi.Size Function(),
    int Function()
  >('nft_size');

  late final nft_alignment = _dylib.lookupFunction<
    ffi.Size Function(),
    int Function()
  >('nft_alignment');

  late final gasestimate_size = _dylib.lookupFunction<
    ffi.Size Function(),
    int Function()
  >('gasestimate_size');

  late final gasestimate_alignment = _dylib.lookupFunction<
    ffi.Size Function(),
    int Function()
  >('gasestimate_alignment');

  late final networkstats_size = _dylib.lookupFunction<
    ffi.Size Function(),
    int Function()
  >('networkstats_size');

  late final networkstats_alignment = _dylib.lookupFunction<
    ffi.Size Function(),
    int Function()
  >('networkstats_alignment');
}
