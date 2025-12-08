pub type Set(a)

@external(erlang, "sets", "new")
pub fn new() -> Set(a)

@external(erlang, "sets", "add_element")
pub fn add(value: a, set: Set(a)) -> Set(a)

@external(erlang, "sets", "from_list")
pub fn from_list(list: List(a)) -> Set(a)

@external(erlang, "sets", "to_list")
pub fn to_list(list: Set(a)) -> List(a)

@external(erlang, "sets", "is_element")
pub fn contains(value: a, set: Set(a)) -> Bool

@external(erlang, "sets", "size")
pub fn size(set: Set(a)) -> Int

@external(erlang, "sets", "union")
pub fn union(set1: Set(a), set2: Set(a)) -> Set(a)

@external(erlang, "sets", "fold")
pub fn fold(f: fn(a, b) -> b, acc: b, set: Set(a)) -> b

@external(erlang, "sets", "subtract")
pub fn difference(set1: Set(a), set2: Set(a)) -> Set(a)
