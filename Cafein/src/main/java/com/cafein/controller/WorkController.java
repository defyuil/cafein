package com.cafein.controller;

import java.sql.Date;
import java.time.LocalDate;
import java.time.format.DateTimeFormatter;
import java.util.List;

import javax.inject.Inject;
import javax.servlet.http.HttpSession;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;

import com.cafein.domain.Criteria;
import com.cafein.domain.PageVO;
import com.cafein.domain.ShipVO;
import com.cafein.domain.WorkVO;
import com.cafein.service.ShipService;

@Controller
@RequestMapping(value = "/production/*")
public class WorkController {

	private static final Logger logger = LoggerFactory.getLogger(ShipController.class);

	@Inject
	private ShipService shService;
	
	// 작업지시 조회
	// http://localhost:8088/production/WKList
	@RequestMapping(value = "/WKList", method = RequestMethod.GET)
	public String AllWKListGET(Model model, WorkVO wvo, HttpSession session, Criteria cri) throws Exception {
		logger.debug("AllWKListGET() 실행");
		
		// SalesVO의 Criteria 설정
		wvo.setCri(cri);
		
		// 페이징 처리
		PageVO pageVO = new PageVO();
		pageVO.setCri(cri);
		pageVO.setTotalCount(shService.countWK(wvo));
		logger.debug("총 개수: " + pageVO.getTotalCount());
		
		List<WorkVO> WKList = shService.AllWKList(wvo);
		
		model.addAttribute("countWK",shService.countWK(wvo));
		model.addAttribute("WKList", WKList );
		model.addAttribute("pageVO", pageVO);
		model.addAttribute("pcList", shService.registPC()); 
		model.addAttribute("mcList", shService.registMC());
		model.addAttribute("membercode", session.getAttribute("membercode"));
		
		logger.debug("작업지시 리스트 출력!");
		
		return "/production/WKList";
	}
	
	
	// 작업지시 등록 - POST
	// http://localhost:8088/production/WKList
	@RequestMapping(value = "/registWK", method = RequestMethod.POST)
	public String registWK(WorkVO wvo, ShipVO svo, HttpSession session, Model model,
			@RequestParam(value = "workdate1") String workdate1) 
										throws Exception {
		
		logger.debug("registWK() 호출 ");                                 
		logger.debug(" wvo : " + wvo);  
		wvo.setWorkcode(makeWKcode(wvo));
		wvo.setWorkdate1(Date.valueOf(workdate1));
		
		model.addAttribute("membercode", session.getAttribute("membercode"));
		
		shService.registWK(wvo);                                                      
		logger.debug(" 작업지시 등록 완료! ");     
                                     	
	                                                                                 
		logger.debug("/production/registWK 이동");                                          
		return "redirect:/production/WKList";                                             
	}
	
	// 출하 코드 생성 메서드
		public String makeSHcode(ShipVO svo) throws Exception {
		    // DB에서 전체 작업 수 조회
		    int count = shService.shCount(svo);

		    String codePrefix = "SH";
		    DateTimeFormatter dateFormat = DateTimeFormatter.ofPattern("yyMMdd");
		    String datePart = LocalDate.now().format(dateFormat);
		    String countPart = String.format("%04d", count + 1); // 4자리 숫자로 포맷팅

		    // 최종 코드 생성
		    return codePrefix + datePart + countPart;
		}

	// 작업 지시 코드 생성 메서드
	public String makeWKcode(WorkVO wvo) throws Exception {
	    // DB에서 전체 작업 수 조회
	    int count = shService.wkCount(wvo);

	    // 작업 코드 형식 설정
	    String codePrefix = "WK";
	    DateTimeFormatter dateFormat = DateTimeFormatter.ofPattern("yyMMdd");
	    String datePart = LocalDate.now().format(dateFormat);
	    String countPart = String.format("%04d", count + 1); // 4자리 숫자로 포맷팅

	    // 최종 코드 생성
	    return codePrefix + datePart + countPart;
	}
	
	// 작업지시 수정 - POST
	// http://localhost:8088/production/WKList
	@RequestMapping(value = "/modifyWK", method = RequestMethod.POST)
	public String modifyPOST(WorkVO wvo, ShipVO svo, HttpSession session, Model model) throws Exception {
		logger.debug(" /modify form -> modifyPOST()");
		logger.debug(" 수정할 정보 " + wvo);

		// 출하 등록 조건 검사
	    if ("진행".equals(wvo.getWorksts())) {
	        svo.setShipdate1(wvo.getWorkdate1());
	        svo.setShipcode(makeSHcode(svo));
	        svo.setWorkcode(wvo.getWorkcode());
	        svo.setClientname(wvo.getClientname());
	        svo.setItemname(wvo.getItemname());
	        svo.setShipsts(wvo.getWorksts());
	        svo.setPocnt(wvo.getPocnt());
	        svo.setShipdate2(wvo.getWorkdate2());
	        svo.setMembercode(wvo.getMembercode());
	        shService.insertShipList(svo);
	        model.addAttribute("membercode", session.getAttribute("membercode")); 
	    }

		// 서비스 - 정보수정 동작
		int result = shService.WKModify(wvo);
		logger.debug("result", result);
		return "redirect:/production/WKList";
	}
	
	// 작업지시 삭제 - POST
		@RequestMapping(value = "/WKDelete", method = RequestMethod.POST)
		public String WKDelete(WorkVO wvo, HttpSession session, Model model) throws Exception {
			logger.debug("WKdelete() 호출");
			
			// 서비스
			shService.WKDelete(wvo);
			model.addAttribute("membercode", session.getAttribute("membercode")); 
			
			return "redirect:/production/WKList";
		}
	
}