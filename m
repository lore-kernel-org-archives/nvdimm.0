Received: from DM5PR21CU001.outbound.protection.outlook.com (mail-centralusazon11011070.outbound.protection.outlook.com [52.101.62.70])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 89FB230C631
	for <nvdimm@lists.linux.dev>; Fri, 30 Jan 2026 21:45:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.62.70
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769809523; cv=fail; b=HHZd4qa0NQhgOvaRqAULgQ23uOWy8ePMStGUl/AyZOo7TJTim7n5MW4LUZIpOMwKB7sjRb3Q9KkgzGxhAGuDabE0tvEiFcS40dX+z+v/hZCBw4jBICpLamyaerBgj7b1/JE+IT9rsWuGNUPu85pfdVEkplIB2sDOM8YVSC4jdww=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769809523; c=relaxed/simple;
	bh=a9V32aOccTPfYcCnm9vFMBYrcJfk0HvmLjT2QE372iQ=;
	h=Message-ID:Date:MIME-Version:Subject:To:CC:References:From:
	 In-Reply-To:Content-Type; b=oBqMnFShWgqK16dFvewJKBmYOBNguMyVwutTTQj4qnKKIfXYC7GSH9tc4IiRGB5wDMrTN2+UevAEvr0dEl1C4QaKehl0IayR+q4+sB0tUK+A84zZ5QRfmcSbQrcyYI5Zx0yh4+Mnb5xkuXo2wMA+9A4ZKB5VlRDZawG3oEdt6ys=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=C46cHSL7; arc=fail smtp.client-ip=52.101.62.70
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="C46cHSL7"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=effWFvmfs1iBWdU5GHI/GjDwSnZF7Plz/KSKo+e2QcAH5gcBvU8RHS2kHFh1CWaks3dB33wIDb1R5HcX1Y5jDZngr4drLOF4/gLN6kPtEMC1L2P+T6KGgHF8gKADqt25NL13DyWnSRlS8caE5xq+A6/IDJp7UFGBz2wDq5NIzd/miRtSZHB87kjSlwWEMHK1PbOCk5PUeIOJYI0jf+KhLoV1Wnfly9OlAb/bkeLmAmpPn9kM96nGwNuIEj2UxZQWc6yDivJUrA/qSBrmVa79ZCarXctJq+KqZSjyKnwLZo4cOl912ZRdVj9+fq2ESuSCxcCOZoGDFOgOeOCYnm6RSQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=gBbRwqrKKLCHPWaD4my+42vE+P+PcgIuOBEITKEAtu8=;
 b=x4w/sxbwAyJiBrC3eihbYWTr84E6S1//VhxhlCLdyRTM5lsy5Q7Lja8Enhk7qBQ9YhcW3/RVwiX3I4zkkXbZPIDhuTVie1hdBUW+feAfKd/rTEXrUWGUoOmp2AZ3DE17uwNq96ecTYq9Kqk6R4960vl55AWRw7bateEUGz1Nw0/7zKWjXMcj6Zz29DAaLsGbr3vK19dOJsDc5nIyZZLRv/XpYxUnXQpEn1BWy4DmH0qdjdsMZyoY0EWFwNYtlHaaLVxRUbx39cWsIirRW4VAyMa/oivzbBlwJ54AfSQueWUvRdRSYu33Mkq+wudNPHktvuseQUSP5i2ptyHuSJPPXA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=intel.com smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=gBbRwqrKKLCHPWaD4my+42vE+P+PcgIuOBEITKEAtu8=;
 b=C46cHSL7rhO+biKQMSxkqBY2nfYqmkdsldpmgqBJiNIp2vkHy8amddfv20fe2emdFcke8PYORTgRrwKOlpke3UOw9bKmUYNtNblhTypOcoI4yAcpsg+RyIvo4ty33cQ1RSuYBpPi4k83YK0TsyZFF0/n6YT6L4oMl6KvTTLs7Kk=
