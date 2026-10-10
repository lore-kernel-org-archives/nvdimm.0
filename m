Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DA4723C1F
	for <nvdimm@lists.linux.dev>; Sat, 10 Oct 2026 02:24:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.10
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791599092; cv=fail; b=ot4R40O3fyfiMiYc8kE+3ijTpzlx6cJWimMcx56kTlFp9/jKRophxQHEYsO1bSS8YPTshf6eefwgFk6xIgiz9xeS+4IaU5WzlyjXMBG4NMfUIcPrmXIMnRYjRxYhjSRcpa0TKeE41W6eP16sdzvlJ8NBv6Sat9UZKPFk616tecE=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791599092; c=relaxed/simple;
	bh=W1KicY7cIav56cqcpiwDA0ahvm0jAi0I+OfSZLevoHQ=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=YzRBsOIfPi0pAdoM7OgtoGSfJI+e+tw6qwMfeDi2RIOn7+B7IxhtEIFthmJYyUZ7qLh/p/9b/3rEI/6zT9qaV9Cjor1bEmuY5tYyuPoPrWFpF3L5Wi2kYmQZL6ObAijD+rgejwMf1ZX6zun51kIRyZ1MH2Nk+utyUVL7b1hgtBE=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=llgYlYYO; arc=fail smtp.client-ip=198.175.65.10
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="llgYlYYO"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1791599090; x=1823135090;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=W1KicY7cIav56cqcpiwDA0ahvm0jAi0I+OfSZLevoHQ=;
  b=llgYlYYOvn/qLtArDfzeFg2vUBpB2fMtpCT11hUKZt1b0J7eAz5aFqcb
   T2CCDAmGiCuQ6NJYeQ6icrgJLWTfSxbgJ+B09jWYkhh5+ctSVXpsn8Lur
   ayXjhMWqEaiQJqVRm/8/3Iz7wARk2HLq+x0NMGIi5neGEwJVV6IIhdjMF
   FqGF6zw9k1dcaxgeJyJDfx/S3YEiJm5C0OwkqjUbkdszl1K4KpycuL9Ps
   xP2vWdSwI+LzUIW8BN7IECD4IcZjsq8rC3lYHhXhh5sre9gNnUvfmhaIM
   fbywq2Ak5KkJmeDzA47COzrnNuWrBbu+84GEHU7veF8GrZHS+MefcNFq7
   A==;
X-CSE-ConnectionGUID: 8Qo4BhWwQzSdTvXuv62FgQ==
X-CSE-MsgGUID: dUY7bjeaQv+JVEX11FCcUw==
X-IronPort-AV: E=McAfee;i="6800,10657,11930"; a="288111"
X-IronPort-AV: E=Sophos;i="6.27,149,1787036400"; 
   d="scan'208";a="288111"
Received: from fmviesa005.fm.intel.com ([10.60.135.145])
  by orvoesa102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Oct 2026 19:24:50 -0700
X-CSE-ConnectionGUID: b2GPJQjpQOmetYIu3inQGA==
X-CSE-MsgGUID: jx+ElS95Tzikqs82xga5HA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.27,149,1787036400"; 
   d="scan'208";a="544979"
Received: from orsmsx902.amr.corp.intel.com ([10.22.229.24])
  by fmviesa005.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Oct 2026 19:24:49 -0700
