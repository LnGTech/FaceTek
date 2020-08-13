
import Foundation

class Person
{
    
//    var name: String = ""
//    var age: Int = 0
    var id: Int = 0
    var customerId:String = ""
    var branchId = ""
    var employeeId = ""
    var customerName: String = ""
    var branchName: String = ""
    var employeeName: String = ""
    var empGroupFaceList:String = ""
    var empPersistedFaceId = ""
    
    
    init(id:Int, customerId: String, branchId:String,employeeId:String,customerName:String,branchName:String,employeeName:String,empGroupFaceList:String,empPersistedFaceId:String )
    {
        self.id = id
        self.customerId = customerId
        self.branchId = branchId
        self.employeeId = employeeId
        self.customerName = customerName
        self.branchName = branchName
        self.employeeName = employeeName
        self.empGroupFaceList = empGroupFaceList
        self.empPersistedFaceId = empPersistedFaceId
        
        
        
        
        
        
//        self.name = name
//        
//        branchId
//        self.age = age
    }
    
}
