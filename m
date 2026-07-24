Received: from BN1PR04CU002.outbound.protection.outlook.com (mail-eastus2azon11010038.outbound.protection.outlook.com [52.101.56.38])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0D9113AEB2C
	for <nvdimm@lists.linux.dev>; Fri, 24 Jul 2026 07:45:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.56.38
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784879138; cv=fail; b=J6LyXAQzZmySzqFi6PX9jiwQ9YGLfPwSggUlS/g7RZwfG8Y3+1aveonu3F04WsHrefM9nS7/ZgCASVmFqGX2nNcOJUPEIB7W1K7A18inzNjpQwAsHWwdL5tdyC13si6qo8RZAY7mqBZIalNlhk54kjtZ17gXhibJ8AnIUo9lW3E=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784879138; c=relaxed/simple;
	bh=vKyumQZNmSdfZRyfnazqklE3mQNX6Id9wQ/DrAzhgNc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=VaORqmyauhu9CsDGdxTzc+fSSbrU64mNyIL4kQT8kO0OfyvKWI+IOnDyD/hB7whXKCS2XBSKpR5Arp5tYIcmnYM/WxB8P6PMNYLF0WVktDiVP3JcDiNKeFhCJeSwCVBfWs2XdHxuOkAkScYKMOlVwRbAf2ehFGSlmbztVCMKatg=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=aXIY9lGu; arc=fail smtp.client-ip=52.101.56.38
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="aXIY9lGu"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=XutdjDGUm130qs6CKVXY42VWL3fbWUGsKsHMrNP3bHxFz9ILos5UgcsDq/RRUKj+o6RcoioHMbKxuvfxEPvMcPYn0KA/Rr0h3fmUjQXU5gpLdYK/wk/ueC0MBFZvP8cYv46iNwv/3HGktlfqJjBRzw3fzaRgp+LIsSt/bmCNnay/MCesjK4hJRzJU322SwiyUdwM1t1v85gUqtWR3eNAYIbYcQ1RHYUtKzL8iWZgRtrWY39DkdrAxOTBTN5g+RpbnWx/MgqCVOF03aKxxX8jHFZvS9a5OOkbmsYvDge7f056RbX1xaABf/InjUsw9fE6HIcd3yUn+oXGXPjeVLyJuQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ZEVdmz1AmI4DKBO22cAoG854ZHf/WpIImFha/Jg8Yc8=;
 b=gfztbvum6fxKS6aZYe6CDYsEy2yZBgZUV7IxABGvj5F0INpsjmLgE02BUTqrONEVlp4AxJk81DtNwh8Kf6yoSj6aNffm4Ec4rjNDxRns+4aOZO32jxb5t8EtPLph8OJj6YIbpWmh9sAaFcS3GFvhAekHdTQACNT6wn4M6P5wSrGLsnkAozkzf7Ui3TRa87VGdpKXUpZNma4fQ9AjRkf5RbL7TjLRgIC4hYLNxPPpC4x6V97jGa4T7p0zZbxi5zbo2gD1eSdsRhrcdJ36GGmEpSdiDjUgBYoL/b1KYDsiDk4YsGpRGRVIQ84LfhqT4QXi0sVuM+90fZNo/Y/u/sQoJg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ZEVdmz1AmI4DKBO22cAoG854ZHf/WpIImFha/Jg8Yc8=;
 b=aXIY9lGujEFEpDomTuuZdfcFuad2qoLZQAfc/qGh+Yi35mGO9qjjERDL8bSk6hwdOZ+6X0nu4Boj+Vrcl9H8EmFkEtJP4BoCLjWrv0VsJSSbNL/mTtkzaZ/sVEsEKnisUmOth+WcEoJGbXQkSWBQmfeVnrSiPlGk9GkprW1YAqGlg04yF+uNSvhLI7ymZA+7oBAurRA0Gocp7qSpKRyhFZ052kuABn5YaaTZKqOWw9l2B29SK2Wu3mlDT/BhQUV0hQtTTxMybpQecn2j9iJMzQJG87aU4YaFoTbQC0FL2AEQvDVkikrXAThL40F/sYDmPvPnn8/XLHawgAHoT5GQIw==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from MW2PR12MB2380.namprd12.prod.outlook.com (2603:10b6:907:4::32)
 by SJ1PR12MB6100.namprd12.prod.outlook.com (2603:10b6:a03:45d::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.223.18; Fri, 24 Jul
 2026 07:45:29 +0000
Received: from MW2PR12MB2380.namprd12.prod.outlook.com
 ([fe80::90d:c5c:6a5e:94a5]) by MW2PR12MB2380.namprd12.prod.outlook.com
 ([fe80::90d:c5c:6a5e:94a5%4]) with mapi id 15.21.0245.010; Fri, 24 Jul 2026
 07:45:28 +0000
Date: Fri, 24 Jul 2026 15:45:23 +0800
From: Richard Cheng <icheng@nvidia.com>
To: Gregory Price <gourry@gourry.net>
Cc: linux-cxl@vger.kernel.org, nvdimm@lists.linux.dev, 
	linux-kernel@vger.kernel.org, kernel-team@meta.com, djbw@kernel.org, vishal.l.verma@intel.com, 
	dave.jiang@intel.com, alison.schofield@intel.com
Subject: Re: [RFC PATCH 0/8] dax/kmem: support for private NUMA nodes
Message-ID: <amMUZ-QnxV0SKevW@MWDK4CY14F>
References: <20260722183519.935213-1-gourry@gourry.net>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260722183519.935213-1-gourry@gourry.net>
X-ClientProxiedBy: TP0P295CA0040.TWNP295.PROD.OUTLOOK.COM
 (2603:1096:910:4::13) To MW2PR12MB2380.namprd12.prod.outlook.com
 (2603:10b6:907:4::32)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: MW2PR12MB2380:EE_|SJ1PR12MB6100:EE_
X-MS-Office365-Filtering-Correlation-Id: 99c71815-c9c7-46b9-cc1d-08dee95787ec
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|376014|23010399003|366016|22082099003|18002099003|56012099006|10067099003|11063799006|6133799003;
X-Microsoft-Antispam-Message-Info:
	WlWiEHV/DEY3jOaGkBNBXNGrWUN/jfhQbK+91blAITb5pelzMbixxrvpfuIPEhzPUSHdG8JKFuX8DoehaQGPVDYv1wN7B8xKn9SUw0Irar5K40rGz33hreODU2N4jR6dRmLQWPSi4nH5JJs6PtKy2zHQNXPDPiQ/pB2COHXwBcpo/nEPXVegExUexGfpAsQg8Ac1HIvwni26DwH5Z0a9OgcvDzgdfBLVTubMTyh3OTlRYsbqpKLRwma6g5Ujhuq20lVRe+8D3AJGIIOqrpxi8d1FAdWhv8E0WTr8LHQlENGhRO0+gflTG7Qq4Zll3ZL7TBj+tGcojer7J/gvlfL49NFVZs5vfdI1Fvt2YegpGiUJM6tg/wo4k6w11f3xDjMgaifYaiFYToe+EUyorhpjt0r8WUknGaNDDvGQk1Wljxsg+D+X+CHwH1jwB1mXEVAEJRXUObb8Po3slUea6CAGjZYpLRE7W5wnqFTGCY+7CSMweTKBlsk4RR5EpO8B/qvP48kAK8y5hLHndlI874KSSIPMkxV54/b1lag72MBCrP4zZVfC1rcZ2nZNXMgC7Gw7G5oVOcsColL09jqHxwynz2agmJMDcHMFfOqyqP8ld7lBvk29spB7m2pNLo36oAityv/LwaClX8sqRcnRj70ONWK8cshUFZK3OlYLW0ypWnA=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MW2PR12MB2380.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(23010399003)(366016)(22082099003)(18002099003)(56012099006)(10067099003)(11063799006)(6133799003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?xi8gb3T/viOkGFPk5i2PTD4W75Gmt9MDOSmYNNIQ/Vg/Ljio00u8pURETN9N?=
 =?us-ascii?Q?HoCmk6O6GbwuTDrXwUq17gtUhfhoX0rHVTAoAdKF4H0j81ZhMuTc5CCMZKBx?=
 =?us-ascii?Q?BUYsnxD5c9uaNyDxtY/5mbNmmA45HhzKaN5Jy3i/t/EptU+almqGMoM16CpP?=
 =?us-ascii?Q?lYXPAMBae0oRBRnss2fvYdrLruxIr264WOz3s057Jv17pdVnxSKNqtW3FkgM?=
 =?us-ascii?Q?E6aIr52sJqPFWRaFiyG1C0SfH/MmpNzG2X452yd7EfQBbXHPrcwbxlWz1pFj?=
 =?us-ascii?Q?XP7BDT5qFZ3RPX5A+tH7YAGutOUmKBplyGZ1yxuyELVvu/jte2hDJ7/fBiFr?=
 =?us-ascii?Q?NXoklP/Q3/Kxdf1qj2UGq/V2ot62/O8O2otjcic8kNXkEz1XLkizPWjgJ0y7?=
 =?us-ascii?Q?4D0ikkLaDzmADuqfSQi5B1H/Fwntq4XijI+O2YvTg0EaHp0ghZQdou4Mqv+k?=
 =?us-ascii?Q?Q/Itu2xyKLgOId52hYcki5Nb0flKQfe3AkMYkbwW9HxAHkByDpd/UEgh2BRg?=
 =?us-ascii?Q?mW1MDfnt6J0/khvIMJHq0KBH0aj7RUoaWrE83IgSkEfclM81OO/bpb82WCVf?=
 =?us-ascii?Q?3jBtbMeeYq54Y8tuWxj4yKTqZBMR5gPpBXKA5iImq/QZO46IZ/JQW314FWaG?=
 =?us-ascii?Q?4b96DunLLjihG5Xqlot+sC+Rdpo5uqmYc8SKxmK1XEmxUgeTTH+ru0zWX5px?=
 =?us-ascii?Q?H7fDtyfkT54olVmqVVqppYtHZd6VtImnIFDyYTYkyRHLUG5CZ+ps0ia7Cqxa?=
 =?us-ascii?Q?8NG02LDnZGu8El3OgtB54iJuE+nKeJAOdVsIYI3NSh3nOnHtl+6gS6C68Q6z?=
 =?us-ascii?Q?IGrVXI1s0mnKn574UIFEI+WltPKfazNjOEWr0iG7Hnsf/g8JE4Spcx2W5JBF?=
 =?us-ascii?Q?8kNqKxA135RtR7a4Fpfc4tfGAEZT+UAWa1/l6KOfFTSJOkjCZ/i3TFrM5y0a?=
 =?us-ascii?Q?jlh7mXm+3FYOSfNcU4EBO/bfPb9404FyeLyF5pgw1q2YG02TCMcBAjNdtSXe?=
 =?us-ascii?Q?dWPC5nvG5JmLgrccgIEMa437QTBNiS0xz4iwU0DzziglaknPJuH5ZNzXY99q?=
 =?us-ascii?Q?LOSf4YDxCN1vhm/TvZ2hxMmKPcT8ePUVcp/yjmiTFqm469v5sngQb44ussvh?=
 =?us-ascii?Q?+jYgMlmrIIlk3CFAm//gb1Cw/s5QORjK9dsPp2Pagsi0/Xr4FlXdd2UIEUX0?=
 =?us-ascii?Q?k1swGjXOwac7o7iypKjJfe/zxuVM8LTGGuSVE51pH1zDYBrt6OZi9Kno8j/D?=
 =?us-ascii?Q?en3vSmpwwU/PW9cF/42qQOj1ExeoSu2cAGQ56Gsen+oHBUztZQav9i9jUYNF?=
 =?us-ascii?Q?MIeJzdMYPQX0RJtWQFNFypAvijxxKEUKJvnJYiCUaqX3dQYdDlSJwOdlX3dg?=
 =?us-ascii?Q?ubA/CQ879qbiSoeUpqT/Oz5nIjmeORq51Oi5IdrNabJ3ujX+Xah8K3rdQEKB?=
 =?us-ascii?Q?TVONTdlwrdAQN//NVGAwEJakByoCDC7MtJMNcLdHSbSG/icPqwyO9T+Ezxvy?=
 =?us-ascii?Q?/lAbTWakEnEODJiYP5/bb7DT/ISsGhUTfz7SakRUgkJGa7igFvku3YCV8g47?=
 =?us-ascii?Q?sXcY+YLrNPCkMEObe+0Aj/yJwwIwFxHqk7+Bs5SYRSItUd93GPBX1Ibe9fps?=
 =?us-ascii?Q?wQZa11c+D5of7zEg7uin0GyJn234OB1/XcFvLIQvW0VqQxEK9wc7+CKb9sJb?=
 =?us-ascii?Q?93phcXcl+ftM6wgkpvnCQDfN2nlglvtUVZy20tJFQzEwd2+s?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 99c71815-c9c7-46b9-cc1d-08dee95787ec
X-MS-Exchange-CrossTenant-AuthSource: MW2PR12MB2380.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Jul 2026 07:45:28.6988
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: /2Y9B2u1Dh6HJhpSuyiGY4/FGOmpEsZ8vFbs/eGkaTOt/NpBBsroU3lfUH6d0RcA3sXCiEC3IUge96xiyEreDA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ1PR12MB6100

On Wed, Jul 22, 2026 at 02:35:11PM +0800, Gregory Price wrote:
> This series adds uapi bits for private memory NUMA node [0] control.
> 
> It is not intended for merge - just discussion.
> 
> I have been using this to extensively test mm/ behaviors with private
> nodes [1] and am wondering whether some of this is more generally
> useful for coherent memory devices if private nodes lands.
> 
> For now, this is useful for testing, but locks in UAPI, so this RFC
> is not intended as an intent to upstream - just sharing my testing api.
>   
>   Question 1: Do we want dax control of private node settings?
>               1a) External? (uapi like this?)
> 	      1b) Internal-only? (plumbed through module apis)
> 
>   Question 2: If we do want this, do we want it in kmem or a
>               separate dax driver? (dax/private_mem ?)
> 
>   Question 3: are dax_file and adistance useful regardless?
> 
> This adds 9 interfaces:
> 
>   dax0.0/dax_file
>      this makes /dev/dax0.0 mmap-able when online as kmem
>      it essentially attaches a default mempolicy to the vma
>      that binds it to the dax device's node.
> 
>   dax0.0/private
>      this switches whether hotplug sets N_MEMORY or N_MEMORY_PRIVATE
> 
>   dax0.0/adistance
>      this allows overriding the default adistance to for the node
>      into a specific tier.  That allows for testing tiering in both
>      directions (demotion from/to the node)
> 
>   dax0.0/reclaim
>   dax0.0/user_numa
>   dax0.0/hotunplug
>   dax0.0/demotion
>   dax0.0/numa_balancing
>   dax0.0/ltpin
>      these bits all enable their respective NODE_PRIVATE_CAP_ bit
> 
>      reclaim   - enables reclaim on the node
>      user_numa - enables mbind/mempolicy/move_pages/migrate_pages
>      hotunplug - enables hotunplug to migrate memory
>      demotion  - enables reclaim to demote from or to the node
>      numa_balancing - allows prot_none injection on the node's folios
>      ltpin     - allows longterm pin on node's folios to work
>

