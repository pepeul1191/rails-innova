class MessagesController < ApplicationController
  layout "application"
  # Validar antes de mostrar las vistas de site

  def index
    @link = '/messages'
  end

  def recipients
    url_chat = ENV['URL_CHAT_SERVICE']
    x_auth_chat = ENV['X_AUTH_CHAT_SERVICE']
    response = HTTParty.get(
      "#{url_chat}api/v1/users/#{session[:user]['uid']}/conversations",
      headers: {
        'Content-Type' => 'application/json',
        'Accept' => 'application/json',
        'X-Auth-Trigger' => x_auth_chat
      }
    )
    #puts 'chat_token'
    conversations_json = JSON.parse(response.body)
    # [{"_id"=>"688431bd82ba5438fcb5c388", "user_ids"=>["111087613070225952629", "1"], "last_message"=>{"sender_id"=>"111087613070225952629", "content"=>"aaaaaaaaaaaaaaaaaaaaaaaaaaaaa", "created"=>"25/07/2025 08:52:18 PM"}}...]

    conversations = []
    puts 'A +++++++++++++++++++++++++++++++++'
    puts "#{url_chat}api/v1/users/#{session[:user]['uid']}/conversations"
    puts session[:user]
    conversations_json.each do |conversation|
      puts conversation
      conversation['user_ids'].delete(session[:user]['uid'])
      puts conversation['user_ids']
      puts 'C +++++++++++++++++++++++++++++++++++'
      receiver_id = conversation['user_ids'][0]
      sql = <<-SQL
        SELECT * FROM (
          SELECT google_id, full_name, image_url FROM students
          UNION
          SELECT google_id, full_name, image_url FROM mentors
        ) AS users
        WHERE google_id = #{receiver_id}
      SQL
    
      result = ActiveRecord::Base.connection.select_all(sql).to_a
      puts '1 ++++++++++++++++++++++++++++++++++++'
      puts result
      puts '2 ++++++++++++++++++++++++++++++++++++'
      if result 
        tmp = {}
        tmp['name'] = result[0]['full_name']
        puts 'A ++++++++++++++++++++++++++++++++++++'
        tmp['image_url'] = result[0]['image_url']
        puts 'B ++++++++++++++++++++++++++++++++++++'
        tmp['last_message'] = conversation['last_message']
        puts '3 ++++++++++++++++++++++++++++++++++++'
        tmp['recipent_id'] = receiver_id     
        conversations.push(tmp)
      end
    end

    render json: conversations
  end
end