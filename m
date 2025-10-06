Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8673A17A316
	for <nvdimm@lists.linux.dev>; Mon,  6 Oct 2025 16:48:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.12
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759769288; cv=fail; b=f/QM35H+va7SvT3ii4xUgLGVrMmhXBVRP+LHsQS1Y1GTrnYBpJuhGN3CDEG6bYbNTcHxka4Jx7rJYvE/06Xr3n9J4RLjUyNKs8zXJGb9C5OiJdHt+gpWszcl8QPoDoc5doP4Hvyca+62aiWq5jrV6fbGEcYW4BGlEJRxJft/Vas=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759769288; c=relaxed/simple;
	bh=tZNBDnZ8WD+JJI9N7UKmpbJZsnVMW1iDROGKVez9hVk=;
	h=Date:From:To:CC:Subject:Message-ID:Content-Type:
	 Content-Disposition:MIME-Version; b=HFQg8EjIRZyP2bO1X/gu81ZRpMh2lT1hOhgaoXggAyXhRSMJBl1mihx+4FyYa5f3r5jdckn41IILiQSaXpuQIz9yqui7XY3cwTT6CvYrlzB9Quy1zG7v1Cuo1Fo0Er5V5pMSz0aycYWx9NtwPZ70kkmdzcKfxyOaEYq27Rjcnvg=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=RNGvWhpk; arc=fail smtp.client-ip=198.175.65.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="RNGvWhpk"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1759769286; x=1791305286;
  h=date:from:to:cc:subject:message-id:mime-version;
  bh=tZNBDnZ8WD+JJI9N7UKmpbJZsnVMW1iDROGKVez9hVk=;
  b=RNGvWhpkfuj55i1GOvxBjTz3OZwI1NjkggSnsB2K3z/HxJdeJ8TvXjNC
   YUnUsNndF28j2dk+73zF3MpGAHeBHvjOQ/t8OhsSu32e94Nb0xEb8A6hh
   gdyRxeZ6VSTmkOEY/Wazz2srlK0dWYuiCdZzaPA9mAYLrFj6UuhLrBIwa
   DRwewuJHI7k29qfctYwO3AhpPkZqF13RzNckZmcCfi6DN55RSuy5om1JH
   Htpk4djH63kstQRS56N8tcNoQjiHP3bhIPxgztgfOgRCgOBQ7V83iOWAN
   zV0XAkxlObDNsgKpq7cx/mEHqrDIO4yy6Q79GWe83AbKIX11npUaSqEBN
   w==;
X-CSE-ConnectionGUID: eIbm56LQTHWcBfn9x4Itlw==
X-CSE-MsgGUID: jzYlzqIZQY6Wg9VsewOQLA==
X-IronPort-AV: E=McAfee;i="6800,10657,11574"; a="73368660"
X-IronPort-AV: E=Sophos;i="6.18,320,1751266800"; 
   d="scan'208";a="73368660"
Received: from orviesa009.jf.intel.com ([10.64.159.149])
  by orvoesa104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Oct 2025 09:48:06 -0700
X-CSE-ConnectionGUID: vZKo0ksqQZWPNmODciVUfw==
X-CSE-MsgGUID: gD2wMAmbRLSG59SA9raowQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.18,320,1751266800"; 
   d="scan'208";a="179523098"
Received: from fmsmsx903.amr.corp.intel.com ([10.18.126.92])
  by orviesa009.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Oct 2025 09:48:05 -0700
Received: from FMSMSX903.amr.corp.intel.com (10.18.126.92) by
 fmsmsx903.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27; Mon, 6 Oct 2025 09:48:04 -0700
Received: from fmsedg902.ED.cps.intel.com (10.1.192.144) by
 FMSMSX903.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27 via Frontend Transport; Mon, 6 Oct 2025 09:48:04 -0700
