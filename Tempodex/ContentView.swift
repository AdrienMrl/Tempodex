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
    private let tasksSample = [a, b, c, d, e]
    @State private var taskPlayed: UUID? = nil
    @State private var tasks: [Task] = []
    
    func checkForRunningTask() {
        for var task in tasks {
            if task.isRunning {
                if taskPlayed == nil {
                    taskPlayed = task.id
                } else {
                    task.stopWork()
                }
            }
        }
    }
     
    func loadTasks() {
        for name in tasksSample.map({ $0.name }) {
            self.tasks.append(Task.load(name: name))
        }
    }
    
    var body: some View {
        List(tasks, id: \.id) { task in
            TaskRow(task: task, playing: $taskPlayed)
        }.onAppear() {
            loadTasks()
            checkForRunningTask()
        }
//        List {
//            TaskRow(task: a, playing: $taskPlayed)
//            TaskRow(task: b, playing: $taskPlayed)
//            TaskRow(task: c, playing: $taskPlayed)
//            TaskRow(task: d, playing: $taskPlayed)
//            TaskRow(task: e, playing: $taskPlayed)
//        }
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