Hi Gregory,

I have some thoughts especially for ownership and configs.

I think it would be good to expose dax control of private node, just with
the following guarantees.

Let's make it clear that userspace should never become the owner
of private node, they should be driver-owned and 1-to-1 mapping relationship.

A userspace tool can request to reconfigure some capability of the DAX device, and
maybe how the driver expose it.

A dax range may have several deployment rules, e.g. devdax, system-ram or private, with
the patch series' tool, it looks like a userspace tool can convert a DAX device between
dax and system-ram mode, I think that's unsafe especially when the region is online as
system-ram.

And it will cause coherence issue to be resolved, if no special or strong use cases, I would
prevent having such ability to convert the rules in runtime, especially for fixed-purpose device.

For capability bitmap part, I think it's reasonable to expose it, but with 2 concepts
- supported_caps : immutable, supplied by the provider/vendor
- enabled-caps : selected policy, subset of supported_caps

The invariant should always hold
"""
enabled_caps & ~supported_caps == 0
"""

This way we can prevent userspace from touching things that they shouldn't.

Maybe a demo with a driver would be nice ?

This is my initial thoughts of this, thanks.

Best regards,
Richard Cheng.

> [0] private node series
> https://lore.kernel.org/linux-mm/20260720193431.3841992-1-gourry@gourry.net/
> 
> [1] selftests/dax extensions for all of this that show use cases and
>     testing for the private node series - including all user api's
>     like mbind, set_mempolicy, move_pages, migrate_privates - as well
>     as reclaim behaviors.
> https://github.com/gourryinverse/linux/commits/scratch/gourry/managed_nodes/dax_private-mm-new/
> 
> Gregory Price (8):
>   dax/kmem: add dax_file= to expose an anonymous-fault char device
>   dax/kmem: add private= to online memory as an N_MEMORY_PRIVATE node
>   dax/kmem: add the reclaim opt-in (CAP_RECLAIM) for private nodes
>   dax/kmem: add the user_numa opt-in (CAP_USER_NUMA) for private nodes
>   dax/kmem: add the hotunplug opt-in (CAP_HOTUNPLUG) for private nodes
>   dax/kmem: add the demotion and numa_balancing opt-ins for private
>     nodes
>   dax/kmem: add the ltpin opt-in (CAP_LTPIN) for private nodes
>   dax/kmem: add dax/adistance to make private node adistance
>     configurable
> 
>  drivers/dax/kmem.c | 368 ++++++++++++++++++++++++++++++++++++++++++++-
>  1 file changed, 366 insertions(+), 2 deletions(-)
> 
> -- 
> 2.53.0-Meta
> 
> 
