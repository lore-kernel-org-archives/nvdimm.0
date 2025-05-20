Received: from esa12.fujitsucc.c3s2.iphmx.com (esa12.fujitsucc.c3s2.iphmx.com [216.71.156.125])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 681AF1C860B
	for <nvdimm@lists.linux.dev>; Tue, 20 May 2025 03:00:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=216.71.156.125
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747710037; cv=fail; b=mKR4skra+fdY7OZPYn/sIx6Rmu3jYuzXfSnRRCT8mTR+TS/x/P0k5nKmSU+bHrfJ3tpF6JZXBhpsTF8p48QANUcxO7bV+L4bF/mGOHzZ+V7fWDekP+oUqk/PP1imTzxRXNqg+6XmuIh8ebRIOoPDzeOIRSFU0gaH6f879gpGiaM=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747710037; c=relaxed/simple;
	bh=gNPDL1Xwv8tvuwWzv/luhDBiDrM+I1/o+JKZ5QNomN4=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=Qd34FgGkVfsMcD/+gB9xt7Rt7um/VWKDoCnB3lHooNmA7bA/x41kMXGNIl1F0F8ROdGOwOqHA+fktZk44m7w1WeFrrHrUcExYEwYUTW+WbOPCuMRusvliiMf2FRxmXGhgk/PQTm3l2EbagetCgq4Zbx5QZYsLSHaqG56qFTXa6M=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=fujitsu.com; spf=pass smtp.mailfrom=fujitsu.com; dkim=pass (2048-bit key) header.d=fujitsu.com header.i=@fujitsu.com header.b=fg9N+/Tm; arc=fail smtp.client-ip=216.71.156.125
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=fujitsu.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fujitsu.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fujitsu.com header.i=@fujitsu.com header.b="fg9N+/Tm"
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=fujitsu.com; i=@fujitsu.com; q=dns/txt; s=fj1;
  t=1747710035; x=1779246035;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=gNPDL1Xwv8tvuwWzv/luhDBiDrM+I1/o+JKZ5QNomN4=;
  b=fg9N+/TmKsgMsgLoF8Mhv0ZYu0Lg1gOky9C5J23y6qaV2137lw89YOTN
   oKooQq/MIMnx/rkMmMU5hQVaB95J3or4JFwCMKeN8OZM6q3FtwWL7E+CQ
   5Kvo+vGQg7mjw5zIgc6L/vaYgO8dX/OlwuMZ30Cyc1kZwoxZDda1a9gTE
   89UM6Rwrq9GnMJuKEzOEHEGJaTUxPPkhKdW6NO5t7iqlf1q7ATACOxjkT
   2KE6XSRPggftuABk1pBuKcYJSL7abXaVR4XhFkQlmZi/R46hwzZ+t/plz
   ikWitI3CxCRcuJmP6U1J8WkEygebNfSqKXl7b1zZ9oi/OjnUJGsJNCuj+
   w==;
X-CSE-ConnectionGUID: HunD9xF0QLqs8taoQKGLwg==
X-CSE-MsgGUID: UcIMkuzJRRWKWyu/BV0mcg==
X-IronPort-AV: E=McAfee;i="6700,10204,11438"; a="156101072"
X-IronPort-AV: E=Sophos;i="6.15,302,1739804400"; 
   d="scan'208";a="156101072"
