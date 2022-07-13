Received: from mga12.intel.com (mga12.intel.com [192.55.52.136])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AE59733C4
	for <nvdimm@lists.linux.dev>; Wed, 13 Jul 2022 14:44:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1657723480; x=1689259480;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=Uzeg22b6KZl4m+xNatJT8zeyI/9BCs9cdY46b+AtZh0=;
  b=R0kzlDXlxyLIHRNngtlf1ZWj7DTyviXkgRhJ9dF5j/SNLFbAw+46Qo4E
   z9OAkSfwD2W890Df1Doj9SJ13AIk3n6IaBSgV+7L04fVBSfOo4obyKA8/
   jyyzlEVUHYzHTLw1D4ej2DX18f9BAy1AbHJyteciO9HGGtEsPRvIFtpMl
   Mill1pG14KYnD3jMq9sq+wEhgvSqVIsUqZgyLutmZIpSa90HXHjIoCbWU
   GiQggz+0TiTcUDKE3CILx77d4BGykCB9tIGLbTDksyfXh2kLEf0MVoyTI
   d7LS4GoSL0tk64gWh4dMjkbh8yXdPh27E+Sbh0IbktvG7DVTqsl/pSX3c
   A==;
X-IronPort-AV: E=McAfee;i="6400,9594,10407"; a="265017508"
X-IronPort-AV: E=Sophos;i="5.92,267,1650956400"; 
   d="scan'208";a="265017508"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Jul 2022 07:44:39 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.92,267,1650956400"; 
   d="scan'208";a="622972635"
Received: from orsmsx605.amr.corp.intel.com ([10.22.229.18])
  by orsmga008.jf.intel.com with ESMTP; 13 Jul 2022 07:44:39 -0700
Received: from orsmsx611.amr.corp.intel.com (10.22.229.24) by
 ORSMSX605.amr.corp.intel.com (10.22.229.18) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.27; Wed, 13 Jul 2022 07:44:39 -0700
Received: from orsmsx608.amr.corp.intel.com (10.22.229.21) by
 ORSMSX611.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.27; Wed, 13 Jul 2022 07:44:38 -0700
