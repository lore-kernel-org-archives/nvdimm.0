Received: from SN4PR0501CU005.outbound.protection.outlook.com (mail-southcentralusazon11011060.outbound.protection.outlook.com [40.93.194.60])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AE6B231A053
	for <nvdimm@lists.linux.dev>; Thu, 12 Mar 2026 21:31:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.93.194.60
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773351113; cv=fail; b=rRGLS+VmCVS3tD4uwif4vnl5Q3Hz9bp1ZIIl0+FIxn6zPJOmWQJR2zWWxF2W1quCXhhb3M39jNlxMYcEVWNLmcuFhRasyADXb4x2LbWrxnIBIslCYb5C/LgFtp2Fy8DRHEbwJ2A+TCY/DzffbXKOvJFaV+1oQmJFl6UWQgcRxTE=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773351113; c=relaxed/simple;
	bh=tIBCYf81aKRnTXRYop3ezYqDgjUSAFTqPBHwFocvCiU=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=achtAc3UxySuWHEyIjKlGJ+ydYT+cX4b6rSOZo3E+REvpJmgqZDPXYW1chj8ixKZhcevfo/yr2GUfIvcHTD6eiE794BzRF5idpjF6kxpuPOcE+Azu+LTRYCD7vnBnEj5Z8goraMBDt8kvXBQfCkpuJm5WFJHM3p6FHARXB5YObo=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=MI4DccNw; arc=fail smtp.client-ip=40.93.194.60
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="MI4DccNw"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=ONfyhBLlCTuuGBnZFr+aaPe1fjwJ4wGqTXpX6Dax+yCsDig3NGjIYxzICgd5SFRW4nRBhTXim3YBGoJ03DkSHR60BeTnWfoRxKU4Uy63WTBi6CuAKUWFrn9iyZZDDBiUNkn6mYW9pbENBIiUDhWCHoqxCaM6007g9ZR9ILADdvxUeJke0Qj7+4mTAnYyf9mX+UzWjiCBwPWusXQPvY2FTWsJqxZIfecs3Wxp4igvV3+9fmr5gbinFezes2umJEHcFdYHklYB6VhKvsw0ZT8bs5sIJyGBu5Fn2E49QRUUcSeqR9OS25RBx3wcjh995CFOtoDAf0Y8WiIC6eKcTkzS9Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=E2dBEBc0YATwXLivOwngGwphTh6bIpdIPot4oKdwj3s=;
 b=QXTEk+iGM16SANpbomssPBpwKNw+v8XjaJP5WvbYa/JXVJsXObHObZph3abxzV0bz5gV7c4hvzJe02PcrfgA20csiuLCA8Op9ZYkK+F8azgkq7O1zKiabr7jolt2XdwRq04W4vB77g7C+rvF2xmqikP2VavJ2n4d9JUdAENlKHKIyfVyhkpUjoe+pVuXjhT5NxGk/EKRu2pp/e5eXa4nljbF89vULp4u6RKF8LX8/Rx9KnPtpzdGY+GXWDq2YR3fquGa0KUySetstwBUbt6CBkKSuhHtYjwgV7vlwP0lqk0vn+w9grr2tNVf+WRa+fWjnxQ54zsGe5IlrfkKYX/M/A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=E2dBEBc0YATwXLivOwngGwphTh6bIpdIPot4oKdwj3s=;
 b=MI4DccNwJNlAIJ6vQXowk0NUYvHCdxQQYJQmcN6LjgnyELQjEd9L5HRQ6tcd/hnQnvEHntz5LlIU/+iRVi/vDseXnlBu89ww0TLRNo5vQjMGjiw5SWz+vFmsTdViLrK63EZcoF0ndug0Y7AACfPhaEBE2MMTD+mY9PHBQWvGD74=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from LV8PR12MB9714.namprd12.prod.outlook.com (2603:10b6:408:2a0::5)
 by CY8PR12MB8410.namprd12.prod.outlook.com (2603:10b6:930:6d::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9723.4; Thu, 12 Mar
 2026 21:31:49 +0000
Received: from LV8PR12MB9714.namprd12.prod.outlook.com
 ([fe80::8c9f:3a5b:974b:99c6]) by LV8PR12MB9714.namprd12.prod.outlook.com
 ([fe80::8c9f:3a5b:974b:99c6%6]) with mapi id 15.20.9723.006; Thu, 12 Mar 2026
 21:31:49 +0000
Message-ID: <e812f955-c696-4474-8dec-1b4654286876@amd.com>
Date: Thu, 12 Mar 2026 14:31:44 -0700
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v6 5/9] dax: Track all dax_region allocations under a
 global resource tree
