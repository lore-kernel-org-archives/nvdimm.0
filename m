Received: from mga12.intel.com (mga12.intel.com [192.55.52.136])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0EE7B7B
	for <nvdimm@lists.linux.dev>; Fri, 30 Sep 2022 00:21:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1664497301; x=1696033301;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=6LDtAd6R0zXseFuhmkxEQoQNIcplGRtfHqh7/PGdq7c=;
  b=K1V3CtQaPkuQIV2jpb+QytP4JXtVi6W2lJJwVYIELI9tQ78yKgiT/e5X
   UwR5OyjclvK1hkzAa9UAXP19+UILtphWdCOxvaA5VeUbnQWxsUJ2eteho
   DqnFCozXhv2ei5rQSXWJpHiquvQ3Ad5/hIwFOS2ckPfOhR/xYaE+XW/Zn
   H80v4Ykm3AH5sMWkZhPQs7KLDe/9o7rxNUcj6x5HB3WAIHa3lXgLgfX1p
   u7nG27KvajKI00sx8boiHPdqIJJFm7+kqlbw/lqK06OS9zXeXLdfS2Qd/
   QmygVOdKBQNCDKgiqdZn4pq5U+eU6TmKvloUw5jD4y0WvuYE/Q+I2bw9t
   g==;
X-IronPort-AV: E=McAfee;i="6500,9779,10485"; a="281773866"
X-IronPort-AV: E=Sophos;i="5.93,356,1654585200"; 
   d="scan'208";a="281773866"
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Sep 2022 17:21:39 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10485"; a="748044051"
X-IronPort-AV: E=Sophos;i="5.93,356,1654585200"; 
   d="scan'208";a="748044051"
Received: from orsmsx602.amr.corp.intel.com ([10.22.229.15])
  by orsmga004.jf.intel.com with ESMTP; 29 Sep 2022 17:21:38 -0700
Received: from orsmsx608.amr.corp.intel.com (10.22.229.21) by
 ORSMSX602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Thu, 29 Sep 2022 17:21:38 -0700
Received: from orsmsx602.amr.corp.intel.com (10.22.229.15) by
 ORSMSX608.amr.corp.intel.com (10.22.229.21) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Thu, 29 Sep 2022 17:21:37 -0700
