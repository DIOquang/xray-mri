<%@ page contentType="text/html;charset=UTF-8" language="java" isELIgnored="false" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<html>
<head>
    <title>Homepage</title>
   <style>
        body {
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            background: #525561;
            color: #eee;       /* Changed text color for readability on dark background */
            line-height: 1.6;
            width: 100vw;
        }

        .header {
            width: 96vw;
            color: white;
            padding: 20px 30px;
            display: flex;
            justify-content: space-between;
            align-self: flex-start;
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
            height: 82%;
            background: linear-gradient(
                to right,
                rgb(39, 42, 55) 40%,
                rgba(39, 42, 55, 0.8)
            ), url("${pageContext.request.contextPath}/images/bg1.jpg") center no-repeat;
            background-size: cover;

            border-radius: 2rem;
            box-shadow: 0 1rem 5rem rgba(0, 0, 0, 0.4);

            /* Center align */
            margin: 0 auto;
            display: flex;            
            flex-direction: column;   
        }

        .tabs h2 {
            padding-left: 5%;
            margin-top: 5%;
            margin-bottom: 20px;
            font-size: 3em;
        }

        form {
            padding-left: 5%;
        }

        .form-group input {
            width: 30%;
            padding: 15px;
            border: 10px solid #e1e8ed;
            border-radius: 16px;
            font-size: 20px;
            transition: all 0.3s 
        ease;
            background: rgba(255, 255, 255, 0.9);
        }

        .notify {
            padding-left: 5%;
        }


        .btn {
            width: 30%;
            padding: 12px;
            font-size: 18px;
            background: #1d90f5;
            color: white;
            border: none;
            border-radius: 20px;
            cursor: pointer;
            font-weight: 600;
            transition: all 0.3s ease;
        }

        .btn:hover {
            background: linear-gradient(90deg, #00b7ff, #0085f5);
            transform: translateY(-2px);
            box-shadow: 0 5px 10px rgba(29, 144, 245, 0.3);
        }

        .notify {
            color: #ff6b6b;
            font-weight: bold;
            margin-bottom: 10px;
        }

        .form-group {
            margin-bottom: 20px;
            text-align: left;
        }



        .form-group input::placeholder {
            color: #ccc;
        }

        .form-group input:focus {
            background: rgba(255, 255, 255, 0.2);
            box-shadow: 0 0 0 2px #1d90f5;
        }
        .menu {
            padding-left: 5%;
            display: flex;
            flex-direction: column;
            gap: 20px; /* space between buttons */
            margin-top: 30px;
        }
        p{
            padding-left: 5%;
            font-size: 1.2em;
            
        }
        a {
            text-decoration: none;
        }

        a:hover {
            text-decoration: none;
        }
    </style>
</head>
<body>

    <header class="header">
        <div class="header-left">
            <span class="circle"></span>
            <h1>Go Anywhere</h1>
        </div>
        <c:if test="${not empty sessionScope.userType}">
            <a href="logout" style="color: white; text-decoration: none; padding: 10px 20px; background: transparent; font-weight: 600;">
                Logout
            </a>
        </c:if>
    </header>


    <div class="tabs show-home">
        <!-- Access Denied Message -->
        <c:if test="${not empty error}">
            <div style="padding-left: 5%; color: #ff6b6b; font-weight: bold; font-size: 1.2em; margin-top: 20px;">
                 ${error}
            </div>
        </c:if>
        
        <!-- Customer Menu -->
        <c:if test="${sessionScope.userType == 'customer'}">
            <h2>Hello, ${sessionScope.cus.logginname}! (Customer)</h2>
            <p>Please choose a function below:</p>
            <div class="menu">
                <a href="invoiceList" class="btn">Invoice Tracking</a>
            </div>
        </c:if>
        
        <!-- Manager Menu -->
        <c:if test="${sessionScope.userType == 'manager'}">
            <h2>Hello, ${sessionScope.manager.logginname}! (Manager)</h2>
            <p>Please choose a function below:</p>
            <div class="menu">
                <a href="supplierStats" class="btn">Statistics</a>
            </div>
        </c:if>
        
        <!-- Not logged in -->
        <c:if test="${empty sessionScope.userType}">
            <h2>You are not logged in!</h2>
            <a href="login">Back to login</a>
        </c:if>

    </div>

</body>
</html>