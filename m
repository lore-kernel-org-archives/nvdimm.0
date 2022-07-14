Received: from mga04.intel.com (mga04.intel.com [192.55.52.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 569ED4C76
	for <nvdimm@lists.linux.dev>; Thu, 14 Jul 2022 17:21:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1657819260; x=1689355260;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=4wlYWKepwZbwmzPtgEsLU/oRD4bbNa/S3gjR/h77ljo=;
  b=U3Ob8V49Q+f2a2rPT6Qpx72y22tLQlK2HA2fH4FTwV+5G7opYGAq81zv
   7VBQjsCX56ENMb8dS1Ig2xhlE/Z8wurgIRVLAhnVsIFVrw37mSaynwy3b
   MqgSj4AoGiQrNPS18fKDkdhlreH6Z2lsms+pc4PLAByZ2x9Q4JJxuWzeT
   D9VN21ucAaiJ94xKFdkBCSgpwReoTBsPYPflURQ0BaXSw3eQ8+rvCvoWR
   x/jzsPPs8EuN5BQ/zifZACKIMu4b/yfoBYzt8LdPqzhU4YG5jnuQJ/Y7/
   8yB4W78zA61FoAdoiQeXCGGkASHBRrNzYwVPYd8o5P9XEyee6MgMZniSJ
   g==;
X-IronPort-AV: E=McAfee;i="6400,9594,10408"; a="284339701"
X-IronPort-AV: E=Sophos;i="5.92,271,1650956400"; 
   d="scan'208";a="284339701"
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Jul 2022 10:20:59 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.92,271,1650956400"; 
   d="scan'208";a="571186492"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by orsmga006.jf.intel.com with ESMTP; 14 Jul 2022 10:20:59 -0700
Received: from orsmsx609.amr.corp.intel.com (10.22.229.22) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.27; Thu, 14 Jul 2022 10:20:58 -0700
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 orsmsx609.amr.corp.intel.com (10.22.229.22) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.27 via Frontend Transport; Thu, 14 Jul 2022 10:20:58 -0700
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (104.47.55.101)
 by edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2308.27; Thu, 14 Jul 2022 10:20:58 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Q2cB1yJSu9Lg7tV4dGsb2U/9MYgc3to8DABBDodXt+ensGLbXI/X5FMSK6z55y9dL2YU2Dlq540BvyweDgOTJO1Vxbv4oQmAU6Q0rknw7qHOr+6LiBz4uos2ywi6bx9fhvMJ0OwyDgTfwzRR1YfHDAp1r8Cgg0r7bXnqz1YTgrCFln4gsZxh6d2uc7cvmQujh5XINcPGtlKCqdHCQRLWyQWv6ksXYCwNz+1da/NO5wueHqz9g2RRsGDtFNMb0qfUIl9wGdVKH1vPC6GxCY1t1lVPc7Od99MR5nthEYYMXrQGViLC4rA9hCLpUl6SDi/4VobIPAtsYTX+MMOPT3EgEg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=XaBLJYYL6t7/axq21igfPHiT8NgnHG65RJKNd1jRFv0=;
 b=SCRLh9vFEZs7Pjp65AnCS7Ai4KeHX5PNhjZAINBU3Qv8lfUvw4Iy5fysagZqXb+BMljNbAxwqOhb13JnVtl3K+xv+qg01Jo4vMtbrgMSnwc9dRvFKgh5G+Gf+JElrkgEZJtK+iHUFbF4X+r3Y+AZoCQGh8pRXhSG17XYXt4q+5mZ1uuIJ28XFqNT6EJ1K0z6a9WfzUmuzYsEqRy46HNKI4NQOemkoeImrzi5HyY3s+VGOllo24voHOv6pttwGRQjzpE/CetZH3+3evb+hiP7r/JUPFKUy8qV1Y3wYkbG7ClSXBhWCixazjgr8S09YPjxUM/Gk7BVs8oEG8O6BdrzLw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DM4PR11MB6311.namprd11.prod.outlook.com (2603:10b6:8:a6::21) by
 DM8PR11MB5703.namprd11.prod.outlook.com (2603:10b6:8:22::5) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5417.20; Thu, 14 Jul 2022 17:20:57 +0000
Received: from DM4PR11MB6311.namprd11.prod.outlook.com
 ([fe80::3154:e32f:e50c:4fa6]) by DM4PR11MB6311.namprd11.prod.outlook.com
 ([fe80::3154:e32f:e50c:4fa6%5]) with mapi id 15.20.5417.026; Thu, 14 Jul 2022
 17:20:57 +0000
Date: Thu, 14 Jul 2022 10:20:50 -0700
From: Ira Weiny <ira.weiny@intel.com>
To: Dan Williams <dan.j.williams@intel.com>
CC: <vishal.l.verma@intel.com>, <alison.schofield@intel.com>,
	<nvdimm@lists.linux.dev>, <linux-cxl@vger.kernel.org>
Subject: Re: [ndctl PATCH v2 05/12] ccan/list: Import latest list helpers
Message-ID: <YtBQctT+7n1CD+nO@iweiny-desk3>
References: <165781810717.1555691.1411727384567016588.stgit@dwillia2-xfh.jf.intel.com>
 <165781813572.1555691.15909358688944168922.stgit@dwillia2-xfh.jf.intel.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <165781813572.1555691.15909358688944168922.stgit@dwillia2-xfh.jf.intel.com>
X-ClientProxiedBy: SJ0PR05CA0100.namprd05.prod.outlook.com
 (2603:10b6:a03:334::15) To DM4PR11MB6311.namprd11.prod.outlook.com
 (2603:10b6:8:a6::21)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: bb8f70d2-5254-4870-735b-08da65bd368c
X-MS-TrafficTypeDiagnostic: DM8PR11MB5703:EE_
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: xCVscZ6cpq6Xi9XuP9YAvy/MTMAZUFG9q1BKn3LRX3UcagqQ7W25ADjGSJVpbKhi/nCy1uzGlWG8/I07tMiN8DiI7xnfXPUMjT3VW6a8CrzMMUwX1ouOhMASkVszPo9LTuskZ9iqJgPuE6vDrC1ULRyGYVvuFkCM0Te2d9IEeOdfL82Ji693HVfyTM4c+G5wLR+t+7q2oE7iQok7qz2jYwC/68ZolXkQGl+MzDXTNWQaTvCdnN+OeGnjdFrmCqM0H+PeUVqQsF+QJhNte9d2s0FU21fA9a58D4AvF3k5dOTmUWLDY9zKNe/O1v8aVFcsxkWWL4lfyp0FR+Yww+b5MRk1TfpVRVvma3GWnoOTbsyvDXnkVwLwfXm8noa27s3t9JakDRchTXVE8gdQOO1qCT9uPA6/LjUb81KQMPw7JrkbURHaInV0G9yCT00aF/4tWM5UFsP2KlT9VIDQIN4mManI+CrHUPGs/8A/dafuJXiWEWLuJPaBG3Tb0FlRezEkbnEkBOFXBIbFXs9KROjWXP5cufEtk3WTADOOITpEYiW1Y/XMJeF7sS+YXbHuGrty3z4S3P8CV8p7tRT3iZUCDspgVsariATbu4j5m52mWZX4fSHBpIdJiDbJ7L/t/MqrMocfESWK1DE4mPmWp0L95KElP+yPaR48MpYiRzRFDVLqW4MEnf8lZ90IHOFRRQGXEkBLseJiMAFTzCpaVsy9Imx8g7dvpE01dXqcXuhkqfbeDaMOujwLW+jLOBGxL+t5
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR11MB6311.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(7916004)(376002)(39860400002)(346002)(396003)(136003)(366004)(478600001)(41300700001)(316002)(83380400001)(5660300002)(66946007)(6506007)(6862004)(82960400001)(4326008)(38100700002)(186003)(9686003)(66476007)(66556008)(6512007)(33716001)(44832011)(2906002)(6666004)(86362001)(8676002)(6486002)(6636002)(30864003)(8936002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?CHrcu+yyi/StNhQMOmuW30Q7/ZeWoCugrBO4WtOcrYhjWL0aKIvoejBmRoRo?=
 =?us-ascii?Q?7ZtlpQOIkQkJbDXsssg4JgQJdtUjIi+fbh6phSVc2JQprn6UUazkMdmt6CRc?=
 =?us-ascii?Q?PM4tAW3eGvmyDbMBL0D1owoYpng+BPS9n+b7njvNGhvuvuWjq7GlL8AjF27A?=
 =?us-ascii?Q?ta5ldn1bKP0P3HKQa2wG44AtvScfpt0uwL0tTmzFFh4uiuZ1A5pJJl2t5Cby?=
 =?us-ascii?Q?9vY1pQyyNwmDvY+gS2gwrGO5GZ5f/iTbQ1KdNyUEj+eH55Fw69NskbRcTMpf?=
 =?us-ascii?Q?VCL23GpijjuvcKkvOXySyPqWwzQ4foOAk38iUulXo3ifF1dzijqMLGf4hnSi?=
 =?us-ascii?Q?bTUVXNgvbwjWbf3bfzU5Me75PKOd5WdWLnMeeaC9mxqi4ZodJc4UGppeam7G?=
 =?us-ascii?Q?pMJ/SVyMfs1mqT0wargaTtBKDhRHEwD1rBJ7NikbdCEctrfHsYuBptjPqJVL?=
 =?us-ascii?Q?WzjvFJdn8AWYsZ8ONagaxEjeOvRWNh9vl0ueM5zOb+oJ1OqyzPSzkZjaR4eo?=
 =?us-ascii?Q?cZzAzxZ9yFqQDQfvxAxCHnuw2QJUr6zpT7P+Me+02Ze9XNZme37iuepWNX1m?=
 =?us-ascii?Q?Wtm8YqAz9gqT01WI0QacNhQ/Jb5hilcCeVaBOiaZUJN4GP8NiguRpySniO9T?=
 =?us-ascii?Q?vW0w0DxpaFoB5NHUEYYerPE5G6N9JlD3Ap9BgOFvyaLQmyGPrrh+75AFRlke?=
 =?us-ascii?Q?fpNQLu0Xswp6Qe2rkBAAKKfrnfeXJwFROiQIcqg+2OSm9W1j3451wMIfeqPD?=
 =?us-ascii?Q?IMYqv74JKOfvz32pjBLbSVcz4Q1LUNUtgIUDOEPgawOrxF6X4RTxPnuOGJqc?=
 =?us-ascii?Q?AeYcf2J1q+CZHn8m2qmDtdBaccS37qGxvQsWS1W7lLqQW+5RxGzN9052m33D?=
 =?us-ascii?Q?LO3kzrZNFxY0ZbBIeCH3vn0xoR/8GsMoVbMjZepDnHatH/EpsdBMgI+yiGpa?=
 =?us-ascii?Q?TLEnOMtO8ulz5CeKDgcNiSv4DngACT9ctbIRhVGhSnWSe9z1caHW9RISF9XB?=
 =?us-ascii?Q?9inGwyU607cLBUCu4WBUYvi2xV9aPUz0i2nnvVN4fYSIyMSGvDFllpJCHRdX?=
 =?us-ascii?Q?OXZb0g6Q1TKP4MfPMo/SG2KlsXvXmNFTwB3HlZUyXH8L4g9Mi5ifpt9AdAe8?=
 =?us-ascii?Q?Wyf7IS2m2hhyE33pCECyIt585fGpe5YYn+omGBUvqoCP1evfgha5dETkhrES?=
 =?us-ascii?Q?+KGpZ0eyw/lMug531nCKnk5WJRMukDjfP0i8sK9irRZNB0cO3D1qn8fgqTHE?=
 =?us-ascii?Q?H4AwNp6p8jP+s7qylUsQWbyOBp27ciMIAS+cBkN12OozIPfcoMKpImqQeL1c?=
 =?us-ascii?Q?saNJhovBiETM+639Fi0GThhINZSwpYt/iQn4wZsAOarKZV82lJSDaTSWORWu?=
 =?us-ascii?Q?XDDhhVbaShsHTfrxHxz8GW6/AfdAazshWWXYVIxh8Hz24jkmoIvYOGqD0rgL?=
 =?us-ascii?Q?BRrmcZUyLm32eNTWi4SGvLRz68aKqexZG7Zbp1HvCbzYVdwoRMDXCplBGnYm?=
 =?us-ascii?Q?a1+7fWBFgX6d31AQZUp1MKznaQmtWasEa2YLlDhpJY9pkkf+5spy9o/bAU+p?=
 =?us-ascii?Q?QpVXmxJVPnMerUSWkOEZwfar7nRmN6N6XTcWsth4dy+ffVciCBoH/hiiBUAT?=
 =?us-ascii?Q?R2GIFtRURirg+OIpFLa9LwGvqHzSfXkOOPBYq72C0uFJ?=
X-MS-Exchange-CrossTenant-Network-Message-Id: bb8f70d2-5254-4870-735b-08da65bd368c
X-MS-Exchange-CrossTenant-AuthSource: DM4PR11MB6311.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Jul 2022 17:20:57.0212
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: jz4X3DdlLXav5BopMTef5KCJjDR4M6AlZhjOVWstB6wyWjquEpQ6f4eaAAJoRD78jiYPpptrv1LW0H87MGR+Ng==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM8PR11MB5703
X-OriginatorOrg: intel.com

On Thu, Jul 14, 2022 at 10:02:15AM -0700, Dan Williams wrote:
> Pick up the definition of list_add_{before,after} and other updates from
> ccan at commit 52b86922f846 ("ccan/base64: fix GCC warning.").
> 
> Reported-by: Ira Weiny <ira.weiny@intel.com>

Reviewed-by: Ira Weiny <ira.weiny@intel.com>

> Signed-off-by: Dan Williams <dan.j.williams@intel.com>
> ---
>  ccan/list/list.h   |  258 +++++++++++++++++++++++++++++++++++++++++++++-------
>  ndctl/lib/inject.c |    1 
>  util/list.h        |   40 --------
>  3 files changed, 222 insertions(+), 77 deletions(-)
>  delete mode 100644 util/list.h
> 
> diff --git a/ccan/list/list.h b/ccan/list/list.h
> index 3ebd1b23dc0f..15f5fb7b34eb 100644
> --- a/ccan/list/list.h
> +++ b/ccan/list/list.h
> @@ -95,8 +95,8 @@ struct list_node *list_check_node(const struct list_node *n,
>  #define list_debug(h, loc) list_check((h), loc)
>  #define list_debug_node(n, loc) list_check_node((n), loc)
>  #else
> -#define list_debug(h, loc) (h)
> -#define list_debug_node(n, loc) (n)
> +#define list_debug(h, loc) ((void)loc, h)
> +#define list_debug_node(n, loc) ((void)loc, n)
>  #endif
>  
>  /**
> @@ -111,7 +111,7 @@ struct list_node *list_check_node(const struct list_node *n,
>   * Example:
>   *	static struct list_head my_list = LIST_HEAD_INIT(my_list);
>   */
> -#define LIST_HEAD_INIT(name) { { &name.n, &name.n } }
> +#define LIST_HEAD_INIT(name) { { &(name).n, &(name).n } }
>  
>  /**
>   * LIST_HEAD - define and initialize an empty list_head
> @@ -145,6 +145,48 @@ static inline void list_head_init(struct list_head *h)
>  	h->n.next = h->n.prev = &h->n;
>  }
>  
> +/**
> + * list_node_init - initialize a list_node
> + * @n: the list_node to link to itself.
> + *
> + * You don't need to use this normally!  But it lets you list_del(@n)
> + * safely.
> + */
> +static inline void list_node_init(struct list_node *n)
> +{
> +	n->next = n->prev = n;
> +}
> +
> +/**
> + * list_add_after - add an entry after an existing node in a linked list
> + * @h: the list_head to add the node to (for debugging)
> + * @p: the existing list_node to add the node after
> + * @n: the new list_node to add to the list.
> + *
> + * The existing list_node must already be a member of the list.
> + * The new list_node does not need to be initialized; it will be overwritten.
> + *
> + * Example:
> + *	struct child c1, c2, c3;
> + *	LIST_HEAD(h);
> + *
> + *	list_add_tail(&h, &c1.list);
> + *	list_add_tail(&h, &c3.list);
> + *	list_add_after(&h, &c1.list, &c2.list);
> + */
> +#define list_add_after(h, p, n) list_add_after_(h, p, n, LIST_LOC)
> +static inline void list_add_after_(struct list_head *h,
> +				   struct list_node *p,
> +				   struct list_node *n,
> +				   const char *abortstr)
> +{
> +	n->next = p->next;
> +	n->prev = p;
> +	p->next->prev = n;
> +	p->next = n;
> +	(void)list_debug(h, abortstr);
> +}
> +
>  /**
>   * list_add - add an entry at the start of a linked list.
>   * @h: the list_head to add the node to
> @@ -163,10 +205,34 @@ static inline void list_add_(struct list_head *h,
>  			     struct list_node *n,
>  			     const char *abortstr)
>  {
> -	n->next = h->n.next;
> -	n->prev = &h->n;
> -	h->n.next->prev = n;
> -	h->n.next = n;
> +	list_add_after_(h, &h->n, n, abortstr);
> +}
> +
> +/**
> + * list_add_before - add an entry before an existing node in a linked list
> + * @h: the list_head to add the node to (for debugging)
> + * @p: the existing list_node to add the node before
> + * @n: the new list_node to add to the list.
> + *
> + * The existing list_node must already be a member of the list.
> + * The new list_node does not need to be initialized; it will be overwritten.
> + *
> + * Example:
> + *	list_head_init(&h);
> + *	list_add_tail(&h, &c1.list);
> + *	list_add_tail(&h, &c3.list);
> + *	list_add_before(&h, &c3.list, &c2.list);
> + */
> +#define list_add_before(h, p, n) list_add_before_(h, p, n, LIST_LOC)
> +static inline void list_add_before_(struct list_head *h,
> +				    struct list_node *p,
> +				    struct list_node *n,
> +				    const char *abortstr)
> +{
> +	n->next = p;
> +	n->prev = p->prev;
> +	p->prev->next = n;
> +	p->prev = n;
>  	(void)list_debug(h, abortstr);
>  }
>  
> @@ -185,11 +251,7 @@ static inline void list_add_tail_(struct list_head *h,
>  				  struct list_node *n,
>  				  const char *abortstr)
>  {
> -	n->next = &h->n;
> -	n->prev = h->n.prev;
> -	h->n.prev->next = n;
> -	h->n.prev = n;
> -	(void)list_debug(h, abortstr);
> +	list_add_before_(h, &h->n, n, abortstr);
>  }
>  
>  /**
> @@ -229,6 +291,21 @@ static inline bool list_empty_nodebug(const struct list_head *h)
>  }
>  #endif
>  
> +/**
> + * list_empty_nocheck - is a list empty?
> + * @h: the list_head
> + *
> + * If the list is empty, returns true. This doesn't perform any
> + * debug check for list consistency, so it can be called without
> + * locks, racing with the list being modified. This is ok for
> + * checks where an incorrect result is not an issue (optimized
> + * bail out path for example).
> + */
> +static inline bool list_empty_nocheck(const struct list_head *h)
> +{
> +	return h->n.next == &h->n;
> +}
> +
>  /**
>   * list_del - delete an entry from an (unknown) linked list.
>   * @n: the list_node to delete from the list.
> @@ -237,7 +314,7 @@ static inline bool list_empty_nodebug(const struct list_head *h)
>   * another list, but not deleted again.
>   *
>   * See also:
> - *	list_del_from()
> + *	list_del_from(), list_del_init()
>   *
>   * Example:
>   *	list_del(&child->list);
> @@ -255,6 +332,27 @@ static inline void list_del_(struct list_node *n, const char* abortstr)
>  #endif
>  }
>  
> +/**
> + * list_del_init - delete a node, and reset it so it can be deleted again.
> + * @n: the list_node to be deleted.
> + *
> + * list_del(@n) or list_del_init() again after this will be safe,
> + * which can be useful in some cases.
> + *
> + * See also:
> + *	list_del_from(), list_del()
> + *
> + * Example:
> + *	list_del_init(&child->list);
> + *	parent->num_children--;
> + */
> +#define list_del_init(n) list_del_init_(n, LIST_LOC)
> +static inline void list_del_init_(struct list_node *n, const char *abortstr)
> +{
> +	list_del_(n, abortstr);
> +	list_node_init(n);
> +}
> +
>  /**
>   * list_del_from - delete an entry from a known linked list.
>   * @h: the list_head the node is in.
> @@ -285,6 +383,39 @@ static inline void list_del_from(struct list_head *h, struct list_node *n)
>  	list_del(n);
>  }
>  
> +/**
> + * list_swap - swap out an entry from an (unknown) linked list for a new one.
> + * @o: the list_node to replace from the list.
> + * @n: the list_node to insert in place of the old one.
> + *
> + * Note that this leaves @o in an undefined state; it can be added to
> + * another list, but not deleted/swapped again.
> + *
> + * See also:
> + *	list_del()
> + *
> + * Example:
> + *	struct child x1, x2;
> + *	LIST_HEAD(xh);
> + *
> + *	list_add(&xh, &x1.list);
> + *	list_swap(&x1.list, &x2.list);
> + */
> +#define list_swap(o, n) list_swap_(o, n, LIST_LOC)
> +static inline void list_swap_(struct list_node *o,
> +			      struct list_node *n,
> +			      const char* abortstr)
> +{
> +	(void)list_debug_node(o, abortstr);
> +	*n = *o;
> +	n->next->prev = n;
> +	n->prev->next = n;
> +#ifdef CCAN_LIST_DEBUG
> +	/* Catch use-after-del. */
> +	o->next = o->prev = NULL;
> +#endif
> +}
> +
>  /**
>   * list_entry - convert a list_node back into the structure containing it.
>   * @n: the list_node
> @@ -406,9 +537,29 @@ static inline const void *list_tail_(const struct list_head *h, size_t off)
>   *		printf("Name: %s\n", child->name);
>   */
>  #define list_for_each_rev(h, i, member)					\
> -	for (i = container_of_var(list_debug(h,	LIST_LOC)->n.prev, i, member); \
> -	     &i->member != &(h)->n;					\
> -	     i = container_of_var(i->member.prev, i, member))
> +	list_for_each_rev_off(h, i, list_off_var_(i, member))
> +
> +/**
> + * list_for_each_rev_safe - iterate through a list backwards,
> + * maybe during deletion
> + * @h: the list_head
> + * @i: the structure containing the list_node
> + * @nxt: the structure containing the list_node
> + * @member: the list_node member of the structure
> + *
> + * This is a convenient wrapper to iterate @i over the entire list backwards.
> + * It's a for loop, so you can break and continue as normal.  The extra
> + * variable * @nxt is used to hold the next element, so you can delete @i
> + * from the list.
> + *
> + * Example:
> + *	struct child *next;
> + *	list_for_each_rev_safe(&parent->children, child, next, list) {
> + *		printf("Name: %s\n", child->name);
> + *	}
> + */
> +#define list_for_each_rev_safe(h, i, nxt, member)			\
> +	list_for_each_rev_safe_off(h, i, nxt, list_off_var_(i, member))
>  
>  /**
>   * list_for_each_safe - iterate through a list, maybe during deletion
> @@ -422,7 +573,6 @@ static inline const void *list_tail_(const struct list_head *h, size_t off)
>   * @nxt is used to hold the next element, so you can delete @i from the list.
>   *
>   * Example:
> - *	struct child *next;
>   *	list_for_each_safe(&parent->children, child, next, list) {
>   *		list_del(&child->list);
>   *		parent->num_children--;
> @@ -537,10 +687,28 @@ static inline void list_prepend_list_(struct list_head *to,
>  	list_head_init(from);
>  }
>  
> +/* internal macros, do not use directly */
> +#define list_for_each_off_dir_(h, i, off, dir)				\
> +	for (i = list_node_to_off_(list_debug(h, LIST_LOC)->n.dir,	\
> +				   (off));				\
> +	list_node_from_off_((void *)i, (off)) != &(h)->n;		\
> +	i = list_node_to_off_(list_node_from_off_((void *)i, (off))->dir, \
> +			      (off)))
> +
> +#define list_for_each_safe_off_dir_(h, i, nxt, off, dir)		\
> +	for (i = list_node_to_off_(list_debug(h, LIST_LOC)->n.dir,	\
> +				   (off)),				\
> +	nxt = list_node_to_off_(list_node_from_off_(i, (off))->dir,	\
> +				(off));					\
> +	list_node_from_off_(i, (off)) != &(h)->n;			\
> +	i = nxt,							\
> +	nxt = list_node_to_off_(list_node_from_off_(i, (off))->dir,	\
> +				(off)))
> +
>  /**
>   * list_for_each_off - iterate through a list of memory regions.
>   * @h: the list_head
> - * @i: the pointer to a memory region wich contains list node data.
> + * @i: the pointer to a memory region which contains list node data.
>   * @off: offset(relative to @i) at which list node data resides.
>   *
>   * This is a low-level wrapper to iterate @i over the entire list, used to
> @@ -548,12 +716,12 @@ static inline void list_prepend_list_(struct list_head *to,
>   * so you can break and continue as normal.
>   *
>   * WARNING! Being the low-level macro that it is, this wrapper doesn't know
> - * nor care about the type of @i. The only assumtion made is that @i points
> + * nor care about the type of @i. The only assumption made is that @i points
>   * to a chunk of memory that at some @offset, relative to @i, contains a
> - * properly filled `struct node_list' which in turn contains pointers to
> - * memory chunks and it's turtles all the way down. Whith all that in mind
> + * properly filled `struct list_node' which in turn contains pointers to
> + * memory chunks and it's turtles all the way down. With all that in mind
>   * remember that given the wrong pointer/offset couple this macro will
> - * happilly churn all you memory untill SEGFAULT stops it, in other words
> + * happily churn all you memory until SEGFAULT stops it, in other words
>   * caveat emptor.
>   *
>   * It is worth mentioning that one of legitimate use-cases for that wrapper
> @@ -567,17 +735,24 @@ static inline void list_prepend_list_(struct list_head *to,
>   *		printf("Name: %s\n", child->name);
>   */
>  #define list_for_each_off(h, i, off)                                    \
> -	for (i = list_node_to_off_(list_debug(h, LIST_LOC)->n.next,	\
> -				   (off));				\
> -       list_node_from_off_((void *)i, (off)) != &(h)->n;                \
> -       i = list_node_to_off_(list_node_from_off_((void *)i, (off))->next, \
> -                             (off)))
> +	list_for_each_off_dir_((h),(i),(off),next)
> +
> +/**
> + * list_for_each_rev_off - iterate through a list of memory regions backwards
> + * @h: the list_head
> + * @i: the pointer to a memory region which contains list node data.
> + * @off: offset(relative to @i) at which list node data resides.
> + *
> + * See list_for_each_off for details
> + */
> +#define list_for_each_rev_off(h, i, off)                                    \
> +	list_for_each_off_dir_((h),(i),(off),prev)
>  
>  /**
>   * list_for_each_safe_off - iterate through a list of memory regions, maybe
>   * during deletion
>   * @h: the list_head
> - * @i: the pointer to a memory region wich contains list node data.
> + * @i: the pointer to a memory region which contains list node data.
>   * @nxt: the structure containing the list_node
>   * @off: offset(relative to @i) at which list node data resides.
>   *
> @@ -590,15 +765,26 @@ static inline void list_prepend_list_(struct list_head *to,
>   *		printf("Name: %s\n", child->name);
>   */
>  #define list_for_each_safe_off(h, i, nxt, off)                          \
> -	for (i = list_node_to_off_(list_debug(h, LIST_LOC)->n.next,	\
> -				   (off)),				\
> -         nxt = list_node_to_off_(list_node_from_off_(i, (off))->next,   \
> -                                 (off));                                \
> -       list_node_from_off_(i, (off)) != &(h)->n;                        \
> -       i = nxt,                                                         \
> -         nxt = list_node_to_off_(list_node_from_off_(i, (off))->next,   \
> -                                 (off)))
> +	list_for_each_safe_off_dir_((h),(i),(nxt),(off),next)
>  
> +/**
> + * list_for_each_rev_safe_off - iterate backwards through a list of
> + * memory regions, maybe during deletion
> + * @h: the list_head
> + * @i: the pointer to a memory region which contains list node data.
> + * @nxt: the structure containing the list_node
> + * @off: offset(relative to @i) at which list node data resides.
> + *
> + * For details see `list_for_each_rev_off' and `list_for_each_rev_safe'
> + * descriptions.
> + *
> + * Example:
> + *	list_for_each_rev_safe_off(&parent->children, child,
> + *		next, offsetof(struct child, list))
> + *		printf("Name: %s\n", child->name);
> + */
> +#define list_for_each_rev_safe_off(h, i, nxt, off)                      \
> +	list_for_each_safe_off_dir_((h),(i),(nxt),(off),prev)
>  
>  /* Other -off variants. */
>  #define list_entry_off(n, type, off)		\
> diff --git a/ndctl/lib/inject.c b/ndctl/lib/inject.c
> index d61c02c176e2..3486ffefc40a 100644
> --- a/ndctl/lib/inject.c
> +++ b/ndctl/lib/inject.c
> @@ -2,7 +2,6 @@
>  // Copyright (C) 2014-2020, Intel Corporation. All rights reserved.
>  #include <stdlib.h>
>  #include <limits.h>
> -#include <util/list.h>
>  #include <util/size.h>
>  #include <ndctl/libndctl.h>
>  #include <ccan/list/list.h>
> diff --git a/util/list.h b/util/list.h
> deleted file mode 100644
> index 1ea9c59b9f0c..000000000000
> --- a/util/list.h
> +++ /dev/null
> @@ -1,40 +0,0 @@
> -/* SPDX-License-Identifier: GPL-2.0 */
> -/* Copyright (C) 2015-2020 Intel Corporation. All rights reserved. */
> -#ifndef _NDCTL_LIST_H_
> -#define _NDCTL_LIST_H_
> -
> -#include <ccan/list/list.h>
> -
> -/**
> - * list_add_after - add an entry after the given node in the linked list.
> - * @h: the list_head to add the node to
> - * @l: the list_node after which to add to
> - * @n: the list_node to add to the list.
> - *
> - * The list_node does not need to be initialized; it will be overwritten.
> - * Example:
> - *	struct child *child = malloc(sizeof(*child));
> - *
> - *	child->name = "geoffrey";
> - *	list_add_after(&parent->children, &child1->list, &child->list);
> - *	parent->num_children++;
> - */
> -#define list_add_after(h, l, n) list_add_after_(h, l, n, LIST_LOC)
> -static inline void list_add_after_(struct list_head *h,
> -				   struct list_node *l,
> -				   struct list_node *n,
> -				   const char *abortstr)
> -{
> -	if (l->next == &h->n) {
> -		/* l is the last element, this becomes a list_add_tail */
> -		list_add_tail(h, n);
> -		return;
> -	}
> -	n->next = l->next;
> -	n->prev = l;
> -	l->next->prev = n;
> -	l->next = n;
> -	(void)list_debug(h, abortstr);
> -}
> -
> -#endif /* _NDCTL_LIST_H_ */
> 
