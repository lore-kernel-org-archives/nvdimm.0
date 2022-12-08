Received: from mga12.intel.com (mga12.intel.com [192.55.52.136])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 045B763B
	for <nvdimm@lists.linux.dev>; Thu,  8 Dec 2022 04:09:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1670472584; x=1702008584;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=iRdz1g/qcdwC/9bktX5ZIP5y+ui2mQ9dEnDiaquL0cg=;
  b=Ye0aobFFQ0N5Gfi3Zv9gl/TF/52pXWQm1YX/lx9CI6LsO/jMdQKmehrE
   zwp9aEnMS/07NoFXTL1RnKMwg4Ta4YW1MzuRxHV4AtxPzC/HtYr233bcJ
   d18xYWZFa241BSr26kg5wSTP64P+EtRQXaI6sPOO723gZ7x/Yfmp48x/a
   WM17EZ/Gdst5yb7veXXDlVYwb785d0zeh6xC9NLKKTq7NQwxGEdnp7mZ4
   zBXZBNkGSKQkU89ryq73S7oYj2H3PSbFpNfdTcfu2KuiAsH8I+/Ei1ACp
   pDu5FWSHzVr7nmssF5bLFzJC7H+gk6v+UUTOiSbII5lxE4174e1CmsKql
   Q==;
X-IronPort-AV: E=McAfee;i="6500,9779,10554"; a="296761695"
X-IronPort-AV: E=Sophos;i="5.96,226,1665471600"; 
   d="scan'208";a="296761695"
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Dec 2022 20:09:43 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10554"; a="892062103"
X-IronPort-AV: E=Sophos;i="5.96,226,1665471600"; 
   d="scan'208";a="892062103"
Received: from fmsmsx603.amr.corp.intel.com ([10.18.126.83])
  by fmsmga006.fm.intel.com with ESMTP; 07 Dec 2022 20:09:43 -0800
Received: from fmsmsx612.amr.corp.intel.com (10.18.126.92) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Wed, 7 Dec 2022 20:09:43 -0800
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx612.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Wed, 7 Dec 2022 20:09:42 -0800
Received: from fmsedg601.ED.cps.intel.com (10.1.192.135) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16 via Frontend Transport; Wed, 7 Dec 2022 20:09:42 -0800
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (104.47.66.47) by
 edgegateway.intel.com (192.55.55.70) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.16; Wed, 7 Dec 2022 20:09:42 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=g5olhjkGfRKxSFth8uiMUQm+qCCzNSKd0bY/1Vaj+mIe6M6mkmyXznWnrOtQKQ+SD6mtQK2EOSUSbGQ11/CrPp61dGZIolz5oIpUAalmUvDZttKI6AcjaepkxVM/Hd2W2HGUR61RXLDpDgqDrU9mYHrqTrOMkbTFMQ0nqjSZBo73f/fS2hoOFvnidE1wVw31QUUjIJX2jq5qjinxBDJy8xe8EgP//OB13IJTPwtYh4jhN3osTHevvmAfILoinW806ibmfNXUTVhHsi58zM6lPfVNCQqwuECvLHjjPKkSnDWvPcBY8TTgBMAzLakoCQ7luNPRIuKW68EwDrNM2SHV3Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=r86NQjxJzcx1HFa+UbrowewnElLBNPqV7psPxqQwMVk=;
 b=PypVvFg+PVaADK8gKsHaMUxnQy1hP3iaFFAdyycG/dpC5UofzHDCtg2zm/04qhzX1cPTqQb1brwrc0T3MhqGFPlbOR9gryIm+ZJMU+gvg+HLvp+8Nv6V0AQFoaRqkUp55iT8m0iKNz+NSyFbD1uYrEFnnmyAPmsOHbv8SClM30rsI07LpQhz33xADvUy+KAVwqjVypllh3ZlQZEctOlrKRghF5Xy/dL5enx7/70NwCjpy+IQJ9YRvPFhvAovWDaasOF/MLe7dQGJyX/DTFtelzSRD8huWz/aVDQU5t1joFLVxpV1F5baghd4ONwjp7372Ksam5/6VKYNl/pmtJP9Hg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from MWHPR1101MB2126.namprd11.prod.outlook.com
 (2603:10b6:301:50::20) by CH3PR11MB7893.namprd11.prod.outlook.com
 (2603:10b6:610:12e::11) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5880.14; Thu, 8 Dec
 2022 04:09:40 +0000
