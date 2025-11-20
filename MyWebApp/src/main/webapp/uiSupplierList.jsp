<%@ page contentType="text/html;charset=UTF-8" language="java" isELIgnored="false" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<html>
<head>
    <title>Supplier Statistics</title>
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
            width: 30%;
            padding: 15px;
            border: 10px solid #e1e8ed;
            border-radius: 16px;
            font-size: 20px;
            transition: all 0.3s ease;
            background: rgba(255, 255, 255, 0.9);
        }

        .form-group input::placeholder {
            color: #ccc;
        }

        .form-group input:focus {
            background: rgba(255, 255, 255, 0.2);
            box-shadow: 0 0 0 2px #1d90f5;
            outline: none;
        }

        .form-group select {
            width: 30%;
            padding: 15px;
            border: 10px solid #e1e8ed;
            border-radius: 16px;
            font-size: 20px;
            transition: all 0.3s ease;
            background: rgba(255, 255, 255, 0.9);
            color: #333;
            cursor: pointer;
        }

        .form-group select:focus {
            background: rgba(255, 255, 255, 1);
            box-shadow: 0 0 0 2px #1d90f5;
            outline: none;
        }

        .form-group select option {
            padding: 10px;
            background: #fff;
            color: #333;
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
            margin-top: 10px;
        }

        .btn:hover {
            background: linear-gradient(90deg, #00b7ff, #0085f5);
            transform: translateY(-2px);
            box-shadow: 0 5px 10px rgba(29, 144, 245, 0.3);
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
            padding: 12px 18px;
            text-align: center;
        }

        th {
            background-color: rgba(255, 255, 255, 0.15);
            font-size: 1.1em;
        }

        tr:hover {
            background-color: rgba(255, 255, 255, 0.1);
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
            font-size: 1.5em;
        }

        .back-link {
            padding-left: 5%;
            display: inline-block;
            margin-top: 20px;
            margin-bottom: 20px;
        }

        .notify {
            padding-left: 5%;
            color: #ff6b6b;
            font-weight: bold;
            margin-bottom: 10px;
            font-size: 1.1em;
        }

        .date-range-info {
            padding-left: 5%;
            padding-right: 5%;
            margin-bottom: 15px;
            font-size: 1.2em;
            color: #1d90f5;
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
        <h3>Supplier Statistics</h3>
        
        <form method="post" action="supplierStats">
            <div class="form-group">
                <label for="statisticType">Statistic Type:</label>
                <select id="statisticType" name="statisticType">
                    <option value="revenue" ${statisticType == 'revenue' || empty statisticType ? 'selected' : ''}>
                        Revenue Statistics
                    </option>
                    <option value="orders" ${statisticType == 'orders' ? 'selected' : ''}>
                        Order Statistics
                    </option>
                    <option value="products" ${statisticType == 'products' ? 'selected' : ''}>
                        Product Statistics
                    </option>
                    <option value="customers" ${statisticType == 'customers' ? 'selected' : ''}>
                        Customer Statistics
                    </option>
                    <option value="growth" ${statisticType == 'growth' ? 'selected' : ''}>
                        Growth Statistics
                    </option>
                </select>
            </div>
            
            <div class="form-group">
                <label for="startDate">Start Date:</label>
                <input type="date" id="startDate" name="startDate" 
                       value="${startDate}" required />
            </div>
            
            <div class="form-group">
                <label for="endDate">End Date:</label>
                <input type="date" id="endDate" name="endDate" 
                       value="${endDate}" required />
            </div>
            
            <button type="submit" class="btn">View Statistics</button>
        </form>

        <c:if test="${not empty message}">
            <div class="notify" style="color: #FFA500;">
                ${message}
            </div>
        </c:if>
        
        <c:if test="${not empty supplierList}">
            <div class="date-range-info">
                Revenue Statistics from ${startDate} to ${endDate}
            </div>
            
            <table>
                <thead>
                    <tr>
                        <th>Supplier ID</th>
                        <th>Supplier Name</th>
                        <th>Address</th>
                        <th>Total Orders</th>
                        <th>Total Revenue</th>
                        <th>Actions</th>
                    </tr>
                </thead>
                <tbody>
                    <c:forEach var="supplier" items="${supplierList}">
                        <tr>
                            <td>${supplier.supplierID}</td>
                            <td>${supplier.name}</td>
                            <td>${supplier.address}</td>
                            <td>${supplier.totalOrders}</td>
                            <td>
                                <fmt:formatNumber value="${supplier.totalRevenue}" 
                                                  type="currency" currencySymbol="$" />
                            </td>
                            <td>
                                <a href="${pageContext.request.contextPath}/supplierImportReceipts?supplierID=${supplier.supplierID}&startDate=${startDate}&endDate=${endDate}">
                                    View Invoices
                                </a>
                            </td>
                        </tr>
                    </c:forEach>
                </tbody>
            </table>
        </c:if>
        
        <c:if test="${empty supplierList && not empty startDate}">
            <div class="notify">
                No data found for the selected date range.
            </div>
        </c:if>

        <a href="main" class="back-link">← Back to Main Page</a>
    </div>

</body>
</html>
