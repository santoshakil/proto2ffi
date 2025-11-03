import 'dart:io';
import 'dart:typed_data';
import 'package:fixnum/fixnum.dart';
import 'package:proto_benchmark/generated/benchmark.pb.dart';

void main() {
  print('=== Protocol Buffers Encode/Decode Benchmark ===\n');
  print('Testing raw protobuf performance in Dart');
  print('Generated code size: 238KB\n');

  // Warm up JIT
  print('Warming up JIT compiler...');
  for (var i = 0; i < 100; i++) {
    final user = createTestUser(1);
    user.writeToBuffer();
  }
  print('✅ JIT warmup complete\n');

  // Run benchmarks
  benchmarkSingleUser();
  benchmarkMultipleUsers();
  benchmarkComplexPost();
  benchmarkProduct();
  benchmarkOrder();
  benchmarkAggregateData();

  print('\n🎉 All benchmarks completed!');
}

void benchmarkSingleUser() {
  print('━━━ Benchmark: Single User Message ━━━');
  final user = createTestUser(1);
  print('User fields: ~40 fields with nested messages');
  print('Approximate size: ${user.writeToBuffer().length} bytes\n');

  runBenchmark('Single User', user, iterations: 10000);
}

void benchmarkMultipleUsers() {
  print('\n━━━ Benchmark: 100 Users ━━━');
  final users = List.generate(100, (i) => createTestUser(i + 1));
  final data = BenchmarkData()
    ..users.addAll(users);

  print('Total users: 100');
  print('Approximate size: ${data.writeToBuffer().length} bytes\n');

  runBenchmark('100 Users', data, iterations: 1000);
}

void benchmarkComplexPost() {
  print('\n━━━ Benchmark: Complex Post with Media ━━━');
  final post = createTestPost(1, 1);
  print('Post with: comments, reactions, media, polls');
  print('Approximate size: ${post.writeToBuffer().length} bytes\n');

  runBenchmark('Complex Post', post, iterations: 5000);
}

void benchmarkProduct() {
  print('\n━━━ Benchmark: Product with Reviews ━━━');
  final product = createTestProduct(1);
  print('Product with: variants, reviews, images, stats');
  print('Approximate size: ${product.writeToBuffer().length} bytes\n');

  runBenchmark('Product', product, iterations: 5000);
}

void benchmarkOrder() {
  print('\n━━━ Benchmark: Order with Multiple Items ━━━');
  final order = createTestOrder(1, 1);
  print('Order with: 10 items, addresses, payment info');
  print('Approximate size: ${order.writeToBuffer().length} bytes\n');

  runBenchmark('Order', order, iterations: 5000);
}

void benchmarkAggregateData() {
  print('\n━━━ Benchmark: Large Aggregate Dataset ━━━');
  final data = BenchmarkData()
    ..users.addAll(List.generate(50, (i) => createTestUser(i + 1)))
    ..posts.addAll(List.generate(200, (i) => createTestPost(i + 1, (i % 50) + 1)))
    ..products.addAll(List.generate(100, (i) => createTestProduct(i + 1)))
    ..orders.addAll(List.generate(75, (i) => createTestOrder(i + 1, (i % 50) + 1)))
    ..timestamp = Int64(DateTime.now().millisecondsSinceEpoch)
    ..version = '1.0.0';

  // Add some config
  data.config['environment'] = 'benchmark';
  data.config['platform'] = Platform.operatingSystem;

  final size = data.writeToBuffer().length;
  print('Total messages: 425 (50 users, 200 posts, 100 products, 75 orders)');
  print('Total size: ${(size / 1024).toStringAsFixed(2)} KB ($size bytes)\n');

  runBenchmark('Large Dataset', data, iterations: 100);
}

