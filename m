Received: from mga11.intel.com (mga11.intel.com [192.55.52.93])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B858117D2
	for <nvdimm@lists.linux.dev>; Thu, 11 Aug 2022 02:24:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1660184692; x=1691720692;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=gA8RzQgZckXrs42Y/JDICH5hxgdmDCjfTusoCosPEMQ=;
  b=GoNYBvTXUiP/5u2WLxV84KuZGUAGljELI24xSg2iWu6aQRSbYN0D8kwb
   MfDABb6fDtSJ+koT2Skec8bI0mGW1ot5l3D2J24OJaS0J5SVcDOIJUFDj
   mzGg06ovIx2jymoH0xFum4JUBMAJlMemWAzUkXPgCxCE94KaMxLeNolks
   rpIt8VmtT1Jxdy3HodEzHc844NxWritflIzwRwI6aWxUw9FILUTtuAoTn
   BvKFtv8RTDLD75OfklLdlQbx3N1NQ02spMwBr+3PDlYnfJuCbvCJkQwh9
   LrOdiGCpRQRMpjsGyWRCNYr1SsmqMnjkHFPGkaDAOHv6DODH/N9Ago/C/
   w==;
X-IronPort-AV: E=McAfee;i="6400,9594,10435"; a="288808128"
X-IronPort-AV: E=Sophos;i="5.93,228,1654585200"; 
   d="scan'208";a="288808128"
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Aug 2022 19:24:52 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.93,228,1654585200"; 
   d="scan'208";a="638330748"
Received: from fmsmsx602.amr.corp.intel.com ([10.18.126.82])
  by orsmga001.jf.intel.com with ESMTP; 10 Aug 2022 19:24:51 -0700
Received: from fmsmsx608.amr.corp.intel.com (10.18.126.88) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.28; Wed, 10 Aug 2022 19:24:50 -0700
Received: from fmsmsx608.amr.corp.intel.com (10.18.126.88) by
 fmsmsx608.amr.corp.intel.com (10.18.126.88) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.28; Wed, 10 Aug 2022 19:24:50 -0700
Received: from fmsedg601.ED.cps.intel.com (10.1.192.135) by
 fmsmsx608.amr.corp.intel.com (10.18.126.88) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.28 via Frontend Transport; Wed, 10 Aug 2022 19:24:50 -0700
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (104.47.56.173)
 by edgegateway.intel.com (192.55.55.70) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2375.28; Wed, 10 Aug 2022 19:24:49 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=P0y1gU6x6xctVeOgg0f8VNWWWxMytRBXusJdT/ZLGew5OIYlvA3tOeshZcMR+MJVnhdrpXt3RE718j69kEQNpCgylC5Dw4r0O5G8BpMrjvIjs0v4sIM6DAnv7qyJ1Z5Q+6mFoNAq+l+/iZV+lOacz1B6Tvzgs5sKby9GYTc0M7i5LDCeoDc74LSnjj2jaQ9DiHqXu2dLYDMhC3jEHdj4h0HeCnWEm9V96q2XfN1mOc7j2hkaqi01JxxZgsYlxzySmrscaSx30LSEMRM1MMSwUdzayB4GmBbAr+5TYL5OsGdUDvdQEdyvT71yXe8va0vEc2wpyWMcS8j0nCtl98GjXQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=62ERq8qNpl+mdyofQ83ze6CBLcdIUnbS3CNlLFYvDKI=;
 b=PT796MTmUjwUJ7oy/+2W1lUq37P5/ANoYjtSI/ZwyCJDMQQnhIieECXAxsloPHTRHBcnzj1ZAzePGKnFwhlJBXybbLnsr4NbRkoCtr63Ft/Ehx2538jzpIxQipATpkKKEHOEqvAbv6hiotUqxdJEJflZh7mHNf0WSijv6T7VUyy5aFE2Sf74yFZbyx/iz8QSC9a4QvsGQ3nBI9TgQNY2X5xaAUvMvX+6SSFVBgbsdWBR0YLTGj9ISUk5KdVHpE8vV77ZcYcIgP1c52rMVVMUrSyUBVylUeYehlFo6VF28yXiFLKlNfVcgV96mcLVGZR60aYUlUTIErwexLcio6FhlQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from MWHPR1101MB2126.namprd11.prod.outlook.com
 (2603:10b6:301:50::20) by BYAPR11MB3157.namprd11.prod.outlook.com
 (2603:10b6:a03:75::30) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5504.14; Thu, 11 Aug
 2022 02:24:48 +0000
