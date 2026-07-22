Received: from CH5PR02CU005.outbound.protection.outlook.com (mail-northcentralusazon11012070.outbound.protection.outlook.com [40.107.200.70])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8C01935DA4A;
	Wed, 22 Jul 2026 14:20:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.200.70
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784730025; cv=fail; b=p4EXViAH4W8zMkUaetn6nGIDL8HrWVWa6pq2tMUL0mZt/TBHAJUFCbXvWT4S8NzMeJu4b9lZ1B8mKvxO9+xWjGQQENqvpgzctD2BTlW8LyClDxh4exKv6wmPHwF1M7bdqyjb0mGJAD4KVi3rQncRrz+QCsU6B6mxgPQQOG5fu5A=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784730025; c=relaxed/simple;
	bh=6QXE3DJvGzXc1hR3EPcIzoEREE4YtVhlFYyWyC8DEEU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=CfxBAOIzC2T/cU+9aEGeuiF5WLbQL2JyZFRgs7cjxHULKypR5lqC+8kqU3neUVr0U3SnJioAXK4zUI4BMpnnWDQnMxFH8nm7xo+K31Sp1pc40uFBRB4i1TnnM12vGNVA3I4wZ9v6hDgZWC2RkHif58U68odKueDJwTr4GEaQg88=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=CpVbSzUa; arc=fail smtp.client-ip=40.107.200.70
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="CpVbSzUa"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=pNfmuW2eAoIsltnR4veJxFXblBJpjPGUKxx1WGaI/sFq8dra+WE2xLg+W80ZkNRuISEmBaq7DR5SrF4/jQXSicMRWV3E7Fjv7NYksgOF65EMHK7PJKPb08C/fhHls6YOROxjz2kfQTCfRB51A644XuUIHUNeVKAMv3vACdPAZG78D1VVPyhik1u5KYTQNW/IviUEySTw/IKMOSpR27cwHWh/ERCRTj9RoPEv1AyJ+Pw2BeOnAkuIp8GwPN3hlBg9nfWcQlgTqBxsX8zMin2zrkPEHDFjkBtoL4jDxws2wPm6AglSbFig69l0Hi+rnxZspANqG0EX3cUWX++DpLatEA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=3+mwfM0JkUtayNZtIUItQsHwOBKUqbwwElK/9X8/ncU=;
 b=hHLSB9it1955FwsSnpuqlaWXeiEQaWu7ZYmBCzU5F7fob1M5Z3MnNJzPb717PsvDVtvpW0+LLgHFBidjzdSCZZK002e1lFaCDOBclW6lWKr0YZdBxGww/c5M6FayFTqkmxgSPFtmbz/oI011eUEuzKS0wvTGDM0qqAxzmnwfhtqZTunTOJAkUIKVgg3MgyuZ0O0JsbDRsazNY1yV40UpV8cMokHaFMtOfLhgru8oRSxXrhROaapOB77R9vA1GJ2/N/8l20XZpOFiBCBooXasPcfZPykxA6Any1x3TbRHkZLbrtO5BuoCEw9c4WH3BbIi38Ud1SZA2q9RdtEr/JOJdw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=3+mwfM0JkUtayNZtIUItQsHwOBKUqbwwElK/9X8/ncU=;
 b=CpVbSzUaL4fvxP9XTWDldJUz8W4IiW0Ol4i3AlPydnxCiP65Zyfo7KJnMe7vJ9pXR6rXINv70HS3pXWlzORQCsggeNQXz3n2xdlxoCFtI5AN8olIah5GzEGXdWSNVYkvO29aaihBc0U62XdjCNslmKmFG45mJF2pCXaMfz94tSpAWz2kumDQ9gSosjSo1cPvLvb+ymXEQXUk7YXMQHFHiHuX1iHRIO7tLmSxdnEh4t31EuADfbTbQp6MSlPjRYzxO6uCVpjVarPQcP2gdpzVTfSewaXco9OeDrRuXlVAcycsemi04fvMh0WkPwWodppeDfRfDnZtTkhM3yJ4IFI39g==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from BL0PR12MB2370.namprd12.prod.outlook.com (2603:10b6:207:47::27)
 by SA1PR12MB8120.namprd12.prod.outlook.com (2603:10b6:806:331::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.245.10; Wed, 22 Jul
 2026 14:20:07 +0000
Received: from BL0PR12MB2370.namprd12.prod.outlook.com
 ([fe80::86cf:c3ec:2cf5:74c8]) by BL0PR12MB2370.namprd12.prod.outlook.com
 ([fe80::86cf:c3ec:2cf5:74c8%5]) with mapi id 15.21.0245.009; Wed, 22 Jul 2026
 14:20:06 +0000
Date: Wed, 22 Jul 2026 22:20:00 +0800
From: Richard Cheng <icheng@nvidia.com>
To: Gregory Price <gourry@gourry.net>
Cc: linux-mm@kvack.org, Zhigang.Luo@amd.com, arun.george@samsung.com, 
	balbirs@nvidia.com, brendan.jackman@linux.dev, yuzenghui@huawei.com, 
	apopple@nvidia.com, alucerop@amd.com, matthew.brost@intel.com, 
	akpm@linux-foundation.org, david@kernel.org, ljs@kernel.org, liam@infradead.org, 
	vbabka@kernel.org, rppt@kernel.org, surenb@google.com, mhocko@suse.com, 
	corbet@lwn.net, skhan@linuxfoundation.org, gregkh@linuxfoundation.org, 
	rafael@kernel.org, dakr@kernel.org, djbw@kernel.org, vishal.l.verma@intel.com, 
	dave.jiang@intel.com, alison.schofield@intel.com, osandov@osandov.com, 
	jannh@google.com, pfalcato@suse.de, jackmanb@google.com, hannes@cmpxchg.org, 
	ziy@nvidia.com, pbonzini@redhat.com, osalvador@suse.de, joshua.hahnjy@gmail.com, 
	rakie.kim@sk.com, byungchul@sk.com, ying.huang@linux.alibaba.com, 
	kasong@tencent.com, qi.zheng@linux.dev, shakeel.butt@linux.dev, baohua@kernel.org, 
	axelrasmussen@google.com, yuanchu@google.com, weixugc@google.com, yury.norov@gmail.com, 
	linux@rasmusvillemoes.dk, longman@redhat.com, ridong.chen@linux.dev, tj@kernel.org, 
	mkoutny@suse.com, sj@kernel.org, jgg@ziepe.ca, jhubbard@nvidia.com, 
	peterx@redhat.com, baolin.wang@linux.alibaba.com, npache@redhat.com, 
	ryan.roberts@arm.com, dev.jain@arm.com, lance.yang@linux.dev, usama.arif@linux.dev, 
	xu.xin16@zte.com.cn, chengming.zhou@linux.dev, roman.gushchin@linux.dev, 
	muchun.song@linux.dev, linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org, 
	driver-core@lists.linux.dev, nvdimm@lists.linux.dev, linux-cxl@vger.kernel.org, 
	linux-debuggers@vger.kernel.org, linux-fsdevel@vger.kernel.org, kvm@vger.kernel.org, 
	cgroups@vger.kernel.org, damon@lists.linux.dev, linux-kselftest@vger.kernel.org, 
	kernel-team@meta.com
Subject: Re: [PATCH v5 00/36] Private Memory NUMA Nodes
Message-ID: <amDL80BSEP6u9XfE@MWDK4CY14F>
References: <20260720193431.3841992-1-gourry@gourry.net>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260720193431.3841992-1-gourry@gourry.net>
X-ClientProxiedBy: TPYP295CA0014.TWNP295.PROD.OUTLOOK.COM
 (2603:1096:7d0:9::20) To BL0PR12MB2370.namprd12.prod.outlook.com
 (2603:10b6:207:47::27)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BL0PR12MB2370:EE_|SA1PR12MB8120:EE_
X-MS-Office365-Filtering-Correlation-Id: c7a05fd3-e32d-4437-60e3-08dee7fc5461
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|23010399003|376014|7416014|366016|1800799024|6133799003|56012099006|10067099003|5023799004|11063799006|22082099003|18002099003|3023799007;
X-Microsoft-Antispam-Message-Info:
	vEKa51a8YdCF4a9sIrUF9e1WGBQxuP8CfdEbh+Umefoo9UrINduYpSdu64nfszWHfTy6YJ+X9tOJqfNorN+46eKSntAdoh5R4snqTbliuvo3FUaOBJ3IJqxsHnDbh8pqh2xSNyoA5/LXzKEo1x6vd15q/zmzsDxt9NRt2Ntk50O6YVrZBPAQy6n9uNHrnKy2G4nTAivdjLHZ4ErhXUDARTX5PmmzEkP92ud6gdW3nn5WF2XbUTYfzCEIKbLPTQwUVpmOYIX7qsMqIGwe8oMfwB8QkcA4ADSrm1HHFrV4yzk6iEe1F082gAEEdwIuVhj0jYOIJQoCfG7EljkDawhtRn3ae16MnmkNSMnmH117pA6nMy1dO9fVqqgZmYkviq+t3vRiGeej6eeG7Kp2MtN7nCNxUyulj1UbV2iyHwLx7VK8GNmy19eQz63CYp4RZpi4mGEK04iGEUhz9E41zK2n/+9cq1Uluj8ChDSRerBKfqPBd5KD/zHcWuLV8XGpVS5VqFQkUSCECMvitgGFRD7U9MV0rMOMRZh5gxgj7NUuFIoSyBzn4mujM1oXGbY51I7jvTnRK+xHBplVk86Enso9VDTpAqf0tR3xBpMF8Ep4KfrNC2ALSWAiwY/mPSBxnF66vJixPh0PrskGHKjiQl9DpVniIDZ0U55wKYL6TRrCeI4=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL0PR12MB2370.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(23010399003)(376014)(7416014)(366016)(1800799024)(6133799003)(56012099006)(10067099003)(5023799004)(11063799006)(22082099003)(18002099003)(3023799007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?eCrCTfKFT+X3Ewb05U/M4cs6GTsDwho5A+k/HG6/jO+4l4Lw6bSV4qFm8Gyu?=
 =?us-ascii?Q?qJ1YtW5RrecYwHUhqp/FaZB0zoNRK7qy2biG0i4SD6rw7QX2wCYsV3nJr/xi?=
 =?us-ascii?Q?JFjdb5tQzg7l8UyMAlB7VzeUfvwNK9guAQEr4kXG7mELOphYb/OlE/LmdeW5?=
 =?us-ascii?Q?LhbuTW28EUMTnfHLrXhbmoZiU/aCxHy2az57xrY3bKgUeoqMYVmXPC2kS0Sn?=
 =?us-ascii?Q?4tjrp5anAMC6dE/ucPSyuifxrLPyC0RtlWe1SrooXBDR/ak8+96KuPf3fFbS?=
 =?us-ascii?Q?s4bmnhEfHfOoTOwqAY//Dmpp40RF9d2oeT/Oo4K6sjjQZx5a+HDM3Ct53q1e?=
 =?us-ascii?Q?DDfMBYVFwMpXEkdSt22oLCkrJjuovp6uyMvkfjT84FHU4t8f9+8BBbyQqnVG?=
 =?us-ascii?Q?cDNJJE3j+TkVGbyU/TxcGYJElIWQTXxI9PU6GKaWu+/46THscToFIWauSEZu?=
 =?us-ascii?Q?+5tB8H2eG+e/GnJt4NFZql35RQbt0IdQOZqPq0b8YOt79e/YkYQIreN8jJTj?=
 =?us-ascii?Q?KQxMNo2dh1sYFuGxlLXPlHvwz4HRkOVbi91nWpe1mGvASaLR9LCP9iT7Y0QC?=
 =?us-ascii?Q?jwA2We79EJJ5YtedgNaj3+NDUa+yudkuSt+1eJ0J+ZTDXkVWiqM/s9gMV2tf?=
 =?us-ascii?Q?xGiKYDk2zQKO17wCjm93CaB5BpMneeOJQmzlcv7tdatrNOxO0wo93p1Wkfrt?=
 =?us-ascii?Q?emlFUvxP/1rXgv4KoLUsFRfdGVrTg5oL1Ub+oOjk/YkKe/r7368RF5XtyIyW?=
 =?us-ascii?Q?22APuuCQ6dbBFWUJ+F9s2aT1tKmM/Zs/1HH9WOX+wMJtqQRmo0hXRpFWMRfB?=
 =?us-ascii?Q?Bae8zTaYcrDkHjHPC7syFANYykGr1PP9d8ISicbkJ1la90Vrq4LvvsmUilhA?=
 =?us-ascii?Q?MiyJavBDxF+nmEDoiX+BmgrLT9VHnbhfozFj8dGhVINSf4f2uy0blDF4OhAK?=
 =?us-ascii?Q?e/7llBpg/9b4OrCFYckxrNVDa8XjDG1ckEyssPt8ImO0AUjVLDPkBG8yNOxa?=
 =?us-ascii?Q?sMh1rkdd9CMJ+QP3VxiHiDj/SWZYLbrO3ftE9bYsrGIvcK0wP4qg3IAH7465?=
 =?us-ascii?Q?u8oVG+64TfyYyi5YDbtHraiOiegcgo44YpyG+ldCpQBu8HzUH8hayMe4t+Lt?=
 =?us-ascii?Q?AvLqt87Rm6USmsCu29YRx+5XMFCm5rn7JDh1o/j+KvSBMliAJRhSOYBFbf7F?=
 =?us-ascii?Q?Llobu4+FJiNajkQcLYgqjMkMTuJmPp4HTaBbSZYAEvqyhe7uEB3PkoKgaoNh?=
 =?us-ascii?Q?pW5rKzpI1WtewL5hjprTRr+dH3SkcUdIomgQRuM3zm8BzgaLu0Et1vOMs2tN?=
 =?us-ascii?Q?sU6kzxn2oav/lB5cYU7MdqR1L+ZFVavbXx4Nhtlocg61lVge5yFcxrYVrcS2?=
 =?us-ascii?Q?dD2FpRVxIT+hxc8hzb7/zhK0tHe4bdSmRRygVKEe4Q8QSR6KI8K5xJ7oKj3v?=
 =?us-ascii?Q?0bLAGNbpRu3DjKlpLvqO2s0yNw5Ix/VF0KenvU1RwkpD1fen2CyHyf+SLzhi?=
 =?us-ascii?Q?Nlua1XfVsp70KA8HeQPP0NpvKkUon1BuNUfpwE0CjC4PfV6i2UMo4/8NNGxo?=
 =?us-ascii?Q?ceM6WmxCwd+54mXc1wWtN0BPkA6dRg5FDjMbJJ0V/PzpPk9zHvALwKIME227?=
 =?us-ascii?Q?SaZloz2mBO3DsbqjC6rb+t0+ZO/KfAhfsh7i9hEH8WbLAPSTPZUqNnhMILrg?=
 =?us-ascii?Q?Wv6uectawZmQwHG0XiGQq9/Ys/RFmlYNEy4zcpd9h54F8Kfqx5gd+E2p1Wx4?=
 =?us-ascii?Q?4mWxi8Mcag=3D=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c7a05fd3-e32d-4437-60e3-08dee7fc5461
X-MS-Exchange-CrossTenant-AuthSource: BL0PR12MB2370.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Jul 2026 14:20:06.8758
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 6PS98IZLosCUQe4Z2nWlKZRSPow8+DP+D2/0byFb3yCtdxWYO+FSnMl4Np03x8JYf37b5WFXMSawdHMnnaGOHQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR12MB8120

On Mon, Jul 20, 2026 at 03:33:54PM +0800, Gregory Price wrote:
> This series introduces the concept of "Private Memory Nodes", which
> are opted into two basic functionalities by default:
>   - page allocation (mm/page_alloc.c)
>   - OOM killing
> 
> All other features of mm/ are opted out of managing these NUMA
> nodes and its memory.  Then we add capability bits to allow node
> owners to opt back into those services (if supported).
> 
> NUMA-hosted memory is presently a most-privilege system (any memory on
> any node, except ZONE_DEVICE, is 100% fungible and accessible). We
> then slap restrictions on top of it (cpuset, mempolicy, ZONE type,
> page/folio flags, etc).
>

Hi Gregory,

I applied your series on mm-next and give a quick review,
not thoroughly, still I have some questions below regarding the design.
 
> The goal here is to flip that dynamic, isolate by default and then
> opt-in to specific services that the device says is safe.
> 
> Isolation at the NUMA/Zonelist layer provides a powerful mechanism for
> memory hosted on accelerators - re-use of the kernel mm/ code.
> 
>  - Accelerators (GPUs) can use demotion, numactl, and reclaim.
>  - Special memory devices (Compressed RAM) with special access controls
>    (promote-on-write) can have generic services written for them.
>  - Network devices with large memory regions intended for ring buffers
>    can use the buddy and standard networking stack.
>  - Slow, disaggregated memory pools which aren't suitable as general
>    purpose memory get cleaner interfaces (no need to re-write the buddy
>    in userland, can use migration interface, etc).
>  - Per-workload dedicated memory nodes (disaggregated VM memory)
> 

For accelerator part, take CXL Type-2 as example, it has its own protocol
CXL.cache, CXL.mem which is the rule they need to obey during memory transaction,
Adding more rules for them since they are NUMA node confused me, I wonder the reason ?

Because NUMA node, at least for me, representing topology/locality rather than
something with ownership or capability or rules.


> And more use cases I have collected over the past few years.
> 
> Not included here is a dax-extension [1] that exposes all the internal
> bits as userland controls for testing - along with a pile of selftests
> that prove correctness.
> 
> Changes Since V4
> ================
>  - Massive reduction in complexity.
>      - no ops struct
>      - no callback functions
>      - no __GFP_PRIVATE
>      - no __GFP_THISNODE requirement
>      - no task flags (no PF_MEMALLOC_* in the alloc path)
>  - isolation via a dedicated zonelist:
>      - private nodes are omitted from FALLBACK/NOFALLBACK
>      - added ZONELIST_PRIVATE(_NOFALLBACK)

I saw the reply in patch 5, so in fact there's not only one
dedicate zonelist, but numerous ?
I raise the question because zonelist was supposed to be a
global, unbypasssable thing in MM design, but now what you
are trying to do is to seperate the whole global list into several
parts ?

Can you explain why in current design you don't consider to support
something like ZONELIST_PRIVATE[n]={0, .. ,n-1} ? that's my imagination
of what a global zonelist should look like, no matter private or non.


>  - ALLOC_ZONELIST_PRIVATE alloc_flag
>      - on top of Brendan Jackman's recent mm/page_alloc.h work [3]
>      - Zonelist selection rides the allocator's alloc_flags
>  - rename OPS -> CAPS (capabilities)
>  - split base functionality (isolation) from opt-ins (CAPS)
>      - first half of series can be merged without CAPS
>  - dropped compressed ram example from series
>      - will submit separately if this moves forward
>  - Added KVM as first primary in-tree user (mempolicy / CAP_USER_NUMA)
>  - fully functional dax-kmem extension and huge suite of selftests
>    located at my github, to be discussed separately [1]
> 
> Patch Layout
> ============
> The series is broken into two sections:
> 
> 1) N_MEMORY_PRIVATE Introduction.
>    Introduce the node state.
>    Opt those nodes out of mm/ services.
> 
> 2) NODE_PRIVATE_CAP_* features
>    A set of mm/ service opt-in flags that augment private
>    nodes to make them more useful (i.e. reclaim = overcommit).
> 
>    NODE_PRIVATE_CAP_LTPIN for private node folio pinning
>    NODE_PRIVATE_CAP_NUMA_BALANCING for private-node NUMA balancing
>    NODE_PRIVATE_CAP_DEMOTION for private-node tiering demotion
>    NODE_PRIVATE_CAP_HOTUNPLUG for opted-in private nodes
>    NODE_PRIVATE_CAP_USER_NUMA for userland numa controls
>    NODE_PRIVATE_CAP_RECLAIM for opted-in private node reclaim
> 
> My hope is to merge at least #1 pulled ahead while #2 is debated.
> 
> Allocation Isolation
> ====================
> page_alloc presently controls whether a node's memory can be allocated
> on a given call by 4 things (in order of authority)
> 
>   1) ZONELIST membership
>      If a node is not in the walked zonelist, it's unreachable.
>

