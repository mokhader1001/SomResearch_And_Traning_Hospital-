<%@ Page Title="Dashboard" Language="C#" MasterPageFile="~/Site1.Master"
    AutoEventWireup="true" CodeBehind="Dashboard.aspx.cs" Inherits="AppointmentSystem.Dashboard" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <style>
        .card-box {
            padding: 25px;
            border-radius: 10px;
            background: #ffffff;
            box-shadow: 0 2px 10px rgba(0,0,0,0.08);
            text-align: center;
            transition: 0.3s;
        }

        .card-box:hover {
            transform: translateY(-3px);
        }

        .stat-number {
            font-size: 35px;
            font-weight: bold;
            margin-top: 10px;
        }

        .stat-title {
            font-size: 18px;
            color: #555;
        }
    </style>
</asp:Content>


<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">

    <h2 class="mb-4">Dashboard</h2>

    <div class="row g-4">

        <!-- Appointments -->
        <div class="col-md-4">
            <div class="card-box">
                <i class="fa fa-calendar fa-2x text-primary"></i>
                <div class="stat-title">Total Appointments</div>
                <div class="stat-number" id="totalAppointments">0</div>
            </div>
        </div>

        <!-- Doctors -->
        <div class="col-md-4">
            <div class="card-box">
                <i class="fa fa-user-md fa-2x text-success"></i>
                <div class="stat-title">Total Doctors</div>
                <div class="stat-number" id="totalDoctors">0</div>
            </div>
        </div>

        <!-- Patients -->
        <div class="col-md-4">
            <div class="card-box">
                <i class="fa fa-users fa-2x text-danger"></i>
                <div class="stat-title">Total Patients</div>
                <div class="stat-number" id="totalPatients">0</div>
            </div>
        </div>

    </div>

    <hr class="my-4">

    <h4>Appointment Chart</h4>
    <canvas id="appointmentChart" height="120"></canvas>

</asp:Content>



<asp:Content ID="Content3" ContentPlaceHolderID="scripts" runat="server">

    <script src="https://cdn.jsdelivr.net/npm/chart.js"></script>

    <script>
        // Dummy sample numbers (replace later with database values)
        document.getElementById("totalAppointments").innerText = 42;
        document.getElementById("totalDoctors").innerText = 8;
        document.getElementById("totalPatients").innerText = 134;

        // Chart.js Line Chart
        const ctx = document.getElementById('appointmentChart');

        new Chart(ctx, {
            type: 'line',
            data: {
                labels: ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat'],
                datasets: [{
                    label: 'Appointments',
                    data: [5, 9, 7, 10, 12, 4],
                    borderWidth: 3
                }]
            },
            options: {
                responsive: true,
                tension: 0.4
            }
        });
    </script>

</asp:Content>
