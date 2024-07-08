Received: from esa11.fujitsucc.c3s2.iphmx.com (esa11.fujitsucc.c3s2.iphmx.com [216.71.156.121])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BCDD919B
	for <nvdimm@lists.linux.dev>; Mon,  8 Jul 2024 02:10:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=216.71.156.121
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720404649; cv=fail; b=rmMlGVC1kHE99eNw3Yh93d7Q7hdBpoxqkoHqaI3tbC3R/houLebgGP3bSYRzhvZQGxu2bQsO2rH0JxkUnWI+lxRPoAeE9e/Q+Q7Bfd99F0gPNLedgywJh7vMT9r3ZHzcv7EYFZ8hvpFY0KTNnbJNXTnfK4p9xMGHjH5I3qWAv2U=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720404649; c=relaxed/simple;
	bh=o03ssn4lldzmMgrKkazOpgZxjoumyBNDFqI3oWr3LDk=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=RWKgER1XIpK18YHFXulDWNdhF75go0QTnzKxi8ncMcG744ZUGUUQDSl75MF5fw2CAblQ59KpjW0kMM5WRiLnNmVNdLOwDS5VDGOqhArDKfYyGn/ScNYd2hNN+bPHWv4YhQ26hDwukSwD9JQ7jWcMWizdkhO9p7E3eyAFW+1xRj0=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=fujitsu.com; spf=pass smtp.mailfrom=fujitsu.com; dkim=pass (2048-bit key) header.d=fujitsu.com header.i=@fujitsu.com header.b=zscaZH3z; arc=fail smtp.client-ip=216.71.156.121
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=fujitsu.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fujitsu.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fujitsu.com header.i=@fujitsu.com header.b="zscaZH3z"
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=fujitsu.com; i=@fujitsu.com; q=dns/txt; s=fj1;
  t=1720404645; x=1751940645;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=o03ssn4lldzmMgrKkazOpgZxjoumyBNDFqI3oWr3LDk=;
  b=zscaZH3zRNysg9YTVR/HfClulyRkpWF6hEmGYm7TJoD4ctDA5d13SWZa
   /zpjQVZcXcvV1566fUU/tABpU86idWsNuw1nJGlT2DbPoGD7XqzdDGMWo
   3GjGe6/ykAwkPxCip9PIybfCgWG4/EksbqJigCtg1Nu2ir1Mha/XeaEh9
   CY8FFYzNYXaES7ohgwW6EaIHy3jZEb6oCDF5uaGRjwSjj0H4l+QG7EZ4p
   u7fj1wsPQ3pMygszgZ40ES+9L0wgThe1Svz3u+JYZgsw5IyRd5PORe8KX
   x9mPp7hKecBuj/EQok16G32+DqAvRq2on2v7Jtp+qdSCOYgCasjFvoMrm
   g==;
X-IronPort-AV: E=McAfee;i="6700,10204,11126"; a="125283128"
X-IronPort-AV: E=Sophos;i="6.09,191,1716217200"; 
   d="scan'208";a="125283128"
