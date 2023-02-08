Received: from mga02.intel.com (mga02.intel.com [134.134.136.20])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B1FF57F
	for <nvdimm@lists.linux.dev>; Wed,  8 Feb 2023 04:09:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1675829344; x=1707365344;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=RwxTqJYbb7hmm0ZYVM0+wLsc98FswaHWKoyz6+DSCeE=;
  b=NlE4lwUFBaYwIHb+yEly+v2T8jIjCdN4V917OJHmPNxupv9jFAZWuGGQ
   ku6SgeePt/zLuS3j1NA+k8WPHaI86gxg/wegbF6wH1YCB1O/ABtLt6tfg
   cd0HFw9ZqrQbkMuB/6GDh42/jFCi1LzketleKaYcm3QX87c/3bdgyCvmE
   hRNXK0cnk6oattrvrPiR2+cq8liWRu14dkC1haDx6+UH2dQRel8ZUYREA
   NznVYwdszn39NT/e/F9zOYYMulkKhKGc9n9eS7Ese6BKWdBm24wtyPxU6
   RUJNh4WULBeYUPsVLhQNeWWW8CuiOAvNPF2BeUVm9kuHjrLasc3hixLlc
   A==;
X-IronPort-AV: E=McAfee;i="6500,9779,10614"; a="317703435"
X-IronPort-AV: E=Sophos;i="5.97,280,1669104000"; 
   d="scan'208";a="317703435"
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Feb 2023 20:09:04 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10614"; a="699486586"
X-IronPort-AV: E=Sophos;i="5.97,280,1669104000"; 
   d="scan'208";a="699486586"