Received: from ORSMSX903.amr.corp.intel.com (10.22.229.25) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.49; Fri, 9 Oct 2026 19:24:48 -0700
Received: from ORSEDG902.ED.cps.intel.com (10.7.248.12) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.49 via Frontend Transport; Fri, 9 Oct 2026 19:24:48 -0700
Received: from BYAPR05CU005.outbound.protection.outlook.com (52.101.85.27) by
 edgegateway.intel.com (134.134.137.112) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.49; Fri, 9 Oct 2026 19:24:48 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=tFb4Fha4va649A3xwXRB4PnFOnV2/3nUjTeEeKygjUd6D3NvK5SiWnobkR/WrTMfV5fHX0qatZfZi9tSFLOLJjtQR+RIbPjhr9gUuu1+EgxyOP1Uj6s8vi1mQBBFf800zOkFZ2MeICIQwKdpSlOdlSlc5pN6/b8ML138rLAjb8dFh4cI1gl3k+v2aP61ZH5M/yYRth+oSG9nlvbv/6S7uqIwK2wGyIUHtJ/GiW/rGwowd1mGVWBA63nBUc4R81Kvu+YTyLDwe2L55PDUT8YLLR619KJp2oWGE6rwwl4pohghCjSqkLzWQmXVnd6HK6jmojA+0gLkMfQclyaJVHUTmA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=u0Y8gCypNeM3L1/YH6v4gFfkNW48X5dFfSquvWPDmqo=;
 b=MLMGif+QPGgVZlfgVnqTd8cOAHZR1YjjA60CkDcJC+xfPFcpGU6LMIX/FLMnUJJJdvvDU7n72vCTJhnTsS8OlvIfnwT7jRGWk4nOLOJ6oiPPkBZG6wiZmlEUS465RWroXW+lJaRbqlFqmu3B96g0T6QA1gEE+DwR6P6Bhg7KZvNG9hHmdsitLV542k4kNNvHU4ZsxgukdwUO4LyA91yT9ibIa2jmKNpwF6RdxtjJJ8lVuRHiNDb/VqCZzdeXFV4BCKhwdB1RzGZjXcMhxKv2YljJ5HVwm+oPpqYl1Oy9CbBG9cUhAOWWVJOrgr+71lflFkqMPKlSNQ8FKNwEqqQMYw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DS4PPF0BAC23327.namprd11.prod.outlook.com (2603:10b6:f:fc02::9)
 by BY1PR11MB8006.namprd11.prod.outlook.com (2603:10b6:a03:52d::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.496.17; Sat, 10 Oct
 2026 02:24:44 +0000
Received: from DS4PPF0BAC23327.namprd11.prod.outlook.com
 ([fe80::6fbf:c112:d0a8:f1a8]) by DS4PPF0BAC23327.namprd11.prod.outlook.com
 ([fe80::6fbf:c112:d0a8:f1a8%5]) with mapi id 15.21.0496.017; Sat, 10 Oct 2026
 02:24:44 +0000
Date: Fri, 9 Oct 2026 19:24:33 -0700
From: Alison Schofield <alison.schofield@intel.com>
To: Wentao Liang <vulab@iscas.ac.cn>
CC: <dave.jiang@intel.com>, <djbw@kernel.org>, <ira.weiny@intel.com>,
	<linux-kernel@vger.kernel.org>, <nvdimm@lists.linux.dev>,
	<vishal.l.verma@intel.com>, <stable@vger.kernel.org>
Subject: Re: [PATCH] nvdimm/bus: Fix dev double put in
 nd_async_device_register()
Message-ID: <asmh4ekYxNzPxcgQ@aschofie-mobl2.lan>
References: <20260917122816.2151081-1-vulab@iscas.ac.cn>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20260917122816.2151081-1-vulab@iscas.ac.cn>
X-ClientProxiedBy: SJ0PR13CA0030.namprd13.prod.outlook.com
 (2603:10b6:a03:2c0::35) To DS4PPF0BAC23327.namprd11.prod.outlook.com
 (2603:10b6:f:fc02::9)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS4PPF0BAC23327:EE_|BY1PR11MB8006:EE_
X-MS-Office365-Filtering-Correlation-Id: 01288e18-761b-4985-ca04-08df2675a5a2
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|23010399003|366016|1800799024|261009223027099003|11063799006|56012099006|10067099003|22082099003|18002099003;
X-Microsoft-Antispam-Message-Info: vQbD9vgYRsqCOUyEvd4lr/6NO3yc/E35+W9eSFdkaM8xNmefRzhqNct86Yz/2c5Q5fhs6o139i00wvxl57OiqBpRvQXxeo9a4A8dWFLKaxBJ41u0PYssmHliHgM/vLimn61RF1wWgwj/HwWX7jh3ZhmOKa9tE9/2bwkPb4oeIfsZ2l93PkacOcpA3+n8rRAmcpVg5I+50xixC5PcvgzlsUXfd+fptcgPWS1Gfxsqhk9JBEq1Ls+E1cayHL++J/iQGvlzgg6mHKJDrh+z8tndDGrK6gYbwqMSerQNomohDQ4BMLdVWgObTn2wsdW2gTKDMvddujfztgvc87cvOVy6AudpGtW9SK4tRykvQTXOkZnoZbpQBRKllNLyaZfW0QSo2DJ5XOXgKv2PRMp/aG9s4N7MFYu/wcS+De8Wi5i+XarvV8Y5C3m0+Knk+SQmBTSk4gVIoo4W7UEiew4NbJWw3N0nG/j30+mC2fQvyjNGKoYNKodfsbGCebISEepO46woZ+gjTYmJ1Xe1E3hVolsbToN8QGv1F6fOyeEyRcVkfz+H1zGu7/+6DX7dqV37gRna5fo38WIWRNTHZ2OuY64vgwX1NZko+Es3M4oNII3yOffJ2CF7n0TU5qDXJpiUCzORIbpTJ/hmPLg/X0q/6xz6Le1GMaWk7kcASQ+V1/adH4M=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS4PPF0BAC23327.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(23010399003)(366016)(1800799024)(261009223027099003)(11063799006)(56012099006)(10067099003)(22082099003)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?Xnblll32ia1E2CnSNlDaQ96vaKi3By1m9R/2kOAUVjdUc4f6YPY87qmEGLt7?=
 =?us-ascii?Q?yiLd9756Byovj0+EZm0e6N+PM2rucDnVFQSffLP/qJkJbG/YQyqNFDezFug7?=
 =?us-ascii?Q?ZEiWS+PJK6s4BYPKz/cavyIxMGSTH6QLpPdI8N8/qlupH+f4Zo6NMF+qrqe2?=
 =?us-ascii?Q?XZ5pGwdEEJNYfwEmxTUQIGb6eIwM6CMWLJ/WCfqVq81Fkji0+wz53xFGMRPO?=
 =?us-ascii?Q?RRBdBrVUbX0QgVNAKarhiPkATdyATtqfxGhWW5s9E7cmdIaPwBdgroUEI5gr?=
 =?us-ascii?Q?Egvcyg0pMN85peVHjJgXdXJ2drTbzDSIOjkukqoVh5z+4+Q3KGE00xQV3dym?=
 =?us-ascii?Q?zkTVdF93FG3CifS6Vkansgh5wQp1fIScKB7yghEniwUxHPuGgRa9JSHpever?=
 =?us-ascii?Q?LV+NZYgzogh18lpEbUi/MsaUYNRxuAwqCaODsCssQ+W5fTokudeETrcLgRdu?=
 =?us-ascii?Q?C2OdrHGnfiPLhv7ASkDHemkkhA1nZKoPCoGufTvTOQpxtZ42oK0BS9YYlI2X?=
 =?us-ascii?Q?vka+g/q0WnMcTrtKLuXOmVJ39TS5a/gqVYNcOGMbGd+4LDAQj3EArrVz6Fjk?=
 =?us-ascii?Q?CN5CRUO1ENmSw1rNErD+DswVX3PE2uXHquUdyz9V0ykNGJGSPHRYyoLbzLtL?=
 =?us-ascii?Q?/P1LMF6czkjr8JUcm5qMWhgvJ4DsNkvnXzCPKuBKUDwR7YfqPEOdL/tliBC0?=
 =?us-ascii?Q?hlvVfuMYTpwfZG5pf8VTt2RRywUV9vU5IGsRejk2ZQUWx0Moyrsu8NHZtlND?=
 =?us-ascii?Q?5uheWK5jd8BqvIQkuHlUmTcuJEbA8k349opa/n5yXWRM5tdPqFdve6pd8cI0?=
 =?us-ascii?Q?nAdgm87SZD87ewqhgXHhofMmXYiR3imW6hpeRCQ6SA7xEOs0KBx5EENiQdga?=
 =?us-ascii?Q?FqG1+2FNpCJTqWrKPKtKzZtzFBbhUXQ0uuUXfBw7WokXhXm3T4XgQ2CWI8wE?=
 =?us-ascii?Q?D3ICTuGcaPJu8bUcggTgAevBbzeiiEVGHV1qJ9bZV5CIQXZAgxoVReqO0Scw?=
 =?us-ascii?Q?MGoD7easVO4bSQGMRwTb/XspFuUdGwgWqPtb/8ijABztJg5ZllBHrd/n3zk4?=
 =?us-ascii?Q?f1biOWm3u8e750viAPVzddKIzb/IUktmOQGhFc7flchn9e40t+Sz0XjqL2iv?=
 =?us-ascii?Q?FBkAkn8Gl6kV6ImzLjLaPkh0Cz8nENmFTGXx7w93v2VN48VDX40spBo7jpWU?=
 =?us-ascii?Q?/Qa00SQi7b4+TmguydWYazQ9n1PjEW1W36gD2GacXWB9N4qApJFnXPS7VQVK?=
 =?us-ascii?Q?OFnewiPG6fcYfJSmwdpSrm2aJNf+OGrnY6bUUM8DJTk6i9BUWTUd4LRpEjY3?=
 =?us-ascii?Q?ACQp3kb2bNbCQNB8Oi8vehT19Md8Htkvux5D3J84VF1VNaHaH/2iVpahVe1p?=
 =?us-ascii?Q?GotdvKKbohX6QB3FQCgL15dIKQdIK3Pgy2IgT9dgGUOT/qtpxSMMr+iMBxEi?=
 =?us-ascii?Q?0WbwYnDwCAjMDtqS02cIXOcBsiRRMlc4ZqdVEcd3mj+7oIaPc4Z/SJcRJtT6?=
 =?us-ascii?Q?PE7OGyS5K35HtCGHvLC9uCOkxCgvm5VOAx/zOD4tajTR/ScPVWMxohJBdMoz?=
 =?us-ascii?Q?HrvaJL6FZc8U39RFkX87wNmpgNuLMKuxAZxPYpX/5re2CV+Ov0t6gMyYvTcj?=
 =?us-ascii?Q?bATh8xToBpX07zCnWUhUEyPyxTRYTNrHXp+s7G2vd9jCevuh+uQJx9bC+29H?=
 =?us-ascii?Q?dryPpPX3RwEvIAHdl7h/X0lkPvCVpDh7juTSlK6OZCdbZ76jin/YaievlVZa?=
 =?us-ascii?Q?/67u+puDTxWSzZDJ6ULdDnxNFct8s4k=3D?=
X-Exchange-RoutingPolicyChecked: bYJO+bsf34UVyXNT5U22T1MF4HAquYSvxCf7yFAQ/pCgf54YC7sAesXF7v2CiAARiJ41JqzGdMTanD5/4jBnK7q2H8RM7bHyHIyEfqskGpBEE/xij3QbS2OkQlzjDLHrJsM2dsiPWG0TNh3F6vahNvUxmmLGWwZ9V3GsNpv0DEW0itz569nq8nLO7Mgyojcjr/F8LbT63NXyAj6C5009e4E68u0KO2lzUkeieed2d4ddY+PR9GqIApdZXNWxjnqzR6AZxoasu+M57F5Epci5LNMlCBOS2JM5jp7df9SlNRUR4yw+Uh/mSGlHScjkS9eN7KsqcAubTXgd5ddIVrsSdA==
X-MS-Exchange-CrossTenant-Network-Message-Id: 01288e18-761b-4985-ca04-08df2675a5a2
X-MS-Exchange-CrossTenant-AuthSource: DS4PPF0BAC23327.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Oct 2026 02:24:44.3020
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: HzkVgT/uI4U+S24WyzoYKSoEVzDtp37ZYOreoG8zul8fXWuiXRe0ccv+cYPNmJOkjN82N24DaGmgsNgH7wQnuB/CFtsJjfjGqK6Zkj2wDlk=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY1PR11MB8006
X-OriginatorOrg: intel.com

On Thu, Sep 17, 2026 at 12:28:16PM +0000, Wentao Liang wrote:
> device_add() takes and drops its own reference on every return path, so
> the async worker only owns the reference that __nd_device_register()
> took with get_device(). The failure branch drops that same reference once
> more before the unconditional put_device(), which underflows the refcount
> and frees the device while it is still referenced by its creator, as
> reported by KASAN for the parent pointer access in this function.
> 
> Drop the spurious put_device() from the failure branch.

Hi Wentao,

Thanks for following up a KASAN report. I do agree with the Sashiko raised
concern. I'm not seeing an extra put_device().

The device has its initial reference from device_initialize(), and
__nd_device_register() takes an additional reference for the async work.
If device_add() fails, it doesn't consume either of those references.

The failure-path put_device() releases the initial reference, while
the unconditional put_device() releases the async reference. Removing
the first one would leave the initial reference outstanding, potentially
leaking the device.

Could you also share the KASAN report that prompted this change?
The parent pointer is saved before either reference is dropped and
the async registration path holds a separate reference to the parent.
I'd like to better understand where the reported use-after-free occurs.

Thanks!

-- Alison

> 
> Fixes: 4d88a97aa9e8c ("libnvdimm, nvdimm: dimm driver and base libnvdimm device-driver infrastructure")
> Cc: stable@vger.kernel.org
> Signed-off-by: Wentao Liang <vulab@iscas.ac.cn>
> ---
>  drivers/nvdimm/bus.c | 4 +---
>  1 file changed, 1 insertion(+), 3 deletions(-)
> 
> diff --git a/drivers/nvdimm/bus.c b/drivers/nvdimm/bus.c
> index 45b7d756e39a..a1f33a03aba8 100644
> --- a/drivers/nvdimm/bus.c
> +++ b/drivers/nvdimm/bus.c
> @@ -488,10 +488,8 @@ static void nd_async_device_register(void *d, async_cookie_t cookie)
>  	struct device *dev = d;
>  	struct device *parent = dev->parent;
>  
> -	if (device_add(dev) != 0) {
> +	if (device_add(dev) != 0)
>  		dev_err(dev, "%s: failed\n", __func__);
> -		put_device(dev);
> -	}
>  	put_device(dev);
>  	if (parent)
>  		put_device(parent);
> -- 
> 2.34.1
> 
> 
