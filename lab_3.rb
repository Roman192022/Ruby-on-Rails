# movie_catalog_classes.rb

require 'json'
require 'yaml'

# --- Клас Movie ---
class Movie
  attr_accessor :title, :directors, :genres, :actors, :year, :rating, :watched

  def initialize(title, directors, genres, actors, year, rating, watched)
    @title = title
    @directors = directors
    @genres = genres
    @actors = actors
    @year = year
    @rating = rating
    @watched = watched
  end

  def to_hash
    {
      directors: @directors,
      genres: @genres,
      actors: @actors,
      year: @year,
      rating: @rating,
      watched: @watched
    }
  end

  def self.from_hash(title, hash)
    Movie.new(
      title,
      hash[:directors] || hash['directors'],
      hash[:genres] || hash['genres'],
      hash[:actors] || hash['actors'],
      hash[:year] || hash['year'],
      hash[:rating] || hash['rating'],
      hash[:watched] || hash['watched']
    )
  end
end

# --- Клас MovieCatalog ---
class MovieCatalog
  def initialize
    @movies = {}
  end

  def add_movie
    print "Назва фільму: "
    title = gets.chomp
    if @movies.key?(title)
      puts "⚠️ Такий фільм вже існує."
      return
    end

    movie = create_movie(title)
    @movies[title] = movie
    puts "✅ Фільм '#{title}' додано!"
  end

  def edit_movie
    print "Введіть назву фільму для редагування: "
    title = gets.chomp
    if @movies.key?(title)
      puts "Редагуємо фільм '#{title}'"
      @movies[title] = create_movie(title)
      puts "✅ Фільм '#{title}' оновлено!"
    else
      puts "⚠️ Фільм не знайдено."
    end
  end

  def delete_movie
    print "Введіть назву фільму для видалення: "
    title = gets.chomp
    if @movies.delete(title)
      puts "✅ Фільм '#{title}' видалено."
    else
      puts "⚠️ Фільм не знайдено."
    end
  end

  def list_movies
    if @movies.empty?
      puts "Каталог порожній."
    else
      puts "\n--- Усі фільми ---"
      @movies.each_value do |movie|
        puts "🎬 #{movie.title} (#{movie.year}) - рейтинг #{movie.rating}, переглянутий: #{movie.watched ? 'так' : 'ні'}"
      end
    end
  end

  def save_to_json(filename)
    data = @movies.transform_values(&:to_hash)
    File.write(filename, JSON.pretty_generate(data))
    puts "✅ Каталог збережено у #{filename} (JSON)"
  end

  def load_from_json(filename)
    data = JSON.parse(File.read(filename))
    @movies = data.transform_keys(&:to_s).transform_values do |movie_hash|
      Movie.from_hash(movie_hash['title'] || '', movie_hash)
    end
    puts "✅ Каталог завантажено з #{filename} (JSON)"
  end

  def save_to_yaml(filename)
    data = @movies.transform_values(&:to_hash)
    File.write(filename, data.to_yaml)
    puts "✅ Каталог збережено у #{filename} (YAML)"
  end

  def load_from_yaml(filename)
    data = YAML.load_file(filename)
    @movies = data.transform_keys(&:to_s).transform_values do |movie_hash|
      Movie.from_hash(movie_hash['title'] || '', movie_hash)
    end
    puts "✅ Каталог завантажено з #{filename} (YAML)"
  end

  private

  def create_movie(title)
    print "Режисери (через кому): "
    directors = gets.chomp.split(",").map(&:strip)
    print "Жанри (через кому): "
    genres = gets.chomp.split(",").map(&:strip)
    print "Актори (через кому): "
    actors = gets.chomp.split(",").map(&:strip)
    print "Рік: "
    year = gets.chomp.to_i
    print "Рейтинг: "
    rating = gets.chomp.to_f
    print "Переглянутий? (y/n): "
    watched = gets.chomp.downcase == 'y'

    Movie.new(title, directors, genres, actors, year, rating, watched)
  end
end

# --- Головне меню ---
catalog = MovieCatalog.new

loop do
  puts "\n=== Каталог фільмів ==="
  puts "1. Показати всі фільми"
  puts "2. Додати фільм"
  puts "3. Редагувати фільм"
  puts "4. Видалити фільм"
  puts "5. Зберегти у JSON"
  puts "6. Завантажити з JSON"
  puts "7. Зберегти у YAML"
  puts "8. Завантажити з YAML"
  puts "9. Вихід"

  print "Вибір: "
  choice = gets.chomp.to_i

  case choice
  when 1 then catalog.list_movies
  when 2 then catalog.add_movie
  when 3 then catalog.edit_movie
  when 4 then catalog.delete_movie
  when 5 then catalog.save_to_json("movies.json")
  when 6 then catalog.load_from_json("movies.json")
  when 7 then catalog.save_to_yaml("movies.yaml")
  when 8 then catalog.load_from_yaml("movies.yaml")
  when 9
    puts "👋 До побачення!"
    break
  else
    puts "⚠️ Невірний вибір."
  end
end