Received: from MW4PR04CA0285.namprd04.prod.outlook.com (2603:10b6:303:89::20)
 by PH0PR12MB999113.namprd12.prod.outlook.com (2603:10b6:510:38f::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9564.7; Fri, 30 Jan
 2026 21:45:16 +0000
Received: from MWH0EPF000989E9.namprd02.prod.outlook.com
 (2603:10b6:303:89:cafe::2a) by MW4PR04CA0285.outlook.office365.com
 (2603:10b6:303:89::20) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9564.11 via Frontend Transport; Fri,
 30 Jan 2026 21:44:55 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=satlexmb07.amd.com; pr=C
Received: from satlexmb07.amd.com (165.204.84.17) by
 MWH0EPF000989E9.mail.protection.outlook.com (10.167.241.136) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9564.3 via Frontend Transport; Fri, 30 Jan 2026 21:45:15 +0000
Received: from [172.31.131.86] (10.180.168.240) by satlexmb07.amd.com
 (10.181.42.216) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.17; Fri, 30 Jan
 2026 15:45:14 -0600
Message-ID: <ff553d4a-a1cd-4d23-b0a2-baf4d7aa72a6@amd.com>
Date: Fri, 30 Jan 2026 15:45:09 -0600
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 7/7] Documentation: Add docs for inject/clear-error
 commands
To: "Verma, Vishal L" <vishal.l.verma@intel.com>, "nvdimm@lists.linux.dev"
	<nvdimm@lists.linux.dev>
CC: "Schofield, Alison" <alison.schofield@intel.com>,
	"linux-cxl@vger.kernel.org" <linux-cxl@vger.kernel.org>, "Jiang, Dave"
	<dave.jiang@intel.com>
References: <20260122203728.622-1-Benjamin.Cheatham@amd.com>
 <20260122203728.622-8-Benjamin.Cheatham@amd.com>
 <4e3cf71a568f98a8349416874a7f08a5e5099799.camel@intel.com>
 <dead69ac-86ee-46ff-ab38-c964935cda13@amd.com>
 <34210a8339035800430a9d4084154e17c285ee86.camel@intel.com>
Content-Language: en-US
From: "Cheatham, Benjamin" <benjamin.cheatham@amd.com>
In-Reply-To: <34210a8339035800430a9d4084154e17c285ee86.camel@intel.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: satlexmb08.amd.com (10.181.42.217) To satlexmb07.amd.com
 (10.181.42.216)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: MWH0EPF000989E9:EE_|PH0PR12MB999113:EE_
