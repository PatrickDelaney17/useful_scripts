
## Insert Operators

*Insert three test documents:*
```
db.inspections.insert([ { "test": 1 }, { "test": 2 }, { "test": 3 } ])
```

*Insert three test documents but specify the _id values:*
```
db.inspections.insert([{ "_id": 1, "test": 1 },{ "_id": 1, "test": 2 },
                       { "_id": 3, "test": 3 }])
```     
*Insert multiple documents specifying the _id values, and using the "ordered": false option.*
```
db.inspections.insert([{ "_id": 1, "test": 1 },{ "_id": 1, "test": 2 },
                       { "_id": 3, "test": 3 }],{ "ordered": false })
```


*find by _id*

```
db.inspections.find({ "_id": 1 }).pretty()
```

*View collections in the active db*
```
show collections

```
*switch active db*
```
use training
```

*view all dbs*
```
show dbs
```

## Update Operators

```
use sample_training
```

*Find how many documents in the zips collection have the city field equal to "HUDSON".*
```
db.zips.find({ "city": "HUDSON" }).count()
```

*Update `all` documents in the zips collection where the city field is equal to "HUDSON" by adding 10 to the current value of the "pop" field.*

```
db.zips.updateMany({ "city": "HUDSON" }, { "$inc": { "pop": 10 } })
```

*Update a single document in the zips collection where the zip field is equal to "12534" by setting the value of the "pop" field to 17630.*
```
db.zips.updateOne({ "zip": "12534" }, { "$set": { "pop": 17630 } })
```

*Find all documents in the grades collection where the student_id field is 250 , and the class_id field is 339.*
```
db.grades.find({ "student_id": 250, "class_id": 339 }).pretty()
```

*Update one document in the grades collection where the student_id is ``250`` *, and the class_id field is 339 , by adding a document element to the "scores" array.*
```
db.grades.updateOne({ "student_id": 250, "class_id": 339 },
                    { "$push": { "scores": { "type": "extra credit",
                                             "score": 100 }
                                }
                     })
```
## Delete

```
use sample_training
```

*Look at all the docs that have test field equal to 3.*
```
db.inspections.find({ "test": 3 }).pretty()
```
*delete one, delete many*
```
db.inspections.deleteMany({ "test": 1 })

db.inspections.deleteOne({ "test": 3 })

```
*find what is left in the inspection db*
```
db.inspection.find().pretty()
```

*show collections, drop collection*

```
show collections

db.<collection name>.drop()
```
