@raw_text = 'Дом Наркомфина — один из знаковых памятников архитектуры советского авангарда и конструктивизма. Построен в 1928—1930 годах по проекту архитекторов Моисея Гинзбурга, Игнатия Милиниса и инженера Сергея Прохорова для работников Народного комиссариата финансов СССР (Наркомфина). Автор замысла дома Наркомфина Гинзбург определял его как «опытный дом переходного типа». Дом находится в Москве по адресу: Новинский бульвар, дом 25, корпус 1. С начала 1990-х годов дом находился в аварийном состоянии, был трижды включён в список «100 главных зданий мира, которым грозит уничтожение». В 2017—2020 годах отреставрирован по проекту АБ «Гинзбург Архитектс», функционирует как элитный жилой дом. Отдельно стоящий «Коммунальный блок» (историческое название) планируется как место проведения публичных мероприятий.'
@words = @raw_text.downcase.gsub(/[—.—,«»:()]/, '').gsub(/  /, ' ').split(' ')

def seed
  reset_db
  create_admin
  create_users
  create_pins(100)
  create_comments(2..8)
end

def reset_db
  Rake::Task['db:drop'].invoke
  Rake::Task['db:create'].invoke
  Rake::Task['db:migrate'].invoke
end

def create_admin
  user_data = {
    email: "admin@email.com",
    password: 'testtest',
    admin: true
  }

  user = User.create!(user_data)
  puts "Admin created with id #{user.id}"
end

def create_users
  i = 0

  10.times do
    user_data = {
      email: "user_#{i}@email.com",
      password: 'testtest'
    }

    # if i == 0
    #   user_data[:email] = "admin@email.com"
    #   user_data[:admin] = true
    # end

    user = User.create!(user_data)
    puts "User created with id #{user.id}"

    i += 1
  end
end

def create_sentence
  sentence_words = []

  (10..20).to_a.sample.times do
    sentence_words << @words.sample
  end

  sentence = sentence_words.join(' ').capitalize + '.'
end

def upload_random_image
  uploader = PinImageUploader.new(Pin.new, :pin_image)
  uploader.cache!(File.open(Dir.glob(File.join(Rails.root, 'public/autoupload/pins', '*')).sample))
  uploader
end

def create_pins(quantity)
  quantity.times do
    user = User.all.sample
    pin = Pin.create(title: create_sentence, description: create_sentence, pin_image: upload_random_image, user_id: user.id)
    puts "Pin with id #{pin.id} just created"
  end
end

def create_comments(quantity)
  Pin.all.each do |pin|
    quantity.to_a.sample.times do
      user = User.all.sample
      comment = Comment.create(pin_id: pin.id, body: create_sentence, user_id: user.id)
      puts "Comment with id #{comment.id} for pin with id #{comment.pin.id} just created"
    end
  end
end

seed