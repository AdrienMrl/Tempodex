//
//  TaskRow.swift
//  TimeRipple
//
//  Created by Adrien morel on 5/28/23.
//

import SwiftUI

struct WorkRange: Codable {
    let start: Date
    var end: Date?
}

struct Task: Identifiable, Codable {
    let id: UUID
    let name: String
    let targetWork: [TimeInterval] // how much time to work each day, array is for the days of the week
    let taskCreationDate: Date
    var timeWorked: [WorkRange]
    
    mutating func startWork() {
        stopWork()
        timeWorked.append(WorkRange(start: Date()))
        save()
    }
    
    mutating func stopWork() {
        if let lastTimeWorked = timeWorked.last {
            if lastTimeWorked.end == nil {
                self.timeWorked[self.timeWorked.count - 1].end = Date()
            }
        }
        save()
    }
    
    static func load(name: String) -> Task {
        let saved = UserDefaults.standard.object(forKey: name) as! Data
        return try! JSONDecoder().decode(Task.self, from: saved)
    }
    
    func save() {
        let encoder = JSONEncoder()
        UserDefaults.standard.set(try! encoder.encode(self), forKey: self.name)
        print("saved!")
    }
}

struct TaskRow: View {
    @State var task: Task
    @State var timer: Timer? = nil
    @State var pendingWork: TimeInterval?
    @Binding var playing: UUID?
    
    func startTimer() {
        stopTimer()
        task.startWork()
        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { _ in
            pendingWork = pendingWorkToDo
        }
    }
    
    func stopTimer() {
        timer?.invalidate()
        timer = nil
        task.stopWork()
    }
    
    func convertDateToDayOfTheWeek(for date: Date) -> Int {
        let calendar = Calendar.current
        let day = calendar.component(.weekday, from: date)
        return (day - calendar.firstWeekday + 7) % 7
    }
    
    var currentDayTargetWork: TimeInterval {
        return self.task.targetWork[convertDateToDayOfTheWeek(for: Date())]
    }
    
    var totalWorkDone: TimeInterval {
        var totalTime: TimeInterval = 0
        for workSession in task.timeWorked {
            let endTime = workSession.end ?? Date()
            totalTime += endTime.timeIntervalSince(workSession.start)
        }
        return totalTime
    }
    
    var totalWorkToDo: TimeInterval {
        var totalTime: TimeInterval = 0
        let components = Calendar.current.dateComponents([.day], from: task.taskCreationDate, to: Date())
        let elapsedDays = components.day!

        for day in 0...elapsedDays {
            let dayOfWork = Calendar.current.date(byAdding: .day, value: day, to: task.taskCreationDate)!
            let dayOfTheWeek = convertDateToDayOfTheWeek(for: dayOfWork)
            let workTargetForThatDay = task.targetWork[dayOfTheWeek]
            totalTime += workTargetForThatDay
        }
        return totalTime
    }
    
    var pendingWorkToDo: TimeInterval {
        totalWorkToDo - totalWorkDone
    }
    
    var pendingWorkFormatted: String {
        let formatter = DateComponentsFormatter()
        formatter.unitsStyle = .full
        let formattedTime = formatter.string(from: pendingWork ?? pendingWorkToDo)!
        return "Remains \(formattedTime)"
    }
    
    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                Text(task.name)
                    .font(.title2)
                Text(pendingWorkFormatted)
                    .font(.caption)
            }
            Spacer()
            PlayButton(isPlaying: playing == self.task.id) {
                if playing == self.task.id {
                    playing = nil
                    stopTimer()
                } else {
                    playing = self.task.id
                    startTimer()
                }
            }
        }.padding(20)
    }
}

struct PlayButton: View {
    let isPlaying: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            Image(systemName: isPlaying ? "pause.fill" : "play.fill")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 30, height: 30)
        }
    }
}

struct TaskRow_Previews: PreviewProvider {
    static var previews: some View {
        VStack {
            TaskRow(task: sampleTask, playing: .constant(nil))
//            Text("\(TaskRow(task: sampleTask, playing: .constant(nil)).totalWorkToDo)")
        }
    }
}
