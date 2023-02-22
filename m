Received: from mga07.intel.com (mga07.intel.com [134.134.136.100])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 697711360
	for <nvdimm@lists.linux.dev>; Wed, 22 Feb 2023 01:56:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1677031000; x=1708567000;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=gCk2KG2r6z7HSdJCHtOFyxgFZ9UNIFUie778WeI/Ovo=;
  b=FTFRfuH4QhAQgna+pdFoVHPld7v9B93tp6aPqVI7yb7UO1Y2RunWPoNZ
   VrROX02DaQ1kNBV3UWp+XqRMsrEn6MyFmtbRedAEvwTxxbcvY9jIWO86m
   6MwmeKbI/71Ev+0kDijiV0m1SSGHHxyqOguwxW31V+T02VBxMS2eIjdBB
   aMfbcI7bJYeZgreHnuauQsSkNhzKXkQiMMLeYoSujU0ZjesVRgR0+kGi6
   66Z5wiEzCzVyI20QELo1na1WF2X1T3XkG5L1THXJ74ZfUKVec2JK3cBUx
   4NVcZfiU7tc6AKql70J5UJamZIE1BvHdB9PZjfJ9XO4z/tePyoOB/B+FI
   w==;
X-IronPort-AV: E=McAfee;i="6500,9779,10628"; a="397498263"
X-IronPort-AV: E=Sophos;i="5.97,317,1669104000"; 
   d="scan'208";a="397498263"
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Feb 2023 17:56:40 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10628"; a="795722739"
X-IronPort-AV: E=Sophos;i="5.97,317,1669104000"; 
   d="scan'208";a="795722739"
Received: from orsmsx602.amr.corp.intel.com ([10.22.229.15])
  by orsmga004.jf.intel.com with ESMTP; 21 Feb 2023 17:56:40 -0800
