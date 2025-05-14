Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.8])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4D7A435968
	for <nvdimm@lists.linux.dev>; Wed, 14 May 2025 00:51:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.8
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747183873; cv=fail; b=etq3y1S1fypPc/gFmABw8m+X+lGVHtHD1BezFpn/2udiKHXyEjFwPDfSdMqwOvgUN8QvYg4UXJ0a2kwTwLh2HCQz7QbsgraqP5oU03yG/NMWKhcZmlMHsGaV1MsdecOhXxg8mNLCdCJq9ce+cA07/1GilRxEgIK1HnM+lTBXpOY=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747183873; c=relaxed/simple;
	bh=poWlzAxeKU0KEhJ0MK2y69NDcJB+Wm3E4BPKSwuSJqw=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=LNx8RjDMrisQQNANFwxo5XqmIXcKraHCMgescWvR2CiIRfNDLMs6EKeuVNKV+hKszo3T7MqWFkxgGttE1KsF5YmOKz19Tl7Fyv0UYx1c6/zDlxlQIBmPra5eHoA7/IBKdJm7aw9WsT/G1rFvBFYABeuEECpmPSvuZg+krYhadQ8=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=cajsrVnW; arc=fail smtp.client-ip=192.198.163.8
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="cajsrVnW"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1747183871; x=1778719871;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=poWlzAxeKU0KEhJ0MK2y69NDcJB+Wm3E4BPKSwuSJqw=;
  b=cajsrVnWBi1AvpRDe9/17LLriOmEw18KYG0yRE7XaU0w2+iK/wIdLD75
   eSNjLcYxuPvZitAYBB7ziyDcdb0Z3uGeRp1r7ajBuGgD+Zo0K71vUmRrt
   MB8PhLfsXqS3Q7SXuQjsWDW+h4wo4HRby0HN7ngnjFl2Bf62dMUhunJbH
   Oj27TA57fVbMIrFf3UaSFz92+Pis6bFnRvRnA7fRhqxc1aA3kV2sms/N3
   J88pUDr7zSd7B8hy/B8QiuaMWvmIX+fm38j9h2uRexcSgIy+YzA+977UY
   M4bOREvmkk0X+hW+6jG3DdYxJ3UZR02xd/BYvliYcv28UzCZ4l+e3PEO7
   g==;
X-CSE-ConnectionGUID: 0dMpgNzuRY6r+0RwfXvMTw==
X-CSE-MsgGUID: DLwjLJweSDSyJzkhaBwCxg==
X-IronPort-AV: E=McAfee;i="6700,10204,11432"; a="66608614"
X-IronPort-AV: E=Sophos;i="6.15,286,1739865600"; 
   d="scan'208";a="66608614"
Received: from orviesa008.jf.intel.com ([10.64.159.148])
  by fmvoesa102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 May 2025 17:51:10 -0700
X-CSE-ConnectionGUID: 8WHEEapxS9W1XNSQG+MYXw==
X-CSE-MsgGUID: sGVW4Tw8Q061AZ6hz4EPNw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.15,286,1739865600"; 
   d="scan'208";a="138796621"
Received: from orsmsx901.amr.corp.intel.com ([10.22.229.23])
  by orviesa008.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 May 2025 17:51:10 -0700
