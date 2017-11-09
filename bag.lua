local Bag = {}
Bag.__index = Bag

function Bag:new(item, ...)
  local mt = {
    items = {},
    _size = 0
  }
  local bag = setmetatable(mt, Bag)
  if item then bag:insert(item, ...) end
  return bag
end

function Bag:copy()
  local bag = setmetatable({items = {}}, Bag)
  for k, v in pairs(self.items) do
    bag.items[k] = v
  end
  bag._size = self._size
  return bag
end

function Bag:clear()
  self.items = {}
  self._size = 0
  return self
end

function Bag:insert(item, item2, ...)
  if not self.items[item] then
    self.items[item] = true
    self._size = self._size + 1
  end
  if item2 then self:insert(item2, ...) end
  return self
end

function Bag:remove(item, item2, ...)
  if self.items[item] then
    self.items[item] = nil
    self._size = self._size - 1
  end
  if item2 then self:remove(item2, ...) end
  return self
end

function Bag:toggle(item, item2, ...)
  self.items[item] = not self.items[item]
  self._size = self._size + self.items[item] and 1 or -1
  if item2 then self:toggle(item2, ...) end
  return self
end

function Bag:contains(item)
  return self.items[item]
end

function Bag:contains_one(...)
  for _, item in pairs({...}) do
    if self.items[item] then
      return true
    end
  end
  return false
end

function Bag:contains_all(...)
  for _, item in pairs({...}) do
    if not self.items[item] then
      return false
    end
  end
  return true
end

function Bag:combine(...)
  local newbag = self:copy()
  for k, bag in pairs({...}) do
    for item, _ in pairs(bag.items) do
      newbag:insert(item)
      if not self.items[item] then
        self.items[item] = true
        self._size = self._size - 1
      end
    end
  end
  return newbag
end

return Bag
