require "sinatra"
require "models"

enable :static

before do
  content_type :html, :charset => 'utf-8'
end

get "/items" do
  @items = Item.all
  erb :index
end

post "/items" do
  @item = Item.new(params)
  if @item.save
    redirect "/items/#{@item.id}"
  else
    erb :new
  end
end

get "/items/new" do
  @item = Item.new
  erb :new
end

get "/items/:id" do
  @item = Item.get(params[:id])
  erb :show
end

delete "/items/:id" do
  item = Item.get(params[:id])
  item.destroy unless item.nil?

  redirect "/items"
end

get "/buy/:id" do
  @item = Item.get(params[:id])
  if @item.sold
    status 404
  else
    haml :buy
  end
end

post "/buy" do
  if valid_params?
    name, email = params[:name], params[:email]
    @item = Item.get(params[:id])
    @item.sell(name, email)
    mail(name, email, @item.title)
    haml :thanks
  else
    status 500
  end
end
