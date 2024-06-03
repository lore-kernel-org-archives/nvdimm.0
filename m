Received: from esa3.fujitsucc.c3s2.iphmx.com (esa3.fujitsucc.c3s2.iphmx.com [68.232.151.212])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5352010E6
	for <nvdimm@lists.linux.dev>; Mon,  3 Jun 2024 01:12:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=68.232.151.212
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717377165; cv=fail; b=LvzaxDS7KsYgV66kZhLbGma2EBIpVN3EfeufMl6Hab2viORP5cXnVcEGdqwtUlPVG12V3uM8r+17PEHWhBPmoJEzAoEPGbqlCQOVOwpzuBu6HM1QxyVXYRdMmvynEhZ8f5k3aI40WXdK3k7dPHkD+U+wV/jVAYgUPoaKBU5gkAw=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717377165; c=relaxed/simple;
	bh=RubGxYdohDX71SphAa/YmW7ET1o4TXPeX8/JVrIHpB8=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=TqKK60TZrVa8qwe5Hyc4byFVQfAyWOaDo/gkAzxLYrdx2KLDpKWLr5LcyawHO8Ogx0eNpUtllUowgOJD0u9my/t0HID7gVqYhIgyhQrdYqjApjYrzt/C2/Jgo0oGYV3YGdF8B1FJN4Bv8PgPksGTrzGJMWsRSMyiNGvLce/owe8=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fujitsu.com; spf=pass smtp.mailfrom=fujitsu.com; dkim=pass (2048-bit key) header.d=fujitsu.com header.i=@fujitsu.com header.b=duvEuTwo; arc=fail smtp.client-ip=68.232.151.212
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fujitsu.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fujitsu.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fujitsu.com header.i=@fujitsu.com header.b="duvEuTwo"
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=fujitsu.com; i=@fujitsu.com; q=dns/txt; s=fj1;
  t=1717377162; x=1748913162;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=RubGxYdohDX71SphAa/YmW7ET1o4TXPeX8/JVrIHpB8=;
  b=duvEuTwopTlXp+Xfut33ynlg9ZCp2hd20X2/xKvynJz1IWNjNYDeIzRG
   U20H+pOvfN1Q2VUqfMsG7K5LP8UjoiznKC/N4OR0sAdC/oE4rPcew66rh
   ds3VM8cB28f63ks/cFFa2YoL4daoh2NU+p4JFMfEwEVatpumFsq+LTpeR
   WG96Q1G4loCloiayKP3nzvcKLIE6PIQr8ZGbG+q8TRDOC9waZI9iPX/Zf
   maJoc3jkLRsHYA8FETGnO+39/Wes+k+dxDHDEWaFx5DdecfRgtHJKSb+5
   wX5AV3jPQT5ZrFmGMQc/aMR8xuXtHH+0DS4lVe/TurtirsgGlLpDrT3K1
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,11091"; a="32300148"
X-IronPort-AV: E=Sophos;i="6.08,210,1712588400"; 
   d="scan'208";a="32300148"
