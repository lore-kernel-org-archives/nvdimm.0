Received: from SJ2PR03CU001.outbound.protection.outlook.com (mail-westusazon11012031.outbound.protection.outlook.com [52.101.43.31])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C5DFF2DC764
	for <nvdimm@lists.linux.dev>; Thu, 12 Mar 2026 21:28:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.43.31
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773350930; cv=fail; b=ka14Kle2JmL2G20zkHoesGcLg/xUQGaEfBrqGthU7XTcvvbvyOqkYSkHFee1eD2uR8BJc/X5ypbVKLQ83s6lz+uffrrKx3qdLtDGS93wuOD86W8fx8SXMSPUeqzvPgBKAX1QdZ3kUgmhz0dknyLr/J5uNwZjjzLebU+YG/35g6s=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773350930; c=relaxed/simple;
	bh=pjobGC6YdOd3K6d5HmXwcKORI4sHLm3N59NUTmcfJuU=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=YxdWZx52DxDxC1xttKC1WJCDyHz5be/0jtUh6u04hvl77FNMC79/fujVlwyQDh1w/P1bfwNgqYOoaeq+Aui+mFyZ2BCHvQhkMcrr7KBNQGW+wpR5dH6TbgShDJX0gv86VI/II7u97st1tO9HjeNcv0dYbjq8YWO8310AxA1HoeE=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=4raoR8An; arc=fail smtp.client-ip=52.101.43.31
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="4raoR8An"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=RtB9PXknef+Z5tkHWUExbGGQtyrusQkqh1BWYWt8dHs9XO4wLG2ywtPwjZJboKK4zTnmU4NTEePgRv2zIn9RC9gdrCB0kNZE6YsoGeCUqFFcqTS/9QwcCiZtqWxZ8T0NCfIuBXeZVg9hH6NyF0I7zqQ9FhHJ2etsRA1UJ/guQZpb/iLz5SYQSxRLZWuUyqidzycKLDGhSOP86/NlpaLsZJjOcquV8BSAtI6iNijfZxebFIpcYmx5MwGH0cHzL4LevvNX2eiNDeMOtCkAnRnDorZbnXkt4jFNTBrg1dlyUp8fCGQAyTGmDqXk7SovqYZ53W+l76vt54RWKeMdSjqQPA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=bf7ZnaLLvKEC49RCtvjRuMXhDwFgryxjJqXwyMx2HCw=;
 b=BUBKovd+UZD+gMbrORdJGgarpguIUKNPRHhHJ5QcFifSvY7XnXU014nm9trZbB5s81Q6942E8yTblRlpj3JiHPPyMaWjZdXzNRjgGMaewDROPoqQ3n/N9n6VLaiBBa6e7G0cp0EWdB0GH12SVL/deREhJeIi09EZgOUyWMIs72LJNCSlsOgt/VZlJiNEyBZk3NcMMjf9iyFUH380eB4hht0lZxIc30LguftjT7W7JlYMbpymXUTJm90YZXoNi1wXkZreU6K+wZIYinr6SRErej4PXbgbre6eJnLzNbTmQeIiqrS+4wT2SeykSku8lymHl4oCQzwbATG3aLQFKC/W/A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=bf7ZnaLLvKEC49RCtvjRuMXhDwFgryxjJqXwyMx2HCw=;
 b=4raoR8Anive0ZtjqihARDs2T9sep5NCwuO3KMgveX+dkmVOjUBbnUdOPVHd9Q8caF2JHjpV5TT+iS6IPrxwYRWvf9eGMwYvl+PTOCuuaBaNHxmAFzjCCs5S1XZ9HWOryQggklUpUBEa1XHjgr+RrYiMXozN0W8TsYEkUXBaVAJw=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from LV8PR12MB9714.namprd12.prod.outlook.com (2603:10b6:408:2a0::5)
 by CY8PR12MB8410.namprd12.prod.outlook.com (2603:10b6:930:6d::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9723.4; Thu, 12 Mar
 2026 21:28:43 +0000
Received: from LV8PR12MB9714.namprd12.prod.outlook.com
 ([fe80::8c9f:3a5b:974b:99c6]) by LV8PR12MB9714.namprd12.prod.outlook.com
 ([fe80::8c9f:3a5b:974b:99c6%6]) with mapi id 15.20.9723.006; Thu, 12 Mar 2026
 21:28:41 +0000
Message-ID: <04db023e-fbd7-4760-99f6-7a8d0f858718@amd.com>
Date: Thu, 12 Mar 2026 14:28:37 -0700
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v6 3/9] cxl/region: Skip decoder reset on detach for
 autodiscovered regions
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
 <20260210064501.157591-4-Smita.KoralahalliChannabasappa@amd.com>
 <69b1e0aacb9d0_2132100c5@dwillia2-mobl4.notmuch>
 <69b319d7e6adf_213210086@dwillia2-mobl4.notmuch>
