Received: from mga11.intel.com (mga11.intel.com [192.55.52.93])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C54892F28
	for <nvdimm@lists.linux.dev>; Sat,  3 Dec 2022 17:06:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1670087182; x=1701623182;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=OCdHLqhLGYSBcjOQg2738qxTvV8jGI1zIcbvSDopCfU=;
  b=QiEq5eUsEvx8tNMOKuTKdRR95A9kqbSvWJs4grEkj9iwwRSCf7o5Jelc
   eH9zp4Ol7EKapdgQ6Idgy3O+SAc8WnuAy6i9G2kuYLx8XOZqFTbRSnDgp
   iEv1UmaJCQTNSrcx0ZCL86d5HnUU0CNaAEHzpLKrWfQQTnHSYfugp089i
   byrDbfe5TmMdbyAV69/jSumPFjJe3A0ACt8i6EZc2eU+XhsMHn3M8/ZeY
   N+vgFds6qGF0y4CIMGkJbmd6C2c1CjN37qlKVjhiBi2I0uxioUOeNrKHH
   6B8YoMh6V9ObukXvJLeejeM/trQa6ygtbPVsJdCxqTk9TWIlflZDvuUHg
   g==;
X-IronPort-AV: E=McAfee;i="6500,9779,10549"; a="313776828"
X-IronPort-AV: E=Sophos;i="5.96,214,1665471600"; 
   d="scan'208";a="313776828"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Dec 2022 09:06:10 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10549"; a="708806518"
X-IronPort-AV: E=Sophos;i="5.96,214,1665471600"; 
   d="scan'208";a="708806518"
Received: from fmsmsx601.amr.corp.intel.com ([10.18.126.81])
  by fmsmga008.fm.intel.com with ESMTP; 03 Dec 2022 09:06:10 -0800
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Sat, 3 Dec 2022 09:06:10 -0800
Received: from fmsedg601.ED.cps.intel.com (10.1.192.135) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16 via Frontend Transport; Sat, 3 Dec 2022 09:06:10 -0800
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (104.47.56.177)
 by edgegateway.intel.com (192.55.55.70) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.16; Sat, 3 Dec 2022 09:06:10 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=kkKsXlNODradP5GICX83RZYKQHb2v1MaAlyFKHJM3llBHQUEFWWf7n8FXcjyXx66MdAcH6+gkZZXuc29MM6dlvsRIthPz/NB0/oa8PDlk2X/dqHYk9XjaE83nB8KXc5zwRcRkyXec0G7p7cxULEOb/3m38MS/+h76fH7wON3tLeL2C4grp2Nw8pAMfb0/xB/E4DjqIS9HPByHc42NVSNh+VfKeJEMlkON29ywC1m+GUjWPkN4XiAMEbeumB0lLnCz81RuelEl2ohWT1o93MK8SHKvxvHzw5nsqWpzY9K48ZK2boC11ONgUmQE7Q5Axg/2QpUCnex6UQdIx6kBzn0yA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=uOEZyg9eAEpY9jEfWNcrrFCgfnRD/x8o96IRayJTdaY=;
 b=eA06Dtsz+BWUU88n1kd3YtzrMBWL15AduLY39xvm3AhU01qrBU4uLbo5rvEHZHEGQy8Tz9by9Ubq9dYIhx8yV81h70+Za80Ti0H4OtiEW2q6FvhYHD4lFYOjA6oP/BPNC/DSkuur5AsuCUZHj+kdz7MWrdT2bLqZ2a+XFoNJZTvyxhqEWC2jxXH1OtylL8sBxu8Zu4waIVGxIALPwSxB4xHHtRsYjSc7Ahte2CthCwZeBfRyzBcl/pFZ9V4lpA/2w2dk9hseJov0L57xG4kqyGm1Rx1N3SVTTQw6b2FHme/LadZmTKc0RH6udbRt+Uvy7a6yrt0yyX2FzRVi2o9C9w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from MWHPR1101MB2126.namprd11.prod.outlook.com
 (2603:10b6:301:50::20) by MW4PR11MB6788.namprd11.prod.outlook.com
 (2603:10b6:303:208::11) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5880.11; Sat, 3 Dec
 2022 17:06:07 +0000
Received: from MWHPR1101MB2126.namprd11.prod.outlook.com
 ([fe80::340d:cb77:604d:b0b]) by MWHPR1101MB2126.namprd11.prod.outlook.com
 ([fe80::340d:cb77:604d:b0b%9]) with mapi id 15.20.5880.011; Sat, 3 Dec 2022
 17:06:07 +0000
