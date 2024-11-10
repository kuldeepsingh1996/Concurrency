//
//  StructClassActorBootcamp.swift
//  SwiftConcurrency
//
//  Created by Philophobic on 23/10/24.
//

import SwiftUI

struct StructClassActorBootcamp: View {
    var body: some View {
        Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
            .onAppear {
                  runTest()
                }
            
    }
}

#Preview {
    StructClassActorBootcamp()
}

struct MyStruct {
var title: String
}

class MyClass {
var title: String

init(title: String) {
  self.title = title
}
}

// MARK: - EXTENSTION
extension StructClassActorBootcamp {
private func runTest() {
  print("Struct Test")
  structTest1()
  printDivider()
  print("Class Test")
  classTest1()
}

private func printDivider() {
  print("""

  -----------------------------
  """)
}

private func structTest1() {
  let objectA = MyStruct(title: "Starting title!")
  print("ObjectA: ", objectA.title)

  print("Pass the VALUES of objectA to objectB")
  var objectB = objectA
  print("ObjectB: ", objectB.title)

  objectB.title = "Second title!"
  print("ObjectB title changed.")

  print("ObjectA: ", objectA.title)
  print("ObjectB: ", objectB.title)
}

private func classTest1() {
  let objectA = MyClass(title: "Starting Title")
  print("ObjectA: ", objectA.title)

  // When we are changing the title here not chaning the object itself. We are changing the title inside the object
  print("Pass the REFERENCE of objectA to objectB")
  let objectB = objectA
  print("ObjectB: ", objectB.title)

  objectB.title = "Second title!"
  print("ObjectB title changed.")

  print("ObjectA: ", objectA.title)
  print("ObjectB: ", objectB.title)
}
}
