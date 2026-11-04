Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.remote-ip=192.198.163.10
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=fail;
	t=1793761624;
	b=FHHKkT5ZEbuE0ILBYIVgF0TTe+GjrIsDHSZQGHXInLd4eM0VGMvQjSCjUBi6svrDPIr0
	 8K1sQkVVdVD3xrlipZXrca9JJZGqPGGNExoSWZXhQi64V0cbHvTuqkKaK+ss2raxCiZ0o
	 X0LwCLJLHN1ytl+czFmAdfJbrumyGMxQdpJMtCe4phOutQftaOJBWnJvYGzr+gIyM/aZo
	 YQwJtVcmSpQ4zBWoYd8TL9e0sDeJgncmdK/g7cY4vq8oBApg4VcGbcSXpxIh7oKTqheRF
	 O/36zcRTDWZZ9lLVFLgjmGGGNNc4jy8673DXXS/xJDSMKvRwFGdnBBNrYWhmawRkHMw==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793761624;
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
	bh=5bEwnFqAmphGmBwS+VPqs9hGaekCvuBPHrxQJI6EYnA=;
	b=jZaYgnGWaRJOj1zeLQ8Srq+aKgxOgvSRJd+cZzMQnFEotTj9KUTAmgwbYsS1igm2yGDw
	 Y4hA4muq4qpxiUZU9NZWh32ZZh3blnU/fjKej5gdrjij0yPVuf/VifrEL97TNQPBA0Z5v
	 nu13TjQnnA28tF3VPuIMUBEWo6vQR0CpTKLSmJPDJSFvmMP0z10N1XJYAAnROWpEhw+db
	 9stBQbtjTde+Vrwcdn+BkiaaiFenbBdvAncuiFzQMcy2rK+S0Jc1pvkBeUck3svBnZcln
	 GCFOWtBOhG/+OI1eCCAt4sVPX41f/aR99FWGwoyNTVbz7dhnEhGY1uq+S30z6lDraiQ==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=intel.com;
	spf=pass smtp.mailfrom=intel.com;
	dkim=pass header.d=intel.com header.i=@intel.com header.a=rsa-sha256 header.s=Intel header.b=cu4qNU88;
	arc=fail smtp.remote-ip=192.198.163.10
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.10])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 357D3606A31B
	for <nvdimm@lists.linux.dev>; Wed,  4 Nov 2026 03:07:02 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 357D3606A31B
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=intel.com header.i=@intel.com header.a=rsa-sha256 header.s=Intel header.b=cu4qNU88
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1793761623; x=1825297623;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=IDMgQ+uP9/NrFd0SMaexTj9VQ9OTVY8G/d2uB16vfLY=;
  b=cu4qNU883BjmkliqD/iY6sE5GX08xQX4SHzTvbNUtzSUEYNUuICvqKw6
   7JtrG85MVZxnD7MWE2HAfw15yJ48e5hi39iCpVprITiui+7B4BdryJtTE
   GwTrzhJJgkSNMGEuMn17IMAFqcKNXXtEP6CPm8PsghFnVNkybX/Kdslmu
   paBOpxch3t4Vf3hfM1sQg6R0Ij5KgL8FBqyHippFWiZV5gsdW3k7MNNiO
   +0YHmlD9EM/Ccui6VAP+xSPR/IoX22AWy5AzYy0yKS+nySmNfgIFeqtf9
   rmi4FGLLPNk1Xf8MZlQsDztx2rtdQaAUrW0qv2fyWDdjjkmEZsIJvAs4S
   w==;
X-CSE-ConnectionGUID: EKT6+g+5SIiFBCmpc+l/IA==
X-CSE-MsgGUID: uQaooxhDQ+eV3rQAv1m+/Q==
X-IronPort-AV: E=McAfee;i="6800,10657,11955"; a="2406556"
X-IronPort-AV: E=Sophos;i="6.27,194,1787036400"; 
   d="scan'208";a="2406556"
Received: from fmviesa005.fm.intel.com ([10.60.135.145])
  by fmvoesa104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Nov 2026 19:07:02 -0800
X-CSE-ConnectionGUID: 5XpeyzzFQpKyqCqvep858g==
X-CSE-MsgGUID: ELzMJgL7QZa3lb/sXRZDUg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.27,194,1787036400"; 
   d="scan'208";a="6712841"
Received: from fmsmsx902.amr.corp.intel.com ([10.18.126.91])
  by fmviesa005.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Nov 2026 19:07:01 -0800
Received: from FMSMSX903.amr.corp.intel.com (10.18.126.92) by
 fmsmsx902.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.56; Tue, 3 Nov 2026 19:07:00 -0800
Received: from fmsedg902.ED.cps.intel.com (10.1.192.144) by
 FMSMSX903.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.56 via Frontend Transport; Tue, 3 Nov 2026 19:07:00 -0800
