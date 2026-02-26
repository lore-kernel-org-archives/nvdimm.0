Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9FFFF17BB21
	for <nvdimm@lists.linux.dev>; Thu, 26 Feb 2026 05:01:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.19
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772082080; cv=fail; b=HYch37PofGqmyCF9eobS/nhlc8/rohtcatt9Wc8dlJB7LGLv43pZW7CG0b63sGpn8+SGsr8BvEJS1kO/y/URS4xf2Ml4GpZtfI9aH/N48q7FT0eaa92qwLZch1/NtBtlqLlrNazxx+vrlFew7H8yyDq5OalSlwnPvrMTH7bnfFg=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772082080; c=relaxed/simple;
	bh=CgZRaPOjvbxNFR2fwCa3i4ciRx8qHDkdy7KXcMZRw20=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=VzeAsay6/p8SpJA/zM4OK0b/BiY83pZioPCxEiDULxBnlPaox9rcBaRco9ejrmnyEnBl6aUz+m5oDhuk8+gZLLoHD6NWlvy5H0LSd78z7S6/3768GFZ9Qjz9Ih5k03GB+icC3UNqGbfSQM4Y4j2WNC/7op2JNCS4zgThzxLs930=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=ICj8jwYz; arc=fail smtp.client-ip=198.175.65.19
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="ICj8jwYz"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1772082078; x=1803618078;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=CgZRaPOjvbxNFR2fwCa3i4ciRx8qHDkdy7KXcMZRw20=;
  b=ICj8jwYzC+uartXKNJztaj3usKWiiIOmzaPzdCxoztfuTo1C4AeL2DRA
   p+MU+ODq3ohXoce/BQ0+2JB0X2gu1mMr/G8KGLkAeDdNOreMa/pUwxQ8n
   TlE20pBs0XPW/VAAcpXH7VsutQpYJZqxhkJoJADLpuZepfOm9BTB1BBH4
   A3PkG3rUXjo1GDNa5FlEY1JUxaVM2QsNXfsOCe1MDDXeInmGx15v52MT6
   FnZtxYwcp8yHFvosA+E/wIcC6mvEre7AkyeUzNxP8eIj4q5K2pEh4HDyN
   F5wzBafxdc8/G2CWjD4I7RgJz4KqjcH3VPCmBmazugZfaYxa2exQ99qXI
   Q==;
X-CSE-ConnectionGUID: eRGEvOG6RLqK5c+lHz/58w==
X-CSE-MsgGUID: ezQg/w6OTYiXTplkKzgPig==
X-IronPort-AV: E=McAfee;i="6800,10657,11712"; a="73039922"
X-IronPort-AV: E=Sophos;i="6.21,311,1763452800"; 
   d="scan'208";a="73039922"
Received: from fmviesa002.fm.intel.com ([10.60.135.142])
  by orvoesa111.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Feb 2026 21:01:17 -0800
X-CSE-ConnectionGUID: PqTQMGnBTjuKzPpoAVxt5Q==
X-CSE-MsgGUID: lcUkoxU8T1+pr/Hgd84CZA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.21,311,1763452800"; 
   d="scan'208";a="239442537"
Received: from orsmsx903.amr.corp.intel.com ([10.22.229.25])
  by fmviesa002.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Feb 2026 21:01:17 -0800
