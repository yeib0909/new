-- Pure transformations for atomic DataStore session ownership.
local ProfileLease = {}
function ProfileLease.acquire(old, session, now)
    local profile = type(old) == "table" and table.clone(old) or {}
    local lease = profile._lease
    if type(lease) == "table" and lease.id ~= session and type(lease.expires) == "number" and lease.expires > now then return nil end
    profile._lease = {id = session, expires = now + 180}
    return profile
end
function ProfileLease.save(old, snapshot, session, now, release)
    if type(old) ~= "table" or type(old._lease) ~= "table" or old._lease.id ~= session then return nil end
    local profile = table.clone(snapshot)
    if not release then profile._lease = {id = session, expires = now + 180} end
    return profile
end
function ProfileLease.release(old, session)
    if type(old) ~= "table" or type(old._lease) ~= "table" or old._lease.id ~= session then return nil end
    local profile = table.clone(old)
    profile._lease = nil
    return profile
end
return ProfileLease
