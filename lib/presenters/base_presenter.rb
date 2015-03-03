class BasePresenter
  attr_reader :record

  def initialize(model)
    @record = model
  end

  def default
    {}
  end
end
