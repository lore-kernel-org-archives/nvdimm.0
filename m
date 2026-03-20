Received: from CY3PR05CU001.outbound.protection.outlook.com (mail-westcentralusazon11013060.outbound.protection.outlook.com [40.93.201.60])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6656335836B
	for <nvdimm@lists.linux.dev>; Fri, 20 Mar 2026 20:42:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.93.201.60
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774039339; cv=fail; b=mogSJnF19k6cLpcbNm9BzLkkRC87+GJUcTBUV23eGpYwn1+8UtCmnUuuKmbTp2Xi/1BFTSvNnNtOFIsXg9s/UI4BqbT9hyielE2BZgjyQp7kSviFNFqPegMbjEBfoDLykUnGG/sI0YF+vjOiCAAG5C3pPvA0a7byOAwTfPr/efQ=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774039339; c=relaxed/simple;
	bh=ifwb3hWY+bXSyFp22Qz/KNefnraPja4ebQr0B9cXCQk=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=VDXp8gObLutQRtHQoO1gA2BvbWjZRizDBJIdwf2ylUU+PLiX9ConCoEeM/0+4no6bjatH/PQkBCLCr3OvHGDtmLJBhcJ+onrlBbgoaHuTVyLsN8d3ApF2MEpuIAjhPVcdQDlT1ziPDWY+eR7ywclcaKxuAd3wvH7ejPTdWuh/wo=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=Mn+R2gjf; arc=fail smtp.client-ip=40.93.201.60
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="Mn+R2gjf"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=oysz1pGkDV8Gu37cgiDJ/JZzIl5ik2K+XRtORoveshL8YspcZ7P4XpgjC/h4evk/jPLpB2XNCCNxWqh3o4fIJlBhOfMbNfe9n3X/jm8WsETdjkRzsspfm5AOfds0ALVWL8smKN8HnfcZu6dQhkKg+XYQTCmW0AxCRgKZIy4p8h14sbCfwrTTMCz8lPkvSDTlLI/JiqEIov8NDUgPIJbW3Ios9x3gpFv8BwzrcK6r7DN9hUx2s/LfdERHG7KK8Y5PZ720fF18IarX/FH8cuuJ0P1Eud6SSYQEOX/tpf8gwf4BdC1iopC+TaUS0lywpesOzQDLo6+QXBIE73EY7YN2Zg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=i31aUGda9HUGX+xiejsGfvSlhcsm97u+js6zmP0sF4s=;
 b=oekhO6aNychUafLObDCCYj7EwLaCq8JrkwoVtYCq4M9/wXhxea1bbkL0bwpYRoHlJoOdkXDsyXkK+gnklKgJbOCD5EBBZaf3PpApbH7n/khYGz6KJkQfjEphC3jaEUI+gnyN/GTTyh11FczcSox3cEi9xIPTpXsW8iuv+z5m2q00af5I+qaWlu6y9VKXwlRYHwAzbQhobnItgmCU+Bax1BWBqK7/AKz1895PRQK5Y9tPrjJSFXy31NuVMh/EYHrEy0jrVmhyGzbs38ErJm7HovOua1mooLyuZVEq2hVMpcbNIz4qS1AD3WoZ+dJFqT3JaoxwckOAVxhbB6JaZBQ5dA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=i31aUGda9HUGX+xiejsGfvSlhcsm97u+js6zmP0sF4s=;
 b=Mn+R2gjf3DxseCFCsSYiS57i8Y2EwVTbcVfePRS0JOZia1A+ViQcyz/AElQqj87oytWp/fVsSxERRxIDwRqQLb2w8IHAb6rFEjNTIrkQF/zhmX7HXsGi32HvXuBLZ8NkvLxnR3NIHXyL4GFeQLU/+atzwDxycnzyNspXhwMYOZw=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from LV8PR12MB9714.namprd12.prod.outlook.com (2603:10b6:408:2a0::5)
 by PH0PR12MB7790.namprd12.prod.outlook.com (2603:10b6:510:289::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9745.9; Fri, 20 Mar
 2026 20:42:13 +0000
Received: from LV8PR12MB9714.namprd12.prod.outlook.com
 ([fe80::8c9f:3a5b:974b:99c6]) by LV8PR12MB9714.namprd12.prod.outlook.com
 ([fe80::8c9f:3a5b:974b:99c6%6]) with mapi id 15.20.9745.012; Fri, 20 Mar 2026
 20:42:12 +0000
Message-ID: <d0eda358-d1fa-4ec1-8a0d-53fd6777ff8d@amd.com>
Date: Fri, 20 Mar 2026 13:42:07 -0700
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v7 3/7] dax/cxl, hmem: Initialize hmem early and defer
 dax_cxl binding
