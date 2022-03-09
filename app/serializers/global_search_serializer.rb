require 'json'
class GlobalSearchSerializer < ApplicationSerializer
  association :looks, blueprint: LookSerializer, view: :result do |object|
     # TODO: Fix the need to Manually parse
    parsed_results = []
    object[:looks].map(&:attributes).map do |look|
      parsed_results.push(Look.find(look["id"]))
    end
    parsed_results
  end

  association :tags, blueprint: LookSerializer, view: :result do |object|
    # TODO: Fix the need to Manually parse
    parsed_results = []
    object[:tags].map(&:attributes).map do |tag|
      parsed_results.push(Look.find(tag["id"]))
    end
    parsed_results
  end

  association :dates, blueprint: LookSerializer, view: :result do |object|
    object[:dates]
  end
end
