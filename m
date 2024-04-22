Received: from esa15.fujitsucc.c3s2.iphmx.com (esa15.fujitsucc.c3s2.iphmx.com [68.232.156.107])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0CA4C4DA08
	for <nvdimm@lists.linux.dev>; Mon, 22 Apr 2024 07:27:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=68.232.156.107
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713770873; cv=fail; b=J673CV7sn9hjbnWaT/70PfwUkdsXjOsNLWMpteKlkX7gVNO3a2nmaEbUbgnYHStVsXsdu+tXdeSk15cHX3rxPs6BFPwycHu48DE6loEmuOYwyFPKEhI6HPS7WastKP41tIoLzQxDIMG0vGGKUoVb7A67qQs0EklXExwtEIluPeo=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713770873; c=relaxed/simple;
	bh=Kk1XT8aqgU+VWpNdt+iBkvpSnBqwAsiSFH5Q5Bfik08=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=p0SKWXrEsn0RHpcJBOaAUe20jcWrW31bIqFfs4ChLdu2TmapC/RFzdh6E9DBjGXM0UA9uILBLYVyLv5WMBua2DET/JnEtrfizyeDOhpxZE0Cstm7eOT+DJ+OXpRPtFVRuQr4F2pShc8pqovmJdpeDnfK2z4rnCGBFf14Be/FCUg=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fujitsu.com; spf=pass smtp.mailfrom=fujitsu.com; dkim=pass (2048-bit key) header.d=fujitsu.com header.i=@fujitsu.com header.b=o2VfFFOR; arc=fail smtp.client-ip=68.232.156.107
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fujitsu.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fujitsu.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fujitsu.com header.i=@fujitsu.com header.b="o2VfFFOR"
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=fujitsu.com; i=@fujitsu.com; q=dns/txt; s=fj1;
  t=1713770870; x=1745306870;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=Kk1XT8aqgU+VWpNdt+iBkvpSnBqwAsiSFH5Q5Bfik08=;
  b=o2VfFFORlUfebvI4b65GOBlVmqoSpWTUm9O6E2pRB2QOybbAGZs/p5Yt
   yXuBjW+77xuI9qo5EC9soahlgmvjc52noWWcaauzzSOgyzeVxE0AJsVxS
   jSLBBaHfjemXPSjjEx5LYBHUh1SoE3vh07WZya+n+pP4Twwz5ZvDsJdDd
   ykbZoUlIC9O5hpCtjdoIlwlSqHUkvHciAiAckF8i5dMPjb7g06+mAJbgK
   Tbe+GLdP9+Q+UZlLd8NpDAyh1qpH7Rk3a5T+DhtEfQQfhX3DoVbuP0Sqh
   l96UKens/0f73Pvq6oZohQ/XYodwBcBr8GHhRxTZzHXHtAXxYgJ9+bX6a
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,11051"; a="117755050"
X-IronPort-AV: E=Sophos;i="6.07,220,1708354800"; 
   d="scan'208";a="117755050"
