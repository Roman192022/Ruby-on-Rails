# catalog.rb

require 'json'
require 'yaml'

# Ініціалізація каталогу
movies = {
  "Inception" => {
    directors: ["Christopher Nolan"],
    genres: ["Sci-Fi", "Action", "Thriller"],
    actors: ["Leonardo DiCaprio", "Elliot Page", "Tom Hardy"],
    year: 2010,
    rating: 8.8,
    watched: true
  },
  "The Shawshank Redemption" => {
    directors: ["Frank Darabont"],
    genres: ["Drama"],
    actors: ["Tim Robbins", "Morgan Freeman", "Bob Gunton"],
    year: 1994,
    rating: 9.3,
    watched: false
  }
}

# --- Збереження у файл ---
def save_to_json(movies, filename)
  File.write(filename, JSON.pretty_generate(movies))
  puts "Каталог збережено у #{filename} (JSON)"
end

def save_to_yaml(movies, filename)
  File.write(filename, movies.to_yaml)
  puts "Каталог збережено у #{filename} (YAML)"
end

# --- Завантаження з файлу ---
def load_from_json(filename)
  data = JSON.parse(File.read(filename))
  puts "Каталог завантажено з #{filename} (JSON)"
  # Перетворюємо ключі в символи
  data.transform_values do |movie|
    movie.transform_keys(&:to_sym)
  end
end

def load_from_yaml(filename)
  data = YAML.load_file(filename)
  puts "Каталог завантажено з #{filename} (YAML)"
  data
end

# --- Функціонал ---
def add_movie(movies)
  print "Назва фільму: "
  title = gets.chomp
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

  puts "Фільм '#{title}' додано!"
end

def edit_movie(movies)
  print "Введіть назву фільму для редагування: "
  title = gets.chomp
  if movies.key?(title)
    puts "Редагуємо фільм '#{title}'"
    add_movie(movies) # Проста реалізація — замінюємо повністю
  else
    puts "Фільм не знайдено."
  end
end

def delete_movie(movies)
  print "Введіть назву фільму для видалення: "
  title = gets.chomp
  if movies.delete(title)
    puts "Фільм '#{title}' видалено."
  else
    puts "Фільм не знайдено."
  end
end

def search_movie(movies)
  print "Введіть ключове слово для пошуку: "
  keyword = gets.chomp.downcase
  results = movies.select do |title, movie|
    title.downcase.include?(keyword) ||
    movie[:directors].any? { |d| d.downcase.include?(keyword) } ||
    movie[:genres].any? { |g| g.downcase.include?(keyword) } ||
    movie[:actors].any? { |a| a.downcase.include?(keyword) }
  end

  if results.empty?
    puts "Нічого не знайдено."
  else
    puts "Знайдені фільми:"
    results.each do |title, movie|
      puts "- #{title} (#{movie[:year]})"
    end
  end
end

# --- Головне меню ---
loop do
  puts "\n--- Каталог фільмів ---"
  puts "1. Додати фільм"
  puts "2. Редагувати фільм"
  puts "3. Видалити фільм"
  puts "4. Пошук фільмів"
  puts "5. Зберегти у JSON"
  puts "6. Завантажити з JSON"
  puts "7. Зберегти у YAML"
  puts "8. Завантажити з YAML"
  puts "9. Вихід"

  print "Вибір: "
  choice = gets.chomp.to_i

  case choice
  when 1 then add_movie(movies)
  when 2 then edit_movie(movies)
  when 3 then delete_movie(movies)
  when 4 then search_movie(movies)
  when 5 then save_to_json(movies, "movies.json")
  when 6 then movies = load_from_json("movies.json")
  when 7 then save_to_yaml(movies, "movies.yaml")
  when 8 then movies = load_from_yaml("movies.yaml")
  when 9 then break
  else puts "Невірний вибір."
  end
end
