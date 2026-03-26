Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EC3912DF707
	for <nvdimm@lists.linux.dev>; Thu, 26 Mar 2026 22:42:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.11
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774564975; cv=fail; b=jlvmXP+aeSO2qyGdLywzq5fM439J+1aPvNCvwaz3eregG+9uIZ1BDMyBN7oEHWlh41RaMX1Rk2dF0S7CQwQvk8Egqy6T7khC09v0jjGm8CBLDXuIL8prGEqQz9lGBuHlXQNwWZauXwsZ2jvNRdxrrffFGdtsiejYC41o8xmp1H4=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774564975; c=relaxed/simple;
	bh=QV6fvvlcxNxVo4wlVjzu3BQt24SPuQT5pshhIcum3DU=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=EoWaAjrj7Yi54sKxV9Op6CH9wGkKHgbMDrbQW7f55+ewefzDEyVEmuImOUt/HBGZiAb7s5NGb6bSd8pkTFxhaXcBgp5iXD2IIYQ1xlikBV9N7aQwbfKH8UiI47ANvrXNqr/BAxYxIOarjZ9Zt0QID8v4v5i4aiTMPDLGiaN7P90=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=e9wJF7IL; arc=fail smtp.client-ip=192.198.163.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="e9wJF7IL"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1774564974; x=1806100974;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=QV6fvvlcxNxVo4wlVjzu3BQt24SPuQT5pshhIcum3DU=;
  b=e9wJF7ILlSW153kWxLqQNsTjhfAvT2/fsoYyiDuuET35BZj7FmGJ4peP
   emOv3FfePd2dfH/cSsXyZdwjpUCzd7x3OXS+685SsvKTvwyilwYlDN0tg
   WNjYOh9/7tgy05Pd0/Ed3X07qIXUMKRtx1du6YyeU4X+OTNnT2HFkoiWd
   6ervjtfsyqZ/f0jDbeGWVX3yY5z7uo7AE/jgLuxOwqRZoWTMun4O7FEJb
   1YUAwN4RJet5959hGU7BNU1GyBgEj/uBBWrCJ5BGzWiPV9qaOaNywzcFg
   Kb6kEvQoTXQnjihaQao8kxecDwZQTaTb74/CJTvtxHA2bp18NOrInhRL0
   g==;
X-CSE-ConnectionGUID: nNFUZQXlTPq1ZOLNF5gKFw==
X-CSE-MsgGUID: lh89KN5bTdaXb3PbWM+R7g==
X-IronPort-AV: E=McAfee;i="6800,10657,11741"; a="86258181"
X-IronPort-AV: E=Sophos;i="6.23,143,1770624000"; 
   d="scan'208";a="86258181"
Received: from orviesa002.jf.intel.com ([10.64.159.142])
  by fmvoesa105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Mar 2026 15:42:47 -0700
X-CSE-ConnectionGUID: 3USkW1mqSVSNMQ2bmXPG3Q==
X-CSE-MsgGUID: fusTJb0HShWSg7PpO9sFMw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.23,143,1770624000"; 
   d="scan'208";a="255633625"
Received: from orsmsx903.amr.corp.intel.com ([10.22.229.25])
  by orviesa002.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Mar 2026 15:42:46 -0700
