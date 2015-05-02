class McasResult < ActiveRecord::Base
  belongs_to :student

  def growth_warning_level
    34
  end
 
  def performance_warning_level
    ["W"] 
  end

  # Warning flags for variables in roster view

  def math_performance_warning?
    if math_performance.present?
      performance_warning_level.include? math_performance
    end
  end

  def ela_performance_warning?
    if ela_performance.present?
      performance_warning_level.include? ela_performance
    end
  end

  def math_growth_warning?
    if math_growth.present?
      math_growth < growth_warning_level
    end
  end

  def ela_growth_warning?
    if ela_growth.present?
      ela_growth < growth_warning_level
    end
  end

  def warning?
    math_performance_warning? || ela_performance_warning?
  end

end
