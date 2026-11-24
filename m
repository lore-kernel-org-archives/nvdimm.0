Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=198.175.65.18
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1795546294;
	b=rWxr0aCRXNlDYMbfjGe6xLsiy+8JY1tQmy9FNFnsC0wcvNQRYBqTwHyZgT+yMiVQufy+
	 HzVX2m2lI2XgLYU5t41lD79uGavc8yqZGNDoqHZ6waS7v29AqZfXFvb3TYUSJA5JKgBIy
	 2CDFqJi41/m/nYa8hIwGkU12hBBeamrYNrCi/o4oLhODyn8qcggzsmyG7KG/VCxYhXTxj
	 l+CRo2FIg7ot9PXliTAQ05npOFszP827fO0FmO/dTJPCS1ZCQ4G3h7fVkmx4TW4sWqhxi
	 asCMOTi9qpH6C/CTr5jxRtivJC1QAzCifw1bi838QGLZS/HShOxoAt/vbIx4EStVw6A==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795546294;
	h=DMARC-Filter:DKIM-Signature:X-CSE-ConnectionGUID:X-CSE-MsgGUID:
	 X-IronPort-AV:X-IronPort-AV:Received:X-CSE-ConnectionGUID:
	 X-CSE-MsgGUID:X-ExtLoop1:X-IronPort-AV:Received:Received:Received:
	 Received:DKIM-Signature:Received:Received:Date:From:To:CC:Subject:
	 Message-ID:References:Content-Type:Content-Disposition:In-Reply-To:
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
	bh=mY+1rXXCNRVR2B1GRHfj5yOCu3FFGiAk/RrCt1Ctie4=;
	b=wwdP+U9bVJ4Pn+jQZl1ImZRSu5LzIOl5lbjW6xrSBNl+t6QHgICPksjldPpPvBIq1W5Y
	 YVqaI50tyO8Tpv9Mir8FEDPYCdDFw1XQa7S1zrk8sFoc7dCKvk2PTfL60ErxVbI47qgdZ
	 9FHMfDhdd0cCc4XrMfmMzSyY66fArp36rBvUfeEYVx8EUNrs5WD4hREuUPQOgkFiLzfWb
	 ryGi43dQB/NjYzDz36AKVWKYw+vfZTsOkNRmzqM/PUvCx5Vkps85jzFjQ+pT6iEHNUCZ7
	 MW9CdtuNr3Zn2KDEhw0+2s6+x1LPFom176h++7+MkbNiwC52Xdq0UPi9zBmbNfjTbuw==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=intel.com;
	spf=pass smtp.mailfrom=intel.com;
	dkim=pass header.d=intel.com header.i=@intel.com header.a=rsa-sha256 header.s=Intel header.b=J2kJyHHT;
	dkim=pass header.d=intel.com header.i=@intel.com header.a=rsa-sha256 header.s=selector1 header.b=ZMMlcnMr;
	arc=pass header.oldest-pass=0 smtp.remote-ip=198.175.65.18
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.18])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8819E606A326
	for <nvdimm@lists.linux.dev>; Tue, 24 Nov 2026 18:51:32 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 8819E606A326
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.a=rsa-sha256 header.s=Intel header.b=J2kJyHHT;
	dkim=pass (1024-bit key, unprotected) header.d=intel.com header.i=@intel.com header.a=rsa-sha256 header.s=selector1 header.b=ZMMlcnMr
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1795546293; x=1827082293;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=jMAj7Ozaa+6HD1rvayRKypp48sZWbv0ZJ1C9PNW54D0=;
  b=J2kJyHHTfWoSgp2AWL/wLlt2SnGOA78BxhgIECxtWaFqH6TRl7wpb0gD
   oN5OCLoP3xLDPsLmLQ/UoMGkmUWHxV24tfGZ4yG/wCP4aLNFzBuRQ6iAo
   SH4EXLxMGHuh1EjmXiLv/JtK6aJFk/+zOwruyWThblfSxo4nAQe6blPJg
   uqUGLBKMLHNCb4CNoi+wBIQsS1IwPLUMY3290FrSzgJUx4eqGdZkOMuFB
   ME6skzaW5AnttZoEgt09BsNXZdZZSOa48l4/Nycs/iqJVZxqMida1qYz1
   GkEYLH1M/EF5kVDS0ASLFE9nFfMRsGvUlmyF0WYFwMxj1BDlr+0gVFwzR
   g==;
