Received: from CH5PR02CU005.outbound.protection.outlook.com (mail-northcentralusazon11012009.outbound.protection.outlook.com [40.107.200.9])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5902D331209;
	Wed, 24 Jun 2026 16:41:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.200.9
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782319292; cv=fail; b=NQG1fKryvLX8dV5PjlsC8rFc8G1WLin2o2h1SxobVddxrL0pgqQzKCLHw0M3UPHEQiCED7gjngVPYg2gKQepUpKqruS6MeKBXdrDuxMA+J2mPAMoJSijDdC8/cADEZ7JlPAbZa97DL+gti1F/H8gOVbb5c6bqkYpFP7rZFmSwqc=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782319292; c=relaxed/simple;
	bh=/tjg02QZia2H3+AJ7qmmLX6QBcKFB1Cs7HtdyMcwBFY=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=EVOPmhZlqp3LcWgKobugy5ZeZOIkP7AM4eSoVbkQCkSE1DxFwutMPiLJgdsVTXtTm1RM3zeT6gKyfcNOh8fgdSV5zJIb6u1h4nrf2UxzGegswBO+SswjFxhwBGu+TcrkFe/Uv4QmJbL1hywboU5rsWhXnPOsmUt3qdNDUiupHI0=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=Mgd8T2vf; arc=fail smtp.client-ip=40.107.200.9
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="Mgd8T2vf"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=o7gUQ3CT6u6eCvDIDUebPekqJOYuuDwwI7Q7gucdVscb+qhgxx6S9U4NHkpnWdO9ThdLP4mROGxYh39ARu1qtzww47kvVzcTm3wxKKbLZSlYz/V8Ihz2FqnT06+hP1XBOxUKK/5BzjdulWjUUBmDNjLAwLF86AcdccGb8UCQuWvoTxbFg8YkMIC3PxvJ6QFb1JAK9FjN2CSzOkoWgz9le3zeSoQ+ko/cLXyrURwJ/KppaNpWCeiSxpLm+yP+TZRRUF5UByZHoFGCrcZ0SkqR45sh1Je8WSUyoHnMQNvutrYNdIrNuNIOGZnD5/OFfZdWHqK6xZepKCgQLsh2MDVpOw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=IQC348/jjnpm3YhjFL5l5N3hsD6rHo9Z+kSh6eQelBQ=;
 b=Xrrhfmtccn3rDeSAKiPY2Qo7FCs291NbWWpjT/UCJSY1nbfw6DllJ+VWNw8bD/65TpPaEMJDCrwQld9hulgr3IhpIXuxasbPXraeSHrACslgVmsI+a26ciUcZxVwX3tItp/lJ1mc2VJ1GaI9pQykSrrcSYcTSxMt4EW9o6wA+nUKcu6VHyLFmvYExI1DWCQ3oLtsi4gtocb+8fvSqbReZ9oBhXu6FHoakuvJVjhS/VvT7vQB0C/1Rwg1bID3Pis+Ta4yvVmjIQwGnNidCs0Gy2dOsyIN6JZgMSKbFf1+oxWcel/cYNEQCCY9GltAAYYTFZwvkUFQCpdNrUn3FofcZQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=IQC348/jjnpm3YhjFL5l5N3hsD6rHo9Z+kSh6eQelBQ=;
 b=Mgd8T2vfrWwJSQNCOfZ8ZlJ8dcif7jpPMsZRksM9BczmoblF4sM8eY9vucAsRZBKA5oF2A3OP8KjNcG138ibM5QxbTvryiHoPbFuY9fgX9JXu1l32v2fhvqf13A2ZB/rJmZWFD/UXDUsFUWlW1K236oKKmTLYKoLJRVJ7QGjoTg=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from CY8PR12MB7433.namprd12.prod.outlook.com (2603:10b6:930:53::22)
 by SN7PR12MB7854.namprd12.prod.outlook.com (2603:10b6:806:32b::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.139.20; Wed, 24 Jun
 2026 16:41:23 +0000
Received: from CY8PR12MB7433.namprd12.prod.outlook.com
 ([fe80::faae:d638:bdc9:4bf6]) by CY8PR12MB7433.namprd12.prod.outlook.com
 ([fe80::faae:d638:bdc9:4bf6%3]) with mapi id 15.21.0159.012; Wed, 24 Jun 2026
 16:41:23 +0000
Message-ID: <5d3aa51c-d582-4989-a9f3-e46c95dcacb7@amd.com>
Date: Wed, 24 Jun 2026 18:41:14 +0200
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v5 4/9] mm/memory_hotplug: add
 __add_memory_driver_managed() with online_type arg
