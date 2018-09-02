defmodule Fsm do
  @enforce_keys [:rules]
  defstruct [:rules]

  @doc """
  Transforms rules keyword list to Fsm struct

  ## Examples
      iex> new(draft: [:signed, :rejected], rejected: [:draft], signed: [])
      %Fsm{rules: %{
        draft: %Fsm.Rule{transitions: [:signed, :rejected]},
        rejected: %Fsm.Rule{transitions: [:draft]},
        signed: %Fsm.Rule{transitions: []}
      }}
  """
  def new(opts) do
    rules =
      Enum.map(opts, fn {rule_name, transitions} ->
        {rule_name, %Fsm.Rule{transitions: transitions}}
      end)
      |> Map.new()

    %Fsm{rules: rules}
  end

  @doc """
  Transitions struct from one status to another

  ## Examples
      iex> fsm = %Fsm{rules: %{rejected: %Fsm.Rule{transitions: [:draft]}}}
      ...> transition!(%{status: "rejected"}, :draft, fsm)
      %{status: "draft"}
  """
  def transition!(%{status: status} = struct, transition, %Fsm{} = fsm)
      when is_atom(transition) do
    rule = get_rule_by_status(status, fsm)
    Fsm.Rule.transition!(struct, transition, rule)
  end

  @doc """
  Gets rule from status

  ##Examples
      iex> fsm = %Fsm{rules: %{draft: %Fsm.Rule{transitions: [:signed, :rejected]}}}
      ...> get_rule_by_status("draft", fsm)
      %Fsm.Rule{transitions: [:signed, :rejected]}
  """
  def get_rule_by_status(status, %Fsm{rules: rules}) when is_binary(status) do
    rule_name = String.to_existing_atom(status)
    Map.fetch!(rules, rule_name)
  end
end
