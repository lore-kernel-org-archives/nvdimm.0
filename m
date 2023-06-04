Received: from mga07.intel.com (mga07.intel.com [134.134.136.100])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8707F64C
	for <nvdimm@lists.linux.dev>; Sun,  4 Jun 2023 02:41:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1685846482; x=1717382482;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=IqmUlY5rjZQfcPBJkRnp6QDrJaeryHaulh7j02AVedk=;
  b=DWHCdq2zIh4GFgNyo1o75Dvs8sKB4TEL4+RjbzSAxNOxf4ITl9arm3h/
   jEOPoS7CCDlh3e2WDeVOzl8cajakzgrcgwJ6hRPm4wHumekZGep/Xhncu
   ATxoqvkQ7coaRy5HY0kydyKw5DmCnDrnHyaJX+zh9pkQfkB8GgQuahclY
   04diJBSRWguM2Man72cqzfKFMF8mnmXR/uyT2vyQBCWa/RkjHSqTf6C6q
   q3IMtEdqHnbrCEMvunWEklvCw6iYp3G6pzOQVS+q8nitfUuVjBODstekz
   AoZopSI/qadNhJnqldkHMjUJTBQZJrsjlwil92rf06rhGQ10Q6Dh0UGDl
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10730"; a="421964907"
X-IronPort-AV: E=Sophos;i="6.00,217,1681196400"; 
   d="scan'208";a="421964907"
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Jun 2023 19:41:22 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10730"; a="852569120"
X-IronPort-AV: E=Sophos;i="6.00,217,1681196400"; 
   d="scan'208";a="852569120"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by fmsmga001.fm.intel.com with ESMTP; 03 Jun 2023 19:41:21 -0700
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Sat, 3 Jun 2023 19:41:21 -0700
Received: from ORSEDG601.ED.cps.intel.com (10.7.248.6) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23 via Frontend Transport; Sat, 3 Jun 2023 19:41:21 -0700
Received: from NAM02-BN1-obe.outbound.protection.outlook.com (104.47.51.42) by
 edgegateway.intel.com (134.134.137.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.23; Sat, 3 Jun 2023 19:41:21 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=RDNBqYy1pQU3iXdvXVWbiCmuuphpkEIICb9i8L7mkafoQbQDlw56mO/sBpwYTbbIWdo0oJPf9jeXrdlOLmkI9LfbYeyLmty0/lhsJoRcobDW9BBauQuCWqeraxXrW0sjxiMH9yLorMs2WXAZUr/0a/IOQLzLgxl7owi2YbEYMJjZejIspVcTD7QbLz/MKY29f8nuFryD20iS5ZZBXP8BlCcK0KmB5BdHvI5gxYk/OK2zM5aYWSZa+Ma9oB51XMm73A1kVrk9eWo+4VcjmdZKO2+lkOpzsnQLBfHUSVf70i9C7+xS2fQ53REjdGhRRA6kr0qj2sEDxOsnRWagFWG9iA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=eJnekjid4qlTfmviF7AYN+J9jdr1ZxGvCN99DuthJoo=;
 b=YLKilcaaBI4s33v7uFm5NDbefdWeG31kBV8OgWG9cGA4M8Sp7noOhRcWSattEc0qJL9cAiVoRZIAJUIYw/P5whC6JrSWyg+DboZsd1M/18/jshP2RycM31a8YIJosK80Zv333+mLCpIqkK6JFrT3q3M2wjcGGXY4luXqUNwpHM0V8OD6KZ4sGm4L9V6B3RbMKRIfn5N2odn2h4mnH44VhrF7+xIuLN2K5dEpew2bXx6Z6IFCuxIi6R8gLZz574x7G+mtbG8UzpwXvKPmlJ9PYlw7NNGd5GTi3eOf4Zf/eFS70MOz0ezseSZrjY1G0XZESoT2tOvxsJMAV3mH8s3fMQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from SA1PR11MB6733.namprd11.prod.outlook.com (2603:10b6:806:25c::17)
 by SA0PR11MB4671.namprd11.prod.outlook.com (2603:10b6:806:9f::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6455.31; Sun, 4 Jun
 2023 02:41:19 +0000
Received: from SA1PR11MB6733.namprd11.prod.outlook.com
 ([fe80::9679:34f7:f1b:1e7c]) by SA1PR11MB6733.namprd11.prod.outlook.com
 ([fe80::9679:34f7:f1b:1e7c%6]) with mapi id 15.20.6455.027; Sun, 4 Jun 2023
 02:41:19 +0000
Date: Sat, 3 Jun 2023 19:41:15 -0700
From: Ira Weiny <ira.weiny@intel.com>
To: Dan Williams <dan.j.williams@intel.com>, <nvdimm@lists.linux.dev>
CC: <linux-cxl@vger.kernel.org>
Subject: Re: [PATCH 2/4] dax: Use device_unregister() in
 unregister_dax_mapping()
Message-ID: <647bf9cbd6edc_4c984294e4@iweiny-mobl.notmuch>
References: <168577282846.1672036.13848242151310480001.stgit@dwillia2-xfh.jf.intel.com>
 <168577283989.1672036.7777592498865470652.stgit@dwillia2-xfh.jf.intel.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <168577283989.1672036.7777592498865470652.stgit@dwillia2-xfh.jf.intel.com>
X-ClientProxiedBy: BY3PR05CA0026.namprd05.prod.outlook.com
 (2603:10b6:a03:254::31) To SA1PR11MB6733.namprd11.prod.outlook.com
 (2603:10b6:806:25c::17)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SA1PR11MB6733:EE_|SA0PR11MB4671:EE_
X-MS-Office365-Filtering-Correlation-Id: 5a122a7d-9921-4edb-d6f6-08db64a52d3e
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: L6uD0ZOwdFHV3ppZlaBalc4tlRL6O/yXgK+igUjFMgB+wnAHm0YZY4aP9RLGCPB/NkH8R0eDMwUIXPWaWEUHL0pSIP29rLWc6RpD9XPtq6QoCylBt2FJmJOWbkLa+PtVgOrwbQ9I01e2hzj4M0cxwe7pKWJ4k5pmHbzV3vKI9XUNRiWKh/8MkpcEOf1GZ6IeqCKAT3fXTCBzElIjr/6DmRqaRVVVoJIJomAPlrSRpDk73rOHCWEdB8EcvOBsEcT8rvqo/kuqDptWoCrHnAuz4s9Bj7fU5F3Q5BKXRdwQXAR9vwz24vbgf75U+GQJlbGDO300TANP8/ADgMT4pVyMzqm+0ybf3r+fvd7V7ItpFsPveic4tO7SslZixniU7IQtAcz5lrEVyofycY6iouUR883l5ZgOtbW6LLQ105cvc6Tu5YeQPrFeJF2NF7rUVU4edfQAbU1nxdaeQqTh55RxOPpSpOAjB6Fr6VZ98YwLZlWlIwZVA/kLuao8/rOnAGlmgjHUHP+xHdJpHhdIYSToryODGCwkZOv060FR88h5ti362pm/AFo3vDi6boenTAk6
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR11MB6733.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(366004)(39860400002)(346002)(396003)(376002)(136003)(451199021)(478600001)(186003)(558084003)(9686003)(6506007)(6512007)(26005)(6486002)(6666004)(86362001)(2906002)(38100700002)(5660300002)(82960400001)(8936002)(8676002)(66476007)(66556008)(4326008)(66946007)(316002)(44832011)(41300700001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?hTK6StSu1gWMVsLAvbQOs3+8MRmzu96fHW5O/3EAD7TSGtdxhotVNgSVMyXQ?=
 =?us-ascii?Q?x0lUwVD9nx172TrjPDEadpzF6tHSpCESVGwZTgIHm2jPUyrWNZNpdM+D5Oxc?=
 =?us-ascii?Q?vgZb8KzLSTujpJX3gqtwmFHWE7NpRFFGondCSlWzfJtQxiWy+7TnQYp/fE8I?=
 =?us-ascii?Q?RPLqgCLW8+jKnC0FSXVYABHKY2rWSwhi2DhNkwj98C51u1SzGzs3OsUiMG2r?=
 =?us-ascii?Q?B3GWjLCrT4qEElZEUHId+4vwW+ZqbfLv4gn7K+K/GjaLnLgPaoozojLVhaPM?=
 =?us-ascii?Q?G+hYCniGiEO0DFfq/Hw4nIyVPhb5YRhZfX5GCuzxl8qNPfbGbmazLDX2kBVV?=
 =?us-ascii?Q?PVE7qc6t86C4rMgn2GI7l5a9OmZHmXr58EVNDp4A1xsWqkpqtZGmt2+gzZ/Z?=
 =?us-ascii?Q?DyBjCGXrnitBY1rvxynHRRi6R6AkS+DLKIaGgdNjzVFo0GPK8T0H0eD7Nia/?=
 =?us-ascii?Q?DAp72Pkn07NGWasF5xOApLvn+jCaO3dHZ16XNDxqbH3Yv70SG2kNVuQUlqEi?=
 =?us-ascii?Q?pfqW6w4J7Z71RjfuhSb/if80YjgvG09hxilYODx+5ULjjrZ1a1bhzBFVErKJ?=
 =?us-ascii?Q?A0qoc7dpQZ0/OCWBuDNoHpk4Cme+y42d+iYqrxyGPIUhe37AAvFQUFSzlWSk?=
 =?us-ascii?Q?JDW9mOPw++nalgE8Dt7r5YW7a7i4pTex8esNCxYI9Vjf8YWBUeMoO7nqbtN8?=
 =?us-ascii?Q?Yxp+JeicLTXbaBOg1e2IyEOy3Y5M/Cpfjf9/a+UTbY5NvIB5ks1B/FhuRuJX?=
 =?us-ascii?Q?QBblBWoJ9AsAuqM8f0MONz6oMOUssr9JT349aXHcn2ekDzlQynDT2XFCDYUs?=
 =?us-ascii?Q?a0OCGK4Bq4rCNytCeG6tijc3FHKTIN4FquN0DZaseoYh1F3fvCcd1jdtPQOM?=
 =?us-ascii?Q?9uz/h5iA1CZfvOH0DLHNyNf0EGjACHw0xzMLJ9tA1PNaKu8LXs24hh3vWnn9?=
 =?us-ascii?Q?I65u00+04d7EQtvZIgQsNOinGnz65818EXc8cFp/CiYC/6ytKE1CoUB68u9Y?=
 =?us-ascii?Q?Zo6zCJg165aS+5FfxDD1qgxx1VeyoQVot6BNpSZ7mM1m0yDIExf0aQfKF6Mb?=
 =?us-ascii?Q?cAfLlujjxx8576vgtgDj126JFrFoUhkkwbVXiJBNEUOAiXSK5iPtFSvnkiJh?=
 =?us-ascii?Q?SEXpzom5Y+1x1Y0EgxiXsRlLXoYL6QwVOMJQyuREGoQ4g+fbOpG/r/RJ/mXb?=
 =?us-ascii?Q?42/hxHY/c/XK9UjmgdAncJne3zBmYDfotQlT9uAflsSeVBiLLe9nraQ1S7Yt?=
 =?us-ascii?Q?pDm7bTawxO1q7UOVCWDxAJ8XB1gH9G6RlIHcmgkl4equjiL1KDGHcOD2o7YW?=
 =?us-ascii?Q?6cqcZ8yoXTH9CNQF0td8IwRmxS3JS+BoDiM/5dZ8KGmQze6im9lCS/RnLm5K?=
 =?us-ascii?Q?QmfqcbxE7D3NmqJA2i4A6fWnJ/sl2P09agHa7ZuF+xAILv60br4HVsl7wEY7?=
 =?us-ascii?Q?KmdV+Nqbqo+5s93CBkbjYn9scC4iWvdBK5BotV+wPa2SiTthvD1k9RP/ny3B?=
 =?us-ascii?Q?5K7iAOTsSoT6YvwaUH68vfR17mcMFvURMUs1y2oz+kGk5kYfta//aeS38fja?=
 =?us-ascii?Q?HOCAa8xIt4eEMTmQnb9ph2mSj7iwUKpNJ4gkimLZ?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 5a122a7d-9921-4edb-d6f6-08db64a52d3e
X-MS-Exchange-CrossTenant-AuthSource: SA1PR11MB6733.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Jun 2023 02:41:19.5796
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: F5hq9IIb4dnL8uOIRCB3jMmjpDIyilTw1AnXqOvWfA2UzGMKMBcvVURtm2bDyzRw84SvNR1pjKharEtqm3SORg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA0PR11MB4671
X-OriginatorOrg: intel.com

Dan Williams wrote:
> Replace an open-coded device_unregister() sequence with the helper.
> 

Reviewed-by: Ira Weiny <ira.weiny@intel.com>

> Signed-off-by: Dan Williams <dan.j.williams@intel.com>
> ---
