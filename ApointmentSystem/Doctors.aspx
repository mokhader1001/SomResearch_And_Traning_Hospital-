<%@ Page Title="Doctors" Language="C#" MasterPageFile="~/Site1.Master"
    AutoEventWireup="true" CodeBehind="Doctors.aspx.cs" Inherits="AppointmentSystem.Doctors" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">

    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet" />
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css" rel="stylesheet" />
    <!-- Added Select2 CSS for styled dropdown -->
    <link href="https://cdn.jsdelivr.net/npm/select2@4.1.0-rc.0/dist/css/select2.min.css" rel="stylesheet" />
    <link href="https://cdn.jsdelivr.net/npm/select2-bootstrap-5-theme@1.3.0/dist/select2-bootstrap-5-theme.min.css" rel="stylesheet" />

    <style>
        body {
            background: linear-gradient(135deg, #f5f7fa 0%, #c3cfe2 100%);
            min-height: 100vh;
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
        }

        .form-container {
            max-width: 800px;
            margin: 40px auto;
        }

        .form-card {
            background: #ffffff;
            border-radius: 12px;
            box-shadow: 0 8px 24px rgba(0, 0, 0, 0.12);
            padding: 40px;
            border-top: 5px solid #0066cc;
        }

        .form-title {
            font-size: 28px;
            font-weight: 700;
            color: #1a1a1a;
            margin-bottom: 10px;
        }

        .form-subtitle {
            color: #666;
            margin-bottom: 30px;
            font-size: 14px;
        }

        .form-section {
            margin-bottom: 32px;
        }

        .section-title {
            font-size: 16px;
            font-weight: 600;
            color: #0066cc;
            margin-bottom: 20px;
            padding-bottom: 10px;
            border-bottom: 1px solid #e0e0e0;
            text-transform: uppercase;
            letter-spacing: 0.5px;
        }

        .form-group {
            margin-bottom: 20px;
        }

        label {
            font-weight: 600;
            color: #333;
            margin-bottom: 8px;
            display: block;
            font-size: 14px;
        }

        .form-control {
            border: 1px solid #d0d0d0;
            border-radius: 6px;
            padding: 12px 14px;
            font-size: 14px;
            transition: all 0.3s ease;
            height: auto;
        }

        .form-control:focus {
            border-color: #0066cc;
            box-shadow: 0 0 0 3px rgba(0, 102, 204, 0.1);
            outline: none;
        }

        .form-control::placeholder {
            color: #999;
        }

        select.form-control {
            cursor: pointer;
        }

        /* Select2 custom styling for consistency */
        .select2-container--bootstrap-5 .select2-selection {
            border: 1px solid #d0d0d0;
            border-radius: 6px;
            min-height: 38px;
            padding: 6px;
        }

        .select2-container--bootstrap-5.select2-container--focus .select2-selection {
            border-color: #0066cc;
            box-shadow: 0 0 0 3px rgba(0, 102, 204, 0.1);
        }

        .select2-container--bootstrap-5 .select2-selection--single .select2-selection__rendered {
            padding-left: 8px;
            color: #333;
        }

        .input-group {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(250px, 1fr));
            gap: 20px;
        }

        .input-group.full {
            grid-template-columns: 1fr;
        }

        .doctor-img-preview {
            width: 120px;
            height: 120px;
            object-fit: cover;
            border-radius: 8px;
            display: none;
            border: 3px solid #0066cc;
            margin-top: 12px;
        }

        .file-input-wrapper {
            position: relative;
            overflow: hidden;
        }

        .file-input-label {
            display: flex;
            align-items: center;
            gap: 8px;
            padding: 12px 14px;
            background: #f5f5f5;
            border: 1px dashed #d0d0d0;
            border-radius: 6px;
            cursor: pointer;
            transition: all 0.3s ease;
            color: #666;
            font-size: 14px;
        }

        .file-input-label:hover {
            background: #efefef;
            border-color: #0066cc;
            color: #0066cc;
        }

        .file-input-wrapper input[type="file"] {
            display: none;
        }

        .button-group {
            display: flex;
            gap: 12px;
            margin-top: 40px;
            justify-content: flex-end;
        }

        .btn-primary {
            background: #0066cc;
            border: none;
            border-radius: 6px;
            padding: 12px 32px;
            font-weight: 600;
            font-size: 15px;
            cursor: pointer;
            transition: all 0.3s ease;
            display: flex;
            align-items: center;
            gap: 8px;
        }

        .btn-primary:hover {
            background: #0052a3;
            transform: translateY(-2px);
            box-shadow: 0 4px 12px rgba(0, 102, 204, 0.3);
        }

        .btn-secondary {
            background: #e0e0e0;
            border: none;
            border-radius: 6px;
            padding: 12px 32px;
            font-weight: 600;
            font-size: 15px;
            cursor: pointer;
            color: #333;
            transition: all 0.3s ease;
        }

        .btn-secondary:hover {
            background: #d0d0d0;
        }

        .required-mark {
            color: #d32f2f;
            margin-left: 4px;
        }

        .success-message {
            background: #4caf50;
            color: white;
            padding: 14px 16px;
            border-radius: 6px;
            margin-bottom: 20px;
            display: none;
            align-items: center;
            gap: 10px;
        }

        .error-message {
            background: #f44336;
            color: white;
            padding: 14px 16px;
            border-radius: 6px;
            margin-bottom: 20px;
            display: none;
            align-items: center;
            gap: 10px;
        }

        @media (max-width: 768px) {
            .form-card {
                padding: 24px;
            }

            .form-title {
                font-size: 24px;
            }

            .button-group {
                flex-direction: column;
            }

            .btn-primary, .btn-secondary {
                width: 100%;
            }
        }
    </style>

