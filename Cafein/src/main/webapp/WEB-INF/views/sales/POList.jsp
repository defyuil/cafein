<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
<%@ include file="../include/header.jsp"%>
<br>
<fieldset>
	<div class="col-12">
		<div class="bg-light rounded h-100 p-4">
				<form action="/sales/POList" method="GET" style="margin-bottom: 10px;">
				<h6>수주 조회</h6>
				<c:if test="${!empty param.searchBtn }">
				<input type="hidden" name="searchBtn" value="${param.searchBtn}" placeholder="납품처명을 입력하세요">
				</c:if>
				납품처조회
				<input type="text" name="searchText" placeholder="납품처명을 입력하세요">
				수주일자				
				<input type="date" id="startDate" name="startDate" required> ~
				<input type="date" id="endDate" name="endDate" required>
				<input class="search" type="submit" value="검색" data-toggle="tooltip" title="등록일이 필요합니다!">
			</form>	
			<form action="POList" method="GET">
					<c:if test="${!empty param.searchBtn }">
						<input type="hidden" name="searchBtn" value="${param.searchBtn}">
					</c:if>
					<c:if test="${!empty param.startDate }">
						<input type="hidden" value="${param.startDate }" name="startDate">
					</c:if>
					<c:if test="${!empty param.endDate }">
						<input type="hidden" value="${param.endDate }" name="endDate">
					</c:if>
				</form>
		</div>
	</div>
	<br>
		<!-- 수주 리스트 테이블 조회 -->
	<div class="col-12">
		<div class="bg-light rounded h-100 p-4" id="ListID">
		<form action="POListPrint" method="GET">
			<input id="ListExcel" type="submit" value="전체 리스트 출력(.xlsx)" class="btn btn-sm btn-success">
		</form><br>
			<form role="form" action="/sales/cancelUpdate" method="post">
				<h6 class="settingPO">수주 관리 [총 ${countPO}건]</h6>
				<!-- 수주 상태에 따라 필터링하는 버튼 -->
		<div class="btn-group" role="group">
			<input type="hidden" name="state" value="전체">
			<button type="button" class="btn btn-outline-dark" id="allpo">전체</button>
			<input type="hidden" name="state" value="대기">
			<button type="button" class="btn btn-outline-dark" id="stop">대기</button>
			<input type="hidden" name="state" value="진행">
			<button type="button" class="btn btn-outline-dark" id="ing">진행</button>
			<input type="hidden" name="state" value="완료">
			<button type="button" class="btn btn-outline-dark" id="complete">완료</button>
			<input type="hidden" name="state" value="취소">
			<button type="button" class="btn btn-outline-dark" id="cancel">취소</button>
		</div>

		
				 <input type="button" class="btn btn-dark m-2" data-bs-toggle="modal"
					data-bs-target="#registModal" id="regist" value="등록"> 
					<input type="hidden" class="btn btn-dark m-2" data-bs-toggle="modal"
					data-bs-target="#modifyModal" data-bs-whatever="@getbootstrap" value="수정">
					<input type="hidden" class="btn btn-dark m-2" data-bs-toggle="modal"
					data-bs-target="#openReceiptModal" data-bs-whatever="@getbootstrap" value="납품서">
				<div class="table-responsive">
					<table class="table">
						<thead>
							<tr>
								<th scope="col">번호</th>
								<th scope="col">수주상태</th>
								<th scope="col">수주코드</th>
								<th scope="col">납품처</th>
								<th scope="col">품명</th>
								<th scope="col">수량</th>
								<th scope="col">수주일자</th>
								<th scope="col">수정일자</th>
								<th scope="col">완납예정일</th>
								<th scope="col">담당자</th>
								<th scope="col">관리</th>
								<th scope="col">진행</th>
								<th scope="col">납품서발행</th>
								
								<th scope="col" style="display: none;">원산지</th>
								<th scope="col" style="display: none;">중량</th>
								<th scope="col" style="display: none;">단가</th>
								<th scope="col" style="display: none;">주소</th>
								<th scope="col" style="display: none;">대표자</th>
								<th scope="col" style="display: none;">사업자번호</th>
								<th scope="col" style="display: none;">전화번호</th>
								<th scope="col" style="display: none;">팩스번호</th>
							</tr>
						</thead>
						<tbody>
							<c:set var="counter" value="1" />
							<c:choose>
								<c:when test="${empty POList}">
									<p>No data available.</p>
								</c:when>
								<c:otherwise>
									<c:set var="counter" value="1" />
									<c:forEach items="${POList}" var="po" varStatus="status">
										<tr>
											<td id="poidCancel" style="display: none;">${po.poid }</td>
											<td>${counter }</td>
											<td>${po.postate }</td>
											<td>${po.pocode }</td>
											<td>${po.clientname}</td>
											<td>${po.itemname}</td>
											<td>${po.pocnt}</td>
											<td><fmt:formatDate value="${po.ordersdate}" dateStyle="short" pattern="yyyy-MM-dd" /></td>
											<c:choose>
												<c:when test="${empty po.updatedate}">
													<td>업데이트 날짜 없음</td>
												</c:when>
												<c:otherwise>
													<td><fmt:formatDate value="${po.updatedate}" dateStyle="short" pattern="yyyy-MM-dd" /></td>
												</c:otherwise>
											</c:choose>
											<td><fmt:formatDate value="${po.ordersduedate}" dateStyle="short" pattern="yyyy-MM-dd" /></td>
											<td>${po.membercode}</td>
											<td>
												<button type="button" class="btn btn-outline-dark"
													onclick="openModifyModal('${po.poid}','${po.clientid}','${po.itemid}','${po.clientname}', '${po.itemname}', '${po.postate}', '${po.pocnt}', '${po.ordersdate}', '${po.ordersduedate}', '${po.membercode}')">
													수정</button> 
													<input value="취소" type="submit" class="btn btn-outline-dark cancelUpdate" data-poid="${po.poid}">
											</td>
											<td><input value="진행" type="submit" class="btn btn-outline-dark ingUpdate" data-poid="${po.poid}"></td>
											<td>
												<input value="불러오기" type="button" class="btn btn-outline-dark" 
												onclick="openReceiptModal('${po.poid}','${po.clientid}','${po.itemid}','${po.clientname}', '${po.itemname}', '${po.postate}', 
												'${po.pocnt}', '${po.ordersdate}', '${po.ordersduedate}', '${po.membercode}', '${po.origin}', '${po.itemweight}', '${po.itemprice}',
												'${po.representative}','${po.clientaddress}' , '${po.businessnumber}', '${po.clientphone}' , '${po.clientfax}' )">
											</td>
											
											<td style="display: none;">${po.origin}</td>
											<td style="display: none;">${po.itemweight}</td>
											<td style="display: none;">${po.itemprice}</td>
											<td style="display: none;">${po.clientaddress}</td>
											<td style="display: none;">${po.representative}</td>
											<td style="display: none;">${po.businessnumber}</td>
											<td style="display: none;">${po.clientphone}</td>
											<td style="display: none;">${po.clientfax}</td>
											
										</tr>
										<c:set var="counter" value="${counter+1 }" />
									</c:forEach>
								</c:otherwise>
							</c:choose>
						</tbody>
					</table>
				</div>
			<!-- 페이지 블럭 생성 -->
			<nav aria-label="Page navigation example">
  				<ul class="pagination justify-content-center">
    				<li class="page-item">
    					<c:if test="${pageVO.prev }">
      						<a class="page-link pageBlockPrev" href="" aria-label="Previous" data-page="${pageVO.startPage - 1}">
        						<span aria-hidden="true">&laquo;</span>
      						</a>
      						
							<!-- 버튼에 파라미터 추가 이동 (이전) -->
							<script>
								$(document).ready(function(){
   									$('.pageBlockPrev').click(function(e) {
   										e.preventDefault(); // 기본 이벤트 제거
   									
   						            	let prevPage = $(this).data('page');
   									
   						            	let searchBtn = "${param.searchBtn}";
   						            	let searchText = "${param.searchText}";
   						            	let startdate = "${param.startdate}";
   						            	let enddate = "${param.enddate}";

   						            	url = "/sales/POList?page=" + nextPage;

   						            	if (searchBtn) {
   						            	  url += "&searchBtn=" + encodeURIComponent(searchBtn);
   						            	}

   						            	if (searchText) {
   						            	  url += "&searchText=" + encodeURIComponent(searchText);
   						            	}

   						            	if (startdate) {
   						            	  url += "&startdate=" + encodeURIComponent(startdate);
   						            	}

   						            	if (enddate) {
   						            	  url += "&enddate=" + encodeURIComponent(enddate);
   						            	}

   				                		location.href = url;
    								});
								});
							</script>
							<!-- 버튼에 파라미터 추가 이동 (이전) -->
      						
    					</c:if>
    				</li>
					<c:forEach begin="${pageVO.startPage }" end="${pageVO.endPage }" step="1" var="i">
    				<li class="page-item ${pageVO.cri.page == i? 'active' : ''}"><a class="page-link pageBlockNum" href="" data-page="${i}">${i }</a></li>
					
					<!-- 버튼에 파라미터 추가 이동 (번호) -->
					<script>
					$(document).ready(function(){
			            $('.pageBlockNum[data-page="${i}"]').click(function (e) {
			                e.preventDefault(); // 기본 이벤트 방지
			                
			               	let searchText = "${param.searchText}";	
			                let searchBtn = "${param.searchBtn}";
			                let startdate = "${param.startdate}";
			            	let enddate = "${param.enddate}";

			                let pageValue = $(this).data('page');
		                	url = "/sales/POList?page=" + pageValue;
			                
			                if (searchBtn) {
			                    url += "&searchBtn=" + encodeURIComponent(searchBtn);
			                }
			                
			                if (searchText) {
			                    url += "&searchText=" + encodeURIComponent(searchText);
			                }
			                if (startdate) {
			            	  url += "&startdate=" + encodeURIComponent(startdate);
			            	}

			            	if (enddate) {
			            	  url += "&enddate=" + encodeURIComponent(enddate);
			            	}
			                
			                location.href = url;
			            });
					});	
					</script>
					<!-- 버튼에 파라미터 추가 이동 (번호) -->
					
					</c:forEach>
    				<li class="page-item">
    					<c:if test="${pageVO.next }">
      						<a class="page-link pageBlockNext" href="" aria-label="Next" data-page="${pageVO.endPage + 1}">
        						<span aria-hidden="true">&raquo;</span>
      						</a>	
      					<!-- 버튼에 파라미터 추가 이동 (이후) -->
						<script>
							$(document).ready(function(){
   								$('.pageBlockNext').click(function(e) {
   									e.preventDefault(); // 기본 이벤트 제거
   									
   						            let nextPage = $(this).data('page');
   									
   									let searchBtn = "${param.searchBtn}";
   									let searchText = "${param.searchText}";
   									let startdate = "${param.startdate}";
					            	let enddate = "${param.enddate}";

   				                	url = "/sales/POList?page=" + nextPage;
   				                
   				                	if (searchBtn) {
   				                    	url += "&searchBtn=" + encodeURIComponent(searchBtn);
   				                	}
   				                
   				                	if (searchText) {
   				                    	url += "&searchText=" + encodeURIComponent(searchText);
   				                	}
   				                	if (startdate) {
					            	  url += "&startdate=" + encodeURIComponent(startdate);
					            	}

					            	if (enddate) {
					            	  url += "&enddate=" + encodeURIComponent(enddate);
					            	}
   				                
   				                	location.href = url;
    							});
							});
						</script>
						<!-- 버튼에 파라미터 추가 이동 (이전) -->  					
    					</c:if>
    				</li>
  				</ul>
			</nav>
			<!-- 페이지 블럭 생성 -->
			</form>
		</div>
	</div>
	
	<!--납품서 모달창 -->
	<div class="modal fade" id="openReceiptModal" tabindex="-1" aria-labelledby="exampleModalLabel" aria-hidden="true">
		<div class="modal-dialog">
			<div class="modal-content rectipt-body">
			
				<div class="modal-header">
				<h5 class="modal-title recript-title" id="exampleModalLabel">납품서</h5>
					<div class="odate">
				수주일자<input name="ordersdate" id="rordersdate"  type="text"  class="form-control form-control-sm"  readonly></div>
					<button type="button" class="btn-close" data-bs-dismiss="modal"
						aria-label="Close"></button>
				</div>
				
				<form role="form" action="/sales/receipt" method="get">
				
				<div class="modal-body">
				<input id="rpoid" name="poid" class="form-control mb-3" type="hidden" value="" readonly> 
				
				<div class="col-12">
						<div class="bg-light rounded h-100 p-4">
							<table class="table">
							<thead>
									<tr>
										<td class="pt15 rowspan6" rowspan="6">공급처</td>
										<td class="pt15"><b>등록번호(사업자번호)</b></td>
										<td><input   id="r사업자번호" name="사업자번호" class="form-control form-control-sm" type="text"  readonly value="12345-54321"></td>
										<td class="pt15 rowspan6" rowspan="6">납품처</td>
										<td class="pt15"><b>상호</b></td>
										<td><input   id="rclientname" name="clientname" class="form-control form-control-sm" type="text"  readonly></td>
									</tr>
									<tr>
										<td class="pt15"><b>상호</b></td>
										<td><input  id="rcafein" name="cafein" class="form-control form-control-sm" type="text"  readonly value="cafein"></td>
										<td class="pt15"><b>성명</b></td>
										<td><input   id="rrepresentative" name="representative" class="form-control form-control-sm" type="text" value="" readonly></td>
									</tr>
									<tr>
										<td class="pt15"><b>대표자</b></td>
										<td><input id="rmembername" name="membername" class="form-control form-control-sm" type="text" value="이현정" readonly></td>
										<td class="pt15"><b>주소</b></td>
										<td><input   id="rclientaddress" name="clientaddress" class="form-control form-control-sm" type="text" value="" readonly></td>
									</tr>
									<tr>
										<td class="pt15"><b>주소</b></td>
										<td><input id="rcafeinadress" name="cafeinadress" class="form-control form-control-sm" type="text" value="부산광역시 부산진구 동천로 109 삼한골든게이트 7층" readonly></td>
										<td class="pt15"></td>
										<td class="pt15"></td>
									</tr>
									<tr>
										<td class="pt15"><b>전화번호</b></td>
										<td><input id="rcafeinadress" name="cafeinadress" class="form-control form-control-sm" type="text" value="051-803-0909" readonly></td>
										<td class="pt15"></td>
										<td class="pt15"></td>
									</tr>
									<tr>
										<td class="pt15"><b>팩스번호</b></td>
										<td><input id="rcafeinadress" name="cafeinadress" class="form-control form-control-sm" type="text" value="0504-456-2580" readonly></td>
										<td class="pt15"></td>
										<td class="pt15"></td>
									</tr>
									</thead>
									<tbody>
										<tr>
											<th>품명</th>
											<th>원산지</th>
											<th>중량</th>
											<th>단가</th>
											<th>수량</th>
											<th>공급가액</th>
											<th>공급세액</th>
											<th>합계총액</th>
										</tr>
										<tr>
											<td><input   id="ritemname" name="itemname" class="form-control form-control-sm" type="text" readonly ></td>
											<td><input   id="rorigin" name="origin" class="form-control form-control-sm" type="text" value="" readonly></td>
											<td><input   id="ritemweight" name="itemweight" class="form-control form-control-sm" type="number" value="" readonly></td>
											<td><input   id="ritemprice" name="itemprice" class="form-control form-control-sm" type="number" value="" readonly></td>
											<td><input   id="rpocnt" name="pocnt" class="form-control form-control-sm" type="number" value="" readonly></td>
											<td><input   id="rsum" name="sum" class="form-control form-control-sm" type="number" value="" readonly></td>
											<td><input   id="rtax" name="tax" class="form-control form-control-sm" type="number" value="" readonly></td>
											<td><input  name="total" class="form-control form-control-sm rtotal" type="number"  readonly></td>
										</tr>
										<tr class="tdempty">
											<td></td>
											<td></td>
											<td></td>
											<td></td>
											<td></td>
											<td></td>
											<td></td>
										</tr>
										<tr class="tdempty">
											<td></td>
											<td></td>
											<td></td>
											<td></td>
											<td></td>
											<td></td>
											<td></td>
										</tr>
										<tr class="tdempty">
											<td></td>
											<td></td>
											<td></td>
											<td></td>
											<td></td>
											<td></td>
											<td></td>
										</tr>
										<tr class="tdempty">
											<td></td>
											<td></td>
											<td></td>
											<td></td>
											<td></td>
											<td></td>
											<td></td>
										</tr>
										<tr class="tdempty">
											<td></td>
											<td></td>
											<td></td>
											<td></td>
											<td></td>
											<td></td>
											<td></td>
										</tr>
										<tr>
											<td class="pt15">합계총액</td>
											<td><input name="total" class="form-control form-control-sm rtotal" type="number"  readonly></td>
										</tr>
										<tr>
											<td class="pt15">납품예정일</td>
											<td><input name="ordersduedate" type="date" id="rdate" class="form-control form-control-sm" value="" readonly></td>
										</tr>
										<tr>
											<td class="pt15">대표자</td>
											<td><input id="rmembername" name="membername" class="form-control form-control-sm" type="text" value="이현정" readonly></td>
										</tr>
										
									</tbody>
							</table>
						</div>
						<div class="modal-footer"></div>
					</div>
				</div><br>
			<div class="modal-footer">
				<button type="button" class="btn btn-secondary"
					data-bs-dismiss="modal">확인</button>
				<input type="button" class="btn btn-sm btn-success" id="receiptBtn" value="엑셀파일 다운">
			</div>
			</form>
		</div>
	</div>
