Received: from SA9PR02CU001.outbound.protection.outlook.com (mail-southcentralusazon11013001.outbound.protection.outlook.com [40.93.196.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 526E72D239B
	for <nvdimm@lists.linux.dev>; Thu, 12 Mar 2026 21:30:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.93.196.1
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773351037; cv=fail; b=mMR6wKBcMTyL4D8PwrxDyTq9fX5r26Htig+AJ47tDCBRScIvETmMxH3Y6E0JPcnPAv2Aw3zALOSpJuGFtHM+DDDLmUKRKkF3mwUNZOU/tEUGBOwL8Q4W1R/bg0IgAW+uDcp5uuYKRWM+SOJqWHEcjjcR6OzkdMzz3lcRkH78kms=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773351037; c=relaxed/simple;
	bh=lOJpw5VwuzhteNpG2nciddLiQKUVyhQtXdk9o+/cCvc=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=mVR6WCDuxSdQ4zaOon2TMI7yiCnAgO4Iok0hHo8fii7znjGLPlFvzeugUc8Dg7UiXOykH+E/5R/CWYdLwpYduzVGRju/4xTLtDOL3I89RAu9Bjnb5F0BXKCoEG9B/hJjKSInwxJvXpA9yJpZjqg0hjmI74TMtv/XZKAhRBs18Io=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=uv6brjBe; arc=fail smtp.client-ip=40.93.196.1
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="uv6brjBe"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=DwAGi1lqXZNok5kLZ6fpLW3BtfByUJHbTNt9QJ8bZK07CGKjjVDemx57JmghnK+JKB/4kA/FI417Sr5m2gq879+BNA9SMvKGPFB6DMbcOa6Qc1dQdWHrCBSn72e6+cBuIgrj4w7usuMOQEAuhOqSDYOpxPtO0BSLIFX59QVoQNYYD7fZXtXagzeySc9eKJYPJsLJRgCrh2kjGNKeRm5S6gGHdQRuZnZSDqbWPW8DT4YocmjkvnzUpv5F+jIQOACzsHBT/v0FhdmnNsg6CIeEyaFkiRRaap87bu50Thy5TQT8fQt+HAkjXZlXF+siPEIRXzl4D8+2LmMf6XzCW7PA6w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=oS/PtMUbFlN7ZVFuZOOMEApNdL/BKenks5v6kUIvj9I=;
 b=D9qXZAvE+kveIjo4wGu2MhfUHs7Q0V1W9GfxlSWBxT1h6YISFg1XlcOAfcOfag1cgv04I54o5Dpo9OROqpUj9hubkZyQkMn7znisvoo+3zKXKJoNwPmjvWZI/8ascqQRSRRQ6hoLJhxYiyQy4sxUu8wZZ98DZUPWsoYa+hD+mJLbQ1crflReOPrdxDDHpcNvowpFhf1gQxq6jjg8koQY+DJokhrYo9S0mV59PBpspbD3ukpgRTjyvv8g3kSNybuUfHlk0AZaofGlRLuBQ5ZYKI1EvxPaWZqEaUZHcxiKwxM0Iyx02FAPSr+5JdPnYcCwZVUTOASN81FC7TJ3bCbOug==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=oS/PtMUbFlN7ZVFuZOOMEApNdL/BKenks5v6kUIvj9I=;
 b=uv6brjBeHXovqdqEVl4hqMeqvo9dRaW0Jf3wGnbnwL6t6amUEBwHO/Gr7W+GcsGijdenjv1jCFliJ7w37VNf8YyQjaqzsPsDktNnvozWBuiPqckVlfsN2kDcgpVg5TgeXjjmNxEd/z/vWbPlMmGSXxC2eugQneKY/nE1OLe5+QI=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from LV8PR12MB9714.namprd12.prod.outlook.com (2603:10b6:408:2a0::5)
 by CY8PR12MB8410.namprd12.prod.outlook.com (2603:10b6:930:6d::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9723.4; Thu, 12 Mar
 2026 21:30:28 +0000
Received: from LV8PR12MB9714.namprd12.prod.outlook.com
 ([fe80::8c9f:3a5b:974b:99c6]) by LV8PR12MB9714.namprd12.prod.outlook.com
 ([fe80::8c9f:3a5b:974b:99c6%6]) with mapi id 15.20.9723.006; Thu, 12 Mar 2026
 21:30:28 +0000
Message-ID: <ce51fc41-e05c-4ed8-8472-19e30dd2b8ca@amd.com>
Date: Thu, 12 Mar 2026 14:30:24 -0700
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v6 5/9] dax: Track all dax_region allocations under a
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
References: <20260210064501.157591-1-Smita.KoralahalliChannabasappa@amd.com>
 <20260210064501.157591-6-Smita.KoralahalliChannabasappa@amd.com>
 <20260309143746.000047ee@huawei.com>
Content-Language: en-US
From: "Koralahalli Channabasappa, Smita" <skoralah@amd.com>
In-Reply-To: <20260309143746.000047ee@huawei.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: BY3PR05CA0003.namprd05.prod.outlook.com
 (2603:10b6:a03:254::8) To LV8PR12MB9714.namprd12.prod.outlook.com
 (2603:10b6:408:2a0::5)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV8PR12MB9714:EE_|CY8PR12MB8410:EE_
X-MS-Office365-Filtering-Correlation-Id: 410a3b07-6b4b-4b72-28f7-08de807e94ec
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|7416014|1800799024|366016|18002099003|22082099003|56012099003;
X-Microsoft-Antispam-Message-Info:
	5WUMe3nyF17DOTOlNwOsOdCIPO74bapPnLIhs+lvWGyYoGA29a/OlLDlEAOAJ7aQ7+jaOJhS4jR3vLnh6b0B0WnP4/r8vH6Q9QgOLT62n7f98GWGIvbPjGVMv321v6aoZnrWMr41A3F0KdYk/Mod07ErqFqioovTGbmFJbh+2y/L5ZDvs38BHzbpS4Yi1V/OUDj3lU7Fvb1zfuq2nle8AYLI/5EysMX4RR6OsEXKGx33xNyrHZzQrFX7qhdN6WU2yQUWGlcxpec18VEuuhkFJZ69YtkbSrr/8dyX98WWmZvnoghKKuA5ygzdkLTiP3G199pSug0o4Phqu3U4XMQcgCaP+ZJXgta14jENBtCZhb/HNkRo7R2xt4kQEPFfB59dmjduHNy4NIPBkR55jEUkvxmGx3fYLpW4HhFxEK+iwxVrpuybRTkIRQ3nzkraymzSbgDvQPLptwNQ2yMBHVr+h8BH1zYxLuN6FTwAgAR427PKIy0yHG9X9LN+ZIFwlPizu8WJfc1ApWsE7AXKeC3e8+Ht6GEcumAR3NlmrvM0LdxtvmivgGbRWKZpwos3Hx/bT6SpZHnTDrQPF9aU1xdA67OFUFj3ixEhoqRWQxXD5whyeBHLOpSaVqIWtZRZ9JJQADCr1ef3uUUwReDLtTQIrRSLr7d241+Tk+YA+e/a5T3UT/tIbfvdmoG0g1UHcIg0oMADUXW7+IZFCGbuqDsDuwKSNuDmzjmqJDpfcQVcbt0=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV8PR12MB9714.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(1800799024)(366016)(18002099003)(22082099003)(56012099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?MGRtYU5ETzI0TDA4MmE3bm8xbFNQbU5oUCtoOEZpTkV0NFlBak41dkxSZ3Mx?=
 =?utf-8?B?UUF1aG1QQUo1R0NnbjhvMElPb0JWM3hhR2tJdHVBSmpWTEMxTkhkQnZBSHM5?=
 =?utf-8?B?OE1IQXlTQzZCMTNMWEZDSnBVMUI1MnJjcjNtR1lTUnRSYmVKMTlzVndHbkRh?=
 =?utf-8?B?MkUzZG9KN1RvQllOMXUyKzREU2YrYzJXRzdidEVJbDNJdm8wL2JDNXVUVDgw?=
 =?utf-8?B?eEd5dXluZjRqQjdOZXlNaEs0cCszQzFUSEFreU5YWmo1Ynd2bldUMXQ2RWh2?=
 =?utf-8?B?NXpJL2pGVHZ5enkvV3lhQWVHbzBDNHRwL2RRVDd0VFhZV3BKcFJUZjN0ak0v?=
 =?utf-8?B?Yk1sNi9hZGlvSWZHSEo3SWJWb1o0Z0xwdUlYWjdWdG5mM2RmMW0vdmVqOWtV?=
 =?utf-8?B?c0FsdStJNTNYS2djYTA1Q1pzMklDMWpmamhmVFE5UUt2VXRBRUVQd2JlQnhn?=
 =?utf-8?B?VWNLTG1RR1p4TVVMemlWQTFCa0NkUlZBYVdyWjROd1hYQXNVSS9VUkNaZks3?=
 =?utf-8?B?Rjg0MEYwbktYaTRSOE9YQmVZQ0NxM2gwbFhCeVlBMTB0S0lkSStkREVnQXpO?=
 =?utf-8?B?aFVacXZ4cXB6RG9CMzBOZzFVY1JzWW81Y1JSRjhKbGc0TTZEblhlRVQ4WHVM?=
 =?utf-8?B?WnAwNG5tNDN1NFZRMkxOUnBPNG96YWJORy84bUE1OWlQSmVPRzcwVWNMRGFM?=
 =?utf-8?B?K3B2dDBWbWdpMzVsR0VscEh2ZndHUTdTY3FCUEVVbUJialozVnBFY2g2ZWE0?=
 =?utf-8?B?djZiQzBZb0tLTXVTRG8wZTNXUS9Xa3NCNXlEMnVyMnZxaWRvdXBiS2I4Yndl?=
 =?utf-8?B?MlowZjFoSUNyU0xCclh4QUE3ZUZhTVNkY2JLbWZoTUVVRHpRQjNlbFo0L25o?=
 =?utf-8?B?RE1iWEZKTWtLbGRPSFFpVWpqd3piMzBNV252UFBkZDZMVU0vU0dUaE5KRTdH?=
 =?utf-8?B?UGJSMEw0SG1nOFZ2YmJ4bWxtbkJ6UC9GWXlLbjF4ZEgwS0tzb2QvVlV0MjBJ?=
 =?utf-8?B?UkN1V1ZZNTVsWFdodmh3dUxvaDdOdzZGaTE2ZWxVa2daU2E2SXloNE9manVH?=
 =?utf-8?B?d204QWVSeG9Cek1uTmlFaFNyZnBTZ0JUSlFndUxFN09EejRybUVkbDZyeTBm?=
 =?utf-8?B?SHp4L2VtZFdhSllETmlmMTRJU0drRHVUbFY1TEk4NE5TUTFlYVNXTHJUN05Q?=
 =?utf-8?B?SEkwbEZKZlEwQm9HajlvVkJJeEdBR29vQkdqNG05MDlvTVVWY2U4V1hzTi9M?=
 =?utf-8?B?Q3lqSmJxVFc4UEJuUGJrVW5JaEwzaGdlblFCS1RhOEdaSi93OXpiZGs1eWRk?=
 =?utf-8?B?T0UvUGhhMklnVE94UmFUZEFXemFzcU1aTlVQbGcyc2R6K3ZrM0U3bzRDb0tr?=
 =?utf-8?B?NE1TNVJqOE43SmtsMXQ5YkVpN2NYeUIwSVBwR2dsczNIaERGa2xKZEVOOER6?=
 =?utf-8?B?Qzg5OHpxQlk3bEQ4ZW94RWFQSXJWRUtTWnJ3WTZOczBWQ3ZzcDNtQk8yVTVn?=
 =?utf-8?B?UW1oL0pUTVhHV0FiVEhNZFFzNTVKZkluYVdXem92eFB2dDVMT0ZRWEpxSCtP?=
 =?utf-8?B?b1R0aUJGZ2Q5WE5wcE5pK0NVWDBGUHFCT2ZPSzJLSytIQ0pYTG9qM0s0WlEy?=
 =?utf-8?B?RytRN1JyMVExRmZBbEJscW9QQmhoMkpGVkVkVkJuVHcwOUNTRmZwY0lyZDF6?=
 =?utf-8?B?eUpMWmZ1MG0yMHJZQVZpVHlUTkZobHdWWE1YQXJpa3VoeUhKK0ozVE5na3BG?=
 =?utf-8?B?RHM1TzVFYWNOV1N5NFF0VXVNemFOd29mZjVRSTNzYVcxeGc3LzdWQ3o0YVNk?=
 =?utf-8?B?d25JakZDS0ZpUEx2dEFOTFR6SGFpSTJLMkE2bmRFTU9QS1NuVHcrZDh1RUl1?=
 =?utf-8?B?NUVqTVozT210WG54eU9XdGIyZ0dlaE9xM0ZIbStHZUlXMmxXWllpOFRCQ2pt?=
 =?utf-8?B?Nk9xWjBMODh5MzlxTFVTOU9RTjdHU3hDWWtlUlQ4QlJzbDMxL2pzU2d1Zk9n?=
 =?utf-8?B?c2FUYlBPOHFSMTFkL2wwQk9ZTDIrTlFyYkZSdzc3Mzg1OUUzdkNYNnJ0UDZI?=
 =?utf-8?B?UmlDK2dRMzJCRmVoa0g4T1ZDRWJwUXFydWhIdXB6OVExNm4xUzVMMDlmd3dL?=
 =?utf-8?B?MlByZUU0NmhRU1VRWEwzVlFVSlMzLzFGTldFWUJTelhNSlJpOTBmSjdaNVBk?=
 =?utf-8?B?cVgrY0tvcDRrUVZLYVJXTkVtT2xMOVRyQW05dzBoM3MvZ1dRUnJpbTQxQjEv?=
 =?utf-8?B?YmJPMG5uQ3pmZmU5cm81azBhZHBtK003WUI2c0E4VGlXcHNuR1ZGYWFZcWh5?=
 =?utf-8?B?QTJYOHdBZUZXR3JsUVZ1ZzNpUzBkVFVKN3lsbHZaSWo4bm5TS1hIQT09?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 410a3b07-6b4b-4b72-28f7-08de807e94ec
X-MS-Exchange-CrossTenant-AuthSource: LV8PR12MB9714.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Mar 2026 21:30:28.6645
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: FJYs97O1tC+skAWY1+b1P7vW37YhCPPFPVyenDu4Aoreeu5ZNGcIe02HDx4CHeXE9GtDAoMbHyTIfd4HsFFQ6Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY8PR12MB8410

Hi Jonathan,

On 3/9/2026 7:37 AM, Jonathan Cameron wrote:
> On Tue, 10 Feb 2026 06:44:57 +0000
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
>> Co-developed-by: Dan Williams <dan.j.williams@intel.com>
>> Signed-off-by: Dan Williams <dan.j.williams@intel.com>
>> Signed-off-by: Smita Koralahalli <Smita.KoralahalliChannabasappa@amd.com>
> 
> One question inline about the locking.
> 
> Is intent to serialize beyond this new resource tree?  If it's just
> the resource tree the write_lock(&resource_lock); in the request
> and release_resource() should be sufficient.
> 
>> ---
>>   drivers/dax/bus.c | 23 ++++++++++++++++++++---
>>   1 file changed, 20 insertions(+), 3 deletions(-)
>>
>> diff --git a/drivers/dax/bus.c b/drivers/dax/bus.c
>> index fde29e0ad68b..5f387feb95f0 100644
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
>> @@ -625,6 +626,8 @@ static void dax_region_unregister(void *region)
>>   {
>>   	struct dax_region *dax_region = region;
>>   
>> +	scoped_guard(rwsem_write, &dax_region_rwsem)
>> +		release_resource(&dax_region->res);
> 
> Do we need the locking? resource stuff all runs under the global
> resource_lock so if aim is just to serialize adds and removes that should
> be enough. Maybe there is a justification in that being an internal
> implementation detail.

Yeah the wrapping is unnecessary I will drop it.

Thanks
Smita

> 
> 
> 
>>   	sysfs_remove_groups(&dax_region->dev->kobj,
>>   			dax_region_attribute_groups);
>>   	dax_region_put(dax_region);
>> @@ -635,6 +638,7 @@ struct dax_region *alloc_dax_region(struct device *parent, int region_id,
>>   		unsigned long flags)
>>   {
>>   	struct dax_region *dax_region;
>> +	int rc;
>>   
>>   	/*
>>   	 * The DAX core assumes that it can store its private data in
>> @@ -667,14 +671,27 @@ struct dax_region *alloc_dax_region(struct device *parent, int region_id,
>>   		.flags = IORESOURCE_MEM | flags,
>>   	};
>>   
>> -	if (sysfs_create_groups(&parent->kobj, dax_region_attribute_groups)) {
>> -		kfree(dax_region);
>> -		return NULL;
>> +	scoped_guard(rwsem_write, &dax_region_rwsem)
>> +		rc = request_resource(&dax_regions, &dax_region->res);
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
>>   		return NULL;
>>   	return dax_region;
>> +
>> +err_sysfs:
>> +	scoped_guard(rwsem_write, &dax_region_rwsem)
>> +		release_resource(&dax_region->res);
>> +err_res:
>> +	kfree(dax_region);
>> +	return NULL;
>>   }
>>   EXPORT_SYMBOL_GPL(alloc_dax_region);
>>   
> 

