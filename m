Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.8])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 906813D564
	for <nvdimm@lists.linux.dev>; Mon, 12 Feb 2024 17:01:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.8
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707757268; cv=fail; b=pXHAO6Hkrgk8Lqm7mB1l73w0wMWJqTYORqBT7OE3IUYfZ6IhwNLH4Z+8oLD2OmzYAXToNZbMLu1yCJeGbEqepwjp0mX6jDrLPbjWqWzW80riEIqZB7n448cawvA1g/vr56QNBJz99gCC7pFu7Y6qXkpRRqH54HvvIbSnDXgBo7I=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707757268; c=relaxed/simple;
	bh=YmxR3ULAMLky5r5NtmYBWlWrX3AvqNF5Gutn5SuHYE8=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=aE6l74FNnTtI0bbTvl/YeaJeioCb+or4GafjK2y9HZ/tyHh++SmGxjIJnED4fBVZOXSxC/MDqFGZolGLYKIuR3p3kTTmIqL1ThvpSjamo5Dpr0VBYTPunEeuPwq+F69hIAqY8CAmivnLYPJof2CymNefELBT6mzm5hjz2+YdMUA=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=bU/C0TEW; arc=fail smtp.client-ip=192.198.163.8
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="bU/C0TEW"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1707757267; x=1739293267;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=YmxR3ULAMLky5r5NtmYBWlWrX3AvqNF5Gutn5SuHYE8=;
  b=bU/C0TEW0mDcVWyLQz6UQSaft42SDh+ZPb4X1gOFB6+o9q6VrGms4uMV
   90hWAi+p1JwXQm8E26e2I8U+ubWyRX86CbGtBmb5kDyNTKkM5lJr9kcwL
   IXYA2LRmVAdP+AQqocrYSxCElaSMjbD+2CThdHYwEh3lMpwZLF5g8ZxbW
   m+4Qj9dh0oa/RU+a1tOW+/VNm+40BZJGxLRqgi5DHd2/YDjMHngj5/Xa0
   9FdcSPmZr4tN+yoPRzyYx3k1I64y8POvVzOR210q1G8AkAtu2darF7TU1
   xXaVChiZsiv9LmzUYye6HbvJg/NF/kD/HajKaJbLNSf+M25CopKAj2S7E
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10982"; a="19249414"
X-IronPort-AV: E=Sophos;i="6.06,264,1705392000"; 
   d="scan'208";a="19249414"
Received: from orviesa003.jf.intel.com ([10.64.159.143])
  by fmvoesa102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Feb 2024 09:01:06 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.06,264,1705392000"; 
   d="scan'208";a="7283164"