Received: from ORSMSX902.amr.corp.intel.com (10.22.229.24) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37; Thu, 26 Mar 2026 15:42:46 -0700
Received: from ORSEDG903.ED.cps.intel.com (10.7.248.13) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37 via Frontend Transport; Thu, 26 Mar 2026 15:42:46 -0700
Received: from CH4PR04CU002.outbound.protection.outlook.com (40.107.201.63) by
 edgegateway.intel.com (134.134.137.113) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37; Thu, 26 Mar 2026 15:42:45 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=obq/SDfpyyiFzi+8W9xK3oj5l0WIXDsgb+DtQCZBN7xPtcjTmkr0aDyWxIIOQ8z7gBn7zSGUsfyu8kYjO+zO8tsfviu6UvWSRP9UnZ4jfNLqmAvJ2J2S/zn4J6hQtBmvzDh+Eth8HPfVnIVkhiCNfWofwCwn1dw9G5p5Kgm40L6T8xu0rVfoSLC5TyaCcvym6myks1UK0Z9BP8vut2nxnD8X4rSg94RhBQlAwjMJ5H3L0mw6nRaw3ejRSjyUuGJwUwVVF4PYoOb5vVEz5BOetpdzlfCu4XCu7edy2+dap2gbJa1lCZyoAdWq9Gc8fJegmxYQ6TH9hYJt7iU56SGyQQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=p+pDlRSnQPEKLtzNeDWHCSUkO7SH6AY9lD6+Q51QuOc=;
 b=kVRWsjV3ubHn8fa8wkTeN86b3prjet7Zz0iW3GzdJTFFvTqyzGLsn93TP8qfj1cQz0v1ot3Os/6rT5RWDT/h8KmctOQtWXqD3ZgscCE4jszpMDJ5tGz33SgUfOj/+8pugm0xjX2uwVeeTiHl+Xk9A2BBm0dEv0jGAy0Hg96AjCjL581KyOUr1eqoE74JTFobLTv3D3FP/+ofNyf2kLee3FQz8uhTgLPypHPga0CoWtESoeqHqp+knE/x8BXpU0Y39pl8ylJHKkcAEuv6PKgKXb7tElxqZ4eo11IO5zpPkIOG6NFTvnH2d9QqLw7RjjdvMi54arQ+Iw5IlS3OWmnMIQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from PH3PPF9E162731D.namprd11.prod.outlook.com
 (2603:10b6:518:1::d3c) by IA0PR11MB7185.namprd11.prod.outlook.com
 (2603:10b6:208:432::20) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9769.8; Thu, 26 Mar
 2026 22:42:39 +0000
Received: from PH3PPF9E162731D.namprd11.prod.outlook.com
 ([fe80::7d4b:a049:aed5:d2b0]) by PH3PPF9E162731D.namprd11.prod.outlook.com
 ([fe80::7d4b:a049:aed5:d2b0%8]) with mapi id 15.20.9723.018; Thu, 26 Mar 2026
 22:42:39 +0000
Date: Thu, 26 Mar 2026 17:46:25 -0500
From: Ira Weiny <ira.weiny@intel.com>
To: John Groves <John@groves.net>, Ira Weiny <ira.weiny@intel.com>
CC: Jonathan Cameron <jonathan.cameron@huawei.com>, John Groves
	<john@jagalactic.com>, Miklos Szeredi <miklos@szeredi.hu>, Dan Williams
	<dan.j.williams@intel.com>, Bernd Schubert <bschubert@ddn.com>, "Alison
 Schofield" <alison.schofield@intel.com>, John Groves <jgroves@micron.com>,
	Jonathan Corbet <corbet@lwn.net>, Shuah Khan <skhan@linuxfoundation.org>,
	Vishal Verma <vishal.l.verma@intel.com>, Dave Jiang <dave.jiang@intel.com>,
	Matthew Wilcox <willy@infradead.org>, Jan Kara <jack@suse.cz>, Alexander Viro
	<viro@zeniv.linux.org.uk>, David Hildenbrand <david@kernel.org>, "Christian
 Brauner" <brauner@kernel.org>, "Darrick J . Wong" <djwong@kernel.org>, "Randy
 Dunlap" <rdunlap@infradead.org>, Jeff Layton <jlayton@kernel.org>, "Amir
 Goldstein" <amir73il@gmail.com>, Stefan Hajnoczi <shajnocz@redhat.com>,
	"Joanne Koong" <joannelkoong@gmail.com>, Josef Bacik <josef@toxicpanda.com>,
	"Bagas Sanjaya" <bagasdotme@gmail.com>, Chen Linxuan
	<chenlinxuan@uniontech.com>, James Morse <james.morse@arm.com>, Fuad Tabba
	<tabba@google.com>, "Sean Christopherson" <seanjc@google.com>, Shivank Garg
	<shivankg@amd.com>, "Ackerley Tng" <ackerleytng@google.com>, Gregory Price
	<gourry@gourry.net>, "Aravind Ramesh" <arramesh@micron.com>, Ajay Joshi
	<ajayjoshi@micron.com>, "venkataravis@micron.com" <venkataravis@micron.com>,
	"linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"nvdimm@lists.linux.dev" <nvdimm@lists.linux.dev>,
	"linux-cxl@vger.kernel.org" <linux-cxl@vger.kernel.org>,
	"linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>
