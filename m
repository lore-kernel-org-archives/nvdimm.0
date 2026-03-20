Received: from CY7PR03CU001.outbound.protection.outlook.com (mail-westcentralusazon11010052.outbound.protection.outlook.com [40.93.198.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A08792C1593
	for <nvdimm@lists.linux.dev>; Fri, 20 Mar 2026 16:58:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.93.198.52
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774025905; cv=fail; b=iyQlUrVTOMU7+SGdLJOctQi8oa8ZOJah0yd/YXgMJ6RFfWMg3CsdPagsRqBNMEzh/f6i4RaxToHIcC0LF12nQcP4y8SMcfAnrqkjFQ5dksDI8rCpPNGxLcRTIBI0/lKlidZkmLA8VvNlXrDi/t3jriZQfFo2Iolf7L/HR4a27x0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774025905; c=relaxed/simple;
	bh=YnGrQ1wngMmtuvOpQWQ1l77DUEd8b/Tm/RwDZ7wkYhA=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=SsqkfzVn2IvgYL0fJ+W7LQc/K5oTA0AF0W02oQ3NKsW0ZBcUGS09s8AeeoDRk+MiOQgDgUg8FN1F69fwi9J8d6Blu9rrZb+jVPyMbWCmj4ulKapGPKp0C9XfFDDvDmDqGbqo468yD2GBzR+oMXUni5Vsaw4L3U5HmPr/enWnAqU=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=LIO5KP4e; arc=fail smtp.client-ip=40.93.198.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="LIO5KP4e"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=UnL7oaKlrM2eLykjdiAGRBhgEO3+eWSSLzd1neN1cEuwaoKAz4QpLvaYKrI6XmBxTebMHDwF/jYYjv35QIe/ywnJiYldWTn1DcRX1u9OXznDlk36urg/7n9DaJhJjCvkdbXw4jhHwS/jJkDDGKEVfhdwvXJ4uJFMT7sobgg1UT0FSaNhapObSpOwhQMiIi5BjFL1V5/bMz6prDoHS/OIOZSSitZg0plCvCeJc1ew2cVO8Dkxuuut0zNC2HkVLsYkunfwlFLNN3NEokWFzKQfsqhS663xk8B9vWOqUfuwdMufPFJUg8L7HXo0AShHAwl46A7I9KsejsBIFLPpq2NX7w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=gosjWwrr1kJx63r9pWxhJOUCjkerdzk7p7NEuC7nFrA=;
 b=JJL+6v0aW6DuH4QXfgqmUamZXPgmCkw7Fd5FQKYYfCRKE0tX+4LlyvKA7X512zFEq2J3rjKgLPDQSIaG9RX0hUaXL9DX4NC4eLHomm8hBDjZROlg8vjYcpQ7nZ0weYnsiJhIoTHGBY23pTq8Q7iT2y3Us1eM8/mg3WLq+5vYxIYCNQcXSnqYM7vaQ63XeQbSC0I9mAjnuP32tH7IaOTiQRiOKi3B+G756QUpP8rjElUbcNjv3ppudiP0oekPcPxYccZs8r4vajwVHcDctNKGPsKpD8QShQAGukOc00CyVShskLiwoklXJGj5IxXcfh3lakXjFTmTaDfqoT6Bd2BeAA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=gosjWwrr1kJx63r9pWxhJOUCjkerdzk7p7NEuC7nFrA=;
 b=LIO5KP4e3gj0q2fY75f8gIvAANjCuZYdlYdGo/kSTtRJ9FyqsnrtMUhavHdamOmPJxdfqID8QfziTgrcgpEO33j9ppCU9rkVx9j25ixYEbniY1HvTjRJc7/Jhkt/pvJYx41GgjBOUzPFhKO+WsD0FyEKpWzCn5XZHmmlZVcba4E=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from LV8PR12MB9714.namprd12.prod.outlook.com (2603:10b6:408:2a0::5)
 by DS0PR12MB999079.namprd12.prod.outlook.com (2603:10b6:8:302::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9745.9; Fri, 20 Mar
 2026 16:58:20 +0000
Received: from LV8PR12MB9714.namprd12.prod.outlook.com
 ([fe80::8c9f:3a5b:974b:99c6]) by LV8PR12MB9714.namprd12.prod.outlook.com
 ([fe80::8c9f:3a5b:974b:99c6%6]) with mapi id 15.20.9745.012; Fri, 20 Mar 2026
 16:58:20 +0000
Message-ID: <6e429f60-af0a-47a8-a85d-ac22f50546d3@amd.com>
Date: Fri, 20 Mar 2026 09:58:18 -0700
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v7 4/7] dax: Track all dax_region allocations under a
 global resource tree
To: Jonathan Cameron <jonathan.cameron@huawei.com>,
 Smita Koralahalli <Smita.KoralahalliChannabasappa@amd.com>
Cc: linux-cxl@vger.kernel.org, linux-kernel@vger.kernel.org,
 nvdimm@lists.linux.dev, linux-fsdevel@vger.kernel.org,
 linux-pm@vger.kernel.org, Ard Biesheuvel <ardb@kernel.org>,
 Alison Schofield <alison.schofield@intel.com>,
 Vishal Verma <vishal.l.verma@intel.com>, Ira Weiny <ira.weiny@intel.com>,
 Dan Williams <dan.j.williams@intel.com>,
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
 <20260319011500.241426-5-Smita.KoralahalliChannabasappa@amd.com>
 <20260319135924.000060c2@huawei.com>
Content-Language: en-US
From: "Koralahalli Channabasappa, Smita" <skoralah@amd.com>
In-Reply-To: <20260319135924.000060c2@huawei.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SJ2PR07CA0015.namprd07.prod.outlook.com
 (2603:10b6:a03:505::28) To LV8PR12MB9714.namprd12.prod.outlook.com
 (2603:10b6:408:2a0::5)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV8PR12MB9714:EE_|DS0PR12MB999079:EE_
X-MS-Office365-Filtering-Correlation-Id: 50f33da4-70cb-4291-d802-08de86a1e38a
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|376014|7416014|1800799024|7053199007|56012099003|18002099003|22082099003;
X-Microsoft-Antispam-Message-Info:
	LDI3FIXGJFuJ1LXciZPckCTB92NI0An6Dh2W67FlQuRz6M6hEPznL4ru3LtMgFnNk0FpQCbzvxNCZplC/KO2oUTH5ydDq1OpJUKv+1ZzUnPtoqRTgWDGHrq6IZvQBTpD8uEaJzDxJ+K1uBi6I53auJALkiZGM79Szm2evrLTgwxai1xgWqnDbty42PAe3fNiwvEvIiZEmez2Vfrh+Yh384e4upr075Uz/LxjCyMBZuRQxBtI4Mt2rVTVQkOeopMAukT7EZLpasiymhKT4n0LCrg7kSVwwvaNBe4xXbnhNBgy9dCkg7w9VBZTLEfwqqDfpnGL1me+wBlXhyZTMwWDyBDLt3T1LyQzqavmTIp5QUvaqtl3ouEdKWRR8tens9/VmMQHI0Kz+Wocm/x8cgdNicaUQJmRZuhYfQm5KSZzq5bUaxeZSCAPFRsxyJ55rYWqv2h0MOLIM6yOX8W6wiJwX15O3Yz0tcjWhcDt4Fl3OgA7YYgW4DN/zJ2wHGZZ19paIGlletfItzQxY973sjhtRmbXK6NZrH/Hzs4pMI+bUI4lIWGFqDcjSsAeoNr0lEb0GFeCYBPHQzVO8HrQYQo0uols2fuciY9xS/l8H+D4dnePbOXFbXP/1t67pSwztCxUtTpgSEoCw/pCPmbw91nKHhxUYduZTHiiIIqaEVVutfcXMfNLXQ8kALV+xyEHMM04mIkSw/UIbsY1lCrzsDf+kOpr2KnWplWNz1NTo/HuuWE=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV8PR12MB9714.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(7416014)(1800799024)(7053199007)(56012099003)(18002099003)(22082099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?d0xxai9tVFRiVEQ4dXlCRjcrQWYyZEVhRWtSdFg3QmlLRThoQnRhaVNqaERY?=
 =?utf-8?B?SGxjb2V2K2JtZ2I3KzZrRUpEeXJKdzJRaVR3dWY3N1JpSVVhNVNObmxvTStR?=
 =?utf-8?B?RlpDa2RrU1Z1UFFFQzN1NktWeEl4K2gvd081dHVaeGh1QkhHMkY4MU9aZ0tS?=
 =?utf-8?B?Q0oxMU1QamM1cXBuUXJKUjZsZENUenAxSDlyUW95Q2VWems1YkkxeWZpdXRm?=
 =?utf-8?B?dWZrRUt0UXBmcGo0aGFValI4bDlDK3J2a3BNRi83Zmt3QXpYdlZEOUJ6WHh0?=
 =?utf-8?B?RWE4WWZLMkV5THdiOGR4M0xua3ppV3lld2Z6bW5kMTZXa21la3hIUGNUYmhv?=
 =?utf-8?B?Slh0MjI3ZFdjTlhHVm5pa281UnRtVndFdm9pSE1sQnAyR0xxVENFY1NEbk0z?=
 =?utf-8?B?cGNpNEpqdkNLZDNEWHlPSWxDVWpMeXpDSXBKNGRXNGVwRGREcCtiS2pvUDZL?=
 =?utf-8?B?TWozUG54WFFCYmUxKzJFcVR1UXFKeitBOHdGeTcwS0o0RkZndjY2REY1QkFO?=
 =?utf-8?B?L0FHcGFlMzdxZis5UVg5RFRQc3pBS0Y0dC9uaWR5Yi9yT2NmVXJHZWxENU8r?=
 =?utf-8?B?Q2Q1czY5eUpaZHhGaE5BWjJmMXNYRDlHUy9JSGNJMDM2c2FzT1d2WkdJWlpW?=
 =?utf-8?B?cnFxWXpLUE11VDdtdTdBTFlEN2NFZytaOEI5dTBreHJYQzBoL3RCM1NmTFdp?=
 =?utf-8?B?N0s1ZjcyUmpGaVJlR3B4YTdoMy9HaWVWTVlXTStyYmxBTFQwYzN4VDFYcHBX?=
 =?utf-8?B?WWtMUkFibnBvYnVnRFA2MUd3VHozQkxXWGovRENOY2dhS2UxazBkQzFMMDU0?=
 =?utf-8?B?cHpoWWhUQ0h1WVJmY29za1RQdVdhejhVczNhRjBKa0laVm9OK1dUNGU0U1pX?=
 =?utf-8?B?YWtsM0dQWVdGTDg5MVRHL3F1TmUwOERLSkVabW5Lc21rcXlhOTNvMnVRYmRo?=
 =?utf-8?B?VzFreGlNWWRzbDBobTRIVHlRRFBWYXJ0aktFTzR1dFUxRklOd2VaWXFyYjNo?=
 =?utf-8?B?cWpUK0JyQmpBQVhId05CbGJGR0FtVHRhaEZkUHdtR1JXWjZpdllHZEVGZVJo?=
 =?utf-8?B?NkJCdXRjam93clhKeU5CcmFwUW5MRFNvc0UwWSt1Tk9pb1pMekVMVktJeE5i?=
 =?utf-8?B?MFBacDdmT2xtYmhYOVY1NFBvL09EVDdTUkdCTEd2UHF2bllaQVk1QW5BY2Ey?=
 =?utf-8?B?RUZuMUZ6Wk9mUUZBY0Q4eTR2Q3FRcmVWYXdidk5DSVRadkdVUTFFTUpuWUJF?=
 =?utf-8?B?aEJTclhaZy9uZCtYY0F2cURZaGw5eE1NdWZQY2ZhYk12d1Z0S3VjVzhVV2lr?=
 =?utf-8?B?MUpQaG1KTlZNQlNNNXVuWmgzbHRpOXhnMmlnTmN1QXQ3VXdndmI1MEZ4em9Y?=
 =?utf-8?B?WE1VY1FiQnd6RU9xRGkyZ0pkRUoxVUUyL2d5MFZFYW9LNnZBc2NBL2duNjNv?=
 =?utf-8?B?Rm1jMUhXSitnM1dZa1JGUDJ2bjFKaXlKMzdIa1p5N21LL2pMRDRHcWduK2dK?=
 =?utf-8?B?UG8zZThVR29NM2lqMjcwUGRDTHkwRm9rem9HQUd1MkQ1ZVA0aVN0VkdrWGFt?=
 =?utf-8?B?NW55YThocjY5VllVdHlWcVF0MitwZXl5Vy9HZmp0cFhEVEVUdlhmemNRVWx5?=
 =?utf-8?B?YnhSQlovTE8xWkwvbURVdk5rWlN1eVhtbWFTZmYzYzVwV1VtbzN2VjZEZnVl?=
 =?utf-8?B?T25DMjlZTFZOWW1tZzlGT1ovNjd4eXhZTlVYVEIzdGEwNUtHMTFEa1JPNzQw?=
 =?utf-8?B?ajJwZmxkU2dNQWN6U2lhVSsxU1pZTlIwRGRvOExQU2NEZW44bXY5VU5mN2pB?=
 =?utf-8?B?ek5XNVRZdks1dUlQTk05NXZ3aFNOOVhwY2c5cUJjVWZ5bEZyQ2x5d2V1cUhk?=
 =?utf-8?B?cjBhZlFzd0ZVZHZ2M1VQb0ZEYm5rc2pUZ0FJNW04MzZVcnJWODdWZWN0TEFU?=
 =?utf-8?B?T1gvUVZzS244QmtHNUpCUWE3Sk5iVHIwRmtvSFZ1S2prTnBGUXNIY3RuTlFJ?=
 =?utf-8?B?M1dXZEVrMWpzSnYwaTJodnNRR01oTzhTVlVYS0ZtZzZPaGJibStlSkdscTBF?=
 =?utf-8?B?TjNtQi8wanJId0FFWFZsMUU1L0c1azdBaW5CMFdPSjN2ckg0aENuU0JoTmxz?=
 =?utf-8?B?RzNGaTYybldQbyt2aFV3Y3VaZHFYSm1CeGJjeEIrSFJ5dFozTmRVVGV1QXRV?=
 =?utf-8?B?d0VETEgxeFJYbUpSNTdIN0xVeHJVRm01L3ZTbEtERkxIdm9VdXE0QkVUdUQ4?=
 =?utf-8?B?ZFA1Mi9vTmRicWE4UVVONTJvaTdHVzNGbnhqYmlWaXRZdVlzaTlyOUFYcEtx?=
 =?utf-8?B?MTRReXN1NnAyaHV1SHRtOWQzMlJFd29vN2JaVFVzU1NvZHVKVk9kZz09?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 50f33da4-70cb-4291-d802-08de86a1e38a
X-MS-Exchange-CrossTenant-AuthSource: LV8PR12MB9714.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Mar 2026 16:58:20.0215
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: EHNQ9chsoFTVFzw68Nh2kp9Z8gTEyFDun9XPuV95AJRNLKm+f6HMvoAs4rssRSviAlJtn9Qi3PzB+J411ofyRw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR12MB999079

On 3/19/2026 6:59 AM, Jonathan Cameron wrote:
> On Thu, 19 Mar 2026 01:14:57 +0000
> Smita Koralahalli <Smita.KoralahalliChannabasappa@amd.com> wrote:
> 
>> Introduce a global "DAX Regions" resource root and register each
>> dax_region->res under it via request_resource(). Release the resource on
>> dax_region teardown.
>>
>> By enforcing a single global namespace for dax_region allocations, this
>> ensures only one of dax_hmem or dax_cxl can successfully register a
>> dax_region for a given range.
>>
>> Suggested-by: Dan Williams <dan.j.williams@intel.com>
>> Signed-off-by: Smita Koralahalli <Smita.KoralahalliChannabasappa@amd.com>
> 
> The comment below is about the existing code.  If we decide not to tidy that
> up for now and you swap the ordering of release_resource() and sysfs_remove_groups()
> in unregister.

Okay I think I can do both.

> 
> Reviewed-by: Jonathan Cameron <jonathan.cameron@huawei.com>
> 
>> ---
>>   drivers/dax/bus.c | 20 +++++++++++++++++---
>>   1 file changed, 17 insertions(+), 3 deletions(-)
>>
>> diff --git a/drivers/dax/bus.c b/drivers/dax/bus.c
>> index c94c09622516..448e2bc285c3 100644
>> --- a/drivers/dax/bus.c
>> +++ b/drivers/dax/bus.c
>> @@ -10,6 +10,7 @@
>>   #include "dax-private.h"
>>   #include "bus.h"
>>   
>> +static struct resource dax_regions = DEFINE_RES_MEM_NAMED(0, -1, "DAX Regions");
>>   static DEFINE_MUTEX(dax_bus_lock);
>>   
>>   /*
>> @@ -625,6 +626,7 @@ static void dax_region_unregister(void *region)
>>   {
>>   	struct dax_region *dax_region = region;
>>   
>> +	release_resource(&dax_region->res);
> 
> Should reverse the line above and the line below so we unwind in reverse of
> setup.  I doubt it matters in practice today but keeping ordering like that
> makes it much easier to see if a future patch messes things up.

Okay.

> 
>>   	sysfs_remove_groups(&dax_region->dev->kobj,
>>   			dax_region_attribute_groups);
>>   	dax_region_put(dax_region);
>> @@ -635,6 +637,7 @@ struct dax_region *alloc_dax_region(struct device *parent, int region_id,
>>   		unsigned long flags)
>>   {
>>   	struct dax_region *dax_region;
>> +	int rc;
>>   
>>   	/*
>>   	 * The DAX core assumes that it can store its private data in
>> @@ -667,14 +670,25 @@ struct dax_region *alloc_dax_region(struct device *parent, int region_id,
>>   		.flags = IORESOURCE_MEM | flags,
>>   	};
>>   
>> -	if (sysfs_create_groups(&parent->kobj, dax_region_attribute_groups)) {
>> -		kfree(dax_region);
>> -		return NULL;
>> +	rc = request_resource(&dax_regions, &dax_region->res);
>> +	if (rc) {
>> +		dev_dbg(parent, "dax_region resource conflict for %pR\n",
>> +			&dax_region->res);
>> +		goto err_res;
>>   	}
>>   
>> +	if (sysfs_create_groups(&parent->kobj, dax_region_attribute_groups))
>> +		goto err_sysfs;
>> +
>>   	if (devm_add_action_or_reset(parent, dax_region_unregister, dax_region))
> 
> This is curious. The code flips over to a kref_put() based release but we didn't
> do anything with the kref in the previous call. So whilst not 'buggy' as such
> it's definitely inconsistent and we should clean it up.
> 
> This should really have been doing the release via dax_region_put() from the
> kref_init().  In practice that means never calling kfree(dax_regions) error paths
> because the kref_init() is just after the allocation. Instead call dax_region_put()
> in all those error paths.
> 
>   
> 
>>   		return NULL;
>>   	return dax_region;
>> +
>> +err_sysfs:
>> +	release_resource(&dax_region->res);
>> +err_res:
>> +	kfree(dax_region);
> 
>  From above I think this should be
> 	dax_region_put(dax_region);

Thank you for pointing this out. I will have a separate patch for this 
change first in the series.

Thanks
Smita

> 
>> +	return NULL;
>>   }
>>   EXPORT_SYMBOL_GPL(alloc_dax_region);
>>   
> 

