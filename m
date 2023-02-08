Received: from mga01.intel.com (mga01.intel.com [192.55.52.88])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 62A527F
	for <nvdimm@lists.linux.dev>; Wed,  8 Feb 2023 03:47:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1675828046; x=1707364046;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=+v8jms+CeRHTMQ8lU4PXdPu/+zcVjgdfq20dm/ulsOg=;
  b=QZy718fTUg1rARO0f1c7RjTrwLHcf+b61eRrQ4oZWqlgUrt2wHaK0M7l
   LuAF2Ymiz7Uv/plGfTCb0ZrhlIpM4hDEjwD0AJIvBnbj4kYzgITHWndUr
   pachmUQXQAJPw7zBbAOvdcS7wpqosgqI7UyvdMKwnLUYt7+pmEznboyiw
   9Armv3Uyq8WCqOQCazihavwX70xyH1Li5SLtUcn4O7PbsgK/8HgCMBVAS
   H+Fr+meZuyoZcNzkDEyrFegB9VkEB/MVYrglXcEzjjdDdVPgPD/Vrupxu
   8fOc5aZQ4dLV1S+sXYhl2T6RAD0TZV3ChMgoz465hkGHcfIZB2YA+mmbo
   g==;
X-IronPort-AV: E=McAfee;i="6500,9779,10614"; a="357086302"
X-IronPort-AV: E=Sophos;i="5.97,279,1669104000"; 
   d="scan'208";a="357086302"
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Feb 2023 19:47:25 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10614"; a="660500444"
X-IronPort-AV: E=Sophos;i="5.97,279,1669104000"; 
   d="scan'208";a="660500444"
Received: from fmsmsx602.amr.corp.intel.com ([10.18.126.82])
  by orsmga007.jf.intel.com with ESMTP; 07 Feb 2023 19:47:24 -0800
