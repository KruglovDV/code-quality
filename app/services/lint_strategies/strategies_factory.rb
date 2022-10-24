# frozen_string_literal: true

require_relative './eslint_strategy'
require_relative './rubocop_strategy'

class StrategiesFactory
  def initialize
    @language_to_strategy = {
      'JavaScript' => ::EslintStrategy,
      'Ruby' => ::RubocopStrategy
    }
  end

  def build(language, repository_dir)
    strategy = @language_to_strategy[language]
    strategy.new(repository_dir)
  end
end