To: Dan Williams <dan.j.williams@intel.com>,
 Alison Schofield <alison.schofield@intel.com>,
 Smita Koralahalli <Smita.KoralahalliChannabasappa@amd.com>,
 Jonathan Cameron <jonathan.cameron@huawei.com>
Cc: linux-cxl@vger.kernel.org, linux-kernel@vger.kernel.org,
 nvdimm@lists.linux.dev, linux-fsdevel@vger.kernel.org,
 linux-pm@vger.kernel.org, Ard Biesheuvel <ardb@kernel.org>,
 Vishal Verma <vishal.l.verma@intel.com>, Ira Weiny <ira.weiny@intel.com>,
 Yazen Ghannam <yazen.ghannam@amd.com>, Dave Jiang <dave.jiang@intel.com>,
 Davidlohr Bueso <dave@stgolabs.net>, Matthew Wilcox <willy@infradead.org>,
 Jan Kara <jack@suse.cz>, "Rafael J . Wysocki" <rafael@kernel.org>,
 Len Brown <len.brown@intel.com>, Pavel Machek <pavel@kernel.org>,
 Li Ming <ming.li@zohomail.com>, Jeff Johnson
 <jeff.johnson@oss.qualcomm.com>, Ying Huang <huang.ying.caritas@gmail.com>,
 Yao Xingtao <yaoxt.fnst@fujitsu.com>, Peter Zijlstra <peterz@infradead.org>,
 Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
 Nathan Fontenot <nathan.fontenot@amd.com>,
 Terry Bowman <terry.bowman@amd.com>, Robert Richter <rrichter@amd.com>,
 Benjamin Cheatham <benjamin.cheatham@amd.com>,
 Zhijian Li <lizhijian@fujitsu.com>, Borislav Petkov <bp@alien8.de>,
 Tomasz Wolski <tomasz.wolski@fujitsu.com>
References: <20260319011500.241426-1-Smita.KoralahalliChannabasappa@amd.com>
 <20260319011500.241426-4-Smita.KoralahalliChannabasappa@amd.com>
 <abuOLq6bMPa0nNAL@aschofie-mobl2.lan>
 <3590e2d5-e768-4180-82a0-c972101f3440@amd.com>
 <b56f55b1-4281-4edf-8aa4-27d0500ebd60@amd.com>
 <69bc81bfa9baa_7ee310093@dwillia2-mobl4.notmuch>
Content-Language: en-US
From: "Koralahalli Channabasappa, Smita" <skoralah@amd.com>
In-Reply-To: <69bc81bfa9baa_7ee310093@dwillia2-mobl4.notmuch>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: SJ0PR05CA0093.namprd05.prod.outlook.com
 (2603:10b6:a03:334::8) To LV8PR12MB9714.namprd12.prod.outlook.com
 (2603:10b6:408:2a0::5)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV8PR12MB9714:EE_|PH0PR12MB7790:EE_
