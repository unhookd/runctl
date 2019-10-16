#

module Runctl
  class Application < Sinatra::Application

    class Error < StandardError; end

    get '/' do
      #TODO: dashboard
    end

    get '/ztls' do
      #TODO: kubectl get ztls
    end

    post '/ztls' do
      #TODO: cat /var/tmp/ztls-from-params.yml | kubectl apply -f -
    end

    get '/deployments' do
      #TODO: helm list
    end

    post '/deployments' do
      #TODO: helm upgrade --install -f from-params.yml
    end

    get '/deployments/:release/:uuid' do
      #TODO: kubectl wait && kubectl logs
    end

    get '/deployments/:release' do
      #TODO helm history release
    end
  end
end
