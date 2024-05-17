local function print_hex(data)
  for i = 1, #data do
    local char = string.sub(data, i, i)
    io.write(string.format("%02x", string.byte(char)) .. " ")
  end
end

local function is_empty(s)
  return s == nil or s == ''
end

local function write_to_file(name, content)
  local curl = require("plenary.curl")
  local response = curl.get("http://localhost:8080/png/SyfFKj2rKt3CoKnELR1Io4ZDoSa70000")
  vim.notify(response.status, 'info')
  -- local file, err = io.open(name)
  -- if file then
  --   file:write(response.body)
  --   file:close()
  -- else
  --   vim.notify("Oops, error during saving PlantUML in file", "error") -- not so hard?
  -- end
end


local function buf_contents_to_hex()
  local contents = vim.api.nvim_buf_get_lines(vim.api.nvim_get_current_buf(), 0, -1, true)

  local contents_hex = ""

  for i = 1, #contents do
    local hex = print_hex(contents[i])

    if not is_empty(hex) then
      contents_hex = contents_hex .. hex
    end
  end

  return contents_hex
end

vim.api.nvim_buf_create_user_command(
  0,
  "PlantUMLTest",
  function()
    -- vim.notify('Hello', 'info')
    local contents = buf_contents_to_hex()

    -- write_to_file("plantumlhex.txt", contents)
  end,
  { nargs = 0 }
)