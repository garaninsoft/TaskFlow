//
//  Plans.swift
//  TaskFlow
//
//  Created by alexandergaranin on 24.04.2025.
//

import SwiftData
import Foundation

// MARK: - План миграции для Payment
struct PaymentMigrationPlan: SchemaMigrationPlan {
    static var schemas: [any VersionedSchema.Type] {
        [
            Schema100.self,
            Schema101.self,
            Schema120.self
        ]
    }
    
    static var stages: [MigrationStage] {
        [
            MigrationStage.custom(
                fromVersion: Schema100.self,
                toVersion: Schema101.self,
                willMigrate: nil,
                didMigrate: { context in
                    let payments = try context.fetch(FetchDescriptor<Schema101.Payment>())

                    for payment in payments {
                        payment.taxdate = payment.declared ? Date(): nil
                    }
                    try context.save()
                }
            ),
            MigrationStage.lightweight(
                fromVersion: Schema101.self,
                toVersion: Schema120.self
            )
        ]
    }
}


