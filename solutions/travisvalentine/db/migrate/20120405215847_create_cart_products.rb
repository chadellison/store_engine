class CreateCartProducts < ActiveRecord::Migration
  def change
    create_table :cart_products do |t|
      t.integer :product_id
      t.integer :cart_id
      t.timestamps
    end
  end
end
