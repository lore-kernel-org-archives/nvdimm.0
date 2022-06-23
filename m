Received: from mga14.intel.com (mga14.intel.com [192.55.52.115])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9006B1FB2;
	Thu, 23 Jun 2022 17:33:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1656005629; x=1687541629;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=b/9OX3x32OTieDPcOvKKtTjczpr1xkzViveLWJnvhqk=;
  b=L2ygKjm7U4/Tc2+GxNWf1KTZ55ssywqJZylod6WhjeJ3ldGXhzJWNylX
   1QOqfwI+K8/lQOBLzHtHsHaALEBBfNC6z3GZe9HQo1y5W5pbs2/Aw0HJh
   ADf/mqWJartqB/pp8PqLcKmMP4VQSQtRIlWdFGpMIk8b/1T97n1cxxzbd
   AM5TYoa9VjStgFm7HyXbych5e8oztkxjtrd4mcMoMlnY+nCzFBBFSFs1s
   d2RfgUJoTKxgQRMLdPJZ4hqVug52oz/nNmxAI0WKmT5Mlk2/KfAFuuz9X
   2LCfRBj2fyTOGGl6TFga1gIQLBOAQnQIs4538spuMe+t4QJaBAdwJQQIE
   A==;
X-IronPort-AV: E=McAfee;i="6400,9594,10387"; a="280834964"
X-IronPort-AV: E=Sophos;i="5.92,216,1650956400"; 
   d="scan'208";a="280834964"
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Jun 2022 10:33:49 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.92,216,1650956400"; 
   d="scan'208";a="678158896"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by FMSMGA003.fm.intel.com with ESMTP; 23 Jun 2022 10:33:48 -0700
Received: from orsmsx601.amr.corp.intel.com (10.22.229.14) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.27; Thu, 23 Jun 2022 10:33:48 -0700
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 orsmsx601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.27 via Frontend Transport; Thu, 23 Jun 2022 10:33:48 -0700
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (104.47.66.49) by
 edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2308.27; Thu, 23 Jun 2022 10:33:42 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ZJ2rS/MBDzxIZM6HLtpxEJppQYHPwSs4nIDr1VVSMLcm04LaDBsOJEQIxhtGYRirBl4mQC/6cvuZyUqD+nA03nW8LL2tazQLRztgvF47LVGvkz8PNKqRIbJphB5C7BaQTD2z8Ms+TgIrDsmtTn+I5LulO2piciMUt5tWhh2J+HLQwK0h0hHgSibk8hUAR28Bw6ZUjEDBeVZrwVYJC2wqJtQM7a90hYx8zE45BK39eMYODKh6MC8NkR9tUyJcEg/Bv58TLw8xgG0gUXcsqA2gKZAv+gE+VEEAxziXCD+TRBYSj2DagY6qMHr8iDR4btD/AmXd6S1xzs5Mad+/AYwo9A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=HgUXQmACpchVcwHCJw8lABNuPui4Os6cSZ0OnjhXGcg=;
 b=RM4HfjFcu871YJEdq0r5Eg4RHshsxhIW22CYx7pWl553qcrPiF/F6tGEQq+sSSRVdGUDAZJB3IYwhiLKvfGQ64nqFaCs4HCr5AXlvGDAFpxNdZt+RNWTvPEU9PNdnq/E9SL1H1rvpjmax+E8N/CGpE7V1uryDV3lJhbPuPjxzG4y8+ib8iuQgTYioxrUdDloKg9fzTa7JQsv5ILAoyTqRWufmh+HxTUlwqCp3ckW3NG8w87s+ONR+2fgC1FvCKUI8nK6CxUyrQUE1mfyzY4yPFZSNonqOXAMCA7FVzufrrfiblltRy3EXKwf8Rp4bWd4IrlannzxoTmDYSbT9gSNUw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from MWHPR1101MB2126.namprd11.prod.outlook.com
 (2603:10b6:301:50::20) by SA2PR11MB5195.namprd11.prod.outlook.com
 (2603:10b6:806:11a::16) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5353.18; Thu, 23 Jun
 2022 17:33:40 +0000
Received: from MWHPR1101MB2126.namprd11.prod.outlook.com
 ([fe80::f50c:6e72:c8aa:8dbf]) by MWHPR1101MB2126.namprd11.prod.outlook.com
 ([fe80::f50c:6e72:c8aa:8dbf%7]) with mapi id 15.20.5353.022; Thu, 23 Jun 2022
 17:33:40 +0000
