require 'test_helper'

class WordsControllerTest < ActionDispatch::IntegrationTest
  test "should get new" do
    get words_new_url
    assert_response :success
  end

end
