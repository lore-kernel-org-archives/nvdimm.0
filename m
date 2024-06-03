Received: from esa14.fujitsucc.c3s2.iphmx.com (esa14.fujitsucc.c3s2.iphmx.com [68.232.156.101])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0A82915C3
	for <nvdimm@lists.linux.dev>; Mon,  3 Jun 2024 01:27:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=68.232.156.101
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717378077; cv=fail; b=OA/+S6yWzf9RMLzVGSTxuA6x075A2ZKY/fxaPEBtPD/RbssHUxQa890QwsaSjjBs9Rd/opvomPDwWbkh6zy3Llz1TaEcmqT0e5lBjH+FMaoDbM3HibnXVYmJ8kOXlwoQSjdmBUIK6Z1+lrtO92sm1XQ3Lruw6E/WfIXVNKaIBZI=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717378077; c=relaxed/simple;
	bh=kVTcKMl61+rkB8ejh0n+oDTVBgEIhe+P5WhGDrvuXZ4=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=HjVQqFcnfGnzbUy7FNSZTb7PiX42Jkyq0dr3bbb0OK1sDx4Q5KLy7TnjNyOfb4Iq34mfq83re2C9hKC8xDDOsr8H7z1Up3xNfFkK/qTV+HJPHVRkfAWphrc+CpwqOPO5+NBrtQke4qE00KTnlzNnfMG81Y8nQuk172r1fXaxhK0=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fujitsu.com; spf=pass smtp.mailfrom=fujitsu.com; dkim=pass (2048-bit key) header.d=fujitsu.com header.i=@fujitsu.com header.b=tbjDW6CU; arc=fail smtp.client-ip=68.232.156.101
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fujitsu.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fujitsu.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fujitsu.com header.i=@fujitsu.com header.b="tbjDW6CU"
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=fujitsu.com; i=@fujitsu.com; q=dns/txt; s=fj1;
  t=1717378075; x=1748914075;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=kVTcKMl61+rkB8ejh0n+oDTVBgEIhe+P5WhGDrvuXZ4=;
  b=tbjDW6CU75Zzd/lF0wuRdUNquxG0+3b+enfJ1TS61YkTRo+4s4gO7tqK
   NnxdM9/Acnlw6iwp/WH4yQkvMbXgxXzeSAjmSLvV2GQbKfSoVj3V9JkuC
   P0BPHDKc3/n7QsOAwxB/LAwnfZHfWSZKp5zlA7oMojcovelEvklcg5sCM
   JRnJ3zjm2oZBzNmnhF4cWG+PNRRleO+0K20vpOxgFu6LG0s4rHFkMYyaP
   nmw0hhqxGbLn1kXFfZIFbyn5eD1hbeGWoGTaEJ+EqarQzo6hrjx2GuTby
   fzoXbro5eIZTFFjWhWKOMqMkGBJBr+jsRjBavBCNMCW8jnZybZ34T0Bnc
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,11091"; a="120699272"
X-IronPort-AV: E=Sophos;i="6.08,210,1712588400"; 
   d="scan'208";a="120699272"
Received: from mail-tycjpn01lp2168.outbound.protection.outlook.com (HELO JPN01-TYC-obe.outbound.protection.outlook.com) ([104.47.23.168])
  by ob1.fujitsucc.c3s2.iphmx.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Jun 2024 10:26:43 +0900
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=DAGbKX9X4RQTmq6wGfOWm+JPYH5rroIpTqOZRq7JQgow366LyCRL/gtIq6wt+BRdH8/+3Vn6/WS8YzsJsBjOrr7MZzrV2LKrm1FwAp3ZELNq8NRiWuuBfXdpsrzeXncIv869Z39q7yciqEg9TY0l1vsgsCj+S/07SHuigL9z8LLMjnnbk+/nHN3uQBQPEIRvL1zHxAExelJIQDvRMymICVeNsG14wYfwdfi1LkZves3kwILmOBDTIabABgBYYspHaul8IeWcese7ugDPnrNr3i/JO8lOZhdFky/rZmmZzJykr7E7isMBZKHgZ8xVkbXV8GmvHgyG16fimLKhyW/ERA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=kVTcKMl61+rkB8ejh0n+oDTVBgEIhe+P5WhGDrvuXZ4=;
 b=nVjxlH9lWUjc1VS9kQ/EQ76E2zQlP4HHsAXC+qE7CEzkGwSW96nWzSRAH4OBIpRn+VsvdGLTrpDr9PAxMr0RyQByuqzqbR+oVnGbl8KPvZW3hWbG0nT4P6Nj/KT9jFeBgvZR8tWm4UhnYL1NWDM91m4Pe5bZWuT04amkWJ7P0wdoExfGZMXkunzGM8zqGYxX/6kPqwJcP5RwNLwfwvnCqRK2UFsos3vyxmK1Ty2wyGrM6gGn1bq4W0il4IraHI/iTwDn6zdyr3z1gh59aV92QdizdOAb2M5uT4QaONsLJhV6MiWcltgdvx3U5S9K5/fTvEMtAGykXxTx2G5hFbyhyA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fujitsu.com; dmarc=pass action=none header.from=fujitsu.com;
 dkim=pass header.d=fujitsu.com; arc=none
