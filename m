Received: from SJ2PR03CU001.outbound.protection.outlook.com (mail-westusazon11012065.outbound.protection.outlook.com [52.101.43.65])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AAE6C3E0241;
	Thu,  9 Jul 2026 08:46:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.43.65
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783586766; cv=fail; b=mdPGc5KLS2YY8A5waHZnX+eU804sB7eS3tiMRb3iYJvWfsur6NE7Z3M7f+cbz4778FGKiYEjxXjK5aR8uCxXEn7OELKs814+D+5XL5cf2FmGC5yQNpdz0vRm9kVAVJMPahYh4ZVaGZfEBB4zl893EYIiWRCIP1QuyYhKufO6u2Y=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783586766; c=relaxed/simple;
	bh=AuYwDtzHflWOI3fN7ZHzWTV22EcDZGfIWajEXq4KFjc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=cncFb2/2WHSlG9maqs47/0NhVdbglruj/K66bG3tjOpBm9sre5WIFr4jGL1Gg8EJeXNgP3wdNxM2NLB8bmCNxQB43o+/pK6WkIIVuQghj9s9lJkKfjTGw1RLSMGMqTN5CmiIfmfHtge/VZMtLuWwCRI63/nh8al3VQp1lp7427w=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=aAtkuTkt; arc=fail smtp.client-ip=52.101.43.65
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="aAtkuTkt"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=tGNANwinMChjdL+m4KX6QvU4MJHfBr14MlWrHxm1QNpjQjdeU3GdnqYegdlDU2U2vvoXTt4wzFsniCR+Vr9pL/61wVA7YzaXJ00VJFqnrGPWLY4To4Sf3/e5kPcJnFB/TsaW1a17lE/pMxlKMHKyITzprgnPeE3mDrplFFXdyQC5pz5HLxEKctbDwyF9OOj/fy1s7RCAlKx4y3d2B0KeRuihMnWdUHo7mE8y3R5icgfOMJtc6rw5UQdc/uabKSAPdo773l3Cqh480r3F2cQ31mpcwOoa3ry1kQEKHNkWb6QejUpRaN6N7O2rK2dJZkZhm7nCS/0lePfZjeY8sqsrVg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=KP5k0OSsJoxqv1YhtRm3nEbrveUJb9u7FSUCwTJfrm4=;
 b=HJjn8aJSYMcaPSUPvLJmomKw3HBGSKvskiX9xN7JNNDUgYVCKjdmwRxnVjDBzaEsPURP2v4QBPC803L+V62ZRfZJmRbB+bMCimuEaxSy/7s9OnQYGT0CXCGx3wfjYuUdn6U52kh7lQP25ZZ8if7mp+HE7SjnkUQYCH9UMyzsGOrggPutI3qCr5zARTSPs6qiVATXr59O7PCqUyD2wEagCs3JaDM9bKIJEGw/wHKxIvVvWGq/AHz+X8NX10/AVEZ3sN31rZ+EA5lgfV2uP7Q4gU6d5hCD9BtI5jpsoIfNt/cXJe6r56tnSt2ZjYUe5/cIKVUEk8JFqa9MQLA85elomA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=KP5k0OSsJoxqv1YhtRm3nEbrveUJb9u7FSUCwTJfrm4=;
 b=aAtkuTktPAwpTVuWZ1/Ls/3UQg+gwXCkNrhbrtlmjhmQNIvPM4rvY4sLmDjEcbGEhwTZsKuVRukjAxR4bKhvKqCQzDeB6GdJKR1Vy9ZvxRtqwFPzOVpG7tiJanKF4ihlF3ln7DyngLbnyAVd6lkMCwwMsnjwIFxoSsnddcZOf4qMtJi+YAeE3V3vEn/hM97QGTMd2vRv0R7yu2r5Zz8x5VAsJRqYnV2jEOIlI65bNAIbmaEnxeGHJYcX2jOLvy0x1NGp3TlIihc1uBgbTf7nIYUg1KsODYQ4LOSiRs9CnXKZnr7Az1yLXoYjR/vPV+CVVtk7a4GB4MlfSwNSZ/nsDg==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from BL0PR12MB2370.namprd12.prod.outlook.com (2603:10b6:207:47::27)
 by CY5PR12MB6528.namprd12.prod.outlook.com (2603:10b6:930:43::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.181.15; Thu, 9 Jul
 2026 08:45:58 +0000
Received: from BL0PR12MB2370.namprd12.prod.outlook.com
 ([fe80::86cf:c3ec:2cf5:74c8]) by BL0PR12MB2370.namprd12.prod.outlook.com
 ([fe80::86cf:c3ec:2cf5:74c8%5]) with mapi id 15.21.0181.014; Thu, 9 Jul 2026
 08:45:57 +0000
Date: Thu, 9 Jul 2026 16:45:51 +0800
From: Richard Cheng <icheng@nvidia.com>
To: Gregory Price <gourry@gourry.net>
Cc: linux-mm@kvack.org, nvdimm@lists.linux.dev, 
	linux-kernel@vger.kernel.org, linux-cxl@vger.kernel.org, driver-core@lists.linux.dev, 
	linux-kselftest@vger.kernel.org, kernel-team@meta.com, david@kernel.org, osalvador@suse.de, 
	gregkh@linuxfoundation.org, rafael@kernel.org, dakr@kernel.org, djbw@kernel.org, 
	vishal.l.verma@intel.com, dave.jiang@intel.com, alison.schofield@intel.com, 
	akpm@linux-foundation.org, ljs@kernel.org, liam@infradead.org, vbabka@kernel.org, 
	rppt@kernel.org, surenb@google.com, mhocko@suse.com, shuah@kernel.org, 
	iweiny@kernel.org, Smita.KoralahalliChannabasappa@amd.com, apopple@nvidia.com
Subject: Re: [PATCH v6 06/10] mm/memory_hotplug: add
 offline_and_remove_memory_ranges()
Message-ID: <ak9ee95F7pJpCKMo@MWDK4CY14F>
References: <20260630211842.2252800-1-gourry@gourry.net>
 <20260630211842.2252800-7-gourry@gourry.net>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260630211842.2252800-7-gourry@gourry.net>
X-ClientProxiedBy: SI2P153CA0018.APCP153.PROD.OUTLOOK.COM (2603:1096:4:140::9)
 To BL0PR12MB2370.namprd12.prod.outlook.com (2603:10b6:207:47::27)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BL0PR12MB2370:EE_|CY5PR12MB6528:EE_
X-MS-Office365-Filtering-Correlation-Id: 06cae3fa-30fd-4811-5bf1-08dedd967e72
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|7416014|376014|23010399003|366016|1800799024|18002099003|22082099003|56012099006|11063799006|5023799004|4143699003;
X-Microsoft-Antispam-Message-Info:
	foqebd9PYE7c9NRrsNCJginSuTSgN00831602Dce5dnflo3Bz1Rl3xDqqHoZFhlgWJ3Nkxn0kzf8WVo9wK6zRjxl1lEPmaYSuS9Haa0Ems7/YyEBFypwJJ7LTw8wuJyJHO58npU8Ak/AeaXU/jwGH16nMi6knyjRljQJcdl+HhdGhM2Y6piRFXA9IzAxo6mF7asLlcTXlEJ0w8iIHOdhGMVPa4Ee71TkCO8xinXoOUQdJ1fxxt7HNH8lwldzpSIz6mUrumixKwyGZeurievimXW8lDT9ZKmKX83IDDO/Cg2bv0nMCJa9PmvDr3J50hwqwozGv/OS4aP1n1aqRIrJKoTGGII7eno15qW5TSFPqDQSt6s234kGrpZxPg//BxD26sP3EQXRnY+gfssmYCqYDYfktGE08A2U/HS8Kdc+lPezTyglzjQGs6Yntl1lqBRpwmzzU0n+sjDfzRZwVF7VBtCb0LS3WBur2bgZiCElUXs2cuybKakqfPX3zyWDVw3t4kmKgJ7RgZ/XSdZWra/c54/RAm0BslqIcY3ZFWYWVesJrlEYxdJ2UrAvy56L532oI0OLAcjvHHy74lSWlikLNTqOYMQLYrG3MeoVqOd1lpTTFeGtv9wAlucZf5rS/QNsDQxBOOCyPI9jbeWKH2VcIttjZQQdMmZtrdRfIXNs0sE=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL0PR12MB2370.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(23010399003)(366016)(1800799024)(18002099003)(22082099003)(56012099006)(11063799006)(5023799004)(4143699003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?gIBUeMRhPKC9BsAvS47tAMb5Nmz4xmyaQn1WnbgElofGtwf2Tu6YKIKNcoFs?=
 =?us-ascii?Q?346j2kWSpFvnh36fdBf34JLg9gcD4GXTfi36pBGwTLCiZx/7lTGeA0VKmSb5?=
 =?us-ascii?Q?v1+YTws2vVZ4VhedNiCKw6ti7eqR7bltvkBYRJZVpnQW/a+2ryx0NskNllm3?=
 =?us-ascii?Q?JeGRq+3l2Yx7A+Qp1BDfHvopsPlF0Z2rqYxsTZgXuJWZVtV9xYktouw0m/6D?=
 =?us-ascii?Q?/u8QE7rubS9B2ZcIgIV8N2605dpROknGkAx3dips+z5tJZDrcGZP+N1qS6mK?=
 =?us-ascii?Q?n1Ds6D2vqP8PHODbmxekijWt1kOC9QUR/8OR9+K2jXecZD9Hxzb2vd1k7rxD?=
 =?us-ascii?Q?m4/pW2fj6zcNUl/XWm+iw45z210hj8qqsCJqgsRd3jDm/1SlDDDb/zQdtNh7?=
 =?us-ascii?Q?MzCssrfqL+n9mA7E91IHt1PGgnB6oAIJTdgKshrul2BQcaP0v7hlLYoy0MNa?=
 =?us-ascii?Q?I0ZdSbhl7k1Mxw7my6rSml8Ko+fTZHD42umuizflf3MmrcGhbl+ofXm7d4dI?=
 =?us-ascii?Q?iDr4pCcIf2j05DzT+lHRJ90JAVzl+8eJXGllKf4NKZ8VHW4dtytUg8DR7q31?=
 =?us-ascii?Q?PC75sf+608L9E2aznZGkgmiN6pkE8VcQ93hjqMXhouoFrVxUuCOtHa/WPi1/?=
 =?us-ascii?Q?FYkVHpbYlYrkt3vFFmNbwB8LNdEnlHgHU141ZSRyDCKd5TIko8tvdsnmULXQ?=
 =?us-ascii?Q?d2zwIBx2go7KA0Y90v1z9Dy/TcbswuHbdJvEEkF8UkJ9vXaRcY4rYA1Uvv5y?=
 =?us-ascii?Q?/8aXMnsiHLH9PrcDrkKP2UhavpRY+1b+3nliWLyPVDnaLzI1acMZE2qfb60k?=
 =?us-ascii?Q?vbB6UR4qAiCVM/TWVkful39TvFI8ACeoCr4+65WsMz/h7s1WC8cB9vVmlx6I?=
 =?us-ascii?Q?HhKxlbK7MAkelaGeCnJaQ3xdTBoxzFNjxYOBlUIb0hcEno++nDdh6ERmHw4Q?=
 =?us-ascii?Q?zVN5s6+psuX1A1NeyMeiHKhB4OQW6CH+e2kadaRReplDeR3/kyhm23q8iKfv?=
 =?us-ascii?Q?sl+dUKmr9VABJ9oLNBkez69S8pqpM955zZ7wGqJhfGS5d1w/3TLgE0uFrnkr?=
 =?us-ascii?Q?tQkCsHJknU2ZcU7+PYVf3IOJo1CirWUpsq0poeQ5Z+Ej3rOJE8K58Nu64ata?=
 =?us-ascii?Q?fZ7YT4lMu0XUZ0+XvgM6oY4iKQNfvYytOJNmLfzmwTwIUVL2mfXBn96vFZ+v?=
 =?us-ascii?Q?3jxdCvUAkCY7AJLvtEnqOo48bpkm3dCqvU+hzl26iP1Ck8kMOycXv6UGdpGT?=
 =?us-ascii?Q?GNns/e++b3RxwyGBGzmwojP2DbzIhw96d07PCb8yndB73aD+4B/e4qBA4b5P?=
 =?us-ascii?Q?AdKM+EGnxcpDaSgyjG85jeCg8T20rqQpZ2rt4bc6fux5260nke8O3NTt0u0F?=
 =?us-ascii?Q?625nisNvXoQK+F5FJWghWGI9azQ3WzGDgfC28CyXYTd7ILTryfWXMB4ojh+K?=
 =?us-ascii?Q?e+VhMFCiQncJeft2/kB6xwzVvkdC8DKEFj+s+TmC9PzOexUBUix3w0eK1TTq?=
 =?us-ascii?Q?QvaVhYzWZJlxmwaEEnJX6B6IRdfV4Y1vQtxsYDeh3hZzvHdR93DPchqrDrxe?=
 =?us-ascii?Q?dKDUv3cOnXUCdqZFmlPdI4wUgQrtZ5iQzS+i3QX/VRqdLLULmM6vo73HlkL9?=
 =?us-ascii?Q?cX7z2hKQRRz3blowuGeZDdrwJ8mwCjHh6xYszDMkGiZZ3VkOLEirlUpkVUTs?=
 =?us-ascii?Q?e+xwVGNPg4stvxe6joqsxQ2GZVWGGyNexbBFV/Vgql9ex+72?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 06cae3fa-30fd-4811-5bf1-08dedd967e72
X-MS-Exchange-CrossTenant-AuthSource: BL0PR12MB2370.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Jul 2026 08:45:57.3153
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 5ff9ULOzWZZoqfZ8u753OtmcrhNX59/j2f4HglgYWUceLeJcjI2EbYpVX+qLBGCzT3QG4QYbTViI1EejWjunZQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY5PR12MB6528

On Tue, Jun 30, 2026 at 05:18:38PM +0800, Gregory Price wrote:
> offline_and_remove_memory() handles a single contiguous range.
> 
> Callers that manage a device composed of several ranges (dax/kmem)
> currently have to call it in a loop, which gives up atomicity.
> 
> In addition to pushing rollback logic into the driver, the lack
> of atomicity creates a race condition between system daemons trying
> to manage the same resource:
> 
>    - Manager 1:  Offlines memory blocks.    Removes device.
>                                         ^^^^
>    - Manager 2:  Detects offline memory blocks, re-onlines them.
> 
> Add offline_and_remove_memory_ranges(), which takes an array of ranges
> and processes them as one operation under a single lock_device_hotplug():
> 
>   - Phase 1 offlines every block of every range.
>   - Phase 2 removes the ranges only if all ranges are offline.
>   - If any offline fails, the whole operation is reverted.
> 
> This gives callers all-or-nothing semantics for the offline step, so a
> failed or interrupted unplug leaves the device in a consistent state.
> 
> This also resolves the battling managers race - the second manager's
> operation simply fails when the block is destroyed / cannot be onlined.
> 
> offline_and_remove_memory() becomes a thin wrapper that passes its single
> range to the new helper, so the offline/rollback logic lives in one place.
> 
> Suggested-by: David Hildenbrand (Arm) <david@kernel.org>
> Signed-off-by: Gregory Price <gourry@gourry.net>
> ---
>  include/linux/memory_hotplug.h |  8 +++
>  mm/memory_hotplug.c            | 93 ++++++++++++++++++++++++----------
>  2 files changed, 73 insertions(+), 28 deletions(-)
> 
> diff --git a/include/linux/memory_hotplug.h b/include/linux/memory_hotplug.h
> index ff3b865ea7e7..db10d50f30ae 100644
> --- a/include/linux/memory_hotplug.h
> +++ b/include/linux/memory_hotplug.h
> @@ -268,6 +268,8 @@ extern int offline_pages(unsigned long start_pfn, unsigned long nr_pages,
>  extern int remove_memory(u64 start, u64 size);
>  extern void __remove_memory(u64 start, u64 size);
>  extern int offline_and_remove_memory(u64 start, u64 size);
> +int offline_and_remove_memory_ranges(const struct range *ranges,
> +		unsigned int nr_ranges);
>  
>  #else
>  static inline void try_offline_node(int nid) {}
> @@ -284,6 +286,12 @@ static inline int remove_memory(u64 start, u64 size)
>  }
>  
>  static inline void __remove_memory(u64 start, u64 size) {}
> +
> +static inline int offline_and_remove_memory_ranges(const struct range *ranges,
> +		unsigned int nr_ranges)
> +{
> +	return -EBUSY;
> +}
>  #endif /* CONFIG_MEMORY_HOTREMOVE */
>  
>  #ifdef CONFIG_MEMORY_HOTPLUG
> diff --git a/mm/memory_hotplug.c b/mm/memory_hotplug.c
> index a66346def504..3225364bec2f 100644
> --- a/mm/memory_hotplug.c
> +++ b/mm/memory_hotplug.c
> @@ -2429,58 +2429,95 @@ static int try_reonline_memory_block(struct memory_block *mem, void *arg)
>   */
>  int offline_and_remove_memory(u64 start, u64 size)
>  {
> -	const unsigned long mb_count = size / memory_block_size_bytes();
> +	struct range range = {
> +		.start = start,
> +		.end = start + size - 1,
> +	};
> +
> +	return offline_and_remove_memory_ranges(&range, 1);
> +}
> +EXPORT_SYMBOL_GPL(offline_and_remove_memory);
> +
> +/**
> + * offline_and_remove_memory_ranges - offline and remove multiple memory ranges
> + * @ranges: array of physical address ranges to offline and remove
> + * @nr_ranges: number of entries in @ranges
> + *
> + * Offline and remove several memory ranges as one operation, serialized
> + * against other hotplug operations by a single lock_device_hotplug().
> + *
> + * This offlines all ranges before removing any of them.  If offlining any
> + * range fails, the entire process is reverted and nothing is removed.
> + * This provides a fully atomic semantic for unplugging an entire device.
> + *
> + * Each range must be memory-block aligned in start and size.
> + *
> + * Return: 0 on success, negative errno otherwise.  On failure no range has
> + * been removed.
> + */

I think this can return 1, and it shouldn't.
device_offline() returns 1 when a block is already offline, and phase 1 passes that value through as-is.

Easy to hit with patch 0, offline one memory block via memoryN/state, then write
"unplugged" to daxX.Y/state. The store returns 1, userspace treats it as a partial write of 1 byte,
and retries the write with the rest of the string.

Maybe
"""
if (rc > 0)
    rc = -EBUSY;
"""

Best regards,
Richard Cheng.


> +int offline_and_remove_memory_ranges(const struct range *ranges,
> +		unsigned int nr_ranges)
> +{
> +	unsigned long mb_count = 0;
>  	uint8_t *online_types, *tmp;
> -	int rc;
> +	unsigned int i;
> +	int rc = 0;
>  
> -	if (!IS_ALIGNED(start, memory_block_size_bytes()) ||
> -	    !IS_ALIGNED(size, memory_block_size_bytes()) || !size)
> +	if (!ranges || !nr_ranges)
>  		return -EINVAL;
>  
> +	for (i = 0; i < nr_ranges; i++) {
> +		const u64 start = ranges[i].start;
> +		const u64 size = range_len(&ranges[i]);
> +
> +		if (!IS_ALIGNED(start, memory_block_size_bytes()) ||
> +		    !IS_ALIGNED(size, memory_block_size_bytes()) || !size)
> +			return -EINVAL;
> +		mb_count += size / memory_block_size_bytes();
> +	}
> +
>  	/*
> -	 * We'll remember the old online type of each memory block, so we can
> -	 * try to revert whatever we did when offlining one memory block fails
> -	 * after offlining some others succeeded.
> +	 * Remember the old online type of every memory block across all ranges,
> +	 * so we can revert if offlining a later block fails.  All entries start
> +	 * as MMOP_OFFLINE so blocks we never touched are skipped on rollback.
>  	 */
>  	online_types = kmalloc_array(mb_count, sizeof(*online_types),
>  				     GFP_KERNEL);
>  	if (!online_types)
>  		return -ENOMEM;
> -	/*
> -	 * Initialize all states to MMOP_OFFLINE, so when we abort processing in
> -	 * try_offline_memory_block(), we'll skip all unprocessed blocks in
> -	 * try_reonline_memory_block().
> -	 */
>  	memset(online_types, MMOP_OFFLINE, mb_count);
>  
>  	lock_device_hotplug();
>  
> +	/* Phase 1: offline every block in every range. */
>  	tmp = online_types;
> -	rc = walk_memory_blocks(start, size, &tmp, try_offline_memory_block);
> -
> -	/*
> -	 * In case we succeeded to offline all memory, remove it.
> -	 * This cannot fail as it cannot get onlined in the meantime.
> -	 */
> -	if (!rc) {
> -		rc = try_remove_memory(start, size);
> +	for (i = 0; i < nr_ranges; i++) {
> +		rc = walk_memory_blocks(ranges[i].start, range_len(&ranges[i]),
> +					&tmp, try_offline_memory_block);
>  		if (rc)
> -			pr_err("%s: Failed to remove memory: %d", __func__, rc);
> +			break;
>  	}
>  
> -	/*
> -	 * Rollback what we did. While memory onlining might theoretically fail
> -	 * (nacked by a notifier), it barely ever happens.
> -	 */
> +	/* If any failure occurred at all, rollback any changes and bail */
>  	if (rc) {
>  		tmp = online_types;
> -		walk_memory_blocks(start, size, &tmp,
> -				   try_reonline_memory_block);
> +		for (i = 0; i < nr_ranges; i++)
> +			walk_memory_blocks(ranges[i].start,
> +					   range_len(&ranges[i]), &tmp,
> +					   try_reonline_memory_block);
> +		goto out_unlock;
>  	}
> +
> +	/* Phase 2: Remove. This should never fail holding the hotplug lock */
> +	for (i = 0; i < nr_ranges; i++)
> +		WARN_ON_ONCE(try_remove_memory(ranges[i].start,
> +					       range_len(&ranges[i])));
> +
> +out_unlock:
>  	unlock_device_hotplug();
>  
>  	kfree(online_types);
>  	return rc;
>  }
> -EXPORT_SYMBOL_GPL(offline_and_remove_memory);
> +EXPORT_SYMBOL_GPL(offline_and_remove_memory_ranges);
>  #endif /* CONFIG_MEMORY_HOTREMOVE */
> -- 
> 2.53.0-Meta
> 
> 
