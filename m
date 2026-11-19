Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=192.198.163.7
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1795118182;
	b=e+8pR+PqCHEJwACu9WLDDf+HUFgBtDH2J5VKR6ET7OtuJCYmCIjfhjF2HwcFwmfDyy6V
	 mXfKJC++x1kyyY9ZyLm+trBRACn8JGDA91hz6ScVXhDRCtxS2IBFw43TkSXalO5kBjshG
	 278osDL+DcBl7nPEWMFDZ6JVTJpWwjwqkeJCBDh1BGjPjPZfyMExFPz8GpEolQxXmVgge
	 pz7a2n4oHM3lKm5m6yiJ9sX1El4s779anSfwH9kcHvnLEaigkeGcr14ieT2uLkEEP0E5R
	 h4OTkjOPHmNOcU5OEeYfEl0uSx+T4yD/pOKtGAL1wPKUszAe02dg5ntqgybkjKNyx6Q==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795118182;
	h=DMARC-Filter:DKIM-Signature:X-CSE-ConnectionGUID:X-CSE-MsgGUID:
	 X-IronPort-AV:X-IronPort-AV:Received:X-CSE-ConnectionGUID:
	 X-CSE-MsgGUID:X-ExtLoop1:X-IronPort-AV:Received:Received:Received:
	 Received:DKIM-Signature:Received:Received:Date:From:To:Subject:
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
	bh=rDwaAoj1XqFIQ50ZKDoPzHgDZzjgNWRTBBtz4MLSTEk=;
	b=g7ndNQyFGIrD+TJi+Cx0hdX5si9GsFlVcV3pFfEQl3/aSFgHK56X2idcqZ6KNDJQJkbK
	 mkgIRYAHK7C9eBWQO2SRJwVj7JI0uPm3WJ7Yn5qcdsLxsAsquqbmEe9LLKbMjuvvXBBA3
	 yGt9QfEaOMmdBy02lINGJsPM6IZFQrpMrYN5nNiNXW9t4SiroBz5gR6X7Iubph5sdwrvL
	 Y0fIlgWWfYOv3G2njX09kXh0Q3dk+YLNkcAjhWJIknGu3LKiZKxA/R40FtjXwXgbWl+Ua
	 p5Dyf8ruiZ8azcTFhJVURg3LgFj3D+Ne4tthaLvm/3AiNcKgMvjiSbb4K+4sa32z7qQ==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=intel.com;
	spf=pass smtp.mailfrom=intel.com;
	dkim=pass header.d=intel.com header.i=@intel.com header.a=rsa-sha256 header.s=Intel header.b=hwZfz7EP;
	dkim=pass header.d=intel.com header.i=@intel.com header.a=rsa-sha256 header.s=selector1 header.b=nJ4J94+j;
	arc=pass header.oldest-pass=0 smtp.remote-ip=192.198.163.7
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.7])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CB313606A320
	for <nvdimm@lists.linux.dev>; Thu, 19 Nov 2026 19:56:21 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org CB313606A320
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=intel.com header.i=@intel.com header.a=rsa-sha256 header.s=Intel header.b=hwZfz7EP;
	dkim=pass (1024-bit key, unprotected) header.d=intel.com header.i=@intel.com header.a=rsa-sha256 header.s=selector1 header.b=nJ4J94+j
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1795118181; x=1826654181;
  h=date:from:to:subject:message-id:references:in-reply-to:
   mime-version;
  bh=rDoqjallgXpMTlFm2zE5JUTV3DCdFsJZm3k5rNlyQhs=;
  b=hwZfz7EPvroSqtlhUVT+xDu+asB2xzDN4NlvFrFq35fUy0e2L+IGFk5s
   ypYSzXHJoBswtrQgJO+ywLvUP2d8dlkqKft7npZnF6PPkE4NRSA9euD8C
   CAuovVI0VVnLqCfd1gZ20d3yFgjvAKRgpKPiYl/EGsVAzVibfKetJ8V4G
   kNa/jb91rz3tx4jo1Sdjk/3x8alAe6YVA3YaN3gpQebXyXmBrwhHFAWXx
   ylXC87thcWtBwBYf6qu79ez26W6v6TF3Apc4YIQ4gRWpchse/55zFC9rA
   f0vmkVm/RzvleKtLbJDyUzAVMRNRp5dNbbTone8IkM5wiCTQv3YyIHdR4
   g==;
