Received: from mx0a-00823401.pphosted.com (mx0a-00823401.pphosted.com [148.163.148.104])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 540B62192F9;
	Tue, 14 Apr 2026 02:15:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=148.163.148.104
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776132948; cv=fail; b=r0d7wVUJwCTNfed/MhCh3Lh7TyA9v1Hunoiu8wA3KzCNd7F0FKMQpuLsKlS16O1rtLq8rovtYc4uczVJM5HmhUW/FolGh2pDyrT+plJC2uvp127/Lv7q40gxAco1OO1TsBJOXDagyPGEDh+0eMG3b8W3mWB0PlYP3BYTC5NFrKE=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776132948; c=relaxed/simple;
	bh=MxMcmlSlrU7yJFqlNHJ8M+DrJPcvIYspiCmBjN2H3BQ=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=nKDStcBCXYW9NiHVSmt5FpCAWGIhoE1NXoq7MgWb9pwji+pbcB3NlzvHKtHNw0cESZQxRsSQAD1LPiS8iQr3nOJh1Iw5uD0Md2MCr/+CgZAovaILImf0rClc9uxZLXPwHiBAszO+O1LnVZ7y0/Yz5WaiN+IYk6N0KBMgTUjzu5Q=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=lenovo.com; spf=pass smtp.mailfrom=lenovo.com; dkim=pass (2048-bit key) header.d=lenovo.com header.i=@lenovo.com header.b=lX3k0fUe; arc=fail smtp.client-ip=148.163.148.104
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=lenovo.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lenovo.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=lenovo.com header.i=@lenovo.com header.b="lX3k0fUe"
Received: from pps.filterd (m0464638.ppops.net [127.0.0.1])
	by mx0a-00823401.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 63DLBOAd2190261;
	Tue, 14 Apr 2026 02:15:40 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=lenovo.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=DKIM202306;
	 bh=MxMcmlSlrU7yJFqlNHJ8M+DrJPcvIYspiCmBjN2H3BQ=; b=lX3k0fUeDurX
	63I+xK5cSNvp3wAFoLfy5TMuO6bWNrD/aUTD61HIhB2LL01UttRXqtVPY4wbHF7N
	zIfTzDdLHwoiGz9QZ4PqKbrNim8jGnbgDCxwP1pn2Quv6Tum7Aa23duyziOCXaQY
	EEX4sRCeBLhCIIMl1PyPM6cZIq//9lzvwzsv1PhSx9lUnChPuzYo7iiujN3awrRm
	AH1dfOyODLZGBH9nBdcXu2S1pWk7TvBunbVkS3mUzy8V0qJraRt3bkc8l+EU8hiV
	qrCeS+FxrOh9WxK4H/cRVeqDWwgYGMPgWd0Pftp/hj3cLXPVr5Ji63nxj+xaecBg
	2+hvqikmLQ==
