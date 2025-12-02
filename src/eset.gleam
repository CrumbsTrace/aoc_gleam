pub type Set(a)

@external(erlang, "sets", "from_list")
pub fn from_list(list: List(a)) -> Set(a)

@external(erlang, "sets", "is_element")
pub fn contains(value: a, set: Set(a)) -> Bool

@external(erlang, "sets", "size")
pub fn size(set: Set(a)) -> Int
