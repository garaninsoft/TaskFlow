//
//  WorksProtocol.swift
//  TaskFlow
//
//  Created by alexandergaranin on 05.04.2025.
//

protocol WorksProtocol {
    func actionDeleteWork(work: Work, onSuccess: ()->Void)
    func actionUpdateWork(work: Work, onSuccess: ()->Void)
}
