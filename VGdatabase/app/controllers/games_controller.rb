class GamesController < ApplicationController
skip_before_action :verify_authenticity_token

require 'rubygems'
require 'apicalypse'

    def homepage
        @user = User.find(session[:user_id])
        @games = Game.all
        @library = Store.where(:user_id => @user.id)
    end

    def collection
        @library = Store.where(:user_id => session[:user_id])
        @user = User.find(session[:user_id])
    end

    def collectionEdit
        @mylibrary = Store.where(:user_id => session[:user_id])
        @user = User.find(session[:user_id])
    end

    def selling
        @user = User.find(session[:user_id])
        @library = Store.where(:user_id => @user.id, :selling => 'true')
    end

    def editSelling
        @mylibrary = Store.where(:user_id => session[:user_id],:selling => 'true')
        @user = User.find(session[:user_id])
    end
    def search
    end

    def friends
        @user = User.find(session[:user_id])
        @friends = Friend.where(:user_id => @user.id)
    end

    def myProfile
        @user = User.find(session[:user_id])
        @review = Review.where(:user_id => @user)
        @friends = Friend.where(:user_id => @user.id)
    end

    def editProfile
        @user = User.find(session[:user_id])
        @review = Review.where(:user_id => @user)
        @friends = Friend.where(:user_id => @user.id)
    end

    def editAvatar
        @avatar = Avatar.all
    end

    def editingAvatar
        @user = User.find(session[:user_id])
        avatar = params[:avatar]
        @user.update_attributes!(:avatar => avatar)
        redirect_to myProfile_path
    end

    def editingProfile
        username = params[:user][:name]
        email = params[:user][:email]
        oldp = params[:user][:oldp]
        newp = params[:user][:newp]
        newp1 = params[:user][:newp1]
        back = params[:user][:background]
        location = params[:user][:location]
        @user = User.find(session[:user_id])
        if username.length!=0 && email.length!=0 && newp.length!=0 && newp==newp1 && oldp==@user.password && location.length!=0 && back.length!=0
            @user.update_attributes!(:password => newp, :username => username, :email => email, :background => back, :location => location)
            redirect_to editProfile_success_path
        elsif username.length!=0 && email.length!=0 && oldp.length==0 && location.length!=0 && back.length!=0
            @user.update_attributes!(:username => username, :email => email, :background => back, :location => location)
            redirect_to editProfile_success_path                         
        else
            redirect_to editProfile_error_path
        end
    end

    def revert 
        @user = User.find(session[:user_id])
        @user.update_attributes!(:background => "default.png")
        redirect_to editProfile_success_path  
    end

    def editProfile_success
        @user = User.find(session[:user_id])
        @review = Review.where(:user_id => @user)
        @friends = Friend.where(:user_id => @user.id)
    end

    def editProfile_error
        @user = User.find(session[:user_id])
        @review = Review.where(:user_id => @user)
        @friends = Friend.where(:user_id => @user.id)
    end

    def show
        id = params[:id]
        @games = Game.find(id)
        @library = Store.where(:user_id => session[:user_id])
        @user = session[:user_id]
        @aux = Review.where(:game_id => @games)
        @aux = @aux.where('user_id != ?', @user)
        @review = Review.where(:game_id => @games, :user_id => @user)
    end

    def contactUs
        @user = User.find(session[:user_id])
    end

    def settings
    end

    def deleteUser
        name = session[:user_id]
        @friends = Friend.where(:user_id => name)
        @friends.each do |friend|
            friend.delete
        end
        @friends1 = Friend.where(:friend_id => name)
        @friends1.each do |friend|
            friend.delete
        end
        @review = Review.where(:user_id => name)
        @review.each do |review|
            review.delete
        end
        @library = Store.where(:user_id => name)
        @library.each do |library|
            library.delete
        end
        User.delete(name)
        redirect_to login_path
    end

    

    def searchUser
        @user = User.find(session[:user_id])
    end

    def searchingUser
        user = params[:username]
        if User.exists?(User.where(:username => user))
            @users = User.where(:username => user)[0].id
            redirect_to visit_profile_path(@users)
        else
            render html: 'user non trovato'
        end
    end

    def gmaps4rails_infowindow
        contentString = '<div id="content">'+
        '<div id="siteNotice">'+
        '</div>'+
        '<h1 id="firstHeading" class="firstHeading">Uluru</h1>'+
        '<div id="bodyContent">'+
        '<p><b>Uluru</b>, also referred to as <b>Ayers Rock</b>, is a large ' +
        'sandstone rock formation in the southern part of the '+
        'Northern Territory, central Australia. It lies 335&#160;km (208&#160;mi) '+
        'south west of the nearest large town, Alice Springs; 450&#160;km '+
        '(280&#160;mi) by road. Kata Tjuta and Uluru are the two major '+
        'features of the Uluru - Kata Tjuta National Park. Uluru is '+
        'sacred to the Pitjantjatjara and Yankunytjatjara, the '+
        'Aboriginal people of the area. It has many springs, waterholes, '+
        'rock caves and ancient paintings. Uluru is listed as a World '+
        'Heritage Site.</p>'+
        '<p>Attribution: Uluru, <a href="https://en.wikipedia.org/w/index.php?title=Uluru&oldid=297882194">'+
        'https://en.wikipedia.org/w/index.php?title=Uluru</a> '+
        '(last visited June 22, 2009).</p>'+
        '</div>'+
        '</div>';
    end

    def searchGame
        @user = User.find(session[:user_id])
        @users = Store.where(:selling => 'true', :condition => 'New')
        @users1 = Store.where(:selling => 'true', :condition => 'Used')
        @hash = Gmaps4rails.build_markers(@users) do |user, marker|
            marker.lat User.find(user.user_id).location.split(',')[0]
            marker.lng User.find(user.user_id).location.split(',')[1]
            marker.infowindow User.find(user.user_id).username+" sells it for "+user.price.to_s+"€"
            marker.picture({
            "url" => ActionController::Base.helpers.asset_path("marker.png"),
            "width" =>  20,
            "height" => 30})
        end
        @hash1 = Gmaps4rails.build_markers(@users1) do |user, marker|
            marker.lat User.find(user.user_id).location.split(',')[0]
            marker.lng User.find(user.user_id).location.split(',')[1]
            marker.infowindow User.find(user.user_id).username+" sells it for "+user.price.to_s+"€"
            marker.picture({
            "url" => ActionController::Base.helpers.asset_path("marker_alt.png"),
            "width" =>  20,
            "height" => 30})
        end
    end

    def searchingGame
        game = params[:game]
        if (Game.exists?(:title => game))
            @game = Game.where(:title => game)[0].id
            @users = Store.where(:selling => 'true', :condition => 'new', :game_id => @game)
            @users1 = Store.where(:selling => 'true', :condition => 'used', :game_id => @game )
            @hash = Gmaps4rails.build_markers(@users) do |user, marker|
                marker.lat User.find(user.user_id).location.split(',')[0]
                marker.lng User.find(user.user_id).location.split(',')[1]
                marker.infowindow User.find(user.user_id).username
                marker.picture({
                "url" => ActionController::Base.helpers.asset_path("marker.png"),
                "width" =>  20,
                "height" => 30})
            end
            @hash1 = Gmaps4rails.build_markers(@users1) do |user, marker|
                marker.lat User.find(user.user_id).location.split(',')[0]
                marker.lng User.find(user.user_id).location.split(',')[1]
                marker.infowindow User.find(user.user_id).username
                marker.picture({
                "url" => ActionController::Base.helpers.asset_path("marker_alt.png"),
                "width" =>  20,
                "height" => 30})
            end   
        end
        redirect_to searchGame_path 
    end
    
    
