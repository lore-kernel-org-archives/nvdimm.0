Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EA2983290C5
	for <nvdimm@lists.linux.dev>; Fri, 16 Oct 2026 01:23:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.10
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792113808; cv=fail; b=b66fBUWf/ZU9aM5UtIU+8SS3wGJ4UNtb61jhX/imM/6iwzSttdqD4B0xSkaAj/RvJOGBk2m9KsiZrvULOChtKFN1O+UqYhSQSQSohhfC+9SpD9fRvkvl4wGXHG63Ix5ZYzx5BZlu5NXJu+P85PN9Lwdmxdz0wMmKHLzWqV7zmtI=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792113808; c=relaxed/simple;
	bh=5Sk+RoAED8h4phR8RzWADjgqNtQ0AD+PGpf+RPPiV5Y=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=JHk62Gmr6jVJB0eHzEz2akwiftJPHg8K43WVSvP+I12K1Qyg6pyKlPbu/e36GeiQ4rlLHX3n6CkLeJsw49B1RugSG//ChhFB1sPvv2T+hyMJmo7fuDx05pSn9X/kd5kXdpQLsJ6YoK4EaWRGvo299S3BaaJt2nZX9J/VUxAdrVQ=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=PEOsldA8; arc=fail smtp.client-ip=192.198.163.10
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="PEOsldA8"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1792113807; x=1823649807;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=5Sk+RoAED8h4phR8RzWADjgqNtQ0AD+PGpf+RPPiV5Y=;
  b=PEOsldA8QzF0yRmMywl7NfpB2+MJy8MLtm1o58Q3AxV2ugkxwWxKSrit
   SdRCI/O1YU2A6GhLbG2Y7DT8IY1lIkPfDiK8JcCJPXgC7oflOoIgHA8Kl
   ckkCkupnYfr5Vm+FU9fiYy8YxCeECUlAzvueFtVhXS8XNq+2WiyrmtS//
   4IycvWDnGByE1Uj35vMZkVTlSkQuuzPv222zUrQi/rz7x2bmbGPxg9Nuu
   oF5RDrSXjHNrTUznCkusj+Bwj9Fl/DlWo1G5NV2W7JHAd+5rpFE0KmItU
   4O+tDfhnSpJXypFk/VMzUrNBVnmJif48YNOnNO6UBXUpBIwYHFns8uQ1H
   Q==;
X-CSE-ConnectionGUID: 77j42ZsyT9+TgcVz0yRlWA==
X-CSE-MsgGUID: qjM02JD2SvS+Qjnl/uF53A==
X-IronPort-AV: E=McAfee;i="6800,10657,11936"; a="793753"
X-IronPort-AV: E=Sophos;i="6.27,160,1787036400"; 
   d="scan'208";a="793753"
Received: from fmviesa004.fm.intel.com ([10.60.135.144])
  by fmvoesa104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Oct 2026 18:23:26 -0700
X-CSE-ConnectionGUID: N7Wo1aYITiaPwxuGEwapXw==
X-CSE-MsgGUID: uaWc5LpLSyGepg2akUHzYw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.27,160,1787036400"; 
   d="scan'208";a="1836141"
Received: from orsmsx902.amr.corp.intel.com ([10.22.229.24])
  by fmviesa004.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Oct 2026 18:23:26 -0700
