defmodule BleacherReport.Cache do
  @moduledoc """
  Implementation for an in memory Cache used to keep a store a reactions to content.

  This is implemented as a GenServer process that acts as a wrapper to ETS. Which is where keep
  records of reactions.
  Reactions are stored in a map under a key (the content's UUID), each map contains reactions keyed under
  the time they occured.
  """
  @name :cache
  @cache_table :cache_table

  use GenServer

  ## Client

  @doc """
  This function accepts any term and at the moment discards it later down the line this can be used
  to prepopulate our cache.
  It then starts our GenServer with a name option an an empty map as state
  """
  @spec start_link(term()) :: {:ok, term()} | {:error, term()}
  def start_link(_opts) do
    GenServer.start_link(__MODULE__, %{}, name: @name)
  end

  @doc """
  This function accepts a term and a key to use when storing that term the key is expected to be of an atom type
  Parameters
  * `key` - atom value to use as key for the term to be stored
  * `term` - an elixir term to store under the key in the Cache
  """
  @spec put(atom(), term()) :: {:ok, tuple()} | {:error, term()}
  def put(key, value) do
    GenServer.call(@name, {:put, {key, value}})
  end

  @doc """
  This function collects the term stored with under the key if none is found it will return nil.
  """
  @spec get(atom()) :: term() | nil
  def get(key) do
    case :ets.lookup(@cache_table, key) do
      [{^key, value}] -> value
      [] -> nil
    end
  end

  @doc """
  Accepts a reaction and proceeds to remove that reaction from the reactions in a piece of content

  Parameters
  * `reaction` - A reaction that is to be removed from the content, note this needs to be a valid reaction structure
  containing both a user uuid and a content's uuid, later it makes sense to make this a struct when provied to the API
  """
  @spec remove(%{required(:content_id) => String.t(), required(:user_id) => String.t()}) :: {:ok, tuple()} | {:error, term()}
  def remove(%{content_id: c_id, user_id: u_id}) do
    GenServer.call(@name, {:remove, {c_id, u_id}})
  end


  @doc false
  def delete(key) do
    GenServer.call(@name, {:delete, {@cache_table, key}})
  end

  ## Server

  @doc """
  This function initializes our Cache process and starts an ETS table to hold keys we need
  Parameters
  * `ignored`
  """
  @spec init(term()) :: {:ok, term()}
  def init(_) do
    state = %{
      cache_table: :ets.new(@cache_table, [:named_table])
    }

    {:ok, state}
  end

  @doc """
  Callback to handle a client request to load some data into the Cache,
  this function will first check whether an item exists before trying to add a
  reaction and if it does exist it will add the reaction the list of reactions
  It's probably best to  make this implementation use a MapSet as that may completely avoid the issue of having duplicates
  """
  @spec handle_call(tuple(), pid(), map()) :: {:ok, term()} | {:error, term()}
  def handle_call({:put, {key, value}}, _from, state) do
    result =
      with nil <- get(key) do
        insert_item(key, value, [])
      else
        vals ->
          insert_item(key, value, vals)

        err -> {:error, err}
     end

    {:reply, result, state}
  end


  def handle_call({:delete, {table, key}}, _from, state) do
    result = :ets.delete(table, key)

    {:reply, {:ok, result}, state}
  end

  @doc false
  defp insert_item(key, new_item, items) do
    case :ets.insert(@cache_table, {key, [new_item | items]}) do
      true -> {:ok, {new_item.content_id, new_item}}
      err -> {:error, err}
    end
  end
end