Received: from mail-japanwestazlp17011004.outbound.protection.outlook.com (HELO OS0P286CU011.outbound.protection.outlook.com) ([40.93.130.4])
  by ob1.fujitsucc.c3s2.iphmx.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Jun 2024 10:12:31 +0900
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Eljd1GuMe6Bu9sf7coIb27l6tkHhrA6OfW6xRizj7VninPVHMAYt4G4cIwj9R+WwOD8kq7QnrzWWH347/sVMVPAw9WWIvNjk5kpWB14rYquBanKBm5owfNIFZNkqnSDDDXj0X+6OzsOyxlv3PT7mj4givAeWhzWqNqSImAFj7DDxmiZeKvTZdl4xMFCBoP/Rmt8efTCpnEsyYUrHdBJ9QKzqu0ir5cAynhp8WtyokQ6me2GP4PqAfqge7xmlqzoPGYH8D+09B1D0McY/uasNQUBQYHb6jWWxtLEYZ6mnk8IDztoqgr+mQOF7EiQ+E8Bx41PIE0cnBoBD2T3LIQnECg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=RubGxYdohDX71SphAa/YmW7ET1o4TXPeX8/JVrIHpB8=;
 b=Hp8BoBsZK16ClIV4SbruUx1CMgzjEnQ0KwDFtUu8UT18zfY/C0X3hj5cevKPURtGTPtq0POFA+Qa8eC+c02Xtf0lIyzBl21txtY1K55lnqRBtFcLGxkZ6w64gtCFTR1897uqZ95XFImODXoaJpqjttcjDbKbiahrHV2NgPQyAEQyEQE6g98SMSepMlu6zdmSBB9A9aajCN47lwhUClbbgYOEryDSU4hV6ilEVp44ktPHfUULzR+hDyzfZRpO+lvNvGu9XS+vmkEA0KAzV7/BT96vxibZEbu7c9/H8PY2PKwpgV7ATJeRvl2y93m6SJZFxkUgZ7EzuEBXItNQqMCkFg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fujitsu.com; dmarc=pass action=none header.from=fujitsu.com;
 dkim=pass header.d=fujitsu.com; arc=none