Received: from MWHPR1101MB2126.namprd11.prod.outlook.com
 ([fe80::9847:345e:4c5b:ca12]) by MWHPR1101MB2126.namprd11.prod.outlook.com
 ([fe80::9847:345e:4c5b:ca12%6]) with mapi id 15.20.5504.023; Thu, 11 Aug 2022
 02:24:46 +0000
Date: Wed, 10 Aug 2022 19:24:31 -0700
From: Dan Williams <dan.j.williams@intel.com>
To: Vishal Verma <vishal.l.verma@intel.com>, <linux-cxl@vger.kernel.org>
CC: <nvdimm@lists.linux.dev>, Dan Williams <dan.j.williams@intel.com>, "Alison
 Schofield" <alison.schofield@intel.com>, Ira Weiny <ira.weiny@intel.com>,
	Dave Jiang <dave.jiang@intel.com>, Vishal Verma <vishal.l.verma@intel.com>
Subject: RE: [ndctl PATCH v2 04/10] cxl-cli: add region listing support
Message-ID: <62f4685faa6f7_7168c294e5@dwillia2-xfh.jf.intel.com.notmuch>
References: <20220810230914.549611-1-vishal.l.verma@intel.com>
 <20220810230914.549611-5-vishal.l.verma@intel.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20220810230914.549611-5-vishal.l.verma@intel.com>
X-ClientProxiedBy: SJ0PR05CA0149.namprd05.prod.outlook.com
 (2603:10b6:a03:33d::34) To MWHPR1101MB2126.namprd11.prod.outlook.com
 (2603:10b6:301:50::20)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: af05f432-f796-4cea-ab60-08da7b40a169
