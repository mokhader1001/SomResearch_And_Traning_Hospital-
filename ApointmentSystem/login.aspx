<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="Login.aspx.cs" Inherits="AppointmentSystem.Login" %>
<!DOCTYPE html>
<html>
<head runat="server">
    <title>Login</title>

    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet" />
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css" rel="stylesheet" />

    <style>
        body {
            background: #f0f4ff;
            height: 100vh;
            display: flex;
            justify-content: center;
            align-items: center;
            font-family: 'Segoe UI', sans-serif;
        }

        .login-card {
            width: 380px;
            padding: 35px;
            background: #ffffff;
            border-radius: 15px;
            box-shadow: 0 6px 18px rgba(0,0,0,0.15);
            text-align: center;
        }

        /* Bigger and clear logo */
        .login-card img {
            width: 220px;
            margin-bottom: 10px;
        }

        .form-control {
            padding: 12px;
            border-radius: 8px;
        }

        .btn-login {
            background-color: #003366;
            color: white;
            padding: 12px;
            font-weight: 600;
            border-radius: 8px;
        }

        .btn-login:hover {
            background-color: #00264d;
        }

        .error-msg {
            color: red;
            font-size: 14px;
            margin-top: 10px;
            display: none;
        }
    </style>
</head>

<body>
    <form id="form1" runat="server">
        <div class="login-card">

            <!-- Logo -->
            <img src="/images/logo.png" alt="Hospital Logo" />

            <!-- New clean title -->
            <h3 class="mb-4">Welcome</h3>

            <!-- Email -->
            <div class="mb-3 text-start">
                <label class="form-label">Email</label>
                <input type="email" id="txtEmail" class="form-control" placeholder="Enter email" required />
            </div>

            <!-- Password -->
            <div class="mb-3 text-start">
                <label class="form-label">Password</label>
                <input type="password" id="txtPassword" class="form-control" placeholder="Enter password" required />
            </div>

            <!-- Login Button -->
            <button id="btnLogin" type="button" class="btn btn-login w-100">
                <i class="fas fa-sign-in-alt"></i> Login
            </button>

            <p id="errorMsg" class="error-msg">Invalid email or password!</p>
        </div>
    </form>

    <script src="https://code.jquery.com/jquery-3.7.1.min.js"></script>

    <script>
        $("#btnLogin").click(function () {

            const email = $("#txtEmail").val().trim();
            const password = $("#txtPassword").val().trim();

            if (email === "" || password === "") {
                $("#errorMsg").text("Please fill all fields").slideDown();
                return;
            }

            $.ajax({
                url: "WebService1.asmx/LoginUser",
                method: "POST",
                contentType: "application/json; charset=utf-8",
                data: JSON.stringify({ Email: email, Password: password }),
                dataType: "json",
                success: function (res) {
                    if (res.d.status === "SUCCESS") {
                        window.location.href = "Dashboard.aspx";
                    } else {
                        $("#errorMsg").text("Invalid email or password").slideDown();
                    }
                },
                error: function () {
                    $("#errorMsg").text("Server error. Try again").slideDown();
                }
            });

        });
    </script>
</body>
</html>