Received: from ORSEDG601.ED.cps.intel.com (10.7.248.6) by
 orsmsx608.amr.corp.intel.com (10.22.229.21) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.27 via Frontend Transport; Wed, 13 Jul 2022 07:44:38 -0700
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (104.47.58.168)
 by edgegateway.intel.com (134.134.137.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2308.27; Wed, 13 Jul 2022 07:44:37 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Wr5OYnpzKaBkTJjIwuXJDBX8nkkZYCIYu+o69gtwz+UwFXZc+E1RNe++fxieddnezTe6au6ZQq0r6yTyVvIT5h5PLwxfcB2JM7rLaFoNLpppZ00NcD/nNL7nn3ANf2dYXZnOS3IRMJKfFk8+kF5EpJ41HVwpCRsHMCSUSdDFPr1LIbSIiyo1t7c8yJnrneM2aVEc9ZV2IJJJptUMO/a3cAMF1Fg9+MoaN62C7zpqnthkAlSiCJ759H7kdeuscz72yIIg9PyRXB/3oWMAupzrcz64gNEblUuTHsU5VmZPwGuLGLOXp2yrWt6WSBtw/h9Dt92DzhfyqUoXYpJX6NTzGw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=qXWHRFiuTSkUHmUKEMVfCxz/mJopYsUJIgXxIWyQJJE=;
 b=Jdggzbz7ndVubnMFizdGLx3it1OczyQ+jRZ5AqGInOKZuIYFFLGrFueebLiOBbEL/dZcRYOnfEN9NLcJZePA7Qpxu4R7wKZi1OL5gU4JK1mqddBeFUSE0uTPUPveKj15CKmRxBT8Idf9QrFY61+9hLZcUg2xrX1lSppbXifgGWcPJUzUsh6b3duJZud7GZ5AhGC5YnYg2Ehm1/iJz/XoDrAOlKUhGo9RXDgJGcUgWfz/5reGz/OxZlQFUUSGMleyw7I69/7Hlst4BfWo6hlRBFVCgVT+5a4Lu3U0Pxfdh+IxvG/0RaTdQsor/W0/rBzlRLT0x798deT8qoMe3T9jpQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DM4PR11MB6311.namprd11.prod.outlook.com (2603:10b6:8:a6::21) by
 DM6PR11MB3610.namprd11.prod.outlook.com (2603:10b6:5:139::26) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5417.20; Wed, 13 Jul 2022 14:44:36 +0000
Received: from DM4PR11MB6311.namprd11.prod.outlook.com
 ([fe80::3154:e32f:e50c:4fa6]) by DM4PR11MB6311.namprd11.prod.outlook.com
 ([fe80::3154:e32f:e50c:4fa6%5]) with mapi id 15.20.5417.026; Wed, 13 Jul 2022
 14:44:36 +0000
Date: Wed, 13 Jul 2022 07:44:28 -0700
From: Ira Weiny <ira.weiny@intel.com>
To: Dan Williams <dan.j.williams@intel.com>
CC: <vishal.l.verma@intel.com>, <alison.schofield@intel.com>,
	<nvdimm@lists.linux.dev>, <linux-cxl@vger.kernel.org>
Subject: Re: [ndctl PATCH 05/11] cxl/lib: Maintain decoders in id order
Message-ID: <Ys7aTMGj7m7l1kGS@iweiny-desk3>
References: <165765284365.435671.13173937566404931163.stgit@dwillia2-xfh>
 <165765287277.435671.14320322485572083484.stgit@dwillia2-xfh>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <165765287277.435671.14320322485572083484.stgit@dwillia2-xfh>
X-ClientProxiedBy: BYAPR05CA0023.namprd05.prod.outlook.com
 (2603:10b6:a03:c0::36) To DM4PR11MB6311.namprd11.prod.outlook.com
 (2603:10b6:8:a6::21)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: cf8b61b3-a510-4a77-0d72-08da64de34f8
X-MS-TrafficTypeDiagnostic: DM6PR11MB3610:EE_
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 7lMLfWyjCmJhY2F+E8v+d2VTDKATlq0/nKSH32PWBO5NJivz6PhxRw+PvwxKa53B0/3L0an2ETiM6bkik1H/RjPKWdNT8ULuoPVs4lZbuqgiAxAsvel5PAOZwDH1h/GAMbRCeJ+w0n9wgMuvFCHjfg3bmISj0rThkM5Fzx8tDMXCFEWMFsdeRfuyjM0bbKem5xy8JKdmKK0i42o9j0Qb7WuJ8+f/3SGW4mr5UNwfwyuOvvxQA0sTFW8R9RuNqDWZWlJmRqS3wU6KWgd4bsXh+mOKZs6XOxD9I0CxWnEhg1dWZBNci9V9hzA7Q9B0x6gY7g0+y8HAKf9lXMss0nLOgJIwTGHOJs4XlDwLhGbXcXVjGOi/E+R9976FypVYagZkWpScvfaizT0FCd3Kax/hUf2JzBckE/AKrFb5/iIzo7YdJqevpqJQ4pgdt0U2PsO4FwdCQiztAo5TkKZn/LJCSrU6VxyrjAHZFvJjwiGzP7X4vgZVs4x7nnrlucFePmwlW0pyyLNoOs3K05PkAs+Q5xf9kuW48SHO5OlSO+6zAh8Dc0WHXXJpr/CgbFr4jMpAM0S16bJkmLyl12VfvlR96TY7ZZrMzO2mi5uACo2sJgn45Eh6ED03j/q0UrCwojGKvCHDtD53+BQFodBuxW9Ge6e1eIEQM0iaegFsuB35VKeiicxoTP6vqqyk6/aU3E9KvDFmv+ejWp2rfcjE86+anSzuIabjWP4Pef903wkPbt+gcQmrffpeRN9N6Mpoax9Ptj64cG9aaciOYRqKXmRhkPxDrCfALJSnSB1KzIBnHmQ=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR11MB6311.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(7916004)(376002)(366004)(136003)(396003)(39860400002)(346002)(82960400001)(86362001)(5660300002)(6512007)(9686003)(186003)(38100700002)(8676002)(6636002)(41300700001)(966005)(4326008)(6506007)(66476007)(33716001)(66946007)(44832011)(83380400001)(8936002)(2906002)(6486002)(6666004)(478600001)(6862004)(316002)(66556008);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?ZboBEIhWA87yECxLc0rixwhWMPCpnddJm4wY3jix7zVvodlErw6NSQLgHVfP?=
 =?us-ascii?Q?zFbxuYEOqJdwyrZdCzEEXUEijXRU7PkbrrVT+efb0S6iIEm+dGaowbhw1tga?=
 =?us-ascii?Q?PA0LSJor9sUstLL3NY3e2vmDs2xMVPt2wFM8JmqYxmVqvk6P8Fkdk7HSrrMb?=
 =?us-ascii?Q?EtFoJuJ9izZzdkBAp83MsqB8IlyGHXk7jOUraKmy4RpUtJhjNyYLmjIsN0Wy?=
 =?us-ascii?Q?iwKZFA5vgU3Oxmtfat+FMrOAYK1OfIayaqSnvUhlPtVFySZgCrhDTr+f8u0Q?=
 =?us-ascii?Q?qGxrp2FIIjR+yS+YaAGJgFyIamTE1hK7y0F2NhcS+yYm/8XpgkeRmGkLWrnd?=
 =?us-ascii?Q?LolDkjA+OHC+QqTwBI3inFvelA+7b7iUb6vzlmVtNpVNCZ3VKmr4PRTvU9Uw?=
 =?us-ascii?Q?9UvrHt/mkkG0hDrESy1lWXOHYIfVGyWr6Qx7aF3PaQS/ImDgeYS2f2ZJG27J?=
 =?us-ascii?Q?a3eE74lrjoB9g6XozcpSHXd8cp97zo9FeZbd8mH2pLgaqwzV+5Nh4J6FDmY7?=
 =?us-ascii?Q?ohWuE15XM9C/5nFELhikcgS8+hejFVyaB8rYeQZYngfKY/9Hk87b+eqKi16j?=
 =?us-ascii?Q?l38JX8XUF/uko6KtV/hoa8vsSG+qmFpsiYndlAEbOln+65aiLA3ROAyJalPR?=
 =?us-ascii?Q?mhcFQyBjDG4j/E2K12uC4gkuwjnQvLRPrJYsob3XukvuF//IPZ3OTmiCH9E6?=
 =?us-ascii?Q?n0kOu1Atl3kbik5AhFKDkkg+MwqBnFGXvCOhJZDXzfkzWZlKszi2dIbj4cfH?=
 =?us-ascii?Q?UsN75P+6NzAqUm8E7J0khZUjZ21BHRPHd/DYBWLtw66wrOHoKpQ0UPd+urlc?=
 =?us-ascii?Q?xjGqR51jdUpS4hx1K5per4TnQybF8HpTDkxTtQzp+tqrDNDk9+E067OJn6Ve?=
 =?us-ascii?Q?hxonNu4PgmB1IW7kiaPazOtt9QWFNCWIl7La++gORUPz0pajOPBVgHE56RkR?=
 =?us-ascii?Q?RexcjEpWg6z7/2lqAtg27yaiDxHoov7P5/uSxccWOD4bTUUEu/LwEZbJg1Fl?=
 =?us-ascii?Q?UdPwP6d3sXS1iflh+7jWa/FYR80zUCnceFI9xIAIq0dSI1wEpwx4IqkQ1jWX?=
 =?us-ascii?Q?uA4a6bYQydN9ORF4l/G9ZKob5Mptjeux+f03B2atryA0WQBPZiONhYCBs5xd?=
 =?us-ascii?Q?lKwAhPbk+m2YJleDdOZ/21tsncIMYQfAb3VUR6MYsfYObe21BsqdOoEavq6V?=
 =?us-ascii?Q?BaEqCPD0Mi/IchALxce1nAkiRNuE4vR80+WXqZIjxse61u30YYumd7TrHP8e?=
 =?us-ascii?Q?0z6QLyrzJHbxmbmqssdHAiLRj1X/YH6w466y0fECZ3/cgvyLIxcKnZIeieJW?=
 =?us-ascii?Q?3t9x3wPkTrbHrspPH2XQTe6aU/v2ZJ8fY0UbxEXRm6yBQhQVjzYrUlTzWpxG?=
 =?us-ascii?Q?xjp8128zB6NiQsxG84AUZnvpYiiCBlwBK6xrgdxVxffHBpMy/E6vLkJPhd8x?=
 =?us-ascii?Q?nvm7U0K/A9GFfAwKJ1/UphaXug+bJrWp7s1VCoebOq+efJgM3qyuowKmt9Ma?=
 =?us-ascii?Q?vQ+WXbe5cxIDjX2Vw8PCMOEbJKO2ZKgW7Vx115GGNs2+4XMCnAxwu1ceNeAv?=
 =?us-ascii?Q?SSKCM2Tkh+VAsmpXzSLHKUVPrYURhYN6UmcYfIcYaRA3o0rFaEqEMZFIx7l4?=
 =?us-ascii?Q?1bu4Iveqeh344AFSH5raQVzGTWYRuyzhHIMGWBMvCftt?=
X-MS-Exchange-CrossTenant-Network-Message-Id: cf8b61b3-a510-4a77-0d72-08da64de34f8
X-MS-Exchange-CrossTenant-AuthSource: DM4PR11MB6311.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Jul 2022 14:44:36.2410
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: HEUC2zwaGTL6ar+Fd8M2EJ0mfAQpIXf5I4gkBaRAVSrKi9MdB6rIRQpd/aIda0A8dxKi/MuWcBpQz0Wc5uBuVg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR11MB3610
X-OriginatorOrg: intel.com

On Tue, Jul 12, 2022 at 12:07:52PM -0700, Dan Williams wrote:
> Given that decoder instance order is fundamental to the DPA translation
> sequence for endpoint decoders, enforce that cxl_decoder_for_each() returns
> decoders in instance order. Otherwise, they show up in readddir() order
> which is not predictable.
> 
> Add a list_add_sorted() to generically handle inserting into a sorted list.
> 
> Signed-off-by: Dan Williams <dan.j.williams@intel.com>
> ---
>  cxl/lib/libcxl.c |    8 ++++++-
>  util/list.h      |   61 ++++++++++++++++++++++++++++++++++++++++++++++++++++++
>  2 files changed, 68 insertions(+), 1 deletion(-)
> 
> diff --git a/cxl/lib/libcxl.c b/cxl/lib/libcxl.c
> index f36edcfc735a..e4c5d3819e88 100644
> --- a/cxl/lib/libcxl.c
> +++ b/cxl/lib/libcxl.c
> @@ -19,6 +19,7 @@
>  #include <ccan/short_types/short_types.h>
>  
>  #include <util/log.h>
> +#include <util/list.h>
>  #include <util/size.h>
>  #include <util/sysfs.h>
>  #include <util/bitmap.h>
> @@ -908,6 +909,11 @@ cxl_endpoint_get_memdev(struct cxl_endpoint *endpoint)
>  	return NULL;
>  }
>  
> +static int decoder_id_cmp(struct cxl_decoder *d1, struct cxl_decoder *d2)
> +{
> +	return d1->id - d2->id;
> +}
> +
>  static void *add_cxl_decoder(void *parent, int id, const char *cxldecoder_base)
>  {
>  	const char *devname = devpath_to_devname(cxldecoder_base);
> @@ -1049,7 +1055,7 @@ static void *add_cxl_decoder(void *parent, int id, const char *cxldecoder_base)
>  			return decoder_dup;
>  		}
>  
> -	list_add(&port->decoders, &decoder->list);
> +	list_add_sorted(&port->decoders, decoder, list, decoder_id_cmp);
>  
>  	free(path);
>  	return decoder;
> diff --git a/util/list.h b/util/list.h
> index 1ea9c59b9f0c..c6584e3ec725 100644
> --- a/util/list.h
> +++ b/util/list.h
> @@ -37,4 +37,65 @@ static inline void list_add_after_(struct list_head *h,
>  	(void)list_debug(h, abortstr);
>  }
>  
> +/**
> + * list_add_before - add an entry before the given node in the linked list.
> + * @h: the list_head to add the node to
> + * @l: the list_node before which to add to
> + * @n: the list_node to add to the list.
> + *
> + * The list_node does not need to be initialized; it will be overwritten.
> + * Example:
> + *	struct child *child = malloc(sizeof(*child));
> + *
> + *	child->name = "geoffrey";
> + *	list_add_before(&parent->children, &child1->list, &child->list);
> + *	parent->num_children++;
> + */
> +#define list_add_before(h, l, n) list_add_before_(h, l, n, LIST_LOC)
> +static inline void list_add_before_(struct list_head *h, struct list_node *l,
> +				    struct list_node *n, const char *abortstr)

