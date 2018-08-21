require 'sinatra'
require 'sinatra/reloader'
require 'csv'
require 'time'

get '/' do
  @title = "Top | MemoApp"
  @indextitles = CSV.read("data/notes.csv", headers: true)
  erb :index
end

get '/new' do
  @title = "New | MemoApp"
  erb :new
end

get '/:id/edit' do
  @title = "Edit | MemoApp"
  table = CSV.read("data/notes.csv", headers: true)
  @post = table.find do |row|
    params[:id] == row["postnumber"]
  end
  erb :edit
end

get '/:id' do
  table = CSV.read("data/notes.csv", headers: true)
  @post = table.find do |row|
    params[:id] == row["postnumber"]
  end
  @newposttitle = @post["newposttitle"]
  @title = "#{@newposttitle} | MemoApp"
  puts @post
  erb :show
end

post '/new' do
  posttime = SecureRandom.urlsafe_base64(8)

  @postnumber = posttime
  @newpost = params[:newpost]
  @newposttitle = params[:newposttitle]

  CSV.open("data/notes.csv", "a") do |csv|
    csv << [@postnumber, @newposttitle, @newpost]
  end
  redirect to('/')
  erb :index
end

patch '/:id/edit' do
  @title = "Edit | MemoApp"
  @newpost = params[:newpost]
  @newposttitle = params[:newposttitle]

  post = CSV.read("data/notes.csv")
  index = post.index do |row|
    row[0] == params[:id]
  end
  post[index] = [params[:id], @newposttitle, @newpost]
  CSV.open("data/notes.csv", "w") do |csv|
    post.each do |row|
      csv << row
    end
  end
  redirect to("/#{params[:id]}")
  erb :show
end

delete '/:id' do
  post = CSV.read("data/notes.csv")
  index = post.index do |row|
    row[0] == params[:id]
  end
  post.delete_at(index)
  CSV.open("data/notes.csv", "w") do |csv|
    post.each do |row|
      csv << row
    end
  end

  redirect to('/')
  erb :index
end 