To: Dan Williams <dan.j.williams@intel.com>,
 Smita Koralahalli <Smita.KoralahalliChannabasappa@amd.com>,
 linux-cxl@vger.kernel.org, linux-kernel@vger.kernel.org,
 nvdimm@lists.linux.dev, linux-fsdevel@vger.kernel.org,
 linux-pm@vger.kernel.org
Cc: Ard Biesheuvel <ardb@kernel.org>,
 Alison Schofield <alison.schofield@intel.com>,
 Vishal Verma <vishal.l.verma@intel.com>, Ira Weiny <ira.weiny@intel.com>,
 Jonathan Cameron <jonathan.cameron@huawei.com>,
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
 <69b2087cb0cb7_2132100c2@dwillia2-mobl4.notmuch>
Content-Language: en-US
From: "Koralahalli Channabasappa, Smita" <skoralah@amd.com>
In-Reply-To: <69b2087cb0cb7_2132100c2@dwillia2-mobl4.notmuch>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: BY5PR20CA0031.namprd20.prod.outlook.com
 (2603:10b6:a03:1f4::44) To LV8PR12MB9714.namprd12.prod.outlook.com
 (2603:10b6:408:2a0::5)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV8PR12MB9714:EE_|CY8PR12MB8410:EE_
X-MS-Office365-Filtering-Correlation-Id: bbc90ad5-3738-4731-d97b-08de807ec4ed
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|1800799024|376014|7416014|56012099003|22082099003|18002099003|7053199007;
X-Microsoft-Antispam-Message-Info:
	YF5qpkqAA5YPC75mal8G/GWJ2Joe5eVLbdP0/gR5I+gdsPzhDFA8q5iIJ2vib5tBqL3g7lHnQaBJr3cGQB/EA54rhmBxag1EyL0ab7m8AWkuxn0IjR3R1H0RqyBhqWgNMI1+fs0VzNslMZTcPeRg5HwgBw7H5N76yH4ae58jPVgTxwu5dFvPzdDRbOvuuV83aLBhP3uAqw5FXVlYqA7HOTNHwxKctXL8uvCaWUrvCVlI7nTpe5bNnljzMUcZGiPcMEXCFwz8sYNBEXoQLb5NZrIcn9OOUc/5FWx5W8qU1OmvtEOt0HOXJBU8jclr9v1YjA09iwIs5efmO+F0W7TtLCXATNvIDbdXQX0uEJse9dWPQfO0uBg7G3yzkj+P9pEws/ymVjRCYLUT2ox9TvvICiIcKv7ndBl5a0yQ3ksiKEyTlJRQ7f4VAMIiaud9o7qbbV5nz0PlaVhJyBeKK0AVq3Zb7VZSObiUzUvnHeDAOUhQniSSzPwEelUACHzYrQIobWJhW1+JaXCzFTm1MS1bpe8yNqaPIBcpaWQeUPH7d6BQAxx4LpNjhJigCwcd40uj58dxZRDl1fS3Vu7z300visukFf1rBt44kMe1hGqLdh1MVay+C2ja+De1cp00U6j3I9HxaDqlpNpOLH5b53rHcSqctLzfrIr6eKlNc35LoEK4tI8oxGagVnyAoTY815n5aKn3qxW3vsNbfwmweWR6h01SrME2k7X54aTYB6Rjlig=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV8PR12MB9714.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014)(7416014)(56012099003)(22082099003)(18002099003)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?azQrc05jQmVZVENwYVFnK2pJOXJUM1U5RENTdyt0a0dNcCtSQWxHcmtGaUh2?=
 =?utf-8?B?amtuTGxTUVhZd1ZlT2Z4aFliRVNDeEJwY1N4ZUtjSXFQM0hUMHRsd3FjbGl1?=
 =?utf-8?B?YkJzZ0M4T2tzRWFlYUgwK2hMSTZSSjZaVTVKN3hubkZucW1LdUJueUpCR1Vl?=
 =?utf-8?B?OWNvTUZ1RnlORG1wN0pSYlp5bEdpN3ZqTjN6M2lmYjl2OFN2TktHSDdQY1Q4?=
 =?utf-8?B?NE1RbTB5OUo1aU1iVHh0S3I4aitiUnhVWWsyOVB0aThyWFl4NXc4bXFuYnlR?=
 =?utf-8?B?MFoxWlpQb3NJUzdwa3Q1VWVEZHovSy9YaVVCL0lVQ0g0TUdDaWhoZDRnZ3NG?=
 =?utf-8?B?OHJuSHh4WDllM1Q5cVVRTmsrSVpwcVdrTVloa1hXRXJQTXlXZTRFK0lKcnM3?=
 =?utf-8?B?TWwzbnBqbG03K0xoNUs5Y28rNjZSZEZ2NTB1bGJTS2EvWDFWMm1SdmsrdThi?=
 =?utf-8?B?eTV4dGpVd052bTcyT1pXK2RtREkzcjVvZFFCdVQwaVo1cUpMWnd6bC9Ramk4?=
 =?utf-8?B?Zm1nL3BTc2k0YmNrd05lSlhuVWFvcEtWeVVLa0Z6ampCMnRZZWlTaldoMDBy?=
 =?utf-8?B?Sk9Ramx3ZVhiYldmTXp3ci92bVFVbDljbUhYZ0RBZG0xclQ0NnNsQmlaWHpq?=
 =?utf-8?B?UXpad2tDVUtxLzJNcFl0YkVxc3g0RTUxVHdTdEdvbTdpTHIzd1ZCeDlIYnZR?=
 =?utf-8?B?ZUhodUNFZXZ3R1lKTVRub0lWVUhRbGV1TEh4N2tGT1dEekk1ZUI4ZHdLWGw5?=
 =?utf-8?B?d0sxTWJvQ05KMWprdm1Vem05RGZFL3JaUExGMlMzSmVGQTIyb3V1VHZWMVJR?=
 =?utf-8?B?YUtGUmpackRMS1hyc242SjNnQm5PcHp5R054SUdSQ0tZQmp2dG9uaGYzNlNl?=
 =?utf-8?B?bGtuVlFVK2dEY2NFK05OV3lGYWtybU5OVEhPdXlkaWQxN3hqOUlSa2ZEcGZv?=
 =?utf-8?B?QUo2ekQ5bytSSXlvNmsyLzZZbEE1cEE3N0RWaU1IZ3RDU1duNmNDWTQ3OWNy?=
 =?utf-8?B?Y1llYU1ueW5sZkpkZ1ZkSmNyS203L3FRUmxWT2Iwei9CNU5ib1RlU2Zjditk?=
 =?utf-8?B?b2lPR3dTV1l2VTBxRm1FOUUxSVRReU5naEZvOU1GQ1J6TnNCVDlnZkgyeXZs?=
 =?utf-8?B?TTNoMjI0M1kyM0R3N0pwKzR6RjdobkQwWlRiSFhRZjNDRndxS2RSR2U2RjNJ?=
 =?utf-8?B?dUc1N1dPdGkxQi8xMkxKN0MwUG9tVVg2Z2pSSTFlZVQ3cllyWHMreVc2U0ZC?=
 =?utf-8?B?Q1ltNmxKUG0xeW9kTEtXdWtKV3FJWjE2SytJUFpQdjdOc25qdFJ2cGtpMmhX?=
 =?utf-8?B?RzQxT2R5emx2ZXYzcGVYS09LVHBlelkyQVl4VTRTUm1XS3dsc2tOVTFwaGdn?=
 =?utf-8?B?d3VVK2RjSUxiWXgvd0M3amZpbUpMNEM2Si9IVURCWUFjZ2oyaXZYd1ArNk1q?=
 =?utf-8?B?RU9GY1lOeUFhdStZc0V1OXdETm5IdFNzdlI1YkpKYjV4YXVURzVISS9qWmtU?=
 =?utf-8?B?c1BLWTU1K3VSUUtNVW9iR2d4UFI3Vjh3c0xmOUJIQWNzdzNPRTJwUENDN0ZU?=
 =?utf-8?B?ZHprZFdNTkdtd2lsSDNnRld1Y2NUdnhmNEdMNUJ0SldRZnFFZEtKNllGcGxW?=
 =?utf-8?B?aG9FTGtyMlN2ZmhMK0RzeDB1MmxFd0hpcEdUbXlScjlPUDJPV3JxaUZNTHh6?=
 =?utf-8?B?VDdQbkt4Ti9mNVZPMjlvM2ZwdExZZEYzU3NKVTlzTHdBUzlPTUtUWUw2a3Uv?=
 =?utf-8?B?ODI4T3cyemtqWDRYKzBKcHBqSlZJK3RYNVdMQTNCdFY4U0srZUFvOXEwaFNP?=
 =?utf-8?B?ZDFQbDFJcllwcmlDOUcwZlk0MjhhQ2RxbGQ3ZHJUR2JFVlFXT0NMZGFuWVU2?=
 =?utf-8?B?UHdnUDVISjI1Nkd0eXF5dzJ6T0RUR2hrV1FiWXdOZmNOVWZqRXNRb3BPNU1X?=
 =?utf-8?B?S1MwdXNKQkZSaEdMWWFVQ0FZNEJoYlZuWTR4ZEZXUnNqczkweld5YnVXSWti?=
 =?utf-8?B?YjA5ckl4WlJNQTBkU3dDM3JBeXpmaU9TMnpUZE9yT2lVd2FCckwwYWVpNDlW?=
 =?utf-8?B?djZzUXhTdk1Lamk4NEpWbnloUitQSGJWNVB0WlVWK0dUSVlKYWRoQ0JwZnVW?=
 =?utf-8?B?UmFYc2FFUzJsV3hRWWxHaTF6cFl3bHpTVzlYelo5OC9GRng5aitubkpyTWpa?=
 =?utf-8?B?TmZvdEFCRGRWWGF3ejlmSXovemdrcWRLa0xITnpLbmFKUjZqSVNTNTh3dmpH?=
 =?utf-8?B?MVBFT3J0YmpCVkpYZGpLZWEwajFCd0lsdEU0ajkyTG1tVDJyd3k2WnBQVmhF?=
 =?utf-8?B?bndhbEhYQUM0aDJHQXp3eExIYk5ZYmdIM0RXbUovL1NqcUxrdDFkUT09?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: bbc90ad5-3738-4731-d97b-08de807ec4ed