Received: from mail-os0jpn01lp2105.outbound.protection.outlook.com (HELO JPN01-OS0-obe.outbound.protection.outlook.com) ([104.47.23.105])
  by ob1.fujitsucc.c3s2.iphmx.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Apr 2024 16:26:37 +0900
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=JZ6waWpPHQO9V7rmcZYLtxLU/TPfmpCT03h249lw3PRu/IRFfJ6grTS1bESCScRvh6Q4LkN5otD0tcpmovqwwKGx9o5GFrLRd8Hmn/fWWEpzImeIvPHaryVC8kD9r3O4Dnh1IbAOqV0j1FV9lt0uNisC58tLjgVj5WHbx+3he657IE72XfxL/fxd4YtPm0N8EnsFzcL/qnu5vl8WCr6WQd8UZNwapjul81q/0SyE9uxbJ6cTvk8BzuLcYUsVkVwh8auVKQcmx+M1EB37ezzow0JSyvAHzGxiYaqa9HJgHZYVQkW4WajVKh/UVBvM77bw6AURkmOvlgJ0l18rw/sNCg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Kk1XT8aqgU+VWpNdt+iBkvpSnBqwAsiSFH5Q5Bfik08=;
 b=XxzYv3N/ipe04EgOK+w0kobli/VZrdJsBzY+GWlEfOuBgHUL+0jY5LofcK2a4OgnCXJgtJYPwX9yGUEN26ikjXOjEUc+urBrB0IvUjEC2hu4KMqPnrygOdOJiEi3VzJGUmuZEDLdvEG/v94ILYjOhXkg/gcyLTjec/Q7xOt8CqdQx5nkrfeGJbZSwLB5ChqDMHr4ngXzmwRS5oaZUB/yndeu46DmDsgl3qFe4mmjwgRvYKRfyVuJ+iEQFpO/rigcN5TeSl0IMSnrVDmkBAwd/ACC7L6TbEmUE7iCmDkI/jeGHdQt+TO9g4/JjD6s+XWvWVAzUEh71a2za13v+/sGOQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fujitsu.com; dmarc=pass action=none header.from=fujitsu.com;
 dkim=pass header.d=fujitsu.com; arc=none
