Received: from SJ2PR03CU001.outbound.protection.outlook.com (mail-westusazon11012039.outbound.protection.outlook.com [52.101.43.39])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 593133FE654
	for <nvdimm@lists.linux.dev>; Tue, 24 Mar 2026 14:06:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.43.39
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774361206; cv=fail; b=dcZ0eAdOnWwl5pZADpca7jJpLEREGgKATMGG/c3x03ulb1zejsQm7gqQgiwC1k7VUO39pkPL+uJkBMU7g00lQ12nFKJ8C68Z56sjx0Bozz1NMmpUI0ElBqxj87HcE1wTMqWZ2Je9t7lnEyxa8/D+9WU0FealnVTKON5UgUQkAu4=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774361206; c=relaxed/simple;
	bh=wQL9zGa+SnVCnfRRoo2qbaQr3SvWnaI4YlXSUQxgmGc=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=lkbOnHrnj575HezCU/FXH0olaBIv9lm4dW6lQ0arQ8qg5WCy/HegG3bYewdfL4WVQU2fMBFAEyYezUOSXEvAfoMKNTpbmQEPkLevrtddnzvynOsNX3VJnQKzkKcyxTgm9ykwyTTIt2yVsXYHQHDECXIvAKm5oItUf4+gLSQp00w=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=DkRGmMUN; arc=fail smtp.client-ip=52.101.43.39
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="DkRGmMUN"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=nXPV2fTJoJ3F1NP9lUkGGWyvzE0/2tjOYDaI3CYuRr+gbC6LNUTZY2KqfN+GKaKGWsfG2nCZpT4DwRDTa+qDGY+j5MyhboXhJnWUBxXA0UmERlGDjH3ZyU3WC1YFYa2KWsVEgDMag/eQ3Oy6enmE2gNKghxIsgQGL5hmQy4EMuv+d5Ph4LIcfog8dVpiXf47lF1V6D298KWd+YOAq13xJjlbHPR+muwibZILNIprXBLygwavp+PnQ7HQLv2jPztYz0f4H1U6IhIJ6p7hx1dTQxMJBWtoXuN5m96RLRuIT9VeDhmFJ1n7DNqzqPpQwBC22xUj8PYEGRIXkeAmmbgJ+Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=rIZX0sbCCXEAU0rUDTdrcphfsJzoRxVfiiBX9b6aKRk=;
 b=idLVUNgV3KaHpLK+ptMhPyiPEKnpTkcHZxPpHGLfEYXEI9vRdA6nQOOiZvUFvU79WxqAT4MVk4rlRqc70y/z6Z4o52q5MpvhnjEixX7pQ4qQjguDagVTNKKGDMmYh3BPZVT//UPF1FjRc6/o3Xhs7nV02Q2aQ11ZhS0ul9F7pTG1TRQIW4ZRsVEcG4zu24gad2hrTF7ga5RpCpCkj47N3pgdqUFlm5ywsQ0q6XY7BSPIt8LNjiqO0f5drJuU58LphelkHhOuRSVO9WQPt0FHvD9ABX+n73YCTOPhQ+X9JfmeFVi8fkeVvGTbDrC0KjZuA9AfW/dyvj6BG8vjVtyjIg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=rIZX0sbCCXEAU0rUDTdrcphfsJzoRxVfiiBX9b6aKRk=;
 b=DkRGmMUNQRE5W66jnj1jecJrfgDVDjAbF233bHLShpcgHNDX9vtkxR9zGWj4EZ9l8XxaMYysJcwPZx6gLOO2WZkhAnvTesATKj/aQ1rPmpLpV8Su0BMWtm7bQcpycoWtYBQ9biyarAz3cwHzmXlT7hs7qBIyOsoIMXCy4beGQ1w=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from DM6PR12MB4202.namprd12.prod.outlook.com (2603:10b6:5:219::22)
 by SJ2PR12MB9244.namprd12.prod.outlook.com (2603:10b6:a03:574::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9745.20; Tue, 24 Mar
 2026 14:06:39 +0000
Received: from DM6PR12MB4202.namprd12.prod.outlook.com
 ([fe80::9e55:f616:6a93:7a3d]) by DM6PR12MB4202.namprd12.prod.outlook.com
 ([fe80::9e55:f616:6a93:7a3d%6]) with mapi id 15.20.9745.019; Tue, 24 Mar 2026
 14:06:38 +0000
Message-ID: <eecb333f-dd90-42ae-9f3f-cfcff8b7fbea@amd.com>
Date: Tue, 24 Mar 2026 14:06:29 +0000
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v6 3/9] cxl/region: Skip decoder reset on detach for
 autodiscovered regions
