Received: from mgamail.intel.com (mgamail.intel.com [192.55.52.93])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 94D97328A6
	for <nvdimm@lists.linux.dev>; Thu, 18 Jan 2024 21:56:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.55.52.93
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705615019; cv=fail; b=EELk7DrH6byLPnWlT4Wovi3SfAtNHXrs3xshKBnToGoi2dYr98c2Xcu95EwI4f9RSle7t4JcEajqjBLM39LxePkzLuWKNn/jV8lfDwmoC8PxywPxUp3ULYOnBl8T5YuhJPnxPmHcDwDncXgUhm6GvpASq4CyvG3mT+RkfWrrkcU=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705615019; c=relaxed/simple;
	bh=BhxnlCTBsyiYU5l1OwjE2lhRdGLWzJ+j20kbXMTzEXw=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=KognDzN63wjAlbVx1TXcrUCx+ehrEPb/tQ2IV+1jw6S0SkN4Tw2h42XinNklVu5GbegGbZ30awDj6wrruQTLFSZC1SntSNNn6dY+Qjyp6xn7UZGRkZ9zi/G/Ud5b0ue4ban/WQkBmABVbybOmQ1c+xtKy1JUMN2nSgLneWSE75A=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=Hl0ECctm; arc=fail smtp.client-ip=192.55.52.93
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="Hl0ECctm"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1705615017; x=1737151017;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=BhxnlCTBsyiYU5l1OwjE2lhRdGLWzJ+j20kbXMTzEXw=;
  b=Hl0ECctmvOiq5M6bV3X5fuTUEQFYi8sQcZC9sfUMSaMUUzN/COOx5abv
   frq3dokq4z4JZXI0FUVt5r5yTdhUIEe14MT7x9V5+wS+d5VtvdOcrwn9Q
   1N5d+YLkmSNM001pNHHoyF8H/plbI5ISfx/5Qb8dSQzYy4gv9eRjTIIw0
   8Fl5GnIE92j44qCNbn66jvL+XPdq0D+TwKZyrxgUk+M04LqwC3eIuef5Q
   bmuzsrpXhrTqwg0zM+SZG7syzGEyIcr8/y72SzxLPVSM4JYkCFwIQYPvc
   JA/JvJ4t2KkldsOMD8c0hl3PL9ULwBGV/EIho2SVnDxYSwk+QySVWsXTp
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10956"; a="397751861"
X-IronPort-AV: E=Sophos;i="6.05,203,1701158400"; 
   d="scan'208";a="397751861"
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Jan 2024 13:56:56 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10956"; a="875201104"
X-IronPort-AV: E=Sophos;i="6.05,203,1701158400"; 
   d="scan'208";a="875201104"
