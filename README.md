# 🚖 Ride-Booking System Database

## 📌 Project Overview
This project is a **transactional database system** designed for **mobility service providers**, enabling efficient management of **drivers, vehicles, customers, rides, payments, and rewards**. The database follows **normalization principles** to ensure data integrity and optimize performance.

## 📊 ER Diagram
![ER Diagram](ER%20Diagram.jpg)

---

## 📂 Dataset Used
The database consists of the following core tables:
1. **Users & Authentication:** Manages user roles (`Admin, Driver, Customer`) with secure login.
2. **Drivers & Vehicles:** Maintains driver information and assigns vehicles.
3. **Rides & Geolocations:** Stores ride details, pickup/drop locations, and real-time geolocation tracking.
4. **Payments & Rewards:** Tracks ride payments and customer reward points.

---

## 🛠️ Technology Used
- **Database:** MySQL / PostgreSQL
- **Query Language:** SQL
- **File Storage:** `.sql` scripts for schema creation and data insertion

---

## 📜 File Structure
| File Name                           | Description |
|-------------------------------------|-------------|
| `mobility_db.sql`                   | Database schema and table creation queries |
| `Ride-Booking System A Transactional Database.pdf` | Detailed project documentation |
| `AnalyticsRequirement.sql`          | SQL queries for analytical insights |
| `ER Diagram.jpg`                    | Entity-Relationship Diagram for database structure |
| `README.md`                         | Project description and instructions |

---

## 🔍 SQL Analytics & Queries
The **AnalyticsRequirement.sql** file contains queries to extract key insights such as:
- Number of registered drivers/customers
- Revenue trends over time
- Top 5 highest-earning drivers/customers
- Most frequently booked ride locations

---

## 🚀 How to Use
1. Clone the repository:
   ```sh
   git clone https://github.com/your-username/ride-booking-database.git