I see a list_add_before() in the latest ccan list code.[1]  Should we just use
that?  The implementation is a bit different.

[1] https://ccodearchive.net/info/list.html 

> +{
> +	if (l->prev == &h->n) {
> +		/* l is the first element, this becomes a list_add */
> +		list_add(h, n);
> +		return;
> +	}
> +
> +	n->next = l;
> +	n->prev = l->prev;
> +	l->prev->next = n;
> +	l->prev = n;

Did you mean to add list_debug() here?

Ira

> +}
> +
> +#define list_add_sorted(head, n, node, cmp)                                    \
> +	do {                                                                   \
> +		struct list_head *__head = (head);                             \
> +		typeof(n) __iter, __next;                                      \
> +		typeof(n) __new = (n);                                         \
> +                                                                               \
> +		if (list_empty(__head)) {                                      \
> +			list_add(__head, &__new->node);                        \
> +			break;                                                 \
> +		}                                                              \
> +                                                                               \
> +		list_for_each (__head, __iter, node) {                         \
> +			if (cmp(__new, __iter) < 0) {                          \
> +				list_add_before(__head, &__iter->node,         \
> +						&__new->node);                 \
> +				break;                                         \
> +			}                                                      \
> +			__next = list_next(__head, __iter, node);              \
> +			if (!__next) {                                         \
> +				list_add_after(__head, &__iter->node,          \
> +					       &__new->node);                  \
> +				break;                                         \
> +			}                                                      \
> +			if (cmp(__new, __next) < 0) {                          \
> +				list_add_before(__head, &__next->node,         \
> +						&__new->node);                 \
> +				break;                                         \
> +			}                                                      \
> +		}                                                              \
> +	} while (0)
> +
>  #endif /* _NDCTL_LIST_H_ */
> 
> 