Received: from os8pr02cu002.outbound.protection.outlook.com (mail-japanwestazon11012013.outbound.protection.outlook.com [40.107.75.13])
	by mx0a-00823401.pphosted.com (PPS) with ESMTPS id 4dh85ugaen-1
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Tue, 14 Apr 2026 02:15:40 +0000 (GMT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=N/4o/5imO+HQZLPQFHFrbKBPUgFYljIBu/Gxbpz6UKV7eagxolnQBTa8+dXA1jwDzb5AC27Zyq4Kd5sDljB+5/rE6jq4Qlq9HuPrQCOzoM+VHhydA54A7GldMpMuoeOOGO1BFOU4VUpJbroy80Ux+3yh3Owe0/X4aqGpuT74Goylg5jC+rgk+j0+IKI2o2t2QQ+xqbuC0WXNYBSY0eOk/R7Ss6Zpc43Vv2Iv8CsBcts+oAvU4wpNniE8WhVbO569BgK7dLv8JgwqQOmMC7jqUZ4krs8ZNLGsZv+rlqwJFBMcqG5HmbS+jl+KiF91sVC1ilyqjoJUrpJlKFSmtvPopg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=MxMcmlSlrU7yJFqlNHJ8M+DrJPcvIYspiCmBjN2H3BQ=;
 b=lgfrWjIPrDTpP7mYwIL+pWN+aKXte+K2KTaYk5nRyt9NnkQoITSvF2DNh6h1HjIIha5MoAgv4ssCiBjG5FZNt2I3Ivgg+XaQ6lcOzUlx9CaQ6uOtVRL4o4R80IOLbH2bLhE0RLysj0ZfblHdq2G3N0RWea2AYT/3JzBM+DFbwp7F1//U28smp7iN1U7G5p1tYjW6sN+PaYIxaJcySJf9KAktpnirEdXoYtwGLJ7np01KjKtfaohMeTHtXVuUZJiwqDPgcP3PV+gYrvQZfOsMdjeGRSwQjrzdu+H97tmDb7HBR04hwevTH/04lX9wgEtxDNhcbRnPMG7UgJvJWhOPIQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=lenovo.com; dmarc=pass action=none header.from=lenovo.com;
 dkim=pass header.d=lenovo.com; arc=none
Received: from OSNPR03MB9538.apcprd03.prod.outlook.com (2603:1096:604:45e::17)
 by SE2PPFDE250D346.apcprd03.prod.outlook.com (2603:1096:108:1::4ac) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9769.45; Tue, 14 Apr
 2026 02:15:37 +0000
Received: from OSNPR03MB9538.apcprd03.prod.outlook.com
 ([fe80::2932:47e8:5e8:302c]) by OSNPR03MB9538.apcprd03.prod.outlook.com
 ([fe80::2932:47e8:5e8:302c%6]) with mapi id 15.20.9769.046; Tue, 14 Apr 2026
 02:15:37 +0000
From: Yahu YH12 Gao <gaoyh12@lenovo.com>
To: Jonathan Cameron <jonathan.cameron@huawei.com>
CC: Dan Williams <dan.j.williams@intel.com>,
        Vishal Verma
	<vishal.l.verma@intel.com>,
        Dave Jiang <dave.jiang@intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-cxl@vger.kernel.org" <linux-cxl@vger.kernel.org>,
        "nvdimm@lists.linux.dev" <nvdimm@lists.linux.dev>
Subject: RE: [External] Re: [PATCH V2] drivers/dax: Fix typo in comment
Thread-Topic: [External] Re: [PATCH V2] drivers/dax: Fix typo in comment
Thread-Index: AdzEroJhJHJWjIpEQjmIUDHKuCNxWgGqg5YAABbwr1A=
Date: Tue, 14 Apr 2026 02:15:37 +0000
Message-ID:
 <OSNPR03MB95384C1A6EBD538A187E02E3DF252@OSNPR03MB9538.apcprd03.prod.outlook.com>
References:
 <OSNPR03MB95383CB4853CB4CD18C2A376DF5CA@OSNPR03MB9538.apcprd03.prod.outlook.com>
 <20260413161656.00003403@huawei.com>
In-Reply-To: <20260413161656.00003403@huawei.com>
Accept-Language: zh-CN, en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: OSNPR03MB9538:EE_|SE2PPFDE250D346:EE_
x-ms-office365-filtering-correlation-id: 59a2f868-4983-4555-61c9-08de99cbb7fd
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam:
 BCL:0;ARA:13230040|1800799024|366016|376014|38070700021|18002099003|22082099003|56012099003;
x-microsoft-antispam-message-info:
 JBi901MXeeZvGJxN+jMC7qYl7DMS3xa7ZcD8cXOkMfaYskpK07iyRydg1Y5OORWsE25regPfVRm96HCOwvg/rkgPezyG0hkV1h6zgNZLWGBWG+ERotxpyD37EqstaK2RCkJaSBt1dic6T+aLBRjo+9aF3R84DEEtwMxCJ25vVP6hXA2S5KeIOI/u0naWRcYXgdlu5rl/pbzjNbJAp7hPtNxJztaomxGFflff0MMTvqOz1y2Nm9U99qvpj0dXu75BSUn7lsyRl8c0LiZqsqkFrMzvoTPFYfjt1TVsHpm1hUpsbOAdgFeGdBCGgh3FgAH6GU5S4MlRnlsskMfY3heQGWOrArmZCsSljXurOctq6rP5rzd3MkDC9X90CVxI3nIMTrc34AbcpgBDLYd3TsyMb2o9QM9nuyzr2V0l5xEYQ36mx97m9ktx8Fwu/m92bby0PTW7n5VMAhtPleRSuuR3sRCcfK/kttHe+PfN4GZBUDeqYCAdKwd/Ks7s4xOECt7oSJuy1ce+XrLQ0NCO5Y0OY27bmz9DhRlEc1w8gl7N/JvxKriattZf6rghc8qD0y1FEon1ZtaIugxNhlxEtso8yf7OyJIT481VPxtZBHox5ZIfPP1P5sgPWOREMqPq67/NkoaRK+1MXSN4xEo+5/2kgrT18RvK9ADlO6zImqF7r7IgLqwnJIGesQd/6oA61zlbSUlTvZWD8AOPY4SvCdNwr1PREG/kTubQjvWi/NwYhbvMjoMWjW4tuRKSs6OZs/e7P2FE72YMLzkw0dAgCv/lwHO5Bdg1qe5S4R3cEXBEvHs=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:zh-cn;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:OSNPR03MB9538.apcprd03.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014)(38070700021)(18002099003)(22082099003)(56012099003);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?gb2312?B?cnNRNng2WVNFcktMZk8vc1U1K2UxNFM0NVFCdXU1YzhxbXFEcU9mdlVRNlRr?=
 =?gb2312?B?dURZbUxNZXl6V2I5YVpMTjJBK3p4NnhSRWV2YW1HQ3BnTDBHOEpkSy9sMFlT?=
 =?gb2312?B?NHBzWDd5dDlwMHY0Ty9NaTdnWDNlYUMyWGl0WUU3UDZGVHdMUzNsOVR6R1M2?=
 =?gb2312?B?ZC9vRlVJQVUrS2V6N2FkTmRPVWMzQnNvOGlIOWZLUi9Oa0ZwZFN1dVAzNlhn?=
 =?gb2312?B?YnFnVjF6YjZQakxuU28zSjFXbWI2WlpkcGdCajNWdkxPNUs3c2R3Vis1eGZ4?=
 =?gb2312?B?VnlaQ3NpaFJmVVlSVWRQYkltTHluVGRldG5CVHFNQUtHa1Q5QWRLSEhlZkZW?=
 =?gb2312?B?bjlhV1U5eDlWMVZ3YWVTdUpkUk9DSUVFQVNmRHhUZUdYZ09zOFZIbElGdkVK?=
 =?gb2312?B?a09tY201NXpnSXhLVVB4N1JGRFRYSUtlYXVqakxUQ0ZYd1NuR1kxMy9aZ0RN?=
 =?gb2312?B?WUpxcTZXL1JxTlJhZi92MHdaaDNKSXV3UENXbWRiWTJwSVg4elpuaU4vQzdk?=
 =?gb2312?B?cVFsVStuY044TTg2YW53S05sNkFIYWdWbjRCVUw4Q0Z3dXozK2Y5NG5nYWxj?=
 =?gb2312?B?SE0rUUd0bFNQa082WDR4ZUsrSStUUXNuQmx1aUlzRlUwRFV6dUNUamp2c3Ey?=
 =?gb2312?B?aDRzUE5GRGY3cFFsV0VYSjJSYU1nSk40dld1ODlQaFk3OWtEMk50eDFIQjl6?=
 =?gb2312?B?c2w2Mi9kRmE5bWlIczRGdUFieks5eVdOTjhyQi92Y290L0sxMms1R3V3VHhS?=
 =?gb2312?B?TmJZTlVvK1RuRXp2UWp0L3AyRDBHelVSQS9xTElBMnNYbC9EUWJRYnVvNEZJ?=
 =?gb2312?B?U1Qzam5ETmRuRWdzMG9PVGNhOUwraGp0STJpRlI0aVRXZm9qYXh1RDFFZm1x?=
 =?gb2312?B?bWlHczVkQW40Q3NNM25OZzZUenRrTW9hbXY0bzgyMm5mQ09RSzFWRE1GV2Vh?=
 =?gb2312?B?OHpDMlkzWDdIWXNtK0tXNm1PQTBCam11Y2lKRXdFQmRydFl1WXl4UWprSm1i?=
 =?gb2312?B?QVp0eW1EZ0tuUy80cFlmWU5jR2N0d1pjTHJjLzdja1h6ZEQwcHBqVVZIWXpB?=
 =?gb2312?B?U294VlREdnBSVHlySUtJUEU0SUx2NzBIdk9PZEpwUlNWSzkrcU43V3lwR2tY?=
 =?gb2312?B?RzhZSi9lL1QyV2VsOVI2NE9kTWFEUERNMXJ6cnc2aFdxQkxjcnl5cVRDekV3?=
 =?gb2312?B?ZmtLeWhNNzZsbk4waG9PRi9ETjIrblYvM1lvTU5nTy95dmZvODBob2dPZlFz?=
 =?gb2312?B?UXE2LzU4NkVCb0pRamo0Z0lzaUhmT0hpbk04a1JwRlhvN2RSYkxwVlZzMitF?=
 =?gb2312?B?bFNaOVo0MVluRTNVMGpKWXZBWkxZNGRnaDdOUUw4V2FBRXY4dHc5MWFMcEI4?=
 =?gb2312?B?WERJdzFqNzROYU9PdmRPdmJwUTl6UWI5U21tanVMZkQrTmhiMVBJNzR6UDUz?=
 =?gb2312?B?V3EySkxRQzM3dkRHeGZvRitnMWM2M2c3YTNTeDNkTGF6NENwc3VtSWRiODRJ?=
 =?gb2312?B?N21kYnlKUEF4bmxmZ2JHbjU0dkJ6aXA1c0VUeC9qTVpwTkZYekpCRlgycDVI?=
 =?gb2312?B?d3RXbC9nd29HU0RFcGZuZksza1lVTFIrRU9uSzhEU29SWmZuTFNqcWN5VjZz?=
 =?gb2312?B?c3lnNkIrSU1IeHlNL1pRendqSFlFMFZKMEtzQmVwTy9XVnVLV2Z3WWdoMU0x?=
 =?gb2312?B?MWhlZG13U2JVdnJnZFpUeDE1clFDcHlwSy9CajRhbkpMR0t3ZmlGQUpaWUxq?=
 =?gb2312?B?NThzM2dVYzMwNmFyQnU2dGZ3NXBKQUtsVldUb25IT1lkSkwrZU9Wc0dVTmRB?=
 =?gb2312?B?L3pOZVd1MElQRndXK2lQQjZ1Wm5KeGxodUlqTGdMVURuNkFsWXdVM2tEeVlh?=
 =?gb2312?B?cEZEVTJkTTY4bUQ3WUc3NzQ3YkFBaEkyWms0ZnM2VUxtTUlrRktrejBIcktF?=
 =?gb2312?B?L3NvbU9ZWjNXdmVSR3NVcGlKNWVBTHNGQURmdW1aRXU2MS9aVGdkQytaajY0?=
 =?gb2312?B?UmtLb21WbmExTU5JQVhhTG96VHFaRktsR2ZZTVJTOE9UakF3WHY4aExNbTBT?=
 =?gb2312?B?VE9FdW96SkdFeGw2QTRKc1YyZFNSdWc3T1IyT0JRc2R5blp1N09MdWZtRUtO?=
 =?gb2312?B?MGJxR05ubDBqV0h4TFc1MG0xQVpFT0dTVTVHeG1rVTY4Ri9iR290TzNBMXJ1?=
 =?gb2312?B?d3pqd3pjTk94STZmQ3FkZTFpUFRObkFZSWNQcGVQUGpVejlSY2ZabmxnVWZ0?=
 =?gb2312?B?SCtzZmVxS2FITHJ3R0dyVVgwS0ZwWkdEeHJML1pnTlI4WlhVR3lTK2IrNTYx?=
 =?gb2312?Q?imRzd1ALQ6/T62EZrH?=
