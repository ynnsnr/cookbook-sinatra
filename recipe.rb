class Recipe
  attr_reader :name, :description, :prep_time, :difficulty, :done

  def initialize(name, description, prep_time, done = false, difficulty)
    @name = name
    @description = description
    @prep_time = prep_time
    @done = done == 'true'
    @difficulty = difficulty
  end

  def mark_as_done!
    @done = !@done
  end
end
