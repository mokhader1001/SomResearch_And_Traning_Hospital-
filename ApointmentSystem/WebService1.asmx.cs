using System;
using System.Collections.Generic;
using System.Data;
using System.Data.SqlClient;
using System.IO;
using System.Web;
using System.Web.Script.Services;
using System.Web.Services;

namespace AppointmentSystem
{
    [WebService(Namespace = "http://tempuri.org/")]
    [ScriptService] // enables AJAX + JSON
    public class WebService1 : WebService
    {
        // Your SQL Server connection
        private readonly string cs =
            System.Configuration.ConfigurationManager.ConnectionStrings["db"].ConnectionString;

        // ---------------- INSERT DOCTOR ----------------
        [WebMethod]
        [ScriptMethod(ResponseFormat = ResponseFormat.Json)]

        public object InsertDoctor(
    string FullName,
    string Gender,
    string Email,
    string Phone,
    string Address,
    string Specialty,
    string LicenseNumber,
    string CertificationPDF,   // base64
    string PhotoURL            // base64
)
        {
            try
            {
                string folder = HttpContext.Current.Server.MapPath("~/DoctorFiles/");
                if (!Directory.Exists(folder))
                    Directory.CreateDirectory(folder);

                string pdfPath = "";
                string photoPath = "";

                // ------ Save Certification PDF ------
                if (!string.IsNullOrEmpty(CertificationPDF))
                {
                    byte[] pdfBytes = Convert.FromBase64String(CertificationPDF);
                    string pdfFileName = "cert_" + Guid.NewGuid() + ".pdf";
                    pdfPath = "/DoctorFiles/" + pdfFileName;
                    File.WriteAllBytes(folder + pdfFileName, pdfBytes);
                }

                // ------ Save Doctor Photo ------
                if (!string.IsNullOrEmpty(PhotoURL))
                {
                    byte[] imgBytes = Convert.FromBase64String(PhotoURL);
                    string imgFileName = "photo_" + Guid.NewGuid() + ".jpg";
                    photoPath = "/DoctorFiles/" + imgFileName;
                    File.WriteAllBytes(folder + imgFileName, imgBytes);
                }

                // ------ Save to Database ------
                using (SqlConnection con = new SqlConnection(cs))
                using (SqlCommand cmd = new SqlCommand("usp_Doctors_CRUD", con))
                {
                    cmd.CommandType = CommandType.StoredProcedure;

                    cmd.Parameters.AddWithValue("@Action", "INSERT");
                    cmd.Parameters.AddWithValue("@DoctorID", DBNull.Value);

                    cmd.Parameters.AddWithValue("@FullName", FullName);
                    cmd.Parameters.AddWithValue("@Gender", Gender);
                    cmd.Parameters.AddWithValue("@Email", Email);
                    cmd.Parameters.AddWithValue("@Phone", Phone);
                    cmd.Parameters.AddWithValue("@Address", Address);
                    cmd.Parameters.AddWithValue("@Specialty", Specialty);
                    cmd.Parameters.AddWithValue("@LicenseNumber", LicenseNumber);

                    cmd.Parameters.AddWithValue("@CertificationPDF", pdfPath);
                    cmd.Parameters.AddWithValue("@PhotoURL", photoPath);

                    con.Open();
                    SqlDataReader dr = cmd.ExecuteReader();
                    dr.Read();

                    return new
                    {
                        status = dr["status"].ToString(),
                        doctor_id = dr["DoctorID"],
                        message = dr["message"].ToString()
                    };
                }
            }
            catch (Exception ex)
            {
                return new
                {
                    status = "ERROR",
                    message = ex.Message
                };
            }
        }
        // ---------- INSERT PATIENT ----------
        [WebMethod]
        [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
        public object InsertPatient(
     string FullName,
     string Gender,
     string DateOfBirth,
     int Age,
     string Phone,
     string Email,
     string Address,
     string EmergencyContactName,
     string EmergencyContactPhone,
     string BloodGroup,
     string CurrentMedications,
     string NationalID_PDF,
     string PhotoBase64,
     string IDBase64
 )
        {
            try
            {
                using (SqlConnection con = new SqlConnection(cs))
                using (SqlCommand cmd = new SqlCommand("usp_Patients_CRUD", con))
                {
                    cmd.CommandType = CommandType.StoredProcedure;

                    cmd.Parameters.AddWithValue("@Action", "INSERT");
                    cmd.Parameters.AddWithValue("@PatientID", DBNull.Value);

                    cmd.Parameters.AddWithValue("@FullName", FullName);
                    cmd.Parameters.AddWithValue("@Gender", Gender);
                    cmd.Parameters.AddWithValue("@DateOfBirth", DateOfBirth);
                    cmd.Parameters.AddWithValue("@Age", Age);
                    cmd.Parameters.AddWithValue("@Phone", Phone);
                    cmd.Parameters.AddWithValue("@Email", Email);
                    cmd.Parameters.AddWithValue("@Address", Address);

                    cmd.Parameters.AddWithValue("@EmergencyContactName", EmergencyContactName);
                    cmd.Parameters.AddWithValue("@EmergencyContactPhone", EmergencyContactPhone);

                    cmd.Parameters.AddWithValue("@BloodGroup", BloodGroup);
                    cmd.Parameters.AddWithValue("@CurrentMedications", CurrentMedications);
                    cmd.Parameters.AddWithValue("@NationalID_PDF", NationalID_PDF);

                    // BASE64 STRINGS
                    cmd.Parameters.AddWithValue("@PhotoBase64", PhotoBase64);
                    cmd.Parameters.AddWithValue("@IDBase64", IDBase64);

                    con.Open();
                    SqlDataReader dr = cmd.ExecuteReader();
                    dr.Read();

                    return new
                    {
                        status = dr["Status"].ToString(),
                        patient_id = dr["Patient_ID"],
                        message = dr["Message"].ToString()
                    };
                }
            }
            catch (Exception ex)
            {
                return new
                {
                    status = "ERROR",
                    patient_id = 0,
                    message = ex.Message
                };
            }
        }
        [WebMethod]
        [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
        public List<object> GetPatients()
        {
            List<object> list = new List<object>();

            using (SqlConnection con = new SqlConnection(cs))
            using (SqlCommand cmd = new SqlCommand("usp_GetPatients", con))
            {
                cmd.CommandType = CommandType.StoredProcedure;
                con.Open();

                SqlDataReader dr = cmd.ExecuteReader();
                while (dr.Read())
                {
                    list.Add(new
                    {
                        PatientID = dr["PatientID"],
                        FullName = dr["FullName"].ToString()
                    });
                }
            }

            return list;
        }
        [WebMethod]
        [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
        public List<object> GetDoctors()
        {
            List<object> list = new List<object>();

            using (SqlConnection con = new SqlConnection(cs))
            using (SqlCommand cmd = new SqlCommand("usp_GetDoctors", con))
            {
                cmd.CommandType = CommandType.StoredProcedure;
                con.Open();

                SqlDataReader dr = cmd.ExecuteReader();
                while (dr.Read())
                {
                    list.Add(new
                    {
                        DoctorID = dr["DoctorID"],
                        FullName = dr["FullName"].ToString(),
                        Specialty = dr["Specialty"].ToString()
                    });
                }
            }

            return list;
        }
        [WebMethod]
        [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
        public object InsertAppointment(
           int PatientID,
           int DoctorID,
           string AppointmentDate,
           string AppointmentTime,
           string PaymentMethod,
           string Notes
       )
        {
            try
            {
                using (SqlConnection con = new SqlConnection(cs))
                using (SqlCommand cmd = new SqlCommand("usp_Appointment_Insert", con))
                {
                    cmd.CommandType = CommandType.StoredProcedure;

                    cmd.Parameters.AddWithValue("@PatientID", PatientID);
                    cmd.Parameters.AddWithValue("@DoctorID", DoctorID);
                    cmd.Parameters.AddWithValue("@AppointmentDate", AppointmentDate);
                    cmd.Parameters.AddWithValue("@AppointmentTime", AppointmentTime);
                    cmd.Parameters.AddWithValue("@PaymentMethod", PaymentMethod);
                    cmd.Parameters.AddWithValue("@Notes", string.IsNullOrEmpty(Notes) ? (object)DBNull.Value : Notes);

                    con.Open();
                    SqlDataReader dr = cmd.ExecuteReader();
                    dr.Read();

                    return new
                    {
                        status = dr["Status"].ToString(),
                        appointment_id = dr["AppointmentID"].ToString(),
                        message = dr["Message"].ToString()
                    };
                }
            }
            catch (Exception ex)
            {
                return new
                {
                    status = "ERROR",
                    appointment_id = 0,
                    message = ex.Message
                };
            }
        }
        [WebMethod]
        [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
        public object LoginUser(string Email, string Password)
        {
            try
            {
                using (SqlConnection con = new SqlConnection(cs))
                using (SqlCommand cmd = new SqlCommand("usp_UserLogin", con))
                {
                    cmd.CommandType = CommandType.StoredProcedure;

                    cmd.Parameters.AddWithValue("@Email", Email);
                    cmd.Parameters.AddWithValue("@Password", Password);

                    con.Open();
                    SqlDataReader dr = cmd.ExecuteReader();

                    if (dr.Read())
                    {
                        return new
                        {
                            status = "SUCCESS",
                            user_id = dr["UserID"],
                            full_name = dr["FullName"],
                            email = dr["Email"],
                            message = "Login successful!"
                        };
                    }
                    else
                    {
                        return new
                        {
                            status = "FAILED",
                            user_id = 0,
                            message = "Invalid email or password"
                        };
                    }
                }
            }
            catch (Exception ex)
            {
                return new
                {
                    status = "ERROR",
                    message = ex.Message
                };
            }
        }

    }
}


