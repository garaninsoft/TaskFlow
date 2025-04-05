//
//  MeetingsProtocol.swift
//  TaskFlow
//
//  Created by alexandergaranin on 24.03.2025.
//

protocol MeetingsProtocol {
    func actionDeleteMeeting(meeting: Schedule, onSuccess: ()->Void)
    func actionUpdateMeeting(meeting: Schedule, onSuccess: ()->Void)
}
