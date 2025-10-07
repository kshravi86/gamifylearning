import SwiftUI

struct Flashcard: Identifiable, Hashable {
    let id = UUID()
    let prompt: String
    let answer: String
    let hint: String?
}

struct FlashcardDeck {
    let level: Int
    let title: String
    let description: String
    let cards: [Flashcard]
}

enum FlashcardsRepository {
    static let levels: [FlashcardDeck] = [
        FlashcardDeck(
            level: 1,
            title: "Basics I",
            description: "print, variables, comments, types",
            cards: [
                Flashcard(prompt: "How do you print 'Hello World'?", answer: "print('Hello World')", hint: "Use print() with quotes"),
                Flashcard(prompt: "Create variable x with value 5", answer: "x = 5", hint: "No type keyword needed"),
                Flashcard(prompt: "Write a comment line", answer: "# this is a comment", hint: "Starts with #"),
                Flashcard(prompt: "Get the type of 3.14", answer: "type(3.14)", hint: "type(...) returns <class 'float'>")
            ]
        ),
        FlashcardDeck(
            level: 2,
            title: "Basics II",
            description: "input, casting, arithmetic",
            cards: [
                Flashcard(prompt: "Read input into name", answer: "name = input()", hint: "input() returns str"),
                Flashcard(prompt: "Convert '42' to int", answer: "int('42')", hint: "Use int()"),
                Flashcard(prompt: "7 divided by 2 (float)", answer: "7 / 2", hint: "Single slash"),
                Flashcard(prompt: "Floor division of 7 by 2", answer: "7 // 2", hint: "Double slash")
            ]
        ),
        FlashcardDeck(
            level: 3,
            title: "Strings",
            description: "slicing, f-strings, methods",
            cards: [
                Flashcard(prompt: "First 3 chars of s", answer: "s[:3]", hint: "slice start:stop"),
                Flashcard(prompt: "Last char of s", answer: "s[-1]", hint: "Negative index"),
                Flashcard(prompt: "Format name='Ada' and age=30", answer: "f\"{name} is {age}\"", hint: "Use f-strings"),
                Flashcard(prompt: "Make 'Hello' lowercase", answer: "'Hello'.lower()", hint: ".lower() method")
            ]
        ),
        FlashcardDeck(
            level: 4,
            title: "Lists & Tuples",
            description: "lists, append, tuple",
            cards: [
                Flashcard(prompt: "Create list of 1,2,3", answer: "[1, 2, 3]", hint: nil),
                Flashcard(prompt: "Append 4 to list a", answer: "a.append(4)", hint: "Mutates the list"),
                Flashcard(prompt: "Get length of a", answer: "len(a)", hint: nil),
                Flashcard(prompt: "Create tuple with 'x','y'", answer: "('x', 'y')", hint: nil)
            ]
        ),
        FlashcardDeck(
            level: 5,
            title: "Conditionals",
            description: "if/elif/else, boolean ops",
            cards: [
                Flashcard(prompt: "If x > 10 print 'big'", answer: "if x > 10:\n    print('big')", hint: "Colon + indent"),
                Flashcard(prompt: "x between 1 and 5 inclusive", answer: "1 <= x <= 5", hint: "Chained compares"),
                Flashcard(prompt: "x is even?", answer: "x % 2 == 0", hint: "Modulo"),
                Flashcard(prompt: "Combine a and b true", answer: "a and b", hint: "and/or/not")
            ]
        ),
        FlashcardDeck(
            level: 6,
            title: "Loops",
            description: "for, while, range",
            cards: [
                Flashcard(prompt: "Loop i: 0..4", answer: "for i in range(5):\n    ...", hint: "range(n)"),
                Flashcard(prompt: "Sum items in nums", answer: "total = sum(nums)", hint: "Built-in sum"),
                Flashcard(prompt: "While x > 0 decrement", answer: "while x > 0:\n    x -= 1", hint: "Careful to update"),
                Flashcard(prompt: "Skip to next iteration", answer: "continue", hint: "Inside loop")
            ]
        ),
        FlashcardDeck(
            level: 7,
            title: "Functions",
            description: "def, return, args",
            cards: [
                Flashcard(prompt: "Define add(a,b) returns sum", answer: "def add(a, b):\n    return a + b", hint: "def name(params):"),
                Flashcard(prompt: "Default arg b=10", answer: "def f(a, b=10):\n    ...", hint: "Defaults on right"),
                Flashcard(prompt: "Unpack list args to f", answer: "f(*args)", hint: "* for positional"),
                Flashcard(prompt: "Docstring first line", answer: "def f():\n    \"\"\"Summary...\n    \"\"\"\n    pass", hint: "Triple quotes")
            ]
        ),
        FlashcardDeck(
            level: 8,
            title: "Dicts & Sets",
            description: "mapping, set ops, comps",
            cards: [
                Flashcard(prompt: "Create dict name='Ada'", answer: "{'name': 'Ada'}", hint: nil),
                Flashcard(prompt: "Get value with default", answer: "d.get('k', 0)", hint: ".get(key, default)"),
                Flashcard(prompt: "Unique items in list a", answer: "set(a)", hint: "Set removes dupes"),
                Flashcard(prompt: "Dict comprehension squares 0..4", answer: "{i: i*i for i in range(5)}", hint: nil)
            ]
        ),
        FlashcardDeck(
            level: 9,
            title: "Files & Errors",
            description: "with open, try/except",
            cards: [
                Flashcard(prompt: "Read all lines from 'a.txt'", answer: "with open('a.txt') as f:\n    lines = f.readlines()", hint: "with auto-closes"),
                Flashcard(prompt: "Write 'hi' to file", answer: "with open('a.txt','w') as f:\n    f.write('hi')", hint: "mode 'w'"),
                Flashcard(prompt: "Catch ValueError", answer: "try:\n    int('x')\nexcept ValueError:\n    ...", hint: "try/except"),
                Flashcard(prompt: "Import math sqrt", answer: "from math import sqrt", hint: nil)
            ]
        ),
        FlashcardDeck(
            level: 10,
            title: "OOP Basics",
            description: "class, __init__, inherit",
            cards: [
                Flashcard(prompt: "Define class Person", answer: "class Person:\n    pass", hint: nil),
                Flashcard(prompt: "__init__ sets name", answer: "class P:\n    def __init__(self, name):\n        self.name = name", hint: "self first arg"),
                Flashcard(prompt: "Method greet() prints name", answer: "def greet(self):\n    print(self.name)", hint: nil),
                Flashcard(prompt: "Subclass Student(Person)", answer: "class Student(Person):\n    pass", hint: "class Sub(Base):")
            ]
        )
    ]
}

final class ProgressStore {
    static let shared = ProgressStore()
    private let defaults = UserDefaults.standard

    func best(for level: Int) -> Int { defaults.integer(forKey: key(level)) }
    func setBest(_ value: Int, for level: Int) { defaults.set(value, forKey: key(level)) }

    private func key(_ level: Int) -> String { "level_\(level)_best" }
}
