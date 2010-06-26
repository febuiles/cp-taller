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
  include DataMapper::Resource

  property :id, Serial

  property :title, String
  property :author, String
  property :description, Text
  property :price, String, :default => "20000"
  property :category, String

  property :sold, Boolean, :default => false

  validates_presence_of :title, :message => "El producto necesita un título"
  validates_presence_of :author, :message => "El producto necesita un autor o fabricante"
  validates_presence_of :price, :message => "El precio del producto no puede estar vacío"

  def sold?
    sold ? "Si" : "No"
  end

  def sell
    self.sold = true
    save
  end
end
