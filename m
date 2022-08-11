Received: from mga12.intel.com (mga12.intel.com [192.55.52.136])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6344820E7
	for <nvdimm@lists.linux.dev>; Thu, 11 Aug 2022 03:05:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1660187140; x=1691723140;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=kZXDxUtc/JpV99OrpVt86d3Jw+DI21nXyqexKl7jRDA=;
  b=Z5810eicytT1X9xBX79BH5XpUAgbkCHDsIrdu81ryPVhfziSJ9XWFWyU
   jyjzmvagyVXVCGecPqnfSEuV7T9lbLz1GKszRpHgyV7iA66ZO0W89htRL
   M5UmCYrm09k36P1W9f+u18RChqk7WxfjfeCe2MlN9VASd0sy+ajoImXry
   Nv6NY2Soz4Cm/JFn1/ZAmgwHLt/g/QreIJPVAWfQb5s8DIN1N4AMxZJeB
   pywc+nOl65WSRi5i8K8EPFCvGmBpiWk0Q9/vgbZUAW2LLlbxsUYuVt5Jp
   crx3DUPFCfVEVQmgGGPCAMMts3+8KkM4CNbnv6QyEXEZSHLVLBd9usCqG
   Q==;
X-IronPort-AV: E=McAfee;i="6400,9594,10435"; a="271020718"
X-IronPort-AV: E=Sophos;i="5.93,228,1654585200"; 
   d="scan'208";a="271020718"
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Aug 2022 20:05:39 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.93,228,1654585200"; 
   d="scan'208";a="581487048"
Received: from fmsmsx603.amr.corp.intel.com ([10.18.126.83])
  by orsmga006.jf.intel.com with ESMTP; 10 Aug 2022 20:05:37 -0700
Received: from fmsmsx611.amr.corp.intel.com (10.18.126.91) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.28; Wed, 10 Aug 2022 20:05:36 -0700
Received: from fmsmsx608.amr.corp.intel.com (10.18.126.88) by
 fmsmsx611.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.28; Wed, 10 Aug 2022 20:05:36 -0700
