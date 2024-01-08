<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
<%@ include file="../include/header.jsp"%>
<br>
<fiedset>
	<!-- 검색 폼 -->
		<div class="col-12">
		<div class="bg-light rounded h-100 p-4">
			<form name="dateSearch" action="/production/WKList" method="get">
				<c:if test="${!empty param.searchBtn }">
				<input type="hidden" name="searchBtn" value="${param.searchBtn}" placeholder="검색">
				</c:if>
				검색 <input class="workSearch" type="text" name="searchText" placeholder="검색">
				작업지시일자 
				<input type="date" id="startDate" name="startDate" required> ~
				<input type="date" id="endDate" name="endDate" required>
				<input class="search" type="submit" value="검색" data-toggle="tooltip" title="등록일이 필요합니다!">
				<br>
			</form>
						<form action="WKList" method="GET">
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

	<!-- 작업지시 조회 -->
	<div class="col-12" style="margin-top: 20px;">
		<div class="bg-light rounded h-100 p-4">
			<h6 class="mb-4">작업지시 관리  <span class="settingWK">[총 ${countWK}건]</span> </h6>

		<div class="col-12">
		<div class="buttonarea1" style="margin-bottom: 10px;">
			<input type="hidden" name="state" value="전체">
			<button type="button" class="btn btn-sm btn-primary"  id="allwk">전체</button>
			<input type="hidden" name="state" value="접수">
			<button type="button" class="btn btn-sm btn-success" id="stop">접수</button>
			<input type="hidden" name="state" value="진행">
			<button type="button" class="btn btn-sm btn-danger" id="ing">진행</button>
			<input type="hidden" name="state" value="완료">
			<button type="button" class="btn btn-sm btn-warning" id="complete">완료</button>
						<span id="buttonset1"><button type="button"
					class="btn btn-dark m-2" data-bs-toggle="modal"
					data-bs-target="#registModal" data-bs-whatever="@getbootstrap">신규
					등록</button></span>
		</div>
		
				<script>
		$("#allwk").click(function() {
		   location.href="/production/WKList";
		});

		$("#stop").click(function () {
		 	console.log("접수 버튼 클릭됨");
			event.preventDefault();
		    location.href="/production/WKList?worksts=접수";
		});

		$("#ing").click(function() {
		 console.log("진행 버튼 클릭됨");
		 event.preventDefault();
		 location.href="/production/WKList?worksts=진행";
		});

		$("#complete").click(function() {
			console.log("완료 버튼 클릭됨");
			 event.preventDefault();
			 location.href="/production/WKList?worksts=완료";
		});

		function updateTotalCount() {
			var totalCount = $(".table tbody tr:visible").length;
			$(".settingWK").text("총 " + totalCount + "건");
		}

		// 필터링할 때마다 호출하여 업데이트
		function updateRowNumbers() {
			var counter = 1;
			$(".table tbody tr:visible").each(function() {
				$(this).find('td:nth-child(2)').text(counter);
				counter++;
			});

			// 총 건수 업데이트 호출
			updateTotalCount();
		}
		</script>
		

					<input type="hidden" class="btn btn-dark m-2" data-bs-toggle="modal" data-bs-target="#modifyModal" data-bs-whatever="@getbootstrap" value="수정">
			<form role="form" action="/production/WKList" method="post">
			<div class="table-responsive">
				<div class="table-responsive" style="text-align: center;">
					<table class="table" id="workTable">
						<thead>
							<tr>
								<th scope="col">No.</th>
								<th scope="col">작업지시일</th>
								<th scope="col">작업지시코드</th>
								<th scope="col">수주코드</th>
								<th scope="col">납품처</th>
								<th scope="col">제품명</th>
								<th scope="col">지시상태</th>
								<th scope="col">지시수량</th>
								<th scope="col">수정일자</th>
								<th scope="col">완료일자</th>
								<th scope="col">담당자</th>
								<th scope="col">관리</th>
							</tr>
						</thead>
						<tbody>
						<c:set var="counter" value="1" />
							<c:choose>
								<c:when test="${empty WKList}">
									<p>No data available.</p>
								</c:when>
								<c:otherwise>
									<c:set var="counter" value="1" />
							<c:forEach items="${ WKList }" var="wk">
								<tr>
									<td>${wk.workid }</td>
									<td><fmt:formatDate value="${wk.workdate1 }"
											pattern="yyyy-MM-dd" /></td>
									<td>${wk.workcode }</td>
									<td>${wk.pocode }</td>
									<td>${wk.clientname}</td>
									<td>${wk.itemname }</td>
									<td>${wk.worksts }</td>
									<td>${wk.pocnt }</td>
									<c:choose>
									<c:when test="${empty wk.workupdate}">
										<td>업데이트 날짜 없음</td>
									</c:when>
									<c:otherwise>
										<td><fmt:formatDate value="${wk.workupdate}" dateStyle="short" pattern="yyyy-MM-dd" /></td>
									</c:otherwise>
									</c:choose>
									<c:choose>
									<c:when test="${empty wk.workdate2}">
										<td>업데이트 날짜 없음</td>
									</c:when>
									<c:otherwise>
										<td><fmt:formatDate value="${wk.workdate2}" dateStyle="short" pattern="yyyy-MM-dd" /></td>
									</c:otherwise>
									</c:choose>
									<td>${wk.membercode }</td>
									<!-- 버튼 수정 -->
									<td>
									<button type="button" class="btn btn-outline-dark"
    										onclick="openModifyModal('${wk.workid}','${wk.pocode}', '${wk.clientname}', '${wk.itemname}', '${wk.worksts}', '${wk.pocnt}', '${wk.workdate1}', '${wk.workupdate}', '${wk.membercode}')">
    										수정
									</button>
									<input type="button" class="btn btn-outline-dark" value="삭제" id="deleteBtn">
									</td>
								</tr>
							</c:forEach>
							</c:otherwise>
						</c:choose>
						</tbody>
					</table>
				</div>
			</div>
			</form>
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

   						            	url = "/production/WKList?page=" + nextPage;

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
		                	url = "/production/WKList?page=" + pageValue;
			                
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

   				                	url = "/production/WKList?page=" + nextPage;
   				                
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
		</div>
	</div>