Received: from mail-japaneastazlp17010002.outbound.protection.outlook.com (HELO TY3P286CU002.outbound.protection.outlook.com) ([40.93.73.2])
  by ob1.fujitsucc.c3s2.iphmx.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 May 2025 12:00:25 +0900
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=cwdmWoRQi/JMph1LOKBZEe3mZVJFfXb2DdKvqn7zXciPH1rc+t+h4oR2jjzBu9QQigdmhKHZMbQ394/1fR74VrLlUL/DMVSpB25yDDdvhjwXHVPAONwP/FcTikGmThE6p7dPwwZ9AFwfI/45NOzCO4g+RoPrUkcZ+3VvwqHldv+6Nai16hePpxzpokiwHKBIyxXLJizvhctbPsG5Dmv1WMNUqRm6gCoeSKHE2ajCjoQPnk7y2JtnK62TBf3gTfO/caPVMhJUHnXZR34jZRuOW96SjhF6iI7jiOgcupLnbo5H6eGhUXNXGCspKbLIJpIOe5QIPmlpqf+t6i/btRrt1A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=gNPDL1Xwv8tvuwWzv/luhDBiDrM+I1/o+JKZ5QNomN4=;
 b=aEO1cBJorvbfqJPaq4FPf7VmktBvDrybfZzbJSXK+ZKqnL1Mqp/pFQ48gOuIGr8qVljp7QXHqUhDT8I5+n9ImLlOunSXeojfy75q0wQq6hvgtYuwUR1KyUqMMoFeb7GAIIvpp4cgQdl32/P/VHtjv9V4QNTwVqAtLWDL4hA1mWQuYR+SCaDsvibnOeuJQSENf9isi1h3BjfPvIUeu0/z7N2Y/B6suxbSRHEvC4w/gKuKGi10MR+y9z71zVzObIGMzWwxCzpg5yZmrFwVAH/wxG6GTaqk6luecaJXz3VXKpuirUJZD02dx4EP2wFm1uqXPFoeM7n3/lNsKLprEzDsGw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fujitsu.com; dmarc=pass action=none header.from=fujitsu.com;
 dkim=pass header.d=fujitsu.com; arc=none