void runBenchmark(String name, dynamic message, {required int iterations}) {
  // Encode benchmark
  final encodeStopwatch = Stopwatch()..start();
  Uint8List? lastEncoded;
  for (var i = 0; i < iterations; i++) {
    lastEncoded = message.writeToBuffer();
  }
  encodeStopwatch.stop();

  final encodeTotal = encodeStopwatch.elapsedMicroseconds;
  final encodeAvg = encodeTotal / iterations;
  final encodePerSec = (1000000 / encodeAvg).round();

  print('📤 ENCODE:');
  print('   Total time:    ${encodeTotal / 1000} ms');
  print('   Iterations:    $iterations');
  print('   Avg per op:    ${encodeAvg.toStringAsFixed(2)} μs');
  print('   Throughput:    $encodePerSec ops/sec');

  // Decode benchmark
  if (lastEncoded == null) {
    print('❌ Encode failed, skipping decode benchmark');
    return;
  }

  final bytes = lastEncoded;
  final decodeStopwatch = Stopwatch()..start();
  dynamic decoded;
  for (var i = 0; i < iterations; i++) {
    if (message is User) {
      decoded = User.fromBuffer(bytes);
    } else if (message is Post) {
      decoded = Post.fromBuffer(bytes);
    } else if (message is Product) {
      decoded = Product.fromBuffer(bytes);
    } else if (message is Order) {
      decoded = Order.fromBuffer(bytes);
    } else if (message is BenchmarkData) {
      decoded = BenchmarkData.fromBuffer(bytes);
    }
  }
  decodeStopwatch.stop();

  final decodeTotal = decodeStopwatch.elapsedMicroseconds;
  final decodeAvg = decodeTotal / iterations;
  final decodePerSec = (1000000 / decodeAvg).round();

  print('📥 DECODE:');
  print('   Total time:    ${decodeTotal / 1000} ms');
  print('   Iterations:    $iterations');
  print('   Avg per op:    ${decodeAvg.toStringAsFixed(2)} μs');
  print('   Throughput:    $decodePerSec ops/sec');

  // Round-trip
  final roundTripAvg = encodeAvg + decodeAvg;
  final roundTripPerSec = (1000000 / roundTripAvg).round();

  print('🔄 ROUND-TRIP:');
  print('   Avg per op:    ${roundTripAvg.toStringAsFixed(2)} μs');
  print('   Throughput:    $roundTripPerSec ops/sec');

  // Verify decoded message
  if (decoded != null && message is User && decoded is User) {
    print('✅ Verification: userId=${decoded.userId}, username=${decoded.username}');
  } else if (decoded != null && message is BenchmarkData && decoded is BenchmarkData) {
    print('✅ Verification: users=${decoded.users.length}, posts=${decoded.posts.length}, products=${decoded.products.length}');
  }
}

// Helper functions to create test data

User createTestUser(int id) {
  final now = Int64(DateTime.now().millisecondsSinceEpoch);

  return User()
    ..userId = Int64(id)
    ..username = 'user$id'
    ..email = 'user$id@example.com'
    ..firstName = 'First$id'
    ..lastName = 'Last$id'
    ..displayName = 'User $id'
    ..bio = 'This is a comprehensive bio for user $id. It contains multiple sentences describing the user. '
        'The user has interests in technology, coding, and protobuf benchmarking. They joined the platform '
        'recently and are very active in the community.'
    ..avatarUrl = 'https://example.com/avatars/user$id.jpg'
    ..coverPhotoUrl = 'https://example.com/covers/user$id.jpg'
    ..phoneNumber = '+1-555-${id.toString().padLeft(4, '0')}'
    ..dateOfBirth = Int64(DateTime(1990 + (id % 30), 1, 1).millisecondsSinceEpoch)
    ..gender = Gender.values[(id % 3) + 1]
    ..primaryAddress = (Address()
      ..streetLine1 = '$id Main Street'
      ..streetLine2 = 'Apt ${id % 100}'
      ..city = 'San Francisco'
      ..state = 'CA'
      ..postalCode = '94102'
      ..country = 'USA'
      ..type = AddressType.HOME
      ..isDefault = true
      ..latitude = 37.7749
      ..longitude = -122.4194)
    ..settings = (UserSettings()
      ..notifications = (NotificationSettings()
        ..pushEnabled = true
        ..emailEnabled = true
        ..smsEnabled = false
        ..likesNotifications = true
        ..commentsNotifications = true
        ..mentionsNotifications = true)
      ..privacy = (PrivacySettings()
        ..profileVisibility = ProfileVisibility.PUBLIC
        ..showEmail = false
        ..showPhone = false
        ..allowTags = true
        ..searchable = true)
      ..display = (DisplaySettings()
        ..theme = 'dark'
        ..fontSize = 'medium'
        ..compactMode = false))
    ..stats = (UserStats()
      ..totalPosts = Int64(id * 10)
      ..totalComments = Int64(id * 50)
      ..totalLikes = Int64(id * 100)
      ..followerCount = Int64(id * 5)
      ..followingCount = Int64(id * 3)
      ..engagementScore = id % 100)
    ..isVerified = id % 10 == 0
    ..isPremium = id % 5 == 0
    ..status = AccountStatus.ACTIVE
    ..createdAt = now - Int64(id * 86400000)
    ..updatedAt = now
    ..lastLogin = now
    ..timezone = 'America/Los_Angeles'
    ..language = 'en'
    ..countryCode = 'US'
    ..accountBalance = id * 10.50
    ..reputationScore = id * 10
    ..referralCode = 'REF${id.toString().padLeft(6, '0')}';
}

