Received: from esa9.fujitsucc.c3s2.iphmx.com (esa9.fujitsucc.c3s2.iphmx.com [68.232.159.90])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A717E22171F
	for <nvdimm@lists.linux.dev>; Fri, 16 May 2025 08:33:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=68.232.159.90
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747384434; cv=fail; b=PaE91HO6CA4Ea8vTU4/u+AalptK74wjmF8miU89ULq7uZTNDjLFw0XEaE03XNAlOQXLcnUoR1RctjyIEJhUXW6d5muiGF/1ywLuu+YpsTFimiMQdfxwpSdMgZ45AXYt3173KbYG+uEhzMxHVRvzG2ZEahRRnEQ57nrW9qPxlayg=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747384434; c=relaxed/simple;
	bh=Cw2avVdyozOuq/fhzwhUmpcF+lnJC/2yA4Qis5vcZtE=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=Nhwl/QZHYWKrgVUbA0bqB3RToe6eigoY23RTU41Vbasot92z378opoCh9+qEl7RTGebJ3URnblvcCQ+o33DbR/lGvDe5KDBYn6NJJbZsTch8I4h+4jslBlRxn1Pj/9s12KoFBIVjuXuPPjXmd7Af3IUhr+Uf/19WDMKZgfJVn6I=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=fujitsu.com; spf=pass smtp.mailfrom=fujitsu.com; dkim=pass (2048-bit key) header.d=fujitsu.com header.i=@fujitsu.com header.b=CzoU+KoM; arc=fail smtp.client-ip=68.232.159.90
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=fujitsu.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fujitsu.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fujitsu.com header.i=@fujitsu.com header.b="CzoU+KoM"
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=fujitsu.com; i=@fujitsu.com; q=dns/txt; s=fj1;
  t=1747384433; x=1778920433;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=Cw2avVdyozOuq/fhzwhUmpcF+lnJC/2yA4Qis5vcZtE=;
  b=CzoU+KoM9im1bIX4KiXDo63pGMrwSoU0ZJ3inTvhRICl0hJW5kZpO52Z
   gp/KwpS8zMhjV88OQrCcRCVenza6BIb3klwAzSkeiueArZY8VZeUuwTT5
   f7yA8THn57WhVF3U70K+4rr4IFpy+zvFeoBCNmGJJK22LxLcU65Ydi7MK
   gITEyO1Slx+EhyEtBBv7Dp3BMO4w0XoGJtpInagKDbYOMLkTMwzv0/M2D
   Osvy1fmHsmpiptlu2frLAMWNSbDwUr+J7nPFAf3GkFSZH95C47oKY6rt6
   4C3F/R7b8rna8RvawLXN/fpARxkob+OmOuaOBkU5DwtqLk7utx+FU6QWt
   Q==;
X-CSE-ConnectionGUID: boeC5lwBQiWGPV/NVwg2bg==
X-CSE-MsgGUID: IlEg6zShRnq6OGCn4RkNhQ==
X-IronPort-AV: E=McAfee;i="6700,10204,11434"; a="155696188"
X-IronPort-AV: E=Sophos;i="6.15,293,1739804400"; 
   d="scan'208";a="155696188"
Received: from mail-japaneastazlp17011030.outbound.protection.outlook.com (HELO TYVP286CU001.outbound.protection.outlook.com) ([40.93.73.30])
  by ob1.fujitsucc.c3s2.iphmx.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 May 2025 17:33:42 +0900
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=cpSPQuV4G4McBzZvGPD357tVcTaWkMHZPUlHQwe7LWowHlcsog8wHFcF4ji6J5dJb8ut2LahSguHCZxacSjvBD+E6kKBuMR6smrZtbzFtvl/2a0D0DWjHIJdqXXpwqNwIiL3Kj8lhrFTLXnwkBm7fxsHZbHjW5lgFFoGcRkXs4xA/G9Nxup+CVVG0r4vZtmNvDLGRlX8TdtDSflaG05XNGcwKYJiukboOQ/SZ29Q5r//lAe0yUcHhnn3KoewUwOV9Gqo/w9wXgg+Jm9Nkxn826q2kYGT88qTQW7zGjCdf8tSKGYapDV7iv4Z2E7vWVNZ8g17VtFDROpojK8q0AFHxQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=4ryzD0IijckMJlE5gjDiFLSQAYQTs5PlRl2mDpSPt/E=;
 b=Ey66QBxRmwFXHKMPiw3WZfxUZn66twuG0QkiLnm9b2l6bloSDX0kR+QRXTJzhRwTP5Th1hGEgfRAlcxXc3S4qkkzb2P+lQk8jjvF5yu1yu62KicHrv6xAGIGOF6LO83c1clYEGMBWornvVpHwHjYJa+Q/ZzqXO7m1aWr7VaI/cl/LWXHQdxG/Dxk7MiFsmuKQTmSrcKUI7tdbluqXbpFngeXo0gMc4aMORW7Ew98QqvWgPwV+A+7C9G7mtZJl6BKpBhucdKvxkxh+EOh+3r/T1ft9w3u4ahWwURmsn7qNvZQyDoa5vMDOTNrRWfbqyDetZRtLB96my65Kcurp5PbuA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fujitsu.com; dmarc=pass action=none header.from=fujitsu.com;
 dkim=pass header.d=fujitsu.com; arc=none