X-MS-Office365-Filtering-Correlation-Id: 75554cd3-c299-4f54-94d6-08de86c129bc
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|7416014|376014|1800799024|18002099003|22082099003|56012099003;
X-Microsoft-Antispam-Message-Info:
	W2B+70CuqsgL0oz0aP2wNAFH6ySiE0BxPHeMogAvBB1o1nXWaRA0wouoNrjNZn73TAPMANPQSbOy5BIqVstSHrg4m3oeshT9sMBNcYZeA/M0VKck3kChDe5Aj1lFghNtFw5UvNBfGhGW29CGJcZ94loKCkAtiDU0fYWQ/5D/1dMjpVuzUpi/liazMyXc7Fdn29Jv/VfjBb0LozExAOorAlevcwQO5VgZL4PFzUHt3pJmxON1ZvUxRSsqPTSgQVk7mvM4An8p+F5J2Ta/uy+kuw+Mg4bRN0QVo/zKOo/0zulOrq8b2y0y6DsBYtBAdzzITN8RXVT8pzEYNRSO/tw0G7wrvP6vXoUjLWvOUUvbMkSYVLoL26BLvaS0fhAjP8umxRNBB8hbEgCUKvla+vEqlUW52TgyyqOjjM1UDINIILF1ffpuKe8ZEJuJA0rEcij5BU9BCHEO9aRNRzFc0qCgnZHI06qMEJzuqi4hBgnzM1fgyilRxE8dYVooWx0+dil4Ivw6YHGG4TersQG5YzsF9sXw87BQUTEo17OW3oXfSN/z/VQ7PLLiHpcchK9ElJviF0V9roisXJ17yNwKH9LuV7nw933dpZeP1nYNgBUzLrR0NkgWBfTCKknQwz6GFo6Bg03A92kNFtbCpcd3VBa8fntqZneetVvDRPPVTaH+GlShsmSepNuYw2ExOG5wmOMfqGAslL/TPDKIzwZEhtzIV//inh/gdZse8QcLN1gWJDc=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV8PR12MB9714.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(7416014)(376014)(1800799024)(18002099003)(22082099003)(56012099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?Ym4vUDVHVWZBUnVCZ2tjOStxaGphSjIxUzNFM1hsQ0FLbW1Bcyt1dlpzTzA3?=
 =?utf-8?B?eGpYa2NvVytOWTVaQllIcUpGOHl2ZjVsOXM2cWhSQlJ6MzBRK2d1M3R4d1hX?=
 =?utf-8?B?c1ljQTVNeGE1anFjOGhKY2QvTUprbzZuczJrUjFjUDU4Mm91SWY4SG1CSkEy?=
 =?utf-8?B?UjlYWEYvdVIySnZSMnNveVY3N3hSMEJNakc1QmFOL1ZIenczNzFtOWpnQzRU?=
 =?utf-8?B?Wk5reFhlZUgrYnN1WmViS3dpdE1qRXFnRkRRakxGRnVBdS8rM0RWc1lTRmlK?=
 =?utf-8?B?V0hjbkplN0NJeWsrMnZEYU9GNkVpazJ4ZURRYUdRRXdkMmYwMEhYMDIzOHd4?=
 =?utf-8?B?b2k3ZStJZTFiQWVINllPaFVjRFMvRUg0Y2Q5WGxiNXdkMWNFdlUvdWFKcHhP?=
 =?utf-8?B?SGI4dnJYUHY5WjVHa1JHQjBtUHNJd0hJM2I4WTlBeUhuVytoM3pZRTFFVm1B?=
 =?utf-8?B?SVJjaXN0emhyYVRLSkZPZkMxMEpRczlBQWxSM3ZnbmFrYTM3cWx5VE5UOU53?=
 =?utf-8?B?Qk1aSy80YktFaDRSelJneE5hZUdDWW1NQ3I0MTEvcVA5WERNR09aSGZFZ3Zx?=
 =?utf-8?B?Skw0dlhHaGk4WUZwNnJLRndPZ1dFTU1jOUZEem5LTVdIQS8xK3Z2VHl6MUor?=
 =?utf-8?B?dzExM2ozWXNYbktjTXltTndjbHdYYzB3b2I5YjJOQ1lwZlJpRUxZanRzMWZO?=
 =?utf-8?B?NVp1aEZiSkE5aHRSSk84U0xnMzUyTC80cTJIdFNYdS9sQjA4KzI1cDgyUFg3?=
 =?utf-8?B?WjNxWlFxZTRZVjJ0WXUveGI2aldQZDJEeHVIYXQ5TkpmODB5R3R2YW01QXZJ?=
 =?utf-8?B?OG9PemNIYTZIMmVLbEF6d0J1TDNveWFjYUlsQ2xDVXZEeEJSQ1BnamNieFp2?=
 =?utf-8?B?YkUrVy9xNXRLZWREdjhHbXE0cXNxdEI1eXBjMnpLbEdvK0pkblpNK2NYeWpo?=
 =?utf-8?B?djd6cHVDSUtjZmFxS05BV0NkNVRvajVLWmk0NFBINk9TZG13Um5pYlNORlhT?=
 =?utf-8?B?RVV3Yy94aGgzdVNTWmlmeGc5UWdvTjdSNEZQMlE1Wi9rRml5Sk1VMzhiTGNW?=
 =?utf-8?B?anJNSklYRjdjYXVIczFTdGhidnV3Nmt5VHNMV1h4WThqcVNWa05lZzRXTWpz?=
 =?utf-8?B?L3hiVEVLYmJyb2U4VDZlVUdHeEsrYlV6c0hNKy9hazh0K0Y0dDI2VlZ1SXR6?=
 =?utf-8?B?elZjZFQ2WkgwdkJTV1JURXpCWGV1ZER5bGxTMmxrU2VtUE1NaXZGb0I1cUJR?=
 =?utf-8?B?TWxkYnpCeDE0K1NpRDB5Wlk0TnNCOEVqdGdFM0xoTEFnQ3R5aWRJaDBDOHZI?=
 =?utf-8?B?VjIydC9PQmFMK1JQeDBBS3MyUXdIaDFZdi8zZFFPVDFVbG01Rk8vSVpNL1BI?=
 =?utf-8?B?SGtjakY4WkFZdmk5Q01mVjc5ZU12dStMc0RMQ3IremFDend4d0k5dXFJYXJC?=
 =?utf-8?B?N21jMUwxVmMvK0RoYnZ1VVJqME1KaEMzdjVVVHozaW5Ud3k4YUNORU5rUG9W?=
 =?utf-8?B?UUg0NTNzYzRXZDFQTFNaUXoyR3FkTE5iRG5HcmE5b0ZLSGNSTGlFOHBrUTJQ?=
 =?utf-8?B?bDc1NDI4UHJXMktERVBobWRpeE9sM2lHQUIwTU9YQVBXWmFNaVhqSm9nRmxL?=
 =?utf-8?B?L0hvY0YyUjljc20weExRZ1NmZnBHZmV1Q1F1V1N3ZGpBMGoyY2JMalRtYjRS?=
 =?utf-8?B?YkNCTlFMZHd5aWl0VWxRWkRMNE1jZzY2NmNydzNab0hVVDV3UTVhWDg3ZnZn?=
 =?utf-8?B?NnBsbDIvcVIwZ1cwZTZLSFQ2dWdrdk9tbXVzSExmS2N3WmZHOWFVOGorem9T?=
 =?utf-8?B?Q0VFKzRuUEM4SjdqMzYwODhpU1ZlbS9PcmszbmQ3NytXbzZqYmYxSndvYnp1?=
 =?utf-8?B?MzNCWVRScWF5YUgvaEN3eU1sSnRpYWZFUnIvdGJEMUgzb0lLSTdIWklTczY2?=
 =?utf-8?B?QVRYMlpLZXF3T1lta2o3RnUra29oWFlndi9ZNnltY3d6OHJPZjRPUk9SOEwv?=
 =?utf-8?B?ckNLdlZVa2pQeE5VQjZhOHAxWHBna2pIeUxwOTA3akVBNHA1WEN3ZjJ3MGp2?=
 =?utf-8?B?SW1YN2liRGUvcUdkL1JYT2MwNVVBajFuSDdZOWtDSmhYbUppK3FWVDdCcS83?=
 =?utf-8?B?TGtkOE91WmxFdy8vMzNDckdBWHY4UlhHR3VJRGd6YVF2TzRNUWxxZGFTZmZi?=
 =?utf-8?B?VU43V2hxU3cweUxJblZXeVlBWVg3a0h5OENBem9wcHZ5eUY2T3NGblIzRWxz?=
 =?utf-8?B?QStIakpFM2g2MjBxSmI1czhTNTFUaXlFK2ROL29QMk82YThhWEF0QndFNjZI?=
 =?utf-8?B?UFQ2S09yN2VEYkoyMmluMGVqTU9QbUdXZXBVN3J6b0w5U1dNbkt6dz09?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 75554cd3-c299-4f54-94d6-08de86c129bc
