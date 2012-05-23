require 'spree_core'
require 'spree_advanced_calculators_hooks'


  
module SpreeAdvancedCalculators
  class Engine < Rails::Engine
    
    config.autoload_paths += %W(#{config.root}/lib)

    def self.activate
      Dir.glob(File.join(File.dirname(__FILE__), "../app/**/*_decorator*.rb")) do |c|
        Rails.configuration.cache_classes ? require(c) : load(c)
      end
      
      [
        #Calculator::PriceBucket, 
        Calculator::WeightBucket, 
        Calculator::QuantityBucket
      ].each(&:register)
    end

    config.to_prepare &method(:activate).to_proc
  end
end