Date: Sat, 3 Dec 2022 09:06:05 -0800
From: Dan Williams <dan.j.williams@intel.com>
To: Robert Richter <rrichter@amd.com>, Dan Williams <dan.j.williams@intel.com>
CC: <linux-cxl@vger.kernel.org>, Terry Bowman <terry.bowman@amd.com>,
	<alison.schofield@intel.com>, <bhelgaas@google.com>, <dave.jiang@intel.com>,
	<nvdimm@lists.linux.dev>
Subject: Re: [PATCH v6 08/12] cxl/acpi: Extract component registers of
 restricted hosts from RCRB
Message-ID: <638b81fd1f5ab_c957294cc@dwillia2-mobl3.amr.corp.intel.com.notmuch>
References: <166993040066.1882361.5484659873467120859.stgit@dwillia2-xfh.jf.intel.com>
 <166993044524.1882361.2539922887413208807.stgit@dwillia2-xfh.jf.intel.com>
 <Y4m0WbVSWjkeF+7x@rric.localdomain>
 <638af5119969_3cbe0294cb@dwillia2-xfh.jf.intel.com.notmuch>
 <Y4tyxE3Q7EIvMpVG@rric.localdomain>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <Y4tyxE3Q7EIvMpVG@rric.localdomain>
X-ClientProxiedBy: SJ0PR13CA0128.namprd13.prod.outlook.com
 (2603:10b6:a03:2c6::13) To MWHPR1101MB2126.namprd11.prod.outlook.com
 (2603:10b6:301:50::20)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: MWHPR1101MB2126:EE_|MW4PR11MB6788:EE_
