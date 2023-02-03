Received: from mga06.intel.com (mga06b.intel.com [134.134.136.31])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4D27FA20
	for <nvdimm@lists.linux.dev>; Fri,  3 Feb 2023 00:11:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1675383076; x=1706919076;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=ONl6JrxKsG2n0S7v48bm36577dZFRAZ/t0YfQJuYAFA=;
  b=AFBPOsLj1wTA1QFlN2vmpn363IJKEzaU3IpWe/CcGt8X5mqhP2i7qF73
   pk8yNsxBE5dqTtX2AI5OwQrUc8xp1eqvOpYyC3O7wDhtsFW4tpkLS1uG1
   WHoJiQ3N923VWbytnQdBKtlHxrAKcuHkdRrz8/eYdzvPQnolk9KfCQHVh
   rKi89pOl3zZf4ud+nwSfUUlx/VcOmO+zHpmU6dLtnyGlGCsa1ZGzh30Jx
   50o/Aq6iscigQqdTDmHD0mv5EdOV2LLechzJORVLTLlTzeCsnPuu8c7DT
   1g5NH8niNrP5ZpXt1NY9vLz7IiikEU3nWv9wZ6xiQ05OWtVR00gMn+mUh
   w==;
X-IronPort-AV: E=McAfee;i="6500,9779,10609"; a="391008539"
X-IronPort-AV: E=Sophos;i="5.97,268,1669104000"; 
   d="scan'208";a="391008539"
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Feb 2023 16:11:15 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10609"; a="667471976"
X-IronPort-AV: E=Sophos;i="5.97,268,1669104000"; 
   d="scan'208";a="667471976"
Received: from orsmsx602.amr.corp.intel.com ([10.22.229.15])
  by fmsmga007.fm.intel.com with ESMTP; 02 Feb 2023 16:11:15 -0800
