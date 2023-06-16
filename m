Received: from mga18.intel.com (mga18.intel.com [134.134.136.126])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7BF41627
	for <nvdimm@lists.linux.dev>; Fri, 16 Jun 2023 01:23:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1686878582; x=1718414582;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=9rEBLM8cuACwsqk2eBmkmzcxYlbkkUFr5ExJXaCnzt0=;
  b=HoXBr3WVo/MqFsUAhc8M/kvLZ12NMQNZCdlzd9tzRC5K36BRt3Crhlhm
   sxtN924+PiZlDu1n+UDb2aJGYGP0Ta18dVCJZYPTUc+xaLWia7FcyCkjK
   iokCv91pOLvUnGwbxfIblpseKUVaKsW5g072/M7JPH9YtYzWnUoYoXAV+
   c8s6GuvuwenMJycoTOIIUUTp4UVqk1bELvn8CVd8J1mRDTuCBOWqjkkUC
   CRDVAWpz3sKpJwlHgrT0DkCggjZptvwMxWS7rnpFA7pgPvqxME3TiNSKJ
   /HzP7AFocLbR9738u27lRWVkpadyq9V4nb2YMoDr+cjzOBzws0t1H7BuS
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10742"; a="343825529"
X-IronPort-AV: E=Sophos;i="6.00,246,1681196400"; 
   d="scan'208";a="343825529"
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Jun 2023 18:22:47 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10742"; a="662985126"
X-IronPort-AV: E=Sophos;i="6.00,246,1681196400"; 
   d="scan'208";a="662985126"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by orsmga003.jf.intel.com with ESMTP; 15 Jun 2023 18:22:47 -0700
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Thu, 15 Jun 2023 18:22:47 -0700
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23 via Frontend Transport; Thu, 15 Jun 2023 18:22:47 -0700
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (104.47.70.109)
 by edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.23; Thu, 15 Jun 2023 18:22:46 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=jocBTGTueZBqI8todTOgy/HE/grLMOoX9vLZE8sr6jfQ8X8hwU5r2NDRT97QYXIZ9bUVkbU76Ce4e881ikD3ifbV/tzJaoCYTgkkP8dM44N3JAdgndGrDG/4wDclGKg+IKnwjj1O5Xd9Q5Ce/epO29x+amKgd9L8dn12WDcPMyk+O2J554zPdewhUosyHIgZa9wHyZTfeoX00tP9Oh0fmMU2lTyWyuwgn2C/yLlu5fp+/RjCOmW1quBUNCbW+gEBebsmzjDeWWTJgPL+Ck488USQGaKYoSxFQAY9Hi/eHbQuZTAaxBOZuLnlj0uP//dS4EGhFIt4Zhm2EXQn/EBZig==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=9Cn9+V6qlwJzXMk+aCAyR6kj9PLXsvd0XEFsAQ6hIl4=;
 b=iZwH/rZbGNRkOyp1R9BYRzcjb5Zj7CrLHW0+e4QNZZW1YJ1ARty80CyxIDwEfk+hDapv0r9ylRuzHwSUS2JjWopuXnfHHz6AtPf/PrTgLJJgC5V/tcDMSLT2BoHAEK81xmfkHxdz64V+dYDSa4RYvkOaxw7mV0dPI0sDuJSWCqhMN3tHyyKPDTeTbIAVMX5a3slQkDIk16yW9GEhHljHrJLkfhkPGyKrr+t9V8hyCYFCeNQ6oA13QWtdhMJJYwUpnUuEC1kmd0XcSLCT068NXhcykwW4xAxmIr1EZMbjSNJy3HeXf0k1nxpvh63fiHwVc+vI88pJMTOJyHtuxx1KRg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from BY1PR11MB8127.namprd11.prod.outlook.com (2603:10b6:a03:531::20)
 by IA1PR11MB6220.namprd11.prod.outlook.com (2603:10b6:208:3e8::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6500.27; Fri, 16 Jun
 2023 01:22:39 +0000
Received: from BY1PR11MB8127.namprd11.prod.outlook.com
 ([fe80::e527:9093:f7ea:d514]) by BY1PR11MB8127.namprd11.prod.outlook.com
 ([fe80::e527:9093:f7ea:d514%5]) with mapi id 15.20.6477.037; Fri, 16 Jun 2023
 01:22:39 +0000
Date: Thu, 15 Jun 2023 18:22:36 -0700
From: Dan Williams <dan.j.williams@intel.com>
To: Ira Weiny <ira.weiny@intel.com>, Dan Williams <dan.j.williams@intel.com>,
	<nvdimm@lists.linux.dev>
CC: Yongqiang Liu <liuyongqiang13@huawei.com>, Paul Cassella
	<cassella@hpe.com>, Ira Weiny <ira.weiny@intel.com>,
	<linux-cxl@vger.kernel.org>
Subject: Re: [PATCH 3/4] dax: Introduce alloc_dev_dax_id()
Message-ID: <648bb95cd38e8_142af8294c6@dwillia2-xfh.jf.intel.com.notmuch>
References: <168577282846.1672036.13848242151310480001.stgit@dwillia2-xfh.jf.intel.com>
 <168577284563.1672036.13493034988900989554.stgit@dwillia2-xfh.jf.intel.com>
 <647bfd7e1ef3_4c9842941c@iweiny-mobl.notmuch>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <647bfd7e1ef3_4c9842941c@iweiny-mobl.notmuch>
X-ClientProxiedBy: SJ0PR03CA0010.namprd03.prod.outlook.com
 (2603:10b6:a03:33a::15) To BY1PR11MB8127.namprd11.prod.outlook.com
 (2603:10b6:a03:531::20)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BY1PR11MB8127:EE_|IA1PR11MB6220:EE_
X-MS-Office365-Filtering-Correlation-Id: cd982f46-1eb5-4321-103a-08db6e082c6e
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 7gxPHGPIV1/YgSh/MSEAz+++uh0mwFfmQq2f0hz8MQHq0pEvl+ibpYhR0SllIrC5cnKfpsqJCNX20p0QkY8oIWbdMYO9XyGTHpR3nc7ctayEYq2s4UCdyrlrAfXKRKqglH/aEEBks0GVJgSlLlyp0ZY1HaFHFR+5vhI5WtGCTou6wM8FxiGlyXRy87dGEsRkJjJ8B2IdjyJ0xr3FvvJ2r11dNCeufDbhfqbcLUzoSHZmB2gZd5RjyoBh9H1TrwoLY79LOQwMtZ8MQH6cf55/hMQ/t3wV6gLH7mI2ieBZLY5LC1Wxa7koesNDNi9vEPEZ/LQxCpZMEt8yanLCHXl+WpWHIoIWJYfcE8z5OmMg89AtphPPQkfuD88OmeBGDcynhx+1mcqVYcv0T4NyWSeJ+f23IA3XjrPV1PGLBB4FmYz1pJCzAPpeZPSI+qgGxTJ1Cmiq7YGw2G5yuVxToT9SdJEcQHkYLXP9MCjQBwclYIuuDcAygYSDnkwpO4KHl8aPiqVcqK/735qFaql/WTGWBc+uZC9k6+FGkQoICeGtzj1UTkTWy2m5zvSvl0ok3xKoWmJHDyU8ph4Hy0DN6m54Bw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY1PR11MB8127.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(396003)(39860400002)(346002)(136003)(366004)(376002)(451199021)(5660300002)(478600001)(54906003)(8936002)(41300700001)(966005)(316002)(8676002)(6486002)(6506007)(186003)(110136005)(4326008)(66556008)(66476007)(66946007)(6666004)(26005)(9686003)(6512007)(83380400001)(2906002)(38100700002)(82960400001)(86362001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?N0ZcdAWA1jBOH+sCQ01ibXmHq8wOeMntHncFmgeZ5FlOKDIiKHMtz7PxfkHL?=
 =?us-ascii?Q?86O4IF41SuiQ+w7v3HQivjl1YgOTidk6fSGdAX6yvsfLKx1wc+poLTNSvb/r?=
 =?us-ascii?Q?jhoFas42dWTWMzy3GMSbBVy9vb9HTD+7BjEIV5/e09BlAXoThbRaPZUHOpAs?=
 =?us-ascii?Q?zKYGvvWFgvbb0gQuZLrdWJrj1kX2yQrcWj3fEB4o33ZPWxbrkafyzSlj6Le4?=
 =?us-ascii?Q?7TpwxOF59mcKoK2yqVdIA412AX/1TjWh4HVIjsRqxCPWQMndStimvuQq55Hs?=
 =?us-ascii?Q?sg07B4CikR27amgTexeCbbspeo2GOHRXXrN8A2JsZDvnHKPL9ty6mWIdLufh?=
 =?us-ascii?Q?NBRMyWsXi6ZI8JDtxJqNcCvtD1G9TMBSPJigDqeP1wDCGxkFQNZezB4cEZWx?=
 =?us-ascii?Q?5uMw/UiqNOyvELp577zXigcc3qKJRTlweetBEwETsshYSab0jrSwe7+iYFou?=
 =?us-ascii?Q?UcJK3ROXHt+nIcJ0ZWAsTRGRZ66lzJ1CHF1rQFwrjaUWGffpMNpiL71ehQA1?=
 =?us-ascii?Q?YwY8UZHUcB5vE1g8t7DtP3uoiDoiNkjoot5Iw1AFEozDcsdt/lNRKW/1vKym?=
 =?us-ascii?Q?GQ+FfNdu/6FHtKNdd/Xyms4meysdb+o/fnzoNX1AtqiYVasTYDPrQNFIIBFl?=
 =?us-ascii?Q?65dQZGsLyRtQhckd1+75uGvpD0uacm6KFlRpWgRJ2heqGQG6tqpwvIRVpHPt?=
 =?us-ascii?Q?r2GDgHSgs84xM1XdNeWP2CPy9znR16Hz9WL5OWGNSLGVcKIPW8PtHyUWqn8v?=
 =?us-ascii?Q?CqOkSMmofxCsa18iz4WMP1fFtmbtFaJ2IFck+SgSdNiqM7qrw4Y0KXw/ZRxU?=
 =?us-ascii?Q?KZEiLhrmH/qc5wm14i1nYWLwqxMcA9mE+mq2xcEmhyhuyM7vCEZ2v3T/m9dq?=
 =?us-ascii?Q?FsEuUC8wr0CllBWL4JAlMDaMGVgy1R+DAmnvvrbb0+avab4o9aQahQRsvMUp?=
 =?us-ascii?Q?ofH+sE/Dnapz+4/DPuyaCvdb4NRp7BaecjN8UqJMkBeAjra66ehKn5MaG64m?=
 =?us-ascii?Q?E9X8PZxOPPm9waBfwHawDAjH37xVQSQH0nCy9TzpSzwNkfZRBFI/fx9cOieu?=
 =?us-ascii?Q?OuvJhcnre8K8RvqjwZx3cVdplG2t8eE5GsGhkJMPj24+LoEKUJJvLhK4odYr?=
 =?us-ascii?Q?km4as0i6rN6p9r7jpNRSYh3BbbJaPHzj3Sm3Mm3vs9qLk/9Nqbn/Miayn6hu?=
 =?us-ascii?Q?Gm9rMqE61rCoSaPfcndQry+YJ1Oud81UXBBoz8f7m154i7A0nNvNLC1hNchh?=
 =?us-ascii?Q?scU7C2MZpclZfiRql+jb90ATUWtwCH4krNQvCjBNkVmKcGyv2lE6pFqC44wy?=
 =?us-ascii?Q?OIYauLuJiko5zoWft9SQpEcErPze7h1X+2Ik04aiavbnjDCoeLnTA6A4Dn62?=
 =?us-ascii?Q?wpPrljfVTscDF/6/aWeP9UYGjv4KTPYk2W22T/EjziY1wRoRqzxter1R7kDL?=
 =?us-ascii?Q?OgDJFwtmef283eTW+7v/0NqzwFiY8Jy9ymFYZRdDkSPuPvXEaEb7z3jdHuw6?=
 =?us-ascii?Q?JvwSaOeKR+AGh4+ucdG2+kU9SlcYjZuklpJZUivjYLo7O10EiYoImDVUSVfL?=
 =?us-ascii?Q?rzqNv1UVbdEA9aedruK8zOZzm3zWa52A3Fc46XBcgd2VIRM93OxHLME4UZRf?=
 =?us-ascii?Q?KA=3D=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: cd982f46-1eb5-4321-103a-08db6e082c6e
X-MS-Exchange-CrossTenant-AuthSource: BY1PR11MB8127.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Jun 2023 01:22:38.9152
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: B8eJusNekWJnpEAsNEKGXy2AD+hLhrmPdGxxMSfUbcYkLwR16eaDPJJfy6zA/YCaSKvIXZu9JGGqeEsimOn7zLptrXVk41Oln4hJvuI4M/Q=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR11MB6220
X-OriginatorOrg: intel.com

Ira Weiny wrote:
> Dan Williams wrote:
> > The reference counting of dax_region objects is needlessly complicated,
> > has lead to confusion [1], and has hidden a bug [2]. Towards cleaning up
> > that mess introduce alloc_dev_dax_id() to minimize the holding of a
> > dax_region reference to only what dev_dax_release() needs, the
> > dax_region->ida.
> > 
> > Part of the reason for the mess was the design to dereference a
> > dax_region in all cases in free_dev_dax_id() even if the id was
> > statically assigned by the upper level dax_region driver. Remove the
> > need to call "is_static(dax_region)" by tracking whether the id is
> > dynamic directly in the dev_dax instance itself.
> > 
> > With that flag the dax_region pinning and release per dev_dax instance
> > can move to alloc_dev_dax_id() and free_dev_dax_id() respectively.
> > 
> > A follow-on cleanup address the unnecessary references in the dax_region
> > setup and drivers.
> > 
> > Fixes: 0f3da14a4f05 ("device-dax: introduce 'seed' devices")
> > Link: http://lore.kernel.org/r/20221203095858.612027-1-liuyongqiang13@huawei.com [1]
> > Link: http://lore.kernel.org/r/3cf0890b-4eb0-e70e-cd9c-2ecc3d496263@hpe.com [2]
> > Reported-by: Yongqiang Liu <liuyongqiang13@huawei.com>
> > Reported-by: Paul Cassella <cassella@hpe.com>
> > Reported-by: Ira Weiny <ira.weiny@intel.com>
> > Signed-off-by: Dan Williams <dan.j.williams@intel.com>
[..]
> > @@ -1326,6 +1340,7 @@ struct dev_dax *devm_create_dev_dax(struct dev_dax_data *data)
> >  	if (!dev_dax)
> >  		return ERR_PTR(-ENOMEM);
> >  
> > +	dev_dax->region = dax_region;
> 
> Overall I like that this reference is not needed to be carried and/or
> managed by the callers.
> 
> However, here you are referencing the dax_region from the dev_dax in an
> unrelated place to where the reference matters (in id management).
> 
> Could alloc_dev_dax_id() change to:
> 
> static int alloc_dev_dax_id(struct dev_dax *dev_dax, struct dax_region *dax_region)
> {
> ...
> }
> 
> Then make this assignment next to where the kref is taken so it is clear
> that this is the only user of the reference?
> 
> I did not pick up on the fact this reference was only needed to free the
> id at all in reviewing the code and I think this would make it even more
> clear.

I hesitate only for symmetry reasons. I.e. that there are many interfaces in
this file, in addition to free_dev_dax_id(), where @dax_region is
implicitly retrieved from the @dev_dax.
