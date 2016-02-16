class CreatePhotos < ActiveRecord::Migration
  def change
    create_table :photos do |t|
      t.string :title
      t.attachment :image

      t.timestamps
    end
  end
end
