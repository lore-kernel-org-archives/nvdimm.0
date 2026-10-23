Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.remote-ip=192.198.163.18
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=fail;
	t=1792713969;
	b=LrsXC1NngnLricBubSPBAPaQ2zU2gtznga8AUuT9IcNIlcZQDzIuVSb6ct+U6kRtMyOl
	 WuvnNAtl3Xrf5WuP5n05/H9k/sP/ZWbCpP3W+kS+NMtVNoqwMIMmhS2ZCASxCZjmGuG47
	 L9OGoT9KlTTBZKs7hwMCg0Eq1BM4/LDz72ylvMUqy9XM6IoS8hr0KA+o94ICIPpG0ejJI
	 NSQ23gJo2VdZ+rJf4GQbsWy/w/eblcFdWzTLUMnQ0NntbtxyG/7s827z2wQ7a1Ky9+1o6
	 CCCElrat8f5fDClrgQBwY23oG2PJ0nm44wk4Rq8Slyc1YrMwa+ptqIgT2plJvwMwx3Q==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792713969;
	h=DMARC-Filter:DKIM-Signature:X-CSE-ConnectionGUID:X-CSE-MsgGUID:
	 X-IronPort-AV:X-IronPort-AV:Received:X-CSE-ConnectionGUID:
	 X-CSE-MsgGUID:X-ExtLoop1:X-IronPort-AV:Received:Received:Received:
	 Received:Received:Received:Date:From:To:CC:Subject:Message-ID:
	 References:Content-Type:Content-Disposition:In-Reply-To:
	 X-ClientProxiedBy:MIME-Version:X-MS-PublicTrafficType:
	 X-MS-TrafficTypeDiagnostic:X-MS-Office365-Filtering-Correlation-Id:
	 X-MS-Exchange-SenderADCheck:X-MS-Exchange-AntiSpam-Relay:
	 X-Microsoft-Antispam:X-Microsoft-Antispam-Message-Info:
	 X-Forefront-Antispam-Report:
	 X-MS-Exchange-AntiSpam-MessageData-ChunkCount:
	 X-MS-Exchange-AntiSpam-MessageData-0:X-Exchange-RoutingPolicyChecked:
	 X-MS-Exchange-CrossTenant-Network-Message-Id:
	 X-MS-Exchange-CrossTenant-AuthSource:X-MS-Exchange-CrossTenant-AuthAs:
	 X-MS-Exchange-CrossTenant-OriginalArrivalTime:
	 X-MS-Exchange-CrossTenant-FromEntityHeader:
	 X-MS-Exchange-CrossTenant-Id:X-MS-Exchange-CrossTenant-MailboxType:
	 X-MS-Exchange-CrossTenant-UserPrincipalName:
	 X-MS-Exchange-Transport-CrossTenantHeadersStamped:X-OriginatorOrg;
	bh=IMKckYJBqSYkPi9kMlCkDRbDJge5ylWmUzTW6mZ4LBM=;
	b=czGW4e9eHkIH/Tw3IFmE09XvLHJGktZ8cBIIBcAhmY0tBxVuDvhAHc9ibqr8G9j5Uq0s
	 IV5Lt0qGA2gZhEDZG/TB1dKOkwcaszCSZNXBRCz805KhfyCjfH5TAufhmykqkqFnAJdL8
	 yBMHKiOUMmk+pJvBJNRp/KMivFN1GksMmBHWcDAp8nAY2tLeMk3bUSEZFN5GRpluBu7ne
	 LAVqd9B5UUn63/nswAkY4zM3Rk5s7blnVivK5iwQWajrMQGZjZnvMND5LrKVHtkYJIEIF
	 kx3+gFh41+e1IJbuY3j/tYZ6aNUZIzjgc/wxIKXaUG3c0NUEY5Nj5HEATYuZ1M3YsLg==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=intel.com;
	spf=pass smtp.mailfrom=intel.com;
	dkim=pass header.d=intel.com header.i=@intel.com header.a=rsa-sha256 header.s=Intel header.b=isLjTIIX;
	arc=fail smtp.remote-ip=192.198.163.18
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.18])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7BB00606A31B
	for <nvdimm@lists.linux.dev>; Fri, 23 Oct 2026 00:06:08 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 7BB00606A31B
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=intel.com header.i=@intel.com header.a=rsa-sha256 header.s=Intel header.b=isLjTIIX
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1792713968; x=1824249968;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=esxhYP1tQUYTwudmjiezWb0ES82h51EyPDNxHPmsoEo=;
  b=isLjTIIXvRQ37l/21tsvYIN8gTxgNhIBzXwYLTRtr7P0lBK9/gkGd0Go
   bV3CogOK3QHSg4aOCpmyUl1LCUqRQsPm0ECQ7d3F5mMiv2qz/MmyLQKWo
   SP90Cmzj11sJgAt3BFATZuf6DfMz0/6Ec8VZjcZPXmoay4QDfh8d0DE7x
   9yZ6Fsqoaqi+I860MPrRZyNeN9FgBfCLc8N7F4hJyu7O0wOwFZXgm+zUm
   W6AVIJU8mIfLyTdaqDtIvWoQECm8BoB58akmAXjo4lP5Q3oMzl66lLxy6
   Q7AJ+3uvlzaHFGdo5DNVTLYWwWnozHd5a+XTjDHY4YHm1rdfJE8lwzpm0
   A==;
