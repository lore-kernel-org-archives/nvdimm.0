Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=198.175.65.12
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1795548672;
	b=GGMQXmoiflhrscyeCm4ozKWsKfRYbRTexZZXgqf4PK+W+Lujy2s+bfohq9LPfvYCbUiI
	 c1ScMK72XJymOTr/KGLEprOimrNvcSZ/MyMN+/2NlnMlNXX8niHvitinBcuVKnVbMplnA
	 Mfzdzu2HqwAwLWw/C5Cvcj/pK8dhpnnE+NuwAiDOs30xkgzyzQoSa4rS/Pk1vRFK74TBM
	 953QkS9dVE9OWZ/Pmhl953PjDl+/sHdBQJxKIqdig7+sjsq+Da1g3okyo4XvnujKvwUSh
	 w1fQNBPJxwzvE4n7BXHR5Y7BAPUFGrQ6qP17TS42/CnaDk6CDWl2r6ovYoi+wLXEzSg==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795548672;
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
	bh=cHrjRYdZiS1oeaYurXSqOa64wD0VpLC26EH+ABbq6p4=;
	b=vG96rLbw5+0kmuAeVj+sq5a9jOd72qA4fkC2XjZLzCWZZebMwUpHEHW23eay/le9GchF
	 NFCfSXRvRXG+dCht1IG8smVLU8raaROHOPJRlM9vnO51mi+2q48R/5Jei76KeNyJ0Xcj8
	 LmLh4GDj/shxFX0fC2xLH4x+xaw+w45ALNxGuvMLcj7eSjZXqSR4BgsRTyJDQ0dK0dSqg
	 BZ8hvhM3yF66b5xghlcbqY7eMcTtuJatzL36SlQGHLWQ9cvpFnoIp36J+See0wZqCb7Xt
	 lz2Wykbt0GXWrc844nmm4b9d1avprnCw0f6ggqtb3X/AqeCC23GEQ4OWgt95oXmd0ow==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=intel.com;
	spf=pass smtp.mailfrom=intel.com;
	dkim=pass header.d=intel.com header.i=@intel.com header.a=rsa-sha256 header.s=Intel header.b=OQKhm4Vn;
	dkim=pass header.d=intel.com header.i=@intel.com header.a=rsa-sha256 header.s=selector1 header.b="M5UZ/K3t";
	arc=pass header.oldest-pass=0 smtp.remote-ip=198.175.65.12
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.12])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8B2AF606A321
	for <nvdimm@lists.linux.dev>; Tue, 24 Nov 2026 19:31:11 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 8B2AF606A321
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.a=rsa-sha256 header.s=Intel header.b=OQKhm4Vn;
	dkim=pass (1024-bit key, unprotected) header.d=intel.com header.i=@intel.com header.a=rsa-sha256 header.s=selector1 header.b=M5UZ/K3t
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1795548672; x=1827084672;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=Oq+G63g9gx7cIkx4u2hHFEJ3HEndkb3tP/kvkViC+GI=;
  b=OQKhm4Vnsf7eEFUfrhSNI/bDM6DMdj6FyFi1tAAo6GYavP+GP0WKm9Po
   ZRT/+VckwNfGhxcoNqWRvQtrM7Kkft4Z/vs7yBBcdzFS5y+RJqVutIEvZ
   Qf70BZq+L6coopYshTxJgs7U21az5BaBMByFq07qjLVSgBP1+gZuVb/gC
   Pn4t3Y4I1LJzaB2y56iQPqH273aug5gQ64FuNVLtbTtdg847sd9DdWYYx
   lF1w1XSiXnre9XWtpFu1GMAtciwfn+D2I9DJ5DUdJi0S3/MKn0ZckyHcd
   Q58s606kfFaP9ZM9r9MvEz2AEITrZ+44DSMqiMOWprq9nDPhBL6ELYalh
   w==;
X-CSE-ConnectionGUID: zee1DeybQ8Se3HhKR5/EWQ==
X-CSE-MsgGUID: 2om30h8QT42Gnmw/tjgiow==
X-IronPort-AV: E=McAfee;i="6800,10657,11976"; a="4304636"
X-IronPort-AV: E=Sophos;i="6.27,231,1787036400"; 
   d="scan'208";a="4304636"
Received: from orviesa007.jf.intel.com ([10.64.159.147])
  by orvoesa104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Nov 2026 11:31:11 -0800
