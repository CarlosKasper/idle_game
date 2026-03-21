/// Tipos de bônus disponíveis
enum BonusType {
  incomeMultiplier, // Multiplicador de renda por tempo
  clickMultiplier, // Multiplicador de cliques por tempo
  instantMoney, // Dinheiro instantâneo (sem tempo)
}

/// Representa um bônus ativo no jogo
class ActiveBonus {
  final String id;
  final String name;
  final BonusType type;
  final double value; // valor do multiplicador ou quantidade de dinheiro
  final DateTime activatedAt;
  final Duration duration; // quanto tempo o bônus dura
  final String emoji;

  ActiveBonus({
    required this.id,
    required this.name,
    required this.type,
    required this.value,
    required this.activatedAt,
    required this.duration,
    required this.emoji,
  });

  /// Verifica se o bônus ainda está ativo
  bool get isActive {
    if (type == BonusType.instantMoney) {
      return false; // Bônus instantâneos não têm timer
    }
    final elapsedTime = DateTime.now().difference(activatedAt);
    return elapsedTime < duration;
  }

  /// Retorna o tempo restante do bônus em segundos
  /// Retorna 0 se o bônus expirou
  int get remainingSeconds {
    if (type == BonusType.instantMoney) {
      return 0;
    }
    final elapsedTime = DateTime.now().difference(activatedAt);
    final remaining = duration.inSeconds - elapsedTime.inSeconds;
    return remaining > 0 ? remaining : 0;
  }

  /// Retorna uma string formatada do tempo restante (MM:SS)
  String get remainingTimeFormatted {
    final remaining = remainingSeconds;
    final minutes = remaining ~/ 60;
    final seconds = remaining % 60;
    return '$minutes:${seconds.toString().padLeft(2, '0')}';
  }

  /// Cria uma cópia do bônus
  ActiveBonus copyWith({
    String? id,
    String? name,
    BonusType? type,
    double? value,
    DateTime? activatedAt,
    Duration? duration,
    String? emoji,
  }) {
    return ActiveBonus(
      id: id ?? this.id,
      name: name ?? this.name,
      type: type ?? this.type,
      value: value ?? this.value,
      activatedAt: activatedAt ?? this.activatedAt,
      duration: duration ?? this.duration,
      emoji: emoji ?? this.emoji,
    );
  }
}