So a device gets hotplugged in the system will get a dedicated zonelist here ?
And make sure it obeys the device's own protocol if it has one ?

>   2) __GFP_THISNODE
>      If this flag is set and the only node in the ZONELIST is the
>      singular preferred node (or the local node, for -1)
> 
>   3) cpuset.mems membership
>      cpuset trims any node in its allowed list
> 

Sounds sane to me.

>   4) mempolicy nodemask
>      the allocator will skip any node not in the nodemask.
> 
> Except for #1 (Zonelist membership) there are all kinds of weird corner
> conditions in which 2-4 can be completely ignored (interrupt context,
> empty set because cpuset doesn't intersect mempolicy, shared vma, ...)
> 
> But ZONELIST membership is *absolute*.  If a zone is not in the
> zonelist being walked, IT CANNOT BE ALLOCATED FROM. PERIOD.
> 
> The existing zonelists are constructed like so:
>   ZONELIST_FALLBACK    : All N_MEMORY nodes
>   ZONELIST_NOFALLBACK  : A singleton N_MEMORY node
> 
> Private node isolation is implemented via ZONELIST isolation:
>   ZONELIST_PRIVATE            : The private node + N_MEMORY
>   ZONELIST_PRIVATE_NOFALLBACK : The private node alone.
> 
> (mirrors exactly the fallback/nofallback for __GFP_THISNODE)
> 
> Private nodes:
>   1) Never appear in any ZONELIST_FALLBACK
>   2) Have an empty ZONELIST_NOFALLBACK
>   3) Only appear in their own ZONELIST_PRIVATE(_NOFALLBACK)
> 
> 1 & 2 mean all existing in-tree callers to page_alloc can NEVER
> accidentally allocate from a private node.
> 
> An allocation must explicitly ask via a zonelist and a nodemask.
> 
>   alloc_flags |= ALLOC_ZONELIST_PRIVATE; /* use ZONELIST_PRIVATE */
>   __alloc_pages(..., nodemask);     /* with the private node set */
> 