X-MS-Office365-Filtering-Correlation-Id: f0dfff53-fe19-4bd4-62bb-08dad550ab3b
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: lWb89m6kkF2CJzAZZDdhJs0bI3o3P3EWSL3BvPsThayBe6iaMbrImCAN9CTeq6lPMPxcIh6CnVxBqvBvIaWY4WzyROMBjJKXeFd5A9F3E++M6WydFQlf6wH6lNp8tM08rKA2gWlCPTiEhMwbvaexA7X7CPoaMphQtJXomGSThnSFG3P6DGLXXH6qvcripPcpL98jxRW3Rr0uoOxypdwdlboNCUHxg/GDxjT47gSYRUqk749+0DmAO011CJ4ZMBZXuHxtqzczL9bIh01I73bW/5ZXSbMEGqGCo80fsFCTVN8lsCwLcVNKOtu5Xb3zUYn0jreUSF6K+Ivn36v/ZiA3orgQX+nX3km2YemRfgwh4kD4vicPHnlYc2n00NDXtarX6VKfG2T4FfVoqYDBE1Bt5Me36gMtpVxHBaYtRounzziZJlunKCbE4NA780ITpQs85Qyzq4lExm9quKQOlXesS4VVvEh99s6m1IGBJiHICI5wBXOI1H6lDTRkFxcplcvtGVszKoxZiUVKGAbntIo0Yh2MhuvS3DqClBSHmWA5oQE/SWGahihMXui+rFVLwyb/1qvqsX9ulY0lP3E8tsc8xcLpOilUTCVg143o0R3d/LvmZEd53zN9uldh/HieMGMSWcskEmvsMWZSA3lh11vnthLzHPpDg2uHRWOEehIyp7Y=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR1101MB2126.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(136003)(396003)(376002)(39860400002)(366004)(346002)(451199015)(478600001)(966005)(110136005)(6486002)(53546011)(6506007)(9686003)(26005)(6512007)(186003)(41300700001)(8936002)(8676002)(316002)(66476007)(66556008)(4326008)(66946007)(2906002)(5660300002)(82960400001)(38100700002)(83380400001)(86362001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?nqWbfppmjJuqVvwPBWzRxbzYu80MTcNeu9neSN8vg6qMTAjhsLyE6AzKesv9?=
 =?us-ascii?Q?abxwnRMM5Xg4ksP8TTe8y+m8orDFgL/3x/4r0czt7XocUJFjGJoowWZ01OLg?=
 =?us-ascii?Q?0k20bQdfSyzU+KWpf/WOaGypjsyK1u3pwTFh/bdXxHhUEfQKzU59AWW5nUUZ?=
 =?us-ascii?Q?amTxspiWPUzZBNqa5P4sgm4Tg5P2UL/YhtPc58B6OxhaVQHWxGIXqWzKbLE1?=
 =?us-ascii?Q?eHlLTduANy+hIIO8fMsrud0wVctFg0NKhyzsW5SYhe1NejejupXsrrUM1Zlw?=
 =?us-ascii?Q?sbT3cvqhvttLRRZbdn8fdNQciHj3uf7HmY8fXbxHpIHsUs0r2xJdoPcvm0TM?=
 =?us-ascii?Q?rbF1EiNz9mPyRLaxAwcN+TnF8VN7Bn9nPCBoWvBreQeaBa+F9J8u44/whVSB?=
 =?us-ascii?Q?+v7uVcmsXxMotJeMNL/pPQ8acC3qgjw3pKKtjQoy3ZN3p+jthlSb0dWnqp+c?=
 =?us-ascii?Q?D4PcLxOTSCSU8IMDISjq4ZSm5uedqBwZ3CNys1Dy7bYz7Q43RNUKdqG3cacz?=
 =?us-ascii?Q?imgmU8OrKwhhJ4W/NcRZe4Yp/6xb+7MWjHR1/B4t82MaJRtyf/TwaJzWDIA3?=
 =?us-ascii?Q?P6TE0Wh8NdUFyKV17bZu0/aboNRmsVWMjJSwrEdMBWP7zvojwyjskxMuPHyt?=
 =?us-ascii?Q?TYOYpiXN3hPYgwRJjcnVvnwJyCi5pfeqYoq2eG52gVGubgWbaRLXfSN0WpPv?=
 =?us-ascii?Q?7nWn7dYnF0dFpTdbrh8ofDF/T9WP20Akhxz+4DCrfLTZjt6OtRTfYNXEeyzh?=
 =?us-ascii?Q?bMeQLlvoHpc1Dnp0Ot/HQUhLs6ulTpcSeKuxZt4JhkQV+WeFY+ojxrm4Y15q?=
 =?us-ascii?Q?cNajclxZ6JmAPB6Mu4YHgcYeCTKezY8OdSqBsLu2vfaHfe0ecIEOgKNmCoK+?=
 =?us-ascii?Q?MV4cvYz/zw86BPvAEPdbIim+MpZTIUojH0nemn3NxBP2rdZdCSq3F6l2K1fp?=
 =?us-ascii?Q?p03fK3wHMlZaS2k1lOClnevXYxP+Lz1zm1sbszRguC+Bu7zOrY+SI9AgZgpy?=
 =?us-ascii?Q?Y5fBufOLd5ZflOGPSENxUVKixj4js2rNe4+JpDB8FanWm34C12m7drdXzJtl?=
 =?us-ascii?Q?QWGHLl2qSB2L49bsNqoLQOgZOIURTQFVJeMJStts1lgq2NNEcr/tVAv2JJfn?=
 =?us-ascii?Q?K9aaErL2xTnmu5M+77bG1LIM2aE1iLuE5qWuzgzsNC+mnVptJ9OYRmrFqPtY?=
 =?us-ascii?Q?FctnP/ZaglI8hKf0u7pa2M0rLZQIb7m56YMT/mgYytZLxv41+Cz7g2wPaZRs?=
 =?us-ascii?Q?lZ1PUGQXK+nySl8hMVQ4PXjA3e8wFNViy+XQAZ0A/IfQieQsfFrxcbxNURoz?=
 =?us-ascii?Q?N0fqvvrVISa0upwSv+yV/K+Oqn+7C8Fld6iPa8+elE/Bm3G0C//s4xsODJwE?=
 =?us-ascii?Q?leQRrFn4hGO6jNLnmuMfBUCzy2K7brZX1jX8xWoVKMC5mxJYkg/gw12vmJxh?=
 =?us-ascii?Q?Cv16mjaS3tTY/jpIZs6eYdewiw0ZocI7VeCNOx+hCX3z5wegA+H1/NIr00hA?=
 =?us-ascii?Q?F2SIhmyXN9VG1dFRXratXhfoCEeC6LCo5PgX62p4dbQ7mVICZqoTemwfw2As?=
 =?us-ascii?Q?quy8FWhtH0q0EpA6iUpd2JUD6tnLi+aGjO7LJxlq1EBJTbGXIaiJMoyWQM6v?=
 =?us-ascii?Q?1Q=3D=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: f0dfff53-fe19-4bd4-62bb-08dad550ab3b
X-MS-Exchange-CrossTenant-AuthSource: MWHPR1101MB2126.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Dec 2022 17:06:07.4492
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: NIihuoGx0/Ui5WfK9Szw7MAGs8qsrh0KBQQzPPCbtIJW3mRNBdo9f6bMt1oE4fllnzfGRU6QNOGvNbJPuF5IieyHGM+TycpCIcs/7UyLoHk=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW4PR11MB6788
X-OriginatorOrg: intel.com

Robert Richter wrote:
> On 02.12.22 23:04:49, Dan Williams wrote:
> > Robert Richter wrote:
> > > On 01.12.22 13:34:05, Dan Williams wrote:
> > > > From: Robert Richter <rrichter@amd.com>
> > > > 
> > > > A downstream port must be connected to a component register block.
> > > > For restricted hosts the base address is determined from the RCRB. The
> > > > RCRB is provided by the host's CEDT CHBS entry. Rework CEDT parser to
> > > > get the RCRB and add code to extract the component register block from
> > > > it.
> > > > 
> > > > RCRB's BAR[0..1] point to the component block containing CXL subsystem
> > > > component registers. MEMBAR extraction follows the PCI base spec here,
> > > > esp. 64 bit extraction and memory range alignment (6.0, 7.5.1.2.1). The
> > > > RCRB base address is cached in the cxl_dport per-host bridge so that the
> > > > upstream port component registers can be retrieved later by an RCD
> > > > (RCIEP) associated with the host bridge.
> > > > 
> > > > Note: Right now the component register block is used for HDM decoder
> > > > capability only which is optional for RCDs. If unsupported by the RCD,
> > > > the HDM init will fail. It is future work to bypass it in this case.
> > > > 
> > > > Co-developed-by: Terry Bowman <terry.bowman@amd.com>
> > > > Signed-off-by: Terry Bowman <terry.bowman@amd.com>
> > > > Signed-off-by: Robert Richter <rrichter@amd.com>
> > > > Link: https://lore.kernel.org/r/Y4dsGZ24aJlxSfI1@rric.localdomain
> > > > [djbw: introduce devm_cxl_add_rch_dport()]
> > > > Signed-off-by: Dan Williams <dan.j.williams@intel.com>
> > > 
> > > Found an issue below. Patch looks good to me otherwise.
> > > 
> > > > ---
> > > >  drivers/cxl/acpi.c            |   51 ++++++++++++++++++++++++++++-----
> > > >  drivers/cxl/core/port.c       |   53 ++++++++++++++++++++++++++++++----
> > > >  drivers/cxl/core/regs.c       |   64 +++++++++++++++++++++++++++++++++++++++++
> > > >  drivers/cxl/cxl.h             |   16 ++++++++++
> > > >  tools/testing/cxl/Kbuild      |    1 +
> > > >  tools/testing/cxl/test/cxl.c  |   10 ++++++
> > > >  tools/testing/cxl/test/mock.c |   19 ++++++++++++
> > > >  tools/testing/cxl/test/mock.h |    3 ++
> > > >  8 files changed, 203 insertions(+), 14 deletions(-)
> > > > 
> > > > diff --git a/drivers/cxl/acpi.c b/drivers/cxl/acpi.c
> > > 
> > > > @@ -274,21 +301,29 @@ static int add_host_bridge_dport(struct device *match, void *arg)
> > > >  	dev_dbg(match, "UID found: %lld\n", uid);
> > > >  
> > > >  	ctx = (struct cxl_chbs_context) {
> > > > -		.dev = host,
> > > > +		.dev = match,
> > > >  		.uid = uid,
> > > >  	};
> > > >  	acpi_table_parse_cedt(ACPI_CEDT_TYPE_CHBS, cxl_get_chbcr, &ctx);
> > > >  
> > > > -	if (ctx.chbcr == 0) {
> > > > +	if (ctx.rcrb != CXL_RESOURCE_NONE)
> > > > +		dev_dbg(match, "RCRB found for UID %lld: %pa\n", uid, &ctx.rcrb);
> > > > +
> > > > +	if (ctx.chbcr == CXL_RESOURCE_NONE) {
> > > >  		dev_warn(match, "No CHBS found for Host Bridge (UID %lld)\n", uid);
> > > >  		return 0;
> > > >  	}
> > > 
> > > The logic must be changed to handle the case where the chbs entry is
> > > missing:
> > > 
> > > 	if (!ctx.chbcr) {
> > > 		dev_warn(match, "No CHBS found for Host Bridge (UID %lld)\n", uid);
> > > 		return 0;
> > > 	}
> > 
> > Noted, and folded into the patch.
> 
> In the (ctx.chbcr == CXL_RESOURCE_NONE) case there is a slighly
> different error reason. The CHBS was found but the CHBCR was invalid
> or something else failed to determine it. That's why a different
> message should be reported, e.g.:
> 
> 	dev_warn(match, "CHBCR invalid for Host Bridge (UID %lld)\n", uid);
> 
> (Note I originally used "missing", but "invalid" is more reasonable
> as there is something but it's not correct.)
> 

Care to send a patch on top of cxl/next to fix this up?