Received: from ORSEDG601.ED.cps.intel.com (10.7.248.6) by
 orsmsx602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31 via Frontend Transport; Thu, 29 Sep 2022 17:21:37 -0700
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (104.47.58.168)
 by edgegateway.intel.com (134.134.137.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2375.31; Thu, 29 Sep 2022 17:21:37 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=CBNaKn6BN7DONqHVzXv6GaQw+hsIYetXmdJc69EuwSlcjqRXigU0dqQcw0MJpsv3KhTfarIMPZnG1gFxtP5/ZB7Y/ZXjkoB/ibiRYqdZB3kvpVBCbpQ9xJQ7YyRiB0Q32oz5IiTI1hf79m5iz5XI1XKEbjV0P/LzduOllMA5mVcghk4xXBfH4M5rQZC0GYPG6q8IvM8A2z8LR+wIv+VVmeQweDMaIRnAihBd6xO5ejobPgzDyJAa0zTQGnXpXkR6wqo16xv9hDhx2MPPQrzeFGBPqWJTINi1AmilJAWG3HtoSX/5pm9gmwh1ChdQRndFYtudGF+JS/BBnoOWyMGe2g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=MPPxkZzZTRkoQRp2tH8cg1qw6sk26PR9QlBh6JPnQW4=;
 b=MYja2t47lMQqNp0t0Q0QLMsDBPIQn6UQi3t/CpGjyz/oIiFojxG1s2ux0vyCCw0RXrjTykFNcPEaUaTnvaVYKSgXNRK4UWeI0NEO5mxoprSarycQGA6LhQDCaye/Ec6SkEj6HhJ+BoLv/dyvrPOMRIYDL7onNTDu+42x59fJyoVRNXwobsx9yqCRFYy3iDykkD7gYAzizNaWMDKuBhIz08nQ2/HxRJFhBhJ2zlA5N54OuqKyhEk5ABazeG9ctMJmEyEWLLxzm7G/ChWdjmXyfBZqU/MRleVXkutaRgYBG2DyHEASM/ofqbpPvmgy+N6tCCjcxsb3l1Id6njAHpEHbw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from MWHPR1101MB2126.namprd11.prod.outlook.com
 (2603:10b6:301:50::20) by PH8PR11MB6754.namprd11.prod.outlook.com
 (2603:10b6:510:1c9::6) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5676.20; Fri, 30 Sep
 2022 00:21:35 +0000
Received: from MWHPR1101MB2126.namprd11.prod.outlook.com
 ([fe80::7d5a:684d:99f7:4e83]) by MWHPR1101MB2126.namprd11.prod.outlook.com
 ([fe80::7d5a:684d:99f7:4e83%12]) with mapi id 15.20.5676.017; Fri, 30 Sep
 2022 00:21:35 +0000
Date: Thu, 29 Sep 2022 17:21:28 -0700
From: Dan Williams <dan.j.williams@intel.com>
To: Tyler Hicks <tyhicks@linux.microsoft.com>, Jeff Moyer <jmoyer@redhat.com>
CC: Dan Williams <dan.j.williams@intel.com>, Vishal Verma
	<vishal.l.verma@intel.com>, Dave Jiang <dave.jiang@intel.com>, Ira Weiny
	<ira.weiny@intel.com>, Aneesh Kumar K.V <aneesh.kumar@linux.ibm.com>, "Pavel
 Tatashin" <pasha.tatashin@soleen.com>, "Madhavan T. Venkataraman"
	<madvenka@linux.microsoft.com>, <nvdimm@lists.linux.dev>,
	<linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2] libnvdimm/region: Allow setting align attribute on
 regions without mappings
Message-ID: <6336368898b9a_795a629421@dwillia2-xfh.jf.intel.com.notmuch>
References: <20220830054505.1159488-1-tyhicks@linux.microsoft.com>
 <x49tu4tlwj9.fsf@segfault.boston.devel.redhat.com>
 <20220926202912.GA58978@sequoia>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20220926202912.GA58978@sequoia>
X-ClientProxiedBy: BY5PR17CA0015.namprd17.prod.outlook.com
 (2603:10b6:a03:1b8::28) To MWHPR1101MB2126.namprd11.prod.outlook.com
 (2603:10b6:301:50::20)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: MWHPR1101MB2126:EE_|PH8PR11MB6754:EE_