To: Gregory Price <gourry@gourry.net>, linux-mm@kvack.org,
 nvdimm@lists.linux.dev
Cc: linux-kernel@vger.kernel.org, linux-cxl@vger.kernel.org,
 driver-core@lists.linux.dev, linux-kselftest@vger.kernel.org,
 kernel-team@meta.com, david@kernel.org, osalvador@suse.de,
 gregkh@linuxfoundation.org, rafael@kernel.org, dakr@kernel.org,
 djbw@kernel.org, vishal.l.verma@intel.com, dave.jiang@intel.com,
 akpm@linux-foundation.org, ljs@kernel.org, liam@infradead.org,
 vbabka@kernel.org, rppt@kernel.org, surenb@google.com, mhocko@suse.com,
 shuah@kernel.org, alison.schofield@intel.com,
 Smita.KoralahalliChannabasappa@amd.com, ira.weiny@intel.com,
 apopple@nvidia.com
References: <20260624145744.3532049-1-gourry@gourry.net>
 <20260624145744.3532049-5-gourry@gourry.net>
Content-Language: en-US
From: "Gupta, Pankaj" <pankaj.gupta@amd.com>
In-Reply-To: <20260624145744.3532049-5-gourry@gourry.net>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: LO4P123CA0209.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:1a5::16) To CY8PR12MB7433.namprd12.prod.outlook.com
 (2603:10b6:930:53::22)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CY8PR12MB7433:EE_|SN7PR12MB7854:EE_
