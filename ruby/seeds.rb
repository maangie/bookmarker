require 'active_record'
require 'yaml'
require 'csv'
require 'action_view'
require 'pry'

include ActionView::Helpers::TextHelper

config = YAML.load_file('./database.yml')

# DB接続設定
ActiveRecord::Base.establish_connection(
  config['db'][ENV["RAILS_ENV"] || 'development']
)

# テーブルにアクセスするためのクラスを宣言
class Bookmark < ActiveRecord::Base; end
class User < ActiveRecord::Base; end

user_id = User.first.id
CSV.foreach('sample.tsv', col_sep: "\t") do |row|
  puts row[0]
  b = Bookmark.new
  b.user_id     = user_id
  b.title       = truncate(row[0], length: 50, escape: false)
  b.description = row[1]
  b.url         = row[2]
  b.created     = Time.now
  b.modified    = Time.now

  b.save!
end