X-CSE-ConnectionGUID: bv0zCl3ZSTaW/TczVS5N1w==
X-CSE-MsgGUID: 0RycDEf/S+GRf6+cis264A==
X-IronPort-AV: E=McAfee;i="6800,10657,11971"; a="3835178"
X-IronPort-AV: E=Sophos;i="6.27,221,1787036400"; 
   d="scan'208";a="3835178"
Received: from fmviesa002.fm.intel.com ([10.60.135.142])
  by fmvoesa101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Nov 2026 11:56:21 -0800
X-CSE-ConnectionGUID: uRYSzWTfQI+EszTAHZrWqw==
X-CSE-MsgGUID: HaRxYTc0Q4atK8+T1URoAw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.27,221,1787036400"; 
   d="scan'208";a="10738140"
Received: from fmsmsx902.amr.corp.intel.com ([10.18.126.91])
  by fmviesa002.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Nov 2026 11:56:21 -0800
Received: from FMSMSX901.amr.corp.intel.com (10.18.126.90) by
 fmsmsx902.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.56; Thu, 19 Nov 2026 11:56:21 -0800
Received: from fmsedg903.ED.cps.intel.com (10.1.192.145) by
 FMSMSX901.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.56 via Frontend Transport; Thu, 19 Nov 2026 11:56:21 -0800