Received: from orsmsx602.amr.corp.intel.com ([10.22.229.15])
  by FMSMGA003.fm.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 18 Jan 2024 13:56:56 -0800
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35; Thu, 18 Jan 2024 13:56:55 -0800
Received: from ORSEDG601.ED.cps.intel.com (10.7.248.6) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35 via Frontend Transport; Thu, 18 Jan 2024 13:56:55 -0800
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (104.47.59.168)
 by edgegateway.intel.com (134.134.137.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.35; Thu, 18 Jan 2024 13:56:55 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=cPSl3m7BgCAXvjNtgdVW+Io600abYaHo5B5KmgAbTl0pyHjtn8+0ySOIfUrs7ewM0ZwGO5M4yZZsK58xDN+ejrgRo/SspcP1KjNR+5ThvOh/y3+MMU2sBAgjrKGknwSjmaALJak1a3FnxUTNc/Yfrceq+g/ia2JhfGMMwDs/hL7oXTsfysU6Hwj+ZlqPWiSF1LNcSpkZ2McvDNke4MhMv4MMQiBLUVtY+WwLUTn3UUf/ZcQm4QaHZ28yIRLa8z2h3T+yaXPJckz6r7TTL0RTK0OHBf0KASto86whroRKELCUKwU0nG6IMi0AXKvcH3twQG/AKqZogdb02FWrlntN+g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=rbe8nbtIgqt6BnC00c51PSBJ7WwyH6dt+D5wGUcH5UI=;
 b=e6JLKuZKZ6sDp0x5VXKArHnMsU7N4y4hjCJtrqD2vx6insUE3jOw/LEezAN1INrrpLhPMrCtxytOfqB0DfkSpLll4m7pHprfubDOU3/wlumbv7ckRpWZYfyt3HB/QGICe/jkKzv1UVG/fyi4YaAk6MMxleKBfGEoAQ/p4inOmckmTGuXWQi8qzJpFV14lZGgxWW82o1QCMNh3fdt+1Me0T4B8onwOLi1thsQhEIWuD1nICalruGUrLOXcMGB/wyjUS+oQKk1rYvflQ87LKK1ThYB0m9WK1xZ7i1/QNOTNilZ9DB6AH95Xb9yiL5dEOxMZ8W+qgBuYaThYk5bmQPysA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from PH8PR11MB8107.namprd11.prod.outlook.com (2603:10b6:510:256::6)
 by DM4PR11MB7375.namprd11.prod.outlook.com (2603:10b6:8:101::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7202.24; Thu, 18 Jan
 2024 21:56:53 +0000
Received: from PH8PR11MB8107.namprd11.prod.outlook.com
 ([fe80::6257:f90:c7dd:f0b2]) by PH8PR11MB8107.namprd11.prod.outlook.com
 ([fe80::6257:f90:c7dd:f0b2%4]) with mapi id 15.20.7181.015; Thu, 18 Jan 2024
 21:56:53 +0000
Date: Thu, 18 Jan 2024 13:56:51 -0800
From: Dan Williams <dan.j.williams@intel.com>
To: <alison.schofield@intel.com>, Vishal Verma <vishal.l.verma@intel.com>
CC: Alison Schofield <alison.schofield@intel.com>, <nvdimm@lists.linux.dev>,
	<linux-cxl@vger.kernel.org>
Subject: Re: [ndctl PATCH v6 0/7] Support poison list retrieval
Message-ID: <65a99ea31393a_2d43c29454@dwillia2-mobl3.amr.corp.intel.com.notmuch>
References: <cover.1705534719.git.alison.schofield@intel.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <cover.1705534719.git.alison.schofield@intel.com>
X-ClientProxiedBy: MW4PR03CA0096.namprd03.prod.outlook.com
 (2603:10b6:303:b7::11) To PH8PR11MB8107.namprd11.prod.outlook.com
 (2603:10b6:510:256::6)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH8PR11MB8107:EE_|DM4PR11MB7375:EE_
X-MS-Office365-Filtering-Correlation-Id: dc259cc2-3375-4eae-3e12-08dc1870618d
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: LBVVYYJ+f8akl5BEoCK/Z69Ls8WoodD6UAGPjt93q6vo8trcbK0c+NA2eaSQ2K/2ogwFnLZ+sf+XYw0jOQzRPpLfrqXs5AiphjfiPWr5i4y1dYSknuuyOqBYnKaoiquynqMjkrwmbBsu7/SX8hztdin4wsATOUiftSr6kEyvMtd1cC1qGIVNeDADkfPUO5wUHMe/53FmrKlOpcYHYzcNavjFoXeCila/BAMd8wIaqVf+dDhJai5cRimoj/68QnwA3QwEI1AKllo1VIOAiDC/AkbtD7cOg5J2n1GTEe41gtSf339N8YWx5RoNv1Ddw+Mtey1pK4JwqDJuv5Iq/83zpiUbxxannbPAPlYhzIjhQ6MTeD86y4+snz3TzOdJi/yWIvqUHwgiaAuEddkk0/15wUM0UfBYpYCgpbgHcWLX/YRHmxrR3vn9+ZXtzwkHxgGyw+lPuQJol6LzXWm2I9mfEBc+OnQCBV08/qiCXowAWOBrIGFrb/MjHOmTK//GweBgK61Kc0OCIPxtzlgVrHZ+mmhZI/nwH9W31YGT5bfgN84=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH8PR11MB8107.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(366004)(39860400002)(396003)(346002)(376002)(136003)(230922051799003)(451199024)(186009)(1800799012)(64100799003)(8936002)(8676002)(6506007)(66899024)(4326008)(26005)(41300700001)(5660300002)(38100700002)(6862004)(2906002)(86362001)(83380400001)(82960400001)(9686003)(6512007)(316002)(66476007)(966005)(6486002)(66556008)(66946007)(478600001)(6636002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?SsQjiYJw54B5KMzd3QPHmFUsiLprpkRyo7s1fPxvnT5rNQl7B2hud7gtg2wf?=
 =?us-ascii?Q?Esm5Fh2tke/dL3rAo4BqXbWgEuV/nKS0XEqL4N1Pir4wMeBZYKAObojHLhv1?=
 =?us-ascii?Q?v2GaLEVcVet6rU2ofgJwszfgiN83UgtxUx3cjdlLOxbXBaWAOage/9mjQ4b1?=
 =?us-ascii?Q?fFgzkN++SSVxeTLC8wh3DtYsV7r7gLLR2xS1pNc2DU17Lm6deDITgxiOQDet?=
 =?us-ascii?Q?cBSeKFT+0rZaHproFDsuvQ4DnWJQgV6gCG7W5YM1dJ6PidGeiZAOoS00eIru?=
 =?us-ascii?Q?0C9ySV/ar3waO2mNgJI6kwEpnnD2ZNc9dYI9f6WtDbHP6n1h1F5dpo1PWoZa?=
 =?us-ascii?Q?cdCgLchfWala8iwUWgyHktrFPYJESgince/1wZHCvE2537V+WNE0WVtH5Ql3?=
 =?us-ascii?Q?GX3JmxVYrE3/M2AnC60Nn9V9VxiEdX+rz8vz/p1Jilno5mNsOkXnLQDP/jl2?=
 =?us-ascii?Q?VXvvfealmE97HVktb5Qm/2Y8WRBDgjKQqy3Cxxr5NzONtsiZLQt+X7b5wiHI?=
 =?us-ascii?Q?6t1n419ed7b2toIGV++wyYl3ZkCrkwQgYqdtS5drbtQsQft5yRp2pBBDYrr5?=
 =?us-ascii?Q?NzM8BoElXuPhCzX/5mcQrO7lfrXuJOL9hr1j/NyIOV7kZvTXJ1Jsh0cTPzuZ?=
 =?us-ascii?Q?m8Tw9Pji5/LZBjtNioj2bZiX3HXa1JarK3oDuHE1YIPAktNSA8ck09PDqVMb?=
 =?us-ascii?Q?GXbM8Dl2QWHQrIZTfa+wWpSveCrzfiAxfATSSfvZYxN2BJM9bR5MO21/jgkN?=
 =?us-ascii?Q?rZ7QaEKn/wklEVcHfLwyJ6AyZWCQ1urq1SgnI+HJxuM4vp2RDuuIu9fKqInq?=
 =?us-ascii?Q?pN/lEUfg2w9wFzbdxNxrzMthMcOG9HMRXH4sroTEhaaJeao7wBkP9XoFXJHM?=
 =?us-ascii?Q?k3hr8TGY4pIciW1LkNdHeKNkJC1ieVf9ETuZmb4okLXyyx1t6iFuLjLi0qAe?=
 =?us-ascii?Q?8Riodvzsd9gHm1MgaW931Lt2SDwuCKwtoxJNC9nRTy7zT+udTvvX0i8RVlUy?=
 =?us-ascii?Q?zkBLt+2D6owvzQGh//DBBhDpNsDC79u/aUJiJUqh94XzJzica8MpFvO9kMyg?=
 =?us-ascii?Q?t2zEer2qXT+K+Qsl4PhCo/AFL8WK7Q0kqXE0uDgaryFB9pWzGoAdT60rD6jL?=
 =?us-ascii?Q?Yuf1k4A2mp3/lToTK9OOZA7+wjD5BEnjGBejQ07Ertxh5hYWv8T+CpK7NdTb?=
 =?us-ascii?Q?oh97vqWZCdnwOHDiQ80f9JXO05pewxJeG46/XtjwUci0He7S7IwxnlY2B4aH?=
 =?us-ascii?Q?0JoyLT40dfhQViNPg+hhyrNx6VZYM7GG3fHSqz5VPh6TGussRdGySipP+fp0?=
 =?us-ascii?Q?3R0yBYFuCHna7+4a7sfvtbqjF3EOdmi6AjCEk8yKjq+EUFcOEuupCv9E9DRI?=
 =?us-ascii?Q?HXyE6hptlrIFgX9rWyMc5/bgK+qyw9+5oSagYtau5rUfRmaxAg+3vnOzluj5?=
 =?us-ascii?Q?l6KAfYLbz6EkwbefYzbDa4oVtlb77VNUcyCMFxSYwLfRGkI9+nvxc9aLsWHp?=
 =?us-ascii?Q?v63wnBe4eKmPK5ZeP7mm01sgQ5J/bmOVWyRB0KNTG1KXCWLaKOiTDYVF4+pA?=
 =?us-ascii?Q?DmEelQ7Egi3G+hYQrZRPrOppBcUko4mh+LLGLsC2Ybs+OO6VOCj5kW34OTxH?=
 =?us-ascii?Q?5Q=3D=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: dc259cc2-3375-4eae-3e12-08dc1870618d
X-MS-Exchange-CrossTenant-AuthSource: PH8PR11MB8107.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Jan 2024 21:56:53.3136
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 7sqVK+na0yL+wQ1nqcvSWSORzrlBcnMVTsPeXPh5WmuA3HJEYIyUza1a8lto+/bUep3QHH6i01BYHChfkjkuKp/nRYuTRXY75gDpFeE1wRk=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR11MB7375
X-OriginatorOrg: intel.com

alison.schofield@ wrote:
> From: Alison Schofield <alison.schofield@intel.com>
> 
> Changes since v5:
> - Use a private parser for cxl_poison events. (Dan)
>   Previously used the default parser and re-parsed per the cxl-list
>   needs. Replace that with a private parsing method for cxl_poison.
> - Add a private context to support private parsers. 
> - Add helpers to use with the cxl_poison parser.
> - cxl list json: drop nr_records field (Dan)
> - cxl list option: replace "poison" w "media-errors" (Dan)
> - cxl list json: replace "poison" w "media_errors" (Dan)
> - Link to v5: https://lore.kernel.org/linux-cxl/cover.1700615159.git.alison.schofield@intel.com/
> 
> 
> Begin cover letter:
> 
> Add the option to add a memory devices poison list to the cxl-list
> json output. Offer the option by memdev and by region. Sample usage:
> 
> # cxl list -m mem1 --media-errors
> [
>   {
>     "memdev":"mem1",
>     "pmem_size":1073741824,
>     "ram_size":1073741824,
>     "serial":1,
>     "numa_node":1,
>     "host":"cxl_mem.1",
>     "media_errors":[
>       {
>         "dpa":0,
>         "dpa_length":64,
>         "source":"Injected"
>       },
>       {
>         "region":"region5",

It feels odd to list the region here. I feel like what really matters is
to list the endpoint decoder and if someone wants to associate endpoint
decoder to region, or endpoint decoder to memdev there are other queries
for that.

Then this format does not change between the "region" listing and
"memdev" listing, they both just output the endpoint decoder and leave
the rest to follow-on queries.

For example I expect operations software has already recorded the
endpoint decoder to region mapping, so when this data comes in the
endpoint decoder is a key to make that association. Otherwise:

    cxl list -RT -e $endpoint_decoder

...can answer follow up questions about what is impacted by a given
media error record.

>         "dpa":1073741824,
>         "dpa_length":64,

The dpa_length is also the hpa_length, right? So maybe just call the
field "length".

>         "hpa":1035355557888,
>         "source":"Injected"
>       },
>       {
>         "region":"region5",
>         "dpa":1073745920,
>         "dpa_length":64,
>         "hpa":1035355566080,
>         "source":"Injected"

This "source" field feels like debug data. In production nobody is going
to be doing poison injection, and if the administrator injected it then
its implied they know that status. Otherwise a media-error is a
media-error regardless of the source.

>       }
>     ]
>   }
> ]
> 
> # cxl list -r region5 --media-errors
> [
>   {
>     "region":"region5",
>     "resource":1035355553792,
>     "size":2147483648,
>     "type":"pmem",
>     "interleave_ways":2,
>     "interleave_granularity":4096,
>     "decode_state":"commit",
>     "media_errors":[
>       {
>         "memdev":"mem1",
>         "dpa":1073741824,
>         "dpa_length":64,
>         "hpa":1035355557888,
>         "source":"Injected"
>       },
>       {
>         "memdev":"mem1",
>         "dpa":1073745920,
>         "dpa_length":64,
>         "hpa":1035355566080,
>         "source":"Injected"
>       }
>     ]
>   }
> ]
> 
> Alison Schofield (7):
>   libcxl: add interfaces for GET_POISON_LIST mailbox commands
>   cxl: add an optional pid check to event parsing
>   cxl/event_trace: add a private context for private parsers
>   cxl/event_trace: add helpers get_field_[string|data]()
>   cxl/list: collect and parse media_error records
>   cxl/list: add --media-errors option to cxl list
>   cxl/test: add cxl-poison.sh unit test
> 
>  Documentation/cxl/cxl-list.txt |  71 +++++++++++
>  cxl/event_trace.c              |  53 +++++++-
>  cxl/event_trace.h              |   9 +-
>  cxl/filter.h                   |   3 +
>  cxl/json.c                     | 218 +++++++++++++++++++++++++++++++++
>  cxl/lib/libcxl.c               |  47 +++++++
>  cxl/lib/libcxl.sym             |   6 +
>  cxl/libcxl.h                   |   2 +
>  cxl/list.c                     |   2 +
>  test/cxl-poison.sh             | 133 ++++++++++++++++++++
>  test/meson.build               |   2 +
>  11 files changed, 543 insertions(+), 3 deletions(-)
>  create mode 100644 test/cxl-poison.sh
> 
> 
> base-commit: a871e6153b11fe63780b37cdcb1eb347b296095c
> -- 
> 2.37.3
> 
> 


