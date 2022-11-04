# frozen_string_literal: true

class LintStrategies::StrategiesFactory
  def self.build(language)
    language_to_strategy[language]
  end

  private_class_method def self.language_to_strategy
    @language_to_strategy = {
      'JavaScript' => ::LintStrategies::EslintStrategy,
      'Ruby' => ::LintStrategies::RubocopStrategy
    }
  end
end