Received: from TY1PR01MB1562.jpnprd01.prod.outlook.com (2603:1096:403:6::12)
 by TYCPR01MB5598.jpnprd01.prod.outlook.com (2603:1096:400:45::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8746.31; Tue, 20 May
 2025 03:00:22 +0000
Received: from TY1PR01MB1562.jpnprd01.prod.outlook.com
 ([fe80::d9ba:425a:7044:6377]) by TY1PR01MB1562.jpnprd01.prod.outlook.com
 ([fe80::d9ba:425a:7044:6377%6]) with mapi id 15.20.8746.030; Tue, 20 May 2025
 03:00:22 +0000
From: "Zhijian Li (Fujitsu)" <lizhijian@fujitsu.com>
To: Davidlohr Bueso <dave@stgolabs.net>, "alison.schofield@intel.com"
	<alison.schofield@intel.com>
CC: "Yasunori Gotou (Fujitsu)" <y-goto@fujitsu.com>, "nvdimm@lists.linux.dev"
	<nvdimm@lists.linux.dev>, "linux-cxl@vger.kernel.org"
	<linux-cxl@vger.kernel.org>
Subject: Re: [PATCH v4 -ndctl] cxl/memdev: Introduce sanitize-memdev
 functionality
Thread-Topic: [PATCH v4 -ndctl] cxl/memdev: Introduce sanitize-memdev
 functionality
Thread-Index: AQHbmGEPX45vEfoGLEGo9XmNHzqTj7PbNeOA
Date: Tue, 20 May 2025 03:00:22 +0000
Message-ID: <e2defa61-8a12-4b5d-87b2-1271222edf28@fujitsu.com>
References: <20250318234543.562359-1-dave@stgolabs.net>
In-Reply-To: <20250318234543.562359-1-dave@stgolabs.net>
Accept-Language: en-US, zh-CN
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Mozilla Thunderbird
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=fujitsu.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: TY1PR01MB1562:EE_|TYCPR01MB5598:EE_
x-ms-office365-filtering-correlation-id: 7419f8c2-2909-4042-062d-08dd974a7658
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam:
 BCL:0;ARA:13230040|1800799024|366016|376014|1580799027|38070700018;
x-microsoft-antispam-message-info:
 =?utf-8?B?NnBTbjQ0NzhHOTJFN2RxQnUxZEkwbUlVa0YzNUVyMUdLZ01IOWlndlBPaDJz?=
 =?utf-8?B?MUxEVGdpSE9qT0l6OXFhMXJUQnNoeXdNdDJPczd3MDcvWmhCbEI2U2p4eCti?=
 =?utf-8?B?YzRjLys4WlZGbGVaNzBoVFUyNDV4NzFQeSt5UTF2N0V0L1hvN2hIQlY3Mk93?=
 =?utf-8?B?SWxSeVNsamNISiswbzB3YjI2RGZLa0tVZ1E2MGdBRFFXdDlRRWVOenhiNlVZ?=
 =?utf-8?B?MkdRb0hxUEZSOXA5bUh6ZlZNRldHWlFieWZNU0VyY3RIT1g5OFpsbVJUd0ZD?=
 =?utf-8?B?RWx6Rk5HSS9lQWQ5d1pmTncwVFkvaXFodWY5RVgvamdUM2JrbVM4T1hEd2NE?=
 =?utf-8?B?RW1vc2xlMytCeGVRbDRNZlVZbkpyZGx3MmpDejBWaUFDQzZDY2FOSk4wL1c0?=
 =?utf-8?B?S1RxcCtVZzNPYTIveUQxbWQ2ZlNGU2xad3FvL1JPRkpBSHJPK21uVnQvUzRT?=
 =?utf-8?B?YUJoenB4MnRRTzZjaXBkOXA3SUhvN1U0U3Q2VGtYR2JrZ3p4bXphY1lBVE5q?=
 =?utf-8?B?ZktyZzhSY09pUTRDQ2Y1T09CbVRhbVdSUFYxTmozaGpFbkRCcXhFV3d3bXhD?=
 =?utf-8?B?OG95RkluUXBKdDI0OTRXc1BmeTdLTzNqYnJTdDR3amxpekxLRWFNQTFjVmFi?=
 =?utf-8?B?QjhNVmtEaUlWWCtUOEFBUUZxekZ6TWNFWmtMMFhVV3NCb1FVcDJyOTNQZWJs?=
 =?utf-8?B?QUgxOEp4U3ozb3E0RDd3TmV1R2d1dEVVTTk0THBTUXdHcm55VHJjMys3dTha?=
 =?utf-8?B?ODF5N0dZYjBFaDlkWjE4Z1ZGTUE2MmV2UnNYNjZGVlFaTEZIZ0tuaHZJQkJK?=
 =?utf-8?B?YU0zUHVoVGRKb0EyOUxFU3dUcFh2TktSdFUzTjJsNHhLOVRxRTdtb1dUclY1?=
 =?utf-8?B?OVdBaWxHZWJoQnNiNHZMQ0daSGVUNm9XNm5BMUVrY0RHVzhLUmZlcGllcWNU?=
 =?utf-8?B?RWlmUi9DQk9Xa3RHSnErRVNzdlIzVnlZVDA5QUhrZzkrVFZIbWw3a0d2KzJl?=
 =?utf-8?B?bmR1RmQweUw2c2RjdTdOa0h4ak56NkJRSEhJeTBDZ2hNQjY4RWxLK2V1NE9l?=
 =?utf-8?B?T0sxZENwOGtydzY2SDc4QmFzU05PbDNrTVZhbVVjampQUnl2ZVRjR2JheEta?=
 =?utf-8?B?RmtZNFRoTFEwYzhRcGRQSXZZZjBwN2w3WFk1K1pHc2I0U0VJV3BNbE1KaU1E?=
 =?utf-8?B?dXQ2ODBUKzc4cG1USENiUFlsNng5VmswM0FES091QytnQitDWlN5NnV3THNh?=
 =?utf-8?B?SW1zNi82RTJ3TjE2TmQzMkhyREpaSklaOFhlQmFzSjlFOE9sbk1nS3VrQ0Vn?=
 =?utf-8?B?a2VEQVJqUDMrWFg1WXNsNUNENWhyOU9icXlFazFmRXdBYXBUWEdSK05BaEU1?=
 =?utf-8?B?ZlM2dGE4T3Y1ZFcvUU5IYndWY2ZZeDg1RnFsdnZBZmJ5Y1Rmb1N4YUhkbmVX?=
 =?utf-8?B?WDc3cDdJVFpqMWQwR1A2KytlZmhWc3hYRHRiU2ZlYU1vZUlJU3BPWkJNZTcy?=
 =?utf-8?B?cHNDRmxWTUg3K3VJWU1BOWppQ25OSjNiRjNmYk9WNHJXODJvZ2ltbGV2eDBi?=
 =?utf-8?B?b3lyVHJuVjlvRFB5RjFFYU0yeWNFMUJQaVJUNnRjS0ZxMWlIb05WeklwLzdT?=
 =?utf-8?B?Z0s2enhuQi8raVFqNXVoVlZWaGYwVmtxQzNQRVpxOE4zSjRMK25jU2Mwcm9Q?=
 =?utf-8?B?M3p4aktJZ3o4Z1B1MCtHdUZ5SWJPU2R5L0ZaYlZBT1E3TGRLYkN6d0hocmtH?=
 =?utf-8?B?VmpPdGZ2cHBXYkZZRTR0VXdRUGNualg5NVVlU2hTZDVZVGFpWWlBOXBjRUlY?=
 =?utf-8?B?NW82Q3lKU2oyWDFNam5yRzltRzhOcitTazlSRFdPOWpMWkhoWmxIc0lqNE8w?=
 =?utf-8?B?WnJSZHRzZGNCeFY3ejBSbExBelJJL2ttNmwvTTIzd1h0TW5SY2VkVXN2VWJw?=
 =?utf-8?B?Z0hVVFFjbFVORzJkK0dXS0JZV2JiWU0xT1EwWDFOWk5wT2gydmNDNllkSDF5?=
 =?utf-8?B?bW10aXIvQzhyMnE5MHNLSTExREx6M0g1OHFpb2I3V3h0UnJZR1hhd0dENFln?=
 =?utf-8?Q?gaICkB?=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:TY1PR01MB1562.jpnprd01.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014)(1580799027)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?utf-8?B?Smw5RktENXFtMWovNld5dmFaQmlpRzFlZzE3a29mTzZiYlJxMzROSVYvc2RH?=
 =?utf-8?B?TElKSzh5bWc1UDAzdXNqcm5hdkJubE9nSGZueml6VzRLeXRtYkR5Q0UrV1BB?=
 =?utf-8?B?UjhsNFFVQXk3aksxVUF4Z0NzTnZuekxKRUhaVldlQWtFZDQyQ29RNFVqWXB4?=
 =?utf-8?B?aERpa3A1cE5JN2JKcjhzM2RpUllWblJuaUQvNkJPN20yM3F5aFZpWS9IdHlr?=
 =?utf-8?B?VThWbUhEVy91MlVxcEIrWHZseTZTQ2pxOXhJSlVLWWYxSFcrYzA3L0hHYTlL?=
 =?utf-8?B?M2ZDbEk2RktGVzZwSERpRDdmZU05T1JKb0tjTGNQRTlqNVdvWDRjbVVVVks0?=
 =?utf-8?B?eFpuK3cxYXlCNXg1S0l2MHBlZHAwRlJnN0hyYUZQaUptWWVtb05lb1Bsb0Yr?=
 =?utf-8?B?VGpLOW1zeGU3cUdLZVMraXBYNDhkUllQREh6bk1HMGdhS3NjM1A0NFlwbnBk?=
 =?utf-8?B?ZVBDYnNvN1loamlwVHBBdms4Tk12aWVnc3BGWTRFQUU3RG9INEhaMVBwNTU0?=
 =?utf-8?B?VlVWUjhvYVdoTWM3TXRqT1E2UzZZRVJNMVI5Z0JjYjJLK1Iwbmk4VmVrcU5j?=
 =?utf-8?B?NG1BRHFKOWxnL3J2SGlDNkJWNXZVOVp2a0wwOEtyNkZsT2xXeC9aMkZpemM2?=
 =?utf-8?B?dVUxUEpMUEVoeGR0RVZyZmFEQ3BFVUZHcTZFemp0bTB0WXY3YTRTUGkxd0xK?=
 =?utf-8?B?dkFGWmFaOGh2UWtaS3UxTlBjYlZFb3NGR1dJc2p6NSszMlA2b21ScHp0K2ll?=
 =?utf-8?B?YkVDUjV4WG50UDJ0Y09DS1Jvblo1dUFtSEs3cGxJMU9uRHFSRkhndHlhTlpI?=
 =?utf-8?B?a1hqOE9GQytYWnA3cEpxdXYzNGZTeW1jR1RPekwwYzdSeXpwMHN0YnNpc05u?=
 =?utf-8?B?ckpubXBGbzRSS0RTYzlDZ0tNbmYyWk9QSHB2clF4Um5uM3FNZ0NRNXlnYjVQ?=
 =?utf-8?B?NmpkTWpicXdKdnkwZkxpd0ZzSXk2bzdicHU4bnJmTW8wMkhhU0NYdFo0cjNj?=
 =?utf-8?B?aXRCNXdHV1dheWtWS1pCSWZUWnRGcnpqK09HRTU2LzNCSUFTY3RwL2IranhH?=
 =?utf-8?B?K21MNURTOG90NGF4TmVmbVlKVTd1d0pBVHUrZkhNQTJETDE2TCtYQ2JEVEdM?=
 =?utf-8?B?ZisvWTFyTmUxZ0xhVEhjNkZtZnJrNjBNbVRsNXFZQVpMUnZYUUZNV1c0RXhh?=
 =?utf-8?B?L0ZIUVZ2YlVsa0lFWW1VS1NQanBtNzFpZEZvUEZuL0VDQWVESEovaDloUnJk?=
 =?utf-8?B?OEJsVEVuSXVLcVZIMDMwcG9nbldZeng0WGFROEZybW5lbmRiQVJ0VXd6bmtI?=
 =?utf-8?B?S1hGUFlUdllDNHVoSjZqVHRtYko1andwNWVHaDZCTzVyUTc1NXJLWG9ONnRV?=
 =?utf-8?B?R2tOa2xYUkxrZVNDL2RuSmxBTW85eTB0R3l1MUpqbllXa2RaVi9oYThQaVhu?=
 =?utf-8?B?REdXOW9LaDFmZWdiWjdPdFd2cXAxYkVYZTN5YTVCRVJhWEw5cFhLcFkzZnJJ?=
 =?utf-8?B?STgxQkxodDhod1FnWFk0dG5NWG0zRmxJdG9RQVZCNEFxbTUrR3gzMnBKTkEz?=
 =?utf-8?B?cS8xSWdPR1BsbEdmSXI5dFhKd01OczByRDJITmtxa3JCbW5kWGtPRnU0L1U1?=
 =?utf-8?B?Vkd0QWZTNGRiVWRCenMrcFdJditIdFM5aG4xNjdVN2xrblVrbUE3c0xtejdY?=
 =?utf-8?B?UkU2eVZ4RHhzMVpOUFpiV1V5dWFacG16V1gyNXhlSkU2TFVlSkd4QkVMTEdC?=
 =?utf-8?B?dW1xUGxmdytQY3R0Ukl2U2dFcWptOUZVemxvOHlDeGtsRkQ5SmYwTDBIVlRn?=
 =?utf-8?B?WVNpU0ZaWXNYRzFVdkszVFpBa1ZaV1ZYRDJMK2pNNlFCRnp1NXhoM2EwOTJx?=
 =?utf-8?B?WUlzWUVQa1pkVFJ5VjZDUXBmblhKOXVjY3ZoWlduSWhoVUxBNDNMb3FKSHZ6?=
 =?utf-8?B?OUYvUktZa0R1eVpkWklnK1M5RDk1dzhQT2lsUS9FYmNQbjRSNEsybzhNcE1P?=
 =?utf-8?B?RUJqSTJGNkw4TXVlQk5CUWlPY1k1bGQ0WHBhQWxrWFpXYWZWUkVJU3ArWWhz?=
 =?utf-8?B?dUlrN3VCTFdiV09BaHg5S1hFRUtWTUNFMzhUTHYxb1o2MFRzc3h1cnk3MFQv?=
 =?utf-8?B?SGpzWGNiM0lHeS9IS1BnUGFsNG5kVGZKcEZhWTJSRWtaV3NlRk5DVDZXM093?=
 =?utf-8?B?Y1E9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <67020DFE6E2F6E45806B96FD54C53E81@jpnprd01.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	+JETJMRyYp1/68QFUFjuGnaqKnxTli5ZNp5IrN1uMuHjTeRFpU52+Cwg7JW1BRed22Vb8tiNGPso2TJA0fkICLLrLJHa0YzLQZdLXDewkJ9Hdo9nBQNF5CzBeP0su3cBkMruf03LYTnkZQ8mETr4wKwwig/zFyc8coEYcZNVV4j6KX5KXx20FnSXyG+pTj9Hz/3MCOiZa8BzehkeB5dLhWGp/HBh/KzNR9w2hlkwBcYWezPOf/wOIm3nClCjFtEiXXxokhRLQ5y4DDTIXAl2JqaWl5PiuB0Kbsjl2yiCDcueVVVUZLBJQiTyNAwOwoIUyLbxsWkcIdx1kly79+WaCTrT+GD+h004Hcax7UwCEvMdM8w3Aa9r6eyldOjUOe06Z1u5Jy/aVlp9vhzoeFaILGnre2wP283WGUqtTgXPDH4sNz28OAGl4SiT4LJYDF9r2KSeNKcNSsmv18eOOaUjpw9Oa+arvLbq+uf+YIrmJDC7yGqmwk0HutgoI0JbU/4Z64+six8F0K4COI7ojdcYBEBX82FzsAx1jDj1M4zTkVoePA9jI+uEr/EGr5ZcJLLjgWESyxTLOTdM/kIDkYLxcxjGvQ/5z2ItUR3VTQMU8zQ2goktDCJ/Ayg43QFjAZUp
