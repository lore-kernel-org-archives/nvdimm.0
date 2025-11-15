Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.17])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 46A5B1BC2A
	for <nvdimm@lists.linux.dev>; Sat, 15 Nov 2025 01:07:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.17
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763168875; cv=fail; b=Iuw3fXJIlbnmELHyvv+klKwUcn3Nn+qI/xtcx3JJC3I0Ek5M6V/ZxClbxkOWN1YJ9de137j/GeZO6JMW2Aj9P7mOOdpX4p3nl8RgIbpkPErmO3SBprrFs9mJKbNZZFZJIWjXBL6kN1Hn9AbMlZbjP//SKJzWDhXk6Ez37twuNTA=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763168875; c=relaxed/simple;
	bh=UFQ82UYi1lUER24YLB+NTSK7xFFR6Pv01xp+T1PKNX4=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=eUqvMJn6F/SL3RD9OMjR7ek/tMU29FbxhVeM4QpEaCeNPogHj2UqbZP5Y119rorwCazCqjrhvvsieO0ARQULjxn42W86UedYkg53hipXaScVfr3d5b8pWl08ApFrjW6NQpqgs9T6HIe6zCekQmsadxNyDsVzVkH73JToFk+OmEU=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=Lw6PmuKV; arc=fail smtp.client-ip=192.198.163.17
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="Lw6PmuKV"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1763168874; x=1794704874;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=UFQ82UYi1lUER24YLB+NTSK7xFFR6Pv01xp+T1PKNX4=;
  b=Lw6PmuKVpmkFEmaZlpshBI+NCYnkM21KVMzEWCbViRniBFuHx5/CBcW2
   /YXsiYuySE0KOsvTVriYhY5tpdw4lU5bn9Ow9oQw04a8IQG3gSA+d9EFl
   0euCJ89DdzS0UoV6+5+Bore+7dJVyWwuPxZlN4XZnij0nHGcSJFu68woJ
   EfRAUkRHKD8379yPoK0Tgke3tavf8rwzL7VtJpbI4EIOhSRtFCKG3+syl
   AE+ynkCLQDtgdhYYR6RI6T78WqwQV0jS7VVn/f6wunQuzxQjpqMLXErki
   8JpCsWoaFD/HvIJIXwOck+IqNPfCtdHhyIaFhNJA47p/AtHHKJCVJAonL
   g==;
X-CSE-ConnectionGUID: J4k30Js1RS2mlTpCO9WUQg==
X-CSE-MsgGUID: LH1FS7FkR/aSZT/qKfa51Q==
X-IronPort-AV: E=McAfee;i="6800,10657,11613"; a="65172244"
X-IronPort-AV: E=Sophos;i="6.19,306,1754982000"; 
   d="scan'208";a="65172244"
Received: from fmviesa009.fm.intel.com ([10.60.135.149])
  by fmvoesa111.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Nov 2025 17:07:54 -0800
X-CSE-ConnectionGUID: VoMPNFZBSMKvae1I9e3/fw==
X-CSE-MsgGUID: 7AspmkfAQPSdz6nYZLaQVg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.19,306,1754982000"; 
   d="scan'208";a="190345035"
Received: from fmsmsx902.amr.corp.intel.com ([10.18.126.91])
  by fmviesa009.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Nov 2025 17:07:53 -0800
Received: from FMSMSX903.amr.corp.intel.com (10.18.126.92) by
 fmsmsx902.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27; Fri, 14 Nov 2025 17:07:53 -0800
Received: from fmsedg902.ED.cps.intel.com (10.1.192.144) by
 FMSMSX903.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27 via Frontend Transport; Fri, 14 Nov 2025 17:07:53 -0800
