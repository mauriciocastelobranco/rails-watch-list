class MoviesController < ApplicationController
  def index
    # Começa com todos os filmes (mas não carrega a query ainda)
    @movies = Movie.all

    # Se o usuário digitou algo no campo de busca ('q')
    if params[:q].present?
      @movies = @movies.where("title ILIKE ?", "%#{params[:q]}%")
    end

    # Pega apenas os primeiros 10 para ser rápido
    @movies = @movies.limit(10)

    render json: @movies.map { |movie|
      {
        value: movie.id,       # O que será salvo no banco (movie_id)
        text: movie.title,     # O que aparece escrito no dropdown
        image: movie.poster_url # A URL da imagem (se tiver no seed)
      }
    }
  end
end
