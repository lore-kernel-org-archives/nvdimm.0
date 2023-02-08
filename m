Received: from mga09.intel.com (mga09.intel.com [134.134.136.24])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EF96F7F
	for <nvdimm@lists.linux.dev>; Wed,  8 Feb 2023 03:46:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1675827975; x=1707363975;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=wLrDQTv0rj/LbUh+uXx8J5TaCBDZYxiZOQ6KHPGF8fM=;
  b=Lfb2Kta26Uxnkx9SYn0MjrzObIJCjFU3UXjh7y9FAUvzUPqrUWw7fNQk
   0gFz1y+mzjhRtYF8Tt97X1Khuk5c6qNNHyVM0MOqLYPvmWJiptUfr81rA
   dY4pYTNAA/M5FfE9H5DqG+rsN4lzloKjfwLfdfRYQbk+G5s+eLmVhzouH
   u1EvAnKehB3lylrv98D+y6d75qBv2pf5E9to6LrzGT+PmDVzNxuCX9swL
   uIV80Y99rB51XyJEeLoCXpIrO798DrqftKGXKnKjrcSajPOv6GON4xG/l
   cmfOgel2YB6gHhSeJsyehVr8KTm8UWmDGkxUMc8fyGJmIuVV0TT9Ykl+C
   Q==;
X-IronPort-AV: E=McAfee;i="6500,9779,10614"; a="330994272"
X-IronPort-AV: E=Sophos;i="5.97,279,1669104000"; 
   d="scan'208";a="330994272"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Feb 2023 19:46:02 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10614"; a="697515421"
X-IronPort-AV: E=Sophos;i="5.97,279,1669104000"; 
   d="scan'208";a="697515421"
