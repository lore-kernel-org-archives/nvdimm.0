Received: from esa5.fujitsucc.c3s2.iphmx.com (esa5.fujitsucc.c3s2.iphmx.com [68.232.159.76])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 27E3517CD
	for <nvdimm@lists.linux.dev>; Fri, 26 Apr 2024 01:58:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=68.232.159.76
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714096735; cv=fail; b=Jt4ekAMvoN8ruM/NQAm65X9XeNV+c3LQcnzrWlRS/8lKUd1roYIhCHWV4G27XnKcrKwHnGfIqiAIkz+22OI5hcxp/SAswtAzMFbumYxe9O9oz/2CPh9YfXld8UlRG+ve5+c6KvsjQljDzkTz5a7fwcGl7NDgfS0nTffYYl5F3ts=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714096735; c=relaxed/simple;
	bh=7e8hnqjeNUfEViZHEMwEWklen46NGylj3V6GuY37kTk=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=lj/26OfGYxs1ILQUCeVy9KWf375H3alyc+2mhN5Wiy7BmJW7I9BB574xlfZpOkeQH9BLFeLWRg5VsJcwYPuYYsLyf3u/Yj6moaSvm6z8qznFSso7gVU+YNw2Vh/6GNA2dUdJQ0uGl29kVNHpBCUzqRix4+d6Gyd6L9IKBsHg/w0=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fujitsu.com; spf=pass smtp.mailfrom=fujitsu.com; dkim=pass (2048-bit key) header.d=fujitsu.com header.i=@fujitsu.com header.b=dmoG6/HF; arc=fail smtp.client-ip=68.232.159.76
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fujitsu.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fujitsu.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fujitsu.com header.i=@fujitsu.com header.b="dmoG6/HF"
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=fujitsu.com; i=@fujitsu.com; q=dns/txt; s=fj1;
  t=1714096732; x=1745632732;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=7e8hnqjeNUfEViZHEMwEWklen46NGylj3V6GuY37kTk=;
  b=dmoG6/HF4yX1rENlyzlXH/Z+sn9LWgWg4kr9oXymdujDip4pE+5UeiMt
   uKBq5fIgs9n5ol+Zj2BlIYlvD9CoH4Bxntu8kbeke5CM5X9bNrKPUnyy5
   JTouYajB8vESB/MwfWrNSHn3SYsmMmE2q+VhlM/r/Nx+/euElSwiHvhO/
   k1Bhv9CIE6VKGOObUw7gSYyoUentHQfHa0cY7B73droyBSw6hcg1qD2Ez
   hNE15C8zlNgVdtolEFFPi4B9uujBoRVJ4TSMZsREytpmlK9mHHlucgSNM
   Aszp0YeAEFW5r2PpTcLAOfeYQ12BfRk8nIO4fLqchry7cGJR9ze4v3NqN
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,11055"; a="118275768"
X-IronPort-AV: E=Sophos;i="6.07,231,1708354800"; 
   d="scan'208";a="118275768"