X-CSE-ConnectionGUID: gNZW8n7aQ2C1BB+9qs5t8Q==
X-CSE-MsgGUID: QmQfyvIwRj24sqcdtac87w==
X-IronPort-AV: E=McAfee;i="6800,10657,11943"; a="1512404"
X-IronPort-AV: E=Sophos;i="6.27,173,1787036400"; 
   d="scan'208";a="1512404"
Received: from orviesa007.jf.intel.com ([10.64.159.147])
  by fmvoesa112.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Oct 2026 17:06:05 -0700
X-CSE-ConnectionGUID: 3QiCQ8iASa+6l3WK9O8p1Q==
X-CSE-MsgGUID: dSgPWpYnTvOxIS9XFxu55A==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.27,173,1787036400"; 
   d="scan'208";a="3401908"
Received: from orsmsx903.amr.corp.intel.com ([10.22.229.25])
  by orviesa007.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Oct 2026 17:06:05 -0700
Received: from ORSMSX903.amr.corp.intel.com (10.22.229.25) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.49; Thu, 22 Oct 2026 17:06:04 -0700
Received: from ORSEDG901.ED.cps.intel.com (10.7.248.11) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.49 via Frontend Transport; Thu, 22 Oct 2026 17:06:04 -0700
Received: from SA9PR02CU001.outbound.protection.outlook.com (40.93.196.53) by
 edgegateway.intel.com (134.134.137.111) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.49; Thu, 22 Oct 2026 17:06:04 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=qr0mO24XiBlLTDjR6Qrbp3KGa96fkl08Hts0Xo7F3gdoouJRSCz+FtBO8AIWJqV/9vYoYf+mg17U15q/mSKQBA3CmoFP+AQhsHISTLBS5ZWB2Xon50xuPPkmX9stuezo48ERi7wArsETKsOhUU03W6Z9vWXRJN1azcf5xKG0HITvWcxg6uLZmJmgmaIYQlCmS/n7GRk7jn9tJJbfgk81wPhG7/COC0i9bn7rjEVE8vjgJGn3wWGhpqXC4QN6dUFrXTazRI4UVIal7psIx0Rvn5EePZBQzJktab3GkezBsCdQp6oRqKcfQoiDI49XHV9O/lOtkTF0+B9w+xIy+aSPLQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=IMKckYJBqSYkPi9kMlCkDRbDJge5ylWmUzTW6mZ4LBM=;
 b=MOOqi4pEOAKrxXGpXdSHKU7LqXpufYDfX9wHUG4yiRamOj/U14fV2r0+xE1ABxlaowUyoffnMldkkliSDV6f2qYiDLUGiD+GJFxklEutHfDJPH7qosrIymU82DVkf4N2IAedB8AN+C+hkpJVtuO8ThQF/h23RUQMuwbbS38CcQezSfokbX5u4j0EFJ0PMTpkALCEJOqyRU5kE5v8Xm7A+uRHVfsQ/G/gO/x4jlwr7Dbt+CjoPf3cxR5ry1Il9hGPJAsMqfww4JHHMPyFsLd0P9tcw4yNlWkeMKe9Oj1zpCxj9V0cVZPoyM21QW+dvw3iCYYSDvaG6/Wcj2Vrt0dUug==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DS4PPF0BAC23327.namprd11.prod.outlook.com (2603:10b6:f:fc02::9)
 by DS4PPFC60125F65.namprd11.prod.outlook.com (2603:10b6:f:fc02::4b) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.546.15; Fri, 23 Oct
 2026 00:06:01 +0000