Received: from TY1PR01MB1562.jpnprd01.prod.outlook.com (2603:1096:403:6::12)
 by OS3PR01MB5879.jpnprd01.prod.outlook.com (2603:1096:604:c1::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7633.24; Mon, 3 Jun
 2024 01:26:39 +0000
Received: from TY1PR01MB1562.jpnprd01.prod.outlook.com
 ([fe80::d9ba:425a:7044:6377]) by TY1PR01MB1562.jpnprd01.prod.outlook.com
 ([fe80::d9ba:425a:7044:6377%3]) with mapi id 15.20.7633.021; Mon, 3 Jun 2024
 01:26:39 +0000
From: "Zhijian Li (Fujitsu)" <lizhijian@fujitsu.com>
To: Alison Schofield <alison.schofield@intel.com>
CC: "nvdimm@lists.linux.dev" <nvdimm@lists.linux.dev>,
	"linux-cxl@vger.kernel.org" <linux-cxl@vger.kernel.org>
Subject: Re: [ndctl PATCH v2 2/2] daxctl: Remove unimplemented create-device
 options
Thread-Topic: [ndctl PATCH v2 2/2] daxctl: Remove unimplemented create-device
 options
Thread-Index: AQHasyP91LA/gWJvDkyFWhccHIm/6bGx4MGAgANjHoA=
Date: Mon, 3 Jun 2024 01:26:39 +0000
Message-ID: <371543d7-5e94-4a33-bc69-086b27889de2@fujitsu.com>
References: <20240531062959.881772-1-lizhijian@fujitsu.com>
 <20240531062959.881772-2-lizhijian@fujitsu.com>
 <ZlpEaV9F6fXKv2Vm@aschofie-mobl2>
In-Reply-To: <ZlpEaV9F6fXKv2Vm@aschofie-mobl2>
Accept-Language: en-US, zh-CN
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Mozilla Thunderbird
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=fujitsu.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: TY1PR01MB1562:EE_|OS3PR01MB5879:EE_
x-ms-office365-filtering-correlation-id: 534f4589-90c7-4228-072e-08dc836c3794
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam:
 BCL:0;ARA:13230031|366007|376005|1800799015|1580799018|38070700009;
x-microsoft-antispam-message-info:
 =?utf-8?B?b3BoQU9lMFA2b1hRMTJ0OEw2QWl0MmRVZEdTUHFSNjRGRmJ5ME1jVGZDUzBU?=
 =?utf-8?B?K1dia1RuNklzNC9mWmhnTkl1dC9FSExpY2F5WEVwcXdIeGtRNXdLRnAyWEVS?=
 =?utf-8?B?SStLS09yL2FFTHRoV1NmNlVsSlcyM1FhMytadS9jelNMeExTTWdqRkZRY0cv?=
 =?utf-8?B?VFE3Z2hrYytLanNHN1J3MGFXaG1TTHcwQzNiUG11MEg2WHhoUHlLQXJvRUdv?=
 =?utf-8?B?WHJseWVBUHlBZmwrTmc0UktYTGkrQmJENk0xUlpxdGN6N3hMN01BM2RackRQ?=
 =?utf-8?B?UmtTOHY3azRnS01pSGUrQ0FiSmMvZUxVU1FoVm12OGpCVWV6WWVSanR2c2ZJ?=
 =?utf-8?B?eFF0dlVlNUJpRFFaSy93bTgrZWkxTytneUxzdUxRZldjbzJiS0lDQUJSRVI2?=
 =?utf-8?B?aVhVY29SZ0FMQ1FpZFZzZ3pCTXlTMjRXK2U1YUtPU2VsQWRoODRKaktCdncy?=
 =?utf-8?B?U1Qya0RiVkVyMmorNEN6MWhZdDFnU2cxVC9wNThUV0kwUnRHNm9pR0JKOGFq?=
 =?utf-8?B?c1R4SS8xNERUSlZjY1RuSGhYNlMrazZIc2hFUUswaWN6TDJlQ2gyQnNoVEl3?=
 =?utf-8?B?V0l3aGtqZDhKb3BLUEd1TDhURStBSjBsbXJ2b1dHM3JpSGtjMU9sZXV2cHVL?=
 =?utf-8?B?Q2xmWlZSRE1QTk9JYzJSbStXWjBwbndndFRiaU4xeGFVTHZCVTRvNVhZaklX?=
 =?utf-8?B?b3c4NjE3M3c1a05jUFlzUXphZ3ZTMHpsWHdjV1RNZGE4anRFWHZLUHNmMjFz?=
 =?utf-8?B?c3hTNUFkRkhGSVBIKzdPR2VpNUJVdyszbmt0bjFVQnphcDVyY0s3MFFKUWt2?=
 =?utf-8?B?RGNXVjhuNitSM3gvTW9YejFOak95b1IzV25aSTBhRU9KdFJCQ01LZHowR0VG?=
 =?utf-8?B?bDd4OWU0U0RsN3pmOUZXSXNzWjQ1Z1hKUHVsaHRLcnJ5ajJkUVRQazI0NkxG?=
 =?utf-8?B?ekxNdjRMMFZxZjR4V0ZhZ0dyWjQ4Z05VV243MjFYeTBFNDI5dWRNWFdhM0ov?=
 =?utf-8?B?WXpZR1dMMkliZzZzWE9HbmYwUkpCNlZrTW9iWHBjbEV6cTQ0QUxkSmx0b3cz?=
 =?utf-8?B?K21wa2tubi9JWGRLRVkxTWh5ZDFTSkE0NXlTUkxETHVyakpCS3ZhTTNMclFy?=
 =?utf-8?B?NDBpWitDem1lWnR3c0pvMGdydDhwSjJISjcxeUtZNDBpclVmSU5TMHJHdU90?=
 =?utf-8?B?SzMvbDVrclhMbXNqeEp2bHpJN0VBNk1kaWd4LzFvaER5S2F6MUpPQ00yZzBB?=
 =?utf-8?B?UllLZFdGME1EYVRSVXpPcG5TTHh2UmE1VmhEZHRLZGxOVCtqWU9FY2FScGVR?=
 =?utf-8?B?aitma2kwU01xWHFUUFN3WCtHR0ZKT2R6dEt5NVZSb1BWMGpteVhPbUJ6R3ht?=
 =?utf-8?B?UTNISXBnUm5SditFSDI1VlQyVXRiM2ZTU053Lzl4SEJjc3ZjRHU2OXhNamth?=
 =?utf-8?B?VEswbHFmaWw3dVFqN0orMHNJWWVlVU9BTnBBUkd5c3VETUtma1VabW1GU3U5?=
 =?utf-8?B?NmMzVE1jZFJKUFp3bXpCODVkd3BRdHlUdU1hdFFjK0k2V1ROWnlYVFhzbVYx?=
 =?utf-8?B?MVZIMzNZNks1WVdlajd1bzhTNkM4R0JLT202aGdwWnRjZmlxTWJ1c1krU3lr?=
 =?utf-8?B?SUsvQU1FMDg2K0xFRmF4eEQrOVMrY3llUXYwcDl4WjRPRDVYZllTSHgyZzdw?=
 =?utf-8?B?M3RwMFBqeWYxSWlVWlVTaGNRSVVzbVVpYTI0SnBaSjh2Tk1QMlk3dmxNWEVp?=
 =?utf-8?B?QVNyRkhCK3V1QUZVVVhFRmN4WVl5b0h1Y203SHNodGVIRHRZbUp6WEtwVXpF?=
 =?utf-8?Q?xKpBjD0QzAJd8LZWFp5KQh5/6Z8foI9SqlIiA=3D?=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:TY1PR01MB1562.jpnprd01.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(366007)(376005)(1800799015)(1580799018)(38070700009);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?utf-8?B?N3ROZkFXY3NCZ3VhaWZWbWdFaVVFQmUvVTFuN1FGVHNXZGJxdkt0U1E0VEVj?=
 =?utf-8?B?NGErVm1MWERQNms1b1VBQTY5bTFhWDFrQXVxY0N1N1BjTUNCRmkxME1JblRn?=
 =?utf-8?B?dUNJZ2RhcUFlVSt1djBBQ0hiRDRTcnljamE5R0NqVDNGOFp2bTU1bFM3a0l4?=
 =?utf-8?B?bnNFbDFFSWUwcmxGaTkxNGdZVS9udWQ5bkhUaHY5eU51Qm0yelZjTkU2QWpE?=
 =?utf-8?B?TG5kV0lsUmN2NFdjdkVQb3lxaGhydG43aTZNblR1Nkw2UzlnQXlJRGFmNmhh?=
 =?utf-8?B?VXFxRy9LZEdUeWpqSDc2S1JxVXVSaXp0NU85RWJuVzc5eTJoVDlPTTNxU21k?=
 =?utf-8?B?QmthbXRKQ1FValZsMlRYQ1FkOFJmUnJoTVpzZ21TeG5taUk0QVVMWmtzbEl2?=
 =?utf-8?B?WTFJV2dIOVlVR1FwakhaMkRXMDRjOTFFOVBmRDBvT2I2Um9sdWJTVVh5UnRa?=
 =?utf-8?B?MUl5S3VEbDlMd3V4N09Fc1ZEZllSOTNYb2NDYVlZU2VqMWxJZ0N5STFVdk55?=
 =?utf-8?B?bnZZdXZ1UFhDWEhGZ2hQRVRBYStYSGNLRWVPRjFFajdXTUhmNUY4VkE0cVRT?=
 =?utf-8?B?Qnc1bWFobWhIMDNNTWhmQ01IakZjcHBPRWZYWFJpMXEyT2Z6aXpkc3dUdFZh?=
 =?utf-8?B?K2pTZkhpWXBYaEtMWlFtNFZBN1A2d3k0Y2JMbklsL0ZyVnBFUVNoOFI5Uytz?=
 =?utf-8?B?VkFoWWtRcnc1dGI2dGUzUEw1SmxtdnhGUDgzOTcxVXVhWERIeXBOR3FkUkxz?=
 =?utf-8?B?a2tlejNrRFF5Yms1TCtqNHFVcGE4ZTZRVTB5clNKdktKeXA4MHMrL05DRlgv?=
 =?utf-8?B?Z0ErNVJDSVo0SFFUVGFKRjEzUUljS2RLMkNRNHViSzNDdDMyTUJhU0c1K2t1?=
 =?utf-8?B?cmtyd2ZBd2pGOWR0Nlh0SUwxOVBpd1k3ZDdoUXRtdTFaVXlKTXg0eGo4K1lr?=
 =?utf-8?B?OThPUHpnUmRzZC82TVRUUWljdncrZmVMeCtJalRtVmE3U1V3RFBpVGhTTWlU?=
 =?utf-8?B?Qk91ZHlyRXhEdml6ME1JQnhydE5RTWsrSkQvN3g3dGl4VXgyeEEvU2wwRWIr?=
 =?utf-8?B?L2ltOGhDc21jbzlRcHpFTTRod01ObmxTTEpBTm9YNmc2KzdyYTYwR3Ezb2oz?=
 =?utf-8?B?YW9DQndGQmd1YzV2WmhDVmp5VFd4QS8vTW55SWo5Tk9oUTZVNFJZQUFOR3Rn?=
 =?utf-8?B?K2xlK3I2YjdEZFBsd04zcTZKL2NFaDhlUkQ0aHFmb0xsNlpWQks3eTN4OVRu?=
 =?utf-8?B?dFZkQjVUdkpxSkFEOE43SkpRc2ZpM3l2NmlYc2lBcDJjeXFTUmpxdFpTZExr?=
 =?utf-8?B?VnNBZFYxbXhmWkd6SHlFOXo2S3diNnFhNXl2TFU5b1ZmdEo5Y0RzMVN6Umd4?=
 =?utf-8?B?UDRVZkRYUW1WZHZveHRrcjdlNmgvQ2Q0bytPT0pyRU1yZ0VLcC8walFGM1Va?=
 =?utf-8?B?UUJIMWVraVpzTlVobnBydTBBN0I1U2tjc09KYWErZHBpK3IwNXNjQWt2Vjlk?=
 =?utf-8?B?Y2w2UmxJalNYTzlIQkt0eUNpZWZYWm9udDFCUnJDclZIaTh6WUE1Y3pxcWkv?=
 =?utf-8?B?R2Q5NFBUbEViYm5uYnAyc3hxWnBWZngvQ2hQektOSU9hYm5oVkcxMVdNT3Fn?=
 =?utf-8?B?S3owQXBMN1kvTVZ1dHAwamZHc05hRXl6NjVwM1kvSzh0cldsUzQ0c0dkeUxa?=
 =?utf-8?B?ZFNtRGI0T0E5Uyt4ZlRiVzZ4UlZkYzhEelB1TklwS0M0TXJCNklObFNydFVC?=
 =?utf-8?B?NE85V3QyckhsMi83NmhIZ3Y0aDRVQ015aWVoVFFDeU8rM0ZxTWNHeDVOc1pl?=
 =?utf-8?B?T3RlcTdEWU9yNTJnUmxUaEVpOHc5VUoxVlhlelRhRTBVekNidE9aVnZPemNq?=
 =?utf-8?B?a2piUHplS051L2FmRHhSYnFGamlaTDB6USthSlNsTHRtalZDUkQ1anhOdmJr?=
 =?utf-8?B?TjJIM0h4NUsvWkN2cHp6QzBOV2dBeHdrZkc1WVdZYkthbVBzQTBlTDk4L01Z?=
 =?utf-8?B?NldBUU1zVnpJWGYySTlzWGxBaGJzU3F3V2ZCb2l1WHBLZVN1NjJqbTBCZGEw?=
 =?utf-8?B?dU1aK0NiNGR4UDA1Ry9jSVJTU0xjdThMV096VHBlQ0IxNTdEUkxJb25nUXpl?=
 =?utf-8?B?NHhyQXNIdEJxVDh3QkZrOS9WZ1VkR3pTaUdRb3F4WStNTXlVR2dTRWFzOEpP?=
 =?utf-8?B?Z2c9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <7254AF7197081C439C051A2901707A57@jpnprd01.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	RxuZ9xEyLKW17aHfiYgIySKDnkKQu5YGrGwxmyBIhz206Ne6lCxmezB0Gnh3ujXyvJ5/9UsKMkU98L4UHZk6YTn+oKc+Rt9Z6QfjTm9fuFfsqzuTEUpAsJeM3KgA3ivb7jFQsuxkgaupPddR7uvrrabpog9hCZeRaoAZbDBdsTmvhQw7G1D5m7RikBDQOJTFWT2uHPox3TQMOMXlDx+ewHmbyml8P45RnU2NceI8GZXBd5Pf+Qr4fNEqgAg4l22wES9z8xpf9SkgZu3s5mNGeQg2AlVJNjEmisWsmEP1Bf/BRO7K4jRWnm4aPfV3O1EmZLdtmYQdEDdfGeN9odbbYoeDSvR/ILACJ7YodfTBiYHJ+1O0yLoMuAXQ2XFvuz+0diUMp8QS8+Tm5R0Lqdbz+itTq6SEW/qNNnSyV0JA7GUkc6Xxk8dyZIBB5Eo8zhtT5DUq8DBQwIupu+SDQMP18r+yLKiIk55O/v5ESKpq3mbXqx/f2YmqFdSynA8vjUR+YRGx/rj2dJUw4K/GZmeL0WGLNbHtD8pWv9Hisy88yXyC1+YFtp7BoXkujHL1kzkNNp/73g6Rx4Zif96Pbqc007HXef3+80YcXVPuu6lnI/nJjphTzaTmoJSbWiAaDRMN
X-OriginatorOrg: fujitsu.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: TY1PR01MB1562.jpnprd01.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 534f4589-90c7-4228-072e-08dc836c3794
X-MS-Exchange-CrossTenant-originalarrivaltime: 03 Jun 2024 01:26:39.1862
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a19f121d-81e1-4858-a9d8-736e267fd4c7
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: blp6JKdL8VB/kYSSEGDyQGWGoq3VJ+Cq4NWGkpC2GMe6BNDBAEA16kGQ5hyo1MOwZOQMWfkDs+d9sGQCms3SQw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: OS3PR01MB5879

DQoNCk9uIDAxLzA2LzIwMjQgMDU6NDMsIEFsaXNvbiBTY2hvZmllbGQgd3JvdGU6DQo+IE9uIEZy
aSwgTWF5IDMxLCAyMDI0IGF0IDAyOjI5OjU5UE0gKzA4MDAsIExpIFpoaWppYW4gd3JvdGU6DQo+
PiBSRUNPTkZJR19PUFRJT05TIGFuZCBaT05FX09QVElPTlMgYXJlIG5vdCBpbXBsZW1lbnRlZCBm
b3IgY3JlYXRlLWRldmljZQ0KPj4gYW5kIHRoZXkgd2lsbCBiZSBpZ25vcmVkIGJ5IGNyZWF0ZS1k
ZXZpY2UuIFJlbW92ZSB0aGVtIHNvIHRoYXQgdGhlIHVzYWdlDQo+PiBtZXNzYWdlIGlzIGlkZW50
aWNhbCB0byB0aGUgbWFudWFsLg0KPj4NCj4+IFNpZ25lZC1vZmYtYnk6IExpIFpoaWppYW4gPGxp
emhpamlhbkBmdWppdHN1LmNvbT4NCj4gDQo+IFRoZSBuZXQgZWZmZWN0IG9mIHRoaXMgaXMgYSBj
b3JyZWN0aW9uIHRvIHRoZSB1c2FnZSBtZXNzYWdlLg0KPiBJIHRoaW5rIHRoYXQgY2FuIGZpdCBp
biB0aGUgY29tbWl0IG1zZyB3aXRoIHNvbWV0aGluZyBsaWtlIHRoaXM6DQo+IA0KPiBkYXhjdGw6
IFJlbW92ZSB1bnVzZWQgb3B0aW9ucyBpbiBjcmVhdGUtZGV2aWNlIHVzYWdlIG1lc3NhZ2UNCg0K
U291bmRzIGdvb2QgdG8gbWUuDQoNCg0KPiANCj4gSSdtIG5vdCBmYW1pbGlhciB3aXRoIHRoaXMg
c3R5bGUgb2YgcGF0Y2ggMiBiZWluZyBhIHJlcGx5IHRvIHBhdGNoIDEuDQo+IElzIHRoZXJlIGEg
cmVhc29uIHRoaXMgaXMgbm90IHByZXNlbnRlZCBhcyBhIHBhdGNoc2V0Pw0KDQpEbyB5b3UgbWVh
biB0aGVzZSAyIHBhdGNoZXMgc2hvdWxkIHBvc3Qgc2VwYXJhdGVseT8gb3Igc3F1YXNoIHRoZXNl
DQoyIHBhdGNoZXMgaW50byBhIHNpbmdsZSBvbmUuDQoNCg0KDQoNCj4gDQo+IFRoYW5rcywNCj4g
QWxpc29uDQo+IA0KPiANCj4+IC0tLQ0KPj4gVjI6IG1ha2UgdGhlIHVzYWdlIG1hdGNoIHRoZSBt
YW51YWwgYmVjYXVzZSB0aGUgdXNhZ2UgaXMgd3JvbmcuDQo+PiAtLS0NCj4+ICAgZGF4Y3RsL2Rl
dmljZS5jIHwgMiAtLQ0KPj4gICAxIGZpbGUgY2hhbmdlZCwgMiBkZWxldGlvbnMoLSkNCj4+DQo+
PiBkaWZmIC0tZ2l0IGEvZGF4Y3RsL2RldmljZS5jIGIvZGF4Y3RsL2RldmljZS5jDQo+PiBpbmRl
eCBmZmFiZDZjZjU3MDcuLjc4MWRjNDAwN2Y4MyAxMDA2NDQNCj4+IC0tLSBhL2RheGN0bC9kZXZp
Y2UuYw0KPj4gKysrIGIvZGF4Y3RsL2RldmljZS5jDQo+PiBAQCAtOTgsOCArOTgsNiBAQCBPUFRf
Qk9PTEVBTignXDAnLCAibm8tbW92YWJsZSIsICZwYXJhbS5ub19tb3ZhYmxlLCBcDQo+PiAgIHN0
YXRpYyBjb25zdCBzdHJ1Y3Qgb3B0aW9uIGNyZWF0ZV9vcHRpb25zW10gPSB7DQo+PiAgIAlCQVNF
X09QVElPTlMoKSwNCj4+ICAgCUNSRUFURV9PUFRJT05TKCksDQo+PiAtCVJFQ09ORklHX09QVElP
TlMoKSwNCj4+IC0JWk9ORV9PUFRJT05TKCksDQo+PiAgIAlPUFRfRU5EKCksDQo+PiAgIH07DQo+
PiAgIA0KPj4gLS0gDQo+PiAyLjI5LjINCj4+DQo+Pg0KPiA=