Received: from mail-tycjpn01lp2169.outbound.protection.outlook.com (HELO JPN01-TYC-obe.outbound.protection.outlook.com) ([104.47.23.169])
  by ob1.fujitsucc.c3s2.iphmx.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Apr 2024 10:57:38 +0900
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=FGRhMeUgvmFIDuPV/74MOLVEe5WYcK42HwT7t9cA8o8IL2kIL0zM2IO1FPhTXZADj1UUU+AUbnl+iAK9drWrrVP8QTXUEiD182QpAM2kqLvWHfi8H/INab7XCUwfZy7Of1rxM2baPwSzh8R1pCO9V45Ot6q2N8RQmpqGFEC1RwFoAG++lFmLXYo7nO/Iw991gsBrHSXKB0VWpqwgapGQaJBOp1Ou1URXuYL7V0Qq93JakPW/PyGSpr7qpjH0Ttg7y3fNJ83Mefwect7Lv7j15P3hq8hifxHySCcncRY1w23A+BZecVkM6BO0VZioYEYpVGR+p6q9TQrsLEKCbFXNOA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=7e8hnqjeNUfEViZHEMwEWklen46NGylj3V6GuY37kTk=;
 b=C5xEbPI5VBUwQlBnleX9iJfans3Mt5B9/C9CmoQwvB7PIiBq6ZMylri8F5uFku/zZbne97UGsG+lrVoLWxYPQ0RRsIrE7clLDjXuUJ1LgPvMcALSfySlqgipJ236jXVDksC06sIb0fd/lgQJKRX9q4vhwtOunCOPt4pTlF7PElVSktxRlvi39qOD27GYAuVw2bOHHj8lb2V9jjBtQZm0nOSQ/pLQG1yoq/kxBV8jeaN79ouGZItmtJkcJsvyIudnTPD9xumCfIiUubgha9MzQO7cpQh7kvZmb6kEwMhorlrMzPtoARThke+En0TN2MHO8/yBBbIsRjn8zbkMXmXHbA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fujitsu.com; dmarc=pass action=none header.from=fujitsu.com;
 dkim=pass header.d=fujitsu.com; arc=none
