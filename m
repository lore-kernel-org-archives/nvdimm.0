Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.20])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E0B402DB7B8
	for <nvdimm@lists.linux.dev>; Wed, 22 Jul 2026 00:19:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.20
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784679577; cv=fail; b=IT0/FuF9TN//AYi2tTGB4M93wmvOQyw0o/BniA9/y1Gf6PkPIIuFcPHJiLO2tbQ/w+zAstVlq6sDUKtLO0Y5QRYJac7abBnu9PoSG0PaqBZj9btWcBKJQnOP5OavxLpvXyk6wHrqpodN2/RnMH3nNcyXoJSDhieqW0kOkXDOEyA=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784679577; c=relaxed/simple;
	bh=MkXAatsWGVPeJxI8X5Or8u1OJaWdGaTactY2Ur3vIAM=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=U8uY4ObUeyWn5qgpxhVlRrsgUsVY44PraIV0RrXRqmAIUZtrDpvFi1Ljr5kNMCvCb3iYEge5H/irSD4+ObRA2gHnCSfJ9AjfbH0sIzIooj0t41jIcH6eHXPkNx7Uu72NMjlwIY96yjPHDeY4hanHbco+SmnJUuiGpnuwkjXzVWk=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=Scl8QKqa; arc=fail smtp.client-ip=198.175.65.20
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="Scl8QKqa"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1784679573; x=1816215573;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=MkXAatsWGVPeJxI8X5Or8u1OJaWdGaTactY2Ur3vIAM=;
  b=Scl8QKqaMHtkhYzYi/PpVZKN6LlBGCxJKL+8zPVHG+Th+DWKUWIapPTb
   MewI1kj6NKVjGHqkgt7jA8RzBfc75AtH6aBalUIXPnb2dOjk2kLnYmmdU
   NVNHsv9UdVph/db1NCZuSoSf/w+DPz+BPRn2nthZWeRv2Fvcnb6IA2Fc/
   n+FKNvk4R42USJJwpvbF/pV/xwuGdhiUDjP8PiOGDikG44E0h5Zf9DwSc
   3Mi1At/aiiAZ9mHP/R/QEA1j7kTX9Co/DNQkFOPMOXc2+V3Wh5Z/Ev74c
   6TqVvq0nqX6ZyOoMpksFVl2Umgr5ALGkiqDwRu+Zhm4NzRrsggLKEPNgO
   g==;
X-CSE-ConnectionGUID: moNm8VgaTNi9elJU/oiarA==
X-CSE-MsgGUID: 6rN4ctcwQSuCmqQsV/3MkQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11853"; a="85064887"
X-IronPort-AV: E=Sophos;i="6.25,177,1779174000"; 
   d="scan'208";a="85064887"
Received: from orviesa004.jf.intel.com ([10.64.159.144])
  by orvoesa112.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Jul 2026 17:19:26 -0700
X-CSE-ConnectionGUID: GHZsmxLSRiGLjNvnrHdcAQ==
X-CSE-MsgGUID: IqDjLdw+Qi669gwiElcAAw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.25,177,1779174000"; 
   d="scan'208";a="261701732"
Received: from fmsmsx903.amr.corp.intel.com ([10.18.126.92])
  by orviesa004.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Jul 2026 17:19:26 -0700
Received: from FMSMSX903.amr.corp.intel.com (10.18.126.92) by
 fmsmsx903.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.43; Tue, 21 Jul 2026 17:19:25 -0700
Received: from fmsedg903.ED.cps.intel.com (10.1.192.145) by
 FMSMSX903.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.43 via Frontend Transport; Tue, 21 Jul 2026 17:19:25 -0700
