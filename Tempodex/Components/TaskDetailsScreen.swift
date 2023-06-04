//
//  TaskDetailsScreen.swift
//  TimeRipple
//
//  Created by Adrien morel on 6/3/23.
//

import SwiftUI

struct TaskDetailsScreen: View {
    let task: Task
    @Binding var playing: UUID?
    
    var body: some View {
        VStack(alignment: .leading) {
            TaskRow(task: task, playing: $playing)
            HStack() {
                Button("+1 minute") {
                    task.addTime(60)
                }
                Spacer()
                Button("-1 minute") {
                    task.addTime(-60)
                }
            }.padding(24)
            HStack() {
                Button("+30 minutes") {
                    task.addTime(30 * 60)
                }
                Spacer()
                Button("-30 minutes") {
                    task.addTime(-30 * 60)
                }
            }.padding(24)
        }
        .navigationBarTitle("Task detail")
        Spacer()
    }
}

struct TaskDetailsScreen_Previews: PreviewProvider {
    static var previews: some View {
        TaskDetailsScreen(task: b, playing: .constant(nil))
    }
}
