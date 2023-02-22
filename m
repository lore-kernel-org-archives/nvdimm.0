Received: from mga05.intel.com (mga05.intel.com [192.55.52.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C2F528F75
	for <nvdimm@lists.linux.dev>; Wed, 22 Feb 2023 20:22:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1677097360; x=1708633360;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=Dg+CE/jvU/r8wS5YEP+lSu2f028DiHjTN+MPx9BPQVE=;
  b=ekYpfgou2VFTOJS/gO4W7lvUReekSmyFCBvadTAeq2IYJ7ZVo/LWJuRq
   duVeUJzwfXt2HlGcMjWx4uJ9Q/t3Mm9XnDKLRoNU5484NaiHgC0o59iHJ
   IE6jKTxe4fCRkPEb68ek1rnBdMxpsEA9nJX3PEN9LSfNv/Bm7xpxBzHG9
   8810hL5qNC9uAjdMUgubyc5Npea9Q8OqmsQ6xWLkRq4jiNnZ6aDkrOsB9
   GfPpFf/4tczfcFHTMLq9lpU2o2gXG+sBEIYyFVb2a79ybTvkIA3DAGyZk
   cOZJwUxFiXRg7W4RJ0HYliUZnCEZNfqwMlE2mUcDhupdemCNc1Np04vsc
   Q==;
X-IronPort-AV: E=McAfee;i="6500,9779,10629"; a="419259903"
X-IronPort-AV: E=Sophos;i="5.97,319,1669104000"; 
   d="scan'208";a="419259903"
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Feb 2023 12:22:40 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10629"; a="917691389"
X-IronPort-AV: E=Sophos;i="5.97,319,1669104000"; 
   d="scan'208";a="917691389"
Received: from orsmsx601.amr.corp.intel.com ([10.22.229.14])
  by fmsmga006.fm.intel.com with ESMTP; 22 Feb 2023 12:22:39 -0800
Received: from orsmsx612.amr.corp.intel.com (10.22.229.25) by
 ORSMSX601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Wed, 22 Feb 2023 12:22:39 -0800
Received: from orsmsx611.amr.corp.intel.com (10.22.229.24) by
 ORSMSX612.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Wed, 22 Feb 2023 12:22:39 -0800
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 orsmsx611.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16 via Frontend Transport; Wed, 22 Feb 2023 12:22:39 -0800
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (104.47.57.168)
 by edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.16; Wed, 22 Feb 2023 12:22:38 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=QE7cS3YzOEL7pGddhS+S7mkKD9qk9dUe2XVdFNJcBvMJfAVdudJkk3i9LtzLyxBI6jgBHkzS7N+X2ix/DGfHJTb2rDXWPXHvEO926pE9w65vRlb6kzFNefayApSYfOW1UBMjty52UH6K5FhZUMVv6gXA1czVI0Uo0tgrFWB5RhY60+d65WZu6wVGz1q9rNycCmY8kkkVmhljq/nD6YLnACYhriIgFYg4HypuyNC0LStYgxde/bIyHQxzSWmu7VAbRx6lilwUV1uc+OdIxDFJ9/u/kEwI/tVAlHyftrTtvbpXVPdbVY79quAfSQ9ATv1GHX2Xwhc6mK+rTxOY4fsuog==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=RmVj+4Qej1cqzU3XGWUS9UKLtjzWOMfyJAgT4fs0rwo=;
 b=aAU6HBU1lFJ9S1obJwucM8XEktSRuE5AKobUk+6S/1cfNbIbOVPmrmuimQAy8lQXgJh3V9HiwAJnwyGW3ptgFdaDK+443YDhfjz88+pkhap1/YlaRMnvrPENPZDJGQQ94Qsezf5S0t03afYiiMuUosMkc1TF3HQbw2Dc2NpQgRIX7Sfv5QRKRPehAoXJvlOJAL2GTmobgtJTeYLxoQCupeZwmHOZ61ZikAlriQNrHpQ4xfBBoa/LpuiFRtqetlw1DTuohjRK1HeZA3qg/dnWMWnh/Cl3XMz3ZvCsGUGDcJ8e7SrAojj5WguJzwU8xFjgfksck7OcVVpYni9glTogXQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from PH8PR11MB8107.namprd11.prod.outlook.com (2603:10b6:510:256::6)
 by SN7PR11MB7707.namprd11.prod.outlook.com (2603:10b6:806:322::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6111.20; Wed, 22 Feb
 2023 20:22:32 +0000
Received: from PH8PR11MB8107.namprd11.prod.outlook.com
 ([fe80::421b:865b:f356:7dfc]) by PH8PR11MB8107.namprd11.prod.outlook.com
 ([fe80::421b:865b:f356:7dfc%6]) with mapi id 15.20.6134.019; Wed, 22 Feb 2023
 20:22:32 +0000
Date: Wed, 22 Feb 2023 12:22:29 -0800
From: Dan Williams <dan.j.williams@intel.com>
To: Vishal Verma <vishal.l.verma@intel.com>, <linux-cxl@vger.kernel.org>
CC: <nvdimm@lists.linux.dev>, Dave Jiang <dave.jiang@intel.com>, Vishal Verma
	<vishal.l.verma@intel.com>
Subject: RE: [PATCH ndctl] ndctl.spec.in: Add build dependencies for
 libtraceevent and libtracefs
Message-ID: <63f679853d680_19f3294e6@dwillia2-xfh.jf.intel.com.notmuch>
References: <20230222-fix-rpm-spec-v1-1-e6d8668ea421@intel.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20230222-fix-rpm-spec-v1-1-e6d8668ea421@intel.com>
X-ClientProxiedBy: MW2PR16CA0051.namprd16.prod.outlook.com
 (2603:10b6:907:1::28) To PH8PR11MB8107.namprd11.prod.outlook.com
 (2603:10b6:510:256::6)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH8PR11MB8107:EE_|SN7PR11MB7707:EE_
X-MS-Office365-Filtering-Correlation-Id: 5d0df2be-28f1-4f28-a962-08db151286bd
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: wPlW5Il8HghZkSgO8GnsKk9k+rAZqmLzm/mFz4IIxMnBDuAOLLM0W9pVBq7P/hHeBYtmCrhURQ7ynBx6Z/XcqIiooPS8Yi/GSuh+6DMpwmeO45mR/wjTt+0U8yPnDkkZfVvknVx+6FgmVsstH3xCnM2S1xQdqge5UONyTYlXxtk9E10aY00J9Ua2KctsEiIc+gM4F7MGNUQ7ygzlfBKRNVXRZzUrOVJbI5giW8ahv9nFvIXXRxtDShx9J9tyTSIGdfTIK2LJV3ibmFgQQ/cnBEn4BCwUDIatRgShqa2Ma8ffARlYhTfn7qY8fajtx0uK/k9Mcrl0oOo+yD0bUNe3J6f47zcHLmkS8T88KJ+r0jZJMGJiNzkNL+isiqTd5riZ/xpn4dkuxXNhaMFwmWCjTK7Hz52pMRgMRvxlhfmpSLDpzmP39wa5itgvwXpwb9+Op+XY0NRy5t0gMnGZPxL338Y0iHFaq/luprcyEFTfKVUuZY8/bS3nBB5ld4a2PUIq9sqlXaOavL9WkiFLmDCmndrpdey0nZCOsIzBdw0KJ1EnOd5KJ2qM5lMD0LaLEGnraY5T+BN+CRJJtmQ9Mk5CGQUa99KCStV5quwrN+NuLTgxiKrlugKlREZV0xACvWq1Jwwzi+StbqxjYQlrnqBL2w==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH8PR11MB8107.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(136003)(376002)(39860400002)(346002)(396003)(366004)(451199018)(38100700002)(2906002)(6512007)(9686003)(186003)(26005)(41300700001)(4744005)(107886003)(6666004)(82960400001)(6506007)(5660300002)(8936002)(6486002)(478600001)(316002)(8676002)(4326008)(83380400001)(66476007)(66946007)(86362001)(54906003)(66556008);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?f5vOnLJiEaBogDsxjnU7iFJR283nCf1pGZkO8e9Ss98JVXimb6xVyDThURzs?=
 =?us-ascii?Q?AWPzKe9PW+R+1NCnC4b25DYsa02JgCs410jGQZ8BrmT8HtFvGpM7TvklRGqq?=
 =?us-ascii?Q?slIa9jScGm2xWfKeyG0QlgElS9VIfotUuaHYzqy1ZgE/WCh6OiWWb/zkNivr?=
 =?us-ascii?Q?234Su3lX+ZEDnQFzBmrSlYvj/WHDeP2n4oiXEDgeQF/iicXTsEGMMHvvF8zz?=
 =?us-ascii?Q?TjAcs6itXG82SSh7C1IE5kt0X217BqOo7n6DQz+wb/mhJgIOmmleVU9Q6fYh?=
 =?us-ascii?Q?/tdHDa6tHZfIXWlxQ0ghEfWP0c25H6PJ8eCkoIYuL4xT6KShCodwdNtKep/y?=
 =?us-ascii?Q?/vdKq53bpkgK0x/SMhrt3p5vkBgsV86/elSGP9ZL/nXfB1iSYCEgwshMp24m?=
 =?us-ascii?Q?nlf4M8Oae+xWiySuVF4rUlTKW7/QBrpGafHiE0p7WCjqmJWwqT5HhDJSa4Fs?=
 =?us-ascii?Q?T7Yg5Hfa/h0a+crP+tVe4J2Tz209vcsf/VxMf4efPo9PZM+8kd8mDkXNJ5oI?=
 =?us-ascii?Q?1h87o47mYtr/9iL31J1PnVJruavEQj3V+VuYQUEnCzW2G9XQxNEmChBLLtmw?=
 =?us-ascii?Q?s/EFC1T1ATjrKqbwfz50iDRcB/yFl+x2EVmxbF0sUJZ142Tkeb6WQjBClYH5?=
 =?us-ascii?Q?rcrd5AbnVfI2UIiDsOgnnkRQ/Uo8dihbtctebpzi2iKygecI1pCEDacmKXdX?=
 =?us-ascii?Q?lDLCAzIUN7srZsGiUhFhlAoquONYDwekz63+E0MXtlnt7M7z8oVPO/nyN7ff?=
 =?us-ascii?Q?iHV6/VfG50RZTKZJPF9lm3BLqSwZCkVjAjJlXfd+QS4ARsDobuw2zInH+BYy?=
 =?us-ascii?Q?HOk3nHdpti/Nh8iGpR8xE9s0j17drr2pvnf8sCYgjD/oYXCsXF58u0DGebX7?=
 =?us-ascii?Q?XxAQ6VG97gSUYUvNjpKRpAwMD7szHDCjuKTiTUSJFmdlzj+PiGG/bMsJgunr?=
 =?us-ascii?Q?ao7p0piQmvvv1ZG8B/oFlmTcTpWR/7UAC7xsREfrlXO2kqJXDBqNXG5cGJz7?=
 =?us-ascii?Q?ggBLTVBmaY4Qd6TWdPBZR1R1iekKRmH7z0lGV1F1Xe+F+JylkuV73urOFvUQ?=
 =?us-ascii?Q?1krNPr09xgcXEbVZLyGnLzRxZMAV7PEr14Pb8K9lwIF9dTQz2rOFCqo5O24i?=
 =?us-ascii?Q?S7K5SmqfVoH2IZukN4f62ugHM5F0lduBWKO+EQh3nGzfNv3wAnPoouzYIHjC?=
 =?us-ascii?Q?n3LG/aeO4cjT83t2neD9oZpK7lM4Vq1mWlaTe5O4xkMxT3OfMZs9YTocOLvC?=
 =?us-ascii?Q?kwD0KHjtQlYim7cdMd+HFt9PN80g0c4K8FdzGODl+XB8VeUcGDlu2nfkY1XR?=
 =?us-ascii?Q?cTZU4aAjuSLtckMqnq1rkXKf39u0q/z+L00lhN0LexnW+YH4Jpok/hF51E82?=
 =?us-ascii?Q?fe1DWV2sKvzLXzPvuY1FkudSjXoRjkAhUFKXXOhgvN4Heh2b0Qcu5+P6uItc?=
 =?us-ascii?Q?rw2OMo4u1D9Db+BYdLLsG+FbXjGQzwCNhht6U1uv+onekhOk/dFQQdF9i07R?=
 =?us-ascii?Q?AznAOQYi5/XAYQY60twZ96IAvufw0fFb+XHLp3kFAhSOPIL8q1oKr8E981yu?=
 =?us-ascii?Q?4qCfYw4JYxPZh/8ChlIMF5qRK2kOU+kftHtzblsH/grob+udq93gz6nMSBYY?=
 =?us-ascii?Q?VA=3D=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 5d0df2be-28f1-4f28-a962-08db151286bd
X-MS-Exchange-CrossTenant-AuthSource: PH8PR11MB8107.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Feb 2023 20:22:31.9416
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: KboNCxnU5L0KLsQbEA8H+lBjTv4+pHWhyImhMg/CLGzM8BXlxvcl0VXvskQ0XPywn6LjAREvaoADWVQ0HcRXnwyUF75ALepdYkjNz91nfnQ=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR11MB7707
X-OriginatorOrg: intel.com

Vishal Verma wrote:
> The cxl-monitor additions pull in new dependencies on libtraceevent and
> libtracefs. While the commits below added these to the meson build
> system, they neglected to also update the RPM spec file. Add them to
> the spec.
> 
> Fixes: 8dedc6cf5e85 ("cxl: add a helper to parse trace events into a json object")
> Fixes: 7b237bc7a8ae ("cxl: add a helper to go through all current events and parse them")
> Cc: Dave Jiang <dave.jiang@intel.com>
> Signed-off-by: Vishal Verma <vishal.l.verma@intel.com>

Looks good to me,

Reviewed-by: Dan Williams <dan.j.williams@intel.com>
