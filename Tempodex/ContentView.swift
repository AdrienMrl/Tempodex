//
//  ContentView.swift
//  TimeRipple
//
//  Created by Adrien morel on 5/22/23.
//

import SwiftUI

let oneHourAndAHalf: TimeInterval = 90 * 60
let halfAnHour: TimeInterval = 60 * 30
let yesterday = Calendar.current.date(byAdding: .day, value: -1, to: Date())!
let a = Task(id: UUID(),
             name: "Clean the kitchen",
             targetWork: [oneHourAndAHalf, oneHourAndAHalf, oneHourAndAHalf, oneHourAndAHalf, oneHourAndAHalf, oneHourAndAHalf, 0],
             taskCreationDate: Date(),
             timeWorked: [])


let b = Task(id: UUID(),
             name: "Side projects",
             targetWork: Array(repeating: halfAnHour, count: 7),
             taskCreationDate: Date(),
             timeWorked: [])


let c = Task(id: UUID(),
             name: "Piano",
             targetWork: Array(repeating: 15 * 60, count: 7),
             taskCreationDate: Date(),
             timeWorked: [])


let d = Task(id: UUID(),
             name: "TODOs/cleaning",
             targetWork: Array(repeating: halfAnHour, count: 7),
             taskCreationDate: Date(),
             timeWorked: [])

let twelve: TimeInterval = 300 * 60
let e = Task(id: UUID(),
             name: "TouchBistro",
             targetWork: [0, twelve, twelve, twelve, twelve, twelve, 0],
             taskCreationDate: Date(),
             timeWorked: [])

struct ContentView: View {
    @State private var taskPlayed: UUID? = nil
    
    var body: some View {
        List([a, b, c, d, e].map { item in item.name }, id: \.self) { name in
            TaskRow(task: Task.load(name: name), playing: $taskPlayed)
        }
    }
    
//    func loadTasks() -> [Task] {
////        return [Task.load(name: sampleTask.name)]
//    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
