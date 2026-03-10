/// Constantes do jogo - Centralizar aqui para facilitar balanceamento
library;

class GameConstants {
  // Colors
  static const primaryColor = 0xFF1565C0;
  static const primaryDarkColor = 0xFF0D47A1;
  static const successColor = 0xFF4CAF50;
  static const successDarkColor = 0xFF388E3C;
  static const accentColor = 0xFFFFB300;

  // Upgrade cost multiplier (exponential curve)
  // custo = base × 1.15^(nível-1)
  static const upgradeCostMultiplier = 1.15;

  // Career requirements
  static const careerEstagiario = 0.0;
  static const careerFuncionario = 100.0;
  static const careerAnalista = 5000.0;
  static const careerGerente = 100000.0;
  static const careerDiretor = 2000000.0;
  static const careerCEO = 50000000.0;

  // Upgrade costs
  static const upgradeCoffeeCost = 10.0;
  static const upgradeNotebookCost = 100.0;
  static const upgradeChairCost = 50.0;
  static const upgradeCourseCost = 500.0;
  static const upgradeMonitorCost = 200.0;

  // Upgrade values
  static const upgradeClickBonus = 1.0; // +1 clique
  static const upgradeNotebookBonus = 2.0; // +2 cliques
  static const upgradePassiveBonus = 0.5; // +0.5/s
  static const upgradeMultiplierCourse = 0.10; // +10%
  static const upgradeMultiplierMonitor = 0.05; // +5%

  // Passive income update frequency (ms)
  static const passiveIncomeUpdateFrequency = 500;

  // Offline limit (hours)
  static const maxOfflineHours = 8;

  // Prestige multiplier per run
  static const prestigeBonus = 0.20; // +20% per prestige

  // Ad placement times (seconds)
  static const firstAdTime = 300; // 5 minutes
  static const adMinInterval = 600; // 10 minutes between ads
}
