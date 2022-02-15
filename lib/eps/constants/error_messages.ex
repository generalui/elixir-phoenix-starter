defmodule EPS.Constants.ErrorMessages do
  @moduledoc """
  The ErrorMessages constants are where all error message
  values should be defined.
  """

  def email_not_in_database(email) do
    "User email '#{email}' not in database."
  end

  defmacro __using__(_opts) do
    quote do
      import EPS.Constants.ErrorMessages

      @already_deleted "Already deleted"
      @bad_request "Bad Request"
      @created "Successfully Created"
      @deleted_successfully "Deleted successfully"
      @email_required "An email address is required"
      @error_creating_user "There was an error creating the user"
      @expired_jwt "JWT has expired"
      @forbidden "Forbidden"
      @internal_server_error "Internal Server Error"
      @invalid_alert_source "Invalid Alert Source."
      @invalid_jwt "Invalid JWT."
      @invalid_user "Invalid User."
      @invalid_values_no_delete "Invalid values passed, nothing deleted"
      @email_already_used "That email is already associated with another person."
      @link_already_used "That link is already being used."
      @logged_out "You have been logged out."
      @no_content "No content"
      @no_values_passed "No values passed"
      @page_not_found "Page not found"
      @passwords_not_match "Passwords do not match"
      @password_required "Password Required"
      @successfully_authenticated "Successfully authenticated."
      @unprocessable_entity "Unprocessable entity"
    end
  end
end
