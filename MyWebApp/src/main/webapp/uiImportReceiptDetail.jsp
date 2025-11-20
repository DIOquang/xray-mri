<%@ page contentType="text/html;charset=UTF-8" language="java" isELIgnored="false" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<html>
<head>
    <title>Import Invoice Details</title>
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
            padding-bottom: 30px;
        }

        .tabs h2 {
            padding-left: 5%;
            margin-top: 5%;
            margin-bottom: 20px;
            font-size: 3em;
        }

        h3 {
            padding-left: 5%;
            font-size: 1.8em;
            margin-bottom: 15px;
            color: #1d90f5;
        }

        .info-section {
            padding-left: 5%;
            padding-right: 5%;
            margin-bottom: 25px;
        }

        .info-box {
            background: rgba(255, 255, 255, 0.05);
            border-left: 4px solid #1d90f5;
            padding: 20px;
            border-radius: 8px;
            margin-bottom: 20px;
        }

        .info-box h4 {
            color: #1d90f5;
            font-size: 1.3em;
            margin-bottom: 10px;
            margin-top: 0;
        }

        .info-box p {
            margin: 8px 0;
            font-size: 1.1em;
        }

        .info-box strong {
            color: #fff;
            display: inline-block;
            min-width: 150px;
        }

        .status-badge {
            display: inline-block;
            padding: 5px 15px;
            border-radius: 20px;
            font-weight: bold;
            font-size: 0.95em;
        }

        .status-success {
            background: #4caf50;
            color: white;
        }

        table {
            width: 90%;
            margin: 20px auto;
            border-collapse: collapse;
            border: 2px solid #fff;
            border-radius: 12px;
            overflow: hidden;
            background: rgba(255, 255, 255, 0.05);
            color: #fff;
        }

        th, td {
            border: 1px solid #fff;
            padding: 15px;
            text-align: center;
        }

        th {
            background-color: rgba(29, 144, 245, 0.3);
            font-size: 1.1em;
            font-weight: 600;
        }

        tr:hover {
            background-color: rgba(255, 255, 255, 0.1);
            transition: 0.2s;
        }

        .product-name {
            font-weight: bold;
            color: #1d90f5;
        }

        .total-row {
            background-color: rgba(29, 144, 245, 0.2);
            font-weight: bold;
            font-size: 1.2em;
        }

        .total-row td {
            border-top: 3px solid #1d90f5;
        }

        .back-link {
            padding-left: 5%;
            display: inline-block;
            margin-top: 20px;
            margin-bottom: 20px;
            color: #1d90f5;
            text-decoration: none;
            font-size: 1.1em;
            font-weight: 600;
        }

        .back-link:hover {
            color: #00b7ff;
            text-decoration: underline;
        }

        .error-message {
            padding-left: 5%;
            padding-right: 5%;
            color: #ff6b6b;
            font-weight: bold;
            margin: 20px 0;
            font-size: 1.2em;
        }

        .number-cell {
            text-align: right;
            font-family: 'Courier New', monospace;
        }
    </style>
</head>
<body>
    
    <header class="header">
        <div class="header-left">
            <span class="circle"></span>
            <h1>Go Anywhere</h1>
        </div>
        <a href="logout" style="color: white; text-decoration: none; padding: 10px 20px; background: transparent; font-weight: 600;">
            Logout
        </a>
    </header>

    <div class="tabs">
        <h2>Hello, ${sessionScope.manager.logginname}!</h2>
        <h3>Import Invoice Details</h3>
        
        <c:if test="${not empty error}">
            <div class="error-message">
                ${error}
            </div>
        </c:if>
        
        <c:if test="${not empty importReceipt}">
            <div class="info-section">
                <!-- Import Receipt Information -->
                <div class="info-box">
                    <h4>Import Invoice Information</h4>
                    <p><strong>Invoice ID:</strong> ${importReceipt.importReceiptID}</p>
                    <p><strong>Import Date:</strong> 
                        <fmt:formatDate value="${importReceipt.importDate}" pattern="dd/MM/yyyy" />
                    </p>
                    <p><strong>Total Value:</strong> 
                        <fmt:formatNumber value="${importReceipt.totalValue}" type="currency" currencySymbol="$" />
                    </p>
                    <p><strong>Status:</strong> 
                        <span class="status-badge status-success">${importReceipt.status}</span>
                    </p>
                </div>
                
                <!-- Supplier Information -->
                <c:if test="${not empty supplier}">
                    <div class="info-box">
                        <h4>Supplier Information</h4>
                        <p><strong>Supplier ID:</strong> ${supplier.supplierID}</p>
                        <p><strong>Supplier Name:</strong> ${supplier.name}</p>
                        <p><strong>Address:</strong> ${supplier.address}</p>
                    </div>
                </c:if>
            </div>
            
            <!-- Product Details Table -->
            <c:if test="${not empty importDetails}">
                <h3>Imported Products List</h3>
                <table>
                    <thead>
                        <tr>
                            <th>No.</th>
                            <th>Product ID</th>
                            <th>Product Name</th>
                            <th>Description</th>
                            <th>Quantity</th>
                            <th>Import Price</th>
                            <th>Subtotal</th>
                        </tr>
                    </thead>
                    <tbody>
                        <c:set var="totalAmount" value="0" />
                        <c:forEach var="detail" items="${importDetails}" varStatus="status">
                            <tr>
                                <td>${status.index + 1}</td>
                                <td>${detail.productID}</td>
                                <td class="product-name">${detail.productName}</td>
                                <td>${detail.productDescription}</td>
                                <td>${detail.quantity}</td>
                                <td class="number-cell">
                                    <fmt:formatNumber value="${detail.importPrice}" type="currency" currencySymbol="$" />
                                </td>
                                <td class="number-cell">
                                    <fmt:formatNumber value="${detail.subTotal}" type="currency" currencySymbol="$" />
                                </td>
                            </tr>
                            <c:set var="totalAmount" value="${totalAmount + detail.subTotal}" />
                        </c:forEach>
                        
                        <!-- Total -->
                        <tr class="total-row">
                            <td colspan="6">TOTAL</td>
                            <td class="number-cell">
                                <fmt:formatNumber value="${totalAmount}" type="currency" currencySymbol="$" />
                            </td>
                        </tr>
                    </tbody>
                </table>
            </c:if>
            
            <c:if test="${empty importDetails}">
                <div class="error-message">
                    No product details found for this import invoice.
                </div>
            </c:if>
        </c:if>

        <a href="${pageContext.request.contextPath}/supplierImportReceipts?supplierID=${supplier.supplierID}&startDate=${startDate}&endDate=${endDate}" class="back-link">← Back to Import Invoices List</a>
    </div>

</body>
</html>
