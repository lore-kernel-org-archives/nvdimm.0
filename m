Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.17])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AA5491779B1;
	Mon, 19 Aug 2024 21:56:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.17
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724104591; cv=fail; b=sqVimVMoyx5hZVsQNKF1RFYXESBBrhU4S6n+sThtIcezGX24qKExUwbGD+s0cixESnFdba07jdNUNmLkUDVpmoS+brb3Sf2y5zWqOdwMgUYOpKZpWk/LxwCWl8MLcX6Pw6C8oU+L36DkdfQGdsL+Dp2Ss8xWZp9nk+EsxdVlkk4=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724104591; c=relaxed/simple;
	bh=P0KsMOg8zrDsCBw2rzaqvdN4tGZ2jyl4IuSucwjmLIE=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=q7rTz7JCAnU3wUUQ4/SY7DI+8kwiziiYkQN51WBwTH0UzQV6XUlyYU1OYq+26pXQqOPNGBXUqW5WrX3j7ae2zIPu3s/XdJiZcJNtpc9n0GuOsno3eZo6fUc9TxW1hdX02dVQ+r5e2YxlY33S+wOamDVm9RlHv85EacC5/qqdw/M=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=dtW/jlKx; arc=fail smtp.client-ip=192.198.163.17
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="dtW/jlKx"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1724104590; x=1755640590;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=P0KsMOg8zrDsCBw2rzaqvdN4tGZ2jyl4IuSucwjmLIE=;
  b=dtW/jlKxmygvH7OZxyifmMj2jjIo3hatxateOdxHzN6ugO2Mg/C1fiCs
   62N6pYxSYhw/8oeN2j4KwG8tilD5qYGymTe6K0w4/+Fos33JVDqIhMjeq
   BOK6o4yGvqKmxVjlBZ1mAfENu6ilAwg4pkGeZs3p1gvx4VeBOB2CF1Awy
   C2G84rd4z7VQ/CIpzvKSS4sliGAFCVBP+AoU/mLZyFxFubVZ6M44ePotF
   +4auTVEzrhMd3lltmZH6V0N7tNf8j1Y9qpRh4ppn6M8WSozRBIhMgfa6e
   u4XYSEbFpkdUVBMJYL1Pq05NZk0oYpkd8AuHjkxqekf7e2H78n2E7pdUk
   Q==;
X-CSE-ConnectionGUID: Z1U1Icf3RwylW9S5c7nkFg==
X-CSE-MsgGUID: lNlXNK2FRJeG8zwgXD6WkQ==
X-IronPort-AV: E=McAfee;i="6700,10204,11169"; a="22259818"
X-IronPort-AV: E=Sophos;i="6.10,160,1719903600"; 
   d="scan'208";a="22259818"
Received: from fmviesa007.fm.intel.com ([10.60.135.147])
  by fmvoesa111.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Aug 2024 14:56:29 -0700