Content-Type: text/plain; charset="gb2312"
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Exchange-RoutingPolicyChecked:
	fy/E8zgqAf1qur03g7JR2J1eb3whVISJOpm0xwrLXXs83xeChvA/SX+nUID0htt6ixnLAzH9lCsCYfcJetgGqqvZR3lExN7VaUP3PTDkE9KD0WxmzX9gIpcNZmoaX4gEg8gYeSmpKS+faWPNCzJRDznk/u1e8LETuhS8+YnKPXAImNLVFN6A1m05RPTGvmRtwhYSlI3zmpGT6TJggq67ahbaSE1rBNGq63c01FaESgKcP2P+GOtierCqUmYOTNFrs1mJHT/ukRFZMu7/xms7fdSjZ4kMQ1qDQvXV5MCKASQIRNp3S86/SON/gHeun9tIExRfTE5D+6kMWtLugRvbOw==
X-OriginatorOrg: lenovo.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: OSNPR03MB9538.apcprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 59a2f868-4983-4555-61c9-08de99cbb7fd
X-MS-Exchange-CrossTenant-originalarrivaltime: 14 Apr 2026 02:15:37.7166
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 5c7d0b28-bdf8-410c-aa93-4df372b16203
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: EWFeaO3DPEF8fBg1ZEfCaqJYl8dYo2oyvqdscE/Gd3iaLP6Z+oIa7sPBOsh3yBLNts73fR7ElHsMzKA6Sm96lw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SE2PPFDE250D346
X-Proofpoint-ORIG-GUID: KUxnPaCMsUsxGToPi0sNZDVd3VWVdcEW
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNDE0MDAxOSBTYWx0ZWRfX3hBDExNldMUW
 zA2hPjHInLtwsatfYhNE2Fe+7Q/Uy87k3+fymySt2NvCcqkBNkSTObVLdK8SBo2tUItRIE/JdSE
 OD8up6QOQ4oDpfdTqUcsoGbEQc8AKk4CQx2ItMyUL13ug/yUOx9NE8dmy7rGSCEMPjN20jsY0sf
 KvnFk+TMAwPfzNuZeIDdQxki2CWYi5oE0yrPAQXijXkobs3uRjMxz7+Jq7cBWKNLpdxTURkYGMW
 MLg0G+0kTWwe6i8bgpxF7uegxIuZgyZjbGyqXnHVDUk37DVn/tVlk4BD7wJLsFGWfsjhcvb28Df
 bQhfKBO6Oz9uc/M29T/luihQ3NptLuUe4jJaZsbrEnfHDQhLsTGuE0Q0wdc2VWXEHioglP7WEUi
 CALZIv8T4y6of7lPK5e4d1ndSF3YBjZ4+tKFXWiNpGiW88srCmFfcllnr/CkDvZLsLCUPZXQbHo
 ahPbPHxPtz9ZjI8SgJg==
