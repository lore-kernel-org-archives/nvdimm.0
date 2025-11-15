Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 68CF814BF92
	for <nvdimm@lists.linux.dev>; Sat, 15 Nov 2025 00:54:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.11
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763168073; cv=fail; b=a+HOO57VMUa8yG/vB3TdzKdiaEhJKsCm9z9EZ8oDOuO/aqPX0dz5l3zEkvpYYxLXNVdC9L3H2HZHeAZrnfBdIEUchxh3fCw900zLT8EKqEdYKwblqgBRhJgMZ2z6uahkfQuATJV+xJYbBImogfoUxkUUcf2O9notR6cdkOtOGp0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763168073; c=relaxed/simple;
	bh=wXw93BeDtaf7ISBRCnu9i2xnbeIrqUMus2NO1P9WLIc=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=RY5UdP3pSmKDp2nw7XzpwD/ZB/JfvcCFafCrlEFdRGiHDIKE4FmX4uDees+0XSJcYWtR/Cxf9gVTFdrxmeSxKVekAZp0BbuelB5SumpJXv2FYN4kUn/J551SoKC6v2/zJNafhF2IepYF1p5hgtx/UA1/uxz/qB0w/aAry5iflo0=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=MC4rxjeZ; arc=fail smtp.client-ip=198.175.65.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="MC4rxjeZ"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1763168071; x=1794704071;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=wXw93BeDtaf7ISBRCnu9i2xnbeIrqUMus2NO1P9WLIc=;
  b=MC4rxjeZUWx9Loee/FxhLblrpru79ZD5WKJI6n2bIGLlGUMyey5XswyE
   1yWNGrcI8gRuJPR1wBK1KLVG5OrWpHMjlzKje51b2Yc3LfUqs4MJptsfI
   w4gmjvTgqO2aSRTLRTgv6hzjxr4sxbpQQn18j9FPx0rYbww2qnzVz0XcK
   XfLeXq3PgdkicWqL2UhIGEUzhyGrPWEQuovEtbxvZ2Buw+1thkY38E9Ti
   cVai6zGTvRwAAVr6hSKRaVtct4kB8WYQjADHVz2NktzWl/3ytD2Dn6YKs
   coc1869/ihh9CJ3LCG61/ij3BjdL7tRdla0DLZJgxyUW8ka1rp3npJwBY
   g==;
X-CSE-ConnectionGUID: XNzmoNxYRASnW61zAk0IuQ==
X-CSE-MsgGUID: WiEthpfER4qd6NuKPhOjPw==
X-IronPort-AV: E=McAfee;i="6800,10657,11613"; a="75586028"
X-IronPort-AV: E=Sophos;i="6.19,306,1754982000"; 
   d="scan'208";a="75586028"
Received: from orviesa004.jf.intel.com ([10.64.159.144])
  by orvoesa103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Nov 2025 16:54:30 -0800
X-CSE-ConnectionGUID: IEFB+xIXQjSzcEJ0pygO8A==
X-CSE-MsgGUID: LIFuokhcQ6i+8anVzIgSsg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.19,306,1754982000"; 
   d="scan'208";a="194350471"
Received: from orsmsx903.amr.corp.intel.com ([10.22.229.25])
  by orviesa004.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Nov 2025 16:54:31 -0800
