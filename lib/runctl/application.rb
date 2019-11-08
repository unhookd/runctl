#

module Runctl
  class Application < Sinatra::Application

    class Error < StandardError; end

    get '/' do
      mab = Markaby::Builder.new
      mab.div do
        mab.h1 "runctl"
        mab.span Time.now.to_s
        mab.ul do
          DataSource.instance.pods.each do |pod|
            mab.li do
              mab.p "namespace=#{pod.metadata.namespace} pod: #{pod.metadata.name} node=#{pod.spec.nodeName}"
              output = DataSource.instance.ansi(DataSource.instance.logs(pod.metadata.name))
              if output.length > 0
                mab.pre do
                  output
                end
              end
            end
          end
        end
      end
      mab.to_s
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
