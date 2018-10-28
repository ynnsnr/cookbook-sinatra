require 'csv'

class Cookbook
  def initialize(csv_file_path)
    @csv_file_path = csv_file_path
    @recipes_list = []
    load_csv
  end

  def all
    @recipes_list
  end

  def add_recipe(recipe)
    @recipes_list << recipe
    save_csv
  end

  def remove_recipe(recipe_index)
    @recipes_list.delete_at(recipe_index)
    save_csv
  end

  def mark_as_done(index)
    recipe = @recipes_list[index]
    recipe.mark_as_done!
    save_csv
  end

  private

  def load_csv
    CSV.foreach(@csv_file_path) do |row|
      @recipes_list << Recipe.new(row[0], row[1], row[2], row[3], row[4])
    end
  end

  def save_csv
    CSV.open(@csv_file_path, 'wb') do |csv|
      @recipes_list.each do |recipe|
        csv << [recipe.name, recipe.description, recipe.prep_time, recipe.done, recipe.difficulty]
      end
    end
  end
end
