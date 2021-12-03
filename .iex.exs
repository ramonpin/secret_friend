alias SecretFriend.API.SFList

SFList.new(:arq)
|> SFList.add_friend("Ramon")
|> SFList.add_friend("Luis")
|> SFList.add_friend("Maria")

IO.inspect(SFList.show(:arq))
IO.puts("Loaded...")
