Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AC7FB1BC9FB
	for <nvdimm@lists.linux.dev>; Wed, 22 Jan 2025 21:30:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.18
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737581455; cv=fail; b=uoCtjIi7O3iR6p8KeBNoZAWvq5gdgJKo0gds2DVAMNZM17eZGVUl9LjZJjAu6XvfNwsQBCmRA5cvVI1MaYXU8jhWKFCKD1de74xOGF6WK/34d9MvVIIghZY+lIj0unO7L0vSOvxBLqOemo77Bmdb/dv0PlNOHxdBjzf1SLvhQ14=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737581455; c=relaxed/simple;
	bh=R9ZfFYppvNQUXS6qFcGEs5939Dhp4773lyJRJ7wVz+4=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=ZQO2MJddmyVr2sp0wbpOaHsQDdp9P2mCwazgaL4ed9u1uBBLzUZEiOF+33xKIjdPg1cMmSeDRv+ldHOhXxmy7bPyYUmfdHBpJH3hMWtEEJtmPGekQN1h/UCeNLNYdxRzrDWwF5+UKh+6iANI8ZgA+DClKlvGhweMKXRXruexxLI=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=FcM6ozDx; arc=fail smtp.client-ip=198.175.65.18
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="FcM6ozDx"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1737581454; x=1769117454;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=R9ZfFYppvNQUXS6qFcGEs5939Dhp4773lyJRJ7wVz+4=;
  b=FcM6ozDxwf7k9kEptJVCEKDCFZc4ShZBVSX1a24mLx10l1QQkNFJXL0c
   wVe6cOMAomGCQFhLMPo+iKeh9+LKr76BElIwy8obwSSmJaYFTlNTxCgJw
   T/1gdUb9Q0bd32ZavjJD9MEhXpilGI8DR7LEe5s8zy/gdpHuM1kQm16D+
   NpY8HfiQkyAErZYBNmXzb5czb+RHyE+Gxmg19O5l2bEFPywkDPazufyH+
   o3zr8msDqD0aQEf3RxAus2czUe/yLl/dAA8LB1LLlrLQafyvXxqm7LmaN
   W17HuU48gXP8G0BzPDsEkJuSlUuQi6VnJ8uvKYZatMf/DUVGOXKBgk6mS
   A==;
X-CSE-ConnectionGUID: 3/fHC/SQR32kmPcjOpTJvA==
X-CSE-MsgGUID: EmCXUg+IQAGTzNiZtLZIxQ==
X-IronPort-AV: E=McAfee;i="6700,10204,11314"; a="38165322"
X-IronPort-AV: E=Sophos;i="6.12,310,1728975600"; 
   d="scan'208";a="38165322"
Received: from orviesa009.jf.intel.com ([10.64.159.149])
  by orvoesa110.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Jan 2025 13:30:53 -0800
X-CSE-ConnectionGUID: QFEAAD1eRguPESyOho+8cg==
X-CSE-MsgGUID: 9dSHNqZSQY2gld1+t6bjkw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.13,226,1732608000"; 
   d="scan'208";a="107072701"
Received: from orsmsx601.amr.corp.intel.com ([10.22.229.14])
  by orviesa009.jf.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 22 Jan 2025 13:30:53 -0800