Received: from MWHPR1101MB2126.namprd11.prod.outlook.com
 ([fe80::340d:cb77:604d:b0b]) by MWHPR1101MB2126.namprd11.prod.outlook.com
 ([fe80::340d:cb77:604d:b0b%9]) with mapi id 15.20.5880.014; Thu, 8 Dec 2022
 04:09:40 +0000
Date: Wed, 7 Dec 2022 20:09:36 -0800
From: Dan Williams <dan.j.williams@intel.com>
To: Alison Schofield <alison.schofield@intel.com>, Dan Williams
	<dan.j.williams@intel.com>
CC: <vishal.l.verma@intel.com>, <linux-cxl@vger.kernel.org>,
	<nvdimm@lists.linux.dev>
Subject: Re: [ndctl PATCH 13/15] cxl/region: Default to memdev mode for
 create with no arguments
Message-ID: <639163807f5c_c9572948@dwillia2-mobl3.amr.corp.intel.com.notmuch>
References: <166777840496.1238089.5601286140872803173.stgit@dwillia2-xfh.jf.intel.com>
 <166777848122.1238089.2150948506074701593.stgit@dwillia2-xfh.jf.intel.com>
 <Y2lsYawI3eQayact@aschofie-mobl2>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <Y2lsYawI3eQayact@aschofie-mobl2>
X-ClientProxiedBy: SJ0PR03CA0049.namprd03.prod.outlook.com
 (2603:10b6:a03:33e::24) To MWHPR1101MB2126.namprd11.prod.outlook.com
 (2603:10b6:301:50::20)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: MWHPR1101MB2126:EE_|CH3PR11MB7893:EE_
