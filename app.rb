require 'bundler/setup'
Bundler.require
require 'sinatra/reloader' if development?
require 'sinatra/activerecord'
require './models'

enable :sessions

helpers do
    def current_user
        User.find_by(id: session[:user])
    end
end

get '/' do
    if !current_user.nil?
        @title = "#{current_user.name}のやること | KazoKey"
    else
        @title = "KazoKey"
    end
    @users = User.all
    @groups = Group.all
    @tasks = Task.all
	erb :index
end

get '/signup' do
    @title = "新規登録 | KazoKey"
    erb :sign_up 
end

get '/signin' do
    @title = "ログイン | KazoKey"
    erb :sign_in 
end

get '/groups/:group_id' do
    @this_group = Group.find(params[:group_id])
    @title = "#{@this_group.name} | KazoKey"
    erb :group
end

post '/signup' do
   user = User.create(
       name: params[:name],
       password: params[:password],
       password_confirmation: params[:password_confirmation]
       ) 
       
    if user.persisted?
        session[:user]  = user.id
    end
    
    redirect '/'
end

post '/signin' do
   user = User.find_by(name: params[:name]) 
   if user && user.authenticate(params[:password]) #有効なユーザー かつ 受け取ったpasswordがそのユーザーのDBに入ってるpasswordとあってるか
       session[:user] = user.id
   end
   redirect '/'
end

get '/logout' do
   session[:user] = nil
   redirect '/'
end

post '/groups/new' do
    Group.create(
        name: params[:name],
        aikotoba: params[:aikotoba]
        )
    redirect '/'
end

post '/users/:user_id/groups/:group_id/add' do
    group = Group.find(params[:group_id])
    if group.aikotoba == params[:aikotoba]
        user = User.find(params[:user_id])
    	unless user.groups.find_by(id: params[:group_id])
    		user.groups << Group.find(params[:group_id])
    	end
    	redirect "/groups/#{params[:group_id]}"
    elsif 
    	redirect '/'
    end
end

post "/groups/:group_id/tasks/:task_id/memo/change" do
    task = Task.find(params[:task_id])
    task.memo = params[:memo]
    task.save
    redirect "/groups/#{params[:group_id]}"
end


post '/users/tasks/:task_id/done' do
    task = Task.find(params[:task_id])
    if task.complete == false
        task.complete = true
        task.save
        redirect "/"
    else
        task.complete = false
        task.save
        redirect "/"
    end
end

post '/groups/:group_id/tasks/create' do
	task = Task.create(
	    name: params[:name],
	    memo: params[:memo],
	    complete: false
	    )
	Group.find(params[:group_id]).tasks << task
	redirect "/groups/#{params[:group_id]}"
end

post '/groups/:group_id/tasks/:task_id/delete' do
	group = Group.find(params[:group_id])
	group.tasks.delete(params[:task_id])
	redirect "/groups/#{params[:group_id]}"
end

post '/groups/:group_id/tasks/:task_id/done' do
    task = Task.find(params[:task_id])
    if task.complete == false
        task.complete = true
        task.save
        redirect "/groups/#{params[:group_id]}"
    else
        task.complete = false
        task.save
        redirect "/groups/#{params[:group_id]}"
    end
end

post '/groups/:group_id/tasks/:task_id/users/add' do
	task = Task.find(params[:task_id])
	unless task.users.find_by(id: params[:user_id])
		task.users << User.find(params[:user_id])
	end
	redirect "/groups/#{params[:group_id]}"
end