Content-Language: en-US
To: Alison Schofield <alison.schofield@intel.com>,
 Dan Williams <dan.j.williams@intel.com>
Cc: Smita Koralahalli <Smita.KoralahalliChannabasappa@amd.com>,
 linux-cxl@vger.kernel.org, linux-kernel@vger.kernel.org,
 nvdimm@lists.linux.dev, linux-fsdevel@vger.kernel.org,
 linux-pm@vger.kernel.org, Ard Biesheuvel <ardb@kernel.org>,
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
 <absY10LzUqb3vK7A@aschofie-mobl2.lan>
From: Alejandro Lucero Palau <alucerop@amd.com>
In-Reply-To: <absY10LzUqb3vK7A@aschofie-mobl2.lan>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: LO4P265CA0299.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:391::17) To DM6PR12MB4202.namprd12.prod.outlook.com
 (2603:10b6:5:219::22)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR12MB4202:EE_|SJ2PR12MB9244:EE_
X-MS-Office365-Filtering-Correlation-Id: ceeb4e78-d87c-444e-9304-08de89ae9125
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|7416014|1800799024|366016|18002099003|56012099003|22082099003;
X-Microsoft-Antispam-Message-Info:
	StTUxwOS+BAK4rNjhwLnf8bAlawqJHwlQR7PyvHty65HWoH/9ACzphZ1qpoFixvOUe2cpUDfenUvZ4aYqTuT/pV1FJbPB8pXG+lNdWw670TFVOWVOvpHlj/Ds2PTkVb25guD8ZD2ZXwVXKsLKfKtuJ4RAO4/T2F1JMw2vF8jAS9QxQKxmNmZynTYZ3kw9lirB/znHGc6XL8s5qVqP8/dRBN7cKv+8eTIHWYNagVIrsY9d0UX9YdKBMqUYRdzrP3ZnnsQQhj89fs5pmt0nKj0l91gq5og2SDnfdaihz9nlqbtjkxvYMK6kCOgm9i35UzE1l/inHTc2KsZmBZH6qjUxZ9HByOptacVRqh6BnHuu1FSfWBlbs44GaOWmgdErXNdQ6u5xain1EHkZjgKdV8haAZ/ksyXbM7v7Ip7/UURuSZQ7woO98bYFFxFy5oYDndo8yfEyZxqUnIcHDoWKEWLpA2EmuPTfns3zxqEWAlUOrkA6/xeDg8v1QZMJVhD/nG4+Y6HlaUV18VP38y90Cd+UCWW/WfNlto/Y1WymEQ/UBqDsgvi6qclSsc3n5f+9gsdM9YlwiDfMqoGCGtalsDZ1IirOZG0s1MoGBT7UUgm015GmSJ+Qaq1aEsWrLPpRmT+8I1L5sy/cUg7Bxa1iZwPbTZd7ZU5Y1KoY6Qp4bmk/osSgaS6TioWDTNTgxUwPx/wP8Qcr0Vmh9eDIJZIQHmHdqzE6U7GHrr61fRr8FLrUtw=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR12MB4202.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(1800799024)(366016)(18002099003)(56012099003)(22082099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?YWYyUXVEV1lBb2sxQlg3USt4T0d0QmZxK1JUeE5pdVdvTGlhdVFFSEhvbGw4?=
 =?utf-8?B?SnZZR01jSi9YRnp4dmNIZFlGWE54b1NqSHlKdWp4b0FEVy9YcjVBMXNyRmtH?=
 =?utf-8?B?aHcvS3pzVjhCeC9xOVBGSFlBVi83bXlJTU9NYlMxRlpLemFOK3N3U1Vwdjl4?=
 =?utf-8?B?T3pqeWVyUElvSUVhS3pjdE01MVVxdnpxWGphTmtjdHozZmg4TU0yOHRGTFF5?=
 =?utf-8?B?dUkvUzBIbC9ZUFFoSktCRFRBTTVNUmF5MmRqR0R6WGNaTmdjcklWUlZSWVlr?=
 =?utf-8?B?QktTaFlrRkwrV243RjlzRnJOOWRXZGUzNmY1TjZzQy9uZnRjeW4vL2d5b0lN?=
 =?utf-8?B?VW9WUUozdk93RGhIQmFKMUhNOVdLcXJHYnZWaTEramcyQVZKUnM0Wk81aGlu?=
 =?utf-8?B?NkxlZVNNNmE2bzlUb0xNbTU5VVNNdGt4NVE3VWpYZEVKTXVleTljZzVuaE1P?=
 =?utf-8?B?cnBPSWhISmRDSllXekxKVVZjZ1U1YjBEVGJzSTZsUFpOV2crQ0dINmxQYjAr?=
 =?utf-8?B?Y0dSWWtMZXFDSjFkbVRQb3M3RVZERW5FK3F0Ri96MGF3dENNWUpxNVBUS1B0?=
 =?utf-8?B?NG4vek1nYXd3ajhhQXZoUHJSOGk3R1NPYnNBenJjYTVyT2F6U3BXUlUwZXVO?=
 =?utf-8?B?bU5hUnQ3a1p5eFV4KzdHN3NKOGQrcy80d0xETzF5cDJ2L25TeVBuZzRaWC9s?=
 =?utf-8?B?dmlRd0ZySFo4RDAxMVhBZWVPYVcxU2Q1NHFOOFQxemtyNVBmdm13TjJVQmcr?=
 =?utf-8?B?UEUrbjJKWHRJeE1XZDNSWE5ZMG5iNnVJZmkzWWVKbkFOeW1vNEtNeE1tY2RF?=
 =?utf-8?B?d3lIUXJwaXJnaTBaWUQrOGNVMHdyMlJNWHdJT2dZNmpmVnhVL3V4Y04wVU5H?=
 =?utf-8?B?VVUyM1p4bENQUmxIK0xhRGZUcXpnTkdjR0U0RGVVS3VqRGE1NGtuQ3JBbmd5?=
 =?utf-8?B?UVNDSTlvU1FndVpaUmNCL1lFNUFwWDhiMldQM29FZlcxb212VVlNZFhtUmpt?=
 =?utf-8?B?UnRoK0hXYUZ1cnQ0OGdsbGgxbVVna2ZpWTk5cUFJTFdHWndBUmFCSDE5NTJX?=
 =?utf-8?B?U2NQMEV4dTFxVzlSbCtFenZEWnJCd01HZkRvdjRQM1VBaDVlcE5SclR2czdM?=
 =?utf-8?B?ckFNc2NOUVdCOGRTeFQxVW8xbXJ0RHc1VHJVb0J0Y2d5ZzZXZlJOeFA4aWRl?=
 =?utf-8?B?Wkc0VTdXY013dVQ0b3p0NVhhYnF1bVJDRUNBMFdsK1MvLzhvQUpsTkFZMlZp?=
 =?utf-8?B?VHpCOTIwK2dZT1BZYTRRQyt5SzMzNGdqOFo3OGQvNUViL0Y4d2tTQjhpWFQ5?=
 =?utf-8?B?QUFqTGpmQytuMlhlTCtaaDVBVG5ob0J5ZTIzMWMvZnliQ3hhRWJRTDg4cHBQ?=
 =?utf-8?B?QWVJQ0RPeUw2TlJkdlFGTFhjZitoeFJXOVN1cUo0MWd6ZkFjMjk4eDlFUEhR?=
 =?utf-8?B?VUppRnVNb3h0VVVSTHgrbmkzWW1ZbjRURUZpVjNRN2RxYnhWcEI2eEUzYWFz?=
 =?utf-8?B?OHVzMjhsVkNRbkplYjltOEt2c09QSFFFa3ZVdW9QQkFScHV1NUJDR0tsZXdo?=
 =?utf-8?B?amJsdVJVTDhYY21XWVN2TWJ0MzB3L0VoaXlZeDJoNUxKTlJVVzVLL250RHM1?=
 =?utf-8?B?SGNDN2FTMWd4eW9KWkNBMEc5NitGVzRNK25WMUlHclpYSmFPaUZFSktSbXpI?=
 =?utf-8?B?TVk0OHlzSGhRblg3ZnUwVlc4U04wM3RBaGtYS0VMZWVwbHp0bjVRNHA5TXNE?=
 =?utf-8?B?VTg3REg2Y1gzVjlHVU4rUXl3QWtPR211d0ZwSHRqaERvOEhwYzhJeTIxelgy?=
 =?utf-8?B?ZnpOUWpFK0FwdERKOXpWeDI0Mm5ZY1dwZ2tJOXNwU1lxKzlidE1LOTd1Ylha?=
 =?utf-8?B?ajI5MUdONVlENmREQTVVdUpabjd6RWI2K1R3ZmRsMjFQQ0djNUdld25ySW9z?=
 =?utf-8?B?YjJPMXc2VXdMQkpMQjBKeFo2NG1XSVB3bmgrYmFBTklOUXVRRzlBTnJpVHF5?=
 =?utf-8?B?QzVqQ0h6a25RQ3ZGQVBuSE0ydFA2R1Jjb2FTTHNtSjgyK1JrbTZlaC8xUjkx?=
 =?utf-8?B?VmZPQjJRZFY1SzZxbHpkK3M4SUd2L2ZwQjM2N1hQQzlYOUc2RG1iMk1hKzE3?=
 =?utf-8?B?NWpOTW5aNDZwdUNkM2xvcEU3ckpmbUp3Q2VHNDhCMitQUitkUGJJamNGYXhm?=
 =?utf-8?B?Sy85R21xejhmNjNBSjVCTEI3MUJYTnRIUlU4OVIvN0tQcmlLaVRvUkt0OVNv?=
 =?utf-8?B?bXgvbTNlblZXY3hsUzQ0MUtYRlFGcVVJbjV6SlIwY3JOWXJJMGVwVDdiY3pq?=
 =?utf-8?B?cnpzb2RmQ25TRzh2SW5rckxaMmd3cElrY0wvN3BHd1dIUFNWbnowZz09?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ceeb4e78-d87c-444e-9304-08de89ae9125
X-MS-Exchange-CrossTenant-AuthSource: DM6PR12MB4202.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Mar 2026 14:06:38.8597
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: tbxYWrGhtyRQdzB76ljXBC8DpIHEK21FnGinaZ1cTWjYHgEW38PdvEAS4HcNHMOQhZ3luGpgkIPJbT7BPN7adA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ2PR12MB9244


On 3/18/26 21:27, Alison Schofield wrote:

<snip>

> As a step in the direction you suggest, AND  aiming to address Type2
> need, here is what I'd like a direction check on:
>
> Start separating decode-reset policy rom CXL_REGION_F_AUTO:
> - keep CXL_REGION_F_AUTO as origin / assembly semantics
> - introduce CXL_REGION_F_PRESERVE_DECODE as a region-scoped policy
> - initialize that policy from auto-assembly
> - clear it on explicit decommit in commit_store()
> - use it to gate cxl_region_decode_reset() in __cxl_decoder_detach()
>
> The decode-reset decision is factored through a small helper,
> cxl_region_preserve_decode(), so the policy can be extended independent
> of the detach mechanics. Maybe overkill in this simple case, but I
> wanted to acknowledge the 'policy' direction.


I like this approach which separates AUTO flag from this need.


>
> Compiled but not yet tested, pending a direction check:


I have tested it using the Type2 v24 and adding some debug lines for 
seeing the proper flag check works when decoder detach.


Maybe there are some other aspects of this approach I can not envision, 
but I'm happy with this change for current Type2 needs. Hopefully this 
plus v24 can go through before the next kernel window closes.


Thank you,

Alejandro


>
> diff --git a/drivers/cxl/core/region.c b/drivers/cxl/core/region.c
> index 42874948b589..f99e4aca72f0 100644
> --- a/drivers/cxl/core/region.c
> +++ b/drivers/cxl/core/region.c
> @@ -432,6 +432,12 @@ static ssize_t commit_store(struct device *dev, struct device_attribute *attr,
>          if (rc)
>                  return rc;
>
> +       /*
> +        * Explicit decommit is destructive. Clear preserve bit before
> +        * unbinding so detach paths do not skip decoder reset.
> +        */
> +       clear_bit(CXL_REGION_F_PRESERVE_DECODE, &cxlr->flags);
> +
>          /*
>           * Unmap the region and depend the reset-pending state to ensure
>           * it does not go active again until post reset
> @@ -2153,6 +2159,12 @@ static int cxl_region_attach(struct cxl_region *cxlr,
>          return 0;
>   }
>
> +/* Region-scoped policy for preserving decoder programming across detach */
> +static bool cxl_region_preserve_decode(struct cxl_region *cxlr)
> +{
> +       return test_bit(CXL_REGION_F_PRESERVE_DECODE, &cxlr->flags);
> +}
> +
>   static struct cxl_region *
>   __cxl_decoder_detach(struct cxl_region *cxlr,
>                       struct cxl_endpoint_decoder *cxled, int pos,
> @@ -2185,7 +2197,8 @@ __cxl_decoder_detach(struct cxl_region *cxlr,
>                  cxled->part = -1;
>
>          if (p->state > CXL_CONFIG_ACTIVE) {
> -               cxl_region_decode_reset(cxlr, p->interleave_ways);
> +               if (!cxl_region_preserve_decode(cxlr))
> +                       cxl_region_decode_reset(cxlr, p->interleave_ways);
>                  p->state = CXL_CONFIG_ACTIVE;
>          }
>
> @@ -3833,6 +3846,7 @@ static int __construct_region(struct cxl_region *cxlr,
>          }
>
>          set_bit(CXL_REGION_F_AUTO, &cxlr->flags);
> +       set_bit(CXL_REGION_F_PRESERVE_DECODE, &cxlr->flags);
>          cxlr->hpa_range = *hpa_range;
>
>          res = kmalloc_obj(*res);
> diff --git a/drivers/cxl/cxl.h b/drivers/cxl/cxl.h
> index 9b947286eb9b..e6fbbee37252 100644
> --- a/drivers/cxl/cxl.h
> +++ b/drivers/cxl/cxl.h
> @@ -532,6 +532,16 @@ enum cxl_partition_mode {
>    */
>   #define CXL_REGION_F_NORMALIZED_ADDRESSING 3
>
> +/*
> + * Indicate that decoder programming should be preserved when endpoint
> + * decoders detach from this region. This allows region decode state to
> + * survive endpoint removal and be recovered by subsequent enumeration.
> + * Automatic assembly may set this flag, and future userspace control
> + * may allow it to be set explicitly. Explicit region decommit should
> + * clear this flag before destructive cleanup.
> + */
> +#define CXL_REGION_F_PRESERVE_DECODE 4
> +
>   /**
>    * struct cxl_region - CXL region
>    * @dev: This region's device
>
>
>
