import 'package:flutter_test/flutter_test.dart';
import 'package:quantum_ide/core/services/runtime/execution_backend.dart';

void main() {
  group('BionicNativeBackend', () {
    const backend = BionicNativeBackend();
    const filesDir = '/data/user/0/com.example.quantum_ide_native/files';

    test('does not require path translation and exposes native env', () {
      expect(backend.kind, ExecutionBackendKind.bionicNative);
      expect(backend.requiresPathTranslation, isFalse);
      expect(backend.mapPath('/tmp/demo', filesDir), '/tmp/demo');

      final env = backend.buildEnvironment(filesDir);
      expect(env['HOME'], filesDir);
      expect(env['PREFIX'], '$filesDir/usr');
      expect(env['TERMUX__PREFIX'], '$filesDir/usr');
      expect(env['LD_LIBRARY_PATH'], '$filesDir/usr/lib');
      expect(env['JAVA_HOME'], '$filesDir/usr/opt/openjdk');
      expect(env['ANDROID_HOME'], '$filesDir/android-sdk');
      expect(env['PATH'], contains('$filesDir/usr/bin'));
    });
  });
}
