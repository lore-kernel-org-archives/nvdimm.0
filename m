Received: from SA9PR02CU001.outbound.protection.outlook.com (mail-southcentralusazon11013056.outbound.protection.outlook.com [40.93.196.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 742393B3890
	for <nvdimm@lists.linux.dev>; Fri, 20 Mar 2026 17:29:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.93.196.56
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774027796; cv=fail; b=jKgzYCkEm0OObgIvIvuOjXj+UuSvDP+eNeydKrKu9KDpaqPaOTJFMJZFta/INdb1QmH1/c4LCH3PnrZMji71LePFwgbsiqUvum7lchY7B5LNJ4oyFsLZXc1EfLdhZaoW7K9F0ANFL9TXVHmgKnerxnvQ7KAumAn4rGcDQ5zksuQ=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774027796; c=relaxed/simple;
	bh=lo1/k/swY1uzkjoRlr0Nci+LNbXNzC/uzqfYL6CNmA4=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=RM9QR+oK5WhtCiKWXefGa7bHdAGwApAHyvi4VRF46h9JhKgTPB+gcbk1Q7GlWEKdZrfwb9yyZ/Svwwj498i+IfAsi3mZeQ/FaevNcoZqVlb5QmfMQnQCASOLk/VfKtCmrGoL+PwPqUoqDGE2xVUofCMCKSekt47glG4E6pj2SBQ=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=hGsDm20c; arc=fail smtp.client-ip=40.93.196.56
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="hGsDm20c"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=mMk9YP99gCKhz4dD67nsMy5zJEXhi2Bl/E47TgSqct1zk1COOsYYhQxidcmjBki4/0oFRgA1cKgmFMtRhjhnB5GGFEVNdzy6cCZqt1dDzh8u/90qeuwFguqfPq44bQjK5L4U8CdeiiJ05IsytKjNhEsc6/QpJHUlXf7bXVzHlo8nPHGbSaIhy4Lrgi3cTWvumng3UOQ3LwAkzPak076Vpq/kT8WULqIRHq7sRBeGNqIVWAbIapwV7ExSPgvR2K+KnX2qe+VsnkhUNhOsoaaL19sEZJ5AjkjJR7J1LZmuo2rYAMqXgOf+WpiqdI0xpWJHZZR3rl3ILqWbxHI4bYusOQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ycsugbnvTs8eSnNKJbzXMtSehp28U+P/Ble446PXv/c=;
 b=VlTiPlMXew5tF5DgwY4nBwEHHsw5A4j2knAWpXYDkvzSNZ5fTJc+KbVom2/4FpNKv0ujAR0GOKayp6ezyvz8jLgjt9i01pa4l0GV2ix6QYK2YcEQ0/HpU1OCOcvnps+CAdZh4cHD6DLF36B9LmMMsszg0EAynvAJWJWTJ1BGNUIJH4qn0MJvETXW9NAk2k4GLyLKx/GXrdRZL/TOBKa3E8vcCB8LfUSmkf5z1HV/ACYdEMoU3c50IPfPUvoYB6tUtFPeNJeO5qvToO6tLI7lLVXxYzfCT1zbkLUymBpV0axL9TM7+wN6pGFyK1/bGFFMKWy+CaG3OtOS4rLl1rie1A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ycsugbnvTs8eSnNKJbzXMtSehp28U+P/Ble446PXv/c=;
 b=hGsDm20csJgo718+Xqzvk8MlDIpZ/mKrc8HRXcWC6lL3xmjhUN85Ym2ac/d7MlOZV/4QX5FTm/69xc8g7bgJQmPml9tTuy8rLbh1NitA6zmPLVrdxDPXsGfHKo3YaDS5bfTtxHV247R28xDATl22jMOXvlYWbYVZTvFUvWs39WM=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from LV8PR12MB9714.namprd12.prod.outlook.com (2603:10b6:408:2a0::5)
 by DM4PR12MB6638.namprd12.prod.outlook.com (2603:10b6:8:b5::5) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9745.9; Fri, 20 Mar 2026 17:29:48 +0000
Received: from LV8PR12MB9714.namprd12.prod.outlook.com
 ([fe80::8c9f:3a5b:974b:99c6]) by LV8PR12MB9714.namprd12.prod.outlook.com
 ([fe80::8c9f:3a5b:974b:99c6%6]) with mapi id 15.20.9745.012; Fri, 20 Mar 2026
 17:29:48 +0000
Message-ID: <d1e077eb-46a5-476b-8fc9-16b28e217dba@amd.com>
Date: Fri, 20 Mar 2026 10:29:43 -0700
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
X-ClientProxiedBy: BYAPR05CA0106.namprd05.prod.outlook.com
 (2603:10b6:a03:e0::47) To LV8PR12MB9714.namprd12.prod.outlook.com
 (2603:10b6:408:2a0::5)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV8PR12MB9714:EE_|DM4PR12MB6638:EE_
X-MS-Office365-Filtering-Correlation-Id: 01bef8bf-25ad-4160-6f27-08de86a64928
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|7416014|376014|366016|1800799024|18002099003|22082099003|56012099003;
X-Microsoft-Antispam-Message-Info:
	Qyeuev3l9kEvjI4+TG6MkdhcFBiJJDWXnk+d1tItp69DBwD8fJs0R0JX7xG4VQ5Fv2bWsTefVNTgHFfzkwOlJ8U7UVz6tiMhwHtDOzsKb5PIgWZs63C/SIgqF7SpCBe1mUbfMzzTk0sTl9tKGt6QmwXqIsNLaDM6O/AHCem6mC06yCJeXfRkCLMgaNH3aHT1REdlGa1F5/vZJ7bQtP10aUOBM7pISrfQGO0YVrfqW/mJtqwWHu4DIFcu49lZRXADQHrVzYGOxpBF/h4mr5N63Hz4XIuft0PpbZUM7ZG0IsmzSol0S2Z9gYkdUE4/rUjI2vYb0g22Q0l/SwSkwmGdc3YKfo2SVHdUUsfRO02MHHy2ChYKyd6ot6BDbKDZhN3RkwAmC8czITEtlefCe+naWkeZ8jtgcj4iOJZxZM6vaVlAIkibn7sOUkk82qfBrwM+iwJp2icBXDDJ01OAJwLR207JvLRFUSljHMfAkorObxnfn3yEiJ7kQGLPUrpkFcua69Cb7xqFRVLwhP2xiQUey46pQtmX0zZAW0xBJ7+0VR5hj5To5oPHGxoF7nMo7zgM/frUzh7vQvpBkOJ5mvv8JpgFE8O+eD8p81CJlITlIQ0zhOHBOeZl5uXtrDpQ6hn6YJw+ZFep6B/kST/U1z93K5dqcwCmlByhfV9uOng+GA3LUKDnFwD9ZTS+dEputP+S+zIVevGK80CjZdYsqUFHUPUKENZ0FPGWdl06G6I5jjM=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV8PR12MB9714.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(366016)(1800799024)(18002099003)(22082099003)(56012099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?ZGxiQU1oc2I5TFBmbWlKZ2ovTFNiRzRJR3ZiOW9SNXFFZnUzaFdlQjNSREhG?=
 =?utf-8?B?RURUOGx4S2J0dGx0WTZZQ0VPa2s0UzBla2lMMzNwaFNUQUJzYlFLTmRRUGkw?=
 =?utf-8?B?VDhYWDlQaEc0clFyK1BjZVBXbFFwNVFYSWpQVnRwejQwK0o5ejhLUlBZamFX?=
 =?utf-8?B?VmRFSHF6VXUvTmREQjVCWDNKakF4N0lSV1l1cG5Ga29jbnd3Z1pVVW1EMjRr?=
 =?utf-8?B?VkIyZnlrajM2TC9aSkh0Z1MyV284RlBQRk9oRjF5Yy9xUithUHlQeDlYWkxv?=
 =?utf-8?B?bnhzeDdJOGxzY3hPZDgwYmtKVDdDUlEvbTdVNEsrZVkvam8yTFFFVmgxdHEr?=
 =?utf-8?B?MGRiZkpVL3BleW5mdzhFTVVqTHZtdkp6Q3Z0aFlXc2loajU0MVI4RTY5OHlQ?=
 =?utf-8?B?VnZzR2F2Q2k3MUwxVUJRTWZISDFGaG1lWERwQ2dJRjlpdEpzSWVFYnQvdm4r?=
 =?utf-8?B?WnFmalR5azBVZW5Gd0lZTW1XeVVaLzE4NkpnQUNaa1ZLUjB6Vm5mTWdUM0JY?=
 =?utf-8?B?bi9PY1MvRDVNdUM4YVpuRTJ0YnphUnpPV1MrKytIV29JT1VHcmpBNzJKSkpD?=
 =?utf-8?B?WmFuT2FjZnpTNTduZUQ2QmtUYjBWOFBmejlMQ294cHZkR1NoWlFUTXJ5SWJs?=
 =?utf-8?B?M290R3hHdU1SMU52ZysyNFBrWmc2SzBuQkY4c0Zhd0dseG9iYUJndUdPUFZF?=
 =?utf-8?B?UHVxVmh5eGI3WHNYeEtWWGxqVks2UXBxSnIzRUU4MWEreVp5OXpzOW9oVzk4?=
 =?utf-8?B?WlR3WkVnNFRLZzh6QXpFV3pUY2xVSFdwZWhQR3pYU2twcFRsbTIwNWtwTnU4?=
 =?utf-8?B?bGJBN29uaGxOSTJmUjFzYWdBNU9ONU91UTdIc0RtNXhxbXVNUzc3WDVKdnBk?=
 =?utf-8?B?L2c3SGNKN1NId3BrSVE0UHd6R3BhcW8zTFloY056eCtldEN3OXUrS1BlY3Vo?=
 =?utf-8?B?KzVzRlZ2OGoybklTWDN5V013dEhvY1ZoMVE4TlphWWhWUnhESU5xR1RuVVJp?=
 =?utf-8?B?U3krRVBrbzlvLzlKRm1SamM0UkhyRUZma3FNUVlYc2ZHUmM3QkhEc2l6cXV3?=
 =?utf-8?B?SHd2Z0JzVmJrU3U3YTZOR2ZDZU5JeGY0UWJ3amtaRmlUd1B3YUF0WXBmTUhj?=
 =?utf-8?B?K2dsOEVuNXRUMk1IdmVjc0tqZGJIWFpWdFNzR2tIVFhaeTlSemxrVjMrN2o3?=
 =?utf-8?B?NWJ1bUNENEhFOWNGaGw3WWM3Tk1pTzZ1R2R1UitUK3d4NHUzY1lWK29vZDRE?=
 =?utf-8?B?Zis3YzYxNEliVnh3U3MrcHhFcVBVS1lhQkZpcENiUndPRXZtdGhkU3BHdHJy?=
 =?utf-8?B?VzRPdXZremtnczhha3hVRmJBYXFZeVVyQXNJV2R0QzBYeXp6QThLTTQyY0xJ?=
 =?utf-8?B?RFpGTEc3Vk9rSW1DdHBiZ1ZzRkQrcFZLOVJtVmp0WlhVUU9neTBmSE1qRDFs?=
 =?utf-8?B?MW9JQURrbkRNSkVvUlc5anh3SXExRzRKbEJJQUp3bUwyVnc2SmNCbnJWdVFV?=
 =?utf-8?B?MDhZOUtPNFo5N0h1OHlYTStOQ0JaOGpyMGVhdGMxQXY0bVJ4bUttU3VJeC9P?=
 =?utf-8?B?THlkTXBLdGVpOE54N2NickhXZVhnTUJmVk5KQTVxSG0yMFI5MDB3UG5BZk1t?=
 =?utf-8?B?MGFwazBSNktBNHhXSEFQWUZXWm9VNHdycnp3cWZCL2NYUXpjSkFRYzR3byt2?=
 =?utf-8?B?OXQzcmZQbUdXR09LcWRMZzcxV1hVR3lUV0lMTW1RTjFLQ1NGc1RSVnAvOVE1?=
 =?utf-8?B?YnpBYVZ2bnppdE9rbi9OcEo0dTVKK2g4Qml4TzkycW5yOHg2WkN4akZybnpG?=
 =?utf-8?B?NkRqSGtxSDJDQVRqdFdtV1l5ZG9odVdDREl3RVdaVmhxV1BNcm9TWG5YS3FZ?=
 =?utf-8?B?MEhDZnltZ0xzS3JVVFZWMU1PbWJwaWY0WlZjakY3RDh1SlFkNnJQYU4zaFly?=
 =?utf-8?B?WUQydjA5eDlQOFExTmsvR1VxeGRzTmR0SU43SFp0L2dHNmtBbmE2cDh0SnpY?=
 =?utf-8?B?aW91YnFaZW9pM3RvcUUwMElZeGIzL2VZeThPZ0hyTlJzY3lncmhrRnhWL1pN?=
 =?utf-8?B?aUhPaS9ka3luWXNMR292cHc1WW5ZajRiVXd3Qk9nY084RGNib01MZVl4ZFRr?=
 =?utf-8?B?L2ZlS1FaSGtqVU9qVkhjMmtLWGE3VFBaMEVMRldISjVXWTFnNDhOYURRREx3?=
 =?utf-8?B?Z2M3ZU9sMWtyQnBqSlhCL1pORWR4dXFLUUZoVmdwMmJBWVNPZ3lXc3kreE5y?=
 =?utf-8?B?QlVYakc1cG82VVJRM2NuU3R4aHhQblZPQUtycEpOQnUvQ0t5anFlTzQycVF0?=
 =?utf-8?B?UkxHZW9FWTg3NnA2YVRqUHM0UU92UGc4dzFCbjlQcUFYeGdUTGtNQT09?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 01bef8bf-25ad-4160-6f27-08de86a64928
X-MS-Exchange-CrossTenant-AuthSource: LV8PR12MB9714.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Mar 2026 17:29:48.4846
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: jQCHz1iNRf+udDvHJ3p3wAcaSHwHV5creYdCLxOeFURsNg6GmBGRenhCoRr7hnGnya3Sb1DPq26g9hTpWFOkvA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR12MB6638

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

Thanks for the clarification on system_long_wq ordering.

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

The fixup for the reload case makes sense.
I will incorporate this into v8 along with Jonathan's __WORK_INITIALIZER 
and the pdev gating.

Thanks
Smita

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