Received: from fmsmsx601.amr.corp.intel.com ([10.18.126.81])
  by orsmga008.jf.intel.com with ESMTP; 07 Feb 2023 19:46:02 -0800
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Tue, 7 Feb 2023 19:46:02 -0800
Received: from fmsedg601.ED.cps.intel.com (10.1.192.135) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16 via Frontend Transport; Tue, 7 Feb 2023 19:46:02 -0800
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (104.47.56.172)
 by edgegateway.intel.com (192.55.55.70) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.16; Tue, 7 Feb 2023 19:46:01 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=CJuT3bd3NhNJO+tCHH7xVmwg5G69plBVXz6ZAH3++VCN4en3Dit09k0+0V1E5MiajWc3/iqESGEyNApxOvAjDDKeJ0fLz8FzjaiimCEYoIt2W0eef7xJAZ3H/uFNBHvEsyR6aRWv3yQtyDytMrCimmFM79M8F+zdz/aWLmt8qYpu5EYtAvL4BQ1bQ8SG4gZB/186NU1gTcZtMFg1N6ImKITysGNT0id0JDKBVLa/OkR4TdEyDRMR4pVtGm88YU47Uo6OBN17Tv+7vsSOPPlVa47rAdvsuj4k8FxbaGjLKT07LUQ+Nv+G6KRwWpYpRaPC4tPOWewM//1S9Aa5DIPzYw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=0A0ogfQmnhzQyb85cD5IrjDoK+/GatrNBxYI/lHiGlk=;
 b=Tmf192bzV5LYZpG40BYkJKJFFA6qPTMOsu8J8hCiNFTFli1h/dBEeFN90oA0zpMSI5eOsHefkgle24m0scTtSBHbG+6flz/bJovSKpxK4pRt2PGc+0S9Z+sIDE8ia9zVlZmdR3gEvZuN9O3U+NmgOK/49drcjIBiCV9AGLuffX86RQGgQr1Kp6l5WLyv7Mg10vqQnMCtbgRuKyCcjko+FzbvB1XnYz667cr0X14qFzLFJx1t3jONmk53imS82e+Io/3IKhwYbFBw0L8oaxn9yzK9BwGdf89XGFFWM7rXfUc6NlgYmI2dEFBrPGil2D+1r1+NyfONdmZvI8J0tsO8Ww==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from SA1PR11MB6733.namprd11.prod.outlook.com (2603:10b6:806:25c::17)
 by BL3PR11MB6458.namprd11.prod.outlook.com (2603:10b6:208:3bd::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6064.34; Wed, 8 Feb
 2023 03:45:55 +0000
Received: from SA1PR11MB6733.namprd11.prod.outlook.com
 ([fe80::6851:3db2:1166:dda6]) by SA1PR11MB6733.namprd11.prod.outlook.com
 ([fe80::6851:3db2:1166:dda6%9]) with mapi id 15.20.6064.034; Wed, 8 Feb 2023
 03:45:55 +0000
Date: Tue, 7 Feb 2023 19:45:49 -0800
From: Ira Weiny <ira.weiny@intel.com>
To: Vishal Verma <vishal.l.verma@intel.com>, <linux-cxl@vger.kernel.org>
CC: Gregory Price <gregory.price@memverge.com>, Jonathan Cameron
	<Jonathan.Cameron@huawei.com>, Davidlohr Bueso <dave@stgolabs.net>, "Dan
 Williams" <dan.j.williams@intel.com>, Vishal Verma
	<vishal.l.verma@intel.com>, <nvdimm@lists.linux.dev>
Subject: Re: [PATCH ndctl 1/7] cxl/region: skip region_actions for region
 creation
Message-ID: <63e31aede1e8c_107e3f29426@iweiny-mobl.notmuch>
References: <20230120-vv-volatile-regions-v1-0-b42b21ee8d0b@intel.com>
 <20230120-vv-volatile-regions-v1-1-b42b21ee8d0b@intel.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20230120-vv-volatile-regions-v1-1-b42b21ee8d0b@intel.com>
X-ClientProxiedBy: SJ0PR03CA0179.namprd03.prod.outlook.com
 (2603:10b6:a03:338::34) To SA1PR11MB6733.namprd11.prod.outlook.com
 (2603:10b6:806:25c::17)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SA1PR11MB6733:EE_|BL3PR11MB6458:EE_
X-MS-Office365-Filtering-Correlation-Id: 2afb46de-7869-4dcf-c8cc-08db0986fb2d
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: wTdu+5zR8qJFjzuIBS3m20rGZcxUYBQyj9ii6oBK8fVikMKYy3yhidjzKclr6dOBEuPPJjegUF2g3FtAiYqsdKwzbvA5zEQTl36jbBG387fJxdazUTWkFWP48RIPYkLh5Ra2OSzb/oNBRcfoa7LQ8F4uqUIia+Uy8mCKsd5p6LDgwUbe5ucUu5kPSNejzWBM0bAA4TMGJ0+FhmLk9qJ4YKUmGfbeRvkcYOFqsLrj/DWYgd5ZrOiotBxNQwPvei1JDUH6LnV60LgQtGkzZ1oekbDvhp7fgVpzRu2g7toBxCiPNmcHTLZKhHCE/FB5qygBloLnMKY5TBr0YcE3IpL/ncNOGLWNUkg/47sg4ED4aDLPx+N1LQjmjGQrYQ1h5EY1xXhmPXqdmyt+jIwhfhvXfHcSFMZBQP7FYb5oPA8aWpV6IRujOE8iYdPKwzmxQuVwdFRUIpt5EzgmNSxwmChtUKykE9YFX7vubUcI9uxwxqyVxdWhkYrSj5Xt7H8SkMRE+qrW1YGztGcYdX8eDzw+CDcuSCDa+JC5zyLXC9UwdmHbrxdbECXxLEk7WjZ11iir7Fe20u9ijEYwx4j3k4xtXw4PDUQvGfwHVWUuuTBZL1GZXTRmItWLtDX0cYFYLoM/Fki6wFtQXB3/Ecy1ooIkBA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR11MB6733.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(396003)(39860400002)(136003)(366004)(376002)(346002)(451199018)(8936002)(54906003)(66556008)(4326008)(66946007)(66476007)(316002)(5660300002)(8676002)(44832011)(2906002)(41300700001)(6486002)(478600001)(9686003)(6666004)(6512007)(6506007)(186003)(26005)(83380400001)(82960400001)(38100700002)(86362001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?KPunK/d+XSYXNTmTKpKwnb38cQZugx6ZqlTnHUGXPiwQD95UrcFPnm2XYKCp?=
 =?us-ascii?Q?9qkU15j6RY2QmHkwvscucK7oLmpkpe0/AClZxJVkDURV15FrdoX1/grAIRfk?=
 =?us-ascii?Q?ho70aq/1HTm0XQZ9APs4JSsy0r8MpOvvuaAsCm+8ly/6POKmOMWuxpLmqf+p?=
 =?us-ascii?Q?crE0HlWiwkT/jW+vy17wgHoZe1k63M0iUDxIvG0e7Y0674G5L1RUprH3i44d?=
 =?us-ascii?Q?0cd9LDQN5dgG6I4Ycm1uok7DtVqcvrARlxmn6UucX9m/jBHG12w0lrTEbc7D?=
 =?us-ascii?Q?LGd5Uuh2GDJ5kWI07E1qmS+eqvXZ95OWSiMVgPMuaf7N9OVUMezy1P0ewkQC?=
 =?us-ascii?Q?sTwEeCdH7KhNdcOIb9Jq6AfgBhrcltDgh6oTxYvKUsrN1iEtauYilkRQ89BG?=
 =?us-ascii?Q?wtSSFAQi0IogEauV1Hgbw4LkRDh7dbQ52pXwQjppKd9xZwGJjybQrLog0Tqz?=
 =?us-ascii?Q?dUXe6ZbtVj+krrXnC+X5hpNiYbtaJV2JQEeD7W5vZYzgPYD3YpD7M8CsLVGl?=
 =?us-ascii?Q?g2Ux5YdpzUpWtTyG0QQ1/u2XaYvu4VFTPfkVPx+n3NMSAM8im47CBR2gkYY/?=
 =?us-ascii?Q?PSrIfTgNFXClsUjRCJfAB6dFyCbrOYuSX+8Mb6sAYQoGVMmPIa5aUD+yws2U?=
 =?us-ascii?Q?oGFlfPT18rzVN3oa7RbP+kWrhMt49KoOycNiiWVNUoKVIoBJW5NBzFvrSFmq?=
 =?us-ascii?Q?s/+T8EpyGjDDz/GBUhImUk4iDrqg2u4aA9DV8Z+IzDxMeiKhpU8MK00QwJ4y?=
 =?us-ascii?Q?CNOa/vmVON8v75yukVdFeW2TC6FyIC6FLIQGC2CSEkUvKkSS8JkkbgvtgozM?=
 =?us-ascii?Q?B78csEE8W9/tAdXgvMGdM9DDlrApyXh4ptox1Kd7nUff9FcyvPhDOQp7Gh0+?=
 =?us-ascii?Q?mtjvdZyMe7veU5Uq35kMYpkuwcaWo2wRukF3oGwpIQkPtfpqccdRA9Vhx2sc?=
 =?us-ascii?Q?kuVrJ9XSN8xWTfZdCU6ahz0p4jOnnHxhEdWy0vKBqLtBrom/HfVEXxw2S3EY?=
 =?us-ascii?Q?kPP3KBoxySwuLuSTsjOba2//lzDPBoDPFV2ePv2avlNwUr3CnZF9XbWx+y3D?=
 =?us-ascii?Q?9vZnWRRtKjjnWwVSfMaxkt7X+ymmND4V1x3YIz0MxZC1nOgNT7RMGHXjxEdK?=
 =?us-ascii?Q?xD+QuyXfp2B3ynclGZhJ7/dajJjfsp+k8vETQ+bo1ZpDVnIysitcLFrd6KnI?=
 =?us-ascii?Q?1PoU1xVsl7DtG5PrMXMIfiJ4fWm2a879rL9382PRweDtbLd2R/Tg4Qg48rrp?=
 =?us-ascii?Q?N1o0vfI7LocGSsg6O4Ti1/t6PCejQLLR0GLYxU+LeNGSXKwfBcBnd4hj3LY7?=
 =?us-ascii?Q?QW/0GTWZNI+tD2EX9/B7pcf9AMSOvcbbPVbaFpn38PBHMMWARPik0zbQwdHc?=
 =?us-ascii?Q?3KQ0eO/6BNdTkin1+wDNuUm6SPXAwLc2paxJFh0xnIwNIHR29fWelgKxj6iW?=
 =?us-ascii?Q?q49gEmiigMZ0+0v7pxl7HFAQGms1rYll0O4vFciI05nzEEyjUb+GYh4nL473?=
 =?us-ascii?Q?zP2ZLyD+BwExfVaL0Fr3izXN943p9SeBFJWn3tCAlh1clAjdTIApDZ42om8T?=
 =?us-ascii?Q?o5xu2QC2I6agjWitsa/TIzD9aEU+tlRZYhJQwraU?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 2afb46de-7869-4dcf-c8cc-08db0986fb2d
X-MS-Exchange-CrossTenant-AuthSource: SA1PR11MB6733.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Feb 2023 03:45:54.9906
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: seVEB8dBadNtQ/RgKtKDrhGAN56ezPDUPMGs7aVsC8qWgPKn4NZV8/ciQISm2GZ4jkcFjoDgMhtBKivpCAMi8w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL3PR11MB6458
X-OriginatorOrg: intel.com

Vishal Verma wrote:
> Commit 3d6cd829ec08 ("cxl/region: Use cxl_filter_walk() to gather create-region targets")
> removed the early return for create-region, and this caused a
> create-region operation to unnecessarily loop through buses and root
> decoders only to EINVAL out because ACTION_CREATE is handled outside of
> the other actions. This results in confising messages such as:
> 
>   # cxl create-region -t ram -d 0.0 -m 0,4
>   {
>     "region":"region7",
>     "resource":"0xf030000000",
>     "size":"512.00 MiB (536.87 MB)",
>     ...
>   }
>   cxl region: decoder_region_action: region0: failed: Invalid argument
>   cxl region: region_action: one or more failures, last failure: Invalid argument
>   cxl region: cmd_create_region: created 1 region
> 
> Since there's no need to walk through the topology after creating a
> region, and especially not to perform an invalid 'action', switch
> back to retuening early for create-region.
> 
> Fixes: 3d6cd829ec08 ("cxl/region: Use cxl_filter_walk() to gather create-region targets")
> Cc: Dan Williams <dan.j.williams@intel.com>

Reviewed-by: Ira Weiny <ira.weiny@intel.com>

> Signed-off-by: Vishal Verma <vishal.l.verma@intel.com>
> ---
>  cxl/region.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/cxl/region.c b/cxl/region.c
> index efe05aa..38aa142 100644
> --- a/cxl/region.c
> +++ b/cxl/region.c
> @@ -789,7 +789,7 @@ static int region_action(int argc, const char **argv, struct cxl_ctx *ctx,
>  		return rc;
>  
>  	if (action == ACTION_CREATE)
> -		rc = create_region(ctx, count, p);
> +		return create_region(ctx, count, p);
>  
>  	cxl_bus_foreach(ctx, bus) {
>  		struct cxl_decoder *decoder;
> 
> -- 
> 2.39.1
> 
> 


