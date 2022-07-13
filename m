Received: from mga18.intel.com (mga18.intel.com [134.134.136.126])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AA1A86AC0
	for <nvdimm@lists.linux.dev>; Wed, 13 Jul 2022 23:14:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1657754070; x=1689290070;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=2OoqRWj8+0kroVqCLxwlhn6wdFeJ0CW0lbvje0rsq5A=;
  b=kuJMs7RTQEGYWlHkyXcUSqh1EI7thPct4FMFJcHz5zvvvbcx6HyAlfYE
   GSIMYaUJEpZUIVzQXwyayesMATTtdwYMUboib28rfs8JLRu+ZIMSLAb3D
   CVhWl/AbVPuKcBt4+xLsWtG/6ddnLUKuMk6L45g+2cjIyoKr4zNQQ6qy7
   Ex0OGNJV9elsXPova83bD0FzkQoZFn1IuD7+Uto6l6WrDl/D33o0lJMLW
   HmdrwcaQ56lz1qBN+DjFMqcOQ8cP4el3czjqH89YIykRidGySPAsO6fHR
   uJLmdZ7RHIDso4Q1vdeDlJXWbHL0PpfpVxpkFhC4yK9WImMiPLG1A8s7l
   A==;
X-IronPort-AV: E=McAfee;i="6400,9594,10407"; a="268400277"
X-IronPort-AV: E=Sophos;i="5.92,269,1650956400"; 
   d="scan'208";a="268400277"
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Jul 2022 16:14:29 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.92,269,1650956400"; 
   d="scan'208";a="599923705"
Received: from orsmsx606.amr.corp.intel.com ([10.22.229.19])
  by fmsmga007.fm.intel.com with ESMTP; 13 Jul 2022 16:14:29 -0700
Received: from orsmsx609.amr.corp.intel.com (10.22.229.22) by
 ORSMSX606.amr.corp.intel.com (10.22.229.19) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.27; Wed, 13 Jul 2022 16:14:29 -0700
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 orsmsx609.amr.corp.intel.com (10.22.229.22) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.27 via Frontend Transport; Wed, 13 Jul 2022 16:14:29 -0700
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (104.47.55.104)
 by edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2308.27; Wed, 13 Jul 2022 16:14:29 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=f0pEHcnnfpukmVZOqR+C38R7eQ201g0k82h+cPefzLmzrn9P7FPdmvOJ4g5BgvgU4lYid9q9GQ+noGxgpMr1/Zq+uKYB6Ok4d7L9vnPvUynYS3shQq03PPGEmZd1bbBtVsxYtcIO6zBFDvxiz2UEDZ6w+Vy4bOzKmmFI6zgQpQmVrNSiQjPmKil6iFZUv/LudtcQ+FinJQKwNnnX5j5pEB3M82HcJ/vWcR4ivWnkWiCOm3C8vNeNBASd7uBsfdBUmb4KpACtuHuHv1xKlV3at0xHmvX6seF/Dp5AQ9nrq/G92nk5ztG4kzR+AZxDBl1UGIeFGpf+Ae2YSh+jBDxUbw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=LjxqVFON3dnYzLZeuod3bnjhrLc/MaZSgL2NHfY/qi0=;
 b=lkEaGNIpcsJNjxU27OJAPnhdnqRhtqkVJJFuVvmb2R7Bt0wppCxw1pNfyhpTd/sNVnbmvQ6LQ4tp/E7pHd5nBqHhX6Fbzw7Ua0JlC2lVWiNz1Zc9GjTsmoPXTPc6clXGKDiPkvuaqQctwJ2WU4g1P/uBySRfyjg/p5dwOFyLVb8o3Y0Hy9C+NUeW4wVL15sHa1V9Nci6ZH7OPNKTf6mOUSlybx7Sk/o53rzgkL2RluYqWyrq0DtBHhJNONdJPK3PuqeOQ6eeltcB/xDdkX/KREScmDtCBp58a/jwxqKKd34JxWOI3news42xZD0qjoqoVn/F2CQZX1ijXy7+z60d9A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from MWHPR1101MB2126.namprd11.prod.outlook.com
 (2603:10b6:301:50::20) by CY4PR1101MB2134.namprd11.prod.outlook.com
 (2603:10b6:910:19::22) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5417.23; Wed, 13 Jul
 2022 23:14:27 +0000
Received: from MWHPR1101MB2126.namprd11.prod.outlook.com
 ([fe80::6466:20a6:57b4:1edf]) by MWHPR1101MB2126.namprd11.prod.outlook.com
 ([fe80::6466:20a6:57b4:1edf%11]) with mapi id 15.20.5417.026; Wed, 13 Jul
 2022 23:14:27 +0000