X-CSE-ConnectionGUID: bFV+KjOvS2u/A2k4b17VRA==
X-CSE-MsgGUID: 4g4YiW37RuiKcahjkpO8GQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.27,231,1787036400"; 
   d="scan'208";a="11638305"
Received: from orsmsx902.amr.corp.intel.com ([10.22.229.24])
  by orviesa007.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Nov 2026 11:31:11 -0800
Received: from ORSMSX901.amr.corp.intel.com (10.22.229.23) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.57; Tue, 24 Nov 2026 11:31:10 -0800
Received: from ORSEDG903.ED.cps.intel.com (10.7.248.13) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.57 via Frontend Transport; Tue, 24 Nov 2026 11:31:10 -0800
Received: from CH1PR05CU001.outbound.protection.outlook.com (52.101.193.15) by
 edgegateway.intel.com (134.134.137.113) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.57; Tue, 24 Nov 2026 11:31:10 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=OYHaUB9zKU4Czbw6Onuif/cbtYi+ViO7dsXqH8yj+j9HYGLPXMbpDb2mEtwZ0sxvkEwHKAjakgJNKk8Y08gDzz6zASVsKfqQQF1ONVddiOfgQVVexLKA4KnC/vgzU6jC8e6M1YBfwecjSTGFWnpHDNd1RdaZUUzIBHYwTnhobH0hDMTuOTWLTsQC/7WFZjCeYkFe57ExCnRmhk3M67XW8KGENv7l003iXkyhSVMPdI7YUZfZGk37/wT79EGk+PQBsyFLQwigWIevd0WEZ0hLvPMFgBqdWUCNOiS+r/FCmQYdApei/itBQBcQ2+jmB1vilWnaxci9t1hi4lyqbIQMMA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=cHrjRYdZiS1oeaYurXSqOa64wD0VpLC26EH+ABbq6p4=;
 b=v4CC/YO79xf9eguPAWR+uLPAiwsMGdCTlyMJfI42a1TZLVpV15hdtg2j/3F+I7zpGyST8Ps58j+MSauZfCvbP967fNqq/uUVCltM+9DCcoDuUfTstlvwN2mBZhKaacMGlgCVLsqxgNHiBV8ph/WqKBNRAaXqP86ueYGJ8jtwtSxlupUt7lrNrhRK0nDf3oMJVMEFFwahzYxqC4XCKDb8mKEZJ0wYF0KLk15NyNsPM/j3Xp+Dzc+NEkc91hXlSP9erWeVa6zh8pWFPy/xUd7ZfWvXEFV0XYY9rkqNrAwNGMVIcW3zsWVdkRnY+1vdBT1JwXZIeml7i52jDbB6/QkyCw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=intel.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=cHrjRYdZiS1oeaYurXSqOa64wD0VpLC26EH+ABbq6p4=;
 b=M5UZ/K3tT2oiDo/IY6gtXNpmP4uBIoqpeFje1XL3L+7qmurjUmX7XuFavUnRJ5FZIvoCx8BHu+UgTtcdYFh5HV5MToiQ0n4io4bLdAi8OTIswfpsWkpKIO8dQBAS0QUvfu2mtdyr7vaq9qkzMWqHU+yV+VaHTOfN/XVwTOrvlzs=
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DS4PPF0BAC23327.namprd11.prod.outlook.com (2603:10b6:f:fc02::9)
 by DS0PR11MB8205.namprd11.prod.outlook.com (2603:10b6:8:162::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.639.12; Tue, 24 Nov
 2026 19:30:42 +0000
Received: from DS4PPF0BAC23327.namprd11.prod.outlook.com
 ([fe80::a1fc:97e0:329a:4aa7]) by DS4PPF0BAC23327.namprd11.prod.outlook.com
 ([fe80::a1fc:97e0:329a:4aa7%6]) with mapi id 15.21.0662.001; Tue, 24 Nov 2026
 19:30:42 +0000
Date: Tue, 24 Nov 2026 11:30:38 -0800
From: Alison Schofield <alison.schofield@intel.com>
To: Anisa Su <anisa.su887@gmail.com>
CC: <linux-cxl@vger.kernel.org>, <nvdimm@lists.linux.dev>,
	<linux-kernel@vger.kernel.org>, Dave Jiang <dave.jiang@intel.com>, "Jonathan
 Cameron" <jic23@kernel.org>, Davidlohr Bueso <dave@stgolabs.net>, Ira Weiny
	<iweiny@kernel.org>, Vishal Verma <vishal.l.verma@intel.com>, Fan Ni
	<nifan.cxl@gmail.com>, Li Ming <ming.li@zohomail.com>, Benjamin Cheatham
	<benjamin.cheatham@amd.com>, Gregory Price <gourry@gourry.net>, Richard Cheng
	<icheng@nvidia.com>, Anisa Su <anisa.su@samsung.com>
Subject: Re: [PATCH v1 05/14] cxl/mem: Add 20 second timeout for stalled DC
 event chains
Message-ID: <awXl3lrb-Rd1Fofb@aschofie-mobl2.lan>
References: <20261104230445.66625-1-anisa.su@samsung.com>
 <20261104230445.66625-6-anisa.su@samsung.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261104230445.66625-6-anisa.su@samsung.com>
X-ClientProxiedBy: MW4PR03CA0144.namprd03.prod.outlook.com
 (2603:10b6:303:8c::29) To DS4PPF0BAC23327.namprd11.prod.outlook.com
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
X-MS-TrafficTypeDiagnostic: DS4PPF0BAC23327:EE_|DS0PR11MB8205:EE_
X-MS-Office365-Filtering-Correlation-Id: 7c0ed4a8-6c5d-4eb5-da31-08df4a616da6
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|7416014|366016|376014|23010399003|261028144727099003|10067099003|261009220027099003|11063799006|4143699003|5023799004|56012099006|261009223027099003|261021123027099003|261021121427099003|261009221227099003|261009221727099003|261009223327099003|261102123227099003|261026121527099003|261026140227099003|261022105027099003|22082099003|18002099003|3023799007;
X-Microsoft-Antispam-Message-Info: b7pL+whnDaROdyqzOmMP8ZW0Hi/aOnVJuiQw9/lBUtfgLrgd3v+RH667Nv0XKbsFy73ybQN3hUb8v7KPJXXppsVXU5Q99z5oyE6TuSrxZR0Gl6ugLcfuExDO32qNZXw0RxBRvem37FJqbvrVzitzPyhKwWmvZqW2JP7wLWkJ3m6q5vjsgSHK2a1m29v+SFBPkXXnZAeJFM2LljyephCS8Vb5xz90uWifOXwRUPWG1vhKTF60s3laHEvJUpMyEuEA3n7yceF6omOWQuxE+xzu353B/lBnp3mm4p7sqXXaebUF45hEn/eQDWCYF+Wy7HwTZKv4v/vDdyFolnRE58sbd5c0MjlUSOLY3P2nOC5r7E03qg3Pr8s1jejkbpObU9pd5Q8XVE6y7NXXXAwAOwzwIYgqF/oaJzubhIVL7ddTf0xeG73HHC1GALP15IElaIn+Z3N0TzolpKxtc4UF1gCjbkulKZsp55brF9qKXiHK6VW1S4/mD3eI9o0b7PuJg0N5biFbGSPaQvUVs6ojGwmlwSHg3kcx+cJuALGrxiJ+GcwEw9k97aiRpEhBNs+ivxGUWsqDzxL6swLoOq0auAw1jqdU6u+GydYiybJ3YGxYjJTyGv9fxjQToAffIJth2RQS9bfE5mUnGnECUzovJI7KsPghqvPXyewRI+Nhypxjsxs=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS4PPF0BAC23327.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(7416014)(366016)(376014)(23010399003)(261028144727099003)(10067099003)(261009220027099003)(11063799006)(4143699003)(5023799004)(56012099006)(261009223027099003)(261021123027099003)(261021121427099003)(261009221227099003)(261009221727099003)(261009223327099003)(261102123227099003)(261026121527099003)(261026140227099003)(261022105027099003)(22082099003)(18002099003)(3023799007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?BtuTVllLsQy67HQ87lLarJjRTIKIE2vEPFlWVldyZTear61KUBApNgqVAz9r?=
 =?us-ascii?Q?PJATtYI7A04UfLsXhKns3Gi/w7vbV1rYhWGwQ3VN2XGiHKvBfCHpbGopDTLv?=
 =?us-ascii?Q?N6OCJnVa3U4zOqLLQOZqnfQmQ40lZpPMUpxqIYyv26IyIIUUNusHJxF1ZO6g?=
 =?us-ascii?Q?t+fLeDsFZ11N1yVrrV8/BOVzgH+wt+096iDg227vcq2feNlsnu6rLPXk5jt1?=
 =?us-ascii?Q?If3LuqAuICFOGcrwKx9YiY+jCkAnpiBwgg7UjlzAlvBXSMHVxtnNAgXU9RzS?=
 =?us-ascii?Q?7P/spduE9nGaea95Q36DBNjtX2SJOqY1/Q207m1z8STilJkPp1ZytmVKTOzB?=
 =?us-ascii?Q?DqUWQCrq0ljnrULiC0mVNt8xysxjoOseH1W4pfHH9aHJqaBJM1+NVAa4XIUB?=
 =?us-ascii?Q?wHNsig1oG+Hx9cnAuo97JFdpydPbr0SlwOpNcKPvYDlamrtdoP7afrk3TFAm?=
 =?us-ascii?Q?TvfmpixERsuAp1Nd5Oef5BaEcLG2VTkeP45kSCy2e+lPg6t5jp2dPtYhsnCK?=
 =?us-ascii?Q?GNA3UpxMZS639c0oFnRfv5q8p8n+sv/aPmhimgLBWWU/YnEaqFxfXX8FNYzj?=
 =?us-ascii?Q?mUMVvChLJ6++Ot+oyGVDaVSV9IkiABhShWp6yq3hUwyGNZURZFYj4axcTGq3?=
 =?us-ascii?Q?QsTlx8sNIfRxajnyL2CGDFynNIM/ipTIflC2JnKMXqZBHnb1+26BhAaOftg2?=
 =?us-ascii?Q?SmSVX24xprIDyl1HsqfBRzhaNtSENfIVt1K+SWyXPedHZXHpWWYyeAcmV6n8?=
 =?us-ascii?Q?zXv6DKXTSxwVgyLXbijnwSyTybZNocX/b8yRTU9CbSCeIQbvQXmCKJ6k2pig?=
 =?us-ascii?Q?d9M4MnTNUUIWzVYJFEjbrzi95PwC3F4uLmSvKfoxeLyVy8nmMfFHUIBFn+io?=
 =?us-ascii?Q?O6vsULXlN4Owse7fJA9nDwwANM2dt+QOOKheIfv+3B2upAwknI3Ly1iMrK0a?=
 =?us-ascii?Q?rIVoRzZjlCJbzcNWoygUVX9TM3ZgP6DmUhjsTdHeWjJIlsgGIGNzimvQ++A5?=
 =?us-ascii?Q?n/tHqHX/golQ53GKRljLxVSzjgv056XwUQAvHra7pE5w++tRU8M1BqQeHOJA?=
 =?us-ascii?Q?AmJdxnSEW1VR1iGtHfNLBsd2RjL8n2ixPWxqv6vA2u26SQ2r7Ir2Ps9sijAY?=
 =?us-ascii?Q?ETl3UC/r3lMlx2zUhGU/Z1WXf+4byf8NzruHodxAxc03yi9Pf2dm7PnNYr4l?=
 =?us-ascii?Q?jmiu4pdwtrMvGyVRjLnjpzEhgVsP34fXAPVTsEpxChWNd5MKyG+Ga4t8ioJZ?=
 =?us-ascii?Q?bPuWikkYhP5rVxRvu4myQt5bwYuhraQ3xZKL6pQtHa8U0XP8UmMi2eSRugnZ?=
 =?us-ascii?Q?Wdc7iB3zzkHqbw6uJZ7qCLZm5zrwzT/kVeMGBPRqNAY9VbQYcEFKVnLFM0lM?=
 =?us-ascii?Q?up1nFCDCUfVldV5MvyCTll3P1QqLKA21IvJvU4K5stO71yWwTGdjBNB1P29D?=
 =?us-ascii?Q?UZiKXEO5KZDmPKfxxz5r5RODJbCWLC2rgahxEsZE0VQR/p99E6u03dvmZSPi?=
 =?us-ascii?Q?IhxyA76YSEX6o5xYig8k5pJvGISt22ICpVeFVFndGDF3j3RsnmpjJOYe/0Fd?=
 =?us-ascii?Q?Q86y5zt66/L66etXtSeBcWQX20m5+cFwY5U+k0+mk2YZ4m3nA3cl882SrSKA?=
 =?us-ascii?Q?jQN9Mzxq99H/ly+0e7jQ580mr58i+C+wAG3AyVEXsZKGpSGmTp4LntGjfTsK?=
 =?us-ascii?Q?4D3mDCuq4ZmyBqnp+oyvFjLQAo9li/54qTW/YCUm/YJE9bHHSifPfCL4j9If?=
 =?us-ascii?Q?q0/2q5D1KDecSiNg90OttVCDfYEmz5I=3D?=
X-Exchange-RoutingPolicyChecked: d2SFgwwsklVW70BnExcvZ3OXHnmVqbO9TwECVVgUzl2wuGdXE6HiCie902Uqhx/HBZSPMgrptQJb4e1/Oi7PU4qrq/AasNKDj2500A0pGm82XjqiGIcKnMy7X9ocCl3wEZssudGE16726gIqfz9SOp+qrrC0D3kYgVD5EzEw4jZtDoLGa4wGiEXFRfmbP/Lrl/Cj+MslwmjDgSFSJVGfB0nw6zTLGNgvsMYOKaQs1Vpw8Tupa5VA7+Vibpz2kKW6fr1KpTAsbtW+Itf00Jo2XT2zhrsDaOXgSCcnMJkmZsGD3HbyzNiwBLaAFRKX/81T/B0Oyw+xFm4aqKnyAaFDpQ==
X-MS-Exchange-CrossTenant-Network-Message-Id: 7c0ed4a8-6c5d-4eb5-da31-08df4a616da6
X-MS-Exchange-CrossTenant-AuthSource: DS4PPF0BAC23327.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Nov 2026 19:30:42.3763
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: lgIz7+9bLCbI1s8xJMxqLmx+hJ4QxbYFPJheHnOM/FE2n55VnIdcaDWg8Tv5YrS50/C3hM/9bYvktmY8T3qYCD6alHKgjSyH9n9b6aNJiYY=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR11MB8205
X-OriginatorOrg: intel.com

On Thu, Nov 05, 2026 at 08:02:29AM +0900, Anisa Su wrote:

Not reviewing this one since it looks like it will be dropped.
-- Alison

> A Dynamic Capacity event can span multiple event records grouped
> together by the CXL_DCD_EVENT_MORE flag. Extents are staged in the
> pending list until the last event record ('More'=0) is received, at
> which point the chain is processed. If the device opens such a chain
> (More=1) but never sends the closing record, the staged list sits
> indefinitely.
> 
> Add a delayed-work watchdog that drops the chain on timeout: an add
> chain is refused with an empty Add Dynamic Capacity Response (4802h),
> a release chain is left for the device to retry.
> 
> The spec sets no limit; 20s is a generous upper bound that may be
> tightened later, and guards against a lost mailbox response or a
> crashed fabric manager.
> 
> The deadline is fixed when the chain opens rather than extended per
> record, so a device cannot keep a chain alive, and the staged list
> growing, by streaming More=1 records.
> 
> Signed-off-by: Anisa Su <anisa.su@samsung.com>
> Tested-by: Wonjae Lee <wj28.lee@samsung.com>
> Tested-by: Junhee Park <jh9934.park@samsung.com>
> Tested-by: Heesoo Kim <habil.kim@samsung.com>
> ---
>  drivers/cxl/core/mbox.c | 84 +++++++++++++++++++++++++++++++++++++++++
>  drivers/cxl/cxlmem.h    | 15 ++++++++
>  2 files changed, 99 insertions(+)
> 
> diff --git a/drivers/cxl/core/mbox.c b/drivers/cxl/core/mbox.c
> index 3acf5ace48db..fea910e6c510 100644
> --- a/drivers/cxl/core/mbox.c
> +++ b/drivers/cxl/core/mbox.c
> @@ -873,6 +873,8 @@ static const uuid_t log_uuid[] = {
>  	[VENDOR_DEBUG_UUID] = DEFINE_CXL_VENDOR_DEBUG_UUID,
>  };
>  
> +static void cxl_cancel_dcd_chain_work(void *_mds);
> +
>  /**
>   * cxl_enumerate_cmds() - Enumerate commands for a device.
>   * @mds: The driver data for the operation
> @@ -891,6 +893,16 @@ int cxl_enumerate_cmds(struct cxl_memdev_state *mds)
>  	struct cxl_mem_command *cmd;
>  	int i, rc;
>  
> +	/*
> +	 * The DC chain watchdog sends a mailbox command when it fires.  Register
> +	 * its cancellation here, once the mailbox is usable, so devm runs it
> +	 * before the mailbox goes away: in cxl_pci the device registers were
> +	 * mapped before this point and are unmapped after the cancel.
> +	 */
> +	rc = devm_add_action_or_reset(dev, cxl_cancel_dcd_chain_work, mds);
> +	if (rc)
> +		return rc;
> +
>  	gsl = cxl_get_gsl(mds);
>  	if (IS_ERR(gsl))
>  		return PTR_ERR(gsl);
> @@ -1198,6 +1210,14 @@ static void clear_pending_extents(void *_mds)
>  		delete_extent_node(pos);
>  }
>  
> +/*
> + * Bound on how long the host will wait for a device to finish a
> + * multi-record DC event chain (More=1 ... More=0) before refusing the
> + * chain.  The spec sets no limit; 20s is a generous upper bound, the
> + * maximum GPF timeout.
> + */
> +#define CXL_DC_CHAIN_TIMEOUT	(20 * HZ)
> +
>  static const char *cxl_dcd_evt_type_str(u8 type)
>  {
>  	switch (type) {
> @@ -1226,6 +1246,11 @@ static void cxl_dc_chain_abort(struct cxl_memdev_state *mds)
>  	struct cxl_dc_event_chain *chain = &mds->dc_chain;
>  	struct device *dev = mds->cxlds.dev;
>  
> +	lockdep_assert_held(&chain->lock);
> +
> +	chain->armed = false;
> +	cancel_delayed_work(&chain->timeout_work);
> +
>  	if (chain->event_type == DCD_ADD_CAPACITY &&
>  	    cxl_send_dc_response(mds, CXL_MBOX_OP_ADD_DC_RESPONSE,
>  				 &chain->pending_extents, 0))
> @@ -1234,6 +1259,43 @@ static void cxl_dc_chain_abort(struct cxl_memdev_state *mds)
>  	clear_pending_extents(mds);
>  }
>  
> +static void cxl_dc_chain_timeout(struct work_struct *work)
> +{
> +	struct cxl_dc_event_chain *chain = container_of(to_delayed_work(work),
> +							struct cxl_dc_event_chain,
> +							timeout_work);
> +	struct cxl_memdev_state *mds = container_of(chain,
> +						    struct cxl_memdev_state,
> +						    dc_chain);
> +	struct device *dev = mds->cxlds.dev;
> +
> +	guard(mutex)(&chain->lock);
> +
> +	/*
> +	 * handle_dcd_chain_event() cancels this work non-synchronously (a sync
> +	 * cancel would deadlock on @chain->lock, which the chain-close path
> +	 * holds), so a callback that already started running can reach here
> +	 * after its chain has moved on.  Abort only if a chain is still armed
> +	 * AND the timer has not been re-armed since this expiry fired: a new
> +	 * chain's queue_delayed_work() makes delayed_work_pending() true,
> +	 * meaning this expiry belongs to a superseded deadline and must not
> +	 * abort the current chain.
> +	 */
> +	if (!chain->armed || delayed_work_pending(&chain->timeout_work))
> +		return;
> +
> +	dev_warn(dev, "DC %s chain timed out\n",
> +		 cxl_dcd_evt_type_str(chain->event_type));
> +	cxl_dc_chain_abort(mds);
> +}
> +
> +static void cxl_cancel_dcd_chain_work(void *_mds)
> +{
> +	struct cxl_memdev_state *mds = _mds;
> +
> +	cancel_delayed_work_sync(&mds->dc_chain.timeout_work);
> +}
> +
>  static int stage_pending_extent(struct list_head *pending,
>  				struct cxl_extent *to_add)
>  {
> @@ -1260,6 +1322,8 @@ static int handle_dcd_chain_event(struct cxl_memdev_state *mds,
>  	struct device *dev = mds->cxlds.dev;
>  	int rc;
>  
> +	guard(mutex)(&chain->lock);
> +
>  	/* Chained records share one event type (CXL r4.0 Table 8-229) */
>  	if (list_empty(&chain->pending_extents)) {
>  		chain->event_type = event->event_type;
> @@ -1279,9 +1343,22 @@ static int handle_dcd_chain_event(struct cxl_memdev_state *mds,
>  
>  	if (event->flags & CXL_DCD_EVENT_MORE) {
>  		dev_dbg(dev, "more bit set; delay processing of extent\n");
> +		/* The deadline is fixed when the chain opens, not per record */
> +		if (!chain->armed) {
> +			queue_delayed_work(system_wq, &chain->timeout_work,
> +					   CXL_DC_CHAIN_TIMEOUT);
> +			chain->armed = true;
> +		}
>  		return 0;
>  	}
>  
> +	/*
> +	 * Chain is closing.  Disarm before flushing so a pending watchdog
> +	 * (queued but blocked on @chain->lock) sees !armed and bails out.
> +	 */
> +	chain->armed = false;
> +	cancel_delayed_work(&chain->timeout_work);
> +
>  	/* Nothing is tracked yet: refuse every add, acknowledge every release */
>  	if (event->event_type == DCD_ADD_CAPACITY)
>  		rc = cxl_send_dc_response(mds, CXL_MBOX_OP_ADD_DC_RESPONSE,
> @@ -2021,7 +2098,14 @@ struct cxl_memdev_state *cxl_memdev_state_create(struct device *dev, u64 serial,
>  
>  	mutex_init(&mds->event.log_lock);
>  	INIT_LIST_HEAD(&mds->dc_chain.pending_extents);
> +	mutex_init(&mds->dc_chain.lock);
> +	INIT_DELAYED_WORK(&mds->dc_chain.timeout_work, cxl_dc_chain_timeout);
>  
> +	/*
> +	 * The watchdog cancel is registered later, by cxl_enumerate_cmds(), so
> +	 * devm's reverse-order unwind cancels (and waits for) the watchdog
> +	 * before this list cleanup runs.
> +	 */
>  	rc = devm_add_action_or_reset(dev, clear_pending_extents, mds);
>  	if (rc)
>  		return ERR_PTR(rc);
> diff --git a/drivers/cxl/cxlmem.h b/drivers/cxl/cxlmem.h
> index c88de7cb65d1..52c936ec15a9 100644
> --- a/drivers/cxl/cxlmem.h
> +++ b/drivers/cxl/cxlmem.h
> @@ -8,6 +8,8 @@
>  #include <linux/uuid.h>
>  #include <linux/node.h>
>  #include <linux/list.h>
> +#include <linux/mutex.h>
> +#include <linux/workqueue.h>
>  #include <cxl/event.h>
>  #include <cxl/mailbox.h>
>  #include "cxl.h"
> @@ -431,6 +433,11 @@ static inline struct cxl_dev_state *mbox_to_cxlds(struct cxl_mailbox *cxl_mbox)
>   * struct cxl_dc_event_chain - staged Dynamic Capacity event chain
>   * @pending_extents: extents received so far; flushed when the chain
>   *		     closes (More=0)
> + * @timeout_work: watchdog that fires if a chain is opened with
> + *		  CXL_DCD_EVENT_MORE but the closing record never arrives
> + * @lock: serialises updates to the chain state against the watchdog
> + * @armed: set when a More=1 chain opens; cleared when the chain closes
> + *	   (More=0), is aborted by cxl_dc_chain_abort(), or times out.
>   * @event_type: DCD event type of the open chain (add or release)
>   *
>   * The records of one Dynamic Capacity operation can be chained by the
> @@ -439,9 +446,17 @@ static inline struct cxl_dev_state *mbox_to_cxlds(struct cxl_mailbox *cxl_mbox)
>   * chain is open at a time.  Both Add Capacity and Release Capacity chains
>   * are staged here, @event_type says which.  Records are staged until
>   * More=0, then the chain is processed and responded to as a whole.
> + *
> + * If a chain is opened (More=1) but the device never sends the closing
> + * record, the staged list would otherwise sit indefinitely.  @timeout_work
> + * is a defensive watchdog that drops such a chain: an add is refused with
> + * an empty response, a release is held for the device to retry.
>   */
>  struct cxl_dc_event_chain {
>  	struct list_head pending_extents;
> +	struct delayed_work timeout_work;
> +	struct mutex lock;	/* chain state, against the watchdog */
> +	bool armed;
>  	u8 event_type;
>  };
>  
> -- 
> 2.43.0
> 
