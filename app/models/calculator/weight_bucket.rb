class Calculator::WeightBucket < Calculator::Advanced
  preference :default_weight, :decimal, :default => 0

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

  # object will be Shipment
  # calculable will be ShippingMethod
  def compute(object)
    total_weight = shipment_weight(object)
    get_rate(total_weight) || self.preferred_default_amount
  end
end