Received: from orsmsx601.amr.corp.intel.com (10.22.229.14) by
 ORSMSX601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.44; Wed, 22 Jan 2025 13:30:50 -0800
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 orsmsx601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.44 via Frontend Transport; Wed, 22 Jan 2025 13:30:50 -0800
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (104.47.66.48) by
 edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.44; Wed, 22 Jan 2025 13:30:48 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Ewl+bcyX8dwsDi7SkYYjJO4i0D8YZ0Avm6dmuK8kKdEfZ7Ao8nuShcaIfk5xNDbD/Nv+eTMI8zhMyibFCaA8ukqOYDX0xnkmbB7bFE7+dZDyxJv1ToZpc/SSRmimjFT62a+USd8G2foZ33+DuJru9GjsQkpcCvSlrO0R6OxTQHb61mKpRMz94bdzvjnlQtNlE9GaGl+taXCTfOAU0CeDHzTD7i+VveQCkwS3pBYXCds7T0bbLux0f/FcZpSyKKulg+GtIJvQG2Z4HYKdt/1RELRj5WU2tReJtAmuAEfeIIIU+eQzVhh20ammZU9/fFwt8WlZNH/TPdYGFUsHaFesrQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=spjkSh54rTlHtNtTTkrUqshd3Ybq8mmf3CxMOjXYyfg=;
 b=CZ6kfuEaffZmhz30O3zArrr3kHssg2vNLuoX14OJ6NDA9JkOFN8lVT2ZqwmO/goA3dvUmmkBxyMqS5Xc8QBV5HL1HA4/AUknrS4Qo1KRWXknPIy5ofCzrCF3P5nw8WGzd93m0tnRBVgoJss3xQKhX8WrASQbXnLi8cs3NrnT+nYcmEaqNw0iD01oJzsvAr+QkLIDlKOXdX+I9RnhzaRE4VJPxx8qYzSi6yKFnfQGtMdVn9OsxXPglgdOxHVsAzfd+WjdVSVqpPonazTZAZ2373B07zOwrF7Wwhm5Zyk2cl7MfWQvfrE56K5eDlfFjxXoAWiGHXcfbJjqCzYuu9AtNw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from SA3PR11MB8118.namprd11.prod.outlook.com (2603:10b6:806:2f1::13)
 by DM4PR11MB5248.namprd11.prod.outlook.com (2603:10b6:5:38b::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8356.21; Wed, 22 Jan
 2025 21:30:47 +0000
Received: from SA3PR11MB8118.namprd11.prod.outlook.com
 ([fe80::c4e2:f07:bdaa:21ec]) by SA3PR11MB8118.namprd11.prod.outlook.com
 ([fe80::c4e2:f07:bdaa:21ec%5]) with mapi id 15.20.8356.017; Wed, 22 Jan 2025
 21:30:46 +0000
Date: Wed, 22 Jan 2025 13:30:43 -0800
From: Dan Williams <dan.j.williams@intel.com>
To: Ira Weiny <ira.weiny@intel.com>, Dan Williams <dan.j.williams@intel.com>,
	Dave Jiang <dave.jiang@intel.com>, Fan Ni <fan.ni@samsung.com>, "Jonathan
 Cameron" <Jonathan.Cameron@huawei.com>, Jonathan Corbet <corbet@lwn.net>,
	Andrew Morton <akpm@linux-foundation.org>, Kees Cook <kees@kernel.org>,
	"Gustavo A. R. Silva" <gustavoars@kernel.org>
CC: Dan Williams <dan.j.williams@intel.com>, Davidlohr Bueso
	<dave@stgolabs.net>, Alison Schofield <alison.schofield@intel.com>, "Vishal
 Verma" <vishal.l.verma@intel.com>, Ira Weiny <ira.weiny@intel.com>,
	<linux-cxl@vger.kernel.org>, <linux-doc@vger.kernel.org>,
	<nvdimm@lists.linux.dev>, <linux-kernel@vger.kernel.org>,
	<linux-hardening@vger.kernel.org>, Li Ming <ming.li@zohomail.com>
Subject: Re: [PATCH v8 02/21] cxl/mem: Read dynamic capacity configuration
 from the device
Message-ID: <6791638393e04_20fa294f1@dwillia2-xfh.jf.intel.com.notmuch>
References: <20241210-dcd-type2-upstream-v8-0-812852504400@intel.com>
 <20241210-dcd-type2-upstream-v8-2-812852504400@intel.com>
 <67871f05cd767_20f32947f@dwillia2-xfh.jf.intel.com.notmuch>
 <67881b606ca4e_1aa45f2948b@iweiny-mobl.notmuch>
 <678837fcc0ed_20f3294fb@dwillia2-xfh.jf.intel.com.notmuch>
 <6791329b4b44c_1eafc294b6@iweiny-mobl.notmuch>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <6791329b4b44c_1eafc294b6@iweiny-mobl.notmuch>
X-ClientProxiedBy: MW4PR03CA0221.namprd03.prod.outlook.com
 (2603:10b6:303:b9::16) To SA3PR11MB8118.namprd11.prod.outlook.com
 (2603:10b6:806:2f1::13)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SA3PR11MB8118:EE_|DM4PR11MB5248:EE_
X-MS-Office365-Filtering-Correlation-Id: d85e23e8-08ea-45c9-6f0d-08dd3b2c089a
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|7416014|376014|1800799024;
X-Microsoft-Antispam-Message-Info: =?us-ascii?Q?4MPJknZgmv0YN0/uOaY8ovJCmlcwCOIM65MR6/E2doNKgk1YaNBpZYLX9pFb?=
 =?us-ascii?Q?qTBVV5sTaKyBYMMWV4gNAwfjltVSavtqk6nbjSUs6rGhGo/doYV22LIkZ+Ww?=
 =?us-ascii?Q?7QPPICwlJ2hPIXUBuF2yYNZQ1gbdw+6V4U+8LQdthqHsWe5EywowM1ZTdSjV?=
 =?us-ascii?Q?FT6MYz4SOwqqJmA2TqoC8f7ZS/hHSCdAcFaIFyN1EIYSJzRlXjnWw8v9XjMu?=
 =?us-ascii?Q?bDVSLDS0j6mum2VPw6z8Zc/ihri7EnyBb5MxYuoWD9thHdOrxcKd+raNXgAC?=
 =?us-ascii?Q?jBSxKNxUtP63Qbs4byIFnK1Dd3Ku2CDRZRJ9b8jM1vYeSRM8pv3+7pNKRWTR?=
 =?us-ascii?Q?0hZ9dklqC+joSyPIVkOAA7hFNXQ8Ml/zEeuPHxRWiBllEI3zOhmfHHNhU+Vn?=
 =?us-ascii?Q?Vue6OL6i0TgM2F/7DVszvmOYMZ0APmO7OkB+svVh9YwAYbpnDilkfoHmQWNP?=
 =?us-ascii?Q?tHqUo8+fGxIlCXdpT0YAKmiGIaZrk+ojIKNhPOi82sdmOUbUZth+1rp5iPvK?=
 =?us-ascii?Q?3gmgUwZvBOT9I9SSQBusnY3FqD1+sJaFcsPuRPHelX14y+xXv7aDOPqssGaa?=
 =?us-ascii?Q?tsSnE6dtakBdMofWf/WpekTFitVWv4EcyJciVunjNudzsgYYpYxaNjEZEFu9?=
 =?us-ascii?Q?gnNzspX7r9S4E7nAxCuz9WnWSCEY9qj920evE/UIqTimqCZVcqKUQCNE/U94?=
 =?us-ascii?Q?yjBHMIcLlMVH+94IwAHa1TxJYba7k2G40G72caxkHHA2YVszcXzs/3S+Lh0q?=
 =?us-ascii?Q?cW8jCNNO4abeugiUhtAHx3VH3FXYGbFBwv8EputuTOLzeEXd0SP4/pitD1kS?=
 =?us-ascii?Q?XuV1vY1fhGlm3vvaiMtyhnK1vtjusmvmVJ9485d+gi5O7plmJ6pyGgioJoUg?=
 =?us-ascii?Q?qQLCqqMogI4O62cqboMG48fOG+Fwkqp59txRlpN406xxFsVfiRNZr3LEPAVW?=
 =?us-ascii?Q?SrcprFJJ1wgGR+G4Vjof5x8maSYZ4WZMFgJ9490A4xXYs/hD4WZWlXm3jIE2?=
 =?us-ascii?Q?mHm/x4UeuPZaVwuTAJZ2yHzdIIm/WUMpZE4jnEMWsW838BhHRnxiAn3OY9nh?=
 =?us-ascii?Q?oq2jC9+WCL1L+uHzIhgKVTqY72JA/fun8iURUvPf1h1deTAXaowVDIGWfPzs?=
 =?us-ascii?Q?wcifOFFBnbI9o4fFMpvYWsldOo8XOJpkRUfaJntuKzd53QN1+zSkJ5slPgP7?=
 =?us-ascii?Q?VL2FK124/twSPgHddUCKRn1ijlt7LDKuAnsPouhjaK4VJwffAxT433KE/fkA?=
 =?us-ascii?Q?ZRWGMAWHsdW+iUToSc7OdIw6EiG1BlGcF4TJMsnSknsiNPl7PNlaDaJKx6wn?=
 =?us-ascii?Q?UvFDBy8L/Qv5RmL0jvtoaPVdwP0bvqsRRLiO3DwGvGA76wYMOuP+WOUIRdw6?=
 =?us-ascii?Q?gMH0BYfiuVwRww/n+AOx7RI51GeK?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA3PR11MB8118.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(7416014)(376014)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?alXofP43Q1sXL7VnevhJ5jwh66VEKiJeCalQeXCR7nCI8SSKpsk/Knkudvph?=
 =?us-ascii?Q?VQKc9YfA6mh18pqFdPsUBjubVo39BAujg5DNbyMB23Wwdf5PhIhdYYQ2fHen?=
 =?us-ascii?Q?BtsZkMWoBvFiCsrhJl3H/Owm0OtS53GNha3mLv/L2nbkmZLc/2eTYf4h5Pcs?=
 =?us-ascii?Q?HptI3k71VrGVp7DuCRF6LRn3xR0rTvPNcNJF6V9OFhLW4N3dY1beeo3TMPW8?=
 =?us-ascii?Q?8vG+dK4MgF9vaEj+QzvabyYEnA8K8v/b4Ew1W/0Aitx2OtcxKK0xS7jDCvy0?=
 =?us-ascii?Q?5sNCUYRijE9R6zn15ieC9kTHEY1OntbVLX2c/+YPkBmOoQ8ZO40bMZ3mcTMJ?=
 =?us-ascii?Q?dt7zdHpuq5/bxBtIuJT/a3Np/vT+wNTLEbrHvzMSXyvmrw+XxAK/X5uj7jW7?=
 =?us-ascii?Q?cdTe7nyEaPH8aT786r3gut8+qyB2Xl4fsaxYMp+aOZ+qzMWiet7P69ytgClk?=
 =?us-ascii?Q?nAiqopL044WcNwNLVE8ca+u4H8fU2qgQcYmU6Unuj2ocm2+FqB7w2jpBWKQX?=
 =?us-ascii?Q?8mm5eu2DAjcCPb/dhclZRNgOUFab4XnRySms+qPROUA004uBW/fYhfypas8C?=
 =?us-ascii?Q?Gq4GZiYSDREGT/qr4U6obYTCAwWOR647NrxwaVZ+KWjMrmFIwL91f5I8MBWe?=
 =?us-ascii?Q?cAZD5HxOUalpZHTjVhlYA4NrXI47wJF5guoNADctevQo737ylO5GJdY3kmdq?=
 =?us-ascii?Q?NaM1ODQnymSfJ3tYyGe0MM7a3SDQWRbbO4eQLiKT97TYDpDyerviCDstVwas?=
 =?us-ascii?Q?/l9FbfP/j3ekjhnDlFr+tut/rxJSG6FYagh3BPLCCdbLUbl2hurLpxLHykAb?=
 =?us-ascii?Q?0DWa3BoNHYaa9md0APqJQgRoDPBBHRVnI75ow4ETodoA9R5dGh0rh84PHcft?=
 =?us-ascii?Q?t7TOKwosubQJMlFaRrF3ceGGLTT5wfaO7JvjwdHl7QFhQ4A9YAuCaP9x9HYM?=
 =?us-ascii?Q?Bi4wYssXM0ULbID5R8rcgRRS32AYB2htfNK3iGYUNsEmEe62+tX9EOvt7t8T?=
 =?us-ascii?Q?OX31Y2Lc5c+qEkVJAwHSbb+qr9dwGD2c/k0nQ6jmjB8E5PX4O5fA/IsmIXOx?=
 =?us-ascii?Q?ZJbGO4J0fpWWYrT4cTS1JHATG2WxvrHTxkcVIgFUlA1uRG4WmIBj+z4qVisy?=
 =?us-ascii?Q?KqoqbXClUsaIl+TGW3YJ8ln0e5COZCRhI+ZlevfcYLuQzAuIUBLky7yeXW5D?=
 =?us-ascii?Q?MFcSOxCjtny6/2l9duC8zXBFfaNMtvE1KDVojuId9fSr3Y9O4nFADneLfNB4?=
 =?us-ascii?Q?aDBnuq7HTvubZ60vL4pijdGrsR2xgkJKc+Dr5TJanVuErLKKDuUOioK6dUr0?=
 =?us-ascii?Q?Mf7p2K8JMUrziPoWJPLhRioqSwMLyRdIZMxkT4Mt55/tExX/gRGGpsRf9AwT?=
 =?us-ascii?Q?hi86jRxP1cFb+IfPzZgPqwLJIAmCYM7rizHZ9YDxJme9VlYxYm94KuI1/6bt?=
 =?us-ascii?Q?FUS5dEKtsb6SROgp1i8b6lBmDCWep9Dtwveev1k4YNDBwjU+AiPNQ3sSSVRT?=
 =?us-ascii?Q?h6f/7XzUuz5CXlwF75Q4LvBBChFtXDAw3Gx8HoTM7DbNsdKasX7k46UkVAe+?=
 =?us-ascii?Q?jysijOBg/zJ1SA/3UK897Gaq9Q9OdCaEg5rSiuYH1Y7gWe2qnZahTBAhmquV?=
 =?us-ascii?Q?6Q=3D=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: d85e23e8-08ea-45c9-6f0d-08dd3b2c089a
X-MS-Exchange-CrossTenant-AuthSource: SA3PR11MB8118.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Jan 2025 21:30:46.8291
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: IydjCeW+ziBqXm7OIkol4XFbqK1KhPpY0gYS0Xx/NC6UEjI+OqgwOkeShAagoC+uG1X5nwm842PJhvrU2z6IvNcz8/I5utsszxJXZ31BP5U=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR11MB5248
X-OriginatorOrg: intel.com

Ira Weiny wrote:
[..]
> > The distinction is "can this DPA capacity be allocated to a region" the
> > new holes introduced by DCD are cases where the partition size is
> > greater than the allocatable size. Contrast to ram and pmem the
> > allocatable size is always identical to the partition size.
> 
> I still don't quite get what you are saying.  The user can always allocate
> a region of the full DCD partition size.  It is just that the memory

Quick note: "region of the full DCD partition size" means something to
me immediately where "region of full DC region size" would tempt a
clarifying question.

> within that region may not be backed yet (no extents).

A partition is a boundary between DPA capacity ranges of different
operation modes / performance characteristics. A region is constructed
of decoders that reference decode length. The usable capacity of that
decode range, even when fully populated with extents, may be less than
the decode range of the decoder / partition. That is similar in concept
to the low-memory-hole where the decoders map more in their range than
the usable capacity seen by the region.

[..]
> > > > Linux is not obligated to follow the questionable naming decisions of
> > > > specifications.
> > > 
> > > We are not.  But as Alejandro says it can be confusing if we don't make
> > > some association to the spec.
> > > 
> > > What do you think about the HW/SW line I propose above?
> > 
> > Rename to cxl_dc_partition_info and drop the region_ prefixes, sure.
> > 
> > Otherwise, for this init-time only concern I would much rather deal with
> > the confusion of:
> > 
> > "why does Linux call this partition when the spec calls it region?":
> 
> But this is not the question I will get.  The question will be.
> 
> "Where is DCD region processed in the code?  I grepped for region and
> found nothing."

Make grep find that definition:

$ git grep -n -C2 -i "dc region"
Documentation/driver-api/cxl/memory-devices.rst-387-
Documentation/driver-api/cxl/memory-devices.rst-388-partition: a span of DPA capacity delineated by "Get Partition Info", or
Documentation/driver-api/cxl/memory-devices.rst:389:"Get Dynamic Capacity Configuration". A "DC Region" is equivalent to a

> Or
> 
> "I'm searching the spec PDF for DCD partition and can't find that.  Where
> is DCD partition specified?"

If they are coming from the code first that's why we have spec reference
comments in the code.
