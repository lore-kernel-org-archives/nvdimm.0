Received: from mga04.intel.com (mga04.intel.com [192.55.52.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4433A4697;
	Thu, 23 Jun 2022 23:44:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1656027867; x=1687563867;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=rYNOxVDayDQ6Kmi5am+PC06Zs+8664loz+hTgTY3VbI=;
  b=UDke5r5pnfMd0Vury20389VnM1Beo123Gza0zldUzySebHhoh9pAjaBq
   hBzqA/v6S+lGZ7bk1oiWj6OFmfu+pepLFqm0v4zDUz6ITnEFEDbKTnSKR
   f+/0yyKT20jGj1gu9Ltt/Kw4Jdhyck+K3kTxh4EX3QI+nK3zL6cXG+HbJ
   y2gapLUJPpin3g6jwvWfXfr5PIpL4u0mvp8hJE9g4nvkTEGg44FUv6QF4
   XEZosLYRDkrao+RVT2pzUfUOZ+FKE6TuGQwse5VXuCAwXqqt344jX+Who
   hfSYl93YErG9jfm/hRgiIv+upAmZ71Z081XuTN757mSZDQpt2UpbTcptu
   Q==;
X-IronPort-AV: E=McAfee;i="6400,9594,10387"; a="279640009"
X-IronPort-AV: E=Sophos;i="5.92,217,1650956400"; 
   d="scan'208";a="279640009"
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Jun 2022 16:44:26 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.92,217,1650956400"; 
   d="scan'208";a="588820800"
Received: from fmsmsx602.amr.corp.intel.com ([10.18.126.82])
  by orsmga002.jf.intel.com with ESMTP; 23 Jun 2022 16:44:26 -0700
Received: from fmsmsx611.amr.corp.intel.com (10.18.126.91) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.27; Thu, 23 Jun 2022 16:44:25 -0700
Received: from fmsmsx607.amr.corp.intel.com (10.18.126.87) by
 fmsmsx611.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.27; Thu, 23 Jun 2022 16:44:25 -0700
Received: from fmsedg601.ED.cps.intel.com (10.1.192.135) by
 fmsmsx607.amr.corp.intel.com (10.18.126.87) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.27 via Frontend Transport; Thu, 23 Jun 2022 16:44:25 -0700
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (104.47.57.177)
 by edgegateway.intel.com (192.55.55.70) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2308.27; Thu, 23 Jun 2022 16:44:24 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=cdfNdOuiFzuHu8PNtrZa2eC7d+Glqg87iCLjP2ZQoVf1ddnDofOpZisGzDp+MKTERU9HWoAqVH2NkFCqX8wlftD1LMvs1Y8WYmN9iWIWzA9JkwybKAh29YlzJM1mN+fWQapxIZP0Gs6J4XAz+sXdTyZ1mLeGn52CsWeTMfoROB1v+N5o5SQKPvcCLVWA3UHb+xn+MH+R59ReO+rjyWmiRUsWxpRy5qY8TvEFtctpwc5ktpMcKhOiAymOYgT0YTpj6WOdM97G+TY/jVgelzGJmI3AgfuodGVXmQCKDIGZZ5V7IeIRHW7d20wvbGz9ooH45OhPbzovow2JMkE/eyFj/Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=NgL310lOljof1qWRLd7ltNrZaOELmKedBMG2jyKUjFI=;
 b=adhrxp1+L8+wWvqq8xxznaG1MyO4zvDZtHXJO9HQEA3VDmpzmZdXBYitiFkeTcroDYs0Bua6NggfzgFw7KBrh1TCkghu4++5tSW1a79MYNj/mlNUIxGr5dMoR/yYdeXO0pHGpJcEFiskmnAPurwANqXnCMpct8bWMKxWJY+UXLgY1auKZr3dS9GHKAMVysmWQyuiqLm6W7sAZzknBFhrK6MLPA5lBj45BC0IkhZ0Cu1gGugqPFtkAaE0SZ1vit4nqIuJcBltuwXdWZ1K8w5hMyY6X+2AgJ/g4/ZcS3TThUv3sVAjyUb7KTSyJuyg/dnyXVDbxBBw5yDucH8RwA9OTw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from MWHPR1101MB2126.namprd11.prod.outlook.com
 (2603:10b6:301:50::20) by MN2PR11MB4080.namprd11.prod.outlook.com
 (2603:10b6:208:137::27) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5373.16; Thu, 23 Jun
 2022 23:44:18 +0000
Received: from MWHPR1101MB2126.namprd11.prod.outlook.com
 ([fe80::f50c:6e72:c8aa:8dbf]) by MWHPR1101MB2126.namprd11.prod.outlook.com
 ([fe80::f50c:6e72:c8aa:8dbf%7]) with mapi id 15.20.5353.022; Thu, 23 Jun 2022
 23:44:18 +0000
Date: Thu, 23 Jun 2022 16:44:15 -0700
From: Dan Williams <dan.j.williams@intel.com>
To: Dan Williams <dan.j.williams@intel.com>, Jonathan Cameron
	<Jonathan.Cameron@huawei.com>
CC: Ben Widawsky <ben.widawsky@intel.com>, <linux-cxl@vger.kernel.org>,
	<nvdimm@lists.linux.dev>, <patches@lists.linux.dev>, Alison Schofield
	<alison.schofield@intel.com>, Ira Weiny <ira.weiny@intel.com>, Vishal Verma
	<vishal.l.verma@intel.com>
Subject: Re: [RFC PATCH 00/15] Region driver
Message-ID: <62b4facfcba22_8070294d1@dwillia2-xfh.notmuch>
References: <20220413183720.2444089-1-ben.widawsky@intel.com>
 <20220520172325.000043d8@huawei.com>
 <CAPcyv4hkP1iuBxCPTK_FeQ=+afmVOLAAfE6t0z2u2OGH+Crmag@mail.gmail.com>
 <20220531132157.000022c7@huawei.com>
 <62b3fce0bde02_3baed529440@dwillia2-xfh.notmuch>
 <20220623160857.00005fe2@Huawei.com>
 <62b4a3f259aad_32f38a294ee@dwillia2-xfh.notmuch>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <62b4a3f259aad_32f38a294ee@dwillia2-xfh.notmuch>
X-ClientProxiedBy: MW4PR03CA0252.namprd03.prod.outlook.com
 (2603:10b6:303:b4::17) To MWHPR1101MB2126.namprd11.prod.outlook.com
 (2603:10b6:301:50::20)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: f01c70f0-6c29-486a-27bf-08da557249b5
X-MS-TrafficTypeDiagnostic: MN2PR11MB4080:EE_
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 4W02FTowbl06Oko2hRioy7SRFO8Nr5H7OCpsYmmnaFWsMDYKKHm0p+o1R00wKBx1mO3Ncdtv4K9n4enKzaV5kO0VZQ0YiV/TsQH1jn4Lo5xSHOdubdcrmDRARTPFNiqT57EceOgOa4EZBWwQDqWkdUQixrljWM5S/15FUFKZgDrd1hJLTARBySqyeLBZ9Pd859Nj/49uInF4NagH0GIDCKOk8z+OYQgnGDISHwTU1mwwIjqCQyYioMBGvJJWUHt1Vtf4Z3b26jaKUJWIj8L+s/Xa3NkooTfziv66eKPG4p2n/rcyuX/suv37UZI9ZocIVsYTTxdzsA2dvOweaVIV/+UnwT4XE4h5q5BHqXNEEeSjr9dUCtYbg6+041J8a8trO4Bo+p/uKy/LZiCVdIzaOC9GvMAnreijxHkU6yUfEi3GSZ48XEFj6rmGk14/ty0ALkseeV6YrjEIBaKEwPGzARehjIRRPnX5xrqz1usI6+T/G9HV9rU6vXifh/D+/hDDauDJ0VVetUUEFdaFA/V4uGOIMJ7T8YSDUaKqxlwco8XYOtuHmcDH3888m7/AT40ULW8EA0QccA8w9zyI9MUyVh/WyC0S7rfB5FUBck3QgriSiMMme9eFXPLoGsDWLsFmaaO4gi2zebalE6tvjRC8xNS6StvLmjVUCj4Q8BhYvnXME35R6M8HncJSjGAcYPJ0re3VaQBF9L7CPej+jtJCBsVQW/sX9JPo9K93CJrzSPSmlFwhGfsqIhpdPhCFYSnRmADb3VAPAABItLWULABNiA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR1101MB2126.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(396003)(376002)(39860400002)(366004)(346002)(136003)(186003)(83380400001)(86362001)(38100700002)(82960400001)(6666004)(6506007)(478600001)(110136005)(54906003)(6512007)(26005)(107886003)(2906002)(6486002)(4326008)(66946007)(8936002)(8676002)(66476007)(66556008)(41300700001)(9686003)(966005)(316002)(5660300002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?s7R4Na/VVEtiFst+hB2jL9c1tPkoRrsD3iBQ06e+n6oGLhHgITXcBHWW6sIG?=
 =?us-ascii?Q?LXjCDjIDnWqNlIKwhIgLxZOPvx4p6lWg0uAi/v4ZltkApNmfVE83pjpflQ0y?=
 =?us-ascii?Q?1O/724HT77pQJfl63LnB03wfg0cx2jesb8AFEmnbVAgfRb829AxFAsJqIdSu?=
 =?us-ascii?Q?tUmK55tNgCNR292k6W6EUMptsigl7/VKsN13QvvcZ1m9kD3Xcilnl0i/swsc?=
 =?us-ascii?Q?GeS1MjPdlVfoiltwmXutmrZ7bV2njhcD5enUgM/H/sIWAk2sxridmBJANl3A?=
 =?us-ascii?Q?f57b5+QwcwWt3TjuRNf1JQc1uLNcbAvrneW3mjgO25tlK+TPFpvazx2lqJTi?=
 =?us-ascii?Q?AXnSFeHnXPD6Yn9FK3yw0bnP8i3qvw0DOz0IYz1PmqEHwa3at+fbcKNRd0cb?=
 =?us-ascii?Q?FkXtaDCxeuZqFrMoUwGpwmmr83tD4IP0nRHfG+wvqEipR80q0Y8dUhUXwG3k?=
 =?us-ascii?Q?iZjStOblQ3ICZPappAp7JnewKsq/3jtuDPpnyoQw6zV4ICAOX40PhDipDHYh?=
 =?us-ascii?Q?HumH0yY63UFHKtJA+Ss/VfzrDPRuwB2PTJeNh9FuGdrPN+xrWqKn/LCuWxIU?=
 =?us-ascii?Q?afWRXa4XIN4SXvUNgQ4zRZvT3tPMMgaTEf3WsrKV6QBtIiv+xLFqDhd5VfMx?=
 =?us-ascii?Q?PyI7JdEqc0o9DZkaJXmLk8yL9RSz7V589ulBlK5E6EcS+y5zQMtwejMp0jlL?=
 =?us-ascii?Q?qTWZGGnZxDnIIiPz+kxw8sHFuSMCttW9ZmDglHA7JldVxV5v09fnSd2K40u0?=
 =?us-ascii?Q?hmLwmJn0EfasE6DU8QI2lEsVvzVqoI0K8NhHLCkgYdPZiRD+TC7zn0Cqd609?=
 =?us-ascii?Q?p2vz70triWjMBAzTCOgY2GS3cg/hANHxVW818kzmcPGEqq/hsiFegzu1CIZY?=
 =?us-ascii?Q?c1eVgxGksdLRjei5m8bakVYWiraSsuRpNTv71c6UEYK50iXsmGwT1iOasKVQ?=
 =?us-ascii?Q?jNtHEZjIEX2kOqjskzEfTU2q2sEjwdIPOFMn+kMnEPlwHW3SM4FkC1kIBmaU?=
 =?us-ascii?Q?cjxj4kCsOelIgalCRAzIC8qNwUcevjPMvK0U4YyVsr47DOODPg6Oeh+TN4d2?=
 =?us-ascii?Q?95tz0Bv1xAVQRQGC5FJZIilVl2gQfbfPy9vdzU9le7EshMmAeehELBEgE2Dk?=
 =?us-ascii?Q?wHLCllMyBIyE9bJTURfVkxkO2+RaMgaXMY3YrgTPAqoMt/RlxwjYx/gGfqmw?=
 =?us-ascii?Q?NmnAG7Qf4MZt8muVuRnVPQ7GGeuAQce6DUikerEg/zooPfm8Z4G7CVoUwwTC?=
 =?us-ascii?Q?VpHJ/wSQODwU8WUjFaZ2y3KDEhl8CL0Af/lgfJxe8/kJzxb+uyAjM3NcNb3s?=
 =?us-ascii?Q?IaHVyNDj1bJLcnZghK+utsen1MRRULc7WU4N24/+x56t6h3qdbx9t1Iz/+rg?=
 =?us-ascii?Q?ezyv0Fqv+IpvGhtA9vLoKAkEI+xWFLCSBY2t7SLN7xz9SPFueJdRpa+9FUr8?=
 =?us-ascii?Q?MwFqIrTWYbm03wyAN7rZKqT4lef4Q0ZRJkDFzesJsYa2o/M3H2nGRa6KAQJz?=
 =?us-ascii?Q?aoRr7pt9L//fpv9J4aOHQcwsOCngJBi5dKSUJ13DMYY9B6OTkFNAt16UrPZc?=
 =?us-ascii?Q?m9o8uTcY2l2QhcGlR5A0NXtDY865GmCIQtB1yaLwLVv4nxWJq2Y+wy8OPWkc?=
 =?us-ascii?Q?+XbXDQ6xrpCeKdxrOr6EAUv5/8b8Z1I69dLuFzNel2sxnnmz4fc1bObMAGSf?=
 =?us-ascii?Q?OJuZGxVgpywrKW1S2/phSnfR5n1vOUUtWqGN6YRBXec+k+HgtHagN1Whd8Ns?=
 =?us-ascii?Q?qYTQrA/VBpb7W2zGKqTffbeGq2NlcZM=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: f01c70f0-6c29-486a-27bf-08da557249b5
X-MS-Exchange-CrossTenant-AuthSource: MWHPR1101MB2126.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Jun 2022 23:44:17.9619
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: QSP8p0oStFEu2r/aHqvxfgX/BcEQ2YBSJWeTqk3USJUa0LOF3/CnFAPIfjLBtY9HFeAgjO5h4whlSGVJkIYPoDSbM0zb2iz6TYFrqs2jOn8=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR11MB4080
X-OriginatorOrg: intel.com

Dan Williams wrote:
> Jonathan Cameron wrote:
> > On Wed, 22 Jun 2022 22:40:48 -0700
> > Dan Williams <dan.j.williams@intel.com> wrote:
> > 
> > > Jonathan Cameron wrote:
> > > > ....
> > > >   
> > > > > > Hi Ben,
> > > > > >
> > > > > > I finally got around to actually trying this out on top of Dan's recent fix set
> > > > > > (I rebased it from the cxl/preview branch on kernel.org).
> > > > > >
> > > > > > I'm not having much luck actually bring up a region.
> > > > > >
> > > > > > The patch set refers to configuring the end point decoders, but all their
> > > > > > sysfs attributes are read only.  Am I missing a dependency somewhere or
> > > > > > is the intent that this series is part of the solution only?
> > > > > >
> > > > > > I'm confused!    
> > > > > 
> > > > > There's a new series that's being reviewed internally before going to the list:
> > > > > 
> > > > > https://gitlab.com/bwidawsk/linux/-/tree/cxl_region-redux3
> > > > > 
> > > > > Given the proximity to the merge window opening and the need to get
> > > > > the "mem_enabled" series staged, I asked Ben to hold it back from the
> > > > > list for now.
> > > > > 
> > > > > There are some changes I am folding into it, but I hope to send it out
> > > > > in the next few days after "mem_enabled" is finalized.  
> > > > 
> > > > Hi Dan,
> > > > 
> > > > I switched from an earlier version of the region code over to a rebase of the tree.
> > > > Two issues below you may already have fixed.
> > > > 
> > > > The second is a carry over from an earlier set so I haven't tested
> > > > without it but looks like it's still valid.
> > > > 
> > > > Anyhow, thought it might save some cycles to preempt you sending
> > > > out the series if these issues are still present.
> > > > 
> > > > Minimal testing so far on these with 2 hb, 2 rp, 4 directly connected
> > > > devices, but once you post I'll test more extensively.  I've not
> > > > really thought about the below much, so might not be best way to fix.
> > > > 
> > > > Found a bug in QEMU code as well (missing write masks for the
> > > > target list registers) - will post fix for that shortly.  
> > > 
> > > Hi Jonathan,
> > > 
> > > Tomorrow I'll post the tranche to the list, but wanted to let you and
> > > others watching that that the 'preview' branch [1] now has the proposed
> > > initial region support. Once the bots give the thumbs up I'll send it
> > > along.
> > > 
> > > To date I've only tested it with cxl_test and an internal test vehicle.
> > > The cxl_test script I used to setup and teardown a x8 interleave across
> > > x2 host bridges and x4 switches is:
> > 
> > Thanks.  Trivial feedback from a very quick play (busy day).
> > 
> > Bit odd that regionX/size is once write - get an error even if
> > writing same value to it twice.
> 
> Ah true, that should just silently succeed.

I fixed this one.

> 
> > Also not debugged yet but on just got a null pointer dereference on
> > 
> > echo decoder3.0 > target0
> > 
> > Beyond a stacktrace pointing at store_targetN and dereference is of
> > 0x00008 no idea yet.
> 
> The compiler unfortunately does a good job inlining the entirety of all the
> leaf functions beneath store_targetN() so I have found myself needing to
> sprinkle "noinline" to get better back traces.
> 
> > 
> > I was testing with a slightly modified version of a nasty script
> > I was using to test with Ben's code previously.  Might well be
> > doing something wrong but obviously need to fix that crash anyway!
> 
> Most definitely.

I tried to reproduce this one, but unfortunately, "worked for me". So
send along more reproduction details when you get a chance, but I'll
proceed with posting the series for now. I tried the following on my
QEMU config to reproduce:

# cxl reserve-dpa -t pmem mem0
{
  "memdev":"mem0",
  "pmem_size":"512.00 MiB (536.87 MB)",
  "ram_size":0,
  "serial":"0",
  "host":"0000:35:00.0",
  "decoder":{
    "decoder":"decoder2.0",
    "state":"disabled",
    "dpa_size":"512.00 MiB (536.87 MB)",
    "mode":"pmem"
  }
}
# echo region1 > /sys/bus/cxl/devices/decoder0.0/create_pmem_region
# echo 1 > /sys/bus/cxl/devices/region1/interleave_ways 
# echo 256 > /sys/bus/cxl/devices/region1/interleave_granularity 
# echo $((512 << 20)) > /sys/bus/cxl/devices/region1/size
# echo decoder2.0 > /sys/bus/cxl/devices/region1/target0 