Received: from fmsmsx601.amr.corp.intel.com ([10.18.126.81])
  by orviesa003.jf.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 12 Feb 2024 09:01:05 -0800
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35; Mon, 12 Feb 2024 09:01:04 -0800
Received: from fmsedg602.ED.cps.intel.com (10.1.192.136) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35 via Frontend Transport; Mon, 12 Feb 2024 09:01:04 -0800
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (104.47.59.169)
 by edgegateway.intel.com (192.55.55.71) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.35; Mon, 12 Feb 2024 09:01:04 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=SLAiOJTomSB64DVUJdQSDWp1xIq0HXEgzxE3dyp8qfvQFsQRWTz9J52cnXJvYteM8LFsGFQsq/ohc+ccSIfESmGQzy8NqKDjnSAEcuyZOndjm85qJi4VxkvbE0AuIxILakWXGLM+pFcLgpS3tAmK9r6BU6K/fI8trmZX1EYaZ3eDbKDY1HCI1rLoe0jUj75HkUl53kjIrJDajzYCu2mW42Lc9e7TXZqaoTVn1YFZgVguKKRB0zPNjgmA461NZyH2FbpC2AiG6WZ2Qg9vifz7MuxVMmq3DxtBbbEgDuHcF1uCBReGNBol4V83pMyPdyIQ0GTA5RgEVwV8T0YajRPjCA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Y/WElIo9wdbEWLRFF/mk9IIqvno9S54zUZFrc2ZoqBQ=;
 b=dR48r1+zFI0x2BhJVPqG7EhniK4xaWFFh4b6Ep+17qXSn2GAQ84e1w0zwmhv87cc+coKRmylNNfAAL9SF8aLY4zNgFzIqoOXqwahuIlWW1xx19oIEKavgvC/a63qqJpB0M0XUSjgWKvcw8h26HCy69JLRAqLp7EZWH/apvTvpfNNSBHcweR5FJMI5piCL8IEGJAOvc6UbydxrJMmX5CRX0MFo+RObsWsUDCgJ0KqjZ55q77d0Sxdqmk8+6h9HyTujxJjaNSy2rHmxo4VpGI2dDS7bPfbDLguVDzQcurHTKRiinOdFTB+rlTtoMBb4a0E/SAJBlooqccEI1dHk2PeIw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from SA1PR11MB6733.namprd11.prod.outlook.com (2603:10b6:806:25c::17)
 by CO1PR11MB5105.namprd11.prod.outlook.com (2603:10b6:303:9f::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7270.35; Mon, 12 Feb
 2024 17:01:02 +0000
Received: from SA1PR11MB6733.namprd11.prod.outlook.com
 ([fe80::9f17:e1f3:d6f0:3d59]) by SA1PR11MB6733.namprd11.prod.outlook.com
 ([fe80::9f17:e1f3:d6f0:3d59%4]) with mapi id 15.20.7270.033; Mon, 12 Feb 2024
 17:01:02 +0000
Date: Mon, 12 Feb 2024 09:00:58 -0800
From: Ira Weiny <ira.weiny@intel.com>
To: Peter Robinson <pbrobinson@gmail.com>, Dan Williams
	<dan.j.williams@intel.com>, Vishal Verma <vishal.l.verma@intel.com>, "Dave
 Jiang" <dave.jiang@intel.com>, Ira Weiny <ira.weiny@intel.com>,
	<nvdimm@lists.linux.dev>
CC: Peter Robinson <pbrobinson@gmail.com>
Subject: Re: [PATCH] libnvdimm: Fix ACPI_NFIT in BLK_DEV_PMEM help
Message-ID: <65ca4eca209b0_8387e294c3@iweiny-mobl.notmuch>
References: <20240212123716.795996-1-pbrobinson@gmail.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20240212123716.795996-1-pbrobinson@gmail.com>
X-ClientProxiedBy: BYAPR05CA0088.namprd05.prod.outlook.com
 (2603:10b6:a03:e0::29) To SA1PR11MB6733.namprd11.prod.outlook.com
 (2603:10b6:806:25c::17)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SA1PR11MB6733:EE_|CO1PR11MB5105:EE_
X-MS-Office365-Filtering-Correlation-Id: 60b58908-5489-4605-cf83-08dc2bec3160
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: HnD7Cn05n1wtrECbGZuhe/xPt+U5BanKuHeo78wiH1iKCbxITPv34y1e99+LLDcSWDJnd0N3QEImxXE670vqBBdCUHjJPU1f+hF38Rc/lQHQL9Oh099nqfJmOTTYYnBeGvDC7Cg0OrdT/co7oGM0+yeSnih6jWS16mT+1aT97StuDvd1qVupvJ40OHKyoJVitjLt5Hwy7MXhSgMAkot7C95969/T1kNOSfQIukaGe8/W8aw9+GCcRGHUWIJmuESKgXppnusR9cH8KwvAR3SgaGytk8/Hsg3xjkP/303qUZJJoaA+pqkzafC1ZGonmvuiDhikbPyPtTzY9Ypjgk584DFYIqI4LLWDmSq4mOV1/UeBM9N4ibaUof9WuFKPP4bOaX1e3HPSpMziaNGNXaKcCC2S1B892MTjooaEeFxYTa8IbnulQAD8jWXAqq4i+tYUtwGL5qhgMnC4I+Aar50dprZq3YYfa0kcD5SZk1ZvvyqqOvLpGY9HGLA5iTr2j5/lAdJMfLSchVxA9yUIo4b7KaidoPVpkpBHVNBCU40qGRAXngS/efSHrzh3iOOJrgs/
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR11MB6733.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(39860400002)(376002)(366004)(346002)(136003)(396003)(230922051799003)(451199024)(1800799012)(64100799003)(186009)(41300700001)(26005)(8676002)(8936002)(478600001)(66946007)(4326008)(83380400001)(9686003)(110136005)(6666004)(66476007)(66556008)(6512007)(6506007)(316002)(6486002)(86362001)(82960400001)(38100700002)(44832011)(2906002)(5660300002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?D7aj4A0V4BXQmFlQIePKD8jr++FWV6s8e7NKWPyBGq8nin735YaaEHjtnaU2?=
 =?us-ascii?Q?Cf6E8cbGR7Ot8PMKidnNGu508+FbEBZHs0oPKAsO3P937uQ6hhLtB2OSuJKT?=
 =?us-ascii?Q?ydUU1oPp1VmU+pOI4jIXwc9sHTKFHE9AFotlmWxJq2ruImVZfr17ndqePLqA?=
 =?us-ascii?Q?owreuyoH32mSSIfoKoqbdNRtKji4zYQme3aaHEhCLlkZ/+KbuCD9fPMAWqoW?=
 =?us-ascii?Q?X9+oPDkBjm+bnUSv51kaiAjR3n6XEJ1CjvO/T9yhqvU7+aEiyIqID7igBuH4?=
 =?us-ascii?Q?zmq7y1Rn8CVwYyWoofL4XF6QPWatHOqOQSveStwltdysZTjKxbm8AaDpxKpa?=
 =?us-ascii?Q?z6c6aWqqj0kzM0HzKTkPs1P8iY4JH2sR1B2K//DIEbEf4APFotdptNtJcrsy?=
 =?us-ascii?Q?TiDwej5WBdiBKk1rAmjuO4ADN7xnRNgbRkIDEaIv1ambF63MhXLjfWBypITH?=
 =?us-ascii?Q?NTF8DD/5e2nJ2JmfshVVMunHp5DaHIJ6kLex9RdYRc9L7OmMwxa4IUchzVvA?=
 =?us-ascii?Q?7AHZ65QV+5o5z2W0oAWBZP2J1nbz5H4zPA9jh5Pz4bqPgvSjKj6fH0vd2hIg?=
 =?us-ascii?Q?ZR3Ucuc1b59/NCZ0p4ytJ9Yk3vh2cbiSiQ5wk83PPuGYMtBuVcYCZK50W+QP?=
 =?us-ascii?Q?+1NDxAi0eoNNyCfFyfrbboqd3C0YrKShwGAU2PC/oQiefe2XeUW7p7f5/FB5?=
 =?us-ascii?Q?ESV1CSo8T3YEhknoemKfhh3pn+0da+huupRlVDFbPQ0oGE8SFVqRxnzID18T?=
 =?us-ascii?Q?r0eks04mXuxsmZFzmuuwRFZawleSADMpPB+CSvKXvhlKWVV8NRz/aoixmC8Y?=
 =?us-ascii?Q?CzRs0tQUU9aO7vZKgihVu4A0iQAQ+ETAxazppIFePYEbd+BKdCpBjqkvyMNq?=
 =?us-ascii?Q?QwyLvsQpSJQ40yXpjeP2702Opf/a53ObMfOIegWhgGItsQEtdkKjIfNgT6qs?=
 =?us-ascii?Q?f9rxiJA4rln8BDvIBSkMGGv9/ywd1Ds7k/+nxMQWZBouChoSeuKCMSp6J82p?=
 =?us-ascii?Q?kslaxPv6L45dcGPNj9ZTt2/wxXDoo4BO6N31dD/KEUbtSf2wXdJO8wqjWl8P?=
 =?us-ascii?Q?Og3gpls4qYOredK8dqxMpCtYVcd7lqKxJYlyrovoq2AEF+VbtOytjL0gAu9W?=
 =?us-ascii?Q?BUvWqw8X+P4QNgGUknshuM4cdGbQlX0zUerSpyctd0hEmsnKZ9WvMka0/475?=
 =?us-ascii?Q?T8tj3MTacdBO0oexjgqEOipmM4VEorAOTnXtNTqwiDRgCJbUdcJPpsAQ3glc?=
 =?us-ascii?Q?pqnTalAIg72maA7neyvDuCpmB34v7x4v+Sz121zdJYF7wjxZ5VIrMqOZlKMz?=
 =?us-ascii?Q?FTBsP/pVxUBWZ0eTgp1W7HSr3OjjNJfUdbxOE9sN4HVO/Z82l5e/bzedUAap?=
 =?us-ascii?Q?yn73gA+RAWylffZJmM0bvuLkd4ALoAUuiomHNOq1ehIGA+GMBN8L/JTVVGIp?=
 =?us-ascii?Q?1cRR7lYmPpua3BHq2cBO7VmjjXaA7hzydFVWEDyUaoOD66CzTK+QcnYO4i+R?=
 =?us-ascii?Q?6JmK/SXTBt/gJChZlORPtTmcpyhN3kOMdMnZy0g/8YeekCidhOWSgnApy/hZ?=
 =?us-ascii?Q?1D6sxZ8WnsLZHMF+VrcQxM2j8V323zXIJc7QeZdd?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 60b58908-5489-4605-cf83-08dc2bec3160
X-MS-Exchange-CrossTenant-AuthSource: SA1PR11MB6733.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Feb 2024 17:01:02.2105
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: NXj4z8wPeMvRMdiFiSvvgdx3D6aaqcQNb31iN3msBvT3lZlGLwKdLxqhi7/0dpX23Yo17AusmABnHZGO9YDJmg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO1PR11MB5105
X-OriginatorOrg: intel.com

Peter Robinson wrote:
> The ACPI_NFIT config option is described incorrectly as the
> inverse NFIT_ACPI, which doesn't exist, so update the help
> to the actual config option.
> 
> Fixes: 18da2c9ee41a0 ("libnvdimm, pmem: move pmem to drivers/nvdimm/")

I don't think this warrants a fixes tag as this commit has been around
since 2015 and has not bothered anyone.  But the change is valid for the
next merge window.

> Signed-off-by: Peter Robinson <pbrobinson@gmail.com>
> ---
>  drivers/nvdimm/Kconfig | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/nvdimm/Kconfig b/drivers/nvdimm/Kconfig
> index 77b06d54cc62e..fde3e17c836c8 100644
> --- a/drivers/nvdimm/Kconfig
> +++ b/drivers/nvdimm/Kconfig
> @@ -24,7 +24,7 @@ config BLK_DEV_PMEM
>  	select ND_PFN if NVDIMM_PFN
>  	help
>  	  Memory ranges for PMEM are described by either an NFIT
> -	  (NVDIMM Firmware Interface Table, see CONFIG_NFIT_ACPI), a
> +	  (NVDIMM Firmware Interface Table, see CONFIG_ACPI_NFIT), a
>  	  non-standard OEM-specific E820 memory type (type-12, see
>  	  CONFIG_X86_PMEM_LEGACY), or it is manually specified by the
>  	  'memmap=nn[KMG]!ss[KMG]' kernel command line (see
> -- 
> 2.43.0
> 


