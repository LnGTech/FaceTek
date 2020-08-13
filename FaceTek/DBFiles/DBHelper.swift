

import Foundation
import SQLite3

class DBHelper
{
    init()
    {
        db = openDatabase()
        createTable()
    }

    let dbPath: String = "suresh4 .db"
    var db:OpaquePointer?

    func openDatabase() -> OpaquePointer?
    {
        let fileURL = try! FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
            .appendingPathComponent(dbPath)
        var db: OpaquePointer? = nil
        if sqlite3_open(fileURL.path, &db) != SQLITE_OK
        {
            print("error opening database")
            return nil
        }
        else
        {
            print("Successfully opened connection to database at \(dbPath)")
            return db
        }
    }
    
    
    
    
    
    
    func createTable() {
        let createTableString = "CREATE TABLE IF NOT EXISTS tmEmployee(id INTEGER UNIQUE PRIMARY KEY AUTOINCREMENT,customerId TEXT,branchId TEXT,employeeId TEXT,customerName TEXT,branchName TEXT,employeeName TEXT,empGroupFaceList TEXT,empPersistedFaceId TEXT);"
        var createTableStatement: OpaquePointer? = nil
        if sqlite3_prepare_v2(db, createTableString, -1, &createTableStatement, nil) == SQLITE_OK
        {
            if sqlite3_step(createTableStatement) == SQLITE_DONE
            {
                print("person table created.")
            } else {
                print("person table could not be created.")
            }
        } else {
            print("CREATE TABLE statement could not be prepared.")
        }
        sqlite3_finalize(createTableStatement)
    }
    
    
    func insert(id:Int, customerId:String,branchId:String,employeeId:String,customerName:String,branchName:String,employeeName:String,empGroupFaceList:String,empPersistedFaceId:String)
    {
        let persons = read()
        for p in persons
        {
            if p.id == id
            {
                return
            }
        }
        let insertStatementString = "INSERT INTO tmEmployee (Id, customerId, branchId, employeeId,customerName ,branchName,employeeName,empGroupFaceList,empPersistedFaceId) VALUES (NULL, ?, ?, ?, ?, ?, ?, ?, ?);"
        var insertStatement: OpaquePointer? = nil
        if sqlite3_prepare_v2(db, insertStatementString, -1, &insertStatement, nil) == SQLITE_OK {
            sqlite3_bind_text(insertStatement, 1, (customerId as NSString).utf8String, -1, nil)
            sqlite3_bind_text(insertStatement, 2, (branchId as NSString).utf8String, -2, nil)
            sqlite3_bind_text(insertStatement, 3, (employeeId as NSString).utf8String, -3, nil)
            sqlite3_bind_text(insertStatement, 4, (customerName as NSString).utf8String, -4, nil)
            sqlite3_bind_text(insertStatement, 5, (branchName as NSString).utf8String, -5, nil)
            sqlite3_bind_text(insertStatement, 6, (employeeName as NSString).utf8String, -6, nil)
            sqlite3_bind_text(insertStatement, 7, (empGroupFaceList as NSString).utf8String, -7, nil)
            sqlite3_bind_text(insertStatement, 8, (empPersistedFaceId as NSString).utf8String, -8, nil)

            


            
            if sqlite3_step(insertStatement) == SQLITE_DONE {
                print("Successfully inserted row.")
            } else {
                print("Could not insert row.")
            }
        } else {
            print("INSERT statement could not be prepared.")
        }
        sqlite3_finalize(insertStatement)
    }
    
    func read() -> [Person] {
        let queryStatementString = "SELECT * FROM tmEmployee;"
        var queryStatement: OpaquePointer? = nil
        var psns : [Person] = []
        if sqlite3_prepare_v2(db, queryStatementString, -1, &queryStatement, nil) == SQLITE_OK {
            while sqlite3_step(queryStatement) == SQLITE_ROW {
                let id = sqlite3_column_int(queryStatement, 0)
                let customerId = String(describing: String(cString: sqlite3_column_text(queryStatement, 1)))
                let branchId = String(describing: String(cString: sqlite3_column_text(queryStatement, 2)))
                let employeeId = String(describing: String(cString: sqlite3_column_text(queryStatement, 3)))
                let customerName = String(describing: String(cString: sqlite3_column_text(queryStatement, 4)))
                let branchName = String(describing: String(cString: sqlite3_column_text(queryStatement, 5)))
                let employeeName = String(describing: String(cString: sqlite3_column_text(queryStatement, 6)))
                let empGroupFaceList = String(describing: String(cString: sqlite3_column_text(queryStatement, 7)))
                let empPersistedFaceId = String(describing: String(cString: sqlite3_column_text(queryStatement, 8)))

                



                
                
                
                //let year = sqlite3_column_int(queryStatement, 2)
                psns.append(Person(id: Int(id), customerId: customerId, branchId: branchId ,employeeId:employeeId,customerName:customerName,branchName:branchName,employeeName:employeeName,empGroupFaceList:empGroupFaceList,empPersistedFaceId:empPersistedFaceId ))
                print("Query Result:")
                print("\(id) | \(customerId) | \(branchId) | \(employeeId) | \(customerName) | \(branchName) | \(employeeName) |\(empPersistedFaceId)")
            }
        } else {
            print("SELECT statement could not be prepared")
        }
        sqlite3_finalize(queryStatement)
        return psns
    }
    
    func deleteByID(id:Int) {
        let deleteStatementStirng = "DELETE FROM person WHERE Id = ?;"
        var deleteStatement: OpaquePointer? = nil
        if sqlite3_prepare_v2(db, deleteStatementStirng, -1, &deleteStatement, nil) == SQLITE_OK {
            sqlite3_bind_int(deleteStatement, 1, Int32(id))
            if sqlite3_step(deleteStatement) == SQLITE_DONE {
                print("Successfully deleted row.")
            } else {
                print("Could not delete row.")
            }
        } else {
            print("DELETE statement could not be prepared")
        }
        sqlite3_finalize(deleteStatement)
    }
    
}
