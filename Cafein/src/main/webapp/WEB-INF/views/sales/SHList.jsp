<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
<%@ include file="../include/header.jsp"%>
<br>
<fieldset>
		<div class="col-12">
		<div class="bg-light rounded h-100 p-4">
			<form name="dateSearch" action="/sales/SHList" method="get">
				<c:if test="${!empty param.searchBtn }">
				<input type="hidden" name="searchBtn" value="${param.searchBtn}" placeholder="검색">
				</c:if>
				검색 <input class="shipSearch" type="text" name="searchText" placeholder="검색">
				출하일자 
				<input type="date" id="startDate" name="startDate" required> ~
				<input type="date" id="endDate" name="endDate" required>
				<input class="search" type="submit" value="검색" data-toggle="tooltip" title="등록일이 필요합니다!">
				<br>
			</form>
			<form action="SHList" method="GET">
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

	<!-- 작업지시 조회 -->
	<div class="col-12" style="margin-top: 20px;">
		<div class="bg-light rounded h-100 p-4">
			<h6 class="mb-4">출하 관리  <span class="settingSH">[총 ${countSH}건]</span> </h6>

		<div class="col-12">
		<div class="btn-group" role="group">
			<input type="hidden" name="state" value="전체">
			<button type="button" class="btn btn-outline-dark" id="allsh">전체</button>
			<input type="hidden" name="state" value="대기">
			<button type="button" class="btn btn-outline-dark" id="stop">접수</button>
			<input type="hidden" name="state" value="접수">
			<button type="button" class="btn btn-outline-dark" id="ing">진행</button>
			<input type="hidden" name="state" value="완료">
			<button type="button" class="btn btn-outline-dark" id="complete">완료</button>
		</div>
		
		<script>
		$("#allsh").click(function() {
		   location.href="/sales/SHList";
		});

		$("#stop").click(function () {
		 	console.log("접수 버튼 클릭됨");
			event.preventDefault();
		    location.href="/sales/SHList?shipsts=접수";
		});

		$("#ing").click(function() {
		 console.log("진행 버튼 클릭됨");
		 event.preventDefault();
		 location.href="/sales/SHList?shipsts=진행";
		});

		$("#complete").click(function() {
			console.log("완료 버튼 클릭됨");
			 event.preventDefault();
			 location.href="/sales/SHList?shipsts=완료";
		});

		function updateTotalCount() {
			var totalCount = $(".table tbody tr:visible").length;
			$(".settingSH").text("총 " + totalCount + "건");
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
		
			<span id="buttonset1"><button type="button"
					class="btn btn-dark m-2" data-bs-toggle="modal"
					data-bs-target="#registModal" data-bs-whatever="@getbootstrap">신규
					등록</button></span>
					<input type="hidden" class="btn btn-dark m-2" data-bs-toggle="modal" data-bs-target="#modifyModal" data-bs-whatever="@getbootstrap" value="수정">
			<form role="form" action="/sales/SHList" method="post">
			<div class="table-responsive">
				<div class="table-responsive" style="text-align: center;">
					<table class="table" id="workTable">
						<thead>
							<tr>
								<th scope="col">No.</th>
								<th scope="col">출하일</th>
								<th scope="col">출하코드</th>
								<th scope="col">작업지시코드</th>
								<th scope="col">납품처</th>
								<th scope="col">제품명</th>
								<th scope="col">출하량</th>
								<th scope="col">출하상태</th>
								<th scope="col">완료일자</th>
								<th scope="col">담당자</th>
								<th scope="col">관리</th>
							</tr>
						</thead>
						<tbody>
						<c:set var="counter" value="1" />
							<c:choose>
								<c:when test="${empty AllSHList}">
									<p>No data available.</p>
								</c:when>
								<c:otherwise>
									<c:set var="counter" value="1" />
							<c:forEach items="${AllSHList}" var="sh">
						<tr>
							<td>${sh.shipid }</td>
							<td><fmt:formatDate value="${sh.shipdate1 }"
									pattern="yyyy-MM-dd" /></td>
							<td>${sh.shipcode }</td>
							<td>${sh.workcode }</td>
							<td>${sh.clientname}</td>
							<td>${sh.itemname }</td>
							<td>${sh.pocnt }</td>
							<td>${sh.shipsts }</td>
							<c:choose>
									<c:when test="${empty sh.shipdate2}">
										<td>업데이트 날짜 없음</td>
									</c:when>
									<c:otherwise>
										<td><fmt:formatDate value="${sh.shipdate2}" dateStyle="short" pattern="yyyy-MM-dd" /></td>
									</c:otherwise>
									</c:choose>
							<td>${sh.membercode }</td>
							<td>
								<!-- 버튼 수정 -->
									<button type="button" class="btn btn-outline-dark"
    										onclick="openModifyModal('${sh.shipid}','${sh.workcode}', '${sh.clientname}', '${sh.itemname}', '${sh.shipsts}', '${sh.pocnt}', '${sh.shipdate1}', '${sh.membercode}')">
    										수정
									</button>
									</td>
								</tr>
								<c:set var="counter" value="${counter+1 }" />
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

   						            	url = "/sales/SHList?page=" + nextPage;

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
		                	url = "/sales/SHList?page=" + pageValue;
			                
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

   				                	url = "/sales/SHList?page=" + nextPage;
   				                
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
	</fieldset>
		
 		<jsp:include page="registSH.jsp"/> 
		<jsp:include page="modifySH.jsp"/>

<!-- 검색 -->

<!-- <script> -->


<!-- // $('.shipSearch').on('input', function(event) { -->
<!-- //     filterRows(event); -->
<!-- // }); -->

<!-- // function filterRows(event) { -->
<!-- //     event.preventDefault(); -->

<!-- //     var keyword = $('.shipSearch').val().toLowerCase(); -->
<!-- //     var startDate = $("#shipdate1").val(); -->
<!-- //     var endDate = $("#shipdate2").val(); -->

    
<!-- //     var modifiedShipid = $("#shipid").val(); -->
<!-- //     var modifiedShipcode = $("#shipcode").val(); -->
<!-- //     var modifiedClientName = $("#clientcname").val(); -->
<!-- //     var modifiedItemName = $("#itemname").val(); -->
<!-- //     var modifiedShipsts = $("#shipsts").val(); -->
<!-- //     var modifiedPocnt = $("#pocnt").val(); -->
<!-- //     var modifiedShipdate1 = $("#shipdate1").val(); -->
<!-- //     var modifiedShipdate2 = $("#shipdate2").val(); -->
<!-- //     var modifiedMemberCode = $("#membercode").val(); -->

<!-- //     // AJAX 요청 보내기 -->
<!-- //     $.ajax({ -->
<!-- //         type: 'POST', // 또는 'GET', 요청 방식에 따라 변경 -->
<!-- //         url: '/sales/SHList', // 실제 서버의 엔드포인트 URL로 변경해야 합니다. -->
<!-- //         data: JSON.stringify({ -->
<!-- //         keyword: keyword, -->
<!-- //         shipdate1: startDate, -->
<!-- //         shipdate2: endDate, -->
<!-- //         shipid: modifiedShipid, -->
<!-- //         shipdate1: modifiedShipdate1, -->
<!-- //         shipcode: modifiedShipcode, -->
<!-- //         clientname: modifiedClientName, -->
<!-- //         itemname: modifiedItemName, -->
<!-- //         pocnt: modifiedPocnt, -->
<!-- //         shipsts: modifiedShipsts, -->
<!-- //         shipdate2: modifiedShipdate2, -->
<!-- //         membercode: modifiedMemberCode -->
<!-- //    		 }), -->
<!-- //    		  contentType: 'application/x-www-form-urlencoded', -->
<!-- //    		  success: function(response) { -->
<!-- //    			 console.log("keyword:", keyword) -->
<!-- //             updateTable(response); -->
<!-- //         }, -->
<!-- //         error: function(error) { -->
<!-- //             console.error('Error fetching data:', error); -->
<!-- //         } -->
<!-- //     }); -->

<!-- //     return false; -->
<!-- // } -->

<!-- // function updateTable(data) { -->
<!-- //     // 서버에서 받아온 데이터를 이용하여 테이블 업데이트 -->

<!-- //     // 표시된 행만 선택하여 번호 업데이트 -->
<!-- //     var visibleRows = $('.workTable tbody tr:visible'); -->
<!-- //     visibleRows.each(function(index) { -->
<!-- //         // 첫 번째 자식 요소인 td 엘리먼트를 찾아 번호를 업데이트 -->
<!-- //         $(this).find('td:first').text(index + 1); -->
<!-- //     }); -->

<!-- //     // 테이블의 tbody를 비워주고 서버에서 받아온 데이터로 다시 채우기 -->
<!-- //     var tbody = $('.workTable tbody'); -->
<!-- //     tbody.empty(); -->

<!-- //     // 서버에서 받아온 데이터를 이용하여 새로운 행 추가 -->
<!-- //     for (var i = 0; i < data.length; i++) { -->
<!-- //         var sh = data[i]; -->
<!-- //         var newRow = $('<tr>'); -->
<!-- //         newRow.append('<td>' + sh.shipid + '</td>'); -->
<!-- //         newRow.append('<td>' + sh.shipdate1 + '</td>'); -->
<!-- //         newRow.append('<td>' + sh.shipcode + '</td>'); -->
<!-- //         newRow.append('<td>' + sh.workcode + '</td>'); -->
<!-- //         newRow.append('<td>' + sh.clientname + '</td>'); -->
<!-- //         newRow.append('<td>' + sh.itemname + '</td>'); -->
<!-- //         newRow.append('<td>' + sh.pocnt + '</td>'); -->
<!-- //         newRow.append('<td>' + sh.shipsts + '</td>'); -->
<!-- //         newRow.append('<td>' + sh.shipdate2 + '</td>'); -->
<!-- //         newRow.append('<td>' + sh.membercode + '</td>'); -->
<!-- //         newRow.append('<td><button type="button" class="btn btn-outline-dark" onclick="openModifyModal(' + -->
<!-- //             sh.workid + ', \'' + sh.pocode + '\', \'' + sh.clientname + '\', \'' + sh.itemname + '\', \'' + -->
<!-- //             sh.worksts + '\', \'' + sh.pocnt + '\', \'' + sh.workdate1 + '\', \'' + sh.workupdate + '\', \'' + -->
<!-- //             sh.membercode + '\')">수정</button></td>'); -->

<!-- //         tbody.append(newRow); -->
<!-- //     } -->

<!-- //     // 번호 업데이트 -->
<!-- //     updateRowNumbers(); -->
<!-- //     // 총 건수 업데이트 -->
<!-- //     updateTotalCount(); -->
<!-- // } -->


<!-- // // 이하 생략 -->




<!-- // $("#allwk").click(function() { -->
<!-- // 	$(".table tbody tr").show(); -->
<!-- // 	updateTotalCount(); -->
<!-- // }); -->

<!-- // $("#stop").click(function() { -->
<!-- // 	$(".table tbody tr").hide(); -->
<!-- // 	$(".table tbody tr:has(td:nth-child(7):contains('접수'))").show(); -->
<!-- // 	updateTotalCount(); -->
<!-- // }); -->

<!-- // $("#ing").click(function() { -->
<!-- // 	$(".table tbody tr").hide(); -->
<!-- // 	$(".table tbody tr:has(td:nth-child(7):contains('진행'))").show(); -->
<!-- // 	updateTotalCount(); -->
<!-- // }); -->

<!-- // $("#complete").click(function() { -->
<!-- // 	$(".table tbody tr").hide(); -->
<!-- // 	$(".table tbody tr:has(td:nth-child(7):contains('완료'))").show(); -->
<!-- // 	updateTotalCount(); -->
<!-- // }); -->



<!-- // function updateTotalCount() { -->
<!-- // 	var totalCount = $(".table tbody tr:visible").length; -->
<!-- // 	$(".mb-5").text("[총 " + totalCount + "건]"); -->
<!-- // } -->


<!-- </script> -->

<script>
// 수정된 값을 서버로 전송
$("#modifyButton").click(function() {
    // 가져온 값들을 변수에 저장
    var modifiedShipid = $("#shipid1").val();
    var modifiedWorkCode = $("#workcode1").val();
    var modifiedClientName = $("#clientcname1").val();
    var modifiedItemName = $("#itemname1").val();
    var modifiedShipsts = $("#shipsts1").val();
    var modifiedPocnt = $("#pocnt1").val();
    var modifiedShipdate1 = $("#shipdate11").val();
    var modifiedShipdate2 = $("#shipdate21").val();
    var modifiedMemberCode = $("#membercode1").val();

    // Ajax를 사용하여 서버로 수정된 값 전송
    $.ajax({
        type: "POST",
        url: "/sales/modifySH",
        data: {
            shipid1: modifiedShipid,
            shipdate11: modifiedShipdate1,
            workcode1: modifiedWorkCode,
            clientname1: modifiedClientName,
            itemname1: modifiedItemName,
            pocnt1: modifiedPocnt,
            shipsts1: modifiedShipsts,
            shipdate21: modifiedShipdate2,
            membercode1: modifiedMemberCode
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
	   
	   function openModifyModal(shipid, workcode, clientname, itemname, shipsts, pocnt, shipdate1, shipdate2, membercode) {
		   console.log("openModifyModal called with shipid:", shipid);
		   
		   // 가져온 값들을 모달에 설정
		   $("#shipid1").val(shipid);
    		$("#workcode1").val(workcode);
   			$("#clientname1").val(clientname);
    		$("#itemname1").val(itemname);
    		$("#shipsts1").val(shipsts);
    		$("#pocnt1").val(pocnt);
    		$("#shipdate11").val(shipdate1);
    		$("#shipdate21").val(shipdate2);
    		$("#membercode1").val(membercode);

		    // 모달 열기
		    $("#modifyModal").modal('show');
		    
		}
	   
	    $('#shipdate11').click(function(){
	        var today = new Date();
	        // 날짜를 YYYY-MM-DD 형식으로 포맷팅
	        var formattedDate = today.getFullYear() + '-' + ('0' + (today.getMonth() + 1)).slice(-2) + '-' + ('0' + today.getDate()).slice(-2);
	        $('#shipdate11').val(formattedDate);
	    });
	    
	    $('#shipdate21').click(function(){
	        var today = new Date();
	        // 날짜를 YYYY-MM-DD 형식으로 포맷팅
	        var formattedDate = today.getFullYear() + '-' + ('0' + (today.getMonth() + 1)).slice(-2) + '-' + ('0' + today.getDate()).slice(-2);
	        $('#shipdate21').val(formattedDate);
	    });
	    
	  // 완료일자 필드 초기화 시점에 호출되는 함수
	    function updateShipdateField() {
	        var shipstsValue = $("#shipsts1").val();

	        // 상태가 '완료'일 때만 완료일자 필드를 활성화
	        if (shipstsValue === '완료') {
	            $("#shipdate21").prop('readonly', false);
	        } else {
	            $("#shipdate21").prop('readonly', true);
	        }
	    }

	    // 모달 열릴 때 이벤트 처리
	    $('#modifyModal').on('show.bs.modal', function (event) {
	        // 모달 열릴 때 상태에 따라 완료일자 필드 업데이트
	        updateShipdateField();
	    });

	    // 상태가 변경될 때 이벤트 처리
	    $("#shipsts1").change(function() {
	        // 상태 변경 시 완료일자 필드 업데이트
	        updateShipdateField();
	    });
	    
 </script>
	   


<%@ include file="../include/footer.jsp"%>