</fiedset>
		<jsp:include page="registWK.jsp"/>
		<jsp:include page="modifyWK.jsp"/>



<script>
// 수정된 값을 서버로 전송
$("#modifyButton").click(function() {
    // 가져온 값들을 변수에 저장
    var modifiedWorkid = $("#workid2").val();
    var modifiedPocode = $("#pocode2").val();
    var modifiedClientName = $("#clientcode2").val();
    var modifiedItemName = $("#itemcode2").val();
    var modifiedWorksts = $("#worksts2").val();
    var modifiedPocnt = $("#pocnt2").val();
    var modifiedWorkdate1 = $("#workdate11").val();
    var modifiedWorkupdate = $("#workupdate2").val();
    var modifiedMemberCode = $("#membercode2").val();

    // Ajax를 사용하여 서버로 수정된 값 전송
    $.ajax({
        type: "POST",
        url: "/production/modifyWK",
        data: {
        	 workid: modifiedWorkid,
        	 pocode: modifiedPocode,
        	 clientname: modifiedClientName,
             itemname: modifiedItemName,
             worksts: modifiedWorksts,
             pocnt: modifiedPocnt,
             workdate1: modifiedworkDate1,
             workupdate: modifiedWorkupDate,
             membercode: modifiedMemberCode
        },
        success: function(response) {
            console.log("Modification success:", response);
            $("#modifyModal").modal('hide');
        },
        error: function(error) {
            console.error("Error during modification:", error);
        }
    });
});
	   
	   function openModifyModal(workid, pocode, clientname, itemname, worksts, pocnt, workdate1, workupdate, membercode) {

		   
		   // 가져온 값들을 모달에 설정
		   $("#workid2").val(workid);
		    $("#pocode2").val(pocode);
		    $("#clientcode2").val(clientname);
		    $("#itemcode2").val(itemname);
		    $("#worksts2").val(worksts);
		    $("#pocnt2").val(pocnt);
		    $("#workdate11").val(workdate1);
		    $("#workupdate2").val(workupdate);
		    $("#membercode2").val(membercode);

		    // 모달 열기
		    $("#modifyModal").modal('show');
		    
		}
	   
	    $('#workdate11').click(function(){
	        var today = new Date();
	        // 날짜를 YYYY-MM-DD 형식으로 포맷팅
	        var formattedDate = today.getFullYear() + '-' + ('0' + (today.getMonth() + 1)).slice(-2) + '-' + ('0' + today.getDate()).slice(-2);
	        $('#workdate11').val(formattedDate);
	    });
	    
	    $('#workupdate2').click(function(){
	        var today = new Date();
	        // 날짜를 YYYY-MM-DD 형식으로 포맷팅
	        var formattedDate = today.getFullYear() + '-' + ('0' + (today.getMonth() + 1)).slice(-2) + '-' + ('0' + today.getDate()).slice(-2);
	        $('#workupdate2').val(formattedDate);
	    });
	    
		// 작업지시 삭제 (작업지시가 대기일 경우에만 삭제 가능)
	    $("td").on("click", "#deleteBtn", function() {
	    	
	    	Swal.fire({
	  		  title: '삭제하시겠습니까?',
	  		  text: "",
	  		  icon: 'warning',
	  		  showCancelButton: true,
	  		  confirmButtonColor: '#3085d6',
	  		  cancelButtonColor: '#d33',
	  		  confirmButtonText: '삭제',
	  		  cancelButtonText: '취소'
	  		}).then((result) => {
	  			if (result.value) {
	        	
	        	var workid = $(this).closest("tr").find("td:first").text();
				console.log(workid);
	        	
	        	// AJAX 요청 수행
	        	$.ajax({
	           		url : "/production/WKDelete",
	           		type : "POST",
	           		data : {
	           			workid : workid
	           		},
	          		success : function(response) {
	              		// 성공적으로 처리된 경우 수행할 코드
	              		console.log("삭제 성공");
	              		location.reload();
	           		},
	           		error : function(error) {
	              		// 요청 실패 시 수행할 코드
	              		console.error("삭제 실패:", error);
	           		}
				});
	        	
	        	} 
	   		 })
	   		 
	     });		
	    
	   </script>
	   


<%@ include file="../include/footer.jsp"%>