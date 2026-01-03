using System;
using System.Data.SqlClient;
using System.Configuration;
using System.Web.Services;
using System.Web.Script.Services;
using System.Net;
using System.IO;
using System.Text;
using System.Web.Script.Serialization;
using System.Collections;
using System.Collections.Generic;
using System.Globalization;

namespace AppointmentSystem.Services
{
    [WebService(Namespace = "tempuri.org")]
    [ScriptService]
    public class ChatBotService : WebService
    {
        // ================= DATABASE =================
        string conStr = ConfigurationManager.ConnectionStrings["db"].ConnectionString;

        // ================= GEMINI API KEY =================
        private string GeminiApiKey => ConfigurationManager.AppSettings["GeminiApiKey"];
        private string GeminiModel => (ConfigurationManager.AppSettings["GeminiModel"] ?? "gemini-1.5-flash").Trim();
        private decimal DefaultAppointmentFee
        {
            get
            {
                decimal fee;
                return decimal.TryParse(ConfigurationManager.AppSettings["DefaultAppointmentFee"], NumberStyles.Any, CultureInfo.InvariantCulture, out fee)
                    ? fee
                    : 10m;
            }
        }

        // ================= MAIN CHAT METHOD =================
        [WebMethod(EnableSession = true)]
        public string Chat(string message)
        {
            if (!string.IsNullOrWhiteSpace(message))
            {
                string m = message.Trim();
                string ml = m.ToLowerInvariant();

                if (ml == "__start__")
                {
                    ResetChatSession();
                    return WelcomeMessage();
                }

                if (ml == "__close__")
                {
                    ResetChatSession();
                    return string.Empty;
                }

                if (ml == "clear")
                {
                    ResetChatSession();
                    return string.Empty;
                }
            }

            if (Session["STEP"] == null)
                Session["STEP"] = "WELCOME";

            switch (Session["STEP"].ToString())
            {
                case "WELCOME":
                    return HandleWelcome(message);

                case "HEALTH_AI":
                    return AskGemini(message);

                case "CHOOSE_DOCTOR":
                    return ChooseDoctor(message);

                case "GET_PATIENT_PHONE":
                    return GetPatientPhone(message);

                case "GET_APPOINTMENT_DATE":
                    return GetAppointmentDate(message);

                case "GET_APPOINTMENT_TIME":
                    return GetAppointmentTime(message);

                case "GET_PAYMENT_METHOD":
                    Session["PAYMENT_METHOD"] = message;
                    Session["STEP"] = "GET_NOTES";
                    return "📝 Any notes? (Type 'skip' to continue)";

                case "GET_NOTES":
                    Session["NOTES"] = (message != null && message.Trim().ToLower() == "skip") ? null : message;
                    SaveAppointment();
                    Session["STEP"] = "WELCOME";
                    return "✅ Your appointment request has been saved.<br/>📅 Your appointment will be confirmed shortly.";

                default:
                    Session["STEP"] = "WELCOME";
                    return WelcomeMessage();
            }
        }

        void ResetChatSession()
        {
            Session["STEP"] = "WELCOME";

            Session.Remove("DOCTOR_ID");
            Session.Remove("PHONE");
            Session.Remove("PATIENT_ID");
            Session.Remove("APPOINTMENT_DATE");
            Session.Remove("APPOINTMENT_TIME");
            Session.Remove("PAYMENT_METHOD");
            Session.Remove("NOTES");
        }

        // ================= WELCOME =================
        string HandleWelcome(string msg)
        {
            if (string.IsNullOrEmpty(msg))
                return WelcomeMessage();

            if (IsBotNameQuestion(msg))
                return BotNameResponse();

            if (msg == "1")
            {
                Session["STEP"] = "HEALTH_AI";
                return "🩺 You can ask me any general health question. (Type 'back' to return to menu)";
            }

            if (msg == "2")
            {
                Session["STEP"] = "CHOOSE_DOCTOR";
                return GetDoctors();
            }

            if (msg == "3")
            {
                return "👋 Thank you for using Somcare Health Assistant.";
            }

            return "Please type 1, 2 or 3.";
        }

        string BotNameResponse()
        {
            return "Somcare Health Assistant powered by Eng Mohamed Yusuf Ahmed";
        }

