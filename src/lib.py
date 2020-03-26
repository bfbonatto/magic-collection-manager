from collections import defaultdict
from typing import Union

class TrieNode:
	def __init__(self):
		self.next = defaultdict(EmptyNode)

	def find(self, name):
		if name == "":
			return self
		return self.next[name[0]].find(name[1:])

class ValueNode(TrieNode):
	def __init__(self, content):
		super().__init__()
		self.content = content

	def insert(self, content, name: str):
		if name == "":
			raise ValueError("key is already used in Trie")
		head = name[0]
		self.next[head] = self.next[head].insert(content, name[1:])
		return self


class EmptyNode(TrieNode):
	def __init__(self):
		self.next = defaultdict(EmptyNode)

	def insert(self, content, name: str):
		if name == "":
			return ValueNode(content)
		else:
			head = name[0]
			self.next[head] = self.next[head].insert(content, name[1:])
			return self

class TrieTree:
	def __init__(self):
		self.root = EmptyNode()

	def insert(self, content, name):
		if name != "":
			self.root.insert(content, name)

	def _find(self, name):
		return self.root.find(name)

	def find(self, name):
		return self._find(name).content
