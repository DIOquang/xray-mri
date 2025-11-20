<%@ page contentType="text/html;charset=UTF-8" language="java" isELIgnored="false" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<html>
<head>
    <title>Danh sách Hóa đơn</title>
    <%-- (CSS của bạn vẫn giữ nguyên, không cần thay đổi) --%>
    <style>
        body {
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            background: #525561;
            color: #eee;       
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

        /* ===== BẢNG CÓ VIỀN TRẮNG ===== */
        table {
            width: 90%;
            margin: 20px auto;
            border-collapse: collapse; /* Gộp viền */
            border: 2px solid #fff; /* Viền trắng ngoài cùng */
            border-radius: 12px;
            overflow: hidden; /* Bo tròn viền gọn */
            background: rgba(255, 255, 255, 0.05); /* Nền mờ nhẹ để nổi lên */
            color: #fff;
        }

        th, td {
            border: 1px solid #fff; /* Viền trắng giữa các ô */
            padding: 12px 18px;
            text-align: center;
        }

        th {
            background-color: rgba(255, 255, 255, 0.15);
            font-size: 1.1em;
        }

        tr:hover {
            background-color: rgba(255, 255, 255, 0.1); /* Hiệu ứng hover */
            transition: 0.2s;
        }

        a {
            color: #1d90f5;
            text-decoration: none;
            font-weight: 600;
        }

        a:hover {
            color: #00b7ff;
            text-decoration: underline;
        }

        h3 {
            padding-left: 5%;
        }

        a {
            padding-left: 5%;
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
    </header>


    <div class="tabs show-home">
            <h2>Hello, ${sessionScope.cus.logginname}!</h2>
    <h3>Your Order List</h3>
    
    <table id="tblInvoice">
        <thead>
            <tr>
                <th>Order ID</th>
                <th>Date</th>
                <th>Total Cost</th>
                <th>Status</th>
                <th>Detail</th>
            </tr>
        </thead>
        <tbody>
            <c:forEach var="inv" items="${listInvoice}">
                <tr>
                    <td>${inv.invoiceID}</td>
                    <td>
                        <fmt:formatDate value="${inv.creationDate}" pattern="dd-MM-yyyy" />
                    </td>
                    <td>
                        <fmt:formatNumber value="${inv.totalValue}" type="currency" currencyCode="VND" />
                    </td>
                    <td>${inv.status}</td>
                    <td>
                        <a href="invoiceDetail?orderID=${inv.orderID}">
                            View Detail (${inv.invoiceID})
                        </a>
                    </td>
                </tr>
            </c:forEach>
        </tbody>
    </table>

    <h3 style="text-align: right; width: 90%; margin-right: 5%; padding-top: 15px;">
        Tổng số tiền đã mua:
        <span style="color: #1d90f5; font-size: 1.3em; font-weight: bold;">
            <fmt:formatNumber value="${totalAmount}" type="currency" currencyCode="VND" />
        </span>
    </h3>
    <br/>
    <a href="main">Quay lại Trang chủ</a>
    </div>

</body>
</html>