json.array!(@spree_questions) do |spree_question|
  json.extract! spree_question, :user_id, :product_id, :question
  json.url spree_question_url(spree_question, format: :json)
end
