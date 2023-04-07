# API Service

| Category     | SLI | SLO                                                                                                         |
|--------------|-----|-------------------------------------------------------------------------------------------------------------|
| Availability |Total number of successful requests / total number of requests  | 99%                                                                                                         |
| Latency      | Bucket of requests in a histogram showing the 95th percentile over the last 30 seconds.   | 90% of requests below 100ms                    |
| Error Budget | The percentage of failed requests                  | Error budget is defined at 20%. This means that 20% of the requests can fail and still be within the budget                |
| Throughput   |Total number of requests over a 1 second period of time    | 5 RPS indicates the application is functioning                                                              |