X-MS-Exchange-CrossTenant-AuthSource: LV8PR12MB9714.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Mar 2026 20:42:12.1837
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Jh5xQWi3amlOKMAjf6M7oB2jMnEikcjXd/z+CWuU+ZefNrcSJirKHM3J7EKYe8u8H4YB+J4T39CzQmhC3uQ97Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR12MB7790

Hi Dan,

On 3/19/2026 4:07 PM, Dan Williams wrote:
> Koralahalli Channabasappa, Smita wrote:
> [..]
>>> I agree with Jonathan's comments in Patch 6, using __WORK_INITIALIZER or
>>> initializing work in dax_hmem_init() and gating flush on pdev will fix
>>> the WARN — I will add both for v8. But I think the WARN is likely
>>> indicating an ordering issue here..
> 
> Yes, Jonathan is right, static initialization is also my expecation.
> 
>>> On initial boot, the Makefile ordering ensures dax_hmem_init() runs
>>> before cxl_dax_region_init(), so both work items land on system_long_wq
>>> in the right order and dax_hmem's deferred work is queued before
>>> dax_cxl's driver registration work.
> 
> There is nothing that guarantees that 2 work items in system_long_wq run
> in submission order. Unlikely that matters given the explicit flushing.
> 
>>> On module reload which Alison is trying here I dont think, modules are
>>> loaded by Makefile order. I think dax_cxl's workqueue is calling
>>> dax_hmem_flush_work() before dax_hmem probe has had a chance to queue
>>> its work, so flush_work() flushes nothing and dax_cxl registers its
>>> driver without waiting.
> 
> Module load order does not matter after initial probe completion.
> 
> ...and dax_hmem is guaranteed to always load before dax_cxl due to the
> symbol dependency of dax_hmem_flush_work().
> 
>>> __WORK_INITIALIZER fixes the WARN, but doesn't fix the race I guess if
>>> we are hitting that here..
>>>
>>> [   34.673051] initcall dax_hmem_init+0x0/0xff0 [dax_hmem] returned 0
>>> after 2225 usecs
>>> [   34.676011] calling  cxl_dax_region_init+0x0/0xff0 [dax_cxl] @ 1059
>>>
>>> These two lines indicate cxl_dax started after dax_hmem_init() returns
>>> but I dont think that guarantees dax_hmem_platform_probe() has actually
>>> run..
>>>
>>> I dont know if wait_for_device_probe() in cxl_dax_region_driver_register
>>> might help..
>>>
>>> Thanks
>>> Smita
>>
>> Actually, thinking about this more..
>>
>> dax_hmem_initial_probe lives in device.c (built-in) so it survives
>> module reload. On reload it's still true from the first boot. This means
>> hmem_register_device() skips the deferral path entirely..
> 
> Yes, that is the expectation.
> 
>> The problem is this bypasses the cxl_region_contains_resource() check
>> that the deferred work normally does. On first boot,
>> process_defer_work() walks each range and decides per-range: if CXL
>> covers it, skip. If not, register with HMEM. On reload, that check never
>> happens — whoever registers first via alloc_dax_region() wins,
>> regardless of whether CXL actually covers the range.
> 
> Yes, I think you have hit on a real issue. There is no point in having
> dax_hmem auto-attach on driver reload. If userspace unloads the driver
> it gets to keep the pieces. So that means something like this:
> 
> diff --git a/drivers/dax/hmem/hmem.c b/drivers/dax/hmem/hmem.c
> index 15e462589b92..7478bc78a698 100644
> --- a/drivers/dax/hmem/hmem.c
> +++ b/drivers/dax/hmem/hmem.c
> @@ -112,10 +112,12 @@ static int hmem_register_device(struct device *host, int target_nid,
>   	    region_intersects(res->start, resource_size(res), IORESOURCE_MEM,
>   			      IORES_DESC_CXL) != REGION_DISJOINT) {
>   		if (!dax_hmem_initial_probe) {
> -			dev_dbg(host, "deferring range to CXL: %pr\n", res);
> +			dev_dbg(host, "await CXL initial probe: %pr\n", res);
>   			queue_work(system_long_wq, &dax_hmem_work.work);
>   			return 0;
>   		}
> +		dev_dbg(host, "deferring range to CXL: %pr\n", res);
> +		return 0;
>   	}

