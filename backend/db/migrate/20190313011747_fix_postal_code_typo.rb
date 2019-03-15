class FixPostalCodeTypo < ActiveRecord::Migration[5.2]
  def change
    rename_column :consumers, "postral_code", "postal_code"
    rename_column :facilities, "postral_code", "postal_code"
  end
end
