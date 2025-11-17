<%@ Page Title="Appointments" Language="C#" MasterPageFile="~/Site1.Master"
    AutoEventWireup="true" CodeBehind="Appointments.aspx.cs" Inherits="AppointmentSystem.Appointments" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">

    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet" />
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css" rel="stylesheet" />
    <link href="https://cdn.jsdelivr.net/npm/select2@4.1.0-rc.0/dist/css/select2.min.css" rel="stylesheet" />
    <link href="https://cdn.jsdelivr.net/npm/select2-bootstrap-5-theme@1.3.0/dist/select2-bootstrap-5-theme.min.css" rel="stylesheet" />

    <style>
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }

        body {
            background: linear-gradient(135deg, #f8f9fa 0%, #e9ecef 100%);
            min-height: 100vh;
            font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', 'Roboto', 'Oxygen', 'Ubuntu', 'Cantarell', sans-serif;
            padding: 40px 0;
        }

        .form-wrapper {
            max-width: 850px;
            margin: 0 auto;
            padding: 0 15px;
        }

        .form-header {
            text-align: center;
            margin-bottom: 40px;
        }

        .form-header h1 {
            font-size: 36px;
            font-weight: 700;
            color: #1a1a1a;
            margin-bottom: 8px;
            letter-spacing: -0.5px;
        }

        .form-header p {
            font-size: 16px;
            color: #6c757d;
            margin: 0;
        }

        .form-card {
            background: white;
            border-radius: 16px;
            padding: 48px;
            box-shadow: 0 10px 40px rgba(0, 0, 0, 0.08);
            border: 1px solid rgba(0, 0, 0, 0.05);
        }

        .form-section {
            margin-bottom: 40px;
        }

        .form-section:last-child {
            margin-bottom: 0;
        }

        .section-title {
            font-size: 16px;
            font-weight: 600;
            color: #1a1a1a;
            margin-bottom: 20px;
            display: flex;
            align-items: center;
            gap: 10px;
        }

        .section-title .icon {
            width: 32px;
            height: 32px;
            background: linear-gradient(135deg, #0066cc 0%, #0052a3 100%);
            border-radius: 8px;
            display: flex;
            align-items: center;
            justify-content: center;
            color: white;
            font-size: 14px;
        }

        .form-group {
            margin-bottom: 20px;
        }

        .form-group label {
            font-size: 14px;
            font-weight: 600;
            color: #1a1a1a;
            margin-bottom: 8px;
            display: block;
        }

        .form-group label .required {
            color: #dc3545;
        }

        .form-control, .select2-container--bootstrap-5 .select2-selection {
            border: 1px solid #d9d9d9;
            border-radius: 8px;
            padding: 12px 16px;
            font-size: 14px;
            transition: all 0.3s ease;
            background-color: #f9f9f9;
        }

        .form-control:focus, .select2-container--bootstrap-5 .select2-selection:focus {
            border-color: #0066cc;
            background-color: white;
            box-shadow: 0 0 0 3px rgba(0, 102, 204, 0.1);
        }

        .form-row {
            display: grid;
            grid-template-columns: 1fr 1fr;
            gap: 20px;
        }

        @media (max-width: 640px) {
            .form-row {
                grid-template-columns: 1fr;
            }
        }

        /* PAYMENT SECTION - Image Cards */
        .payment-methods {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(180px, 1fr));
            gap: 16px;
            margin-top: 20px;
        }

        .payment-card {
            position: relative;
            cursor: pointer;
            border: 2px solid #d9d9d9;
            border-radius: 12px;
            padding: 20px;
            text-align: center;
            transition: all 0.3s ease;
            background: #fafafa;
            display: flex;
            align-items: center;
            justify-content: center;
            min-height: 140px;
            flex-direction: column;
        }

        .payment-card:hover {
            border-color: #0066cc;
            background: #f0f7ff;
            transform: translateY(-4px);
            box-shadow: 0 8px 20px rgba(0, 102, 204, 0.15);
        }

        .payment-card img {
            max-width: 100%;
            max-height: 70px;
            margin-bottom: 10px;
            object-fit: contain;
        }

        .payment-card .payment-name {
            font-size: 12px;
            font-weight: 600;
            color: #666;
            text-transform: uppercase;
            letter-spacing: 0.5px;
        }

        .payment-card.selected {
            border-color: #0066cc;
            background: linear-gradient(135deg, #f0f7ff 0%, #e6f2ff 100%);
            box-shadow: 0 8px 20px rgba(0, 102, 204, 0.2);
        }

        .payment-card.selected::after {
            content: '✓';
            position: absolute;
            top: -8px;
            right: -8px;
            background: #0066cc;
            color: white;
            width: 28px;
            height: 28px;
            border-radius: 50%;
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 16px;
            font-weight: bold;
            border: 3px solid white;
            box-shadow: 0 2px 8px rgba(0, 102, 204, 0.3);
        }

        .hidden-payment-input {
            display: none;
        }

        /* NOTES SECTION */
        textarea.form-control {
            resize: vertical;
            min-height: 100px;
            font-family: inherit;
        }

        /* BUTTONS */
        .form-actions {
            display: flex;
            gap: 12px;
            justify-content: flex-end;
            margin-top: 32px;
            padding-top: 32px;
            border-top: 1px solid #e9ecef;
        }

        .btn-primary {
            background: linear-gradient(135deg, #0066cc 0%, #0052a3 100%);
            border: none;
            padding: 14px 40px;
            border-radius: 8px;
            font-weight: 600;
            font-size: 14px;
            color: white;
            cursor: pointer;
            transition: all 0.3s ease;
            display: flex;
            align-items: center;
            gap: 8px;
            box-shadow: 0 4px 12px rgba(0, 102, 204, 0.3);
        }

        .btn-primary:hover {
            transform: translateY(-2px);
            box-shadow: 0 6px 20px rgba(0, 102, 204, 0.4);
            background: linear-gradient(135deg, #0052a3 0%, #003d7a 100%);
        }

        .btn-primary:active {
            transform: translateY(0);
        }

        .btn-reset {
            background: white;
            border: 1px solid #d9d9d9;
            padding: 14px 40px;
            border-radius: 8px;
            font-weight: 600;
            font-size: 14px;
            color: #666;
            cursor: pointer;
            transition: all 0.3s ease;
        }

        .btn-reset:hover {
            background: #f9f9f9;
            border-color: #999;
        }

        .form-info {
            background: linear-gradient(135deg, #e6f2ff 0%, #f0f7ff 100%);
            border-left: 4px solid #0066cc;
            padding: 16px;
            border-radius: 8px;
            margin-bottom: 20px;
        }

        .form-info p {
            margin: 0;
            font-size: 14px;
            color: #0052a3;
            display: flex;
            align-items: center;
            gap: 10px;
        }

        /* Select2 Customization */
        .select2-container--bootstrap-5 .select2-selection {
            height: auto;
            min-height: 44px;
        }

        .select2-container--bootstrap-5 .select2-selection--single .select2-selection__rendered {
            padding: 8px 0;
        }

        @media (max-width: 768px) {
            .form-card {
                padding: 24px;
            }

            .form-header h1 {
                font-size: 28px;
            }

            .payment-methods {
                grid-template-columns: repeat(auto-fit, minmax(140px, 1fr));
            }

            .form-actions {
                flex-direction: column;
            }

            .btn-primary, .btn-reset {
                width: 100%;
                justify-content: center;
            }
        }
    </style>

</asp:Content>



<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">

<div class="form-wrapper">

    <div class="form-header">
        <h1>Book Your Appointment</h1>
        <p>Schedule a consultation with our healthcare professionals</p>
    </div>

    <div class="form-card">

        <!-- INFO BANNER -->
        <div class="form-info">
            <p><i class="fas fa-info-circle"></i> All fields marked with <span class="text-danger">*</span> are required</p>
        </div>

        <!-- SECTION 1: PATIENT & DOCTOR -->
        <div class="form-section">
            <div class="section-title">
                <div class="icon">1</div>
                Select Healthcare Provider
            </div>

            <div class="form-group">
                <label>Patient <span class="required">*</span></label>
                <select id="patient" class="form-control select2"></select>
            </div>

            <div class="form-group">
                <label>Doctor <span class="required">*</span></label>
                <select id="doctor" class="form-control select2"></select>
            </div>
        </div>

        <!-- SECTION 2: DATE & TIME -->
        <div class="form-section">
            <div class="section-title">
                <div class="icon">2</div>
                Choose Date & Time
            </div>

            <div class="form-row">
                <div class="form-group">
                    <label>Appointment Date <span class="required">*</span></label>
                    <input type="date" id="date" class="form-control" />
                </div>

                <div class="form-group">
                    <label>Appointment Time <span class="required">*</span></label>
                    <input type="time" id="time" class="form-control" />
                </div>
            </div>

            <div class="form-group">
                <label>Appointment Fee</label>
                <input type="text" id="fee" class="form-control" value="10" readonly style="background-color: #f0f0f0; cursor: not-allowed;" />
            </div>
        </div>

        <!-- SECTION 3: PAYMENT METHOD -->
        <div class="form-section">
            <div class="section-title">
                <div class="icon">3</div>
                Select Payment Method
            </div>

            <p style="font-size: 14px; color: #666; margin-bottom: 20px;">Choose your preferred payment provider</p>

            <!-- Replaced dropdown with image-based payment selection cards -->
            <div class="payment-methods" id="paymentMethods">
                <div class="payment-card" data-payment="Salaam Bank">
                    <img src="/images/salamBank.png" alt="Salaam Bank" />
                    <div class="payment-name">Salaam Bank</div>
                </div>

                <div class="payment-card" data-payment="EVC Plus">
                    <img src="/images/evc.jpg" alt="EVC Plus" />
                    <div class="payment-name">EVC Plus</div>
                </div>

                <div class="payment-card" data-payment="Premier Wallet">
                    <img src="/images/premierwallet.png" alt="Premier Wallet" />
                    <div class="payment-name">Premier Wallet</div>
                </div>

                <div class="payment-card" data-payment="Waafi Pay">
                    <img src="/images/waafi.png" alt="Waafi Pay" />
                    <div class="payment-name">Waafi Pay</div>
                </div>
            </div>

            <input type="hidden" id="payment" class="hidden-payment-input" />
        </div>

        <!-- SECTION 4: NOTES -->
        <div class="form-section">
            <div class="section-title">
                <div class="icon">4</div>
                Additional Information
            </div>

            <div class="form-group">
                <label>Description / Notes</label>
                <textarea id="notes" class="form-control" placeholder="Enter any additional notes or concerns (optional)"></textarea>
            </div>
        </div>

        <!-- ACTIONS -->
        <div class="form-actions">
            <button type="button" class="btn-reset" id="btnReset">
                <i class="fas fa-redo"></i> Clear Form
            </button>
            <button type="button" id="btnSave" class="btn-primary">
                <i class="fas fa-check-circle"></i> Confirm Appointment
            </button>
        </div>

    </div>
</div>

</asp:Content>



<asp:Content ID="Content3" ContentPlaceHolderID="scripts" runat="server">

<script src="https://code.jquery.com/jquery-3.7.1.min.js"></script>
<script src="https://cdn.jsdelivr.net/npm/select2@4.1.0-rc.0/dist/js/select2.min.js"></script>
<script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>

<script>


    // ============================
    // INITIALIZE PAGE
    // ============================
    $(document).ready(function () {
        $(".select2").select2({ theme: "bootstrap-5", width: "100%" });
        loadPatients();
        loadDoctors();
        setupPaymentCards();
    });

    // ============================
    // PAYMENT CARD SELECTION
    // ============================
    function setupPaymentCards() {
        $(".payment-card").click(function () {
            $(".payment-card").removeClass("selected");
            $(this).addClass("selected");

            let selectedPayment = $(this).data("payment");
            $("#payment").val(selectedPayment);
        });
    }

    // ============================
    // LOAD PATIENTS
    // ============================
    function loadPatients() {
        $.ajax({
            url: "WebService1.asmx/GetPatients",
            type: "POST",
            contentType: "application/json; charset=utf-8",
            dataType: "json",

            success: function (res) {
                let data = res.d;

                $("#patient").empty().append(`<option value="">Select Patient</option>`);

                data.forEach(p => {
                    $("#patient").append(`
                        <option value="${p.PatientID}">
                            ${p.FullName}
                        </option>
                    `);
                });
            },

            error: function () {
                Swal.fire("Error", "Cannot load patients!", "error");
            }
        });
    }

    // ============================
    // LOAD DOCTORS
    // ============================
    function loadDoctors() {

        $.ajax({
            url: "WebService1.asmx/GetDoctors",
            type: "POST",
            contentType: "application/json; charset=utf-8",
            dataType: "json",

            success: function (res) {
                let data = res.d;

                $("#doctor").empty().append(`<option value="">Select Doctor</option>`);

                data.forEach(d => {
                    $("#doctor").append(`
                        <option value="${d.DoctorID}">
                            ${d.FullName} (${d.Specialty})
                        </option>
                    `);
                });
            },

            error: function () {
                Swal.fire("Error", "Cannot load doctors!", "error");
            }
        });
    }

    // ============================
    // SAVE APPOINTMENT (KEEPS WORKING API)
    // ============================
    $("#btnSave").click(function () {

        let payload = {
            PatientID: $("#patient").val(),
            DoctorID: $("#doctor").val(),
            AppointmentDate: $("#date").val(),
            AppointmentTime: $("#time").val(),
            PaymentMethod: $("#payment").val(),
            Notes: $("#notes").val()
        };

        // required fields
        if (!payload.PatientID || !payload.DoctorID || !payload.AppointmentDate || !payload.AppointmentTime || !payload.PaymentMethod) {
            Swal.fire("Missing Fields", "Please fill all required fields.", "warning");
            return;
        }

        $.ajax({
            url: "WebService1.asmx/InsertAppointment",
            type: "POST",
            contentType: "application/json; charset=utf-8",
            data: JSON.stringify(payload),
            dataType: "json",

            success: function (res) {

                if (res.d.status === "SUCCESS") {
                    Swal.fire("Success", res.d.message, "success");

                    // Reset manually
                    $("#patient").val("").trigger("change");
                    $("#doctor").val("").trigger("change");
                    $("#date").val("");
                    $("#time").val("");
                    $("#payment").val("");
                    $("#notes").val("");
                    $(".payment-card").removeClass("selected");

                } else {
                    Swal.fire("Error", res.d.message, "error");
                }
            },

            error: function () {
                Swal.fire("Error", "Failed to save appointment", "error");
            }
        });

    });

    // ============================
    // RESET FORM
    // ============================
    $("#btnReset").click(function () {
        $("#patient").val("").trigger("change");
        $("#doctor").val("").trigger("change");
        $("#date").val("");
        $("#time").val("");
        $("#payment").val("");
        $("#notes").val("");
        $(".payment-card").removeClass("selected");
    });

</script>

</asp:Content>
