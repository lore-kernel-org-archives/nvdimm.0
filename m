Received: from mga03.intel.com (mga03.intel.com [134.134.136.65])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3FE867C
	for <nvdimm@lists.linux.dev>; Thu,  1 Dec 2022 03:05:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1669863959; x=1701399959;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=5xf4u3i55w8bidg1Gkj8CCh1mff+WjciWStkoVq8xdo=;
  b=WzmrcG0Vd/c19HcPcOAZ49zjHUS2QsWOaU7vstcOhccNRuhOtBHsW9nU
   lvhsDLbFYrM2kSstNVQLLi/HfXfCIZ8MsU+lK8xHt1Vgxd2NGAOGMmZCL
   HZ+flzLpcNmw/WYgHPb4d3Rlf9/AsMKHEheZCrH2MHOuzESnA/c/DBgIm
   uhFLrsWwQ6d8GtHVV2NsP0r7uAiD072k7JzLxCsbnIe33rGXzCf7vOsnN
   mgO5Blmc9zl8PSIQXStPgLrQf2OO7PbDYV++LdB4DF5ucbM+ZLrYOeLM0
   YTvVpjcjh3R16rNWxoKRC654wQkF1wcrkZl6hOMAbJgj3pnEnzbkFblIQ
   A==;
X-IronPort-AV: E=McAfee;i="6500,9779,10547"; a="317426810"
X-IronPort-AV: E=Sophos;i="5.96,207,1665471600"; 
   d="scan'208";a="317426810"
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Nov 2022 19:05:54 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10547"; a="638231856"
X-IronPort-AV: E=Sophos;i="5.96,207,1665471600"; 
   d="scan'208";a="638231856"
Received: from orsmsx602.amr.corp.intel.com ([10.22.229.15])
  by orsmga007.jf.intel.com with ESMTP; 30 Nov 2022 19:05:54 -0800
Received: from orsmsx612.amr.corp.intel.com (10.22.229.25) by
 ORSMSX602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Wed, 30 Nov 2022 19:05:53 -0800
Received: from orsmsx612.amr.corp.intel.com (10.22.229.25) by
 ORSMSX612.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Wed, 30 Nov 2022 19:05:53 -0800
