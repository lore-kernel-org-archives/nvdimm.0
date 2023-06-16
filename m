Received: from mga05.intel.com (mga05.intel.com [192.55.52.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8B2E36AA4
	for <nvdimm@lists.linux.dev>; Fri, 16 Jun 2023 22:12:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1686953534; x=1718489534;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=ysXV/SiNHKUVkwsZfiu+4628bOXl0DYKAK4YNTVudiI=;
  b=GzatSdc1CVInxT14d+Y9/MOzFKjJWw/uhCKQn+sqkCkGZGNExcVnm1o6
   6JTOjwNpuyInGQ5rmPqbcZF6eyTYjDP+qD04IS8Hfnl5Qy7x1pBxlLy1f
   oiYxZPVSAfZbAG/O6QH34qBvyWTCaBUID6pCP1zxwufE5LRSSZ1VtkI/t
   aePUTwV/zxLCEAwd8KCEd5KKYdQS1468uSgdnJyQhmX7SaC+QFw+rGd+I
   WAMcGcgA8DUubsTLQt+WLFHQie8qt2tG1VudIcVXzwH/3X5udj+Xf20WF
   zGmVNsyCeMhBtZXlB8pRpmas91ckThgwu4Yfba7trFw8S1o8WPDqKtcQB
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10743"; a="445704562"
X-IronPort-AV: E=Sophos;i="6.00,248,1681196400"; 
   d="scan'208";a="445704562"
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Jun 2023 15:12:13 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10743"; a="802987950"
X-IronPort-AV: E=Sophos;i="6.00,248,1681196400"; 
   d="scan'208";a="802987950"
Received: from fmsmsx602.amr.corp.intel.com ([10.18.126.82])
  by FMSMGA003.fm.intel.com with ESMTP; 16 Jun 2023 15:12:13 -0700
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Fri, 16 Jun 2023 15:12:12 -0700
Received: from fmsedg602.ED.cps.intel.com (10.1.192.136) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23 via Frontend Transport; Fri, 16 Jun 2023 15:12:12 -0700
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (104.47.58.104)
 by edgegateway.intel.com (192.55.55.71) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.23; Fri, 16 Jun 2023 15:12:03 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=JGhnnBx/L6c+4u3oNoqfxYEFzZr/7wlf3+F83Cw5R89OuL+ZkhfbL4cCMAKq88HkoHkMHUCWeyRpwi/rlzhby7OQU07FPw98TCgHhVJ6hGvycrXA66daMOdhooAI9IYvJPM6/lqpzEab3BwJa/W1DNf97MUbhBePVDmeG4mL2gD1cfWr9mPgAkrMbM7S5R7kCaSxUSoxAlpr/jSHcbLgQqOg3XUSFQ+My2YM40ZPtDsG9+eD2bgXLv0ILKPd5E5l16+n2+WdmMHRkK9CaQn1SY5mnowVqJhBfeKSw4rRkzVcA2DGmkPSuyLVEJc7vkdIqnMXR/91/QWQUFaWmzYOZA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=W8qIhhhrIdLN0gOJnF6dEnxHJ+OnQQpZ0hakaV66P/M=;
 b=JbUR2o5eTnk7+Wvcz4ZUUhd3ZpOzkoGX0XJxhwqJMpLAeNi9k6+ez+xUh5cUJGoZ0ce6GroLQvBOT0d+r7+S9/1EFLlg5mdF6YZOXroUm1rXFS/+44HnIHYB8NPXkGRatGbYUam5vvVsXZc7Hvlk71ethiuHdbeIf6TCgm7S1TTIkfm2ZQRFj7EulrGS0kk4fgClW4bQgR0wmUtFeqoN0DxiWOMJr6fZvJ4T+EPvnO4Bhc6u5RS9Aq4X85yVRwD9KOZmRiF1cDFYkZZYNRbyHofYPpkDnBcw2pnETxmff+lTXIXqAgZV2nxNfJVuCvujo31m1iCCLFDX5dPnkfOjnQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from SA1PR11MB6733.namprd11.prod.outlook.com (2603:10b6:806:25c::17)
 by PH7PR11MB6548.namprd11.prod.outlook.com (2603:10b6:510:210::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6477.37; Fri, 16 Jun
 2023 22:12:02 +0000
Received: from SA1PR11MB6733.namprd11.prod.outlook.com
 ([fe80::7237:cab8:f7f:52a5]) by SA1PR11MB6733.namprd11.prod.outlook.com
 ([fe80::7237:cab8:f7f:52a5%7]) with mapi id 15.20.6500.029; Fri, 16 Jun 2023
 22:12:02 +0000
Date: Fri, 16 Jun 2023 15:11:55 -0700
From: Ira Weiny <ira.weiny@intel.com>
To: Dan Williams <dan.j.williams@intel.com>, Ira Weiny <ira.weiny@intel.com>,
	<nvdimm@lists.linux.dev>
CC: Yongqiang Liu <liuyongqiang13@huawei.com>, Paul Cassella
	<cassella@hpe.com>, Ira Weiny <ira.weiny@intel.com>,
	<linux-cxl@vger.kernel.org>
Subject: Re: [PATCH 3/4] dax: Introduce alloc_dev_dax_id()
Message-ID: <648cde2b40d65_1da39e2941f@iweiny-mobl.notmuch>
References: <168577282846.1672036.13848242151310480001.stgit@dwillia2-xfh.jf.intel.com>
 <168577284563.1672036.13493034988900989554.stgit@dwillia2-xfh.jf.intel.com>
 <647bfd7e1ef3_4c9842941c@iweiny-mobl.notmuch>
 <648bb95cd38e8_142af8294c6@dwillia2-xfh.jf.intel.com.notmuch>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <648bb95cd38e8_142af8294c6@dwillia2-xfh.jf.intel.com.notmuch>
X-ClientProxiedBy: SJ0PR13CA0007.namprd13.prod.outlook.com
 (2603:10b6:a03:2c0::12) To SA1PR11MB6733.namprd11.prod.outlook.com
 (2603:10b6:806:25c::17)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SA1PR11MB6733:EE_|PH7PR11MB6548:EE_
X-MS-Office365-Filtering-Correlation-Id: c8782941-ea77-4499-b0d4-08db6eb6b5ee
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: ndianLvnkIWo5MjSDYe25nt6eDwRkOy7KVmF1hbIaUUbtZC6TC/PyUWuuEjk7h4bl69cUrqF1GeCs3Uveftzcp7rZmbbc3KC0E6Pdl0ohDg+4EPgq4Uze43CfvyHhT9VyiWBc98I7CdUKWY3SImcXTorLCylAsaA0bzrmd5zWeOXkNeFjB9yrf84+Z8bWlwOnrvUStco5ViCeIpdkZ3RoYXHQPXixaHLjfBxUjp1WEEB9Q29pk6IW9h4hSerKLfTdiL6Yj7uP1DV6SnjKWxEFo2XCA8QrfVOUnpeOXU+QDgx8NglpEFsRekbYZ/LImnOY5+tZ5jopQJGOcv+czygZGcIAktCG4p4j20E71Mb/HpGckFkZRbAKpNOEY0AMTBJ3tV03vHiZnPek9EMHzVSkTpD59ey81N7H99jooDHmXc05q3Y7ctziQePZ9BbaxSmlGdBdEdmmTtgBymR4LJgXaqtNRdWpoXgbkkQNPmmJbBnjvL1ooROVm4cYlONV0kxi37x1pmRqsB22TWerrKB8Gykk19Rq1FORDcy1HqwD8vYXCMsiReXyxolB6sF3LU5JCMwpnKsLOeCfVZlW5oGug==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR11MB6733.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(346002)(396003)(366004)(136003)(39860400002)(376002)(451199021)(6512007)(186003)(9686003)(6506007)(83380400001)(4326008)(66476007)(66556008)(2906002)(66946007)(26005)(86362001)(82960400001)(6486002)(966005)(5660300002)(41300700001)(8936002)(8676002)(316002)(44832011)(38100700002)(54906003)(110136005)(478600001)(6666004);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?t/QQSwcgfSxOujqxSDmFDrPrtw9kMoW8N4ZelN/T+CaKX2ylCqMppwyIXlin?=
 =?us-ascii?Q?bspMNRzB6WnAajoqusaE4xx8BHPEqhntL4x4XikRAf+uj4srzJAkYoRzQdcq?=
 =?us-ascii?Q?TeV2UmApHnOrHcIlFkuMO173Am/6rL6ROL4WLOXFJoOi9toVpgKX1CUq/K6F?=
 =?us-ascii?Q?kCF7uU1vx3Js9P/ZksHiI3CiMAf1Dr7mtA02k9xr7XK2fk5AveftZErbXnLn?=
 =?us-ascii?Q?LdSYGLDt65ykXEfVHHjhmi9hwHE6LZsjrYF3cPkyQ6tbtXcYAjzGrNMhewG9?=
 =?us-ascii?Q?167xvgi6GoFNkk5M4MvY/G9GrDXNa3sNQbv/SWCkBCxABjnm7fGqGGYeut9/?=
 =?us-ascii?Q?gLomhhm8iXGYEyKAMlh0EpEmOjAy/3Z1YC/aoQlgFByVYjzkzhWj3YPB/dW6?=
 =?us-ascii?Q?INC0e1/s08y7wLkSkQJE7+1CaFaiGPcN+DJXoEXIXrb8KH4iLxHNiKWkr/f7?=
 =?us-ascii?Q?8lK9PQF9XSuYEqX2K2DlH7M61yK+tFDJMn9CTnLeWy1SBxzeO4qk/hZanjoc?=
 =?us-ascii?Q?LxrY2TNG4vHMUudO7zzL3dVxHpTLdCH85anaHFV/H7+tgt4Djzu7GLGNMkrU?=
 =?us-ascii?Q?uzyO6STmHgRoMWwXH0w7iv4rI3MKBA+rDWcknbWZsrTTgi1SLHHYNCoqJGyc?=
 =?us-ascii?Q?mGVg3DVcWYPqpL9RnoLXZG0JzjIASElbCZycEuJTKcmF9+qOa/NXRTd3sR9a?=
 =?us-ascii?Q?GV3sgqYcg5JU66wH+5bW9fj/CiS9c+tMB0NnM2WfpXD8Elj5Edd+ZmvmXTH1?=
 =?us-ascii?Q?Kzi4YN0DfzzYnrCzngTrDscGxzGOS/tY3q4sBNW8EAACZP57VxMgCsE1DXGE?=
 =?us-ascii?Q?i3GJaST2pdn2rhCZCALJWBUW61BqQ4mK3uLBM8gEuHQcr6TSqjFCnU+qpOY9?=
 =?us-ascii?Q?JUXRYS10o0I4I3FlgDqatTDNThsB0djD3Azgd5vI9poP2Bjgaw9Uimf6Peuh?=
 =?us-ascii?Q?W5OWwDza1fA5BVwVtSac1AKt1vkOrsej83HGNbNDVPUXDb7pO9tJkvgXQVZy?=
 =?us-ascii?Q?aKPXFuRRHuFQ8E5sdAa3xHLZdFt0EQ6BsKv1QoOamT7fIeah7dft7lG/f+TI?=
 =?us-ascii?Q?8PzL2aShEIgy9eubjT/O9WnYfJa8Cq0mwykv3xaXq+pdfpzEWMl0g5AdBOoG?=
 =?us-ascii?Q?ntjV2e0Wwv0PzFfx2dphYendD82itA44IUGkplvQoXiCsui5wghdWWMxcZuU?=
 =?us-ascii?Q?21GK5yH/6icZEeL3SuGzlUgihE+2f066JxXYmhJjkBOgeTmee166SSfm5NSK?=
 =?us-ascii?Q?GjYx/9TWiGjxDuDIrNp0432FOKd7FNJMIs4gEK4trzSmodiHfcWlyxIIvFFy?=
 =?us-ascii?Q?Rj9M9H4TkLwfA8h/X4XAf7gZcZSrcS8/0dJKGo10SFxMehkd0uySe3urlCcp?=
 =?us-ascii?Q?eK6jCb9imzU9GvBNTLe+IYIqQozAyLGbSx04yOh79yFl8gUY9LQ4gqdk09fh?=
 =?us-ascii?Q?FeSDO6X8PiIfn9BCdlFGUeWoFv1Q74Z8R3CLO4B+croVtp0nzZfCYIxhPg+4?=
 =?us-ascii?Q?oFif9ZjHIwzGzPzAiaAFwQ1a+sTvlp6OLZWaBXEPl0q0CObR0gm3nF9HiQTl?=
 =?us-ascii?Q?PTuwsJSkjqKUChsgiY9mjP7WJQ+P7hhZBmHMfZRN?=
X-MS-Exchange-CrossTenant-Network-Message-Id: c8782941-ea77-4499-b0d4-08db6eb6b5ee
X-MS-Exchange-CrossTenant-AuthSource: SA1PR11MB6733.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Jun 2023 22:12:02.0945
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Z1BjqCe9W/Sx5DQ9ke3xW+CXlLhM2CTaDNUD6FBuzY2H+l7m1cA10dRh0VH5r+b9d5JmWs7AfAvSqoKTzV3J+g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR11MB6548
X-OriginatorOrg: intel.com

Dan Williams wrote:
> Ira Weiny wrote:
> > Dan Williams wrote:
> > > The reference counting of dax_region objects is needlessly complicated,
> > > has lead to confusion [1], and has hidden a bug [2]. Towards cleaning up
> > > that mess introduce alloc_dev_dax_id() to minimize the holding of a
> > > dax_region reference to only what dev_dax_release() needs, the
> > > dax_region->ida.
> > > 
> > > Part of the reason for the mess was the design to dereference a
> > > dax_region in all cases in free_dev_dax_id() even if the id was
> > > statically assigned by the upper level dax_region driver. Remove the
> > > need to call "is_static(dax_region)" by tracking whether the id is
> > > dynamic directly in the dev_dax instance itself.
> > > 
> > > With that flag the dax_region pinning and release per dev_dax instance
> > > can move to alloc_dev_dax_id() and free_dev_dax_id() respectively.
> > > 
> > > A follow-on cleanup address the unnecessary references in the dax_region
> > > setup and drivers.
> > > 
> > > Fixes: 0f3da14a4f05 ("device-dax: introduce 'seed' devices")
> > > Link: http://lore.kernel.org/r/20221203095858.612027-1-liuyongqiang13@huawei.com [1]
> > > Link: http://lore.kernel.org/r/3cf0890b-4eb0-e70e-cd9c-2ecc3d496263@hpe.com [2]
> > > Reported-by: Yongqiang Liu <liuyongqiang13@huawei.com>
> > > Reported-by: Paul Cassella <cassella@hpe.com>
> > > Reported-by: Ira Weiny <ira.weiny@intel.com>
> > > Signed-off-by: Dan Williams <dan.j.williams@intel.com>
> [..]
> > > @@ -1326,6 +1340,7 @@ struct dev_dax *devm_create_dev_dax(struct dev_dax_data *data)
> > >  	if (!dev_dax)
> > >  		return ERR_PTR(-ENOMEM);
> > >  
> > > +	dev_dax->region = dax_region;
> > 
> > Overall I like that this reference is not needed to be carried and/or
> > managed by the callers.
> > 
> > However, here you are referencing the dax_region from the dev_dax in an
> > unrelated place to where the reference matters (in id management).
> > 
> > Could alloc_dev_dax_id() change to:
> > 
> > static int alloc_dev_dax_id(struct dev_dax *dev_dax, struct dax_region *dax_region)
> > {
> > ...
> > }
> > 
> > Then make this assignment next to where the kref is taken so it is clear
> > that this is the only user of the reference?
> > 
> > I did not pick up on the fact this reference was only needed to free the
> > id at all in reviewing the code and I think this would make it even more
> > clear.
> 
> I hesitate only for symmetry reasons. I.e. that there are many interfaces in
> this file, in addition to free_dev_dax_id(), where @dax_region is
> implicitly retrieved from the @dev_dax.


Ok but the reason we need this extra reference and for the dax_region to
live this long is because the ida within the dax_region.  Otherwise the
normal device references would be enough, right?

Regardless, I've convinced myself this is ok.

Reviewed-by: Ira Weiny <ira.weiny@intel.com>

Ira