Received: from DS4PPF0BAC23327.namprd11.prod.outlook.com
 ([fe80::6fbf:c112:d0a8:f1a8]) by DS4PPF0BAC23327.namprd11.prod.outlook.com
 ([fe80::6fbf:c112:d0a8:f1a8%5]) with mapi id 15.21.0546.012; Fri, 23 Oct 2026
 00:06:01 +0000
Date: Thu, 22 Oct 2026 17:05:52 -0700
From: Alison Schofield <alison.schofield@intel.com>
To: Muchun Song <songmuchun@bytedance.com>
CC: Dan Williams <djbw@kernel.org>, Vishal Verma <vishal.l.verma@intel.com>,
	Dave Jiang <dave.jiang@intel.com>, Andrew Morton <akpm@linux-foundation.org>,
	Joao Martins <joao.m.martins@oracle.com>, <nvdimm@lists.linux.dev>,
	<linux-cxl@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
	<muchun.song@linux.dev>
Subject: Re: [PATCH v4] dax/bus: fix Device DAX range alignment validation
Message-ID: <atqk4GgaII0KQQnW@aschofie-mobl2.lan>
References: <20261016053944.2579541-1-songmuchun@bytedance.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20261016053944.2579541-1-songmuchun@bytedance.com>
X-ClientProxiedBy: MW4PR04CA0304.namprd04.prod.outlook.com
 (2603:10b6:303:82::9) To DS4PPF0BAC23327.namprd11.prod.outlook.com
 (2603:10b6:f:fc02::9)
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Post: <mailto:nvdimm@lists.linux.dev>
List-Help: <mailto:nvdimm+help@lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
List-Owner: <mailto:nvdimm+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS4PPF0BAC23327:EE_|DS4PPFC60125F65:EE_
X-MS-Office365-Filtering-Correlation-Id: 611cfe38-ffc1-4bd8-ccd8-08df30996bde
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|23010399003|376014|1800799024|261021121427099003|6133799003|18002099003|10067099003|261022113327099003|261021135927099003|22082099003|261021123027099003|56012099006|11063799006|261009223027099003|261022105027099003|261022075727099003;
X-Microsoft-Antispam-Message-Info: kkkcFj3sjQtEckXiT2ayYSd4EaZBTZwMVbtOr80+/8oOxAxqBRIc1Z/OlT2ezS0tW93UUyn413mT7e9YpXAdAdLcSsK81JLuz9p/8BWt46eH3fuaTwtc7FsTz8GcZ9LNnaCG3P/IlOZmnSMHAE9x166vJdwfAnmfnuZffcb/Oej874iS5je8TaSfaE++cMvaRmJ4ebyrR8hUiISIauj/69EV6ljWnI2tq2JBSQQ0Xq3oj3QqsrTSEa064UY8HRlxHtE39CeJ1fzOwtf22tZUS70HZ8ouLJEOXlNKq70jQhCgeFC8DMJ4tTi7mhNO2yBi0HoOklobo+HtJmQjXEbOLT1XUQSCqqxOiZoKeudO/WNMwin/7jBwmofJZJY0GDI7pMJ0ungyuWSB4IiOWfkvVhDOUHFfH/24EED9jX2GuQ4wGC5zrFlrwE1eK9HdSB+p0uABSF6are+A6MUbwog61agfsliEkRyBmOahU8ssYj+zmuW0v41tdfK1chfxGDj4E5Aj9HPiC+FBQp+qlnj+EM6iOExtRmwFYXZ2TYEsc3aLuJecQBqSREKNU/ELVRW6kHDy7W+shgBy53hSMYI1iiSTbddb/t9pOAI+vjTlUv0Q07Y4CZM93wlkAbvg5LVWH0EDOZ1HlC3L2cj2Znqk9JKscSkMoN2cRfZtxFr7wSU=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS4PPF0BAC23327.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(23010399003)(376014)(1800799024)(261021121427099003)(6133799003)(18002099003)(10067099003)(261022113327099003)(261021135927099003)(22082099003)(261021123027099003)(56012099006)(11063799006)(261009223027099003)(261022105027099003)(261022075727099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?OUxjTpc5pJUCvvybolVlxYdO7yZCApdKw9O6YjLgZCNk4224Qqn/Nyz4p6Yb?=
 =?us-ascii?Q?MXMQI6gV7ceV5Qvj+ua5Zrvv5D7k4V5LQ/a6WGphA3q4tSi3nROrJ2ib0WrT?=
 =?us-ascii?Q?peAYoVKBm8WpyQV8aTmt8u8ql5FmvwNHQ1U0VC9VjzWdhuhZRfQPphunfCqh?=
 =?us-ascii?Q?rc5r8WBuc6mSLZZ6xYfBVPnqYh2QNbfiiWX6fqITYXGwnf86XVP7/dxZbXzK?=
 =?us-ascii?Q?ZXs8rGrRzyWB1eO1WZqdlJsiPSQLMk3g8H0GbkRj58QNpkqf0Y1vmK1xQDSi?=
 =?us-ascii?Q?jQUTF0PgipvkccHOMbBrQL6RcNv0ruAwdveQm83Qfn+S5nlK5kO6NVWfm/Nk?=
 =?us-ascii?Q?qjiqACyWo0iqM2f+EQrm/EwhNj1cSqkkP1LPIsR7QfJAcym/GmVjIvAL28ld?=
 =?us-ascii?Q?0bt+gKrO7NkNqdr/L6LgRESxV9krT/1t28/BGUjVGxBNZVKBMBZh+o6Ejlcm?=
 =?us-ascii?Q?5K2tAPzpB/S5JQm2LBmoZDrLOcrnPQ/iDamseCm8AAFSZH3sNmQ5sA4e+9k9?=
 =?us-ascii?Q?ApIGzWTOl6h6qQcBmUVtwYP1vRAy8qs5mjPnQ6P0vE6nFghDS/tqy6Pn2mI4?=
 =?us-ascii?Q?rcHwJrGyg39/a4g29xnEtgoirCRPtdmIM9hOQu0/BSYy8bpmMreuxydBnJMJ?=
 =?us-ascii?Q?1Wy7zq26j04FXLXnu7EJ0N7RmCxo0m1yvTCMv1aCfa9HcC9hV3eJvJCeMinO?=
 =?us-ascii?Q?wOz5NjRW0fnbUcsNdtuCeiCu9Zoj1OR8o0RbgRWTyiLdWSocrR/Zp1g1lg49?=
 =?us-ascii?Q?Hpb3gBLuLsBHx1x6paNjOdxpBlIIgj5F7UY04dI4MMV1+L2/BoRZQb1M1IjY?=
 =?us-ascii?Q?pJ2033KdZ1a+W/GL/QVqolICl0pSPj3rO2jT/uW+CqcAF0m7QuQMNqReUb0g?=
 =?us-ascii?Q?+cAMYrpTNhjDbd9/klmn3fm+HJwanQytHxW4/M9SdkPcCQZ3zcrNj7h/SIYY?=
 =?us-ascii?Q?v1C0BRA20PFnW3GwU5YehkAcbvLQxT/0V2qpWorEvvDlCE3cWYWKCjvOe4R8?=
 =?us-ascii?Q?/aRpRcoWcSGqHcsLzfqDoFhmI9ipC7QEHG20+q8m3ieSw8GfAyFl8pP7OPtq?=
 =?us-ascii?Q?Oi3RvQeEJYCbB3J+Mz3rPhUUC1dKEyw2j1osLITSsuu+Co2oc7ncBWbiuoYM?=
 =?us-ascii?Q?ReM4oCXxXdKcVqqAOnJ/7jxjVc/fPFnvifbfQMi2hTQ5+4Ydl2Q78IGCkriv?=
 =?us-ascii?Q?zgWK+ReZgR8wwR1PT5tjtHQjcBbDIbyivr2FiY8BL6HUMnyEj2/Ri+8rC0Rz?=
 =?us-ascii?Q?y9AKAiLmG54A33tVLmuS/IiGf1yEiqTFLX0QwPJSq5WHyooy6QI43q3kp43U?=
 =?us-ascii?Q?dUhR2+O7KWXKra8INfKXeA2ANMsTVUC99GmffnfMFCADVjVmkBl5NGmOWRR8?=
 =?us-ascii?Q?bWSYFU74va5QT2uvtxJG69L773MGMl8CX0WM7LHS+nvVJRhxJ10Aqpgqe2Zb?=
 =?us-ascii?Q?KEGKDocNrvUCzvMQsc7pENRSPu0fiJAmpfW2YX/1rCoscdr/JLJl+fxeFB4Z?=
 =?us-ascii?Q?ZS8e0dyrZx8WKObYDUhAgIvmFVu378R9hqCWQhShMvsN2NAovclYIPXI6kdj?=
 =?us-ascii?Q?8pVysSCcYxb1mvBx6c4dYeKoWj96KWsxXVuGKvWProsrAJlZUMrTA1S9L1l/?=
 =?us-ascii?Q?aMPTkFTHr/N8GBjghBNtvYjpLnQV/87mNbXOmQKzogH8ASuY6Jdb758muZrN?=
 =?us-ascii?Q?HaD8eqhSpKACkcWKPGPmsyvGnRDismFK3P5UiWLXieTlSzppkrefKnlzyX2C?=
 =?us-ascii?Q?PAvvpyNtkibCmCGY8rWmQAxv2OQoVuY=3D?=
X-Exchange-RoutingPolicyChecked: e/v7Rn5txHmrY+pHUPXfrBLoc2uuxRtwKbBQXuNAnihO28PM0sh/9MlInH6s8F7hSO0T4scFqdk7dFX1NsLjOpaxSf6CiGDspYGplBI5FGl5nJlNls88gEoXm/o0frP+yzqj5j3RNEed5AdI2DG6+CNzAbEmPYrgAKRPs0zwRL3n3g0fiA3AqRVATjZyOlaeB2b6jRZwC65T0JzfkfX+W8Dl5UZMzxhxY+jyxQmRktZek1ZR+oc1PInaSlZr0l+KMMXL89jSF4kpkG8DhtCMmAYfLSPPaAArmCD33ZFh0QQKRRTmjRUTJU/yWZidQesI32WwmH0/+zI+J0xN4Wvhvw==
X-MS-Exchange-CrossTenant-Network-Message-Id: 611cfe38-ffc1-4bd8-ccd8-08df30996bde
X-MS-Exchange-CrossTenant-AuthSource: DS4PPF0BAC23327.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Oct 2026 00:06:01.0148
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 9yJDfGNMElrTG7QXIl0fRo4p855Iml2YKlk6lauofHaQtyHTPt5d50EV7UwASXQoPAEWXPivOwxub+RkENOtBuHT82FpfOrp84DVajCaYas=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS4PPFC60125F65
X-OriginatorOrg: intel.com

On Fri, Oct 16, 2026 at 01:39:44PM +0800, Muchun Song wrote:
> Only range sizes are currently validated against dev_dax->align. A
> dynamic device can therefore select a large-page alignment and allocate a
> range whose start is not naturally aligned. The device binds successfully,
> but a later write to a userspace mapping may trigger a kernel panic.
> 
> The automatic resize path can also split a size-aligned request across
> arbitrary free gaps. When devices with different alignments fragment a
> region, this can extend a range by less than the device alignment. A later
> allocation then fails, leaving the failed resize partially applied.
> 
> Initialize the device alignment before its first allocation. Validate both
> the start and size of allocated and adjusted ranges, account only for
> aligned free space before changing ranges, skip unusable gaps, and
> serialize size validation with alignment updates.
> 
> Static Device DAX already has a pre-populated pgmap whose full range was
> validated against memremap_compat_align(). Its usable data range may begin
> after namespace metadata, so require only dev_dax->align for static
> devices. Dynamic Device DAX builds its pgmap from the allocated ranges and
> must continue to satisfy both alignments.

Hi Muchun,

One commit message comment:

Now that this is a standalone patch, some useful context from the original
cover letter would be useful in this commit message. 

The cover letter explained that Sashiko identified a path where
`memmap_init_zone_device()` could initialize struct pages with a large-page
order for a physical range that wasn't naturally aligned. You also mentioned
that you reproduced the resulting kernel panic.

That gives us both the failure mechanism and confirmation that this is a
reproduced bug, rather than just a potential problem. Those details are worth
keeping in the commit message.

So I happened to hit this and the mapping_store() issue that was in the
original patch 1/2. Both these fixes solved my problems. 

Below I do have some style and simplification feedback, and am also wondering
about the gap handling logic.


> 
> Fixes: 6d82120f4156 ("device-dax: add an 'align' attribute")
> Assisted-by: LLM
> Signed-off-by: Muchun Song <songmuchun@bytedance.com>
> ---
> v4:
> - Use dev_dax->align alone for static Device DAX ranges to preserve
>   older 4K namespaces (reported by Alison Schofield)
> - Condense the commit message to the failure scenarios and required fixes
>   (suggested by Alison Schofield)
> 
> v3:
> - Serialize size alignment validation with alignment updates to avoid a
>   partial shrink after a concurrent alignment change (reported by Sashiko)
> - Document the size validation serialization in the commit message
> 
> v2:
> - Keep the alloc_is_aligned() name to avoid unrelated helper renaming
>   (suggested by Dave Jiang)
> - Move this patch after the mapping error reporting fix for independent
>   backports (suggested by Dave Jiang)
> ---
>  drivers/dax/bus.c | 152 +++++++++++++++++++++++++++++++++++-----------
>  1 file changed, 117 insertions(+), 35 deletions(-)
> 
> diff --git a/drivers/dax/bus.c b/drivers/dax/bus.c
> index b809e1a264af..b2c83a0e4ec5 100644
> --- a/drivers/dax/bus.c
> +++ b/drivers/dax/bus.c
> @@ -848,6 +848,52 @@ static int devm_register_dax_mapping(struct dev_dax *dev_dax, int range_id)
>  	return 0;
>  }
>  
> +static inline unsigned long dev_dax_min_align(struct dev_dax *dev_dax)

