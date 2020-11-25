# frozen_string_literal: true
require 'pry'

class Node
    include Comparable
    attr_accessor :data, :left, :right

    def initialize(data)
        @data = data
        @left = nil
        @right = nil
    end

    # def <=>(other)
    #     data.size <=> other.data.size
    # end
end

class Tree
    attr_accessor :root

    def initialize(array)
        @array = array.sort.uniq
        @root = build_tree(@array)
    end

    def build_tree(arr)
        return nil if arr.empty?
        mid = arr.length / 2
        root = Node.new(arr[mid])
        root.left = build_tree(arr[0...mid])
        root.right = build_tree(arr[mid+1..-1])
        return root
    end

    def insert(value, node=@root)
        return "node exists" if value == node.data
        if value < node.data 
            return node.left.nil? ? 
                node.left = Node.new(value) :
                insert(value, node.left)
        elsif value > node.data 
            return node.right.nil? ? 
                node.right = Node.new(value) :
                insert(value, node.right)
        end
    end

    def delete(value, rootptr=@root, pre_rootptr=nil)
        if value == rootptr.data
            rootptr = node_deleter(rootptr, pre_rootptr)
        elsif value < rootptr.data
            return delete(value, rootptr.left, rootptr)
        elsif value > rootptr.data
            return delete(value, rootptr.right, rootptr)
        end
    end

    protected

    def node_deleter(rootptr, pre_rootptr)
        if !rootptr.right.nil? #node has larger children => find smallest inline successor
            pre_successor = rootptr
            successor = rootptr.right
            until successor.left.nil?
                pre_successor = successor
                successor = successor.left
            end
            pre_successor == rootptr ? pre_successor.right = nil : pre_successor.left = nil
            rootptr.data = successor.data
            rootptr
        elsif !rootptr.left.nil? #node has one child
            rootptr = rootptr.left
            rootptr
        else #node is leaf 
            if !pre_rootptr.nil?
                pre_rootptr.left == rootptr ? pre_rootptr.left = nil : pre_rootptr.right = nil
            end 
            rootptr.data = nil
        end
    end

    public

    def find(value, node=@root)
        return 'node not there' if node.nil? || node.data.nil?
        if value == node.data
            return node
        elsif value < node.data
            return find(value, node.left)
        elsif value > node.data
            return find(value, node.right)
        end
    end

    def level_order
        queue = [@root]
        tree_values = []
        until queue.empty?
            tree_node = queue.shift
            tree_values << tree_node.data if !tree_node.data.nil?
            queue.push << tree_node.left if !tree_node.left.nil?
            queue.push << tree_node.right if !tree_node.right.nil?
        end
        tree_values
    end

    def preorder(rootptr=@root, tree_values=[])
        return if rootptr.nil?

        tree_values << rootptr.data
        preorder(rootptr.left, tree_values)
        preorder(rootptr.right, tree_values)

        tree_values
    end

    def inorder(rootptr=@root, tree_values=[])
        return if rootptr.nil?
        
        inorder(rootptr.left, tree_values)
        tree_values << rootptr.data
        inorder(rootptr.right, tree_values)

        tree_values
    end

    def postorder(rootptr=@root, tree_values=[])
        return if rootptr.nil?

        postorder(rootptr.left, tree_values)
        postorder(rootptr.right, tree_values)
        tree_values << rootptr.data

        tree_values             # not needed but kept for uniformity of code for tree traversal
    end

    def height(node, node_ht=-1)
        node_ht +=1
        return node_ht if node.left.nil? && node.right.nil?
        
        node_left = !node.left.nil? ? height(node.left, node_ht) : 0
        node_right = !node.right.nil? ? height(node.right, node_ht) : 0

        node_ht = node_left > node_right ? node_left : node_right
    end

    def depth(node, rootptr=@root, node_dp=-1)
        node_dp += 1
        if node.data == rootptr.data
            return node_dp
        elsif node.data < rootptr.data
            return depth(node, rootptr.left, node_dp)
        elsif node.data > rootptr.data
            return depth(node, rootptr.right, node_dp)
        end    
    end

    def balanced?
        left_ht = height(@root.left)
        right_ht = height(@root.right)

        case left_ht - right_ht
        when -1, 0, 1
            return true 
        else
            return false
        end
    end

    def rebalance
        @root = build_tree(level_order.sort)
        'rebalanced'
    end

    def pretty_print(node = @root, prefix = '', is_left = true)
        pretty_print(node.right, "#{prefix}#{is_left ? '│   ' : '    '}", false) if node.right
        puts "#{prefix}#{is_left ? '└── ' : '┌── '}#{node.data}"
        pretty_print(node.left, "#{prefix}#{is_left ? '    ' : '│   '}", true) if node.left
    end

end
