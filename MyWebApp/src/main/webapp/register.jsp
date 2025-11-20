<%@ page contentType="text/html;charset=UTF-8" language="java" isELIgnored="false" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<html>
<head>
    <title>Register - Customer</title>
    <style>
        body {
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            background: #525561;
            color: #eee;
            line-height: 1.6;
            width: 100vw;
            margin: 0;
            padding: 0;
        }

        .header {
            width: 96vw;
            color: white;
            padding: 20px 30px;
            display: flex;
            justify-content: space-between;
            align-items: center;
        }
        
        .header-left {
            display: flex;
            align-items: center;
        }
        
        .circle {
            width: 3rem;
            height: 3rem;
            background-color: #1d90f5;
            border-radius: 50%;
            margin-right: 1rem;
        }

        .tabs {
            width: 93%;
            min-height: 82%;
            background: linear-gradient(
                to right,
                rgb(39, 42, 55) 40%,
                rgba(39, 42, 55, 0.8)
            ), url("${pageContext.request.contextPath}/images/bg1.jpg") center no-repeat;
            background-size: cover;
            border-radius: 2rem;
            box-shadow: 0 1rem 5rem rgba(0, 0, 0, 0.4);
            margin: 0 auto;
            display: flex;
            flex-direction: column;
            padding-bottom: 50px;
        }

        .tabs h2 {
            padding-left: 5%;
            margin-top: 5%;
            margin-bottom: 20px;
            font-size: 3em;
        }

        form {
            padding-left: 5%;
            padding-right: 5%;
        }

        .form-group {
            margin-bottom: 20px;
            text-align: left;
        }

        .form-group label {
            display: block;
            margin-bottom: 8px;
            font-size: 1.1em;
            color: #fff;
        }

        .form-group input {
            width: 50%;
            padding: 15px;
            border: 10px solid #e1e8ed;
            border-radius: 16px;
            font-size: 18px;
            transition: all 0.3s ease;
            background: rgba(255, 255, 255, 0.9);
            color: #333;
        }

        .form-group input::placeholder {
            color: #999;
        }

        .form-group input:focus {
            background: rgba(255, 255, 255, 1);
            box-shadow: 0 0 0 2px #1d90f5;
            outline: none;
        }

        .btn {
            width: 50%;
            padding: 15px;
            font-size: 20px;
            background: #1d90f5;
            color: white;
            border: none;
            border-radius: 20px;
            cursor: pointer;
            font-weight: 600;
            transition: all 0.3s ease;
            margin-top: 10px;
        }

        .btn:hover {
            background: linear-gradient(90deg, #00b7ff, #0085f5);
            transform: translateY(-2px);
            box-shadow: 0 5px 10px rgba(29, 144, 245, 0.3);
        }

        .notify {
            padding-left: 5%;
            color: #ff6b6b;
            font-weight: bold;
            margin-bottom: 15px;
            font-size: 1.1em;
        }

        .success {
            padding-left: 5%;
            color: #4CAF50;
            font-weight: bold;
            margin-bottom: 15px;
            font-size: 1.1em;
        }

        .back-link {
            padding-left: 5%;
            display: inline-block;
            margin-top: 20px;
            color: #1d90f5;
            text-decoration: none;
            font-size: 1.1em;
        }

        .back-link:hover {
            color: #00b7ff;
            text-decoration: underline;
        }

        p {
            padding-left: 5%;
            font-size: 1.1em;
            color: #ccc;
        }
    </style>
</head>
<body>

    <header class="header">
        <div class="header-left">
            <span class="circle"></span>
            <h1>Go Anywhere</h1>
        </div>
    </header>

    <div class="tabs">
        <h2>📝 Customer Registration</h2>
        <p>Create your customer account to track invoices</p>

        <c:if test="${not empty error}">
            <div class="notify">
                ⚠️ ${error}
            </div>
        </c:if>

        <c:if test="${not empty success}">
            <div class="success">
                ✅ ${success}
            </div>
        </c:if>
        
        <form action="register" method="POST">
            <div class="form-group">
                <label for="username">Username:</label>
                <input type="text" id="username" name="username" 
                       placeholder="Enter username" required />
            </div>

            <div class="form-group">
                <label for="password">Password:</label>
                <input type="password" id="password" name="password" 
                       placeholder="Enter password" required />
            </div>

            <div class="form-group">
                <label for="confirmPassword">Confirm Password:</label>
                <input type="password" id="confirmPassword" name="confirmPassword" 
                       placeholder="Confirm password" required />
            </div>

            <div class="form-group">
                <label for="address">Address:</label>
                <input type="text" id="address" name="address" 
                       placeholder="Enter your address" required />
            </div>

            <div class="form-group">
                <label for="phone">Phone:</label>
                <input type="text" id="phone" name="phone" 
                       placeholder="Enter phone number" required />
            </div>

            <div class="form-group">
                <label for="email">Email:</label>
                <input type="email" id="email" name="email" 
                       placeholder="Enter email address" required />
            </div>

            <button type="submit" class="btn">Register</button>
        </form>

        <a href="login" class="back-link">← Already have an account? Login here</a>
    </div>

</body>
</html>