Why the static inline here and also why below do you change
alloc_is_aligned() to static inline?

coding-style.rst is against it in .c files and we don't do it in any
other drivers/dax/*.c code.


> +{
> +	/*
> +	 * A static device has a pre-populated pgmap whose range already
> +	 * satisfies memremap_compat_align(). Its data range may start after
> +	 * metadata at dev_dax->align granularity.
> +	 */
> +	if (static_dev_dax(dev_dax))
> +		return dev_dax->align;
> +
> +	/*
> +	 * The minimum mapping granularity for a dynamic device instance is a
> +	 * single subsection, unless the arch says otherwise.
> +	 */
> +	return max_t(unsigned long, dev_dax->align, memremap_compat_align());
> +}
> +
> +static inline bool alloc_is_aligned(struct dev_dax *dev_dax, resource_size_t size)
> +{
> +	return IS_ALIGNED(size, dev_dax_min_align(dev_dax));
> +}
> +
> +static inline bool range_is_aligned(struct dev_dax *dev_dax, u64 start,
> +				    resource_size_t size)
> +{
> +	return IS_ALIGNED(start | size, dev_dax_min_align(dev_dax));
> +}
> +
> +static resource_size_t
> +aligned_gap_size(struct dev_dax *dev_dax, resource_size_t *start,
> +		 resource_size_t end)