Received: from orsmsx611.amr.corp.intel.com (10.22.229.24) by
 ORSMSX602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Thu, 2 Feb 2023 16:11:14 -0800
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX611.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Thu, 2 Feb 2023 16:11:14 -0800
Received: from ORSEDG601.ED.cps.intel.com (10.7.248.6) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16 via Frontend Transport; Thu, 2 Feb 2023 16:11:14 -0800
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (104.47.55.107)
 by edgegateway.intel.com (134.134.137.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.16; Thu, 2 Feb 2023 16:11:06 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=TpIxqBoZPvFseCNwyCnDYQSkkZkE8WFwn5cHFYBYYKZ9sgxYw5jd1t99dr8B3f1G+vr/jLAzCaMBBX8V4zWPEOOL6zlAI5cCBdIq18lzyk3BIRkSHysNCPjWGw2LsyT3D4he7QQ81antj8bESYc6ytUXFq/Xmvsam4YK0upCy/AW3kfrzSN7f86yGpVOS0FqUzqLyecVee1U7gtKa9ip2qTrs1mVDM6xtiBUN9wwU5+/ErKgKb51KO8BZtfyBxgNaXrbcPzBK8IqGeaWtlQDZPSkbqka90tcgowmp4pKirQMtsoXeT9OCanQqcVPDP71j8E5Si04euFbeYvo7pXhSg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=PmN7htB28RJyZuVQ2NOZIQ+x9BGA8AmmEvJ358gaNDA=;
 b=cPb7mbr++c8MrMSnk7sY7iyiJQmJgnDjBIlNPr2FIpE1R/mxCiUu8aoB4fN1sC1ETHudof6e6momOfNmoJHBA3zHUac7/+Vopyxg9HVgtTVyNVfpUqPBJZ+n6/7/KkaJEydg9kRPQqi8AtK77D88hfRy40Jmls+v+usvxXQsirSH286MrW5dVPLwApIjoSJuJJJLSbgCd26MKsQltPk3y6xqsDPfAzpi1gTPlGQ++cdsX1zl8aMj+amX6Tg/00AefiVyNtcukS9ztWE6aAuB9kJglwT9fWCr6hvZpc0CEmwZi0BMEYhSg3h2hquvWD3WXS2JbZTNdxGBRTdgjXApkA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from PH8PR11MB8107.namprd11.prod.outlook.com (2603:10b6:510:256::6)
 by PH0PR11MB7562.namprd11.prod.outlook.com (2603:10b6:510:287::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6064.27; Fri, 3 Feb
 2023 00:11:05 +0000
Received: from PH8PR11MB8107.namprd11.prod.outlook.com
 ([fe80::421b:865b:f356:7dfc]) by PH8PR11MB8107.namprd11.prod.outlook.com
 ([fe80::421b:865b:f356:7dfc%6]) with mapi id 15.20.6043.038; Fri, 3 Feb 2023
 00:11:05 +0000
Date: Thu, 2 Feb 2023 16:11:02 -0800
From: Dan Williams <dan.j.williams@intel.com>
To: Eliot Moss <moss@cs.umass.edu>, Dan Williams <dan.j.williams@intel.com>,
	<vishal.l.verma@intel.com>
CC: <nvdimm@lists.linux.dev>, <linux-cxl@vger.kernel.org>
Subject: Re: [PATCH] daxctl: Fix memblock enumeration off-by-one
Message-ID: <63dc5116b95f1_ea2222941c@dwillia2-xfh.jf.intel.com.notmuch>
References: <167537140762.3268840.2926966718345830138.stgit@dwillia2-xfh.jf.intel.com>
 <7bd7c84a-2c74-df1b-020d-a8f4a6725c18@cs.umass.edu>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <7bd7c84a-2c74-df1b-020d-a8f4a6725c18@cs.umass.edu>
X-ClientProxiedBy: SJ0PR13CA0163.namprd13.prod.outlook.com
 (2603:10b6:a03:2c7::18) To PH8PR11MB8107.namprd11.prod.outlook.com
 (2603:10b6:510:256::6)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH8PR11MB8107:EE_|PH0PR11MB7562:EE_
X-MS-Office365-Filtering-Correlation-Id: ef35a55f-f098-4e1f-6648-08db057b2443
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: QzeNzPjEp2OSec6P92juTtNW4T5kftQ/TUUwyzPJtkgj/R+ctgL3OmRmMbKAbuZSzPcYEzp95meNjm8A3+qjXxneAe5axLGwhKOyby2UDxsVOan6SEOR5CLVv0aeCnBwDoKbw1Ny57ZUlr0CdYIdtfS6/O0YLXfxS9PtuvVb8QRiE6rSDuATS1DGC8EhQxjCYwaSQnvKdvFAXfM5951GepoxAY8r4fCGFVugZ0ZfhEpVlGi3edHBq82qaCAar3IA3YiT3QFT/br9JnhON7OfHq1WtEhJb3u1pZvllVhRcYN1+ljJE9aitCEQeiuYB8E1SNqEIRMtxG9s5W4u4501g7cN1Yti5cnq6MBGuIAL4m/P81+qzoKtMZLyykq6jIfgHlGJtcxDCWuObsGCNCUadxNWMduBU1ZBUHuU71VbuiuTp7khrY04LYsAgcivwU60MyObsGN/gLK74l8dEcY8n7u7PVpNN6tDay6RCOv/NVwGnkPdln07Fq/2UpL/anzWBw7kCtqoz/3EWGPeq98ximciQmbx2+VLSljqchqIXZRMS6OG86MlcmKzQuvBClUrQIF2iOEMr6CNTJRmGFfWFLRZa2Sk7/rqM/KEUpsOYxnxyuomPKUt3Ys5j9VOBhULeADR9eZxj4hJhl8AlxDi1gwhOUsSeixz1mux68HT/NRRuZOL29Ag/WVqSdERLx6h
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH8PR11MB8107.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(39860400002)(376002)(346002)(136003)(366004)(396003)(451199018)(66946007)(66556008)(6486002)(66476007)(86362001)(38100700002)(8676002)(6666004)(110136005)(83380400001)(966005)(26005)(6512007)(9686003)(6506007)(186003)(53546011)(41300700001)(5660300002)(4326008)(8936002)(6636002)(316002)(2906002)(82960400001)(478600001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?HW6huAqVp0S5a6/Z+7twD7Jgbv6FGrv5uDzHoTdg2LIbf/p0sI6s0f5UKw/9?=
 =?us-ascii?Q?rMlRajVG4jATar4acEmmTkF0KcNul2CnerlCDmB5m8FsbgCt6j8vwn1eNz/O?=
 =?us-ascii?Q?gTTrgk7FLc+uu6H1QTXTMNaEdvDZddxHoKP2SUok7lEAH0BOl4x/14hD53w/?=
 =?us-ascii?Q?P7NyyDs9ecH9a63wjPuHiVaRQPwoJpAAEDVqRKj3efKonHwSgfN0Ncv9No8D?=
 =?us-ascii?Q?qV20X05N76eh3zBC+Rdr+MvkToI0h6eyPUSt88xU32jQMYy0tth2Vynpn/ZY?=
 =?us-ascii?Q?SCjXmkBVwk8pFH6aX1DhDvlX7u2uMmFaPhA2oahKNQizbOPmqV8k/9hJVkOB?=
 =?us-ascii?Q?wEr5qkos4U/P9cE6a1aBtNdYRY9FuLJmXQTDkUKJuoC5ZSrHKBvNLwrByJvw?=
 =?us-ascii?Q?oaJ2c8RFUthG8ed+B+qS7SWxMFj/Z95uhQAp4sQvHCBwkbaEQCLID24+E02D?=
 =?us-ascii?Q?74jJhU0CzYkiLJs2B/Uyo1j0x59Cl5ZHMd9tmWAfJ6CXaMc8ZXI9K6ZHjdHu?=
 =?us-ascii?Q?DOWehFHZVUeLA1LSuzqf9xUBox5sfVAQdcVZ8Y4Y7bipZjCFVjatFuOa7eQx?=
 =?us-ascii?Q?T9j2oxjGpUCs4vIXEsOirngZIJ+87OPHn8+wAtiSXXxuUHq5du0AWjdPef+Z?=
 =?us-ascii?Q?YllDyGlZ3bBsz14h1HyLGX09QukDSj5s1/10RiTAKnUCtE9r0afag7KPKs2k?=
 =?us-ascii?Q?+gkPEmTXV8d8m6ZIWDbLJYuHbe6JAN1QFfx00GnZxwy2kXtmvXxpLKY4bniS?=
 =?us-ascii?Q?/nJgDUp84YasMfpYWbLVMt6AFv/re4MWHuPHBnBoR+XV2LlNy5FHRDVB40MT?=
 =?us-ascii?Q?6rJsYj6Iwc/cWivbR4P2l5LpBeb+ee8p7b67GE/RsjN7RUS1+DcO2yj+XUBp?=
 =?us-ascii?Q?9DgSDGZENzJMgPi0WoRrM2/R5ZtHc37d31hNoXep7xhNhFUex0wPHdtkujmO?=
 =?us-ascii?Q?7a3Za15F6rInwMl6/iS36gXqCg7GtFP433pqcgPQAGKMeO2tgITJujSOTsJ7?=
 =?us-ascii?Q?bH3jA2dNs6cqGmO0B3D7PR03ikpZEJ7lc0C9qqgbd6YAtAzOGV1TuAj47dTc?=
 =?us-ascii?Q?iwe9OHbH8jfa7jkKJBEHld1HtqK+mEiRTrVmUAfDgLpXBeN/v81QMtm+Rf4F?=
 =?us-ascii?Q?1LZrpldl6uaYQT+BvJBpZkFF4O11m2oy4tvGSp/DKgVdyyCO3iaKr3b1Qa8S?=
 =?us-ascii?Q?+KukSRlVH6kwV8V0YoYlqbSloQryinBDXTq8S7eG+qIeFJ/a5phEDs/ibOQY?=
 =?us-ascii?Q?I9LbTBi8jGoJtJ/8cegszKFQwne3+6pQp9gbGR95JH7xQNGxGWOhFJMa4Lqu?=
 =?us-ascii?Q?QrYle0BREdiVlEifzSFjzONywlg6/VEcAhywuq4WBRt7lQ0OfmOWil3AOkWx?=
 =?us-ascii?Q?NchQbpFrV2dqeUJN3R6eRrs0UtZ/XD2joS8bmzyoIr0Zv+lWSa4R/J6MKN4y?=
 =?us-ascii?Q?WXWKOkpFUW4YxtWhUBgGCDqFpivNhCzFw1wDjXIOD629LaIIoV1J3v8MGKq9?=
 =?us-ascii?Q?4VUcf0wfkNOLxZ+kzO8w4OtdG+fvYdvslPj6y3OAHmGX+Zg0/NS92i7KSw3K?=
 =?us-ascii?Q?xVrkZHnyR0hvpk9wyZKG0e1hMDK+QFT/dRFCu/NdxbRLctPdsH+5hmjgtaWs?=
 =?us-ascii?Q?Xw=3D=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: ef35a55f-f098-4e1f-6648-08db057b2443
X-MS-Exchange-CrossTenant-AuthSource: PH8PR11MB8107.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Feb 2023 00:11:05.4435
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: BnNNdd2uHVgzQefpkVySl67jaoZft2fWEanAwMTsI0nHiXTVWSNCIMPDktqyTqLsXNA7TDSB+NzEnu1JC02uCiD1GigEiCB9s8tXWWCLyAA=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR11MB7562
X-OriginatorOrg: intel.com

Eliot Moss wrote:
> On 2/3/2023 7:56 AM, Dan Williams wrote:
> > A memblock is an inclusive memory range. Bound the search by the last
> > address in the memory block.
> > 
> > Found by wondering why an offline 32-block (at 128MB == 4GB) range was
> > reported as 33 blocks with one online.
> > 
> > Signed-off-by: Dan Williams <dan.j.williams@intel.com>
> > ---
> >   daxctl/lib/libdaxctl.c |    2 +-
> >   1 file changed, 1 insertion(+), 1 deletion(-)
> > 
> > diff --git a/daxctl/lib/libdaxctl.c b/daxctl/lib/libdaxctl.c
> > index 5703992f5b88..d990479d8585 100644
> > --- a/daxctl/lib/libdaxctl.c
> > +++ b/daxctl/lib/libdaxctl.c
> > @@ -1477,7 +1477,7 @@ static int memblock_in_dev(struct daxctl_memory *mem, const char *memblock)
> >   		err(ctx, "%s: Unable to determine resource\n", devname);
> >   		return -EACCES;
> >   	}
> > -	dev_end = dev_start + daxctl_dev_get_size(dev);
> > +	dev_end = dev_start + daxctl_dev_get_size(dev) - 1;
> >   
> >   	memblock_size = daxctl_memory_get_block_size(mem);
> >   	if (!memblock_size) {
> 
> Might this address the bug I reported?

This one?

http://lore.kernel.org/r/558d0ff1-4658-a11b-5a6d-0be0a3a6799c@cs.umass.edu

I don't think so, that one seems to have something to do with the file
extent layout that causes fs/dax.c to fallback to 4K mappings.
