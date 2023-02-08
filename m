Received: from mga17.intel.com (mga17.intel.com [192.55.52.151])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BAF7439E
	for <nvdimm@lists.linux.dev>; Wed,  8 Feb 2023 05:56:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1675835760; x=1707371760;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=PfGGrpdAbcL/BZsNgMYKn8rlw8rA5ZD8tEOE/leRqgQ=;
  b=FwUqFe3giKsL2jz8rIoPTmRqyh8pMR5mVMbVldsjl3IZXgV2A3ysc2/x
   5HVxZP6xo+zDcfL6vVUpV2roFtLrgZisOkwd6999NSGC5K07nUbmcGX2w
   xRGTQC1UfpdutUuTR1XbE3ap7kY3ZADxv7TAutNFqvBUBTsfqsyLNq+Ro
   iWyVU+CGCWyw1deHeO0PEFagmGKIL5B9nQOjhVfjdfa0hEZQbBRgK7Q14
   Y2unvukezLTifTuwYAz5W4q+Lx85fD7qb2QYK1vpRB7rOhNyM3agqWwNf
   BuE/yMEnUTEiKC5/yYJRO/JqPVaYGLAEkoUffN9OhkzOaVN9GehsMHNWP
   Q==;
X-IronPort-AV: E=McAfee;i="6500,9779,10614"; a="310068399"
X-IronPort-AV: E=Sophos;i="5.97,280,1669104000"; 
   d="scan'208";a="310068399"
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Feb 2023 21:56:00 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10614"; a="912613722"
X-IronPort-AV: E=Sophos;i="5.97,280,1669104000"; 
   d="scan'208";a="912613722"
