costomQueue = require('List')

function fileToTable(file) --converts maze file to table
	local lines = {}
	for line in file:lines() do
		table.insert(lines, line)
	end
	return lines
end

function tableToMatrix(mazeTable) -- converts maze table to matrix
	local matrix = {}
	for i=1, #mazeTable do
		matrix[i] = {}
		mazeTable[i]:gsub('.', function(c) table.insert(matrix[i], c) end)
	end
	return matrix
end

function countRowsColumns(matrix) -- counts rows and columns of the matrix
	return #matrix, #matrix[1]
end

function tableContains(ttable, key) -- checks if table contains the key
	return ttable[key] ~= nil
end

function isNotWall(point) -- checks if the point is the part of the wall
	if point == ' ' or point == 'I' or point == 'E' then
		return true
	else
		return false
	end
end

function checkNextNode(x, y) -- checks if we can go in the next node
	if 1 <= x and x <= columns and 1 <= y and y <= rows and isNotWall(mazeMatrix[y][x]) then
		return true
	else
		return false
	end
end


function getNextNodes(x, y) -- returns array of neighbours 
	local ways = {
		{-1, 0},
		{0, -1},
		{1, 0},
		{0, 1}
	}
	local next_nodes = {}
	for _, way in pairs(ways) do
		if checkNextNode(x+way[1], y+way[2]) then
			table.insert(next_nodes, x+way[1]..';'..y+way[2])
		end
	end
	return next_nodes
end

function getStartFinishCoords(matrix) --returns start and finish coordinates
	for y=1, rows do
		for x=1, columns do
			if matrix[y][x] == 'I' then
				start = x..';'..y
			elseif matrix[y][x] == 'E' then
				finish = x..';'..y
			end
		end
	end
	return start, finish
end

function bfs(start, finish, graph) -- Breadth-first search algorithm
	local queue = costomQueue.new()

	costomQueue.pushright(queue, start)
	local visited = {[start]=false}
	while true do
		cur_node = costomQueue.popleft(queue)

		if not cur_node then 
			break
		end
		if cur_node == finish then
			break
		end

		next_nodes = graph[cur_node]
		for _, node in pairs(next_nodes) do
			if not tableContains(visited, node) then
				costomQueue.pushright(queue, node)
				visited[node] = cur_node

			end
		end
	end
	return queue, visited
end


local mazeFile = io.open('Maze.txt', 'r')
local mazeTable = fileToTable(mazeFile)
mazeFile:close()
mazeMatrix = tableToMatrix(mazeTable)

-- creating a graph of the Maze
local graph = {}
rows, columns = countRowsColumns(mazeMatrix)

for y=1, rows do
	for x=1, columns do
		if isNotWall(mazeMatrix[y][x]) then

			next_nodes = getNextNodes(x, y)

			local point = x..';'..y

			if tableContains(graph, point) then
				for _, node in pairs(next_nodes) do
					table.insert(graph[point], node)
				end
			else
				graph[point] = next_nodes
			end					
		end
	end
end


local start, finish = getStartFinishCoords(mazeMatrix)
local queue, visited = bfs(start, finish, graph)

-- finding the shortest path
local path = {}
path_head, path_segment = finish, finish
while true do
	if not tableContains(visited, path_segment) then
		break
	end

	table.insert(path, path_segment)
	path_segment = visited[path_segment]
end

--printing Mazes
print('Maze: ')
for i=1, #mazeMatrix do
	for j=1, #mazeMatrix[i] do
		io.write(mazeMatrix[i][j])
	end
	io.write('\n')
end
print('\n')

local mazePathMatrix = {}
for key, value in pairs(mazeMatrix) do
	mazePathMatrix[key] = value
end

pathCoords = {}
for i=1, #path do
	for x, y in string.gmatch(path[i], '(%w+);(%w+)') do
		table.insert(pathCoords, {tonumber(x), tonumber(y)})
	end
end

for k, v in pairs(pathCoords) do
	mazePathMatrix[v[2]][v[1]] = '@'
end

print('Path: ')
for i=1, #mazePathMatrix do
	for j=1, #mazePathMatrix[i] do
		io.write(mazePathMatrix[i][j])
	end
	io.write('\n')
end

