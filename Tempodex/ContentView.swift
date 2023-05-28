//
//  ContentView.swift
//  TimeRipple
//
//  Created by Adrien morel on 5/22/23.
//

import SwiftUI

let oneHourAndAHalf: TimeInterval = 90 * 60
let yesterday = Calendar.current.date(byAdding: .day, value: -1, to: Date())!
let sampleTask = Task(id: UUID(),
                      name: "Clean the kitchen",
                      targetWork: [oneHourAndAHalf, oneHourAndAHalf, oneHourAndAHalf, oneHourAndAHalf, oneHourAndAHalf, oneHourAndAHalf, 0],
                      taskCreationDate: Date(),
                      timeWorked: [])

struct ContentView: View {
    @State private var taskPlayed: UUID? = nil
    
    var body: some View {
        VStack {
            TaskRow(task: sampleTask, playing: $taskPlayed)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
