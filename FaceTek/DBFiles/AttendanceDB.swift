////
////  AttendanceDB.swift
////  FaceTek
////
////  Created by sureshbabu bandaru on 7/4/20.
////  Copyright © 2020 sureshbabu bandaru. All rights reserved.
////
//
//import Foundation
//import SQLite3
//
//class AttendanceDB
//{
//    init()
//    {
//        db = openDatabase()
//        createTable()
//    }
//
//    let dbPath: String = "suresh4 .db"
//    var db:OpaquePointer?
//
//    func openDatabase() -> OpaquePointer?
//    {
//        let fileURL = try! FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
//            .appendingPathComponent(dbPath)
//        var db: OpaquePointer? = nil
//        if sqlite3_open(fileURL.path, &db) != SQLITE_OK
//        {
//            print("error opening database")
//            return nil
//        }
//        else
//        {
//            print("Successfully opened connection to database at \(dbPath)")
//            return db
//        }
//    }
//    
//    
//    
//    
//    
//    
//    func createTable() {
//        let createTableString = "CREATE TABLE IF NOT EXISTS tmAttendancee(id INTEGER PRIMARY KEY,refEmpId TEXT,attendanceDate TEXT,attendanceInDateTime TEXT,attendanceOutDateTime TEXT,attendanceInType TEXT,attendanceOutType TEXT,inLatLong TEXT,outLatLong TEXT,attendanceInConfidence TEXT,attendanceOutConfidence TEXT,locationInAddress TEXT,locationOutAddress TEXT,inSync TEXT,outSync TEXT);"
//        
//        
////
////         let createTableString = "CREATE TABLE IF NOT EXISTS tmEmployee(id INTEGER UNIQUE PRIMARY KEY AUTOINCREMENT,customerId TEXT,branchId TEXT,employeeId TEXT,customerName TEXT,branchName TEXT,employeeName TEXT,empGroupFaceList TEXT,empPersistedFaceId TEXT);"
////
//////
////        CREATE TABLE tmAttendancee(id INTEGER PRIMARY KEY,refEmpId TEXT,attendanceDate TEXT,attendanceInDateTime TEXT,attendanceOutDateTime TEXT,attendanceInType TEXT,attendanceOutType TEXT,inLatLong TEXT,outLatLong TEXT,attendanceInConfidence TEXT,attendanceOutConfidence TEXT,locationInAddress TEXT,locationOutAddress TEXT,inSync TEXT,outSync TEXT)
//        
//        
//        
//        var createTableStatement: OpaquePointer? = nil
//        if sqlite3_prepare_v2(db, createTableString, -1, &createTableStatement, nil) == SQLITE_OK
//        {
//            if sqlite3_step(createTableStatement) == SQLITE_DONE
//            {
//                print("person table created.")
//            } else {
//                print("person table could not be created.")
//            }
//        } else {
//            print("CREATE TABLE statement could not be prepared.")
//        }
//        sqlite3_finalize(createTableStatement)
//    }
//    
//    
//    //func insert(id:Int, customerId:String,branchId:String,employeeId:String,customerName:String,branchName:String,employeeName:String,empGroupFaceList:String,empPersistedFaceId:String)
//        
//    func insert(id:Int, refEmpId:String,attendanceDate:String,attendanceInDateTime:String,attendanceOutDateTime:String,attendanceInType:String,attendanceOutType:String,inLatLong:String,outLatLong:String,attendanceInConfidence:String,attendanceOutConfidence:String,locationInAddress:String,locationOutAddress:String,inSync:String,outSync:String)
//    {
//        let persons = read()
//        for p in persons
//        {
//            if p.id == id
//            {
//                return
//            }
//        }
//        let insertStatementString = "INSERT INTO tmAttendancee (Id, refEmpId, attendanceDate, attendanceInDateTime,attendanceOutDateTime ,attendanceInType,attendanceOutType,inLatLong,outLatLong,attendanceInConfidence,attendanceOutConfidence,locationInAddress,locationOutAddress,inSync,outSync) VALUES (NULL, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?);"
//        var insertStatement: OpaquePointer? = nil
//        if sqlite3_prepare_v2(db, insertStatementString, -1, &insertStatement, nil) == SQLITE_OK {
//            sqlite3_bind_text(insertStatement, 1, (refEmpId as NSString).utf8String, -1, nil)
//            sqlite3_bind_text(insertStatement, 2, (attendanceDate as NSString).utf8String, -2, nil)
//            sqlite3_bind_text(insertStatement, 3, (attendanceInDateTime as NSString).utf8String, -3, nil)
//            sqlite3_bind_text(insertStatement, 4, (attendanceOutDateTime as NSString).utf8String, -4, nil)
//            sqlite3_bind_text(insertStatement, 5, (attendanceInType as NSString).utf8String, -5, nil)
//            sqlite3_bind_text(insertStatement, 6, (attendanceOutType as NSString).utf8String, -6, nil)
//            sqlite3_bind_text(insertStatement, 7, (inLatLong as NSString).utf8String, -7, nil)
//            sqlite3_bind_text(insertStatement, 8, (outLatLong as NSString).utf8String, -8, nil)
//            sqlite3_bind_text(insertStatement, 9, (attendanceInConfidence as NSString).utf8String, -9, nil)
//            sqlite3_bind_text(insertStatement, 10, (attendanceOutConfidence as NSString).utf8String, -10, nil)
//            sqlite3_bind_text(insertStatement, 11, (locationInAddress as NSString).utf8String, -11, nil)
//            sqlite3_bind_text(insertStatement, 12, (locationOutAddress as NSString).utf8String, -12, nil)
//            sqlite3_bind_text(insertStatement, 13, (inSync as NSString).utf8String, -13, nil)
//            sqlite3_bind_text(insertStatement, 14, (outSync as NSString).utf8String, -14, nil)
//
//
//
//            
//
//
//            
//            if sqlite3_step(insertStatement) == SQLITE_DONE {
//                print("Successfully inserted row.")
//            } else {
//                print("Could not insert row.")
//            }
//        } else {
//            print("INSERT statement could not be prepared.")
//        }
//        sqlite3_finalize(insertStatement)
//    }
//    
//    func read() -> [AttendanceDB] {
//        let queryStatementString = "SELECT * FROM tmAttendancee;"
//        var queryStatement: OpaquePointer? = nil
//        var psns : [AttendanceDB] = []
//        if sqlite3_prepare_v2(db, queryStatementString, -1, &queryStatement, nil) == SQLITE_OK {
//            while sqlite3_step(queryStatement) == SQLITE_ROW {
//                let id = sqlite3_column_int(queryStatement, 0)
//                let refEmpId = String(describing: String(cString: sqlite3_column_text(queryStatement, 1)))
//                let attendanceDate = String(describing: String(cString: sqlite3_column_text(queryStatement, 2)))
//                let attendanceInDateTime = String(describing: String(cString: sqlite3_column_text(queryStatement, 3)))
//                let attendanceOutDateTime = String(describing: String(cString: sqlite3_column_text(queryStatement, 4)))
//                let attendanceInType = String(describing: String(cString: sqlite3_column_text(queryStatement, 5)))
//                let attendanceOutType = String(describing: String(cString: sqlite3_column_text(queryStatement, 6)))
//                let inLatLong = String(describing: String(cString: sqlite3_column_text(queryStatement, 7)))
//                let empPersistedFaceId = String(describing: String(cString: sqlite3_column_text(queryStatement, 8)))
//
//                
//
//
//
//                
//                
//                
//                //let year = sqlite3_column_int(queryStatement, 2)
//                psns.append(AttendanceDB(id: Int(id), customerId: customerId, branchId: branchId ,employeeId:employeeId,customerName:customerName,branchName:branchName,employeeName:employeeName,empGroupFaceList:empGroupFaceList,empPersistedFaceId:empPersistedFaceId ))
//                print("Query Result:")
//                print("\(id) | \(customerId) | \(branchId) | \(employeeId) | \(customerName) | \(branchName) | \(employeeName) |\(empPersistedFaceId)")
//            }
//        } else {
//            print("SELECT statement could not be prepared")
//        }
//        sqlite3_finalize(queryStatement)
//        return psns
//    }
//    
//    func deleteByID(id:Int) {
//        let deleteStatementStirng = "DELETE FROM person WHERE Id = ?;"
//        var deleteStatement: OpaquePointer? = nil
//        if sqlite3_prepare_v2(db, deleteStatementStirng, -1, &deleteStatement, nil) == SQLITE_OK {
//            sqlite3_bind_int(deleteStatement, 1, Int32(id))
//            if sqlite3_step(deleteStatement) == SQLITE_DONE {
//                print("Successfully deleted row.")
//            } else {
//                print("Could not delete row.")
//            }
//        } else {
//            print("DELETE statement could not be prepared")
//        }
//        sqlite3_finalize(deleteStatement)
//    }
//    
//}
