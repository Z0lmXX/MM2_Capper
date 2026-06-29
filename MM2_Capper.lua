local Players = game:GetService("Players")

-- Put the username of the person you want to show the message to
local targetUsername = "Player1" 

Players.PlayerAdded:Connect(function(player)
    if player.Name == targetUsername then
        -- This creates the native error screen with a "Leave" button
        player:Kick("You have been banned from this game.")
    end
end)
