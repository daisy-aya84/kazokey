require 'bundler/setup'
Bundler.require

if development?
	ActiveRecord::Base.establish_connection("sqlite3:db/development.db")
end

class User < ActiveRecord::Base
    has_many :group_users
    has_many :groups, through: :group_users
    has_many :user_tasks
    has_many :tasks, through: :user_tasks
    
    has_secure_password
    validates :name,
        presence: true,
        format: { with: /\A\w+\z/ }
    validates :password,
    length: { in: 5..10 }
end

class GroupUser < ActiveRecord::Base
    belongs_to :user
    belongs_to :group
end

class Group < ActiveRecord::Base
    has_many :group_users
    has_many :users, through: :group_users 
    has_many :tasks
end

class Task < ActiveRecord::Base
    belongs_to :group
    has_many :user_tasks
    has_many :users, through: :user_tasks
end

class UserTask < ActiveRecord::Base
   belongs_to :task
   belongs_to :user
end

# class モデル < ActiveRecord::Base
    
# end