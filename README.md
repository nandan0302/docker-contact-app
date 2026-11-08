# 🚀 Docker Contact Application

A production-style **multi-container Contact Application** deployed on **AWS EC2** using Docker.

The project consists of a React frontend, Node.js backend, and MongoDB database. It also includes automated database backups, Amazon S3 storage, monitoring, alerting, and disaster recovery testing.

---
---

##  Features

- Multi-container application using Docker
- Docker Compose for container orchestration
- React frontend served using Nginx
- Node.js backend API
- MongoDB database
- Docker network segmentation
- Persistent MongoDB storage using a bind mount
- Multi-stage Docker builds
- Automated MongoDB backups
- Scheduled backup execution using Cron
- Backup storage in Amazon S3
- Local backup retention and cleanup
- Backup monitoring using AWS Lambda
- Automated email alerts using Amazon SNS
- MongoDB disaster recovery and restore testing

---

##  Technologies Used

### Containerization & DevOps

- Docker
- Docker Compose
- Docker Networks
- Docker Bind Mounts
- Multi-stage Docker Builds

### Application

- React
- Nginx
- Node.js
- Express.js
- MongoDB

### AWS

- Amazon EC2
- Amazon S3
- AWS Lambda
- Amazon SNS
- IAM

### Automation

- Bash
- Cron
- `mongodump`
- `mongorestore`

---

##  Project Structure

```text
docker-contact-app/
│
├── frontend/
│   ├── Dockerfile
│   └── ...
│
├── backend/
│   ├── Dockerfile
│   └── ...
│
├── scripts/
│   └── backup-mongodb.sh
│
├── docs/
│   └── Project Report
│
├── compose.yaml
│
└── README.md
```

---

##  Multi-Container Application

The application runs as separate containers:

```text
Frontend Container
        │
        ▼
Backend Container
        │
        ▼
MongoDB Container
```

This separation allows each service to operate independently while communicating through Docker networks.

---

##  Docker Networking

The application uses Docker network segmentation to control communication between services.

```text
Frontend
    │
    ▼
Backend
    │
    ▼
MongoDB
```

The database is accessed internally by the backend and is not directly exposed to the frontend layer.

---

##  Persistent Database Storage

MongoDB data is stored using persistent storage outside the container lifecycle.

```text
MongoDB Container
        │
        ▼
     /data/db
        │
        ▼
EC2 Host Storage
/mnt/mongodb-data
```

This helps ensure database data can persist even if the MongoDB container is recreated.

---

##  Automated MongoDB Backup

The MongoDB backup workflow is automated using a Bash script and scheduled using Cron.

```text
MongoDB
    │
    ▼
mongodump
    │
    ▼
Backup Archive
    │
    ▼
Local Backup Storage
    │
    ▼
Amazon S3
```

Backups are stored outside the EC2 instance in Amazon S3 for additional durability.

---

##  Backup Automation

Cron is used to schedule automatic backup execution.

The backup process includes:

- Creating a MongoDB backup archive
- Storing the backup locally
- Uploading the backup to Amazon S3
- Managing local backup retention

---

##  Backup Monitoring and Alerting

The latest backup stored in Amazon S3 is monitored using AWS Lambda.

```text
Amazon S3
     │
     ▼
AWS Lambda
     │
Check Latest Backup
     │
     ▼
Healthy / Alert
```

If the latest backup is missing or exceeds the configured age threshold:

```text
AWS Lambda
     │
     ▼
Amazon SNS
     │
     ▼
Email Notification
```

---

##  Disaster Recovery

A backup is only useful if it can be successfully restored.

The disaster recovery workflow was tested using:

```text
Create Backup
      │
      ▼
Simulate Data Loss
      │
      ▼
mongorestore
      │
      ▼
Verify Restored Data
```

The MongoDB restore test successfully recovered the application data.

---

##  Running the Application

Clone the repository:

```bash
git clone https://github.com/nandan0302/docker-contact-app.git
cd docker-contact-app
```

Start the application:

```bash
sudo docker compose up -d --build
```

Check the containers:

```bash
sudo docker compose ps
```

View logs:

```bash
sudo docker compose logs
```

Stop the application:

```bash
sudo docker compose down
```

---

##  Key DevOps Concepts Demonstrated

- Containerization
- Multi-container architecture
- Docker Compose orchestration
- Multi-stage builds
- Docker networking
- Network segmentation
- Persistent storage
- Database backup automation
- Cron scheduling
- Cloud backup storage
- Serverless monitoring
- Automated alerting
- Disaster recovery testing

---

##  Project Objective

The objective of this project was to go beyond simply containerizing an application and implement a more complete DevOps workflow.

```text
Application
    ↓
Containerization
    ↓
Multi-Container Deployment
    ↓
Persistent Storage
    ↓
Automated Backup
    ↓
Cloud Storage
    ↓
Monitoring
    ↓
Alerting
    ↓
Disaster Recovery
```

---

##  Author

**Nandan K R**

AWS | Linux | Docker | DevOps

---

If you found this project useful, feel free to star the repository!
