class DonorPresenter < BasePresenter
  def index
    default.merge({
      total: record.total_donations,
      candidates: record.donations_list
    })
  end

  alias_method :show, :index

  def treemap
    {
      name: record.name,
      children: record.donations.map do |c|
        {
          name: c.candidate.name,
          value: c.amount
        }
      end
    }
  end

  def default
    {
      id: record.slug,
      name: record.name
    }
  end
end
