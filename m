Received: from mga11.intel.com (mga11.intel.com [192.55.52.93])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E92537B
	for <nvdimm@lists.linux.dev>; Sat,  3 Dec 2022 07:14:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1670051663; x=1701587663;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=D4gCZmJpGmVjMCQKHBMQaffVBxxcxE3fFpKjSuy1EHE=;
  b=NOxT/rCyCGbo4kRMZ/EdVFcNn56TUHUvGTDvs4oJuXuryAx3OXvL/FZY
   qzQ8UanwOGyusYJxvDVRVYmNVMTEPSonNYb9Q4xBd+CbLKt4JN01ppqIy
   yVfRB0utiUXHD9g/6Zt7X7j+qPFZwcxcm4jVRSh3dGbmJ1wzyOLcTbjzz
   Ov4TDB89eYisx1paPmky1qY37Z9RK1a3DlTZJeyymUD7TBTO9MnPD6SnO
   Kd+PCG2cwErrzkO6Pd5Rmur3LgTovydslgGSRcisarpGqbZKeBLEYH71j
   cA6ezUNf8IGvCbQ068aHbuHGfDwEjq4lQyrsrB1R8lvPIx5zDXPSf8cse
   A==;
X-IronPort-AV: E=McAfee;i="6500,9779,10549"; a="313742137"
X-IronPort-AV: E=Sophos;i="5.96,214,1665471600"; 
   d="scan'208";a="313742137"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Dec 2022 23:14:23 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10549"; a="708728329"
X-IronPort-AV: E=Sophos;i="5.96,214,1665471600"; 
   d="scan'208";a="708728329"
Received: from orsmsx601.amr.corp.intel.com ([10.22.229.14])
  by fmsmga008.fm.intel.com with ESMTP; 02 Dec 2022 23:14:23 -0800
Received: from orsmsx611.amr.corp.intel.com (10.22.229.24) by
 ORSMSX601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Fri, 2 Dec 2022 23:14:22 -0800
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX611.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Fri, 2 Dec 2022 23:14:22 -0800
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16 via Frontend Transport; Fri, 2 Dec 2022 23:14:22 -0800
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (104.47.55.177)
 by edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.16; Fri, 2 Dec 2022 23:14:22 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=DGPsaJC6MsCDP+rwvZg0a/OqIaScCBrYXY2e5nHiMr0KJjKXj4GHSFFr4WDAhbR+Al6gKVvsFKXSi77YN5uNZPrYizDojO90tr7G3GebQ/NsigAC+qCLYen2Pp8AZY/ub+hntWMYYOt7KYTarEeCECgqCY7fo83HK8DwjYcjYn+RDr2x26gq18Elu/XcwjLhZqcwtMkrTq2MBr0J4W0Ea2eFDXN23D+AbenM4/6fnPUIcbEqHKAEPDzGhAvuVck0AkTdMTkkAHu7VyfI4qHLI6gIz7nNVGAMBXQNkM/12PlcjX6VU99aEk6KPjH4VLxektpQuzsEfNr0SG3Io92IFw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=KuqnK7G2WrCM+HvI7/u7M/FpePl6SKzfL9Dmf7W9oC8=;
 b=TQGUVGxswRHZQukUW0cluPtz3alyyQHM9g/b+L5i4Fwx3jkgFDBqHNHfUaoSLX9u2uzAoiQv9sTVfxLPSYgQ8zRNVH/IVaxGPOvqmIZELn4V9H1zFEnldwJoQiut/spn2Vd9uY6qgpkAPAWzMhRAGYy/EtfZCQ8tfFR3oOiYq9sqNpS20vxF8lcQD5yLLQGnuc/UPiJMcKqCVONTHvs5+omJQzGKTemT/xLEuw0JHlKfPBGJVHwC4BMHcJDwV842lQskFg2I7s3f585pz6GS0Bt3L+SDo4pt0dCK/xoLhDCRpDyFiLIIjQiX+U6XIzeICKtv/jQSjQZZ+BaxJs73Yw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from MWHPR1101MB2126.namprd11.prod.outlook.com
 (2603:10b6:301:50::20) by BL1PR11MB5334.namprd11.prod.outlook.com
 (2603:10b6:208:312::5) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5880.11; Sat, 3 Dec
 2022 07:14:18 +0000
Received: from MWHPR1101MB2126.namprd11.prod.outlook.com
 ([fe80::340d:cb77:604d:b0b]) by MWHPR1101MB2126.namprd11.prod.outlook.com
 ([fe80::340d:cb77:604d:b0b%9]) with mapi id 15.20.5880.011; Sat, 3 Dec 2022
 07:14:18 +0000
Date: Fri, 2 Dec 2022 23:14:07 -0800
From: Dan Williams <dan.j.williams@intel.com>
To: Jonathan Cameron <Jonathan.Cameron@huawei.com>, Dan Williams
	<dan.j.williams@intel.com>
