Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DB7F01D6A8;
	Tue, 27 Feb 2024 20:25:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709065510; cv=fail; b=DM5of9isL1Xthek5t64p2KZ6jONOZMkwWAiWGIuUL3mSgJae0Dm9W2rLaw43CFxWRovv9HNzwhW2KOkOGfH5XTu3/fIawrbvzfcNuRwLlBHpMqSJGW2q76PBaLvteD4uZE2pntaZgpJhaR9nrMccAE7jIFS9VZ6CaatZ5l9bX40=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709065510; c=relaxed/simple;
	bh=1xb7chs3nORmBdpXocq1uHgB/soGRgvzD9UkfOfoBsk=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=tiOHU3LFzXoSicdGe1/AEQlyfilO+BNnVRLibKT2XHjA8UVfltxsR3HICR7tLd0dOZcomenIL3HlXEtk0/8X3n7DsJuhqjq7F5ozmivBJCIZfxLjXVxABxxeZKZake9FRnnyGU54+362A+D/xq0ZHQVa42yjGuNUM4rHL0cIyqc=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=jI63n2m1; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=H2X3ixyB; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="jI63n2m1";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="H2X3ixyB"
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 41RKJTRm027467;
	Tue, 27 Feb 2024 20:25:05 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2023-11-20;
 bh=yVpBKpMyT19SZwJah23gH38Z05LGdQh+4/YIe6kC4O8=;
 b=jI63n2m1fqxhnvbrUuxgeXrc+Rej3rHD0jbfa0EIvsZiC+CtEmXWnJ470kbxzREG3UxU
 Bw4ss4wfKM4eIbSiBr3ycr9Bbo5+Ufxu0ORhkBWgu5SwJl5pBtJCTcrtgx05rPSOomtX
 rKXbQCHn8t5mc91tZ2mGoGG9L1P4f2kC8EF17PzBxQfd53ML2beK8efmiDGEXctlqSMu
 mjQ3YPmv6SLl6odyU6kU16VTuuJDQiFYrS2cWG1syyS/JqTWSXNAtlSxvepFZ5QsFQxJ
 b9/4U8+oxDODv+m3u3ugEZmiWDo5xWj7aBagA6q1TNuDqNCxwB+DeD4Jiq6BaKxPHSoK Uw== 
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3wf8bb87f2-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 27 Feb 2024 20:25:05 +0000
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 41RIvRlU015246;
	Tue, 27 Feb 2024 20:25:04 GMT
Received: from nam02-dm3-obe.outbound.protection.outlook.com (mail-dm3nam02lp2041.outbound.protection.outlook.com [104.47.56.41])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3wf6w81cdv-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 27 Feb 2024 20:25:04 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=IobQLgV2N0PNW0nvyImNHfrD7WsCTfAVrcJABV4qFZ+esEuRIgnjKQs6lX42/OedYALCxcwRLpyafKOb7o8SfVw6nmanXJTy31CNChs7G0yWoeNFg3Tj9X3Pou1u63zifqBBe1J6zoAuUWY3KwuEujF5bCiJZeIPr0iD7BaA5c8fahXjiB0HP+k5CT9EwWOnr09OmfqyKa2l8Wb6SxQBi+V8nPz7sCjj3PyeDoNnmgsbGnFe+3/kDB/RTyI6+mI5PFRkL+g1gb5pb+27IS8+BTKT81OboaS28IG/XiPH72v+c4CMwqIZnx6D+LithGOqAaeQqtgDaSfU8PZcvHYJwg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=yVpBKpMyT19SZwJah23gH38Z05LGdQh+4/YIe6kC4O8=;
 b=gaw/dlpw1P/ZmysPRS/yyfxp8rF22Rc+zE6EC3EBIbgWfdHEHFHJi16JHgyOpFCaD6jVLrxlCVUXQQZ8aVsjCcZaav7MDooDI9+BJin0agLrYXUxWRxcVUgoJqvKnlGag+fw5uMbuwt78haw/7e7l6f7FbPdhPaxx43ufrcfpU7a94h9iQUP1IHdvaa+bZH6v5CYSvx41z9HSdLTcFs2EvmTUOGywzZ0BT9bPkLSoJwYnsE5M9K67GvVKRHh5uHy9xdFnuyC3XbffGCg+6T1++cRFzFgVKcF9kZkxKr4IWH/1frQ15U+NMONzHPwYAY0zvZ7caAoIYAvLxnWmh/YQQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=yVpBKpMyT19SZwJah23gH38Z05LGdQh+4/YIe6kC4O8=;
 b=H2X3ixyBC5kyQ57A5q0Y04eb6QyJpKutoy1d9RysnjJFYQ7hu22laxXsxmua8PPMf6zpYzOxFmSmlFPkkNm1f3RPjVW2reqMLtZq9g9svyBmhIlqAueI7+71VSjBHf4+umnHVs6GrZ5joVvjkJOljmmAI6vr2OiYQgrSs4skzS0=
