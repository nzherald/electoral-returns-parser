class ElectoratePresenter < BasePresenter
  def index
    default.merge({
      total: record.candidates.map(&:donation_amounts).flatten.sum,
      candidates: record.candidates.map { |c| c.as_json(:default) }
    })
  end

  def default
    {
      id: record.slug,
      name: record.name
    }
  end
end
