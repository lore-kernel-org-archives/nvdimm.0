Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.9])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BCFB41848
	for <nvdimm@lists.linux.dev>; Thu,  7 Dec 2023 04:23:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="L00Ennau"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1701923009; x=1733459009;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=axYVnF5gwzQ/CUUq+H4iZqgJJqAWxnba+TGqNW2/f5c=;
  b=L00Ennauf47kzgsJ8/RpbCvE9qYOR/CipQbjAZQ2DTAGa81v2gB4N4r1
   cQdx/MypzTxbtFyck0COe85kckQ+5lFqz4AOABp07g1sEkkovq6FE7ouv
   JSwwHS97uvCSOkzMhjVf5/OK6WxZarNa82POREPNopvP0Tl3I8XIGtwHW
   cBm+6XWAd63Cn+NgGiosF76VeHSvhrarvQAhTW9ghuVjz5WzHsOumFkUf
   iwzTBjF41K0QYbt2mjz7SdVKl1c0N/xxrhrA7TuyBUmOLiVHjaepquqzK
   ElCmwqezA3fxhdsNP727VE6XEfxxnzh2NJjm0yotmWUtzhil+QXQFH9gK
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10916"; a="12882616"
X-IronPort-AV: E=Sophos;i="6.04,256,1695711600"; 
   d="scan'208";a="12882616"
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by orvoesa101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Dec 2023 20:23:28 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10916"; a="764969724"
X-IronPort-AV: E=Sophos;i="6.04,256,1695711600"; 
   d="scan'208";a="764969724"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by orsmga007.jf.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 06 Dec 2023 20:23:27 -0800
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35; Wed, 6 Dec 2023 20:23:27 -0800
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35; Wed, 6 Dec 2023 20:23:26 -0800
Received: from ORSEDG601.ED.cps.intel.com (10.7.248.6) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35 via Frontend Transport; Wed, 6 Dec 2023 20:23:26 -0800
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (104.47.66.40) by
 edgegateway.intel.com (134.134.137.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.35; Wed, 6 Dec 2023 20:23:25 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=PCrW1goBkq91HsA0qu0ReAB8A2lzoWpuSpMo9vLhI3QKVE0xqIfA/+S3W3iQBOBBRjN4kMPsato4Oxp6We1SChP4xV0SI1vA5/GXDhJmO288+PRj6MLHr/GsVkvFvt7sA216W0k814NlBPzbcFygBDqk7Sidm8vhJxOJ6ySP4YHRQq/0pxUkKlIw45Ggejh2N9U/7mMWoEjqD2c9WnEfM/B6EQtJTn8D/8OY9LZIdgU7hNAiVP2xc4DZtYny4zYHNpQEsVzAya56uMt/PsNVfU4jMyUdWaVYCzdo9LBcgqQbUC5OuFnSj9nwN6nMKQo4PcW5QR8FxP3K7VRNaFhJcg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=m4EmVe3AquBTsa49DqHBOJy4ijoRPD7509/l5HS8LLM=;
 b=Kx9Y/eMUBkEBYeyI2UONWUQzR7suay7+08+RUPBqAswJ6T3Q21kWI3bhdmiS+xISjaeC+aukuCeGR9IlAIseOybYISlPOCKhYYpvYYYEQZl5gDx8ciQW5h7/HxF6BirBI/eQN+Z0tBFX0WJwHVgxF9KRld7hOJEaaWGGJNMPxz4Ee2piWAs32A3vtyF7cmIAhqUlkbM1j7LYPa6z9vaALHKsIBD9FjdHfwk1NXS27y7WxqvR8Jc+fPXrqRuXOWqgpVNFTcjHnNTspQwwRvsB6aHR+IHDQSzLkxCjwSugwLQ/THEo3RDWUJxSFzyAODl/JKiFhJxzhFdOSv3mVPdBsA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from PH8PR11MB8107.namprd11.prod.outlook.com (2603:10b6:510:256::6)
 by SN7PR11MB8112.namprd11.prod.outlook.com (2603:10b6:806:2ea::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7068.25; Thu, 7 Dec
 2023 04:23:23 +0000
Received: from PH8PR11MB8107.namprd11.prod.outlook.com
 ([fe80::6362:763e:f84b:4169]) by PH8PR11MB8107.namprd11.prod.outlook.com
 ([fe80::6362:763e:f84b:4169%5]) with mapi id 15.20.7068.025; Thu, 7 Dec 2023
 04:23:23 +0000
Date: Wed, 6 Dec 2023 20:23:10 -0800
From: Dan Williams <dan.j.williams@intel.com>
To: <alison.schofield@intel.com>, Vishal Verma <vishal.l.verma@intel.com>
CC: Alison Schofield <alison.schofield@intel.com>, <nvdimm@lists.linux.dev>,
	<linux-cxl@vger.kernel.org>
Subject: Re: [ndctl PATCH v5 4/5] cxl/list: add --poison option to cxl list
Message-ID: <657148ae35bce_b9912945d@dwillia2-mobl3.amr.corp.intel.com.notmuch>
References: <cover.1700615159.git.alison.schofield@intel.com>
 <216ab396ab0c34fc391d1c3d3797a0d832a8d563.1700615159.git.alison.schofield@intel.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <216ab396ab0c34fc391d1c3d3797a0d832a8d563.1700615159.git.alison.schofield@intel.com>
X-ClientProxiedBy: MW4PR03CA0157.namprd03.prod.outlook.com
 (2603:10b6:303:8d::12) To PH8PR11MB8107.namprd11.prod.outlook.com
 (2603:10b6:510:256::6)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH8PR11MB8107:EE_|SN7PR11MB8112:EE_
X-MS-Office365-Filtering-Correlation-Id: 3186a35c-b47a-4bc2-2635-08dbf6dc3fe5
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: FvlV++KlwMdP9jNAhfASN5LyjatIiLiVyWwh7lFnsQ/+nPYJeoY/yN5gE9kROSggSX24xOvaxgUbqgQlO9rKW3hY+ms40k3Sc8EJYBSKROwR6kkKzRw0LFICKnXl3xS4xiLS93rfGCMEHE6Q7mEIaa0EcpRPvUuo8iR1sfEWwKosgR+rx+zTI7Az/jeFcehF1n26YAi6g/XXORhQsUUC3y1F705L/zdTOQNyBgLLG9n4TwwvB/HDnLEibqxsJCuitCf+FwxgYKUR5KBLuSpqGzHNUICmzBjrrfv62Or+biLHCXtzWZA+/EIJboTUCELj7ggfutNSwfkzFRhSik61vD6WtIy3XgPLfnsqJvigUHPNGda/JPTE2Jc61ZbyEwsxpkcimPrYegTAGT/HozrcVlnRtk7EGt87uFWhYsa+iFWwMD6MY2mG98ytBHjXMUrBWhusrAZ7mxwH/KtujaHO5Id3GckYW7N0HyU6CKWvtegOSSyCIy+tVJLk2nKVDawO+uo7rvqip4M4ZbnBCOtGxKzMFEqn0ErkA4UrP3FUYMZuK8TYMTFiSHdvhQH6k/Kr
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH8PR11MB8107.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(39860400002)(366004)(346002)(376002)(396003)(136003)(230922051799003)(186009)(64100799003)(451199024)(1800799012)(38100700002)(66946007)(83380400001)(82960400001)(26005)(9686003)(6512007)(6666004)(6506007)(478600001)(66476007)(4326008)(86362001)(66556008)(316002)(6486002)(8676002)(6862004)(6636002)(8936002)(5660300002)(2906002)(41300700001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?dtG1TPh8fBb4wrKjHX+S0qakjICKMCuZKZJijFc3YPnf0C39D8d4F2zObiuo?=
 =?us-ascii?Q?hFc8bfXK5T9FZCFtgQuZfa2e0qkfmDjlPoxAFijCA5u9zZq8A1B/hfXr/q9Q?=
 =?us-ascii?Q?L/YjbKPgfekge54zuEkKugGahrr/CdCs593z6cBkw6jt+I+skwrbOCe9WeOC?=
 =?us-ascii?Q?R+EdyU4kQw/5gVqNf5sc5S+lym+khhZuHyhAwKNWyvOVA77aLgUECimNXOBl?=
 =?us-ascii?Q?wrQRF60YMLkWsyAbY/kpEJwndmfIEg6iE74RCKSxUxXVsoygB+0n0AcKUddC?=
 =?us-ascii?Q?lClxILnVfeWQiCtDFkD2nLbXe5eG+D2pJ6Aw3NPopkWlLzUGU/+hpaiswPk7?=
 =?us-ascii?Q?vM1Vma02pRMf6A3XOXhiZH+HurPhHe6xxcElkKNptvJd+nB2vC+QInN2qCJD?=
 =?us-ascii?Q?41RzS4bEE0f6jdMEFkz7QVipax/MA1JKWCSxbzX3z5LXkf3i2EwpkoIABxG0?=
 =?us-ascii?Q?uPI8ArTe66shgasc/XUiqkIF6hAWoDit54lvT71vN8raDy8oMoyyCsUo+9St?=
 =?us-ascii?Q?KTlEPycr+P550/79tyGk51ZCk6rk3tv4hI5q6YznAPfDexnHclGZT1OwLjfz?=
 =?us-ascii?Q?2sIPBsvy+18238qWvedC2g6BXr8b4asagCvaehSiMXmVMj2V8++b5dK4AWyS?=
 =?us-ascii?Q?/7B5syQXKuVV4P+Sil/xKrwbCTWLPeMCQCKpR21Q1XigzEcOwYWJLD+pdJ9u?=
 =?us-ascii?Q?PPUyKLRbZqf/fdekliK7V37jgJyeSObVyXRzL8icCNG2zj1//J3oh5O4WT47?=
 =?us-ascii?Q?iJhcRTgPduNNaE/OlZX4IHTqr1YzfhhyzC4AcxrJT656PGUucC1baFViI1t1?=
 =?us-ascii?Q?QIC7QB2jV6bdqJH/J5WdPPHhUdMI1r4e/hrUxeIwoAIgxfy56P68AColV1LC?=
 =?us-ascii?Q?DtG7tw3l1oSy6Od4JYuRXVuZJihcwEMDcpSFL+BL91buPxSQxoYSvnNZ5vxm?=
 =?us-ascii?Q?HMD/CDrKa3Kz1Y29HyHAio0w0FYNljz8NoZ9XZtUCPly/aXNSRMAcPucutQG?=
 =?us-ascii?Q?XO2MkaqxsWg3Om+bmLgpBe5riuluZp/+3wjjviHL16O6cHi/teVTat3p0jF9?=
 =?us-ascii?Q?8sx0i3xHZplUbBfe6Z64+lpOXwriB5+hRzr+DvzX4gWKabWNQcingB3pMms2?=
 =?us-ascii?Q?6ZNaKicL0rdB+dkCVtY/T6cfg+e7G8TwFVdf9hIPO6g7zGqRUxEGHPSFLVhA?=
 =?us-ascii?Q?qaNp6gFn9aVa+jwlOZ2kpq0E0b63DvrSTOWIIGUUMpvrbEXaKikYPXdEwjG3?=
 =?us-ascii?Q?nZYb/tYTKYxz3qqDi/SEEmvrR9AbIWDaLtAdbIeDRE19vD3MEauMEohKZKTn?=
 =?us-ascii?Q?xqIzD9R6wCAcpRoJCUwY8WBT6ieIZVRMUHTJ03kjKLtxLv97nHJ/UQBjJ/EY?=
 =?us-ascii?Q?tGRrV8ZhDlLd79gLlJSoFzeEtB8nGN3a4lMCt2CCoo/rbEIefVDIlblmgzUW?=
 =?us-ascii?Q?UNRMxlgo/vlZBWkf2t4ZQ0YZxqdBDsgSaE/iBVlEo6s+gv31AIF3vyq6axhV?=
 =?us-ascii?Q?vSFsT8WrO+WfhXJini9BvmJBywByvfYX6Bb0MLF6U6xI7XEqOgRXxIwr7yDs?=
 =?us-ascii?Q?DC6ANDnaRoJ5FJQX5rtMhizwE0B8SplUWxXJWCtvHSOqdIpmT8WxLTSDBMNL?=
 =?us-ascii?Q?Uw=3D=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 3186a35c-b47a-4bc2-2635-08dbf6dc3fe5
X-MS-Exchange-CrossTenant-AuthSource: PH8PR11MB8107.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Dec 2023 04:23:23.7596
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: srRXWoVLOxnGnVboHN80Do0PHsD5sGtsh1Ps3rl/AFbb4sksWhMC3SeWCjXKLSM/ajQwSINM3mi185FsEvbjC9BDMRxbuIxeE19F0VFO8kM=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR11MB8112
X-OriginatorOrg: intel.com

alison.schofield@ wrote:
> From: Alison Schofield <alison.schofield@intel.com>
> 
> The --poison option to 'cxl list' retrieves poison lists from
> memory devices supporting the capability and displays the
> returned poison records in the cxl list json. This option can
> apply to memdevs or regions.
> 
> Example usage in the Documentation/cxl/cxl-list.txt update.
> 
> Signed-off-by: Alison Schofield <alison.schofield@intel.com>
> ---
>  Documentation/cxl/cxl-list.txt | 58 ++++++++++++++++++++++++++++++++++
>  cxl/filter.h                   |  3 ++
>  cxl/list.c                     |  2 ++
>  3 files changed, 63 insertions(+)
> 
> diff --git a/Documentation/cxl/cxl-list.txt b/Documentation/cxl/cxl-list.txt
> index 838de4086678..ee2f1b2d9fae 100644
> --- a/Documentation/cxl/cxl-list.txt
> +++ b/Documentation/cxl/cxl-list.txt
> @@ -415,6 +415,64 @@ OPTIONS
>  --region::
>  	Specify CXL region device name(s), or device id(s), to filter the listing.
>  
> +-L::
> +--poison::
> +	Include poison information. The poison list is retrieved from the
> +	device(s) and poison records are added to the listing. Apply this
> +	option to memdevs and regions where devices support the poison
> +	list capability.

While CXL calls it "poison" I am not convinced that's the term that end
users can universally use for this. This is why "ndctl list" uses -M,
but yeah, -M and -P are already taken. Even -E is taken for "errors".

> +
> +----
> +# cxl list -m mem11 --poison
> +[
> +  {
> +    "memdev":"mem11",
> +    "pmem_size":268435456,
> +    "ram_size":0,
> +    "serial":0,
> +    "host":"0000:37:00.0",
> +    "poison":{
> +      "nr_records":1,
> +      "records":[

One cleanup I want to see before this goes live... drop nr_records and
just make "poison" an array object directly. The number of records is
trivially determined by the jq "len" operator.

Also, per above rename "poison" to "media_errors". I believe "poison" is
an x86'ism where "media_error" is a more generic term.

> +        {
> +          "dpa":0,
> +          "dpa_length":64,
> +          "source":"Internal",
> +        }
> +      ]
> +    }
> +  }
> +]
> +# cxl list -r region5 --poison
> +[
> +  {
> +    "region":"region5",
> +    "resource":1035623989248,
> +    "size":2147483648,
> +    "interleave_ways":2,
> +    "interleave_granularity":4096,
> +    "decode_state":"commit",
> +    "poison":{
> +      "nr_records":2,
> +      "records":[
> +        {
> +          "memdev":"mem2",
> +          "dpa":0,
> +          "dpa_length":64,

Does length need to be prefixed with "dpa_"?

> +          "source":"Internal",

I am not sure what the end user can do with "source"? I have tended to
not emit things if I can't think of a use case for the field to be
there.
