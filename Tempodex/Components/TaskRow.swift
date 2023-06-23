//
//  TaskRow.swift
//  TimeRipple
//
//  Created by Adrien morel on 5/28/23.
//

import SwiftUI
import Combine

struct WorkRange: Codable {
    let start: Date
    var end: Date?
}

class Task: Identifiable, Codable {
    internal init(id: UUID, name: String, targetWork: [TimeInterval], taskCreationDate: Date, workOffset: TimeInterval, timeWorked: [WorkRange]) {
        self.id = id
        self.name = name
        self.targetWork = targetWork
        self.taskCreationDate = taskCreationDate
        self.workOffset = workOffset
        self.timeWorked = timeWorked
    }
    
    let id: UUID
    let name: String
    let targetWork: [TimeInterval] // how much time to work each day, array is for the days of the week
    let taskCreationDate: Date
    var workOffset: TimeInterval
    var timeWorked: [WorkRange]
    
    var isRunning: Bool {
        guard let lastWorkSession = timeWorked.last else {
            return false
        }
        return lastWorkSession.end == nil
    }
    
    func startWork() {
        stopWork()
        timeWorked.append(WorkRange(start: Date()))
        save()
    }
    
    func stopWork() {
        if isRunning {
            self.timeWorked[self.timeWorked.count - 1].end = Date()
        }
        save()
    }
    
    static func load(name: String) -> Task? {
        guard let saved = UserDefaults.standard.object(forKey: name) as? Data else {
            return nil
        }
        return try! JSONDecoder().decode(Task.self, from: saved)
    }
    
    func save() {
        let encoder = JSONEncoder()
        UserDefaults.standard.set(try! encoder.encode(self), forKey: self.name)
    }
    
    func addTime(_ time: TimeInterval) {
        workOffset += time
        save()
    }
}

struct TaskRow: View {
    @State var task: Task
    @State var timer: Timer? = nil
    @State var pendingWork: TimeInterval?
    @Binding var playing: UUID?
    @Environment(\.scenePhase) var scenePhase
    
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
    
    private func getDaysBetween(from date: Date, to currentDate: Date) -> Int {
        let calendar = Calendar.current
        
        let dayFromDate = calendar.startOfDay(for: date)
        let dayToDate = calendar.startOfDay(for: currentDate)

        let components = calendar.dateComponents([.day], from: dayFromDate, to: dayToDate)
        return components.day ?? 0
    }
    
    var totalWorkToDo: TimeInterval {
        var totalTime: TimeInterval = 0
        let elapsedDays = getDaysBetween(from: task.taskCreationDate, to: Date())

        for day in 0...elapsedDays {
            let dayOfWork = Calendar.current.date(byAdding: .day, value: day, to: task.taskCreationDate)!
            let dayOfTheWeek = convertDateToDayOfTheWeek(for: dayOfWork)
            let workTargetForThatDay = task.targetWork[dayOfTheWeek]
            totalTime += workTargetForThatDay
        }
        return totalTime + task.workOffset
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
            .onChange(of: scenePhase) { newPhase in
                if newPhase == .active {
                    pendingWork = pendingWorkToDo
                }
            }
            .onAppear() {
                if playing == task.id {
                    startTimer()
                }
            }
            .onChange(of: playing) { newValue in
                if let newValue, newValue != task.id {
                    stopTimer()
                }
            }
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
        }.buttonStyle(PlainButtonStyle())
    }
}

struct TaskRow_Previews: PreviewProvider {
    static var previews: some View {
        VStack {
            TaskRow(task: b, playing: .constant(nil))
//            Text("\(TaskRow(task: sampleTask, playing: .constant(nil)).totalWorkToDo)")
        }
    }
}
