# frozen_string_literal: true

require_relative 'adapters/deep_seek_adapter'
require_relative '../utils/code_snippet_parser'

class RecipeGeneratorService
  attr_reader :message, :user, :preferences, :adapter

  def initialize(message, user_id, adapter)
    @message = message
    @user = User.find(user_id)
    @preferences = @user.preferences
    @adapter = adapter
  end

  def call
    check_valid_message_length
    response = adapter.message_to_chat_api(request_messages)
    create_recipe(response)
  end

  private

  def check_valid_message_length
    error_msg = I18n.t('api.errors.invalid_message_length')
    raise RecipeGeneratorServiceError, error_msg unless !!(message =~ /\b\w+\b/)
  end

  def prompt
    <<~CONTENT
      Genera una receta como UN ÚNICO STRING de texto formateado INTERNAMENTE como JSON válido,
      siguiendo ESTRICTAMENTE estas reglas:

      1) Estructura EXACTA:
         "{"name": "Nombre", "content": "Ingredients:\\n- item1\\n- item2\\nPreparation:\\n1. Paso1\\nPreferences:\\n- Descripción"}"

      2) REQUERIMIENTOS TÉCNICOS:
         - Nunca uses ```json o marcas de código
         - El output debe ser UN SOLO STRING parseable directamente con JSON.parse()

      3) Formato de 'content':
         Ingredients:
         - Lista con viñetas (usar \\n-)
         Preparation:
         - Pasos numerados (usar \\n1., \\n2.)
         Preferences:
         - Explicar exclusiones por restricciones

      4) Preferencias a considerar: [lista tus preferencias aquí]
         * Las RESTRICCIONES son OBLIGATORIAS
         * Las preferencias son sugerencias

    CONTENT
  end

  def system_message
    [{ role: 'system', content: prompt }]
  end

  def new_message
    [
      { role: 'user',
        content: "\nIngredients: #{message} Preferences:  #{preferences_mapped}" }
    ]
  end

  def request_messages
    system_message + new_message
  end

  def preferences_mapped
    preferences.map do |preference|
      "Description : #{preference.description}, Restriction: #{preference.restriction}"
    end
  end

  def create_recipe(response)
    parsed_response = response.is_a?(String) ? JSON.parse(response) : response
    content = parsed_response.dig('choices', 0, 'message', 'content')
    json_string = CodeSnippetParser.parse_snippet(content)
    json_parsed = JSON.parse(json_string)
    Recipe.new(name: json_parsed['name'], ingredients: message, description: json_parsed['content'], user:)
  rescue JSON::ParserError => exception
    raise RecipeGeneratorServiceError, exception.message
  end
end