Content-Language: en-US
From: "Koralahalli Channabasappa, Smita" <skoralah@amd.com>
In-Reply-To: <69b319d7e6adf_213210086@dwillia2-mobl4.notmuch>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: BY1P220CA0012.NAMP220.PROD.OUTLOOK.COM
 (2603:10b6:a03:59d::8) To LV8PR12MB9714.namprd12.prod.outlook.com
 (2603:10b6:408:2a0::5)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV8PR12MB9714:EE_|CY8PR12MB8410:EE_
X-MS-Office365-Filtering-Correlation-Id: 387a29cf-bce5-418c-f33f-08de807e5524
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|7416014|1800799024|366016|3122999024|18002099003|22082099003|56012099003;
X-Microsoft-Antispam-Message-Info:
	hVI+Hr6OekFuqXmZmjOQIGZVeYRQ+brHh/0PVKY9VzntPeQTLumH6iPQ2jpyWTE/D/rHpHVIGJNahejbxfRvhP7YjeVpDoG/46fHc9QmYeLXDqQUyfxfOnH8gkQ2apBGwVgMjGoieQRTiTFHPm5J8BlO0PlSWwtQtueEtdXEtNMyEOmEq68vao58+8UrthplIdfeWqFbv19rT8NEmwq+o4jbup3I6UcdfkRNGsc4b2FSMXnxOpREpU8sQhk261Bn73+AtWsWWJ4XDoIwr4zt1hmVf8ZDyKJampBeOdSCZ5Q8/zeKA/XMb14tchdz+QQdD6c5p7mnPFpPanJ0Xkzve+6u7uAc19zEC9g8+KJlyJ1SSSveoapKa296WhrWHrjtXFq80pgKqDjOVNv6Ho1w2ARasUf3fVHXYX3R7PQ2T9NglQoRKm/gXa85XCCfZ59ELQ2MjFZjOMq2TBQas0CooCL42BMy3dV8fyRX0sUuitY1AGmjVLe2aoRWdWIJu2YBIiv1TsuQQi2P7vEOP89hv0ol7+nhTP8SAoW6yUD2mIFLt0v7MICY/7NaSg06zbe/097xnObrJp7XVaD/5xPXBZu5TM7hWqtMCapo/3vNRfl328NUoielPRutYyyZ/nKNVBt3voZMhhfCJzQ7rO2vBBIVz4qmW4A8cJLMF3h2ZCT8sOyn680OTHmjJjqez0YshfI2wIk3FDfhSzwMQP1OeC/nx/NRIeSscSlmKOPqtB0=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV8PR12MB9714.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(1800799024)(366016)(3122999024)(18002099003)(22082099003)(56012099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?MWVQeGpLckh6ckI2end5UXpqdjh0anhncXhNckFkaGVIekZITFN2UGZvL0JS?=
 =?utf-8?B?bEtTUHhLWllDVDVPekFXbHhLeDUxbXZsWjA4VGtIN1hnazZuU3V6b21maUxt?=
 =?utf-8?B?cnphVGpSbzdQeGJxcG5RcHgvWkR1OEtka3dJQzY3TU9GS1JvcHZoTHlldU1y?=
 =?utf-8?B?QWxLbHRxUlRBeGxQeFZreTdZalNaM2ZtaGpiWkNrdEFwUGRlaUpUZHBPQmZl?=
 =?utf-8?B?ZUxEN2ljWjRka3FqSldTYjhCQ3NJMmJFMHBIeTFYK0sxMHlRaFNkVllOWXdG?=
 =?utf-8?B?SGJxczJpS1R2S3R6K01Zc3lQa2Jiclp6bWkvbXdjTkVNZkpmYnl1TWlZaWJH?=
 =?utf-8?B?RUFsZ3kycjhMUTdmbWY2TlRTZHF4K05sR00zZTNaWnB4Qmg5T0hEaCtRWTlM?=
 =?utf-8?B?UUQrS2M0ck1jV1MxTUZXUUp0Vm9wQmZjR3lhbUdrZEVHYXhOQ2R5NTYxUUNj?=
 =?utf-8?B?UE8yd0RxOXZBZzVEajQ2Z0o4cFJkeXVFbWlWSllEblc0NEp2RXZheDlFS0Z5?=
 =?utf-8?B?ZERuMlU3aFkrMGEwUWtWMnhNVDR6NWlXblk3WXBCOWw2YyttbjRyZkdIUEpY?=
 =?utf-8?B?bTdiVlA4bzE3MnNsQ28rUGxXTVV4YmZBMHVicnZ6alk3OEV1dElNeGY2K3Fv?=
 =?utf-8?B?bGlNMDdqTWt2cEgwNGNJZTF5SDREMGtiTW5COFl5YTJreTVZQmVUNXdNaW9M?=
 =?utf-8?B?NkdmSTVDbmZFb3FDUndhSzAwampoNVVNZFJRNDNwVURiWEY1TnhXNEpyMnll?=
 =?utf-8?B?Y0wxdlNURnd2T3JWc3lQVkN6V0JFUUpMOUgzWCtTRkRzOVR1czI4YXdrZGZG?=
 =?utf-8?B?ZGNsZ2wyQzlqNU9sNnI2N2RBS1VpT2RJZ0NYejBzQ0NTZWp0cTlEMTBrOWhm?=
 =?utf-8?B?NlVsNkZlZXN6MmRmQitucVdPeTk3Mk40dVhWcmFYSXp4aUVvUzZoV2x0aWYr?=
 =?utf-8?B?SGlMTnJUbXVRUzFGZjgxdlBMam5yZ2NqVEF1NTlRODRlQmJoRlhyTlBjRXZJ?=
 =?utf-8?B?UWZHWVBiSVJ4M0l5NncydVNvY2FhRE04S1V6bHY4MkZoVjU5V0YvblVsQ3lE?=
 =?utf-8?B?Y0wwVDVkK2dHS09YR001QWxaQ0lFRklOTzdCTkE5UzEzU2lPWDZ6enU2TXUv?=
 =?utf-8?B?WVB2UkhWOXFIb3QranB0amFWK2Z1Vmk5OXBaaTZLelFWU2d2Vm1qckFpVEtK?=
 =?utf-8?B?dVNpbnUyeHFkWldRdFBYVHluWThJMWhYMm8rZExaQkJtK0cwUDRva09ZakRI?=
 =?utf-8?B?ZmplZEYzRXJoYk9xNXltcEJGVGFBbDByS0tjdFp5N2tHbElFU2xOUW1TclZZ?=
 =?utf-8?B?d1lFaTZ1dHVBOVltYVlacFhhbVJ4UTVnQmJMMTBvMEpRQTVJTlZLVnlnQTBv?=
 =?utf-8?B?OWtKQU5BWVlMSzQ1NGNvcnFzb3Rva1JGZ0YzRHU4bmdnQnJEQkJSTTRHaWps?=
 =?utf-8?B?Q3N6Nlg0ZXBsWk1Oa21LQnNEU0oyRWhzdXkyZGZxWXZZUHNObFAyZ3NSWENV?=
 =?utf-8?B?MEFENjdtV29RM1dwalorRkxKNTA0YmtDRFQzVlpSUEllMHVhZVR1bzVvWFBp?=
 =?utf-8?B?UW9vR3BUVEc2NFVhM29VeHl2RjYrazJqbklFbWdKTXVaRmE0S0x0bzJVNDd4?=
 =?utf-8?B?VHIxaFNTUjQ2N2dOZlBMTEYvL0VzSFpWcHNNVmVndWlEVWlxSzQ4UFFKOENC?=
 =?utf-8?B?bzQzQ2t3L3dvRkoyMTdwSlllM1hjNFZtN1I3N2tJZDdMclcxWCtmbmtWYlR4?=
 =?utf-8?B?Y3JtQjZDeTR3V2JYNjZwYnYxN3dkVFprNDluSURjQ2lGd011RGtZdFdkUHdM?=
 =?utf-8?B?eFNxT0E0bnVXYnRpSzRTL0RZdE1vR0xoQkNVbkVsQW54YUxLaHBFc2trZ2sv?=
 =?utf-8?B?cjFpZzk2WHlVT2duQmhWWlQzL1pSYVBYZGhlTlN0bTBLd3o2Rm9BNTlmVUVK?=
 =?utf-8?B?TUlHRGs5cmFpSlU0ZDhWbmJOd1k1RmM1eEZobWd0S0xndEVPejJiZUtWMnZj?=
 =?utf-8?B?NXZCK2pvL1VzMkRZcjA1VmpBSEdkZHZYNi9BYjNYMFloQUlQVVZtM3hzNkFE?=
 =?utf-8?B?R3JSQ1dXY0lsc3B5VWpjT1ByYmNTUWMxbjNxeSsvQjU0Vmc5MVJXaFdBYzlF?=
 =?utf-8?B?VXpvTksxMU5kL3BObVJCTVBzSmdaRXJpY3I0M3hQZ3JNeE80SWZSWExWQ1lR?=
 =?utf-8?B?TEN2bUl1Q0Rva3RrVzZiV0hTQmx5YjBianFRQ3BLK2l5cGZ1MFhuOVVzaGFU?=
 =?utf-8?B?bmRjd3BGV0ROY1RXQldMWW1jRGZHdFduNDBKNnRHVWFRdWpjNzNjOHg1cmNG?=
 =?utf-8?B?U0hqMFpmWVZObSs4WW85eHovSUM5TGpucXJSbFYwdDMwaEMzMDRBZz09?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 387a29cf-bce5-418c-f33f-08de807e5524
X-MS-Exchange-CrossTenant-AuthSource: LV8PR12MB9714.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Mar 2026 21:28:41.7495
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: gySWm/9Oojijp9OeZZ3T14YCAD1dHax30FkRuU8obiF5aHECpbpsHvTatJRca6Mp/0wC7cGO7pIBk/7hzKCzSg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY8PR12MB8410

On 3/12/2026 12:53 PM, Dan Williams wrote:
> Dan Williams wrote:
> [..]
>> All of this wants some documentation to tell users that the rule is
>> "Hey, after any endpoint decoder has been seen by the CXL core, if you
>> remove that endpoint decoder by removing or disabling any of cxl_acpi,
>> cxl_mem, or cxl_port the CXL core *will* violently destroy the decode
>> configuration". Then think about whether this needs a way to specify
>> "skip decoder teardown" to disambiguate "the decoder is disappearing
>> logically, but not physically, keep its configuration". That allows
>> turning any manual configuration into an auto-configuration and has an
>> explicit rule for all regions rather than the current "auto regions are
>> special" policy.
> 
> Do not worry about this paragraph of feedback. I will start a new patch
> set to address this issue. It is the same problem impacting the
> accelerator series where driver reload resets the decode configuration
> by default. Both accelerator drivers and userspace should be able to
> opt-out / opt-in to that behavior.
> 
> This will want some indication that the root decoder space is designated
> such that it does not get reassigned while the driver is detached.

Sure, this patch is not needed for SR series as region teardown is been 
dropped. I will exclude this while sending v7

Thanks
Smita

