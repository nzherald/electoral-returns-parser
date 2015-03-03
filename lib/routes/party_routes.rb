module PartyRoutes
  extend self

  def included(base)
    Routes.index('/v1/parties.json', base)
    Routes.show('/v1/parties/:id.json', base)
  end

  module Routes
    extend self

    def index(path, base)
      base.get path do
        JSON.pretty_generate Party.all.map { |c| c.as_json(:index) }
      end
    end

    def show(path, base)
      base.get path do
        begin
          record = Party.find_by(slug: params[:id])
        rescue ActiveRecord::RecordNotFound
          halt 404
        end
        JSON.pretty_generate record.as_json(:show)
      end
    end

  end
end
