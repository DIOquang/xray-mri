<%@ page contentType="text/html;charset=UTF-8" language="java" isELIgnored="false" %>
<html>
<head>
    <title>Đăng nhập</title>
    <style>
        body {
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            background: #525561;
            color: #eee;       /* Đổi màu chữ cho dễ đọc trên nền đen */
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

            /* ✅ Căn giữa chính xác */
            margin: 0 auto;           /* Căn giữa ngang */
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
    </style>
</head>
<body>
    <header class="header">
                <div class="header-left">
                    <span class="circle"></span>
                    <h1>Go Anywhere</h1>
                </div>
    </header>


    <div class="tabs show-home">
        <h2>Login</h2>
        
        <c:if class = "notify" test="${not empty error}">
            <p style="color:red;">${error}</p>
        </c:if>
        
        <c:if test="${not empty success}">
            <p style="color:#4caf50; font-weight: bold; padding-left: 5%;">${success}</p>
        </c:if>

        <form action="login" method="POST">
            <div class="form-group">
                <input type="text" name="username" placeholder="Username" required />
            </div>
            <div class="form-group">
                <input type="password" name="password" placeholder="Password" required />
            </div>
            <button type="submit" class="btn">Login</button>
        </form>
        
        <div style="padding-left: 5%; margin-top: 20px;">
            <p style="font-size: 16px; color: #ccc;">
                Chưa có tài khoản? 
                <a href="register" style="color: #1d90f5; text-decoration: none; font-weight: 600;">Đăng ký ngay</a>
            </p>
        </div>
    </div>
</body>
</html>