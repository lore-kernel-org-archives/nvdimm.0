Received: from mga14.intel.com (mga14.intel.com [192.55.52.115])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C030A4681
	for <nvdimm@lists.linux.dev>; Wed, 13 Jul 2022 16:23:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1657729427; x=1689265427;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=+w8JlPdnbSXy9K2SsIjXZpTGi+gn0jld9ei9MueHv08=;
  b=TYwQ7LqooKEty3xqtNPIE9yFoyXADaosGVvkfszXpeuThbdYplnOt1nL
   XaojU7s82Rv8YZ/XfKcGUsVLaAZJ6mH0i3bQQwFAyEgz0eBPJPClfdfNC
   HtGsuIESnzeBnQmDtgSV1FktvInu8uFBYfv1hMoqa7eC3LH5YP3CRPM/V
   hlQeIixKOcWMjoTRuQvcfk/bXYjrCm6mZP8u+9CGlkc7EAaXu8m/XiZ3Z
   jvHzgLg/QvuTKztpo5DWl/3Xi+kGdluAKNW3LHNloeYufd++HJs1z6SxC
   nsI8MItoykGFQbkAeUBiPUQfKYRczL0e6tLGwtd08G++s6COPlpHT3yKE
   g==;
X-IronPort-AV: E=McAfee;i="6400,9594,10407"; a="285298769"
X-IronPort-AV: E=Sophos;i="5.92,267,1650956400"; 
   d="scan'208";a="285298769"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Jul 2022 09:23:47 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.92,267,1650956400"; 
   d="scan'208";a="653465579"
Received: from fmsmsx601.amr.corp.intel.com ([10.18.126.81])
  by fmsmga008.fm.intel.com with ESMTP; 13 Jul 2022 09:23:47 -0700
Received: from fmsmsx603.amr.corp.intel.com (10.18.126.83) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.27; Wed, 13 Jul 2022 09:23:46 -0700
Received: from fmsedg601.ED.cps.intel.com (10.1.192.135) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.27 via Frontend Transport; Wed, 13 Jul 2022 09:23:46 -0700
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (104.47.66.47) by
 edgegateway.intel.com (192.55.55.70) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2308.27; Wed, 13 Jul 2022 09:23:46 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=R3sDNRUKFJqUO01OCAsrdJVgymQLHeCpDEVs7K9mn9wTEb0JhS1ayztjF72YnZR/Io0J7qsc4ezQtXqqLxnLEfuacUzfHGRE1VJNr7IdYBIoEm9uANfs+NUyuE1OHMdFFdlxFl5BDEtm+9ZTIBr8+0Tz2rihyfJYBautLrOOsalmNiLUOqaUy2xJVK+dCwCIknSZQfDSp+WsWrdsXeRyrx9GiOkZ72Jj+Zbi7uw0yeN5aXqU6McY/tRLMVgLaH5NPQmrMDf32oAC4J94gIgCZzimSMVzcJAbn1SfbKZojgA0oJ1lcH+Rpg2I3vgtESg0eEeTElflTbD2PEn5vRFi3g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=weKw4/ilS6BNWn3XGPmKnBlWOxH5Vl1zBUO396++Qdw=;
 b=eY5lT9jh4YLr45jknYzAmisvqQdhrswWXN9QcHwhf3uJL+4nU30D1lf/0ZZifkHAHALzkHrzulLvicpgSUvB3ZOkmObpbWFTCqS+nDKtLUK/tyuLkYs/xntM6mMDbRxp2W0ZY2sPDGCT/FOL8ntgHmD5fNzS1D2ZZ/ByaGzuZsjEbsEA1vpi51pTtXsz0RvP63h54TEk1GBSenwwdUrbMI/qFbZ2qp5C8HfY1Iu06JKxdSZR8P/h/GnooGx6k1q+DILFiy3Hqs0NWt8zar90CJRmrL3gBpXXJQDoLMsWtCpX5PbdrtiIPE9BFSkjt6VCHcLsIXC77gsVxpDRsZCmfg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from MWHPR1101MB2126.namprd11.prod.outlook.com
 (2603:10b6:301:50::20) by SA2PR11MB5180.namprd11.prod.outlook.com
 (2603:10b6:806:fb::16) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5417.20; Wed, 13 Jul
 2022 16:23:45 +0000
