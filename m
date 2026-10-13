Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ACA8F302767
	for <nvdimm@lists.linux.dev>; Tue, 13 Oct 2026 00:13:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.16
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791850420; cv=fail; b=nxWPs9GtV3n2lASvAtlbFgDN0TdUQK+xbcKHvw/jfRHOeMSESkkulX3WnCJGb1WF5GcKikAAG/4um91dGJ4W7ag3jE7BUfWaIg3exgaP+iA8YhZB/kwVuL6oddorIygUpNdqmWhNSuTYamnGsPzUKpzTUXx+8Db/3TbfKo6DSQM=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791850420; c=relaxed/simple;
	bh=4BXgDLvslGdYQgH8WPyorQBm4eC8H85BU+EOgqE1vFs=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=jaa6U+Y4aG59mN9X5Jr7CL/SZ/Ztarz9eg1TOwCS2CxU3prf6haj1bKkZG3tZBctwqwhK0aY2bqX5vNePpt0n4uh92VQndAoIk3z+R/UebsNufuJKPQUU9hg/uQxw2DhCSVvKTuyGaULRtUpMiYLFwQPeZfBiUslsskeRoY/3Jk=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=TWFloQp8; arc=fail smtp.client-ip=198.175.65.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="TWFloQp8"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1791850419; x=1823386419;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=4BXgDLvslGdYQgH8WPyorQBm4eC8H85BU+EOgqE1vFs=;
  b=TWFloQp8rNxFIQHGdV8rT0sJAPIJWotZkh+bAEZgsiaFEkf6lZ+IbzxT
   OsP+RclKQPo4MInHQhMps/l58wGhh/c0MHlUbU+Poa87I4cGLqjdA+EYz
   vXodzbWgYIMyDw+4WcyJTn15Fx8G1sG6Ce9nPo61519Np2Pod51WRS0mw
   XioWx5DdD4nX4y9Zup9RpFTS8L1JfVEjzsM2mS5Vev27Slrh7KzLcq072
   4F8EtSHAvsUEkywNl/C+JhDS/80ElWg+zi6wNFOE152c1BIfeEIh7IVZL
   Ui1O7ho1ho6SOzmzvBgOEKY5L5BBbXUxV1LyCKuYYxn+OrpoqRzUgmcdQ
   w==;
X-CSE-ConnectionGUID: 0Nlwaef8Sm6cVPaBNByQvg==
X-CSE-MsgGUID: PWKiNB7HSTa/wjdr21P3mw==
X-IronPort-AV: E=McAfee;i="6800,10657,11933"; a="554629"
X-IronPort-AV: E=Sophos;i="6.27,154,1787036400"; 
   d="scan'208";a="554629"
Received: from orviesa002.jf.intel.com ([10.64.159.142])
  by orvoesa108.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Oct 2026 17:13:39 -0700
X-CSE-ConnectionGUID: GRIJrnoIT4+r6/DJZ/tuNw==
X-CSE-MsgGUID: 9JCXgStITfqzAXovHcXEkg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.27,154,1787036400"; 
   d="scan'208";a="989775"
Received: from fmsmsx903.amr.corp.intel.com ([10.18.126.92])
  by orviesa002.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Oct 2026 17:13:35 -0700
Received: from FMSMSX901.amr.corp.intel.com (10.18.126.90) by
 fmsmsx903.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.49; Mon, 12 Oct 2026 17:13:33 -0700
Received: from fmsedg903.ED.cps.intel.com (10.1.192.145) by
 FMSMSX901.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.49 via Frontend Transport; Mon, 12 Oct 2026 17:13:33 -0700
