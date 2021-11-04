#Usage
This nodule creates a lambda and a cloudwatch event that shutsdown an Aurora cluster that contains a specific tag and tag value. 
If you add a tag
```stop_cluster = daily```
the db will be shutdown at 17:30 UTC. if you don’t add the tag
```start_cluter = daily```
it won’t automatically be started, so it doesn’t cost any money, while it stays available. AWS will start rds instances every 7 days, but the stop schedule will automatically stop them again. you can also call the lambda manually to start:
```aws lambda invoke --function-name lambda_start_aurora ~/aws.log```

The tags and the time the schedule is created is configurable by variables. 
