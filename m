Received: from mga11.intel.com (mga11.intel.com [192.55.52.93])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 41A6F15AC
	for <nvdimm@lists.linux.dev>; Wed, 13 Jul 2022 01:25:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1657675537; x=1689211537;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=7zxXkwQ5ks7gOR4ReOvhSqieOhYRePIpWqjwbwVoji4=;
  b=axo41C3gKgmzxHHqmVqB/dVHFONReehiHT14/i394XTvitQpsj2iJ4S3
   MmqdYkU8lUPPc8AoVufFfamabTHZiKV+4olvICdbc4cAl/QdmEvNIrnJJ
   CCd+UNFBgnDA3fTB9i4uvTJkJeNkeGE0W71XOuoxmpBaMNf/49zbe5waN
   KuoecKoOKcbMxCN+RJ6G6o87mM+LLUyl7Z0UUcQnmXkVbnDwRt40tSFXp
   ZTIGoq47DR9v2zBH6zkYLUb12R11CMpFxs/gGhqVDgzN7ev3gdZvJSM8z
   zzE1iiQUoZRjg7n7eH9Wk+tK9CQg1qH3MCb3vL1qWtdQhES8mRPDXpaSa
   Q==;
X-IronPort-AV: E=McAfee;i="6400,9594,10406"; a="282634480"
X-IronPort-AV: E=Sophos;i="5.92,266,1650956400"; 
   d="scan'208";a="282634480"
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Jul 2022 18:25:36 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.92,266,1650956400"; 
   d="scan'208";a="570414269"
Received: from fmsmsx604.amr.corp.intel.com ([10.18.126.84])
  by orsmga006.jf.intel.com with ESMTP; 12 Jul 2022 18:25:36 -0700
Received: from fmsmsx612.amr.corp.intel.com (10.18.126.92) by
 fmsmsx604.amr.corp.intel.com (10.18.126.84) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.27; Tue, 12 Jul 2022 18:25:35 -0700
Received: from fmsmsx606.amr.corp.intel.com (10.18.126.86) by
 fmsmsx612.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.27; Tue, 12 Jul 2022 18:25:35 -0700
Received: from FMSEDG603.ED.cps.intel.com (10.1.192.133) by
 fmsmsx606.amr.corp.intel.com (10.18.126.86) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.27 via Frontend Transport; Tue, 12 Jul 2022 18:25:32 -0700
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (104.47.56.170)
 by edgegateway.intel.com (192.55.55.68) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2308.27; Tue, 12 Jul 2022 18:25:35 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=OrPWYGV7GlcjRF0ZAuzhmSzTL9Len0Mfe2xIMGXoqtFY4JjeGkvfzG7vkfcFc4J2cmsOCilNamNCG30Z/GNrAXGJ+A4e1lBx8qKLn0dxxoWuSfB6w+httuQou/rclTjghDWXtq+yGY1rnAEvFGSa0SdDMQCcl4wYUzuQnKJBBUTq9aSQ/a1HuAEv9789wC2uCKALpYZJavtZFeJU7NWhhht3jJ2PLorOTWvSTvkzrm1a9T183HfvcTvvExGTBcFtnvBLSoY6P/fu+Bq+dLXlLx9mPcqkHK1GBYMFjYm0lScZdH7haR4xEspPDloIY7cCJzxwK1BiIxv/mqUK4dZ+ug==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=tBWmGbWiS9MXJPwZTTZeyGz1+XiBfnCuu64wpbrHYs4=;
 b=lh6GxZ+H5j4MVIiRONFCrAaWA/zCL+Nz0277cOpG1VDYOfaDMZkQcbv3iISbNKRmpUmSumMrUz9v9kqm8caU5irW1TvDT8Oy9Yh64rTmGa5H2HVROu879FBDwj5WjqGG3hhW7dk9nSwj7t0Xs8tMf+7pcr6geFEuJeD8+i7Kbfe+bQ68mSIZ4vQob3ufmCx/6nRCZNj8UZq0W7L6hazoIt34ME1cM8W60hNA4tv08KL+5Mjq2XjL0Dj5kAbF3qB6yz1P1Gor2qW6kt/FsvXDOfqGslOXlT6ZgGGqqWJdnL8eEjEfb7klmqes+Z9+a6gn5liM2duqCZCnnkjfObDJKQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from MWHPR1101MB2126.namprd11.prod.outlook.com
 (2603:10b6:301:50::20) by SN6PR11MB2638.namprd11.prod.outlook.com
 (2603:10b6:805:58::21) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5417.16; Wed, 13 Jul
 2022 01:25:32 +0000
Received: from MWHPR1101MB2126.namprd11.prod.outlook.com
 ([fe80::6466:20a6:57b4:1edf]) by MWHPR1101MB2126.namprd11.prod.outlook.com
 ([fe80::6466:20a6:57b4:1edf%11]) with mapi id 15.20.5417.026; Wed, 13 Jul
 2022 01:25:32 +0000
