require 'open-uri'
require 'json'

puts "Limpando banco de dados..."
Movie.destroy_all

puts "Iniciando o download de 2000 filmes..."

# Configuração
api_key = '79c97ac3a63de8dbce3a68606997b091' # <--- COLE SUA CHAVE AQUI
base_url = "https://image.tmdb.org/t/p/original"
total_pages = 500 # 20 filmes por página * 100 páginas = 2000 filmes

(1..total_pages).each do |page|
  puts "Processando página #{page} de #{total_pages}..."

  url = "https://api.themoviedb.org/3/movie/top_rated?api_key=#{api_key}&language=en-US&page=#{page}"

  begin
    user_serialized = URI.open(url).read
    response = JSON.parse(user_serialized)
    movies = response['results']

    movies.each do |movie_data|
      # Pula se não tiver poster ou overview para evitar erros visuais
      next if movie_data['poster_path'].nil? || movie_data['overview'].empty?

      # Cria o filme apenas se ele ainda não existir (evita duplicatas)
      unless Movie.exists?(title: movie_data['original_title'])
        Movie.create!(
          title: movie_data['original_title'],
          overview: movie_data['overview'],
          poster_url: "#{base_url}#{movie_data['poster_path']}",
          rating: movie_data['vote_average']
        )
      end
    end
  rescue OpenURI::HTTPError => e
    puts "Erro na página #{page}: #{e.message}"
  end
end

puts "Concluído! #{Movie.count} filmes criados."