Please keep the return type on the same line as the function name, like
rest of this file.

Also a function comment like:
/* Return usable aligned gap size and update *aligned_start */

and a rename of *start to *aligned_start would make the contract clearer.


> +{
> +	resource_size_t aligned_start = ALIGN(*start, dev_dax_min_align(dev_dax));
> +	resource_size_t size;


How about calculating dev_dax_min_align() once and keep it in a local variable?
We use the same value again for ALIGN_DOWN().


> +
> +	if (aligned_start < *start || aligned_start > end)
> +		return 0;
> +
> +	size = ALIGN_DOWN(end - aligned_start + 1, dev_dax_min_align(dev_dax));
> +	if (!size)
> +		return 0;

The above early return looks needless given how callers use the result

> +
> +	*start = aligned_start;
> +	return size;
> +}
> +

snip

>  
> +static resource_size_t
> +dax_region_aligned_avail_size(struct dax_region *dax_region,
> +			      struct dev_dax *dev_dax)

Same as previous, keep return type on the same line here.

The dax_region argument looks needless as we can get it from
dev-dax->region.


snip


> @@ -1062,37 +1130,51 @@ static ssize_t dev_dax_resize(struct dax_region *dax_region,
>  	 */
>  retry:
>  	first = region_res->child;
> -	if (!first)
> -		return alloc_dev_dax_range(dev_dax, dax_region->res.start, to_alloc);
> +	if (!first) {
> +		resource_size_t start = region_res->start;
> +
> +		alloc = aligned_gap_size(dev_dax, &start, region_res->end);
> +		return alloc_dev_dax_range(dev_dax, start, min(alloc, to_alloc));
> +	}
>  
>  	rc = -ENOSPC;
>  	for (res = first; res; res = res->sibling) {
>  		struct resource *next = res->sibling;
> +		resource_size_t start, end;
>  
>  		/* space at the beginning of the region */
>  		if (res == first && res->start > dax_region->res.start) {
> -			alloc = min(res->start - dax_region->res.start, to_alloc);
> -			rc = alloc_dev_dax_range(dev_dax, dax_region->res.start, alloc);
> -			break;
> +			start = dax_region->res.start;
> +			end = res->start - 1;
> +			alloc = min(aligned_gap_size(dev_dax, &start, end), to_alloc);
> +			if (alloc) {
> +				rc = alloc_dev_dax_range(dev_dax, start, alloc);
> +				break;
> +			}
>  		}
>  
> -		alloc = 0;
>  		/* space between allocations */
> -		if (next && next->start > res->end + 1)
> -			alloc = min(next->start - (res->end + 1), to_alloc);
> -
> -		/* space at the end of the region */
> -		if (!alloc && !next && res->end < region_res->end)
> -			alloc = min(region_res->end - res->end, to_alloc);
> +		if (next) {
> +			if (next->start <= res->end + 1)
> +				continue;
> +			end = next->start - 1;
> +		} else {
> +			/* space at the end of the region */
> +			if (res->end >= region_res->end)
> +				continue;
> +			end = region_res->end;
> +		}
>  
> +		start = res->end + 1;
> +		alloc = min(aligned_gap_size(dev_dax, &start, end), to_alloc);

We're walking the free gaps twice now. Once in dax_region_aligned_avail_size()
and again here. It seems the 2 walks need to agree about which gaps
are usable so that the pre check doesn't succeed and then the allocation
loop cannot satify the request...which would get us right back to a
partially applied resize.

Please look at sharing the gap traversal.

-- Alison

snip