As I stated above, NUMA concept was quite naive at first glance for my
limited knowledge.

This is quite alot to add for NUMA node concept, I'll want to see
more explanation in v6 and learn from it, thanks.

> The page allocator keeps all its original interfaces which only
> ever touch the default zonelists - avoiding churn.
> 
> Making it accessible via Mempolicy: MPOL_F_PRIVATE and page_alloc
> =================================================================
> The vast majority of the kernel will never need to know about
> ZONELIST_PRIVATE, because we add MPOL_F_PRIVATE to mempolicy.
> 
> When a mempolicy has MPOL_F_PRIVATE, the alloc_mpol() interfaces
> do the zonelist selection for the source of the allocation.
> 
> That really is the whole explanation of the mechanism:
> 
>   alloc_flags = mpol_alloc_flags(pol);
>   page = __alloc_frozen_pages_noprof(..., alloc_flags);
> 
> On mm-new this rides the allocator's existing alloc_flags plumbing:
> ALLOC_ZONELIST_PRIVATE is just another alloc_flag, so no new
> parameter, enum, or alloc_context change is required.
> 
> For modules that want to implement their own special handling, they
> get the _private variants for the page allocator.  This lets modules
> re-use the buddy instead of rewriting it.
> 
>    - alloc_pages_node_private_noprof()
>    - folio_alloc_node_private_noprof()
> 
> This keeps ALLOC_ flags mm/ internal (these functions add the flags).
> 
> Isolating private node folios from kernel services
> ==================================================
> We implement filter points in mm/ to prevent operations on
> private node memory.  Where possible, we even re-use existing
> filter points from ZONE_DEVICE.
> 
> Most filter points are one or two lines of code:
> 
> Combining ZONE_DEVICE and N_MEMORY_PRIVATE opt-out spots:
>   -     if (folio_is_zone_device(folio))
>   +     if (unlikely(folio_is_private_managed(folio)))
> 
> Disabling a service:
>   +  if (!node_is_private(nid)) {
>   +      kswapd_run(nid);
>   +      kcompactd_run(nid);
>   +  }
> 
> Disallowing a uapi interaction:
>   +  if (node_state(nid, N_MEMORY_PRIVATE))
>   +      return -EINVAL;
> 

