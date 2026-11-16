-- Pure progression and daily reward rules; the server owns the profile.
local Progress = {}
function Progress.day(now)
    return math.floor(now / 86400)
end
function Progress.refresh(d, now)
    local day = Progress.day(now)
    if d.dailyDay ~= day then
        d.dailyDay, d.dailyRounds, d.dailyClaimed, d.missionClaimed = day, 0, false, false
    end
end
function Progress.level(xp)
    return math.floor(xp / 100) + 1
end
function Progress.finishRound(d, won, now)
    Progress.refresh(d, now)
    d.rounds += 1
    if won then d.wins += 1 end
    d.xp += won and 35 or 20
    d.dailyRounds += 1
end
function Progress.claimDaily(d, now, amount)
    Progress.refresh(d, now)
    if d.dailyClaimed then return false end
    d.dailyClaimed = true
    d.coins += amount
    return true
end
function Progress.claimMission(d, now, required, amount)
    Progress.refresh(d, now)
    if d.missionClaimed or d.dailyRounds < required then return false end
    d.missionClaimed = true
    d.coins += amount
    return true
end
return Progress
