//
//  ContentView.swift
//  Demo
//
//  Created by Roy Hsu on 2021/7/10.
//

import SwiftUI

struct ContentView: View {
  var body: some View {
    ContactList()
  }
}

struct ContentView_Previews: PreviewProvider {
  static var previews: some View {
    ContentView()
  }
}

struct ContactList: UIViewControllerRepresentable {
  func makeUIViewController(context: Context) -> ContactListController {
    ContactListController()
  }
  
  func updateUIViewController(
    _ viewController: ContactListController,
    context: Context)
  {}
}
