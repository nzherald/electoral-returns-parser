module DonationRoutes
  extend self

  def included(base)
    Routes.index('/v1/donations.json', base)
    Routes.show('/v1/donations/:id.json', base)
  end

  module Routes
    extend self

    def index(path, base)
      base.get path do
        JSON.pretty_generate Donation.all.map { |c| c.as_json(:index) }
      end
    end

    def show(path, base)
      base.get path do
        begin
          record = Donation.find(params[:id])
        rescue ActiveRecord::RecordNotFound
          halt 404
        end
        JSON.pretty_generate record.as_json(:show)
      end
    end

  end
end