X-MS-Office365-Filtering-Correlation-Id: ae130821-07d4-48b5-7dab-08dad8d20647
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: cAydn2AZdh4SzAv8fGLtF/8e77QoJjTZrjmKUWRXvEWT8kMAzRmbjk1BI2WDA8B6sNHqNCKIFCiP95IBx9m7P73Y3V93IXqliZHlPrq7+ErgQZBlFYViwl/FjUt7QD7rSudgsx2gZMnMvHoHS+KH4DBYWiLknTbaZDmWWevYaQKv8pRia+YMYVB3JHNNx4FdPDUWdqBkSKPITRlZN/WK8PoB+wrt9ZDI8irbPxy5odIK0K0A+AlP9hDIx/FnRnghlGn13vIlimAU14EQ/sYTOvfeCjMh268gOpTgDYz7G6v2ltw2tC+zUZ7ji2+vRn2Eti2sWuz+8aInieDmNSMZnoNchuEpBDaZiKJ7ExH8ND0TiCI9LGNW9z1rA7gWQP+bnauyF9gPWI7FPEXDkhflqkaJUN1mdROvk55qeBNVZpH9EHSLo5KQnGqlkweH6HJ8RtL1ejXl6cjzdiyAIOATcAVbQxVA41S+ZqmE2qVbxkpB8GStbCpyLavSlerJAdYPFOJn/kH1d6EZBI7ZPezX9nr3IJD/zol5Jg3CBcsNhu3oOhY0x+mmJ492NIEvEN0rYUeZtuChWB9esQRcwNgpophAbBcOV0kQqr+JHaoWQRDFs708FlztgNvrpDCiD9XTzGOWJz0Z4G/xLPw8E+OW3A==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR1101MB2126.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(39860400002)(376002)(366004)(346002)(396003)(136003)(451199015)(86362001)(6486002)(6506007)(478600001)(8936002)(26005)(5660300002)(6666004)(82960400001)(4326008)(316002)(41300700001)(83380400001)(6512007)(2906002)(66476007)(110136005)(66946007)(66556008)(9686003)(38100700002)(8676002)(186003);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?uFyIavAcSRpI/z/NwIkUMgObttpb4gK8jTHY+3R2DY47soDAnlqYPGsicnHu?=
 =?us-ascii?Q?9lJvmKvTC3qhaN3jNjHhmzf6uGSJ1DiqRFDf6pkd4ZXx4ILVkCtXnrjnO1bx?=
 =?us-ascii?Q?dLDp7YHwHxN0hT0pnWF2WppalLzYYTD3XtgrgTrT2bSArzUQpZ/m1lWcK8z4?=
 =?us-ascii?Q?HUCwCcxkvwIapxWuGfSUNzo7JSvFpldGVyFOk47P0aZWtN3KWXuVt7FyvwUq?=
 =?us-ascii?Q?mCi5JLskjVUoXVjbJi9rBM3uibvnhCnvIlxBF/l8SP96bYsjKVGl7YAcF3UG?=
 =?us-ascii?Q?+AbV+7v05LFvSq4sF7+BFyrWjMvJW9pYEhxHCEcypbp3SLSfsap1ZpTk7iYO?=
 =?us-ascii?Q?XN3MU/wT7vhUpsfV42biRnwLXV0Am32hV7FW0qE1+WbtY6IX7q53/i1zE+gf?=
 =?us-ascii?Q?hIdX/OgTr4PrdQtJGsbuV152CODB6QSDo+HMMri3ATqqcZw2E8jlfyNgZrMz?=
 =?us-ascii?Q?RH5W+NmHF2JA9akhH5dZz7Eqo47VSU3MjztM9qZev1Q38gBLRGqi8k5R0blZ?=
 =?us-ascii?Q?dmGUW03/SkV/Jm0eQNaTHVHYaJYFFmY0hSf/O/Iqoul/hVhcIKNE5v4K4ycm?=
 =?us-ascii?Q?2xCZdd+K4bDIH3iQV0fSFmp23qCNeFm/HVQWbap1Ahnoj4gOeN4okvTeiwJk?=
 =?us-ascii?Q?n3CE7a80WcjHz1sTJhYk+ixNsZMVWvsXVqwfBg9DWVyIXMs3RtDy0Ooi7CVF?=
 =?us-ascii?Q?g5CNsychoCr0pv1U6iH+KdoqSyvDxC/U9zejuoV+R4L3EeIHFbTzKJnsFvMj?=
 =?us-ascii?Q?8SX0hu/DpKt33yJwKTorOhd5o/Nm3YvyvXDtqwOR71L++49Mm5L+eyPDy/Gc?=
 =?us-ascii?Q?GLizYVx9PCn4NlK/LkHUssSOw2NKoAUgA5d2Kurw5gf949XL3P3brZz6Kb5c?=
 =?us-ascii?Q?f6mZzV9kr4celKeivoaHizg7StClqsvX0hPPlaKxBdI0M183dapVZQ53LBVG?=
 =?us-ascii?Q?sFuu8mXGs0365ibyhlK151vrl4SFR6G7WWRf3yfwpV/MU5Az00D3K4sBnuT7?=
 =?us-ascii?Q?WegMH0pmDgKYUlIZrzODYdTbqo9Y7rKpERmlneuYmxsvSRGhSO7ZgTXFL+TT?=
 =?us-ascii?Q?b/w3v/6MECxeLpaVhYQIVeW4cHwygPUJJ441fy6REHo6kaxzS8h+pcgzIrkY?=
 =?us-ascii?Q?HvBM5tSsdSF0iuUP20Etjexyk0I5/aOW6LsxHsdXx2h+6oNnE1FMhGG7oiqi?=
 =?us-ascii?Q?uk21HDfa6hAcdeM0O4RgVheZPAPmXq6Zkl4zewPr1IBdCNh3KeaMG++Wx9Wp?=
 =?us-ascii?Q?CVWj4RbKOapXsZ2SIDGQ//i6sPEjjrxscj2jnxthTd/QF3jezH9/w+XEwwDA?=
 =?us-ascii?Q?dV2dwWoD8nVBmtfNtnlLgf7B0HKqRpU0VhLlIqj2IKTFu1wLUDrNCJXcMQyB?=
 =?us-ascii?Q?fddk8epc9JllIFv6KLOdTdD6Z59jkfeLDoe7EE//dXAO3dUjl0bGVrfWRdny?=
 =?us-ascii?Q?QEof9KtrXp7NCEQn9wSapaO4IkoRcCJQVPhnX2lR3WoX2wh4A+zXsO2bPNB6?=
 =?us-ascii?Q?mZwvcSMms6kVzVVfaNvGao6u5RG0OtHf5So5tUZD7TT10d22rqZaZx+Ect7z?=
 =?us-ascii?Q?tGpmX7ZerirMflw5vNvOp5pIb50D3Bvnx7rdujZ89LlMw0JueSHfK+3UXfRk?=
 =?us-ascii?Q?Jw=3D=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: ae130821-07d4-48b5-7dab-08dad8d20647