Received: from mail-japanwestazlp17010001.outbound.protection.outlook.com (HELO OS0P286CU011.outbound.protection.outlook.com) ([40.93.130.1])
  by ob1.fujitsucc.c3s2.iphmx.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Jul 2024 11:10:36 +0900
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=cjKZfwerl1kjeEKNgws6Wdqe/DMUVDP4WgqBJYsrPi+0LPwPEDt9cTOPrIyEm4/h5GgHl0H9j5dxNpkBl/chPxDznWZrv0D5KImjUVD2WtYpry4F4mdtn8akNG+9OVNVC0D4xwME5oDPeIvFp5nhG6IYvMz3IUsxcbuAhfhPOuproC935O0pGFAvJkf/lLTlEubIPf6qcmFuZ1oLJKaYHEiIBCbqIDa/NiJ6AyJXlu143hUH6AIu2EPK1mKPsyZ5v0XEhaeuzl9hG/BU8PfQZInB4PGEY5Fa1vlVC9P9rcsYR6R/tsEficHwfgEZcj9sABr8KIYEIZZt0pp13vPLJQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=9KeQNx+kI18tyZo7vMM8xpDTGprnXF/mngDTYGbAkBk=;
 b=SaDl0RxrasZjk8fm0ARnsAs3SAqqeZaOBzm9zhCuKITbzd+FZpMzrQU8KdpTZYRE1sxK9U22VHRuylBm0bDDIX46H5lgvy3edKWZWdV8qy/V5SchhpvtWhgjt1rJk6ojN0jA5U3th/zcPmzcSzBdxS8kmmGBir8IcJcmHFkXeM4s+m/SZhUMBVee/L7zVw0D8zQNAnApg9zh6CKdMXfl6TgGssXWzCV2wiXA5tR5zFyGAxIvBYZMw+b6f+Ob+llN+bKEFuqUdK2saHhmzzUkM2Dg95uXAwKvcvfQPyfDY4cYcDoPF9J2mspq81nPYVDjUu0waHjbEZxKMlaJNXhiyg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fujitsu.com; dmarc=pass action=none header.from=fujitsu.com;
 dkim=pass header.d=fujitsu.com; arc=none
