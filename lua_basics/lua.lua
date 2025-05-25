print("Hello world")
local x = 10
local y = 10
print(x + y)

local function println(string)
  print(string)
end

println("Welcome")

local t = { 1, 2, 3 }
print(t[1])
if x > 10 then
  println("a more than 10")
end

local i = 10
while i >= 1 do
  print(i)
  i = i - 1
end

for i = 1, 5 do
  print(i)
end

for j, v in ipairs(t) do
  print(i, v)
end
