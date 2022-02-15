defmodule EPS.TestConstants do
  @moduledoc """
  The Test constants are where all static
  values used in tests should be defined.
  """

  alias EPS.Orgs

  defmacro __using__(_opts) do
    quote do
      import EPS.TestConstants
      import EPS.DataFactory

      @integer_id 42
      @invalid_guid "fqu42078-187m-4f61-affa-d0f3900d01b2"
      @longer_than_255 "viverra ipsum nunc aliquet bibendum enim facilisis gravida neque convallis a cras semper auctor neqnunc pulvinar sapien et ligula ullamcorper malesuada proin libero nunc consequat interdum varius sit amet mattis vulputate enim nulla aliquet porttitor lacus"
      @test_file_path "test/support/test_file.exs"
      @test_file_path_sha256_hash "38a9321d1e24cd3f4c48fb07ccd7d79ee8da7b27e18312880b679804f936fd4c"
      @test_s3_file_name "test_file"
      @test_string "some_string"
      @test_string_sha256_hash "539a374ff43dce2e894fd4061aa545e6f7f5972d40ee9a1676901fb92125ffee"
      @too_long_id "very_very_very_very_very_long_id_that_should_not_be_accepted_I_mean_really_long"
      @uid "test.uid@1234567890.hotels.eps.com"
      @unauthenticated "unauthenticated"
      @unauthorized "unauthorized"
      @zip_file_url "https://file-examples-com.github.io/uploads/2017/02/zip_2MB.zip"
      @zip_file_url_sha256_hash "b76f59616f3d7b74413c471f5860ae338be25fe0140ee4d59118c953be8c8003"
    end
  end
end
