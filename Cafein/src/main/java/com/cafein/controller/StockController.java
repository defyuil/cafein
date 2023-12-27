package com.cafein.controller;

import java.util.List;

import javax.inject.Inject;
import javax.servlet.http.HttpSession;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import com.cafein.domain.Criteria;
import com.cafein.domain.PageVO;
import com.cafein.domain.QualityVO;
import com.cafein.service.StockService;

@Controller
@RequestMapping(value = "/material/*")
public class StockController {
	
	private static final Logger logger = LoggerFactory.getLogger(StockController.class);
	
	@Inject
	private StockService sService;
	
	// 재고 관리 통합 페이지 (자재 / 생산 + 반품)
	// http://localhost:8088/material/stock
	@GetMapping(value = "/stock")
	public void allStockGET(HttpSession session) {
		
	}
	
	// http://localhost:8088/material/productStockList
	// 재고 목록 조회 (생산 [포장] + 반품)
	@RequestMapping(value = "/productStockList", method = RequestMethod.GET)
	public void productStockListGET(Model model, HttpSession session, QualityVO vo, Criteria cri) throws Exception{
		session.setAttribute("membercode", "admin"); // 정상 처리 시 세션에 저장된 값 사용
		
		vo.setCri(cri);
		List<QualityVO> resultList = sService.stockList(vo); // 생산 + 반품 재고 목록
		List<QualityVO> storageList = sService.storageList(); // 생산 + 반품 창고 목록
		
		model.addAttribute("list", resultList);
		model.addAttribute("slist", storageList);
		
		PageVO pageVO = new PageVO();
		pageVO.setCri(cri);
		pageVO.setTotalCount(sService.stockListCount(vo));
		
		model.addAttribute("pageVO", pageVO);
	}
	
	// 재고 목록 조회 검색 버튼 (자재)
	@GetMapping(value = "/materialStockList")
	public void materialStockListGET(Model model, HttpSession session, QualityVO vo, Criteria cri) throws Exception{
		session.setAttribute("membercode", "admin"); // 정상 처리 시 세션에 저장된 값 사용 (없어서 추가해놓은 부분 / 삭제 예정)
		
		vo.setCri(cri);
		List<QualityVO> resultList = sService.materialStockList(vo); // 자재 재고 목록
		List<QualityVO> rawStorageList = sService.rawmaterialStorageList(); // 원자재 창고 목록
		List<QualityVO> subStorageList = sService.submaterialStorageList(); // 부자재 창고 목록
		logger.debug(" rawStorageList : " + rawStorageList);
		logger.debug(" subStorageList : " + subStorageList);
		
		model.addAttribute("list", resultList);
		model.addAttribute("rlist", rawStorageList);
		model.addAttribute("slist", subStorageList);
		
		PageVO pageVO = new PageVO();
		pageVO.setCri(cri);
		pageVO.setTotalCount(sService.materialStockListCount(vo));
		
		model.addAttribute("pageVO", pageVO);
	}

	// 재고 입력 (생산 [포장] + 반품)
	@RequestMapping(value = "/newStock", method = RequestMethod.POST)
	public String newStockPOST(QualityVO vo, RedirectAttributes rttr, HttpSession session) throws Exception{
		int qualityid = vo.getQualityid();
		logger.debug(" qualityid : " + qualityid);
		Integer duResult = sService.duplicateStock(qualityid);
		if(duResult != null) {
			logger.debug(" 이미 재고 정보가 등록된 검수 내역입니다. ");
			rttr.addFlashAttribute("result", "duplicateStock");
			return "redirect:/quality/qualities";
		}else {
		
		String workerbycode = (String) session.getAttribute("membercode"); // 세션에 있는 사용자코드 받아오기 (수정 예정)
		
		vo.setWorkerbycode(workerbycode);
		vo.setLotnumber(sService.roastedbeanLotNum(vo)); // 생산 LOT 번호 조회
		
		int result = sService.newStock(vo);
		if(result == 0) {
			rttr.addFlashAttribute("result", "STOCKNO");
			logger.debug(" 재고 등록 실패! ");
			return "redirect:/quality/qualities";
		}else {
			rttr.addFlashAttribute("result", "STOCKYES");
			logger.debug(" 재고 등록 성공! ");
		}
		// 재고 등록 여부 업데이트
		sService.registerStockY(vo);
		return "redirect:/material/stock";
		}
	}
	
	// 재고 입력 (자재)
	@RequestMapping(value = "/newMaterialStock", method = RequestMethod.POST)
	public String newMaterialStockPOST(QualityVO vo, RedirectAttributes rttr, HttpSession session) throws Exception{
		int qualityid = vo.getQualityid();
		logger.debug(" qualityid : " + qualityid);
		Integer duResult = sService.duplicateStock(qualityid);
		if(duResult != null) {
			logger.debug(" 이미 재고 정보가 등록된 검수 내역입니다. ");
			rttr.addFlashAttribute("result", "duplicateStock");
			return "redirect:/quality/qualities";
		}else {
			
		String workerbycode = (String) session.getAttribute("membercode"); // 세션에 있는 사용자코드 받아오기 (수정 예정)
		
		vo.setWorkerbycode(workerbycode);
		vo.setLotnumber(sService.receiveLotNum(vo)); // 입고 LOT 번호 조회
		
		int result = sService.newStock(vo);
		if(result == 0) {
			rttr.addFlashAttribute("result", "STOCKNO");
			logger.debug(" 재고 등록 실패! ");
			return "redirect:/quality/qualities";
		}else {
			rttr.addFlashAttribute("result", "STOCKYES");
			logger.debug(" 재고 등록 성공! ");
		}
		// 재고 등록 여부 업데이트
		sService.registerStockY(vo);
		return "redirect:/material/stock";
		}
	}
	
	// 재고량 변경 (생산 [포장] + 반품)
	@RequestMapping(value = "/updateStockQuantity", method = RequestMethod.POST)
	public String updateStockQuantityPOST(QualityVO vo, RedirectAttributes rttr, HttpSession session) throws Exception{
		
		String workerbycode = (String) session.getAttribute("membercode"); // 세션에 있는 사용자코드 받아오기 (수정 예정)
		
		vo.setWorkerbycode(workerbycode);
		logger.debug(" vo : " + vo);
		int result = sService.stockQuantity(vo);
		
		if(result == 0) {
			rttr.addFlashAttribute("result", "STOCKUPNO");
			logger.debug(" 재고량 변경 실패! ");
		}else {
			rttr.addFlashAttribute("result", "STOCKUPYES");
			logger.debug(" 재고량 변경 성공! ");			
		}
		
		return "redirect:/material/stock";
	}
	
	// 창고 변경
	@RequestMapping(value = "/updateStockStorage", method = RequestMethod.POST)
	public String updateStockStoragePOST(QualityVO vo, RedirectAttributes rttr, HttpSession session) throws Exception{
		
		String workerbycode = (String) session.getAttribute("membercode"); // 세션에 있는 사용자코드 받아오기 (수정 예정)
		
		vo.setWorkerbycode(workerbycode);
		logger.debug(" vo : " + vo);
		int result = sService.stockStorage(vo);
		
		if(result == 0) {
			rttr.addFlashAttribute("result", "STOCKSUPNO");
			logger.debug(" 창고 변경 실패! ");
		}else {
			rttr.addFlashAttribute("result", "STOCKSUPYES");
			logger.debug(" 창고 변경 성공! ");			
		}
		
		return "redirect:/material/stock";
	}
}
