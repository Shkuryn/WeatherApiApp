# Используем официальный образ Ruby с тегом, соответствующим вашей версии Ruby
FROM ruby:3.2.2

# Устанавливаем зависимости
RUN apt-get update -qq && apt-get install -y \
    build-essential \
    nodejs \
    sqlite3 \
    libsqlite3-dev

# Устанавливаем Bundler
RUN gem install bundler

# Создаем директорию для приложения и устанавливаем ее как директорию по умолчанию
RUN mkdir /myapp
WORKDIR /myapp

# Копируем Gemfile и Gemfile.lock в контейнер
COPY Gemfile Gemfile.lock ./

# Устанавливаем зависимости проекта
RUN bundle install

# Копируем все файлы приложения в контейнер
COPY . .

# Экспортируем порт, на котором работает приложение (если необходимо)
EXPOSE 3000

# Запускаем приложение (может отличаться в зависимости от способа запуска)
CMD ["rails", "server", "-b", "0.0.0.0"]
