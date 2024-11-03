getgenv().T3rrifer_lol = {
    ["Main"] = {
       ["Prediction"] = 0.16353,
       ["Partz"] = "UpperTorso",
       ["Air Delay"] = 0.148, -- // this is NOT an prediction, don't mess with it if you don't know how to.
       ["AutoPred"] = true,
       ["Dot"] = true,
       ["No Floor Shots"] = true,
       ["Pred Increase"] = true
    },
    ["Aim Assist"] = {
       ["Cam Enabled"] = true,
       ["Partz"] = "UpperTorso",
       ["Use Smoothness"] = true,
       ["Smoothness Value"] = 0.9
    },
    ["GUIs"] = {
       ["Save Position"] = true,
       ["Auto Air"] = true,
       ["Buy Items"] = true, -- // Only works on VFS games
       ["Reset"] = true,
       ["Leave"] = false,
       ["Trigger Bot"] = { false, delay = 5.5 }, -- // under maintenance
       ["Macro"] = { true, type = "Legit" } -- // Can be: "Legit" , "Speed" , "CFrame".
    }
}
 
loadstring(game:HttpGet("https://raw.githubusercontent.com/plah911/phyx/refs/heads/main/betaphyx"))();