Received: from OSZPR01MB6453.jpnprd01.prod.outlook.com (2603:1096:604:ed::14)
 by OS0PR01MB5681.jpnprd01.prod.outlook.com (2603:1096:604:b3::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7741.34; Mon, 8 Jul
 2024 02:10:33 +0000
Received: from OSZPR01MB6453.jpnprd01.prod.outlook.com
 ([fe80::9ef5:e83:9047:de11]) by OSZPR01MB6453.jpnprd01.prod.outlook.com
 ([fe80::9ef5:e83:9047:de11%4]) with mapi id 15.20.7741.033; Mon, 8 Jul 2024
 02:10:33 +0000
From: "Xingtao Yao (Fujitsu)" <yaoxt.fnst@fujitsu.com>
To: "alison.schofield@intel.com" <alison.schofield@intel.com>,
	"nvdimm@lists.linux.dev" <nvdimm@lists.linux.dev>,
	"linux-cxl@vger.kernel.org" <linux-cxl@vger.kernel.org>
CC: Dave Jiang <dave.jiang@intel.com>
Subject: RE: [ndctl PATCH v13 8/8] cxl/test: add cxl-poison.sh unit test
Thread-Topic: [ndctl PATCH v13 8/8] cxl/test: add cxl-poison.sh unit test
Thread-Index: AQHaz21O5H1P/0tKNUKoUy51VM1ba7HsGPgw
Date: Mon, 8 Jul 2024 02:10:32 +0000
Message-ID:
 <OSZPR01MB6453DFB0CA4ABE76B9A6595A8DDA2@OSZPR01MB6453.jpnprd01.prod.outlook.com>
References: <cover.1720241079.git.alison.schofield@intel.com>
 <4212bf9d89e31a17f0092b84da473de2abf554a2.1720241079.git.alison.schofield@intel.com>
In-Reply-To:
 <4212bf9d89e31a17f0092b84da473de2abf554a2.1720241079.git.alison.schofield@intel.com>
Accept-Language: zh-CN, en-US
Content-Language: zh-CN
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
msip_labels:
 MSIP_Label_1e92ef73-0ad1-40c5-ad55-46de3396802f_ActionId=f2f6d873-1023-4567-983a-6dba1a5a68a7;MSIP_Label_1e92ef73-0ad1-40c5-ad55-46de3396802f_ContentBits=0;MSIP_Label_1e92ef73-0ad1-40c5-ad55-46de3396802f_Enabled=true;MSIP_Label_1e92ef73-0ad1-40c5-ad55-46de3396802f_Method=Privileged;MSIP_Label_1e92ef73-0ad1-40c5-ad55-46de3396802f_Name=FUJITSU-PUBLIC?;MSIP_Label_1e92ef73-0ad1-40c5-ad55-46de3396802f_SetDate=2024-07-08T02:10:07Z;MSIP_Label_1e92ef73-0ad1-40c5-ad55-46de3396802f_SiteId=a19f121d-81e1-4858-a9d8-736e267fd4c7;
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=fujitsu.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: OSZPR01MB6453:EE_|OS0PR01MB5681:EE_
x-ms-office365-filtering-correlation-id: 4217a4b7-1e76-498a-1584-08dc9ef325e7
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam:
 BCL:0;ARA:13230040|376014|366016|1800799024|1580799027|38070700018;
x-microsoft-antispam-message-info:
 =?iso-2022-jp?B?RTNhT1htV1owYzJuYjdNbzd5N0VpS0FqVUtWK0ZaOU5FeUMwTmhMZDNz?=
 =?iso-2022-jp?B?YlZMazh2UFVCT0xZRDBhQTcxaUlianJ6ZUhkV3d1ZXZ0TGJGMDVxWFhP?=
 =?iso-2022-jp?B?eTkrS01IcGRSOFFQM1BtZmVuVWZVR1A5aTNrR3EvNFA4QjhYWmJqZ3Nr?=
 =?iso-2022-jp?B?NHg5aU1iaXpoNVFYLytvTmRkL2RJcjVxZGd1b2VXNkV0cUgvSGZhaEhm?=
 =?iso-2022-jp?B?MDBqV0R2SmZxbmROWWFycXg5U3NlUU45YnRjOHlRa0M2UkhIaDNOd0tP?=
 =?iso-2022-jp?B?T0N1WjJnT2ZkRC9KOUw1UjZHS2F1TU5ORzNYUitqSVcwUnlaQVllU0tw?=
 =?iso-2022-jp?B?RGhxMGtZN0F5UnRESTVWNXJwYkxNdi9ucTFocGdyZDA3Zi9HM3pCYVJU?=
 =?iso-2022-jp?B?S0RDSnNlVXNBL0JyNGxQMG5QRGEzSWxMVDV3dkxnQ1U1ZDdXNTE2UUls?=
 =?iso-2022-jp?B?QWFCWUNlYjQ3SjR5YTRhYlFDOFo5ZHpGa2EzdEtDV2hqRHV4Um5IYUN3?=
 =?iso-2022-jp?B?VDFyYk9MVVZPUHczMTdBK2pZNXRteitWTlVSek1jSXZmd3dPY0psMXRj?=
 =?iso-2022-jp?B?ajV5NG93ZEZuZnlyK1o3SVZNQ1J4akEwM1hRKzNqRDljMWpoeHlMakk1?=
 =?iso-2022-jp?B?eldNYUMwQnUrZlkxVzVFZ1N2K09IUVFJZ21QNFR1RmJBTWZreVMzbTNY?=
 =?iso-2022-jp?B?S0Y1MVlMbXhHUGg1eWk3ekNOb29Eb2RvT0FWU1FucndsOTFRRVJQL29E?=
 =?iso-2022-jp?B?L0xFZkxFQStTOHBlSDg5V0JlVWJ2blY5VXR0VGRKYXRFMmJQVm1hYlVq?=
 =?iso-2022-jp?B?Wi9ZNVVRWUZ4SStIVlpkQ2xKZHNJRmg4TXVKcmJmTXJvMlRZMXhIZWFO?=
 =?iso-2022-jp?B?NWp4UEdIaExnY2FXVGw5ZkZIWFRrd29GTVQrNEFUUkZMdmlQMEZJR1Fz?=
 =?iso-2022-jp?B?eUpvVUZXenprZ2sydXc3TDF2emVKUmtKZzBtbzN6ZkNoMEl2M1Q3RDZO?=
 =?iso-2022-jp?B?emRXRkVWQllodEYrUjZnM0x0WkduRjRUWCt1WEN0WXZkdzZxclZrQlI4?=
 =?iso-2022-jp?B?WExSL0xIbWduZThoN0FPRjVVSTFRejJmcHhmK2pQeGJrL0xNWi9OZDNq?=
 =?iso-2022-jp?B?SjltQmd5Qk5HM2JlUmtuYlIwRm1Zb1h6MzJiYlBlSklzL2tHNnpXcm92?=
 =?iso-2022-jp?B?TkdhSWZJU0ZoUTYxbVJ0RmoreGtCWHVTU1MyL2RKYVc1R1R6bDJ6Z2Ex?=
 =?iso-2022-jp?B?QzFCRUtLRWl5Z1lvWUZ1cFBURGx2ZERmTlRXVHpodUdkYmpJdkxDSElY?=
 =?iso-2022-jp?B?aEFvZDdYTVlzbUJvT252TkJkeTNubkZJc3AxRHMvK1kvQUNTQVo3aDFy?=
 =?iso-2022-jp?B?RlBCdUE4ZUJ5NGVYT2xtNXdqNzlZSytVUGJ1VDJabE8vSUlCN2lYREhF?=
 =?iso-2022-jp?B?MkU3OFppTEd6dkhza1M4SHpYQU0vNEQ1WjNyK3Jxd0hKZkk0VS9EWkJa?=
 =?iso-2022-jp?B?MmUzcFFHVVJPYUZ1d0p0SjdQL0tib2s4QVlJRUdLV1NHVWs0bWpkRWUz?=
 =?iso-2022-jp?B?OUt3RnBtZjJkNUJoRDE4RHJGbE4xZzA4WGovak0vTGVhZUpaMmxjd3hr?=
 =?iso-2022-jp?B?aE9zQzBCVHZwZW90c3lqZDJkU3ZKTW1ZL3FYVEowSDhQWWc3YnAyUlpC?=
 =?iso-2022-jp?B?OFRWSkloT1lxOWlHd2JIbGFNQ3F4NTFJV3haMU5XOW5HMHBQNEFRYVF0?=
 =?iso-2022-jp?B?UXEwN3JXSUtsa25UQnJWZlVNMFJKOFByT2gxdHFJRWRYNWJaeEFNdm0v?=
 =?iso-2022-jp?B?dHU2YVZNcG43RXFNTkNmQ1ZRNmltSWIwOEpWWHBOYi9HT3kvN3BkbkJN?=
 =?iso-2022-jp?B?RUFRRFlKd095U3NJUTBWbnNnaUYyNUd4M1JlbEhvZWZ6M2xPelc1UWYy?=
 =?iso-2022-jp?B?Q1pYZ1grVFUrdk5FNGZRY1dDSGl3QUNsSlMxbkprTGprNHpFL095amdX?=
 =?iso-2022-jp?B?OWEyYUFTOS83L25wUGJDMS8zc01SMkFFem9jOEk5SGx3dGp3TDJxN21t?=
 =?iso-2022-jp?B?ek9JdWJBdlpxbFdsUHB1UjlxK3ZFV009?=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:zh-cn;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:OSZPR01MB6453.jpnprd01.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(366016)(1800799024)(1580799027)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?iso-2022-jp?B?SUxDT2QrUXQ2NUJZV0xJbXRHNWg0ekN2VWdLRTBkN1l1VHJTbDdzNlRq?=
 =?iso-2022-jp?B?VWhjR0lXcWcrNnR2aGNvL2FPemtSWnZEQnVzRmh3RFpGN1pqckc2VGVl?=
 =?iso-2022-jp?B?RGQva3F5VFBZOGFVR1pTYVV1ZWd0MUpxdFlFYUtMNFA0Wm11SlRPVE1z?=
 =?iso-2022-jp?B?SEZFRUxDQWdMVTl3RGpoU3pERnJrWlIyaHhWSUJZV1lvT1VWeEZOZW4z?=
 =?iso-2022-jp?B?UTNGMmRlQlJNSE9pYUVRMVRMQS8wY0NUR0N0K05RajZHekZXVjNCcXBH?=
 =?iso-2022-jp?B?WHd3THhDWmhvL0tMcHRzbmtpR3VDWEJhbnA4VGdJc3NXdHFuZ2xvNVRR?=
 =?iso-2022-jp?B?WFRMeit4aitvUk9vR2MzOThtWEhoczhlVzVlUG85UlFiamxScWdaSXEv?=
 =?iso-2022-jp?B?NFFtcVVOWnc4R1RlZmVMYm1qRWhsZUxjcDB0dXVhMFBJTmRCc0tuK3Vo?=
 =?iso-2022-jp?B?bkJ1cmZOb2ZqWmJxTlNjVnRYYmJQY0pRelFFRDVaUVo1RDFxN1RWZndM?=
 =?iso-2022-jp?B?RnpQeXNyT1JDUTJGNTk4cEdLUExpWlErYzM5MXBxK2ZBYzB1ZXU5dkFp?=
 =?iso-2022-jp?B?Nmt6dWI2YktKQ0dwaGxndERpZFdXVnpJNDQ3dDl3VG12ZTNJV05jMnpX?=
 =?iso-2022-jp?B?SmpsaDE2cllkaFN2cDU4ZlFxL3RJMGwyWlZhWVdaaUl2NEU5dnJ4WVdP?=
 =?iso-2022-jp?B?R0thVDZnUWFTcVJzOGVObmxZNG51aExhLzBOUHZPU3dqRVR2ZVNmQldt?=
 =?iso-2022-jp?B?elRRWVM5c1hiV0Y2S1Y4aUt1aE1YcFZvenVhYkRuOUZVZTVRNWpLeXdQ?=
 =?iso-2022-jp?B?Y2p4WkxNUGxPQjZHbGJjZlVZSkc0bW5uMVErM2VVMjVMUVIralA1S2RK?=
 =?iso-2022-jp?B?OVRnU2pXVzhzWnc2U0RXSXY4WExYVGczQTNBTE5rTTMrYTFLUmZnMWpL?=
 =?iso-2022-jp?B?ZkY4Y1Ivd0xnMExHZVhMc2xaWmprTUt1SFVMVkoxb0svN3gwU2x1U0hJ?=
 =?iso-2022-jp?B?TEE4eFF2b2ZSYm9IdEc4ZVVkMHk3ZmViMjltK3RYbVpDczJNcmtmTVln?=
 =?iso-2022-jp?B?QnA5MVRKNTJPeFFvcDJTZUdTS1EwYld0bkNYYlRONmRsTWtKR2JHMFQz?=
 =?iso-2022-jp?B?NFpVbTVPU2poaFRCTkFNSXM4SXJRM0pSdVhXaDJ5djI0R0cyMXNiR0xL?=
 =?iso-2022-jp?B?em10MWV4VDQwZWRGTW5BTzZhcXk0Y2VhNENVdWE5TTJGWVFCUFBiUFhD?=
 =?iso-2022-jp?B?aFkva2lEOTFMd1NkMXkzb1M1RzJRSDAwaUdLZzAyZjBmTmpCZy9GaDh3?=
 =?iso-2022-jp?B?Nkt3S2hLdk5ob3dBR2cvY3BwVkJRZzRmTVBvd1RzeGU3UG5EejZ4RTJP?=
 =?iso-2022-jp?B?bTlBT3hIbzdzNzVyc3UrNjB4bElKanE1bXM2Yis4Mnh2V0VZTWdleFhE?=
 =?iso-2022-jp?B?SlhET3B1elZockMrVWxtc1NlL3dMUHZIM0xJQnNBQ1VjN1FXNDlmbXJC?=
 =?iso-2022-jp?B?dW01Z2J6VUVkWGc1TlJkUUxzaXI4cWRFOUFrY2NCS1IxTWxtblJYUVBi?=
 =?iso-2022-jp?B?V084SlorYmNHNnpxN1R2YUZnTFJuank3TjU5U2FaR29VWXUzYmFuOXBq?=
 =?iso-2022-jp?B?eWZiWmVFYytuL1g0U0NUbmdtMWYrWE1WSWdETlFaWndGT3J5RTkwNkxH?=
 =?iso-2022-jp?B?VUMrOElvQ2pJVCtrdDJYRlB3QWhVSG9WM2cwTEU3L3MwdUdkMXNhN2FI?=
 =?iso-2022-jp?B?OFpsNGRVelRER2lFTFpHUitnWG1DanoxeEhvYTlRalRGZ2NaQ3JBWHJt?=
 =?iso-2022-jp?B?SkdCQTBSN1ErY0VNU2FVaTQzVDY3dFNPYWorUWZCTGdiNGtSSkNYWUZt?=
 =?iso-2022-jp?B?MGVGOWc3ODRnZzVUb29TeENXeHdEWkxpc0V6QkF2RnB2a09MNWhOK3Vj?=
 =?iso-2022-jp?B?RHRkS1ZseFhCbFFtTFp4OTl3dkMwQTR5LzUxWlRqTHA5alF4MU1uQUdt?=
 =?iso-2022-jp?B?QTNyeVFoWDlPYm9zVEl0cng5ZEdrR0hqKzk4YVpsbGwzZGF3dzJJZnpv?=
 =?iso-2022-jp?B?Zk52U1l5VjNacDNtaWl6a1pseWpOVmVnVlFtZjE5WnJvSlZDNEVnVUFI?=
 =?iso-2022-jp?B?b3RwR1NHQ25HVTRzYkZWTVJHbDZ6eUFoNmhPZDNNcHArODh6V2ZNajhG?=
 =?iso-2022-jp?B?U09rVXcybVMxODI5OC9rQkRBVXliVVY3OXNCanRVQkZTMHo1ODZWemJr?=
 =?iso-2022-jp?B?RjVnYWN1YTAyZnNJdmU4YXpmdkhJV0hhT1hzRUdWTGRQRzZjOWJ1bXJ2?=
 =?iso-2022-jp?B?aFY1cA==?=
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
	MWnl48CJFjGHL2pRIFTNhcQlpPZvN2fF4iGSOJQJ2awVUvV47fWInP9W2wTdQybWlYpujI7cPcjmu/+30ppAORxBpvHpDbg05bRo2lWMr5d9znRiFLUsWjBI4KNLWUQFNlF7ZZs6HW121m5Qubz8IY6Wo9nAcNVdbcAfoB7t467sJtxIyj2OamgGCCDtEzrZDMbntcKkZi755Rt9f9uJkeQqA3/Y96YIuGUuTlIe4FUm+NIOno4daYvpVT/huhatOQhgNTPDtRFMvejKPYT0YGnElDfyNxO7mvXDnvIc7RbxyI4X0KvUl2YXolzYKK/aaP9g6ZHnxMisLL0DS+U/ZscgSRkRLPTbBR7aLX1JW4XQxHU1jz6/ITjdaaBof43uhEPVXTIbBAATwp6w8B/BJg+qQOn6VUP0qYxnkOOfs7PgDvB5OsQuP4JhYbl+Ve8EJBo0AX8DQpmxIuttA3TFPkADnSTMmGawdsoiR2h/D/MuF/+d3BrvQtCDOaDlewDQl4RQnPNcHmgURa36WfIMHLRxtqHgc4aNMW1Zejst2Tauit3GVq/4hamOSAdvExvjrWUX1stXfo1z6nSafuFrZ9WthRsyk08qCjC8wxqb9qJXVfb4P234Z37W4vvRYtJA
X-OriginatorOrg: fujitsu.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: OSZPR01MB6453.jpnprd01.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4217a4b7-1e76-498a-1584-08dc9ef325e7
X-MS-Exchange-CrossTenant-originalarrivaltime: 08 Jul 2024 02:10:32.9690
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a19f121d-81e1-4858-a9d8-736e267fd4c7
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: lStslkcXFXln5im2TM2c66PGz1PZHkm3yi8Op0A/ew7b7TiV9kPlzYbw0xie4yM2fFTjXDUWj7nThykZpByGSQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: OS0PR01MB5681

Tested-by: Xingtao Yao <yaoxt.fnst@fujitsu.com>

> -----Original Message-----
> From: alison.schofield@intel.com <alison.schofield@intel.com>
> Sent: Saturday, July 6, 2024 2:25 PM
> To: nvdimm@lists.linux.dev; linux-cxl@vger.kernel.org
> Cc: Alison Schofield <alison.schofield@intel.com>; Dave Jiang
> <dave.jiang@intel.com>
> Subject: [ndctl PATCH v13 8/8] cxl/test: add cxl-poison.sh unit test
>=20
> From: Alison Schofield <alison.schofield@intel.com>
>=20
> Exercise cxl list, libcxl, and driver pieces of the get poison list
> pathway. Inject and clear poison using debugfs and use cxl-cli to
> read the poison list by memdev and by region.
>=20
> Signed-off-by: Alison Schofield <alison.schofield@intel.com>
> Reviewed-by: Dave Jiang <dave.jiang@intel.com>
> ---
>  test/cxl-poison.sh | 137
> +++++++++++++++++++++++++++++++++++++++++++++
>  test/meson.build   |   2 +
>  2 files changed, 139 insertions(+)
>  create mode 100644 test/cxl-poison.sh
>=20
> diff --git a/test/cxl-poison.sh b/test/cxl-poison.sh
> new file mode 100644
> index 000000000000..2caf092db460
> --- /dev/null
> +++ b/test/cxl-poison.sh
> @@ -0,0 +1,137 @@
> +#!/bin/bash
> +# SPDX-License-Identifier: GPL-2.0
> +# Copyright (C) 2023 Intel Corporation. All rights reserved.
> +
> +. "$(dirname "$0")"/common
> +
> +rc=3D77
> +
> +set -ex
> +
> +trap 'err $LINENO' ERR
> +
> +check_prereq "jq"
> +
> +modprobe -r cxl_test
> +modprobe cxl_test
> +
> +rc=3D1
> +
> +# THEORY OF OPERATION: Exercise cxl-cli and cxl driver ability to
> +# inject, clear, and get the poison list. Do it by memdev and by region.
> +
> +find_memdev()
> +{
> +	readarray -t capable_mems < <("$CXL" list -b "$CXL_TEST_BUS" -M |
> +		jq -r ".[] | select(.pmem_size !=3D null) |
> +		select(.ram_size !=3D null) | .memdev")
> +
> +	if [ ${#capable_mems[@]} =3D=3D 0 ]; then
> +		echo "no memdevs found for test"
> +		err "$LINENO"
> +	fi
> +
> +	memdev=3D${capable_mems[0]}
> +}
> +
> +create_x2_region()
> +{
> +	# Find an x2 decoder
> +	decoder=3D"$($CXL list -b "$CXL_TEST_BUS" -D -d root | jq -r ".[] |
> +		select(.pmem_capable =3D=3D true) |
> +		select(.nr_targets =3D=3D 2) |
> +		.decoder")"
> +
> +	# Find a memdev for each host-bridge interleave position
> +	port_dev0=3D"$($CXL list -T -d "$decoder" | jq -r ".[] |
> +		.targets | .[] | select(.position =3D=3D 0) | .target")"
> +	port_dev1=3D"$($CXL list -T -d "$decoder" | jq -r ".[] |
> +		.targets | .[] | select(.position =3D=3D 1) | .target")"
> +	mem0=3D"$($CXL list -M -p "$port_dev0" | jq -r ".[0].memdev")"
> +	mem1=3D"$($CXL list -M -p "$port_dev1" | jq -r ".[0].memdev")"
> +
> +	region=3D"$($CXL create-region -d "$decoder" -m "$mem0" "$mem1" |
> +		jq -r ".region")"
> +	if [[ ! $region ]]; then
> +		echo "create-region failed for $decoder"
> +		err "$LINENO"
> +	fi
> +	echo "$region"
> +}
> +
> +# When cxl-cli support for inject and clear arrives, replace
> +# the writes to /sys/kernel/debug with the new cxl commands.
> +
> +inject_poison_sysfs()
> +{
> +	memdev=3D"$1"
> +	addr=3D"$2"
> +
> +	echo "$addr" > /sys/kernel/debug/cxl/"$memdev"/inject_poison
> +}
> +
> +clear_poison_sysfs()
> +{
> +	memdev=3D"$1"
> +	addr=3D"$2"
> +
> +	echo "$addr" > /sys/kernel/debug/cxl/"$memdev"/clear_poison
> +}
> +
> +validate_poison_found()
> +{
> +	list_by=3D"$1"
> +	nr_expect=3D"$2"
> +
> +	poison_list=3D"$($CXL list "$list_by" --media-errors |
> +		jq -r '.[].media_errors')"
> +	if [[ ! $poison_list ]]; then
> +		nr_found=3D0
> +	else
> +		nr_found=3D$(jq "length" <<< "$poison_list")
> +	fi
> +	if [ "$nr_found" -ne "$nr_expect" ]; then
> +		echo "$nr_expect poison records expected, $nr_found found"
> +		err "$LINENO"
> +	fi
> +}
> +
> +test_poison_by_memdev()
> +{
> +	find_memdev
> +	inject_poison_sysfs "$memdev" "0x40000000"
> +	inject_poison_sysfs "$memdev" "0x40001000"
> +	inject_poison_sysfs "$memdev" "0x600"
> +	inject_poison_sysfs "$memdev" "0x0"
> +	validate_poison_found "-m $memdev" 4
> +
> +	clear_poison_sysfs "$memdev" "0x40000000"
> +	clear_poison_sysfs "$memdev" "0x40001000"
> +	clear_poison_sysfs "$memdev" "0x600"
> +	clear_poison_sysfs "$memdev" "0x0"
> +	validate_poison_found "-m $memdev" 0
> +}
> +
> +test_poison_by_region()
> +{
> +	create_x2_region
> +	inject_poison_sysfs "$mem0" "0x40000000"
> +	inject_poison_sysfs "$mem1" "0x40000000"
> +	validate_poison_found "-r $region" 2
> +
> +	clear_poison_sysfs "$mem0" "0x40000000"
> +	clear_poison_sysfs "$mem1" "0x40000000"
> +	validate_poison_found "-r $region" 0
> +}
> +
> +# Turn tracing on. Note that 'cxl list --media-errors' toggles the traci=
ng.
> +# Turning it on here allows the test user to also view inject and clear
> +# trace events.
> +echo 1 > /sys/kernel/tracing/events/cxl/cxl_poison/enable
> +
> +test_poison_by_memdev
> +test_poison_by_region
> +
> +check_dmesg "$LINENO"
> +
> +modprobe -r cxl-test
> diff --git a/test/meson.build b/test/meson.build
> index a965a79fd6cb..d871e28e17ce 100644
> --- a/test/meson.build
> +++ b/test/meson.build
> @@ -160,6 +160,7 @@ cxl_events =3D find_program('cxl-events.sh')
>  cxl_sanitize =3D find_program('cxl-sanitize.sh')
>  cxl_destroy_region =3D find_program('cxl-destroy-region.sh')
>  cxl_qos_class =3D find_program('cxl-qos-class.sh')
> +cxl_poison =3D find_program('cxl-poison.sh')
>=20
>  tests =3D [
>    [ 'libndctl',               libndctl,		  'ndctl' ],
> @@ -192,6 +193,7 @@ tests =3D [
>    [ 'cxl-sanitize.sh',        cxl_sanitize,       'cxl'   ],
>    [ 'cxl-destroy-region.sh',  cxl_destroy_region, 'cxl'   ],
>    [ 'cxl-qos-class.sh',       cxl_qos_class,      'cxl'   ],
> +  [ 'cxl-poison.sh',          cxl_poison,         'cxl'   ],
>  ]
>=20
>  if get_option('destructive').enabled()
> --
> 2.37.3
>=20

