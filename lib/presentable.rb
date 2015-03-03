module Presentable
  def presenter
    Object.const_get("#{self.class.name}Presenter").new(self)
  end

  def as_json(presenter_type = :default)
    presenter.public_send(presenter_type)
  end
end
