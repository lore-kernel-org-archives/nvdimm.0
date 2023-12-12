Received: from mgamail.intel.com (mgamail.intel.com [192.55.52.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D67CF660EB
	for <nvdimm@lists.linux.dev>; Tue, 12 Dec 2023 22:46:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="SAWvW5JA"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1702421184; x=1733957184;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=Rjc4J7XzpcJ3KKOzIgNvck8pg1w5MfLW0kUUR+IQixo=;
  b=SAWvW5JAGsv/QDY/GSDGK/STGIi+kRbKfJxupwWxiuxzB8A3iZHQZli1
   TxVYaPoAzZSixE86fKepBhx2SW3fT6sFYnpVOlOVXXv9n6JtRuCAARIpn
   tF6PqOlzkH145qqxTqtcORth2YcitsIoFjHu3pcz8ysI6pA8Lb48yBAzs
   98iWgDBd1YBmNTPVoFOCfuktGuvqBMtu4AlZFnBRoXZqIz/qipQHclSPS
   EVHb1fe1Ziz+8FL4QdkIaxceEivkwEh8bf9QtSLguoDlHORUZoQrU1c8b
   OgUR8flLVzPo5FctkfAdR7FF33xDhlRtyc4v4mbq14+vHsXSy6OAUJNAx
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10922"; a="481081099"
X-IronPort-AV: E=Sophos;i="6.04,271,1695711600"; 
   d="scan'208";a="481081099"
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Dec 2023 14:46:21 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10922"; a="766983475"
X-IronPort-AV: E=Sophos;i="6.04,271,1695711600"; 
   d="scan'208";a="766983475"
Received: from orsmsx602.amr.corp.intel.com ([10.22.229.15])
  by orsmga007.jf.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 12 Dec 2023 14:46:20 -0800
Received: from orsmsx612.amr.corp.intel.com (10.22.229.25) by
 ORSMSX602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35; Tue, 12 Dec 2023 14:46:19 -0800
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX612.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35; Tue, 12 Dec 2023 14:46:19 -0800
Received: from ORSEDG601.ED.cps.intel.com (10.7.248.6) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35 via Frontend Transport; Tue, 12 Dec 2023 14:46:19 -0800
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (104.47.56.169)
 by edgegateway.intel.com (134.134.137.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.35; Tue, 12 Dec 2023 14:46:18 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=WibHmF0wEzMtrE6rvgIpiMWvEBmODmXLYdvNqFmmDNrOr8ICXhHRPSuUyvcItCfa2lJFM5iSyePeJi3X2Wk34aQaI5b5Vc68DxAojZrZ7WfsofIETviIr8YHbti4WjgGIcGssi2TJpeGBSWZOXHif44F53VphGDIqZZa6DePkStC8VEqwFsNj21+c2WfEId8Ex5F4UKTi6voFouWSxA/dZ2a6WyjrVMy57M+1akOqA9bPvzmTr9LobjI2zW1pSNXJYSlIvj4swF9z99+gdT7GrsLzmqkBcjntlfAJhie55Jy/Ek7x7C8lHEK7wrUiicXmuNVvhWrc4f+B2NZ+Xw27w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=jgybsKJNEKNC9wdDURf7TajFuKgFwXPS4O2fT8IhKcY=;
 b=OYfgwl/5h12Iai4ekrD2p/MVF+mN97mgSIyqiSQW61b3UO5XiOc6X+DFXBNQDEUxBYCneIFVed/sEbZcmoBMv2dfC9VBVZCppKwUtFJwjZ29OGpYiQA1oMvzNqQDGTb9sY9p9M127IyYhBLeEnSRLik0ARyqeD4Fbh9ZYxKsBsjDp78Vsg+OfC6IXeZjA2gphVCdgGsWNrRLpY9h5wKCvejVuLUbYjnCwe+feSijGTMPPybrtmI+F/ONjGpp1Mf6KFFXDxtHJ9ky8JzMiuacnvirSpPsHu8USxwy7x2X1FdavyKZVj/KSWjFTiW7nsQXEuzjyl7acHxn2d2I5LY9sQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from PH8PR11MB8107.namprd11.prod.outlook.com (2603:10b6:510:256::6)
 by SJ0PR11MB6623.namprd11.prod.outlook.com (2603:10b6:a03:479::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7091.26; Tue, 12 Dec
 2023 22:46:17 +0000
Received: from PH8PR11MB8107.namprd11.prod.outlook.com
 ([fe80::6362:763e:f84b:4169]) by PH8PR11MB8107.namprd11.prod.outlook.com
 ([fe80::6362:763e:f84b:4169%5]) with mapi id 15.20.7068.031; Tue, 12 Dec 2023
 22:46:17 +0000
Date: Tue, 12 Dec 2023 14:46:09 -0800
From: Dan Williams <dan.j.williams@intel.com>
To: Li Zhijian <lizhijian@fujitsu.com>, <nvdimm@lists.linux.dev>
CC: <linux-cxl@vger.kernel.org>, Li Zhijian <lizhijian@fujitsu.com>, "Dan
 Williams" <dan.j.williams@intel.com>
Subject: RE: [ndctl PATCH v2 2/2] test/cxl-region-sysfs.sh: Fix
 cxl-region-sysfs.sh: line 107: [: missing `]'
Message-ID: <6578e2b1609e9_a04c5294d3@dwillia2-xfh.jf.intel.com.notmuch>
References: <20231212074228.1261164-1-lizhijian@fujitsu.com>
 <20231212074228.1261164-2-lizhijian@fujitsu.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20231212074228.1261164-2-lizhijian@fujitsu.com>
X-ClientProxiedBy: MW4PR04CA0319.namprd04.prod.outlook.com
 (2603:10b6:303:82::24) To PH8PR11MB8107.namprd11.prod.outlook.com
 (2603:10b6:510:256::6)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH8PR11MB8107:EE_|SJ0PR11MB6623:EE_
X-MS-Office365-Filtering-Correlation-Id: 023fb43c-7319-4d9f-c338-08dbfb6426b6
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: VEDtZfFLajay0zs+HGNPJnrTELvrnkm3qy+uUgb90UblmvzxyA15H0ukydGOuteheAUn6kfyb0C2Rh3xlDcq51pBKF3PjQ9dtfklF5QSplmPC0O02Ob1pxW4XnMMbPs9HgFG7/rEwGHhnthEjCYp2z4ePGcnldmmDDs8lVBUssSS6Lstkx8ucMsGUqrSA4ZvwK4nKPV7KK++9qRkZ7HNXcEZI5mrdkLupcda+YWykM9SKebxw01+nMBBwmZVypgg88zYVwWz/9F0WPw3xoEocTDdct4t1mTsuQxUJmiwI/U8OrfPbfEpgmqaFUy0PILmKo+ZPXLmygWa0Y7SRMlgQSE7Vpqc2SbimBGgnZhnQlTy1EeWb/MpM4I40xhsfSuNjvCh8dLMBiXMXuyK0Dnu3Kogjt3Fc+RllZzCaMwESLogozQJL5OY61pFn0AEnsljnGwx1Nb2lOo+14BQbeSVU1+yyIpqL57JHRu21ULJS2lp7Osm9Z53WSwxFMwTQGGQ95oYsVKk0sixXZ4qo3HrHb34oqsZqqVpvHXtfbdmtm8y6njVgLayU5EENtxJGHwA
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH8PR11MB8107.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(39860400002)(136003)(396003)(366004)(376002)(346002)(230922051799003)(186009)(451199024)(64100799003)(1800799012)(66899024)(41300700001)(4744005)(5660300002)(2906002)(26005)(107886003)(6512007)(9686003)(83380400001)(6506007)(6666004)(6486002)(478600001)(38100700002)(82960400001)(86362001)(8936002)(4326008)(8676002)(316002)(66946007)(66556008)(66476007)(54906003);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?Dh38/ISxE2od/GV/UilenW0w8liKhQp7nWUQxeabv0cZH9fcTbVqCTtff4UM?=
 =?us-ascii?Q?rtMmOLhInfnt30AMJlqMyGCllXASJSAr/lxBOrkRAOQ22l2cjBO4eDs1i2Ia?=
 =?us-ascii?Q?GyTc3n0OltL4tjevtdH8rZd5HhBWXT+A7wbm7UUHF9svRLkVohn1CaPAZV31?=
 =?us-ascii?Q?sCX0UClTanBE9hVx0lVgB1BlZnCzccGbrfTCf9GJr/BTWcVZwNxTY0eo5yqJ?=
 =?us-ascii?Q?ixAyh6fVHdwkeAmJRKewLpSZxovCn9jEdpZLJJ6K+Mw5NeC4haabdaE3+NVn?=
 =?us-ascii?Q?mWSpguy0nsShwx+sP4FKmbBk5p2I1HC5W2jwCM/Y7j0oCBNY0E7+S5JSU/92?=
 =?us-ascii?Q?GHyO7qzRydv7jE0OethAeW+Jowd04R3oEhKviMNz8+EWwuFxlaOwW4KsaTSF?=
 =?us-ascii?Q?CFf2L37ieTRA5+ueJTbq6DDKPT+rngju+HgKTXffMVnpuz9GahjJ0S/oBwBF?=
 =?us-ascii?Q?e8+fosvv0UGzTJe9OvbuOuKZKHV9QAzsXBEQZDSL+9KatXUscPzSWP8x0rMz?=
 =?us-ascii?Q?5i2YNTghTU2rCje2418V+OPZtHXGwFmTvVa3SXv/CJW+iecbuj+UpZpEOLY4?=
 =?us-ascii?Q?3nANvzOjkovfJzJdb2zSBu5tUHrTiXkKbYEQKwl2s7GLVcfmgLENDpkFvfOI?=
 =?us-ascii?Q?abg1PlyhuJ86e77lz/961yjTcMSxuP5kQ0ysZHnGH4Q2yVUVGVrVTWqpVQfA?=
 =?us-ascii?Q?t0Xv1s0w94QwK2BWGcldxAYcuBOrDO3bQuDpazoRO2Dkgu286DOjGUiZU2hH?=
 =?us-ascii?Q?iCZDI+fliwDOi3D0G5MrmYjYf3PhKT0+z/a6bLuH6PkVNTKmkpoe+HJAUbnx?=
 =?us-ascii?Q?cG8KfYUmGKk8k5Z5zTIcbDomR5X8ForyU2c94zrvY0KgAb7CIY1pVHG94eXW?=
 =?us-ascii?Q?Ss6lYpUXSLTYfZaD12sIeX/+zGGJbwit/8DvG1tBF8ooq++DTRGLfbkOkqpf?=
 =?us-ascii?Q?nh1o/v0QZcd9ojQ8EMtoDt8m2KVGNf8aIeN3RLd06OzgEYiAHgMKnNcWN/Id?=
 =?us-ascii?Q?wP1ENlcNJ4Gedz1ZThpGr3EI31r9uEoMaYAHXwsuz5zLvGGx2UwJMgwq0sla?=
 =?us-ascii?Q?k176Hv+MEJ7vtc4v/l+Itzssjm1LEJNAUMqEYcFsCvLXheiKHBcBXT+ShX2m?=
 =?us-ascii?Q?Gi7WNFxvoUmhtp/2AiUr52/8ks7MuqkmGRQYLWmwmuyNgUTAYlKx6TX5rm3D?=
 =?us-ascii?Q?IeiVG6WSSrZAZtEF2FSaEMCoWjxeiXGC19CuhoZtKF/4tft5wmx9zaSws5sS?=
 =?us-ascii?Q?tHwwm7MJbPwNvi8WzHaot720q1lhoBEvUpTs6ILVlKmIZzVRD2sQt4QB3AqO?=
 =?us-ascii?Q?SmaIPg51iZcIfEJKvA2EMWID7w+8COANcq/fbp1Gn6K2aj+Clp+8KIlJg/bd?=
 =?us-ascii?Q?VP21Mb+gag9HLkMIs/w/IFLT8yVyt5jeNFt0VGCh+KH6YsSPwHsPMT+QtpJb?=
 =?us-ascii?Q?mSyKpIAR5/ZmCAeOe3TBKwZ6O3pC0UJ3JfRAnD8iXUY3VEyoKH1zA63x53Fh?=
 =?us-ascii?Q?hm3ql1u6E25Wkcb89fckjeCYZn7+daxuuSFzsv4+rXbxFbNiTK0x/Orfc1pK?=
 =?us-ascii?Q?ck9R/T456g+bE4lUf/UkqnpKrgD9hvcNtLfIcM1MSPVFbewhrZoJJXh8ngr1?=
 =?us-ascii?Q?aQ=3D=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 023fb43c-7319-4d9f-c338-08dbfb6426b6
X-MS-Exchange-CrossTenant-AuthSource: PH8PR11MB8107.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Dec 2023 22:46:16.9459
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: kso/ug7wr+/zZ8Ml1TdGm19q/wL46lqMPFp4i81gqb0rj7gMGWOgCnvLh3Ta6Ttg0VZ8MN/rh4rXmLMr1mq0xS5SGD+BdQgYu1x4hQ7qAWI=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR11MB6623
X-OriginatorOrg: intel.com

Li Zhijian wrote:
> A space is missing before ']'
> 
> Acked-by: Dan Williams <dan.j.williams@intel.com>

You added my Ack without addressing the feedback.

"Commentary on the impact of the change is always welcome."

Please include a sentence on how this triggered for you and some
analysis of the why it has not triggered previously. Otherwise "A space
is missing before ']'" does not add any information that can not be
determined by reading the patch.

A useful changelog for this would be something like:

Currently the cxl-region-sysfs.sh test runs to completion and passes,
but with syntax errors in the log. It turns out that because the test is
checking for a positive condition as a failure, that also happens to
mask the syntax errors. Fix the syntax and note that this also happens
to unblock a test case that was being hidden by this error.