        bool IsBotNameQuestion(string msg)
        {
            if (string.IsNullOrWhiteSpace(msg))
                return false;

            string t = msg.Trim().ToLowerInvariant();
            return t.Contains("your name") || t.Contains("what is your name") || t.Contains("who are you") || t.Contains("who r u") || t.Contains("who r you");
        }

        string NormalizeSingleParagraph(string text)
        {
            if (string.IsNullOrEmpty(text))
                return text;

            string t = text.Replace("<br/>", " ").Replace("<br>", " ").Replace("\r", " ").Replace("\n", " ");
            while (t.Contains("  "))
                t = t.Replace("  ", " ");
            return t.Trim();
        }

        string WelcomeMessage()
        {
            return @"Welcome to Somcare health service.<br/>
                    1️⃣ General health questions<br/>
                    2️⃣ Book an appointment<br/>
                    3️⃣ Exit";
        }

        // ================= DOCTORS =================
        string GetDoctors()
        {
            string txt = "👨‍⚕️ Available doctors:<br/>";

            using (SqlConnection con = new SqlConnection(conStr))
            {
                SqlCommand cmd = new SqlCommand("usp_GetDoctors", con);
                cmd.CommandType = System.Data.CommandType.StoredProcedure;
                con.Open();
                SqlDataReader dr = cmd.ExecuteReader();

                while (dr.Read())
                {
                    txt += dr["DoctorID"] + ". " + dr["FullName"] + " (" + dr["Specialty"] + ")<br/>";
                }
            }

            txt += "<br/>Please type doctor number.";
            return txt;
        }

        string ChooseDoctor(string msg)
        {
            int doctorId;
            if (!int.TryParse(msg, out doctorId))
                return "❌ Please enter a valid doctor number.";

            Session["DOCTOR_ID"] = doctorId;
            Session["STEP"] = "GET_PATIENT_PHONE";
            return "📞 Please enter your phone number (the one you registered with)";
        }

        string GetPatientPhone(string msg)
        {
            if (!string.IsNullOrWhiteSpace(msg) && msg.Trim().ToLower() == "back")
            {
                Session["STEP"] = "WELCOME";
                return WelcomeMessage();
            }

            string phone = (msg ?? "").Trim();
            if (string.IsNullOrWhiteSpace(phone))
                return "❌ Please enter your phone number.";

            Session["PHONE"] = phone;

            if (Session["PATIENT_ID"] == null)
            {
                int patientId;
                if (!TryGetPatientIdByPhone(phone, out patientId))
                    return "❌ No patient found with this phone number. Please register first or type 'back' to return to menu.";
                Session["PATIENT_ID"] = patientId;
            }

            Session["STEP"] = "GET_APPOINTMENT_DATE";
            return "📅 Enter appointment date (YYYY-MM-DD)";
        }

        string GetAppointmentDate(string msg)
        {
            if (!string.IsNullOrWhiteSpace(msg) && msg.Trim().ToLower() == "back")
            {
                Session["STEP"] = "WELCOME";
                return WelcomeMessage();
            }

            DateTime date;
            if (!DateTime.TryParseExact((msg ?? "").Trim(), "yyyy-MM-dd", CultureInfo.InvariantCulture, DateTimeStyles.None, out date))
                return "❌ Invalid date. Please enter as YYYY-MM-DD.";

            Session["APPOINTMENT_DATE"] = date.ToString("yyyy-MM-dd", CultureInfo.InvariantCulture);
            Session["STEP"] = "GET_APPOINTMENT_TIME";
            return "⏰ Enter appointment time (HH:mm)";
        }

        string GetAppointmentTime(string msg)
        {
            if (!string.IsNullOrWhiteSpace(msg) && msg.Trim().ToLower() == "back")
            {
                Session["STEP"] = "WELCOME";
                return WelcomeMessage();
            }

            DateTime time;
            if (!DateTime.TryParseExact((msg ?? "").Trim(), "HH:mm", CultureInfo.InvariantCulture, DateTimeStyles.None, out time))
                return "❌ Invalid time. Please enter as HH:mm (example 15:30).";

            Session["APPOINTMENT_TIME"] = time.ToString("HH:mm", CultureInfo.InvariantCulture);
            Session["STEP"] = "GET_PAYMENT_METHOD";
            return "💳 Enter payment method (example: Salaam Bank, EVC Plus, Waafi Pay)";
        }

