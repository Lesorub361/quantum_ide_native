import 'dart:io';
import 'package:path/path.dart' as p;

/// Execution engine mode for QuantumIDE's runtime environment.
enum ExecutionBackendKind {
  /// Native Android Bionic userspace (`$PREFIX/usr`) with direct `fork+exec`
  /// and no PRoot syscall interception.
  bionicNative,

  /// Elevated Android kernel mode (`su`) for rooted devices.
  nativeRoot,

  /// Android 15+ AVF / KVM microVM backend.
  microVm,

  /// Legacy PRoot userspace fallback (Ubuntu rootfs).
  prootFallback,
}

/// Strategy contract describing how shell commands and toolchains are
/// resolved and executed across QuantumIDE's supported runtime backends.
abstract interface class ExecutionBackend {
  ExecutionBackendKind get kind;

  /// Human-readable backend name for diagnostics and UI.
  String get displayName;

  /// Whether this backend requires path translation between host and guest.
  bool get requiresPathTranslation;

  /// Resolves the active `PATH` entries for this backend given [filesDir].
  List<String> resolvePathEntries(String filesDir);

  /// Builds the environment map merged into spawned commands and terminals.
  Map<String, String> buildEnvironment(
    String filesDir, {
    Map<String, String> baseEnv = const {},
  });

  /// Maps a host filesystem path into the backend's execution path.
  String mapPath(String hostPath, String filesDir);
}

/// Native Android Bionic userspace backend (`$PREFIX/usr` — Leostryx / pkg).
///
/// Runs ARM64 Bionic binaries (`openjdk`, `kotlinc`, `gradle`, `aapt2`,
/// `d8`, `apksigner`, `node`, `python`, `git`, `clang`) directly on the
/// Android kernel without PRoot or Ubuntu rootfs overhead.
class BionicNativeBackend implements ExecutionBackend {
  const BionicNativeBackend();

  @override
  ExecutionBackendKind get kind => ExecutionBackendKind.bionicNative;

  @override
  String get displayName => 'Android Native Bionic (\$PREFIX)';

  @override
  bool get requiresPathTranslation => false;

  @override
  List<String> resolvePathEntries(String filesDir) {
    final prefix = p.join(filesDir, 'usr');
    final home = filesDir;
    return [
      p.join(prefix, 'bin'),
      p.join(prefix, 'local', 'bin'),
      p.join(prefix, 'opt', 'openjdk', 'bin'),
      p.join(home, 'flutter', 'bin'),
      p.join(home, '.pub-cache', 'bin'),
      '/system/bin',
      '/system/xbin',
    ];
  }

  @override
  Map<String, String> buildEnvironment(
    String filesDir, {
    Map<String, String> baseEnv = const {},
  }) {
    final prefix = p.join(filesDir, 'usr');
    final tmpDir = p.join(filesDir, 'tmp');
    final pathEntries = resolvePathEntries(filesDir);
    final existingPath = baseEnv['PATH'];
    final fullPath = [
      ...pathEntries,
      if (existingPath != null && existingPath.isNotEmpty) existingPath,
    ].join(Platform.pathSeparator);

    return {
      ...baseEnv,
      'HOME': filesDir,
      'PREFIX': prefix,
      'TERMUX__PREFIX': prefix,
      'TMPDIR': tmpDir,
      'PATH': fullPath,
      'LD_LIBRARY_PATH': p.join(prefix, 'lib'),
      'JAVA_HOME': p.join(prefix, 'opt', 'openjdk'),
      'ANDROID_HOME': p.join(filesDir, 'android-sdk'),
      'GRADLE_USER_HOME': p.join(filesDir, '.gradle'),
    };
  }

  @override
  String mapPath(String hostPath, String filesDir) => hostPath;
}

/// Elevated root kernel backend (`su`) without PRoot translation.
class NativeRootBackend implements ExecutionBackend {
  const NativeRootBackend();

  @override
  ExecutionBackendKind get kind => ExecutionBackendKind.nativeRoot;

  @override
  String get displayName => 'Native Root Kernel (su)';

  @override
  bool get requiresPathTranslation => false;

  @override
  List<String> resolvePathEntries(String filesDir) =>
      const BionicNativeBackend().resolvePathEntries(filesDir);

  @override
  Map<String, String> buildEnvironment(
    String filesDir, {
    Map<String, String> baseEnv = const {},
  }) =>
      const BionicNativeBackend().buildEnvironment(filesDir, baseEnv: baseEnv);

  @override
  String mapPath(String hostPath, String filesDir) => hostPath;
}
