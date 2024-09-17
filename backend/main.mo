import Bool "mo:base/Bool";
import Text "mo:base/Text";

import Array "mo:base/Array";
import Debug "mo:base/Debug";
import Iter "mo:base/Iter";
import Nat "mo:base/Nat";
import Option "mo:base/Option";

actor {
  // Define the ShoppingItem type
  public type ShoppingItem = {
    id: Nat;
    text: Text;
    completed: Bool;
  };

  // Stable variable to store shopping items
  stable var shoppingItems: [ShoppingItem] = [];
  stable var nextId: Nat = 0;

  // Add a new shopping item
  public func addItem(text: Text) : async Nat {
    let id = nextId;
    nextId += 1;
    let newItem: ShoppingItem = {
      id = id;
      text = text;
      completed = false;
    };
    shoppingItems := Array.append(shoppingItems, [newItem]);
    id
  };

  // Get all shopping items
  public query func getItems() : async [ShoppingItem] {
    shoppingItems
  };

  // Toggle the completed status of an item
  public func toggleCompleted(id: Nat) : async Bool {
    let index = Array.indexOf<ShoppingItem>({ id = id; text = ""; completed = false }, shoppingItems, func(a, b) { a.id == b.id });
    switch (index) {
      case null { false };
      case (?i) {
        let item = shoppingItems[i];
        let updatedItem = {
          id = item.id;
          text = item.text;
          completed = not item.completed;
        };
        shoppingItems := Array.tabulate(shoppingItems.size(), func (j: Nat) : ShoppingItem {
          if (j == i) { updatedItem } else { shoppingItems[j] }
        });
        true
      };
    }
  };

  // Delete an item
  public func deleteItem(id: Nat) : async Bool {
    let filtered = Array.filter(shoppingItems, func (item: ShoppingItem) : Bool { item.id != id });
    if (filtered.size() < shoppingItems.size()) {
      shoppingItems := filtered;
      true
    } else {
      false
    }
  };
}
