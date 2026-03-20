Received: from SA9PR02CU001.outbound.protection.outlook.com (mail-southcentralusazon11013056.outbound.protection.outlook.com [40.93.196.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 08E503D2FFB
	for <nvdimm@lists.linux.dev>; Fri, 20 Mar 2026 17:17:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.93.196.56
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774027071; cv=fail; b=PfV+ku6AFgf5CA/sS9tWltukN/BBRN/2UePtF+bdKXYLyhJEqfIUclEVc138RvZBXoZq0VTt33ul52Tlj+hPZHV8TCUYEpEeBh3fmVyq4zLh7U8+AUL9/nHUImJuTTArRmNeKOwL6nL0VpnMGOgdfDG7K+ybs2ss4x25E2/Eqnc=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774027071; c=relaxed/simple;
	bh=FwfRti5gvPQ6e8N0B1AiGj60KGKXXl+kLKnM4aQRHMU=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=qATjuGzB3u0XF/Fi3r9RwAQ8BO9sB0hj5o+SFLAsAePbL1skmVAfWzf3bgGS8t3h3l5ig7KUbUigqpsVgUECTiiJ20CBXqRjm8LQEWQv4x8MK3pO9MHD4vxYltTCAgeEeul33A7wBL32UN5zc2YZ+GkKRA8nM1QaOR0uoztH0zc=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=BbDR1mjc; arc=fail smtp.client-ip=40.93.196.56
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="BbDR1mjc"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=an81zrQQQWkFhI4UDyPIjih8L/5U2bJGDZ2owxfXzu0DA439+JqPC/JpuyEEWFpwWf+F7Kk0+PoTw51LEO8gTFLnz7XSpif4R+voDvySkpIwIbpI134l1hUgektbcZgBqkOI3XZFOUOsUV6Hm3zDvPbmjE/kBk42q6/bC6JqqBjlDokis1nXr/kmpH52HHSFK8A+UwdmV8C4skyZVRAGhsXpkvWrKLG9rH8Osnr8lOhVl9JemYZwzDB1e5B7fGPVHGfHhIhZkDBheEWIB9l/X7cLMjqonr9CGuP2ustOsjR3YNG+B/doB3gGq7DIleVU01vlWy7IrC/vD98Rg85u9g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=G4VGrotY9yyzsLRoOyqxrJc+bUYfPLh5CQNTqYQRz30=;
 b=PhMVs506RyPOhoyhgXEIdItQtHR5q15z0mURhls0cPr0QWBJMT/bZhYn4qGDbKjpbniGJ3/NB1xrhgATFG/7sBlwtaM98mrStqqczMn/juCDY9FN77+Xh7aEwuOSPPe+E3islRZA6mcdV4DdrVK3yB4O9fzmD/khJEPv0a02m6XlqkTMoUH8EhAydTO5vmA0ltYpNrhEEgVjZrDb0BDz6vEBpDm5ORqGC68wrW8XHA/aswUhkh3TIrwTutfv82+TFMZd2l308OGnedcqGWeoOn6F4dxRIzlR7V+ZoF3fgU/LyOXkdvUZPwJBtPPcW+jjjYVAU/tyyFf5OSsDdDU7RQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=G4VGrotY9yyzsLRoOyqxrJc+bUYfPLh5CQNTqYQRz30=;
 b=BbDR1mjcytQtMOK5qbYKaxhd6xvIqDY+RwodG5hPqZZtPuzQx2jQJ+GMjhE52feoVFFPf3yYg5xojgaoPNI/9rFnfnIhABjIYlYllkQpJnpUkkALWOiM0+6pAbGxBNvfJOMiLVqrPFKbXnbCbgNMj9pkR2MzeaBAmxP8DKZ7Ctw=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from LV8PR12MB9714.namprd12.prod.outlook.com (2603:10b6:408:2a0::5)
 by IA1PR12MB7758.namprd12.prod.outlook.com (2603:10b6:208:421::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9723.19; Fri, 20 Mar
 2026 17:17:44 +0000
Received: from LV8PR12MB9714.namprd12.prod.outlook.com
 ([fe80::8c9f:3a5b:974b:99c6]) by LV8PR12MB9714.namprd12.prod.outlook.com
 ([fe80::8c9f:3a5b:974b:99c6%6]) with mapi id 15.20.9745.012; Fri, 20 Mar 2026
 17:17:44 +0000
Message-ID: <ae30ab74-2f1c-464c-acc7-1354cfb2eb1d@amd.com>
Date: Fri, 20 Mar 2026 10:17:38 -0700
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v7 6/7] dax/hmem, cxl: Defer and resolve Soft Reserved
 ownership
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
 <20260319011500.241426-7-Smita.KoralahalliChannabasappa@amd.com>
 <20260319142910.0000113d@huawei.com>
Content-Language: en-US
From: "Koralahalli Channabasappa, Smita" <skoralah@amd.com>
In-Reply-To: <20260319142910.0000113d@huawei.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SJ0PR05CA0120.namprd05.prod.outlook.com
 (2603:10b6:a03:334::35) To LV8PR12MB9714.namprd12.prod.outlook.com
 (2603:10b6:408:2a0::5)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV8PR12MB9714:EE_|IA1PR12MB7758:EE_
X-MS-Office365-Filtering-Correlation-Id: af3ce29f-923d-4f5c-229a-08de86a49963
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|376014|7416014|1800799024|56012099003|18002099003|22082099003;
X-Microsoft-Antispam-Message-Info:
	n0xkGplZGAuzCo9BkM3KJaaJr3mMhN75VRzR6n9/93hEp4WMtdpmQJyMORPsnuPO8BbADhJQpTMVf9LARPNYNPvgFum8RXEV4hj304TyUxdvPjHLNBx3dyVSe4WQC++9+Oz1fNZuBHP7Mw7sZOUvXxGhTmrHtEQu6kBTFgJwNWlBKeuOzsA/PwTS4lOe+7zShT31nC/uyF+JbdubfuQRoV3r+TumjkSYuAaaRNKNLbmfs2ilGTnYxY8k80dBtGk8ottfxVnUgHSawTR/oHqhtEm4eW359sFW78/BdlEeH+HpgZ8KL2h29Zfw5rs0PTYByB/aK+T4ROJj0JYC1f6Rcl9p+cRWV5ZIL3tyvRG3bF4YQAfJbF/f64oP8UXqNWSiE6/wFtWRTOeAjGOwHYldpzEqp2DSY1NhTQfCrkQspuRBUzWe2B9QbqfQLx2wpEM36u4PnYDVKmXj/PmzMMoGIxfa+tRYrw6JiO/Nx4JZoOHVtwliEd46GO/jD1eX7ZDpp4jbj5tPdd2nfVPyMz+HfrDWVTlkA9ywoCHtaNrINAZ1VkF/gkQXeKCnvY7SDc2KaA6X6Fxr6yXPZm1enJVP/39hiapbHSgOLAr9YmbL0IYa8XwTN0bpacm3pn733zqrxGq1wyNJJ574mVR9hQF9I0M6AmOyM4vsByHQiGDjeLnDhg9JOqe/L0exG1u9daKdenZ7G4r+mrMmiEDsSu0n9+Gy/CcyoEBM/91lEZXxh7k=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV8PR12MB9714.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(7416014)(1800799024)(56012099003)(18002099003)(22082099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?czBzeDdVYkR3aXZYSHQ0NmxaQm1YVDJ2ZzJMVXNnYmRFTWR5bTI1cENUUFVY?=
 =?utf-8?B?SlQ4RHdCdW5GR1hUZHBxS0lySTlSb0hidlRadzAzQUh0TjZLZHRKc250WlBT?=
 =?utf-8?B?ZEFUMXl2K29iSVJLK2xHUk9hdFhCdCt3ZDRTL2dkMHo1RmhGZVJrQUU2ekM5?=
 =?utf-8?B?MFlGVzc2TnM5cFFHbWVXdHdzNzVzd3pWbCtmK093Z2NDOFR5VVZ4YXpwY2tW?=
 =?utf-8?B?YVRsMzBuRm53Unh6NVByU0NFSlV3cjZGSTk2T0xkK0hLWkNNNGpERHhRSXp4?=
 =?utf-8?B?cmRHOGpmMUpraWk3TjRiMDJ6USt3dkNDcGorbUx0NmFpSU1YZW9MdGJtN3dV?=
 =?utf-8?B?UUVpSmFmZ1dTbkNBSms4YXpBZnN6dlA3RG04YUtaYnBxNk16c0Zzd0lBSEtr?=
 =?utf-8?B?UG11K3A4dkNxSW1xTEpDZG0xRktLb3M2R1ZnOUQyTnFJazVkK3BXMEl2Y0hK?=
 =?utf-8?B?UWoxendTMVZTRXF4THhWd3hBL0QwN3VVUmFEcExWWjdtT2thb3gzZHhITG41?=
 =?utf-8?B?bHdUNlZ4L3BQVjB3MHd3VXFPZ0Exa3Y1ZnRwTWFUd0F0YStSdm9NL1graytN?=
 =?utf-8?B?MGNRTHZUUGdoaGtXUHUvYjJYWW02eTJBdENwV3psRXhPY0NEV2FLdzlrWmdE?=
 =?utf-8?B?YzdvU0FnWG1tK1oyKzVMTWtHY2ZlUE5ZQWpkZTNZVmNOYUNlVDBJMTIrdWIx?=
 =?utf-8?B?aU81YTV0NzhSa3lHYXc2SWhEU2RhWjV6TUZXZmJubW15UzQ4bjBKWFYrQ3h4?=
 =?utf-8?B?SlZCTjRaVmN3d0hZamdEWngveUUzNG9uWXhXK0gzWGhrLzJUSmVtRTBGZktn?=
 =?utf-8?B?TTU2NU5uL1VwdGFSbW5YdFhRNjdVdFZIcHArNEgxU1J5QlZNb0graldiczI3?=
 =?utf-8?B?c05nQmpFcFNnVkhua1BvOHN1dnVJWmxVUTN2djl2U2pKS0E3RXlBbzJGbDVF?=
 =?utf-8?B?Z09ZSHNXejRQU01WNGFDOVV6ZjJlZnNuRFZZS0JaN1ltWkZCcExSNU40U2Er?=
 =?utf-8?B?SThucFNFeVgrSCsvWDdnVzhIWHJ0V05tOGQ2MXZ4RURSZ3NDaFM1ajdBUVcy?=
 =?utf-8?B?K3ZRUlVsTFVMRVlTcFVVYld3TExQMjNkdEJYT0pyNlplUVByeEZ6RWpMS01C?=
 =?utf-8?B?VFBWWmlMV3JYVXlaYU5QS3JWaTZxVzBmQ3IxYkEwUDZiY01mZ0dpTnJEUEpo?=
 =?utf-8?B?MHNBQTN5RFJSVlJMY1ZKYlpCd1ZWVXFaK3l1emFLblFpSnRpNmJsRTVUQklE?=
 =?utf-8?B?Rks4TGxuZVpwNm9Xd2IySXIyRmRJbDFIWGVVTFJvcWRON3JtQU1jTkgxTjdx?=
 =?utf-8?B?UEtlb3B1VVhTNURjL2lzYVpodG1xM0swRit0U3FPZWZPclFTRDJxYzlBWnBw?=
 =?utf-8?B?UG5YMGVEdHZmS0txOUZtM3ludm1Ib21BR2p3LzhVc1B3Y1VlMG4yOFd5eHZj?=
 =?utf-8?B?YTFnV01MaFZ3S1JrK2UxU1RldVozM0JBRGU1SFNYUzVDUnJBZnZUamM3ZUZX?=
 =?utf-8?B?YmsydmhOQmU3aDFIQjNDS2NaM1pYNnlEdktiZitpSjlWbkh4Z2gxVUUxK1Fp?=
 =?utf-8?B?aEtpV1Q3WGpYSFNIdW1TYzFuUzBmWGZnaEFGekJtSHN0RExYQitsMktNTHQr?=
 =?utf-8?B?aWthMSsxYVBoaFBuTkpneUpCWTd4UzNhNHFvaEx2cFdPWFBIU2hYRTRWSDBV?=
 =?utf-8?B?K2t0RDdJY1J6MUQzMXlOZ0l5NW1MczJWSEUwcDV1VkljOWxhSUsyRXAwOUhm?=
 =?utf-8?B?ckJRZmRFN00vbVdDRGl0ZVNDSE1OL0U4RVBHcnJkNTJpR3BkKzJtdXlqWXE0?=
 =?utf-8?B?cmhlMVZNK3FsNE04NzFhaU85VXdmVDJ3eVkxS2hZZ1ozZDl0RlZEZHZybmdW?=
 =?utf-8?B?dkVSZEhkbzJTb1d1OXY1WFFOY1ZGdm9NMm1OMzQ5bkdkd0prdzdlc1BKSjZL?=
 =?utf-8?B?LzR5WVY4Ly9GbitEUE9xU2NqTHlkczU5N20xcTB1eE9UOGt2SzFmYlE1ejcr?=
 =?utf-8?B?N1lKSzNvcC9PcmI2UGhYb1pWUmsyR0d0cmlKcEpuLzRMRkp6RHVXVGJFVCt5?=
 =?utf-8?B?Q1hyU1Z5QlRmT2I3Vm1tY2F4cDNGQ3UrTzU5Sk9ubEszU24wRGNkT2M2S20z?=
 =?utf-8?B?bDdmS3VMWUpid2htY0VkRDQzTXllSFM0V1lkODNYWFc4WXl3Vm9ic3pOTG91?=
 =?utf-8?B?eXlKQWRiZDJFU2RwMDhxL2M1THA1TlVseHowR3hyVjRMUDNINEVuV1lGQUVB?=
 =?utf-8?B?MUlTVWVRd1QrM3EyN1NrbEJ4R2dJZ252bkR4T2VxYmc0K3I5RG5UWDlaVTk4?=
 =?utf-8?B?V0crOGRnbW5yV0JJMFVvUHQvWjhVU1ZsTFlZZGlVS3RSVmF2RTJvQT09?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: af3ce29f-923d-4f5c-229a-08de86a49963
X-MS-Exchange-CrossTenant-AuthSource: LV8PR12MB9714.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Mar 2026 17:17:44.1628
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: V+OcVKFmIG1MD6BmZL8skvbYJXqOyXd1mp9xOtReMh0e4rW1aJJ9jacft5+FKeVPOhDPAZDP+2EXC45p+td9Lw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR12MB7758

Hi Jonathan,

Thanks for all the comments. I will fix all of them in v8.

Thanks
Smita

On 3/19/2026 7:29 AM, Jonathan Cameron wrote:
> On Thu, 19 Mar 2026 01:14:59 +0000
> Smita Koralahalli <Smita.KoralahalliChannabasappa@amd.com> wrote:
> 
>> The current probe time ownership check for Soft Reserved memory based
>> solely on CXL window intersection is insufficient. dax_hmem probing is not
>> always guaranteed to run after CXL enumeration and region assembly, which
>> can lead to incorrect ownership decisions before the CXL stack has
>> finished publishing windows and assembling committed regions.
>>
>> Introduce deferred ownership handling for Soft Reserved ranges that
>> intersect CXL windows. When such a range is encountered during the
>> initial dax_hmem probe, schedule deferred work to wait for the CXL stack
>> to complete enumeration and region assembly before deciding ownership.
>>
>> Once the deferred work runs, evaluate each Soft Reserved range
>> individually: if a CXL region fully contains the range, skip it and let
>> dax_cxl bind. Otherwise, register it with dax_hmem. This per-range
>> ownership model avoids the need for CXL region teardown and
>> alloc_dax_region() resource exclusion prevents double claiming.
>>
>> Introduce a boolean flag dax_hmem_initial_probe to live inside device.c
>> so it survives module reload. Ensure dax_cxl defers driver registration
>> until dax_hmem has completed ownership resolution. dax_cxl calls
>> dax_hmem_flush_work() before cxl_driver_register(), which both waits for
>> the deferred work to complete and creates a module symbol dependency that
>> forces dax_hmem.ko to load before dax_cxl.
>>
>> Co-developed-by: Dan Williams <dan.j.williams@intel.com>
>> Signed-off-by: Dan Williams <dan.j.williams@intel.com>
>> Signed-off-by: Smita Koralahalli <Smita.KoralahalliChannabasappa@amd.com>
> Hi Smita,
> 
> I think this is very likely to be what is causing the bug Alison
> saw in cxl_test.
> 
> It looks to be possible to flush work before the work structure has
> been configured.  Even though it's not on a work queue and there is
> nothing to do, there are early sanity checks that fail giving the warning
> Alison reported.
> 
> A couple of ways to fix that inline.  I'd be tempted to both initialize
> the function statically and gate against flushing if the whole thing isn't
> set up yet.
> 
> Jonathan
> 
>> ---
>>   drivers/dax/bus.h         |  7 +++++
>>   drivers/dax/cxl.c         |  1 +
>>   drivers/dax/hmem/device.c |  3 ++
>>   drivers/dax/hmem/hmem.c   | 66 +++++++++++++++++++++++++++++++++++++--
>>   4 files changed, 75 insertions(+), 2 deletions(-)
>>
>> diff --git a/drivers/dax/bus.h b/drivers/dax/bus.h
>> index cbbf64443098..ebbfe2d6da14 100644
>> --- a/drivers/dax/bus.h
>> +++ b/drivers/dax/bus.h
>> @@ -49,6 +49,13 @@ void dax_driver_unregister(struct dax_device_driver *dax_drv);
>>   void kill_dev_dax(struct dev_dax *dev_dax);
>>   bool static_dev_dax(struct dev_dax *dev_dax);
>>   
>> +#if IS_ENABLED(CONFIG_DEV_DAX_HMEM)
>> +extern bool dax_hmem_initial_probe;
>> +void dax_hmem_flush_work(void);
>> +#else
>> +static inline void dax_hmem_flush_work(void) { }
>> +#endif
>> +
>>   #define MODULE_ALIAS_DAX_DEVICE(type) \
>>   	MODULE_ALIAS("dax:t" __stringify(type) "*")
>>   #define DAX_DEVICE_MODALIAS_FMT "dax:t%d"
>> diff --git a/drivers/dax/cxl.c b/drivers/dax/cxl.c
>> index a2136adfa186..3ab39b77843d 100644
>> --- a/drivers/dax/cxl.c
>> +++ b/drivers/dax/cxl.c
>> @@ -44,6 +44,7 @@ static struct cxl_driver cxl_dax_region_driver = {
>>   
>>   static void cxl_dax_region_driver_register(struct work_struct *work)
>>   {
>> +	dax_hmem_flush_work();
>>   	cxl_driver_register(&cxl_dax_region_driver);
>>   }
>>   
>> diff --git a/drivers/dax/hmem/device.c b/drivers/dax/hmem/device.c
>> index 56e3cbd181b5..991a4bf7d969 100644
>> --- a/drivers/dax/hmem/device.c
>> +++ b/drivers/dax/hmem/device.c
>> @@ -8,6 +8,9 @@
>>   static bool nohmem;
>>   module_param_named(disable, nohmem, bool, 0444);
>>   
>> +bool dax_hmem_initial_probe;
>> +EXPORT_SYMBOL_GPL(dax_hmem_initial_probe);
>> +
>>   static bool platform_initialized;
>>   static DEFINE_MUTEX(hmem_resource_lock);
>>   static struct resource hmem_active = {
>> diff --git a/drivers/dax/hmem/hmem.c b/drivers/dax/hmem/hmem.c
>> index 1e3424358490..8c574123bd3b 100644
>> --- a/drivers/dax/hmem/hmem.c
>> +++ b/drivers/dax/hmem/hmem.c
>> @@ -3,6 +3,7 @@
>>   #include <linux/memregion.h>
>>   #include <linux/module.h>
>>   #include <linux/dax.h>
>> +#include <cxl/cxl.h>
>>   #include "../bus.h"
>>   
>>   static bool region_idle;
>> @@ -58,6 +59,19 @@ static void release_hmem(void *pdev)
>>   	platform_device_unregister(pdev);
>>   }
>>   
>> +struct dax_defer_work {
>> +	struct platform_device *pdev;
>> +	struct work_struct work;
>> +};
>> +
>> +static struct dax_defer_work dax_hmem_work;
> 
> static struct dax_defer_work dax_hmem_work = {
> 	.work = __WORK_INITIALIZER(&dax_hmem_work.work,
> 				   process_defer_work),
> };
> or something similar.
> 
> 
>> +
>> +void dax_hmem_flush_work(void)
>> +{
>> +	flush_work(&dax_hmem_work.work);
>> +}
>> +EXPORT_SYMBOL_GPL(dax_hmem_flush_work);
>> +
>>   static int hmem_register_device(struct device *host, int target_nid,
>>   				const struct resource *res)
>>   {
>> @@ -69,8 +83,11 @@ static int hmem_register_device(struct device *host, int target_nid,
>>   	if (IS_ENABLED(CONFIG_DEV_DAX_CXL) &&
>>   	    region_intersects(res->start, resource_size(res), IORESOURCE_MEM,
>>   			      IORES_DESC_CXL) != REGION_DISJOINT) {
>> -		dev_dbg(host, "deferring range to CXL: %pr\n", res);
>> -		return 0;
>> +		if (!dax_hmem_initial_probe) {
>> +			dev_dbg(host, "deferring range to CXL: %pr\n", res);
>> +			queue_work(system_long_wq, &dax_hmem_work.work);
>> +			return 0;
>> +		}
>>   	}
>>   
>>   	rc = region_intersects_soft_reserve(res->start, resource_size(res));
>> @@ -123,8 +140,48 @@ static int hmem_register_device(struct device *host, int target_nid,
>>   	return rc;
>>   }
>>   
>> +static int hmem_register_cxl_device(struct device *host, int target_nid,
>> +				    const struct resource *res)
>> +{
>> +	if (region_intersects(res->start, resource_size(res), IORESOURCE_MEM,
>> +			      IORES_DESC_CXL) == REGION_DISJOINT)
>> +		return 0;
>> +
>> +	if (cxl_region_contains_resource((struct resource *)res)) {
>> +		dev_dbg(host, "CXL claims resource, dropping: %pr\n", res);
>> +		return 0;
>> +	}
>> +
>> +	dev_dbg(host, "CXL did not claim resource, registering: %pr\n", res);
>> +	return hmem_register_device(host, target_nid, res);
>> +}
>> +
>> +static void process_defer_work(struct work_struct *w)
>> +{
>> +	struct dax_defer_work *work = container_of(w, typeof(*work), work);
>> +	struct platform_device *pdev = work->pdev;
> If you do the suggested __INITIALIZE_WORK() then I'd add
> a paranoid
> 
> 	if (!work->pdev)
> 		return;
> We don't actually queue the work before pdev is set, but that might
> be obvious once we spilt up assigning the function and the data
> it uses.
> 
>> +
>> +	wait_for_device_probe();
>> +
>> +	guard(device)(&pdev->dev);
>> +	if (!pdev->dev.driver)
>> +		return;
>> +
>> +	dax_hmem_initial_probe = true;
>> +	walk_hmem_resources(&pdev->dev, hmem_register_cxl_device);
>> +}
>> +
>>   static int dax_hmem_platform_probe(struct platform_device *pdev)
>>   {
>> +	if (work_pending(&dax_hmem_work.work))
>> +		return -EBUSY;
>> +
>> +	if (!dax_hmem_work.pdev) {
>> +		get_device(&pdev->dev);
>> +		dax_hmem_work.pdev = pdev;
> 
> Using the pdev rather than dev breaks the pattern of doing a get_device()
> and assigning in one line. This is a bit ugly.
> 
> 		dax_hmem_work.pdev = to_pci_dev(get_device(&pdev->dev));
> 
> but perhaps makes the association tighter than current code.
> 
>> +		INIT_WORK(&dax_hmem_work.work, process_defer_work);
> 
> See above. I think assigning the work function should be static
> which should resolve the issue Alison was seeing as then it should
> be fine to call flush_work() on the item that isn't on a work queue
> yet but is initialized.
> 
>> +	}
>> +
>>   	return walk_hmem_resources(&pdev->dev, hmem_register_device);
>>   }
>>   
>> @@ -162,6 +219,11 @@ static __init int dax_hmem_init(void)
>>   
>>   static __exit void dax_hmem_exit(void)
>>   {
>> +	flush_work(&dax_hmem_work.work);
> 
> I think this needs to be under the if (dax_hmem_work.pdev)
> Not sure there is any guarantee dax_hmem_platform_probe() has run
> before we get here otherwise.  Alternative is to assign
> the work function statically.
> 
> 
> 
>> +
>> +	if (dax_hmem_work.pdev)
>> +		put_device(&dax_hmem_work.pdev->dev);
>> +
>>   	platform_driver_unregister(&dax_hmem_driver);
>>   	platform_driver_unregister(&dax_hmem_platform_driver);
>>   }
> 