Received: from BN1PR04CU002.outbound.protection.outlook.com (52.101.56.43) by
 edgegateway.intel.com (192.55.55.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.56; Tue, 3 Nov 2026 19:07:00 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=EPV1jfRXlYNpzp6Vi965ZFbgzwi6AM3NvsoY9/T8PduKxH7N2QIqXt3y6YFvJH5wgZ3Hg9gFWI4eIs8tAIowzIwEzTULDsGRXRkLEhcSYzxICHCkgURge/3cUIabz7zHBMKd9lRWpwZVlc1Rqo2tzeW/6vvw3Ovrk189TBEgY940qdL2o3GedST1+E7emlLS0+mzdbZiLFE8Y/mPvsjguF0ocZYJWVPB00uZ48Edd2CAQKDh6q30maMnaJll28mPKrCiz0BL64W+tzaCpYOUvR533HdkFoqPotv9J9B+jMatRaupgcNB8Yvoby/kAoY+7JXUqYdNUTjV/A6OLbT6jw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=5bEwnFqAmphGmBwS+VPqs9hGaekCvuBPHrxQJI6EYnA=;
 b=vpsV4Ea5P9Ts8X/i/CFNQhYgn7EURWBLgZxrSEsZQP6ZbGhnp5kXWwoELN3fUdv2ZEUEKq0GcNdeAAIYXpRLbQkAr+t+SqZM/q9ilCeNyZxhYReK3seTnxHj5FC73wR5Ty54ut7CanLpuIwDnSPkwLpPc6hmK2k9apuhYRP1c5Ra/B2c6PBZeqebIOtUFq3UrSK7wGCU4L8Gkn3YIJVg+h+bGr/P3gDCCDehS1+G+V0bu+24rAJnbegt3JqFidH9c8vHmLc6S5CK9q/6OnUA/tmx0hkSCY4wdnm7uji0p9h67JcD0cdLwWN9F9J26IVRz30MdODFceXeOZlBNsdmMg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DS4PPF0BAC23327.namprd11.prod.outlook.com (2603:10b6:f:fc02::9)
 by PH0PR11MB5782.namprd11.prod.outlook.com (2603:10b6:510:147::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.569.12; Wed, 4 Nov
 2026 03:06:51 +0000
Received: from DS4PPF0BAC23327.namprd11.prod.outlook.com
 ([fe80::6fbf:c112:d0a8:f1a8]) by DS4PPF0BAC23327.namprd11.prod.outlook.com
 ([fe80::6fbf:c112:d0a8:f1a8%5]) with mapi id 15.21.0569.011; Wed, 4 Nov 2026
 03:06:51 +0000
Date: Tue, 3 Nov 2026 19:06:47 -0800
From: Alison Schofield <alison.schofield@intel.com>
To: Dave Jiang <dave.jiang@intel.com>
CC: <linux-cxl@vger.kernel.org>, <nvdimm@lists.linux.dev>,
	<linux-crypto@vger.kernel.org>, <dmaengine@vger.kernel.org>,
	<linux-kernel@vger.kernel.org>, Vishal Verma <vishal.l.verma@intel.com>,
	Matthew Wilcox <willy@infradead.org>, Jan Kara <jack@suse.cz>, "Davidlohr
 Bueso" <dave@stgolabs.net>, Jonathan Cameron <jic23@kernel.org>, Vinod Koul
	<vkoul@kernel.org>, Frank Li <Frank.Li@kernel.org>
Subject: Re: [PATCH] MAINTAINERS: Update CXL, NVDIMM, DAX, and others for djbw
Message-ID: <auqhR3H98vkCdHTk@aschofie-mobl2.lan>
References: <20261103201547.4079847-1-dave.jiang@intel.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20261103201547.4079847-1-dave.jiang@intel.com>
X-ClientProxiedBy: MW4PR03CA0346.namprd03.prod.outlook.com
 (2603:10b6:303:dc::21) To DS4PPF0BAC23327.namprd11.prod.outlook.com
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
X-MS-TrafficTypeDiagnostic: DS4PPF0BAC23327:EE_|PH0PR11MB5782:EE_
X-MS-Office365-Filtering-Correlation-Id: b8502037-3280-44a6-73f2-08df3a20ac00
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|366016|376014|7416014|23010399003|21046099003|22082099003|56012099006|18002099003|261022105027099003|11063799006|10067099003|261028144727099003|261026140227099003;
X-Microsoft-Antispam-Message-Info: UoYp7x/KE8qYATzCLnbEWEotlR5fb9Fh6iLr/EcEKf4qzM9dWqx6yhR093ZzzT7tEkzZyodQKWE/rQElBgYktnsSldRuQlCkEq7EFU77XNUMIGkNdUnoFcD3ktN31zmyRlt+UYYGcpUtPuphO1B0HhpLDG0+wSSI07bCmoBRgN7wDo4qqPb5zvEsBgp5wXdXwJFU5ka1rJKMFueB+a7jWOg02SroFhuO94A3grkrdKTfAcz+jEeExmPWfz6MHqdUoKwYmZJzx0nmjzf7fgQrCUaJoB0o6Cr7dc8N25PPQWQMhORYs5AOIcnSfPoxRlItfT0NDGCrH/7ViGrcwbP9B0F50x+Cz3YnqxzSpwEJ5LHIewAmBt2HAPPk8I1lSK3mPdoqi+7v9g5xdZhPZ4Kzv/kU9WDA5tAJmzMh/GXMEAudomvvZ+m8BTK+SaN+JMixUfOdH27zFhR/FhcVFN+KFwS2D52qboWGYUeT3GxwJsQtfANcrWZoaVXwCuBBcBCcre3dOiOcz2lga/MEH4EYw9sjrBp2Jkc5U4aY1FClk7S7ZnqkjD3KNQ3l6unnH8JHc+u+bz3EEV4BKikBpl1Pj1lVpHnyCr5MC/iTmMipQhK56E5fGEVZJUPsBkCmRGQBWUGOtYmy3lQ+ERqtG920ml3po/1jPPerlgn92hhVSm8=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS4PPF0BAC23327.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014)(7416014)(23010399003)(21046099003)(22082099003)(56012099006)(18002099003)(261022105027099003)(11063799006)(10067099003)(261028144727099003)(261026140227099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?gjS/+5Ordpuz9gXpV1H3p1nCsdxe3t2IKKWcze5Cy5M+ilAqkNZg6G0CsIog?=
 =?us-ascii?Q?p9qx2F4NNMFWEQwsEfap8uh9ZFZW7lnHOOonmtNrE17EhS+OgJkEQGI47O5F?=
 =?us-ascii?Q?h0fyN6jxxd3ISvCncf0Ja66qbHnKz7rDfvJPo4j2SoiQmgFmTC+KucNnz3qo?=
 =?us-ascii?Q?ncvUKFFxYwstNcuVz7c4NwvaaFcpFluWGET/Kh3UHk2/qXsv6NCC2NuE5IyG?=
 =?us-ascii?Q?nckTWMiRdcF6ul/fKRjJ9OnnP25D5QQGiTUxQ9OP+pzequ0mguQFjeJRKt6C?=
 =?us-ascii?Q?7mqDIY6uaWpd98cdGhfswFOprHBSn2OlxI1Gn+HeMgKG+CShnyCo9X9N3P8P?=
 =?us-ascii?Q?drpvb8hXGuquKVof0cnQgLwc0bMMo9aheUv/cgnVwGlIulY1jmlni/GB+It5?=
 =?us-ascii?Q?CtFbzEptMLi52TzGR/Cno/ghkvVI+qFmRkJN8JPK/AIghei1UcMm5P0aW3wn?=
 =?us-ascii?Q?davbZTh2fce9NzTxknj43WlJSYfRPowg4uPduQUJ9frrUvs1z+ri9Gg8IZPu?=
 =?us-ascii?Q?SrKKcptf4pCHPULPaJiX3m071z12mNHaVvH3ep+1/b8SJhdLn6zpj0MFCvCy?=
 =?us-ascii?Q?cNlZ7NMsEuY3ZnZMAY+q6ybI+VxQJHGl6Noiu54evU8kvbbtJ+/zmLYGNU/u?=
 =?us-ascii?Q?edRn3KR6p3rNwQFAtSVdj9dBTIxI/ZRoDWv63/vTI51MQr+pkcW/Q2uSB3up?=
 =?us-ascii?Q?opfe8QenszxSVuQG/BDmDNTLlrUgyiH0Bw8VK2SFHZdm5kWCi5UA5XWID/qb?=
 =?us-ascii?Q?NqKHP52isB++UDS4mBRgD9dVcuHUOgwCBVaWolLLnXTBUUr+LPf8X0LrjP6M?=
 =?us-ascii?Q?HkFNd8Z5VusSj7jqpsfDN0azwXhq6Xh5c0kaotWXK/20Nj77ItqpRIxL1Y+2?=
 =?us-ascii?Q?YODotCHRp2usddQOabHT1uZxZa+81LYSQtXgP09hbss4OkkLsI3wj0MVKNR4?=
 =?us-ascii?Q?OCt4x3DdP/dOv79pi3DS1VoCwy0LkkGARmRnhvXxC8xYRH8V3sC8DpCMEqzz?=
 =?us-ascii?Q?ZxTd1wLROLAckyqQ7eviGagCZK4DMox/Zpw736U5cT0Y2oqCwDR8RcmtWeVe?=
 =?us-ascii?Q?YBEDuP5Nvj/87pye8Vm59ri78M7AK11W2zKwpJJNuC0nZ6uhqMvqqr1dToF8?=
 =?us-ascii?Q?5E1l7p06O+v9cD309VrPjh4dAehUHloRyE/aSLO7eSrMkd4+cIsJ8+CfOm/w?=
 =?us-ascii?Q?zLP4cgoYEslhUh3oWymtUD8vwqoEeUs1azvHlFjyKXtcA3MEbrTPgRWkuljQ?=
 =?us-ascii?Q?MMc14FJBzyEKA54MWSY6Tb/f7AC1jPwPEE4s70KU2KE/1FBpOEjZZH9SiWRv?=
 =?us-ascii?Q?0D5TounaJuveS5eLIyNPj9sdhbFM5/Li8UKSKnm1M8pKJf7/aMT4mNGoxH4D?=
 =?us-ascii?Q?h/GS7ua5nsxjvEC0YJJBm4Jo56J8Pmo6nO1hhIPXmEi4Rgb4AGYmTWK5xzmM?=
 =?us-ascii?Q?V7E2ceAZhLDR3Lcoc61klN/ZR+F10uegmkUlEsk9DuuTVVWHlLUMeq315uYS?=
 =?us-ascii?Q?ogK5mWd7J3LGJwCRwTHLXQ/AX6nwVjvlvmc4rZ6RD4dRIegpxPqYnyif9vRB?=
 =?us-ascii?Q?WT4Dj+HY8PvJHFty4xucUvtzCELPXavRUBNEe1wwjmbdIaqyAUafqVAr80V7?=
 =?us-ascii?Q?X49PxVRzaoTnA56oPvudhs7ZcFX9AldCG6X3ES/V0UiAEMyX4/jwdnGa7S5f?=
 =?us-ascii?Q?RJ6oVjXBF3MnWt/7RwAkZfXWatJpY269uatd9yF4L666RkhoL0WDM62JKDw+?=
 =?us-ascii?Q?d0jyHb9sl1TXdFuOZiF+y+VT0ZyGiNg=3D?=
X-Exchange-RoutingPolicyChecked: XhONVnxwx2yHIGiygiHRWbDreOdT4AllJBNsU73DHX2TcW42U37rBS6fEGMLhRQDPYoB/eLCAcyE3jo1zmhR2kKMrdZFYiiF0CyM3emGZE9mlJ3p/DWsa5EHHI78gBFSJIv7+KgHByGErLFQd6Pcj4Pa+cBq42yOiEFLgFP1MPhi9LQcsW8gJS2zIV80gF/FjcWw0scdxLrFOE0QpdoZghLrRcp4I8BJ4CTW3794RADIV9gJ3aaiWPPyJPxcqhI//cXJ0eMy6NIHjAS1Zb62PQTiYYrznJnOFZWtSy/OnhkiVElsOcR2VV0zAduEbGpcmiTtSAdCSA+GBojRhdoSxA==
X-MS-Exchange-CrossTenant-Network-Message-Id: b8502037-3280-44a6-73f2-08df3a20ac00
X-MS-Exchange-CrossTenant-AuthSource: DS4PPF0BAC23327.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Nov 2026 03:06:51.3691
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: zp1LFBtt3p+/hNCK++OyzbKWkQdLNrFAGVRQ6phALKXmhBJxxa/Nl7FF9G3SM1hncZRs0sALM0Taa5pItlv1ZG4KIjHUdUPkHGUzh7+SxhE=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR11MB5782
X-OriginatorOrg: intel.com

On Tue, Nov 03, 2026 at 01:15:47PM -0700, Dave Jiang wrote:
> Dan is no longer with us. Removing entries in MAINTAINERS to prevent
> people from keep emailing his address.
> 
> async_tx will be essentially orphaned. There has been discussion of
> deprecation for the feature on the dmaengine mailing list.
> 
> fsdax will no longer have a maintainer. But there are reviewers still
> and Alison Schofield will continue to wrangle patches for DAX overall.
> 
> Cc: Alison Schofield <alison.schofield@intel.com>
> Cc: Vishal Verma <vishal.l.verma@intel.com>
> Cc: Matthew Wilcox <willy@infradead.org>
> Cc: Jan Kara <jack@suse.cz>
> Cc: Davidlohr Bueso <dave@stgolabs.net>
> Cc: Jonathan Cameron <jic23@kernel.org>
> Cc: Vinod Koul <vkoul@kernel.org>
> Cc: Frank Li <Frank.Li@kernel.org>
> Signed-off-by: Dave Jiang <dave.jiang@intel.com>

Acked-by: Alison Schofield <alison.schofield@intel.com>
