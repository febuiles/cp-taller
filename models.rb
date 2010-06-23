# -*- coding: utf-8 -*-
require 'dm-core'
require 'dm-migrations'
require 'dm-validations'

configure :development do
  DataMapper.auto_upgrade!
  DataMapper::setup(:default, "sqlite3://#{Dir.pwd}/data.db")
end

configure :production do
    DataMapper.setup(:default, ENV['DATABASE_URL'] || 'mysql://localhost/heroin')
end

class Item

  CATEGORIES = ["Programación", "Literatura", "DVD"]
  include DataMapper::Resource

  property :id, Serial

  property :title, String
  property :author, String
  property :description, Text
  property :price, String, :default => "20000"

  property :buyer, String
  property :buyer_email, String
  property :sold, Boolean, :default => false
  property :category, String


  validates_presence_of :title, :message => "El producto necesita un título"
  validates_presence_of :author, :message => "El producto necesita un autor o fabricante"
  validates_presence_of :price, :message => "El precio del producto no puede estar vacío"

  def sold?
    sold ? "Si" : "No"
  end

  def sell(name, email)
    self.buyer = name
    self.buyer_email = email
    self.sold = true
    self.save
  end
end

#configure :development do

#end