</div>
	

<script>
	/* 리스트 값 납품서 모달로 값 전달 */
	function openReceiptModal(poid, clientid, itemid, clientname, itemname, postate, pocnt, ordersdate, ordersduedate, membercode, 
			origin, itemweight, itemprice, representative, clientaddress, businessnumber, clientphone, clientfax) {
		console.log('poid:', poid);
		console.log('clientid:', clientid);
		console.log('itemid:', itemid);
		console.log('clientname:', clientname);
		console.log('itemname:', itemname);
		console.log('postate:', postate);
		console.log('pocnt:', pocnt);
		console.log('ordersdate:', ordersdate);
		console.log('ordersduedate:', ordersduedate);
		console.log('membercode:', membercode);
		console.log('origin:', origin);
		console.log('ritemweight:', itemweight);
		console.log('ritemprice:', itemprice);

		var sum = pocnt * itemprice; //공급가액
		var tax = sum*0.1; //공급세액
		var total = sum+tax; //합계금액
		
		// 가져온 값들을 모달에 설정
		$("#rpoid").val(poid);
		$("#rclientid").val(clientid);
		$("#ritemid").val(itemid);
		$("#rclientname").val(clientname);
		$("#ritemname").val(itemname);
		$("#rfloatingSelect").val(postate);
		$("#rpocnt").val(pocnt);
		$("#rordersdate").val(ordersdate);
		$("#rdate").val(ordersduedate);
		$("#rmembercode").val(membercode);
		
		$("#rorigin").val(origin);
		$("#ritemweight").val(itemweight);
		$("#ritemprice").val(itemprice);
		$("#rsum").val(sum);
		$("#rtax").val(tax);
		$(".rtotal").val(total);
		
		$("#rrepresentative").val(representative);
		$("#rclientaddress").val(clientaddress);
		$("#rbusinessnumber").val(businessnumber);
		$("#rclientphone").val(clientphone);
		$("#rclientfax").val(clientfax);

		// 모달 열기
$("#openReceiptModal").modal('show');
		console.log("납품서 모달 열기");
	}
