class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
 
         validates :name, presence: true, length: { minimum: 2, maximum: 20}, uniqueness: true

         has_many :posts, dependent: :destroy
         has_many :likes, dependent: :destroy
         has_many :liked_posts, through: :likes, source: :post # 自分がいいねした投稿一覧
         has_many :comments, dependent: :destroy

 end
