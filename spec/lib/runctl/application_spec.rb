#

require "spec_helper"

describe Runctl::Application do
  it "has a index" do
    get "/"

    expect(last_response).to be_ok
  end

  it "can create deployments" do
    post "/deployments"

    expect(last_response).to be_ok
  end

  it "can fetch status of existing deployments" do
    uuid = SecureRandom.uuid

    get "/deployments/example-production/#{uuid}"

    expect(last_response).to be_ok
  end

  it "can fetch history of previous deployments" do
    get "/deployments/example-production"

    expect(last_response).to be_ok
  end
end
