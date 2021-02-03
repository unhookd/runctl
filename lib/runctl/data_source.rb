#

class DataSource
  include Singleton

  def initialize
    @client = K8s::Client.config(K8s::Config.load_file('~/.kube/config'))
    #@client = K8s::Client.config(K8s::Config.load_file('~/.kube/kubeadm_config'))
    #@client = K8s::Client.in_cluster_config
  end

  def pods
    @client.api('v1').resource('pods', namespace: 'default').list.sort_by { |a|
      a.metadata.creationTimestamp
    }.reverse
    #.each do |pod|
    #(labelSelector: {'role' => 'test'})
    #  puts "namespace=#{pod.metadata.namespace} pod: #{pod.metadata.name} node=#{pod.spec.nodeName}"
    #end
  end

  def logs(pod, container, has_message)
    #puts [pod.metadata, pod.status]
    if (pod.status.phase == "Running" || pod.status.phase == "Succeeded") && has_message == nil
      all_log_output = ""
      @client.transport.get(
        ['api', 'v1', 'namespaces', 'default', 'pods', pod.metadata.name, 'log'],
        query: {
          follow: '0',
          container: container
        },
        response_block: lambda do |chunk, _, _|
          all_log_output << chunk
        end
      )
      all_log_output
    end
	end

  def ansi(txt)
    if txt
      aha_options = {:stdin_data => txt}
      #aha_cmd = ["aha", "--no-header", "-s", "-b", "-w"]
      ##aha_cmd = ["cat"]
      #aha_cmd = "bash bin/ansi2html.sh --bg=dark --palette=linux --body-only"
      aha_cmd = ["vendor/bin/terminal-to-html-3.3.0-linux-amd64"]
      r = silentx(aha_cmd, aha_options)
      r || ""
    end
  end

  def silentx(cmd, options)
    o, e, s = Open3.capture3(*cmd, options)
    if s
      s.success?
    end
    return o || ""
  end
end
