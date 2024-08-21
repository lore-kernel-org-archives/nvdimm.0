Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6C8DB79CD
	for <nvdimm@lists.linux.dev>; Wed, 21 Aug 2024 19:01:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.11
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724266866; cv=fail; b=LjpcEF7zoN8T4lKL7Jyg9uz4Xxq2lox28GTurf4z2+s+dJszZ9XWghEaQK4Jyj3gXdz19oSOxOmOI5zOluqatw9Ov8wrIZRyiXnJRXO1O3ad5Fvak+uP9Z1obxL1n7z8tMvlNZmJyxLAZjGEvNe0pc5mkO6xcrJY7wH4I9DL3UE=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724266866; c=relaxed/simple;
	bh=qVJl/JAsdrScbVdvVNrYXhHjo2MNc5nq+61yn2/gu7Q=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=nuIAjGQSKMShwhHzN8Cg1Ku/LEw6IctHTjVO8OnriMaZzUDSn39D3aHh6kaq7MlDbx3pB+jb1nHQLSQMP6g77uulU1xxMBzk+Nj7eAwOYVW7hPEj9Q9my5/e51STlujuK9yDcaqNKA4zUFR9zcneDN0Gy6idN7XL0dLqhQdWOzY=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=SzU+TuLD; arc=fail smtp.client-ip=198.175.65.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="SzU+TuLD"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1724266862; x=1755802862;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=qVJl/JAsdrScbVdvVNrYXhHjo2MNc5nq+61yn2/gu7Q=;
  b=SzU+TuLDZJGlOehzqXW0YwlTm9LUF3BB39BO1SrC6zbWc6M3yb9/UlXN
   HsD+bbqNB5d0BrlCIc64nmHPItBp2Dyl/qxvQ8l5ZyGqYvCjelh7J4V7G
   gFsKAADkg8V/uFbC32jIBORJJBpJnDw2ROBYXHaIMf8malHmQGPWBYc+b
   1qk1WRWg8PKyVqHVCG41TwBDKv/KQKn2zx4vpeX9WB7KxTm5DITYO2Wc3
   ubrR0nVCP1M/5wT8H7ynYbmGVzHfS7vywkypw+X7FtbOdtseeH2PQc1Fs
   xSFX1kHkR4dDN/EDduntFigP+QvSL8kcnG5jqo5wqyNAqoteHxzeLUrl3
   g==;
X-CSE-ConnectionGUID: wNprSLtjQICdGqckSoDmHQ==
X-CSE-MsgGUID: 0glwkjuOSF2aV4fSJDBfpg==
X-IronPort-AV: E=McAfee;i="6700,10204,11171"; a="33217501"
X-IronPort-AV: E=Sophos;i="6.10,164,1719903600"; 
   d="scan'208";a="33217501"
Received: from fmviesa003.fm.intel.com ([10.60.135.143])
  by orvoesa103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Aug 2024 12:01:01 -0700
X-CSE-ConnectionGUID: Rqkm3WtvR1CpnxGLXZ9ggg==
X-CSE-MsgGUID: z9cryiyTT2+mkmdy6Otgig==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.10,164,1719903600"; 
   d="scan'208";a="65387966"
