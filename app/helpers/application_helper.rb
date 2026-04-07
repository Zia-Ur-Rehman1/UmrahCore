module ApplicationHelper
  def currency_amount(cents, currency)
    number_to_currency(cents.to_i / 100.0, unit: "#{currency} ", precision: 2)
  end
end