Received: from MWHPR1101MB2126.namprd11.prod.outlook.com
 ([fe80::6466:20a6:57b4:1edf]) by MWHPR1101MB2126.namprd11.prod.outlook.com
 ([fe80::6466:20a6:57b4:1edf%11]) with mapi id 15.20.5417.026; Wed, 13 Jul
 2022 16:23:44 +0000
Date: Wed, 13 Jul 2022 09:23:42 -0700
From: Dan Williams <dan.j.williams@intel.com>
To: Ira Weiny <ira.weiny@intel.com>, Dan Williams <dan.j.williams@intel.com>
CC: <vishal.l.verma@intel.com>, <alison.schofield@intel.com>,
	<nvdimm@lists.linux.dev>, <linux-cxl@vger.kernel.org>
Subject: Re: [ndctl PATCH 05/11] cxl/lib: Maintain decoders in id order
Message-ID: <62cef18e713c4_156c6529419@dwillia2-xfh.jf.intel.com.notmuch>
References: <165765284365.435671.13173937566404931163.stgit@dwillia2-xfh>
 <165765287277.435671.14320322485572083484.stgit@dwillia2-xfh>
 <Ys7aTMGj7m7l1kGS@iweiny-desk3>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <Ys7aTMGj7m7l1kGS@iweiny-desk3>
X-ClientProxiedBy: BY3PR05CA0023.namprd05.prod.outlook.com
 (2603:10b6:a03:254::28) To MWHPR1101MB2126.namprd11.prod.outlook.com
 (2603:10b6:301:50::20)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 05c20dd6-7c87-4a4d-212a-08da64ec0e84