Received: from SJ0PR10MB4429.namprd10.prod.outlook.com (2603:10b6:a03:2d1::14)
 by PH0PR10MB4789.namprd10.prod.outlook.com (2603:10b6:510:3c::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7316.39; Tue, 27 Feb
 2024 20:24:59 +0000
Received: from SJ0PR10MB4429.namprd10.prod.outlook.com
 ([fe80::210e:eea7:3142:6088]) by SJ0PR10MB4429.namprd10.prod.outlook.com
 ([fe80::210e:eea7:3142:6088%5]) with mapi id 15.20.7316.035; Tue, 27 Feb 2024
 20:24:59 +0000
Message-ID: <ebe3f86f-d3f9-414d-9749-7d41ac7d3404@oracle.com>
Date: Tue, 27 Feb 2024 12:24:55 -0800
User-Agent: Mozilla Thunderbird
Subject: Re: Question about forcing 'disable-memdev'
Content-Language: en-US
To: Dave Jiang <dave.jiang@intel.com>,
        =?UTF-8?B?Q2FvLCBRdWFucXVhbi/mm7kg?=
 =?UTF-8?B?5YWo5YWo?= <caoqq@fujitsu.com>,
        linux-cxl@vger.kernel.org, nvdimm@lists.linux.dev
Cc: vishal.l.verma@intel.com
References: <3788c116-50aa-ae97-adca-af6559f5c59a@fujitsu.com>
 <dd61a8f2-ef80-46cc-8033-b3a4b987b3f4@intel.com>
From: Jane Chu <jane.chu@oracle.com>
In-Reply-To: <dd61a8f2-ef80-46cc-8033-b3a4b987b3f4@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: BYAPR07CA0023.namprd07.prod.outlook.com
 (2603:10b6:a02:bc::36) To SJ0PR10MB4429.namprd10.prod.outlook.com
 (2603:10b6:a03:2d1::14)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ0PR10MB4429:EE_|PH0PR10MB4789:EE_
X-MS-Office365-Filtering-Correlation-Id: d030a766-3124-4c6b-30a7-08dc37d22b99
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 
	aCrWjDPmVaSEVaEAKIWIxGdQJeKI+Gh0MSLk6GSzqdfiDtw1lnFJnqbZIJLjganFCESsS0GTleBrQhgzrBB965B3yeJjo+2e6BEvsXEN51oz+Tb/2tZPA6zwApwV6GrUU4al+cEqBEto8uwt/q9By5wl5S2hS66w4tyudBSQD5WB4yT7Z3Mj7RJgJZZEYLI8+tquo54kqv7VOJn+MfwV/LxwNN0UVEYlMEZyYYsW1o4QY5bH35B8DO7V2hIxDOD9bGseLNdVeAmaIdsy7GH7Mcu3mUyMpnUOxzIJKSMA0K5H3hEuLKddqCsQE8c3gVCq2MxQ9bUM65RAkR63sBGDTNoXldfReTmLswXoCvjlGRRJIGloZe02dfpcFAL/OfIGKUbnkZxCtiWtdJH91oLsIRGtckzveUIyowSCfF8/Ud/VfYE14uxhgfdFQVisQo738wGELxMV4b6omW8Exn6CqtQaK/Wnk7GhkrSCpOgSzurlM5tW4M5Xgrh5kKgyrfbQ5erRdbOeg4U36guU7LgK9wIzRx83bm4/dByDZDyLqw6tXRjngwTN9EZ81cNrWZFA74Ymjs856UK5M2sfFpVSjiPFRpiJiROY30ZERpCnCeSh8I+jqehvHamEK71G+K/N
X-Forefront-Antispam-Report: 
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ0PR10MB4429.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: 
	=?utf-8?B?RzQxY3krb0tVNzdicElWRERtQUZyTGFBNUswQW4vOWhyZDdEQzY3LytUUW9W?=
 =?utf-8?B?WExuazBPUldNN1NqQkRJVTV1QURpM1FVcUVYbzd0aTgxL1Y4ckJ4cDdyb0pD?=
 =?utf-8?B?eEYzL1UxSHJ4QTFDWnREeHc2K1lmakgvSEVNVG5iaXl2My9NOEdqRU11Zm5D?=
 =?utf-8?B?UmRWb2x4TGcyb1FFQ2pscCtPTHFGK1NWU1F5cVpmTEpXaXNTRlcxYXgrQS8y?=
 =?utf-8?B?d09LNHFIS3JzZ2JCWnpSSDhnVTZuOVBhUXlFcVhlZm5MejFLK2pzSEYwTTMz?=
 =?utf-8?B?SGVjQ3R1Nk56MkpmU1RhZjFKa2IrWGNWZ1BrQVFUR2padStBdHArQTkwd0pZ?=
 =?utf-8?B?NmVCRC9GMC9wMUZhZ096aVMyK0tma0hYaHpIRWlKbkwxK3U1QkZiK0hsT2ZR?=
 =?utf-8?B?L2c5KzZHdnlvcmNYeTBLdDNOOXFGQVVzNkFVY1FPdUxSQWRNS2xvcEtBQ3dl?=
 =?utf-8?B?MDBTeGhQeGM0TGRrU2l1MXBxSUFBYzBYanZWbk9HeUJCTEo3MFF2M0U4UEIz?=
 =?utf-8?B?amlCblZlSEt5b2NwUnpCaDVIQjBjb1NhdWhFSmZpay9UWk9ESDlVTVZmYWhi?=
 =?utf-8?B?aGtCZEhJd3luMWRZZFFMNmR5QUdTTWpibjRsNHZpZzJOUkhLRUlFRnZQR0JL?=
 =?utf-8?B?SGYxdVBxbHpBSnhrZVgrSTgwK2RvSTZiVDJINytTbUtMek9vSVpBMXNYRG5Y?=
 =?utf-8?B?elVybC9QSlB2OFJTQXh4cWQxcS9ON2VJUkRuVnFaOFhKNGJrZzNESHRLU1JG?=
 =?utf-8?B?ZFQwYXIyallMUlk2WmMvTDVScktkem16U2F6dGdmbWpoLzBEbTJyMDZEWFNV?=
 =?utf-8?B?SWlKZHlKc1lRTVk3N2xCaGExbS9TL0tOQ2VKeTI5VlpDV0ZOWUNZVkoxNUhv?=
 =?utf-8?B?cGp2VU5RS2dXZTUrbWl5VXhXSGtSYWh4Qm04T3FXakFWaDNLUE13WmZwNVVx?=
 =?utf-8?B?aDZyUmRlSDgyTjV5UHIyUzRCd0tWTHNkR3JxM0duSFQ5QnRPRmprdHY4WGFh?=
 =?utf-8?B?NDFOYUYrQUM5Mnh4MVJCSHkxMnFmUDhKYk5WTzVIUGJCN3ptWGFhMjdiNDRF?=
 =?utf-8?B?OFZtM1BNMWlpZG1iQUJKNER0c1huN25zMnlwNS9Dd3hndFN2di91blM0VDFR?=
 =?utf-8?B?MHExelAwd01TUWRhaVMxM0l6SGxHWDV1V1BhUHZWNjFsUjNnbm81N094M29l?=
 =?utf-8?B?NGpvRVU2bVBPdGZJaGV3UStxUkpjekp0dzREeWJxSGlpUFFpSTA0MG1YbFU2?=
 =?utf-8?B?cDQ0cENNL1FRbTYvVTljKzFGZnVmMUpLTHJCaG1rRGpJaUdDWHVVbXR3b0hR?=
 =?utf-8?B?MEN6NVY0M2JrR090UGxnRlJUM1hUYVdnVmwrSkNaM25oNUc5TE96VDcyaHJm?=
 =?utf-8?B?Z1UrUVpidXhpY20rT05qd21TZDBidXdORzdCaHVKQ25KTkZDZnJzR2p5QWlr?=
 =?utf-8?B?Umk3VXh4Q2hsRFNkbllaUUJHWnNkMnM4RlV4S2FXd1BaSE0wcS9KMmkxN0p5?=
 =?utf-8?B?QkFXRVRZM1RVZExqR0lzejhDTWYzQjNkampqNXJCeVA2SGZ6UFVzRW83bk9r?=
 =?utf-8?B?bS9kNFRZelJFK1U5ZkU4aElaS0xTOFh1eCsxajkxa2YxL2VnUDcwSmxGZGlJ?=
 =?utf-8?B?a2NsbHNNbUJtUlpYblg2WWRQdEdrWjdNQjlMTmRlWU04Y21RRC9WSTU3RGdL?=
 =?utf-8?B?OVF2N3ZVU2pyU1FUQ2JsaU0rUHVtRFdVNFJsOHB5Q1VYVmVZcmZSelorK2Rx?=
 =?utf-8?B?UHgweG42S3Bna09sbGRHczJTYnRrWVlmV3BQOVRxSlhjNW5yQW5iVXlmQ2Jk?=
 =?utf-8?B?UVBEM3daV3d3YWl4dTdENVRWUnZrVFdOWXNsZEk2bWlqQnRIQ28zWFVCUGE2?=
 =?utf-8?B?RWtuUFNhSGZzT2NveTNhY0NrNW53WVJ4a2VDeDBIU0crL3IrSXRpanVKb0xT?=
 =?utf-8?B?ZEovRERCMjVZT1BrOStzZTBnRExCOTNuUk9FblhsYStmbWM5cGhIK0I4a21T?=
 =?utf-8?B?czJ2cWF2ekpMUEkrK0JBUTI2NzdTVG13N2svbUNQQzNQNWltalVWZERPRWh0?=
 =?utf-8?B?OWJWYTJiRjVJRW04eXRoUFpwOWtLamZpMmkwaGQ4bTBwWG5kOTViTUZPWVVU?=
 =?utf-8?Q?hhwfYedoSclVqa0gNZflikEvD?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: 
	rk2G7alKjP7goOm5asKDwoGKBtPtCeDg2FxQ9kNSPFW0TME1u4jf9rBf5RGvmN3+6eb9cp4qfS7ZfwnHJ97He4hvdYlEA/XtBi6tFlUVNnw4FSdgBaMP27RIRAlXD23nnyEG6tnULVrr1R2jjjY9jJSSBC2b4Ym7jyxcljUOAeL/36t0985HlS97A1iAhKCVBqKRwRGyvi+m48eokM6m22EPDJIh7rdWZKoK9yOdU132um1ND1qOoe7MFehpNDdIKwa3KBRDizJEeRqpl6uyUwIhDP/3qFJztjrbKJnW67E3XOHF61moeTJ+C1VmWUjPKJW0jzQUAUjnWQS9FXJG4c4sYy5jsdEqwEpZot1yNWT+ywsd4y7i8UrLMsJBZLGSD8OV6rGXJB3S9JUK+DP0EhEkFsRcSz75FipVFdW2s0pREvoIZvrUkcYm0TEc7HxT4q5zlCsyvmOTYGycr4e1HirPLY6wdLVV+mhoVXd7jBqs/qp2HoJdaaIkQET5D6OclTT0q09yDqMuO0ggd3WUBjQ6ChZzPBu3gpUxRCSr8MIa9kmtz+Fmyj9ZyF48E/dWzkGabzE0oJyOULnEsGiWXHLwxSIW/ZI5DP0POhghDPw=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d030a766-3124-4c6b-30a7-08dc37d22b99
X-MS-Exchange-CrossTenant-AuthSource: SJ0PR10MB4429.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Feb 2024 20:24:59.5382
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: p9tpoOpZCGi31KBlpNJRyNq6rCuiDZD/zF0Y4qQt/vNDzQUfG2a9EfFpQXOeR1ZvL6UfNZLx6GCGyKZU+meTrg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB4789
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.272,Aquarius:18.0.1011,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2024-02-27_07,2024-02-27_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 suspectscore=0 phishscore=0
 spamscore=0 mlxlogscore=999 malwarescore=0 adultscore=0 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2311290000
 definitions=main-2402270159
X-Proofpoint-GUID: rXyCh77L2TIUYbRyPqQwnbzBiKdJmuiJ
X-Proofpoint-ORIG-GUID: rXyCh77L2TIUYbRyPqQwnbzBiKdJmuiJ

On 2/27/2024 8:40 AM, Dave Jiang wrote:

>
> On 2/26/24 10:32 PM, Cao, Quanquan/曹 全全 wrote:
>> Hi, Dave
>>
>> On the basis of this patch, I conducted some tests and encountered unexpected errors. I would like to inquire whether the design here is reasonable? Below are the steps of my testing:
>>
>> Link: https://lore.kernel.org/linux-cxl/170138109724.2882696.123294980050048623.stgit@djiang5-mobl3/
>>
>>
>> Problem description: after creating a region, directly forcing 'disable-memdev' and then consuming memory leads to a kernel panic.
> If you are forcing memory disable when the memory cannot be offlined, then this behavior is expected. You are ripping the memory away from underneath kernel mm. The reason the check was added is to prevent the users from doing exactly that.

Since user is doing the illegal thing, shouldn't that lead to SIGBUS or 
SIGKILL ?

thanks,

-jane

>
>>
>> Test environment:
>> KERNEL    6.8.0-rc1
>> QEMU    8.2.0-rc4
>>
>> Test steps：
>>        step1: set memory auto_online to movable zones.
>>             echo online_movable > /sys/devices/system/memory/auto_online_blocks
>>        step2: create region
>>             cxl create-region -t ram -d decoder0.0 -m mem0
>>        step3: disable memdev
>>             cxl disable-memdev mem0 -f
>>        step4: consum CXL memory
>>             ./consumemem   <------kernel panic
>>
>> numactl node status:
>>        step1: numactl -H
>>
>>      available: 2 nodes (0-1)
>>      node 0 cpus: 0 1
>>      node 0 size: 968 MB
>>      node 0 free: 664 MB
>>      node 1 cpus: 2 3
>>      node 1 size: 683 MB
>>      node 1 free: 333 MB
>>      node distances:
>>      node   0   1
>>        0:  10  20
>>
>>      step2: numactl -H
>>
>>      available: 3 nodes (0-2)
>>      node 0 cpus: 0 1
>>      node 0 size: 968 MB
>>      node 0 free: 677 MB
>>      node 1 cpus: 2 3
>>      node 1 size: 683 MB
>>      node 1 free: 333 MB
>>      node 2 cpus:
>>      node 2 size: 256 MB
>>      node 2 free: 256 MB
>>      node distances:
>>      node   0   1   2
>>        0:  10  20  20
>>        1:  20  10  20
>>        2:  20  20  10
>>
>>      step3: numactl -H
>>
>>      available: 3 nodes (0-2)
>>      node 0 cpus: 0 1
>>      node 0 size: 968 MB
>>      node 0 free: 686 MB
>>      node 1 cpus: 2 3
>>      node 1 size: 683 MB
>>      node 1 free: 336 MB
>>      node 2 cpus:
>>      node 2 size: 256 MB
>>      node 2 free: 256 MB
>>      node distances:
>>      node   0   1   2
>>        0:  10  20  20
>>        1:  20  10  20
>>        2:  20  20  10