Received: from CH1PR05CU001.outbound.protection.outlook.com (52.101.193.8) by
 edgegateway.intel.com (192.55.55.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27; Mon, 6 Oct 2025 09:48:03 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=yPpZbxnnGo0C3gATp79jK70UwWn/MaHxPRr0/xqwmZz0MKRTn2MzyOi8WLjeQDCssewNzMmnsMPxhjApf2OUPokHeYX5+R6K8l1gtZ2IUxC+oZPQkmqvs9MtYEIT5NdK5CBaNxDwP4wc8Hzy3+r7vhnwB4oZrZqvg3oj/3jKqT+wXm/oG848G6R3ygY4mO5C5RPEqKfdM9pG22TLvwLIamm4PCvG29aaDREdAldeBEO4WqCV6jkhutrf4wlf9W5YKdniHUGjPPXrjIbxwVXMW0K9MUZN57ctCNmK//cc4v5ggJa2aIxWcg/B42ZPkUg4fkETx1ytXUtD+kW4Xyj2jw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=GyvsFDN7ixAalqDkFTeWvSjMYy4R8zn3Tt2OFawjj58=;
 b=LO6esGIAF89wgd5n3aO6sSmeP3cAwvAcBL0dCQFeGiPYegfvsbxXFM5E4fNn/zveIszh+CaaIVpBOrs0gwqAB5BS4tEPz3FAS8gOtiEKwfKDtE/xY3Zb7XhN2w49J7r2e/PiNT9ercS7JhE9dHDaIQP/1A2ufEtgAjFfn58kInofwKFAdfddapYxJq0MIRCdNKcrg1a9tVVKOVLtljVV6R2El4JAAM3xwnDFWYIAfGzrDPFrJ7DxWKVgmvSr/3Z1Roa5zW02IQEZWqGDSTNEPQhqVH0hB67DnhFhheU0HiBk+7cbL6XdwtNvl8UfvTNa6KPAd+HMKttIiltGbnoVsQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DS4PPF1C61BB986.namprd11.prod.outlook.com
 (2603:10b6:f:fc00::71) by PH8PR11MB6732.namprd11.prod.outlook.com
 (2603:10b6:510:1c8::10) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9182.20; Mon, 6 Oct
 2025 16:47:52 +0000
Received: from DS4PPF1C61BB986.namprd11.prod.outlook.com
 ([fe80::32d2:f7f:239c:178d]) by DS4PPF1C61BB986.namprd11.prod.outlook.com
 ([fe80::32d2:f7f:239c:178d%5]) with mapi id 15.20.9182.015; Mon, 6 Oct 2025
 16:47:52 +0000
Date: Mon, 6 Oct 2025 11:50:00 -0500
From: Ira Weiny <ira.weiny@intel.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: 'Linux Kernel Mailing List' <linux-kernel@vger.kernel.org>,
	<linux-cxl@vger.kernel.org>, <nvdimm@lists.linux.dev>, "Jiang, Dave"
	<dave.jiang@intel.com>, Xichao Zhao <zhao.xichao@vivo.com>, Colin Ian King
	<colin.i.king@gmail.com>, Jonathan Cameron <jonathan.cameron@huawei.com>,
	"Dan Williams" <dan.j.williams@intel.com>, Guangshuo Li
	<lgs201920130244@gmail.com>, Alison Schofield <alison.schofield@intel.com>,
	Jiapeng Chong <jiapeng.chong@linux.alibaba.com>, Abaci Robot
	<abaci@linux.alibaba.com>
Subject: [GIT PULL] NVDIMM for 6.18
Message-ID: <68e3f338166e_2bc301294bb@iweiny-mobl.notmuch>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
X-ClientProxiedBy: SJ0PR13CA0015.namprd13.prod.outlook.com
 (2603:10b6:a03:2c0::20) To DS4PPF1C61BB986.namprd11.prod.outlook.com
 (2603:10b6:f:fc00::71)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS4PPF1C61BB986:EE_|PH8PR11MB6732:EE_
X-MS-Office365-Filtering-Correlation-Id: b7704dd7-fbb5-4913-0b22-08de04f81666
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|7416014|366016|1800799024|13003099007;
X-Microsoft-Antispam-Message-Info: =?us-ascii?Q?mKM71e6oacvUgaQSlyxhoz2qn4GYt5ARK3AcMWRo9mm8DETcgoMJNwhhJwHM?=
 =?us-ascii?Q?TI4B0w7w3WbatzzOjhIXX4F09jcWduIbodqR+mCl5NGvpGa98w8J1Es3jsVQ?=
 =?us-ascii?Q?k45ijEBg9vH8OGZ69A4MjZciNBHj1duRM6Qcm8TzgnVFRgeVFYDC25mp5OPN?=
 =?us-ascii?Q?pV5jLi7xTDOBrM/ACLSoy9Awog1VPN8zwa2nJGGcPl3dBDedKzQ3GTru8+Yu?=
 =?us-ascii?Q?boEKYPzVKhbdQrXCl70tHLwzUmfgM0tjZvbuAXpQEzZD0VonvRc/zcZsLasm?=
 =?us-ascii?Q?4vkH4G4fr1iXPispvPNZcnjSFZ/lBEES+qQSBcmRKboKROkjioNYIA4IIbjT?=
 =?us-ascii?Q?TxqmbyNQo0mSkWZiW9h+D5JvCacCxbFJvIRyJGHQMOW1AxRjGjm6Ag5sBvPk?=
 =?us-ascii?Q?133oJ90yNO48wgwI9RsbOpvpWQZBoTxTK7jz4e44fqVhnfXmK1wzuoNCOZ61?=
 =?us-ascii?Q?3Hppxxg9sNYTg07WwwS0BZup1gnaU+b7A0FA8MRQBRM9yLW7e3xq6HBfI2Fj?=
 =?us-ascii?Q?meesnEnfWshyKjcf0OtJosKse0XKqg5oVzea38WgtdQNFP4/ja6Jz89igSTR?=
 =?us-ascii?Q?DoT8M1IXjtXFFGsxSbRKJhQ1o1rkzCdCJUWpkp6bNXMZscJFXvoO5kQu5MUm?=
 =?us-ascii?Q?kAikyYC4wIB+oW2InAaKi+1hFdGQEtUdK+SgbO3ccb25JaqiNW/HuECMOGD5?=
 =?us-ascii?Q?vbaeIG1IYALbMkQrt6OxCck2UoDZXnpJSPUEOdI3E4XX21YmrzeJ+u/fB/ij?=
 =?us-ascii?Q?j60NuShjrf9jJKX54iXkZ7O7viuWzKJM4+dAgZ8xCxqR09LhmGcVoRQ3LsJB?=
 =?us-ascii?Q?hKK2YHv0ACfdhJZfnRn16kw0ZQ+NwK8nzaawyzh72FT/qVb9jvponU9Pd+hC?=
 =?us-ascii?Q?OSdtiK4sA0pzIbu9qWYLfqPuf2ltFMo3F6csLFxDwf29eElWeHsttIao+PCm?=
 =?us-ascii?Q?dh1xluS/euXmhe9wkyzPnWFphNh+3MsjkytJykux3lF/HS9UvRXV0LowFdXI?=
 =?us-ascii?Q?0+6CQ0hs49fdW5eR5XfycUKgBI285W2bEznTOfXZPydT8bBOTojUCBkj/nID?=
 =?us-ascii?Q?F8tzfHZ0yMFnAVreV2FxcA/FlzYYpCjkRYJXNIWToPhuIu9Kzj9eYr5cDySj?=
 =?us-ascii?Q?of2pnKUr4EBvO2zw+eLsvYHoHvvO1VzvQYBmkLIEoKoBxM908ppSDge8Cs5B?=
 =?us-ascii?Q?bBJVPNzajsYUm4solkq1C2q3OSh/qn+GRVv0U1DLWrAo2r2LoSQ5B3Re8trp?=
 =?us-ascii?Q?kfu4H4ZjaTHG5nwTWBukbWt/WFuIK7sMgLKN0wC5LJnTCNrALZS4T/1R6ilc?=
 =?us-ascii?Q?qPQOMu1LgoBRyZv2djV+qhcE3jcQnqIQwlXOSTOC5PUgat0KTZt3Bvq6iLI1?=
 =?us-ascii?Q?O4Rh3Rv1ZwgGuvtC3LnigP864c1snj0zpr84cKfiClmImhQxBdCTu/yoq8+X?=
 =?us-ascii?Q?EQptiN3h579k6wT8izdXh8yC/JjkEGl5Cz9fvsARMbCaGVo5VNS27g=3D=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS4PPF1C61BB986.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(366016)(1800799024)(13003099007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?cBfgqVV6DxlfF46VGgI5FQiDko0q5xbqmIqcIhKX8Ps4EBdRGRHwtP6BWh42?=
 =?us-ascii?Q?I5ZaIs1rNJUzbVGe9hDlwvwQaB9CfWZwgTb0ctAlhcUJo5He9N+VH7XaDP8f?=
 =?us-ascii?Q?SXBeSIwbecihF0LUPA9tZm703Bzs8Iqaw7MSz2zyiji8ot7Kyu9Q2m9OPQn5?=
 =?us-ascii?Q?1dgZ3Xr9DUqS5gy+5PvIczOQjMe9gvM8xp7c9rgYuE6/D4R04bkhGIBba3Pg?=
 =?us-ascii?Q?nA4X315KFCl/M3X3kX2/BUYxy01hk+rg+RMQuUYPfS0zRM6MD+Q89L2wIDH4?=
 =?us-ascii?Q?LW0SKARjFa1FEo4DH5aJB0DLr3tuIeU7tcEey/4ixJqqOb/Fc1lnirPlXd99?=
 =?us-ascii?Q?BeyJgsHjTYlRNYNiGrix8SvDHsQFrNnb9tnJLOwYaJOdQlxRixS8sDmN/cYi?=
 =?us-ascii?Q?hQxZyDr/1nm/F0x1SM3hDSjMSeNlOOQuVsIKuzRKDLwS5k43fBTcXDmy9ggo?=
 =?us-ascii?Q?cxROUdoO3FC9O1NuBw3ZmyEv6rRHP/culNVQRbmapeh43WZLvJOX6k60U3/y?=
 =?us-ascii?Q?v/2WN1F+VlDoOxFN3GExVsXnU9PgtLrCdMVvYE75tBicZihSdRPA0xCEMeY+?=
 =?us-ascii?Q?da3gcEno3d/TAi7W5c+6BTUEamG+s1pFoJcv8TcRAaYuSwW7SRadZueqWAL0?=
 =?us-ascii?Q?Z68ugZOnEKYEju2pXCs4Id4dMR+mkQnKTMP5HP38f5QFj5PJzVCOvHLhpC6b?=
 =?us-ascii?Q?QagfNmMuBwes/og3I4gkvbU3/IVDfplpXmf8NoFKRatXd9ZM4uHJbYSQmKgX?=
 =?us-ascii?Q?ajwBVp8whMh7Aj0miTzfE3ohLwOoR8DZKyBOnGRMuiR5p+3VZV6J20wCgrxu?=
 =?us-ascii?Q?2SeVRD2PZaTRGamni09PYLxfejLPUVCm/Wni1udA8dLpW17xIfzsQK/7lZYO?=
 =?us-ascii?Q?EzPcd0xX4Zw3R12wbiZNlBs3zcyCVxJ3tuygZhg+atU7kEFimJMEkeOk/86Y?=
 =?us-ascii?Q?3j5MgHo4w1uy05m9qKK/o4u+tMnx8pZecGOEtjiGjrA5/xfx2vbhga1Fd94g?=
 =?us-ascii?Q?GMnNG0bvAgEQGkai1ATHknIbqMakcS+aNOmLMq379RHWaDNUuZzl5yB5khNm?=
 =?us-ascii?Q?jzz/8RoV6Feky3uucPEQ/rG2wbezZOXH0c6ARFVNplaiX3JxpqhOvodX4+Dp?=
 =?us-ascii?Q?zIdX8Fr9kxPgMzGg2ERiAnx8RWgCGb4xIfl2YI7dPlzSQxtu4tczh4RM+nj6?=
 =?us-ascii?Q?Jpe8S2lEQLMH14YDFBTQWLN9XQHwhH+rp8Ryhmc8krQ1Z2vFdPqgxpvgIJLt?=
 =?us-ascii?Q?EvGz72DOOHTsMZN0vi73Ytuncx3wWLYtqGk5DoBWZoiaLEO8monhV1MMviK4?=
 =?us-ascii?Q?L3castAvzlQ9QiEPE+u81ZCpA/wM7RVYKpcSy7cxlE/90Puc3zZBKR7wLKPn?=
 =?us-ascii?Q?FtOhVtoe1VCB49JYdqkY0SyAZJi1RAmy/4ADTSF2e+qHjZuu2RCP7J005qO1?=
 =?us-ascii?Q?uQC0YtHjYhOLqrG234wRhQrb7KWLDvTBcXYEEb8dsAshQLi5ZXxN3tkfOrNw?=
 =?us-ascii?Q?jbY1tmsnHA052OhtHbmwV3pLGVNcAleF6DlXJtTKK6o9zAZlkoZGYrw9a/la?=
 =?us-ascii?Q?7YDgRliXBxB/+9yqh1aPmW/XXElpy6LTrrSoDATL?=
X-MS-Exchange-CrossTenant-Network-Message-Id: b7704dd7-fbb5-4913-0b22-08de04f81666
X-MS-Exchange-CrossTenant-AuthSource: DS4PPF1C61BB986.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Oct 2025 16:47:52.0835
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: oqdQy5+EobCmG/aC1UQHuS2jwdkPpD30il3j8AP2x2UbdIA2EuBMJQpAHZE5bIEvHaIISWSQSQhGTEXiNmtTPg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH8PR11MB6732
X-OriginatorOrg: intel.com

Hey Linus, please pull from:

  https://git.kernel.org/pub/scm/linux/kernel/git/nvdimm/nvdimm.git tags/libnvdimm-for-6.18

... to get libnvdimm changes for the 6.18 kernel.

The changes are primarily bug fixes.  Dave introduced the usage of cleanup.h a
bit late in the cycle to help with the new label work required within CXL.[1]

Unfortunately linux-next caught a bug so I delayed the pull request slightly to
include that fix of a duplicate slab.h include.  Hopefully, I've managed that
correctly.

The fix has soaked in linux-next for a few days now with the rest of the
patches being in since Sept 26th.

Thanks,
Ira

[1] https://lore.kernel.org/all/20250917134116.1623730-1-s.neeraj@samsung.com/


---

The following changes since commit f83ec76bf285bea5727f478a68b894f5543ca76e:

  Linux 6.17-rc6 (2025-09-14 14:21:14 -0700)

are available in the Git repository at:

  https://git.kernel.org/pub/scm/linux/kernel/git/nvdimm/nvdimm.git tags/libnvdimm-for-6.18

for you to fetch changes up to 5c34f2b6f89ad4f31db15f9c658b597e23bacdf8:

  nvdimm: Remove duplicate linux/slab.h header (2025-09-29 10:06:03 -0500)

----------------------------------------------------------------
libnvdimm for 6.18

nvdimm:
        - ndtest: Return -ENOMEM if devm_kcalloc() fails in ndtest_probe()
        - Clean up __nd_ioctl() and remove gotos
                - Remove duplicate linux/slab.h header
        - Introduce guard() for nvdimm_bus_lock
        - Use str_plural() to simplify the code

ACPI:
        - NFIT: Fix incorrect ndr_desc being reportedin dev_err message

----------------------------------------------------------------
Colin Ian King (1):
      ACPI: NFIT: Fix incorrect ndr_desc being reportedin dev_err message

Dave Jiang (2):
      nvdimm: Introduce guard() for nvdimm_bus_lock
      nvdimm: Clean up __nd_ioctl() and remove gotos

Guangshuo Li (1):
      nvdimm: ndtest: Return -ENOMEM if devm_kcalloc() fails in ndtest_probe()

Jiapeng Chong (1):
      nvdimm: Remove duplicate linux/slab.h header

Xichao Zhao (1):
      nvdimm: Use str_plural() to simplify the code

 drivers/acpi/nfit/core.c           |   2 +-
 drivers/nvdimm/badrange.c          |   3 +-
 drivers/nvdimm/btt_devs.c          |  24 +++-----
 drivers/nvdimm/bus.c               |  72 ++++++++--------------
 drivers/nvdimm/claim.c             |   7 +--
 drivers/nvdimm/core.c              |  17 +++---
 drivers/nvdimm/dax_devs.c          |  12 ++--
 drivers/nvdimm/dimm.c              |   5 +-
 drivers/nvdimm/dimm_devs.c         |  48 ++++++---------
 drivers/nvdimm/namespace_devs.c    | 113 +++++++++++++++++------------------
 drivers/nvdimm/nd.h                |   3 +
 drivers/nvdimm/pfn_devs.c          |  63 ++++++++------------
 drivers/nvdimm/region.c            |  16 ++---
 drivers/nvdimm/region_devs.c       | 118 ++++++++++++++++---------------------
 drivers/nvdimm/security.c          |  10 +---
 tools/testing/nvdimm/test/ndtest.c |  13 +++-
 16 files changed, 229 insertions(+), 297 deletions(-)