Received: from OSZPR01MB6453.jpnprd01.prod.outlook.com (2603:1096:604:ed::14)
 by TYWPR01MB10176.jpnprd01.prod.outlook.com (2603:1096:400:1e4::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7472.44; Mon, 22 Apr
 2024 07:26:33 +0000
Received: from OSZPR01MB6453.jpnprd01.prod.outlook.com
 ([fe80::3a1c:a3fe:854f:2e1d]) by OSZPR01MB6453.jpnprd01.prod.outlook.com
 ([fe80::3a1c:a3fe:854f:2e1d%6]) with mapi id 15.20.7472.044; Mon, 22 Apr 2024
 07:26:33 +0000
From: "Xingtao Yao (Fujitsu)" <yaoxt.fnst@fujitsu.com>
To: "Verma, Vishal L" <vishal.l.verma@intel.com>, "Jiang, Dave"
	<dave.jiang@intel.com>
CC: "Quanquan Cao (Fujitsu)" <caoqq@fujitsu.com>, "linux-cxl@vger.kernel.org"
	<linux-cxl@vger.kernel.org>, "nvdimm@lists.linux.dev"
	<nvdimm@lists.linux.dev>
Subject: RE: Re:
Thread-Topic: Re:
Thread-Index: AQHakJMvZ/aqtwC1WEuOwT17T+SVjbFsxOqAgAclPEA=
Date: Mon, 22 Apr 2024 07:26:33 +0000
Message-ID:
 <OSZPR01MB64532C45DD4536C337A3918F8D122@OSZPR01MB6453.jpnprd01.prod.outlook.com>
References: <170138109724.2882696.123294980050048623.stgit@djiang5-mobl3>
	 <20240417064622.42596-1-yaoxt.fnst@fujitsu.com>
 <9b00e36292b7aa19f68bda6912b04207f43c8dc5.camel@intel.com>
In-Reply-To: <9b00e36292b7aa19f68bda6912b04207f43c8dc5.camel@intel.com>
Accept-Language: zh-CN, en-US
Content-Language: zh-CN
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
msip_labels:
 =?utf-8?B?TVNJUF9MYWJlbF8xZTkyZWY3My0wYWQxLTQwYzUtYWQ1NS00NmRlMzM5Njgw?=
 =?utf-8?B?MmZfQWN0aW9uSWQ9MjY5NTQyNzctM2UwMC00YTYzLWIxMzEtOWE1NTYxMjY2?=
 =?utf-8?B?MGFiO01TSVBfTGFiZWxfMWU5MmVmNzMtMGFkMS00MGM1LWFkNTUtNDZkZTMz?=
 =?utf-8?B?OTY4MDJmX0NvbnRlbnRCaXRzPTA7TVNJUF9MYWJlbF8xZTkyZWY3My0wYWQx?=
 =?utf-8?B?LTQwYzUtYWQ1NS00NmRlMzM5NjgwMmZfRW5hYmxlZD10cnVlO01TSVBfTGFi?=
 =?utf-8?B?ZWxfMWU5MmVmNzMtMGFkMS00MGM1LWFkNTUtNDZkZTMzOTY4MDJmX01ldGhv?=
 =?utf-8?B?ZD1Qcml2aWxlZ2VkO01TSVBfTGFiZWxfMWU5MmVmNzMtMGFkMS00MGM1LWFk?=
 =?utf-8?B?NTUtNDZkZTMzOTY4MDJmX05hbWU9RlVKSVRTVS1QVUJMSUPigIs7TVNJUF9M?=
 =?utf-8?B?YWJlbF8xZTkyZWY3My0wYWQxLTQwYzUtYWQ1NS00NmRlMzM5NjgwMmZfU2V0?=
 =?utf-8?B?RGF0ZT0yMDI0LTA0LTIyVDA3OjIxOjE4WjtNU0lQX0xhYmVsXzFlOTJlZjcz?=
 =?utf-8?B?LTBhZDEtNDBjNS1hZDU1LTQ2ZGUzMzk2ODAyZl9TaXRlSWQ9YTE5ZjEyMWQt?=
 =?utf-8?Q?81e1-4858-a9d8-736e267fd4c7;?=
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=fujitsu.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: OSZPR01MB6453:EE_|TYWPR01MB10176:EE_
x-ms-office365-filtering-correlation-id: a3988482-45b6-4e79-2564-08dc629d8994
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info:
 =?utf-8?B?Wm4xWXA3SEg3RWF0SkF6cjNuSXVMUlpCL2hKeVVaOVZHN2tvcWxGbEV6MHlX?=
 =?utf-8?B?Rys1cFZkZ01FdjlFWVdPZSsrMjFXdkhpTmlUQkVyWDdFb2dNU1p6TklXNnpD?=
 =?utf-8?B?WmdwbWNMak5jaEJCQ1o4OEgyWGxUNUxtVU5VdWRrRURPY2htcE1qbjNlSzlN?=
 =?utf-8?B?SjhERjU0SmpaY0F6Z3JVcnNlbVZpYU5rS05lT05ybXptaHNIbXFMVUtIWC9Y?=
 =?utf-8?B?OGt4LzlMUFNuMnd4bzVwWlpuMTJFMnhQWVdxalFoYzMxNWorZUFaU0QzbjY3?=
 =?utf-8?B?Q1ZTUnEwUHFib2l0Y2FEZEl6Zm45NTltM3lKK3RWSVNnZ01ZemRKNlRhclgx?=
 =?utf-8?B?V0dtc0ZNN2YxVFdhdUpaU1ZqejhicE50MXRySUZXcjc0U1JTLy9zUFFybUJH?=
 =?utf-8?B?aXdkVTJ4blJHTW9uRUttYnBjdGVxWk9JKzA1Z1NHd2dwZGUrVW54UFN6UVk2?=
 =?utf-8?B?aGtmZzFzUWtxYXhZU21zWXBCTlQySHhGc0x5K1J6S1RLOXJscTJ4SU1tclNz?=
 =?utf-8?B?dC9ZcmtJcnpKTzFXU3kvZVloSm9uQjRyeHVOS2s0Q3BjSzNtTkxpSEVkUGhh?=
 =?utf-8?B?SVp6RkRJWUJLWU4rd3BxVGFpZzEyTHp6MWxCZWhCSVJWamJDd2MxVE9BeERy?=
 =?utf-8?B?WVpaeVZqY3d1QWFVYzl5R3Jiemd6N1lKYWw5OUFOakluS21ZdXRpMDhCSlgr?=
 =?utf-8?B?aVJjcVJ3RW9iYnpJVE5PZ21rOE0xc3FUTnBDSmY0NjN3bnpMa0EzZERuVUcr?=
 =?utf-8?B?UW56dlAzRmlLdEdzcG9XSmZNNm5KL01Oc2cwaC9Tam9ZK0gyUkJpdzRrUmd3?=
 =?utf-8?B?aktFTlJXL3dkTVF2dDRtT085Z1lWV2hKTHh2NFg2L2lJL0ltNFJXeXYyNkFu?=
 =?utf-8?B?Y25vTVk1UGg4V3NWeUZ6VDIxRkFvcmZwKy9DWkhBZnpuVVdlQm82c1krSXJJ?=
 =?utf-8?B?b24rL3diaHMzczdoM1NGREw3dy9WZHlIS0QyTXpuM1JhNEE4Y1JuYU9jNGpC?=
 =?utf-8?B?aGpCTmd6bkh6cmhlMzlScElGdDJpN0tjNnJQZnVFWEo1MlAxRHdFb29xMkY5?=
 =?utf-8?B?Z0ZyTG1qZEJ1d09BSmR2UGJtUzg2b0JxOW14c0dtYWozK3J4R1lvdEJjWmQ1?=
 =?utf-8?B?ZkVmc0xHZVVpL0JzUTNFdGU5Vk5VNkZ2c3Bxc0FNTXh2RDdOc1B3V0UzU296?=
 =?utf-8?B?a1ZsVGhxcjVRaUNNTlhmNC9ib3FVTmpRL2wzc0JBNm0yVXZmWmVwU1pUcnBJ?=
 =?utf-8?B?OHF0Zy91UnFBNXNicWcwbDZiYjRYdS9kQWJrZC9oeU1XZDQ3TU83R0JYc0dW?=
 =?utf-8?B?VDlJQ2pkYklscTc4SGltTTlCZmhEVGVJNUVGckZVdXlGNVhJM3p1ZVNGV2cw?=
 =?utf-8?B?T3p3WnFDcHJucTZ6ZVJLUXhXRENCY1FsQTN6Vnh2UWtOR1VuQUxIb05kcEpJ?=
 =?utf-8?B?UnVQMkYrTElNRW5vMHdzWHVDeFlHRHkvZGJHVE8wR2ROY1l2eTV1L1RkdDEz?=
 =?utf-8?B?ZG9BWTdvSm11SFVjaHhLUU9QVjJDaEd3M2V3MG5Qb2tMYnFENlFhZUcyQXJm?=
 =?utf-8?B?b3ZzZ1FpZ2NubVdCcjlQT3JYUUJYamQ5LzI4WVhrREp5Si9lUCsyTkJYc3J3?=
 =?utf-8?B?dGJKeFcwTDR2cTFoYzdja1YwOFdaWVcrWDhLYWhDSDdEUGYxZXJVSzU3V041?=
 =?utf-8?B?cHYrTjVsekdwdms4cmdXMWlnYVJBb0x1T3l0WDAvcytzYUY2bGgzQzQ5bFdC?=
 =?utf-8?B?WDlSdFJ4Y1RlZ0g3TjRPMUdUT2ovdnRxNGIrNWRMa0JXQXE3MjlYcXk4SHFn?=
 =?utf-8?B?VXJ1L3dFRmlTWDRGK29jMmtaVFAwT1lPd0huZmg0SUpOUnBsbTNDSkxEa3Nq?=
 =?utf-8?Q?mJNR3nhQNfO9V?=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:zh-cn;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:OSZPR01MB6453.jpnprd01.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(366007)(376005)(1800799015)(38070700009)(1580799018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?utf-8?B?aWRWU0g4N0VNclVGcFI5NVJZK0tJZHUralNaNzlZb2wvSGU3ODhkWkpFLzkv?=
 =?utf-8?B?TnJOUkt2WnFJaERSbU5XeE1URFhNYjMvTkIyMlpqSEF5bG1Vb1kwckJPS0FZ?=
 =?utf-8?B?dWNqYWFRTm41RDhyRVFoMFB1WWlpSCtBbW92dmVqMy9VWDR2RSszMTVteXZQ?=
 =?utf-8?B?RmwyTldZK1JXZjNXNEdhWVhnK01IWlg3YTZEY1FaYWdSc3hBT0JyeDh3L2FF?=
 =?utf-8?B?TDh3UnF6WVdKM1RRUmFPVDNTS0ltT2pOZ1hwQTFWMUM0NjUrTXp4My9DL3FU?=
 =?utf-8?B?SVZ5Y1NwZEZNWXdBeWFnOEhmbzRhTEVPNTcrbGxjNWQ2bzJ2QUp3MjBGR1ZI?=
 =?utf-8?B?djJoK3hQQ3BpMWwrSHJFUGVKV0JQbTZXaDdYWUpXTzhGZmFxZGthZ2dXdVlU?=
 =?utf-8?B?Mi9zMy85dVRNK05MVitmU3NaKzBrbkU5dDM0KzAreERXNzlVdklKS25Pa1N5?=
 =?utf-8?B?amlvWUE3cFJNWmtaeWlSeDBsdUk0M3ZnOXFLZzVzVzNyRW1GV0dONlZ3Sm00?=
 =?utf-8?B?cFFheDJIM2JnUndIeFRhZ1FTNzl4QTV5UFdXdC91d1BSK293ek5uZVZWbXVE?=
 =?utf-8?B?VDgrNGN6VzNHNm5YS0cxQnZoNmtLRU9XY3Z6ZXBSZ1VmQzZvbmlXakoyVjVS?=
 =?utf-8?B?eFprMGJZMmowOHY0Y0U2TmNCV094QWI3eDB1WG5YVnhsSE14ZzdxSTNnaTNW?=
 =?utf-8?B?Q2szVDR4MEtyd2pOaEVxc29sbkxaZGQyaS81bnZWK0twMGtKelVtR2trWENq?=
 =?utf-8?B?Qmpkd3hhWDdYaHV2QkJrNDI5MWloSVg2R002UDFNWjdGdEU1NlFqMWlBWjRm?=
 =?utf-8?B?RVVJWm95eDZnSngrVXlidHYrSTRCY2ZqUmVaYlFWMVpYRnRyOGRWMjh2djc4?=
 =?utf-8?B?WkZ5TzJQOW9VQnVzak85Wk5iQjkvN3pmM3JDTWoxcE5UZDNMN29yV1lvK1JQ?=
 =?utf-8?B?cjZlWG5OMTRLWmxhSTBMcStCTVhNa015U2JrSmI1aDdsVWduT2dJcnJ5M2w4?=
 =?utf-8?B?MzQ2cUs2a0w4STVKa2ZISHNNamYwWURpNmdwdmhSS3JiQlZjTUtUMjlWZmgv?=
 =?utf-8?B?dDRJY0N6TnRseHFHSERKUjJROFlic1BSRk1RNDV6cHdEMlpWRXRJOHRLT05T?=
 =?utf-8?B?YXNBZG51K0VTMG1lTDJmcklEclRQMGNKYUZwMjZtc2RoVTV5SHRPUmdSMVZS?=
 =?utf-8?B?Z3lRelRSTmF1Q2s3ZXhzZTB4MFR6azZmaHBIWHZPaFM2YjlaQXArM29keVk3?=
 =?utf-8?B?SXBtQ0RSVS90bndmcEtHSW9vWm5xaUJYVUVPYWovcHV3Y1NocEtLU205ellt?=
 =?utf-8?B?d0lnUjBYdkRaYnVZU25iZjJOMldzaHloRW5pV2JCMCtQdk9QcUx4TzFJdXpK?=
 =?utf-8?B?MVREQS96ODluanZlVFlka3hycHc0N1MyaGhLRVBQODNjZGdxRjZWVHptS0dW?=
 =?utf-8?B?K21Vd00vRVR0UzNCSlJFdDYxbGk4V201eW9xc1FGdkd6ODl1NUlaMkszUnlL?=
 =?utf-8?B?N0hVY29FL1FYRFNZWUVZT3hVeG83V1doTmx4a01rV3EwN3ZMQjJ1UzVDSkU0?=
 =?utf-8?B?Q3I1S2ZzV2NubVNab2dHczd3bGZsTGMrT29Wd1E0dlhyMjhRdUhBTFBRcHZh?=
 =?utf-8?B?S1YrejFMaUpacDBTOXdEQUtzakg0U0JwOW5lOUo2QWNNd3FObzF5dlNhMjNz?=
 =?utf-8?B?VDVhOTZXMmlwMmRtWWdrOTd5dzAva09nMUV2VW1FQ3A3RHFadGxzeVp6U00y?=
 =?utf-8?B?aXVkdVY4RkQyYmpJcmdGbUNwb1JiZUZUU3ZqV1V0bC9BTDNKbWV1UUtvSnBr?=
 =?utf-8?B?UUJFdzYvemY0MUNDZUdlRVJLbFpyL1JzQ21tWXBicGVieDVlNzJvcmZDWTZZ?=
 =?utf-8?B?bW9JL2R4UXZUYW5ISGZ3aG1VSm1zaCsyeFhuUGh6eU9mSlVxRmk5ZVBkZjRz?=
 =?utf-8?B?ZGN5SUt3ZFNBZGdQMWVLOEFpZUpKV3Nza1p1djRJdURMY0NuVVc0alpibjZa?=
 =?utf-8?B?Vkk5T3RqeXNYdGxMNjd0YlFtRkd5NXQ4cnhKRnA4OS9JY2VjUEFiY3NJampw?=
 =?utf-8?B?MG81eCttZGhEZ3RmOFNJMWxCQThqdGRZNE9OK0lMR1c4cmdIK3FtbnMzelJ4?=
 =?utf-8?Q?GizLSf7M2Peh69vQmoZ4bbAQT?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	/umU4uVUvfssrSfiJqtRTjD1Bjtzxy0PA6CITkiNE1G1hQ3nHduCDxS4Nf5tHQXHqNcHqgpfjNBMaHCFMGsj7Pn11OEO7ndeI1pHdLbIKAhQrGp+xKNmfVlOblWwRYWix9RsEHxlu4yQ4zQuP3eHhCSy9PXM6AX2lMAwOHzY7V7ymxy7/iCMax8KFfOctXG6DbjZGIOAo2YXJGy7X4z1XcKOoxcPfPSIrteqke0Q+V+XVg+0Gn7Od6fkiG3F6ivGKJY7rqOMRHBHZPmZK1aI3S8NGOhjZ46OU/PwmSgu3BJhDeGMwji+LCoCMt25Pbih+41uay3VorAOBnEvhSS4YYqxVaGczUD8oOyztBtkyjvshJXkPABrvlqrcKRm0GqTQn0mUqi3HZfv7uRbdkAmlHSbvF+4FTuGOIBGgEehi32g2OcFDiF+DAWKNxmk4MyE5ueoa1k2PXcCuD2GEnEAQrrpBuXGd9u3HT5VuEqYJaYTPY5T+Q6pe356fh9O3Latxp5bchLy+s1U7as/7m/48ZgHi7vLImb1/NPJJKi3SLHgGV0B5bD3yU29E6vfV3ogSyZNEhIZbQ1wOKJALt6QfL2bJxWlu18c4ZDizo8G/2iiZXMA0lKhMcWBVxk0ZPD1
X-OriginatorOrg: fujitsu.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: OSZPR01MB6453.jpnprd01.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a3988482-45b6-4e79-2564-08dc629d8994
X-MS-Exchange-CrossTenant-originalarrivaltime: 22 Apr 2024 07:26:33.6715
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a19f121d-81e1-4858-a9d8-736e267fd4c7
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: TcRJ9Z78SbnbfHwILizGzuhL46r2b0fyYvkdvquJe4fVLduHxwNkBLMrJA2WLqWS/xCbGl8xnuMDDOM+bWUIlA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: TYWPR01MB10176

DQo+IC0tLS0tT3JpZ2luYWwgTWVzc2FnZS0tLS0tDQo+IEZyb206IFZlcm1hLCBWaXNoYWwgTCA8
dmlzaGFsLmwudmVybWFAaW50ZWwuY29tPg0KPiBTZW50OiBUaHVyc2RheSwgQXByaWwgMTgsIDIw
MjQgMjoxNCBBTQ0KPiBUbzogSmlhbmcsIERhdmUgPGRhdmUuamlhbmdAaW50ZWwuY29tPjsgWWFv
LCBYaW5ndGFvL+WnmiDlubjmtpsNCj4gPHlhb3h0LmZuc3RAZnVqaXRzdS5jb20+DQo+IENjOiBD
YW8sIFF1YW5xdWFuL+abuSDlhajlhaggPGNhb3FxQGZ1aml0c3UuY29tPjsgbGludXgtY3hsQHZn
ZXIua2VybmVsLm9yZzsNCj4gbnZkaW1tQGxpc3RzLmxpbnV4LmRldg0KPiBTdWJqZWN0OiBSZToN
Cj4gDQo+IE9uIFdlZCwgMjAyNC0wNC0xNyBhdCAwMjo0NiAtMDQwMCwgWWFvIFhpbmd0YW8gd3Jv
dGU6DQo+ID4NCj4gPiBIaSBEYXZlLA0KPiA+IMKgIEkgaGF2ZSBhcHBsaWVkIHRoaXMgcGF0Y2gg
aW4gbXkgZW52LCBhbmQgZG9uZSBhIGxvdCBvZiB0ZXN0aW5nLA0KPiA+IHRoaXMNCj4gPiBmZWF0
dXJlIGlzIGN1cnJlbnRseSB3b3JraW5nIGZpbmUuDQo+ID4gwqAgQnV0IGl0IGlzIG5vdCBtZXJn
ZWQgaW50byBtYXN0ZXIgYnJhbmNoIHlldCwgYXJlIHRoZXJlIGFueSB1cGRhdGVzDQo+ID4gb24g
dGhpcyBmZWF0dXJlPw0KPiANCj4gSGkgWGluZ3RhbywNCj4gDQo+IFR1cm5zIG91dCB0aGF0IEkg
aGFkIGFwcGxpZWQgdGhpcyB0byBhIGJyYW5jaCBidXQgZm9yZ290IHRvIG1lcmdlIGFuZA0KPiBw
dXNoIGl0LiBUaGFua3MgZm9yIHRoZSBwaW5nIC0gZG9uZSBub3csIGFuZCBwdXNoZWQgdG8gcGVu
ZGluZy4NCkF3ZXNvbWUsIG1hbnkgdGhhbmtzISEhDQoNCj4gDQo+ID4NCj4gPiBBc3NvY2lhdGVk
IHBhdGNoZXM6DQo+ID4NCj4gaHR0cHM6Ly9sb3JlLmtlcm5lbC5vcmcvbGludXgtY3hsLzE3MDEx
MjkyMTEwNy4yNjg3NDU3LjI3NDEyMzE5OTUxNTQ2MzkxOTcuc3QNCj4gZ2l0QGRqaWFuZzUtbW9i
bDMvDQo+ID4NCj4gaHR0cHM6Ly9sb3JlLmtlcm5lbC5vcmcvbGludXgtY3hsLzE3MDEyMDQyMzE1
OS4yNzI1OTE1LjE0NjcwODMwMzE1ODI5OTE2ODUwLnMNCj4gdGdpdEBkamlhbmc1LW1vYmwzLw0K
PiA+DQo+ID4gVGhhbmtzDQo+ID4gWGluZ3Rhbw0KDQo=