Post createTestPost(int id, int userId) {
  final now = Int64(DateTime.now().millisecondsSinceEpoch);

  final post = Post()
    ..postId = Int64(id)
    ..userId = Int64(userId)
    ..username = 'user$userId'
    ..userAvatarUrl = 'https://example.com/avatars/user$userId.jpg'
    ..type = PostType.values[(id % 6) + 1]
    ..title = 'This is an interesting post title #$id'
    ..content = 'This is the content of post $id. It contains multiple paragraphs of text. '
        'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Sed do eiusmod tempor incididunt '
        'ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco '
        'laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in '
        'voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat '
        'non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.'
    ..hashtags.addAll(['technology', 'coding', 'benchmark', 'protobuf'])
    ..createdAt = now - Int64(id * 3600000)
    ..updatedAt = now
    ..stats = (PostStats()
      ..viewCount = Int64(id * 100)
      ..likeCount = Int64(id * 10)
      ..commentCount = Int64(id * 5)
      ..shareCount = Int64(id * 2)
      ..engagementRate = (id % 100) / 100.0)
    ..settings = (PostSettings()
      ..visibility = PostVisibility.POST_PUBLIC
      ..allowComments = true
      ..allowShares = true
      ..showStats = true)
    ..isEdited = false
    ..isPinned = false
    ..isSponsored = id % 20 == 0
    ..language = 'en';

  // Add media
  for (var i = 0; i < (id % 3) + 1; i++) {
    post.media.add(MediaAttachment()
      ..mediaId = 'media${id}_$i'
      ..type = MediaType.IMAGE_MEDIA
      ..url = 'https://example.com/media/post$id-$i.jpg'
      ..thumbnailUrl = 'https://example.com/media/post$id-${i}_thumb.jpg'
      ..sizeBytes = Int64(1024 * 512 * (i + 1))
      ..width = 1920
      ..height = 1080
      ..mimeType = 'image/jpeg');
  }

  // Add comments
  for (var i = 0; i < (id % 5); i++) {
    post.comments.add(Comment()
      ..commentId = Int64(id * 1000 + i)
      ..postId = Int64(id)
      ..userId = Int64(userId + i)
      ..username = 'user${userId + i}'
      ..content = 'This is comment $i on post $id. Great post!'
      ..createdAt = now - Int64(i * 60000)
      ..stats = (CommentStats()
        ..likeCount = Int64(i * 2)
        ..replyCount = Int64(i)));
  }

  return post;
}

Product createTestProduct(int id) {
  final now = Int64(DateTime.now().millisecondsSinceEpoch);

  final product = Product()
    ..productId = Int64(id)
    ..sku = 'SKU-${id.toString().padLeft(6, '0')}'
    ..name = 'Premium Product $id'
    ..description = 'This is a detailed description of product $id. It includes all the features and benefits. '
        'Made with high-quality materials and crafted with precision. Perfect for everyday use. '
        'Available in multiple colors and sizes. Free shipping on orders over \$50.'
    ..shortDescription = 'High-quality product $id'
    ..categoryIds.addAll(['cat1', 'cat2', 'cat${id % 10}'])
    ..brand = 'Brand ${id % 20}'
    ..price = 99.99 + (id % 100)
    ..compareAtPrice = 149.99 + (id % 100)
    ..cost = 50.00 + (id % 50)
    ..currency = 'USD'
    ..inventory = (ProductInventory()
      ..stockQuantity = 100 + (id % 500)
      ..availableQuantity = 100 + (id % 500)
      ..trackInventory = true
      ..allowBackorder = false
      ..lowStockThreshold = 10)
    ..stats = (ProductStats()
      ..viewCount = Int64(id * 500)
      ..cartAddCount = Int64(id * 50)
      ..purchaseCount = Int64(id * 10)
      ..wishlistCount = Int64(id * 25)
      ..averageRating = 4.0 + ((id % 10) / 10.0)
      ..reviewCount = Int64(id * 5))
    ..createdAt = now - Int64(id * 86400000)
    ..updatedAt = now
    ..status = ProductStatus.PRODUCT_ACTIVE
    ..isFeatured = id % 10 == 0
    ..isNew = id % 5 == 0
    ..isOnSale = id % 3 == 0
    ..shipping = (ShippingInfo()
      ..freeShipping = id % 5 == 0
      ..weight = 1.5 + (id % 10)
      ..dimensions = (Dimensions()
        ..length = 10.0
        ..width = 8.0
        ..height = 6.0
        ..unit = 'inches'))
    ..seo = (SEOInfo()
      ..metaTitle = 'Premium Product $id - Best Quality'
      ..metaDescription = 'Buy premium product $id online. Free shipping available.'
      ..metaKeywords.addAll(['product', 'quality', 'premium']));

  // Add variants
  for (var i = 0; i < 3; i++) {
    product.variants.add(ProductVariant()
      ..variantId = 'var${id}_$i'
      ..sku = 'SKU-${id.toString().padLeft(6, '0')}-$i'
      ..name = 'Variant $i'
      ..price = 99.99 + (id % 100) + (i * 10)
      ..stockQuantity = 50 + (i * 10)
      ..weight = 1.5 + i
      ..dimensions = (Dimensions()
        ..length = 10.0
        ..width = 8.0
        ..height = 6.0 + i
        ..unit = 'inches'));
  }

  // Add reviews
  for (var i = 0; i < (id % 5); i++) {
    product.reviews.add(ProductReview()
      ..reviewId = Int64(id * 1000 + i)
      ..userId = Int64(i + 1)
      ..username = 'user${i + 1}'
      ..rating = 4 + (i % 2)
      ..title = 'Great product!'
      ..content = 'I really enjoyed using this product. Highly recommended!'
      ..createdAt = now - Int64(i * 86400000)
      ..stats = (ReviewStats()
        ..helpfulCount = Int64(i * 5)
        ..notHelpfulCount = Int64(i))
      ..verifiedPurchase = true);
  }

  return product;
}

