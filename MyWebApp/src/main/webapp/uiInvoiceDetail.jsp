<%@ page contentType="text/html;charset=UTF-8" language="java" isELIgnored="false" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<html>
<head>
    <title>Invoice Details</title>
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

        /* ===== TABLE WITH WHITE BORDER ===== */
        table {
            width: 90%;
            margin: 20px auto;
            border-collapse: collapse; /* Merge borders */
            border: 2px solid #fff; /* Outermost white border */
            border-radius: 12px;
            overflow: hidden; /* Keep border radius neat */
            background: rgba(255, 255, 255, 0.05); /* Light transparent background */
            color: #fff;
        }

        th, td {
            border: 1px solid #fff; /* White border between cells */
            padding: 12px 18px;
            text-align: center;
        }

        th {
            background-color: rgba(255, 255, 255, 0.15);
            font-size: 1.1em;
        }

        tr:hover {
            background-color: rgba(255, 255, 255, 0.1); /* Hover effect */
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
        <h2>Order Detail: ${orderID}</h2>
        
        <!-- Invoice Information -->
        <c:if test="${not empty invoice}">
            <div style="padding-left: 5%; padding-right: 5%; margin-bottom: 20px;">
                <div style="display: grid; grid-template-columns: repeat(2, 1fr); gap: 15px; font-size: 1.1em;">
                    <div>
                        <strong>Invoice ID:</strong> ${invoice.invoiceID}
                    </div>
                    <div>
                        <strong>Status:</strong> 
                        <span style="color: ${invoice.status == 'Paid' ? '#4CAF50' : '#FFA500'}; font-weight: bold;">
                            ${invoice.status}
                        </span>
                    </div>
                    <div>
                        <strong>Creation Date:</strong> 
                        <fmt:formatDate value="${invoice.creationDate}" pattern="dd-MM-yyyy" />
                    </div>
                    <div>
                        <strong>Total Value:</strong> 
                        <span style="color: #1d90f5; font-weight: bold;">
                            <fmt:formatNumber value="${invoice.totalValue}" type="currency" currencySymbol="$" />
                        </span>
                    </div>
                </div>
            </div>
        </c:if>
        
        <h3>Order Items</h3>
    
        <table id="invoiceDetail">
            <thead>
                <tr>
                    <th>Product Name</th>
                    <th>Description</th>
                    <th>Quantity</th>
                    <th>Unit Price</th>
                    <th>Subtotal</th>
                </tr>
            </thead>
            <tbody>
                <c:forEach var="item" items="${invoiceDetail}">
                    <tr>
                        <td>${item.product.name}</td>
                        <td>${item.product.description}</td>
                        <td>${item.quantity}</td>
                        <td>
                            <fmt:formatNumber value="${item.unitPrice}" type="currency" currencySymbol="$" />
                        </td>
                        <td>
                            <fmt:formatNumber value="${item.unitPrice * item.quantity}" type="currency" currencySymbol="$" />
                        </td>
                    </tr>
                </c:forEach>
            </tbody>
        </table>

        <br/>
        <a href="invoiceList">Back to Invoice List</a>
        <br/>
        <a href="main">Back to Homepage</a>
    </div>


</body>
</html>