#admin

    def deleteReviewsGame
    end

    def deleteReviewsGame_success
    end

    def deleteReviewsGame_error
    end

    def deletingReviewsGame
        game1 = params[:game][:title]
        if(Game.exists?(:title => game1))
            @game = Game.where(:title => game1)[0].id
            if(Review.exists?(:game_id => @game))
                @review = Review.where(:game_id => @game)
                @review.each do |review|
                    Review.delete(review.id)
                end
                redirect_to deleteReviewsGame_success_path
            else 
                redirect_to deleteReviewsGame_error_path
            end
        else 
            redirect_to deleteReviewsGame_error_path
        end
    end

    def deleteReviewsUser
    end

    def deleteReviewsUser_success
    end

    def deleteReviewsUser_error
    end

    def deletingReviewsUser
        user1 = params[:user][:name]
        game1 = params[:game][:title]
        if(User.exists?(:username => user1) && Game.exists?(:title => game1))
            @user = User.where(:username => user1)[0].id
            @game = Game.where(:title => game1)[0].id
            if(Review.exists?(:user_id => @user,:game_id => @game))
                @review = Review.where(:user_id => @user,:game_id => @game)[0].id
                Review.delete(@review)
                redirect_to deleteReviewsUser_success_path
            else 
                redirect_to deleteReviewsUser_error_path
            end
        else 
            redirect_to deleteReviewsUser_error_path
        end
    end

    def deletingUser
    end

    def deletingAdminUser
        name = params[:user][:name]
        if name == 'admin'
            redirect_to deletingUser_error_path
        else
            if User.exists?(User.where(:username => name))
                @user = User.where(:username => name)[0].id
                @friends = Friend.where(:user_id => @user)
                @friends.each do |friend|
                    friend.delete
                end
                @friends1 = Friend.where(:friend_id => @user)
                @friends1.each do |friend|
                    friend.delete
                end
                @review = Review.where(:user_id => @user)
                @review.each do |review|
                    review.delete
                end
                @library = Store.where(:user_id => @user)
                @library.each do |library|
                    library.delete
                end
                User.delete(@user)
                redirect_to deletingUser_succes_path
            else
                redirect_to deletingUser_error_path
            end
        end
    end

    def deletingUser_success
    end

    def deletingUser_error
    end


end
