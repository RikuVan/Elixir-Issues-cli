defmodule Issues.GithubIssues do
  @user_agent [{"User-agent", "richard.vancamp@gmail.com"}]
  @github_url Application.get_env(:issues, :github_url)
  require Logger

  def fetch(user, project) do
    Logger.info "Fetching user #{user}'s project: #{project}"
    issues_url(user, project)
     |> HTTPoison.get(@user_agent)
     |> handle_response
  end

  def issues_url(user, project) do
    "#{@github_url}/repos/#{user}/#{project}/issues"
  end

  alias Poison.Parser

  def handle_response({:ok, %{status_code: 200, body: body}}) do
    Logger.info "Successful response"
    {:ok, Parser.parse!(body)}
  end

  def handle_response({_, %{status_code: status, body: body}}) do
    Logger.error "Error code #{status} received"
    {:error, Parser.parse!(body)}
  end
end