X-MS-Office365-Filtering-Correlation-Id: bb7d9c88-e565-4a19-7539-08daa279bba3
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: i42NnGEuGyaomZg/04tM05AlMEx06h4BI/6fQLudpjYfpe0R+0jUypyUrKlDp8f8yLoLHpdktjA3Fsi9qvDspB7UnJIflBRZjDAJDSfWNkyTDNt781w3T3AE1o7OHbKtsafDfJrIO2YWbT2xgx9QgZK1G5F/vjW4I2bt3zJcPB9HaERIduvPYV5Uq0Nil1tSTu+BauR9Gp+Ohb0q/oAldiW+iIeuwa4cmSlARCW89jsEXR+ojQqAPvzn4qV8M8mk5DcyazkE4EJydTKVUbwUUd1/Gu1SpfGRf2AWAR885uDIFIWykxLUz54GtsY8MkCEGepSEQDrV/eo7HH1iUUzBeH5sZOcBY42pRNnPnmGEb2uZ9PFjcr57KdWrPcJZ9AsuagTgywgmeDgFocBJDlj8ElTQH6eTQ08cPqUSTB7JYSGiT36bnBrJEqaegt4urkaUs+Yu8XSv9wmNbA8tydnMgLsBxSyiNb1FlCI4OV7FQaosdZEsJcz6+65Wlm55hFzRjc4oGaX6fSRfcNo0IILZb8Hlh9qib2E6Ty9x0qjFjzsh6N+dTFRRS0h6JoWEAZVCD6jTpIlVgf3sx8/LtQUyTZJY3TpX2/rbpjHOL6epZzlKZLzT+JD0xsCHr3+52JHQsux7NJ/vgvpdzGczBhB1vAm+82pF2RwubuQf5g1NFWEDlFjW71bXR1sE+286kUyJKErfeomi63iM2N7NtN2Ghx7ZIYeOsIW+sl9RAQ3tjkS/2bEg74ykQGV9mu72lKamA5Nq73pzWWTfaq0wfbMcw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR1101MB2126.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(396003)(346002)(376002)(39860400002)(136003)(366004)(451199015)(6512007)(41300700001)(66476007)(66556008)(4326008)(66946007)(8676002)(9686003)(26005)(53546011)(38100700002)(316002)(6506007)(54906003)(110136005)(8936002)(86362001)(5660300002)(82960400001)(966005)(186003)(6486002)(2906002)(83380400001)(478600001)(6666004);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?dPTmzqlsfhW9g91DLE6jZ18Nn0ACPNEmCHfgY/aO/uqPrR6cvYGX3LgSIjkP?=
 =?us-ascii?Q?bRUQGQ0CBnTwVERZBaL9gS2ll1bQYH/04wJFhIauONSCyVfPWJ+v+9BumrKJ?=
 =?us-ascii?Q?lQsvgLDiprXyvxzv9RdxKxol9agqxBBsPVzn9eKuEJ+C+9JSnyFmsUAILTwq?=
 =?us-ascii?Q?DPtKHQ06CT8yg7R0ur41YcLBOnxKDQ/bAb6z3IdbPILHFLtBnoAiQ9Be8hE3?=
 =?us-ascii?Q?jpILy7z0lacLh1BPCZmij6INNzjQZmXDvTqu2B4brKi0GHLPtiKXT2QyrGOY?=
 =?us-ascii?Q?PHcNZK5VLFjLlIxV1NOZL5dxllL8I5z19xFF+dcBwAEUP0wadCC75TMUHUVB?=
 =?us-ascii?Q?crnxZQylMuf49gaoEQlSI7ElKFphRhPDD12oGtnBNUgUHl+rO4x6sjnTO5X4?=
 =?us-ascii?Q?QuBBcoQIMz5QwuhA7I69m+SEpYWy7Yfim5oHg6NKWE5SCNH3uh8LsClCuU63?=
 =?us-ascii?Q?HjcLbc5RL+/lKg/er+MprFChwCh2HohTGDUr/J6Ft/E4fZ8Nox6ROLoAIl3T?=
 =?us-ascii?Q?Mlc+a0Umczqf5UxVGOEADUUYhfsnmMEdij2WjYIq0gx9xYUkBx6jwOmzo7gA?=
 =?us-ascii?Q?n0sCAeZVl4IrsOFJMkbEArIvWIUEMNFxFmO4LviP6v/Q9CSiur7Y9tXaMcDU?=
 =?us-ascii?Q?nXlVqpQRnnXMEcOEJqJkn3B0II0arvGb2tcpvWfsf5bb1CebnYbm19Ii66v3?=
 =?us-ascii?Q?d22aAMaKYj/ri+HK1RENqJWU69wocdqQJIijS7NU3+H1zrkOCT7cPzOwBmnM?=
 =?us-ascii?Q?jOJt01WQ4KqueRHFBXuy32Nk9s0YqIMzefApYgURZ31n3xNfYxmEGkXmPG8L?=
 =?us-ascii?Q?AsMPSRZ/dXGDs/Mjpwsy/LTV7y1ortI93jv+6j5FjC+0tfEvQGd/i4T3HvH3?=
 =?us-ascii?Q?k+8XiKgIG7XigHdnOV66CUtSnsdOALNLnGdV52VdbNqv0zu2sp0T3Z+PxnP4?=
 =?us-ascii?Q?jlcvAjfguJkS5eSrEzO1pHjyMURCWBZAAfykGgbn+6Teqxfak/UnD9KVcpiF?=
 =?us-ascii?Q?9KequIYO/yIm4nTcefh18r+OTydXRGx7bdfksI67zm9HoAVnfRcy7PQiV7n5?=
 =?us-ascii?Q?jlw659rO9hTYD9ceRrCDR+ok6m1Q6NAbnZdTeLaIsuEXOi8VNe73wvl4mZ3R?=
 =?us-ascii?Q?ZjWjFdUVMJcs4XE3doHWboFMBC7oihDCDYWdg1o03yMmm06dT4vB+z7ecwob?=
 =?us-ascii?Q?nZU1tRVooE4JVxVuSzT+8WMhQaxDXUiu6SzY9Gqxzqg2y7zxkSTmYhd20S/g?=
 =?us-ascii?Q?Me1dUXXbe7vc05evNpthA4CWjQ6sYISoZgVLX6PzOddr4OQu4lIekgSzRPZl?=
 =?us-ascii?Q?ZEvWGwrMW729d8Kti67JNLq81aZfHDCTdVpM+nld+VazmX+1NG+ly3mPeMVC?=
 =?us-ascii?Q?TRsbM3T5r3ixcKe4610EuMdskml22+BHKcHJWYKf1x6XS/m58ga1SdlcmY10?=
 =?us-ascii?Q?W20by2d75+fbnzVIT7ksvOtPS0EuwXNJAP9pywN8pDlru6TON7+snIlDN7CI?=
 =?us-ascii?Q?iEhDscSYHI95LZI1vH587D/GEqrhQPgbiaLGUoCgiILLD8qLsMJ+VCFS03vt?=
 =?us-ascii?Q?rqGTCUT4sEWdZBckZ6gPqsbj3KsXpT9snlQXoFBwTtpl3HjkiyLSjitglPsF?=
 =?us-ascii?Q?Jw=3D=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: bb7d9c88-e565-4a19-7539-08daa279bba3
