class Calculator::WeightBucket < Calculator::Advanced
  preference :default_weight, :decimal, :default => 0
  preference :max_weight,     :decimal, :default => 0

  def self.description
    I18n.t("weight_bucket", :scope => :calculator_names)
  end

  def self.unit
    I18n.t('weight_unit')
  end

  def shipment_weight(shipment)
    shipment.line_items.map {|li|
      (li.variant.weight || self.preferred_default_weight) * li.quantity
    }.sum
  end

  def available?(object)
    return true if preferred_max_weight.nil?
    weight = shipment_weight(object)
    Rails.logger.debug "... #{weight} <= #{preferred_max_weight} ? => #{weight <= preferred_max_weight}"
    weight <= preferred_max_weight
  end

  # object will be Shipment
  # calculable will be ShippingMethod
  def compute(object)
    weight = shipment_weight(object)
    get_rate(weight) || self.preferred_default_amount
  end

end