X-MS-Office365-Filtering-Correlation-Id: fb6c6b04-6a26-44ac-288e-08ded20f6cad
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|7416014|23010399003|1800799024|366016|6133799003|3023799007|18002099003|22082099003|4143699003|11063799006|56012099006|20046099003;
X-Microsoft-Antispam-Message-Info:
	c+X/T02gLuMr3K0hHvzaDK+WYJCWpj6KdDvO8L6keb/m/JXGHGTgsj/kqrfOmT7hKfIIAUMnkqdvtGU8N+JZlGXWZN9M6SYWLCt5/vN886jberfhPrEY2va4QubAe+YKNPjENli9cKndG3N1L5qRsCnvU9vqQRi5qVSHPNA3445DeDEwx6G950ClwIAQM/Ci4TbW1ENKwuNdqDweoMXsO7FtJxx5Vk8vsjia/rJrhHouBEKTrpacPdbXGG+b3C7upC9SOpcFJRUe+b4x+AMXr9h0uxTKkgRQ6EFIjxpdIhD4K24tL/iT3XNRWeab9AVBUFLDLVa6zXU6yWjlRPbEaJGZXhbT77eNpUAqaG+zFDI8x9LPNMvCfebiPxSs40RZEqYLKlQ56VyDmodbRhWMqkUywA91JI6GHnsd48V/vcBpRdPXgAGFKp0wksrqVsAUwN1cGQhPQJCs2wGZVApJMh5BySKKToKTGv1ZQlfyenRLA9CxiTmaq/kZuEtJZwlANGZ0BR+gCZHHdn5zFqnPrn4MA431bzQy/85RCLmRTYwdhBGKfoWESuL1JOJoUiyCvWhYu6W8mgMZq5Z8Pb2yxxd1Lx03gURsSYiRwZQEecP3dFmwIxbpm+r5QyuqJSmvt+YnJfbKjTpvFyLwck6TvlOgPcPeeP5TSB15bii+ktI=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY8PR12MB7433.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(23010399003)(1800799024)(366016)(6133799003)(3023799007)(18002099003)(22082099003)(4143699003)(11063799006)(56012099006)(20046099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?alhQUndhWFJPYkxwaGprRm54eHlqTTRnNVFCajRWQTBxNTVlVUJrS01jdHIr?=
 =?utf-8?B?MWVTbEMxdkhqMUZFZ1ljbldROGdLcjhDZ1dnMVpzT1VvS1NodUd6bFdYemI3?=
 =?utf-8?B?R2l1aW9QQ21Mait3L2pjZU80SHdqUFk5bDZkR0RsakxOSjFxcE9PQ3Q4ZlZO?=
 =?utf-8?B?eXVUWk9DUEc0YXBScGp2Ry8yWmVrNXVOK1E4MWlBOXN6Z1hidVEvUHJQUFFL?=
 =?utf-8?B?L0ZQdGxQU3VhQXhNM3BQSWNDcyt3THRKM0ExajdncVBheUhLYVVUWW9rNEc4?=
 =?utf-8?B?YWEzR2NLay9EZDcra0t2SVE1endFTmdZQWd6TjZXcHUzZmRBNWNkTGRxb09m?=
 =?utf-8?B?dDRReDRTdmxGOWhaZ2VyVXBseFBpNUxGaWRoWXZMZTRUOVR2RVNTc0E0V3ZN?=
 =?utf-8?B?T3ZtK0FVS0p3OVE1UlhGaldBTlZIN0ZWY1ZpN2Q0SDY3NDdSeHMxT0pCYUI3?=
 =?utf-8?B?KzJzWHJFOERnR1NjcVFHYTJMWDUyOW9oMHpYd25QTnNnVGFMbmo3bjBQUTNL?=
 =?utf-8?B?T3lhRE0xeFg1TURMdTlaUSs2T3J2UGxMOEp4a1g0d1lvbVYzcFl4VGl5dE1y?=
 =?utf-8?B?MDd5eFp5SWZzSy95dUhUVTFmTG9XTGhtamlTaWYvTHBab0FKUzNaNTh3ZlIx?=
 =?utf-8?B?WUFkRzlmdkg3VzlRVXgrSHhlRTFVK0hZN1ovQnkxY3JhOUV3c2NGL2tOclQr?=
 =?utf-8?B?blNXd1lYRXg2ZnFMeU9tYzdNOXhTdENRbUZZek93ZVJya01pcjlXeFpWV1hF?=
 =?utf-8?B?RkQyaWQ5MWU5TGRBV1VWY1hmOVJ4a20vTlppZ3IzanZvbTdFM3NqNGtIM1ZU?=
 =?utf-8?B?NUdxVnJHSUtuZFN5RmN1aFlRK0F2WU1yQUVUTnlDc2FReld6UWJ3V256eFc0?=
 =?utf-8?B?Y3Y2RFdVSU9LTU1qeVBnOG1aZlg2UGFSY2pHWGp4aHE2ZFQ2djV5a1hkSW9N?=
 =?utf-8?B?U0pZRG5RMytrNTdXNGZKNExCSVhCVGZhODN5RlNNeTgveEtteVhUQktCTFE4?=
 =?utf-8?B?THU2emNoVHlvR2VJa1BxYXBpYWEwZDlnczlHNnF3UlNUcStJV0RtMHliaUk1?=
 =?utf-8?B?bjRGSEFPc05FalhoeGxXLzFWa3BYZllCcUdVT0NGY2tsbEpqem03WWVvN3k5?=
 =?utf-8?B?RGpKUnJVbStUVjczWk0raE9BS1k3cHBpbEllQ0lCRWtRTFU4eUM2WHhDcjYv?=
 =?utf-8?B?SVdLbDJPdW5pRjl1aURscXp3VmlEZVRpQzIrRCthNnh1WWRCQTUwSjIwVkdU?=
 =?utf-8?B?QnV4Tmtia01ZbXlKR3ZWY1VwaSs4THkzdE1BaUpKam1HTDd4ckJ5Y2JsNjIr?=
 =?utf-8?B?WUcvNnZCWUVJdnYvekV4MmRFa3lxMVppRzV1dkhZTU4zNWtQMlBKZ0xldFJB?=
 =?utf-8?B?dzU5dTdIS3h1ZzdTSW0yeGh3RVI5bUlUN0h1ZDNwVzZjamQwVm9hZkpGeWpH?=
 =?utf-8?B?akVZVXJxclU3VDB2dUdHUGI0MHBWeXFuUGdZT3RUODVNNFUvbG1FNW1QQ2R3?=
 =?utf-8?B?U1NseFBJUm02TVpCWXdjMTFlRWNSVTVXWHgwRnF3WDRoRFlkclNRNHlxSW5J?=
 =?utf-8?B?ZzVvR2JWTHdyeVFQa2QxTkE0QzVkVE1FSlF3VFJRZ1Blek1vWTRDNVFjeERY?=
 =?utf-8?B?b2lSRFdkRm85Vng4VVozQWJycFdIQnhTYWh2Wmhhd2VoNXZHWFZjbFNHczlK?=
 =?utf-8?B?RVdHZUJjMlV6THRLV3BveDRrTXZaTWJ1WU5QckY5VGx1WG1ZU1JrOVJvMnpz?=
 =?utf-8?B?bFNsMTQ1alIrdjExakFOWW9zR3hvdEVYNUpMNEx0OTBZd0pHcWNidGJ1UkRJ?=
 =?utf-8?B?S1hzMEYzNHh0aXNBNkJSc1RkNmRIQW5HdlZEWXFRS0NnWDVJMlNvUi9ndGNQ?=
 =?utf-8?B?RzlXN29MRFgvZE9LbHMxYTdxZVVVUzgrWWdha1lWcXNwQ05pbXpNMnBucCs5?=
 =?utf-8?B?UmxpVDBHRVJuT0JGekpoWVFIOWlQa3lsT3RDVVB5RGdkekdnbStoaGpJSmpl?=
 =?utf-8?B?ZUFXK3BHaEExcW9OZE96aWJtUitHZVhRc1dKQTVFTjhhQ0pOSHNaU3ZRWlZn?=
 =?utf-8?B?a3U5UUFQRjFNWjh2eVBGRDVlaE5PLytwbTJITVZXMEZqVGJiVHV4WG5aY25n?=
 =?utf-8?B?ZlRIckxDd1czZDl4MnlXbnFMeVUyRlFSanZHOERVeXRnZFpLUThDYm1FaDl3?=
 =?utf-8?B?MVJvRWVTTGhUamRpRXZUcnY1RFVqVU9Qd3FQckJWRWJtY0YwbW9EZzQ5bnVo?=
 =?utf-8?B?RVpiQjdMVUZKRjZ2SHl3bkVwdC81WGFqY25TK0pDdzc4Tjh5eVJlSUhPa0Rh?=
 =?utf-8?Q?d/Z6Yerzu1/rmAi1qL?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: fb6c6b04-6a26-44ac-288e-08ded20f6cad
X-MS-Exchange-CrossTenant-AuthSource: CY8PR12MB7433.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Jun 2026 16:41:22.6887
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: OiF1zzel0zrx4RpHLrwN1XRA3wcuh+twNapi2oW8Q3GrRmw5Vuh4TnGEg8ZRWA/kYOXALgmLMCZwVD6BPSjNow==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR12MB7854


> Existing callers of add_memory_driver_managed cannot select the
> preferred online type (ZONE_NORMAL vs ZONE_MOVABLE), requiring it to
> hot-add memory as offline blocks, and then follow up by onlining each
> memory block individually.
>
> Most drivers prefer the system default, but the CXL driver wants to
> plumb a preferred policy through the dax kmem driver.
>
> Refactor APIs to add a new interface which allows the dax kmem module
> to select a preferred policy.
>
> Overriding the configured auto-online policy is only safe for known
> in-tree modules, where we know the override reflects a different,
> user-requested policy.  We do not want arbitrary out-of-tree drivers
> silently overriding the system-wide onlining policy, so restrict the
> new interface to the kmem module using EXPORT_SYMBOL_FOR_MODULES()
> rather than a plain EXPORT_SYMBOL_GPL().  Other in-tree modules (e.g.
> cxl_core) can be added to the allowed list as the need arises.
>
> Refactor add_memory_driver_managed, extract __add_memory_driver_managed
> - Add proper kernel-doc for add_memory_driver_managed while refactoring
> - New helper accepts an explicit online_type.
> - New helper validates online_type is between OFFLINE and ONLINE_MOVABLE
>
> Refactor: add_memory_resource, extract __add_memory_resource
> - new helper accepts an explicit online_type
>
> Original APIs now explicitly pass the system-default to new helpers.
>
> No functional change for existing users.
>
> Acked-by: David Hildenbrand (Arm) <david@kernel.org>
> Signed-off-by: Gregory Price <gourry@gourry.net>
> ---
>   include/linux/memory_hotplug.h |  3 ++
>   mm/memory_hotplug.c            | 61 +++++++++++++++++++++++++++++-----
>   2 files changed, 56 insertions(+), 8 deletions(-)
>
> diff --git a/include/linux/memory_hotplug.h b/include/linux/memory_hotplug.h
> index f059025f8f8b..d3edeb80aadb 100644
> --- a/include/linux/memory_hotplug.h
> +++ b/include/linux/memory_hotplug.h
> @@ -294,6 +294,9 @@ extern int __add_memory(int nid, u64 start, u64 size, mhp_t mhp_flags);
>   extern int add_memory(int nid, u64 start, u64 size, mhp_t mhp_flags);
>   extern int add_memory_resource(int nid, struct resource *resource,
>   			       mhp_t mhp_flags);
> +int __add_memory_driver_managed(int nid, u64 start, u64 size,
> +				const char *resource_name, mhp_t mhp_flags,
> +				enum mmop online_type);
>   extern int add_memory_driver_managed(int nid, u64 start, u64 size,
>   				     const char *resource_name,
>   				     mhp_t mhp_flags);
> diff --git a/mm/memory_hotplug.c b/mm/memory_hotplug.c
> index 494257054095..a66346def504 100644
> --- a/mm/memory_hotplug.c
> +++ b/mm/memory_hotplug.c
> @@ -1494,10 +1494,10 @@ static int create_altmaps_and_memory_blocks(int nid, struct memory_group *group,
>    *
>    * we are OK calling __meminit stuff here - we have CONFIG_MEMORY_HOTPLUG
>    */
> -int add_memory_resource(int nid, struct resource *res, mhp_t mhp_flags)
> +static int __add_memory_resource(int nid, struct resource *res, mhp_t mhp_flags,
> +				 enum mmop online_type)
>   {
>   	struct mhp_params params = { .pgprot = pgprot_mhp(PAGE_KERNEL) };
> -	enum mmop online_type = mhp_get_default_online_type();
>   	enum memblock_flags memblock_flags = MEMBLOCK_NONE;
>   	struct memory_group *group = NULL;
>   	u64 start, size;
> @@ -1585,7 +1585,7 @@ int add_memory_resource(int nid, struct resource *res, mhp_t mhp_flags)
>   		merge_system_ram_resource(res);
>   
>   	/* online pages if requested */
> -	if (mhp_get_default_online_type() != MMOP_OFFLINE)
> +	if (online_type != MMOP_OFFLINE)
>   		walk_memory_blocks(start, size, &online_type,
>   				   online_memory_block);
>   
> @@ -1603,7 +1603,13 @@ int add_memory_resource(int nid, struct resource *res, mhp_t mhp_flags)
>   	return ret;
>   }
>   
> -/* requires device_hotplug_lock, see add_memory_resource() */
> +int add_memory_resource(int nid, struct resource *res, mhp_t mhp_flags)
> +{
> +	return __add_memory_resource(nid, res, mhp_flags,
> +				     mhp_get_default_online_type());
> +}
> +
> +/* requires device_hotplug_lock, see __add_memory_resource() */
>   int __add_memory(int nid, u64 start, u64 size, mhp_t mhp_flags)
>   {
>   	struct resource *res;
> @@ -1631,7 +1637,15 @@ int add_memory(int nid, u64 start, u64 size, mhp_t mhp_flags)
>   }
>   EXPORT_SYMBOL_GPL(add_memory);
>   
> -/*
> +/**
> + * __add_memory_driver_managed - add driver-managed memory with explicit online_type
> + * @nid: NUMA node ID where the memory will be added
> + * @start: Start physical address of the memory range
> + * @size: Size of the memory range in bytes
> + * @resource_name: Resource name in format "System RAM ($DRIVER)"
> + * @mhp_flags: Memory hotplug flags
> + * @online_type: Auto-Online behavior (offline, online, kernel, movable)
> + *
>    * Add special, driver-managed memory to the system as system RAM. Such
>    * memory is not exposed via the raw firmware-provided memmap as system
>    * RAM, instead, it is detected and added by a driver - during cold boot,
> @@ -1639,6 +1653,7 @@ EXPORT_SYMBOL_GPL(add_memory);
>    *
>    * Reasons why this memory should not be used for the initial memmap of a
>    * kexec kernel or for placing kexec images:
> + *
>    * - The booting kernel is in charge of determining how this memory will be
>    *   used (e.g., use persistent memory as system RAM)
>    * - Coordination with a hypervisor is required before this memory
> @@ -1651,9 +1666,12 @@ EXPORT_SYMBOL_GPL(add_memory);
>    *
>    * The resource_name (visible via /proc/iomem) has to have the format
>    * "System RAM ($DRIVER)".
> + *
> + * Return: 0 on success, negative error code on failure.
>    */
> -int add_memory_driver_managed(int nid, u64 start, u64 size,
> -			      const char *resource_name, mhp_t mhp_flags)
> +int __add_memory_driver_managed(int nid, u64 start, u64 size,
> +		const char *resource_name, mhp_t mhp_flags,
> +		enum mmop online_type)
>   {
>   	struct resource *res;
>   	int rc;
> @@ -1663,6 +1681,9 @@ int add_memory_driver_managed(int nid, u64 start, u64 size,
>   	    resource_name[strlen(resource_name) - 1] != ')')
>   		return -EINVAL;
>   
> +	if (online_type < MMOP_OFFLINE || online_type > MMOP_ONLINE_MOVABLE)
> +		return -EINVAL;
> +
>   	lock_device_hotplug();
>   
>   	res = register_memory_resource(start, size, resource_name);
> @@ -1671,7 +1692,7 @@ int add_memory_driver_managed(int nid, u64 start, u64 size,
>   		goto out_unlock;
>   	}
>   
> -	rc = add_memory_resource(nid, res, mhp_flags);
> +	rc = __add_memory_resource(nid, res, mhp_flags, online_type);
>   	if (rc < 0)
>   		release_memory_resource(res);
>   
> @@ -1679,6 +1700,30 @@ int add_memory_driver_managed(int nid, u64 start, u64 size,
>   	unlock_device_hotplug();
>   	return rc;
>   }
> +EXPORT_SYMBOL_FOR_MODULES(__add_memory_driver_managed, "kmem");
> +
> +/**
> + * add_memory_driver_managed - add driver-managed memory
> + * @nid: NUMA node ID where the memory will be added
> + * @start: Start physical address of the memory range
> + * @size: Size of the memory range in bytes
> + * @resource_name: Resource name in format "System RAM ($DRIVER)"
> + * @mhp_flags: Memory hotplug flags
> + *
> + * Add driver-managed memory with the system default online type set by
> + * build config or kernel boot parameter.
> + *
> + * See __add_memory_driver_managed for more details.
> + *
> + * Return: 0 on success, negative error code on failure.
> + */
> +int add_memory_driver_managed(int nid, u64 start, u64 size,
> +			      const char *resource_name, mhp_t mhp_flags)
> +{
> +	return __add_memory_driver_managed(nid, start, size, resource_name,
> +			mhp_flags,
> +			mhp_get_default_online_type());
> +}
>   EXPORT_SYMBOL_GPL(add_memory_driver_managed);
>   
>   /*

Reviewed-by: Pankaj Gupta <pankaj.gupta@amd.com>


