//
//  ExerciseListView.swift
//  stevesweights
//
//  Created by Stephen Dawes on 16/02/2024.
//

import SwiftUI
import CoreData

struct ExerciseListView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \Exercise.name, ascending: true)],
        animation: .default)
    private var exercises: FetchedResults<Exercise>
    @State private var isAddingExercise = false

    var body: some View {
        NavigationStack {
            List {
                ForEach(exercises, id: \.self) { exercise in
                    NavigationLink(destination: ExerciseDetailView(exercise: exercise)) {
                        Text(exercise.name ?? "Unnamed Exercise")
                    }
                }
                .onDelete(perform: deleteExercises) // Enables swipe to delete
            }
            .navigationTitle("Exercises")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Add Exercise") {
                        isAddingExercise = true
                    }
                }
            }
            .sheet(isPresented: $isAddingExercise) {
                AddExerciseView()
            }
        }
    }

    // This function must be defined within the view struct but outside the body closure
    private func deleteExercises(offsets: IndexSet) {
        withAnimation {
            offsets.map { exercises[$0] }.forEach(viewContext.delete)
            do {
                try viewContext.save()
            } catch {
                // Handle the Core Data error
                print(error.localizedDescription)
            }
        }
    }
}








