<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
    if (session.getAttribute("usuarioLogueado") != null) {
        response.sendRedirect(request.getContextPath() + "/index.jsp");
        return;
    }

    String error = (String) request.getAttribute("error");
    String mensajeError = (String) session.getAttribute("mensajeError");
    session.removeAttribute("mensajeError");
%>
<!DOCTYPE html>
<html lang="es" data-bs-theme="dark" style="background-color: #0b0f19;">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Iniciar Sesión - La Casa del Rincón Guatemalteco</title>

    <style>
        html, body {
            background-color: #0b0f19 !important;
            color: #e2e8f0;
            margin: 0;
            padding: 0;
            min-height: 100vh;
            font-family: system-ui, -apple-system, "Segoe UI", Roboto, sans-serif;
        }

        .login-wrapper {
            min-height: 100vh;
            display: flex;
            align-items: center;
            justify-content: center;
            padding: 20px;
            background: radial-gradient(circle at 50% 30%, #152238 0%, #0b0f19 70%);
        }

        .login-card {
            width: 100%;
            max-width: 420px;
            background-color: #101726;
            border: 1px solid #28354f;
            border-radius: 14px;
            box-shadow: 0 10px 30px rgba(0, 0, 0, 0.5);
            padding: 36px 30px;
        }

        .form-control-dark {
            background-color: #172136 !important;
            border: 1px solid #2e3f61 !important;
            color: #ffffff !important;
            padding: 12px 14px;
            border-radius: 8px;
            font-size: 0.95rem;
            transition: all 0.2s ease-in-out;
        }

        .form-control-dark:focus {
            border-color: #00d2ff !important;
            box-shadow: 0 0 10px rgba(0, 210, 255, 0.25) !important;
            background-color: #1a263e !important;
        }

        .form-control-dark::placeholder {
            color: #64748b;
        }

        .btn-login {
            background-color: #00d2ff;
            color: #0b0f19;
            border: none;
            border-radius: 8px;
            font-weight: 700;
            padding: 12px;
            font-size: 1rem;
            letter-spacing: 0.3px;
            transition: all 0.2s ease-in-out;
        }

        .btn-login:hover {
            background-color: #38bdf8;
            color: #0b0f19;
            box-shadow: 0 0 15px rgba(0, 210, 255, 0.4);
            transform: translateY(-1px);
        }

        input:-webkit-autofill,
        input:-webkit-autofill:hover,
        input:-webkit-autofill:focus {
            -webkit-text-fill-color: #ffffff !important;
            -webkit-box-shadow: 0 0 0px 1000px #172136 inset !important;
            transition: background-color 5000s ease-in-out 0s;
        }
    </style>

    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="<%= request.getContextPath() %>/css/custom-dark.css" rel="stylesheet">
</head>
<body style="background-color: #0b0f19;">

<div class="login-wrapper">
    <div class="login-card">
        <div class="text-center mb-4">
            <div class="d-inline-flex p-3 rounded-circle mb-3" style="background-color: #172136; border: 1px solid #28354f;">
                <svg xmlns="http://www.w3.org/2000/svg" width="32" height="32" fill="#00d2ff" class="bi bi-shop" viewBox="0 0 16 16">
                    <path d="M2.97 1.35A1 1 0 0 1 3.73 1h8.54a1 1 0 0 1 .76.35l2.609 3.044A1.5 1.5 0 0 1 16 5.37v.255a2.375 2.375 0 0 1-4.25 1.458A2.37 2.37 0 0 1 9.875 8 2.37 2.37 0 0 1 8 7.083 2.37 2.37 0 0 1 6.125 8a2.37 2.37 0 0 1-1.875-.917A2.375 2.375 0 0 1 0 5.625V5.37a1.5 1.5 0 0 1 .361-.976zm1.78 4.275a1.375 1.375 0 0 0 2.75 0 .5.5 0 0 1 1 0 1.375 1.375 0 0 0 2.75 0 .5.5 0 0 1 1 0 1.375 1.375 0 1 0 2.75 0V5.37a.5.5 0 0 0-.12-.325L12.27 2H3.73L1.12 5.045A.5.5 0 0 0 1 5.37v.255a1.375 1.375 0 0 0 2.75 0 .5.5 0 0 1 1 0M1.5 8.5A.5.5 0 0 1 2 9v6h12V9a.5.5 0 0 1 1 0v6h1a.5.5 0 0 1 0 1H0a.5.5 0 0 1 0-1h1V9a.5.5 0 0 1 .5-.5m2 .5a.5.5 0 0 1 .5.5v4a.5.5 0 0 1-1 0v-4a.5.5 0 0 1 .5-.5m3 0a.5.5 0 0 1 .5.5v4a.5.5 0 0 1-1 0v-4a.5.5 0 0 1 .5-.5m3 0a.5.5 0 0 1 .5.5v4a.5.5 0 0 1-1 0v-4a.5.5 0 0 1 .5-.5"/>
                </svg>
            </div>
            <h4 class="fw-bold text-white mb-1 tracking-wide">La Casa del Rincón Guatemalteco</h4>
            <span class="text-white small opacity-50">Administración General</span>
        </div>

        <% if (error != null) { %>
        <div class="alert alert-danger py-2 px-3 small rounded-3 mb-3" role="alert" style="background-color: rgba(239, 68, 68, 0.15); border: 1px solid #ef4444; color: #fca5a5;">
            <%= error %>
        </div>
        <% } %>

        <% if (mensajeError != null) { %>
        <div class="alert alert-danger py-2 px-3 small rounded-3 mb-3" role="alert" style="background-color: rgba(239, 68, 68, 0.15); border: 1px solid #ef4444; color: #fca5a5;">
            <%= mensajeError %>
        </div>
        <% } %>

        <form action="<%= request.getContextPath() %>/login" method="post">
            <div class="mb-3">
                <label class="form-label text-white small fw-bold opacity-75">Usuario</label>
                <input type="text" class="form-control form-control-dark" name="usuario"
                       placeholder="Ingrese su usuario" required autofocus autocomplete="username">
            </div>

            <div class="mb-4">
                <label class="form-label text-white small fw-bold opacity-75">Contraseña</label>
                <input type="password" class="form-control form-control-dark" name="clave"
                       placeholder="••••••••" required autocomplete="current-password">
            </div>

            <button type="submit" class="btn btn-login w-100 mb-3 shadow-sm">
                Acceder al Sistema
            </button>
        </form>

        <div class="text-center mt-3 pt-3 border-top" style="border-color: #1e293b !important;">
            <small class="text-white opacity-50" style="font-size: 0.78rem;">
                Por un país mejor
            </small>
        </div>
    </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>