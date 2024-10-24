# defmodule TimeManagerApi.Mailer do
#   use Bamboo.Mailer, otp_app: :time_manager_api
#   import Bamboo.Email

#   def send_welcome_email(user) do
#     new_email()
#     |> to(user.email)
#     |> from("no-reply@gothimemanager.com")
#     |> subject("Welcome to GoThime Manager")
#     |> html_body("""
#       <h1>Hello #{user.username},</h1>
#       <p>Your account has been created successfully. Below are your login credentials:</p>
#       <p><b>Username:</b> #{user.email}</p>
#       <p><b>Password:</b> #{user.password}</p>
#       <p>Thank you for joining us!</p>
#     """)
#     |> deliver_now()
#   end
# end