X-MS-TrafficTypeDiagnostic: BYAPR11MB3157:EE_
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Qv3mvTuT4EotRtiTygR+rUIBYxUVARBXMU92q0ILmnDQTWvsyqcnjtCm1XQZnuCYtseMuxM0MP2Xm74Ga79GAOl56ou0Nk6e9radkUSgxMh6mAARt3XhNs0wkZs/1jdNrYad9458ycMjIEeCowbuFh/agwWsCVvTyephGH1P+4b5qmLX/3Q2hJY6Ev0821+6UWWU9brfGGgJuhtaN8R4aA7LwXVu0+PoRBEZ8XDz7Esc6lt/D854zMrAmMUWV0c9M6n6ljj1SzaZ2pqKF3PMSe1QTyNodToVCoJbk4kQ/OP1E9Z/N8c59rls5XbE9ZGWemazu2Pam6X0VpyFEhnxt62VowzPXBpIgX1KyR1FlT5k+U0Nh+8uUoLygk2e5++0tOUqhLWBsEMikuEZRtwDPvC0UUmAwhFPcR6/4qwjWvvSDfyRsmqCGX+m5cx0lSSUD9lO+PtS3UVWM0b/oDpPQNVeat3qqPPoGd+c4O3j8fdX2I3rhiKONarVg+6ApMbl1Vv0HTmkGvGvfm6g84PSszSNQy6aUqx25Cu0l0i+/UZBUK3MgdAQgzRhMJz3F3UBsf2s/lk4Y9g6+NjLud3kC1S10c70k/YZ46A3QDnmNdm0SEOA2kQyZg8Fda+iQRcHYsj8jsmzJKJFavxen0uoURqzzsZnSfB7Cx/19mgSScpmhkl3W6jvI96C2RyaIxUGtzK+xSZzY87FgRE/FJYTWcitJ6lyPqmOkh/PGpADKT6cVq0sziolVTxrVD/6oKF7
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR1101MB2126.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(376002)(39860400002)(366004)(136003)(396003)(346002)(107886003)(186003)(9686003)(26005)(83380400001)(6512007)(82960400001)(38100700002)(6506007)(8936002)(4326008)(5660300002)(8676002)(66946007)(66556008)(66476007)(2906002)(6486002)(41300700001)(6666004)(478600001)(316002)(54906003)(86362001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?BssTDXSAtiaSntu2KHmDKz1IQr3SYrj9KnFZYvapHBHBoJRLCczPeYr/diqJ?=
 =?us-ascii?Q?UDfDhOtTjWNLjNsmc7qdRPhBIRHkGOBPyV0R6vieSOfI8AgNVGfLzhSrbgLl?=
 =?us-ascii?Q?avNJiablUKcNaHyuTtUUMoMGQ8YukRpHzZa5LgBbuwC19lH2xxGMNlKaNpfD?=
 =?us-ascii?Q?lptlKJNrdoqovQW4fKS1B9AZdF2EV3GPBLoy+D2E83DV27yyypsvWyBFkGsR?=
 =?us-ascii?Q?yx1Alp+82k9GH1+GdRgFzybuY3MVlnMLrhT9bkk7IuitwOK4NDC0V1U8AfRv?=
 =?us-ascii?Q?/LmwNzKeMTCl0r0jI/3J2TlNI3bVA2SE0Usi/dRUmbsIQsvi+vGL8j83PJjh?=
 =?us-ascii?Q?/LmwAxAlsVSh3mpL77sJQHHzvo3TE8NWSuDn/1yAj3egkvc+uLkBEqXMmLwk?=
 =?us-ascii?Q?w2tVX75Fz6aMb1srrGv87dYdKf1geot1m84JLl5lC0BU/NV0zEobUA2lDbcj?=
 =?us-ascii?Q?byjs9/8dBUlLIC/gTY40OwtDG6bQLMtJhgD5WYxEc3JjRduFbnpdWWCuvNto?=
 =?us-ascii?Q?ubDs28Ere871GK2bCcYenO0o/urc0T3cjRJUJgknnwRn5XQ7+qM3h6/EQk2O?=
 =?us-ascii?Q?g+9zgqbvCxv2iym2DXRf9sQ6lJWzN8H7VE1Al65Sn55OInwWDzQgzBz0YTrq?=
 =?us-ascii?Q?+0gR8GerYbW/pfnKmDPxpy7yN077CYpmKx9a0GOV8CLU29Sntn+lPmR3s/9Y?=
 =?us-ascii?Q?5qQnqR4TzXcPZv9OdkXvj8Z0/tDU+764cqBVMKcOvCcmFh9w1EBImbcCbpu1?=
 =?us-ascii?Q?e8QYlraEE+TujypPRsDoFH5CUhoqHM7fbO7G5Zch+6hn81y4TJPRNWOJS+AO?=
 =?us-ascii?Q?0Vnw/6aHs6321BMH4KNIGgeI4aI/DaJn8mpiRlpqR88fUWFTlnZZXwCmILti?=
 =?us-ascii?Q?fWmhz41Hu/kZxRboTqEw6l9hfISg8UDw9V6Vk3LYIxeIDGMzUGQSZNle1lGY?=
 =?us-ascii?Q?qToDBQGSjWWWqpojBjcCkBQz5PcTU0jOpL5qMr7T1wD5TYI+UyGExEU/fwZL?=
 =?us-ascii?Q?jOPGSjBy2VgHSli4vlNkXfvQL3nrsScDhUwKYyD9d0HWQb4QlMdL6Rkfw9kN?=
 =?us-ascii?Q?pUGNLYAois35TjG8/2s/WnVpyXQCIpfb8t2u4A6xBq86dm0N14V4x2obZN7D?=
 =?us-ascii?Q?m+iF82wDdR19Yr8cPuEUnQXC+sN/OhMJ0Mgi39dTnCSDZpJbY1Potjl0oGTp?=
 =?us-ascii?Q?9h6yBMgVLHMc6TJa1Qu1xxhBOa932prMlNPA4rKgSO1/otgLBr42DDZXvYxS?=
 =?us-ascii?Q?5lPXuGCrsN4ECZD4nlPTbhFGDrXhe6T6gG4fUggchYUZoecfq04QYU9GgTln?=
 =?us-ascii?Q?eRJBQikxbjHpG1tgtNcJaXBaasaZtrBkEJMg7pTfKp2Zxn1EnrjNL5h/gUR7?=
 =?us-ascii?Q?P+hEzPqVPbvWwp10KG/9+Rc3I+utz4+rbzpGVt6fP5nOYJWNH2PNlZEZJd71?=
 =?us-ascii?Q?14uiReqGhFPo+OWuFE6raGM0Ma2GH8SGdm6Kksqr0S+xmwNAgJfKtp7CFy4G?=
 =?us-ascii?Q?CFqeyWDjq1mElxw78TzNQwtIKJI9OwUZcuvYubYkhv35cXaVg5QPB+ErZAOv?=
 =?us-ascii?Q?clwInkggw+bzv0OTDHCFHgACRNDO94HXiP09kWnB+h6XpQhjnD+6/XL5g7WF?=
 =?us-ascii?Q?rA=3D=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: af05f432-f796-4cea-ab60-08da7b40a169
X-MS-Exchange-CrossTenant-AuthSource: MWHPR1101MB2126.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Aug 2022 02:24:46.3452
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: eF5lGn1z3evvj8Qf6DTRx2baQNOyfRc5rDOxpNiuvrwGJGYUrC6ExZ+crBZBs+nQno0DhVkO157iPT6Ih3E86HUIgk2ZabY01o3XZXOMt74=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR11MB3157
X-OriginatorOrg: intel.com

Vishal Verma wrote:
> Add cxl_region -> json and cxl_mapping -> json emitter helpers, and
> teach cxl_filter_walk about cxl_regions. With these in place, 'cxl-list'
> can now emit json objects for CXL regions. They can be top-level objects
> if requested by themselves, or nested under root-decoders, if listed
> along with decoders. Allow a plain 'cxl list' command to imply
> '--regions'.
> 
> Cc: Dan Williams <dan.j.williams@intel.com>
> Signed-off-by: Vishal Verma <vishal.l.verma@intel.com>
> ---
>  Documentation/cxl/cxl-list.txt |  13 ++-
>  cxl/filter.h                   |   4 +
>  cxl/json.h                     |   5 ++
>  cxl/filter.c                   | 158 +++++++++++++++++++++++++++++++--
>  cxl/json.c                     | 123 +++++++++++++++++++++++++
>  cxl/list.c                     |  25 +++---
>  6 files changed, 304 insertions(+), 24 deletions(-)
> 
> diff --git a/Documentation/cxl/cxl-list.txt b/Documentation/cxl/cxl-list.txt
> index f6aba0c..2906c2f 100644
> --- a/Documentation/cxl/cxl-list.txt
> +++ b/Documentation/cxl/cxl-list.txt
> @@ -309,8 +309,9 @@ OPTIONS
>  
>  -T::
>  --targets::
> -	Extend decoder listings with downstream port target information, and /
> -	or port and bus listings with the downstream port information.
> +	Extend decoder listings with downstream port target information, port
> +	and bus listings with the downstream port information, and / or regions
> +	with mapping information.
>  ----
>  # cxl list -BTu -b ACPI.CXL
>  {
> @@ -327,6 +328,14 @@ OPTIONS
>  }
>  ----
>  
> +-R::
> +--regions::
> +	Include region objects in the listing.
> +
> +-r::
> +--region::
> +	Specify the region name to filter the emitted regions.

Should this match the template of the other filter options, i.e.:

"Specify CXL region device name(s), or device id(s), to filter the
listing."

...because -r may be a list and it may filter more than just emitted regions.

Other than that, it looks good to me.

Reviewed-by: Dan Williams <dan.j.williams@intel.com>
