defmodule Parent do

  def init(num1) do
    first = Enum.at(num1,0)
    last = Enum.at(num1,1)
    list_worker=Enum.chunk_every(first..last,10000)
    chil = Enum.map(list_worker, fn n ->

      Supervisor.child_spec({Child, n}, id: Enum.at(n,0))

  end )
    {:ok, pid} = Supervisor.start_link(chil, strategy: :one_for_one, name: My_Sup)
    IO.puts Supervisor.which_children(My_Sup) |> Enum.map(fn {_,pid,_,_} -> pid end) |> Enum.map(fn n -> GenServer.call(n,:view) end)
    |> List.flatten
    |> Enum.filter( & !is_nil(&1))
    |> Enum.sort
    |> Enum.join("\n")
    {:ok, pid}
  end
def output(pid) do
  GenServer.call(pid, :view)
end

end

defmodule Child do
  use GenServer

  def init(init_arg) do
    {:ok, init_arg}
  end

  def handle_cast(item, _list) do
    updated_list = input(item)
    {:noreply, updated_list}
  end

  def handle_call(:view, _from, list) do
    {:reply,list,nil}
  end


  @spec start_link(any) :: {:ok, pid}
  def start_link(num1) do
    {:ok, pid} = GenServer.start_link(__MODULE__, [])
    GenServer.cast(pid,num1)
    {:ok, pid}
  end


  @spec input(any) :: :ok
  def input(num1) do
    for n <- num1, do: getfangs(n)
  end

    def getfangs(number) do

        llist = []
        first = :math.pow(10,length(to_charlist(number))/2-1) |> round
        second =:math.sqrt(number)|> round
        j = facts_num(first,second, llist,number)
        k = List.flatten(Enum.map(j, fn n -> checkfactor(n,number) end) |> Enum.filter( & !is_nil(&1)))
        if k != [], do: "#{number} #{Enum.join(k, " ")}"


    end
    def facts_num(num1, num2, ll,number) do
        if num1>num2 do
            ll
        else
            fang = div(number,num2)
            ll = if fang*num2===number do
                    ll ++ [[fang,num2]]
            else
                ll
            end
            facts_num(num1,num2 - 1,ll,number)
        end
    end

    def checkfactor(fang,number) do
        [head|[tail]] = fang
        s1=length(to_charlist(head))
        s2=length(to_charlist(tail))
        if (s1==s2 && (rem(head,10) != 0 || rem(tail,10) !=0)), do: vampfactor(head,tail,number)

end

def vampfactor(fang,fang2,number) do

    if(Enum.sort(to_charlist(fang) ++ to_charlist(fang2)) == Enum.sort(to_charlist(number))) do
        [fang, fang2]
    end

end

end