Received: from CH5PR02CU005.outbound.protection.outlook.com (40.107.200.35) by
 edgegateway.intel.com (192.55.55.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27; Fri, 14 Nov 2025 17:07:53 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=NzN+WDqHglgykLn8oFhREwjazNwYvACSR1nUzs/bgkSfcSjYnJMWESUbSE93VpTPJlDrb7LgrKql7oWWIXphOrOLFtBnL9htxXHvEESKq/br8dY4mUnf+woz+8HcZfnQtz+YBVAEziDK9UuXG4Ugc/oaS6NZQWpEqZRT9XaNGjIXEKT0YnyC0e2cFroEk9V6KUP2JiZiLXnNN/Ua/s7Tzmfj8WsZXJW4wdBpurowCc7jaroekHhGi5rn480skT1lKRSFAj20aTWzFDJDk5zn1S6nffkd5/WGONInC4Rwm0HyGUq8/RYU7thSfq9SP6SpN2SVboDN2yqnc5OIogv7UA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=KID0g/wyoUrlkcwABAwpKCnPvaPtr+Jzys28l6Hj8KA=;
 b=Z5dLDwGNryG7RFiIreQ0yULrvEXzw7C3CcUKivkMUYffn/sDcHqDQw3pBl/PZ2XWdw1+oFA1a4ly+ndvhEttw6c4Ar+WHvZhhFEB71jE99A353abaYZCK6KnwKPIPoIX1lcNWtehExFbZ7O0ULD9P0z2OyzbxnAIK+YUQ/tjdr4nHKa7fhtStTeH3+6apsD8o5BHHBLIBAWFYykIm+fvIts2UuNQpf88ckL7VFytqD6oglFy1VvbStQpLiwM7qxISyKkIEYWpqZ1nDT7cH7cbKhcVXw0xLYLtoHZIzTOAqKvgVLvFWxVFqQtZH8KoXBp6/WqFYB7MQ13H5GZXmN0oQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DS4PPF0BAC23327.namprd11.prod.outlook.com (2603:10b6:f:fc02::9)
 by LV8PR11MB8771.namprd11.prod.outlook.com (2603:10b6:408:206::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9320.18; Sat, 15 Nov
 2025 01:07:45 +0000
Received: from DS4PPF0BAC23327.namprd11.prod.outlook.com
 ([fe80::46c9:7f71:993d:8aee]) by DS4PPF0BAC23327.namprd11.prod.outlook.com
 ([fe80::46c9:7f71:993d:8aee%6]) with mapi id 15.20.9320.018; Sat, 15 Nov 2025
 01:07:45 +0000
Date: Fri, 14 Nov 2025 17:07:42 -0800
From: Alison Schofield <alison.schofield@intel.com>
To: Dave Jiang <dave.jiang@intel.com>
CC: <linux-cxl@vger.kernel.org>, <nvdimm@lists.linux.dev>,
	<dave@stgolabs.net>, <jonathan.cameron@huawei.com>,
	<vishal.l.verma@intel.com>, <ira.weiny@intel.com>, <dan.j.williams@intel.com>
Subject: Re: [NDCTL PATCH 3/5] cxl/test: Move cxl-poison.sh to use cxl_test
 auto region
Message-ID: <aRfSXqoSN0Zxixcu@aschofie-mobl2.lan>
References: <20251031174003.3547740-1-dave.jiang@intel.com>
 <20251031174003.3547740-4-dave.jiang@intel.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20251031174003.3547740-4-dave.jiang@intel.com>
X-ClientProxiedBy: SJ0PR13CA0021.namprd13.prod.outlook.com
 (2603:10b6:a03:2c0::26) To DS4PPF0BAC23327.namprd11.prod.outlook.com
 (2603:10b6:f:fc02::9)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS4PPF0BAC23327:EE_|LV8PR11MB8771:EE_
X-MS-Office365-Filtering-Correlation-Id: a2d7a3dd-3770-41f5-6eec-08de23e36298
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|366016|1800799024;
X-Microsoft-Antispam-Message-Info: =?us-ascii?Q?9WmsLcoVLEwOitqGa1oDZ/dh9jT5/V/7ZJh1tfMnb6McRy42+6jYvj1ohbei?=
 =?us-ascii?Q?udrfKAjLVZDI4740vKJUhWvFmijhO//qv3CRY+L5rBPBmpOt5a9g9edCxhY8?=
 =?us-ascii?Q?ZucDHB7m7ECQjj3jlbT1YNDYTc8/WO1lETK6Ya+CW2alNHVl9y2ZPr3e83XO?=
 =?us-ascii?Q?rTRWSEXuHr7Hc1jrxiuln1YLfPzMN3+JpQbmkOCQtJ6NfPj/+u7Hh5vulSps?=
 =?us-ascii?Q?oiNxH5DMCBHDqMUUrGJJFQmKNAanJVrUXy4hE3tSTuqQmk0CHFM6HgyAqzP6?=
 =?us-ascii?Q?OqttyOzSXLget5a7RnkwosJoFKtA0NfklvJVONvv6WBvTonFVhrbcPsLtLN8?=
 =?us-ascii?Q?BD/wRiK6G1Fe6VXtu37AU3eY0pT+f1r0Y6+pP+GM/7Nn1I5x+ei/e8F7wn27?=
 =?us-ascii?Q?RFpy7ovStSEj5EiZ6K5P6hBnWJHFnQNNVnRF5CrW/c8tnDYWO0N2MP7aiurG?=
 =?us-ascii?Q?x6FiznGKnCcGpuY7IgGM3Al7+Ks59fT7dehOYSwcVR9aBwSAohQLIQJKZHeb?=
 =?us-ascii?Q?Km+hlidALqRotASnGqhghWbwjbd/DkIbBVxjMrJRNPlbZ6/NlKg4mUVh3H0E?=
 =?us-ascii?Q?4HgdcbBR017NuF47qlSw0zPGrKNO9yRljIuBlmPUgEyw+tCuSkob+KjMJJgg?=
 =?us-ascii?Q?n2J/lgAKhGMQS733+FTVRZrkp/JnQmdIQUoUO5Kxr0pdOAgV0dRN1ukvoPc3?=
 =?us-ascii?Q?nguUHHmwDATB1trI7UrjSnoE5Y73gfRUlGyDjl0MzOEZowqRpp5P86gDZs3E?=
 =?us-ascii?Q?eNHPzGMuNWvM0BP6E/t7prc2VZjPY29UWcCIk8NzbXxfitIbNqe9r8QqRJuv?=
 =?us-ascii?Q?w09O/0myobQqjFQu3Sl+iFspeNvnSVD84rSbqYGrPsSLjUyUldapepfKzJDK?=
 =?us-ascii?Q?7JBFyjfw//DABDA+juBOsKj88gdGt1BrqOwvGwOx/cZMKphhW3DunulGKDwY?=
 =?us-ascii?Q?QamyPBj9aCB3APr0dpmJ2r5W/A01G198Xv6U17ELeY6zSRn7OkSIViIKzl/Y?=
 =?us-ascii?Q?wnzTyw7RxveiNPDKV2OqjkGxDn5QRTafXMUKLrXM8CM/9opqk+RycbVYLMFn?=
 =?us-ascii?Q?8I6YGX1ex2krLSX5tp+xvw1B8NszxlXW1A3bwm8NbTE909hIOCCnfjdBI4Cy?=
 =?us-ascii?Q?Ih1CtkIx9l+P0Y/1bUpwAVzj226TtnA3iguFyXVZmxEUujCmdWOWx4gMtUfI?=
 =?us-ascii?Q?9q01C2B2h1eSK3UesWHkibb4MmlsL009xKZi+Go88QjrXGWLyUocfJv8qBju?=
 =?us-ascii?Q?LrgmeoEtzwo+UK253vU6Q8tqvda8iMKyhNOuBcMyig/hssjMyD+NWNgMNoUU?=
 =?us-ascii?Q?h+9Av0qAhVzJCnoOkcLW23iv7lrPI3VmxSLejjhL07lojS3uov9JGopsEDRK?=
 =?us-ascii?Q?cvTH8Yp9UWSvbUM2PnbGaSUDepFh6AoAQda49qixO1zSbAiHfF8MhvoCpIuJ?=
 =?us-ascii?Q?bI5GXDl9faVevKamtCuhrYggBZ15EPsw+t4SX3DlsgsD2THJM6MtjQ=3D=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS4PPF0BAC23327.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(366016)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?mAEU5QKl2cyFr6vbkprFw+GdBH+/93KfYhW/u9zvKTT9hTh6Ro0vnJdNvW2D?=
 =?us-ascii?Q?yfGLZyIH0zJz1zxYBL2dmdGUPIvxwo4m6ABmqJS/cTHcOzDZRsO0KtpdUTjt?=
 =?us-ascii?Q?y7eHHsPwLai9k1Rms2BSEq32xp+aELZ/0oZ1JWqPPmQ82+Sy0797kwazpMmK?=
 =?us-ascii?Q?yBSfyXNLRTQi+dm5oUBVdMmuhMA7HYrkyL6z9vAZOX4L4J5sfv2CnDqT7s2s?=
 =?us-ascii?Q?D3vwGnsjScq+dKK1wPMcdOZOqknuy+ahxUFXhCR9SRLofA/dlDxqvi3eg1WQ?=
 =?us-ascii?Q?Zs7N/yt4+J+u/2d6izXGS/5va/FKyLXjkzz/vvv2rfn8lmypnsW/l2pDuhg5?=
 =?us-ascii?Q?Mw2GqAjuHZSLobcCRQAhA3DyGMN7JkIinOFDdGHj+tk5PkZUAt2j1HdAEV57?=
 =?us-ascii?Q?8320jPxBJcdF0fcKqdWIf8aRAicpFqhBhE/Zv46obEv9WeoVYrQUKB39eayR?=
 =?us-ascii?Q?SLdyEw2T7V/Fup10M//XfJQXfj2tctXye+UzdaK/6kQ1EeoLNhaSNmIccRA2?=
 =?us-ascii?Q?FIA+onooIKFLx3CkSiXSJ5GtnkfZrwLmZjqr2EqE6NvIX0MQpjV5Y6pxx5ob?=
 =?us-ascii?Q?rS0XXo++3u5SH5uQiEk/ias+wzGqB5cmANMTztePCiublIrzYch3FjBz/+ZD?=
 =?us-ascii?Q?0m5NWfbXleifU6Y9bX+ZOQMKPDuOLP+atwc1yiMN/Cj8bNNTq1a54kTlNa9d?=
 =?us-ascii?Q?52Rs60TobWd0qnV5yWf6Yps6WE+JceTi8IGGk+HacrhNxqNYO7p0o2f9+H7m?=
 =?us-ascii?Q?nByX6QyTu3b4Y6JDdn8wfMSaeokFmn4aa/O1igWkkB0OqRtoQDalYYODUX0O?=
 =?us-ascii?Q?7r7fqggCBlP3AaWSIqlOqEQNtN+g/ctrSY0B5ZBRRy7jLOWx/0RH16JRHmln?=
 =?us-ascii?Q?1FnPJcfCKsYeWxCvXuJ2a3zwbkbTTT0AR3LfgBPdltR9lxexnvTMHCoKJGEO?=
 =?us-ascii?Q?/wtQ92F4GEL7SXGkax0cypX+vnd5dnw8apqlhJ50XFCW2WlnclZQeYK+sVf3?=
 =?us-ascii?Q?xVizsFFl8x+hm0ZQOx/S2OvOAKAdSnASJ4UPzfRus2wLxfG2dGdoZ8GY2C02?=
 =?us-ascii?Q?7fo5hzvJxZLZRLLck9zESHbXUXZmHSEpAMSEJXiXGbVhaSrA9zMSy3gcjHbV?=
 =?us-ascii?Q?jga9pZhvpyHDQgBK2Bw5Rh9Fj1O3oPVNwmb0edR4bqjUIey0MFI5ml6yyIrH?=
 =?us-ascii?Q?brpAlykPAQWxAu8QQ6XOsXJyyN+HEZJNYoRH40UTp9fFdufoS1Rgrat/xJW0?=
 =?us-ascii?Q?VLuGXoC5b2BESpXYthydT5Lkh7/d69JZ7d3Bu4+8WuLQ/Sl7+ZugLRWK4p8d?=
 =?us-ascii?Q?bk91udj7Farts5bOSyDrqzi++x+AfUyfOxAC2TNCiRHYgWbnSmjRMLq3sQLD?=
 =?us-ascii?Q?E95YC+wk8R+7Cxk/a4VnDqKHWY0yJuyl3T7IrxaxwvKvX8vJsLWdIatmaCWI?=
 =?us-ascii?Q?MiuPqrHJp2Jg6qY1HCUpJKLw24RYrPzOBQVUMP+mV1nzbIdtI38pYLvjKI1m?=
 =?us-ascii?Q?gtvQZdEvTL6GofuLlJ/RhYa/wni1bVxN6EFrFZbigg3SWXTcMpmFX9P2/u6D?=
 =?us-ascii?Q?vAPf/QvrlODKm6RIJbVmHn9mONWd47RjOGU3OUHhP+wIQI4giTtOurA1GQaW?=
 =?us-ascii?Q?Uw=3D=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: a2d7a3dd-3770-41f5-6eec-08de23e36298
X-MS-Exchange-CrossTenant-AuthSource: DS4PPF0BAC23327.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Nov 2025 01:07:45.3572
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 5+mW1KbnNE70dpLe+5oOJDm0EPULpje3FMOFGik+GH32fv4FN2U/Xu/Qyy8Idg1kHPK/z+iIVG6iM9XtW+eX0K7IrbrdIW8Y5H4p9mIg3to=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LV8PR11MB8771
X-OriginatorOrg: intel.com

On Fri, Oct 31, 2025 at 10:40:01AM -0700, Dave Jiang wrote:
> Move cxl-poison.sh to use the cxl_test auto region instead of manually
> create an additional region. This is in preparation to allow utilize
> the existing poison unit tests to also test the extended linear cache
> region.
> 
> The offset has been changed due to the auto region starts at 0 and pmem
> region starts at 0x40000000. The original test was creating a pmem
> region. It makes no difference what type of region is being used for
> testing.

Reviewed, tested, and applied: https://github.com/pmem/ndctl/commits/pending

Thanks!