Subject: Re: [PATCH V9 3/8] dax: add fsdev.c driver for fs-dax on character
 dax
Message-ID: <69c5b7411999c_14003310089@iweiny-mobl.notmuch>
References: <0100019d1d463523-617e8165-a084-4d91-aa5e-13778264d5d4-000000@email.amazonses.com>
 <20260324003818.5009-1-john@jagalactic.com>
 <0100019d1d476420-6b0bf60e-3b3a-4868-8f5f-484cd55d4709-000000@email.amazonses.com>
 <20260324143927.000024c3@huawei.com>
 <acPX9T2ZF7xTCHtZ@groves.net>
 <69c407903b54c_130d6e1007a@iweiny-mobl.notmuch>
 <acVDCKeolpJM9qg6@groves.net>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <acVDCKeolpJM9qg6@groves.net>
X-ClientProxiedBy: MW4PR03CA0256.namprd03.prod.outlook.com
 (2603:10b6:303:b4::21) To PH3PPF9E162731D.namprd11.prod.outlook.com
 (2603:10b6:518:1::d3c)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH3PPF9E162731D:EE_|IA0PR11MB7185:EE_
X-MS-Office365-Filtering-Correlation-Id: 08fe05bd-5ad7-4467-716b-08de8b88fba2
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|366016|7416014|376014|22082099003|18002099003|56012099003;
X-Microsoft-Antispam-Message-Info: tkldoXTv4zSI/d6jrMBvujj29neub23mjswNdSlIEWcErabcBc/otuZkRR+jXvqfIBmKjhoKDZ2FoUSB4nBcItWJor8k7e+5FDhRY2EqSkVngdyDyYdrB35YAzGZ5CY/nIQ+lXqGexcFnLv9yrAeNaMlpKQcz1vce6AXhoDX4Uxh+2HEpsBiJchCHQ1dKBE4r0qKlmAPdrtK+6eeumCOjBcz7cxb+SDvETr6aqz+ohoqEKla4YlbcvHu6WCU6Q+hip2gEXpYhDi4qBBz1FhGVhrpXxAgv73wn1jevX7Z3NOjbg7VkUjgDqsuXlmhoDJu+AsUhPdqicCWW9Inv3qLFSQWRmtB77tHhojF2zfh0pseGdkX1RJdxf9Rw0G3dV7SJwf03FcLnHrclrT3vHhD846zLx+JGhDkGyAfUF8IjU4I2h18TqUSVCexOk/xoZzUwWpQN/toTU0SCRodhEp935P/mOGLqs46ARoTJlEXnj9u5Xpo0V7JcojvUUf1CZTbH6Z/8Atzmi9AU9yBSdmdrxRoP97ZctGNICimSk163MxoqRULebVlgzuKOpQaaZ+N/K8krhSf+B7RcFIMyzH8wWVvu1LLPAO6B1gbC6oTT/aNl68nK3A7cCFhf3tfXw2oLs1Y4TNyfWXAeLYDmF1CnXhJVdC1c1Es6SDNyadHSNG5dXpzCGGEzGLCoWSkLXkgW+rYsJ8SBY54ne0JXh+a1VgCzGNhJTeTxarlNy/HhPQ=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH3PPF9E162731D.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(7416014)(376014)(22082099003)(18002099003)(56012099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?ohjOMx9wdX3Sq+9JIalqouLWFuEM6ooGIchmh7VAbPXrq60YPnNALMoWtB4m?=
 =?us-ascii?Q?MMDqkl0VbBU+7ZzppCvqqF0Kj8bwdpvyJiKc68FcqaRFNN61K3eT3wE13llb?=
 =?us-ascii?Q?VJfQSA8hd7AOJcaAArI93k6zDleB1Q8gmULf8be4lqHqiOL5PtlM9BPjnBxv?=
 =?us-ascii?Q?cq7txZRlrDhik1Lj2oDgHrELA0hBAbUtglB/44ynRf2MyfsKmPf/4IuEubGJ?=
 =?us-ascii?Q?GDVxRhykamUuiKYGiIeBenbfA8nVLvUtBNLtJBkgf08er0XB7gcPJBCniSaJ?=
 =?us-ascii?Q?+5iSMCXzMn9YQgR82l064Sr9cD9/f7MHajz0jjnKxr8M41BLbpTkGlepBoOu?=
 =?us-ascii?Q?M/Lp+fVh0dtrCiBAYUKmkGtltG+b2zyGk92Da04NG2JF7iiqss3qkUfF8seq?=
 =?us-ascii?Q?ayetJS5K8ZUZ52ITEjnxptBvr6+KJyP0ap+dKGan63SxXDEITEQfhMtcY194?=
 =?us-ascii?Q?a+FaMhFGIClaroZO9Oj2loQ98CXCgiWwoQaVqeTuLPyEQjMgkG+Enz7EqkfO?=
 =?us-ascii?Q?JUtP4bjodtR9PyPlX38jCw3v5OSqeV3TyCdteH5XfO8w8XEc1UgwoQe6tdzh?=
 =?us-ascii?Q?LKV8PfcZEh5nGXaFTDWwr2iscPCF+XYo8rzIwkPJ5DPXB4H0LWMD5DVNOAtD?=
 =?us-ascii?Q?Kix76BCjfrXONK+01XQWYdtdyMAqZsSPhd1bnYmKniKcOLD0M3lyvSSl9i0m?=
 =?us-ascii?Q?R0vyTGSIekotxgxHSH/Rtgv+700rzYMGQvQkM34c93xkPvtqz5XjHIK33pCv?=
 =?us-ascii?Q?GB1d+ZUq6RQDTsQNM+HJ+JLVg8slzHj9RBOEHgwsALigm72ECY/FyPZuaqtr?=
 =?us-ascii?Q?MPcduXenT9DXH8Zf+s97vbHa0VpyjGN19H8K9k+2OyhdWUEaxThGJlV5fbWp?=
 =?us-ascii?Q?1aeFvw9QCco4VNGolTbTnXHpVNbjbCMnjOf2FmiIA4jxqIVPv7GLM0SMxqo5?=
 =?us-ascii?Q?V7u6JPdG7VFSwR/JYpPDv9kRKdUqC/JKb3Z2tymivZbaOvMe1HYAEK+64/to?=
 =?us-ascii?Q?lcahqfWC3+oZ8yxTZ84sqL/Flp2mqxlas18sb1kr3yn3vRQIsiHXw93NkC6P?=
 =?us-ascii?Q?IVaKqpb3X7+NGBQQ49jVlc1cwI1nOVWBENT1hzFqN71CkVzu3Qu/1mRdtZUH?=
 =?us-ascii?Q?apI4nw+IOA1RCg7LSq/S+2W6TOKUQLQuwH4krqKfCUchoMI0R+7ZwKM+WXgS?=
 =?us-ascii?Q?E3286X5Xl5/dRlvyuIpTotDzPn1tZLH+2CDHsR98xSf0hgj9+2jOmbIpMRM/?=
 =?us-ascii?Q?zoapXYNUH4EVm5ooq0ftpCF+iXtLm3m357zpkq7eABcnqelAYnkKUNPebwyK?=
 =?us-ascii?Q?RH5NBC4INda7ioMoWMkQ3jCMm8Lv9eMKCIaFuUwnHOnxltivJRZWR9TYTMq0?=
 =?us-ascii?Q?nymxqCvAWUbtz3e6y82QFprMMKPF0C5TNaUHBBHr35bfZpW2SUFxpNh+dOa9?=
 =?us-ascii?Q?TMG0+3nhafnk3AJaL+eNEPUlXqkRdwrtXWDAGL78Q5zAVRVNNz1oUP5RUwvI?=
 =?us-ascii?Q?y1ef1KCom19VM/P7PIm7lT3bOIzPbv2/fiHipSeYXxsnL4620jYXinwK5TK/?=
 =?us-ascii?Q?L2YiGRHNgsnndg2Pygy2aI0Gntlpbz28VtSrzFjE1ihvkxctMfeGPcao+S6i?=
 =?us-ascii?Q?eH8LtEU+YrkPIIXkNeETkElod4MsCJw6OzuEgJaHPzRJ3YjzC9FMDe8AUj5a?=
 =?us-ascii?Q?GWXJryGbrmxN57aRaSeY7n/wqkusD7qih/4kPSUtqcfolLi9sU3zaleixdFk?=
 =?us-ascii?Q?dxgzAo6bPw=3D=3D?=
X-Exchange-RoutingPolicyChecked: A9SJMyrdOZ8DuHhgZYt4TzjvMPglSvDlZKozM+NsJm7PQK6smlnt4315m5y1KyG6vfKpMlpjuuo62uZmahAmlvHsAdBAfsLfL54nCG+Pbaaalp3EmoRzikHUzspb7o8rJo4IGdl7keVonKcUQ5IStnWWUXmt34Tos2dU40CH5wGQUZiiMweKZfgSy9z5uUMmE3kmSV/jldt8Np/+NhuZiVYmQwtHQfUCC/cmaavrTuYnkaNC9cyiGsSXcLh+Ruw8khYd07aMN0c8PwXYDwSTlZm0hZMW1xw1/5xTSZGMgrNi3xNjeQJOQvqbteuhT1WMogT5O7dmA/qXfVhf00cf8g==
X-MS-Exchange-CrossTenant-Network-Message-Id: 08fe05bd-5ad7-4467-716b-08de8b88fba2
X-MS-Exchange-CrossTenant-AuthSource: PH3PPF9E162731D.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Mar 2026 22:42:38.8712
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: snY9tuh5hkJGPMO2Hp97tYkRQmTl2MRAB21mQOtWiig5xYUmAH0T4nI4UDdWohrXDcJDLOKwwTX2q//uVGaGbw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA0PR11MB7185
X-OriginatorOrg: intel.com

John Groves wrote:
> On 26/03/25 11:04AM, Ira Weiny wrote:
> > John Groves wrote:
> > > On 26/03/24 02:39PM, Jonathan Cameron wrote:
> > > > On Tue, 24 Mar 2026 00:38:31 +0000
> > > > John Groves <john@jagalactic.com> wrote:
> > > > 
> > > > > From: John Groves <john@groves.net>
> > > > > 
> > > > > The new fsdev driver provides pages/folios initialized compatibly with
> > > > > fsdax - normal rather than devdax-style refcounting, and starting out
> > > > > with order-0 folios.
> > > > > 
> > > > > When fsdev binds to a daxdev, it is usually (always?) switching from the
> > > > > devdax mode (device.c), which pre-initializes compound folios according
> > > > > to its alignment. Fsdev uses fsdev_clear_folio_state() to switch the
> > > > > folios into a fsdax-compatible state.
> > > > > 
> > > > > A side effect of this is that raw mmap doesn't (can't?) work on an fsdev
> > > > > dax instance. Accordingly, The fsdev driver does not provide raw mmap -
> > > > > devices must be put in 'devdax' mode (drivers/dax/device.c) to get raw
> > > > > mmap capability.
> > > > > 
> > > > > In this commit is just the framework, which remaps pages/folios compatibly
> > > > > with fsdax.
> > > > > 
> > > > > Enabling dax changes:
> > > > > 
> > > > > - bus.h: add DAXDRV_FSDEV_TYPE driver type
> > > > > - bus.c: allow DAXDRV_FSDEV_TYPE drivers to bind to daxdevs
> > > > > - dax.h: prototype inode_dax(), which fsdev needs
> > > > > 
> > > > > Suggested-by: Dan Williams <dan.j.williams@intel.com>
> > > > > Suggested-by: Gregory Price <gourry@gourry.net>
> > > > > Signed-off-by: John Groves <john@groves.net>
> > > > 
> > > > I was kind of thinking you'd go with a hidden KCONFIG option with default
> > > > magic to do the same build condition to you had in the Makefil, but one the
> > > > user can opt in or out for is also fine.
> > > > 
> > > > Comments on that below. Meh, I think this is better anyway :)
> > > > 
> > > > Reviewed-by: Jonathan Cameron <jonathan.cameron@huawei.com>
> > > > 
> > > > 
> > > > 
> > > > > diff --git a/drivers/dax/Kconfig b/drivers/dax/Kconfig
> > > > > index d656e4c0eb84..7051b70980d5 100644
> > > > > --- a/drivers/dax/Kconfig
> > > > > +++ b/drivers/dax/Kconfig
> > > > > @@ -61,6 +61,17 @@ config DEV_DAX_HMEM_DEVICES
> > > > >  	depends on DEV_DAX_HMEM && DAX
> > > > >  	def_bool y
> > > > >  
> > > > > +config DEV_DAX_FSDEV
> > > > > +	tristate "FSDEV DAX: fs-dax compatible devdax driver"
> > > > > +	depends on DEV_DAX && FS_DAX
> > > > > +	help
> > > > > +	  Support fs-dax access to DAX devices via a character device
> > > > > +	  interface. Unlike device_dax (which pre-initializes compound folios
> > > > > +	  based on device alignment), this driver leaves folios at order-0 so
> > > > > +	  that fs-dax filesystems can manage folio order dynamically.
> > > > > +
> > > > > +	  Say M if unsure.
> > > > Fine like this, but if you wanted to hide it in interests of not
> > > > confusing users...
> > > > 
> > > > config DEV_DAX_FSDEV
> > > > 	tristate
> > > > 	depends on DEV_DAX && FS_DAX
> > > > 	default DEV_DAX
> > > 
> > > I like this better. I see no reason not to default to including fsdev.
> > > It does nothing other than frustrating famfs users if it's off - since
> > > building it still has no effect unless you put a daxdev in famfs mode.
> > > 
> > > Ira, it's kinda in your hands at the moment. Do you feel like making this
> > > change?
> > 
> > I don't mind making this change.  But we have to deal with the breakage to
> > current device dax users.
> > 
> > https://lore.kernel.org/all/69c36921255b6_e9d8d1009b@iweiny-mobl.notmuch/
> > 
> > What am I missing?
> > 
> > Ira
> 
> OK, I can reproduce that failure with kernel 7.0.0-rc5 and 
> straight ndctl v84. So it's not famfs.

No it is the fsdev_dax driver which causes the issue.

I can reload the driver and effectively change the order the drivers are
searched.

I can prove this with a simple print.  With my test system (where
fsdev_dax _happens_ to be the first driver searched) the failure happens.

[  526.564232] IKW searching drv type 0 ; type 1
[  526.564515] IKW searching drv type 2 ; type 1

If I remove your driver (modprobe -r fsdev_dax) prior to running the test
I get.

[   59.748171] IKW searching drv type 0 ; type 1
[   59.749127] IKW searching drv type 1 ; type 1

And it passes.  I can continue by loading fsdev_dax back and it will
continue to work.  If you are getting this to pass it must be because in
your system that driver gets loaded first...  not sure how.

This is with the same exact kernel just with your module removed at run
time.

dax_match_type() needs some other way of matching when the fsdev_dax
driver should be used.

I'm not seeing a clear path ATM.

> 
> I also studied the verbose logs trying to figure out if famfs
> could cause it (while running a famfs kernel and ndctl), but
> I don't see it.
> 
> Then I tried non-famfs kernel and ndctl and it's the same with
> or without famfs kernel and famfs ndctl.

:-/  I'm not seeing any failures with rc5.

Also I'm not running with famfs.  Just the dax changes.

Ira