Received: from TY1PR01MB1562.jpnprd01.prod.outlook.com (2603:1096:403:6::12)
 by TYWPR01MB10080.jpnprd01.prod.outlook.com (2603:1096:400:1e1::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7633.23; Mon, 3 Jun
 2024 01:12:28 +0000
Received: from TY1PR01MB1562.jpnprd01.prod.outlook.com
 ([fe80::d9ba:425a:7044:6377]) by TY1PR01MB1562.jpnprd01.prod.outlook.com
 ([fe80::d9ba:425a:7044:6377%3]) with mapi id 15.20.7633.021; Mon, 3 Jun 2024
 01:12:28 +0000
From: "Zhijian Li (Fujitsu)" <lizhijian@fujitsu.com>
To: Alison Schofield <alison.schofield@intel.com>
CC: "nvdimm@lists.linux.dev" <nvdimm@lists.linux.dev>,
	"linux-cxl@vger.kernel.org" <linux-cxl@vger.kernel.org>, Fan Ni
	<fan.ni@samsung.com>
Subject: Re: [ndctl PATCH v2 1/2] daxctl: Fix create-device parameters parsing
Thread-Topic: [ndctl PATCH v2 1/2] daxctl: Fix create-device parameters
 parsing
Thread-Index: AQHasyP8J0Rv9wrXS0ChjNPGYxooZrGx3dmAgANiEAA=
Date: Mon, 3 Jun 2024 01:12:28 +0000
Message-ID: <91b5cf68-b69c-4eb8-a91e-8577e8cc4fd0@fujitsu.com>
References: <20240531062959.881772-1-lizhijian@fujitsu.com>
 <ZlpB+SYykp2gpAcS@aschofie-mobl2>
In-Reply-To: <ZlpB+SYykp2gpAcS@aschofie-mobl2>
Accept-Language: en-US, zh-CN
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Mozilla Thunderbird
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=fujitsu.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: TY1PR01MB1562:EE_|TYWPR01MB10080:EE_
x-ms-office365-filtering-correlation-id: b55de911-5c95-43a3-c724-08dc836a3c7b
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam:
 BCL:0;ARA:13230031|1800799015|366007|376005|1580799018|38070700009;
x-microsoft-antispam-message-info:
 =?utf-8?B?aThHNmlCWmI1NWhaczAwdnVRZ3kxNldVUy9BZG9MYlNvc2hTWXFWa1RzTGtl?=
 =?utf-8?B?eStjeU1XdXRQSkVoWVMrVzhUWlBxWEllTk9YRVNJeEs2UzZVcWgxdnVTWFVU?=
 =?utf-8?B?TUJwNjZ5cXJOaWtlbm9PVXZVMm5vNitmWnkvYWxzcnpBYmY0QWVTMHlLN0oy?=
 =?utf-8?B?c2cwckNsVHFEbHMxMXFZQTFUbzQ3ZmRxc2pYRjRBOFVUczY4T1V4ODZIR2JW?=
 =?utf-8?B?TnNOcnVublRDeHpvYnR0bnNyYmNYd1BHM1ZoK2tLT3FNZlBzZ2F6TU5Vcm1J?=
 =?utf-8?B?eHVzOEZyaEY3YURTQVBvSkRUbFVWNHBob3NseDVXbGxkVmw4N2UrZmJ2bllV?=
 =?utf-8?B?NDBTRDBzWW9VaFlpN1hwUGdmOFpTdEhqcStlNVdaSUIrMlZ2SUszRXZxQklL?=
 =?utf-8?B?bUEwR1ROK0RxcUtBV1lHWUxDUnhyYkxicUhOTHNIRVJSOUNhYlp6Q2N1Vk5L?=
 =?utf-8?B?Rk9CK2JNQ1psclZ5cldVVTFtYkFDSmkrOWhwTzlJMWhYU0wwemhVT3pyTUhX?=
 =?utf-8?B?b3BkeENGRzZ2bDNxbEhRZ0xHa3luZHVvODFSSnFITkdZN0hFTlNzdHYvQ1dJ?=
 =?utf-8?B?Q20vQTVTdGNzakJ5WFZvM2hraWY2VVpTazhvSXhjMW9KRlI4TUlYQm81eVp4?=
 =?utf-8?B?cS9MYlZRWE45bVRBU3NGYytxc0RKOEw5ekN1clRXZCs2SXlYSW1KR2NzTnN3?=
 =?utf-8?B?a0JreVVSMUt1OWwzdkxTUnY5K052OERBWWpkbno5bGJuUEJGa21rb2pPcUZG?=
 =?utf-8?B?V2F2dkoxN29Kc211NUc1NU96dVJzYTMrUGg3Y0IxUnJKKzZPei9lNW05em1G?=
 =?utf-8?B?MDZuRWtzK0x2MEZENStpOEs1TDRCaWVpZG9RWmppN0dGTWtYZ3QxUmhFbVZS?=
 =?utf-8?B?SE1ORFBWU0oybWFuaCtXNnVUNUYxQVE2aGNsTGFjalJUTUtkTkxJYnIyM3BJ?=
 =?utf-8?B?Uk9LMEcrY0JRSU45eXhvL1MvbmxObnhDY2czWmZqVTA3OEpyU2RuK29yY3Np?=
 =?utf-8?B?b2EvTzQ2WFFndG4xSCtlSlM2amNSdkcvV2VvRFB1OHVUTkM5QmhyMTlTMUxO?=
 =?utf-8?B?SjFWWDJLQ2E4cC9qeWwwb1N2VUo4TlBTTzFQQnl0RkhiRDVxbDRkMGRRd2Zz?=
 =?utf-8?B?bXh6QkE4aFhNK3pHZXYzSTJVWXFCQkRha3NwaWFuQnNmeG9uU1grMkdDYTBi?=
 =?utf-8?B?WFdZemhERU16alRVd0haNmI3NlVJdi9xTVBSZWN6NDVlSzZYUEowSkwzbDY0?=
 =?utf-8?B?Y2tzSHEvMDlGWlRjWjlDZzQ4SWowVzQyK080NjdTMmt4amdYSmlCNUYxV0pI?=
 =?utf-8?B?NzRBczU5WDZFTUd5UDlJWnJxclpaNVdYUzNHZms2ek0vT0djRzF3MTJoMDRG?=
 =?utf-8?B?YkVKVGhTblNSVzg0L3U3RDRRT0RtWVdsUDhIS3prVjJTSS9PSkJxT2VLakZQ?=
 =?utf-8?B?elFlQWlKOS9aaDhnZVVXbHBZWXZUSlpEK25GaTl6eElSZDExZDlNR0JlM3RR?=
 =?utf-8?B?bzNTa1pzeUVJWEkyenJwZlJPZjQrdk9tQmVsS2VVTjVCV1JSVC9WekdYbDhS?=
 =?utf-8?B?OFcvSXZVNFVqeUwva1VlOFdiUHJleDBUSUd3QUdRYWlBaC8yUWxWdnVpdkdT?=
 =?utf-8?B?R0VLeXBLUVVBakk3UnNSeDVkc3EydFVJOFErbTk2NVRrWVRpdXZHaGJ1NnFO?=
 =?utf-8?B?elRhV2F0UDUvQjNvem1QMWNVVkJOQ2sxTDFVTjFEZ1dTUDJRekxMaU10czdN?=
 =?utf-8?Q?L/cNwB43MZRga9Hq+n80iiyRIy2D+c/L4xTiiHL?=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:TY1PR01MB1562.jpnprd01.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(1800799015)(366007)(376005)(1580799018)(38070700009);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?utf-8?B?QUdjaTB6SUlvSk1TVXlFelNmUzN4YXRsNDdac1lWVlphc1RHWThWMTQ0ZkV2?=
 =?utf-8?B?b0YxbmcrZDZ1amJkYzJzaVg3b0V1eUhKbkc2bUMyZ1JadXhWbG5WUnJlemVr?=
 =?utf-8?B?cWhCM2w4VUR5OGpOSlUwRmJpQlhROEdSMVVCSHZlNnBYdk9jL0NydVl3TzJU?=
 =?utf-8?B?cmJyWlEzdk9FOGVhaUtGUzF3V1pPTFBCc2ErWFRvTHlYbk9uMEdUYkpTUGk0?=
 =?utf-8?B?NUFONDlOWTBGOEt5MTJwSVRwaXZKVndhd0VsOW5UNGxaaysxTmZXZy9JaDFw?=
 =?utf-8?B?OHdmeE9jbXNsSFFUK1A0ZitDSXhacjI1aUZFZVJ2UkRobHJKdFBEdXRMdmlO?=
 =?utf-8?B?Mk1wb2swOWJXWmt1SDljc3BIelJxVFlQemxOMUIrYUNTMjZ1VndhaUF2b3V1?=
 =?utf-8?B?WXJ0N2FHK09wdlU0aERnanExVlI2T1hPMVo3czZJaDVEM2svR2JENW5UYmJz?=
 =?utf-8?B?US9mSGROZ0RNc29HMEFsVVNTSXhKd1ZWTmJydExYcytmWXk5OUVLT2YzWTRi?=
 =?utf-8?B?d3dzQkNoTWkzb3NrQmNiUkJpRnJTb3ZKSFFwaXNFdHhzd0d1UWJCQlNTRXdw?=
 =?utf-8?B?TDRrUGtPNyt3ZDFXKzBxRVVaVmRuNklyZlJ3em5qVVYyV3p3cWNFeDRsTS9u?=
 =?utf-8?B?Vlh2eDRvSmZOektzazVtWDhXelFXSm91TUVBK2ZHNVRnWUtQN3J0QlNqOGlD?=
 =?utf-8?B?cUJmRS9jQzU2d2NlaU8yd1EyUFp6bVFaanQ0Nzk2RTB1aHRxR3NBQk9VK0lU?=
 =?utf-8?B?TU9OeGZMZ0ovTzJvYnZmK2xiYm4xbE94aTM3ZDFqRXFSWFZzWWQ3c1did2RE?=
 =?utf-8?B?bUMyOEZGVDh5OWlBSVE0emt1NjJ1VFVrblkxR2JHU2tLVlJHMDE5ZjFFZXhO?=
 =?utf-8?B?d0tNWnpoRFFQUE1oQk9LZU9xZml0ODd0dUVOS1BZZ1Zid1JMNUh1VWxmcjAz?=
 =?utf-8?B?ZEdNUmhXdGJzM1pNMEIwZDVXaDA5SzM0ck50M0lUbDBQVmd6RDgrSjRsUm93?=
 =?utf-8?B?MjY5V0E0VHV0NHhaZC95S1BFYlpGTEpSemRkUVZvVWJrVFFXc201K0lTWnMv?=
 =?utf-8?B?U0E0ZmJaMzY3eDB0ZVVCUVYwdGxJUnlEU2lZMlBRUXd2NUk5OXpYT0ZzbUE0?=
 =?utf-8?B?bHR0SkFGZXo0SloyN3pQd0phL21jUnFUWnF0VldITUdOaVdXV2puOGgrVklr?=
 =?utf-8?B?c21yaWM2MVVkZExTaUFsbDVCWTkzb29WdVF0YTdEOXNTMU5uUUU5S05VNDVo?=
 =?utf-8?B?ZlViNHJSVkRraVFMSld2ZzVwYkE1NDlFenFiWTh2LzNsWkM3WlpCMlg5cUov?=
 =?utf-8?B?NG0zWVp3Ry92VmlVWjVOYU1WaWRjSGhmSmVvSTVjY3NlbGVmZEVsbkF1cm5R?=
 =?utf-8?B?Qk1qc1JiRW5sMFdFeVpsMUhadlZqZ1JyOHlmZzBHUmZkaHlFNDhJR0wyM3U0?=
 =?utf-8?B?dmxGbzRHdXBadC83UVBpdkthcUhvZldIOURxdGhwazJoU0Flb3QxMDdUY0U5?=
 =?utf-8?B?S0JuOTNMRXFld1hPamRVdkNZdkl5blNPaGFUbzBOOW0yZjhPdU5EVzVsUlN5?=
 =?utf-8?B?Um9CWGRKanVtOTZOYUFBZ0Q3MjVwbnJZSmZlbDRMcWRrQTJtWG1FOTBtT0pj?=
 =?utf-8?B?cWN3S2k4anJ4L25Za21Za05ZZ0JsZndsMGN6Y0xkRVBhajNNY2g2YWRQNzkx?=
 =?utf-8?B?dEtxR1NVeENUVlpQSlZ2QWFhWnphQndUeG5FTXlqeTF0Tm1meEpQTnBpNS9J?=
 =?utf-8?B?MFVRZEtuVGdURCtvbVc5WTc3Tkh1aGNIczN1UmREM0hxZmswM09YUjdJN040?=
 =?utf-8?B?azcvei9uUWtWMHZEajZVUThzUGRXVHBhWkJpOTRWZlNlMmxGMWZLVUdWWktS?=
 =?utf-8?B?MlNIcncvL2F2TkxHWXlGeVg0YXd3cUxYRFVMREE5WWtGTWpGMlZkdGRJT1I0?=
 =?utf-8?B?UDUweGRIcUs4Ym5ySSs1cG85SjlxWmt0bXZra3VJZVNDOVRwdVFtM2ExdmdT?=
 =?utf-8?B?Q3FyUVdTTW9hYXhNTmc5emxCSEwvSnF3V0VEMGRURlAvcmMvT1p0emtnQ3Fu?=
 =?utf-8?B?VkQ1cHRCMHJMdkZ4eTV1OG5mVGY0Wi9NemQvNGhEM24xWUtRV3hzcjl0NFpY?=
 =?utf-8?B?QkQzUTRVYXY5Wjhvb0ROaGFuTmxSWE5mUUZxckZvYko0a2RtK2h3OTU2d3Vs?=
 =?utf-8?B?S2c9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <CAFB97372D60B74487E06909C6302D5D@jpnprd01.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	B6em++W9/bmGMa3nE8IYQZPAO7e02lsTmlGBBG0A7MWGLONYHdJjCK7rk51RPPGDoFilaKrV7sYQmu5rhATbZrV/eGNTz3C+fj4cokF6Y+tGOJxHb01KByG2vaOVa8ocWq2rJKM/vWAF5GJA8hE3hTt+cb0zwqZlsO0Be1V6EUJPs6R3jiwdxUs2vewsQiml8XvCNTP50VOhzI7CNvabvKPq1bpOP8c44/+YfyUuhbU3ARCI7jeCVseeQzw8STXQItflc28R7+iLJHuF9alt5vcCCEJoU1kGDKji7Y6ZCqKxzracY3hCyt0RCqW9wL6UMbAUWN3X9GzzHIrKT2B3yUut27avZknLvrC2KvuQ7BA2DCYSMWxpZDHLTR0mpF09lZ5KdQnCpzmAjmC+PPo/KvfW8Alh5HAbYRlupD7RX7eSCRs040SNRoIXHE56hKLarnG3eQNlHknwnytHhfKiaWnfJ2RSVkqpReAF+FgXOHENyuuW3aqEYv4WqQRPws8bEZv97Cz59N/rpr7/RUQub62BzEyAeGbOqIpVS6agWAMNCp6O/JMeDu34Ndcq1HzUa9GTCG4dmcYNnB++Jh6GmRLfq9J5O8KInRcrK0Li1Y2els4PQZzpQGnrcFdBICwA
X-OriginatorOrg: fujitsu.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: TY1PR01MB1562.jpnprd01.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b55de911-5c95-43a3-c724-08dc836a3c7b
X-MS-Exchange-CrossTenant-originalarrivaltime: 03 Jun 2024 01:12:28.4093
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a19f121d-81e1-4858-a9d8-736e267fd4c7
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 7FmPiAk9mpENFWaJzoi771G+RDIiUx3t6hy7dqPgm/kUovy4t1Z+rGT14FadwBSQHzZYnZHYNYx1r0NguzjFUg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: TYWPR01MB10080

DQoNCk9uIDAxLzA2LzIwMjQgMDU6MzIsIEFsaXNvbiBTY2hvZmllbGQgd3JvdGU6DQo+IE9uIEZy
aSwgTWF5IDMxLCAyMDI0IGF0IDAyOjI5OjU4UE0gKzA4MDAsIExpIFpoaWppYW4gd3JvdGU6DQo+
PiBQcmV2aW91c2x5LCB0aGUgZXh0cmEgcGFyYW1ldGVycyB3aWxsIGJlIGlnbm9yZWQgcXVpZXRs
eSwgd2hpY2ggaXMgYSBiaXQNCj4+IHdlaXJkIGFuZCBjb25mdXNpbmcuDQo+IA0KPiBJdCdzIGp1
c3Qgd3JvbmcuIFRoZXJlIGlzIGNvZGUgdG8gY2F0Y2ggZXh0cmEgcGFyYW1zLCBidXQgaXQncyBi
ZWluZw0KPiBza2lwcGVkIGJlY2F1c2Ugb2YgdGhlIGluZGV4IHNldHRpbmcgdGhhdCB5b3UgbWVu
dGlvbiBiZWxvdy4gU3VnZ2VzdA0KPiByZWZlcmVuY2luZyB0aGUgaW5jb3JyZWN0IGluZGV4IGlz
IGNhdXNpbmcgdGhlIGV4dHJhIHBhcmFtcyB0byBiZQ0KPiBpZ25vcmVkLg0KPiANCj4gU3VnZ2Vz
dCBjb21taXQgbXNnIG9mOg0KPiBkYXhjdGw6IEZhaWwgY3JlYXRlLWRldmljZSBpZiBleHRyYSBw
YXJhbWV0ZXJzIGFyZSBwcmVzZW50DQoNClNvdW5kcyBnb29kIHRvIG1lLA0KDQpXaWxsIGZpeCBp
dCBhbmQgb3RoZXIgYmVsb3cgc3VnZ2VzdGlvbnMuDQoNCg0KVGhhbmtzDQpaaGlqaWFuDQoNCg0K
PiANCj4gDQo+PiAkIGRheGN0bCBjcmVhdGUtZGV2aWNlIHJlZ2lvbjANCj4+IFsNCj4+ICAgIHsN
Cj4+ICAgICAgImNoYXJkZXYiOiJkYXgwLjEiLA0KPj4gICAgICAic2l6ZSI6MjY4NDM1NDU2LA0K
Pj4gICAgICAidGFyZ2V0X25vZGUiOjEsDQo+PiAgICAgICJhbGlnbiI6MjA5NzE1MiwNCj4+ICAg
ICAgIm1vZGUiOiJkZXZkYXgiDQo+PiAgICB9DQo+PiBdDQo+PiBjcmVhdGVkIDEgZGV2aWNlDQo+
Pg0KPj4gd2hlcmUgYWJvdmUgdXNlciB3b3VsZCB3YW50IHRvIHNwZWNpZnkgJy1yIHJlZ2lvbjAn
Lg0KPj4NCj4+IENoZWNrIGV4dHJhIHBhcmFtZXRlcnMgc3RhcnRpbmcgZnJvbSBpbmRleCAwIHRv
IGVuc3VyZSBubyBleHRyYSBwYXJhbWV0ZXJzDQo+PiBhcmUgc3BlY2lmaWVkIGZvciBjcmVhdGUt
ZGV2aWNlLg0KPj4NCj4+IENjOiBGYW4gTmkgPGZhbi5uaUBzYW1zdW5nLmNvbT4NCj4+IFNpZ25l
ZC1vZmYtYnk6IExpIFpoaWppYW4gPGxpemhpamlhbkBmdWppdHN1LmNvbT4NCj4+IC0tLQ0KPj4g
VjI6DQo+PiBSZW1vdmUgdGhlIGV4dGVybmFsIGxpbmtbMF0gaW4gY2FzZSBpdCBnZXQgZGlzYXBw
ZWFyZWQgaW4gdGhlIGZ1dHVyZS4NCj4+IFswXSBodHRwczovL2dpdGh1Yi5jb20vbW9raW5nL21v
a2luZy5naXRodWIuaW8vd2lraS9jeGwlRTIlODAlOTB0ZXN0JUUyJTgwJTkwdG9vbDotQS10b29s
LXRvLWVhc2UtQ1hMLXRlc3Qtd2l0aC1RRU1VLXNldHVwJUUyJTgwJTkwJUUyJTgwJTkwVXNpbmct
RENELXRlc3QtYXMtYW4tZXhhbXBsZSNjb252ZXJ0LWRjZC1tZW1vcnktdG8tc3lzdGVtLXJhbQ0K
Pj4gLS0tDQo+PiAgIGRheGN0bC9kZXZpY2UuYyB8IDUgKysrLS0NCj4+ICAgMSBmaWxlIGNoYW5n
ZWQsIDMgaW5zZXJ0aW9ucygrKSwgMiBkZWxldGlvbnMoLSkNCj4+DQo+PiBkaWZmIC0tZ2l0IGEv
ZGF4Y3RsL2RldmljZS5jIGIvZGF4Y3RsL2RldmljZS5jDQo+PiBpbmRleCA4MzkxMzQzMDE0MDku
LmZmYWJkNmNmNTcwNyAxMDA2NDQNCj4+IC0tLSBhL2RheGN0bC9kZXZpY2UuYw0KPj4gKysrIGIv
ZGF4Y3RsL2RldmljZS5jDQo+PiBAQCAtMzYzLDcgKzM2Myw4IEBAIHN0YXRpYyBjb25zdCBjaGFy
ICpwYXJzZV9kZXZpY2Vfb3B0aW9ucyhpbnQgYXJnYywgY29uc3QgY2hhciAqKmFyZ3YsDQo+PiAg
IAkJTlVMTA0KPj4gICAJfTsNCj4+ICAgCXVuc2lnbmVkIGxvbmcgbG9uZyB1bml0cyA9IDE7DQo+
PiAtCWludCBpLCByYyA9IDA7DQo+PiArCWludCByYyA9IDA7DQo+PiArCWludCBpID0gYWN0aW9u
ID09IEFDVElPTl9DUkVBVEUgPyAwIDogMTsNCj4gDQo+IFRoaXMgY29uZnVzZXMgbWUgYmVjYXVz
ZSBhdCB0aGlzIHBvaW50IEkgZG9uJ3Qga25vdyB3aGF0ICdpJyB3aWxsIGJlDQo+IHVzZWQgZm9y
LiAgSG93IGFib3V0IG1vdmluZyB0aGUgc2V0dGluZyBuZWFyIHRoZSB1c2FnZSBiZWxvdyAtDQo+
IA0KPj4gICAJY2hhciAqZGV2aWNlID0gTlVMTDsNCj4+ICAgDQo+PiAgIAlhcmdjID0gcGFyc2Vf
b3B0aW9ucyhhcmdjLCBhcmd2LCBvcHRpb25zLCB1LCAwKTsNCj4+IEBAIC00MDIsNyArNDAzLDcg
QEAgc3RhdGljIGNvbnN0IGNoYXIgKnBhcnNlX2RldmljZV9vcHRpb25zKGludCBhcmdjLCBjb25z
dCBjaGFyICoqYXJndiwNCj4+ICAgCQkJYWN0aW9uX3N0cmluZyk7DQo+PiAgIAkJcmMgPSAtRUlO
VkFMOw0KPj4gICAJfQ0KPj4gLQlmb3IgKGkgPSAxOyBpIDwgYXJnYzsgaSsrKSB7DQo+PiArCWZv
ciAoOyBpIDwgYXJnYzsgaSsrKSB7DQo+PiAgIAkJZnByaW50ZihzdGRlcnIsICJ1bmtub3duIGV4
dHJhIHBhcmFtZXRlciBcIiVzXCJcbiIsIGFyZ3ZbaV0pOw0KPj4gICAJCXJjID0gLUVJTlZBTDsN
Cj4+ICAgCX0NCj4gDQo+IFNvbWV0aGluZyBsaWtlIHRoaXM6DQo+IA0KPiBkaWZmIC0tZ2l0IGEv
ZGF4Y3RsL2RldmljZS5jIGIvZGF4Y3RsL2RldmljZS5jDQo+IGluZGV4IDE0ZDYyMTQ4YzU4YS4u
NmMwNzU4MTAxYzRhIDEwMDY0NA0KPiAtLS0gYS9kYXhjdGwvZGV2aWNlLmMNCj4gKysrIGIvZGF4
Y3RsL2RldmljZS5jDQo+IEBAIC00MDIsNiArNDAyLDggQEAgc3RhdGljIGNvbnN0IGNoYXIgKnBh
cnNlX2RldmljZV9vcHRpb25zKGludCBhcmdjLCBjb25zdCBjaGFyICoqYXJndiwNCj4gICAgICAg
ICAgICAgICAgICAgICAgICAgIGFjdGlvbl9zdHJpbmcpOw0KPiAgICAgICAgICAgICAgICAgIHJj
ID0gLUVJTlZBTDsNCj4gICAgICAgICAgfQ0KPiArICAgICAgIC8qIEFDVElPTl9DUkVBVEUgZXhw
ZWN0cyAwIHBhcmFtZXRlcnMgKi8NCj4gKyAgICAgICBpID0gYWN0aW9uID09IEFDVElPTl9DUkVB
VEUgPyAwIDogMTsNCj4gICAgICAgICAgZm9yIChpID0gMTsgaSA8IGFyZ2M7IGkrKykgew0KPiAg
ICAgICAgICAgICAgICAgIGZwcmludGYoc3RkZXJyLCAidW5rbm93biBleHRyYSBwYXJhbWV0ZXIg
XCIlc1wiXG4iLCBhcmd2W2ldKTsNCj4gICAgICAgICAgICAgICAgICByYyA9IC1FSU5WQUw7DQo+
IA0KPiANCj4gDQo+IA0KPiANCj4gDQo+PiAtLSANCj4+IDIuMjkuMg0KPj4NCj4+
