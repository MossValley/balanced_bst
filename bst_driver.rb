require_relative 'balanced_bst'

#1
tree = Tree.new([69, 27, 117, 6, 46, 91, 175, 3, 23, 38, 67, 73, 93, 169, 198, 1, 16, 28, 72, 143])
# tree = Tree.new(Array.new(15) { rand(1..100) })

tree.pretty_print

#2
p tree.balanced?

#3
p tree.level_order
p tree.preorder
p tree.postorder
p tree.inorder

#4
5.times { tree.insert( rand(100..200)) }

tree.pretty_print

#5
p tree.balanced?
#6
p tree.rebalance
#7
p tree.balanced?

tree.pretty_print

#8
p tree.level_order
p tree.preorder
p tree.postorder
p tree.inorder

#----

p tree.delete(6)
p tree.level_order
p tree.preorder
tree.pretty_print
p tree.delete(23)
tree.pretty_print
p tree.delete(72)
tree.pretty_print
p tree.delete(69)
tree.pretty_print
