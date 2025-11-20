<%@ page contentType="text/html;charset=UTF-8" language="java" isELIgnored="false" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<html>
<head>
	<title>Supplier Import Receipts</title>
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

		h3 {
			padding-left: 5%;
			font-size: 1.5em;
			margin-bottom: 10px;
		}

		.supplier-info {
			padding-left: 5%;
			padding-right: 5%;
			margin-bottom: 20px;
		}

		.supplier-info p {
			margin: 5px 0;
			font-size: 1.1em;
		}

		.supplier-info strong {
			color: #1d90f5;
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

		.total-summary {
			text-align: right;
			width: 90%;
			margin: 0 auto;
			padding-top: 15px;
			font-size: 1.2em;
		}

		.total-summary span {
			color: #1d90f5;
			font-size: 1.3em;
			font-weight: bold;
		}

		.status-success {
			color: #4caf50;
			font-weight: bold;
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
		<h2>Hello, ${sessionScope.manager.logginname}!</h2>
		<h3>📦 Supplier Import Receipts</h3>
        
		<c:if test="${not empty supplier}">
			<div class="supplier-info">
				<p><strong>Supplier ID:</strong> ${supplier.supplierID}</p>
				<p><strong>Supplier Name:</strong> ${supplier.name}</p>
				<p><strong>Address:</strong> ${supplier.address}</p>
			</div>
            
			<div class="date-range-info">
				Import period: from ${startDate} to ${endDate}
			</div>
		</c:if>

		<c:if test="${not empty importReceiptList}">
			<table>
				<thead>
					<tr>
						<th>Receipt ID</th>
						<th>Import Date</th>
						<th>Total Value</th>
						<th>Status</th>
						<th>Actions</th>
					</tr>
				</thead>
				<tbody>
					<c:set var="totalValue" value="0" />
					<c:forEach var="receipt" items="${importReceiptList}">
						<tr>
							<td>${receipt.importReceiptID}</td>
							<td>
								<fmt:formatDate value="${receipt.importDate}" pattern="dd-MM-yyyy" />
							</td>
							<td>
								<fmt:formatNumber value="${receipt.totalValue}" 
												  type="currency" currencyCode="VND" />
							</td>
							<td class="status-success">${receipt.status}</td>
							<td>
								<a href="${pageContext.request.contextPath}/importReceiptDetail?importReceiptID=${receipt.importReceiptID}&startDate=${startDate}&endDate=${endDate}">
									View Details
								</a>
							</td>
						</tr>
						<c:set var="totalValue" value="${totalValue + receipt.totalValue}" />
					</c:forEach>
				</tbody>
			</table>
            
			<div class="total-summary">
				Total Receipts: <span>${importReceiptList.size()}</span><br/>
				Total Value: <span><fmt:formatNumber value="${totalValue}" type="currency" currencyCode="VND" /></span>
			</div>
		</c:if>
        
		<c:if test="${empty importReceiptList}">
			<div class="notify">
				No import receipts found for this supplier in the selected date range.
			</div>
		</c:if>

		<form action="${pageContext.request.contextPath}/supplierStats" method="post" class="back-link" style="display:inline">
			<input type="hidden" name="startDate" value="${startDate}"/>
			<input type="hidden" name="endDate" value="${endDate}"/>
			<input type="hidden" name="statisticType" value="${empty statisticType ? 'revenue' : statisticType}"/>
			<button type="submit" style="background:none;border:none;color:#1d90f5;font-weight:600;cursor:pointer;padding:0">← Back to Statistics</button>
		</form>
	</div>

</body>
</html>