CC: <linux-cxl@vger.kernel.org>, Robert Richter <rrichter@amd.com>,
	<alison.schofield@intel.com>, <terry.bowman@amd.com>, <bhelgaas@google.com>,
	<dave.jiang@intel.com>, <nvdimm@lists.linux.dev>
Subject: Re: [PATCH v6 05/12] cxl/acpi: Move rescan to the workqueue
Message-ID: <638af73f7ad4_3cbe02946e@dwillia2-xfh.jf.intel.com.notmuch>
References: <166993040066.1882361.5484659873467120859.stgit@dwillia2-xfh.jf.intel.com>
 <166993042884.1882361.5633723613683058881.stgit@dwillia2-xfh.jf.intel.com>
 <20221202155014.00006755@Huawei.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20221202155014.00006755@Huawei.com>
X-ClientProxiedBy: SJ0PR03CA0106.namprd03.prod.outlook.com
 (2603:10b6:a03:333::21) To MWHPR1101MB2126.namprd11.prod.outlook.com
 (2603:10b6:301:50::20)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: MWHPR1101MB2126:EE_|BL1PR11MB5334:EE_
X-MS-Office365-Filtering-Correlation-Id: f59b206d-0bf2-49e4-5250-08dad4fdfe4d
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: HrpDgSv9G90Tg/WuCHG5T5PfrULq8s+C51r1Q4lWnZMxnsyH/fFvXJgUYfl8WGLKevkgK4WOWgGp4Q3vJumjaLI9SfiOqu8fiyM9okcOpN/E1RRffrHtGpXCfyB+Lg5zYWDJbvEBsWjKtfSchePNu+HEe0cyhW+gaYTrT/5dZs0fDHDv7Eg0eea5miHK01JFV6gZwqItt4OLR1uQcg0eCq+L6SlQTjBcmsQ3bI7o/Avbeliw7sp1K29DTSsk5p+ZNipN66SfjW4vrviiZsWHZGXhGUFvAIFQlGQGnrV5jXb8DOQA+pVEweM4UNhYCujGiPLyiCCNX1DvXy196zckui3Zi+oFC51e2hxlru26LQ3J5LyY2iRSYVDlQUhkObtd6ZALKc+TubPfc4z9joXQwNbyxxxdZT3SoYTZEvYUFb8bw6HUcCIxrSPllXLW/hJPkYzP5qCHx/dcBVctoJ57XzjCn3IDlH3mg2fv41Ykexv/h6kuO1jF/+HvJsN989VMBF0vZRSm56e2dKIwfMrqtqbXdvtH0AaSjsR2mgYaHLMFnfHIclID4O6d6xLzVCLZc+vVql+0X3cMdWIXl6dA9fndM8XnXXF364ZCthJxMI8QHNAjfDKQRfGke5YRfWqCvKTHVGkNk1hNZMImPOWGnC6joLpVBSq1q3/x2lqjhyY=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR1101MB2126.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(366004)(396003)(39860400002)(346002)(136003)(376002)(451199015)(8676002)(4744005)(66476007)(66556008)(66946007)(86362001)(41300700001)(4326008)(5660300002)(8936002)(83380400001)(186003)(82960400001)(38100700002)(2906002)(478600001)(6486002)(6506007)(966005)(6666004)(6512007)(9686003)(110136005)(316002)(26005);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?xUTsx8gBdXvgE6qecuVdbepmlRCYOCvKLp+ebliVkw3iZLcowQNue0YivZKD?=
 =?us-ascii?Q?sQFwnOmA01Yqd0QLNxLmKzkup1Ypga7nbCvfnUPieVLb1n1wXlt3HnEkpmBB?=
 =?us-ascii?Q?T1fixJzwZhgeVUfHs7uRSZEw6+LfP+Km6oRNn3OW0qsl5nSG8ru1OhCQN9fk?=
 =?us-ascii?Q?LLM4NuI0OXX/8J+JcSNN15pu/2Km2D3TOEIlbAUqPzEs7JcGghujc8hTfaMj?=
 =?us-ascii?Q?J17P9/IaVkastAm8aKvyr5afFn0ZMUsw6XU19dkBqIHxawSlGGcHxJPaqih2?=
 =?us-ascii?Q?yWnuZR0XeKpa9YrGcXTG2B+LUVyB90GUAozaU2MIdVgnfBGl4z6NTX/DylEN?=
 =?us-ascii?Q?XznreSjNbvx+5zGSfw/I+HVP6ZACqffQNs8B8jyYNalzf6F2LUQpaN6LIeBS?=
 =?us-ascii?Q?PNrt/jFIGExmEFN8xw+hPXR/G/f92KOOPvFDFdZ1j/uG3NKSlgJXpovQzhVe?=
 =?us-ascii?Q?S46nubKmj1RiqvlXgPutGWwrDA+lUNHfFKiGbol0ZPN8lDW3RbUPmyIvfSAS?=
 =?us-ascii?Q?6YaM8t4Len0RzPReB4468Of3zRBYw9ubD5RKQtgwqfatQ5LbwZpzuTGd206K?=
 =?us-ascii?Q?8i+TrguLnSmrIbjrjb9qIypV21tcwFgdyL+PrkV5Njl2kIn118ezo0efH2Qt?=
 =?us-ascii?Q?NxOL337ty+Fz7KZLGbAngPiMI3biKHB6HqwZijgId7CAP/IGKlkGcQ5XcZGW?=
 =?us-ascii?Q?0eMcDY2NBCxY41ats9mdx4WMBUNV0m6m8SvVfbwLXNqivshRWol4iyONZJZa?=
 =?us-ascii?Q?DWYmXJx3t6xYE4ijf7eC4oQe4nbeMLawu13/2ShG7NB8qFde6WRmbP5/lUdy?=
 =?us-ascii?Q?v8mp4fU2MXNN3nk7SKYELP3ttOdRHUDLNQUCs5AeqVu+79oaJe8gEceLv0zt?=
 =?us-ascii?Q?HgHlTkzgL9f3+WkYCSKSXtSO2M4072Di3GuyLv+sePUNeKXn/T+7C8d0Hc5l?=
 =?us-ascii?Q?+2a2TrvbbPc8BKRmn+cpTrrGpHGee+SGmbHypXcxPHZIRjjueavjP1r6XqDo?=
 =?us-ascii?Q?eItCKZJbhcHXOhgfh/YlRTZdLufUGKfFXSqoHOIwzfjKyECgshnJgN4mkcQo?=
 =?us-ascii?Q?Lf8TqQgK0fPFsuJIhs8Etak4VEhAtXSrgqQ4mkr5+HVFQS3Dzg+eWYu5Khbl?=
 =?us-ascii?Q?w2NRmJcTCQNTdst6Mi5Rsdovj6Ky44rNEScIKOJBzifWuiZgCQ5aFeHSzBUi?=
 =?us-ascii?Q?xEq5xyAfj1Hz82pWj7SUuB/116BmKET/2aaoWv7D4UROa9qBTyrFi1o9WpUB?=
 =?us-ascii?Q?WSLSUF2ycCpNpQv1Ey9K4WHQT/PjMWTG+Cv2gRmXYNfINKJAYI+zIrjwdQam?=
 =?us-ascii?Q?pqSG7ujTe2EGOaOQLUxqaWenVlU8PYOpv3dBrGdnThZOeBxf7wZi6E96I5K0?=
 =?us-ascii?Q?IEVoj0OF7Dd9cDv8qwGFUmrs7Dy8ZWGmLzbM2QuFokCxst+ePe7YT5gT7048?=
 =?us-ascii?Q?K1XQpTCqMKXdO8b2F3keOUDwX8yY6mCsIYV44658W1ppyzO2/Skh6DTz+VRv?=
 =?us-ascii?Q?Tp5lzHuyLUW95P4QriocObF/nKIrcYbPhCWqEB2KtydMviNwCIhBSDuPy051?=
 =?us-ascii?Q?mGLg7sO4yBCCr3T740MzwLteTHUhHtp06el+q7ay6qBHnk6Hoa9IIsAavG51?=
 =?us-ascii?Q?hg=3D=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: f59b206d-0bf2-49e4-5250-08dad4fdfe4d
