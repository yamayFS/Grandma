local M = {}
M.maxLevels = 5
M.settings = {}
M.settings.currentLevel = 1
M.settings.unlockedLevels = 3
M.settings.soundOn = true
M.settings.musicOn = true
M.settings.levels = {} 
 
-- These lines are just here to pre-populate the table.
-- In reality, your app would likely create a level entry when each level is unlocked and the score/stars are saved.
-- Perhaps this happens at the end of your game level, or in a scene between game levels.
M.settings.levels[1] = {}
M.settings.levels[2] = {}
M.settings.levels[3] = {}


return M