Order createTestOrder(int id, int userId) {
  final now = Int64(DateTime.now().millisecondsSinceEpoch);

  final order = Order()
    ..orderId = Int64(id)
    ..orderNumber = 'ORD-${id.toString().padLeft(8, '0')}'
    ..userId = Int64(userId)
    ..subtotal = 500.00 + (id % 1000)
    ..tax = 50.00 + (id % 100)
    ..shippingCost = 10.00
    ..discount = 25.00
    ..total = 535.00 + (id % 1000)
    ..currency = 'USD'
    ..status = OrderStatus.values[(id % 6) + 1]
    ..payment = (PaymentInfo()
      ..paymentId = 'pay$id'
      ..type = PaymentType.CREDIT_CARD
      ..amount = 535.00 + (id % 1000)
      ..currency = 'USD'
      ..status = PaymentStatus.COMPLETED
      ..transactionId = 'txn${id.toString().padLeft(10, '0')}'
      ..provider = 'Stripe'
      ..createdAt = now)
    ..shippingAddress = (Address()
      ..streetLine1 = '$id Shipping Street'
      ..city = 'Los Angeles'
      ..state = 'CA'
      ..postalCode = '90001'
      ..country = 'USA'
      ..type = AddressType.SHIPPING
      ..isDefault = true)
    ..billingAddress = (Address()
      ..streetLine1 = '$id Billing Street'
      ..city = 'Los Angeles'
      ..state = 'CA'
      ..postalCode = '90001'
      ..country = 'USA'
      ..type = AddressType.BILLING
      ..isDefault = true)
    ..createdAt = now - Int64(id * 3600000)
    ..updatedAt = now
    ..customerNotes = 'Please deliver before 5 PM'
    ..trackingNumber = 'TRK${id.toString().padLeft(12, '0')}'
    ..carrier = 'UPS';

  // Add order items
  for (var i = 0; i < 10; i++) {
    order.items.add(OrderItem()
      ..orderItemId = 'item${id}_$i'
      ..productId = Int64(i + 1)
      ..sku = 'SKU-${(i + 1).toString().padLeft(6, '0')}'
      ..productName = 'Product ${i + 1}'
      ..quantity = (i % 3) + 1
      ..unitPrice = 50.00 + (i * 10)
      ..totalPrice = (50.00 + (i * 10)) * ((i % 3) + 1)
      ..taxAmount = 5.00 + i
      ..discountAmount = 2.50);
  }

  // Add status history
  order.statusHistory.add(OrderStatusHistory()
    ..status = OrderStatus.ORDER_PENDING
    ..timestamp = now - Int64(7200000)
    ..note = 'Order placed'
    ..updatedBy = 'system');

  order.statusHistory.add(OrderStatusHistory()
    ..status = OrderStatus.ORDER_PROCESSING
    ..timestamp = now - Int64(3600000)
    ..note = 'Payment confirmed'
    ..updatedBy = 'system');

  return order;
}
