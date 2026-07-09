Received: from CH1PR05CU001.outbound.protection.outlook.com (mail-northcentralusazon11010046.outbound.protection.outlook.com [52.101.193.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 18E9D378833;
	Thu,  9 Jul 2026 08:07:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.193.46
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783584470; cv=fail; b=Mh1yDqXagGr1C6kkt9Tm8blC4L7FknSioc6m5nDXX4shtYdCfNwZpv0QtShBMShmNdV3uouWD/jkawkonoSEiic02IvWydp8X+VrniwnPnhfJ/Fw9Zwcl9ltfGlC4kcpU73ySofuvCjeBxQ2YxEFlii1m1OPcb6/V9eQl2e3vjQ=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783584470; c=relaxed/simple;
	bh=Z+3GaQ/YbZyH7S8CPe0ycro7VXS/wXc6PwQjyFfThwI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=f85xreA+7FJTrmzhYSatvgBtGBO8cEcCF7Ir1B+9AA/7enEw4NW1qZuRgQMdllkYxpOsGGMoIRVTclJEzJdEF8bXXKLqk9YXc03mUvUe3KVhWm3kw4pGGa3p3bYIAaNySzxHbar2Pkxk6LMG8veP4/vs4Ua+uSYtGXAmTPH5BJE=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=pmq264o5; arc=fail smtp.client-ip=52.101.193.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="pmq264o5"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=netdeyiDBXxSCVo5jtZvUZrtP1Ev0LWUbw7GXrDvVFwPqfX3CfCnhD1xmkam6rFksJ/io+losWGAN0NwCkCkUP3tHHENewqWX/GWlc5fKHaq2tqxZ/rvFNkPckikz/6kAfoT723PYNsbknvysiqKWmHtb7Hjg+eiuloezHqXErFrjwe99ordhOsztBpC3560hCdAdRKFmgB/eNdrVGQQTkOTNVwDlhwT9KlUpHBya4fYBFxSC+k1PTauoooopYiodv0Eqb0mSetw1cSuJx4Ytq5QequsbwVQ0Ih9ye2Cuj+NzMZ8Y0RRqDm04IwQX+ANDAEpvGc2w3+4+Luu5Nj1cQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=CrkT5GIe3q+adHYN4TKqCMGczNCH/69+Ql8vsRn8puQ=;
 b=XE4Vvzu6PEZJqtf3NV7D7BrkRmHpRVHM3OUtYhiWu5q1TqXYr26zGwcE90fw4qWd40HZF2U7dH0F4WvjQl9qlUaVhC6T2iJ0miSJ0qcXUb//T8+BFqrnzemf/3BFc7bwzIJkLiNMvYnpcX8Kx2i4q3SUes5mllbcj+UWVM3Q9HhckkfJLaQeVNigihBPsv/LOS/MiFyZBsFrHaG9Da7S8oNdjjeX3uDyuJr8uXJhvy7uId9Gn8/1tf8eiVgFswv6mX4BvU00DAuVAom84BHuGeGGSiX66bNtMtxfXqEJel+yxU6L25y+OarXphapPW1YEsyVrIubiAFzJMMegN4F9w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=CrkT5GIe3q+adHYN4TKqCMGczNCH/69+Ql8vsRn8puQ=;
 b=pmq264o5Zi2taQKa5zukvnFv8Nomzh7og0hXTzMlEd1smHei76lYPyauFQatNoS8dYbgv5H2shvPG/uuwaWv5jWBDdCjZVwhwHapxaUxwo2l/2ZZuRYFhoiR3x57kK5lVWnfyPVKu9v6IWItzGEZDdGiYLcWPca7Tb8mryfPqLFG5YqEbhIpdcb1nOE3UeqNjWqfJH6kQszkZ2UmkI8aJIHMRDY9VUoMFOX7/r7IPrC8Zz5qdAtJEuKnanyZM1AOQYNrDJyDPIzJrP7GiNb1vNqJr/V3Ci75kLh1EFDNHJtfMOngRnIRHsAijAkxAPb6GYtsr9KjKtjfuPFdWwI+uQ==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from BL0PR12MB2370.namprd12.prod.outlook.com (2603:10b6:207:47::27)
 by SJ2PR12MB8720.namprd12.prod.outlook.com (2603:10b6:a03:539::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.181.15; Thu, 9 Jul
 2026 08:07:40 +0000
Received: from BL0PR12MB2370.namprd12.prod.outlook.com
 ([fe80::86cf:c3ec:2cf5:74c8]) by BL0PR12MB2370.namprd12.prod.outlook.com
 ([fe80::86cf:c3ec:2cf5:74c8%5]) with mapi id 15.21.0181.014; Thu, 9 Jul 2026
 08:07:40 +0000
Date: Thu, 9 Jul 2026 16:07:31 +0800
From: Richard Cheng <icheng@nvidia.com>
To: Gregory Price <gourry@gourry.net>
Cc: linux-mm@kvack.org, nvdimm@lists.linux.dev, 
	linux-kernel@vger.kernel.org, linux-cxl@vger.kernel.org, driver-core@lists.linux.dev, 
	linux-kselftest@vger.kernel.org, kernel-team@meta.com, david@kernel.org, osalvador@suse.de, 
	gregkh@linuxfoundation.org, rafael@kernel.org, dakr@kernel.org, djbw@kernel.org, 
	vishal.l.verma@intel.com, dave.jiang@intel.com, alison.schofield@intel.com, 
	akpm@linux-foundation.org, ljs@kernel.org, liam@infradead.org, vbabka@kernel.org, 
	rppt@kernel.org, surenb@google.com, mhocko@suse.com, shuah@kernel.org, 
	iweiny@kernel.org, Smita.KoralahalliChannabasappa@amd.com, apopple@nvidia.com, 
	Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH v6 09/10] dax/kmem: add sysfs interface for atomic
 whole-device hotplug
Message-ID: <ak9TSx-I-53dX6fx@MWDK4CY14F>
References: <20260630211842.2252800-1-gourry@gourry.net>
 <20260630211842.2252800-10-gourry@gourry.net>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260630211842.2252800-10-gourry@gourry.net>
X-ClientProxiedBy: KUZPR04CA0015.apcprd04.prod.outlook.com
 (2603:1096:d10:25::7) To BL0PR12MB2370.namprd12.prod.outlook.com
 (2603:10b6:207:47::27)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BL0PR12MB2370:EE_|SJ2PR12MB8720:EE_
X-MS-Office365-Filtering-Correlation-Id: 73310170-7c49-487f-eda9-08dedd912562
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|23010399003|376014|7416014|1800799024|18002099003|22082099003|56012099006|5023799004|11063799006|4143699003|6133799003;
X-Microsoft-Antispam-Message-Info:
	h40ygepBVNIN9uQOCqcw//FMMf6STp0rQsdTluXYfg1Gr6iVFcekPAlfWXZ2wJtEizW6JesoMc73EZLbK1Y75pMQr5qaJHENrzDmWr2gGy0mCrIQhIMbirpLjCKD3xN/m3XsH2vD8y+mzA/3Zo1bv63wXYhg3SBgjQQ9OC4pSV65UdfiGn6MjFTH0Jid/g+IM/4PBPwkbti2e6VG3lqKE42RZAancgPkrJNjjb2CUi4NTEmhMCSAQqHvpOs0hNsmv31dPrrbbJWuT13NLCa3XvSI6f7EnD2HFzHxJ1TyCrnPblHam3+eIp+d/2RO1+8gyMvTCD9GBUEDijkYoKqTGb0U2PBb3O6nnMNTRRMXWrM+tYLN95cmg7CMntByu7ONb3CYs98QqzCMSgSNwB4fsfWgahKuIpuxC6Uwfr0hhxvZPXtt2JTLnK0UcxP3qbQIvlbiMMPmYXtH4ainX2ZSdzHPbPxJMHEAQykmey88f6JZ/CduKY4FN+wnVDncj3bxQL5GUm9fswF+ngNzQaB/6lCS//W+GC4f+Z6Lrf96WGOU1kWcrZAWQBbWkPMJOW320HwB8H6GtGLd/Yc/R4Vj4nCLMn9TxwnvOEcg9Muwy4fCvlbjG470g7di2Mbf39gDbQWY7WHT90i47QlT59tVTycYY7F862Z6B1fsUFiEaWo=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL0PR12MB2370.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(23010399003)(376014)(7416014)(1800799024)(18002099003)(22082099003)(56012099006)(5023799004)(11063799006)(4143699003)(6133799003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?j2ko3x2mLOnCwstUUVOOrKWm8bMEa3tdyPzcR0mFKr4+EZzUQQ3rB5Y/l9l6?=
 =?us-ascii?Q?3hZdfeNCZ6CL860z+4T3UZDGi7APgbkAeV3Ehww0eowtOYzAUI9Z9IuCvk3b?=
 =?us-ascii?Q?pntsWV/sqb5TUW8hG11MyOyT6V9o4+XszH8G9oDv7J3z88vtXSIPy7AjmVCi?=
 =?us-ascii?Q?4TSj17z7dElVTmvPxWeEWjaC9M1KlmWvulc8NdyZPL13oo4/XRgrv/Uvtqel?=
 =?us-ascii?Q?jR98axFtTXMsyGiaubEGnYzmEiry8sdbBrMr1U1Ip80Nvn6IpE236ffLFNca?=
 =?us-ascii?Q?CICYuKg90pnBY+Ot/Fqcw0U0/G+89CQ28e5DIzhct42iNgTml7obM25xQLhU?=
 =?us-ascii?Q?mrrLBEUTsH/iKnLyk6bh16GnqW/hg9Qls15SEgpLMKQgVbVgV8KdVlKnEDnR?=
 =?us-ascii?Q?RgsUMbbFugOvyTXZRBTjClGXv84D7Lo/kOcqCz9lztpTqKCnqfTi09ito64U?=
 =?us-ascii?Q?7Sde/++PkX8MTDjbTXle6W39cTxR09huSo+TJAA3joN1cs2KQntk9bqUeBD3?=
 =?us-ascii?Q?X6NfOtXC8vojrXdnMZ5IaV8blgUXuW80y7izv/euBvR0dtYYucCBb3vwSHux?=
 =?us-ascii?Q?GfR/4jdJCZUi9z9ss497HhN3z8X0+PH2U6GrR1L5VD3gQtKez0KXcRgd6IpS?=
 =?us-ascii?Q?4RUtfk4KcrJjmru5YPL8En08UxLremoO0tNnLro33yT8cKWiDadcTnPQemki?=
 =?us-ascii?Q?XWiT3uaJBU8Su/2TdmRsekVaUtrIVfD4bwMjScnXI7XzuBhf/+swEbH87l6e?=
 =?us-ascii?Q?ryNA0icsjGFAvy5x7MTSvd/eWUGR7BjOvXQxJZOsTzOvPqRI5SdxmTScSC2G?=
 =?us-ascii?Q?EqM4J8QyNyU0uN84CJ/PhpQxORuQYfUimZjNIC9tjMtX47SI0Xnn+iWZgkCl?=
 =?us-ascii?Q?0raR0rtR4cX0FRcbpb/1o5I9puQ5zSekEvzPWvaGS5U3QJSZsII+m3GT8tag?=
 =?us-ascii?Q?m3NOkyhRx/ZdgOcQHCIH2ji4Huu3YVU6JvCuXwUhf+qLNkDHD8oZaTsDcFpb?=
 =?us-ascii?Q?lOxnTtBv2PZ2PYHwMnWfJYApUnO4n2Efl4u5j+Khn9dW+FhAfopTt3If5h9u?=
 =?us-ascii?Q?gCkrWc/OocJUiTPvHSPU2/PTfRukTljdxwKPQkJJPjxTJlNN04eR2AVzA8ki?=
 =?us-ascii?Q?qpyx5IJaghz9yAZjDR3pPQE8uvemEC3E4yntZVNR0jtGaJAKArNL5mLMlpJn?=
 =?us-ascii?Q?YsE9Vc+QHo9kIbQEGF888fGMvf3MnZWiBDLolypockDrpu9bzoXk6pjtzKEY?=
 =?us-ascii?Q?z3rUwo9BCa4NCGbvvST86UAwcAN/lDINeKoYrPEOqi8yketa0n92lgI67Xg5?=
 =?us-ascii?Q?eqiE2e+1cNhXj4d0L0mt6mRzFN3lZtsg2o6YY3ZiI7xIzcB9iLCcTuDcJElg?=
 =?us-ascii?Q?KzNKYnaUgYfV+1HFxR4NX0ZI8XdpCykvCExwlzfF8dHbonisDZ1tcTORa1CT?=
 =?us-ascii?Q?l3CXvMws89RzvR6ECzQ3qlISahSGoS0IfSZmLH/gAH8RQHhjodbAbc4gc1Ac?=
 =?us-ascii?Q?2J898b64fqfwfoJdgPQjCmcng9BbEFGRFLJhmkemaQqzLapherG4vC02Te1B?=
 =?us-ascii?Q?eMZQJfIoLTJizSNpEDupJNKJafGwniTGkg3pgCt+ewHOf7Jq20+S9d0Ei4XR?=
 =?us-ascii?Q?6UvEBAgHRhkdAOmd5KzIN+ara2WaPAORsWhvqiGWuQ69v8yFAHr+G8LfT29Z?=
 =?us-ascii?Q?2IPDTuvUtsZbSr1YdqamnHBnOS2ca20Qd7TMC/PXXarconSt4LsW3gd/9Xwy?=
 =?us-ascii?Q?C6VtnJ5Nag=3D=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 73310170-7c49-487f-eda9-08dedd912562
X-MS-Exchange-CrossTenant-AuthSource: BL0PR12MB2370.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Jul 2026 08:07:40.4310
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: W41GzhVMMrI80rk3GZftKEQ9lwTO6EefKOI1ZHCJwbqncQQvLqmAHgc8mV1LJaJGAxlRKXROhduDor2uvvtZiQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ2PR12MB8720

On Tue, Jun 30, 2026 at 05:18:41PM +0800, Gregory Price wrote:
> There is no atomic mechanism to offline and remove an entire
> multi-block DAX kmem device.  This is presently done in two steps:
>     1. offline all
>     2. remove all
> 
> This creates a race condition where another entity operates directly
> on the memory blocks and can cause hot-unplug to fail / unbind to
> deadlock.
> 
> Add a new 'state' sysfs attribute that enables an atomic whole-device
> hotplug operation across its entire memory region.
> 
> daxX.Y/state mirrors the per-block memoryX/state ABI:
>   - [offline, online, online_kernel, online_movable]
>   - "unplugged" - is added specifically for dax0.0/state
> 
> The valid writable states include:
>   - "unplugged":      memory blocks are not present
>   - "online":         memory is online, zone chosen by the kernel
>   - "online_kernel":  memory is online in ZONE_NORMAL
>   - "online_movable": memory is online in ZONE_MOVABLE
> 
> Valid transitions:
>   - unplugged                -> online[_kernel|_movable]
>   - online[_kernel|_movable] -> unplugged
>   - offline                  -> unplugged
> 
> A device can only be onlined from "unplugged", so it must be returned
> there before being onlined into a different state.
> 
> For backwards compatibility the memory blocks are always created at
> probe - existing tools expect them to be present after kmem binds.
> 
> "offline" is therefore a reportable state but is not writable: it only
> arises from the legacy auto_online_blocks=offline policy.  Onlining
> such a device through this attribute requires unplugging it first in
> an effort to get drivers creating DAX devices to set a default.
> 
> Unplug is atomic across the whole device: dax_kmem_do_hotremove()
> collects every added range and offlines/removes them in one operation.
> Either the operation succeeds or is entirely rolled back.
> 
> Unbind Note:
>   We used to call remove_memory() during unbind, which would fire a
>   BUG() if any of the memory blocks were online at that time.  We lift
>   this into a WARN in the cleanup routine and don't attempt hotremove
>   if ->state is not DAX_KMEM_UNPLUGGED or MMOP_OFFLINE.
> 
>   An offline dax device memory is removed on unbind as before.
> 
>   If online at unbind, the resources are leaked (as before), but now
>   we prevent deadlock if a memory region is impossible to hotremove.
> 
> Suggested-by: Hannes Reinecke <hare@suse.de>
> Suggested-by: David Hildenbrand <david@kernel.org>
> Signed-off-by: Gregory Price <gourry@gourry.net>
> ---
>  Documentation/ABI/testing/sysfs-bus-dax |  26 +++
>  drivers/dax/kmem.c                      | 258 ++++++++++++++++++++----
>  2 files changed, 248 insertions(+), 36 deletions(-)
> 
> diff --git a/Documentation/ABI/testing/sysfs-bus-dax b/Documentation/ABI/testing/sysfs-bus-dax
> index b34266bfae49..2dcad1e9dad0 100644
> --- a/Documentation/ABI/testing/sysfs-bus-dax
> +++ b/Documentation/ABI/testing/sysfs-bus-dax
> @@ -151,3 +151,29 @@ Description:
>  		memmap_on_memory parameter for memory_hotplug. This is
>  		typically set on the kernel command line -
>  		memory_hotplug.memmap_on_memory set to 'true' or 'force'."
> +
> +What:		/sys/bus/dax/devices/daxX.Y/state
> +Date:		June, 2026
> +KernelVersion:	v6.21
> +Contact:	nvdimm@lists.linux.dev
> +Description:
> +		(RW) Controls the state of the memory region.
> +		Applies to all memory blocks associated with the device.
> +		Only applies to dax_kmem devices.
> +
> +		Reading returns the current state; the writable states mirror
> +		the per-block /sys/devices/system/memory/memoryX/state ABI::
> +
> +		  "unplugged": memory blocks are not present
> +		  "online": memory is online, zone chosen by the kernel
> +		  "online_kernel": memory is online in ZONE_NORMAL
> +		  "online_movable": memory is online in ZONE_MOVABLE
> +
> +		"offline" (memory blocks are present but offline) may also be
> +		reported - this happens when the device is bound while the
> +		auto_online_blocks policy is "offline".  It cannot be written,
> +		as it's not useful and creates device destruction races.
> +
> +		A device can only be onlined from the "unplugged" state, so a
> +		device must be returned to "unplugged" before it can be onlined
> +		into a different state.
> diff --git a/drivers/dax/kmem.c b/drivers/dax/kmem.c
> index 72dcccee41e1..19effe0da3dc 100644
> --- a/drivers/dax/kmem.c
> +++ b/drivers/dax/kmem.c
> @@ -42,9 +42,15 @@ static int dax_kmem_range(struct dev_dax *dev_dax, int i, struct range *r)
>  	return 0;
>  }
>  
> +#define DAX_KMEM_UNPLUGGED	(-1)
> +
>  struct dax_kmem_data {
>  	const char *res_name;
>  	int mgid;
> +	int numa_node;
> +	struct dev_dax *dev_dax;
> +	int state;
> +	struct mutex lock; /* protects hotplug state transitions */
>  	struct resource *res[];
>  };
>  
> @@ -63,12 +69,22 @@ static void kmem_put_memory_types(void)
>  	mt_put_memory_types(&kmem_memory_types);
>  }
>  
> +/* True for the online states a kmem dax device can hold. */
> +static bool dax_kmem_state_is_online(int state)
> +{
> +	return state == MMOP_ONLINE ||
> +	       state == MMOP_ONLINE_KERNEL ||
> +	       state == MMOP_ONLINE_MOVABLE;
> +}
> +
>  /**
>   * dax_kmem_do_hotplug - hotplug memory for dax kmem device
>   * @dev_dax: the dev_dax instance
>   * @data: the dax_kmem_data structure with resource tracking
> + * @online_type: the online policy to use for the memory blocks
>   *
> - * Hotplugs all ranges in the dev_dax region as system memory.
> + * Hotplugs all ranges in the dev_dax region as system memory with the
> + * provided online policy (offline, online, online_movable, online_kernel).
>   *
>   * Returns the number of successfully mapped ranges, or negative error.
>   */
> @@ -77,9 +93,15 @@ static int dax_kmem_do_hotplug(struct dev_dax *dev_dax,
>  			       int online_type)
>  {
>  	struct device *dev = &dev_dax->dev;
> -	int i, rc, onlined = 0;
> +	int i, rc, added = 0;
>  	mhp_t mhp_flags;
>  
> +	if (dax_kmem_state_is_online(data->state))
> +		return -EINVAL;
> +
> +	if (online_type < MMOP_OFFLINE || online_type > MMOP_ONLINE_MOVABLE)
> +		return -EINVAL;
> +
>  	for (i = 0; i < dev_dax->nr_range; i++) {
>  		struct range range;
>  
> @@ -123,14 +145,14 @@ static int dax_kmem_do_hotplug(struct dev_dax *dev_dax,
>  				kfree(data->res[i]);
>  				data->res[i] = NULL;
>  			}
> -			if (onlined)
> +			if (added)
>  				continue;
>  			return rc;
>  		}
> -		onlined++;
> +		added++;
>  	}
>  
> -	return onlined;
> +	return added;
>  }
>  
>  /**
> @@ -193,45 +215,64 @@ static int dax_kmem_init_resources(struct dev_dax *dev_dax,
>   * @dev_dax: the dev_dax instance
>   * @data: the dax_kmem_data structure with resource tracking
>   *
> - * Removes all ranges in the dev_dax region.
> + * Offlines and removes every currently-added range in the dev_dax region
> + * atomically: either all ranges are offlined and removed, or none are and
> + * the device is returned to its prior state.
>   *
> - * Returns the number of successfully removed ranges.
> + * Returns 0 on success, or a negative errno on failure.
>   */
>  static int dax_kmem_do_hotremove(struct dev_dax *dev_dax,
>  				 struct dax_kmem_data *data)
>  {
>  	struct device *dev = &dev_dax->dev;
> -	int i, success = 0;
> +	struct range *ranges;
> +	int i, nr_ranges = 0, rc;
> +
> +	ranges = kmalloc_array(dev_dax->nr_range, sizeof(*ranges), GFP_KERNEL);
> +	if (!ranges)
> +		return -ENOMEM;
>  
> +	/* Collect the ranges that were actually added during probe. */
>  	for (i = 0; i < dev_dax->nr_range; i++) {
>  		struct range range;
> -		int rc;
>  
> -		rc = dax_kmem_range(dev_dax, i, &range);
> -		if (rc)
> +		if (!data->res[i])
>  			continue;
> -
> -		/* range was never added during probe, count as removed */
> -		if (!data->res[i]) {
> -			success++;
> +		if (dax_kmem_range(dev_dax, i, &range))
>  			continue;
> -		}
> +		ranges[nr_ranges++] = range;
> +	}
>  
> -		rc = remove_memory(range.start, range_len(&range));
> -		if (rc == 0) {
> -			/* Release the resource for the successfully removed range */
> -			remove_resource(data->res[i]);
> -			kfree(data->res[i]);
> -			data->res[i] = NULL;
> -			success++;
> +	/* Nothing added means nothing to remove. */
> +	if (!nr_ranges) {
> +		kfree(ranges);
> +		return 0;
> +	}
> +
> +	rc = offline_and_remove_memory_ranges(ranges, nr_ranges);
> +	kfree(ranges);
> +	if (rc) {
> +		/* Recoverable: the ranges rolled back, nothing is leaked yet. */
> +		dev_err(dev, "hotremove failed, device left online: %d\n", rc);
> +		return rc;
> +	}
> +
> +	/* All ranges removed; release the reserved resources. */
> +	for (i = 0; i < dev_dax->nr_range; i++) {
> +		if (!data->res[i])
>  			continue;
> -		}
> -		any_hotremove_failed = true;
> -		dev_err(dev, "mapping%d: %#llx-%#llx hotremove failed\n",
> -			i, range.start, range.end);
> +		remove_resource(data->res[i]);
> +		kfree(data->res[i]);
> +		data->res[i] = NULL;
>  	}
>  
> -	return success;
> +	return 0;
> +}
> +#else
> +static int dax_kmem_do_hotremove(struct dev_dax *dev_dax,
> +				 struct dax_kmem_data *data)
> +{
> +	return -EBUSY;
>  }
>  #endif /* CONFIG_MEMORY_HOTREMOVE */
>  
> @@ -247,6 +288,18 @@ static void dax_kmem_cleanup_resources(struct dev_dax *dev_dax,
>  {
>  	int i;
>  
> +	/*
> +	 * If the device unbind occurs before memory is hotremoved, we can never
> +	 * remove the memory (requires reboot).  Attempting an offline operation
> +	 * here may cause deadlock and a failure to finish the unbind.
> +	 *
> +	 * Note: This leaks the resources.
> +	 */
> +	if (WARN(((data->state != DAX_KMEM_UNPLUGGED) &&
> +		  (data->state != MMOP_OFFLINE)),
> +		 "Hotplug memory regions stuck online until reboot"))
> +		return;
> +
>  	for (i = 0; i < dev_dax->nr_range; i++) {
>  		if (!data->res[i])
>  			continue;
> @@ -256,6 +309,85 @@ static void dax_kmem_cleanup_resources(struct dev_dax *dev_dax,
>  	}
>  }
>  
> +static int dax_kmem_parse_state(const char *buf)
> +{
> +	int online_type;
> +
> +	/* "unplugged" is kmem-specific - the rest map to MMOP_ */
> +	if (sysfs_streq(buf, "unplugged"))
> +		return DAX_KMEM_UNPLUGGED;
> +
> +	online_type = mhp_online_type_from_str(buf);
> +	/* Disallow "offline": it's not useful and creates race conditions */
> +	if (online_type == MMOP_OFFLINE)
> +		return -EINVAL;
> +	return online_type;
> +}
> +
> +static ssize_t state_show(struct device *dev,
> +			    struct device_attribute *attr, char *buf)
> +{
> +	struct dax_kmem_data *data = dev_get_drvdata(dev);
> +	const char *state_str;
> +
> +	if (!data)
> +		return -ENXIO;
> +
> +	if (data->state == DAX_KMEM_UNPLUGGED)
> +		state_str = "unplugged";
> +	else
> +		state_str = mhp_online_type_to_str(data->state);
> +
> +	return sysfs_emit(buf, "%s\n", state_str ?: "unknown");
> +}
> +
> +static ssize_t state_store(struct device *dev, struct device_attribute *attr,
> +			     const char *buf, size_t len)
> +{
> +	struct dev_dax *dev_dax = to_dev_dax(dev);
> +	struct dax_kmem_data *data = dev_get_drvdata(dev);
> +	int online_type;
> +	int rc;
> +
> +	if (!data)
> +		return -ENXIO;
> +
> +	online_type = dax_kmem_parse_state(buf);
> +	if (online_type < DAX_KMEM_UNPLUGGED)
> +		return online_type;
> +
> +	guard(mutex)(&data->lock);
> +
> +	/* Already in requested state */
> +	if (data->state == online_type)
> +		return len;
> +
> +	if (online_type == DAX_KMEM_UNPLUGGED) {
> +		rc = dax_kmem_do_hotremove(dev_dax, data);
> +		if (rc)
> +			return rc;
> +		data->state = DAX_KMEM_UNPLUGGED;
> +		return len;
> +	}
> +
> +	/* Onlining is only allowed from the unplugged state. */
> +	if (data->state != DAX_KMEM_UNPLUGGED)
> +		return -EBUSY;
> +
> +	/* Re-acquire resources if previously unplugged, otherwise no-op */
> +	rc = dax_kmem_init_resources(dev_dax, data);
> +	if (rc < 0)
> +		return rc;
> +
> +	rc = dax_kmem_do_hotplug(dev_dax, data, online_type);
> +	if (rc < 0)
> +		return rc;
> +
> +	data->state = online_type;
> +	return len;
> +}
> +static DEVICE_ATTR_RW(state);
> +
>  static int dev_dax_kmem_probe(struct dev_dax *dev_dax)
>  {
>  	struct device *dev = &dev_dax->dev;
> @@ -324,6 +456,10 @@ static int dev_dax_kmem_probe(struct dev_dax *dev_dax)
>  	if (rc < 0)
>  		goto err_reg_mgid;
>  	data->mgid = rc;
> +	data->numa_node = numa_node;
> +	data->dev_dax = dev_dax;
> +	data->state = DAX_KMEM_UNPLUGGED;
> +	mutex_init(&data->lock);
>  
>  	dev_set_drvdata(dev, data);
>  
> @@ -336,9 +472,15 @@ static int dev_dax_kmem_probe(struct dev_dax *dev_dax)
>  	if (online_type == DAX_ONLINE_DEFAULT)
>  		online_type = mhp_get_default_online_type();
>  
> +	/* Always create blocks for backward compatibility, even if offline */
>  	rc = dax_kmem_do_hotplug(dev_dax, data, online_type);
>  	if (rc < 0)
>  		goto err_hotplug;
> +	data->state = online_type;
> +
> +	rc = device_create_file(dev, &dev_attr_state);
> +	if (rc)
> +		dev_warn(dev, "failed to create state sysfs entry\n");
>  
>  	return 0;
>  
> @@ -357,22 +499,62 @@ static int dev_dax_kmem_probe(struct dev_dax *dev_dax)
>  }
>  
>  #ifdef CONFIG_MEMORY_HOTREMOVE
> +/*
> + * Remove the device's added ranges with remove_memory().
> + * Unlike the sysfs unplug path it never offlines and fails if the blocks are
> + * online (-EBUSY), so it is safe from unbind. Failures leak until reboot.
> + *
> + * Returns 0 only if every added range was removed.
> + */
> +static int dax_kmem_remove_ranges(struct dev_dax *dev_dax,
> +				  struct dax_kmem_data *data)
> +{
> +	struct device *dev = &dev_dax->dev;
> +	int i, rc = 0;
> +
> +	for (i = 0; i < dev_dax->nr_range; i++) {
> +		struct range range;
> +
> +		if (!data->res[i] || dax_kmem_range(dev_dax, i, &range))
> +			continue;
> +		if (remove_memory(range.start, range_len(&range))) {
> +			dev_warn(dev, "mapping%d: %#llx-%#llx stuck online until reboot\n",
> +				 i, range.start, range.end);
> +			rc = -EBUSY;
> +			continue;
> +		}
> +		remove_resource(data->res[i]);
> +		kfree(data->res[i]);
> +		data->res[i] = NULL;
> +	}
> +	return rc;
> +}
> +
>  static void dev_dax_kmem_remove(struct dev_dax *dev_dax)
>  {
> -	int success;
>  	int node = dev_dax->target_node;
>  	struct device *dev = &dev_dax->dev;
>  	struct dax_kmem_data *data = dev_get_drvdata(dev);
>  
> +	device_remove_file(dev, &dev_attr_state);
>  	/*
> -	 * We have one shot for removing memory, if some memory blocks were not
> -	 * offline prior to calling this function remove_memory() will fail, and
> -	 * there is no way to hotremove this memory until reboot because device
> -	 * unbind will succeed even if we return failure.
> +	 * If UNPLUGGED: state is known clean and reboot can clean up.
> +	 *
> +	 * If ONLINE_*: memory cannot be removed here: offlining during an
> +	 * uninterruptible unbind can deadlock. Leak the resources until reboot.
> +	 *
> +	 * If OFFLINE: blocks are attempted to remove with remove_memory(),
> +	 * which never attempts offlining. A block onlined behind our back
> +	 * fails -EBUSY and is leaked.
>  	 */
> -	success = dax_kmem_do_hotremove(dev_dax, data);
> -	if (success < dev_dax->nr_range) {
> -		dev_err(dev, "Hotplug regions stuck online until reboot\n");
> +	if (dax_kmem_state_is_online(data->state)) {
> +		dev_warn(dev, "Hotplug regions stuck online until reboot\n");
> +		any_hotremove_failed = true;
> +		return;

Hi Gregory,

I suppose data->state is only updated when writing to the new daxX.Y/state file?
If the blocks are offlined through the old per-block interface, data->state
still says online and we will hit this early return.
Everything is leaked and a later rebind fails -EBUSY.

Current behavior is using remove_memory(), and it succeeds on offlined blocks
and fails safely with -EBUSY on online ones, no offlining from unbind context
either way.

Your changelog state "on unbind fallback to legacy if still online", but the
fallback only runs for data->state == MMOP_OFFLINE.
Maybe drop this early return and just try dax_kmem_remove_ranges() here too?

Best regards,
Richard Cheng.


> +	} else if (data->state == MMOP_OFFLINE &&
> +		   dax_kmem_remove_ranges(dev_dax, data)) {
> +		any_hotremove_failed = true;
> +		dev_warn(dev, "Unplug failed, resources leaked until reboot\n");
>  		return;
>  	}
>  
> @@ -393,6 +575,10 @@ static void dev_dax_kmem_remove(struct dev_dax *dev_dax)
>  #else
>  static void dev_dax_kmem_remove(struct dev_dax *dev_dax)
>  {
> +	struct device *dev = &dev_dax->dev;
> +
> +	device_remove_file(dev, &dev_attr_state);
> +
>  	/*
>  	 * Without hotremove purposely leak the request_mem_region() for the
>  	 * device-dax range and return '0' to ->remove() attempts. The removal
> -- 
> 2.53.0-Meta
> 
> 
