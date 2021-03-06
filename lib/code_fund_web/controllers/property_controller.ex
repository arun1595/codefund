defmodule CodeFundWeb.PropertyController do
  use CodeFundWeb, :controller
  use Framework.Controller

  use Framework.Controller.Stub.Definitions, [:index, :show, :delete]
  plug(CodeFundWeb.Plugs.RequireAnyRole, roles: ["admin", "developer"])

  defconfig do
    [schema: "Property"]
  end

  defstub new do
    before_hook(&fields/2)
  end

  defstub create do
    inject_params(&CodeFundWeb.Hooks.Shared.join_to_user_id/2)
    |> error(&fields/2)
  end

  defstub edit do
    before_hook(&fields/2)
  end

  defstub update do
    before_hook(&fields/2)
  end

  defp fields(conn, _params) do
    fields = [
      name: [type: :text_input, label: "Name"],
      description: [type: :textarea, label: "Description", opts: [rows: 4]],
      url: [type: :text_input, label: "URL", opts: [placeholder: "https://"]],
      estimated_monthly_page_views: [
        type: :number_input,
        label: "Est. Monthly Page Views",
        opts: [
          hint: "How many page views (sessions) per month per Google Analytics?"
        ]
      ],
      estimated_monthly_visitors: [
        type: :number_input,
        label: "Est. Monthly Visitors",
        opts: [
          hint: "How many unique visitors (users) per month per Google Analytics?"
        ]
      ],
      language: [
        type: :select,
        label: "Primary Language",
        opts: [
          class: "form-control",
          choices: CodeFund.Properties.languages(),
          prompt: "Choose the primary language of the website?"
        ]
      ],
      programming_languages: [
        type: :multiple_select,
        label: "Programming Languages",
        opts: [
          class: "form-control selectize",
          choices: CodeFund.Properties.programming_languages(),
          hint: "Which programming languages are used or discussed on the website?"
        ]
      ],
      topic_categories: [
        type: :multiple_select,
        label: "Topic Categories",
        opts: [
          class: "form-control selectize",
          choices: CodeFund.Properties.topic_categories(),
          hint: "Which general topics apply to this website?"
        ]
      ]
    ]

    fields =
      case conn.assigns.current_user.roles |> CodeFund.Users.has_role?(["admin"]) do
        true -> Enum.concat(fields, admin_fields())
        false -> fields
      end

    [fields: fields]
  end

  defp admin_fields() do
    [
      status: [type: :select, label: "Status", opts: [choices: CodeFund.Properties.statuses()]],
      alexa_site_rank: [type: :number_input, label: "Alexa Ranking"],
      screenshot_url: [
        type: :text_input,
        label: "Screenshot URL",
        opts: [placeholder: "https://"]
      ]
    ]
  end
end