Received: from fmsmsx602.amr.corp.intel.com ([10.18.126.82])
  by orsmga001.jf.intel.com with ESMTP; 07 Feb 2023 20:09:03 -0800
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Tue, 7 Feb 2023 20:09:02 -0800
Received: from fmsedg601.ED.cps.intel.com (10.1.192.135) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16 via Frontend Transport; Tue, 7 Feb 2023 20:09:02 -0800
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (104.47.55.174)
 by edgegateway.intel.com (192.55.55.70) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.16; Tue, 7 Feb 2023 20:09:02 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=URveKOOcpt0GSDwmYaCw5Yuq2QQkQ+R512gRBRaQq85shr6eVuVSNdENqoZYeHu3hsy9S4rDTuT0aOMtJVbYSDnMrGkUurZB4VmgkyyS2z6wpZbTeCPK0OaFg19PETn6S13/HuErMV5t6fj0AJdJyaTpIK3P+FLaNxxy+XyfIy+9y5CHoTyrn20pwg0zWwEWYLmpG3XYRlnirKSYhqhny3rFg0ATnWrlY8jJbTCMxAjxqNKLANCfzMhMS0AHhiO84fL6RQuXROCcuZWfF8GuqBT03c2hl7rILCtIIcTjnJmZT/jYkgcBg87JH6AfLbPilC2rmZw0BLhwdcv01YUJOQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=JxaSz7lmDc8MI6zZsaix9SvIN1BRibWxPCiGDQNr4rU=;
 b=PT3VmlH4NrL6NgbwFzbFgubVQ3PnzY3F272ud6QEb53nc1eykiXOMxSTtc7rx55rwRBw01D9NOKRWlNeGuRB/tYEOIOk29MLQ7FGEMXtU2790NGG0ROubzOtQpaz74VVY1KOPyoC655rGsQQn9T3oMzqyMoyCMdo7cVyeA6CtxAt3fsmX/Jm558CJM+c2usG3QkPfQYNxyawaxh834aeDWRkBrjFbCjo5m5XGrEXCjfNRBc0cHe506dsrxpY8/gP+0hRyS05grfijXg5OyfdBUwzu+YYUPkn/mAUMeO0W1559F+NezdfsJkmKDv3kQzBTfJDPG7agqdXS88SGnSggw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from SA1PR11MB6733.namprd11.prod.outlook.com (2603:10b6:806:25c::17)
 by DM4PR11MB6287.namprd11.prod.outlook.com (2603:10b6:8:a6::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6064.34; Wed, 8 Feb
 2023 04:08:56 +0000
Received: from SA1PR11MB6733.namprd11.prod.outlook.com
 ([fe80::6851:3db2:1166:dda6]) by SA1PR11MB6733.namprd11.prod.outlook.com
 ([fe80::6851:3db2:1166:dda6%9]) with mapi id 15.20.6064.034; Wed, 8 Feb 2023
 04:08:55 +0000
Date: Tue, 7 Feb 2023 20:08:52 -0800
From: Ira Weiny <ira.weiny@intel.com>
To: Vishal Verma <vishal.l.verma@intel.com>, <linux-cxl@vger.kernel.org>
CC: Gregory Price <gregory.price@memverge.com>, Jonathan Cameron
	<Jonathan.Cameron@huawei.com>, Davidlohr Bueso <dave@stgolabs.net>, "Dan
 Williams" <dan.j.williams@intel.com>, Vishal Verma
	<vishal.l.verma@intel.com>, <nvdimm@lists.linux.dev>
Subject: Re: [PATCH ndctl 6/7] cxl/list: Include regions in the verbose
 listing
Message-ID: <63e320543d413_110c8129456@iweiny-mobl.notmuch>
References: <20230120-vv-volatile-regions-v1-0-b42b21ee8d0b@intel.com>
 <20230120-vv-volatile-regions-v1-6-b42b21ee8d0b@intel.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20230120-vv-volatile-regions-v1-6-b42b21ee8d0b@intel.com>
X-ClientProxiedBy: SJ0PR03CA0265.namprd03.prod.outlook.com
 (2603:10b6:a03:3a0::30) To SA1PR11MB6733.namprd11.prod.outlook.com
 (2603:10b6:806:25c::17)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SA1PR11MB6733:EE_|DM4PR11MB6287:EE_
X-MS-Office365-Filtering-Correlation-Id: d5ababbf-e014-4841-c737-08db098a3240
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 7rDuKMmLaJPO7Y3LLoC6w5nabj7NlHJcv8Rg12CAJU4btxyfBqd7tsOJxAJlL13iKxKsjFU7ywLrT2iFBj1y7/Xwncej4oojMpEfMourDnlVQVoKPa4Yu2yGSzxy14tBd0X3IXvUcPHz5clFC5akyFa7fzPxkaWVL3Ec9DIWVNKJxgehqzUOZ/3T5F9UOmk+AxVksxaIFyx0+BltW2oS9IqkCYFJMqmf5+AHuN+MvcchhjnSqEJ8Ef+CL3yS0AQwpfO2yYOdVjZwLn2tH0c6Vsv0Id2cEfAgGU115cATqFdRiIb64P4fmvApkVGbL4xaFBpxOCnhpR7JGkiLQbhhu9XUwcoDLiL/abcgig61xxiXOmXU4fqOhkINGWFbKSYhw9f9ivoeWzkZyQLAfaTOmAycw+SAeNULMwpGzxx+3mJtEVG0DYiJp0PIEp1AR3MyBVjer04gaDGV5D+uVMKMjxap8sGIx5HZcoZhybK1QYxOwfu1m34sVz/0ZgOZ1TeqTs9vDhnQ8PlYLMw6QI+d4Um8GHggcS8JwEwloeyjbtEoC4pQ63h3/YzCXPICqf/bJzK8md8Kpf9VPf8zLnBLmPFwSNovRi0c0ex3hDLMv5HJFQWCYzW66PvZAtQb2dlOHKZdyAey5vBiup8FHwGNrA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR11MB6733.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(346002)(366004)(136003)(396003)(376002)(39860400002)(451199018)(5660300002)(86362001)(478600001)(38100700002)(82960400001)(316002)(6486002)(54906003)(8936002)(6666004)(41300700001)(44832011)(6512007)(66556008)(66476007)(4744005)(4326008)(186003)(66946007)(8676002)(6506007)(9686003)(26005)(2906002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?5ujtLhsZZBiwWAigt33t8k9w07Z9gizgg90woUbura7Ch/ejmoFTKm0ahvwz?=
 =?us-ascii?Q?Peos5WYO/w7HFAfLClu7kZYptm76n160GiCUF7lkcxxfqiiDNQeL2ZWk8Qe5?=
 =?us-ascii?Q?wHZeb3yvfWoHaFHjY0Ymi8RhpvjX5qGOYkFsRJ/FoELBx+aEzOmuSffN7pWW?=
 =?us-ascii?Q?ki/YuL1r7iIvRixWrfDn/09udOyWhTY/DuJuQJxAF9i90s6wRcDcbSmO3B+N?=
 =?us-ascii?Q?vBtnZ7UpF+7S7SuK0OTsBokZb9GIJLxOFHTR5Og7Fmp1DUIUv0giXOtkrFHq?=
 =?us-ascii?Q?JIblbnpqOnNDhh2n18ez3lnSrLQ+9nftuENoM618/TU+vSb8TRDioI8YEqc4?=
 =?us-ascii?Q?z5IgV6LSu+dstRRRXWYE9fo8OV4k1aOEDPiEdVTfh9hs3WY2goYxp300Fpwm?=
 =?us-ascii?Q?OFBIZUXu/zNm/fq8Swg8sox07Ve4eZgeTds10Bw2c4DqoObk05yt8qQOCXpc?=
 =?us-ascii?Q?3Ut9QN6khV70aABOy/ygb+qC913PL0FlAx8sDw/SMmY7bskzCEzzaCxE++HF?=
 =?us-ascii?Q?A3xxzM4bstvJLUJAHQw+vUinyIJvGzdeFy0TL0ujy7hwAczUZWACGA6n4yJs?=
 =?us-ascii?Q?KQ20yBads/zEL+sGd4ZKwT48DIERoZpC0hD9FVLoBMhffkSaXseX3uIQPUZ+?=
 =?us-ascii?Q?/2st00U1Dt1CtpD7dHnTbV4fs3MF3S9KVRKr3XrFjE+FQAjPPclHMdwuAVjF?=
 =?us-ascii?Q?d2nqHi+8R2uGFyEErtYRe6SvYitjtpNDC1C1qME/Z9SCQt8NaqjaN+LYR9qG?=
 =?us-ascii?Q?xmByMsF7wT5iC3PXGhLnbH/WVZfzpHNPr+uyuAv31djOxqU6c0+N1iR73Hom?=
 =?us-ascii?Q?5RRppYdiQFEmYYSsrRlcX/gNtd+kMFOArYKk00AUHjnZ4nG3bv3R1iAW0A8c?=
 =?us-ascii?Q?rxALPKNv2MbxYzwJ1p1vr3M5qHI/e+dePgx4+x6/AeQTu3tFG+7NOQAmIQAS?=
 =?us-ascii?Q?ScNCKh6vBZOF19geiL+yq9LhrJsIpHAAE7rGL1MGZeObkT8pvRaN2YjE6P1z?=
 =?us-ascii?Q?exg9hvq8H88uApLahoBHPhLS1jXAPDHCeJDDyalh9YeQetO8wteWOtci75+S?=
 =?us-ascii?Q?1axqMQaIWEjLcgXkBzcy/A+DSnPXlTV0yxKHLW0sYhxDjToIavaaSCGPq6OB?=
 =?us-ascii?Q?8pqBp4/iVx6iFKZOfrdNqKwiBbP4B5RxUUB2ObwJu+bxBbBWhMeiUpGW7fwo?=
 =?us-ascii?Q?0ZmklK2G9wMqltuT++fEBOVrzYsAI6mHoC9D3goqqMyyyTqi9ioMsqkumQrp?=
 =?us-ascii?Q?NTQWRLyjCGcD3GX3UhQjNIOGF/p1gC7AxjPSKSm+DsXy2vq7EOgFBgWA8qHK?=
 =?us-ascii?Q?DY0i4w6Em+w/3cXHxb48ErnubPzLIrB6jJHFEM2d0fPdGh93mRVwOjwpWbp+?=
 =?us-ascii?Q?8pB2fBlsmJo+D51489totMDfYRGUJ5G+LCcYuPbXdWZJT9NDLXB8Fzr6kF6c?=
 =?us-ascii?Q?VL5GrxYFh8LK8gkFZZFpPs+sDYrEIowamTXGUVzsIlk8ocdFllc2lQLwLDWQ?=
 =?us-ascii?Q?1ZHioBSWL9yslGWGmKhAecryHaFFok37/buT+iklfglRkvjjklESCBnhLI0w?=
 =?us-ascii?Q?uCDAi/hyfLF5Jb7QgQoMu0O6t5wya4pDodkKA28D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: d5ababbf-e014-4841-c737-08db098a3240
X-MS-Exchange-CrossTenant-AuthSource: SA1PR11MB6733.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Feb 2023 04:08:55.7861
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: REUvP5HggnsGQ1kim86QomhP2ubAEpxip6ZaUWMw5oxk2txOM3x0rADB0cowO1rnsl0YRVfFKCKb0C8xLLI7ww==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR11MB6287
X-OriginatorOrg: intel.com

Vishal Verma wrote:
> From: Dan Williams <dan.j.williams@intel.com>
> 
> When verbose listing was added, region listing support was not available, so
> it got missed. Add it now.
> 

Reviewed-by: Ira Weiny <ira.weiny@intel.com>

> Signed-off-by: Dan Williams <dan.j.williams@intel.com>
> Signed-off-by: Vishal Verma <vishal.l.verma@intel.com>
> ---
>  cxl/list.c | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/cxl/list.c b/cxl/list.c
> index e3ef1fb..4e77aeb 100644
> --- a/cxl/list.c
> +++ b/cxl/list.c
> @@ -126,6 +126,7 @@ int cmd_list(int argc, const char **argv, struct cxl_ctx *ctx)
>  		param.endpoints = true;
>  		param.decoders = true;
>  		param.targets = true;
> +		param.regions = true;
>  		/*fallthrough*/
>  	case 0:
>  		break;
> 
> -- 
> 2.39.1
> 