Received: from ORSMSX903.amr.corp.intel.com (10.22.229.25) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.49; Thu, 15 Oct 2026 18:23:25 -0700
Received: from ORSEDG901.ED.cps.intel.com (10.7.248.11) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.49 via Frontend Transport; Thu, 15 Oct 2026 18:23:25 -0700
Received: from CH5PR02CU005.outbound.protection.outlook.com (40.107.200.71) by
 edgegateway.intel.com (134.134.137.111) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.49; Thu, 15 Oct 2026 18:23:25 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=mBVFNSm11dTV/uwIAKz3+4/Cav4zdc0CePu9cGUrsNqEv4VI8XaVvWkwcO8qAlORJgI5oWuxxjz0LvMw57S/cpCyDeImsA72v2Ib0+ad3WrwFcEK2+FLfsCYdM7y9sbcx+r/SVE+CrFGF8VbSrjCs0hnkCSNjd4gsV8dg6Rv+gUoEJ++QoxkmdKO9YGAeHvA9IsZ5mLP38UaxKQC95AharEwj7YAto8uSuRZHygSCj3n3s0ALpoozeFkgHAM3VUnvM5d67owLSPLqxLC2EdtZq6D0Wzwu36MG0MWv8+2uqGs/9/uF2yAngAoVfTZVT+uhUrsDA2KL5qY1LL6Lb+wVQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=PrpO0GEuM7LcZUYpVE6Hs4WxYLegrNMqaaDQDH1ETUI=;
 b=vHciLsQU8YyfKUATjfpOQsBYiqhGH0uuLq2gi6K6vudSKK7dTMnFJvt58sREoanadF6DpGf0G2ZpQekmIduWH9Gs0JgVSG2Du+kfV9qq4G4Mz7Cma4TER4iFe348WnmAkjDOtfBDS0myoVXfMPk2qlGugNVu3LsyVO4Ket1S8UzQOn3CQzXYcnqlU77eLny3Qtoi3yxQ9h5EEq42VLqXdTdWMK72A/xYK+R7IXdAYrOZVUjgCMRI7u2bNe0JqeDy+R3lSOQbmNGBXZI7II3XNabEZ6GRHoUV7m1tcGpe6svZewS6sis9LfQFJ1/GM/cpyrTS3fsDALSeg/w8DyKkzA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DS4PPF0BAC23327.namprd11.prod.outlook.com (2603:10b6:f:fc02::9)
 by PH3PPF2B89F77E0.namprd11.prod.outlook.com (2603:10b6:518:1::d11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.522.14; Fri, 16 Oct
 2026 01:23:15 +0000
Received: from DS4PPF0BAC23327.namprd11.prod.outlook.com
 ([fe80::6fbf:c112:d0a8:f1a8]) by DS4PPF0BAC23327.namprd11.prod.outlook.com
 ([fe80::6fbf:c112:d0a8:f1a8%5]) with mapi id 15.21.0522.013; Fri, 16 Oct 2026
 01:23:15 +0000
Date: Thu, 15 Oct 2026 18:23:11 -0700
From: Alison Schofield <alison.schofield@intel.com>
To: <jianyungao89@gmail.com>
CC: <linux-kernel@vger.kernel.org>, <stable@vger.kernel.org>, Jan Kara
	<jack@suse.cz>, "Darrick J. Wong" <djwong@kernel.org>, Alexander Viro
	<viro@zeniv.linux.org.uk>, Christian Brauner <brauner@kernel.org>, "Dan
 Williams" <djbw@kernel.org>, Matthew Wilcox <willy@infradead.org>, "Andrew
 Morton" <akpm@linux-foundation.org>, Shiyang Ruan <ruansy.fnst@fujitsu.com>,
	"open list:FILESYSTEMS (VFS and infrastructure)"
	<linux-fsdevel@vger.kernel.org>, "open list:FILESYSTEM DIRECT ACCESS (DAX)"
	<nvdimm@lists.linux.dev>
Subject: Re: [PATCH v3] dax: fix wrong error code returned from
 dax_dedupe_file_range_compare()
Message-ID: <atF8f0Jdb8OMcE9I@aschofie-mobl2.lan>
References: <20261015143426.17620-1-jianyungao89@gmail.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20261015143426.17620-1-jianyungao89@gmail.com>
X-ClientProxiedBy: MW4P220CA0021.NAMP220.PROD.OUTLOOK.COM
 (2603:10b6:303:115::26) To DS4PPF0BAC23327.namprd11.prod.outlook.com
 (2603:10b6:f:fc02::9)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS4PPF0BAC23327:EE_|PH3PPF2B89F77E0:EE_
X-MS-Office365-Filtering-Correlation-Id: 3c09cd1e-7da1-4aa1-afd1-08df2b240d0f
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|23010399003|7416014|1800799024|376014|366016|10067099003|18002099003|22082099003|11063799006|261009223027099003|56012099006;
X-Microsoft-Antispam-Message-Info: qpYCW3glbK+o2JO3Ai+eBQZ93Y14xPZpuDq9/jCemPriFpl5iFO2ulHpO/8cF+6xhM9599Sp2vwA6NHBgiW6WtI4TDIGLZCGyMdXmgCtCGyenVc2QlnMzw4JOFPMGueWFESJLJismuewoxsXkFlTjejlf+88iZ/jT+VuFe1b7qk8K4a5CO7k1qFfSIiYEHRsuOQsv4uDxYbR/CGx+tgmHTS5gK4XrTGq/mGukISXvlCBRRDxFcx0h8vdhrwqXIcGuUjFkPA/q2wwMItHgp+kKf+AUjqvAgUZgP5bsRE9yfD3aiLwKuGvjO2tYCzjs5hrIJaP2cO38bYaHk/0jIEVFj0Wyu8mhWQq965SOagz07XmFsQQhouudLmAgWysWFobxhV4Mpe2bUIELpZLppHjCyb+BWGw5nrj81vIkNmz6n97+iwp9mOEXiyCYrendHIIc1TSRwmIIJ8tEDoMpopiwHEkr2LKXlsLoYG5J8tsv7N3liehhDO999w0VdL+FmcZ5TbzCyEumFDrVS6iMZVVmgLNYFl6JV2Rw0qrZbdI2GpXNDII1fUcp16OGgTXdTIstQZGi+5gu/dwRSZHeXikJ6gWg2y/olRz/foxCboJKlYRkC/AQ6JIuF5S/+0CMqvS
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS4PPF0BAC23327.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(23010399003)(7416014)(1800799024)(376014)(366016)(10067099003)(18002099003)(22082099003)(11063799006)(261009223027099003)(56012099006);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?vK9Wo07y7EsHZAhg5OvaFY1+xGbLkawVfXkM2/raCi7z6tAo09r7QCWHUqop?=
 =?us-ascii?Q?/BNw5g3SxIX1+1ZN8Jfz6opgg03rKDKhO5e9BKvf1UObEV0Ce9exTu3iOpU6?=
 =?us-ascii?Q?R7deN7a4BHFC0pgFO2pC+H6Ym9dvfrPCjsMrOztwkTpTp+Vl20QI9H3KXkKk?=
 =?us-ascii?Q?DOzWabN8v4rnfS5i5Vw5LpDMgOIguWwYsu66gzPtNPA0ITKgdaUQ+hD1y4gv?=
 =?us-ascii?Q?JSvUDSje/KpaNeR2v0FZSpyFJ1EzEmOWhwBz0lOznefElFAgG7BsNNlgrMc+?=
 =?us-ascii?Q?htj1rlbNYG2kZeiX0oVThZjs6rRxt4WueMZuvGSkhZadgIUzejgEJJsxuUxe?=
 =?us-ascii?Q?nsYNCVXBzsA+9MyVCezal2j6nbMKbWkjhYZGEV2ooo+vOwUbVna/EXbcd8n0?=
 =?us-ascii?Q?ko5Vl1C78h5fprrhIn/XgB418lGN4gRMNS7ErHlO8PxSRxZI9b8bonNecQTy?=
 =?us-ascii?Q?V2AElsnkBt4L/Zop1wQjlPlPYzPuLw3J1RYYecBKKB83Y9PxOk+LvgbupbGo?=
 =?us-ascii?Q?C6CbvHNXtAQjFsfnsPNG23YrUSEptmiUvuc/HC4XQwehoYeaDgm2GyJuMZTt?=
 =?us-ascii?Q?i643BDeX4toMzcLliuzURic4sArQr/g7pJOu9r43J09EMy+us5PdEwJuu836?=
 =?us-ascii?Q?qsEYNAMP4Lo+yUSKk+hOlv7UH5xp7kw05XGHTANRDCBEsjzV6DnrbGGnIDwp?=
 =?us-ascii?Q?N1A7hvSzSpKJ0mRwCh8+q6qqgtseBNCAkBNbIYWJiyUQiJVxoBaX6slvxmIl?=
 =?us-ascii?Q?q/Qf9Gy6BOJC8SfG5RLas1FdZ7d6BeoSYPsmCKklK4/nn4c2A7x44LX/qOJ5?=
 =?us-ascii?Q?NXDFpswb4uOfsk1fzN3IuDWC96s5taIHaCzIKxcLGII4nwwifIaZd4IIZypR?=
 =?us-ascii?Q?+xce4WylVxRjYqTuxlqWqkYJzFDl9jeLKk3/YQMZfgO4NiEaH/akv/rnh3aq?=
 =?us-ascii?Q?Mvno4uojYO0T8kqaVHy8Y6BaC/80VHMcd4n+GljxkZeLIRLUi0G3iAjUmT3j?=
 =?us-ascii?Q?jlNp/V+F8oiTxKEMMZRQPH2DOulTeoH6yAy2tgUMtdlzdgt7sJ1frLH3IZFc?=
 =?us-ascii?Q?wnWJ7SWxikFm7JkanZI3ZFrhkA7sSvXmg83RfZDvUN8EaiMEeqjRnZoHbA1A?=
 =?us-ascii?Q?Dab9lnn6fdFaYo3u0yT/CMWTMdt2/1ZF552di+Z6v8uGHVoS+McJg3GUiVpS?=
 =?us-ascii?Q?GxnBXC6QjkUgixVVSuAv7rxXRznr1VKV3reXa0FoJ4/KNofQKMSiGy+l7iUQ?=
 =?us-ascii?Q?0fHaGPz64fUaSGU8cqzmUh6klWuasnN/GnGa4KvrulnK7SWd8srk6lMFXM5h?=
 =?us-ascii?Q?eW5y28yfuJTC6nZLIWeLQUYhLZSGzYsagszf8DB5yYGCejXUvvZ3GFUlPlOw?=
 =?us-ascii?Q?dBixek5xHvtFDGaPlLwLQGkneXlOJIyanVNXtewSR9hC2UIWBvtzP0R6NPL5?=
 =?us-ascii?Q?MTV69sxTP1zhAmCSucO7hufi0i2uuPcfb3kQxSy1wi0hlqsZ8G64MWIp5+wu?=
 =?us-ascii?Q?gSfBsGba7FFBqlgiiptJHxcOv7MZIUnKcGnLlIu+bno//xP3zzONwZ67lf+p?=
 =?us-ascii?Q?24H7bB0Pm3HHcCkctk50t+ev+pA//QEXRnH95yc8Pg12pU9hAIKh/LobLG3R?=
 =?us-ascii?Q?/jlAMXFQcvAXO1LmJ9TuybslUssIMO0weXHALDNs9IR1qRCp0HUOOW8dreVe?=
 =?us-ascii?Q?KBLBn5Yea8qzV6wYeEFevwrOTMFzY1lwJtA9MJEduqV3ME0VrcSZwzaTVHxs?=
 =?us-ascii?Q?QaHZKtzxiAL+Puwb2PpPivUUyGaRtAY=3D?=
X-Exchange-RoutingPolicyChecked: hx3uizeOTSbuqN/fQeu4xvp9ipitUdM/5J/bb+4UhV6eRgqx89zxSKCdtp86pXswy/GxtWHy8AqxsWWyFBkab472qcn293PvFZmLyW/9Ox3JC4N+2c33iZo2UIsD5u/F+8zpRXIkY0HR1ynvmG7lQ0HfxH07MqrF2irEjHqEcgu0aYSCgEmjwFwKkB+TSZ93Yl3ZHiPcdPDEkL55sNFqTuZzDnUSeZzQ16T5eSEGuOSZHvYtgNRxIH7Ns8KY8bqHA+2FVZdjrHq9/vUG6FGl5gOl6CCYZKJG2h10b9D4J6yfHfgf/5NiF61D3aaiO50AyNRj0XjIJ4sWIEfjCfaRiw==
X-MS-Exchange-CrossTenant-Network-Message-Id: 3c09cd1e-7da1-4aa1-afd1-08df2b240d0f
X-MS-Exchange-CrossTenant-AuthSource: DS4PPF0BAC23327.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Oct 2026 01:23:14.9940
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: onZlDFw3RH+WrZw09kLrxRu7/hg1Zm24K6cSgeecRjIffIEsNhKP/g4UYDd7E1eFC2BigAeXXOXBHbrMD/75DEEo8vOBkfn4JibOCIB2Wo4=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH3PPF2B89F77E0
X-OriginatorOrg: intel.com

On Thu, Oct 15, 2026 at 10:34:25PM +0800, jianyungao89@gmail.com wrote:
> From: Jianyun Gao <jianyungao89@gmail.com>
> 
> When dax_range_compare_iter() returns a negative error code (e.g. -EIO),
> dax_dedupe_file_range_compare() incorrectly returns 'ret' which holds the
> positive return value from iomap_iter() indicating more iterations remain.
> This positive value leaks to the caller, where vfs_dedupe_file_range()
> interprets it as success (bytes_deduped = len), causing userspace to
> incorrectly believe deduplication completed.
> 
> Return 'status' instead to propagate the actual error code.

Hi Jianyun,

I looked at merging this today but the Sashiko response stopped me.

I do see you addressed Sashiko in v1, ignored Sashiko in v2.
If this v3 Sashiko complaint is one you've already addressed, please
reply saying so. Thanks!

-- Alison

> 
> Fixes: 0e79e3736d54 ("fsdax: dedupe: iter two files at the same time")
> Cc: stable@vger.kernel.org
> Signed-off-by: Jianyun Gao <jianyungao89@gmail.com>
> Reviewed-by: Jan Kara <jack@suse.cz>
> Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>
> ---
> Changes in v3:
> - Fix the Fixes tag to point to the commit that actually introduced
>   the bug (0e79e3736d54), not the one that renamed the variable
> - Add Reviewed-by from Darrick J. Wong
> 
> Link: https://lore.kernel.org/lkml/20261012144925.6728-1-jianyungao89@gmail.com/ # v2
>  fs/dax.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/fs/dax.c b/fs/dax.c
> index 6ba50142eeb2..1f6a4fbb97bd 100644
> --- a/fs/dax.c
> +++ b/fs/dax.c
> @@ -2261,7 +2261,7 @@ int dax_dedupe_file_range_compare(struct inode *src, loff_t srcoff,
>  		status = dax_range_compare_iter(&src_iter, &dst_iter,
>  				min(src_iter.len, dst_iter.len), same);
>  		if (status < 0)
> -			return ret;
> +			return status;
>  		src_iter.status = dst_iter.status = status;
>  	}
>  	return ret;
> -- 
> 2.34.1
> 
> 
