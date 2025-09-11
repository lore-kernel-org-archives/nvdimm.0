Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E44B32877DC
	for <nvdimm@lists.linux.dev>; Thu, 11 Sep 2025 16:53:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.19
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757609603; cv=fail; b=NlANSetamLd/IvooDsWotdB6hCQcGpam9uTKY2WHjWJCro1npfEDmrckvpS2FCzO3GpTK5aghSMFKMpUJz9GLM1NCKaHsk8zIbht5dTIlgyi9QErOIRb+EJ+CT8lshaC44fOVBy+cBzx7rxpwohEs4Mj1ir1yPGYAV7UU4RPDRs=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757609603; c=relaxed/simple;
	bh=qZcD+u8HkhD9P/VgdCql2LmjxQWh7/0/BOiQmxO+dQM=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=pwmPg8teObI55YZNZpbjc2VZGHu7VzjcP0jAaT/kcUl7k3jbBWmLq01UgcCivXvTmyncSvMzdq+3IOHtUBVMkaGj6nf0Cpn4wUC5E7ij7iaNyOx0uhLNlM+M49DklpR9bO7hg2z2aLHxOlUZSybcMbn64WBst/PeIU0ZMaCjvxA=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=iqXXAVQC; arc=fail smtp.client-ip=192.198.163.19
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="iqXXAVQC"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1757609600; x=1789145600;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=qZcD+u8HkhD9P/VgdCql2LmjxQWh7/0/BOiQmxO+dQM=;
  b=iqXXAVQC0m2F8ePG6cUVaNm4kUP/VB15Wm0SO8LcC5+bvOqffdXZZ7Qx
   xOobabmWPw0B6OIXBgWl7NZSfuE0q+UieCqvhSLwRH9TIbcuwoZYNJWH0
   4gVh6UCHRgoY3MWVSs7DL6wqMqvy9Rvp/LH04xqXzhJMqjwFxE82YGizk
   nvWL71pD9Q6Sptv9Wb5xlfkFhz8RyXkT39nfjwaUgiXgAPnsWjF8FzuIZ
   XI5+pVgLnjDBowQM0QROTojYRBqrU13nJL9/I3VMkQTtYxYq4S46kXGiv
   DD3qvbJFq8zXJS4T9aOIDv3roGI3quGPO+WxrLbL/5YyZPfUZCaYGWEMQ
   A==;
X-CSE-ConnectionGUID: l38Kf7/JQDuKCK7SokU7ow==
X-CSE-MsgGUID: rxQlTcCoTpOrlD88wqNjhw==
X-IronPort-AV: E=McAfee;i="6800,10657,11549"; a="58990295"
X-IronPort-AV: E=Sophos;i="6.18,257,1751266800"; 
   d="scan'208";a="58990295"
Received: from fmviesa007.fm.intel.com ([10.60.135.147])
  by fmvoesa113.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Sep 2025 09:53:20 -0700
X-CSE-ConnectionGUID: jZUV2xN8RqWObw6mRSmIBw==
X-CSE-MsgGUID: V0CVkvzHTE2R0IGFAaSFPg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.18,257,1751266800"; 
   d="scan'208";a="173306776"
Received: from fmsmsx902.amr.corp.intel.com ([10.18.126.91])
  by fmviesa007.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Sep 2025 09:53:20 -0700
Received: from FMSMSX902.amr.corp.intel.com (10.18.126.91) by
 fmsmsx902.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.17; Thu, 11 Sep 2025 09:53:20 -0700
Received: from fmsedg902.ED.cps.intel.com (10.1.192.144) by
 FMSMSX902.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.17 via Frontend Transport; Thu, 11 Sep 2025 09:53:20 -0700