X-MS-TrafficTypeDiagnostic: SA2PR11MB5180:EE_
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Z3lH56ROZDBuEJtkF0L9Nx3hYO8pcTerM7o8zTAD3ILbjR8sRkPD16/E9FmRp6ppqfIHcvc9MYQRdWjP/t/GVrgEB6E2vBzhOdewCE5/uwKf115xTvROEfeoz8XFR/VU7JV48oWyulee29qnrrCRPb3VNCEcNikMDnsUcp487Mex074PM0uSO0EpSgDLkomGbk1ThkM8rxrSxFFj8PUd/CZVG++qdVMnc5lSYqr0bSVohUYsXGm7P0CybONY8XKdlPPPI3uxWEX0d8XCSsMwFbkhRrLEkxAm/al5VI36Ff71qTXwFLviSW0U7IOZ69g/8gzPAruGknHU6eNeBW2rfLhA99ivJKLMbTaOOTfkrn7ctFRK46FZqAmjBpz7XsbSsECoTFgR5NDrTBGD50t1Vt9jAdlE2B5yLEOvW1J6usNjN69WY1wrgU1SVWw1R1dREzrZJXole/w47p7TYoLL9rvS8IkcYG1agxKCB+35+sigqJMaBoXqu+iMlFwwyOilhihTrWkU3eG0dGWUQP7eJr80gb33+Qcgd0nByMecwjQRK0qVP2TW7UOWKHL6yyGdz6UfPGToIZiRKH02Nm6qYkcHq0j9Nt9DU6UrJw7+RPhabbURxzml4qtxzOM1ArFB9CwwKhoUXV1s+1VEO+EwmMp8nICn/vTtEXdYDob+bW5JkPjeVN/LACzXwP6jkRBjW5wgfVd16l3H/KoPih6Tzf802QGiXAOGpyhnAiN3Ljz10TsDyX9ARu5b/zS1UruLvBjGowMVgXrXvkLatCBG1+aXqaitomU1j7t3GkdF3eA=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR1101MB2126.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(39860400002)(396003)(136003)(366004)(376002)(346002)(26005)(38100700002)(2906002)(478600001)(66556008)(6506007)(83380400001)(8936002)(5660300002)(110136005)(41300700001)(8676002)(4326008)(186003)(966005)(6486002)(6512007)(82960400001)(66946007)(66476007)(316002)(9686003)(86362001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?atlNAiy4fJfK+DEacvS9U9x8nk7IJBeW9lY9MfL5TizPsHZJl1RL59R1oKkR?=
 =?us-ascii?Q?ghM0cbwzsza3OTXUhA98TKNhfPJLEE0ZZbXruo5f+H/iw8VbbDsSxikvjm7l?=
 =?us-ascii?Q?wjRS1BZpf5jQfBWqgnULVWjkf86O+c+3mWSMFrvB0gVIRLqcGQ3J5dhDZuuu?=
 =?us-ascii?Q?bqWE8BJc+vPg4sYJDXk+i8oqwF1U2mn1/O7yacl3CR0l0jiGLX6SIku2pU6y?=
 =?us-ascii?Q?JwfAy2lLNUqh1u2r2lVUSC7YtJojRTfmB6VDcdQFsrmwBv20AcKiCGsHUApt?=
 =?us-ascii?Q?MyCpBUtVM9B9hmYD7C6yYLQEuzgdgTYortlK6AYMBUc9oudrYMgDRuhBLl3B?=
 =?us-ascii?Q?WfmDrHjeKS+/r3h4HltRgEval++sgUfSoTn2yahHr/wky6XBYWmAoJwEe8/I?=
 =?us-ascii?Q?Hfz6TMnzjuioq9JCuEYzXE0oeE6Qp2twNnoqTPkfYFTwZdzdTf149xDgzCtn?=
 =?us-ascii?Q?qGrKq9kzfOYb5x+akJKqaWCDam44+9xSEUeNQ3CBtZ6d3kJtXcA+3xbW0y00?=
 =?us-ascii?Q?rqx5jvr5A21u74RYSs5IuJv/E5sWdjbHxRXMZvcLNEMuVN74wN96o9ZKP8G7?=
 =?us-ascii?Q?QChZ5fKLKY2gSftVyELMsZQE0XSb827X/lqkNRDB/C3BgOXhsVpnvPEyRbeT?=
 =?us-ascii?Q?4dwowtFEuhX8MKh4XrNGApVknIscCBPRNylnFEP4QDc45MjsHOSqpzf/VMEd?=
 =?us-ascii?Q?A5U/NFvPqGLHHufOdCaFCcOM6BwFjdytgPA6Phn8JBBsTNiqjU68LmOXDmBP?=
 =?us-ascii?Q?Lt4Rxf9L3HSfFCLeVyGkDfMw124MlfWTr+7q41KolwzLI40u+KgjDPmvz3JZ?=
 =?us-ascii?Q?eRhFyp5eqOkeWVik9vEjHx6HldFfcYLrAycyXbYhbHdYhE3veXkeZulRAFpO?=
 =?us-ascii?Q?nTDZgyOEmLzvmyDp8PW/tS8qB4rWhlfdDcIkAQ23W+d+qUsfYmFqezASWJe6?=
 =?us-ascii?Q?D+7JPph615z3OHr4Nv/28aK4twtmdsGvghbL6d/6VERmGMPhoDoVFmIUkkDa?=
 =?us-ascii?Q?oqMaZi62hmEXOGsMVklpAiOvnRQUl6LLWs9oQo9b3fUUDfIxLz0sPMPNEVFr?=
 =?us-ascii?Q?7kn1JrWG5oEFF3kiEy1HZ1J+VzO6MblCC3TbvWo7yglIwTS9WI4dP+JERLRI?=
 =?us-ascii?Q?DRXfTIrOVLRHoEE0osIcexifdTi+1jJEEN2sINELtyK4rsdlZ2G+gzUCYfQ8?=
 =?us-ascii?Q?yNH7HjujgH1LgDKLdcY5ryNYo+JK+YGRm5RAiupbbLnXhHxWcaAlHs3BO9iJ?=
 =?us-ascii?Q?DyPvQl2WbGtFUghy/7kqpW9ipa3Wgts46XNz1z3ZRs+NsMBiAqU+nILd2nC4?=
 =?us-ascii?Q?xeb/xzqhPWe8GpwTxM4lxXL/Zm2SoAnzW55hEcBoOasEjh2FX/rX3XQUm0cg?=
 =?us-ascii?Q?RtTSOEOTPRBTX7U3rPOoJ3XVewG51PYNVv+RHrYqCiCGGglc41nb6b79YOY7?=
 =?us-ascii?Q?FE/mqos3ePaScuTZewLhmDLMtQFp+B9WOsR4YkU6XIqcx9HL+Y8Irfwd+zQ/?=
 =?us-ascii?Q?7ehilL7qcmGKaF6JpFslBLieXyIa7+Y+TybLk1eGyp3mTknG4oK8vxkrGK1Y?=
 =?us-ascii?Q?jOfu35Z5yLKGADdw1dGsaztOHsnB2XBz10jLuMoZJtU49sEJSUIqkPALLEpF?=
 =?us-ascii?Q?3Q=3D=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 05c20dd6-7c87-4a4d-212a-08da64ec0e84
X-MS-Exchange-CrossTenant-AuthSource: MWHPR1101MB2126.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Jul 2022 16:23:44.8070
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: fZQ7GuLbtGbBV0rxeqSs4EmEIjNq4zksh4iGcvs0pqB8BToR4FDfVcQsFyLqc39MY4mQlGE1rVJCif/MUNTmAKIagn+xzp1I9aLmNM20I18=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA2PR11MB5180
X-OriginatorOrg: intel.com

Ira Weiny wrote:
> On Tue, Jul 12, 2022 at 12:07:52PM -0700, Dan Williams wrote:
> > Given that decoder instance order is fundamental to the DPA translation
> > sequence for endpoint decoders, enforce that cxl_decoder_for_each() returns
> > decoders in instance order. Otherwise, they show up in readddir() order
> > which is not predictable.
> > 
> > Add a list_add_sorted() to generically handle inserting into a sorted list.
> > 
> > Signed-off-by: Dan Williams <dan.j.williams@intel.com>
> > ---
> >  cxl/lib/libcxl.c |    8 ++++++-
> >  util/list.h      |   61 ++++++++++++++++++++++++++++++++++++++++++++++++++++++
> >  2 files changed, 68 insertions(+), 1 deletion(-)
> > 
> > diff --git a/cxl/lib/libcxl.c b/cxl/lib/libcxl.c
> > index f36edcfc735a..e4c5d3819e88 100644
> > --- a/cxl/lib/libcxl.c
> > +++ b/cxl/lib/libcxl.c
> > @@ -19,6 +19,7 @@
> >  #include <ccan/short_types/short_types.h>
> >  
> >  #include <util/log.h>
> > +#include <util/list.h>
> >  #include <util/size.h>
> >  #include <util/sysfs.h>
> >  #include <util/bitmap.h>
> > @@ -908,6 +909,11 @@ cxl_endpoint_get_memdev(struct cxl_endpoint *endpoint)
> >  	return NULL;
> >  }
> >  
> > +static int decoder_id_cmp(struct cxl_decoder *d1, struct cxl_decoder *d2)
> > +{
> > +	return d1->id - d2->id;
> > +}
> > +
> >  static void *add_cxl_decoder(void *parent, int id, const char *cxldecoder_base)
> >  {
> >  	const char *devname = devpath_to_devname(cxldecoder_base);
> > @@ -1049,7 +1055,7 @@ static void *add_cxl_decoder(void *parent, int id, const char *cxldecoder_base)
> >  			return decoder_dup;
> >  		}
> >  
> > -	list_add(&port->decoders, &decoder->list);
> > +	list_add_sorted(&port->decoders, decoder, list, decoder_id_cmp);
> >  
> >  	free(path);
> >  	return decoder;
> > diff --git a/util/list.h b/util/list.h
> > index 1ea9c59b9f0c..c6584e3ec725 100644
> > --- a/util/list.h
> > +++ b/util/list.h
> > @@ -37,4 +37,65 @@ static inline void list_add_after_(struct list_head *h,
> >  	(void)list_debug(h, abortstr);
> >  }
> >  
> > +/**
> > + * list_add_before - add an entry before the given node in the linked list.
> > + * @h: the list_head to add the node to
> > + * @l: the list_node before which to add to
> > + * @n: the list_node to add to the list.
> > + *
> > + * The list_node does not need to be initialized; it will be overwritten.
> > + * Example:
> > + *	struct child *child = malloc(sizeof(*child));
> > + *
> > + *	child->name = "geoffrey";
> > + *	list_add_before(&parent->children, &child1->list, &child->list);
> > + *	parent->num_children++;
> > + */
> > +#define list_add_before(h, l, n) list_add_before_(h, l, n, LIST_LOC)
> > +static inline void list_add_before_(struct list_head *h, struct list_node *l,
> > +				    struct list_node *n, const char *abortstr)
> 
> I see a list_add_before() in the latest ccan list code.[1]  Should we just use
> that?  The implementation is a bit different.
> 
> [1] https://ccodearchive.net/info/list.html 

Ah, thanks for checking. Yeah, probably time to refresh our fork to the
latest upstream baseline.

> 
> > +{
> > +	if (l->prev == &h->n) {
> > +		/* l is the first element, this becomes a list_add */
> > +		list_add(h, n);
> > +		return;
> > +	}
> > +
> > +	n->next = l;
> > +	n->prev = l->prev;
> > +	l->prev->next = n;
> > +	l->prev = n;
> 
> Did you mean to add list_debug() here?

Looks like we get that for free with the upstream rebase.