X-OriginatorOrg: fujitsu.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: TY1PR01MB1562.jpnprd01.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7419f8c2-2909-4042-062d-08dd974a7658
X-MS-Exchange-CrossTenant-originalarrivaltime: 20 May 2025 03:00:22.5075
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a19f121d-81e1-4858-a9d8-736e267fd4c7
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: WOVzNeXx0w8lBSQrPiVh/yAP8LueHwZ3+Ji/TyutZgZWF+EKRRxiJZWdGzcM6DtM8VEMPsdnmFvwtnT1MudlbQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: TYCPR01MB5598

DQooUmVzZW5kIGl0IGFnYWluLCBteSBwcmV2aW91cyByZXBseSBkaWRuJ3QgYXBwZWFyIGluIHRo
ZSBsb3JlLmtlcm5lbC5vcmcpDQoNCg0KT24gMTkvMDMvMjAyNSAwNzo0NSwgRGF2aWRsb2hyIEJ1
ZXNvIHdyb3RlOg0KPiBBZGQgYSBuZXcgY3hsX21lbWRldl9zYW5pdGl6ZSgpIHRvIGxpYmN4bCB0
byBzdXBwb3J0IHRyaWdnZXJpbmcgbWVtb3J5DQo+IGRldmljZSBzYW5pdGF0aW9uLCBpbiBlaXRo
ZXIgU2FuaXRpemUgYW5kL29yIFNlY3VyZSBFcmFzZSwgcGVyIHRoZQ0KPiBDWEwgMy4wIHNwZWMu
DQo+IA0KPiBUaGlzIGlzIGFuYWxvZ291cyB0byAnbmRjdGwgc2FuaXRpemUtZGltbScuDQo+IA0K
PiBTaWduZWQtb2ZmLWJ5OiBEYXZpZGxvaHIgQnVlc28gPGRhdmVAc3Rnb2xhYnMubmV0Pg0KPiAt
LS0NCg0Kc25pcC4uLg0KDQo+ICtzdGF0aWMgaW50IGFjdGlvbl9zYW5pdGl6ZV9tZW1kZXYoc3Ry
dWN0IGN4bF9tZW1kZXYgKm1lbWRldiwNCj4gKwkJCQkgIHN0cnVjdCBhY3Rpb25fY29udGV4dCAq
YWN0eCkNCj4gK3sNCj4gKwlpbnQgcmM7DQo+ICsNCj4gKwlpZiAocGFyYW0uc2VjdXJlX2VyYXNl
KQ0KPiArCQlyYyA9IGN4bF9tZW1kZXZfc2FuaXRpemUobWVtZGV2LCAiZXJhc2UiKTsNCj4gKyAg
ICAgICAgZWxzZQ0KPiArCQlyYyA9IGN4bF9tZW1kZXZfc2FuaXRpemUobWVtZGV2LCAic2FuaXRp
emUiKTsNCj4gKw0KPiArCXJldHVybiByYzsNCj4gK30NCj4gKw0KDQpjeGxfbWVtZGV2X3Nhbml0
aXplIGNvdWxkIGZhaWwgZm9yIHNvbWUgcmVhc29ucyhsYWNrIG9mIGhhcmR3YXJlIHN1cHBvcnQs
IGRldmljZSBidXN5IGV0YykNCg0KSSdkIGxpa2UgdG8gbG9nIG1vcmUgZGV0YWlscyBmb3IgdGhl
IGZhaWx1cmUsIHNvbWV0aGluZyBsaWtlOg0KDQorICAgICAgIGlmIChyYykgew0KKyAgICAgICAg
ICAgICAgIGxvZ19lcnIoJm1sLCAib25lIG9yIG1vcmUgZmFpbHVyZXMsIGxhc3QgZmFpbHVyZTog
JXNcbiIsDQorICAgICAgICAgICAgICAgICAgICAgICBzdHJlcnJvcigtcmMpKTsNCisgICAgICAg
fQ0KDQoNCk90aGVyd2lzZSwNCkkgdGVzdGVkIGl0IHdpdGggUUVNVSBhbmQgQ1hMX1RFU1QsIGl0
IHdvcmtlZA0KDQpUZXN0ZWQtYnk6IExpIFpoaWppYW4gPGxpemhpamlhbkBmdWppdHN1LmNvbT4=
