defmodule Fsm.Rule do
  @enforce_keys [:transitions]
  defstruct [:transitions]

  @doc """
  Transitions struct from one status to another using specified rule

  ## Examples
      iex> rule = %Fsm.Rule{transitions: [:draft]}
      ...> transition!(%{status: "rejected"}, :draft, rule)
      %{status: "draft"}

      iex> rule = %Fsm.Rule{transitions: [:draft]}
      ...> transition!(%{status: "rejected"}, :signed, rule)
      ** (RuntimeError) Transition from 'rejected' to 'signed' is not allowed
  """
  def transition!(%{status: status} = struct, transition, %Fsm.Rule{transitions: transitions})
      when is_atom(transition) do
    if transition in transitions do
      %{struct | status: Atom.to_string(transition)}
    else
      raise "Transition from '#{status}' to '#{transition}' is not allowed"
    end
  end
end