Date: Wed, 13 Jul 2022 16:14:24 -0700
From: Dan Williams <dan.j.williams@intel.com>
To: Davidlohr Bueso <dave@stgolabs.net>, Dan Williams
	<dan.j.williams@intel.com>
CC: <vishal.l.verma@intel.com>, <alison.schofield@intel.com>,
	<nvdimm@lists.linux.dev>, <linux-cxl@vger.kernel.org>,
	<a.manzanares@samsung.com>
Subject: Re: [PATCH 5/11] cxl/lib: Maintain decoders in id order
Message-ID: <62cf51d076841_16a11729414@dwillia2-xfh.jf.intel.com.notmuch>
References: <165765284365.435671.13173937566404931163.stgit@dwillia2-xfh>
 <165765287277.435671.14320322485572083484.stgit@dwillia2-xfh>
 <20220713194502.5hxf5jxpwzvsukx7@offworld>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20220713194502.5hxf5jxpwzvsukx7@offworld>
X-ClientProxiedBy: SJ0PR05CA0202.namprd05.prod.outlook.com
 (2603:10b6:a03:330::27) To MWHPR1101MB2126.namprd11.prod.outlook.com
 (2603:10b6:301:50::20)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 53ad6d9c-2244-4e45-d117-08da65256ec5
