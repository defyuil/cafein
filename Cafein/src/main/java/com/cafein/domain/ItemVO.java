package com.cafein.domain;

import lombok.Data;

@Data
public class ItemVO {

	private int itemid;
	private String itemcode;
	private String itemtype;
	private String itemname;
	private String clientcode;
	private String origin;
	private int itemweight;
	private int itemprice;
	private String available;
	
}