Received: from ORSEDG601.ED.cps.intel.com (10.7.248.6) by
 orsmsx612.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16 via Frontend Transport; Wed, 30 Nov 2022 19:05:53 -0800
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (104.47.66.44) by
 edgegateway.intel.com (134.134.137.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.16; Wed, 30 Nov 2022 19:05:53 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=nCUIKjJhdGlYMDOxNOqPaBSQViwIcATgszmyJurQ4UzkqlQTChdv912huLoUp6f3nj0ESe5ffV2xpC3TgMhbYgYOEdTNxoxz75eDfRg1endheI+UBe2f2xI4VdGc9RWnE4uDUDykJcdz2/97REDq3AVd0hw5oxTB5Kngw3F13RQasFoSLTTjClur+IYHZupbrdpG/+rgO415yOc8jyyqCfQ5sdVcOjd1tsKPT2DErz9elMmlnFmh8RuIfnGuqq+Fvnwg2V8OQ554vs6WMTGzXbcVgAMXVjDXjE/9dHVTuUV0sDQ7aBeam14DFO8cWoJxJ6COKAclw7jOECMMjiehfw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=I84IBfQRiGtJ+iV4crg69Nqz1OhdNgqwY29zjS1YfII=;
 b=UgzSD1QX6L82FJS/C4+yEYMigsPSM08Ztlcl3IO8eZ6XCA/zO7jAwl2l6QA8pcT4r2vcWJjBvaCwYSIKPg0blUfamH/9oZeNNGLvrlxUncUYeNaw4po0sYlKjATqN9tUSch19SagdWfcc7y8LNWiv0tWutTiqGJdDGlZ93Rg2TvoacRp+BRnvR8rwEW99id+5hTb3FbG/ea4PPmtO5s4wrr5SWWy25tKzBBpHg6JIRQFJmdwjszDrTwFn0W7PyHPwXPDd7+fltHlHRvx9EdQkoK3tmWcn7tGWotYvtRGohPyfjv2PiDdTh/ocDnPkMMl2SVzSMr+Am1P6GbMN8hh4A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from MWHPR1101MB2126.namprd11.prod.outlook.com
 (2603:10b6:301:50::20) by PH8PR11MB7048.namprd11.prod.outlook.com
 (2603:10b6:510:214::5) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5857.23; Thu, 1 Dec
 2022 03:05:51 +0000
Received: from MWHPR1101MB2126.namprd11.prod.outlook.com
 ([fe80::340d:cb77:604d:b0b]) by MWHPR1101MB2126.namprd11.prod.outlook.com
 ([fe80::340d:cb77:604d:b0b%9]) with mapi id 15.20.5857.023; Thu, 1 Dec 2022
 03:05:49 +0000
Date: Wed, 30 Nov 2022 19:05:45 -0800
From: Dan Williams <dan.j.williams@intel.com>
To: Davidlohr Bueso <dave@stgolabs.net>, Dan Williams
	<dan.j.williams@intel.com>
CC: Dave Jiang <dave.jiang@intel.com>, <linux-cxl@vger.kernel.org>,
	<nvdimm@lists.linux.dev>, <ira.weiny@intel.com>, <vishal.l.verma@intel.com>,
	<alison.schofield@intel.com>, <Jonathan.Cameron@huawei.com>
Subject: Re: [PATCH v7 18/20] cxl: bypass cpu_cache_invalidate_memregion()
 when in test config
Message-ID: <63881a095a3bd_3cbe029428@dwillia2-xfh.jf.intel.com.notmuch>
References: <166983606451.2734609.4050644229630259452.stgit@djiang5-desk3.ch.intel.com>
 <166983619332.2734609.2800078343178136915.stgit@djiang5-desk3.ch.intel.com>
 <20221130221641.hban57icdww2fie5@offworld>
 <6387ed1b67fb7_c957294dd@dwillia2-mobl3.amr.corp.intel.com.notmuch>
 <20221201015127.mjq7pa3yo4b7ygfj@offworld>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20221201015127.mjq7pa3yo4b7ygfj@offworld>
X-ClientProxiedBy: SJ0PR03CA0118.namprd03.prod.outlook.com
 (2603:10b6:a03:333::33) To MWHPR1101MB2126.namprd11.prod.outlook.com
 (2603:10b6:301:50::20)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: MWHPR1101MB2126:EE_|PH8PR11MB7048:EE_
X-MS-Office365-Filtering-Correlation-Id: 6b3ee865-0d50-4b11-a323-08dad348f229
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 7owLmioKtkDoPROpy4QQCuNqfF34sIIX9BCGvj3fO79RXh7LuN4F4lhhi1KZPhXpZ9tb1lDRe6BCldcPDx/1Un+AVRNZ8HiGdXa7ajyNQFnv/wAWnM6IxuZKYKCgh471UbTZHBFWrehm6Pqx3FbsxrzFHCkqGthiTT9aTIQxJqzVI+y46d6TOY66hMy0hgtZRxhE6C3AS0sm620CU812vthO2cM8bYsIfZrpIy++RXBo+PO+OPfJd5/fRYb+z+LEh+yKs0WHuHZlCr2oHnd25oASzmx7dj2i79YJsKPzuKHgc9SFY73IUbm/sMtfUwn2cX0y/sqeVNpZmIs8d3y2INd9tHE1V4XdAi3uHg/A7bwb3+CI6Kdk4uRkxd52q+2NhaMKk8ZKZheaX87Z40MnkV0+XAGsetArp79Z33j+6CO+CRKbS2uprtNUZMOBNRixjIQVasusVMm4DX21fKRWk8PKp7cr2Xb5JtFm8P6R7FQr3kbDWSuQSPR0+hkcsS2fHV+57tvkKnuwDjAYxNi5b+jKTGNtQlagPugjptq4S4ywF6p/3w/hTgJwYXAVabtePC9sk+/8gGyVJl/mYqb5TnzITdADT8sGN2hPXtgmJKLemGMXh0k46kzT1pmtE1La2x37D61vAwTSYWE6DQS8QpIrhMAc+RaVP19EhVgRpBzrwmfS3zXrOU1hliA4NOlO
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR1101MB2126.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(136003)(396003)(346002)(366004)(376002)(39860400002)(451199015)(41300700001)(5660300002)(2906002)(83380400001)(186003)(8936002)(86362001)(82960400001)(38100700002)(9686003)(6666004)(110136005)(6512007)(316002)(6506007)(478600001)(966005)(4326008)(6486002)(26005)(66946007)(66556008)(8676002)(66476007);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?v0f0BJg9mt+k0Xl3iOpO5Kxjzl3IlCqkpFYNdTnNPW0xylf5O78Vqrs5SRm3?=
 =?us-ascii?Q?RKgrCAdFzgRwrVD6T1sGX/K7nX6MuWMET+P67C54lgufd7clyg6BYk2yJkw5?=
 =?us-ascii?Q?j4MWEPbQOndUGKk6EbrMOM+wv0p0dS9PJZUqK9533yQQLuwPzq7HngEDUmdB?=
 =?us-ascii?Q?Y54iPw6/EZAwn11zmHmxzMg5gWSvk2gEGyiq3/pbUi3hIIPenmstb09OXFF5?=
 =?us-ascii?Q?aek8Ccrib8SdGMT7CHvFx//swcoXYhkMTeJdHG28BeW+ajW0aoSpLDJx/gWI?=
 =?us-ascii?Q?Gl7aVRKhYANXFd9c6Y79nhquYfgrUqSYDdSQVZRq7smdmXAYlbjpU+qKCZCF?=
 =?us-ascii?Q?FJGhj4WUWSU4sE0xdqfdfePNUFjhZyPyrpNzUFOoAony587ycpGpGsp3wsDN?=
 =?us-ascii?Q?J3IJm36BPpHjJEMj9XCh2HK5ol9YFnvN8A7wE5zDMZOXif55Etp+JGrlBTdA?=
 =?us-ascii?Q?4lHS56NoXUc7d7LwckKdsbr/bt2523PhTMgLvYciFS1Sh9+SGyfmMsunFnly?=
 =?us-ascii?Q?8S0SM0AohGmhBmF1AmsqJr03ryqtIJFUONgrDwOanDm4dhGbHbUoXLlIye7D?=
 =?us-ascii?Q?8qHhGJoHzpevxrhX7ZYGuHEqI1Y43pP2LNhGCHJR0kYJIk+fjfab7uUlek+E?=
 =?us-ascii?Q?z2kvUPXGxiU0xV9tabmZwHENsoBc3522b04870VKorMopA2eSz79cZfi1ZFZ?=
 =?us-ascii?Q?ptE0cuLeKsEVwj/uL0OMp55iNd/OKRH7uc2KfVOV/aFy+H7dV32cqFgs2Zso?=
 =?us-ascii?Q?4E96O5LsNYPRrxK5yTmi0UVZbfe/l4QMjF3cDm/tiI+4sAzc8KgBV7G367kN?=
 =?us-ascii?Q?rDRpFvhNquWDQb1fwwdwUG3b9EH8/rxp5rZxo06K5A8reJ/9E0HtmKZwX5IC?=
 =?us-ascii?Q?bNIylZJdLydgPxRV8dWgM3aoJm0Gt+2IKJu0nx/hJ9riKip40r4cr8DKWy0+?=
 =?us-ascii?Q?QKx6y2GAk1uhLcdeldqlFHo4C/uAdSleRNWWG+1WH5LrMKqnyg5wN2p8EwF8?=
 =?us-ascii?Q?OIOkAVuT3uRNWYpktOYwJS8Yxwk9DZkdNZAtgG6Xwt0YHJWNWOwxjP7ndW6+?=
 =?us-ascii?Q?XDapNCtDGd672RcqAHr5CEp5BeJkCTYpfiU0mdZKrodZiVN+4wNHKS4ntNYS?=
 =?us-ascii?Q?KXPq9MLraWUTM22IWLMGlwuOKgEwh+ZKkLRYfbNkHgvOvhUSegYE1YQ/04Xi?=
 =?us-ascii?Q?XGch1659qrH6lOubRH5iwS2uEYIxXfTHDGAwh/to/bMA+p21M4olZLxUBgUt?=
 =?us-ascii?Q?GTkS54gor35MOlBE006nC8XI75bSzGGwyovCHP9rjRTsUePDgqYnipfW2Duf?=
 =?us-ascii?Q?wiuWqlhnKY/5fXby/Zm/czkPEo5HWZBVbQIcdwgfASY9fk7un7CE1x7Ytjxa?=
 =?us-ascii?Q?4fSX6WDoOFIJtAPFKCiNJA86t20P50hDzed/h3JDvJA+F3wd45PeWpNh1A6x?=
 =?us-ascii?Q?sEzyQaPN7nkVvamm5Z3Jk1blZr100cKOtUdA3WryFR98De9NL0MjD4UsOra6?=
 =?us-ascii?Q?oeJlubhDm8Et/s+4ssxVtt4mMthzjYOeasYStSWojVaLw/ufy42X9pYfKiVS?=
 =?us-ascii?Q?FJKlVsrXgMw6FIE4616HNQ8YtqFno0z+qvFYkPeughSfck7P1XZmaUkyquvO?=
 =?us-ascii?Q?tQ=3D=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 6b3ee865-0d50-4b11-a323-08dad348f229
X-MS-Exchange-CrossTenant-AuthSource: MWHPR1101MB2126.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 Dec 2022 03:05:49.4797
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: jTqR0ot6QXGE9XeTyI2i7dwZ7fBMowIakDpHSL0kF87BALH5BPEkL4BzacFTdgTpkx+HwS5IR8sQ42seO1I8nOvoMhNchmjJSDgydpZSxxc=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH8PR11MB7048
X-OriginatorOrg: intel.com

Davidlohr Bueso wrote:
> On Wed, 30 Nov 2022, Dan Williams wrote:
> 
> >Davidlohr Bueso wrote:
> >> On Wed, 30 Nov 2022, Dave Jiang wrote:
> >>
> >> >Bypass cpu_cache_invalidate_memregion() and checks when doing testing
> >> >using CONFIG_NVDIMM_SECURITY_TEST flag. The bypass allows testing on
> >> >QEMU where cpu_cache_has_invalidate_memregion() fails. Usage of
> >> >cpu_cache_invalidate_memregion() is not needed for cxl_test security
> >> >testing.
> >>
> >> We'll also want something similar for the non-pmem specific security
> >> bits
> >
> >Wait, you expect someone is going to build a device *with* security
> >commands but *without* pmem?  In the volatile case the device can just
> >secure erase itself without user intervention every time power is
> >removed, no need for explicit user action to trigger that. So the
> >data-at-rest security argument goes away with a pure volatile device,
> >no?
> 
> Well the spec explicitly states that sanitation can be done to volatile
> capacity devices, which makes me think the use case for this would not
> require rebooting.

It does, but Linux supports memory sharing across multiple tenants today
without secure erase. So I think the specification may have been getting
ahead of itself about how useful that is as a concept, at least in the
near term. In the long term, when memory may be shared outside of the
system I think the kernel will have an interest in santizing that memory
before it leaves the local system control, but for that there's the
"Sanitize on Release" facility for DCD regions.

You are right though, I was under the mistaken impression that CXL
Secure Erase behaved like PMEM [1], and only erased the persistent
media, not the volatile, but the spec says it erases everything user
accessible. That's going to need to make it as violent as CXL Sanitize
from the perspective of what needs to be taken offline before the
operation, similar to PMEM Overwrite. However, the cache management for
Sanitize, Secure Erase, and Unlock can all be unified under the same
cxl_region_invalidate_memregion() proposal.

Basically any time the DPA contents are changed behind the kernel's back
either "in-place" by a security operation, or a "remap" event of
assigning different DPA, any associated regions get marked
CXL_REGION_F_INCOHERENT. Then the region driver can handle cache
management centrally if the given device gets reactivated.

That also has the nice property of deferring wbinvd violence until the
last possible moment where the cache incoherence can actually spill over
into a data corruption scenario.

[1]: https://pmem.io/documents/IntelOptanePMem_DSM_Interface-V3.0.pdf
