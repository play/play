require File.expand_path("../../helper", __FILE__)

context "Site" do
  setup do
  end

  test "/" do
    get "/"

    assert last_response.ok?
    assert last_response.body.include?('dat play')
  end
end