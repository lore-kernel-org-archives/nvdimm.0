Received: from mga14.intel.com (mga14.intel.com [192.55.52.115])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B46937F
	for <nvdimm@lists.linux.dev>; Wed,  8 Feb 2023 04:07:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1675829258; x=1707365258;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=u1xVmOI6C5MrzwNDR5CFWP22xNwa0ekOijG+SbtSQ0k=;
  b=RWj56YPxgt4p69YnWgoZHFvbRVYm6q+blHHczvh3saLwLZob6qcQHecq
   Vt1a2SJjvlXlZn6GVQihI2IQ/x9wI6tzv0/u7LDVix+IgjvTNfE5SNvfC
   ZhnwB7vbpFVrNJjKwVlIkGGdeb18LuuUwufSoIJtGkOSbrjy3ADxbKOq9
   xMP1IGoByxngFNCdSBbmuQuloPfTxOnovLtN0YmkJiFHkMmnt4UIIFJtY
   dx/TSUwVXNsMJ1F7ShGIez4nAh4cSXuAQIYW01MYVGD1VPH5sJKNH5P2W
   1LxusdY2M/FY4xXwJuu+nqdXnYGGbpTUzoRtaa7ocFfMcMqJnETkwcn1C
   g==;
X-IronPort-AV: E=McAfee;i="6500,9779,10614"; a="329730053"
X-IronPort-AV: E=Sophos;i="5.97,280,1669104000"; 
   d="scan'208";a="329730053"
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Feb 2023 20:07:37 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10614"; a="667090223"
X-IronPort-AV: E=Sophos;i="5.97,280,1669104000"; 
   d="scan'208";a="667090223"
Received: from fmsmsx602.amr.corp.intel.com ([10.18.126.82])
  by orsmga002.jf.intel.com with ESMTP; 07 Feb 2023 20:07:37 -0800