</asp:Content>


<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">

    <div class="form-container">

        <div class="form-card">

            <div class="success-message" id="successMessage">
                <i class="fas fa-check-circle"></i>
                <span id="successText">Doctor registered successfully!</span>
            </div>

            <div class="error-message" id="errorMessage">
                <i class="fas fa-times-circle"></i>
                <span id="errorText">Please fill in all required fields.</span>
            </div>

            <h1 class="form-title"><i class="fas fa-user-md"></i> Doctor Registration</h1>
            <p class="form-subtitle">Complete all fields to register a new medical professional</p>

            <!-- Personal Information Section -->
            <div class="form-section">
                <h3 class="section-title">Personal Information</h3>

                <div class="form-group">
                    <label>Full Name <span class="required-mark">*</span></label>
                    <input type="text" id="name" class="form-control" placeholder="Enter full name" required />
                </div>

                <div class="input-group">
                    <div class="form-group">
                        <label>Gender <span class="required-mark">*</span></label>
                        <select id="gender" class="form-control" required>
                            <option value="">Select gender</option>
                            <option value="Male">Male</option>
                            <option value="Female">Female</option>
                            <option value="Other">Other</option>
                        </select>
                    </div>

                    <div class="form-group">
                        <label>Email Address <span class="required-mark">*</span></label>
                        <input type="email" id="email" class="form-control" placeholder="doctor@example.com" required />
                    </div>

                    <div class="form-group">
                        <label>Phone Number <span class="required-mark">*</span></label>
                        <input type="tel" id="phone" class="form-control" placeholder="+252 61 XXXXXXX" required />
                    </div>
                </div>

                <div class="form-group">
                    <label>Address <span class="required-mark">*</span></label>
                    <input type="text" id="address" class="form-control" placeholder="Street address, city, country" required />
                </div>
            </div>

            <!-- Professional Information Section -->
            <div class="form-section">
                <h3 class="section-title">Professional Information</h3>

                <div class="input-group">
                    <div class="form-group">
                        <!-- Changed specialty input to Select2 dropdown with medical specialties -->
                        <label>Specialty <span class="required-mark">*</span></label>
                        <select id="specialty" class="form-control select2-specialty" required>
                            <option value="">Select specialty</option>
                            <option value="Cardiology">Cardiology</option>
                            <option value="Neurology">Neurology</option>
                            <option value="Orthopedics">Orthopedics</option>
                            <option value="Dermatology">Dermatology</option>
                            <option value="Pediatrics">Pediatrics</option>
                            <option value="Psychiatry">Psychiatry</option>
                            <option value="General Surgery">General Surgery</option>
                            <option value="Ophthalmology">Ophthalmology</option>
                            <option value="Otolaryngology">Otolaryngology (ENT)</option>
                            <option value="Urology">Urology</option>
                            <option value="Gynecology">Gynecology</option>
                            <option value="Obstetrics">Obstetrics</option>
                            <option value="Oncology">Oncology</option>
                            <option value="Gastroenterology">Gastroenterology</option>
                            <option value="Pulmonology">Pulmonology</option>
                            <option value="Nephrology">Nephrology</option>
                            <option value="Endocrinology">Endocrinology</option>
                            <option value="Rheumatology">Rheumatology</option>
                            <option value="Infectious Diseases">Infectious Diseases</option>
                            <option value="Hematology">Hematology</option>
                            <option value="Radiology">Radiology</option>
                            <option value="Anesthesiology">Anesthesiology</option>
                            <option value="Dentistry">Dentistry</option>
                            <option value="Pathology">Pathology</option>
                            <option value="Emergency Medicine">Emergency Medicine</option>
                            <option value="Physical Medicine">Physical Medicine & Rehabilitation</option>
                            <option value="Nuclear Medicine">Nuclear Medicine</option>
                            <option value="Psychiatry">Psychiatry</option>
                            <option value="General Practice">General Practice</option>
                            <option value="Internal Medicine">Internal Medicine</option>
                        </select>
                    </div>

                    <div class="form-group">
                        <label>License/Certification Number <span class="required-mark">*</span></label>
                        <input type="text" id="cert_no" class="form-control" placeholder="Medical license number" required />
                    </div>
                </div>
            </div>

            <!-- Documents Section -->
            <div class="form-section">
                <h3 class="section-title">Documents & Photo</h3>

                <div class="input-group">
                    <div class="form-group">
                        <label>Certification Document (PDF) <span class="required-mark">*</span></label>
                        <div class="file-input-wrapper">
                            <label class="file-input-label">
                                <i class="fas fa-file-pdf"></i>
                                <span id="pdfFileName">Choose PDF file</span>
                                <input type="file" id="pdf_file" accept="application/pdf" required />
                            </label>
                        </div>
                    </div>

                    <div class="form-group">
                        <label>Professional Photo <span class="required-mark">*</span></label>
                        <div class="file-input-wrapper">
                            <label class="file-input-label">
                                <i class="fas fa-image"></i>
                                <span id="imageFileName">Choose image</span>
                                <input type="file" id="image_file" accept="image/*" required />
                            </label>
                        </div>
                        <img id="previewImg" class="doctor-img-preview" />
                    </div>
                </div>
            </div>

            <div class="button-group">
                <button type="reset" class="btn-secondary"><i class="fas fa-redo"></i> Clear Form</button>
                <button id="btnSave" class="btn-primary"><i class="fas fa-save"></i> Register Doctor</button>
            </div>

        </div>

    </div>