Date: Thu, 23 Jun 2022 10:33:38 -0700
From: Dan Williams <dan.j.williams@intel.com>
To: Jonathan Cameron <Jonathan.Cameron@huawei.com>, Dan Williams
	<dan.j.williams@intel.com>
CC: Ben Widawsky <ben.widawsky@intel.com>, <linux-cxl@vger.kernel.org>,
	<nvdimm@lists.linux.dev>, <patches@lists.linux.dev>, Alison Schofield
	<alison.schofield@intel.com>, Ira Weiny <ira.weiny@intel.com>, Vishal Verma
	<vishal.l.verma@intel.com>
Subject: Re: [RFC PATCH 00/15] Region driver
Message-ID: <62b4a3f259aad_32f38a294ee@dwillia2-xfh.notmuch>
References: <20220413183720.2444089-1-ben.widawsky@intel.com>
 <20220520172325.000043d8@huawei.com>
 <CAPcyv4hkP1iuBxCPTK_FeQ=+afmVOLAAfE6t0z2u2OGH+Crmag@mail.gmail.com>
 <20220531132157.000022c7@huawei.com>
 <62b3fce0bde02_3baed529440@dwillia2-xfh.notmuch>
 <20220623160857.00005fe2@Huawei.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20220623160857.00005fe2@Huawei.com>
X-ClientProxiedBy: MW4PR03CA0328.namprd03.prod.outlook.com
 (2603:10b6:303:dd::33) To MWHPR1101MB2126.namprd11.prod.outlook.com
 (2603:10b6:301:50::20)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 03bcdbb3-d2b1-4197-0bd4-08da553e8306
