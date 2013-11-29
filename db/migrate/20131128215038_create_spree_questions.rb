class CreateSpreeQuestions < ActiveRecord::Migration
  def change
    create_table :spree_questions do |t|
      t.references :user
      t.references :product
      t.text :question

      t.timestamps
    end
  end
end
