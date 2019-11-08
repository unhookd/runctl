#

module Runctl
  class Application < Sinatra::Application

    class Error < StandardError; end

    get '/' do
      mab = Markaby::Builder.new
      mab.div do
        mab.h1 "runctl"
        mab.ul do
          DataSource.instance.pods.each do |pod|
            mab.li do
              last_sc = pod.status.conditions.sort_by { |c| c.lastTransitionTime }.last
              mab.p "pod: #{pod.metadata.name} phase=#{pod.status.phase} #{last_sc.message}"
              output = DataSource.instance.ansi(DataSource.instance.logs(pod, last_sc.message))
              if output.length > 0
                mab.div.terminal do
                  mab.div(:class => "term-container") do
                    output
                  end
                end
              else
                mab.pre do
                  pod.status.containerStatuses
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