I'm not sure of why do we re-implement more filter and basically
doing the same thing ? Any unavoidable scenario ?

re-using the exisintg filter would be nice if that's possible.

> In the second half of the series, we replace blanket N_MEMORY_PRIVATE
> filters with NODE_PRIVATE_CAP_* filters to opt those nodes into that
> interaction if CAP is set.
> 
> We abstract this with a nice clean interface to make it really clear
> what is happening (nodes have features!)
> 
>   -  if (node_state(pgdat->node_id, N_MEMORY_PRIVATE))
>   +  if (!node_allows_reclaim(pgdat->node_id))
> 
> NODE_PRIVATE_CAP_* features
> ===========================
> This series of commits opts private nodes into various mm/ services.
> 
> Capabilities:
>   NODE_PRIVATE_CAP_RECLAIM       - direct and kswapd reclaim
>   NODE_PRIVATE_CAP_USER_NUMA     - userland numa controls
>   NODE_PRIVATE_CAP_DEMOTION      - node is a demotion target
>   NODE_PRIVATE_CAP_HOTUNPLUG     - hotunplug may migrate
>   NODE_PRIVATE_CAP_NUMA_BALANCING - NUMAB may target node folios
>   NODE_PRIVATE_CAP_LTPIN         - Longterm pin operates normally
> 
> Some opt-in support is more intensive than others, so these features
> are broken out in a way that we can defer them as future work streams.
> 
> NODE_PRIVATE_CAP_RECLAIM:
>   Enabling reclaim for these nodes is actually surprisingly trivial.
> 
>   Without CAP_RECLAIM, when an allocation failure occurs, the system
>   will not attempt to swap the memory - and instead will OOM (typically
>   whatever task is using the most memory on *that* private node).
> 
>   This capability consists of:
>     1) enabling kswapd and kcompactd for that node at hotplug time.
>     2) formalizing opt-out hooks to node_allows_reclaim() opt-in hooks.
>     3) Sets normal watermarks for these nodes.
>     4) Allow madvise operations on that node (PAGEOUT).
>     5) A small tweak to how LRU decides which zones to visit.
> 
> NODE_PRIVATE_CAP_USER_NUMA
>   Enables the following userland interfaces to accept the node:
>     mbind()
>     set_mempolicy()
>     set_mempolicy_home_node()
>     move_pages()
>     migrate_pages()
> 
>   example:
>      buf = mmap(..., MAP_ANON);
>      mbind(buf, ..., {private_node});
>      buf[0] = 0xDEADBEEF; /* Page faults onto the private node */
> 
>   Later - the KVM example shows how in-kernel mempolicies can
>   also be bound by CAP_USER_NUMA.
> 
>   Otherwise, that's it - it's just a mempolicy with MPOL_F_PRIVATE.
> 
> NODE_PRIVATE_CAP_HOTUNPLUG
>   This is simple: allow hotunplug to migrate this nodes folios.
> 
>   Some devices may not be able to tolerate unexpected migrations,
>   so we prevent hotunplug from engaging in migration by default.
> 
>   Some devices may have an mmu_notifier in their driver that can
>   manage the migration and subsequent refault.
> 
>   CAP_HOTUNPLUG allows memory_hotplug.c to migrate normally.
> 
> NODE_PRIVATE_CAP_DEMOTION
>   This adds the private node as a valid demotion target, and allows
>   reclaim to demote memory from a private node to a demotion target.
> 
>   Requires:  NODE_PRIVATE_CAP_RECLAIM
> 
> NODE_PRIVATE_CAP_NUMA_BALANCING
>   This enables numa balancing to inject prot_none on private node
>   folio mappings and promote them when faults are taken.
> 
> NODE_PRIVATE_CAP_LTPIN
>   This allows GUP Longterm Pinning to operate normally.
> 
>   Normally, longterm pinning determines folio eligibility based
>   on its ZONE_* membership (among other things).
> 
>   ZONE_NORMAL is eligible, while ZONE_MOVABLE folios require
>   migration to ZONE_NORMAL before pinning.
> 
>   Neither operation is preferable by default on a private node,
>   so the base behavior of FOLL_LONGTERM is to FAIL.
> 
>   This capability allows longterm pinning to operate normally
>   based on the ZONE membership.  Private node memory may be
>   hotplugged as either ZONE_NORMAL or ZONE_MOVABLE.
> 
> In-tree User: KVM
> =================
> Dave Jiang proposed [2] dax-backed guest_memfd() memory as a way of
> enabling disaggregated memory pools to host dedicated KVM memory.
> 
> With private nodes, this is trivial (with a bit of basic plumbing):
> 
> static int kvm_gmem_bind_node(struct inode *inode, int node)
> {
> ...
>   /* Bind to a private node - gated on CAP_USER_NUMA */
>   pol = mpol_bind_node(node);
>   if (IS_ERR(pol))
>     return PTR_ERR(pol);
> 
>   /* Set the shared policy */
>   err = mpol_set_shared_policy_range(&GMEM_I(inode)->policy, ..., pol);
> ...
> }
> 
> KVM doesn't even need to know about private nodes at all, all it
> does is ask mempolicy whether the requested node is a valid bind.
> 
> mm/ component testing with dax driver
> =====================================
> The dax driver extensions[1] implements a simple interface to create
> a private node from a dax device created by any source.
> 
> I left the dax driver extensions out of this feature set because
> it locks in the CAP_ bits before anyone has input.  It's there
> primarily for testing at this point.
> 
> The simplest way to get a dax device is with the memmap= boot arg.
>    e.g.: "memmap=0x40000000!0x140000000"
> 
> The dax driver extension has the following sysfs entries:
>   dax0.0/private         - set the node to private
>   dax0.0/dax_file        - make /dev/dax0.0 mmap'able in kmem mode
>   dax0.0/adistance       - dictate memory_tierN membership
>   dax0.0/reclaim         - CAP_RECLAIM
>   dax0.0/demotion        - CAP_DEMOTION
>   dax0.0/user_numa       - CAP_USER_NUMA
>   dax0.0/hotunplug       - CAP_HOTUNPLUG
>   dax0.0/numa_balancing  - CAP_NUMA_BALANCING
>   dax0.0/ltpin           - CAP_LTPIN
> 
> Now consider the following...
> 
> Single node reclaim + mbind support:
>   echo 1 > dax0.0/private
>   echo 1 > dax0.0/reclaim
>   echo 1 > dax0.0/user_numa
>   echo online_movable > dax0.0/state
> 
> Test program:
>    /* node1: 1GB Private Memory Node, 4GB swap */
>    buf = mmap(NULL, TWO_GB, PROT_READ | PROT_WRITE,
>               MAP_PRIVATE | MAP_ANONYMOUS, -1, 0);
>    sys_mbind(p, len, MPOL_BIND, mask, MAXNODE, MPOL_MF_STRICT);
>    memset(buf, 0xff, TWO_GB);
> 
> We can *guarantee* the ONLY reclaiming tasks are exactly:
>   - kswapdN (in theory we can even make this optional!)
>   - the memset task faulting pages in
> 
> This also means these are the only tasks capable of becoming
> locked up and OOMing (as long as it is not under pressure).
> 
> The rest of the system remains entirely functional for debugging.
> 
> It now becomes possible to micro-benchmark and A/B test reclaim
> changes with different scenarios (number of tasks, amount of
> memory, watermark targets, etc), because we have hard controls
> over exactly which tasks can access that node memory and how.
> 
> If we broke CAP_RECLAIM into subflags:
>   - CAP_RECLAIM_KSWAPD
>   - CAP_RECLAIM_DIRECT
>   - CAP_COMPACTION_KCOMPACTD
>   - CAP_COMPACTION_DIRECT
> 
> We can actually test the efficacy of each of these mechanisms in
> isolation to each other - something that is strictly impossible today.
> 
> Bonus Configuration: HBM device memory tiering
> ==============================================
> echo 1 > dax0.0/private       # make the node private
> echo 0 > dax0.0/adistance     # highest tier
> echo 1 > dax0.0/reclaim       # reclaim active
> echo 1 > dax0.0/demotion      # may demote from the node
> echo 1 > dax0.0/user_numa     # mbind()
> echo online_movable > dax0.0/state
> echo 1 > numa/demotion_enabled
> 
> This is an HBM device which is treated as the top-tier in the
> system but for which memory can only enter via explicit mbind().
> 
> It can be overcommitted because it can be reclaimed (demotions
> go to CPU DRAM, and reclaim can swap from it).
> 
> If the HBM is managed by an accelerator (GPU), the mmu_notifier
> allows it to know when reclaim is moving memory out to do
> device-mmu invalidation prior to migration.
> 
> Prereqs, base commit, references
> ================================
> akpm/mm-new - for Brendan Jackman's mm/page_alloc.h work[3]
> 

