class UsersController < ApplicationController
  def index
  end

  def new
    @user = User.new
  end

  def edit
  end

  def show
    
  end
def create

        username = params[:username]

        password = params[:password]

        user = User.where("username =? and activation_status =?", username, "active").first

        user_password = BCrypt::Engine.hash_secret(password, user.password_salt) unless user.blank?

        if !user_password.blank? and user.password_hash.eql? user_password

            session[:user] = user.id

            flash[:notice] = "Wellcome #{user.username}"

            redirect_to root_url

        else

            params[:username]

            flash[:error] = "Your data not valid"

            render "new"

        end

    end
 private

        def params_user

            params.require(:user).permit(:username, :email, :password, :password_confirmation, :humanizer_answer, :humanizer_question_id)
        end
  end