Received: from TY1PR01MB1562.jpnprd01.prod.outlook.com (2603:1096:403:6::12)
 by OSZPR01MB6327.jpnprd01.prod.outlook.com (2603:1096:604:ea::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7519.24; Fri, 26 Apr
 2024 01:57:36 +0000
Received: from TY1PR01MB1562.jpnprd01.prod.outlook.com
 ([fe80::d9ba:425a:7044:6377]) by TY1PR01MB1562.jpnprd01.prod.outlook.com
 ([fe80::d9ba:425a:7044:6377%5]) with mapi id 15.20.7519.021; Fri, 26 Apr 2024
 01:57:35 +0000
From: "Zhijian Li (Fujitsu)" <lizhijian@fujitsu.com>
To: Alison Schofield <alison.schofield@intel.com>
CC: "Verma, Vishal L" <vishal.l.verma@intel.com>, "Jiang, Dave"
	<dave.jiang@intel.com>, "Xingtao Yao (Fujitsu)" <yaoxt.fnst@fujitsu.com>,
	"Quanquan Cao (Fujitsu)" <caoqq@fujitsu.com>, "linux-cxl@vger.kernel.org"
	<linux-cxl@vger.kernel.org>, "nvdimm@lists.linux.dev"
	<nvdimm@lists.linux.dev>
Subject: Re: [NDCTL PATCH v3 2/2] cxl: Add check for regions before disabling
 memdev
Thread-Topic: [NDCTL PATCH v3 2/2] cxl: Add check for regions before disabling
 memdev
Thread-Index: AQHaltG2SzHUVWSV+06RfsOl90X7tbF5NGQAgACYLgA=
Date: Fri, 26 Apr 2024 01:57:35 +0000
Message-ID: <a8100cbc-7394-4803-a2a1-8c74c4285384@fujitsu.com>
References: <170138109724.2882696.123294980050048623.stgit@djiang5-mobl3>
 <20240417064622.42596-1-yaoxt.fnst@fujitsu.com>
 <9b00e36292b7aa19f68bda6912b04207f43c8dc5.camel@intel.com>
 <779cc56f-9958-4c0a-b5d6-2a9d4c3e4260@fujitsu.com>
 <ZiqKZqsA0JjT51Wl@aschofie-mobl2>
In-Reply-To: <ZiqKZqsA0JjT51Wl@aschofie-mobl2>
Accept-Language: en-US, zh-CN
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Mozilla Thunderbird
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=fujitsu.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: TY1PR01MB1562:EE_|OSZPR01MB6327:EE_
x-ms-office365-filtering-correlation-id: 422cdbc9-15ce-4c9d-a76d-08dc65943e57
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam:
 BCL:0;ARA:13230031|366007|376005|1800799015|38070700009|1580799018;
x-microsoft-antispam-message-info:
 =?utf-8?B?WngzOE96NUduNFVZcVFqY2ZmdURtN3RDVjhtbWE5U2dYUjBlR3lLeHRjdWJN?=
 =?utf-8?B?RDhJTzBjOU96Z0V4Vy9UNnJQNTl0VDFWdXdSelJ1aE5YVkJrR3MraHlKWmta?=
 =?utf-8?B?QVZHdUEzdTJsaEJYeUEvaWlLWHhOMElUTy9WQXhCSm94aWExWitHbjRtaHdR?=
 =?utf-8?B?c1A0dzBrRGgvKzZlQ2Ewd29LQ21iaXlRdklSeHlkYk0zaFROMFBlb0lRSkky?=
 =?utf-8?B?bUx6dDFoQm9rd1BwYzYzbm9wR2pKS1hBWWRHRUpuMjZHcmxlRGVRN0ZJQmc1?=
 =?utf-8?B?K1FLTWpxOCt1ZS8vWXlvTGtKbjAzblVYRGNtbmtXdFFVelV6NzBYeW5Hall5?=
 =?utf-8?B?L0kxUXE5eFZSSmtjdEY2cXh3VXJPV04zMDVxYUlzV2g3eFlJYUpwZlZSb0JS?=
 =?utf-8?B?YnhnRnhnWFRwUnpNMWgxVkoxbDVMR2dQalVlUGV4OVBFUmd0S2gwZW5yU1lF?=
 =?utf-8?B?S25OdkhrR1ZIQ1JtZFRHaUpjam5oeEk3aG1mVVcyMEVQMThTK0ZJSzRrUFJS?=
 =?utf-8?B?WG1rK0Fyc1EyTHNuZmpWQ3RNWTcxRmpaK3A3dVdmL3p5dHgrL0JacnZvcmtH?=
 =?utf-8?B?K1dCS2lweVltOW1nN1hoNEQyeFk2S2J6NU9qK05TR3dtdk00QmFVT0w0ZkQ4?=
 =?utf-8?B?cXk1QjAwcWtSSXQ4NUl5ZHo1Zm5zMXJtV3hCc2xPc0VldW1hdXp6K3AwdlFJ?=
 =?utf-8?B?L29PYlo1VXJoZXc1RXp2S1lhaUNZbVIwTWpGVm82ZE5NY0hDVEFUL0RDUU1T?=
 =?utf-8?B?bFpvNC9QSmdURUtac2tacXlIaW9Ec0M0b0pxRkhaSmFTUzJkdjZyeVllbDZu?=
 =?utf-8?B?cC9JdVlLUmo3SDQzUmFWdGFoQ0dHOWlwQXRxVWhXdDQ2eUt2dm1Ic3F2Q2pH?=
 =?utf-8?B?RTFQTFVPNjQ4cXEwQkQ0SFpsYis4QXhBcCtoV0QwK3F4QVlNc00veGl6cWVy?=
 =?utf-8?B?L29vR3Z5RjJiY3FXUXg4RE92YUFqMFRoMUNEcW1yd0JsanhjNm9BbUhDSE5w?=
 =?utf-8?B?V2tnQmpxaGZ4R2luYklvWXBWUUpMZlM3aTVhcVFXa1Ayd1M2VktzeXBqK1NO?=
 =?utf-8?B?cGExb0V2elF0bXVQL0VJNXlRNjVEelN0R01JdGdlbEtmOElUZkxoTFNodm83?=
 =?utf-8?B?QkxaMTYra1pQWVgvczlnN2FzNEhSaXR5ZlZzQVc2cUNOcTBpejRRSjRrSThn?=
 =?utf-8?B?S2dJaTIrRHo2Z2ZxRW51UlY4M2dnU0FrdTJYL1hNZmhXQWh6RXRXWDBIU09H?=
 =?utf-8?B?V1NLL0t0NkpvRmZ5M0JOYTA5MkpnVUVjenVJWSs1TFg3dHVZVDhFREt4b2RG?=
 =?utf-8?B?dENOaEt3Slp2R1VDWjJSb2pXZDE2OEMySHdBVnl2NjhVUVpYTGQrcExnYWd0?=
 =?utf-8?B?clI3S2VZOUhsbDN5MWdObzR0UDBQTkZhcUdtR0NTUGltZGJ0NnI4d2psOTlh?=
 =?utf-8?B?ZC9Nak9wSHJ6SkR0TkZQd2RHRWNpeUJGTytHazZaWmdzQTlFUnlYdVR5KzlS?=
 =?utf-8?B?WFgwYTJRb2lmbC9mRkxEd2pxdkptUzg2Z2Fxa3U3b3prQ1NrQzZLd2IrY3hR?=
 =?utf-8?B?ZWhPZ1ZrbEh0OUNZb1pLTzIydE50MUxVQmsvRzI2dnRyRTNUNWpmRXk2TXVv?=
 =?utf-8?B?VnA2c2tHS3dUdDdDSkd5TTRvOGx1N1N4Ukp4UWhLZ1RMYWVDU0ppQ1F6UmN6?=
 =?utf-8?B?MDRwUWJ0Szg1c2EwM1MrVWpadWVHOVV6d1VLK2FTc0Z3NEluK3VSdy9DbkxO?=
 =?utf-8?B?VHc0Sy94MHh4MHdOU0NmMHExcnpNYW4zMHBWSWJxWWNQSnlHUHNzaDdZdzFR?=
 =?utf-8?B?ZkYvSmxmcXlNdnA2aGpQZnIwRFRVbUx3NXR1NG5uV1d2b0diM2ExWWsyN2d0?=
 =?utf-8?Q?y+1MPAy+3WRlv?=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:TY1PR01MB1562.jpnprd01.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(366007)(376005)(1800799015)(38070700009)(1580799018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?utf-8?B?aXc3aWU4QnArZzcvcFlxeDJ0K25BM3lCRHN3YTNOTzVwbmJCSTR4YU9qVXpx?=
 =?utf-8?B?R1lIc3I3cS9NWlB1YmNXZkY2QW5MVFNxZERLOEhYUWl4M09WQjlNeDRxYVgz?=
 =?utf-8?B?ZFRCUTRqMDVkRkRGUDl1NGROUHdnWDBwYkVxdmRKcWRVOC9iRnFUei9FcFlp?=
 =?utf-8?B?L0FqUWNoSmlua09wcHJzbjJwVFJkamk4L0lVQnN4YS9qNmpvZW56Q3pUWUVu?=
 =?utf-8?B?Wkd2UTEzeFUxOCtjVXQyZVA5am5wVWU0aExZQm1qUVVRa1N5R1BFTDFXR2pZ?=
 =?utf-8?B?ci93MlBZc3hLVWgzaEMyaFF2RlNnd0wybnVtY05aMHVHaTNaR3pqSWRJbkM4?=
 =?utf-8?B?a01zb0xVUEVaM2p6SVpnbVZrU0ZUYVNXRmo3aVJweEdEdjJ2dlExRXc3VEtu?=
 =?utf-8?B?Wmd4OGxpM21zaytLOHJMWXVBTVpJR2hJOFV6WDgzUmtHMVdwQnFGRmxyWDZW?=
 =?utf-8?B?cndaNyt6RHZxNStGNWRseGIvVWZsc1A3SDAyUk5TdmxHTGxGK25PMzNOZXVM?=
 =?utf-8?B?Umd6Q05mNGxoY0xjYk01K0lIRDNGdEJSOVFnMi9ab3MvQnREOG0xemZZQ1Fl?=
 =?utf-8?B?Z2wzeHVvQmhwdENHOTRCaUVFekhjeXpTWUpaeVVDK0hieW9pNkwwcWwzekRF?=
 =?utf-8?B?MDRDVUtadnRJOGI1c2FpTXVWSm54VEJuZWx4TnBOSjFtYXFVbkhaZ0JWZUxM?=
 =?utf-8?B?cFJQVU5wR0hDQ3FsQzFqZzZYTitGb0kvTFRCbHZRL3VzOU5wK3NRaFhyMURw?=
 =?utf-8?B?c2dxalArWE5USEhhbUhYRFVxdkRQalhaMEw4SklqL1MvY3JxUHRKcHVBYkNR?=
 =?utf-8?B?YVIwS1A2T3VKV0VKM1ZOazRCQjVjOTVrWmxKRlFscDlneXF2OHQwVzYwTWo1?=
 =?utf-8?B?enVDVGFuNjlZZDFSWVRwcW1idEJQblQzN0dJNk55VEVFTmJvOVJBSmpXRkJY?=
 =?utf-8?B?RDJ0dEdDQzZ3ZGJCV0dGLy85T1IrckNsazRKTkJLbUFqQU9qN2lLYnNOYlJS?=
 =?utf-8?B?aVBNZzZvQTUwcDlNL25kd2lqbFdVdFlQUHpOYUVYMk8rdFduQzNWYjMwWnpv?=
 =?utf-8?B?OHpMRGJmWDRvUllVcUhBU2IyYmlzUHprazdHN1ZYM3QxWERPTVdNT0tZQ3Vq?=
 =?utf-8?B?Z2FDMDZYY0FUbWFvemVSaHV1TXdkR0N4WHo5WGU5U3Vua0I5L2F3L2t3MEh6?=
 =?utf-8?B?U0MvMFBSdWZ0T3laUlhkTHV0eldIRGluYnUzckhUQzVzVllxamVJSnMrNVov?=
 =?utf-8?B?QzhDY2k0K3ZUcXlwYWovb28yYmZkYVU0V1ByOWkwSWZ6K3R4eThwbkMvbDNZ?=
 =?utf-8?B?dDR3MklORzVJT3lsVURCd1JYY1F3Wk5FOFlxdkJVTjhlL3Z5cTJjQTEyWGpI?=
 =?utf-8?B?NjROWmRpeWxseWJHcllYM1ZrVEo3d2g2eU1kU3BVbVZRdVl1ZU5PckZuNThr?=
 =?utf-8?B?L3ZqSjByS1hOcG02YWlVQ05SU0tNVzg3UFZsVjVRZ2lHeHdjVUtEMzdIaExM?=
 =?utf-8?B?SXVQR2xmajJ5TkV5VDhMZi80TFZpM2VNTXFEeW90V3hlbnFvUXVZRWpEWlVW?=
 =?utf-8?B?bFM5cVUvanFySkZCRzFnSWcyZ1BoRGl2U0VUV2tlQkt4SkZETXlFYXJJMk5l?=
 =?utf-8?B?Ky9mdGpSMXNRUkE2Qnl2b0F3S0ZKZzk3RVdiK2VJZzYxTk5VRGxxSmJMckFB?=
 =?utf-8?B?VXA2ZkpRL29hb0JuR0JNTEFSL29mb283emFqU0orTm1JM1BtMGxoc3JWV05I?=
 =?utf-8?B?Q1V1eUltM0pBSXZSKzJPSXZuYXpDQTRZQ3pMOURvbnY0MzZ6V1V6cElUNDY1?=
 =?utf-8?B?ZklwZUFZNFF3cGpDY1o5K1Bkd3REakRtMnc2eHlOd1ZPMWdlYzR3NE5jSVcr?=
 =?utf-8?B?aE4vMUFSTnQrMnZFZXA1UUE4Ykp0d1ZPbitxK1BxcHVXYml3K2JaN0txcFE0?=
 =?utf-8?B?K3ZBaUJOMk1KM3RnT2k1Mzd4T1BaS3k5Z1RvVXFkWFk1NG5rNkg4U1ZjN0xQ?=
 =?utf-8?B?cWRENEJ1amVudUtEOU5VVmgrYS9tb2lSUEpvVE83OHU5K0ZpT1hjbWhxb1ND?=
 =?utf-8?B?T2plTlF6YXdLbGFLckVnaU1UaU9RK2EweWdGUHZVN3YwNHlmSk8xT0lPRG5h?=
 =?utf-8?B?WHAzZ2JRNWhiUVNuOFpHZVdrM1NSR0ROU0FMQ0FFV1Bld0Y5YjlZRTRjUXFZ?=
 =?utf-8?B?T1E9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <8C6658BABDEF1047A5E8B3B118D684E2@jpnprd01.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	stFcHSeWG7rWl+VTnFW68g3RLNOhwklHr5OOpEK9v4mte5U4esNwVYTFePsohUEfMR3cBhjGnJ9DZZ4MO42nXJufg86EfyPlNRaQiLTcsax0wmFgJMCE0VBir48S0t+CdWZBQSyRgA0X/F90aOruXdubCIU1T4+qVLe/b8b24JEnES1vnW8ZCBO3757DWZxU9Uq7W0QWjymZkan4eWoJCxDxGkR7f67YbEq8BWvS3+Uf+HfXMyjHck/33uOJVGIu8wPM1WSssF1UuGyqzmWbnTEMvfutsFbtLRGAeQ7Mw5vQ5Da6HYZNNC+yJI0TKl6EXhOvre/ha28JZXxJEnNH7VMHvhnXi5p4dx7kj2njBnjgKTPApVYgfc/Rl/12ITNfxT1Bm8Ff8e0ST8MwAqUb2eN2a/rfp1qfdt6GK4/9BRUn0Q5r27T2fG03bPEH01pfx62I0XhYSSuLo1UG7yIHpNTjTttZ6j/RO5grl2bhabDI4VgKOTrRIzYU7hgdd9b5IC6FJvwlWIffWjBAWicwGxIuuWqzJz5hywQSjND+vnMSAmP5enPnvuERn+f1w7kkTtzJ1u9UCKB+CPVBhct7BQQXPeoVeblMPb6Hhq6PDfELyramdAoi32OPLFEoRbCz
X-OriginatorOrg: fujitsu.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: TY1PR01MB1562.jpnprd01.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 422cdbc9-15ce-4c9d-a76d-08dc65943e57
X-MS-Exchange-CrossTenant-originalarrivaltime: 26 Apr 2024 01:57:35.4633
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a19f121d-81e1-4858-a9d8-736e267fd4c7
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: +2hOS2gJPSohcGTnm9u+V0HhCsXAXjP8APedgyGrlKxij6UW36BE9HkLeVTmye+7VBTyjBPPJcKPcTJYXbI04g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: OSZPR01MB6327

DQoNCk9uIDI2LzA0LzIwMjQgMDA6NTIsIEFsaXNvbiBTY2hvZmllbGQgd3JvdGU6DQo+IE9uIFRo
dSwgQXByIDI1LCAyMDI0IGF0IDA1OjMwOjQwQU0gKzAwMDAsIFpoaWppYW4gTGkgKEZ1aml0c3Up
IHdyb3RlOg0KPj4gSGkgVmVybWEsDQo+Pg0KPj4NCj4+IE9uIDE4LzA0LzIwMjQgMDI6MTQsIFZl
cm1hLCBWaXNoYWwgTCB3cm90ZToNCj4+PiBPbiBXZWQsIDIwMjQtMDQtMTcgYXQgMDI6NDYgLTA0
MDAsIFlhbyBYaW5ndGFvIHdyb3RlOg0KPj4+Pg0KPj4+PiBIaSBEYXZlLA0KPj4+PiAgIMKgIEkg
aGF2ZSBhcHBsaWVkIHRoaXMgcGF0Y2ggaW4gbXkgZW52LCBhbmQgZG9uZSBhIGxvdCBvZiB0ZXN0
aW5nLA0KPj4+PiB0aGlzDQo+Pj4+IGZlYXR1cmUgaXMgY3VycmVudGx5IHdvcmtpbmcgZmluZS4N
Cj4+Pj4gICDCoCBCdXQgaXQgaXMgbm90IG1lcmdlZCBpbnRvIG1hc3RlciBicmFuY2ggeWV0LCBh
cmUgdGhlcmUgYW55IHVwZGF0ZXMNCj4+Pj4gb24gdGhpcyBmZWF0dXJlPw0KPj4+DQo+Pj4gSGkg
WGluZ3RhbywNCj4+Pg0KPj4+IFR1cm5zIG91dCB0aGF0IEkgaGFkIGFwcGxpZWQgdGhpcyB0byBh
IGJyYW5jaCBidXQgZm9yZ290IHRvIG1lcmdlIGFuZA0KPj4+IHB1c2ggaXQuIFRoYW5rcyBmb3Ig
dGhlIHBpbmcgLSBkb25lIG5vdywgYW5kIHB1c2hlZCB0byBwZW5kaW5nLg0KPj4NCj4+DQo+PiBN
YXkgSSBrbm93IHdoZW4gdGhlIG5leHQgdmVyc2lvbiBvZiBORENUTCB3aWxsIGJlIHJlbGVhc2Vk
LiBJdCBzZWVtcyBsaWtlDQo+PiBpdCdzIGJlZW4gYSB2ZXJ5IGxvbmcgdGltZSBzaW5jZSB0aGUg
bGFzdCByZWxlYXNlLg0KPiANCj4gSGkgWmhpamlhbiwNCj4gDQo+IFdlIGFwcHJlY2lhdGUgeW91
IHdvcmtpbmcgd2l0aCB0aGUgcGVuZGluZyBicmFuY2ggd2hpbGUgd2FpdGluZw0KPiBmb3IgdGhl
IG5leHQgcmVsZWFzZS4gV2UgYXJlIGFpbWluZyB0byBnZXQgdGhlIHBvaXNvbiBsaXN0IGZlYXR1
cmUNCj4gbWVyZ2VkIGluIHRoZSBuZXh0IHJlbGVhc2UsIGFuZCBhcmUgZ2V0dGluZyBjbG9zZXIu
IFRoYXQncyBhbGwgSQ0KPiBjYW4gb2ZmZXIsIG5vIGRhdGUgcHJlZGljdGlvbi4NCg0KVW5kZXJz
dG9vZCwgdGhhbmtzIGZvciB5b3VyIGluZm9ybWF0aW9uLg0KDQoNClRoYW5rcw0KWmhpamlhbg0K
DQo+IA0KPiAtLSBBbGlzb24NCj4gDQo+Pg0KPj4NCj4+IFRoYW5rcw0KPj4gWmhpamlhbg0KPj4N
Cj4+DQo+Pg0KPj4NCj4+Pg0KPj4+Pg0KPj4+PiBBc3NvY2lhdGVkIHBhdGNoZXM6DQo+Pj4+IGh0
dHBzOi8vbG9yZS5rZXJuZWwub3JnL2xpbnV4LWN4bC8xNzAxMTI5MjExMDcuMjY4NzQ1Ny4yNzQx
MjMxOTk1MTU0NjM5MTk3LnN0Z2l0QGRqaWFuZzUtbW9ibDMvDQo+Pj4+IGh0dHBzOi8vbG9yZS5r
ZXJuZWwub3JnL2xpbnV4LWN4bC8xNzAxMjA0MjMxNTkuMjcyNTkxNS4xNDY3MDgzMDMxNTgyOTkx
Njg1MC5zdGdpdEBkamlhbmc1LW1vYmwzLw0KPj4+Pg0KPj4+PiBUaGFua3MNCj4+Pj4gWGluZ3Rh
bw0KPj4+
