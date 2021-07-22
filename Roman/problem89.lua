local replacement = {
	['VIIII'] = 'IX',
	['IIII'] = 'IV',
	['LXXXX'] = 'XC',
	['XXXX'] = 'XL',
	['DCCCC'] = 'CM',
	['CCCC'] = 'CD',
}
local character_saved = 0

local roman = io.open('roman.txt', 'r')
local tmp_output = io.open('roman_out.tmp.txt', 'w')

for line in roman:lines() do
	for key, value in pairs(replacement) do
		shorted_line = line:gsub(key, value)
		if shorted_line ~= line then
			break
		end
	end

	if shorted_line ~= line then
		tmp_output:write(line .. '\t' .. shorted_line .. '\t' .. 'changed\n')
	else
		tmp_output:write(line .. '\t' .. shorted_line .. '\n')
	end

	local diff = string.len(line) - string.len(shorted_line)
	character_saved = character_saved + diff
end

roman:close()
tmp_output:close()


local output = io.open('roman_out.txt', 'w')
local tmp_output = io.open('roman_out.tmp.txt', 'r')



output:write('CHARACTER_SAVED = ' .. character_saved .. '\n\n')
output:write(tmp_output:read('*a'))


output:close()
tmp_output:close()

os.remove('roman_out.tmp.txt')