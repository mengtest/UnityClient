local #NAME# = Class("#NAME#")
local instance = #NAME#()

function #NAME#.new() 
  error('Cannot instantiate from a #NAME# class') 
end

function #NAME#.extend() 
  error('Cannot extend from a #NAME# class')
end

function #NAME#.init() 
    
end

function #NAME#:getInstance()
  return instance
end

return #NAME#