X-MS-Exchange-CrossTenant-AuthSource: LV8PR12MB9714.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Mar 2026 21:31:49.2679
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: XBuW0uwN48xY3zQRWzwTBnQtinY3XxWCZD+/++4uwFBtdNeYb5vFI78w/FH1i8ixE5myZ7s6YKGzWBzmOxmIZQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY8PR12MB8410

On 3/11/2026 5:27 PM, Dan Williams wrote:
> Smita Koralahalli wrote:
>> Introduce a global "DAX Regions" resource root and register each
>> dax_region->res under it via request_resource(). Release the resource on
>> dax_region teardown.
>>
>> By enforcing a single global namespace for dax_region allocations, this
>> ensures only one of dax_hmem or dax_cxl can successfully register a
>> dax_region for a given range.
>>
>> Co-developed-by: Dan Williams <dan.j.williams@intel.com>
> 
> Did I send any code for this? If I suggested the locking below,
> apologies, otherwise Suggested-by is expected unless code is adopted
> from another patch.

No sorry the locking was added by me. I will make the changes and drop 
the locking.

> 
>> Signed-off-by: Dan Williams <dan.j.williams@intel.com>
>> Signed-off-by: Smita Koralahalli <Smita.KoralahalliChannabasappa@amd.com>
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
> I continue to dislike what scoped_guard() does to indentation. Often
> scoped_guard() usage can just be replaced by "helper that uses guard()"
> 
> However, dax_region_rwsem protects subdivision of a dax_region, not
> coordination across regions.
> 
> Also, release_resource() and request_resource() are already protected by
> the resource_lock, why is a new lock needed?

You are right. I will remove

Thanks
Smita
> 

