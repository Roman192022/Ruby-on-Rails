# movies_crud.rb

require 'json'
require 'yaml'

# Ініціалізація каталогу
movies = {}

# --- Збереження у файл ---
def save_to_json(movies, filename)
  File.write(filename, JSON.pretty_generate(movies))
  puts "✅ Каталог збережено у #{filename} (JSON)"
end

def save_to_yaml(movies, filename)
  File.write(filename, movies.to_yaml)
  puts "✅ Каталог збережено у #{filename} (YAML)"
end

# --- Завантаження з файлу ---
def load_from_json(filename)
  data = JSON.parse(File.read(filename))
  puts "✅ Каталог завантажено з #{filename} (JSON)"
  # Перетворюємо ключі в символи
  data.transform_values do |movie|
    movie.transform_keys(&:to_sym)
  end
end

def load_from_yaml(filename)
  data = YAML.load_file(filename)
  puts "✅ Каталог завантажено з #{filename} (YAML)"
  data
end

# --- CRUD Операції ---

# CREATE
def add_movie(movies)
  print "Назва фільму: "
  title = gets.chomp
  if movies.key?(title)
    puts "⚠️ Такий фільм вже існує."
    return
  end

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

  movies[title] = {
    directors: directors,
    genres: genres,
    actors: actors,
    year: year,
    rating: rating,
    watched: watched
  }

  puts "✅ Фільм '#{title}' додано!"
end

# READ (показати всі фільми)
def list_movies(movies)
  if movies.empty?
    puts "Каталог порожній."
  else
    puts "\n--- Усі фільми ---"
    movies.each do |title, movie|
      puts "🎬 #{title} (#{movie[:year]}) - рейтинг #{movie[:rating]}, переглянутий: #{movie[:watched] ? 'так' : 'ні'}"
    end
  end
end

# UPDATE
def edit_movie(movies)
  print "Введіть назву фільму для редагування: "
  title = gets.chomp
  if movies.key?(title)
    puts "Редагуємо фільм '#{title}'"
    print "Нові режисери (через кому): "
    movies[title][:directors] = gets.chomp.split(",").map(&:strip)
    print "Нові жанри (через кому): "
    movies[title][:genres] = gets.chomp.split(",").map(&:strip)
    print "Нові актори (через кому): "
    movies[title][:actors] = gets.chomp.split(",").map(&:strip)
    print "Новий рік: "
    movies[title][:year] = gets.chomp.to_i
    print "Новий рейтинг: "
    movies[title][:rating] = gets.chomp.to_f
    print "Переглянутий? (y/n): "
    movies[title][:watched] = gets.chomp.downcase == 'y'

    puts "✅ Фільм '#{title}' оновлено!"
  else
    puts "⚠️ Фільм не знайдено."
  end
end

# DELETE
def delete_movie(movies)
  print "Введіть назву фільму для видалення: "
  title = gets.chomp
  if movies.delete(title)
    puts "✅ Фільм '#{title}' видалено."
  else
    puts "⚠️ Фільм не знайдено."
  end
end

# --- Головне меню ---
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
  when 1 then list_movies(movies)
  when 2 then add_movie(movies)
  when 3 then edit_movie(movies)
  when 4 then delete_movie(movies)
  when 5 then save_to_json(movies, "movies.json")
  when 6 then movies = load_from_json("movies.json")
  when 7 then save_to_yaml(movies, "movies.yaml")
  when 8 then movies = load_from_yaml("movies.yaml")
  when 9
    puts "👋 До побачення!"
    break
  else
    puts "⚠️ Невірний вибір."
  end
end
