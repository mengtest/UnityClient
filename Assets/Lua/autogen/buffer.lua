
local shared_buffer = {0,0,0}
local offset
function shared_buffer.write_to_buffer(x)
        offset=offset+1
        shared_buffer[offset] = x
end

function shared_buffer.offset()
	return offset
end

function shared_buffer.move_offset(newoffset)
	offset = newoffset
end

return shared_buffer
