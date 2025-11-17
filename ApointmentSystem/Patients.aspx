<%@ Page Title="Patients" Language="C#" MasterPageFile="~/Site1.Master"
    AutoEventWireup="true" CodeBehind="Patients.aspx.cs" Inherits="AppointmentSystem.Patients" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">

    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet" />
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css" rel="stylesheet" />
    <link href="https://cdn.jsdelivr.net/npm/select2@4.1.0-rc.0/dist/css/select2.min.css" rel="stylesheet" />
    <link href="https://cdn.jsdelivr.net/npm/select2-bootstrap-5-theme@1.3.0/dist/select2-bootstrap-5-theme.min.css" rel="stylesheet" />

    <style>
        body {
            background: linear-gradient(135deg, #f5f7fa 0%, #c3cfe2 100%);
            min-height: 100vh;
        }

        .form-container { max-width: 800px; margin: 40px auto; }
        .form-card { background: #fff; padding: 40px; border-radius: 12px; }
        .file-preview-img { width: 120px; height: 120px; border-radius: 8px; display: none; margin-top: 10px; }
        .file-input-wrapper input[type='file'] { display: none; }
        .file-input-label { padding: 12px; border: 1px dashed #ccc; cursor: pointer; background: #f5f5f5; }
    </style>

</asp:Content>


<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">

<div class="form-container">
    <div class="form-card">

        <h2><i class="fas fa-hospital-user"></i> Patient Registration</h2>
        <hr />

        <!-- PERSONAL INFO -->
        <h5><b>Personal Information</b></h5>

        <div class="form-group mt-3">
            <label>Full Name *</label>
            <input type="text" id="p_fullname" class="form-control" />
        </div>

        <div class="row mt-3">
            <div class="col-md-4">
                <label>Gender *</label>
                <select id="p_gender" class="form-control">
                    <option value="">Select gender</option>
                    <option>Male</option><option>Female</option>
                </select>
            </div>

            <div class="col-md-4">
                <label>Date of Birth *</label>
                <input type="date" id="p_dob" class="form-control" />
            </div>

            <div class="col-md-4">
                <label>Age</label>
                <input type="text" id="p_age" class="form-control" readonly />
            </div>
        </div>

        <div class="row mt-3">
            <div class="col-md-6">
                <label>Phone *</label>
                <input type="text" id="p_phone" class="form-control" />
            </div>

            <div class="col-md-6">
                <label>Email</label>
                <input type="email" id="p_email" class="form-control" />
            </div>
        </div>

        <div class="form-group mt-3">
            <label>Address *</label>
            <input type="text" id="p_address" class="form-control" />
        </div>

        <div class="row mt-3">
            <div class="col-md-6">
                <label>Emergency Name *</label>
                <input type="text" id="p_emg_name" class="form-control" />
            </div>

            <div class="col-md-6">
                <label>Emergency Phone *</label>
                <input type="text" id="p_emg_phone" class="form-control" />
            </div>
        </div>

        <hr />
        <h5><b>Medical Information</b></h5>

        <div class="row mt-3">
            <div class="col-md-6">
                <label>Blood Group *</label>
                <select id="p_blood" class="form-control">
                    <option value="">Select</option>
                    <option>A+</option><option>A-</option>
                    <option>B+</option><option>B-</option>
                    <option>O+</option><option>O-</option>
                    <option>AB+</option><option>AB-</option>
                </select>
            </div>

            <div class="col-md-6">
                <label>Current Medications</label>
                <input type="text" id="p_medications" class="form-control" />
            </div>
        </div>

        <hr />
        <h5><b>Documents</b></h5>

        <div class="row mt-3">

            <div class="col-md-6">
                <label>National ID / Passport PDF *</label>
                <div class="file-input-wrapper">
                    <label class="file-input-label">
                        <i class="fas fa-file-pdf"></i> <span id="idFileName">Choose PDF</span>
                        <input type="file" id="p_id_pdf" accept="application/pdf" />
                    </label>
                </div>
            </div>

            <div class="col-md-6">
                <label>Patient Photo *</label>
                <div class="file-input-wrapper">
                    <label class="file-input-label">
                        <i class="fas fa-image"></i> <span id="photoFileName">Choose image</span>
                        <input type="file" id="p_photo" accept="image/*" />
                    </label>
                </div>
                <img id="photoPreview" class="file-preview-img" />
            </div>

        </div>

        <button class="btn btn-primary mt-4" id="btnSavePatient">Register Patient</button>

    </div>
</div>

</asp:Content>

<asp:Content ID="Content3" ContentPlaceHolderID="scripts" runat="server">

<script src="https://code.jquery.com/jquery-3.7.1.min.js"></script>
<script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>

<script>

    // AUTO CALCULATE AGE
    $("#p_dob").change(function () {
        let dob = new Date($(this).val());
        if (!isNaN(dob)) {
            let diff = Date.now() - dob.getTime();
            let age = new Date(diff).getUTCFullYear() - 1970;
            $("#p_age").val(age);
        }
    });

    // SHOW FILE NAMES + PREVIEW
    $("#p_id_pdf").change(function () {
        $("#idFileName").text(this.files[0]?.name || "Choose PDF");
    });

    $("#p_photo").change(function () {
        const file = this.files[0];
        $("#photoFileName").text(file?.name || "Choose image");

        if (file) {
            let reader = new FileReader();
            reader.onload = e => $("#photoPreview").attr("src", e.target.result).show();
            reader.readAsDataURL(file);
        }
    });

    // Convert File → Base64
    function toBase64(file) {
        return new Promise((resolve) => {
            const reader = new FileReader();
            reader.onload = () => resolve(reader.result.split(',')[1]);
            reader.readAsDataURL(file);
        });
    }

    // VALIDATION
    function validate() {
        let fields = ["p_fullname", "p_gender", "p_dob", "p_phone", "p_address",
            "p_emg_name", "p_emg_phone", "p_blood", "p_id_pdf", "p_photo"];

        let ok = true;
        fields.forEach(id => {
            if (!$(`#${id}`).val()) {
                $(`#${id}`).addClass("is-invalid");
                ok = false;
            } else {
                $(`#${id}`).removeClass("is-invalid");
            }
        });

        return ok;
    }

    // SAVE PATIENT
    $("#btnSavePatient").click(async function (e) {
        e.preventDefault();

        if (!validate()) {
            Swal.fire("Missing Fields", "Please fill all required fields.", "warning");
            return;
        }

        Swal.fire({ title: "Saving...", allowOutsideClick: false, didOpen: () => Swal.showLoading() });

        let idFile = $("#p_id_pdf")[0].files[0];
        let photoFile = $("#p_photo")[0].files[0];

        let payload = {
            FullName: $("#p_fullname").val(),
            Gender: $("#p_gender").val(),
            DateOfBirth: $("#p_dob").val(),
            Age: $("#p_age").val(),
            Phone: $("#p_phone").val(),
            Email: $("#p_email").val(),
            Address: $("#p_address").val(),
            EmergencyContactName: $("#p_emg_name").val(),
            EmergencyContactPhone: $("#p_emg_phone").val(),

            BloodGroup: $("#p_blood").val(),
            CurrentMedications: $("#p_medications").val(),
            NationalID_PDF: idFile.name,

            PhotoBase64: await toBase64(photoFile),
            IDBase64: await toBase64(idFile)
        };



        $.ajax({
            url: "WebService1.asmx/InsertPatient",
            type: "POST",
            contentType: "application/json; charset=utf-8",
            data: JSON.stringify(payload),
            dataType: "json",

            success: function (res) {
                Swal.close();

                if (res.d.status === "SUCCESS") {
                    Swal.fire("Success", res.d.message, "success");
                } else {
                    Swal.fire("Error", res.d.message, "error");
                }
            },

            error: function () {
                Swal.close();
                Swal.fire("Server Error", "Could not save patient.", "error");
            }
        });

    });
</script>

</asp:Content>
