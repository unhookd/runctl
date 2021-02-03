#

module Runctl
  class Application < Sinatra::Application

    class Error < StandardError; end

    get '/' do
      full_render = !params['p']
      selected_container = params['c']

      mabb = Markaby::Builder.new

      dashboard_partial_proc = Proc.new { |mab, sc|
        mab.div do
          mab.a(:href => "?") do
            mab.h1 "runctl"
          end
          mab.ul do
            DataSource.instance.pods.each do |pod|
              mab.li do
                #mab.p pod.inspect
                if pod.status.conditions
                  last_sc = pod.status.conditions.sort_by { |c| c.lastTransitionTime }.last
                  mab.p "pod: #{pod.metadata.name} phase=#{pod.status.phase} #{last_sc.message}"

                  #mab.p pod.spec.containers.collect { |c| c.name }.inspect
                  ((pod.spec.initContainers ? pod.spec.initContainers.collect { |c| c.name } : []) + pod.spec.containers.collect { |c| c.name }).each { |container_name|

                  #output = DataSource.instance.ansi(DataSource.instance.logs(pod, last_sc.message))

                    mab.a("href" => "?c=#{container_name}") do
                      mab.p(container_name)
                    end

                    if sc == container_name
                      if full_render
                        #mab.div(:id => "jump")
                        mab.div.ooo do
                          mab.progress
                        end
                      else
                        output = DataSource.instance.ansi(DataSource.instance.logs(pod, container_name, last_sc.message))
                        if output && output.length > 0
                          mab.div.ooo do
                            mab.div.terminal do
                              mab.div(:class => "term-container") do
                                output
                              end
                            end
                          end
                        else
                          mab.pre do
                            pod.status.containerStatuses
                          end
                        end
                      end
                    end
                  }
                end
              end
            end
          end
        end

        #raw_output = IO.popen({"COLUMNS" => "80", "LINES" => "48"}, "top -b -n 1")
        #Process.wait rescue Errno::ECHILD

        #output = DataSource.instance.ansi(raw_output) 

        #mab.div.terminal do
        #  mab.div(:class => "term-container") do
        #    output
        #  end
        #end
      }

      if full_render
        mabb.html5("lang" => "en") do
          mabb.head do
            mabb.title("runctl")
            mabb.link("href" => "vanilla.css", "rel" => "stylesheet", "type" => "text/css")
            mabb.script("src" => "morphdom-umd-2.5.10.js") {}
            mabb.script("src" => "index.js") {}
          end

          mabb.body do
            mabb.div("id" => "dashboard-container") do
             #, &dashboard_partial_proc)
             dashboard_partial_proc.call(mabb, selected_container)
            end
          end
        end
      else
        dashboard_partial_proc.call(mabb, selected_container)
      end

      mabb.to_s
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