Received: from PH0PR06CU001.outbound.protection.outlook.com (40.107.208.6) by
 edgegateway.intel.com (192.55.55.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.56; Thu, 19 Nov 2026 11:56:20 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=SyPQwLjehkNtpe4SWaei6Kjkhg3sDWvUGfduk6JWy/5kQoBOMWBzCo035ypBdTssouToZXBSQg8LHZbAt75BZyHySlzKbObqyoT2uICFNH7ZSJjXlzv7Jjxwc/gUsxytgs35L3vZJlKeGXP9PRFBfyy286ZEJGaQnB0uljperrxhAMZW1Md1l5iQZ1Bl8HG5nrIF3b5CBtIsikYMy2DFZ6QYctNxOHB2I4QX1IKmlh+AoTHYrWxTb74c5Ulje4/+jqD1MUXP7+FZi+S9VBEu1kOpMwPNZ4vZnCPL8z4XgYPmysSvLNvq2FbIMKienAjhuOZ7c+pUsq6ISFFF97g0AQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=rDwaAoj1XqFIQ50ZKDoPzHgDZzjgNWRTBBtz4MLSTEk=;
 b=UKRTcR8GStwHWpuzznb8kztoA/j/blL8tfleJrJRDnmiBAmnTIS4pZr7ubaGlMiQfHkrPVBo3nDdOyFJ0+/4Qx56bAC2NJoeEJGT++xXjBrRSRhGaLi8jYvVuKugjeWfwZG1aCznNo8iEsqUwlpfDre1UicItBf2WVxyTHEzF83O8VyljaSTvBRTM9VUp3hR1ea5dS0hfCOM/+dyXB7yHWkoIzXvCdapbz9CW0VWmQ0NtEK0Et3F+2EEzzrTP9K0wcjtm1RUTGPgReKVqgn7h+6B2sN8coynLqffwSow6iPxAbr/0TgL2/Ox7dqZntH/jx7mt7H8MdL37op5of5TXA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=intel.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=rDwaAoj1XqFIQ50ZKDoPzHgDZzjgNWRTBBtz4MLSTEk=;
 b=nJ4J94+jnxCqGefzdOVg5fu2THlb8WVwU1gXagy+/hzwyg4+j0mi//Qsiivfsi8GvhwpLXDR30pOK5ykGgy8lYjT/Q2w4dDd1SU5zFdg8qKEECzLA7ZduaF5dUMm1mqFAtZxaCR2TvU1F/P1GHCbNOFu/DNEb7nIBBxQvRfW6yo=
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DS4PPF0BAC23327.namprd11.prod.outlook.com (2603:10b6:f:fc02::9)
 by MW3PR11MB4763.namprd11.prod.outlook.com (2603:10b6:303:2c::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.615.14; Thu, 19 Nov
 2026 19:56:07 +0000
Received: from DS4PPF0BAC23327.namprd11.prod.outlook.com
 ([fe80::6fbf:c112:d0a8:f1a8]) by DS4PPF0BAC23327.namprd11.prod.outlook.com
 ([fe80::6fbf:c112:d0a8:f1a8%5]) with mapi id 15.21.0615.013; Thu, 19 Nov 2026
 19:56:06 +0000
Date: Thu, 19 Nov 2026 11:56:02 -0800
From: Alison Schofield <alison.schofield@intel.com>
To: <nvdimm@lists.linux.dev>, <linux-cxl@vger.kernel.org>
Subject: Re: [ndctl PATCH] test/cxl-security.sh: test dimm unlock with a
 large serial number
Message-ID: <av9UUuDO1JbgI8tY@aschofie-mobl2.lan>
References: <20260702003407.1611731-1-alison.schofield@intel.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260702003407.1611731-1-alison.schofield@intel.com>
X-ClientProxiedBy: MW4PR03CA0229.namprd03.prod.outlook.com
 (2603:10b6:303:b9::24) To DS4PPF0BAC23327.namprd11.prod.outlook.com
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
X-MS-TrafficTypeDiagnostic: DS4PPF0BAC23327:EE_|MW3PR11MB4763:EE_
X-MS-Office365-Filtering-Correlation-Id: 84e3e445-945e-4e7c-d197-08df467725db
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|23010399003|1800799024|376014|6133799003|261009223027099003|18002099003|22082099003|261026140227099003|261021121427099003|261028144727099003|261102123227099003|261022105027099003|56012099006|10067099003|11063799006;
X-Microsoft-Antispam-Message-Info: 7rSFZkZ1JHV31guxf4Euf3pCPvs+Jl4NqIs5Mg/xU3qR9gAHR66apkERehRx3MV6kqTiwdocrQ5hYQj6vsl6a838jLRU22id0Cl24LaR6h5jpfxkMOzgOx4YDNcnrtAjOREBY5S5o6RBjyVjx6NT5/KXMQo6PvyqSr648zvyKGOoVZ3H1fPHQz8eXXCaYc3gLa3Mvgux0irr5IPuAFihVS3IthQ8MNEXVF3mNHtfbWRu7tNrCbwBAkM4bIcBvQpa96tx45FQQW6VyOzQ597DneB0r5j2FIQr3zqMqTax+G/9QpN2+hJU/0qlcFnL1+w89owj2hedIU34sUIj26evjml7LyRSS5+7bOHJ/L+py3OjwYI4PKCruzXfwEdND8QJflhgomrCPBNehSQ5GQ+wsRcrungP+h8twlydJWCFWs7ynL9Zt+gNch33szg6pBik/9aK6FcExL21Fjwv2ddvJRK6EjKWts6yp8wfI04E5MWzfcv/8O+bkMalwcwNNU/muxOqDtJhE7yoUWQ6ttP47qHGBCJ2qoGLzxpXNR4XFssQ0fZqHsitNTCKerylFWZl15ea2ZIqNqkhevPrVdzjY0fzr7/mRNXQ4S8p8q/ayLuuxguBFk5ASKZKzYERgqMwQv+GHzokuFg3G9WyTscU8VCF/0VjHDRy1v2CjUDvF78=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS4PPF0BAC23327.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(23010399003)(1800799024)(376014)(6133799003)(261009223027099003)(18002099003)(22082099003)(261026140227099003)(261021121427099003)(261028144727099003)(261102123227099003)(261022105027099003)(56012099006)(10067099003)(11063799006);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?u4Rn2eD1K9pApTkGjXkY1bnZC8gvlIwL5FE6OOOx+614Q5BkHs8FCbVW7X8s?=
 =?us-ascii?Q?AEZJ7gCj+tWjYMUgIKxkJ9D4Fp8moo540yj9GMhA3/4lAzZ/91wIEhGfw+pO?=
 =?us-ascii?Q?nlIcvosvICpYWamC41GEKFATMTbguhdUOZY+rFGyXNasm/qfpJsg7e8Hrpnw?=
 =?us-ascii?Q?F0h/I9BPA/Ns28U01WUKPvpDkFjZE638GLVcvpgNVfwgt9J7bkR0cYfDkZhF?=
 =?us-ascii?Q?etoTQhoTa1WSyyfcVNTMoFEvQoZTGTYZUBwfb4oOV2v955m+4QdSM/qZXQ8w?=
 =?us-ascii?Q?jaiqqK1Xu0ojC0C5n1+RMlt/UsmgxW4pY+MBgsNNbHwJv4q3mURkevQ76I91?=
 =?us-ascii?Q?nCw51P68lPxBwpaxYGUDPbYKN3NsuFDVpW2H5eiThsKfSb5Kba75Joyl+r9b?=
 =?us-ascii?Q?F1zx2Ii1KCq53p85x4wpPhUHZdY1vq5Grg9DdkkWvyEL2C66SDFqbUo8HlpA?=
 =?us-ascii?Q?W9DfelE6j4oADGla2vJFVHlvG9x5dPceZgvXdZZDn7aJDC3GJuWQBeUdsvhR?=
 =?us-ascii?Q?9gkBeMe/mX7D5KQOBP6iZUgbTBYEzPHzXxcpYHH+z5pZm08Nh9UK9NLVkC/c?=
 =?us-ascii?Q?os+wCHvaX2EmIjaxkaGpJhLZ//Ly2NN3EcHR9eS4yu9aNK707AypghzQHOOS?=
 =?us-ascii?Q?ewQD9cmO3caaYPOa/HREWN35YZ559FFEQXLcAbo0SsbwMFEMB54kb64r02sb?=
 =?us-ascii?Q?uzHYpAWDW+vXQlJ2xtwxK+AJS5lIzrraeaS0Vf3eYXofGW6CUdWvqWhYkVQl?=
 =?us-ascii?Q?VECWNP7MB4qkDb+Al1OfCvHgomG7Q2sZRrOXow5PNnYf9/wHb9D0+v333rh3?=
 =?us-ascii?Q?+6lfpmlaFDg2wsBrrLH+Oa43+ZFhQnBeIeKU5VXi/YiH5j2F8jSgIt5yxzmY?=
 =?us-ascii?Q?jMkIbO5Izgac0BTSSRowVgTN9e0GeD2aD2BMNe06paNN/exXF59sxaccq8lW?=
 =?us-ascii?Q?/aGHicJky9vKRCSSg+n6z13nT1hVG0+K4gKE7BWI7MBnS0zbSo2NvypyJJKP?=
 =?us-ascii?Q?BH5H2QibvRayLQjdgiuuuTzsDyjK47AJHKzuvipipG9HHNUCzq7B3U6mDSDT?=
 =?us-ascii?Q?4i1ARvrEoYgv7JknPYTFJtSmZxLT87oDv8STPp4M9F8sGyhWJJVmvNxSWwQa?=
 =?us-ascii?Q?bKBZ+ZecMuW+k7Bfw3Zq9g2StrzJAPYyjp/edKXJZzroOVvja8gCaEjxYmgk?=
 =?us-ascii?Q?QnyAkKgX/tPjaYQTxSUJfq7O0vSUx6BoiX0F2iuE4W6QtkAzDAL6hZczO2ub?=
 =?us-ascii?Q?7nd7Y33gCJqfkAG9LHBiEZ26/qRzvEedcTTwuioTp9QgE2fL51Mr1qUbPjl7?=
 =?us-ascii?Q?PEOT7NYWE/bzolJp6muB5GnQoFrsSlh+1XLTn4zVzjcrABhO8jWjqcgL8tbT?=
 =?us-ascii?Q?nrtTGrm4gNhcLySkLRyv4+YnUW2L6X2b1HJTEuQL5NFXbNo8ggGRpJfV7nTe?=
 =?us-ascii?Q?a57LsQ42QIfzDzIY74mkPuTRjPUXDidx0WDxtr0ry7hnhbM8aYJ0ltghtmoR?=
 =?us-ascii?Q?MFoqiWHv4iqgMvtr376tan3ArMqEUAiC5/PtTQcb9h1i8o1xpQON6tVJhJYK?=
 =?us-ascii?Q?p6XkOC6Gdr/Q8l3qT+A1NqUu28EIoB4nEcObCyPR2B7e67gnnuJtuYjAWJJ+?=
 =?us-ascii?Q?cQG0eM/9norBz1oVDlQHhU4mhTN9eS8lxnStDsH3YDydXF+nX6/b1NmWnbIn?=
 =?us-ascii?Q?YVA2iqrHbiWec6j1kpIMLc5LAM25qNEMhQQeSF/ljWVjWGaPWDTsIBHzLxh2?=
 =?us-ascii?Q?En5kXz/ajo3jtgflgFqPuizN6WJXVD8=3D?=
X-Exchange-RoutingPolicyChecked: 3LvAGBuxJimT9gM2v7BjQ+6SwGSlaGX1Tlix40lyTm+zqUMANBoNV8uR3PFbqIPiy9kwgaQlPO1sutSqcRLrAqyFji1P6hRovHhRTHq9rdglhtjwRR8lV3vx8eRVUyK22dK5ItrnJRKKlkJ7w6Amm68cP0wWJjLbIxejZOcsy9Q1/uqqQJ+scNMHO+997btzBoOUiG1P9jaqc/xTG1OV+3ppZw0uEAYik6ZhG8y88xXI31Kn8iL0NXFVQ+9VHGz+w28CkrB5NgRJ8ztFScMWqqw6D1IJXGoKhXhoZnlSGxebXZBk82gk1lLgDvVCqD5f2yDav/i7dDSdL8xuTgifWA==
X-MS-Exchange-CrossTenant-Network-Message-Id: 84e3e445-945e-4e7c-d197-08df467725db
X-MS-Exchange-CrossTenant-AuthSource: DS4PPF0BAC23327.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Nov 2026 19:56:06.7626
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 93xyPr+iA6X/yZVsqmKpl2Eb4vhfi1dp5YSRBv3oPSomIRZeWXYJmRgdVTxoQzwXhk3rlcxWenf7I/m6rvLStXX3BgQG0m8FReInw7i69vA=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW3PR11MB4763
X-OriginatorOrg: intel.com

On Wed, Jul 01, 2026 at 05:34:03PM -0700, Alison Schofield wrote:
> The existing CXL unlock test exposed the hexadecimal-vs-decimal key
> description mismatch once cxl_test mock serial numbers were extended
> to 10 and above. Serials with bit 63 set expose a second formatting
> problem in that the kernel formats the decimal serial as signed,
> rendering it as a negative value.
> 
> Extend the existing "unlock dimm" test to repeat the unlock against a
> mock memdev with a full-width serial that has bit 63 set. Refactor the
> common unlock sequence into an unlock_dimm() helper so the signedness
> case follows the same test flow as the original key lookup case.
> 
> Signed-off-by: Alison Schofield <alison.schofield@intel.com>

Applied to pending for NDCTL v86
https://github.com/pmem/ndctl/commits/pending/