X-CSE-ConnectionGUID: fUMU236qRg2f/cbzS5eimg==
X-CSE-MsgGUID: QR/efbjbQ9CIuFwFenRDgg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.10,160,1719903600"; 
   d="scan'208";a="60206339"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by fmviesa007.fm.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 19 Aug 2024 14:56:29 -0700
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Mon, 19 Aug 2024 14:56:28 -0700
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Mon, 19 Aug 2024 14:56:28 -0700
Received: from ORSEDG601.ED.cps.intel.com (10.7.248.6) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39 via Frontend Transport; Mon, 19 Aug 2024 14:56:28 -0700
Received: from NAM04-MW2-obe.outbound.protection.outlook.com (104.47.73.168)
 by edgegateway.intel.com (134.134.137.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.39; Mon, 19 Aug 2024 14:56:28 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=ez7ZmMTvU8sTIM2LSadfuUc3qMkV60jE3lUxCpRrJwYVgHw54xpYNCKOAglHZgslfRbISoKfZ9ImGlC/qt1Pvsdlc0XjkP5DTXEcVHdkRPjMPVw58Te0Ct1XZqLCIpuLihp/mgWG91TU+V2VM6D+9+VlD35f9SWuo9S6kNqWmGOLE/bofG6QquRX1s7WebA2E9rBmdS8VFGntN+aPPkYaDebzKIiSJKUP68gmYwCrQDeN1tY4lXXMDEV6nseBRG1MZoJJAlLJchmdHg27c11dJRt0xXZDX4EUExR/j2X+PMndRDWYrcWR+wDdPALLOrs7ihKRr2cwwShiYK8W7myxw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=wSvb50Bsu/Q/NHBFTTXqYWvtKAfHs056eA1TYpbd5zk=;
 b=HbZw2Uo4G3XXOJOxgmyOxM2fzhC71kRLruFqiGXExJcYlyBXZSrN7x/tEfFiGAgSdzoZ0ZmjSWkV9nHRjmZTSvHcORVr1u3Jg6GC52Ovc5fHeVwUvMYOJWbADa3y4AN8PDAztryBAjQ7ZSa33uyS0/PJKF68HP8/ccVYuUJTXOAvNs4wK9PY2Dl7FEFsKTETDjNJsIiMWgYpX5aJ71Bixb4ZgoBAj7e2YBwabbE4Wddc9+YNpvXmIrLbjwP4/KwDDQdMS7HtT0ZkBPa4L75aFupyq9M1nl+CVu7NU13SRv+nu/buJkqs2xjqPUKtJ7IC49Y8FxDki5ideu9te6UoMA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from SA1PR11MB6733.namprd11.prod.outlook.com (2603:10b6:806:25c::17)
 by SJ0PR11MB4782.namprd11.prod.outlook.com (2603:10b6:a03:2df::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7875.21; Mon, 19 Aug
 2024 21:56:25 +0000
Received: from SA1PR11MB6733.namprd11.prod.outlook.com
 ([fe80::cf7d:9363:38f4:8c57]) by SA1PR11MB6733.namprd11.prod.outlook.com
 ([fe80::cf7d:9363:38f4:8c57%6]) with mapi id 15.20.7875.019; Mon, 19 Aug 2024
 21:56:25 +0000
Date: Mon, 19 Aug 2024 16:56:21 -0500
From: Ira Weiny <ira.weiny@intel.com>
To: Philip Chen <philipchen@chromium.org>, Pankaj Gupta
	<pankaj.gupta.linux@gmail.com>, Dan Williams <dan.j.williams@intel.com>,
	Vishal Verma <vishal.l.verma@intel.com>, Dave Jiang <dave.jiang@intel.com>,
	Ira Weiny <ira.weiny@intel.com>
CC: <virtualization@lists.linux.dev>, <nvdimm@lists.linux.dev>,
	<linux-kernel@vger.kernel.org>, Philip Chen <philipchen@chromium.org>
Subject: Re: [PATCH] virtio_pmem: Check device status before requesting flush
Message-ID: <66c3bf85b52e3_2ddc242941@iweiny-mobl.notmuch>
References: <20240815005704.2331005-1-philipchen@chromium.org>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20240815005704.2331005-1-philipchen@chromium.org>
X-ClientProxiedBy: MW4PR03CA0155.namprd03.prod.outlook.com
 (2603:10b6:303:8d::10) To SA1PR11MB6733.namprd11.prod.outlook.com
 (2603:10b6:806:25c::17)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SA1PR11MB6733:EE_|SJ0PR11MB4782:EE_
X-MS-Office365-Filtering-Correlation-Id: 8144637a-42d4-4849-f4a2-08dcc099c575
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|1800799024|366016;
X-Microsoft-Antispam-Message-Info: =?us-ascii?Q?N/BhCdIPEcSU537gudX+X8/Ili9XMk6hffbmZvgvzpuIMC1uj0eRAvWLxSRI?=
 =?us-ascii?Q?3fNb3J/HbKtQU1e7x4x3nNv8fIc4eS+Ptr9wfnbqFdLZ9LxA21erupw4vCMZ?=
 =?us-ascii?Q?x1ujCZ7QFBwqrHo9eozrQiaJD00gWH1eTk54DLg9kh5GaSZaeyJeMr8enZ8t?=
 =?us-ascii?Q?GJAj+3PqKaownCU9Q3UXqYTqlfHx95XMu1o0KXmkPBf4hPuAFjZPDN+KIvzw?=
 =?us-ascii?Q?StYNu24iJYR/QnQIEXjI7DnASZK8s5bL518iHs4sIQSYamqsUuvpTYVODLMP?=
 =?us-ascii?Q?V0nIqyTFiJ/7SQJr+SctX/XzuoYA02NWPmQjhefPvRat85Ne3sQSVVSbspLu?=
 =?us-ascii?Q?Q+VQqbjT8n4Fr9UGdd/HC/yMZFdM0qMPWMISRGuk8ZRm2QbreOuOxBFGQDt0?=
 =?us-ascii?Q?TyATtLA0MvgA/vIXpLLW6iiQbLE+Z5SRcDcsUHM0I04kW+YBpre7DDY8bkuP?=
 =?us-ascii?Q?k0E/h1tpfGWOvc0fxfp+NYkSKRwooTv/JiVW9MGDSh0237LR1nMbotX+ldFH?=
 =?us-ascii?Q?yUAoNE6gR4qbWwXXHVyGnzn7NkkIrQApPWiB2HMo8XYQ0xQqEZ7qf9Kze4XF?=
 =?us-ascii?Q?ydxT36MvbrSL8h11Mscj/Yr1oJcQc7Q+WrJQdrT8GnXQJTsPeQeeEkPV3YYt?=
 =?us-ascii?Q?HH1m5NWehasLlHI6833Sbh7fJlqXEwln2jVgj3grAlBqw9H+R4bfyY0Z4vWF?=
 =?us-ascii?Q?zFlDH8NLaV9WayBH15i8Qp9NE5a2j4r13wY8oMiGrU5j4ZlDS6lCVkzFCbN+?=
 =?us-ascii?Q?wS2uD2amT0ddUAoXmY5ZZlGfdcL61H/WnoBRXssn+EbCVG84UCaj4LA6doU5?=
 =?us-ascii?Q?DumAGHjR0R/7QhJxSLST552/W9eef/GzPv3AlC4A/T0WXeScpHflY81YCcuD?=
 =?us-ascii?Q?MSDr4VHrVTBUDvcZ2SO82PvBQKAmsLp5jy246lTyPKy93RXMKbWSnhyxK0rW?=
 =?us-ascii?Q?t6c3nhzgwJQJqAUkFdKbnYxVGjB3/E6Jnah5lev2IbJZdCBtIB5LCz7Fn12B?=
 =?us-ascii?Q?qq2fFQ39tL81jOVT4fyK2o66HxT7c5biVosADk/MzGD8dMuNSLH3bm866qB4?=
 =?us-ascii?Q?hrkFlj4A9+m8Db7eWSP7Su02hHtOBDThEPkIwXvbQsE3923bCHK/t2kPAThl?=
 =?us-ascii?Q?GjRhfw9Q8OfC/s0QEOPtkwCWc8S5PzvRxaDqEGA+BfFfWXOlCfOYzu5OOYdZ?=
 =?us-ascii?Q?NUCaz7J1uOKZKOF6rhJa5PYzhmdnbeP1clB/HgUsKDkXhydF7ZSRFUCkp3Ni?=
 =?us-ascii?Q?6FOUGpGMmv+IND3eKWb54uSRODo1Rh4NiUICTmNNJEg9z/nX6J+R6BdJUZS9?=
 =?us-ascii?Q?Wrt/kKjYALczk79QdGvLBw2tfDadsbq+2+tDxPSN3dSYAQ=3D=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR11MB6733.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(1800799024)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?iY3b+/mtlA6DF1MaulebSM2+jNNondA75nsUDX4qMVfP3INsixsvMZs7EEnP?=
 =?us-ascii?Q?ObVkedsXXh2Zl0i+vGlr6I6a5GLvnQFFd3L6bss+YSsW0RDzGnfgDTjAi8qY?=
 =?us-ascii?Q?8vRoZWSUXt2JPkS2+3LqEYtQaTaJ/wglZ41BqrAy8NLMAwVocVNe1Rd51gv8?=
 =?us-ascii?Q?9fkacdIy8Q+RE2VUxXBcThwSw3ur5tRLp9orHcRVH6h9QKfUDdyhpSTqAzuo?=
 =?us-ascii?Q?7VpIdmI5LN5jwikjj4odgDV+Lc4KDoT1dDLMS0Q8BPNAwbPNQRXFfgJlnVMx?=
 =?us-ascii?Q?kBya8DyVaCy8W56V7MJJn+tkKWIW4tj9brIJrg/sulCkjcOp/emfooqQ/V73?=
 =?us-ascii?Q?z+5EekZWIsV8oQiVSEgSAPwev4RG0JF8qK6J5bG0kOADeWWUul4Dju1XVJ6o?=
 =?us-ascii?Q?o/lYEdac2gtj6vs3QHwovnvaGMnEAk8en11Qk9IWh7Jrqgefvl3uMUJnxGfl?=
 =?us-ascii?Q?1DCTkJaaAiaPJu3DJgsA0jv6xo/cu6P1Cp04EeLFLF0W4mTgMfV7FeEjlxQF?=
 =?us-ascii?Q?iutGGI84u2Vm69r5pwcT0QHwPGgSbWab4bvli1RBHvKAMvaAymC8hFR5l1XA?=
 =?us-ascii?Q?q5vpEJRlDiHZQaajRZNff7TKY7dyrJOyCG7X/asHh7uwCszKA9rRindC0yxh?=
 =?us-ascii?Q?pk6oir9xP7FeQ4E5nv2Ldiavm7snweh9RFCyf33bYOW5cDtWKpA0xKyquGJu?=
 =?us-ascii?Q?qQtKATe2HwX1sf47LQgqt1v7msKoIEcY+dZSeypbGHMhc/rmW9kA6Kav3oK6?=
 =?us-ascii?Q?OWFbvtaBCCdl4Lf/zbozFYmsfUfJkeSkpv6Lck/GnaqPSpc9AVhinTsbWSfy?=
 =?us-ascii?Q?zHUNAPGpbWUG/FpiBR+3lL1imh2SOTI9ONyQ9dTq76l27yc3utSgyxdH+mdM?=
 =?us-ascii?Q?GearHtqSFN+gtj5cYDULMUUXlxyVAKkvhCcPu+1MHRv2NNIDf60VwG1zJWIN?=
 =?us-ascii?Q?Y59ytTzq0dUszbHFZoftecNLJqJCcrb41rneqEIOI3bnagyMqo6UIoEqln+Q?=
 =?us-ascii?Q?/tx5UiLVO44XuXMaelxDLixQOqAdF4h9ZzZvHFkIJQlvyIXhhpn/5VFGOvqp?=
 =?us-ascii?Q?7g0gO5XmIX42n2SwN/UlGUPLDAN4P9ndqQLMzxmWX6x2U5aVLdpCCzE9VPfR?=
 =?us-ascii?Q?VhdZNJOcLjba+jjnjJjGW9CStCNEpihVe2NXx1OdWZYbOzYKQxvnAVMvJNoa?=
 =?us-ascii?Q?2JqoCrhu3bgtVahpBv/UnbA3zJlhKmXH6mrQpRAJeHJ8nhI3HbPtnsSqKDhU?=
 =?us-ascii?Q?sLxF4HlSqeba8HV5IEBhN5RQkxkvjbthGf+gDs+bGIDnP8soA5z1vGUjhb1u?=
 =?us-ascii?Q?5/iowtbZ/TVbqw/dG33tdJ08EYxYeAGExQqZQaj8ictgtZxdYBjpjrwurES1?=
 =?us-ascii?Q?J2Tqr+rhc0b2fR/xBMwGnaOJ/TZ93xeBKICC7IEVMWidtcx9h1C7ipjIOvMl?=
 =?us-ascii?Q?8ZB4XGz6csuuC1W6z1G6SjsIGVPEI9GeCYvB7sf93021OrlRTuilsvG1bgfe?=
 =?us-ascii?Q?MkROtlWWnTOUOIieGZA4Ht9s2x/C9XWjAH7QKT0J/vwI1RhGVf9Mp+uioT7M?=
 =?us-ascii?Q?5aCOVO5WTflp1XiYrBoqcj1g456/EZtVGEn+E8UC?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 8144637a-42d4-4849-f4a2-08dcc099c575
X-MS-Exchange-CrossTenant-AuthSource: SA1PR11MB6733.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Aug 2024 21:56:25.7359
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 6n9Ywyp446Zqe+ADrGlA8iU797A+6ZWMIDJlluUb4YhLTm7ZM2nQ7d8om2vIdI20ksiew336N8wHoYjK43p9cw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR11MB4782
X-OriginatorOrg: intel.com

Philip Chen wrote:
> If a pmem device is in a bad status, the driver side could wait for
> host ack forever in virtio_pmem_flush(), causing the system to hang.

I assume this was supposed to be v2 and you resent this as a proper v2
with a change list from v1?

Ira

> 
> Signed-off-by: Philip Chen <philipchen@chromium.org>
> ---
>  drivers/nvdimm/nd_virtio.c | 9 +++++++++
>  1 file changed, 9 insertions(+)
> 
> diff --git a/drivers/nvdimm/nd_virtio.c b/drivers/nvdimm/nd_virtio.c
> index 35c8fbbba10e..3b4d07aa8447 100644
> --- a/drivers/nvdimm/nd_virtio.c
> +++ b/drivers/nvdimm/nd_virtio.c
> @@ -44,6 +44,15 @@ static int virtio_pmem_flush(struct nd_region *nd_region)
>  	unsigned long flags;
>  	int err, err1;
>  
> +	/*
> +	 * Don't bother to send the request to the device if the device is not
> +	 * acticated.
> +	 */
> +	if (vdev->config->get_status(vdev) & VIRTIO_CONFIG_S_NEEDS_RESET) {
> +		dev_info(&vdev->dev, "virtio pmem device needs a reset\n");
> +		return -EIO;
> +	}
> +
>  	might_sleep();
>  	req_data = kmalloc(sizeof(*req_data), GFP_KERNEL);
>  	if (!req_data)
> -- 
> 2.46.0.76.ge559c4bf1a-goog
> 


