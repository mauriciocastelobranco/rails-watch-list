class ListsController < ApplicationController

  def index
    @lists = List.all
  end

  def show
  @list = List.find(params[:id])
  @movies = Movie.all
  end

  def new
    @list = List.new
  end

  def create
     @list = List.new(list_params)
    if @list.save
      redirect_to @list, notice: "List was successfully created."
    else
      render :new, status: :unprocessable_entity
    end
  end

  private

  def set_list
    @list = List.find(params[:id])
  end

  def list_params
    # AQUI ESTÁ A MÁGICA:
    # 1. require(:list) -> exige que os dados venham dentro da chave 'list'
    # 2. permit(:name, :address, ...) -> lista APENAS os campos que podem ser salvos
    params.require(:list).permit(:name, :image_url)
  end
end