Received: from ORSMSX901.amr.corp.intel.com (10.22.229.23) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27; Fri, 14 Nov 2025 16:54:29 -0800
Received: from ORSEDG903.ED.cps.intel.com (10.7.248.13) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27 via Frontend Transport; Fri, 14 Nov 2025 16:54:29 -0800
Received: from SN4PR0501CU005.outbound.protection.outlook.com (40.93.194.12)
 by edgegateway.intel.com (134.134.137.113) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27; Fri, 14 Nov 2025 16:54:29 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=fT68AvRJp/E28m0dwn9w9gFFOsNc9MOtECFG/K0ft3SLS3I7FqSx2yKBvegz36otMhwVrFprwJVXdILhFf7W6UhWmYEj7zqnVz4g4xIkpoxIjh6bnmosP4uCo7bfd/9mBqK7nOwb0IxpYMRIZXVFoSLcX6ASniGEWPg+USQY5YHxviZKMrfBq67eSJgdHqGT59wRR4aPpoTJ2iao1U/0R3zaIGBrWL2Q2h26u31SnJGC5oCXknBzgOaWD54hmSCJ070O16EXpLoIeBs1iudLmkBfemJ1ZY26e0LokOcLyM3DOWNPZoW9NB3UPzpl16rtRt3WgRj0yhONJngLZzhdzQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ATPR4qBoDY/zXIOF8y3ox6jRNAsQz2h/M2dOwpzI69o=;
 b=JhlmbCmK3jizigg/xO3FN64GqOJZVNLNWZp7zQFbuZneiPSRUef+RyMTQiiTRcOLkgzYzdouTeT2u1AxxhkewRykW3akFU6VNSO4shlj0fdQDDBvsKZ1+lA38vElTwBMG+drCdOd2IAZGWp7arKHRhAyZXplTh8IF+Uf/E3zMHFIWr+6urfYsr0K33ZLi04Q6xcd2DKQxlQE2k6cF/omGH5+3A5ERr73uwKBZTmqhjdJdXB5i+9lpgKSZx/eYsMqWBHhXBm2Oz/UfOsRmSsvoLPHYnU6g8m/day4Yf4vXcEBPbRNd44wc0lAV+fUUA89HFn7O+R0YdzqNS13zJe6LA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DS4PPF0BAC23327.namprd11.prod.outlook.com (2603:10b6:f:fc02::9)
 by BL3PR11MB6337.namprd11.prod.outlook.com (2603:10b6:208:3b1::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9320.17; Sat, 15 Nov
 2025 00:54:27 +0000
Received: from DS4PPF0BAC23327.namprd11.prod.outlook.com
 ([fe80::46c9:7f71:993d:8aee]) by DS4PPF0BAC23327.namprd11.prod.outlook.com
 ([fe80::46c9:7f71:993d:8aee%6]) with mapi id 15.20.9320.018; Sat, 15 Nov 2025
 00:54:26 +0000
Date: Fri, 14 Nov 2025 16:54:23 -0800
From: Alison Schofield <alison.schofield@intel.com>
To: Dave Jiang <dave.jiang@intel.com>
CC: <linux-cxl@vger.kernel.org>, <nvdimm@lists.linux.dev>,
	<dave@stgolabs.net>, <jonathan.cameron@huawei.com>,
	<vishal.l.verma@intel.com>, <ira.weiny@intel.com>, <dan.j.williams@intel.com>
Subject: Re: [NDCTL PATCH 2/5] cxl/test: Fix cxl-poison.sh to detect the
 correct elc sysfs attrib
Message-ID: <aRfPPyhC5aauX09g@aschofie-mobl2.lan>
References: <20251031174003.3547740-1-dave.jiang@intel.com>
 <20251031174003.3547740-3-dave.jiang@intel.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20251031174003.3547740-3-dave.jiang@intel.com>
X-ClientProxiedBy: BY3PR05CA0004.namprd05.prod.outlook.com
 (2603:10b6:a03:254::9) To DS4PPF0BAC23327.namprd11.prod.outlook.com
 (2603:10b6:f:fc02::9)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS4PPF0BAC23327:EE_|BL3PR11MB6337:EE_
X-MS-Office365-Filtering-Correlation-Id: abb5ba1d-41b9-4df4-8334-08de23e18689
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|1800799024|366016;
X-Microsoft-Antispam-Message-Info: =?us-ascii?Q?twwn+E7ZbroJH/5pEjplAPn8/I8JdACz4PX3L2A/uz8ayAanSg5JZaQG4lLA?=
 =?us-ascii?Q?P2ZpfVJK4ezg2GZ6Q39Mg/OfzR8aFzOaUcvMZSNawknB4t9SmpsogwZGdDeN?=
 =?us-ascii?Q?h821vBXNTtghuH8MX90r3JrIJJQFDySmHuiOrPmvqJ7mMA0mxc7Dylv/ZIKb?=
 =?us-ascii?Q?XyAeZa5UftMh1P5u81+snldX6N8PVPRbZoa03/sWs/9f8gZrQSDpL02ldCru?=
 =?us-ascii?Q?qv7vuXuIXnQ1MjvX7Go1JB7kPmsKxgQvz+zIRsZWbdP26C050exCphrgXPfB?=
 =?us-ascii?Q?gyjx4a9t1bQ4Q4uihUpaTxO5waHE4QQK+O/53et7lEF2vtPm0fGv86T+4rhK?=
 =?us-ascii?Q?T4mv+Vo16EVBvhYtakMTKL+kSUAeJ3yqPwNso4yiZzoQHkCJW3NZ7/ZOut3S?=
 =?us-ascii?Q?scAlgMZI0OFxxx97y3jVBufcCtegLfvTuxFD4Y63SIhpJ9/vRnDTvfKidy5t?=
 =?us-ascii?Q?blZQq5UF+Dn4DiduwvcpDxYp9r4yj30b2Rg4It4sBcUOORu6Tlwb/HQaE22Y?=
 =?us-ascii?Q?jLUPhNnZiXbuel/AyUHtoY+4bdJemopdI3nwQztg7Ywumcm+855JukyieVm8?=
 =?us-ascii?Q?238f5l1VodOwSx3D2s67Se4yZEStmNqBpOi+Ram/VO54cfbrnx+6AMg/shUX?=
 =?us-ascii?Q?5Inzhj88RTvUbWjQacgShwKhG3JQlkuCN+zMzdYDR+4lme5Ci7Miyfjk3fLU?=
 =?us-ascii?Q?Nmr7LyfcXiOSApA8TgAGSq/UfRflKhZTQQyJPTFywpMNSflleV4WS5Ukadal?=
 =?us-ascii?Q?gJwfpP/8EVuSypzWMglYE0M7Dbbgh7JMKcyOYWglU77cYc1FkYnPYEfL3vwx?=
 =?us-ascii?Q?dOSynYRJ9VDLGQ1D+2Jw0xYyimMs2nZvF6cPPdnGHJGvolAAAMrUOo2w0JjM?=
 =?us-ascii?Q?XjEX4AEommXO8MA7Waw+quQdxSgxPcVv+A7uZTPZvZtXlZwd7mwpsAlrbgKo?=
 =?us-ascii?Q?qKNG4nf2J/0XG/7KbpsMzUO957bAk21hNu0M24ORRXgLtpAtEdda58jxb9dV?=
 =?us-ascii?Q?aC1pMG39hGGwpPNcTsOsnW02jqLTcFIJW94U9ba75Hr59A/qbBo2sgrEDI5m?=
 =?us-ascii?Q?zrAED7pcNPUf+4vf/Sd8Go+PXsEzrz68cKqfTLHmguAzKSW9NxA65nAO7a9u?=
 =?us-ascii?Q?kpSQ0/rATVB1Xzjua3WK5MoQivDtjRihwR3nP/h88ZUqZX1JamxJjQsZJdMM?=
 =?us-ascii?Q?g+oNgSo/l7IvVDGYwWDYU/ReZT/fDs4kfp/JgCotFg4Svxv3lpeI+ahdMKiH?=
 =?us-ascii?Q?VgIHqCwuKnjQiqufJcK3sDTgagFnoKdcXiq5QY2YPZYKiWnivBs98WC0ONN3?=
 =?us-ascii?Q?W97V6n0RC4xYsvoePT4sXwDxfFxSEVZuHJjo4TggrXYhlGqqsqJSOaVOupwp?=
 =?us-ascii?Q?HenPf/mWMh2gHs8VNzc1T/sFWrDXN6U2GtfQU9lJZ2QIrttWMQzZG9PQTqRa?=
 =?us-ascii?Q?zHVXqHuTkJ3yTHZ5CWzVt1DScomHma+zhQsfNkJb1n2cbwjJl5gljA=3D=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS4PPF0BAC23327.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(1800799024)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?c378Oax8Tkogg+1w75XwpMDBxVW0gRY7FlPg4/GWZCvREUu4Qsr3sxpj26/g?=
 =?us-ascii?Q?r+eFUL4jm+Y1iJ3PvdL6YZDoIQpvHfYuq4YWRLr03cFwkA1tN+lV5DwmR2uU?=
 =?us-ascii?Q?M/zdB7DyBbzBz3ZxTEE5N69o2hpqeNOjZ57ecKVSjuLFz1eU5Eu/HoimoBsy?=
 =?us-ascii?Q?lbllCZ43XVGBK2WuYHRso87GfU3LJKOBQWgAbSyS/mS6wHoG7kzorPZ0DKoh?=
 =?us-ascii?Q?sI21mdmN6KP+lx+7RZEHIT6f3ClZqK4k4WPQCAqRZeV/2erXWtJwAX81z6/L?=
 =?us-ascii?Q?7joOrt/YNfOoIikt3bT1IMApeUO1pldzLEKlB1BQMqFA7mlvgf6Ujw46QJFP?=
 =?us-ascii?Q?IXrrx7EoOnnBDwedAMJa1qrEJkGRqtTaDtNbBAyLucEi28Db2q2eMh/+wKHF?=
 =?us-ascii?Q?G5p6u8fXGk4zf4dBj8JV3bJDo6pMSRjOFCiyOC0GTSoZTqkf4TtquuWROvWp?=
 =?us-ascii?Q?bLScdNLvoPtpgldfG0EmvNNY5PpI0zqXdD+Jcb3sbdxhC8xE1ROFg4IqJZVp?=
 =?us-ascii?Q?qEjliv8PW8E+MtZivR7FqyObqkXGVbVeUrcpopa95A8eOd1v94mTgIl6d3t8?=
 =?us-ascii?Q?cTE+hrq/tTTK7k/CAedlFcQpO0Z0JMDrkv7ML+VG/WPBPYKMtOiyRimVxXhb?=
 =?us-ascii?Q?ZfeBnyDuLJtvuIIFadhKLVbPNNLsByL3XF+YdMk0ocR2UosPVe07L5FrD8LD?=
 =?us-ascii?Q?q8zDZDKTXxI2E3j7jNPuSdoxOOdTRA6iQNi31vBvPXzI+wVSnPA7pEuZTNrS?=
 =?us-ascii?Q?gcW8Mk9NLXe4UZI8qe9uqcumEiD/MuJjzXPeZTyljIvuH380gXORTaCdtOEY?=
 =?us-ascii?Q?wcjqMd3VLlaszhclofxnweqeEYhA/N3RvvSHqMurb6Y/GdUQ8iIDVaLGeTMX?=
 =?us-ascii?Q?aboK4EzooB81hEdDGCRa6RS7qREo6ACgnNrzw+XENMp0x+rWzzJnfpmmBV7s?=
 =?us-ascii?Q?E7FA0PdN/iooyzq6Ji6TegfsGcsGgdgiKL5C9e/4tp9QnSTwlkLYrFfRPQ4L?=
 =?us-ascii?Q?qyyyUn4lJSJojbomLIuLy4Ioq9ILfFtrl+N1gP8l/gKwAlxatXWb0ZakswBu?=
 =?us-ascii?Q?yRPBS3VMd6GtAoxi/lC8odiobOWa+o3lnqezJ1RKMMQ5//G46oku3nCqKWHQ?=
 =?us-ascii?Q?fZ4bFUwHw8xZTA4EUP0DkMRVcoIiJw6HND8BmfqsERLX6Ohdjfbxw+fCaIA5?=
 =?us-ascii?Q?QNlXCYms0cyfZhL02mP96GW46JEJTVAQCA1XjSGHLUuMA3r7ds8rySNgFz44?=
 =?us-ascii?Q?Dt8z6zBkKWEAYCnR/t9fRHdxMYUhXlWLsKMRjANOcMudUI65tQr669dRZir+?=
 =?us-ascii?Q?iBzX9AeQTdnWJT6+MyRnSQXpKr6FO7ujjocgyxYResR9PUgpJlYTe8q4VSOq?=
 =?us-ascii?Q?T5spppM/ky/l9/zBt2ZBiLRrgiEdfimkXenbISo/+8v3qvRAnYv27p3Ihceq?=
 =?us-ascii?Q?EycABsYuZEWmtabQQFdeeCvX/lxNl8YXIr7vhzYFijip9dAC9GAiWjRcj0nK?=
 =?us-ascii?Q?PfepMjmFPaNexqA2ns1lPlo9uTpKHVz30qOP7dbuyYcGxk9u+lsdPb8sR7eW?=
 =?us-ascii?Q?14bfrElu9qVlXMWQ8h34xK4F/XeM/hFqO54BV4RNKfSthCpPv6fv5pBVX99W?=
 =?us-ascii?Q?ng=3D=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: abb5ba1d-41b9-4df4-8334-08de23e18689
X-MS-Exchange-CrossTenant-AuthSource: DS4PPF0BAC23327.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Nov 2025 00:54:26.7893
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: R8TNpCDZ48JqeKW2LQ+DQPpqxuMpFf07b1++xNPzYorU1M2ySe63RlfYe8OTkmqpIq2ZVplbBNAK9dpcI4xHf6eHmcdqAaAm601HDSROqX0=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL3PR11MB6337
X-OriginatorOrg: intel.com

On Fri, Oct 31, 2025 at 10:40:00AM -0700, Dave Jiang wrote:
> The cxl-poison.sh script attempts to read the extended linear cache
> size sysfs attribute but is using the incorrect attribute name.
> 
> Signed-off-by: Dave Jiang <dave.jiang@intel.com>

Reviewed, tested and updated to the no-op comment
[ alisons: update the no-op attribute comment ]

Applied: https://github.com/pmem/ndctl/commits/pending

Thanks!

> ---
>  test/cxl-poison.sh | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/test/cxl-poison.sh b/test/cxl-poison.sh
> index 231a0733f096..8e81baceeb24 100644
> --- a/test/cxl-poison.sh
> +++ b/test/cxl-poison.sh
> @@ -197,8 +197,8 @@ test_poison_by_region_offset_negative()
>  
>  	# This case is a no-op until cxl-test ELC mocking arrives
>  	# Try to get cache_size if the attribute exists
> -	if [ -f "/sys/bus/cxl/devices/$region/cache_size" ]; then
> -		cache_size=$(cat /sys/bus/cxl/devices/"$region"/cache_size)
> +	if [ -f "/sys/bus/cxl/devices/$region/extended_linear_cache_size" ]; then
> +		cache_size=$(cat /sys/bus/cxl/devices/"$region"/extended_linear_cache_size)
>  	fi
>  
>  	# Offset within extended linear cache (if cache_size > 0)
> -- 
> 2.51.0
> 