X-MS-TrafficTypeDiagnostic: CY4PR1101MB2134:EE_
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: AhQUJ6+GAwXeeP0K29E0lWYeYesoplds/DpYCT5jrI1lyvFaGb9tb1rvj7AwTFCBH31+dbPr49HUS9ZbaeGM3rLeU8qonE6krVcZuHvaNfySzdjB3PdVMP+zu7UB2r+G7/28YboZ4mfcXNFRoIskFCBY3pr9VCbqTg6ah+N0OLMHBvRVeJsxFQvh+b1gbcB0OAn60Qca1j+P6pHJsT8lMo92vDuPJMOTqxisJSK3wSiX9QieyLWL+nYwKov4bPDOpAMoEs6I0oym5dmBa4dtysbTZDHsf4u52FRqenw7ChRmIh4O1kD17jMNoVVV29yShRquoWYuHfU2d9I9HJ6/c2BSSLDxo9hhwkV6p3q9KMYy07JeDKz3VbGZYaxIV/mkhvwKzbo4SG17NXlc05zmIJ2cyi13N3JTWTtrn1W+BLwgQ5FhSnJ49o4j2dbo1f5gxDpvqt5fcxBlA+1kWX9DuTGrq3UptSqu40gbyszXwuhxgurHBD5eSIZkePXCqG04tK8K2wLbe8SLiuDUZCIN+DY2+SeSfma2w4BazXEhls1Ysa2rxynoQuLgzefMvuz/lG3ggb3fX5ZuSI6kbz7yZJ3IoUERnqXu5mENZYq74q98b5H5K6F4SWNO9g0b9G+iqv8McnwY+duoqVjMPwPmoM10l6Vxfk/32D3UHiagIMTTyCjyRDiOFCGMFs2/1aJCmvJa1+ILzEiT1QCSCC6VELsRXvWfJdnP7016Y3loyIgWteAR6a714VaTposj04j1
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR1101MB2126.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(346002)(39860400002)(366004)(136003)(396003)(376002)(8936002)(2906002)(82960400001)(4744005)(86362001)(5660300002)(38100700002)(110136005)(26005)(6512007)(9686003)(4326008)(6666004)(478600001)(6486002)(66476007)(66556008)(8676002)(66946007)(186003)(41300700001)(83380400001)(316002)(6506007);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?8PG3xC4c+Yruhuk/eZI4BWqXWqP9qnUhsIlzZ0PXrtPbNZCvPIv2APDHNgad?=
 =?us-ascii?Q?7DoSll8mw18I8a2NrPbqPP7jBeWjbwLi+7zjHGr3+7891f6s3HNQv2C2aWAt?=
 =?us-ascii?Q?6IwJr1KQzO/0po1rHYB5suu66BsMMz2jP0u2urh3zy2Gr5tqov2SfXaHCAI0?=
 =?us-ascii?Q?VHHDIjBFcyq/txC+AZpD0h0Fiy6xCQOiJ7c1nCfRkkLSedIC4kHA7EWtOJLy?=
 =?us-ascii?Q?GY2CsP4vLLE9KRiXCJDnsPATXtxVJSQSFQp2ir9mVMkWsranrHhhJ7VHVX8y?=
 =?us-ascii?Q?fZCly4vuOQMxn7beWrifn14xitVFkjzT8zVQCwxEXJJNEWJ6/IUiQacs79r+?=
 =?us-ascii?Q?qeydlFpfscA4HUki6UBImgJeju4pflNWlbacn/+EfYY8/2u+agRHiff14wLQ?=
 =?us-ascii?Q?9bsGTu2RNwYXOeKUqz3h6yYdyTfVCFP9oi85XB7qst/fWqQXeLv8vWthDTt3?=
 =?us-ascii?Q?HtJ27TOoSw+WlRTG7W8xF/1fElgWa2t+LWKcTYRCTZdY3VdsZpQKwo8yu0WM?=
 =?us-ascii?Q?ADsiHFBL1Ok/uY7Yw0bMoXDCxBfwCKN28EkSnFHdZ6LwK4yZfvRr6Y43daTo?=
 =?us-ascii?Q?Jd73yTSw3g3mHculZ3FQXEWWRDdIDeIC/zRVa8B0vzLMch27/GUkN1RXJT0W?=
 =?us-ascii?Q?1IhHVtFlv8uSL89rYkqhfLvpkAcFarA+1VdtgoBHdH28DhRb5WS0ImsU370w?=
 =?us-ascii?Q?k8WbpXlwxvEQQWQGMQShSKfKTyn6/WHpJm5NzZ7APzV1HCBvsf4EkqUOUfHx?=
 =?us-ascii?Q?RhnAfnYdDAh7gY3hmiJAeAEp+kbajiMBa1dTG4A6MP2SubuBLMQCZ6K4qPfM?=
 =?us-ascii?Q?YPiKqZJH/mpij9FS0WWLXvhU2o1poPZEwPV3edF2Y8D1tROSNwVTYz06KFZ5?=
 =?us-ascii?Q?U9oZKALXsPchp8xsTbdjjpxm/wEHHAM+wCQGUTDdzGuS0XxO5e6JsVKySZi0?=
 =?us-ascii?Q?H1GD2svz88C19FQW/ytqwdpHb9/FOq3d3UCY7HI4Zk29djRKqTkkPbeTWI7P?=
 =?us-ascii?Q?JRQ2ifScQDq/8/NM1dOjjjnwJDVir82l8CEV45se+wcaVmUn8B7kstMtUitx?=
 =?us-ascii?Q?vmwRhvZ1LvGRkqw3NQSjvN+FiOSN1WM4S7JF1878cQmA8e5+LXqvjFNFVOjT?=
 =?us-ascii?Q?SXGSkfC3QeVsUmCCcnybsWYbNLVFl0B0mRxsTpKWlHv1gFLJJvG6qXSX73ir?=
 =?us-ascii?Q?V0wUICVsXu1/JI/MS/JoO47kFEvLiRg0VDE+2i6Sm13LxgZa9gnU/MJPkVMn?=
 =?us-ascii?Q?wexaUUZueZ2DGxsKsC+gLjOuaAUuVFc9culC6TIg8umX2wix+ARQgmcoDuZQ?=
 =?us-ascii?Q?Z5zmypcedciOA7pnnjiPfGbz6l0iqX3Y0eZNzG1FJDEjbXjAV4bwx2ZFIt/6?=
 =?us-ascii?Q?adfagWcWSZfsuljLA3ujT/8B41E1e8+q2eqaeg8/3fojiAArEHxWRY69gbBf?=
 =?us-ascii?Q?Ek26t2dQ4VksJiTr3QkpyVUWIsIJUFlFpgkapMA00q0T1Lb4BANSwiokZ6GP?=
 =?us-ascii?Q?gVJXG+gMqKAPqv7StrAUr6QteIsrF1JV/kGrvI9JqrXLcfMLQQg0b3H0x0xB?=
 =?us-ascii?Q?a/UGsyt3uXZpDOj/5EtIORRhxAAlBc4PDm5pW+tTWfE0IM1W7hLi7h7xSQEL?=
 =?us-ascii?Q?tw=3D=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 53ad6d9c-2244-4e45-d117-08da65256ec5
X-MS-Exchange-CrossTenant-AuthSource: MWHPR1101MB2126.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Jul 2022 23:14:27.5030
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Wg/VJVLbK7WU1A4DM1sO7CzZK+1zOyl9ERf3ywdjqlcAvI70m0MwSbfA/BKpQchRd0EwhSaLkqOsSJG1v2RypearN5uhZLCZFLdmBLx/478=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY4PR1101MB2134
X-OriginatorOrg: intel.com

Davidlohr Bueso wrote:
> On Tue, 12 Jul 2022, Dan Williams wrote:
> 
> >Given that decoder instance order is fundamental to the DPA translation
> >sequence for endpoint decoders, enforce that cxl_decoder_for_each() returns
> >decoders in instance order. Otherwise, they show up in readddir() order
> >which is not predictable.
> >
> >Add a list_add_sorted() to generically handle inserting into a sorted list.
> 
> With the already available list_add_before ccan code nit already pointed out
> by Ira.

Done.

> Reviewed-by: Davidlohr Bueso <dave@stgolabs.net>

Thanks!
