class DonorPresenter < BasePresenter
  def index
    default.merge({
      total: record.total_donations,
      candidates: record.donations_list
    })
  end

  alias_method :show, :index

  def default
    {
      id: record.slug,
      name: record.name
    }
  end
end