X-Authority-Analysis: v=2.4 cv=VNXtWdPX c=1 sm=1 tr=0 ts=69dda34c cx=c_pps
 a=bq18cM49yRSU9CYFWfyu3A==:117 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=_l4uJm6h9gAA:10
 a=A5OVakUREuEA:10 a=VkNPw1HP01LnGYTKEx00:22 a=2RTuljz969oO5usasWGy:22
 a=QJilI6ASod0cdCKXAsqI:22 a=8k6WQxmsAAAA:8 a=i0EeH86SAAAA:8 a=QyXUC8HyAAAA:8
 a=VwQbUJbxAAAA:8 a=YEbR5CYhuYe7HpUxBdYA:9 a=lqcHg5cX4UMA:10 a=mFyHDrcPJccA:10
X-Proofpoint-GUID: KUxnPaCMsUsxGToPi0sNZDVd3VWVdcEW
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-04-13_03,2026-04-13_04,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 adultscore=0 phishscore=0 malwarescore=0 priorityscore=1501 bulkscore=0
 impostorscore=0 lowpriorityscore=0 clxscore=1011 spamscore=0 suspectscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=-20
 reason=mlx scancount=1 engine=8.22.0-2604070000 definitions=main-2604140019

DQoNCj4gLS0tLS1PcmlnaW5hbCBNZXNzYWdlLS0tLS0NCj4gRnJvbTogSm9uYXRoYW4gQ2FtZXJv
biA8am9uYXRoYW4uY2FtZXJvbkBodWF3ZWkuY29tPg0KPiBTZW50OiAyMDI2xOo01MIxM8jVIDEx
OjE3DQo+IFRvOiBZYWh1IFlIMTIgR2FvIDxnYW95aDEyQGxlbm92by5jb20+DQo+IENjOiBEYW4g
V2lsbGlhbXMgPGRhbi5qLndpbGxpYW1zQGludGVsLmNvbT47IFZpc2hhbCBWZXJtYQ0KPiA8dmlz
aGFsLmwudmVybWFAaW50ZWwuY29tPjsgRGF2ZSBKaWFuZyA8ZGF2ZS5qaWFuZ0BpbnRlbC5jb20+
Ow0KPiBsaW51eC1rZXJuZWxAdmdlci5rZXJuZWwub3JnOyBsaW51eC1jeGxAdmdlci5rZXJuZWwu
b3JnOw0KPiBudmRpbW1AbGlzdHMubGludXguZGV2DQo+IFN1YmplY3Q6IFtFeHRlcm5hbF0gUmU6
IFtQQVRDSCBWMl0gZHJpdmVycy9kYXg6IEZpeCB0eXBvIGluIGNvbW1lbnQNCj4gDQo+IE9uIFN1
biwgNSBBcHIgMjAyNiAwMzo0NTo0MyArMDAwMA0KPiBZYWh1IFlIMTIgR2FvIDxnYW95aDEyQGxl
bm92by5jb20+IHdyb3RlOg0KPiANCj4gPiBGaXggYSB0eXBvIGluIGRheF9jb3B5X3RvX2l0ZXIg
d2hlcmUgInZmc19yZWQiIHNob3VsZCBiZSAidmZzX3JlYWQiLg0KPiA+DQo+ID4gU2lnbmVkLW9m
Zi1ieTogWWFodSBHYW8gPGdhb3loMTJAbGVub3ZvLmNvbT4NCj4gPg0KPiANCj4gU2hvdWxkIGhh
dmUgY2hhbmdlIGxvZy4gIEZvcm1hdCBhczoNCj4gDQo+IC0tLQ0KPiANCj4gdjI6IFdoYXQgY2hh
bmdlZC4NCj4gDQo+IA0KPiAoVGhvdWdoIGdpdmVuIHlvdSd2ZSBzZW50IHRoaXMgb3V0IGFscmVh
ZHkganVzdCByZXBseSBoZXJlIHRvIHNheSB3aGF0DQo+IGNoYW5nZWQpDQoNClYyOiBSZW1vdmUg
d29yZCAnbWFpbHRvJyBpbiBzaWduYXR1cmUuDQpUaGUgc2lnbmF0dXJlIG9mIHBhdGNoIFYxIGlz
ICIgU2lnbmVkLW9mZi1ieTogWWFodSBHYW8gbWFpbHRvOmdhb3loMTJAbGVub3ZvLmNvbSIuDQog
ICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgIF4NCkNoYW5nZSB0aGUg
c2lnbmF0dXJlIHRvICIgU2lnbmVkLW9mZi1ieTogWWFodSBHYW8gPGdhb3loMTJAbGVub3ZvLmNv
bT4iIGluIFYyLg0KDQo+IA0KPiA+IGRpZmYgLS1naXQgYS9kcml2ZXJzL2RheC9zdXBlci5jIGIv
ZHJpdmVycy9kYXgvc3VwZXIuYyBpbmRleA0KPiA+IGMwMGI5ZGZmNGEwNi4uZTMyZGIwZWJhOWMx
IDEwMDY0NA0KPiA+IC0tLSBhL2RyaXZlcnMvZGF4L3N1cGVyLmMNCj4gPiArKysgYi9kcml2ZXJz
L2RheC9zdXBlci5jDQo+ID4gQEAgLTE5Miw3ICsxOTIsNyBAQCBzaXplX3QgZGF4X2NvcHlfdG9f
aXRlcihzdHJ1Y3QgZGF4X2RldmljZQ0KPiA+ICpkYXhfZGV2LCBwZ29mZl90IHBnb2ZmLCB2b2lk
ICphZGRyLA0KPiA+DQo+ID4gICAgICAgICAvKg0KPiA+ICAgICAgICAgICogVGhlIHVzZXJzcGFj
ZSBhZGRyZXNzIGZvciB0aGUgbWVtb3J5IGNvcHkgaGFzIGFscmVhZHkgYmVlbg0KPiB2YWxpZGF0
ZWQNCj4gPiAtICAgICAgICAqIHZpYSBhY2Nlc3Nfb2soKSBpbiB2ZnNfcmVkLCBzbyB1c2UgdGhl
ICdubyBjaGVjaycgdmVyc2lvbiB0bw0KPiBieXBhc3MNCj4gPiArICAgICAgICAqIHZpYSBhY2Nl
c3Nfb2soKSBpbiB2ZnNfcmVhZCwgc28gdXNlIHRoZSAnbm8gY2hlY2snIHZlcnNpb24NCj4gPiAr
IHRvIGJ5cGFzcw0KPiA+ICAgICAgICAgICogdGhlIEhBUkRFTkVEX1VTRVJDT1BZIG92ZXJoZWFk
Lg0KPiA+ICAgICAgICAgICovDQo+ID4gICAgICAgICBpZiAodGVzdF9iaXQoREFYREVWX05PTUMs
ICZkYXhfZGV2LT5mbGFncykpDQo+ID4gLS0NCj4gPiAyLjQ3LjMNCj4gPg0KDQo=
