class CreateAnswers < ActiveRecord::Migration
  def change
    create_table :spree_answers do |t|
      t.text :answer
      t.integer :question_id

      t.timestamps
    end
  end
end
