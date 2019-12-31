# Script to delete all the data persisted in the database
#
#     mix run priv/repo/unseeds.exs

alias Nfl.Repo
alias Nfl.Entities.{Player, Team}
alias Nfl.Refs.Position
alias Nfl.Stats.Rushing

Repo.delete_all(Rushing)
Repo.delete_all(Player)
Repo.delete_all(Team)
Repo.delete_all(Position)