X-MS-Office365-Filtering-Correlation-Id: ca7238c3-880c-43c2-bde1-08de6048dab8
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|82310400026|376014|36860700013|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?blIrOFllR3hrMU8ya0NieUF2Z3RXT1V3K3RJazIvNzU2dXdHbjJTZDhBWFlP?=
 =?utf-8?B?U0hiTUVoNTRDaUt6d1gyeE55SHBwdlZweWdWc240bjltRTc0K2pZUjNGY0J3?=
 =?utf-8?B?djVyZGZldS82dHVFSkFHaEw4L212NVdaMityNkpneDFROVM5eGphZUQ1Snhw?=
 =?utf-8?B?RW03OUpRMTJ5c3R6aFhlbEFMdFlieEJUYURIRVJKdkpKbDJZdnY2ZHRnMWxH?=
 =?utf-8?B?UlFsT3A5M2NXL0NDbFRSamNNOFZNT3hWKzduZUZaTkdsVEtXQlplZTdnMndV?=
 =?utf-8?B?M082Y2xGSUdjenB1eWZTUzRWdkowV2kxdXZtNUJiaXpOTXRCdVBSaXdXdDNz?=
 =?utf-8?B?SnRiZHhxSkJSR0hnM0xud2ZpQ2M1bmQ0TkcyMlk4RFpqSkFDWWJOWkhneE84?=
 =?utf-8?B?RW9pQ09oZWlveGhjTVM5dWt6UHlzZHRVdjRzRDMwblNubVVUWThWaHUvdHNK?=
 =?utf-8?B?WnR2L3lMYSsrK1RrVk5OV3dlcUxTN0JjcUxhclhMVmRPa2pRYlF1NW54Z253?=
 =?utf-8?B?RC9GejBobjF4K1dJQzRzRlEyM0RZZDF0bzhDWEFjcHprRGJkOEJIVmo0RGtD?=
 =?utf-8?B?NHk0dGdMWFR6U0Z1RjNJLzBUWm5jdU9QVmRhS1prbFFRZCtJbnAxSlZLZFhK?=
 =?utf-8?B?NEdzTUFvY21jSURyYWdWVWtPVVJUemFIbUYybkJIZEp5RFl5c1UrZVdmOFJP?=
 =?utf-8?B?cGNsNmlZMFFVaEdrQVYyQ2tab3RzbkFpTzZKQmhPZEUwYkx5NkRHTm5yclEx?=
 =?utf-8?B?ZGtxalNZRHVJRDZoM0FOc3JqbkFjZXlvQlJZWktsN25uYU1HYWpha0tIVzJ1?=
 =?utf-8?B?Uzd6YVFlZ0lYclVBTERnKy9ZclJCeVU1bWxDOW9VK0h6elhFRHlvRDVkb0dy?=
 =?utf-8?B?Vm1uMlV4V3JWVmUrci8wMnY2MUw1SUkzM2lDdHZxaXV0eFRaMWV0RlV1VWRP?=
 =?utf-8?B?dGJaRFpYd0hSSmhLaEVldWpiMTNOT1MxQ0ZZd1pIT1AwMkI2NlZXQ3ZnUW93?=
 =?utf-8?B?bFVWcTJMRm5SUU9SSU1XVFVTRndHVzY4QVdqa05FQXFUZXIxMzJ5bDhVWWhh?=
 =?utf-8?B?UCtqcHE5WjhXWm4zNzhHMUxwZTc0RGZvSGUya1RBVHc2VWNIY3VrZFNYRWVF?=
 =?utf-8?B?aHhkblBzZ0Z5cG1DYVBvc3dNZmRiZCt0UHhPVEZBKzN1aVNhbDdZZ3pUaWUy?=
 =?utf-8?B?aFFSd2U2Y0pKVjh2d3NvWTYrUWF3bnhiSUpaRjRkbXBaa2hGc1liaGd0b0Q3?=
 =?utf-8?B?OUl6cnREekh3NkZGbG90NGt3R3hDNGtFWW05cXRrNXZPM1VCTWZjNmdzbmdh?=
 =?utf-8?B?aFpzams0cVg3aXE4bUh2Zjl5d05vTTNNT0oyMldwZXVOR04rV1RvSmpJbWQ4?=
 =?utf-8?B?V0lYb3lYeVp3MWpPcFNOa1lDdXRPZFQzRUFVenVlcTlxMVA1RXNpNnIwbisr?=
 =?utf-8?B?QWRuVlVwK3RUTTV0U2lJZUtCS1ZFTzBxd3ZyZ3NQTGJKYldCU1BXUU03Rktw?=
 =?utf-8?B?bnV4dHorMWgzS0JRbkJiQk1UUTJVNFpmcE8zVlY4eTZtMFZQUkE2Z0lqNndw?=
 =?utf-8?B?c1hranFBQTQxaDA2ZWJIMWxtRUlRRDZ3c0UxTGdId2YxNG1UR3ZpWkRSRHJD?=
 =?utf-8?B?ekNNa28ycGtWYzlqVTAwM1IrVjBwckJEQWZPWWtzVWZISmphWTlydENjNisw?=
 =?utf-8?B?K1M3NEQyMjdjcjVJRTNtUEpDSFhiR0tHSGRSU0Zpd1ExdmpSTGJkVkE3M1Jt?=
 =?utf-8?B?ZUcwTjI4REtUdTRiUThuOS9iUWQrZllmUUN2ZW0zMEl6YWNTY0E3aFcvZDVt?=
 =?utf-8?B?Zy9kOXM4alR4NG44algzUEl0UmpIQ2Npa3Z6Z2pvclgxRVo5TlNxeW9ONXVw?=
 =?utf-8?B?SHQ3ZGdFYVpnTE5BaWFJc1V1ZmJsS1NuQ29tSjY0cGVXb3FFRm1oMFV2L0VG?=
 =?utf-8?B?bVBER3h1eStpMkoxRXU5OEFlYy8yQWducWpGWFRPWXk0a041UjUxdkduYzNq?=
 =?utf-8?B?NW9tblA4R2cvbFk5N09yM1Zkc1NwU3I1UVRJTVh5YTBBRzArN1dIUVV0L2hq?=
 =?utf-8?B?QnkzRStDQjJtZG94bGM1RTZNLzM0STU1eWVtd1lLeHhNVGF3SnMxc1NLRWR4?=
 =?utf-8?B?Y0VOYmRqcDRaakRtRWc4d2s0bndKTjNSL2hOdXRnVmhEaHZzWkNYcHliY0VI?=
 =?utf-8?B?dUZWblBBYmFob0VUbXBkVVBBcktHTml6SU5GWUIyM00wNGtwcVdYWndocDIz?=
 =?utf-8?B?RW1CaWFwakJNQUVGM2V0ZWM2RjlBPT0=?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:satlexmb07.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(82310400026)(376014)(36860700013)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	sBURg1I7HSjpwBUOfRyiuM6WUlAt/kg8SkdWYK7+DJ0X7FG6wu3+/rXQzAmS8gCL4KzoXS6ihsT02cnh4vcpmYNNZolSDLHSLaE5qB9Rz0JeYCX0TPO9bfR3QvWA2FUcieBBzM35THTfF3nm7o+O2y7XK4Lj5mBZFWjpbfE3BCLYzTrot+MShmKq1DAV4ak4D6WbIHUcxoZTo6Bgfpap3SqZiVG5kjDXG2XbczjZ7AukOd7bM9mJjj+NjxbiZJ2HAp5AErhIgYiTzEa7T+A3POkDKUSoYYq1R4uEIHXb2A+KaBYXwauh5NKnBpzNEm2JrpG4rqjP1H23XlGTil9gZJAgrSQKSwbyqu5KAKURD03aGAZErWJxalQcEAZAEwNgks0lkHAaDLJvn0G0n0TL1BR71E+6fp7YKi3YuS8GEJItb8CyIt9Z/45raGhYO3bP
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Jan 2026 21:45:15.5329
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: ca7238c3-880c-43c2-bde1-08de6048dab8
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[satlexmb07.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	MWH0EPF000989E9.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR12MB999113

On 1/30/2026 2:58 PM, Verma, Vishal L wrote:
> On Fri, 2026-01-30 at 13:59 -0600, Cheatham, Benjamin wrote:
>>>
>>> It feels to me like the two injection 'modes' should really be two
>>> separate commands, especially since they act on different classes of
>>> targets.
>>>
>>> So essentially, split both the injection and clear commands into:
>>>
>>> inject-protocol-error
>>> inject-media-error
>>> clear-protocol-error
>>> clear-media-error.
>>
>> This seems reasonable but I should clarify it would only be 3 commands,
>> clear-protocol-error wouldn't be a thing since there's only an injection
>> action for protocol errors.
> 
> Ah I see, makes sense on 3 commands. I assume the clear command would
> still be clear-media-error for symmetry.
> 
>>
>> Should I keep this all in one file or split into two separate files
>> on protocol/media error lines? Could also do inject/clear files if that
>> seems more logical.
> 
> For the code - a single inject.c file probably seems fine. There's
> precedent of implementing multiple related commands in one file, and it
> makes sense to me here.

Ok, sounds good.

> 
>>>
>>> That way the target operands for them are well defined - i.e. port
>>> objects for protocol errors and memdevs for media errors.
>>>
>>>
>>> Another thing - and I'm not too attached to either way for this -
>>>
>>> The -t 'long-string' feels a bit awkward. Could it be split into
>>> something like:
>>>
>>>   --target={mem,cache} --type={correctable,uncorrectable,fatal}
>>>
>>> And then 'compose' the actual thing being injected from those options?
>>> Or is that unnecessary gymnastics?
>>>
>>
>> No, I like that idea. I do think the argument names could be better though.
>> What about:
>>
>> 	# inject-protocol-error <port> --protocol={mem,cache} --severity={correctable,uncorrectable,fatal}
>>
>> with the short flags for --protocol and --severity being -p and -s, respectively?
> 
> Yes, I like those better!
> 
>>
>> For inject/clear-media-error it could stay as-is, i.e.:
>>
>> 	# inject-media-error <memdev> -t={poison} -a=<device physical address>
>>
>> or I could update it to be something like:
>>
>> 	# inject-media-error <memdev> --poison -a=<device physical address>
> 
> Either of those seems reasonable to me. What's the possibility of a
> /lot/ of types getting added? Probably small? If so, maybe --poison is
> cleanest, no string parsing needed.

I'm not sure, but I doubt it's many. I'll look into it and if it's less than ~5 or
so I'll change it to --poison.

Thanks,
Ben