Received: from orsmsx611.amr.corp.intel.com (10.22.229.24) by
 ORSMSX602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Tue, 21 Feb 2023 17:56:39 -0800
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX611.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Tue, 21 Feb 2023 17:56:39 -0800
Received: from ORSEDG602.ED.cps.intel.com (10.7.248.7) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16 via Frontend Transport; Tue, 21 Feb 2023 17:56:39 -0800
Received: from NAM02-DM3-obe.outbound.protection.outlook.com (104.47.56.47) by
 edgegateway.intel.com (134.134.137.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.16; Tue, 21 Feb 2023 17:56:38 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=naf+bNrMwp88CzOZg0+jE4Lv6glSg6fHwAeGtMTBxlvsmFkfnsjypZsQlcUs9P6tmBBIVV5DQK3Tb2TCU+pqGb8Lv8xcGDOTtkPFvlEzIEeSIFq54wnGecgvif1QjrtmIWJ3/fZfV0y1eqqsrhiYygIATrOgztN/ueg61uF//1n+TEfJ/UgcYB+yutm7Mrb8EyCj/THWx9Wz/SS9kltAVkg/h/+nbgfHM26rGXTnyZPw0jCD6LwWLqvQ+OlxIjJevSPaAPVjVezemxJfWDbY/MyNzfsohdsTNmgAOQpbkPkzXTvcPoBOURNt9r/SMmS7lPo2YOv4+dDZM0cG+ndQkA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=CWXsMHh2fHU9upMizpq0aXgKoapiC076FLyY9pVX9SM=;
 b=mqcGSXVxGFYCJw1av6fve6UQ/PyLPTeVlH479Zpckd/GmsonTfXcDzh7+3DO1uBYNCqt20G5pzfSq61fxbXcV/S+GY3FNbd5FUwx0c7DR2emwz6J5tAUKhQkbkJYd36QzGHnjOAZbJvWYcpF/rk14y8IT2iO8Bs476vZSOCUPR08hIAqEnOvapWpOU8WRhHLwLU/9e1Vg+zY3SL78xM9imGgs/2d1y0gVzFRVs5G9FBVXq1vhWMDkljj6W31IylBM43Fk0c4BkqfW2+vdJiJ2FSUrW5YoP8bUdHlsQHrpuJPd7gYGHp0W5ixxqm382HbI3Dm0frV2FMg6BKFiR6RxQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from SA1PR11MB6733.namprd11.prod.outlook.com (2603:10b6:806:25c::17)
 by DM4PR11MB5261.namprd11.prod.outlook.com (2603:10b6:5:388::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6134.19; Wed, 22 Feb
 2023 01:56:37 +0000
Received: from SA1PR11MB6733.namprd11.prod.outlook.com
 ([fe80::84dd:d3f2:6d99:d7ff]) by SA1PR11MB6733.namprd11.prod.outlook.com
 ([fe80::84dd:d3f2:6d99:d7ff%8]) with mapi id 15.20.6111.021; Wed, 22 Feb 2023
 01:56:37 +0000
Date: Tue, 21 Feb 2023 17:56:34 -0800
From: Ira Weiny <ira.weiny@intel.com>
To: Vishal Verma <vishal.l.verma@intel.com>, <linux-cxl@vger.kernel.org>
CC: <nvdimm@lists.linux.dev>, Dave Jiang <dave.jiang@intel.com>, Dan Williams
	<dan.j.williams@intel.com>, Vishal Verma <vishal.l.verma@intel.com>
Subject: Re: [PATCH ndctl 2/3] cxl/monitor: retain error code in
 monitor_event()
Message-ID: <63f57652656e8_1dd2fc294b@iweiny-mobl.notmuch>
References: <20230217-coverity-fixes-v1-0-043fac896a40@intel.com>
 <20230217-coverity-fixes-v1-2-043fac896a40@intel.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20230217-coverity-fixes-v1-2-043fac896a40@intel.com>
X-ClientProxiedBy: SJ0PR03CA0058.namprd03.prod.outlook.com
 (2603:10b6:a03:33e::33) To SA1PR11MB6733.namprd11.prod.outlook.com
 (2603:10b6:806:25c::17)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SA1PR11MB6733:EE_|DM4PR11MB5261:EE_
X-MS-Office365-Filtering-Correlation-Id: 8a69db0b-4d19-4460-246b-08db14780842
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: McHsT33OKCHxb3w/mm6yj12Z66eQd+23FnAl3DZRI/rqtaq0Mt5Ve0SOOYkUyp9psNI98FdvVFV6MCwYKWUBlyt61Nn8zq60XsbobUostx05sD9jrbgK8GosRmDqnCcIs013Umx4+4vya0cBmqNOrBE3XwvKIdmSdDfufOw8jBc5Irj1EX7fQlhTKxADjga7hfWBpb0+i2ves7uHgFdOx3rqRhtzWUIZ6naq9RRV5UXKXott09OXfGmRrqLukbXaComr32+CxW0YZPwV6thlJ0J/nAE7Kj3hXaAbbkDkWJxO3oZ+xa217Ug7NQX7Z5aqhQeB0xMUieFH1y34Ux89iaSpu0XqhCrQ2KNg3flNvrkRB2lN/v9qypDVleXwAaFllKmlKikoyo2LLYvleqh6XZpv4/ZCk4FarNo0j0OkGstE2Mg2cmVmr0iFLscywFY/mvD2QCOojt7N5AMwptVdHLl7taWkVxvHdR73we76XC/OhOGTcy6KWHM6wnxaCwjcd1Z30qxWDd6eIWY3H1gThbUaUOmmgeZcT9B9D18Gb++Ou0kwHF4cUJC+1LdEPzHGNe6XJVlq/AY/vpfAjAWAD/HUSeSagsl4Joqei5mft5HtJwmPz04OypmpV9N71xGBO1wV3BdCvIUZjjVLOaN9pg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR11MB6733.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(346002)(366004)(396003)(39860400002)(136003)(376002)(451199018)(41300700001)(9686003)(6512007)(66556008)(8676002)(8936002)(66946007)(186003)(26005)(4326008)(6506007)(66476007)(86362001)(5660300002)(83380400001)(44832011)(478600001)(316002)(54906003)(107886003)(6666004)(6486002)(82960400001)(2906002)(38100700002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?/z/DqwgeGgyO64xm1YkU3r759q+nvg2nDMWI86zIesdJ987yao6896wzNmVc?=
 =?us-ascii?Q?6K8CQ4Dj2vyOJxowyLN89v/LipO0u+5PZVs5+ZRFVVzNgjUMti0gVwcsHn7N?=
 =?us-ascii?Q?0epYMrjcAHeqgMkRUdAGVfaXZu+fhDO2mK0Nf1No+mFETzP9K8o8/b+KsCNk?=
 =?us-ascii?Q?0dk/U0w2+Vtrj091Wn9OJB6eQrgaTEtRZwRGh2bDwvwzq91jL+H8m2SxJGYu?=
 =?us-ascii?Q?obnJRfF8SOMN18SGcTZ8Xwy5olzKAl04t2FRo3T9xyGuNjoEydsdjO2t5O1S?=
 =?us-ascii?Q?4L9zlbaHwtEPs0FLNibD+uk+8Y48jH/jZMCjdo4fiAy7Q+grriprM//oSmVi?=
 =?us-ascii?Q?ocI1RPoPJcKcv74txnxDqenLgOl3LRh4zav4xxJMmNZ6mreyoMxMNzZl7aPT?=
 =?us-ascii?Q?FqApWCASWLCDf0W+HH3+2VFfCWIw54qGn04+NHJzX+sGZ05de5S78ttd64xd?=
 =?us-ascii?Q?mwcjuAblmtQd3OUwNdV4+56e4ulhk7Ho+EXNbHtMGf+3JK/JNJrbd3cCSbSL?=
 =?us-ascii?Q?dVHFjxqdMyqxga9s/Nfgtdn+qtAUKHed0xCr4WVvtlealTxlPhxqhq/mnCos?=
 =?us-ascii?Q?lyLmrVOoDwOzDeykYnOiUVyeparQrRe/deS1WSS8w1VK9SGK+YqFGSK2Ilbe?=
 =?us-ascii?Q?C0IuE9fL/u4b/vMohjaPK5FD66Kz+HsfrKwix18VFS3IOxaQoZewpkRkWVwH?=
 =?us-ascii?Q?gFAHWPXs42a2U4r/PACgEwbU0Ul+jLqJLMp+1ZX8ZOi90zOvdTWOwPLHL31X?=
 =?us-ascii?Q?/+ivA5FuaN+kGed3ZrZbuuqbTBZDSPLPmLZn5qO938JqhjSTV9CKXtIdqFPO?=
 =?us-ascii?Q?2o3lxrIRzoaKNBt9VBUP4aGaB45FR8oVSAf4Xj3wsnyH5BvvMh78lIjNX3/j?=
 =?us-ascii?Q?TLmpEnqRhvg7MhlhQAE9TomLdOnwPlja5rFTRBfOyPdd4oB6N/3s37fWdHYB?=
 =?us-ascii?Q?PDq4Sx9Mjk5kWvrYv4ngT2uPF1v7nr3ktKLrzCg4TCzhxiPrv1IB6AMI+kTB?=
 =?us-ascii?Q?h51GSxqB8W5BhHr5A4FFL0gY5ZLOeZ/I96YJ0pE0TF8pcPObKWmSWHVc0oI8?=
 =?us-ascii?Q?767YQT1ccVfs91pqugtX3MP1i3eVPcyG2k7nPvcQM9mjD3Q9uVJ3jf/+PDWT?=
 =?us-ascii?Q?nh/5PLGHcfmEThKucIlKO3Uz4OXR2Dzf7YIyEa9rK/+WMpSlO2xyxZaDzNnT?=
 =?us-ascii?Q?pf2Wvt3A8ks6MHdRXjzHo82h0h9+jI9TFQJRhxdcXEk+WCwu8Do4Q4mYTB7S?=
 =?us-ascii?Q?hx1pPXmj912aAl8pcs/VEt0g4MqPHA0MicYHIMFttqFC1aQKn6i4GzT6wIS7?=
 =?us-ascii?Q?3M5im+Y9ecKxYZxxxtsfQUj73swuZxNYcckd10LoPK3tFzfntOgI8oKutgwQ?=
 =?us-ascii?Q?yAEWeGixulTc2U4qFps14IhVn3wwUYC57y+obTdy6H/RKkyTiEYqfVgafYHS?=
 =?us-ascii?Q?2R1/TdTXhPfw8uzE5bBiFQ9IjZ7WkqMC2SkuORJpHKUW8DTJ4UJ/kodsCdzA?=
 =?us-ascii?Q?knUpGymKsnR8Wct/Vp2/k+bQqnnfq++M/Q5nQFBGzZxHi3pPTfUsPZPTHxqd?=
 =?us-ascii?Q?RDguqxcAobHVhPgXSRAdyakN6fDx2RO+1gNYtvmz?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 8a69db0b-4d19-4460-246b-08db14780842
X-MS-Exchange-CrossTenant-AuthSource: SA1PR11MB6733.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Feb 2023 01:56:37.2115
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: NIRu26ddpAxcvBk9fvotrrEmHViwhNaIy0OlQv/83GHugAG87xxyY01Z/Yo8MdwSjVGDZWG/ZXrrfMUNK36rZw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR11MB5261
X-OriginatorOrg: intel.com

Vishal Verma wrote:
> Static analysis reports that the error unwinding path in monitor_event()
> overwrites 'rc' with the return from cxl_event_tracing_disable(). This
> masks the actual error code from either epoll_wait() or
> cxl_parse_events() which is the one that should be propagated.
> 
> Print a spot error in case there's an error while disabling tracing, but
> otherwise retain the rc from the main body of the function.
> 
> Fixes: 299f69f974a6 ("cxl/monitor: add a new monitor command for CXL trace events")
> Cc: Dave Jiang <dave.jiang@intel.com>
> Cc: Dan Williams <dan.j.williams@intel.com>
> Signed-off-by: Vishal Verma <vishal.l.verma@intel.com>
> ---
>  cxl/monitor.c | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
> 
> diff --git a/cxl/monitor.c b/cxl/monitor.c
> index 31e6f98..749f472 100644
> --- a/cxl/monitor.c
> +++ b/cxl/monitor.c
> @@ -130,7 +130,8 @@ static int monitor_event(struct cxl_ctx *ctx)
>  	}
>  
>  parse_err:
> -	rc = cxl_event_tracing_disable(inst);
> +	if (cxl_event_tracing_disable(inst) < 0)
> +		err(&monitor, "failed to disable tracing\n");

Is this even worth printing?  Perhaps just make
cxl_event_tracing_disable() return void?

Either way:

Reviewed-by: Ira Weiny <ira.weiny@intel.com>

>  event_en_err:
>  epoll_ctl_err:
>  	close(fd);
> 
> -- 
> 2.39.1
> 
> 