Received: from fmsmsx603.amr.corp.intel.com ([10.18.126.83])
  by fmsmga006.fm.intel.com with ESMTP; 07 Feb 2023 21:56:00 -0800
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Tue, 7 Feb 2023 21:55:59 -0800
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Tue, 7 Feb 2023 21:55:59 -0800
Received: from fmsedg601.ED.cps.intel.com (10.1.192.135) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16 via Frontend Transport; Tue, 7 Feb 2023 21:55:59 -0800
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (104.47.58.109)
 by edgegateway.intel.com (192.55.55.70) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.16; Tue, 7 Feb 2023 21:55:58 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=er9iQ/2TsUDiVbrrVPZfZHvlM84GGc20cAKDBOHSbGtsvfoOQYEjqXVwxDKb/XCMx8fbS8kIz74R/ElxQAzVfIPdR/6PjJdvxBoIetxScr1mA1kWpx7365wko+nkYOAIgPadqrNLDtIDbWHv2EmCjsDO681Qn/vA8wXrmFbxmcA8u8Od0v3JPe+eUpXvGZPlyNoucFQrCBs3CFDjBp/u7CDu47foxY8xMcM5JAujBGq6fRBT6mMxs6xPRy07vGdQXu5j5Uy2uRttggJ5hYOXRPsr45AqwIALwfUaG4Ui4rzOJdczozzYBYAduuFNRLs+1Fa9fqF97AdgSVVdvPdIEw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=xN7pFum8knYy70YEgWl6dvH2Ivhy3TS8Oyz5Lj1KWUI=;
 b=cISPFLucygy85X/OtLa0Ays4Hn0KpXJm6EWgwQ+y6savA+vwIzQF1nlvcchPtWOurTCVCPeKRocI8B4GCDVNrb6LpG6xR8RRMAJx1Ga/bkSNkqEJdgs5XytdSoQnYWf1vvkE++gjJrQRDwxkxyLIFZ4+cRgkkDxq6dypGQGe5+FGQWQMqEN3/5Wq8cYRO6c4ylqH2wRaeqmuQjQg/gtQjuzgtgCQ5EOdco73/Gjmmy57Yv2dOPVP3o74qQEQQW4Zui6UB7DGGUI5OFFakVcNxFnnvmEL+a3MSPR6AgYwT5Ugjml4Jk5HIZX+W/vBteNVJSDhydiD7bueGKDUkHp/xg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from PH8PR11MB8107.namprd11.prod.outlook.com (2603:10b6:510:256::6)
 by SN7PR11MB6971.namprd11.prod.outlook.com (2603:10b6:806:2ab::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6086.17; Wed, 8 Feb
 2023 05:55:57 +0000
Received: from PH8PR11MB8107.namprd11.prod.outlook.com
 ([fe80::421b:865b:f356:7dfc]) by PH8PR11MB8107.namprd11.prod.outlook.com
 ([fe80::421b:865b:f356:7dfc%6]) with mapi id 15.20.6064.036; Wed, 8 Feb 2023
 05:55:57 +0000
Date: Tue, 7 Feb 2023 21:55:54 -0800
From: Dan Williams <dan.j.williams@intel.com>
To: Vishal Verma <vishal.l.verma@intel.com>, <linux-cxl@vger.kernel.org>
CC: Gregory Price <gregory.price@memverge.com>, Jonathan Cameron
	<Jonathan.Cameron@huawei.com>, Davidlohr Bueso <dave@stgolabs.net>, "Dan
 Williams" <dan.j.williams@intel.com>, Vishal Verma
	<vishal.l.verma@intel.com>, <nvdimm@lists.linux.dev>
Subject: RE: [PATCH ndctl 5/7] cxl/region: determine region type based on
 root decoder capability
Message-ID: <63e3396a17860_e3dae294d8@dwillia2-xfh.jf.intel.com.notmuch>
References: <20230120-vv-volatile-regions-v1-0-b42b21ee8d0b@intel.com>
 <20230120-vv-volatile-regions-v1-5-b42b21ee8d0b@intel.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20230120-vv-volatile-regions-v1-5-b42b21ee8d0b@intel.com>
X-ClientProxiedBy: BY3PR10CA0013.namprd10.prod.outlook.com
 (2603:10b6:a03:255::18) To PH8PR11MB8107.namprd11.prod.outlook.com
 (2603:10b6:510:256::6)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH8PR11MB8107:EE_|SN7PR11MB6971:EE_
X-MS-Office365-Filtering-Correlation-Id: 42e1c516-3b52-4d21-194b-08db0999258f
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: i0qIi5zg1B9QAJ2+/ZCKHv7i+0XzOjlvgoApcbOTCrOS+PAJZ02nx8ZnfXxcCGQXHIgSUe21gD6eamc1MtbfqEGBeCV6mjPHMXVQtZuPjwCJW0UIm2zduEvItWyCotMpF3f2l3UMIlwN6r8Q5Y81ywib27cZXTAxC+6GkNoA/SlAC9Re78eohe1C/o0JvhAD0pdyGBvHv6XNMns2rtItkAUQZvCs+M8+Z7K0VzMGc974j0cgpMQPMppUmZTiMnoKFAnl4fE9mU2zYzvNtCdiI8bAAuoUJajanv9l3iUAF/CNZqBrw5rMLeJ5FwFyZum/WDzy/fryR72EcwdqwiumdpsND6IrBg9xSwxIN8WKFR7Ojb9iEed2wG3wBsCiR4YcSaXGbOxMGK77BvUjUGiO0DN1O5d+ePz4AbQtCZ7aqeFS+Rap6p++hVl60azrzN7ijDYY54i6+CmEmF7rigDY7huiTUygR8tPDDO2PbCLNUe/jJNO3MyQE5Stl948uD5isekmVRkaBo5h/XzY7rgZHTGGATLo8/O3hKLYbZ/kinTITfeQQE7h3pGlAOqR6FVCgJGYUO4XBE0F/3CtR+SMQ2OL5+Ty+IIeJDMO9BH/CJFCaTzsdxeruU/p2jHOqSB6dAwssCp0zANmFJ0ovY8YCw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH8PR11MB8107.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(396003)(136003)(39860400002)(346002)(366004)(376002)(451199018)(41300700001)(38100700002)(6506007)(186003)(26005)(316002)(54906003)(6512007)(9686003)(86362001)(6486002)(478600001)(6666004)(4326008)(8676002)(66476007)(66556008)(66946007)(82960400001)(8936002)(5660300002)(2906002)(83380400001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?PPgUigixzQrkCXvbZEqurV+vzaJkIvkr8VPm1NdOQK6l5CA4iVimcqzkkVsK?=
 =?us-ascii?Q?Pn6wUxac6zjI9nc/y7neAa/jk2foQ3P5HUUmV/OS58FcWncm0iQNg2cgL//l?=
 =?us-ascii?Q?xpWqkIy6huIMeYtyI8mdtkBtpJ3DniOS/RpjrqxijP0bOqahs0YuXEiGIZmR?=
 =?us-ascii?Q?imK58CzfWDmvTTKHC3vm+VrxkFJEDAPLzF6epnMMjNAggUd6S/T1tlvEimLJ?=
 =?us-ascii?Q?S0gjLg3hoUErG9oYTK05Ve8Y0e5XpsDZp3ifFP2CZVF8ncnrRbjIrX/+7O3i?=
 =?us-ascii?Q?UiZTwa2OaCDVCPYP1PbXCXnyMWNPX75c/cr0qxiXoA8woiZqv5TSoIMbWqlJ?=
 =?us-ascii?Q?b6gH+UKdB6XSQNd1YrzbQmN7BBF7wWo1xnq8XwmwAPnvMwuCj+FQWOhqtiLn?=
 =?us-ascii?Q?Vk4RVhGbY4jrmCQDv2tMhpsEJ7GUtu7jitxDA9OxmEGQlGaMjlkeex5BsrJB?=
 =?us-ascii?Q?PQISJaynmhlL/ehY0otG3qf7I2sMYr0zIRo5Au1koaG2zCnD1cMHqtSSjyiX?=
 =?us-ascii?Q?qrDul9nr9a0akysmllb5vu+DRWQIxFIBJgd5CdNQ+7wmzI2hmGaxtsroWp4N?=
 =?us-ascii?Q?VgNQUaFampaorf3lAIGVqaQlPvUxJDNTTrn1SY7BkxkMbNxG03mqHOaMXTXO?=
 =?us-ascii?Q?klU1tr5QOuOlrY1Khb07kZLRjTfFjxcxZXqRGtm3i+43Cb5jSPZTI4JFJcBC?=
 =?us-ascii?Q?DSVIfJSBnlkOBiJ7m5sY5pzkTbLYPX/V1hnYmxGXhY2U/kXOwhO6NlESNVVt?=
 =?us-ascii?Q?uSLvWI2xSS2BvzP2O0bD/Et1aTyNpL22Hhj4utTcJABCnlg1KNVmTNrvrbak?=
 =?us-ascii?Q?akvtst04qkezgr9tKsQB+RkaUVOW85HvmByKVa+fehxbFmBn49Y0EwHWJW3b?=
 =?us-ascii?Q?QkThgAIhRdBAOtwdPnJblyj99uGI7Ty/6i+eHnOTPrJHCRneYStDVNPLmWET?=
 =?us-ascii?Q?0aQs0OA2N6vNqDGVDMLAks549DyKRNWmbsOQ0TvzmIm3TPNv6z3wfsY/+rF9?=
 =?us-ascii?Q?S55DGNhJb9UskMYQHMSheOeGxjPKnosYABcrKm6udJ7Yr6HBJ17SydzuYZNM?=
 =?us-ascii?Q?+aB6bboLYuIQQxZFBEseUSAvmcUulvG3k6pqCOic5W0JXHrOycfUp5O+QZyN?=
 =?us-ascii?Q?EhmCnSniM0SVzpcOlW84qEGXupSLLcSc0TM8c6F9pN71Li8Gzi/sDZB5B85P?=
 =?us-ascii?Q?7CiXA9xqdKtMaH4sWzyz2w0rafybEPWrDs8vIJWzox8nT+Wh1LDifKr1zWAM?=
 =?us-ascii?Q?1j2778prUe5oyU+ixxCpxOsCE5+oppY3M03lUJclFrzNECO+cFS0AIGtwp7F?=
 =?us-ascii?Q?jiEtjahU7ojIXR0644JLSZgV1wHKgEOibVpGEZstVePQ32/p5y4ax4SurjoW?=
 =?us-ascii?Q?vnmGkwQOf4kRewGn2a5YeyswiQrXtAvg2gK+fdeMX9/sOVRjHUixMuPqC1x/?=
 =?us-ascii?Q?eITa6Iq7w/GzZcwWCgdqReaZ/NbbfrIGAYQbf30zUZJP46TzrPtbXzkg9zoF?=
 =?us-ascii?Q?0tfoophCQCaW+A9GlHRbcsKaCZ4sSahdVA6pT+0+K0eJiWwqaEg6MXxeGZdQ?=
 =?us-ascii?Q?bGtnUgJyEj88/R0dxvGZLt2fYj7yq3SjrvYJI0T5EhnPwhNFxMnrPM95N2Kz?=
 =?us-ascii?Q?uw=3D=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 42e1c516-3b52-4d21-194b-08db0999258f
X-MS-Exchange-CrossTenant-AuthSource: PH8PR11MB8107.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Feb 2023 05:55:57.1432
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: l4f/PRwgMUKaoRrnW1D3tc0oWsoQNqo+mFO4zEyJ8GhJ3DhZY+sf5/B0SqaOxzVBd8Zo/pIjGbZXgBPRTwP8G+W5gr+/9IWAnHTlOa3HPHg=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR11MB6971
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

Is @num_cap needed? I.e. if this just does:

    if (cxl_decoder_is_volatile_capable(p->root_decoder))
    	p->mode = CXL_DECODER_MODE_RAM;
    if (cxl_decoder_is_pmem_capable(p->root_decoder))
    	p->mode = CXL_DECODER_MODE_PMEM;

...then it matches the changelog of defaulting to pmem if both types are
set, and otherwise the single capability dominates.