Received: from MW6PR02CU001.outbound.protection.outlook.com (52.101.48.71) by
 edgegateway.intel.com (192.55.55.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.43; Tue, 21 Jul 2026 17:19:25 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=WAfwTVoceIXNOEPuV1q0DoodkqhB6AT06g5/E15JKdS55ItIos78nq8ue6ROV0FksL/yi/ReQKQXX5BXl8/h6eAmzEVc61SfR8MLdFDk0f8vz3/+e+8vJaUYAq2cOGe2/KVAPq5L6GMoFTHkn3w3Km1HUsSDfAWyhCJ9QthUFp4u4mBgKH8W6l8RwLNeJ3mT2qODyyAYcXc9FjK2vWJG2ESKcdN20VpYRKuqsPv8FsamL/2WMa/eSfQR1ORoZPY9BKGSSV7JEewdjilnF/zGGDY063q/o8MvotUvDH6bQaJ+82ByK+jMiqdB5GfQs+zelY0AjWmE3Ws1Cwxej/Vang==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=O4UVmaV+X/+2NLRrFm28bG8MzZvgNiXZk9tXr6rcrQQ=;
 b=vx0xssivwIpjwFD6smBAwKb02fTyujLMvYuPGfjrwrMzF7FNfFcgwwKcYVcvch09VPz1op2vQ7y3woNJB36Uc8aXyX6yMUL7bUTSiyEjj4yTbNdCeB4MKh0QvWOoW5UfQwu2uTB67GHJHuYgNv1+SF44oaCKT0s/uLj9k1123UFdPkOxBtslWym8jIwnO42MzMzULUE71VGDNudrGWnup65apNEloziTLG3QCvy8K5tFXZJh46SH533nAEL2GA2HbhgwhcwTSD6UlRB6y8IjvzXT/zSmDYqA8Gl1QqgjdhiCJltI96Koo5xKXuM5dcM1hcZj3imOytUR5UPLPTvPYg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DS4PPF0BAC23327.namprd11.prod.outlook.com (2603:10b6:f:fc02::9)
 by DS0PR11MB7998.namprd11.prod.outlook.com (2603:10b6:8:126::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.245.10; Wed, 22 Jul
 2026 00:19:23 +0000
Received: from DS4PPF0BAC23327.namprd11.prod.outlook.com
 ([fe80::a195:49d4:38c5:3891]) by DS4PPF0BAC23327.namprd11.prod.outlook.com
 ([fe80::a195:49d4:38c5:3891%4]) with mapi id 15.21.0223.017; Wed, 22 Jul 2026
 00:19:22 +0000
Date: Tue, 21 Jul 2026 17:19:18 -0700
From: Alison Schofield <alison.schofield@intel.com>
To: Richard Cheng <icheng@nvidia.com>
CC: <dave@stgolabs.net>, <jic23@kernel.org>, <dave.jiang@intel.com>,
	<vishal.l.verma@intel.com>, <djbw@kernel.org>, <nvdimm@lists.linux.dev>,
	<iweiny@kernel.org>, <ming.li@zohomail.com>, <gourry@gourry.net>,
	<rrichter@amd.com>, <linux-cxl@vger.kernel.org>,
	<linux-kernel@vger.kernel.org>, <newtonl@nvidia.com>, <kristinc@nvidia.com>,
	<kaihengf@nvidia.com>, <kobak@nvidia.com>, <mochs@nvidia.com>
Subject: Re: [ndctl PATCH v2] test/fwctl: Add Feature OOB rejection
 regression tests
Message-ID: <amAMhmCpBCKC1XOB@aschofie-mobl2.lan>
References: <20260721062122.24138-1-icheng@nvidia.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20260721062122.24138-1-icheng@nvidia.com>
X-ClientProxiedBy: SJ0PR03CA0338.namprd03.prod.outlook.com
 (2603:10b6:a03:39c::13) To DS4PPF0BAC23327.namprd11.prod.outlook.com
 (2603:10b6:f:fc02::9)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS4PPF0BAC23327:EE_|DS0PR11MB7998:EE_
X-MS-Office365-Filtering-Correlation-Id: 2d882d21-0409-40b0-28cf-08dee786e174
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|23010399003|366016|1800799024|376014|7416014|56012099006|11063799006|10067099003|22082099003|18002099003|3023799007;
X-Microsoft-Antispam-Message-Info: m0mUe3rBJI/Y2VIrGC77XrZZQTAam38pvv8xGY+eDjBMGrW8VBH0vsAlCPT3YTyqpKo5LZKnrJIFwH+6pvWkuvZdx/S2ouMUlNf6JUbrc77Q6ROR4FmQSfJ8Vsb9M/Wcqopt4SsWX0oWGfWzftHMT9qdsnLSbfQHaSiPyC0VD0BTg2M0tHW/ps/Y4NFAsKWyDYFZvbwTtLcoW2zgEHTrbInVkENNVBGjysNeTh9MYTEYSiDAT1rw9M90spgO3+exDrMEbrupIsuzwJYpkc8kc6lZ4CO0Qx5EDt0a1omi1CjeDQOHXB0XtjfrlmlTwEWerUEVREoXG/xyqFc4vhf3l4lhXlg8Y15svtgZiNtu0AIpDQAwiIa24PGTHx38XWlFPBeyoe4gN3+dj7DyVRmWUK5vkGYr/RbZdI8ON5SLASzs2gzdQdfbtOBYFqLvViJcyWtxhS59zi3kYySC3rI7BW9OOF5J3Q21Wk1o5lvJM0UvLiUaOt/nkECNz7EEhKrBhHTZCPS//cE+3E0IOxxboorRQpBfRLK16gb0Zpg80lj7yiggtshHLE9Q90GUhXW0Ddh27hCBHtO5sOqCwnFDQFJXvnrRAixMaqxnqJrMI2TjDycIOHM8ARFrZztr2fk3s1AdQ6GEbfzIgfGw7Jj56QwkolhOWpQyqrC4TEypmjQ=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS4PPF0BAC23327.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(23010399003)(366016)(1800799024)(376014)(7416014)(56012099006)(11063799006)(10067099003)(22082099003)(18002099003)(3023799007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?lnEBkrxzL8asD2Rw3hCKJOaWO4b1yEvh2l6XuRQf/vchYGcnFKDTxNVyFtLS?=
 =?us-ascii?Q?U4TS9CkvF5DrViccQvdKH/yTLFiOfdrZvtRZCHQjNfwRt+0LZePKVlulIf5h?=
 =?us-ascii?Q?OOqG1wUPAGHnE0lnDzz62jSCOg/dhIzBu8X8EVcIL5Ot800LS7Fm33F9fAX7?=
 =?us-ascii?Q?+0/gp+Cw6lUpkJ7BsDbCDn2KdK7//0hAlvgy4wTTLmwqD5wIObvUFWmjNrHL?=
 =?us-ascii?Q?n1dLJt+1WTkTmKZOiISVlgxX5WDxx5hVwWlq2jT2CYbaxV3NSaaVjK69gnVJ?=
 =?us-ascii?Q?R/vhOh0UifQulpWsXmxps96mlIqvLC+9aVzqiT40P8aT7eUj5rHA5IKQ8OJu?=
 =?us-ascii?Q?ImKq/bfoCpuM+3nwtBVtbVBUEytoHlI2ilSTGO9LiqYoiV8zJc0OUeDD94xY?=
 =?us-ascii?Q?c8VsQrh+wNxXPgUCURHK/GctJJfDnxwE5tT9dyv1A+7ulKqYNHZhzsptc/OF?=
 =?us-ascii?Q?VJ8Y69Fhv5zjF4Zi9Ciq+XMsVeg8NT+Alk5VtHORsj6RdiEkmaBFbc3ls4JW?=
 =?us-ascii?Q?mEl6/T1jgNzHRrO9qoqT7KdV5vF5y6AiiMvVkq25beXulP3jeYtE1Rt9q/uy?=
 =?us-ascii?Q?MMXU0EdGv2Schb3tLpPgLBxIcPornA9agnydTC87wzNupMpU1pSAKMevo+uG?=
 =?us-ascii?Q?CJRGtOL8sK0ixUnMu2j9Ox9nQc6GICpATsljTXubr3iheiw1UWddRNEZjxqC?=
 =?us-ascii?Q?/fmNaLmuIKc0y2EFBgEDm4l7KQHpsEDA9giS/ybEiUC5Z9HQg/YHLb4VN/DK?=
 =?us-ascii?Q?alqKQMaN7BWwijJaBuQKQpW72zh279WvFIwr8caqosFOJhNJl55d5CCfjrvd?=
 =?us-ascii?Q?WJwGmVi/hq6q44+ZvYrKaJQKZ1KHliA0bxFTlfg1Cf1LDLbWuF31yVe2ONOY?=
 =?us-ascii?Q?iEHFwS1+MeFS3jKtEDtTVoYKTZgkD2ktSVh8w7Lx2qHK7NeH9pF6h0g/pJEk?=
 =?us-ascii?Q?D1HAXC5KRzcTWKlTaeVb+jWUrhbrD9tGu0OFTQFIWRe2LnwazoIY9n5TSS8p?=
 =?us-ascii?Q?/nFzPdKX8zt9W+ss64DrKlXA/wI34R8aJt7LuKNoCy67EFvQxnIscP0LlzpC?=
 =?us-ascii?Q?XMkZjMo7FzNEYNycHFd1dorda0YkvHzIa1pZEpJlH6Q2GW90D2MTfJQmgvrB?=
 =?us-ascii?Q?wXU+IfYC6uXsRZ+IU3IrpCC1Q1VlmfbZe/NYmbPDUABzLWpMkRZyanYxprvY?=
 =?us-ascii?Q?You5FEiEuMlvvG4v8hbB6voxh8W5vbd5qqYHtndZkTY/jxOaf56XKSlltH14?=
 =?us-ascii?Q?i0x/jOq5dyDWV+5WzGk90EkXRcmAU1hnPhPhK3ofoKZ2vB8/thZ8eErEPYRg?=
 =?us-ascii?Q?Lb5KWPfpeCjktIfZ8Mu+EUUUDUIaNfMATdv3oiAHxa2XW13qIPfBEDgs2mvy?=
 =?us-ascii?Q?Lx+xfNLDfKFf9SLEe/P+EqN72mMn3893GQaPi2ymzqsypMn6snCA1CSkoCKq?=
 =?us-ascii?Q?cySqrg/mYNaIuT5VlcVUTmFttsVxVlb8skgaCCiz6FKKU2jDtZOaQPFuocj9?=
 =?us-ascii?Q?NeX09xZuqKcqiUfjom9nEgVPw4U7Q/v9D7I0R60pIhBfZ+n/Vj/04eDylbaN?=
 =?us-ascii?Q?+EW2JnflbNP/XfPSrSkSSnflW387a4p/TVSyMEhIgv/I/qyUwnVxrdQiiZ8l?=
 =?us-ascii?Q?+EgukSg/PKbofzMOzGxaJqsmIb4tXEXJr7hBw/IHgoB+gLhZmnm7eReTCDq4?=
 =?us-ascii?Q?Kg1LT4u0N77+X+s6NX36TJmwELA0YKUY1jJRgx3ft1VTy8KJ8rpF9b0dIAI7?=
 =?us-ascii?Q?bH+TCTDyCh7qDPa37ofkeZ1ULJgVqpo=3D?=
X-Exchange-RoutingPolicyChecked: d0O7gBN6or+IQKdWjSLF2eO6knhJ7Po9Y1j+MGH2O4mrg080MSLn+niSJ9p1wPKyasH6EOnJxvl0IvGHx9Vt/qq3WT3B0UzI32d1YscEjNmnY3rverSqUHhFA2MTIY/spm/d3FGku9n1SzvxXDJanf3bsK5OgljsMR93d/YoBzZpmSW63czkuExI4MKd1tlxLoLHyVo+cc3bNQIIqp/TsG+pP38oi3ErE3l/a3CDsWdqbibvfz0lmTShZLiZtGX5SzmAESmtUG216HLUEdKHptF/avBhRkggkyw8Jeg02jyHnoUVijpxYeYgaQPutkYgxdRvbiow/FWuY/G9cGDEtw==
X-MS-Exchange-CrossTenant-Network-Message-Id: 2d882d21-0409-40b0-28cf-08dee786e174
X-MS-Exchange-CrossTenant-AuthSource: DS4PPF0BAC23327.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Jul 2026 00:19:22.8601
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: lj7+MqpvudtEr4UEHGH1f0y2qj09mQLHr6rx9kPHkJ3qMVPub5DsAKlrVGGzBIxxbpCgC2XA3pjplNN98CjfozQRanlx3rUX9hyrZNOIHms=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR11MB7998
X-OriginatorOrg: intel.com

On Tue, Jul 21, 2026 at 02:21:22PM +0800, Richard Cheng wrote:
> Add negative cases for the CXL fwctl Get Feature and Set Feature output
> buffer bounds checks.
> 
> For Get Feature, request a non-zero payload while providing room only
> for the fwctl_rpc_cxl_out header. Verify that the kernel rejects the
> request with -EINVAL instead of writing past the rpc_out buffer.
> 
> For Set Feature, build a valid request and set out_len to zero. Verify
> that the kernel rejects it with -EINVAL. Without the bounds check,
> kvzalloc(0) returns ZERO_SIZE_PTR and the output header write can oops
> the kernel.
> 
> Both cases depend on fixes [1]. Gate the tests on the running kernel
> version so older kernels skip the unsafe requests rather than failing
> the fwctl test.
> 
> [1]: https://lore.kernel.org/all/20260624134737.49166-1-icheng@nvidia.com/
> Signed-off-by: Richard Cheng <icheng@nvidia.com>
> ---

Thanks!

Reviewed-by: Alison Schofield <alison.schofield@intel.com>

Applied to pending for NDCTL v86
https://github.com/pmem/ndctl/commits/pending/
