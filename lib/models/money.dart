/// Classe para gerenciar valores monetários com grande amplitude
/// Usando double permite trabalhar com números muito grandes sem overflow
class Money {
  final double amount;

  const Money(this.amount);

  Money operator +(Money other) => Money(amount + other.amount);
  Money operator -(Money other) => Money(amount - other.amount);
  Money operator *(double multiplier) => Money(amount * multiplier);
  Money operator /(double divisor) => Money(amount / divisor);

  bool operator >(Money other) => amount > other.amount;
  bool operator >=(Money other) => amount >= other.amount;
  bool operator <(Money other) => amount < other.amount;
  bool operator <=(Money other) => amount <= other.amount;
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Money &&
          runtimeType == other.runtimeType &&
          amount == other.amount;

  @override
  int get hashCode => amount.hashCode;

  /// Formata o número para exibição com abreviações (1K, 1M, 1B, 1T)
  String format() {
    if (amount < 1000) {
      return amount.toStringAsFixed(0);
    } else if (amount < 1000000) {
      return '${(amount / 1000).toStringAsFixed(1)}K';
    } else if (amount < 1000000000) {
      return '${(amount / 1000000).toStringAsFixed(1)}M';
    } else if (amount < 1000000000000) {
      return '${(amount / 1000000000).toStringAsFixed(1)}B';
    } else {
      return '${(amount / 1000000000000).toStringAsFixed(1)}T';
    }
  }
}