X-MS-TrafficTypeDiagnostic: SA2PR11MB5195:EE_
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: DVLoLbpE/0BrlilKk6s+p7WJ1aW7TEgCDzhLoch183QOIWH3fcSjxBenPO0bTwCxSbzMU/AQYruGu+vOAK/s9bDv2dBE3QetTej4elFjHgytRbscMCd51K7+m6MYTY0V0mPLh6NelC+cLYXSBh9BBptTW2i4fmdtgpOjurAE4IorRrhiJGjpY7PbMLlgdqfZnklUCvFIHPIiuZltOCdMR86G0wU+vFiT1652JAmJQ0FghPVqCC118Imp7Up5OpMKBJJu6RvYlFqQKNuBli4C4ArN14IBR2rPEWkXh8wi1IzfMd27AvPQmu3uSIWL69lOINZpmsUKLqIco3b1G/G064XxiTJSokoTR1bq+bKvzO/MKBplPFAqxf5Dzg55blzfPvGCc0UO/Tktri5TlYk5KDRc5jiXjhFbmI0XUVuJPqFCKjx62+dlEzEOmVzf+i7T0X8EB8AskJq9SSZS2eZWl1O6HNbNueuuAbPEQxL5DboEuWEsiY/Xl1aWTgn8CnmV2IQk06P4bkxznOPjb+yTX8jgGwVFFh9ZN3oM4r/cU/UBFxDzebjuwnTYDXmFY5JK5FgDmfMfbky9k1lsGcQ2uPD+Y8GjuRusvXAE7UF4uDkB0uSJApWye/FHKQ23ae9H8JkJznf7rO3L9FrLcoS6GMimcu38IMrg1IgxoYY0fCRq8p6G2ZmyZPELbMHFU1N1sK4nSmTYDbAVePfSa5A76qZ2Jw1AJ9LKnyXmnCndlb0IKX+hQhtxei+Sgc0AdJCM2ybV95NJH2XnFWivoF9+5w==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR1101MB2126.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(39860400002)(346002)(376002)(396003)(366004)(136003)(26005)(41300700001)(8676002)(4326008)(186003)(66476007)(316002)(38100700002)(54906003)(107886003)(66556008)(66946007)(6506007)(6486002)(5660300002)(110136005)(82960400001)(966005)(86362001)(6512007)(8936002)(9686003)(2906002)(478600001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?dK6bat+u02+rGT2BF0YJ94oROZmXsLxDzzUPZK+bT/xnGvTM0xYY/qtm86EF?=
 =?us-ascii?Q?IgHS1JJaodqIwjhDkOT43Zb14woCI4HqeL2C9EmP/UkFvvF1wQ6IhaGrWM5p?=
 =?us-ascii?Q?rnShlLz6Vi50GxhBV7LTRXf1BUL9XCaKAG119uTtURA/z6PyAEWcDUx9V1rt?=
 =?us-ascii?Q?I25AVshqU9uMJXWEMsGne9YP4hUm5NzN0lDsPHvE9Wra38HeyKDLuyOizhK1?=
 =?us-ascii?Q?D9UWlUjWlyVkUI4mPk1hf6NNsdAkQ/WMYhf0NV1V2A9j+pfv/D05s4f2Srvz?=
 =?us-ascii?Q?tDfVF6JJEYt8JQkviZ+V4zJFxXAG2fMmm+bWFMsimkvsAA5UhujXiVXgkFUi?=
 =?us-ascii?Q?xBk9mUaN+UGIAN+WJROpBxmvOV7tq1bEYVyWz0iqEqlfEbsqzKtQsSkntgJp?=
 =?us-ascii?Q?dtzOv2c6H9qDvlQ4fws9bROsqTisbfvuF6jTUJ8pvao6otTpE/3Lph6lzSGb?=
 =?us-ascii?Q?vATb4rKvsZpAIYNVL7E46J+UTROWKqiWz2oSWG+h/1E3C9e5stEj6N/9sKYg?=
 =?us-ascii?Q?/gpm7ovvuZYNqZUxzMJ1Blvfhnq/8YhmJU+1IiUTrCmUO0IMx0n4UAc8Mer+?=
 =?us-ascii?Q?bNwhEztGI2WFSpaNxprYphWQxPaGHkJAOgRU6vph8C4EfAqVWFebWOPYDHlR?=
 =?us-ascii?Q?ETNEP0/wlc0n8Ru6kBuvy9yussL8YbC9QSWdbsvhdPFC6KHfTo5ydjkmWrqP?=
 =?us-ascii?Q?p7Dow4cXlM9MSMlFez15DUZLWHyqKiWp4Gy2MGIy8KnkrfB+bSLTNIkNBoDx?=
 =?us-ascii?Q?ClfrzfS3HiBITfAQHnJXQe+1BXeB2ZC7BSK1THIRCDAD24fFPpIfRhwa4U+V?=
 =?us-ascii?Q?gZ/4bds2aEQ61788tzFyvU5TsZiqPymCera6cWgi/FGJT9dB7VT+DLpR/Nmf?=
 =?us-ascii?Q?T+uwPD/s0k/aZ92vHWd6Pik2BUfe2CywSxw/n5ns2MWR01IZda3Vto5pIMqr?=
 =?us-ascii?Q?+qaT7GYTRLO8OTxp+6NAg+76I3HSu1HIK1RbLdRfEEYnRcOfjehxzSTGtQi/?=
 =?us-ascii?Q?4Xu9tGIjXyW8dgMos+TGcZzyU39qb7AOpy8Q+3c+S3bLVqgRBaZJXksmtIuU?=
 =?us-ascii?Q?sp5NTW+0FnjlKmeTe5uzguYYkARR+HA+DPrvTSa18RVT5l9gT5IDTWqH2y5e?=
 =?us-ascii?Q?jYi5K3JGH3M21AmHCJ2uzQzU9dT6gVArJoSxtzddDatDVzkKvyo35nE+Wyln?=
 =?us-ascii?Q?ZwFPxls+h0/cIJhWS1R2Z3SXN/hxvXq9IPMQh0GiJMnjzK62ty1Jb0jLAv1s?=
 =?us-ascii?Q?hdAqESjvI4+zVkQui75mEE9uvNuuuYBwDz8OB0KJg7iWUk53KMDEuFOLXTfK?=
 =?us-ascii?Q?+gtgATOGBJe77UpygJveaxqWqCO4OX/g5Z5N/9L3pC0NXD2EvX47KJowaldd?=
 =?us-ascii?Q?29op7hotE7cssKnMR0o6QzUepM0j2pIfUGcdPUAIsyHFAQb5DanLwxgTf28t?=
 =?us-ascii?Q?pvLbVpYqCWVGBcnPAlBwa8wVt+6v9jMWS+6Edc3wqbyTj6GYAs66nshIEX8v?=
 =?us-ascii?Q?Ic8BYPAEsIBzz3WqIk8PPDdM2IfN0Nq6Z49LrEflAXAUIcDySnPrTaBK7gRo?=
 =?us-ascii?Q?bi1B+ENB8FduVg+TwC807G47WdS6srSnrpJt9kjI0XfBAagrw76Sc8LjtCfm?=
 =?us-ascii?Q?9kCstghUg8bSwaQyvwJwsp+778MfPq5o0sr63loVbrWwZ6Z7jyHAJW2ZaeLK?=
 =?us-ascii?Q?6dl7Ezqd8yX5a7f98R0aAjCyfDMddWauZuE2o85xu5RbvtnmaY3eUWVz46Br?=
 =?us-ascii?Q?j/8eh0YCTRv+a4ZEYCrseFfU8py9Vfo=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 03bcdbb3-d2b1-4197-0bd4-08da553e8306
X-MS-Exchange-CrossTenant-AuthSource: MWHPR1101MB2126.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Jun 2022 17:33:40.3703
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: aXknbFdW251yNziVJSjRNIwu/xBw3R2k4L6ywmPMw+O4hIbiqG/yikMsHd5mOivJtsD2XqbYj3q3MvxZ9GZfCCw/PnhqsfPmUD6aKXAEBIw=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA2PR11MB5195
X-OriginatorOrg: intel.com

Jonathan Cameron wrote:
> On Wed, 22 Jun 2022 22:40:48 -0700
> Dan Williams <dan.j.williams@intel.com> wrote:
> 
> > Jonathan Cameron wrote:
> > > ....
> > >   
> > > > > Hi Ben,
> > > > >
> > > > > I finally got around to actually trying this out on top of Dan's recent fix set
> > > > > (I rebased it from the cxl/preview branch on kernel.org).
> > > > >
> > > > > I'm not having much luck actually bring up a region.
> > > > >
> > > > > The patch set refers to configuring the end point decoders, but all their
> > > > > sysfs attributes are read only.  Am I missing a dependency somewhere or
> > > > > is the intent that this series is part of the solution only?
> > > > >
> > > > > I'm confused!    
> > > > 
> > > > There's a new series that's being reviewed internally before going to the list:
> > > > 
> > > > https://gitlab.com/bwidawsk/linux/-/tree/cxl_region-redux3
> > > > 
> > > > Given the proximity to the merge window opening and the need to get
> > > > the "mem_enabled" series staged, I asked Ben to hold it back from the
> > > > list for now.
> > > > 
> > > > There are some changes I am folding into it, but I hope to send it out
> > > > in the next few days after "mem_enabled" is finalized.  
> > > 
> > > Hi Dan,
> > > 
> > > I switched from an earlier version of the region code over to a rebase of the tree.
> > > Two issues below you may already have fixed.
> > > 
> > > The second is a carry over from an earlier set so I haven't tested
> > > without it but looks like it's still valid.
> > > 
> > > Anyhow, thought it might save some cycles to preempt you sending
> > > out the series if these issues are still present.
> > > 
> > > Minimal testing so far on these with 2 hb, 2 rp, 4 directly connected
> > > devices, but once you post I'll test more extensively.  I've not
> > > really thought about the below much, so might not be best way to fix.
> > > 
> > > Found a bug in QEMU code as well (missing write masks for the
> > > target list registers) - will post fix for that shortly.  
> > 
> > Hi Jonathan,
> > 
> > Tomorrow I'll post the tranche to the list, but wanted to let you and
> > others watching that that the 'preview' branch [1] now has the proposed
> > initial region support. Once the bots give the thumbs up I'll send it
> > along.
> > 
> > To date I've only tested it with cxl_test and an internal test vehicle.
> > The cxl_test script I used to setup and teardown a x8 interleave across
> > x2 host bridges and x4 switches is:
> 
> Thanks.  Trivial feedback from a very quick play (busy day).
> 
> Bit odd that regionX/size is once write - get an error even if
> writing same value to it twice.

Ah true, that should just silently succeed.

> Also not debugged yet but on just got a null pointer dereference on
> 
> echo decoder3.0 > target0
> 
> Beyond a stacktrace pointing at store_targetN and dereference is of
> 0x00008 no idea yet.

The compiler unfortunately does a good job inlining the entirety of all the
leaf functions beneath store_targetN() so I have found myself needing to
sprinkle "noinline" to get better back traces.

> 
> I was testing with a slightly modified version of a nasty script
> I was using to test with Ben's code previously.  Might well be
> doing something wrong but obviously need to fix that crash anyway!

Most definitely.

> Will move to your nicer script below at somepoint as I've been lazy
> enough I'm still hand editing a few lines depending on number on
> a particular run.
> 
> Should have some time tomorrow to debug, but definitely 'here be
> dragons' at the moment.

Yes. Even before this posting I had shaken out a few crash scenarios just from
moving from my old QEMU baseline to "jic123/cxl-rework-draft-2" which did
things like collide PCI MMIO with cxl_test fake CXL ranges. By the way, is
there a "latest" tag I should be following to stay in sync with what you are
running for QEMU+CXL?  If only to reproduce the same crash scenarios.
