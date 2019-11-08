#

class DataSource
  include Singleton

  def initialize
    @client = K8s::Client.config(K8s::Config.load_file('~/.kube/kubeadm_config'))
  end

  def pods
    @client.api('v1').resource('pods', namespace: 'default').list
    #.each do |pod|
    #(labelSelector: {'role' => 'test'})
    #  puts "namespace=#{pod.metadata.namespace} pod: #{pod.metadata.name} node=#{pod.spec.nodeName}"
    #end
  end

  def logs(pod)
		all_log_output = ""
		@client.transport.get(
			['api', 'v1', 'namespaces', 'default', 'pods', pod, 'log'],
			query: {
				follow: '0'
			},
			response_block: lambda do |chunk, _, _|
				all_log_output << chunk
			end
		)
		all_log_output
	end

  def ansi(txt)
    aha_options = {:stdin_data => txt}
    #aha_cmd = ["aha", "--no-header", "-s", "-b", "-w"]
    #aha_cmd = ["cat"]
    aha_cmd = "bash bin/ansi2html.sh --bg=dark --palette=linux --body-only"
    r = silentx(aha_cmd, aha_options)
    r
  end

  def silentx(cmd, options)
    o, e, s = Open3.capture3(*cmd, options)
    s.success?
    return o
  end
end
