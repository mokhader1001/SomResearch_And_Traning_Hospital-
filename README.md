# 🏥 SomResearch & Training Hospital — Appointment Booking System

A modern **hospital appointment booking system** built using **ASP.NET WebForms**, **C#**, **AJAX Web Services (.asmx)**, and **SQL Server**.  
The system allows both hospital staff **and patients themselves** to book appointments easily and securely.

This is NOT a full hospital management system —  
✔ Focused purely on **appointment scheduling**  
✔ Fully extendable for future modules  
✔ Supports patient self-booking portal  

---

## 🚀 System Overview

The project provides two modes of booking:

### 1️⃣ **Admin/Reception Mode**
Hospital staff can:
- Register patients  
- Register doctors  
- Create appointments  
- Manage bookings  

### 2️⃣ **Self-Service Patient Booking**
Patients can:
- Search available doctors  
- Choose specialty  
- Pick available time slots  
- Submit booking request  
- Receive confirmation  

---

## 📌 Key Features

### ✔ 1. Patient Registration (Admin)
Staff can register full patient details:
- Personal info  
- DOB (age auto-calculated)  
- Medical info  
- Emergency contact  
- Blood group  
- Medications  
- National ID / Passport (PDF)  
- Patient photo (Base64)

---

### ✔ 2. Doctor Registration
- Doctor profile  
- Specialization  
- License number  
- Certification PDF  
- Profile image  
- Contact info  

---

### ✔ 3. Appointment Booking (Admin Mode)
Staff selects:
- Patient  
- Doctor  
- Date  
- Time  
- Payment method (EVC, Salaam, Waafi, Premier Wallet)  
- Optional notes  
### 3.1 User can book Apointment Directly Through his Phone
---

### ✔ 4. ⭐ Patient Self-Booking Portal (NEW)
Patients can book appointments on their own via a front-facing page.

#### How patient booking works:
1. Patient opens the booking page  
2. Selects a specialty  
3. System displays available doctors  
4. Patient picks:
   - Doctor  
   - Date  
   - Time  
   - Payment method  
5. The booking is saved to the database  
6. Confirmation is shown immediately  

#### Optional enhancements (already supported structurally):
- SMS confirmation  
- Email confirmation  
- OTP verification  

This feature lets the hospital offer **public online booking**.

---