Received: from ORSMSX902.amr.corp.intel.com (10.22.229.24) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.35; Wed, 25 Feb 2026 21:01:16 -0800
Received: from ORSEDG902.ED.cps.intel.com (10.7.248.12) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37 via Frontend Transport; Wed, 25 Feb 2026 21:01:16 -0800
Received: from CY3PR05CU001.outbound.protection.outlook.com (40.93.201.41) by
 edgegateway.intel.com (134.134.137.112) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.35; Wed, 25 Feb 2026 21:01:14 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=JciEdJxKMpUjoKbeNS/PtE3SFi7pKE1URk552AcCf6wEQMB1a7gJsgjAVl0lezaNTwBNCC8a8vl57VbZ9z27Ys9Z7q1qI72XsBP9kIIdPqOG7bB1asG0Wcg5vRVUtabFdjEW8FKdvcFYEOJNLrZQNoxFNMVEuRvBDsYeb12klXzOxxsgJ22wBch54KZgVVCNXKHAWVf6GtFiVPNh2Jhd4/WFn4iFJEjdY9iX0RYje0n5TitF3ulv8gFZ/xVTJ0QueLynTzGAnnldZTppOUvYv38/dAAWMJJlmGgPcb6JHWOBJOI4MuvQQU5CfsG0zwwLDgVwqQ5Kw9w+zij1pMIjbQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=dEImHQwKLj5QDmtGh7DhUp6Jn/ofYXH7YoiBKDRg6DI=;
 b=IxbXpt1W+NfGBDeKHjcQQ0NNZoNvV+0UhQEFMvhxiFQaFb9SN6w68BtSzG1hrGfr4pC5FlHOG9y+vF1C32Zk8G6R2dvij2JdCzXt8146/hNDUe5YbM4Ul1zbuZs94yEn44zL3w/RfIoWcVqwKlNvnGJow0B34CnX/smVBTf69l9vCBUo7i/9L4+aw5wr0G3lfQwT7RcJL3qG8kl8bQKWTSSUUmAjs5TSPx5oDT5Gj9ya8neaYDm7hxlZ3YqLmTDW2d/49WiozBFlJ5nAf1OgWjN/YnkyvTFLAoAZl5Z9+WLvlq7jAFKdhhmUqbhXykzNPRZmUvpcSwmEqnjUdpydQg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DS4PPF0BAC23327.namprd11.prod.outlook.com (2603:10b6:f:fc02::9)
 by CO1PR11MB4898.namprd11.prod.outlook.com (2603:10b6:303:92::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9654.14; Thu, 26 Feb
 2026 05:01:12 +0000
Received: from DS4PPF0BAC23327.namprd11.prod.outlook.com
 ([fe80::4a5f:d967:acb2:e28a]) by DS4PPF0BAC23327.namprd11.prod.outlook.com
 ([fe80::4a5f:d967:acb2:e28a%6]) with mapi id 15.20.9632.017; Thu, 26 Feb 2026
 05:01:12 +0000
Date: Wed, 25 Feb 2026 21:01:08 -0800
From: Alison Schofield <alison.schofield@intel.com>
To: Davidlohr Bueso <dave@stgolabs.net>
CC: <dan.j.williams@intel.com>, <vishal.l.verma@intel.com>,
	<dave.jiang@intel.com>, <akpm@linux-foundation.org>,
	<nvdimm@lists.linux.dev>, <linux-cxl@vger.kernel.org>,
	<linux-kernel@vger.kernel.org>, Ben Cheatham <benjamin.cheatham@amd.com>
Subject: Re: [PATCH v2] dax/kmem: account for partial dis-contiguous resource
 upon removal
Message-ID: <aZ_TlK4r41P0xBDO@aschofie-mobl2.lan>
References: <20260223201516.1517657-1-dave@stgolabs.net>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20260223201516.1517657-1-dave@stgolabs.net>
X-ClientProxiedBy: SJ0PR05CA0163.namprd05.prod.outlook.com
 (2603:10b6:a03:339::18) To DS4PPF0BAC23327.namprd11.prod.outlook.com
 (2603:10b6:f:fc02::9)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS4PPF0BAC23327:EE_|CO1PR11MB4898:EE_
X-MS-Office365-Filtering-Correlation-Id: 60640c94-59f1-4cf0-ef3f-08de74f40ffa
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|1800799024|366016|7053199007;
X-Microsoft-Antispam-Message-Info: H80oyCFWXjIX9AKexkmXqdJh8Vyy2ycJO9h/62IGrxPyK1kuraoxfcW3Wo5w+rAuKeCu9S8/or8cGR2wYAPOmOD+8fHNLm3ZUF82Ohw6tNKHY2S4cB85+WugiqGK905PpHqxHW+0ANPtykVPwZQAe867mIoPtfQYrf21odhXDMgV3gRhpjVdXF0K0wDjVCi4EZbnj6ODWWO9jTsSf/45SuIyEq7zyPppmWjpEqeRcGl4D1rZaL4UgelwGL2YYklCB+EVEFsWobgyXYwMVPROHS03i3ces8WFp0Na2kI+SM/hFNKPH0H7FiRXy+XT2J9LPSObfYEJyoWrfB9tDwyr2uyRcrS6EE1A4taPQlEX4soQM+P91gJuDb1s3pKA0Rv5h+l4m/sHjsFbZNky2OAJDaGqYNTZvPc3/ILQaF3llC/1oHZy4TZzg/l8D2Dit31EjEMyGkr86A0NTNQu8rHfgAk5Yij8Cx6uijY8yuOuiXTPEViZRDCDIZzdXH64yHyIHyOFzQCltdXZOgsKyUBwhILOFxrUja5RM8DbG6uqS2WBGiocQidYZ7Skn82Ckp7EFCf4i0iT5s2UJDOKp8bUM2no3t6aS7qaDgO1At2v+gzBL+dzLjwytalh4rsLlUNPTWQ6UPjl8tNg1m1CgfXIH2MW/dTE9VMWOHFVuLBvrAFaJyV4N/MQs9y0KFUDfEW26RpYGsGOroKFTpYtoM9UUNRtIsXyQzkjrejV3Q+v5OQ=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS4PPF0BAC23327.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(1800799024)(366016)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?2FHL7skVG7xcZzvU4hbj5P63zkY2wBVPY7iyMJtkHnIVKMaZqagkT6ZqA5l/?=
 =?us-ascii?Q?v9tzUmPVZJhw19nPMlpQnoDaPmvb3FvlXCCmh/+zkzs3Ia++C8SMxSGCJ65g?=
 =?us-ascii?Q?6BMUumQ/fl8tYjFX36hbxdvxiOAbzVC9I1KKfeKiX0bnhB7dYqOOtkw5d9Ne?=
 =?us-ascii?Q?IInVOXpUyc/NCTRBOJDyASzGnODjF5LsWviAnYcHoFa7xOiRGoWsjUkfNj4J?=
 =?us-ascii?Q?fT3BkPcsgVDrqa33rHr9ruuSB532mt1Z8gtwk+b1KQ6+2ziqBNM0E5WVMDcY?=
 =?us-ascii?Q?Oy4rpFBdYt/QzJh9bNzYT3D7Dv9A2PKMATifNDVWoF5xXGGwP0um1i0rk42a?=
 =?us-ascii?Q?JTU1IR8w72VkAopUffU3DaECogRWmqxXiBFSd5yvHZwo9Hs/sFIJlo8Byvk6?=
 =?us-ascii?Q?0DlEK/1Jzmxw0rKqXqeS6rt0xcmsOHfSyRpKs8ojxaS3RVn+TB5kbkqWqqw/?=
 =?us-ascii?Q?agzw6BVvrRMkl6pUs5xhBYMLd2WmrIYt8CUWoMZKGUwcTxHoWne9kaboQOvF?=
 =?us-ascii?Q?+f0lPlclCn5J+SDXfxW/+dbSZtL72Bm32Yyh4pvZFLbvKVEW4ecVQ+21DZx9?=
 =?us-ascii?Q?Q8jMoMZTf3Ca8S+tuqqWPsiBM9/ZLAGWauf0jk7nmE1A6igRJzDgB8KVZYft?=
 =?us-ascii?Q?1Hwuq0YrExmHbOaRcx7jmSA2iRhXQuciWUhxg6A5GQHWguXYZLoSWgks7nT4?=
 =?us-ascii?Q?YSCVkNpRMtiFz521A4zwQ2fT2oO1jUqKhQp+LtAQBHmSvv/m5BK4qyQDLnv0?=
 =?us-ascii?Q?jrHJgM/GbSurgU6q+Nr4sHTHbPtJeWxySl76vz5TBzQESOKQwsBwkdNj8pHN?=
 =?us-ascii?Q?AR/zHjxALh6YQN3uMRn87vbGHOCuagf4robKIpxjZKNkaY0TQBthTbfi3GJN?=
 =?us-ascii?Q?a7JkfIZsJPDBYJjr/WMRkbq+7yFmhuj5Yn6HTj6vXMrVi9EFJHXERRvM8iKm?=
 =?us-ascii?Q?sw+KV+BT8QDSthZ5AkfcyT67W4Ev+nvfuqtS2PxxdENIuxiSpQJgmaBqJBpE?=
 =?us-ascii?Q?TG3o+oQs/L0PA72myzxMmED6b7bOX65Tx4FM7DHPnRu6Jcz7ybwX8N7+cx+v?=
 =?us-ascii?Q?NFkIK8n07ZjuL70abW7EaqXS6oQvEecP4/r5dIACLDaRcywYeji8d4kvIVc/?=
 =?us-ascii?Q?+pSWu0yfzscCeOxqn7BrRN7ChvXZf6IPnu8S1qiUTDFo/XtjCgE6ojOEwpXP?=
 =?us-ascii?Q?ptBEHYtp4iDxPe9+s3fI2FHhPVMRQluqTmdRGys4N+w2ucA2Me1TZIgOXFL7?=
 =?us-ascii?Q?AOmR6hjBoeRwlRCCCDUyz3aS40rWONxnsyMrgIE7qRXKVPh/qjBch3iFPk/k?=
 =?us-ascii?Q?/s6ujJi5jBHlYrCbzb0DSn66dWUF9DICDhZo30Zxo3xXv3ta6FL3vY6GoYw2?=
 =?us-ascii?Q?9h1WKVsvWOWo28IQFHs8uWVl3MltJSV73T3QqQK/TBr7Ax1hcB/5MSVnz9v+?=
 =?us-ascii?Q?Nqgn2BAxUOpGFrb+f5YwUhZhxzIwwpT/GyLmas5Bf55Qlxy/wQsOvychtrPY?=
 =?us-ascii?Q?HKEJ0sx00kt4WtgHCY6N0XpmvDzSRnZmWDritmS2g7cj5yrbzD8pjdjv0VyD?=
 =?us-ascii?Q?WUDa9UOc0gpT6f3aTHnQFMad5aWyVVMLmOBu4hKrWU86+GlY4errZ4RX+fPz?=
 =?us-ascii?Q?GPZIM95BLHT+tYB2XMh2eDrbkukT6ZwyDptnMTOv5Ggy/WvkOSruA0XDA/Ac?=
 =?us-ascii?Q?SH1Aw/hTHdEN0ZUocEPxuYDLwJoBl9bGw1572SHvnruWhw+g0NhjKcr5YHWO?=
 =?us-ascii?Q?TvXPFr59sWwzUbC5ToYqoxRmUyrUUpM=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 60640c94-59f1-4cf0-ef3f-08de74f40ffa
X-MS-Exchange-CrossTenant-AuthSource: DS4PPF0BAC23327.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Feb 2026 05:01:12.3814
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 7liGPbLjQZJSBBrajECH5xYRIs3IYgW/Epvp6SY1o/mqF/LPTyjrKwONZekmwAODNtWWYnDJJ1RRKr7XAnikRHJUAQAnGq2lkzkTMMki4AM=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO1PR11MB4898
X-OriginatorOrg: intel.com

On Mon, Feb 23, 2026 at 12:15:16PM -0800, Davidlohr Bueso wrote:
> When dev_dax_kmem_probe() partially succeeds (at least one range
> is mapped) but a subsequent range fails request_mem_region()
> or add_memory_driver_managed(), the probe silently continues,
> ultimately returning success, but with the corresponding range
> resource NULL'ed out.
> 
> dev_dax_kmem_remove() iterates over all dax_device ranges regardless
> of if the underlying resource exists. When remove_memory() is
> called later, it returns 0 because the memory was never added which
> causes dev_dax_kmem_remove() to incorrectly assume the (nonexistent)
> resource can be removed and attempts cleanup on a NULL pointer.

Do you have a failure signature w Call Trace to paste here?
If not, maybe just insert the expected signature for grepping:
"BUG: unable to handle kernel NULL pointer dereference"

Reviewed-by: Alison Schofield <alison.schofield@intel.com>

> 
> Fix this by skipping these ranges altogether, noting that these
> cases are considered success, such that the cleanup is still
> reached when all actually-added ranges are successfully removed.
> 
> Reviewed-by: Ben Cheatham <benjamin.cheatham@amd.com>
> Fixes: 60e93dc097f7 ("device-dax: add dis-contiguous resource support")
> Signed-off-by: Davidlohr Bueso <dave@stgolabs.net>
> ---
> Changes from v1: reword some of the changelog (Ben)
> 
>  drivers/dax/kmem.c | 6 ++++++
>  1 file changed, 6 insertions(+)
> 
> diff --git a/drivers/dax/kmem.c b/drivers/dax/kmem.c
> index c036e4d0b610..edd62e68ffb7 100644
> --- a/drivers/dax/kmem.c
> +++ b/drivers/dax/kmem.c
> @@ -227,6 +227,12 @@ static void dev_dax_kmem_remove(struct dev_dax *dev_dax)
>  		if (rc)
>  			continue;
>  
> +		/* range was never added during probe */
> +		if (!data->res[i]) {
> +			success++;
> +			continue;
> +		}
> +
>  		rc = remove_memory(range.start, range_len(&range));
>  		if (rc == 0) {
>  			remove_resource(data->res[i]);
> -- 
> 2.39.5
> 
> 
