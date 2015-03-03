module DonorRoutes
  extend self

  def included(base)
    Routes.index('/v1/donors.json', base)
    Routes.show('/v1/donors/:id.json', base)
  end

  module Routes
    extend self

    def index(path, base)
      base.get path do
        JSON.pretty_generate Donor.all.map { |c| c.as_json(:index) }
      end
    end

    def show(path, base)
      base.get path do
        begin
          record = Donor.find_by(slug: params[:id])
        rescue ActiveRecord::RecordNotFound
          halt 404
        end
        JSON.pretty_generate record.as_json(:show)
      end
    end

  end
end
