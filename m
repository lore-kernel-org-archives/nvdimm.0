Received: from mga04.intel.com (mga04.intel.com [192.55.52.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D7F2162F
	for <nvdimm@lists.linux.dev>; Wed,  8 Feb 2023 05:48:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1675835292; x=1707371292;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=XZci4UYHc+02tltspVTimY3ho5143YtdTquLMXB4Vck=;
  b=EkhUbcbFMMx318cs3u7SjrIGOnF0998P09lEPpcv+5NKSmmYNxZ+Hybs
   lFIeV63bNtC8d41RyqOjnNz+G74iRiKANKvjEdZCqTKItjBVY7FsaKWz5
   XKEoT8fwG2BShCHLuEWeQitL53ZaEWY55b8D8T0t7IEFJ9QzV13c4X/Fj
   /cYf/atzQKlB9GCgTuxqYz5owcuXw1kLDLs5X/IrZ2094iP+CcLH0F7n4
   GxXSuO1KV8+u/SwDLwWLB1qkEtX7E8V9iNy8gGiLSBiVwxzGp3EMq2pVd
   XuC4/kjUtKDIG0fRb7pSgJ8qDCXHp1RMOO+xLGeeezA5XsqrOaM4BXThj
   w==;
X-IronPort-AV: E=McAfee;i="6500,9779,10614"; a="328372130"
X-IronPort-AV: E=Sophos;i="5.97,280,1669104000"; 
   d="scan'208";a="328372130"
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Feb 2023 21:48:10 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10614"; a="996008919"
X-IronPort-AV: E=Sophos;i="5.97,280,1669104000"; 
   d="scan'208";a="996008919"
Received: from orsmsx602.amr.corp.intel.com ([10.22.229.15])
  by fmsmga005.fm.intel.com with ESMTP; 07 Feb 2023 21:48:01 -0800
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Tue, 7 Feb 2023 21:48:01 -0800
Received: from ORSEDG602.ED.cps.intel.com (10.7.248.7) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16 via Frontend Transport; Tue, 7 Feb 2023 21:48:01 -0800
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (104.47.55.105)
 by edgegateway.intel.com (134.134.137.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.16; Tue, 7 Feb 2023 21:48:01 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=h3tXMgTXZ87BEcGnk2pG94D+st0dWkEGY/n1ERD2ro2496iOaYgdI2Vu6Vq0fLZcOIYg7aSneWVjPfBss+W6YDtPEWdL970GiHXxytM2XM+InM9rmSAx3p5TZ/8b0IyHZTIeUyKO78nnLyEx3jHjypCsZ3t4zEV20wQOSKblAmp07JSnR4nGq2KAzmPWg6ZZfrJkODw6mk5zoMaUjmL9QXrPro3t+DVDLI3p8OBqo89t8zd8x2Oahpr2Dqrmunyck/e7htw7JV0UyR45Q7+1T8SMEV6T6aexnZKr38jutcggMnNzOU1ycKdN/5XoKO0H64Bj6JAb8q2n4G7r7rPqrQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=nK/NDlUArE+sALJCdH09VFpPZ7+oe3BUvtYqppCMPy4=;
 b=Jm+zUsZ6RMo/D/Vwigr9sG5mVBYpAIDoeTHH3RRC3o3ugvG2sCEvH2PrtgB3aqUNjC/2AA3K1TiV7O/00TQ5NMrRmvjxSj6yDFVMkMU8nFcR1JaecbLtefxm+NNc2YFrsjE/vC1WttZBS5uI0/ykefPjE48lruDo1QB37wbyK3NCEZhtJUY4ieoCtHNIlPHRMVqsNa85hSs9oGaVcVlKRz7NRVu9lKxOfDeFwzSqFEbNsjCrchMDUT7POjedupcJktcjI7Qng53jTqjAYWsVxaR9pxO6ja4psXeQYX62XOffsTSCYCV8nthxkluymCyodqb365n5P2ZMjHbWCYiisA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from PH8PR11MB8107.namprd11.prod.outlook.com (2603:10b6:510:256::6)
 by PH0PR11MB5612.namprd11.prod.outlook.com (2603:10b6:510:e7::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6086.17; Wed, 8 Feb
 2023 05:48:00 +0000
Received: from PH8PR11MB8107.namprd11.prod.outlook.com
 ([fe80::421b:865b:f356:7dfc]) by PH8PR11MB8107.namprd11.prod.outlook.com
 ([fe80::421b:865b:f356:7dfc%6]) with mapi id 15.20.6064.036; Wed, 8 Feb 2023
 05:48:00 +0000
Date: Tue, 7 Feb 2023 21:47:56 -0800
From: Dan Williams <dan.j.williams@intel.com>
To: Vishal Verma <vishal.l.verma@intel.com>, <linux-cxl@vger.kernel.org>
CC: Gregory Price <gregory.price@memverge.com>, Jonathan Cameron
	<Jonathan.Cameron@huawei.com>, Davidlohr Bueso <dave@stgolabs.net>, "Dan
 Williams" <dan.j.williams@intel.com>, Vishal Verma
	<vishal.l.verma@intel.com>, <nvdimm@lists.linux.dev>
Subject: RE: [PATCH ndctl 2/7] cxl: add a type attribute to region listings
Message-ID: <63e3378cb5248_e3dae2943f@dwillia2-xfh.jf.intel.com.notmuch>
References: <20230120-vv-volatile-regions-v1-0-b42b21ee8d0b@intel.com>
 <20230120-vv-volatile-regions-v1-2-b42b21ee8d0b@intel.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20230120-vv-volatile-regions-v1-2-b42b21ee8d0b@intel.com>
X-ClientProxiedBy: SJ0PR13CA0153.namprd13.prod.outlook.com
 (2603:10b6:a03:2c7::8) To PH8PR11MB8107.namprd11.prod.outlook.com
 (2603:10b6:510:256::6)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH8PR11MB8107:EE_|PH0PR11MB5612:EE_
X-MS-Office365-Filtering-Correlation-Id: 099246f8-558d-44f7-a18a-08db0998091b
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: aNVrxmx66w08gV4CNNlrOYHidaY9XYP8drJaGJwmxvhu8jFhiGwa8AKdXOFdepFpITfrGWEJDpZry0OXAtzZt9SbQxwFjjI7XyEW7gvabp4jxfVkQjf0BHHYj4r5a2zQWdK0WVlmmrc8I9I9w0QUrR9Xy5iiz+K0xO8xo22bAU3CbjaajfherdktGOXOxr0kcA8nQc+je7pi04psWzlhduwyKo8kOyOiANrMDeNSo9mCe2uADPTAkEk4tGGprLK2MGSbIKpcknfONR7kG5KqrGeGrlY4hVQZchT9GpDGASo2e1oynU239Wvg+u8ESh2H9KV9RWjd3/iR5xEK9zvD+XPy221XzDnrFuVJyPQcinUSTAV3b9IfzppEqvAJbuzyJR717MKg6w53fVyNo2MtXf/RJP0iuY+82tqkDJbaRPmaYqiiMys2vybUmLPuwUn2P+83TI7TfvVPPPeeqbxqARWMycEbJ/cCl/7ZKHtYb0KSHtnlmTaM+8ukESDas11P3E2/8b4vwXuqjO5rIVKfZjKv4NTmcj6QPH7XtXCd9LqJDUIcWdIIiBWZi4BitP0FE8o/YkV6YcxxsO6sxBfygrWOaNWvpKzXkKVbL0Sje9IeGA/a76Z4HhimBBeJKUAkXiPdry7xJwUEwmiANZI10g==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH8PR11MB8107.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(366004)(39860400002)(136003)(396003)(346002)(376002)(451199018)(316002)(83380400001)(2906002)(26005)(41300700001)(478600001)(54906003)(38100700002)(6512007)(6486002)(186003)(9686003)(6666004)(86362001)(8936002)(6506007)(5660300002)(4326008)(8676002)(82960400001)(66556008)(66946007)(66476007);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?YmPVV9QxcfeOWgjP9bfGduAQ0gZfTDys17sIe7hO0ImEa/t2WOsV8c6ZQh5d?=
 =?us-ascii?Q?ZIwiqqYk9ySE2kNVeouX2BfenmHJ9ZsgqaoiwJKI2WvPWplXEzEMorywqCJU?=
 =?us-ascii?Q?oRcElGcsQrzaY4mAuflBLGzeM1QfXyhPlXXKPdvfAR3q8LUgz4OWK/2vWhV2?=
 =?us-ascii?Q?l/ztGY5T4aGp3uhiGFYuOxuMkWTLw0Ayaz6AtAy5+R/D7MJJ99w98fwxBO6G?=
 =?us-ascii?Q?xr8BvocJ2EkqncpnUdpXizZuOgWa9IBExHlDRgLZgnlfHTTRQdm5YkvFE1kE?=
 =?us-ascii?Q?KziI6d9k503YscLo5uFtPdRgxtzPyvekuMCetqgtBn6ywKhWd1VDysDXZFko?=
 =?us-ascii?Q?eSyeETRi80sEMpmxffBZw2Eb45B9MM2ael6ENkOlJzU3sh10EFwB+xXze5dX?=
 =?us-ascii?Q?eMMTne+it0yHZXAZFahZycjZ9VKMFrw5CIm83LZj+TRckuo31w++xD/Q04yn?=
 =?us-ascii?Q?mamo2iygEm0qHU3p/uRIUxIq0L5bYWc5ChdEaScGTsYnQimr6ssXlEonyL3t?=
 =?us-ascii?Q?UzPoE+eGBgXhJOuyMbhFX/wDms1JDitsDPo+8Jy09UqBZPMcGkocG6X3kUn9?=
 =?us-ascii?Q?Uz4a5zzLs3cl39cCuasWhD9QmoTsmSFfHfLxDHAK1964tv5yCRZtk4fPES5+?=
 =?us-ascii?Q?gSjo4APZiJQrZgElK+Tk9dDSgZcf64pW25/UbpFgI3BCoLAR1Xq0qQawy78/?=
 =?us-ascii?Q?BzbMU4D7ChlJ2pbKbP+0liu42qSgfeZpbX0ParIPLbw9exYxncICdgP3MZoV?=
 =?us-ascii?Q?YS1DsXF5/Don+cfCQYw9IGZ6+yLa1bR6JJcBaLtGQuxyL1fE4EqaLRjvPx8P?=
 =?us-ascii?Q?r5dTegP7QPugwuGn5rKXB2gQhfmSm1aTFbmn4VAHz1edEjKBaE1wwwmlK1ds?=
 =?us-ascii?Q?w1dyKgjhKdylUOMSCS8kMqRqIslKJ7jWmMyE+/i0We/Pd2iZa8M4iqbveuu6?=
 =?us-ascii?Q?sdFjBAiBMgc0WPga8gN3iRYCZA5++bBo3pZudrTz2mndtAmMotLichBxhCkY?=
 =?us-ascii?Q?7DwSlLqszE+2JhYveMVNcGqQVH6a2W6VW0Wv10QLLTPrOj+lwo9Ronqp7wCJ?=
 =?us-ascii?Q?os/9WHPcIX3IpRNvYz44U6OeS7dhk4as11qCMlZimuCHFAD0XJUPqe6tTPRp?=
 =?us-ascii?Q?9tmBSKu8kJU2LWTUTW4QPspewRzC1Jz/ROdju0JUFjENlL96hLtFKvqteDj9?=
 =?us-ascii?Q?Ay/QNf6+aAJ460eHPS2KX15rA8/z5x2Gkv6AsiaM3DNc8f3IhjUPrCWeYNtG?=
 =?us-ascii?Q?lEuKKaRJn7j9MxNxCHAZubtEA/WSlkwDCViSqJQtK9f6AAkKcqW89bgTEpes?=
 =?us-ascii?Q?2Sc1XZn5ufn35+K49cwJFNHX/DkRolRoB3QIAhJLWtzeUwwAhmE/gpqsWoJu?=
 =?us-ascii?Q?eq5d4WcgRR4Qj3BQYpNzrPFPb2SiFVf7rXKJ4XG5vB4mHtogxf+ErQ+Cy80K?=
 =?us-ascii?Q?mPXh7kCoVAtBwdfIZjwd6nc4df3skaIZhp4qNJYw1nuzdLpoeI45UJ9EiJZm?=
 =?us-ascii?Q?eLuVjNO58/cwuMQ1DX5LNrNTQRUCOclVVIvlGicvTNZNzNmldrnoL9+dYwWn?=
 =?us-ascii?Q?UqH2l5xW7/m3qAFe20StYhj4jUWf/HedgVaBU3S3HdLaSkFTm4DS25x7ATw5?=
 =?us-ascii?Q?Ig=3D=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 099246f8-558d-44f7-a18a-08db0998091b
X-MS-Exchange-CrossTenant-AuthSource: PH8PR11MB8107.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Feb 2023 05:47:59.7729
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ItWsccPri+IQMpr8FqFzaAE8+q12ydzoeft5A2ndjCmZbRxzNmIWqBjz36gQ6bNc4TTwY5Drk4tjHvee+Xl5WNee0fTfM5janmbzrmR9OTc=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR11MB5612
X-OriginatorOrg: intel.com

Vishal Verma wrote:
> In preparation for enumerating and creating 'volatile' or 'ram' type
> regions, add a 'type' attribute to region listings, so these can be
> distinguished from 'pmem' type regions easily. This depends on a new
> 'mode' attribute for region objects in sysfs. For older kernels that
> lack this, region listings will simply omit emitting this attribute,
> but otherwise not treat it as a failure.
> 
> Cc: Dan Williams <dan.j.williams@intel.com>
> Signed-off-by: Vishal Verma <vishal.l.verma@intel.com>
> ---
>  Documentation/cxl/lib/libcxl.txt |  1 +
>  cxl/lib/private.h                |  1 +
>  cxl/lib/libcxl.c                 | 11 +++++++++++
>  cxl/libcxl.h                     |  1 +
>  cxl/json.c                       |  5 +++++
>  cxl/lib/libcxl.sym               |  5 +++++
>  6 files changed, 24 insertions(+)
> 
> diff --git a/Documentation/cxl/lib/libcxl.txt b/Documentation/cxl/lib/libcxl.txt
> index f9af376..dbc4b56 100644
> --- a/Documentation/cxl/lib/libcxl.txt
> +++ b/Documentation/cxl/lib/libcxl.txt
> @@ -550,6 +550,7 @@ int cxl_region_get_id(struct cxl_region *region);
>  const char *cxl_region_get_devname(struct cxl_region *region);
>  void cxl_region_get_uuid(struct cxl_region *region, uuid_t uu);
>  unsigned long long cxl_region_get_size(struct cxl_region *region);
> +enum cxl_decoder_mode cxl_region_get_mode(struct cxl_region *region);
>  unsigned long long cxl_region_get_resource(struct cxl_region *region);
>  unsigned int cxl_region_get_interleave_ways(struct cxl_region *region);
>  unsigned int cxl_region_get_interleave_granularity(struct cxl_region *region);
> diff --git a/cxl/lib/private.h b/cxl/lib/private.h
> index f8871bd..306dc3a 100644
> --- a/cxl/lib/private.h
> +++ b/cxl/lib/private.h
> @@ -149,6 +149,7 @@ struct cxl_region {
>  	unsigned int interleave_ways;
>  	unsigned int interleave_granularity;
>  	enum cxl_decode_state decode_state;
> +	enum cxl_decoder_mode mode;
>  	struct kmod_module *module;
>  	struct list_head mappings;
>  };
> diff --git a/cxl/lib/libcxl.c b/cxl/lib/libcxl.c
> index 4205a58..83f628b 100644
> --- a/cxl/lib/libcxl.c
> +++ b/cxl/lib/libcxl.c
> @@ -561,6 +561,12 @@ static void *add_cxl_region(void *parent, int id, const char *cxlregion_base)
>  	else
>  		region->decode_state = strtoul(buf, NULL, 0);
>  
> +	sprintf(path, "%s/mode", cxlregion_base);
> +	if (sysfs_read_attr(ctx, path, buf) < 0)
> +		region->mode = CXL_DECODER_MODE_NONE;
> +	else
> +		region->mode = cxl_decoder_mode_from_ident(buf);
> +
>  	sprintf(path, "%s/modalias", cxlregion_base);
>  	if (sysfs_read_attr(ctx, path, buf) == 0)
>  		region->module = util_modalias_to_module(ctx, buf);
> @@ -686,6 +692,11 @@ CXL_EXPORT unsigned long long cxl_region_get_resource(struct cxl_region *region)
>  	return region->start;
>  }
>  
> +CXL_EXPORT enum cxl_decoder_mode cxl_region_get_mode(struct cxl_region *region)
> +{
> +	return region->mode;
> +}
> +
>  CXL_EXPORT unsigned int
>  cxl_region_get_interleave_ways(struct cxl_region *region)
>  {
> diff --git a/cxl/libcxl.h b/cxl/libcxl.h
> index d699af8..e6cca11 100644
> --- a/cxl/libcxl.h
> +++ b/cxl/libcxl.h
> @@ -273,6 +273,7 @@ const char *cxl_region_get_devname(struct cxl_region *region);
>  void cxl_region_get_uuid(struct cxl_region *region, uuid_t uu);
>  unsigned long long cxl_region_get_size(struct cxl_region *region);
>  unsigned long long cxl_region_get_resource(struct cxl_region *region);
> +enum cxl_decoder_mode cxl_region_get_mode(struct cxl_region *region);
>  unsigned int cxl_region_get_interleave_ways(struct cxl_region *region);
>  unsigned int cxl_region_get_interleave_granularity(struct cxl_region *region);
>  struct cxl_decoder *cxl_region_get_target_decoder(struct cxl_region *region,
> diff --git a/cxl/json.c b/cxl/json.c
> index 0fc44e4..f625380 100644
> --- a/cxl/json.c
> +++ b/cxl/json.c
> @@ -827,6 +827,7 @@ void util_cxl_mappings_append_json(struct json_object *jregion,
>  struct json_object *util_cxl_region_to_json(struct cxl_region *region,
>  					     unsigned long flags)
>  {
> +	enum cxl_decoder_mode mode = cxl_region_get_mode(region);
>  	const char *devname = cxl_region_get_devname(region);
>  	struct json_object *jregion, *jobj;
>  	u64 val;
> @@ -853,6 +854,10 @@ struct json_object *util_cxl_region_to_json(struct cxl_region *region,
>  			json_object_object_add(jregion, "size", jobj);
>  	}
>  
> +	jobj = json_object_new_string(cxl_decoder_mode_name(mode));
> +	if (jobj)
> +		json_object_object_add(jregion, "type", jobj);
> +

I am thinking this should be gated by an:

    if (mode != CXL_DECODER_MODE_NONE)

...just to avoid saying "type : none" on older kernels where there is an
implied non-NONE type.

Otherwise looks good to me:

Reviewed-by: Dan Williams <dan.j.williams@intel.com>