X-CSE-ConnectionGUID: /VUG+KL2RgKF3MzY5wa0Iw==
X-CSE-MsgGUID: 8ZAFBGxdR2mvrA5dICkxyQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11976"; a="4419215"
X-IronPort-AV: E=Sophos;i="6.27,231,1787036400"; 
   d="scan'208";a="4419215"
Received: from fmviesa007.fm.intel.com ([10.60.135.147])
  by orvoesa110.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Nov 2026 10:31:16 -0800
X-CSE-ConnectionGUID: ZLKxMU1lQRSBq1FFu1vo0Q==
X-CSE-MsgGUID: 6C2Ty/p0RjirJRcV/ThaXg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.27,231,1787036400"; 
   d="scan'208";a="11979666"
Received: from fmsmsx902.amr.corp.intel.com ([10.18.126.91])
  by fmviesa007.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Nov 2026 10:31:16 -0800
Received: from FMSMSX901.amr.corp.intel.com (10.18.126.90) by
 fmsmsx902.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.57; Tue, 24 Nov 2026 10:31:15 -0800
Received: from fmsedg902.ED.cps.intel.com (10.1.192.144) by
 FMSMSX901.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.57 via Frontend Transport; Tue, 24 Nov 2026 10:31:15 -0800
Received: from SN4PR0501CU005.outbound.protection.outlook.com (40.93.194.21)
 by edgegateway.intel.com (192.55.55.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.57; Tue, 24 Nov 2026 10:31:14 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Y/S08qQ/fVwEk3latUjeR77NzuI9kW9cwr1lkBC0bGmVRRkfGld1/GNSeynmzcLcPvMszduOt80m0PhDHRV9mOQ0gP0AscVMBTGbmeUfJeFOA0aZJ6+ckDcMworDJtRfJw+mE3yi8LSnt62+mgRcyQ/1Ad5AQM5Q8Se4qXgjm1yqaKMFynWNRyWVq+wJDTiYZxiTQTm0q+7BuHyyQTXApuk4mKbQlzj2qXr2pHCFAHGY9uNWQwAILpgPOcAiI5mn2kB9mOSMILHARDLdQIefiWbiKg0E9/WORgptYwcMVBQtg6JDiq1l7My/VIxDo1zgQlIOlCPrjRyHRd1/jHqkIw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=mY+1rXXCNRVR2B1GRHfj5yOCu3FFGiAk/RrCt1Ctie4=;
 b=sfXTNeQ9vdxIcRC1hYFJ0ytfH3+IjhRRkNKZk4rGfVZW1rgc5d7AcCRYprWb5ya7q5G7y5BIdHnSy4shCm6PwWU85tvTmR8zJsmaf4YV7/FglUWHaLgn4Gxp1nzRymvToxmxps7y5Dz8WEyEGTOIS0ZIkd7C5jbl9wYpRYdxxjYPUM+HBq+eTka4i/pXiuFJBF84XCCY9S0ljgdu+V+xVV+OimWUzsMg0WNa19MNBdIPhDEnqfFhWKl2DZ+OZn7uYowkJbILAAIfXetn3yD5HpL2DUbcBC2K0OnVmk7zrgDuWCpsgbznlzMwLeY5Qw7XhgbAN86F42X86FXbjYI4kw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=intel.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=mY+1rXXCNRVR2B1GRHfj5yOCu3FFGiAk/RrCt1Ctie4=;
 b=ZMMlcnMr97y8xxrKa82opXp6PCNoSw3qnK22hlpYxgjTxx5PzJKLq+St0eD3rwb7FFupGj1m/T4ipGAYPwTqkKSmp6wsXOnR9vvbHqtdPHu0jDCgwuLhgjf0eqUb275yMsmKIGtKKUMtwdOj7ntNwgQNBP+XOkXES5fUF5YFAAE=
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DS4PPF0BAC23327.namprd11.prod.outlook.com (2603:10b6:f:fc02::9)
 by PH0PR11MB9774.namprd11.prod.outlook.com (2603:10b6:510:398::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.662.4; Tue, 24 Nov
 2026 18:31:07 +0000
Received: from DS4PPF0BAC23327.namprd11.prod.outlook.com
 ([fe80::a1fc:97e0:329a:4aa7]) by DS4PPF0BAC23327.namprd11.prod.outlook.com
 ([fe80::a1fc:97e0:329a:4aa7%6]) with mapi id 15.21.0662.001; Tue, 24 Nov 2026
 18:31:07 +0000
Date: Tue, 24 Nov 2026 10:31:02 -0800
From: Alison Schofield <alison.schofield@intel.com>
To: Anisa Su <anisa.su887@gmail.com>
CC: <linux-cxl@vger.kernel.org>, <nvdimm@lists.linux.dev>,
	<linux-kernel@vger.kernel.org>, Dave Jiang <dave.jiang@intel.com>, "Jonathan
 Cameron" <jic23@kernel.org>, Davidlohr Bueso <dave@stgolabs.net>, Ira Weiny
	<iweiny@kernel.org>, Vishal Verma <vishal.l.verma@intel.com>, Fan Ni
	<nifan.cxl@gmail.com>, Li Ming <ming.li@zohomail.com>, Benjamin Cheatham
	<benjamin.cheatham@amd.com>, Gregory Price <gourry@gourry.net>, Richard Cheng
	<icheng@nvidia.com>, Anisa Su <anisa.su@samsung.com>
Subject: Re: [PATCH v1 01/14] cxl/core: Return endpoint decoder information
 from region search
Message-ID: <awXX5vNLxf2cef24@aschofie-mobl2.lan>
References: <20261104230445.66625-1-anisa.su@samsung.com>
 <20261104230445.66625-2-anisa.su@samsung.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261104230445.66625-2-anisa.su@samsung.com>
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
X-MS-TrafficTypeDiagnostic: DS4PPF0BAC23327:EE_|PH0PR11MB9774:EE_
X-MS-Office365-Filtering-Correlation-Id: 0d8ff952-6e92-4a78-ab76-08df4a591a84
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|7416014|376014|23010399003|366016|18002099003|22082099003|56012099006|4143699003|11063799006|261022105027099003|261028144727099003|261026140227099003|10067099003;
X-Microsoft-Antispam-Message-Info: A/qabUV8EhTLWBmzOq7AW53fUdPO9NLyyG7MGItD68hFIrH8vGl4bCk2gI5wZfr1jJhByvYinvSfFgPZcM9pQaZLiiU0AjLBcCDOSxQJ0wQAXc/lXqpdPGlEDX2ja1Iv+dytbwvy8aOTNXpr30u1nnrS0R7vzeZpVgmVcEQgPg05UmqNjz0s60HWgtpqZLL978eFvTOFa1IEsjcNuNU2KaOQkZRHhWYmKMFYeSiEA+KtIxNVWGBf7xJP2B1EXlqUlhsh+OyVEGiejRzlWMy2ZDr8dCYBce2orgzv2EDaY7TBlOtG9sTSFBRaKZO0Uop+3jHosYB2ECC/beBr/qYUfwqQCVzEn0YA+pIwREIgMnhaPFMGZvJa3dUUMMCA6rg4inC6Y4Y7ahJ4ufdxFGq8oM1zThhFoXmoyVfaulmiY20mFyW01BT7kBHCVfVY380juVsWEHmeWrfeRPn/arA8qa1zoctfkC7vlpbW5rUkQqVFrbCE1+oX5VeYkBklVw2mmAHzz6fwaHUVmFtPzJMFZSvJlZDifn2JFPstRDEI34fBIU81SIAb0+I22OrsKabVaOUy1QgsLbyLXbY3eszalcAvQDqCPQNIUhf4I+YWmgSZhUYxhey2ApJIN5nX62ZGFUHdiq6fKiUU3y1wczFuIAqIBKqfzwCHotbr21MUMFY=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS4PPF0BAC23327.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(7416014)(376014)(23010399003)(366016)(18002099003)(22082099003)(56012099006)(4143699003)(11063799006)(261022105027099003)(261028144727099003)(261026140227099003)(10067099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?F2yHcWe1ikTubtLDPapfldbEHqAjPvT1E4v20ISV6jJTrBu+sZr6eA4lBgpa?=
 =?us-ascii?Q?vcr02WMCIkyL2QW0wVG5ImK9gLIaSdJXbywktBgTMeLVpnjQiH3bZmxcpQNr?=
 =?us-ascii?Q?+P39Mi6QhSH/fUAH4lTAczTt/CRAv7OEvPJuR98hsr71KnA5cXdXKeejvGcj?=
 =?us-ascii?Q?iFsxfjYqiapArWFSIlmEt3k72pdAgO72jMARsc/+lINvRRSOVDdjrB0FR6os?=
 =?us-ascii?Q?uElNtcKSMrgeKDjldJodLXTbTHp0eAcHQce9BofHnhADdcIFvUQDNz0CB+zy?=
 =?us-ascii?Q?QT/iVRXxgNqFOADziWxCTEzhZKTaa8LqGwNnGxzzcKqeHoyPeYs5Skjooa1c?=
 =?us-ascii?Q?snNnFvA0LY0w/wSfXmgFIzvSEW8sPh62LNZJAVa2sULarj1Tj1xZ/5YiZ3MP?=
 =?us-ascii?Q?djtnEtBYl710FDeut5enenABoDBPsvg5+mZ+30EqpmpO0UM9yIyEUCV9l0bC?=
 =?us-ascii?Q?tqPsnfkPyk2oknP/EJwAkwv65RF3dAMWNk1dSsb93vMh+ymN/L7KIxzp37Ap?=
 =?us-ascii?Q?cDVwk6WPO85zK9cX5t3FuB9bnSzXbadGRIFBkqucI1nnGj+bROUytOD1TXlG?=
 =?us-ascii?Q?2JWO88MBJuQbj+LS2jWAdfknDjjISmfH3+7nSGjaXB/tbggHw+i8aA0kwZFf?=
 =?us-ascii?Q?I0IsVtSSco1eDGjkqY+O9jBbQ7m0c6zrHXTUrNIt8gcupZIhWt4ukrJettcU?=
 =?us-ascii?Q?/mQhEAIjv7nWwWO+kOsdBxIngSp6djIGfHzunB6km7y/ovAIQ59drGAhlPLp?=
 =?us-ascii?Q?LgfZjx58QqKLUVSTLM89EFQ7L0KQmRhaGnDsNVTXs4OehMBeffhfTyIYLcGQ?=
 =?us-ascii?Q?KQImGyJsusTXt/hy7oKDXcEd0gCMzNix9itGVzZQlBXJo3QTqrMbEIeaYgPN?=
 =?us-ascii?Q?DCqc1i8YTTuM/OvDF+AWimfd1Aqre7lGkZAPAAd58OGnzkXbpu2hfRwK7p74?=
 =?us-ascii?Q?HV0520xp2Om6+21EQ6QAzRA6vVByyqEfdb8S5VWthwhG18weUFmWycSxUUIQ?=
 =?us-ascii?Q?FxRyFuwuzMMfxfqwp+Zgv/bijKCB+cgK7E38GRCnKb3F0/WpXmy/80PCK0X6?=
 =?us-ascii?Q?OD0Sx0SNrffKzDQ0ITBG693k5JjX/VTw35hRap+6TXPL4tX5YpngvHtZcE6R?=
 =?us-ascii?Q?CCsBbzYIbHo8y0IvK3NLTmgsUAnDP1kOOyBKQGfeQX3eOr34zaZmjrEOhrVS?=
 =?us-ascii?Q?Jht5DOatpivl6dz8Wxa6gTd8N7G3F2PkN5pmdUmaOgiJJ4p/J1wXLKCr2kzq?=
 =?us-ascii?Q?I7hsGA989tiYoBqv9UYdrmNou/p3EEmgV86GKhGs19BfACOxb7bOQD0mBMj+?=
 =?us-ascii?Q?q/koXjzz70BuK7r0sPKiL9vqeMe+zeFzdQ7L0JsBlcVSSCOlpTQFqwkQ16fA?=
 =?us-ascii?Q?0LdLn4nbnmx6Vqrg2sWeaVubGZTcKdHTOoe7+U9yA2/uBaOZqm+xrPbKE/NB?=
 =?us-ascii?Q?VWWp36EFQ3tWjp55gAp+7ar9Q1c45X77rFwxKUQkgIFYMjAUB2pYRfYV8RBl?=
 =?us-ascii?Q?fe7r9QdvRo6laBK5gJXD8iVhi3PlAdEiqW0xSA32YkBQrAz1q1aMd1cr05iI?=
 =?us-ascii?Q?gAgY26fwZ2zHZCRHQkjtci7+goecj+iwN1vYSLE1Qq3fM0UsuqXUah4ZN/ps?=
 =?us-ascii?Q?gNViPMsjZE3k0obIUwQTrQYvrBpW5kPs4O6uR76JsNGMZ15K3KkEK0jyhZ4c?=
 =?us-ascii?Q?zYYO9gZ0N3xr7zM5fTzxVe6fPMMbauXdNjFhTp937JrbrzvY+3vRWSu+CIxo?=
 =?us-ascii?Q?/Ex19sKXmn/B/3Eh8k25mWuEELqAhOI=3D?=
X-Exchange-RoutingPolicyChecked: Egt05X/FpJIi4g3a7mzCFf7FMqPOE6Lbr8v/RSJzp/lwnibImCJINGd+L4OykebV87cPSdZHmjVWgUam05SjDzQ7akdVLnPqqTsU/9KgIPvOuCV9mVeyacru1167uIFl2RU7rNWdpxbQ34OTrRagsRNWY3w1OKyYRBQTP3AH7mmDy7/i6mGTqJ6Tp2JExksiorLyeoV+yoVmlm1yExpt+ihbdLcC7OqO7CxDEvJ/DK7oc6M/9TnDn8wCoCe9D7ALU5Lzxlr4/2tXUdcHiUqEM5ivliRRXutHJlAVQsGDsT760k1Bv9tXcvc3kzE9+UybN7NzmUstRe7WKL8oGmhWkg==
X-MS-Exchange-CrossTenant-Network-Message-Id: 0d8ff952-6e92-4a78-ab76-08df4a591a84
X-MS-Exchange-CrossTenant-AuthSource: DS4PPF0BAC23327.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Nov 2026 18:31:07.1298
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: wcWufPxtb+HWCb0U+OuLGi5oppdDBPLDHYk7eDPqLHeJgf6gR20HNa9cQvP/0L54ftfgIi9XllAkOtImDIa8zzkbfAM/H0ulXH6YJ0P6MXU=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR11MB9774
X-OriginatorOrg: intel.com

On Thu, Nov 05, 2026 at 08:02:25AM +0900, Anisa Su wrote:
> From: Ira Weiny <iweiny@kernel.org>
> 
> cxl_dpa_to_region() finds the region from a <DPA, device> tuple.
> The search involves finding the device endpoint decoder as well.
> 
> Dynamic capacity extent processing uses the endpoint decoder HPA
> information to calculate the HPA offset.  In addition, well behaved
> extents should be contained within an endpoint decoder.
> 
> Return the endpoint decoder found to be used in subsequent DCD code.
> 

"subsequent DCD code" reads like a pointer to later patches. The previous
paragraph already names the user, perhaps just -
"Return the endpoint decoder so that DC extent processing can use it."

(already tagged)