Received: from fmsmsx603.amr.corp.intel.com ([10.18.126.83])
  by fmviesa003.fm.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 21 Aug 2024 12:01:00 -0700
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Wed, 21 Aug 2024 12:00:59 -0700
Received: from FMSEDG603.ED.cps.intel.com (10.1.192.133) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39 via Frontend Transport; Wed, 21 Aug 2024 12:00:59 -0700
Received: from NAM02-SN1-obe.outbound.protection.outlook.com (104.47.57.40) by
 edgegateway.intel.com (192.55.55.68) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.39; Wed, 21 Aug 2024 12:00:59 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=FQ1U7+MMKGSvN0Op/msdHwxICDc3opVN/WC0ZKN5sOMyhSZ0J+nlBmc3atyj/vshvlAEADEmstWcJQvkNQl6RUrGxkopMU3nTVljVxc7cPPCv4+ODXjr7uuHC1wDG6a4bwFG/EBO4gAJFherNaRIN6qEdA7TrZTl/Ln5nNT+ELUvZ6fmzMZ82P1yHNdYF+ha128KjPMH//7qPyZnnRr0smdK0UkEpCY8iKD3kTGyWPwuGnXPN1/h0KjkdhYbME34H+zxGK8CxAXrkM9z9GI1LU0M1gko62ALoVD7xpohwuFE4yPfWvPRzDmCqsOGfQU4hbzdEFWrdk+kZFVe/g04pQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=/6XgV2tz9S0XNVXSO34tkzcfRZs5GL9f3Ip93KYSZqI=;
 b=sFXb7ZzdpXdJQhIFFe7/sXkre9Sh4GV6PFnFAG36O2pVKALFYZrrpXw47MHTgP1EtPP0OzHuFNVnPb+FZxWykoZuc97N77wRXlfOsniYe93S40DcXbFR4O3j+221/0OzE9Av4y2XE2TIjc7gTtO27HfqgYw9XlgXgy3q9f7kQRLxjJfQU1t/ci+vV4zEA5JX/QpV5pXhobb52OEcjTX/KUAOmjth/573iumShVv3spyiEaFuGjDi3zKClI9i7Rh/KbGKwFFwA6I4eaYcdtdGYEDNk7rmAyJ8lyn17Wi4HgopoCBJG3/ahJPzJD/KiBQVKk/oXSABbVZTOc4NOhm+bw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from SA1PR11MB6733.namprd11.prod.outlook.com (2603:10b6:806:25c::17)
 by DM6PR11MB4529.namprd11.prod.outlook.com (2603:10b6:5:2ae::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7897.19; Wed, 21 Aug
 2024 19:00:57 +0000
Received: from SA1PR11MB6733.namprd11.prod.outlook.com
 ([fe80::cf7d:9363:38f4:8c57]) by SA1PR11MB6733.namprd11.prod.outlook.com
 ([fe80::cf7d:9363:38f4:8c57%6]) with mapi id 15.20.7897.014; Wed, 21 Aug 2024
 19:00:57 +0000
Date: Wed, 21 Aug 2024 14:00:53 -0500
From: Ira Weiny <ira.weiny@intel.com>
To: Li Zhijian <lizhijian@fujitsu.com>, <nvdimm@lists.linux.dev>
CC: <dan.j.williams@intel.com>, <vishal.l.verma@intel.com>,
	<dave.jiang@intel.com>, <ira.weiny@intel.com>,
	<linux-kernel@vger.kernel.org>, Li Zhijian <lizhijian@fujitsu.com>
Subject: Re: [PATCH v3 2/2] nvdimm: Remove dead code for ENODEV checking in
 scan_labels()
Message-ID: <66c6396577ab9_1719d2945@iweiny-mobl.notmuch>
References: <20240819062045.1481298-1-lizhijian@fujitsu.com>
 <20240819062045.1481298-2-lizhijian@fujitsu.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20240819062045.1481298-2-lizhijian@fujitsu.com>
X-ClientProxiedBy: MW2PR16CA0064.namprd16.prod.outlook.com
 (2603:10b6:907:1::41) To SA1PR11MB6733.namprd11.prod.outlook.com
 (2603:10b6:806:25c::17)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SA1PR11MB6733:EE_|DM6PR11MB4529:EE_
X-MS-Office365-Filtering-Correlation-Id: 9397b071-0f33-4cfa-8828-08dcc21396e8
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|376014|1800799024;
X-Microsoft-Antispam-Message-Info: =?us-ascii?Q?49f9Bo1dlFjLRQULrWjznXbGeuZe7KdS2+dCC8DIc1FZvm1p7JWL+C9ekuTV?=
 =?us-ascii?Q?1lAwx0Nl9oIzGRvrgrJ6TY6T1QnlVZgn9tXbPlB5wUIh857fYrP/sv/8/iqw?=
 =?us-ascii?Q?SkI6ojwvKKy9FCXUqoGVjxi27LdmroRMnzPqlLSkpbLVvnIjrWTm1OvydNei?=
 =?us-ascii?Q?ToqD8QTgmu6KDGAut8s0bbkbKdwm+vOIKwirBMQ4VFel4eJ9PFw5R176nkag?=
 =?us-ascii?Q?3QlCTdh+kP7tuLsZW82E3OG0Ne6wwVDzXUaCngk+dzPt0okVxRkG586XA/ic?=
 =?us-ascii?Q?c0QQKOExJidJwvutkgKcK//H6aWB3rP+dvvU88zfXyfEQlqKpGuqR2aUnU9O?=
 =?us-ascii?Q?SBJQDxCAngrNRs7lY21ZxMKm1FPGUl5NklWVf/7c9rV+XYFdOzKDFTpw8OfW?=
 =?us-ascii?Q?nv6+qW9TkhltgIbqUCU0yGyBI5yykad8yd7swAEWGvjx1tUqppp57AW2PB0k?=
 =?us-ascii?Q?KFwvu1PoEh5Yx+N5xCFWlh9P+pDHEFQh+Jw/ipLwjZqk1encjHoDYwnVPVSc?=
 =?us-ascii?Q?duKIR4ckFIsCNj7CNxhzXVbV3D1YdyCRfFV9BYh4g40CYjmcj9f56gWBoMg7?=
 =?us-ascii?Q?/NcOx3tOpvbsDoYjWKeCr0PXFevh7x//IIbUGWrUJFdsBjgm/MaCW1JAe+FH?=
 =?us-ascii?Q?0cFvLeP6S+Nb6C2aouuwPWYuJ8AMdQhZMQjdgvp+x+5S96p4KuwT0F0SG2Pn?=
 =?us-ascii?Q?F47r9+5tcNcpjHZJkpby5ao9gBK3w3h5Axp+A5LVbDOdUR1BCcYsL/pG6UYN?=
 =?us-ascii?Q?DltyRJz/cZ4U4FET8y3ZMaRghZdonWZAZRp7JyqVK7P+0b1IycAJCDAlIDp1?=
 =?us-ascii?Q?U6hcCvo07+YeIt99Mmn255WS6wLuK1576X8GaOkh4j5vm5r381IJnYu3efdt?=
 =?us-ascii?Q?ZLfZv5or57Cf8iyYHOwGoBZo28WIZNxQgmN+O9r4HxfgOUzYLX9th1XhLo80?=
 =?us-ascii?Q?1VyySqKPOolRYK2mI18D/wpxjQF0/YMSwQYzOLBm/4AiH3YlxjEX4a+9By4H?=
 =?us-ascii?Q?owGF9ogwiu8IS4ZFtAYm02KaQ3L3fwW9hvHifezx2xaqbl9L9wa/7GGkEYmW?=
 =?us-ascii?Q?O7nETAI2/gr6rPiLEF5Lua7RJk5f6mnQmYeJJ9X2E6fJeE2ntC0hqhxhfevt?=
 =?us-ascii?Q?zEARP5bzJQHPfMK2TTp8ZJ44hBgM77Lc5ku9nEl2VeFqNnjLCrTMiTB77Kia?=
 =?us-ascii?Q?rd+Mm+Rd8UeH7kMGIpJkAGo1/l+A+6VDZyehAA1efGwdL974VMJii3FH9vDr?=
 =?us-ascii?Q?E8/Xhi8jWIlRcDKyt22vGDW5YgFoGtI27JpZ/wLIitsov/kPK8zdEo1jnhat?=
 =?us-ascii?Q?ALTUrKbqRyiAXSLS+RYWvp9efJrp4aoNTeOYTM485+yMpg=3D=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR11MB6733.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?UHt2nYkWfbe6kpKyyQTws/ZohJ5X/MLLQERlby/1Sh0UPXRyUQMckyQ90c4D?=
 =?us-ascii?Q?trf0B7v7epx3H5wfhqxtA9jAvChgsKh9Frf0f2KlyyobTcoZ5j/n7hBJZIYe?=
 =?us-ascii?Q?17W59ayw3OotvLOBpI59mbVzosOpGZ5Wn/SUFoAwJzVFD/PFxeRxU9i0rtIw?=
 =?us-ascii?Q?c6DaRKpj+duUp6a6obm4B4VVH+GwzSCS+QQzIPmzkAJ9ELe71hHIcz2eHxjy?=
 =?us-ascii?Q?5mOV//ssFlRb6iAQ8yj/NTNmHHnz43z92NOR9FHcM4EFs3moS3+xNvWX+ahr?=
 =?us-ascii?Q?DUEj5P8tBj12nMggYjY+Bhg6IVGLvP6PSKCIPvI1hBAg1U7+v8t95URTK/V2?=
 =?us-ascii?Q?qNv4+P/irPG9+r8IYAbzX1i/5sua6dwAwE/JRnBpU1IsMqk/mDKyRytt1yCf?=
 =?us-ascii?Q?+nqiwUzazI5Qf5P292VdkaPcwhN0gdNTetmHmAe4GaaSqMZp+ajFt44Cs10h?=
 =?us-ascii?Q?xqV+bQDafBHuFVmau6yh3auaEw3/E3yLKsW5vg17ijduFdmJn5cbZYMiyd2H?=
 =?us-ascii?Q?SHrRSZI0cNLSP4VWXiGKUrUCYyBxhEQmFHKTj/M1OtkGxlJAC8PlQPmHqYJS?=
 =?us-ascii?Q?5QDNzXJSW27g4VhfaqvljJjv1nuBxOfBVIY8rQ96wFSH4rPH+UUFeDv7zz7r?=
 =?us-ascii?Q?pxBgM1bvMeUp7R8Z7n9aUhwLh2D9k7PJHKSIVcK56x2cFmpbgxpA3LbatNEA?=
 =?us-ascii?Q?dVJYAluy3JnqidPfapzWu4qiQh6MlaXozvYZbbai/k75dSDTWnBXrSaAAj8A?=
 =?us-ascii?Q?UMGfGLMGLwuq7mu0j2vKYUnMpRlr2o+zvK1EHiPLbfqYe1iJIIufipHZRE4v?=
 =?us-ascii?Q?u5L/ln7oe5AzyO7B08JUcKjtt3/9Oon0cDzOte8k9O9EUUH7AUORDoCejQDg?=
 =?us-ascii?Q?Nqm+9vmekh021+VjqMyxYAx2T//LjjkntgSE58ievQ8B+ACmg47cu1+thYOM?=
 =?us-ascii?Q?++TzJLKs8oUI7smydR2Wthop1rV43elbzHevC/fBkm/bBMi4cT3RaY0rTnMa?=
 =?us-ascii?Q?QvIMCIFjAiBrXAI72VXM4Ty8tC75Dx9wBA+3M7Vrt3U7QRsnKVA9ZEouaFAE?=
 =?us-ascii?Q?Swhhfw0z7Yzr0hCCz8MNJM0uw+alXyMbj0MGURRjoEQml5stGYFcu2RGgejr?=
 =?us-ascii?Q?v7HlJmZEerq9/kuXg6pHbjeEc2e4hsNdnWa+zAb+HfL19eVHGa9qOz40l+0e?=
 =?us-ascii?Q?BbHaBccnVB4pbAcJAnxBzsi1up/fPN4q54DvoI50Lat0fAuBIaiwrxru9fJg?=
 =?us-ascii?Q?V1DJ1qja5QHDE8PATJN3unwHk9QP7aXjfa8/7LDXkdY8N5NVoerltdt4wuzP?=
 =?us-ascii?Q?ii9T1tP1Zk3iA0y+wwFOdQ/N36JlhcDZ2vAfH16zPJmsJGw+10QdD9WVyA4v?=
 =?us-ascii?Q?rsqqIeaAAd6/NSY7VIIUxHyw0CDkWOfw4Q95+YCq8K6nE9SPkSBnqJQuAlmd?=
 =?us-ascii?Q?vENb8cRq9Wy89/38/Xb0ZMcuYMfZmG2+HwirLoM/tR3x3UkqdWRqqGPEnjXH?=
 =?us-ascii?Q?3/j6Hzd6ROpUbVRlS5JytoLoGvKNBOO8UvHx3zYst9llD3aCopHzS9z2tknM?=
 =?us-ascii?Q?HjYKqIB69yISVHCm/T17/S+gdfpFxUoevhZ6X3e0?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 9397b071-0f33-4cfa-8828-08dcc21396e8
X-MS-Exchange-CrossTenant-AuthSource: SA1PR11MB6733.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Aug 2024 19:00:57.3400
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: yqmW9e+G2fEA9Qi9xtnbelOgtdKlTWlmh0ERUz8G6KQOiTmhFm3N5Rco3UvGIDxQcimQxa0QJ7Xbs9Q64h+Xkw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR11MB4529
X-OriginatorOrg: intel.com

Li Zhijian wrote:
> The only way create_namespace_pmem() returns an ENODEV code is if
> select_pmem_id(nd_region, &uuid) returns ENODEV when its 2nd parameter
> is a null pointer. However, this is impossible because &uuid is always
> valid.
> 
> Furthermore, create_namespace_pmem() is the only user of
> select_pmem_id(), it's safe to remove the 'return -ENODEV' branch.
> 
> Signed-off-by: Li Zhijian <lizhijian@fujitsu.com>

Reviewed-by: Ira Weiny <ira.weiny@intel.com>

> ---
> V2:
>   new patch.
>   It's found when I'm Reviewing/tracing the return values of create_namespace_pmem()
> ---
>  drivers/nvdimm/namespace_devs.c | 9 ---------
>  1 file changed, 9 deletions(-)
> 
> diff --git a/drivers/nvdimm/namespace_devs.c b/drivers/nvdimm/namespace_devs.c
> index 35d9f3cc2efa..55cfbf1e0a95 100644
> --- a/drivers/nvdimm/namespace_devs.c
> +++ b/drivers/nvdimm/namespace_devs.c
> @@ -1612,9 +1612,6 @@ static int select_pmem_id(struct nd_region *nd_region, const uuid_t *pmem_id)
>  {
>  	int i;
>  
> -	if (!pmem_id)
> -		return -ENODEV;
> -
>  	for (i = 0; i < nd_region->ndr_mappings; i++) {
>  		struct nd_mapping *nd_mapping = &nd_region->mapping[i];
>  		struct nvdimm_drvdata *ndd = to_ndd(nd_mapping);
> @@ -1790,9 +1787,6 @@ static struct device *create_namespace_pmem(struct nd_region *nd_region,
>  	case -EINVAL:
>  		dev_dbg(&nd_region->dev, "invalid label(s)\n");
>  		break;
> -	case -ENODEV:
> -		dev_dbg(&nd_region->dev, "label not found\n");
> -		break;
>  	default:
>  		dev_dbg(&nd_region->dev, "unexpected err: %d\n", rc);
>  		break;
> @@ -1980,9 +1974,6 @@ static struct device **scan_labels(struct nd_region *nd_region)
>  			case -EAGAIN:
>  				/* skip invalid labels */
>  				continue;
> -			case -ENODEV:
> -				/* fallthrough to seed creation */
> -				break;
>  			default:
>  				goto err;
>  			}
> -- 
> 2.29.2
> 