</asp:Content>


<asp:Content ID="Content3" ContentPlaceHolderID="scripts" runat="server">

    <script src="https://code.jquery.com/jquery-3.7.1.min.js"></script>
    <!-- Added Select2 JS library -->
    <script src="https://cdn.jsdelivr.net/npm/select2@4.1.0-rc.0/dist/js/select2.min.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>


   <script>

       $(document).ready(function () {
           $("#specialty").select2({
               theme: "bootstrap-5",
               width: "100%",
               placeholder: "Select or search specialty...",
               allowClear: true
           });
       });

       // Show Selected PDF Name
       $("#pdf_file").change(function () {
           $("#pdfFileName").text(this.files[0]?.name || "Choose PDF file");
       });

       // Show Selected Image Name + Preview
       $("#image_file").change(function () {
           const file = this.files[0];
           $("#imageFileName").text(file?.name || "Choose image");

           if (file) {
               let reader = new FileReader();
               reader.onload = e => $("#previewImg").attr("src", e.target.result).show();
               reader.readAsDataURL(file);
           }
       });

       // Convert file → Base64
       function toBase64(file) {
           return new Promise((resolve) => {
               const reader = new FileReader();
               reader.onload = () => resolve(reader.result.split(',')[1]);
               reader.readAsDataURL(file);
           });
       }

       // Validate required fields
       function validateForm() {
           const required = [
               "name", "gender", "email", "phone",
               "address", "specialty", "cert_no",
               "pdf_file", "image_file"
           ];

           let valid = true;

           required.forEach(id => {
               const value = $(`#${id}`).val();
               if (!value || value.trim() === "") {
                   $(`#${id}`).addClass("is-invalid");
                   valid = false;
               } else {
                   $(`#${id}`).removeClass("is-invalid");
               }
           });

           return valid;
       }

       // 🔥 SAVE BUTTON CLICK 🔥
       $("#btnSave").click(async function (e) {
           e.preventDefault();  // stopping page refresh

           if (!validateForm()) {
               Swal.fire("Missing Fields", "Please fill all required fields.", "warning");
               return;
           }

           Swal.fire({
               title: "Saving Doctor...",
               text: "Please wait",
               allowOutsideClick: false,
               didOpen: () => Swal.showLoading()
           });

           const pdfFile = $("#pdf_file")[0].files[0];
           const imgFile = $("#image_file")[0].files[0];

           // Convert files to Base64
           const pdfBase64 = await toBase64(pdfFile);
           const imgBase64 = await toBase64(imgFile);

           const payload = {
               FullName: $("#name").val(),
               Gender: $("#gender").val(),
               Email: $("#email").val(),
               Phone: $("#phone").val(),
               Address: $("#address").val(),
               Specialty: $("#specialty").val(),
               LicenseNumber: $("#cert_no").val(),
               CertificationPDF: pdfBase64,
               PhotoURL: imgBase64
           };

           $.ajax({
               url: "WebService1.asmx/InsertDoctor",
               type: "POST",
               contentType: "application/json; charset=utf-8",
               data: JSON.stringify(payload),
               dataType: "json",
               success: function (res) {
                   Swal.close();

                   if (res.d.status === "SUCCESS") {

                       Swal.fire({
                           icon: "success",
                           title: "Doctor Registered!",
                           text: res.d.message,
                           timer: 3500
                       });

                       // Reset form
                       $("form")[0].reset();
                       $("#specialty").val(null).trigger("change");
                       $("#previewImg").hide();
                       $("#pdfFileName").text("Choose PDF file");
                       $("#imageFileName").text("Choose image");

                   } else {

                       Swal.fire({
                           icon: "error",
                           title: "Error",
                           text: res.d.message
                       });

                   }
               },
               error: function (err) {
                   Swal.close();
                   Swal.fire({
                       icon: "error",
                       title: "Request Failed",
                       text: "Could not save doctor. Check console."
                   });
                   console.error("API Error:", err);
               }
           });

       });

   </script>


</asp:Content>