Received: from NAM02-BN1-obe.outbound.protection.outlook.com (40.107.212.51)
 by edgegateway.intel.com (192.55.55.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.17; Thu, 11 Sep 2025 09:53:19 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=uLnHGQ9QA+1vKVoNdRAv8kWurikMMmEsjw98qas/BzyzidJmSRXwoeNGn6dLXNt/aAmPazkfPy8sX+KRNxypGmHV4tKdxcER7gF8SqMVfKU8+g+8iyu/tnK3ScvvNhnWzg/x9JHTE5nhxw3KKF1gM2YZhpgN4uTJLJ8T9LSWCKxNG0cpaBr/bymAEElZB5dyW/3MRRnMN+gqk+usm33KNsSOU/3KQTY6xu1FGAbYw3XD/1n4pI1y5hqmboWLaf0dqrT8BzBOSsZ3RAcD3b1YrYuyVPlD5kow2+r/Y2VV+VVM/gKpxGCN6c4wsxT6cDHxVM5T/92lZrRaRFxsUPcG4Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=moSEecPY4edqSTymH9QS5n9pfPzTt6BCid5EgMtY98Q=;
 b=FH+y6vo3BUyxnDLvudSFDMIS/t7344KxPfYc5UYBaPkVzMYkME4NlszihfH/T0/jHKrJt3TLgs25IzvzevzJrpASlEafch/msAbvzX9BdpzFhI1uRIgiUNRljOx4ZcHMNmBTKek1j72iGN0eB7+ijk1DRy1fr9MaXtMymLSMW/bwvySgi5bkSgtBEqjlPxQh+XWtfYMCsn1qS3agW/mUHBYdLQ7DTvdx/cY01cpxtomVUJsgUXwWXutc9pEQYZrkRrTCkgGflbsnjtHwByJ/juUpfwQkY3uuNxLD4s/UlBncRZ79v8scWdC8U1siNpfZad/BZ107ne+uvwEo83jA5g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DS4PPF0BAC23327.namprd11.prod.outlook.com (2603:10b6:f:fc02::9)
 by DS0PR11MB6326.namprd11.prod.outlook.com (2603:10b6:8:ce::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9094.22; Thu, 11 Sep
 2025 16:53:17 +0000
Received: from DS4PPF0BAC23327.namprd11.prod.outlook.com
 ([fe80::5a0a:3196:957e:6695]) by DS4PPF0BAC23327.namprd11.prod.outlook.com
 ([fe80::5a0a:3196:957e:6695%6]) with mapi id 15.20.9094.021; Thu, 11 Sep 2025
 16:53:17 +0000
Date: Thu, 11 Sep 2025 09:53:14 -0700
From: Alison Schofield <alison.schofield@intel.com>
To: Dave Jiang <dave.jiang@intel.com>
CC: <nvdimm@lists.linux.dev>, <linux-cxl@vger.kernel.org>
Subject: Re: [ndctl PATCH v3] test/cxl-poison.sh: test inject and clear
 poison by region offset
Message-ID: <aML-ejwrUMO355jp@aschofie-mobl2.lan>
References: <20250823025954.3161194-1-alison.schofield@intel.com>
 <1c8b14d9-adfb-4154-8d7b-a1cd28a13048@intel.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <1c8b14d9-adfb-4154-8d7b-a1cd28a13048@intel.com>
X-ClientProxiedBy: BYAPR11CA0057.namprd11.prod.outlook.com
 (2603:10b6:a03:80::34) To DS4PPF0BAC23327.namprd11.prod.outlook.com
 (2603:10b6:f:fc02::9)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS4PPF0BAC23327:EE_|DS0PR11MB6326:EE_
X-MS-Office365-Filtering-Correlation-Id: 79711733-8c99-486c-5d01-08ddf153b4d8
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|366016|1800799024;
X-Microsoft-Antispam-Message-Info: =?us-ascii?Q?etESfx74NW0o64z7jJI0h+t5pcmp7R4flU+30Sh8MstQmNn8YyJwI/PgyClB?=
 =?us-ascii?Q?Bhhf9PYbPsUak5K4qxqZ8dAD/t8ZA6QlbndFylBaOIYhT2jIGClMblezqoX8?=
 =?us-ascii?Q?3zxX2IofngjTpDYHcpboPi/7CwwtPs53AHkNILe/KCSxzyDj257dcSnfv0Ah?=
 =?us-ascii?Q?PAtzXD3gfJ4FLwlGuf6Kc1DURN33116gqG6pdKRnycOmcTEo7S4UDZNHSVBn?=
 =?us-ascii?Q?y1JkvtKjXdjWE3Ws7lspytmKqC2IkQSnulH85imLBaln84a/ijh32QK760AK?=
 =?us-ascii?Q?cWki8d4uXZm8qUbJnNci9gIlzoprDupRjEYlTVwXUgCPEC+vCBtLHzjRxdRe?=
 =?us-ascii?Q?alaFs+b/jOk2UHJMwPqSMx6K4Plv6dahgvdlpVqnCM7QVh0kr0sNmVIDezW7?=
 =?us-ascii?Q?qki+Fqh55LiCW2PkKCkUW2cO1zAEyY24RAkdhgLrDrGqGw4CRKsrDi0KcbuM?=
 =?us-ascii?Q?xCrBzk5GIkuY4H2ZqZir295Rde4S95SbeMz9n7FoREWDWyDlbtcDPVKzxAPp?=
 =?us-ascii?Q?l2kh1jl7a+NwHvreSHSUa3XYjnhPrWm2uH5nlPNgvkPsr0n9ZmsMMUgOKBH5?=
 =?us-ascii?Q?VxdAdjhSwSn5fmpuKRwxBZ3kcxUC5xOqo6dE7KlVL2n+EfoLELd8RLs00TL2?=
 =?us-ascii?Q?D+/Tkx+jTBIWBoOXYTv7kiiLgrfn7WqL3t5fU4pWKqUTZQOfN3RyjNHUFqKn?=
 =?us-ascii?Q?V3I5oRTfR4hw4OQ2pBzFiuPOBb/E4bq6qSeMDHOz1ljjQWfwGKpFxjtUxNeD?=
 =?us-ascii?Q?9duIZW4MIwgTvdO/C4t9PpV6l1CLXrQpw6UiEarpOE9WpTfWBiOL9PvXWauO?=
 =?us-ascii?Q?s7U7RrOt3zcPxXVRTuK+vL56mtMe0VjJHPYXUlrRuklahj05US2ZJclhwd0w?=
 =?us-ascii?Q?fGLM84+qtQBcXZPTs6OCyi/spvneXe3ZrHdjz6AiLsHqF1+P75uNmrMYdL2w?=
 =?us-ascii?Q?gWzqPHWVcaiyvjlhftiWztwgCnnrUa5gZFTZ7CYm8RM/gcVr7lWkSTSDA07O?=
 =?us-ascii?Q?KQPPTE9jD87sCbdfqPl56+BovM7JjqPkmg9xx19KcP5QqSFsIfCeYtXRwa03?=
 =?us-ascii?Q?ZrHYDZEnoUVl8iFaEXKBHp+CPbjmsnq4dxbILHs6FOPobX8mgXauKioTwAau?=
 =?us-ascii?Q?/+YTf9MUAS1sXylA3xdS7X39bCVhuvnxFmlN/7JSCHyJQcpBIdSHk8hJCHT7?=
 =?us-ascii?Q?3t/kZtBgBjA+II39zMAYXRVZmZsPmnO+sfrxQ4P92B88jQRWsmkxpAmlcAnc?=
 =?us-ascii?Q?wBF4xb6rHBPS2UlUBGWMfd4z4lebfEgj/weo2WStqRZX+TFlJi1YzJoJ3ozc?=
 =?us-ascii?Q?kce5Vsqk3uq6TRMX9wWI/BJBZ6x4GYtu6+DfOTUqV5DTANvVqcWuytwwxd2j?=
 =?us-ascii?Q?REBYsPnzzAQD+MIxOzEPcuEy7JtextCtbJW6Sv7Lif9v7vkxAvhRQ6tYmde/?=
 =?us-ascii?Q?OMT4cQ3QGyM=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS4PPF0BAC23327.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(366016)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?PhtXgLiEzNehNnTnv3SgaibPedWX+6rvzv2uOu0TlFCHfcZJ7lmqX+M7Uh3K?=
 =?us-ascii?Q?DEHWDK3GTnfTnqBDkRQJbJhQnfHC0ZElYA9MtHWposCRf2VIUC8XKB3OThGI?=
 =?us-ascii?Q?VW9PdYOM/o/9RGnx53WylL+ihFrKrntasbxWenooVASAEYbPkdzACxIyUNdA?=
 =?us-ascii?Q?45XjijlyjpsvDUpsm0pAx7DgcBKfB5XNZ0V+eQ/f9EMTzM8YIH0oUkzTCJ7N?=
 =?us-ascii?Q?8sfghVTSjmZaSN89t/PT+IoHVw0IJGQATTFksT3I7OQyQ3AlUMadvMJHk90C?=
 =?us-ascii?Q?Zsl2zkhgDEhsgCff+OBFpeeKonERKvbn40oYILYvecBXBIFdpmgDBPUJAqCb?=
 =?us-ascii?Q?8h41lvjKbsFVBzDxcVkVHPNWFa1EDan5fDVsRrDad3szRuT/XKN6fdQp1ZrF?=
 =?us-ascii?Q?Vvozrb5CViDanQ6VouJsDE+0pwdk1sv6VbkYn6NpBciWXuKO4/u359k/wOQL?=
 =?us-ascii?Q?607BoixGWCEstUAUcU2GAaGbDJcgXXhBNSmp6VD3Yy5+SDyBvX+hcVjbvJpj?=
 =?us-ascii?Q?uPpKSlukWdxLRxeUHfXaKiN/CA1qvr3sQUBGHddw7BXIpVXlpebrFQ3Xxl8k?=
 =?us-ascii?Q?AMDWeWGvHcBK7izCR4Ez2EtSwDxRfcTGWSB9xoNfiWwSM2X72kkSEzC14PtA?=
 =?us-ascii?Q?OdtlJ5yRITR0pI7eYqXQ5YrNd8I+b5yRiNChvx9WKqXuboBr9+7y6YWhglcZ?=
 =?us-ascii?Q?YkWH8ec1u/w/RdFVpL71vtoi/svKcmGiGdnfmN87J9hVdZd66pcuTZy0uYsN?=
 =?us-ascii?Q?2a1Jk+cJQ/E70LcA+CYPa99QKdxUm/LaU9z+TuRMhqfnlO8V+WechKvfaOSq?=
 =?us-ascii?Q?dqYwIimB1lENoPUoNI/SZ0To0wNJzQx1Q6OVpdvTiCxeIoFTpesSOjyEHwSp?=
 =?us-ascii?Q?z8KcZpr8oFmHD0WbocrcnyXDPhTeGVvIhPd7qhE5hX6AatmIXihLUKi4apVu?=
 =?us-ascii?Q?Y3IjUIu62wuGgLI8yKUjFEH+s5cz0qdk1WoQXpjYDhdoq4IFA4+C3eSo5syg?=
 =?us-ascii?Q?7/hTVU/jOl+7VHdbIFRtmu5TuDBR0izIly0S58uHCo2hNHK6yqttyGeUJhia?=
 =?us-ascii?Q?Lt5lCkrmOJnUOrd3tUqsYl8FY/wXWG3zg2tEC0Q2xF/81o4oCq4GHO8HPamS?=
 =?us-ascii?Q?3vFOR3SEIvRx8XlGWo1d4KdHRZd4c8j/TeUkjiiWDz7ItpSUctcyMtUykqJi?=
 =?us-ascii?Q?6+dHeySNptu8aQkgbVXKU+MsduljFt2TTUwVEF9hLw7wneoDMAuhEwzUWaII?=
 =?us-ascii?Q?eSWVTmo3FzBnrefSDdIS5b9I0dLCwI+Y8UYyhaja/NFYquN0jiPdB8ysi3sT?=
 =?us-ascii?Q?1TNVXXuL0s9fHvkreK6CxGkadO4UggzYBRZ2cMgTp92PHu+Xkoo+vUM6fyfw?=
 =?us-ascii?Q?Zm+m7hjx2ulAHjCKeElq3TRfEMonmEx9hC5884i/zIzR8JtL9gHyRfvtVnUR?=
 =?us-ascii?Q?HGSAJibObQQTOewJNeGC8+nC1RJ3d9bPaCKalcTujZjIinV6CWcIaCIV1GzL?=
 =?us-ascii?Q?SPZnyO8/gXNA98RO8Wp721KzotY9lDB/cG7dAC9+m0T7TLpKlL17GDxCQVfI?=
 =?us-ascii?Q?BpPn0s9RBLpMYuhz4w1FdgJEwWRA7WAdvr9Jhc1i9F62BcM4Km6jGAhniCSY?=
 =?us-ascii?Q?UQ=3D=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 79711733-8c99-486c-5d01-08ddf153b4d8
X-MS-Exchange-CrossTenant-AuthSource: DS4PPF0BAC23327.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Sep 2025 16:53:17.7784
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: X7EJB+BPuIj07Dph164qcck3qP8Gabys3kdGiGookrtXVodbbHltYymn5UWyOaBUZnFl8lTP8+bwWNBdUNkWAgfTkzXNsxDMJvko9htlXC4=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR11MB6326
X-OriginatorOrg: intel.com

On Fri, Sep 05, 2025 at 04:34:46PM -0700, Dave Jiang wrote:
> 
> 
> On 8/22/25 7:59 PM, alison.schofield@intel.com wrote:
> > From: Alison Schofield <alison.schofield@intel.com>
> > 
> > The CXL kernel driver recently added support to inject and clear
> > poison in a region by specifying an offset. Add a test case to the
> > existing cxl-poison unit test that demonstrates how to use the new
> > debugfs attributes. Use the kernel trace log to validate the round
> > trip address translations.
> > 
> > SKIP, do not fail, if the new debugfs attributes are not present.
> > 
> > See the kernel ABI documentation for usage:
> > Documentation/ABI/testing/debugfs-cxl
> > 
> > Signed-off-by: Alison Schofield <alison.schofield@intel.com>
> 
> Reviewed-by: Dave Jiang <dave.jiang@intel.com>

Thanks for the review!
Applied https://github.com/pmem/ndctl/commits/pending/

