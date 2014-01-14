module Spree
  module Admin
    class QuestionsController < ResourceController
      before_action :set_question, only: [:show, :edit, :update, :destroy]

      # GET /spree/questions
      # GET /spree/questions.json
      def index

        #Spree::Question.joins(:user).where(user_id: a.id)
        params[:q] ||= {}
        if !spree_current_user.admin?
          params[:q][:user_email_cont] ||= spree_current_user.email
        end

        params[:q][:s] ||= "created_at asc"
        #@questions = @questions.with_deleted if params[:q].delete(:deleted_at_null).blank?
        #@search needs to be defined as this is passed to search_form_for
        @search = Spree::Question.ransack(params[:q])
        @questions = @search.result.
            #group_by_products_id.
            #includes(product_includes).
            page(params[:page]).
            per(Spree::Config[:admin_products_per_page])

        #if params[:q][:s].include?("master_default_price_amount")
        #  # PostgreSQL compatibility
        #  @questions = @questions.group("spree_prices.amount")
        #end
        @questions
      end

      # GET /spree/questions/1
      # GET /spree/questions/1.json
      def show
        #@question = Spree::Admin::Question.find(params[:id])
      end

      # GET /spree/questions/new
      def new
        @question = Spree::Admin::Question.new
      end

      # GET /spree/questions/1/edit
      def edit
      end

      # POST /spree/questions
      # POST /spree/questions.json
      def create
        @question = Question.new(question_params)
        product = Product.find_by permalink:params[:product_id]
        @question.user_id = product.user_id
        @question.product_id = product.id

        respond_to do |format|
          if @question.save
            format.html { redirect_to product_path(params[:product_id]), notice: 'Question was successfully created.' }
            #format.json { render action: 'show', status: :created, location: @question }
          else
            format.html { redirect_to product_path(params[:product_id]), alert: 'Question not created.'  }
            #format.json { render json: @question.errors, status: :unprocessable_entity }
          end
        end
      end

      # PATCH/PUT /spree/questions/1
      # PATCH/PUT /spree/questions/1.json
      def update
        respond_to do |format|
          if @question.update(question_params)
            format.html { redirect_to @question, notice: 'Question was successfully updated.' }
            #format.json { head :no_content }
          else
            format.html { render action: 'edit' }
            #format.json { render json: @question.errors, status: :unprocessable_entity }
          end
        end
      end

      # DELETE /spree/questions/1
      # DELETE /spree/questions/1.json
      def destroy
        @question.destroy
        respond_to do |format|
          format.html { redirect_to questions_url }
          format.json { head :no_content }
        end
      end

      def answer
        answer = Answer.new(answer_params)
        question = Question.find(params[:id])
        answer.question = question

        respond_to do |format|
          if answer.save
            format.html { redirect_to admin_questions_path(params[:product_id]), notice: 'Answer was successfully created.' }
            #format.json { render action: 'show', status: :created, location: @question }
          else
            format.html { redirect_to product_path(params[:product_id]), alert: 'Answer not created.'  }
            #format.json { render json: @question.errors, status: :unprocessable_entity }
          end
        end
      end

      private
        # Use callbacks to share common setup or constraints between actions.
        def set_question
          @question = Question.find(params[:id])
        end

        # Never trust parameters from the scary internet, only allow the white list through.
        def question_params
          params.require(:question).permit(:question)
        end
        def answer_params
          params.require(:answer).permit(:answer)
        end

    end
  end
end