X-MS-Exchange-CrossTenant-AuthSource: MWHPR1101MB2126.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Sep 2022 00:21:35.1797
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: J0SjY3KugHy7CQDV8OqL0wSQ7pzZt6NFU1sMoqFwrmcJRXcqBJ1VvBqR6nMgcrDjbuoQIWN9GyUWd/wT1D8Ewa/2ChiJQPocwOoWjPAJ+LQ=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH8PR11MB6754
X-OriginatorOrg: intel.com

Tyler Hicks wrote:
> On 2022-09-26 16:18:18, Jeff Moyer wrote:
> > Tyler Hicks <tyhicks@linux.microsoft.com> writes:
> > 
> > > The alignment constraint for namespace creation in a region was
> > > increased, from 2M to 16M, for non-PowerPC architectures in v5.7 with
> > > commit 2522afb86a8c ("libnvdimm/region: Introduce an 'align'
> > > attribute"). The thought behind the change was that region alignment
> > > should be uniform across all architectures and, since PowerPC had the
> > > largest alignment constraint of 16M, all architectures should conform to
> > > that alignment.
> > >
> > > The change regressed namespace creation in pre-defined regions that
> > > relied on 2M alignment but a workaround was provided in the form of a
> > > sysfs attribute, named 'align', that could be adjusted to a non-default
> > > alignment value.
> > >
> > > However, the sysfs attribute's store function returned an error (-ENXIO)
> > > when userspace attempted to change the alignment of a region that had no
> > > mappings. This affected 2M aligned regions of volatile memory that were
> > > defined in a device tree using "pmem-region" and created by the
> > > of_pmem_region_driver, since those regions do not contain mappings
> > > (ndr_mappings is 0).
> > >
> > > Allow userspace to set the align attribute on pre-existing regions that
> > > do not have mappings so that namespaces can still be within those
> > > regions, despite not being aligned to 16M.
> > >
> > > Link: https://lore.kernel.org/lkml/CA+CK2bDJ3hrWoE91L2wpAk+Yu0_=GtYw=4gLDDD7mxs321b_aA@mail.gmail.com
> > > Fixes: 2522afb86a8c ("libnvdimm/region: Introduce an 'align' attribute")
> > > Signed-off-by: Tyler Hicks <tyhicks@linux.microsoft.com>
> > > ---
> > >
> > > While testing with a recent kernel release (6.0-rc3), I rediscovered
> > > this bug and eventually realized that I never followed through with
> > > fixing it upstream. After a year later, here's the v2 that Aneesh
> > > requested. Sorry about that!
> > >
> > > v2:
> > > - Included Aneesh's feedback to ensure the val is a power of 2 and
> > >   greater than PAGE_SIZE even for regions without mappings
> > > - Reused the max_t() trick from default_align() to avoid special
> > >   casing, with an if-else, when regions have mappings and when they
> > >   don't
> > >   + Didn't include Pavel's Reviewed-by since this is a slightly
> > >     different approach than what he reviewed in v1
> > > - Added a Link commit tag to Pavel's initial problem description
> > > v1: https://lore.kernel.org/lkml/20210326152645.85225-1-tyhicks@linux.microsoft.com/
> > >
> > >  drivers/nvdimm/region_devs.c | 8 +++-----
> > >  1 file changed, 3 insertions(+), 5 deletions(-)
> > >
> > > diff --git a/drivers/nvdimm/region_devs.c b/drivers/nvdimm/region_devs.c
> > > index 473a71bbd9c9..550ea0bd6c53 100644
> > > --- a/drivers/nvdimm/region_devs.c
> > > +++ b/drivers/nvdimm/region_devs.c
> > > @@ -509,16 +509,13 @@ static ssize_t align_store(struct device *dev,
> > >  {
> > >  	struct nd_region *nd_region = to_nd_region(dev);
> > >  	unsigned long val, dpa;
> > > -	u32 remainder;
> > > +	u32 mappings, remainder;
> > >  	int rc;
> > >  
> > >  	rc = kstrtoul(buf, 0, &val);
> > >  	if (rc)
> > >  		return rc;
> > >  
> > > -	if (!nd_region->ndr_mappings)
> > > -		return -ENXIO;
> > > -
> > >  	/*
> > >  	 * Ensure space-align is evenly divisible by the region
> > >  	 * interleave-width because the kernel typically has no facility
> > > @@ -526,7 +523,8 @@ static ssize_t align_store(struct device *dev,
> > >  	 * contribute to the tail capacity in system-physical-address
> > >  	 * space for the namespace.
> > >  	 */
> > > -	dpa = div_u64_rem(val, nd_region->ndr_mappings, &remainder);
> > > +	mappings = max_t(u32, 1, nd_region->ndr_mappings);
> > > +	dpa = div_u64_rem(val, mappings, &remainder);
> > >  	if (!is_power_of_2(dpa) || dpa < PAGE_SIZE
> > >  			|| val > region_size(nd_region) || remainder)
> > >  		return -EINVAL;
> > 
> > The math all looks okay, and this matches what's done in default_align.
> > Unfortunately, I don't know enough about the power architecture to
> > understand how you can have a region with no dimms (ndr_mappings == 0).
> 
> Thanks for having a look!
> 
> FWIW, I need this working on arm64. It previously did before the commit
> mentioned in the Fixes line. ndr_mappings is 0 when defining a
> pmem-region in the device tree. The region is also marked as 'volatile'
> but I don't recall if that contributes to ndr_mappings being 0.

Oh, ndr_mappings being 0 can also happen for cases where the platform
just does not advertise any DIMMs / nmemX devices that map to a region.
It is not possible for ndr_mappings to change at run time as they are
only established at nd_region_create() time. The change looks good to
me.
