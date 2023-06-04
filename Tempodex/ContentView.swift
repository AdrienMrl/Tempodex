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

let b = Task(id: UUID(),
             name: "Side projects",
             targetWork: Array(repeating: halfAnHour, count: 7),
             taskCreationDate: Date(),
             workOffset: 0,
             timeWorked: [])


let c = Task(id: UUID(),
             name: "Piano",
             targetWork: Array(repeating: 15 * 60, count: 7),
             taskCreationDate: Date(),
             workOffset: 0,
             timeWorked: [])


let d = Task(id: UUID(),
             name: "TODOs/cleaning",
             targetWork: Array(repeating: halfAnHour, count: 7),
             taskCreationDate: Date(),
             workOffset: 0,
             timeWorked: [])

let twelve: TimeInterval = 300 * 60
let e = Task(id: UUID(),
             name: "TouchBistro",
             targetWork: [0, twelve, twelve, twelve, twelve, twelve, 0],
             taskCreationDate: Date(),
             workOffset: 0,
             timeWorked: [])

struct ContentView: View {
    private let tasksSample = [b, c, d, e]
    @State private var taskPlayed: UUID? = nil
    @State private var tasks: [Task] = []
    
    func checkForRunningTask() {
        for task in tasks {
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
            if let task = Task.load(name: name) {
                self.tasks.append(task)
            }
        }
    }
    
    var body: some View {
        NavigationView {
//            TaskRow(task: a, playing: $taskPlayed)
            List(tasks, id: \.id) { task in
                NavigationLink(destination: TaskDetailsScreen(task: task, playing: $taskPlayed)) {
                    TaskRow(task: task, playing: $taskPlayed)
                }
            }.onAppear() {
                if tasks.isEmpty {
                    loadTasks()
                    checkForRunningTask()
                    // todo: refresh here
                }
            }.navigationBarTitle("Home")
                .navigationBarItems(trailing: NavigationLink(destination: AddTaskScreen()) {
                    Image(systemName: "plus")
                })
        }
//        List {
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