Still thanks for the work, I learn alot from your work as well, thanks.

Best regards,
Richard Cheng.



> Prereqs (all already in akpm/mm-new; listed for out-of-tree application):
> 
> page_alloc.h split + alloc_flags plumbing this series rides on:
> commit e81fae43cd69 ("mm: split out internal page_alloc.h")
> commit b4ff3b6d0a1d ("mm: replace __GFP_NO_CODETAG with ALLOC_NO_CODETAG")
> 
> dax atomic whole-device hotplug (used by the dax extension [1]):
> commit d7aa81b9a919 ("mm/memory: add memory_block_aligned_range() helper")
> commit 3b2f402a1754 ("dax/kmem: add sysfs interface for atomic whole-device hotplug")
> 
> [1] https://github.com/gourryinverse/linux/tree/scratch/gourry/managed_nodes/dax_private-mm-new
> [2] https://lore.kernel.org/all/20260423170219.281618-1-dave.jiang@intel.com/
> [3] https://lore.kernel.org/all/20260702-alloc-trylock-v4-0-0af8ff387e80@google.com/
> 
> base-commit: c872b70f5d6c742ad34b8e838c92af81c8920b3e
> 
> Gregory Price (36):
>   mm: refactor find_next_best_node to find_next_best_node_in
>   mm/page_alloc: refactor build_node_zonelist() out of build_zonelists()
>   mm/page_alloc: let the bulk and folio allocators carry alloc_flags
>   numa: introduce N_MEMORY_PRIVATE
>   mm: add ZONELIST_PRIVATE(_NOFALLBACK) for N_MEMORY_PRIVATE nodes.
>   cpuset: exclude private nodes from cpuset.mems (default-open)
>   mm/memory_hotplug: disallow migration-driven private node hotunplug
>   mm/mempolicy: skip private node folios when queueing for migration
>   mm/migrate: disallow userland driven migration for private nodes
>   mm/madvise: disallow madvise operations on private node folios
>   mm/compaction: disallow compaction on private nodes
>   mm/page_alloc: clear private node watermarks and system reserves
>   mm/mempolicy: disallow NUMA Balancing prot_none on private nodes
>   mm/damon: skip private node memory in DAMON migration and pageout
>   mm/ksm: skip KSM for managed-memory folios
>   mm/khugepaged: skip private node folios when trying to collapse.
>   mm/vmscan: disallow reclaim of private node memory
>   mm/gup: disallow longterm pin of private node folios
>   proc: include N_MEMORY_PRIVATE nodes in numa_maps output
>   mm/memcontrol: account private-node memory in per-node stats
>   proc/kcore: include private-node RAM in the kcore RAM map
>   mm/mempolicy: add MPOL_F_PRIVATE and zonelist selection
>   mm/mempolicy: apply policy at the kernel zone for private-node binds
>   mm/mempolicy: add in-kernel MPOL_BIND interfaces for drivers/services
>   mm/memory_hotplug: support N_MEMORY_PRIVATE node hotplug
>   mm: add NODE_PRIVATE_CAP_RECLAIM for opted-in private node reclaim
>   mm: add NODE_PRIVATE_CAP_USER_NUMA for userland numa controls
>   mm: add NODE_PRIVATE_CAP_HOTUNPLUG for opted-in private nodes
>   mm: add NODE_PRIVATE_CAP_DEMOTION for private-node tiering demotion
>   mm: add NODE_PRIVATE_CAP_NUMA_BALANCING for private-node NUMA
>     balancing
>   mm: add NODE_PRIVATE_CAP_LTPIN for private node folio pinning
>   mm/khugepaged: base private node collapse eligiblity on actor/cap bits
>   Documentation/mm: describe private (N_MEMORY_PRIVATE) memory nodes
>   mm/mempolicy: add mpol_set_shared_policy_range()
>   KVM: guest_memfd: bind backing memory to a NUMA node at creation
>   KVM: selftests: add a guest_memfd FLAG_BIND_NODE test
> 
>  Documentation/ABI/stable/sysfs-devices-node   |  10 +
>  Documentation/mm/index.rst                    |   1 +
>  Documentation/mm/numa_private_nodes.rst       | 160 ++++++++++
>  drivers/base/node.c                           | 118 +++++++
>  drivers/dax/kmem.c                            |   2 +-
>  fs/proc/kcore.c                               |   5 +-
>  fs/proc/task_mmu.c                            |  10 +-
>  include/linux/gfp.h                           |  22 +-
>  include/linux/kvm_host.h                      |   3 +
>  include/linux/memory_hotplug.h                |   5 +-
>  include/linux/mempolicy.h                     |  16 +
>  include/linux/mmzone.h                        |  26 +-
>  include/linux/node_private.h                  | 262 ++++++++++++++++
>  include/linux/nodemask.h                      |   7 +-
>  include/uapi/linux/kvm.h                      |   5 +-
>  include/uapi/linux/mempolicy.h                |   1 +
>  kernel/cgroup/cpuset.c                        |  26 +-
>  mm/compaction.c                               |  13 +
>  mm/damon/paddr.c                              |   9 +
>  mm/gup.c                                      |  28 +-
>  mm/huge_memory.c                              |   5 +
>  mm/internal.h                                 |  97 +++++-
>  mm/khugepaged.c                               |  18 +-
>  mm/ksm.c                                      |   8 +-
>  mm/madvise.c                                  |   8 +-
>  mm/memcontrol-v1.c                            |   8 +-
>  mm/memcontrol.c                               |  13 +-
>  mm/memory-tiers.c                             |  40 ++-
>  mm/memory_hotplug.c                           | 119 +++++++-
>  mm/mempolicy.c                                | 288 +++++++++++++++---
>  mm/migrate.c                                  |  19 +-
>  mm/mm_init.c                                  |   2 +-
>  mm/page_alloc.c                               | 189 +++++++++---
>  mm/page_alloc.h                               |  34 +++
>  mm/vmscan.c                                   |  57 +++-
>  tools/testing/selftests/kvm/Makefile.kvm      |   2 +
>  .../kvm/guest_memfd_bind_node_test.c          | 213 +++++++++++++
>  virt/kvm/guest_memfd.c                        |  39 ++-
>  38 files changed, 1728 insertions(+), 160 deletions(-)
>  create mode 100644 Documentation/mm/numa_private_nodes.rst
>  create mode 100644 include/linux/node_private.h
>  create mode 100644 tools/testing/selftests/kvm/guest_memfd_bind_node_test.c
> 
> -- 
> 2.53.0-Meta
> 
> 