Received: from TYRPR01MB12430.jpnprd01.prod.outlook.com (2603:1096:405:ff::5)
 by TYCPR01MB6189.jpnprd01.prod.outlook.com (2603:1096:400:4d::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8722.33; Fri, 16 May
 2025 08:33:39 +0000
Received: from TYRPR01MB12430.jpnprd01.prod.outlook.com
 ([fe80::c82f:3cb1:5b5f:b363]) by TYRPR01MB12430.jpnprd01.prod.outlook.com
 ([fe80::c82f:3cb1:5b5f:b363%5]) with mapi id 15.20.8722.031; Fri, 16 May 2025
 08:33:38 +0000
From: "Yasunori Gotou (Fujitsu)" <y-goto@fujitsu.com>
To: 'Davidlohr Bueso' <dave@stgolabs.net>, Alison Schofield
	<alison.schofield@intel.com>
CC: "nvdimm@lists.linux.dev" <nvdimm@lists.linux.dev>,
	"linux-cxl@vger.kernel.org" <linux-cxl@vger.kernel.org>, "Yasunori Gotou
 (Fujitsu)" <y-goto@fujitsu.com>
Subject: RE: [PATCH v4 -ndctl] cxl/memdev: Introduce sanitize-memdev
 functionality
Thread-Topic: [PATCH v4 -ndctl] cxl/memdev: Introduce sanitize-memdev
 functionality
Thread-Index: AQHbmF/9S4EY6oYJJUmO8zEOxl4fELOxxz8AgB+GbACAAnGnMIABiUTQ
Date: Fri, 16 May 2025 08:33:38 +0000
Message-ID:
 <TYRPR01MB124306445DC309E51CC2ED7F79093A@TYRPR01MB12430.jpnprd01.prod.outlook.com>
References: <20250318234543.562359-1-dave@stgolabs.net>
 <aAkuxAG30M_WxT8d@aschofie-mobl2.lan>
 <20250513194250.2mpidwy452awflf6@offworld>
 <OS9PR01MB12421FA48385C1611C63CEDE79090A@OS9PR01MB12421.jpnprd01.prod.outlook.com>
In-Reply-To:
 <OS9PR01MB12421FA48385C1611C63CEDE79090A@OS9PR01MB12421.jpnprd01.prod.outlook.com>
Accept-Language: ja-JP, en-US
Content-Language: ja-JP
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
msip_labels:
 MSIP_Label_1e92ef73-0ad1-40c5-ad55-46de3396802f_ActionId=3f9d5efe-a1ab-401d-a821-95f58b5ac2f0;MSIP_Label_1e92ef73-0ad1-40c5-ad55-46de3396802f_ContentBits=0;MSIP_Label_1e92ef73-0ad1-40c5-ad55-46de3396802f_Enabled=true;MSIP_Label_1e92ef73-0ad1-40c5-ad55-46de3396802f_Method=Privileged;MSIP_Label_1e92ef73-0ad1-40c5-ad55-46de3396802f_Name=FUJITSU-PUBLIC?;MSIP_Label_1e92ef73-0ad1-40c5-ad55-46de3396802f_SetDate=2025-05-15T09:03:22Z;MSIP_Label_1e92ef73-0ad1-40c5-ad55-46de3396802f_SiteId=a19f121d-81e1-4858-a9d8-736e267fd4c7;
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=fujitsu.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: TYRPR01MB12430:EE_|TYCPR01MB6189:EE_
x-ms-office365-filtering-correlation-id: 28c23576-b247-4139-d3cc-08dd94545b3d
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam:
 BCL:0;ARA:13230040|1800799024|376014|366016|1580799027|38070700018;
x-microsoft-antispam-message-info:
 =?iso-2022-jp?B?RkNNNFlVQTQxeWd5em10RWJGV0tJSkVzZElhaFBhbllIcEE0OURtYzZF?=
 =?iso-2022-jp?B?NWdVSEE1ZXV5dXUwVWJ1TlNKNXJ3eHdIVVZ4SEZnbTJLd1lURHRRTmlH?=
 =?iso-2022-jp?B?b1ZzMjNKQ1lmRVRia0tQeG1uRm9CbnQ0c2JLVjNGc2syQnRoWDU4eHBr?=
 =?iso-2022-jp?B?ZmFKZ0FGOGIvaU5EdmFmdC9PYnMyKzltOHZhQnlNVUswb0h3MHhDa0Zn?=
 =?iso-2022-jp?B?eUNPdU1nMlpXZVZHaERKc0V2bVJsZFZXR2gxVStZTHRyb253K2ZtWTRs?=
 =?iso-2022-jp?B?c3NrTmpsNzdCbEpuTS96cTd0NXhoUFVsODlmSXRsQzZGbEF2SlZPanJh?=
 =?iso-2022-jp?B?Y0FHNVVqazYrdDVCaXg1MGg0dUo0RHFLL044NFlaN1A5OGszbjRyeW12?=
 =?iso-2022-jp?B?cEVzNitsaXlVUnVGWWZrNk83dk0zNGUzSUlqdlZJcmU0ZjE4N2hPNnp0?=
 =?iso-2022-jp?B?SEZLNVlyMncrWFhuVTF6Ui9XZGY3Ym1RTWFBYnJFaE1KbzF4bmg3OVVS?=
 =?iso-2022-jp?B?eFpFTXJNbEUxMm1RUXk5U3BsODZWUVFwNjFnNG03cUFXYm9BWkR5Umtr?=
 =?iso-2022-jp?B?bkhJS3N1aHFtVE1RQ0FWR0FXUXo1YU8xZi9LaXlZOERsMzVkd1Zpemxp?=
 =?iso-2022-jp?B?Vi8rdjFiNldKWG5TZk14ckgxOTE4c3VmeU1sWWNPZzA4Q0hnRmNVRENx?=
 =?iso-2022-jp?B?MHNwOXZxd0c4TnFqeGRWemdFTWpBUWV2eWN4bTVRWjZuN3FFMVJxK2h5?=
 =?iso-2022-jp?B?aUJGcUlWNysvTlB4WWp5MWlOeXVyOUtDUWllSXZwU1A3aWw1MGpKOWEv?=
 =?iso-2022-jp?B?ZUFZVlpFNjFSeUJCdmZFWDB6azd3Mzl4cVVxemlmRS9kYkZSVjliWmZq?=
 =?iso-2022-jp?B?bGhrdGp1TzR0ZmYyRHQ1TVNHNUtzekpCNHJGbnh3VVpZd3hqMGZWZEQy?=
 =?iso-2022-jp?B?YlVoNTZlRzZGNVFOVHBIenBCcWhoNjUvWlg2UTNDM2ZIcFpoaGpTQUNl?=
 =?iso-2022-jp?B?U3FoVnN1S1ZyUGRPczNkKzAyalE4cEpkR3NCVE5LZ2lDVlpMYlU5aHFm?=
 =?iso-2022-jp?B?VE1vTlBxUndwTWYxbU5kQWxhd0pzU05rVmNLUWZGK0RwUTVlQmhkMWtp?=
 =?iso-2022-jp?B?dVJsSFRWZ2luYVJUZmN1ZTJPRXdWWUdZRFJIdzBOQjlVNzRWRzBKRytt?=
 =?iso-2022-jp?B?SHpMV3M1L0MxQ1NhOXVZUW4xZitQKzF2N2dLaWlNRDJodUNFaGZZdVZp?=
 =?iso-2022-jp?B?KzBxMDJqQUdkZ0xSZW1uQS82WEt0OTVySGFMcmFsQ1N1ZnZDVGEwd2Nq?=
 =?iso-2022-jp?B?YnQ4T1JCMm5SNDE3dzF3WDFobHNkdlhUWm9hQy9sVG1wbTF3QlRnQUhU?=
 =?iso-2022-jp?B?S3lSenJ0cXFxV1BTblBnR296NTRJUEU0aHJWeDZOR1BjejRNUGUrZi9J?=
 =?iso-2022-jp?B?bkF6VVA1NCsyT2c3RnRuTTB5VHhEaHpHNUgwbERjRkd1NkNLaHVBc1c3?=
 =?iso-2022-jp?B?ZE9yR1BNL1VtTHp1THpIcGdCQ3lCUFU5amduMmlzamFSNDA3SUFxSFc4?=
 =?iso-2022-jp?B?aDB2K0dxRGFIN3hKNGt5TVlJNmVWcXFlVEwxd2tvOHpVRU8vU3g5K00r?=
 =?iso-2022-jp?B?ZWNyWlFpektRY1Q0SG1saEhpOGg3THBOMCsvNlNIVVU0S3dXVGU0Vlg2?=
 =?iso-2022-jp?B?OEpkd2thVk9ac0tuRmpxVS9tRWZVNmltR0d0QXd4cDFDcmlieVViRnhD?=
 =?iso-2022-jp?B?SDZWeERWTm1Cd1JpeW5GaXh6RUpORWdyRFU1OW9Fd09VWHQrQkFLM29o?=
 =?iso-2022-jp?B?RXdYaHJHSmxwcE1jOTlSYkpFbVgxaUx4TW55Q0FkclI4ZmR5MVpvUjQ1?=
 =?iso-2022-jp?B?dHZuTmdhd2Iwd3hWRnpFV3pVWHcvS2JrbmloZlRaeEJpOUdRejZyOUgy?=
 =?iso-2022-jp?B?VG5TK0hOSkU0cUdURjhrL1lzZjR1UE5vYXllZXdpamhIYTdTWU43RUlF?=
 =?iso-2022-jp?B?Z2pEZVVhZGhnVzhOSVVWQTJqaytHOTFlaFVNSERVd2FNc3RmNGd6WkFT?=
 =?iso-2022-jp?B?c1YxM3BmdlNiWWNHVFB2WXJqeGROL1Y4MUhUWnE5U2xTTHZxR3lnQzly?=
 =?iso-2022-jp?B?N3hjOTdsUHMrRE5VaE9VQ3FOV3lDeTRuT21nMUpkNVpCQjZZNEcyKzRW?=
 =?iso-2022-jp?B?Q2NWZkt1Mm5tYTBsTkhaQnBabVNBWmhT?=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:ja;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:TYRPR01MB12430.jpnprd01.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(366016)(1580799027)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?iso-2022-jp?B?MkFpYXJJMUdzdFl0TzZjYlR1dGxUSHJhSzlDMTN3aVcwZS82bWd3dDF6?=
 =?iso-2022-jp?B?ZVBLTFR4eGFqbU5XeG9ldGgvZFRNUmdGOU9Va0Q5VGpMQmFWdkIvVlJH?=
 =?iso-2022-jp?B?S0p5bHUvaDRiY1pMM3E4T3B6M3JYNHEwOGxCTzVrSm1YK2MzejlKRWZG?=
 =?iso-2022-jp?B?VnBPUWx3c1hzZm0rQWJ3ME1WVldkZ2xyVjBNR2lTZkpsSFh1bzdtUUVa?=
 =?iso-2022-jp?B?MUxxZEQ3bVo2UTlpTlRncnc0Z2Nxa25LRlg3THNLOU9pNmxzU0ZEL2xl?=
 =?iso-2022-jp?B?SWl2eHlVL3NiUmRiaTZ1K2R6eTg4ZUxXTVduMFRzUnAwRVFnRzVGdWJY?=
 =?iso-2022-jp?B?RUZLQ0UzNHdqL1huNEVQR2xYQ1V4d1dHcVhXb0IzYnBDdGNndFJaSFYy?=
 =?iso-2022-jp?B?eHZYMmRyRXV3N011cVVRWlhSQzhMenpicXRNWlFQdHRWQjBpOEM5T0U0?=
 =?iso-2022-jp?B?QytJNFlzVmpCd3pyeE5iSkRneDZFRFJ6c3dYak9KanhVQUZzU1dtRGRZ?=
 =?iso-2022-jp?B?aExDZ09wOTQ5LzJqTm5mTElPYXNOVDRJaE53dXJWMHpTWkc4YUpXYXdm?=
 =?iso-2022-jp?B?RllCUGtQbndMbkRRSkYyZGozVmVBUnkybWp4NnpKbVNqLzc4bjBOcXFz?=
 =?iso-2022-jp?B?N05wR2lNUFRlb0F6K3JDZHhZMktsMEVuWUd1bmlSMFBJVElxRk1yb29X?=
 =?iso-2022-jp?B?WDcwWWc3K1BGU05zQ2xncnIvNkFQaEQwL2J6L0xHeTF0YUIrbjJsL0xk?=
 =?iso-2022-jp?B?SFM0anJFSHB4TUppOCsvSG1KWit1ejlndFJtamxweThZaWU3NGhVUTNE?=
 =?iso-2022-jp?B?UzRTeXlZUFJMSnV3M1NuOVpKbFFaWEt1Q210eER0YUNYd292V2Ixa3F3?=
 =?iso-2022-jp?B?Y3g3ZGlGSE9aQkJXTjNFa0pGY3JiYWcvcHFZSGRQRkV1L3lJWENaVDV0?=
 =?iso-2022-jp?B?UFd4Tm92LzJzMzJTT0REaDRsWDZIN080TnBBMnlSejcybUdCeUhWTldS?=
 =?iso-2022-jp?B?Q3lVL2h4S3F2bGhmUWRCMjNvZ00yTi9scWZvdEVZbVBMeWdCYmNxUklV?=
 =?iso-2022-jp?B?NGs0QklkZXYyRFdNWW80eWhHU1NkRDNVdlZ3WVBzdS9jSlNad0ZtTkhw?=
 =?iso-2022-jp?B?aXBwNHR0VzdYc1FySTZ1Y0FkbUpnVDFPV0NaZDVNeU1RNmJFK1NDWThr?=
 =?iso-2022-jp?B?QnYzSGE3UEdnU2c0OFFMNzhGdndOVnRnbElLTXlKMktDNkliSFIxNXQ1?=
 =?iso-2022-jp?B?RTYxR2RETms1UUpUU0xsc3hFYnVkMWxzQkZzWEV4VjFmUzh5NFBwdTU0?=
 =?iso-2022-jp?B?K2lRSmlwc3I3TE0xaHpsZ1VsS2kwUU45SjBDNzdFSXVab3U1b1p2WXg5?=
 =?iso-2022-jp?B?MjQ0UmhGcTBMekwyYVRWckhESzNIVGI0ejZaWlBTNnU4STZNa3JrZGph?=
 =?iso-2022-jp?B?T1AwcXorWDBFK3ZpbFJSMlZ6VHQ0TmtJWkxabG9udnIzb2xXRmcwVFJy?=
 =?iso-2022-jp?B?SHhsNVAwcDByUkxwQis0eUlTNDFmNlJYWUE1L1V5eHYzWHhVc0xqR2Vy?=
 =?iso-2022-jp?B?VDg5cWNiVGlTYVcycjRicm9hZjRVWk1KRE9ycGN2ZGxkalpOSkt5L29n?=
 =?iso-2022-jp?B?ZkNtMkNYV3JzYzBWMll4a1Y1WU9jemxvc0dYeVU2NGNmeEZmSitKN2pG?=
 =?iso-2022-jp?B?RkFiTzF4K1lPVWQ0L3VLRjJyK1VscDc4cElqNFNXSWZNZlhLY3Eyam9n?=
 =?iso-2022-jp?B?TUZ6UTM4WEczRzUwejFqL1NWU2Z6TkJTV0VRR1RyZVBmbE1DdXJGd01G?=
 =?iso-2022-jp?B?VkZRTHJ0Vkk2K1RoQ3UzZWpvdGlUOEdGa3FDTlZQb0xpdnBGSmlJaW9I?=
 =?iso-2022-jp?B?ejFEN2hHM3htbzViZ2ROYjd6TDFpNjVOai9KZC9GMi9XOVBxYUkvdHpw?=
 =?iso-2022-jp?B?SDFrTnNQOFJvTkg5RHIwSENIdG1oS2hSaHNqRkVDMEcyenlrR3BIZ0tm?=
 =?iso-2022-jp?B?cTdkOXhsOS84QmMrcVpMSk0yeVd5eDNtbVFQRkdpbXlXRHpHRGlGYXM5?=
 =?iso-2022-jp?B?cGJ2WFBvOFlyU01MYy9BV1dFaUtBZWJvbzhOUlBUWExNWmR0ODdrZzZ2?=
 =?iso-2022-jp?B?T1BVbHl2eGM1MXhIaFRtc3F6NnVZZ1I1VDByc1pDWmgzY3ZVdGF0T21a?=
 =?iso-2022-jp?B?L0NDYWtxV2R0SzV6QlZtSURITkVVWTlzTURyRHZoNnlUTWw1STFEK2Vy?=
 =?iso-2022-jp?B?N1Vsa3ZrVU9SMTVoZlhvK0ZxL2lEMWVXeVJ6WExTMFpJNG8wNDRaT1d6?=
 =?iso-2022-jp?B?cm96bg==?=
Content-Type: text/plain; charset="iso-2022-jp"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	0x4iuF3BrVHs2pH7nOmokfJIJy0ET89V2KE8N5Kvy2HNkR2+liUr5/qlYfdypbOA922HoVyjVtUMCgvhBWRMcpLEPCJ9DmehC7jNBL2SCWauwNc11lqx7r6yaqVxlFfLdU9DMIhIKSOxHB8EoFrTpCGyaR5LSNCik1MO43xeIGlCO5SyDaIkCi5C8xVXIP+hDB/CAlWg9gZShq44yi2I+3AxqUBw8z8vbiow9Yhs81hHHVhoptfkPxAN12x233OCt1SXhvWIFKJdBxLfqppEBXSeKNqeFiQU8dsC4JMTtmfRMu3c/7xQ2Ibk1J0SXpdBpq8Z8rEScW1Wemn1ix2UgFRoRyPbH2Mb6ENYLi0g2RGMCmKIU42ZASQin54megl5jbzhYAPG5DYuF/l3YhY2eqc0uZEEqxViYg638IhqRSnaBqsjmtyd6H6VxELexwPEw7xhQ9k7TgJXgX3yVHvd3yRecDRAMcgQvBeGBCenvwXZ/zyAgJz1NWc7z39f9WszZuwPanogzqE5BmVWCuistf2o9aUAhhrjJsW/Aa9i41ZaseedQEnZMozD1s5zW5/CjhSgPzCVG/0AsBjKOuHlboZ8I5M/QJ9P0bTgKRjn2IN3kAGUXSBgxTOxGiv0X7PR
X-OriginatorOrg: fujitsu.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: TYRPR01MB12430.jpnprd01.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 28c23576-b247-4139-d3cc-08dd94545b3d
X-MS-Exchange-CrossTenant-originalarrivaltime: 16 May 2025 08:33:38.4876
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a19f121d-81e1-4858-a9d8-736e267fd4c7
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: MAZO3trE5630XLHE4iuJ3UC+f9+gXcpzfYpcIQNj/hPy6jJeoOdTn2dUG9FV5/Ssya3xjttnV1VxEgaa3EKEGQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: TYCPR01MB6189

David-san,

> Hello David-san,
>=20
> > >On Tue, Mar 18, 2025 at 04:45:43PM -0700, Davidlohr Bueso wrote:
> > >> Add a new cxl_memdev_sanitize() to libcxl to support triggering
> > >> memory device sanitation, in either Sanitize and/or Secure Erase,
> > >> per the CXL 3.0 spec.
> > >>
> > >> This is analogous to 'ndctl sanitize-dimm'.
> > >>
> > >> Signed-off-by: Davidlohr Bueso <dave@stgolabs.net>
> > >
> > >Hi David,
> > >
> > >Is there anyone you can ping directly to review this one?
> > >
> > >It's been lingering a bit and I'd want to see a review by someone
> > >other than me before merging.
> >
> > Yasunori-san, since you were requesting this (as opposed to just doing
> > a trivial echo 1 > ...), could you please give this a test/review?
>=20
> Ah, OK!  I'll test it.
> Please wait.

Oops, I noticed that my CXL memory does not have the sanitize feature yet.
Did you test your patch with the cxl_test.ko test module?

Thanks,


>=20
> Thanks,
> ----
> Yasunori Goto
>=20
>=20
> >
> > Thanks,
> > Davidlohr