</script>
	
	<!-- 품목 등록 모달 -->
	<jsp:include page="registPO.jsp" />
	<!-- 품목 수정 모달 -->
	<jsp:include page="modifyPO.jsp" />

	<!-- 납품처 조회 모달 -->
	<div class="modal fade" id="clientSM" tabindex="-1" aria-labelledby="exampleModalLabel" aria-hidden="true">
		<div class="modal-dialog">
			<div class="modal-content">
				<div class="modal-header">
					<h5 class="modal-title" id="exampleModalLabel">납품처 조회</h5>
					<button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
				</div>
				<div class="modal-body">

					납품처명 <input type="search" class="clientNS"><br> 납품처코드 <input type="search" class="clientCS">
					<button id="clibtn" type="submit" class="btn btn-dark m-2">조회</button>
					<br> <br>
					<div class="col-12">
						<div class="bg-light rounded h-100 p-4">
							<table class="table">
								<thead>
									<tr>
										<th scope="col">납품처명</th>
										<th scope="col">납품처코드</th>
									</tr>
								</thead>
								<tbody>
									<c:forEach items="${cliList}" var="cli">
										<tr class="clientset">
											<td>${cli.clientname }</td>
											<td>${cli.clientcode }</td>
										</tr>
									</c:forEach>
								</tbody>
							</table>
						</div>
						<div class="modal-footer"></div>
					</div>
				</div>
			</div>
		</div>
	</div>

	<!-- 품목 조회 모달 -->
	<div class="modal fade" id="itemSM" tabindex="-1" aria-labelledby="exampleModalLabel" aria-hidden="true">
		<div class="modal-dialog">
			<div class="modal-content">
				<div class="modal-header">
					<h5 class="modal-title" id="exampleModalLabel">품목 조회</h5>
					<button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
				</div>
				<div class="modal-body">

					품명 <input type="search" class="itemNS"><br> 품목코드 <input type="search" class="itemCS">
					<button id="itembtn" type="submit" class="btn btn-dark m-2">조회</button>
					<br> <br>
					<div class="col-12">
						<div class="bg-light rounded h-100 p-4">
							<table class="table">
								<thead>
									<tr>
										<th scope="col">품명</th>
										<th scope="col">품목코드</th>
									</tr>
								</thead>
								<tbody>
									<c:forEach items="${iList}" var="item">
										<tr class="itemset">
											<td>${item.itemname }</td>
											<td>${item.itemcode }</td>
										</tr>
									</c:forEach>
								</tbody>
							</table>
						</div>
						<div class="modal-footer"></div>
					</div>
				</div>
			</div>
		</div>
	</div>
</fieldset>


<%@ include file="../sales/POListJS.jsp"%>
<%@ include file="../include/footer.jsp"%>