Received: from fmsedg602.ED.cps.intel.com (10.1.192.136) by
 fmsmsx608.amr.corp.intel.com (10.18.126.88) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.28 via Frontend Transport; Wed, 10 Aug 2022 20:05:36 -0700
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (104.47.66.46) by
 edgegateway.intel.com (192.55.55.71) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2375.28; Wed, 10 Aug 2022 20:05:36 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=dE5XECQMb+F+KBUzSLv0WGwYemaeSOoh3HJg3XZBB9O3Dk62FGzyru8ohaTXCbsRHmRX4ZJVKCEeKheEfr3gaSAZUoFnVrjC/kyLgn1v+K9gqdINm+U0zVoj+B6Ndg/nSc8BVrt9gO7LPNOBC5Ywbg7c6aETW0eFHXO8sM8GuvBIObGWzqVRvwmG8xwFjnJ3ZSdHBlsnNVjl+wOcxmQ2kZEs8AG8WqP62MdsxvwINFtCyYrZT0HMtkqIo9zYe2btmoVWIzsMnr0LN5IAZVz3P+NgnqPZJMQ4QORXAD4ire5juAgl5XJnjGXdCF2fLdPaIcbhKQFtHjXgwQ4SUFf5+g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=EGLru0YGb2Aee73IPoKjUvV6LH4TMb0CiO17HSsiMn4=;
 b=mJMWFQAxKBTLnKOxufcpiZEX9TQRmuC5c2sec7/ydYxYt4R8yWAjb5luKNOWwO3FAD4vIFYr2Jq3EWiynE7Cu1RiwqcE7TTTQd+Y0L/d7wE+hQUpfdgzTzu/TSHdiIAqxI7cZYjvrJAD+ke2el1y6Zum9DtrUgOTd1EKlwGXNqDiitEcO49o0vctsfhSypUqxCgiphvJ4jXSvPCiKWsfD1ReXM/BJac0uGn6oYzT5VRpC7KGlz1bo+rWIgmIKCI+ZK4v9LPBZDtXmOzt6kAqIAR+brhQaMx/ykA+ZHlNgBVRPt+Xr8eny1NeL9lXv5q3bAVLusU2Wbn4PmleelkP4w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from MWHPR1101MB2126.namprd11.prod.outlook.com
 (2603:10b6:301:50::20) by CH0PR11MB5284.namprd11.prod.outlook.com
 (2603:10b6:610:bf::8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5525.11; Thu, 11 Aug
 2022 03:05:34 +0000
Received: from MWHPR1101MB2126.namprd11.prod.outlook.com
 ([fe80::9847:345e:4c5b:ca12]) by MWHPR1101MB2126.namprd11.prod.outlook.com
 ([fe80::9847:345e:4c5b:ca12%6]) with mapi id 15.20.5504.023; Thu, 11 Aug 2022
 03:05:34 +0000
Date: Wed, 10 Aug 2022 20:05:31 -0700
From: Dan Williams <dan.j.williams@intel.com>
To: Vishal Verma <vishal.l.verma@intel.com>, <linux-cxl@vger.kernel.org>
CC: <nvdimm@lists.linux.dev>, Dan Williams <dan.j.williams@intel.com>, "Alison
 Schofield" <alison.schofield@intel.com>, Ira Weiny <ira.weiny@intel.com>,
	Dave Jiang <dave.jiang@intel.com>, Vishal Verma <vishal.l.verma@intel.com>
Subject: RE: [ndctl PATCH v2 05/10] libcxl: add low level APIs for region
 creation
Message-ID: <62f471fbd22a2_7168c29410@dwillia2-xfh.jf.intel.com.notmuch>
References: <20220810230914.549611-1-vishal.l.verma@intel.com>
 <20220810230914.549611-6-vishal.l.verma@intel.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20220810230914.549611-6-vishal.l.verma@intel.com>
X-ClientProxiedBy: BY5PR20CA0030.namprd20.prod.outlook.com
 (2603:10b6:a03:1f4::43) To MWHPR1101MB2126.namprd11.prod.outlook.com
 (2603:10b6:301:50::20)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 543483b7-f43b-4342-6d9a-08da7b465b80
X-MS-TrafficTypeDiagnostic: CH0PR11MB5284:EE_
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: waA8Rwz80WClO8ciLkhbSyowg8+JwKL/97yRQKc3UpNw+/mqWNUDCPGYcuEF/e2dp5b45pUtwu3gkfdleaHGCCOEauGGuYUbUv3g8yZ5cvaSGD3Ode3gTNaJZfG1cX4bFhOdrTucLbsBtNwufufFVCm1Mx882b2vulHq9aJDzZNMVX/vitIHoofz2uBeUGGBsupd2LeHbifVDovKL/AtTSWryrqvSCzEKPsgg1ZBtSwv+KAgGhKHyQ/5B2YoHKZfVGgBu7X3GAAnohDnsoJtpVnJc/vm4k5IkwlZLELQPXynBymFh9T0T/rZT2Z9flltkrWgNyp+9l+oSGfYu9yMNj5rPx9NP+5jrOtcfmEAAJmmv6XUgM0LsAQzBJf89HYlBYaRuddbR7xQfx3thYze1SIMH0rLuHyRM4Ob9taG9N839uAzw+UCqA8hyWsdBORBr2X7lV1Zgx1Vcz2LqYzo2zT6ThELLpBH8WUr9umLc/kBAan2X6ZuJCa8kTqXiqY6w3L7bGOsSZBzK2q8T50C8hIKu74dGFx9gOYgmgYq++69WZozsif+bD+Y1y+hCzD4Wvm+zDjAuWXkVbZ1JF+/th9USwgXjBJH1c/ah3z+092AUOyD+jeSsl2FZOphLTEMUgcQKCgwvkPgZ9gy7lqugejYUws3pnvCstGfIbosQooUIC8Rxaliy2qqR8eDOPpZdraMPntFBJjuBPOPu+D970WAYxRKLgzl0pgvWITyWS0HtynqpBB7n7FRDbOz7nbM
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR1101MB2126.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(396003)(376002)(346002)(39860400002)(366004)(136003)(6486002)(478600001)(41300700001)(82960400001)(38100700002)(86362001)(6512007)(6666004)(6506007)(26005)(9686003)(186003)(54906003)(83380400001)(107886003)(316002)(8936002)(66946007)(5660300002)(4326008)(8676002)(66556008)(66476007)(30864003)(2906002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?dG6YD+ov/ryK9pmcl1LVacablp/WdmmKsQGQNxa1lz2tx9jg773mH6fb7wPg?=
 =?us-ascii?Q?RVDImcoKGf5AOB36ZcqzJPsqcj9JElKsD7VKXOKE8LdJM8hZGa7zWd6wdeoi?=
 =?us-ascii?Q?YHL0ptmeTAuJhh/aBPRU7w4sO/gFiGJ0ZIAYFzpD09uREL4h7bRzfysPvpNp?=
 =?us-ascii?Q?DjGMcDeO4bg/eAfCKvSdgdc6S2rA0q6yHvloionJrAol49sWnhkUbESgZ3Pw?=
 =?us-ascii?Q?EKFm0WYavRtXRCeaaiTlwg9F4nfRw2vvrb6h7rdYrfPc5m2CFTmID0tZbeZI?=
 =?us-ascii?Q?fs4qpxC8THe12dGJ/uyTWKYtYTD+WGcDVJESCNq9Mcs5SOhbPnbi00h70JZV?=
 =?us-ascii?Q?gR4pR48yiWQR1ZAnwvHiWB/bjAk9M4JP4AuJYHXN24G6DNtmPf3vUwN0Zh9a?=
 =?us-ascii?Q?zlRYieRRo/3/nKzBzRvstwPhAJhU95HhsR2P+Rl7weLuZKuvMGxZpGAL/x/t?=
 =?us-ascii?Q?nHwAkAbD2GNQfh/wAxkx6SULYPunVNU8cDQFXWOVjb89U8+DXekF42mWm/HT?=
 =?us-ascii?Q?l6P0tTa7sMBV3J9gRH8ChzFAc2f4sDO9dM/ygBznS32uOLKeEk1WOBp8xyDa?=
 =?us-ascii?Q?Pell1zOEvWkY4t4KRJyrYwFl/kiR73VeEwJN/WIbNgg5lpwNhqMLvyMuXVL/?=
 =?us-ascii?Q?TyJ8tRgKoyPiL4DCpAQ/tqXSyrobL/MN0bzCd0sMj9KkkHFC5udwskv2uzBa?=
 =?us-ascii?Q?rHVTzNoNhnuRbkitgIKNloYUjDSR8F7KV7kTb1gXiAhedJCraJdri2a6/Mf8?=
 =?us-ascii?Q?pjwErKo/MhJJEJgaTnUqml6KB+/8nOffndqdkzl2oVhA8rpwblCWEuHPE+6M?=
 =?us-ascii?Q?jLKan0/mpNkI7w/vLZUcWtz8I/2hzjxr25JOKVGqHwRqI+1r6psWkMumzyMp?=
 =?us-ascii?Q?pFVbDXX1O8Mhy2ODBW4BfH3L6xVm/OZYUOwW5HtIftYWm1lnxerRtspwWx4A?=
 =?us-ascii?Q?P7lOXVsyh+zD2iafaKqPvKKQeOkr3EjOSWNbQY01MMIsJwgQFM80dL6bacbX?=
 =?us-ascii?Q?SpP5snK3NeOcJhx0M/7owe0unhJCNwNzBy4ADJPQ+kPTbLOlJc0/KtCUcuMw?=
 =?us-ascii?Q?cSFSjB4BfKtTpjWmscJi+dSkLfz1KNELHZxy0tjm3ESL2in0c7GTuIMF6uMZ?=
 =?us-ascii?Q?r9GxU4BwQh9DPYEGx24LNmPjIoN3Kfe9Te1wkQjajyKiuU9nI0MU+CCGF+LM?=
 =?us-ascii?Q?+b0c/MTX5KuSmhDds/FoYJujHjvZvV4kg9hOBuzpQXBJC5MzBq9rkudfiKQE?=
 =?us-ascii?Q?fvP1JyUhsYmj4wLBpOpvRY9QuESSjdlIuVbNME9RYF3iX2WIbnT+btriNUGU?=
 =?us-ascii?Q?Fsa0+sEIfEErY06tOo3LhCpS5LHO5h/LWCck9PP//OBLzNaWOWJThHDSH/tt?=
 =?us-ascii?Q?KslrPqB3YIf3aqo6Rj4ZCtqWEwMWumgMrC055h4TdCeU/8pJuzcryReNlt3f?=
 =?us-ascii?Q?wPZ304+reHEJ3J20vqGXi9zrzTEzhSMEKgpvXytiP/TD8epUIOe349MNPQ+q?=
 =?us-ascii?Q?OVEeYjxs1vCcW2S4A0M01jkYAHKsN+ahF+PN06KQ01fBGESBFd6XF3Ff64ed?=
 =?us-ascii?Q?/OJsSmhGPqhW14noBSq8AQ74FgQOuDWkG7o5gjVFTqljd7QTtUNrYFXlxV9A?=
 =?us-ascii?Q?ew=3D=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 543483b7-f43b-4342-6d9a-08da7b465b80
X-MS-Exchange-CrossTenant-AuthSource: MWHPR1101MB2126.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Aug 2022 03:05:34.1135
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: CyH6E0aGD7nMQrqBuvJJc3SNoIpEJchJHh3lGUYwOZFzPy9eLuMRw9bMB/+Sv6geIN7ByRtY4IXLqMhToNdiYJhoQg1SnfPIz86NVmYvt80=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH0PR11MB5284
X-OriginatorOrg: intel.com

Vishal Verma wrote:
> Add libcxl APIs to create a region under a given root decoder, and to
> set different attributes for the new region. These allow setting the
> size, interleave_ways, interleave_granularity, uuid, and the target
> devices for the newly minted cxl_region object.
> 
> Cc: Dan Williams <dan.j.williams@intel.com>
> Signed-off-by: Vishal Verma <vishal.l.verma@intel.com>
> ---
>  Documentation/cxl/lib/libcxl.txt |  69 ++++++
>  cxl/lib/private.h                |   2 +
>  cxl/lib/libcxl.c                 | 377 ++++++++++++++++++++++++++++++-
>  cxl/libcxl.h                     |  23 +-
>  cxl/lib/libcxl.sym               |  16 ++
>  5 files changed, 484 insertions(+), 3 deletions(-)
> 
> diff --git a/Documentation/cxl/lib/libcxl.txt b/Documentation/cxl/lib/libcxl.txt
> index 7a38ce4..c3a8f36 100644
> --- a/Documentation/cxl/lib/libcxl.txt
> +++ b/Documentation/cxl/lib/libcxl.txt
> @@ -508,6 +508,75 @@ device to represent the root of a PCI device hierarchy. The
>  cxl_target_get_physical_node() helper returns the device name of that
>  companion object in the PCI hierarchy.
>  
> +==== REGIONS
> +A CXL region is composed of one or more slices of CXL memdevs, with configurable
> +interleave settings - both the number of interleave ways, and the interleave
> +granularity. In terms of hierarchy, it is the child of a CXL root decoder. A root
> +decoder (recall that this corresponds to an ACPI CEDT.CFMWS 'window'), may have
> +multiple chile regions, but a region is strictly tied to one root decoder.

Mmm, that's a spicy region.

s/chile/child/

> +
> +A region also defines a set of mappings which are slices of capacity on a memdev,

Since the above already defined that a region is composed of one or more
slices of CXL memdevs, how about:

"The slices that compose a region are called mappings. A mapping is a
tuple of 'memdev', 'endpoint decoder', and the 'position'.

> +each represented by an endpoint decoder.
> +
> +===== REGION: Enumeration
> +----
> +struct cxl_region *cxl_region_get_first(struct cxl_decoder *decoder);
> +struct cxl_region *cxl_region_get_next(struct cxl_region *region);
> +
> +#define cxl_region_foreach(decoder, region)                                    \
> +	for (region = cxl_region_get_first(decoder); region != NULL;           \
> +	     region = cxl_region_get_next(region))
> +
> +#define cxl_region_foreach_safe(decoder, region, _region)                      \
> +	for (region = cxl_region_get_first(decoder),                           \
> +	     _region = region ? cxl_region_get_next(region) : NULL;            \
> +	     region != NULL;                                                   \
> +	     region = _region,                                                 \
> +	     _region = _region ? cxl_region_get_next(_region) : NULL)
> +----
> +
> +===== REGION: Attributes
> +----
> +int cxl_region_get_id(struct cxl_region *region);
> +const char *cxl_region_get_devname(struct cxl_region *region);
> +void cxl_region_get_uuid(struct cxl_region *region, uuid_t uu);
> +unsigned long long cxl_region_get_size(struct cxl_region *region);
> +unsigned long long cxl_region_get_resource(struct cxl_region *region);
> +unsigned int cxl_region_get_interleave_ways(struct cxl_region *region);
> +unsigned int cxl_region_get_interleave_granularity(struct cxl_region *region);
> +struct cxl_decoder *cxl_region_get_target_decoder(struct cxl_region *region,
> +						  int position);
> +int cxl_region_set_size(struct cxl_region *region, unsigned long long size);
> +int cxl_region_set_uuid(struct cxl_region *region, uuid_t uu);
> +int cxl_region_set_interleave_ways(struct cxl_region *region,
> +				   unsigned int ways);
> +int cxl_region_set_interleave_granularity(struct cxl_region *region,
> +					  unsigned int granularity);
> +int cxl_region_set_target(struct cxl_region *region, int position,
> +			  struct cxl_decoder *decoder);
> +int cxl_region_clear_target(struct cxl_region *region, int position);
> +int cxl_region_clear_all_targets(struct cxl_region *region);
> +int cxl_region_decode_commit(struct cxl_region *region);
> +int cxl_region_decode_reset(struct cxl_region *region);
> +----
> +
> +A region's resource attribute is the Host Physical Address at which the region's
> +address space starts. The region's address space is a subset of the parent root
> +decoder's address space.
> +
> +The interleave ways is the number of component memdevs participating in the
> +region.
> +
> +The interleave granularity depends on the root decoder's granularity, and must
> +follow the interleave math rules defined in the CXL spec.
> +
> +Regions have a list of targets 0..N, which are programmed with the name of an
> +endpoint decoder under each participating memdev.
> +
> +The 'decode_commit' and 'decode_reset' attributes reserve and free DPA space
> +on a given memdev by allocating an endpoint decoder, and programming it based
> +on the region's interleave geometry.
> +
>  include::../../copyright.txt[]
>  
>  SEE ALSO
> diff --git a/cxl/lib/private.h b/cxl/lib/private.h
> index da49a6c..8619bb1 100644
> --- a/cxl/lib/private.h
> +++ b/cxl/lib/private.h
> @@ -110,6 +110,8 @@ struct cxl_decoder {
>  	int nr_targets;
>  	int id;
>  	enum cxl_decoder_mode mode;
> +	unsigned int interleave_ways;
> +	unsigned int interleave_granularity;
>  	bool pmem_capable;
>  	bool volatile_capable;
>  	bool mem_capable;
> diff --git a/cxl/lib/libcxl.c b/cxl/lib/libcxl.c
> index 8dd804c..b4d7890 100644
> --- a/cxl/lib/libcxl.c
> +++ b/cxl/lib/libcxl.c
> @@ -17,6 +17,7 @@
>  #include <ccan/minmax/minmax.h>
>  #include <ccan/array_size/array_size.h>
>  #include <ccan/short_types/short_types.h>
> +#include <ccan/container_of/container_of.h>
>  
>  #include <util/log.h>
>  #include <util/list.h>
> @@ -412,6 +413,39 @@ CXL_EXPORT int cxl_region_enable(struct cxl_region *region)
>  	return 0;
>  }
>  
> +static int cxl_region_delete_name(struct cxl_decoder *decoder,
> +				  const char *devname)
> +{
> +	struct cxl_ctx *ctx = cxl_decoder_get_ctx(decoder);
> +	char *path = decoder->dev_buf;
> +	int rc;
> +
> +	sprintf(path, "%s/delete_region", decoder->dev_path);
> +	rc = sysfs_write_attr(ctx, path, devname);
> +	if (rc != 0) {
> +		err(ctx, "error deleting region: %s\n", strerror(-rc));
> +		return rc;
> +	}
> +	return 0;
> +}
> +
> +CXL_EXPORT int cxl_region_delete(struct cxl_region *region)
> +{
> +	struct cxl_decoder *decoder = cxl_region_get_decoder(region);
> +	const char *devname = cxl_region_get_devname(region);
> +	int rc;
> +
> +	if (cxl_region_is_enabled(region))
> +		return -EBUSY;
> +
> +	rc = cxl_region_delete_name(decoder, devname);
> +	if (rc != 0)
> +		return rc;
> +
> +	free_region(region);
> +	return 0;
> +}
> +
>  static void *add_cxl_region(void *parent, int id, const char *cxlregion_base)
>  {
>  	const char *devname = devpath_to_devname(cxlregion_base);
> @@ -589,6 +623,258 @@ cxl_region_get_interleave_granularity(struct cxl_region *region)
>  	return region->interleave_granularity;
>  }
>  
> +CXL_EXPORT struct cxl_decoder *
> +cxl_region_get_target_decoder(struct cxl_region *region, int position)
> +{
> +	const char *devname = cxl_region_get_devname(region);
> +	struct cxl_ctx *ctx = cxl_region_get_ctx(region);
> +	int len = region->buf_len, rc;
> +	char *path = region->dev_buf;
> +	struct cxl_decoder *decoder;
> +	char buf[SYSFS_ATTR_SIZE];
> +
> +	if (snprintf(path, len, "%s/target%d", region->dev_path, position) >=
> +	    len) {
> +		err(ctx, "%s: buffer too small!\n", devname);
> +		return NULL;
> +	}
> +
> +	rc = sysfs_read_attr(ctx, path, buf);
> +	if (rc < 0) {
> +		err(ctx, "%s: error reading target%d: %s\n", devname,
> +		    position, strerror(-rc));
> +		return NULL;
> +	}
> +
> +	decoder = cxl_decoder_get_by_name(ctx, buf);
> +	if (!decoder) {
> +		err(ctx, "%s: error locating decoder for target%d\n", devname,
> +		    position);
> +		return NULL;
> +	}
> +	return decoder;
> +}
> +
> +CXL_EXPORT int cxl_region_set_size(struct cxl_region *region,
> +				   unsigned long long size)
> +{
> +	const char *devname = cxl_region_get_devname(region);
> +	struct cxl_ctx *ctx = cxl_region_get_ctx(region);
> +	int len = region->buf_len, rc;
> +	char *path = region->dev_buf;
> +	char buf[SYSFS_ATTR_SIZE];
> +
> +	if (size == 0) {
> +		dbg(ctx, "%s: cannot use %s to delete a region\n", __func__,
> +		    devname);
> +		return -EINVAL;
> +	}
> +
> +	if (snprintf(path, len, "%s/size", region->dev_path) >= len) {
> +		err(ctx, "%s: buffer too small!\n", devname);
> +		return -ENXIO;
> +	}
> +
> +	sprintf(buf, "%#llx\n", size);
> +	rc = sysfs_write_attr(ctx, path, buf);
> +	if (rc < 0)
> +		return rc;
> +
> +	region->size = size;
> +
> +	return 0;
> +}
> +
> +CXL_EXPORT int cxl_region_set_uuid(struct cxl_region *region, uuid_t uu)
> +{
> +	const char *devname = cxl_region_get_devname(region);
> +	struct cxl_ctx *ctx = cxl_region_get_ctx(region);
> +	int len = region->buf_len, rc;
> +	char *path = region->dev_buf;
> +	char uuid[SYSFS_ATTR_SIZE];
> +
> +	if (snprintf(path, len, "%s/uuid", region->dev_path) >= len) {
> +		err(ctx, "%s: buffer too small!\n", devname);
> +		return -ENXIO;
> +	}
> +
> +	uuid_unparse(uu, uuid);
> +	rc = sysfs_write_attr(ctx, path, uuid);
> +	if (rc != 0)
> +		return rc;
> +	memcpy(region->uuid, uu, sizeof(uuid_t));
> +	return 0;
> +}
> +
> +CXL_EXPORT int cxl_region_set_interleave_ways(struct cxl_region *region,
> +					      unsigned int ways)
> +{
> +	const char *devname = cxl_region_get_devname(region);
> +	struct cxl_ctx *ctx = cxl_region_get_ctx(region);
> +	int len = region->buf_len, rc;
> +	char *path = region->dev_buf;
> +	char buf[SYSFS_ATTR_SIZE];
> +
> +	if (snprintf(path, len, "%s/interleave_ways",
> +		     region->dev_path) >= len) {
> +		err(ctx, "%s: buffer too small!\n", devname);
> +		return -ENXIO;
> +	}
> +
> +	sprintf(buf, "%u\n", ways);
> +	rc = sysfs_write_attr(ctx, path, buf);
> +	if (rc < 0)
> +		return rc;
> +
> +	region->interleave_ways = ways;
> +
> +	return 0;
> +}
> +
> +CXL_EXPORT int cxl_region_set_interleave_granularity(struct cxl_region *region,
> +						     unsigned int granularity)
> +{
> +	const char *devname = cxl_region_get_devname(region);
> +	struct cxl_ctx *ctx = cxl_region_get_ctx(region);
> +	int len = region->buf_len, rc;
> +	char *path = region->dev_buf;
> +	char buf[SYSFS_ATTR_SIZE];
> +
> +	if (snprintf(path, len, "%s/interleave_granularity",
> +		     region->dev_path) >= len) {
> +		err(ctx, "%s: buffer too small!\n", devname);
> +		return -ENXIO;
> +	}
> +
> +	sprintf(buf, "%u\n", granularity);
> +	rc = sysfs_write_attr(ctx, path, buf);
> +	if (rc < 0)
> +		return rc;
> +
> +	region->interleave_granularity = granularity;
> +
> +	return 0;
> +}
> +
> +static int region_write_target(struct cxl_region *region, int position,
> +			       struct cxl_decoder *decoder)
> +{
> +	const char *devname = cxl_region_get_devname(region);
> +	struct cxl_ctx *ctx = cxl_region_get_ctx(region);
> +	int len = region->buf_len, rc;
> +	char *path = region->dev_buf;
> +	const char *dec_name = "";
> +
> +	if (decoder)
> +		dec_name = cxl_decoder_get_devname(decoder);
> +
> +	if (snprintf(path, len, "%s/target%d", region->dev_path, position) >=
> +	    len) {
> +		err(ctx, "%s: buffer too small!\n", devname);
> +		return -ENXIO;
> +	}
> +
> +	rc = sysfs_write_attr(ctx, path, dec_name);
> +	if (rc < 0)
> +		return rc;
> +
> +	return 0;
> +}
> +
> +CXL_EXPORT int cxl_region_set_target(struct cxl_region *region, int position,
> +				     struct cxl_decoder *decoder)
> +{
> +	if (!decoder)
> +		return -ENXIO;
> +
> +	return region_write_target(region, position, decoder);
> +}
> +
> +CXL_EXPORT int cxl_region_clear_target(struct cxl_region *region, int position)
> +{
> +	const char *devname = cxl_region_get_devname(region);
> +	struct cxl_ctx *ctx = cxl_region_get_ctx(region);
> +	int rc;
> +
> +	if (cxl_region_is_enabled(region)) {
> +		err(ctx, "%s: can't clear targets on an active region\n",
> +		    devname);
> +		return -EBUSY;
> +	}
> +
> +	rc = region_write_target(region, position, NULL);
> +	if (rc) {
> +		err(ctx, "%s: error clearing target%d: %s\n",
> +		    devname, position, strerror(-rc));
> +		return rc;
> +	}
> +
> +	return 0;
> +}
> +
> +CXL_EXPORT int cxl_region_clear_all_targets(struct cxl_region *region)
> +{
> +	const char *devname = cxl_region_get_devname(region);
> +	struct cxl_ctx *ctx = cxl_region_get_ctx(region);
> +	unsigned int ways, i;
> +	int rc;
> +
> +	if (cxl_region_is_enabled(region)) {
> +		err(ctx, "%s: can't clear targets on an active region\n",
> +		    devname);
> +		return -EBUSY;
> +	}
> +
> +	ways = cxl_region_get_interleave_ways(region);
> +	if (ways == 0 || ways == UINT_MAX)
> +		return -ENXIO;
> +
> +	for (i = 0; i < ways; i++) {
> +		rc = region_write_target(region, i, NULL);
> +		if (rc) {
> +			err(ctx, "%s: error clearing target%d: %s\n",
> +			    devname, i, strerror(-rc));
> +			return rc;
> +		}
> +	}
> +
> +	return 0;
> +}
> +
> +static int set_region_decode(struct cxl_region *region,
> +			     enum cxl_decode_state decode_state)
> +{
> +	const char *devname = cxl_region_get_devname(region);
> +	struct cxl_ctx *ctx = cxl_region_get_ctx(region);
> +	int len = region->buf_len, rc;
> +	char *path = region->dev_buf;
> +	char buf[SYSFS_ATTR_SIZE];
> +
> +	if (snprintf(path, len, "%s/commit", region->dev_path) >= len) {
> +		err(ctx, "%s: buffer too small!\n", devname);
> +		return -ENXIO;
> +	}
> +
> +	sprintf(buf, "%d\n", decode_state);
> +	rc = sysfs_write_attr(ctx, path, buf);
> +	if (rc < 0)
> +		return rc;
> +
> +	region->decode_state = decode_state;
> +
> +	return 0;
> +}
> +
> +CXL_EXPORT int cxl_region_decode_commit(struct cxl_region *region)
> +{
> +	return set_region_decode(region, CXL_DECODE_COMMIT);
> +}
> +
> +CXL_EXPORT int cxl_region_decode_reset(struct cxl_region *region)
> +{
> +	return set_region_decode(region, CXL_DECODE_RESET);
> +}
> +
>  static struct cxl_decoder *__cxl_port_match_decoder(struct cxl_port *port,
>  						    const char *ident)
>  {
> @@ -623,8 +909,8 @@ static struct cxl_decoder *cxl_port_find_decoder(struct cxl_port *port,
>  	return NULL;
>  }
>  
> -static struct cxl_decoder *cxl_decoder_get_by_name(struct cxl_ctx *ctx,
> -						   const char *ident)
> +CXL_EXPORT struct cxl_decoder *cxl_decoder_get_by_name(struct cxl_ctx *ctx,
> +						       const char *ident)
>  {
>  	struct cxl_bus *bus;
>  
> @@ -1387,6 +1673,18 @@ static void *add_cxl_decoder(void *parent, int id, const char *cxldecoder_base)
>  	} else
>  		decoder->mode = CXL_DECODER_MODE_NONE;
>  
> +	sprintf(path, "%s/interleave_granularity", cxldecoder_base);
> +	if (sysfs_read_attr(ctx, path, buf) < 0)
> +		decoder->interleave_granularity = UINT_MAX;
> +	else
> +		decoder->interleave_granularity = strtoul(buf, NULL, 0);
> +
> +	sprintf(path, "%s/interleave_ways", cxldecoder_base);
> +	if (sysfs_read_attr(ctx, path, buf) < 0)
> +		decoder->interleave_ways = UINT_MAX;
> +	else
> +		decoder->interleave_ways = strtoul(buf, NULL, 0);
> +
>  	switch (port->type) {
>  	case CXL_PORT_ENDPOINT:
>  		sprintf(path, "%s/dpa_resource", cxldecoder_base);
> @@ -1719,6 +2017,63 @@ CXL_EXPORT bool cxl_decoder_is_locked(struct cxl_decoder *decoder)
>  	return decoder->locked;
>  }
>  
> +CXL_EXPORT unsigned int
> +cxl_decoder_get_interleave_granularity(struct cxl_decoder *decoder)
> +{
> +	return decoder->interleave_granularity;
> +}
> +
> +CXL_EXPORT unsigned int
> +cxl_decoder_get_interleave_ways(struct cxl_decoder *decoder)
> +{
> +	return decoder->interleave_ways;
> +}
> +
> +CXL_EXPORT struct cxl_region *
> +cxl_decoder_create_pmem_region(struct cxl_decoder *decoder)
> +{
> +	struct cxl_ctx *ctx = cxl_decoder_get_ctx(decoder);
> +	char *path = decoder->dev_buf;
> +	char buf[SYSFS_ATTR_SIZE];
> +	struct cxl_region *region;
> +	int rc;
> +
> +	sprintf(path, "%s/create_pmem_region", decoder->dev_path);
> +	rc = sysfs_read_attr(ctx, path, buf);
> +	if (rc < 0) {
> +		err(ctx, "failed to read new region name: %s\n",
> +		    strerror(-rc));
> +		return NULL;
> +	}
> +
> +	rc = sysfs_write_attr(ctx, path, buf);
> +	if (rc < 0) {
> +		err(ctx, "failed to write new region name: %s\n",
> +		    strerror(-rc));
> +		return NULL;
> +	}

I think there either needs to be a "decoder->regions_init = 0" here, or
a direct call to "add_cxl_region(decoder...)" just in case this context
had already listed regions before creating a new one.

I like the precision of "add_cxl_region()", but that needs to open code
some of the internals of sysfs_device_parse(), so maybe
"decoder->regions_init = 0" is ok for now.

> +
> +	/* create_region was successful, walk to the new region */
> +	cxl_region_foreach(decoder, region) {
> +		const char *devname = cxl_region_get_devname(region);
> +
> +		if (strcmp(devname, buf) == 0)
> +			goto found;
> +	}
> +
> +	/*
> +	 * If walking to the region we just created failed, something has gone
> +	 * very wrong. Attempt to delete it to avoid leaving a dangling region
> +	 * id behind.
> +	 */
> +	err(ctx, "failed to add new region to libcxl\n");
> +	cxl_region_delete_name(decoder, buf);
> +	return NULL;
> +
> + found:
> +	return region;
> +}
> +
>  CXL_EXPORT int cxl_decoder_get_nr_targets(struct cxl_decoder *decoder)
>  {
>  	return decoder->nr_targets;
> @@ -1729,6 +2084,24 @@ CXL_EXPORT const char *cxl_decoder_get_devname(struct cxl_decoder *decoder)
>  	return devpath_to_devname(decoder->dev_path);
>  }
>  
> +CXL_EXPORT struct cxl_memdev *
> +cxl_ep_decoder_get_memdev(struct cxl_decoder *decoder)

Hmm, this is the only place where the API assumes the type of the
decoder. The other root-only or endpoint-only decoder attribute getters
are just cxl_decoder_get_*(), so I think drop the "_ep".

Other than the items listed above, this looks good.

Reviewed-by: Dan Williams <dan.j.williams@intel.com>
