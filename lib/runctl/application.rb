#

module Runctl
  class Application < Sinatra::Application

    class Error < StandardError; end

    get '/' do
      full_render = !params['p']
      selected_pod = params['pod']
      selected_container = params['c']

      if selected_pod && selected_pod.empty?
        selected_pod = nil
      end

      if selected_container && selected_container.empty?
        selected_container = nil
      end

      mabb = Markaby::Builder.new

      dashboard_partial_proc = Proc.new { |mab, sp, sc|
        mab.div do
          mab.a(:href => "?") do
            mab.h1 "runctl"
          end
          mab.ul do
            #mab.li do
            #  mab.a("href" => "?") do
            #    "kubectl top nodes"
            #  end

            #  raw_output = IO.popen("kubectl top nodes")
            #  Process.wait rescue Errno::ECHILD
            #  output = DataSource.instance.ansi(raw_output) 
            #  mab.div.terminal do
            #    mab.div(:class => "term-container") do
            #      output +
            #      "\n\n" + Time.now.to_s
            #    end
            #  end

            #  mab.a("href" => "?") do
            #    "kubectl top pods --containers=true"
            #  end

            #  raw_output = IO.popen("kubectl top pods --containers=true")
            #  Process.wait rescue Errno::ECHILD
            #  output = DataSource.instance.ansi(raw_output) 
            #  mab.div.terminal do
            #    mab.div(:class => "term-container") do
            #      output +
            #      "\n\n" + Time.now.to_s
            #    end
            #  end
            #end

            DataSource.instance.pods.each do |pod|
              if !sp
                mab.li do
                  mab.a("href" => "?pod=#{pod.metadata.name}") do
                    mab.em(pod.metadata.name)
                  end

                  last_sc = "n/a"
                  if pod.status.conditions
                    last_sc = pod.status.conditions.sort_by { |c| c.lastTransitionTime }.last
                  end

                  mab.p "pod: #{pod.metadata.name} phase=#{pod.status.phase} #{last_sc.message}"
                end
              else
                if !sc
                  mab.li do
                    mab.a("href" => "?pod=#{pod.metadata.name}") do
                      mab.em(pod.metadata.name)
                    end

                    if sp == pod.metadata.name
                      ((pod.spec.initContainers ? pod.spec.initContainers.collect { |c| c.name } : []) + pod.spec.containers.collect { |c| c.name }).each { |container_name|
                        mab.a("href" => "?pod=#{pod.metadata.name}&c=#{container_name}") do
                          mab.p(container_name)
                        end
                      }
                    end
                  end
                else
                  if sp == pod.metadata.name
                    mab.li do
                      mab.a("href" => "?pod=#{pod.metadata.name}") do
                        mab.em(pod.metadata.name)
                      end

                      if pod.status.conditions
                        last_sc = pod.status.conditions.sort_by { |c| c.lastTransitionTime }.last
                        
                        ((pod.spec.initContainers ? pod.spec.initContainers.collect { |c| c.name } : []) + pod.spec.containers.collect { |c| c.name }).each { |container_name|
                          if sc == container_name
                            mab.a("href" => "?pod=#{pod.metadata.name}&c=#{container_name}") do
                              mab.p(container_name)
                            end

                            if full_render
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
            end

            #raw_output = IO.popen({"COLUMNS" => "80", "LINES" => "48"}, "top -b -n 1")
            #Process.wait rescue Errno::ECHILD

            #output = DataSource.instance.ansi(raw_output) 

            #mab.div.terminal do
            #  mab.div(:class => "term-container") do
            #    output
            #  end
            #end

          end
        end
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
             dashboard_partial_proc.call(mabb, selected_pod, selected_container)
            end
          end
        end
      else
        dashboard_partial_proc.call(mabb, selected_pod, selected_container)
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
