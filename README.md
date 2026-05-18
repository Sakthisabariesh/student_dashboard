# Student Fee Management Dashboard

A complete full-stack web application designed for learning SQL and full-stack development, simulating a real-world Student Fee Management system.

## Project Structure
This repository contains two main parts:
1. **`frontend/`**: A beautiful, modern web dashboard built with HTML, CSS (Glassmorphism design), and Vanilla JavaScript.
2. **`backend/`**: A Java Spring Boot REST API for connecting to a MySQL Database and serving data.
3. **`database.sql`**: A SQL script to initialize the MySQL database for SQL learning.

## Tech Stack
- **Frontend**: HTML5, CSS3, Vanilla JavaScript
- **Backend**: Java 17, Spring Boot, Spring Data JPA, Hibernate
- **Database**: MySQL

## How to use for SQL Learning
You can practice SQL by exploring the `database.sql` file and running custom queries against the database after setting it up. The provided Java backend also includes CRUD operations mapped to SQL.

## Setup Instructions

### Database Setup
1. Open MySQL Workbench or your preferred SQL tool.
2. Run the commands in `database.sql` to create the `student_dashboard` database and seed it with dummy data.

### Backend Setup (Spring Boot)
1. Navigate to the `backend/` folder.
2. Ensure you have Java 17 and Maven installed.
3. Update `backend/src/main/resources/application.properties` with your MySQL credentials.
4. Run the Spring Boot app:
   ```bash
   mvn spring-boot:run
   ```

### Frontend Setup
1. Navigate to the `frontend/` folder.
2. Simply open `index.html` in your web browser. 
3. *Note: By default, the JS file uses mock data so you can view the dashboard immediately. To connect it to the Spring Boot backend, uncomment the API fetch section in `app.js`.*
