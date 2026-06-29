local GuiService = game:GetService("GuiService")
local Players = game:GetService("Players")

-- Wait for the game to load fully before showing the error
if not game:IsLoaded() then
    game.Loaded:Wait()
end

-- We use a slight delay so the player actually spawns in right before it hits
task.wait(1)

-- This forces Roblox to display the official connection error prompt
-- The text will display your custom ban message, and the button will exit the game
GuiService:SetErrorMessageGuiType(Enum.ErrorMessageGuiType.Default)
Players.LocalPlayer:Kick("You have been banned from this game.")
