class Cart < ActiveRecord::Base
  has_many :line_items, dependent: :destroy
  has_many :items, through: :line_items
  belongs_to :user

  def total
    sum = 0
    self.line_items.each do |line_item|
      sum += line_item.item.price * line_item.quantity
    end
    sum
  end

  # def add_item(new_item)
  #   line_item = self.line_items.find_by(item_id: item_id)
  #   if line_item
  #     line_item.quantity += 1
  #   else
  #     line_item = self.line_items.build(item_id: item_id)
  #   end
  # end
  def add_item(item_id)
    if item_ids.include?(item_id.to_i)
      current_line_item = line_items.find_by(item_id: item_id)
      current_line_item.quantity += 1
      current_line_item
    else
      line_items.build(item_id: item_id)
    end
  end

  def checkout
    self.status = "submitted"
    change_inventory
  end

  def change_inventory
    if self.status = "submitted"
      self.line_items.each do |line_item|
        line_item.item.inventory -= line_item.quantity
        line_item.item.save
      end
    end
  end

end
