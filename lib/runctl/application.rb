#

module Runctl
  class Application < Sinatra::Application

    class Error < StandardError; end

    get '/' do
      full_render = !params['p']
      mab = Markaby::Builder.new

      dashboard_partial_proc = Proc.new {
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
      }

      if full_render
        mab.html5("lang" => "en") do
          mab.head do
            mab.title("runctl")
            mab.link("href" => "vanilla.css", "rel" => "stylesheet", "type" => "text/css")
            mab.script("src" => "morphdom-umd-2.5.10.js") {}
            mab.script("src" => "index.js") {}
          end

          mab.body(&dashboard_partial_proc)
        end
      else
        dashboard_partial_proc.call
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
