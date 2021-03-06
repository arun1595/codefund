defmodule Metabase.Helpers do
  @spec dashboard_map(%CodeFund.Schema.User{}) :: map

  def dashboard_map(%CodeFund.Schema.User{roles: ["admin" | _roles]}),
    do: %{resource: %{dashboard: dashboard_role_mapping(:admin)}, params: %{}}

  def dashboard_map(%CodeFund.Schema.User{id: id, roles: ["sponsor" | _roles]}),
    do: %{resource: %{dashboard: dashboard_role_mapping(:sponsor)}, params: %{user_id: id}}

  def dashboard_map(%CodeFund.Schema.User{id: id}),
    do: %{resource: %{dashboard: dashboard_role_mapping(:user)}, params: %{user_id: id}}

  @spec dashboard_role_mapping(atom) :: integer
  defp dashboard_role_mapping(role),
    do: Application.get_env(:code_fund, :metabase_dashboard_mappings) |> Keyword.get(role)
end