        // ================= SAVE APPOINTMENT =================
        void SaveAppointment()
        {
            using (SqlConnection con = new SqlConnection(conStr))
            {
                SqlCommand cmd = new SqlCommand(
                    @"INSERT INTO Appointments (PatientID, DoctorID, AppointmentDate, AppointmentTime, AppointmentFee, PaymentMethod, PaymentStatus, Notes, CreatedAt)
                      VALUES (@pid,@did,@dt,@tm,@fee,@pm,@ps,@notes,GETDATE())", con);

                cmd.Parameters.AddWithValue("@pid", Session["PATIENT_ID"] ?? 0);
                cmd.Parameters.AddWithValue("@did", Session["DOCTOR_ID"] ?? 0);
                cmd.Parameters.AddWithValue("@dt", Session["APPOINTMENT_DATE"] ?? "");
                cmd.Parameters.AddWithValue("@tm", Session["APPOINTMENT_TIME"] ?? "");
                cmd.Parameters.AddWithValue("@fee", DefaultAppointmentFee);
                cmd.Parameters.AddWithValue("@pm", Session["PAYMENT_METHOD"] ?? "");
                cmd.Parameters.AddWithValue("@ps", "Pending");
                cmd.Parameters.AddWithValue("@notes", string.IsNullOrWhiteSpace((Session["NOTES"] ?? "").ToString()) ? (object)DBNull.Value : Session["NOTES"].ToString());

                con.Open();
                cmd.ExecuteNonQuery();
            }
        }

        bool TryGetPatientIdByPhone(string phone, out int patientId)
        {
            patientId = 0;
            using (SqlConnection con = new SqlConnection(conStr))
            {
                SqlCommand cmd = new SqlCommand("SELECT TOP 1 PatientID FROM Patients WHERE Phone = @p", con);
                cmd.Parameters.AddWithValue("@p", phone);
                con.Open();
                object o = cmd.ExecuteScalar();
                if (o == null || o == DBNull.Value)
                    return false;
                return int.TryParse(o.ToString(), out patientId);
            }
        }

        // ================= GEMINI AI (UPDATED FOR 2026) =================
        string AskGemini(string userMessage)
        {
            if (userMessage.ToLower() == "back")
            {
                Session["STEP"] = "WELCOME";
                return WelcomeMessage();
            }

            if (IsBotNameQuestion(userMessage))
                return BotNameResponse();

            try
            {
                if (string.IsNullOrWhiteSpace(GeminiApiKey))
                    return "⚠️ Gemini API key is missing in Web.config.";

                // Use TLS 1.2 or 1.3 for 2026 security standards
                // 3072 is Tls12, 12288 is Tls13
                ServicePointManager.SecurityProtocol = SecurityProtocolType.Tls12;

                string configuredModel = string.IsNullOrWhiteSpace(GeminiModel) ? "gemini-1.5-flash" : GeminiModel;
                return GenerateWithGemini(configuredModel, userMessage, true);
            }
            catch (WebException wex)
            {
                if (wex.Response != null)
                {
                    using (var reader = new StreamReader(wex.Response.GetResponseStream()))
                    {
                        string errorBody = reader.ReadToEnd();
                        return "⚠️ API Error: " + errorBody;
                    }
                }
                return "⚠️ Connection Error: " + wex.Message;
            }
            catch (Exception ex)
            {
                return "⚠️ System Error: " + ex.Message;
            }
        }

        string GenerateWithGemini(string model, string userMessage, bool allowFallback)
        {
            string normalizedModel = (model ?? "").Trim();
            if (normalizedModel.StartsWith("models/", StringComparison.OrdinalIgnoreCase))
                normalizedModel = normalizedModel.Substring("models/".Length);

            Uri url = new UriBuilder("https", "generativelanguage.googleapis.com")
            {
                Path = $"/v1/models/{normalizedModel}:generateContent",
                Query = "key=" + Uri.EscapeDataString((GeminiApiKey ?? "").Trim())
            }.Uri;

            var payload = new
            {
                contents = new[]
                {
                    new {
                        parts = new[] {
                            new { text = "You are Somcare Health Assistant. Respond with only ONE short paragraph (no line breaks, no lists)." },
                            new { text = userMessage }
                        }
                    }
                }
            };

            JavaScriptSerializer js = new JavaScriptSerializer();
            string json = js.Serialize(payload);

            try
            {
                HttpWebRequest request = (HttpWebRequest)WebRequest.Create(url);
                request.Method = "POST";
                request.ContentType = "application/json";

                using (var stream = request.GetRequestStream())
                {
                    byte[] bytes = Encoding.UTF8.GetBytes(json);
                    stream.Write(bytes, 0, bytes.Length);
                }

                using (var response = request.GetResponse())
                using (var reader = new StreamReader(response.GetResponseStream()))
                {
                    string resultJson = reader.ReadToEnd();
                    Dictionary<string, object> result = js.Deserialize<Dictionary<string, object>>(resultJson);
                    var candidates = (ArrayList)result["candidates"];
                    var firstCandidate = (Dictionary<string, object>)candidates[0];
                    var content = (Dictionary<string, object>)firstCandidate["content"];
                    var parts = (ArrayList)content["parts"];
                    var firstPart = (Dictionary<string, object>)parts[0];
                    return NormalizeSingleParagraph(firstPart["text"].ToString());
                }
            }
            catch (WebException wex)
            {
                string errorBody = null;
                int? statusCode = null;
                if (wex.Response != null)
                {
                    var http = wex.Response as HttpWebResponse;
                    if (http != null)
                        statusCode = (int)http.StatusCode;
                    using (var reader = new StreamReader(wex.Response.GetResponseStream()))
                        errorBody = reader.ReadToEnd();
                }

                if (statusCode == 429 || (!string.IsNullOrEmpty(errorBody) && errorBody.IndexOf("RESOURCE_EXHAUSTED", StringComparison.OrdinalIgnoreCase) >= 0))
                {
                    return "⚠️ The AI service is temporarily busy or your quota is exceeded. Please try again later.";
                }

                if (allowFallback && !string.IsNullOrEmpty(errorBody) && errorBody.IndexOf("NOT_FOUND", StringComparison.OrdinalIgnoreCase) >= 0)
                {
                    string fallbackModel = DiscoverFirstGenerateContentModel();
                    if (!string.IsNullOrWhiteSpace(fallbackModel) && !fallbackModel.Equals(normalizedModel, StringComparison.OrdinalIgnoreCase))
                        return GenerateWithGemini(fallbackModel, userMessage, false);
                }

                if (!string.IsNullOrEmpty(errorBody))
                    return "⚠️ API Error: " + errorBody;

                return "⚠️ Connection Error: " + wex.Message;
            }
        }

        string DiscoverFirstGenerateContentModel()
        {
            Uri url = new UriBuilder("https", "generativelanguage.googleapis.com")
            {
                Path = "/v1/models",
                Query = "key=" + Uri.EscapeDataString((GeminiApiKey ?? "").Trim())
            }.Uri;

            JavaScriptSerializer js = new JavaScriptSerializer();

            HttpWebRequest request = (HttpWebRequest)WebRequest.Create(url);
            request.Method = "GET";

            using (var response = request.GetResponse())
            using (var reader = new StreamReader(response.GetResponseStream()))
            {
                string resultJson = reader.ReadToEnd();
                Dictionary<string, object> result = js.Deserialize<Dictionary<string, object>>(resultJson);
                if (!result.ContainsKey("models"))
                    return null;

                var models = result["models"] as ArrayList;
                if (models == null)
                    return null;

                foreach (var m in models)
                {
                    var dict = m as Dictionary<string, object>;
                    if (dict == null || !dict.ContainsKey("name"))
                        continue;

                    string name = dict["name"]?.ToString();
                    if (string.IsNullOrWhiteSpace(name))
                        continue;

                    bool supportsGenerate = false;
                    if (dict.ContainsKey("supportedGenerationMethods"))
                    {
                        var methods = dict["supportedGenerationMethods"] as ArrayList;
                        if (methods != null)
                        {
                            foreach (var method in methods)
                            {
                                if (method != null && method.ToString().IndexOf("generateContent", StringComparison.OrdinalIgnoreCase) >= 0)
                                {
                                    supportsGenerate = true;
                                    break;
                                }
                            }
                        }
                    }

                    if (!supportsGenerate)
                        continue;

                    if (name.StartsWith("models/", StringComparison.OrdinalIgnoreCase))
                        name = name.Substring("models/".Length);

                    return name;
                }

                return null;
            }
        }
    }
}