Date: Tue, 12 Jul 2022 18:25:30 -0700
From: Dan Williams <dan.j.williams@intel.com>
To: Christoph Hellwig <hch@infradead.org>, Dennis.Wu <dennis.wu@intel.com>
CC: <nvdimm@lists.linux.dev>, <dan.j.williams@intel.com>,
	<vishal.l.verma@intel.com>, <dave.jiang@intel.com>, <ira.weiny@intel.com>
Subject: Re: [PATCH] ACPI/NFIT: Add no_deepflush param to dynamic control
 flush operation
Message-ID: <62ce1f0a57b84_6070c294a@dwillia2-xfh.jf.intel.com.notmuch>
References: <20220629083118.8737-1-dennis.wu@intel.com>
 <YrxvR6zDZymsQCQl@infradead.org>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <YrxvR6zDZymsQCQl@infradead.org>
X-ClientProxiedBy: BYAPR05CA0107.namprd05.prod.outlook.com
 (2603:10b6:a03:e0::48) To MWHPR1101MB2126.namprd11.prod.outlook.com
 (2603:10b6:301:50::20)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: d040c4fe-6709-49ef-0245-08da646e9440
X-MS-TrafficTypeDiagnostic: SN6PR11MB2638:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: S43cJVPm2RxNPGB3eYlVg9Vg52AILIhiaOV9XmBZyql8ShUHJxfWtddS3qIQQhzkT8NDpyKS77BP+VNy+R7AEOIHW0szyNfGYUgPcN0evmMGNJ82uPh2W7eDfD03q/MFubB28p7mvZY3YOySlKOCBe7bbxakkSp1l+b8mJdektzWXwvizFKfgAXM4suNfnIsuJ/rRwkY0K1gLVrXfwGN9F/vu4zj8n/s2vhYzGy5eSK/SIWfGxnjB1KYPrr67RFbFzRZuzKdjDxEgZhP37sDFejjyHX+tDDXfhf7v47Tc6wLeeoy7hmOi+71vvRKlpnCfHkO089odqg+lj1QvGqHjvT6WPgFo2U7cykDxPZmNwl//X7gLBVfjaAIRNdCLtSVOx8UMDGLIA1VRqF1Aqx6ffzqWzu4qnC7dzwKnMN0MR0ZJb6zvu4BPgPoDzmMC69o4Tq1+QxQyIFi1UosaKeH5cZjn/8CMIcijfnM9SJr4kxGwzm/7Du5OmGdJR17hsm4AHiuOMGuoulH0MyxT039RS8lpiptV9QOR4Tf0NXW88M/pOZGSBRhilrBadaKJl+hFgy9dioDoob1vGBDu9MunRy7xWtaJ1u+KlHXqXGnMh2gqbYOmb/95bW0PQm2IlkW0YUCbyXRKTKJuSazrR/A+M2EAE9n06Vy/c7KcuJ1oqzEf0WakGk8x4bf1B5vpJL9epQPjeUz7hotv+9z0RSF7z+4Ner4hcKjYlh4kjcxBInMbv1391rmwUF2r2Aynod2KaDeB+T0NDmWUx0tHDcdlg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR1101MB2126.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(346002)(396003)(39860400002)(376002)(366004)(136003)(66946007)(6486002)(41300700001)(4326008)(66476007)(478600001)(110136005)(8676002)(66556008)(5660300002)(83380400001)(6506007)(6636002)(8936002)(2906002)(316002)(38100700002)(82960400001)(86362001)(107886003)(26005)(6512007)(9686003)(186003);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?bCLPyH0MLzWzDY16XV24ggi8GI/mIdlUhFRMpPenfdhZeoBvM6OEZc7NffMt?=
 =?us-ascii?Q?PmN6p/zAdkZyl8DUDvQCfkZ7pClHH/Uij5VEpmqY2uxJFZrTKDHzVAT3CpcP?=
 =?us-ascii?Q?IQzt+gjWF2BLip/UTZPKw17m7USsemhz+ch/gBukU8dzx5PRBUrPEt2ezExu?=
 =?us-ascii?Q?mPaHx5RImAuIm9RwDQP0Jk0cnpIcAdIUZkAPSHT6seFHTJvyCuDfrR3qFrNb?=
 =?us-ascii?Q?QBZTei2LOB3W7eYsmSB9Zi/0e2whI4QhXcuQFSOEBeGsZypUc1QxbWZ0ZrUV?=
 =?us-ascii?Q?sQFrOPed4fSmBVYUh89wIADIpYaEblfRX35+90b2kRUOJgyU2eh7kMfbUIby?=
 =?us-ascii?Q?mKQ8EnA9WcyGZeheS++8G23NZKIxsOvDA3ZIaC5smzS0JanoZNjsjf0JAgMr?=
 =?us-ascii?Q?4jk653s1jdPwClnHtRHIIHb5BH1VUDzF9M8g7q52i8RfJWI1ZU23Ctxo0tzx?=
 =?us-ascii?Q?xH8yCnURyz66yhcFtLr8/gWSRJjWoLGfNmBc12NtA0EJiHA7e9i6f6aTWGj/?=
 =?us-ascii?Q?iQA1xUiyPL13OkArWxPjubuwMhPGxrHxrAIlEcJ8yhRhEkuR87ebb+rECJE8?=
 =?us-ascii?Q?ehTIqYmZK/iXYQiceXOlk2bg4zCEqmuPQJOgbskHKV3wlkISLMOsqjxzhjdP?=
 =?us-ascii?Q?NV/rYVVU281zJQ4v4+1jRqsDGfiOUMqUYf/cm/ZewshcER46qccy6LLIjsj8?=
 =?us-ascii?Q?W+dqn8e6FRWChtWG7X0y0UKvFyo0nqbmz/D6CaP3drX6GSroOFGL/KTzuliM?=
 =?us-ascii?Q?TgdMCrNc6vztW2WCGV8Q5EdY40c5vYI59avtYWKPYTK+oZSimUQPrskZcVI9?=
 =?us-ascii?Q?V/egZSCZYViSAAmR4RzmUXNS77NJJHDCW9xjWYSvmoLz8w7jip9XZSPHxEIp?=
 =?us-ascii?Q?Dfd9HBsDbYi47wqDTooiy/v55jdFDRLlYjBo10EchEV+HXcGo6BXVd0P7LPn?=
 =?us-ascii?Q?AmCeV+tP8H2U9eyy8rgFPPf+2XIqWgSVstCww4R0jyGd4mO4h92PTM0cNaD5?=
 =?us-ascii?Q?I7lCCclktaLtWFTk+pH9iCz+f7/r5s3PImgF9/954GphxssuATbkQGD3yE31?=
 =?us-ascii?Q?IkH+uyMeKgff4C5wbsGxefJF6eaN1UoNvD1CNnfCabK90DbvMduH0c7DHrHt?=
 =?us-ascii?Q?ZKGR8SymLuaEXjQycgooEPPILIolYUnacfaXTdMb5/CXKz+TNX9g7zmN0ksL?=
 =?us-ascii?Q?bKbcGImsIUu1nDGu0BoNYKVYhMgLi/FseOMwsG3c8ZYbT001jChlptZb0HgY?=
 =?us-ascii?Q?w+nq656XXqtwb73VQcVwjI8ED4b8Q6eUQ0mdotxiS87EDGpxq5BsjfwNTuBc?=
 =?us-ascii?Q?LNqaV9+0gdQNeEw+mawQnlBxwD854VlUWTWuEcaKyPyywE0QOd7lCiXA4ALk?=
 =?us-ascii?Q?xnH8PafKd3tv+6jEa3CFDNZtBLK/TsdXlcOMhRw5t1yuiHNdYdj7R4DKIAYS?=
 =?us-ascii?Q?3ttQgUuL/Ia3D653P0Ui+FCCrrUUs0+wDoKBmMDqw8z/K/nLTGWkltyCoDMW?=
 =?us-ascii?Q?9VpDHbKerSDsfDirC5CWoU35aOsEsYz8meB6IkVFn1ai8iMdO7ybVcEhXpsP?=
 =?us-ascii?Q?VLI1QgviAwIQsLYp9fI1XG3MJ67VJJtvXBciFCjC1rvYUxNrlJbeCsU01isV?=
 =?us-ascii?Q?VA=3D=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: d040c4fe-6709-49ef-0245-08da646e9440