One issue with the reload fix - At boot, hmem_register_cxl_device() 
calls hmem_register_device() to register ranges that aren't claimed by 
CXL. But hmem_register_device() now always returns 0 for those ranges at 
boot.

I was thinking factoring out registration logic into 
__hmem_register_device() and have hmem_register_cxl_device() call that 
directly, bypassing the CXL gating. Something like:


+static int __hmem_register_device(...)
+{
+	/* Remaining in hmem_register_device after the CXL check */
+}

static int hmem_register_device(..)
{
	if (IS_ENABLED(CONFIG_DEV_DAX_CXL) && .. {
+		if (!dax_hmem_initial_probe_done) {
+			queue_work(system_long_wq, &dax_hmem_work);
+			return 0;
+		}
+		return 0;
+	}

+	return __hmem_register_device(host, target_nid, res);
}

+static int hmem_register_cxl_device(...)
+{
	...
+	return __hmem_register_device(host, target_nid, res);
+}

+static void process_defer_work(...)
+{
+	...
-	dax_hmem_initial_probe = true;
-	walk_hmem_resources(&pdev->dev, hmem_register_cxl_device);
+	if (!dax_hmem_initial_probe) {
+		dax_hmem_initial_probe = true;
+		walk_hmem_resources(.., hmem_register_cxl_device);
+	}
..
+}

Tracing it

At boot:

probe -> walk(hmem_register_device)
    CXL range, !dax_hmem_initial_probe -> queue_work, return 0
    non-CXL ranges -> __hmem_register_device -> registers

process_defer_work:
    !dax_hmem_initial_probe
       dax_hmem_initial_probe = true
       walk(hmem_register_cxl_device)
       CXL covers -> return 0
       CXL doesn't cover -> __hmem_register_device()
          no CXL check again, straight to registration..

On reload:

probe -> walk(hmem_register_device)
    CXL range, dax_hmem_initial_probe = true, "your return 0" -> skips
    non-CXL ranges -> __hmem_register_device -> registers

process_defer_work:
    dax_hmem_initial_probe = true -> skip the walk entirely..

Or do you think this can be simplified better and the above approach has 
some caveats?

Thanks
Smita
>   
>   	rc = region_intersects_soft_reserve(res->start, resource_size(res));
> 
> ---
> 
> ...because if userspace wants to reload the dax_hmem driver, then it
> needs to pick what happens with the CXL intersection. Userspace can
> always unload cxl_acpi to force everything back to dax_hmem.
> 
> Now, you might say, "but this means that if the initial probe results in
> a partial result of some regions in dax_hmem and others in dax_cxl, that
> state can not be recovered outside of a reboot". I think that is ok.
> This mechanism is automatic best-effort workaround for bugs / missing
> capabilities in the CXL driver. Module reload fidelity is out of scope.
> 
>> So if dax_cxl registers first on reload, it could claim a range that CXL
>> doesn't actually cover, and dax_hmem would lose a range it should own..
> 
> With the above change, dax_cxl always wins in the "reload" scenario iff
> cxl_acpi is loaded. Otherwise dax_hmem owns all the Soft Reserved.
> 
>> I dont know if Im thinking through this right..
> 
> You definitely identified the need for that fixup above.

