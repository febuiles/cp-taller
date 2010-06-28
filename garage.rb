require "sinatra"
require "models"

before do
  content_type :html, :charset => 'utf-8'
end

get "/" do
  redirect "/items"
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

delete "/items" do
  item = Item.get(params[:id])
  item.destroy unless item.nil?

  redirect "/items"
end

put "/items" do
  item = Item.get(params[:id])
  error 500 if item.nil?

  if item.sell
    @items = Item.all
    @notice = "Felicitaciones por la compra de: #{item.title}"
    erb :index
  else
    not_found("No encontramos el producto que intentas comprar")
  end
end

helpers do

  def buy_item_link(item)
    html = <<HTML
<form action="/items" method="post">
  <input type="hidden" name="_method" value="put" />
  <input type="hidden" name="id" value="#{item.id}" />
  <input type="submit" value="Comprar" />
</form>
HTML
    html if !item.nil?
  end

  def delete_item_link(item)
    html = <<HTML
<form action="/items" method="post">
  <input type="hidden" name="_method" value="delete" />
  <input type="hidden" name="id" value="#{item.id}" />
  <input type="submit" value="Eliminar" />
</form>
HTML
    html if !item.nil?
  end
end