X-MS-Exchange-CrossTenant-AuthSource: MWHPR1101MB2126.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Dec 2022 07:14:18.6359
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ZoBaj5rXzyvuEdOYmHl/Gn8uI/qMdR3ypqIHtzOCtIVALV4cIULAYToRB8kIwnIY1Sg8cYNireFjm5ZAntc3iVSK/sOkiSrccWncFJacoak=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL1PR11MB5334
X-OriginatorOrg: intel.com

Jonathan Cameron wrote:
> On Thu, 01 Dec 2022 13:33:48 -0800
> Dan Williams <dan.j.williams@intel.com> wrote:
> 
> > Now that the cxl_mem driver has a need to take the root device lock, the
> > cxl_bus_rescan() needs to run outside of the root lock context.
> 
> If possible add a bit more detail here or a reference to the patch
> that needs to take the root device lock.

Sure, updated to:

cxl/acpi: Move rescan to the workqueue

Now that the cxl_mem driver has a need to take the root device lock, the
cxl_bus_rescan() needs to run outside of the root lock context. That
need arises from RCH topologies and the locking that the cxl_mem driver
does to attach a descendant to an upstream port. In the RCH case the
lock needed is the CXL root device lock [1].

Link: http://lore.kernel.org/r/166993045621.1882361.1730100141527044744.stgit@dwillia2-xfh.jf.intel.com [1]