Received: from ORSMSX901.amr.corp.intel.com (10.22.229.23) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.14; Tue, 13 May 2025 17:51:10 -0700
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.14 via Frontend Transport; Tue, 13 May 2025 17:51:10 -0700
Received: from NAM04-BN8-obe.outbound.protection.outlook.com (104.47.74.45) by
 edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.44; Tue, 13 May 2025 17:51:08 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=EKdxxaKBBC1K9MEgkD51P1r24GJ7znMujWM5DdHNHTDCckNZh3/Svlt0C088OjeZoRYVetYzS+G0zcVTM6FJkeozLQRoZfdHJlQ0vh75zAzcFb9DsvSd1Dv5102lAap4qetyA/p7Fslkcg+kQSVKTZNkt5JXSbwELLVWlGEU9me3dYqEyCoTAZUyYj1Du68ns72bgRYR6CaPXRPigizegAOoi7fmmyKlWFwFskz4bgoHiXDGkDMieqjL6cZd588uymlXnZs57/rKte1p2yUhj3ILt4XwUvCkmLD/b7tvmzcdS4kZ80H2tXSFGmBG74j8mPrK0sE3wXB7YG/ZBgz6/w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=5LUC1RHGqYM0PKcFp5RT71Eto8YVW04BPJ3Go5GxQ9s=;
 b=CnQhedpUk0FZUo/PlCML45o2oFQdeR07JejXxC8/3FkNQx3F38mdfblQanXAAGMRgts+2ZDKcwT4qzD/+qa5fJ5gadzljX6LdLrm8Iz/Osnx+utBx4eYKGYvKO/YtVkZxqS/IGjaMBds/mHzWsyHPLykXzvFLj2VZJRDWk/p47mN1u2N+DaOgirf7/xC1bcirOfr8Z+1x/cJKr2f+k47VTxPX54ejNEEhyF4qj2vgBaQMiWeZLdYMqmw2vGACjbwi2FSe4kU6KZkD4xgvgHOL4g/j4rOrTfT4OT+k1ns57xolGCnC0JodSRVnPEh9iPOXG8bOiy67yEscYjMg5QQ2Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from SA1PR11MB8794.namprd11.prod.outlook.com (2603:10b6:806:46a::5)
 by DS7PR11MB5992.namprd11.prod.outlook.com (2603:10b6:8:73::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8722.29; Wed, 14 May
 2025 00:50:37 +0000
Received: from SA1PR11MB8794.namprd11.prod.outlook.com
 ([fe80::a3d4:9d67:2f5d:6720]) by SA1PR11MB8794.namprd11.prod.outlook.com
 ([fe80::a3d4:9d67:2f5d:6720%5]) with mapi id 15.20.8722.027; Wed, 14 May 2025
 00:50:36 +0000
Date: Tue, 13 May 2025 17:50:33 -0700
From: Alison Schofield <alison.schofield@intel.com>
To: Dave Jiang <dave.jiang@intel.com>
CC: <linux-cxl@vger.kernel.org>, <nvdimm@lists.linux.dev>, Vishal Verma
	<vishal.l.verma@intel.com>
Subject: Re: [NDCTL PATCH v2] cxl: Change cxl-topology.sh assumption on host
 bridge validation
Message-ID: <aCPo2Q0v5oF-Ne0I@aschofie-mobl2.lan>
References: <20250508204419.3227297-1-dave.jiang@intel.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20250508204419.3227297-1-dave.jiang@intel.com>
X-ClientProxiedBy: BYAPR11CA0106.namprd11.prod.outlook.com
 (2603:10b6:a03:f4::47) To SA1PR11MB8794.namprd11.prod.outlook.com
 (2603:10b6:806:46a::5)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SA1PR11MB8794:EE_|DS7PR11MB5992:EE_
X-MS-Office365-Filtering-Correlation-Id: 0e2a8420-f385-48be-1a83-08dd9281570b
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|1800799024|376014;
X-Microsoft-Antispam-Message-Info: =?us-ascii?Q?Pb+iscE3mi8VgfCBofEWEjCzHrXeZ3mtyxnZH00MIOXg9B0d3SGX0ll0rbys?=
 =?us-ascii?Q?kmb9Ug8HlSFBGvMjCzXkG32fh5B1OEmYLo5B+HcTUXskHxBlNsXebusaJ1Jk?=
 =?us-ascii?Q?EVfqO7oHbePZ2vVo+3O1Xh2VTMWAvRWt0sQohSx4P9velD3KHhYg5Zue1Ovl?=
 =?us-ascii?Q?Ii+EZsfx4fCtLU4ydkfcaozmNxn8PDmpVDQgNqvbz/vLbUM0lTS5SSt/lBtS?=
 =?us-ascii?Q?icFP90Uk2bRWLRQtM+OFiKjmpJjscOhgI7S+byN/CmgGqve8N1Mc0R1r7uFP?=
 =?us-ascii?Q?dyKr9Hg3Rl4wHAlXgGJuCOUglBqR1jft2IF8Y4LN5UHV0TAIDJnJKcNl0SmB?=
 =?us-ascii?Q?L/Zn/7h6bt4nCLLtD75gDVdDQlR9gW7bf7JqPLhQm3bapHF6hZmtgc6riu4Q?=
 =?us-ascii?Q?VHbR3myDlRKK/RpuP+7NZlITLuqtfkb2t/M2ydxd1JJyTOelhkuMHDKphmIr?=
 =?us-ascii?Q?TR2+Yk0fB47LpDsJRtHYnUoMKF3k+DXtahxE4CTUNTZDU7KekYgUjJrwt2rd?=
 =?us-ascii?Q?YttJiYIA7jRobfVe99GQOqXZfrD8bkZsfdGAOPajJ9Db1ojALTsMmzFlEsNP?=
 =?us-ascii?Q?iph6YYJYW2ktyOhLXQacdF2NzAp57aTIBoOZNs3xt5OvtlSKNYb3fL+Y1CsD?=
 =?us-ascii?Q?VkHCwqUsb5D4qTJZIUcAsP+/l9Fp4PwOq/I9jwjQ23p7WspOUsw38V3uyv9e?=
 =?us-ascii?Q?dHc0S9Y5Yl1MRDhWOO4WPtxyllER0wyIqM8Sp2uo2n0dLhwsCHMmmVPaQvD0?=
 =?us-ascii?Q?ld+FBSYw4zWAw5n+WidWrbWaQiEOA7ZfHSASh982iM86tL+xpnkJ7QPAwral?=
 =?us-ascii?Q?omj2ylZGfsvMyySgcr9qJgpkX580N/y22dYwYQebeiKdokkOUvSN9zdLvvPg?=
 =?us-ascii?Q?mpqZv8p1De8YseYV/R/GqkwEVScO4E9ZZQhP7ZP4IFQdxZVLUrcWWf2BfHGq?=
 =?us-ascii?Q?BeDD4OKQRjq8OpEj9CkLqipzTJ0a9pk677z8/Ezh7Lgm6seRpr5CqIpLQxsZ?=
 =?us-ascii?Q?S/NlMR40v693tE9aeiT3xS2uMsEmTwW+fIF/xDlsBS6fJVokolBI7LKcXYBT?=
 =?us-ascii?Q?IEeQ/eZEi82jDoqb52foTjvL8sKYAI5HkW2zpE7SSyZJDYT8W8JiwR/G7/PB?=
 =?us-ascii?Q?m76ZovLEBOsb4rsnPQIY/uWNynv9F/Q4GQg+nfEldbTwHZ+PI11nmHomiQ3t?=
 =?us-ascii?Q?gm1X94XfBPfPZHPeS2jxWDWo80NgCdR5uoZ0QUDtTAgK9limejgYsIHdfz8b?=
 =?us-ascii?Q?A8eR3lkqKXazXV4Xjz+X1W+h7rReN7niqkK7aNeZcZX1OE9Gk+/tcsNxCfYK?=
 =?us-ascii?Q?7VPbntVH6uN0EiRN6rP2wCPofYlrw8CkgCXXyra0gi+BacMbfdFHOiy/QHWI?=
 =?us-ascii?Q?ls19TtG/Z65JKKOKCfEaVKyxBb4uIN8PZctDKoGXyUXavHxA7mI8lTXCdbJ5?=
 =?us-ascii?Q?LKSQU/jg700=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR11MB8794.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?oi0DB1Ezjmdzmwglg8oGm/XrOPC/cWkeTdH7sN6Xt3bZ5l84QYozObxwH9in?=
 =?us-ascii?Q?5QWkwa6xWdasDUcaKaJ+VgFAKwVDsFDaz2encdQFgtF8xS87egxpkAx3C1p6?=
 =?us-ascii?Q?uKyDsIEg6hSrscauIuFVgEAElIvh6WMmLK5JDIXdEZHE/cKfY17lZc8R0Me2?=
 =?us-ascii?Q?/w5R0iVGRZuqVQ+v7n+jj+mRcvaWk2invRipL2cTtqkwL31RDgeQLGn1Eu53?=
 =?us-ascii?Q?UGHY/VSeIo7nSVo8Kf0PGj0iUOAf/Bye0u6GeIaumx9Qeo98pWcdWqCmw5bP?=
 =?us-ascii?Q?iTVVLHtu+5oDzx3cJ/fSCMC4xh0V9QllOC2O5K5HvYotpMqvoVKQzwBb4lpL?=
 =?us-ascii?Q?CXG8oZMOYYkX5+4rp+0OYtvuJ57qUN7gB+y4eJzchWJtajXjdL8zrHNuwwst?=
 =?us-ascii?Q?Nor56Yr7TzOGZzZ235dd/Val+Hu3frc/SCx1PRKNK0zMCK2X0uzNnjyxAQXT?=
 =?us-ascii?Q?Ee3SSCluudt7cT/3wte7aTnOSYSzL9+5iRCKqY+6WaTqvRqxrzRj0hMjgM3K?=
 =?us-ascii?Q?2pw6DAUUUvuMubnkjHK48ZikURO/EVi51NK5XreGRRMRZnDockdMF0ldVr8F?=
 =?us-ascii?Q?M7qqJgkGHMYReXWRko7UBsWLLBNCRqiqQDoE1Qw/r9zuMnCbOHDsLNiUCdii?=
 =?us-ascii?Q?LLem6pPi7/K3ZbUZ3OhYSWyVQyxe6mGxrjXI43bLWLi2rXEMQH7vvldfJp82?=
 =?us-ascii?Q?Efdj8C5DO/K/pq1mQN+z6WzHmbRyaAnW0Rrq9mfSShO4k+XowISkBtDZ/t0K?=
 =?us-ascii?Q?vYmJxArGqbIX8zgdcURlIgFIQHdTDuHbdmxdUEwksn9Bke8k51oUQZ8G9Cdg?=
 =?us-ascii?Q?oahI1+67L+0eChhmz8wvziY0UHYFUAi3goggxzaPqCXK3s6U03m/b9JKgt2O?=
 =?us-ascii?Q?hht9DyQFeRQ2v1/c2GxqXlbzMt50+bJxlD/PcNw6QH/ZW6JvtGFsZoXSV3nf?=
 =?us-ascii?Q?29uiWoH/i/xLyJCapayuDDEqLNk9KF7o4+CFwdfJvFymfAwwYYjpxSdt0Ef/?=
 =?us-ascii?Q?s5hFFPyKMBqE2jNZ82gQqKJilhXE3cu1jnj4Tsjp9prfx3hyu+uE4dDMcZq/?=
 =?us-ascii?Q?rzk215NVtYQQB39k06r9X//74BoMhEOYKPQ5lbcDCLNqRGDyqLm2L6ozxkPH?=
 =?us-ascii?Q?rrOClITQ8dm9qjI5VEnZopW2ulbQ4a/yVsnEqT+THRgPsnimYJWUolCEwoKs?=
 =?us-ascii?Q?S/9CNHp5M3OfRLhtd3i7dHWfk1rYPyo0TPdO9agrn2/ViynWmcs6bkA+Gdqc?=
 =?us-ascii?Q?tsG58RH0RY1DfUlL3aD1UR62ervjN5vUCl+NONA8J5fdBghE31PQAA+MujGa?=
 =?us-ascii?Q?/BAlPmRtLxFDhhEynSguijyeDDfnEfByoIkd61MyAxKkrxGNq9Q4tyKueTp2?=
 =?us-ascii?Q?4AJ7fErw6Ao2knbfO71WENqMwAnXX6BsUAMa3IJsckY2Kieh6uBTdn4hDQYZ?=
 =?us-ascii?Q?Pb6+gZo4Jo3F4ZVbz9OAKrn2QzG5iu+GgOGMRhdicoZ1oaLY+o/6JdPZlBW+?=
 =?us-ascii?Q?izp1XOIApTLfQ641XmN5oGQ7pVt0/ppgInQ01I1EBDi1fB2svLkN0II74bh0?=
 =?us-ascii?Q?+nS1vto+0AaFrwFdYnoXjWu4jJJR4zfZC3FO+U8huR5hbEWCx4SEOIUxrFdM?=
 =?us-ascii?Q?lg=3D=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 0e2a8420-f385-48be-1a83-08dd9281570b
X-MS-Exchange-CrossTenant-AuthSource: SA1PR11MB8794.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 May 2025 00:50:36.8388
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: wupCee5rSCirWUxLFOZTl5bnrsovkXqguIJunXA2jYUZ4OfgxE7ZT6f6c3dpW9PGM5qOzCXHLLJlO1jInMw2afpqvReHAnmxqAXNz7tnKBk=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR11MB5992
X-OriginatorOrg: intel.com

On Thu, May 08, 2025 at 01:44:19PM -0700, Dave Jiang wrote:
> Current host bridge validation in cxl-topology.sh assumes that the
> decoder enumeration is in order and therefore the port numbers can
> be used as a sorting key. With delayed port enumeration, this
> assumption is no longer true. Change the sorting to by number
> of children ports for each host bridge as the test code expects
> the first 2 host bridges to have 2 children and the third to only
> have 1.
> 
> Signed-off-by: Dave Jiang <dave.jiang@intel.com>
> Signed-off-by: Vishal Verma <vishal.l.verma@intel.com>

Applied to pending, thanks!
https://github.com/pmem/ndctl/tree/pending


> ---
> v2:
> - Merged Vishal's suggestion
> 
>  test/cxl-topology.sh | 31 +++++++++++++++++++++++++++----
>  1 file changed, 27 insertions(+), 4 deletions(-)
> 
> diff --git a/test/cxl-topology.sh b/test/cxl-topology.sh
> index 90b9c98273db..49e919a187af 100644
> --- a/test/cxl-topology.sh
> +++ b/test/cxl-topology.sh
> @@ -37,15 +37,37 @@ root=$(jq -r ".[] | .bus" <<< $json)
>  
>  
>  # validate 2 or 3 host bridges under a root port
> -port_sort="sort_by(.port | .[4:] | tonumber)"
>  json=$($CXL list -b cxl_test -BP)
>  count=$(jq ".[] | .[\"ports:$root\"] | length" <<< $json)
>  ((count == 2)) || ((count == 3)) || err "$LINENO"
>  bridges=$count
>  
> -bridge[0]=$(jq -r ".[] | .[\"ports:$root\"] | $port_sort | .[0].port" <<< $json)
> -bridge[1]=$(jq -r ".[] | .[\"ports:$root\"] | $port_sort | .[1].port" <<< $json)
> -((bridges > 2)) && bridge[2]=$(jq -r ".[] | .[\"ports:$root\"] | $port_sort | .[2].port" <<< $json)
> +bridge_filter()
> +{
> +	local br_num="$1"
> +
> +	jq -r \
> +		--arg key "$root" \
> +		--argjson br_num "$br_num" \
> +		'.[] |
> +		  select(has("ports:" + $key)) |
> +		  .["ports:" + $key] |
> +		  map(
> +		    {
> +		      full: .,
> +		      length: (.["ports:" + .port] | length)
> +		    }
> +		  ) |
> +		  sort_by(-.length) |
> +		  map(.full) |
> +		  .[$br_num].port'
> +}
> +
> +# $count has already been sanitized for acceptable values, so
> +# just collect $count bridges here.
> +for i in $(seq 0 $((count - 1))); do
> +	bridge[$i]="$(bridge_filter "$i" <<< "$json")"
> +done
>  
>  # validate root ports per host bridge
>  check_host_bridge()
> @@ -64,6 +86,7 @@ json=$($CXL list -b cxl_test -P -p ${bridge[0]})
>  count=$(jq ".[] | .[\"ports:${bridge[0]}\"] | length" <<< $json)
>  ((count == 2)) || err "$LINENO"
>  
> +port_sort="sort_by(.port | .[4:] | tonumber)"
>  switch[0]=$(jq -r ".[] | .[\"ports:${bridge[0]}\"] | $port_sort | .[0].host" <<< $json)
>  switch[1]=$(jq -r ".[] | .[\"ports:${bridge[0]}\"] | $port_sort | .[1].host" <<< $json)
>  
> 
> base-commit: 01eeaf2954b2c3ff52622d62fdae1c18cd15ab66
> -- 
> 2.49.0
> 
> 
