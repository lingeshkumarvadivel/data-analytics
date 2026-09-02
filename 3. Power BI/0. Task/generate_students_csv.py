import csv
import random
from datetime import datetime, timedelta

random.seed(42)

first_names = [
    "Aarav", "Aadhya", "Aditya", "Akash", "Akshaya", "Ananya", "Arjun",
    "Arun", "Bala", "Bhavya", "Charan", "Deepa", "Dharani", "Divya",
    "Gokul", "Hari", "Harini", "Ishwarya", "Jeeva", "Karthik", "Kavya",
    "Keerthana", "Kishore", "Krishna", "Lakshmi", "Lokesh", "Manoj",
    "Meena", "Mithun", "Nandhini", "Naveen", "Nithya", "Pranav",
    "Priya", "Rahul", "Raja", "Ranjith", "Rithika", "Rohit", "Sanjay",
    "Sathish", "Shalini", "Siva", "Sowmiya", "Surya", "Swathi",
    "Tamil", "Usha", "Vignesh", "Vishal", "Yazhini"
]

last_names = [
    "Kumar", "Raj", "Murugan", "Vel", "Selvam", "Babu", "Prasad",
    "Raman", "Krishnan", "Shankar", "Natarajan", "Srinivasan",
    "Venkatesh", "Balaji", "Senthil", "Mohan", "Reddy", "Devi"
]

classes = [f"Class {grade}-{section}" for grade in range(6, 13) for section in ["A", "B", "C"]]
cities = [
    "Chennai", "Coimbatore", "Madurai", "Trichy", "Salem", "Tirunelveli",
    "Vellore", "Erode", "Thanjavur", "Kanchipuram", "Hosur", "Puducherry"
]
sports = [
    "Cricket", "Football", "Badminton", "Volleyball", "Basketball",
    "Athletics", "Kabaddi", "Kho-Kho", "Tennis", "Table Tennis", "None"
]
clubs = [
    "Science Club", "Coding Club", "Literary Club", "Music Club",
    "Dance Club", "Art Club", "Eco Club", "Robotics Club",
    "Quiz Club", "Drama Club", "None"
]

subjects = [
    "English_Marks", "Mathematics_Marks", "Science_Marks",
    "Social_Science_Marks", "Tamil_Marks", "Computer_Science_Marks"
]

def random_date(start_date, end_date):
    days = (end_date - start_date).days
    return start_date + timedelta(days=random.randint(0, days))

def format_date(date_value):
    return date_value.strftime("%d-%m-%Y")

def generate_marks():
    # About 20% of marks are below 50, representing failed subjects.
    if random.random() < 0.20:
        return random.randint(20, 49)
    return random.randint(50, 100)

start_dob = datetime(2008, 1, 1)
end_dob = datetime(2015, 12, 31)
start_admission = datetime(2019, 6, 1)
end_admission = datetime(2026, 6, 30)

headers = [
    "Student_ID", "Name", "Class", "DOB", "Admission_Date",
    *subjects, "Attendance_Percentage", "Residency", "City", "Sports", "Club"
]

with open("students_500.csv", "w", newline="", encoding="utf-8") as file:
    writer = csv.DictWriter(file, fieldnames=headers)
    writer.writeheader()

    for student_id in range(1, 501):
        dob = random_date(start_dob, end_dob)
        admission_date = random_date(start_admission, end_admission)

        # Ensures admission date does not occur before a student is 4 years old.
        minimum_admission = dob.replace(year=dob.year + 4)
        if admission_date < minimum_admission:
            admission_date = minimum_admission

        row = {
            "Student_ID": f"STU{student_id:04d}",
            "Name": f"{random.choice(first_names)} {random.choice(last_names)}",
            "Class": random.choice(classes),
            "DOB": format_date(dob),
            "Admission_Date": format_date(admission_date),
            "Attendance_Percentage": round(random.uniform(60, 100), 2),
            "Residency": random.choice(["Hosteller", "Day Scholar"]),
            "City": random.choice(cities),
            "Sports": random.choice(sports),
            "Club": random.choice(clubs)
        }

        for subject in subjects:
            row[subject] = generate_marks()

        writer.writerow(row)

print("students_500.csv created successfully with 500 records.")