Received: from fmsmsx612.amr.corp.intel.com (10.18.126.92) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Tue, 7 Feb 2023 20:07:36 -0800
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx612.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Tue, 7 Feb 2023 20:07:36 -0800
Received: from fmsedg601.ED.cps.intel.com (10.1.192.135) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16 via Frontend Transport; Tue, 7 Feb 2023 20:07:36 -0800
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (104.47.55.169)
 by edgegateway.intel.com (192.55.55.70) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.16; Tue, 7 Feb 2023 20:07:35 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=AoNiDvH8Hq7190I3mHice6Tx+kdeJLwnHbQ5phSk1wkbTPEw7TmPVOhtveLFibSdJPTpYw8JYZwO5vS1YYx2nS2C78Z52PmxPy2rlFz0QyaazKRDl6ewfD+iGYR9ej7v9q8wxcCbQhhZ9ZsLlTb3lDHxyJ5Tx5Dmd/VGHhr3/0h2+aiqInf6SQ8/c/OUMtVC/LLfkuY/GJB8aaR4X23y2jBWN5ZblCIEP7VptvYyWy/M2+udvVgE/HtP1wcaUjuduPZeUumfiAATsYSDcqtltj8LkGbfaNvpN4qB1O1QDENlLdgXvKaoTEZ2jdx9N8tH9Rto5hpPlQa6wA6UZXCYKw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=CP4eAFbd9WQCz1pENkFRwXMytNEPyLMaJal5x/mzc5A=;
 b=YAG+oMgVOdbYbo7AxKZtzJ1cBDqRQlnQwjEcPglVtBJ4ODE6GVcJjOpaOCI9dI+vv/2axX43EXTmJrfk7L/GDZIE1O4IcaUlreCRPGN90/JsvVsksvJkIKRHlKfwWBv2HQ541XHt2aEEAzECQvkbAxqlWvmEWhWUftP01hoC8Y3FXwiuwkof/Y/51R46Lfqz5YgmOdFlAiI5u1aRIdPKys1Xyv14u0TJHmc+2GNC0+3gEHOUvWlVSM+Hd9NOb1OJPMWgxoXNnTz+Bv98RCqKJJfSBfUAru1PAqkEECqmqBF6/JL2EDbpK3jQMOYD87HNbMBRF/3/VXfygiwR0vXYJQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from SA1PR11MB6733.namprd11.prod.outlook.com (2603:10b6:806:25c::17)
 by DM4PR11MB6287.namprd11.prod.outlook.com (2603:10b6:8:a6::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6064.34; Wed, 8 Feb
 2023 04:07:34 +0000
Received: from SA1PR11MB6733.namprd11.prod.outlook.com
 ([fe80::6851:3db2:1166:dda6]) by SA1PR11MB6733.namprd11.prod.outlook.com
 ([fe80::6851:3db2:1166:dda6%9]) with mapi id 15.20.6064.034; Wed, 8 Feb 2023
 04:07:33 +0000
Date: Tue, 7 Feb 2023 20:07:30 -0800
From: Ira Weiny <ira.weiny@intel.com>
To: Vishal Verma <vishal.l.verma@intel.com>, <linux-cxl@vger.kernel.org>
CC: Gregory Price <gregory.price@memverge.com>, Jonathan Cameron
	<Jonathan.Cameron@huawei.com>, Davidlohr Bueso <dave@stgolabs.net>, "Dan
 Williams" <dan.j.williams@intel.com>, Vishal Verma
	<vishal.l.verma@intel.com>, <nvdimm@lists.linux.dev>
Subject: Re: [PATCH ndctl 5/7] cxl/region: determine region type based on
 root decoder capability
Message-ID: <63e3200218c32_107e3f294ea@iweiny-mobl.notmuch>
References: <20230120-vv-volatile-regions-v1-0-b42b21ee8d0b@intel.com>
 <20230120-vv-volatile-regions-v1-5-b42b21ee8d0b@intel.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20230120-vv-volatile-regions-v1-5-b42b21ee8d0b@intel.com>
X-ClientProxiedBy: SJ0PR05CA0057.namprd05.prod.outlook.com
 (2603:10b6:a03:33f::32) To SA1PR11MB6733.namprd11.prod.outlook.com
 (2603:10b6:806:25c::17)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SA1PR11MB6733:EE_|DM4PR11MB6287:EE_
X-MS-Office365-Filtering-Correlation-Id: e542e975-5210-4580-ad77-08db098a015d
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: MT2ZeG2ksHkwDiHir8iSrwQ25MZbRBAswUxaQHp8BwKEvS6Hl2blnqZ72RYXiYzvJn13yQH55jwd4ToqrI+BH4/cTHlai6vsOZ6JcFmfyhWZpgArkcOr9q091auJZPGw27J29dq2tx/lN54f/eLdt/uG6U/j4yd9cyTaLlUZSUImw5SBsa9bUN/mWhteBUGhKCFY0XtNbWZS6eiKUBfWrjBGLg0ApvCp6GeNTjX4Z5GPkdlhhvq/KPG3XWS8VjSgWW3rzBXxFsMgvGV9v9rxeoP6x927KQEEQQMeY8za+IAMgO76yaay8gt4lwRYpePJI0Yop2D4WTO46KntoyoxCYgHIeOsCV4isSHAdz9PNooCcFae+RXhXv2KGgzgETUwOsRxtFNnYEvMIn/DsSv2tvJI7DXKFhBjUKLZ1z76wqm386UyhUIOIkLxprYOcNFzKqWCrNwKOAZsXz1tUZdEDJ+lm6sFpHsUE1GENNd2MoEdKDAPDT3xzlH3CiEb2bRBMF2uXVritHuzr9TlR831vgaU7EGpI9/AuDf42JrJkYw8+uxUxb//4haWvVgR0gOl4RIPkRyrGt5RZ0mb9XwWep2ds0sVseCaCh1hGgaj7EA4OREe9nyOlOL2p41c0NWSU6PecH2NVOT5odmsv3AGOg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR11MB6733.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(346002)(366004)(136003)(396003)(376002)(39860400002)(451199018)(5660300002)(86362001)(478600001)(38100700002)(82960400001)(316002)(6486002)(54906003)(8936002)(41300700001)(44832011)(6512007)(66556008)(66476007)(4326008)(186003)(83380400001)(66946007)(8676002)(6506007)(9686003)(26005)(2906002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?RpqpLJcmZaICeHOphNvwaaOf5ntO1TIbdxrs+FkXh3uC+dT6VMNorGrjRP4z?=
 =?us-ascii?Q?MJt4lYxZFzY4Xs0bHjf9C7B7XYmRcC7izZgaXJ/5wcaz9FAar3srN2nrkNQu?=
 =?us-ascii?Q?nGUPuxgyTci6VhQRgbcoX+1WeqNZB1y0HkaztSmokpxau2mYP/QtkI+GcCqs?=
 =?us-ascii?Q?Cf5QgPBt3Fym10MN/OFRRX6X3O6NjK+0a8+yCe83Y8K+c1YrLAKH+s+LMg8p?=
 =?us-ascii?Q?+c+/hdC0BqDsuzjgkGNULpubGVxEMnZxaro+cYSYH5bXPLygITuoDz2rK2+g?=
 =?us-ascii?Q?0/bWqLaEl5Zpvy758S/cxdZFym80ke7lK04GJRkhSm5Xa0rAAnU615PwpQ6u?=
 =?us-ascii?Q?p810PNbyvU6xaGKMmEuL7Sa6ueZq9KcBURtAID7YvIOXq5U0daAOUw1mIMOZ?=
 =?us-ascii?Q?kYemNy+SVNkhLSAQaVwvDco7EYg6lqSpGp1q5MKAM+9wDh/VlH1iyf/fSyXI?=
 =?us-ascii?Q?jX11bM7ax7/nI2Y/Gz8uV1bn6bXl2KTxUKgd9hqp4xVL+xnX2SktihD1Vxvr?=
 =?us-ascii?Q?0tjdD6wwi+Eq1Ym+G0SPxNMEIZafZxA+JOZk3MUNunPK4aDj7e4jKlY+qfBs?=
 =?us-ascii?Q?kmGQOXrUnuk/hnsueOEbOfMQ/ahov8YnUy0THZe7NYq/yH2Bl8cS/nuF5eS7?=
 =?us-ascii?Q?J9tuMaPSwQc6ik8FCUwLvEb4bGlhz+L3fqBQdSXUiODruVpX9cqWhCOjh2HB?=
 =?us-ascii?Q?wNWMw5x9g5g9ihwM00biib7XEMBi8TNR/vZWpEv/n2NsYqp+9/fIJSqqkCzv?=
 =?us-ascii?Q?N1Up18uRdKjspOdITIk/cMtulOzx4ed8ejDGOc2llDb83IjeWdXuFQ0/ubF9?=
 =?us-ascii?Q?CK4zLJeKscjsMyc8qzjJTjUuuuqGTtdTqUllaVVf1utMFr/8S11ZVbtpwVYF?=
 =?us-ascii?Q?lhXXt37q4b842YMCkmcac7jP630oUxseeATKKUceydrRadu0XQkKNwo/8TDC?=
 =?us-ascii?Q?uV5g/oQ3N9feMh3gDwZTrMs0W6VHJYTzbu+uGh6URdcFoWPTGPBGuz+aGQm7?=
 =?us-ascii?Q?DWAcsPt6C4cmE5Oova0mCHStw38t9Y56JjgaN2WPpJL9tfS0YAqFgdc0EZ+/?=
 =?us-ascii?Q?DnvnsL4iq6ypRKhXZyb/vYkq7GeFSKJY/o16HLjWpoAXCm6UIrDsz8QoH36O?=
 =?us-ascii?Q?gLahTCW9bw9lP7QOam1Zqo9gMwJMTEOrLbeRuEHKDEZ5dhbwfhL/6CsHCawS?=
 =?us-ascii?Q?79ADasCiAj/ShfibEHOb20bRGH3JR/SHKU3BbXMSIczwW3aKMZ5aErmyvaRB?=
 =?us-ascii?Q?eJecghTKlB1vO2gKE/UQ9CGelfWSbs195YpZldBprhLihFrvk4catTXWYtzr?=
 =?us-ascii?Q?Ziiu7jvbhmGksy2RGyK1DNT4Ot+YBGvkBeWji2Tw0PUWRcC+XuT/tH6CDZDi?=
 =?us-ascii?Q?aH0o8iiOIL35ynHeVus1AFE3UV4t/D0m7GMYSlFk89OzHWFKFXLE9Jq326NI?=
 =?us-ascii?Q?72YxLym0JdrbMnWNLfHpbnmdtI0T1mt3ME4PrH1weHdl39MoqrIFexulbhJt?=
 =?us-ascii?Q?x/jBSuQLzBN4hU5Lq6zvnxS8ikpMX+Pr+JEzX/lAuZ7pPl1M5NjPT4eSedyz?=
 =?us-ascii?Q?uEQ0XGVBCXd7AHpwCyoGDHaViA/axGuSaQgcy2bj?=
X-MS-Exchange-CrossTenant-Network-Message-Id: e542e975-5210-4580-ad77-08db098a015d
X-MS-Exchange-CrossTenant-AuthSource: SA1PR11MB6733.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Feb 2023 04:07:33.7516
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Ne2rvEdbdJy0H2Yh11+jsKXAVXvj3I4IHRpRl3KSZL3PssY/G2/GtIPEuudjVqLsIRRXG+3a5EOT+T9Kp4cONQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR11MB6287
X-OriginatorOrg: intel.com

Vishal Verma wrote:
> In the common case, root decoders are expected to be either pmem
> capable, or volatile capable, but not necessarily both simultaneously.
> If a decoder only has one of pmem or volatile capabilities,
> cxl-create-region should just infer the type of the region (pmem
> or ram) based on this capability.
> 
> Maintain the default behavior of cxl-create-region to choose type=pmem,
> but only as a fallback if the selected root decoder has multiple
> capabilities. If it is only capable of either pmem, or ram, then infer
> region type from this without requiring it to be specified explicitly.
> 
> Cc: Dan Williams <dan.j.williams@intel.com>
> Signed-off-by: Vishal Verma <vishal.l.verma@intel.com>
> ---
>  Documentation/cxl/cxl-create-region.txt |  3 ++-
>  cxl/region.c                            | 27 +++++++++++++++++++++++++++
>  2 files changed, 29 insertions(+), 1 deletion(-)
> 
> diff --git a/Documentation/cxl/cxl-create-region.txt b/Documentation/cxl/cxl-create-region.txt
> index ada0e52..f11a412 100644
> --- a/Documentation/cxl/cxl-create-region.txt
> +++ b/Documentation/cxl/cxl-create-region.txt
> @@ -75,7 +75,8 @@ include::bus-option.txt[]
>  
>  -t::
>  --type=::
> -	Specify the region type - 'pmem' or 'ram'. Defaults to 'pmem'.
> +	Specify the region type - 'pmem' or 'ram'. Default to root decoder
> +	capability, and if that is ambiguous, default to 'pmem'.
>  
>  -U::
>  --uuid=::
> diff --git a/cxl/region.c b/cxl/region.c
> index 9079b2d..1c8ccc7 100644
> --- a/cxl/region.c
> +++ b/cxl/region.c
> @@ -448,6 +448,31 @@ static int validate_decoder(struct cxl_decoder *decoder,
>  	return 0;
>  }
>  
> +static void set_type_from_decoder(struct cxl_ctx *ctx, struct parsed_params *p)
> +{
> +	int num_cap = 0;
> +
> +	/* if param.type was explicitly specified, nothing to do here */
> +	if (param.type)
> +		return;
> +
> +	/*
> +	 * if the root decoder only has one type of capability, default
> +	 * to that mode for the region.
> +	 */
> +	if (cxl_decoder_is_pmem_capable(p->root_decoder))
> +		num_cap++;
> +	if (cxl_decoder_is_volatile_capable(p->root_decoder))
> +		num_cap++;
> +
> +	if (num_cap == 1) {
> +		if (cxl_decoder_is_volatile_capable(p->root_decoder))
> +			p->mode = CXL_DECODER_MODE_RAM;
> +		else if (cxl_decoder_is_pmem_capable(p->root_decoder))
> +			p->mode = CXL_DECODER_MODE_PMEM;
> +	}

I feel like the default for p->mode should be moved here from
parse_create_options().  But I'm not sure what the flows might be like in
that case.  That means p->mode would default to NONE until here.

That would make the man page behavior and this function match up nicely
for future maintenance.

But I don't think this is wrong.  So:

Reviewed-by: Ira Weiny <ira.weiny@intel.com>

> +}
> +
>  static int create_region_validate_config(struct cxl_ctx *ctx,
>  					 struct parsed_params *p)
>  {
> @@ -481,6 +506,8 @@ found:
>  		return -ENXIO;
>  	}
>  
> +	set_type_from_decoder(ctx, p);
> +
>  	rc = validate_decoder(p->root_decoder, p);
>  	if (rc)
>  		return rc;
> 
> -- 
> 2.39.1
> 
> 


