import 'dart:convert';

import 'package:crypto/crypto.dart';

class R2Service {
  final String accountId = '8a5712d1d8c345540efd2daac58e6dfe';
  final String bucket = 'snuz-app';
  final String accessKeyId = '381330149a3dd52b7b939e07575489a3';
  final String secretAccessKey = '40459a8c2fea6e731b56821a4f5bee011039a9b2e9d5b1129783e3518c44b8e9';

  Future<String> getPresignedUrl({
    required String key,
    Duration expiration = const Duration(minutes: 60),
  }) async {
    final endpoint = 'https://$accountId.r2.cloudflarestorage.com';
    final datetime = DateTime.now().toUtc();
    final expireTime = datetime.add(expiration);
    final dateStamp = datetime.toIso8601String().split('T')[0].replaceAll('-', '');
    final amzDate =
        '${dateStamp}T${datetime.hour.toString().padLeft(2, '0')}${datetime.minute.toString().padLeft(2, '0')}${datetime.second.toString().padLeft(2, '0')}Z';

    // Create canonical request
    final credentialScope = '$dateStamp/auto/s3/aws4_request';
    final params = {
      'X-Amz-Algorithm': 'AWS4-HMAC-SHA256',
      'X-Amz-Credential': '$accessKeyId/$credentialScope',
      'X-Amz-Date': amzDate,
      'X-Amz-Expires': expireTime.difference(DateTime.now().toUtc()).inSeconds.toString(),
      'X-Amz-SignedHeaders': 'host',
    };
    final canonicalQueryString = params.entries.map((e) => '${e.key}=${Uri.encodeComponent(e.value)}').join('&');

    final canonicalRequest = [
      'GET',
      '/$bucket/$key',
      canonicalQueryString,
      'host:$accountId.r2.cloudflarestorage.com\n',
      'host',
      'UNSIGNED-PAYLOAD'
    ].join('\n');

    // Create string to sign
    final stringToSign = [
      'AWS4-HMAC-SHA256',
      amzDate,
      credentialScope,
      sha256.convert(utf8.encode(canonicalRequest)).toString(),
    ].join('\n');

    // Calculate signature
    final signature = _calculateSignature(dateStamp: dateStamp, stringToSign: stringToSign);

    // Construct final URL
    final presignedUrl = '$endpoint/$bucket/$key?$canonicalQueryString&X-Amz-Signature=$signature';

    return presignedUrl;
  }

  String _calculateSignature({
    required String dateStamp,
    required String stringToSign,
  }) {
    final kDate = Hmac(sha256, utf8.encode('AWS4$secretAccessKey')).convert(utf8.encode(dateStamp));
    final kRegion = Hmac(sha256, kDate.bytes).convert(utf8.encode('auto'));
    final kService = Hmac(sha256, kRegion.bytes).convert(utf8.encode('s3'));
    final kSigning = Hmac(sha256, kService.bytes).convert(utf8.encode('aws4_request'));
    final signature = Hmac(sha256, kSigning.bytes).convert(utf8.encode(stringToSign));

    return signature.toString();
  }
}