Received: from fmsmsx612.amr.corp.intel.com (10.18.126.92) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Tue, 7 Feb 2023 19:47:20 -0800
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx612.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Tue, 7 Feb 2023 19:47:20 -0800
Received: from fmsedg601.ED.cps.intel.com (10.1.192.135) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16 via Frontend Transport; Tue, 7 Feb 2023 19:47:20 -0800
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (104.47.58.169)
 by edgegateway.intel.com (192.55.55.70) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.16; Tue, 7 Feb 2023 19:47:09 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=R98i+CxKQQL+vcWBgUpcfgkT1v8y63PMTgHl61YuFAUuMrl6ovwyNQiFc0aMZn2OTqX26W8y4T6e9ZMoxsMrt6wN5t96JYhRV6HGlxrGLddxCjsNn2EOGgPL1VgR9r4OLcEuhWNNGOt63wVd+K3qZ+AqIY53zCOhX1CLwRIavU+v1FOME/F2eR2/u3zmbee8HVvTEE2dUWAAFdlhw20nYBR22cVNtJQNakHOR2JGsZa00VdpJmTOLlz5Ax9sztlGo9uh47RienUADncG018oauxTx6l01m2CBcOEntuuhPmBYIX7PZVE809smHpiwCrejAI2GeLtOcK7r2U1wOX6hA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=HaOOO06BDQ5jbHuYwlHjT9g+UQBUdlUoRje4jHPE3lc=;
 b=bbXL44SajeuYv9NN7Cdf5SIdRAF2BF5SYXQnnIS5nd0JwJf84sP7jCMldHt2NIN4UxezzHgyQyXUIIaTEFaWD4QAmLBQ8euwtRiQx3xlasClv9yqOvKxAVtH1rPahsBTqqvnHEC2eC9zQ7LmpgdT7SsSdHpEBJoyO4AZUidnpTqaHYDEwlOxVPT0gCjVWg2JbXAPsUGdwipDQfocjgiKsOpw12i85Tp6JhYgf19JZ4ZeaE440u/3mO0zD+RDWF6/epfnra2VkuTwG8VrZf2jgeEK5fy5MgywEr6X7dZWlF0WTY760ZEDBkZLdxzbvlmC0cKXepxi6q50quk5wUdffA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from SA1PR11MB6733.namprd11.prod.outlook.com (2603:10b6:806:25c::17)
 by BL3PR11MB6458.namprd11.prod.outlook.com (2603:10b6:208:3bd::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6064.34; Wed, 8 Feb
 2023 03:47:02 +0000
Received: from SA1PR11MB6733.namprd11.prod.outlook.com
 ([fe80::6851:3db2:1166:dda6]) by SA1PR11MB6733.namprd11.prod.outlook.com
 ([fe80::6851:3db2:1166:dda6%9]) with mapi id 15.20.6064.034; Wed, 8 Feb 2023
 03:47:02 +0000
Date: Tue, 7 Feb 2023 19:46:58 -0800
From: Ira Weiny <ira.weiny@intel.com>
To: Vishal Verma <vishal.l.verma@intel.com>, <linux-cxl@vger.kernel.org>
CC: Gregory Price <gregory.price@memverge.com>, Jonathan Cameron
	<Jonathan.Cameron@huawei.com>, Davidlohr Bueso <dave@stgolabs.net>, "Dan
 Williams" <dan.j.williams@intel.com>, Vishal Verma
	<vishal.l.verma@intel.com>, <nvdimm@lists.linux.dev>
Subject: Re: [PATCH ndctl 2/7] cxl: add a type attribute to region listings
Message-ID: <63e31b32c80ff_107e3f2945c@iweiny-mobl.notmuch>
References: <20230120-vv-volatile-regions-v1-0-b42b21ee8d0b@intel.com>
 <20230120-vv-volatile-regions-v1-2-b42b21ee8d0b@intel.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20230120-vv-volatile-regions-v1-2-b42b21ee8d0b@intel.com>
X-ClientProxiedBy: SJ0PR03CA0292.namprd03.prod.outlook.com
 (2603:10b6:a03:39e::27) To SA1PR11MB6733.namprd11.prod.outlook.com
 (2603:10b6:806:25c::17)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SA1PR11MB6733:EE_|BL3PR11MB6458:EE_
X-MS-Office365-Filtering-Correlation-Id: 3da01d37-2ca7-4320-b58a-08db09872325
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: zoyQF8AwZilyt8HrF/B0cnqMNO2vHKAhVxAmE3JmtvhoPWDml5JlHOWsDZWLVcIbPZo44oHei0YGRtTYKW2atlgL0b713Q3KAGrkzXlcOrz1xyDzpCHHY1NXFIgHtPtelFGm8xHrSmxsphPQD66uBubQ1gryiESH/T1f6B84GwJmiR0C/Kfq2+bsJfNPRJkWGxqgMwneqO5uma8rbgjqo7bzNTGhHBG2fjKSpEb1LJcpASsn+eiPq5Tq+KyiyrbTt8l+/xECamtJGJ0TxjVRpmWM4n5kmKqU7dClmPKZrUmbgpRGFeUDyIK3XtujikMek1ZOd9J1fcVpkb9dJLoeWkUEHpgdB6Sy2FoQERnizW2SCZNcpm7Aktje9DHjaBRhmyDLY2VFcJ+t5BzksMDGrwv62x9N97A+8TBSLPB8WUG2CQZ6kn/Qzo04Aqxv95B3AMaNz5SaFYnwcMBrkungmbmi+RbOtW9QcJk6OV0hYEUrBiQTl3hlsPSFZ4sJ7epjtbsvll6mUebKgdSWhioBGHGR6DR3Y7L4tmK81Z43Z/W9Udw8EQqd1YyqiDyhMffz/HedojQAcfY664kEHIv1XvppkP/YLBrcsSyBDGFAlbiwyaI5EgfoMo5lHAm80gQO2wPZur+m/ciyFWhdrmPbRg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR11MB6733.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(396003)(39860400002)(136003)(366004)(376002)(346002)(451199018)(8936002)(54906003)(66556008)(4326008)(66946007)(66476007)(316002)(5660300002)(8676002)(44832011)(2906002)(41300700001)(6486002)(478600001)(9686003)(6666004)(6512007)(6506007)(186003)(26005)(83380400001)(82960400001)(38100700002)(86362001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?GF8PRowbAFet1DD1rWgg6NBDYGcr43x20Mh4iufmR3cUetJFPz4M75VDxtuN?=
 =?us-ascii?Q?yMoVwAcyDXQRLYqZGqgopetq1ff4cyg1qsV51MvWOqu1CigHtzytEB2kf9m5?=
 =?us-ascii?Q?F2Ht3MzarQulSLKV8glO+3GVyFCeHF7ELvajRifrv6uJODIf66/3O17meoU6?=
 =?us-ascii?Q?yGyHoS5yl04V6wE/bcauZB8iidtBkyUTfwqvq2dppyoUghMxyiy4MPCe3tFm?=
 =?us-ascii?Q?HudZNncbbAabKe3Ipky6+S8nsEMa2HZb8LS2/6Ia0M0d3rnuloX1iVHVxbYT?=
 =?us-ascii?Q?cPPyUmgA0a4WbkIepCAFuNSmQBzTgx/GDVuNppr8ZMBy934lYlkllex7pzJe?=
 =?us-ascii?Q?VmdasB3EpEjbyBErgy3q5rHQxwm8kYO1rGccVFpPTM3rz/Mw/3rf/pjYlM2D?=
 =?us-ascii?Q?Hm8LlGu3EAyMSQIddBWKwgDoj9OGiVmaDepKl3gNMCtwge9YAamCkbN/wsOZ?=
 =?us-ascii?Q?t9EKRbtKhkV6vmIWxE9Wud3v/zBAGqIjrCvGZGd96vXufs9uwv3+xflmZKtH?=
 =?us-ascii?Q?EZJL4uXFTSNmW03eb8Lx2W+vmFAAnVTjmr2VW/uQQuzf0PU2kdDRojRUj+GR?=
 =?us-ascii?Q?czcfDjqyTbWi6jffdzcj7RKDL3KGnQ3AHhtROCoklfqII3vGQkqc9h3szrWx?=
 =?us-ascii?Q?1pqKa9/iXKYDArJWSxswjrcSfvr43DRgyHkEGwvH97oOyePUaPvJjou1RXOv?=
 =?us-ascii?Q?ld9EI8ciUkbMJtUGHLS8nVmc/rlQm5j4NnH6/Hu8wAiVqx5wgQ5JJjinGBPT?=
 =?us-ascii?Q?9EqFj8UtcXaf7C0YvR77R1zMnC6UyXfI4tVodW4lxLy84kku1FRbEJXkfhtW?=
 =?us-ascii?Q?5kaVapBXgvdC55GySWsLhOdSpvc/9Kr7uwU0NRgZ3Kywey+3Ow1c+YfacAtE?=
 =?us-ascii?Q?8vwxVMLURhD7YgDU9FZRcIdjFrKvoonMVNsRHUtFA0kzg7Brmg6/zewVQnrY?=
 =?us-ascii?Q?XfypXFOKbRROUkh0Lq0vQwKhbNNMRuLwo0rsr4F+iPjbuWt2zOBPhMAxPfBw?=
 =?us-ascii?Q?I888sZ1zA5CKRtAaImlJeJ1a/QaGjt6cp95xwWSXGrVMs5WxE4pNFBC29TiZ?=
 =?us-ascii?Q?B9kbgJhEBYNUtu/Oskwe/4GPKkQp1GAHaUhzmeFND//GzJuSqS0meQ6DFGIw?=
 =?us-ascii?Q?cYmMOeJucTc1/QIAxIT2ugBDNT21Qhb2AHA5rPu6WwindzEd+vB2FMb6Nztw?=
 =?us-ascii?Q?zEAjeZivNdttQwUYAYtMCYI1TgR2ffyp4mpP8mh6l1TLNIsgirGDF+p1f5f0?=
 =?us-ascii?Q?9JXkGqnLZr83RDP1LyylM97neiYgn7b9bOuHqENlbkmOWxxGhzUCXWAm9Fyx?=
 =?us-ascii?Q?0/oyg6KY47XF2jryNXakPfA8fjTzrzwjz8YHT73TJea88X2R/8o1zrxLPIOg?=
 =?us-ascii?Q?678tq8sp0IppD4KdTnr/m4ZnNWJcwcDU2SgIZGONfdDD1do3yxMShmKt7/ib?=
 =?us-ascii?Q?X7nSYZRXn8y9z8oFQJHmnwYidrswT8ith1uuRMu7HYzFPEnsjE4gnxBXx/n0?=
 =?us-ascii?Q?r4MaWkLGr7ItKEs2yr2glk3hxWBb01NWToCxbZ4/LEws1KFBy8EP4hPTs8oQ?=
 =?us-ascii?Q?psYWLgMXXYFJyJy1DvBxuxrNMjzjtPGC8NdzAd06?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 3da01d37-2ca7-4320-b58a-08db09872325
X-MS-Exchange-CrossTenant-AuthSource: SA1PR11MB6733.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Feb 2023 03:47:01.9996
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: JQRrjtahAEwZov0jWmiyx19nkTQ92r/cgwqhrRO3jOOwojtggvMwE4DaXpVWINlRBqAIBj6aXrnNu5PHrvc3Mg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL3PR11MB6458
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

Reviewed-by: Ira Weiny <ira.weiny@intel.com>

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
>  	val = cxl_region_get_interleave_ways(region);
>  	if (val < INT_MAX) {
>  		jobj = json_object_new_int(val);
> diff --git a/cxl/lib/libcxl.sym b/cxl/lib/libcxl.sym
> index 6bc0810..9832d09 100644
> --- a/cxl/lib/libcxl.sym
> +++ b/cxl/lib/libcxl.sym
> @@ -242,3 +242,8 @@ global:
>  	cxl_target_get_firmware_node;
>  	cxl_dport_get_firmware_node;
>  } LIBCXL_3;
> +
> +LIBCXL_5 {
> +global:
> +	cxl_region_get_mode;
> +} LIBCXL_4;
> 
> -- 
> 2.39.1
> 


