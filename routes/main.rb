class Carpool
  get '/' do
    locals = {
      events: Event.all
    }

    slim :home, locals: locals
  end

  get '/event' do
    slim :create_event
  end

  get '/event/:event_id' do
    locals = {
      event: Event.find_by(event_id: params[:event_id]),
      drivers: Driver.where(event_id: params[:event_id]),
      riders: Rider.where(event_id: params[:event_id])
    }
    slim :info, locals: locals
  end

  get '/event/:event_id/drive' do
    locals = {
      event: Event.find_by(event_id: params[:event_id])
    }
    slim :drive, locals: locals
  end

  get '/event/:event_id/ride' do
    locals = {
      event: Event.find_by(event_id: params[:event_id])
    }
    slim :ride, locals: locals
  end

  get '/event/:event_id/carpool' do
    event = Event.find_by(event_id: params[:event_id])
    locals = {
      event: event,
      cars: event.assign
    }
    slim :assign, locals: locals
  end

  post '/event' do
    Event.create({
      name: params[:event_name]
    })

    redirect '/'
  end

  post '/event/:event_id/drive' do
    event = Event.find_by(event_id: params[:event_id])

    event.drive(params[:driver_name], params[:num_seats], params[:group_size], params[:leaving])

    redirect '/'
  end

  post '/event/:event_id/ride' do
    event = Event.find_by(event_id: params[:event_id])

    event.ride(params[:rider_name], params[:group_size], params[:leaving])

    redirect '/'
  end
end