X-MS-Exchange-CrossTenant-AuthSource: MWHPR1101MB2126.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Jul 2022 01:25:32.4155
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: RwHyvyXVCzRVjC5Vj86h4WBLnJMAuPch/TyihQ5YQWzbGtn/P0b4ziDvwB+eF2rO6XNg5q+651bSxObiMKmw+Y6g/NkdBgVZa1vvfB71Rog=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN6PR11MB2638
X-OriginatorOrg: intel.com

Christoph Hellwig wrote:
> On Wed, Jun 29, 2022 at 04:31:18PM +0800, Dennis.Wu wrote:
> > reason: in the current BTT implimentation deepflush is always
> > used and deepflush is very expensive. Since customer already
> > know the ADR can protect the WPQ data in memory controller and
> > no need to call deepflush to get better performance. BTT w/o
> > deepflush, performance can improve 300%~600% with diff FIO jobs.
> > 
> > How: Add one param "no_deepflush" in the nfit module parameter.
> > if "modprob nfit no_deepflush=1", customer can get the higher
> > performance but not strict data security. Before modprob nfit,
> > you may need to "ndctl disable-region".
> 
> This goes back to my question from years ago:  why do we ever
> do this deep flush in the Linux nvdimm stack to start with?

The rationale is to push the data to smaller failure domain. Similar to
flushing disk write-caches. Otherwise, if you trust your memory power
supplies like you trust your disks then just rely on them to take care
of the data.

Otherwise, by default the kernel should default to taking as much care
as possible to push writes to the smallest failure domain possible.