X-MS-Exchange-CrossTenant-AuthSource: MWHPR1101MB2126.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Dec 2022 04:09:39.6894
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: nbFBjKZsgaVZ7k+fcyd/z5A1bSObV1AvWpGbgtvURJs0hjM4kiUWvDdPhvtEX3uBWSRqwq8PscYNorl0l55aPtWMOFGp1r01qNxho53QKVs=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH3PR11MB7893
X-OriginatorOrg: intel.com

Alison Schofield wrote:
> On Sun, Nov 06, 2022 at 03:48:01PM -0800, Dan Williams wrote:
> > Allow for:
> > 
> >    cxl create-region -d decoderX.Y
> > 
> > ...to assume (-m -w $(count of memdevs beneath decoderX.Y))
> 
> I'm not understanding what the change is here. Poked around a bit
> and still didn't get it. Help!
> 
> Leaving out the -m leads to this:
> $ cxl create-region -d decoder3.3 mem0 mem1
> cxl region: parse_create_options: must specify option for target object types (-m)
> cxl region: cmd_create_region: created 0 regions
> 
> Leaving out the the -m and the memdevs fails because the memdev order is
> not correct. 
> $ cxl create-region -d decoder3.3
> cxl region: create_region: region5: failed to set target0 to mem1
> cxl region: cmd_create_region: created 0 regions
> 
> This still works, where I give the -m and the correct order of memdevs.
> cxl create-region -m -d decoder3.3 mem0 mem1

I fixed up the man page to clarify that this is a possibility when
eliding the target list:

diff --git a/Documentation/cxl/cxl-create-region.txt b/Documentation/cxl/cxl-create-region.txt
index e0e6818cfdd1..286779eff9ed 100644
--- a/Documentation/cxl/cxl-create-region.txt
+++ b/Documentation/cxl/cxl-create-region.txt
@@ -53,16 +53,18 @@ OPTIONS
 -------
 <target(s)>::
 The CXL targets that should be used to form the region. The number of
-'target' arguments must match the '--ways' option (if provided). The
-targets are memdev names such as 'mem0', 'mem1' etc.
+'target' arguments must match the '--ways' option (if provided).
 
 include::bus-option.txt[]
 
 -m::
 --memdevs::
        Indicate that the non-option arguments for 'target(s)' refer to memdev
-       names. Currently this is the only option supported, and must be
-       specified.
+       device names. If this option is omitted and no targets are specified
+       then create-region uses the equivalent of 'cxl list -M -d $decoder'
+       internally as the target list. Note that depending on the topology, for
+       example with switches, the automatic target list ordering may not be
+       valid and manual specification of the target list is required.
 
 -s::
 --size=::

> 
> > 
> > Signed-off-by: Dan Williams <dan.j.williams@intel.com>
> > ---
> >  cxl/region.c |   16 ++++++++--------
> >  1 file changed, 8 insertions(+), 8 deletions(-)
> > 
> > diff --git a/cxl/region.c b/cxl/region.c
> > index aa0735194fa1..c0cf4ab350da 100644
> > --- a/cxl/region.c
> > +++ b/cxl/region.c
> > @@ -227,10 +227,13 @@ static int parse_create_options(struct cxl_ctx *ctx, int count,
> >  	}
> >  
> >  	/*
> > -	 * For all practical purposes, -m is the default target type, but
> > -	 * hold off on actively making that decision until a second target
> > -	 * option is available.
> > +	 * For all practical purposes, -m is the default target type, but hold
> > +	 * off on actively making that decision until a second target option is
> > +	 * available. Unless there are no arguments then just assume memdevs.
> >  	 */
> > +	if (!count)
> > +		param.memdevs = true;
> > +
> >  	if (!param.memdevs) {
> >  		log_err(&rl,
> >  			"must specify option for target object types (-m)\n");
> > @@ -272,11 +275,8 @@ static int parse_create_options(struct cxl_ctx *ctx, int count,
> >  		p->ways = count;
> >  		if (!validate_ways(p, count))
> >  			return -EINVAL;
> > -	} else {
> > -		log_err(&rl,
> > -			"couldn't determine interleave ways from options or arguments\n");
> > -		return -EINVAL;
> > -	}
> > +	} else
> > +		p->ways = p->num_memdevs;
> >  
> >  	if (param.granularity < INT_MAX) {
> >  		if (param.granularity <= 0) {
> > 


