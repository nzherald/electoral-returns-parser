class DonationPresenter < BasePresenter
  def show
    default.merge({
      id: record.id,
      name: record.donor.name,
      candidate: record.candidate.name,
      amount: record.amount
    })
  end

  alias_method :index, :show

end