Received: from SA9PR02CU001.outbound.protection.outlook.com (40.93.196.26) by
 edgegateway.intel.com (192.55.55.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.49; Mon, 12 Oct 2026 17:13:33 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=RDmw7VQeBWYJAbx6f50FNT1ksWr2MNnPpjXCBuHeBDQpgIchdEgAA2pKhThO+tqtkodbq9Yku0oMANOOn4uDL8j6o4rxT+mOO5yF2a12Hjf3f7TGUjopns+RfCdUJg79JxQYhH2yV6DxA0fBRykHzuPpDdohdHKsS1Rt/WaFemjSJgFe2Dv6qrSqGNLOOGv4bka0uflSXbGV5AWJf10idAcNfRdYywxdE2WwtS6J/n0G/qNA/m0n5M+uaQmvDnRTw1y9q3iCDYEC6eoNrSVt1hxhiRE6pSKROTolfm2er/gsd2vf0Ee9q+HK6X4p5P+8kU7DHbyC8egMiHpj0yPPAw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ZXhP9Kz0/tzJTcG/OC3QEJCUWybo29c2ak3b0mXIrf0=;
 b=ukgIPc3On/MSc5U5mlxYkXKWu3durX+fVf8J097eBdQN5EKnjlGnlxzi6ctlutuqRbhZ1B9hVF/+4T+REP6Ojeqfouanl0dxdx4sFECyN4ZE/zJ6FZHHc0NtU1nCTQg9uaLfYNfgC2Pibb55wjN6TJOE34RdW6iZwG8j3hDNZnvCRUPaDCqwXP2iUSFKJgrnurZeiqdWHrl+kqxcNooNd+RdqRIdhNaJ2n+gdyTT2yHAbkZkIbOpjPnVYEqeeWApYhgw6zJrqWQAsP40rtjCrlHUveifO/+zvegGXaRFyqPYI85OoowyM7LpCEQdKNLMYh8iTKg4A/7ssydSwvM+Kw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DS4PPF0BAC23327.namprd11.prod.outlook.com (2603:10b6:f:fc02::9)
 by SA2PR11MB4825.namprd11.prod.outlook.com (2603:10b6:806:111::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.472.20; Tue, 13 Oct
 2026 00:13:26 +0000
Received: from DS4PPF0BAC23327.namprd11.prod.outlook.com
 ([fe80::6fbf:c112:d0a8:f1a8]) by DS4PPF0BAC23327.namprd11.prod.outlook.com
 ([fe80::6fbf:c112:d0a8:f1a8%5]) with mapi id 15.21.0496.021; Tue, 13 Oct 2026
 00:13:25 +0000
Date: Mon, 12 Oct 2026 17:13:18 -0700
From: Alison Schofield <alison.schofield@intel.com>
To: Muchun Song <songmuchun@bytedance.com>
CC: Dan Williams <djbw@kernel.org>, Vishal Verma <vishal.l.verma@intel.com>,
	Dave Jiang <dave.jiang@intel.com>, Andrew Morton <akpm@linux-foundation.org>,
	Joao Martins <joao.m.martins@oracle.com>, <nvdimm@lists.linux.dev>,
	<linux-cxl@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
	<muchun.song@linux.dev>
Subject: Re: [PATCH v3 1/2] dax/bus: fix mapping attribute error reporting
Message-ID: <as13np-95gSaBbQm@aschofie-mobl2.lan>
References: <20260924025035.1265035-1-songmuchun@bytedance.com>
 <20260924025035.1265035-2-songmuchun@bytedance.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20260924025035.1265035-2-songmuchun@bytedance.com>
X-ClientProxiedBy: BYAPR21CA0008.namprd21.prod.outlook.com
 (2603:10b6:a03:114::18) To DS4PPF0BAC23327.namprd11.prod.outlook.com
 (2603:10b6:f:fc02::9)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS4PPF0BAC23327:EE_|SA2PR11MB4825:EE_
X-MS-Office365-Filtering-Correlation-Id: 311927c8-032c-4706-7374-08df28beccb3
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|23010399003|366016|1800799024|11063799006|6133799003|56012099006|10067099003|22082099003|18002099003|4143699003;
X-Microsoft-Antispam-Message-Info: w2jUH1vC6CHGQpXgPpMWYE+gP3VX1opSO4hBr9awlXJRoiat8KeXZDwT32S62ayAgXcLRDH0dgBPADjgtnlXF7nWpwuELALqkym9jTelzr4d9mGYG8vIxlaoQ2aLCtbS32wP0QoY8C4RYsnRSq4EhtrwuRCRgr0c5MFSHO6Qxp8NFhqVIN2zayqQZ9FNp7IiSruD/uUmgB25oPDabJ6lIxVn1mG+WXdxJlAms/viTn6W+L34mnEiXjLkeQPCV2vtncvwLi8ZmLp2VydCDiS+BewOgfdQxiZamXbTTptE9ClRf67uWEM8848rDyCaTqKcitmxb2tgLcfZtfA/Vh1PAnFIlfMP7Kz9dG8Nw+VoPI14v/HtI4mGg/I/U2qYBunTPCohqD+61ghuqVRKQ9SoytJTCKSHke/AgMJ3SzKFGkAVlpxybGQqOYz+AbdV7fmK6O4Hn5rY9oxIr6QHmXAeGbjeQyUyEu7QkueGEoO3srBqYO4GeTJiJaPJ90AWtJ0PVSzmbJbhgcTJKjUo5viT/6suTRcRnx2VZYkWk0AeyVxHcyuAMTaorV3F0KHVnrll6bMsh1kjIUoWv+siA+RVzMLTt0arwAceC+ZhMu9ytzSVp5eIvWG7GV9C5TBfdaXlNJP9VEAvyK+oXWZPc4BNnGytbqkKTQqVN+gkOxydi9c=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS4PPF0BAC23327.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(23010399003)(366016)(1800799024)(11063799006)(6133799003)(56012099006)(10067099003)(22082099003)(18002099003)(4143699003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?2b7m7fGE8Zo0sGYDLda07VQSUSPZxmHWX5Dp+DzEgTfKLQt/TLVVdPoI5kJr?=
 =?us-ascii?Q?WE6Pt+GiNGf9NhpEK1R2omgozBL7kW55hHQqlgVzmgTgCRhGB5mPJ9D8/K8L?=
 =?us-ascii?Q?v5KE6TlXSoolwG6zZ7Zhk/RrOiIAkiJjZu/xYUdxGRrX88IC90r/eb6nMVx6?=
 =?us-ascii?Q?Z/du2EPymLUU7PyV+S8bPlRlvA/xyROoWxyL2W786eB1sYnDxXCZ+mKV+bkk?=
 =?us-ascii?Q?VGkK1De3tyJt/uaVwkabHRYSccduMGg/mmxAOsAv5jWeVSvqsTI2o6x/8Qne?=
 =?us-ascii?Q?1PXi9omapTrRIthkpJMA81gBAc56UasTYQc4M7vxNOjeVFcAKFgHFhQ2tE4M?=
 =?us-ascii?Q?HVU3oymJYySKppyzyHNfGR8qODrB3w0ygv8osHuu5rBg2GsgB1HWTTQN7mES?=
 =?us-ascii?Q?zfSH4ex8CSIsgcDUCz/HP6F8v7dv7XZZR4i12SPE4Wi7U6B0Vk73sonZKBtL?=
 =?us-ascii?Q?kmAVH3rSxo0IbEUnvG2viqoF4DdS7DProzMHo1q2pxPOBUoy+Ly13PpIvqMg?=
 =?us-ascii?Q?Uva2ESyE//rbTOQVUS5dhRdJKwBO2UcLKFFvTESfnLGcrpoAQlrKfqgGyk95?=
 =?us-ascii?Q?S18tuySsb02QNX0NcRHUOlGysSVF1ogZifCGOfJF26FiDtWmqqsxFIA2teRd?=
 =?us-ascii?Q?5kOPykhOAm8IJzHScIKlU4uuiwC5zhozGazy1gxqIjvBaYZhqmOGiLUD2Iv6?=
 =?us-ascii?Q?Jh+1ZgXUQYVHBwqMGERQR6aIZITcHbIQk7Uijw2kTLBYcuYlGm73pJZp9TZB?=
 =?us-ascii?Q?3yDV8u+cO7myoHXXP6+D3QVyXMP/I0E/r5C70QVANx0uzanmCIzk+5cuCMnT?=
 =?us-ascii?Q?0ytJI4Y0ETHVXbtIm/MK2M5E3cdYMY0ScYhAKJIYmoqXG2iWIkhE/asjdjbp?=
 =?us-ascii?Q?gjtFEFv8gMboMaWtM9paOcIjESlPpyF24TTzeHHc124gEPELCaAbJyHBVqwl?=
 =?us-ascii?Q?AbQWtSDeiOYakhuLFsCpRieu/WtZK7UR2jd/WYWlggmApXUr5PBW7KZDPA7W?=
 =?us-ascii?Q?xpPY/HTqOHe8+90SYWJD3Pse/F3NS5yjMOwS4YMNquUz/fCfXoZipITg4S+z?=
 =?us-ascii?Q?OIs444mQrKLYSlKqRM1LJilxxPv1KEM+ugPQlVcctPVbCCr9DIeXh0jtfibw?=
 =?us-ascii?Q?WqhWL8pURLBC6I4N5VCd2snkwHfOZHJko4p7mEBE9pGujCbkzXCRwIn2AorJ?=
 =?us-ascii?Q?rdhDKhElxjT7RTO68BkqfoInpvkpKFfQVZRhaO+kh2IGU+0pvQwxNRMn7P7r?=
 =?us-ascii?Q?LuIaXSLW/BklypqWsiMT9dh/m3gNSsKfz4y725bTuN6LTLolj4GiO4cDdDgD?=
 =?us-ascii?Q?AVBxNqT4PH8aD+1Ro6k9Y/1sGVUf4NvbrBkw4FW5XrjQsxQrdB5dQTcMfyXL?=
 =?us-ascii?Q?UFm1i6oDkvsKH6ZPfVqqEI3CHtunsTTjNxtQUFfWb2GPwPeOCdi9YH03AAHT?=
 =?us-ascii?Q?Xp66sI707uU4bFJfXpDJj3HqITmaP0sRV7iVvG9snGt2ii55B0+hmEfOYzhF?=
 =?us-ascii?Q?BP9kWm+eKBP20rqTr0pE1atOa/Si5TG8jQCVjFGL4PEIq22ax9BR+ncn+dbz?=
 =?us-ascii?Q?Qc7e1EKfxsDPlyJ7my2XBTTt60/qO9Y0arhz1/Q5mzMd/1AgI/8WiE5VirrZ?=
 =?us-ascii?Q?IV+hZC3DAIJeUHZVjFNhQmfHJMeb7KUe11dv9b01o0YC3GPzW1dejea0bfHS?=
 =?us-ascii?Q?MBVR0/mri6L8XAC5Gx29v337ubQWpFox8lOHZrtQqzIuFAihGsFQtAy9L1VD?=
 =?us-ascii?Q?M47AVDFgHesfMQ2PgwNPCdLFeF3V7xM=3D?=
X-Exchange-RoutingPolicyChecked: avaODYJh3AizKdpSW86BRVJKsJsetMvWbMLpv2LXlAxfq1R5s//StSzbkuTQNGaJpHQ0umQoTTymW5px3Bvdhj72IHS5D77wnyZQzkhStZBAMzisvp5ine9SQJPNHHqA/NDjDkIY6QgaVoW3JNnHSb/hXsdS4MwFOWVwwKajz5383k1QpnLf7A9Pi/uFt+VKHyctykCqZ2o1hyZAAP7JfBu+nlKk10g67+vvNOQWwBlV04U4qfOl1YNBJHs5lhko5CvP0aikP77AR25OeTC8upBXkGGODnUnljKdZ3y71ULtRrGOL0kJPAHswdYCGCzuzMSVRfCwc9NeHk5dtbczlg==
X-MS-Exchange-CrossTenant-Network-Message-Id: 311927c8-032c-4706-7374-08df28beccb3
X-MS-Exchange-CrossTenant-AuthSource: DS4PPF0BAC23327.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Oct 2026 00:13:25.6359
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: XZedw68COFVYn7nZj3V2qvpGm+mcn0eHtdwFxKUEZxXRnkEOMUijxFWJ64g9Qz1/3BDW+w5PD4ZapfosXJMKQOsXdUGXi54/ktC4eWD+uYE=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA2PR11MB4825
X-OriginatorOrg: intel.com

On Thu, Sep 24, 2026 at 10:50:34AM +0800, Muchun Song wrote:
> After the DAX configuration locking was converted to rwsems, successful
> lock acquisition leaves rc set to zero in mapping_store(). Two error
> paths can return this stale value: an unbound region driver and a
> misaligned range size. The sysfs write therefore reports success without
> allocating the requested range.
> 
> Return -ENXIO when the region driver is not bound and -EINVAL when the
> range size is misaligned.

Reviewed-by: Alison Schofield <alison.schofield@intel.com>

Will modify subject line upon applying like so:
dax/bus: Return errors for invalid mapping requests

> 
> Fixes: c05ae9d85b47 ("dax/bus.c: replace driver-core lock usage by a local rwsem")
> Assisted-by: LLM
> Signed-off-by: Muchun Song <songmuchun@bytedance.com>
> Reviewed-by: Dave Jiang <dave.jiang@intel.com>
> ---
> v3:
> - Collect Reviewed-by from Dave Jiang
> 
> v2:
> - Return explicit errors before Device DAX range allocation
>   (suggested by Dave Jiang)
> - Move the patch before range alignment validation for independent
>   backports (suggested by Dave Jiang)
> ---
>  drivers/dax/bus.c | 8 ++++++--
>  1 file changed, 6 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/dax/bus.c b/drivers/dax/bus.c
> index b809e1a264af..e40c25401cf0 100644
> --- a/drivers/dax/bus.c
> +++ b/drivers/dax/bus.c
> @@ -1192,7 +1192,7 @@ static ssize_t mapping_store(struct device *dev, struct device_attribute *attr,
>  		return rc;
>  	if (!dax_region->dev->driver) {
>  		up_write(&dax_region_rwsem);
> -		return rc;
> +		return -ENXIO;
>  	}
>  	rc = down_write_killable(&dax_dev_rwsem);
>  	if (rc) {
> @@ -1201,8 +1201,12 @@ static ssize_t mapping_store(struct device *dev, struct device_attribute *attr,
>  	}
>  
>  	to_alloc = range_len(&r);
> -	if (alloc_is_aligned(dev_dax, to_alloc))
> +	if (!alloc_is_aligned(dev_dax, to_alloc)) {
> +		dev_dbg(dev, "%s: size: %zu misaligned\n", __func__, to_alloc);
> +		rc = -EINVAL;
> +	} else {
>  		rc = alloc_dev_dax_range(dev_dax, r.start, to_alloc);
> +	}
>  	up_write(&dax_dev_rwsem);
>  	up_write(&dax_region_rwsem);
>  
> -- 
> 2.54.0
> 
