alias SecretFriend.API.SFList
alias SecretFriend.API.User

arq = SFList.new(:arq)

User.new("Juan", :juan)
User.new("Luis", :luis)
User.new("Maria", :maria)

User.add_me_to(:juan, :arq)
User.add_me_to(:luis, :arq)
User.add_me_to(:maria, :arq)

:timer.sleep(1000)
IO.inspect(SFList.show(:arq))
IO.puts("Loaded...")
