# TrainTrax

After doing a bunch of projects making websites and machine learning programs, I want to expand my knowledge and hence I am making an iOS app using Swift.


## Idea

I want to create an app that is almost like Letterboxd but for those who are passionate about the London train system. Allowing users to log what parts of the tube and other TfL trains they have been on, while also giving them live access to delay information with a simple and clean UI, will prove both fun and useful. 

## Station Logging

As of the time I am writing this, I have not implemented the station logging feature yet. However, I intend for it to be the centrepiece of this app, as it is not something that already exists. I want to first make a system that works and so I will go for a simple list where the users can select which stations they have been through. Once, this has been established, I intend to create an interactive map where the user can slide their finger along the route they took, to then log their travels.

## Live Delay Reporting
Using the TfL Unified API, I am able to access unique endpoints for each tube line, the Overground, DLR, and the Elizabeth line, where each endpoint contains a JSON string outlining the status of a line and the reason behind it. Once this data is fetched, I can then present it to the user in a simple and effective way, ensuring that they can quickly get an idea of the status of their train.
