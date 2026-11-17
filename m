Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=198.175.65.11
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1794960007;
	b=zOiHZvb4PnMf6eN5N8/9CTqcS0d1i40KsGfmYLACG+hw3bv5Fb2UGLDsU+j2Txd28unR
	 WxoKH2PFtyv3Na5k2Z74hzFkN2sdK6wvUcih2KohVJyk1YuzofN8/Lo14edxVzw9iGZBG
	 fN3YurR5L4aPIdxNgbh8cUD7/9V/DxY1hoZNGuvvKwb0J3NyW+I+xHCTvNVDyTUTxRPrb
	 BiPpFjWtFWKg50BFjV3sJVyHQVqxiXtyZE8v8Ymjm7l5+zH/HW0C7LaafGNKUw6dLuDMp
	 dfuCHT/A9vtf8/Mn53qrJ/4ehEQ3hjkmtbrtrXzFSdx5Y9uXt16eZdzqVAR6NNOMd/Q==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794960007;
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
	bh=XtqGb7vlU22+AgpufBLu2/TVLBjd/Da7BxPVg82LZVA=;
	b=5RWvzwqMLbAQovHBjlvZKCyl3WxymYKeY3+0xiCot9aB18d6pEDlufWVCI9gorAgtv40
	 U/Cdw4dxm6mdD3fHiz+dq1pgmPYiZaeeMsh5dg6Vpl3AdGv3IofSeBs901n4kFvzLwlm4
	 hyYkyhVb/MoD5gxeViNI8uskdSqBVpNx7NsynUo7o/Bjw8+tLP4vM95Xbo8oNTDHWgQgT
	 Wga1zyrFI4hUs+v80toOia25rGZZPNvuFUd1vehscPWnAZFBaUaIdsCVsITpX9dkfWWNy
	 3SZ8pLjl2gnKhszjl0fpgi0pN0L/mQu/eiyQ3wL1x1vWuMU/cqZn3NXDY4eksMdRt0A==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=intel.com;
	spf=pass smtp.mailfrom=intel.com;
	dkim=pass header.d=intel.com header.i=@intel.com header.a=rsa-sha256 header.s=Intel header.b=dJTFLSWb;
	dkim=pass header.d=intel.com header.i=@intel.com header.a=rsa-sha256 header.s=selector1 header.b=aJzC66Mb;
	arc=pass header.oldest-pass=0 smtp.remote-ip=198.175.65.11
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.11])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C9471606A332
	for <nvdimm@lists.linux.dev>; Wed, 18 Nov 2026 00:00:06 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org C9471606A332
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.a=rsa-sha256 header.s=Intel header.b=dJTFLSWb;
	dkim=pass (1024-bit key, unprotected) header.d=intel.com header.i=@intel.com header.a=rsa-sha256 header.s=selector1 header.b=aJzC66Mb
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1794960007; x=1826496007;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=gdTTuN+cuFErOKhLmN56OT+YYWEGjbow7B96BaacSzU=;
  b=dJTFLSWbjk2893CnlL7K7q9nHBs4j4asLv3gBiLUDY9U8lWrtawjOmoN
   HwaDnC2QPiiTmzDbmTK4vIl1zWx312p7heoSZbW3vDHXMYeJhME9mfjLB
   xsRjZxFzHGo5EGglUloa4dXZSJ+iFGLo9Lwx/UL5LncoOwrI4H7FyrW9m
   JChqMlvtaNUUCRItH/HXQTaKZ5YWSp2d9BoNq8x43UOMoUmdZ1gR/yu+M
   i+KnhVW1jYrTppAsW+Pj88QDjP+ZpEI7GHt/RcN14qcH5NuW/sk7XmmL/
   mVDK9Qr92zA2J08J2zVr8mvCsqY1R5B3JrJJbpuzO+foQ0QYLFd2OTjFF
   w==;
X-CSE-ConnectionGUID: orBgUT+VTQmGLNmC0Qfgyw==
X-CSE-MsgGUID: qLLDxGPKQ7WnBlsvIn4gdA==
X-IronPort-AV: E=McAfee;i="6800,10657,11969"; a="3653043"
X-IronPort-AV: E=Sophos;i="6.27,219,1787036400"; 
   d="scan'208";a="3653043"
Received: from fmviesa001.fm.intel.com ([10.60.135.141])
  by orvoesa103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Nov 2026 16:00:06 -0800
X-CSE-ConnectionGUID: lsessl/RRcOFUbuBGFzeDg==
X-CSE-MsgGUID: 86BDfiebRAWZgq7lq1v/dw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.27,219,1787036400"; 
   d="scan'208";a="10347053"
Received: from orsmsx903.amr.corp.intel.com ([10.22.229.25])
  by fmviesa001.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Nov 2026 16:00:05 -0800
Received: from ORSMSX902.amr.corp.intel.com (10.22.229.24) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.56; Tue, 17 Nov 2026 16:00:05 -0800
Received: from ORSEDG903.ED.cps.intel.com (10.7.248.13) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.56 via Frontend Transport; Tue, 17 Nov 2026 16:00:05 -0800
Received: from CH4PR04CU002.outbound.protection.outlook.com (40.107.201.10) by
 edgegateway.intel.com (134.134.137.113) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.56; Tue, 17 Nov 2026 16:00:04 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=FO5z7VhpoTI7t71ZmCJeyTqPsx/eaO/wesZST0xG+PgIVjFvtf+6V8olLbfr4EX0sz32oFEGzddc8H6dpWxOxPbdehQUDnqi8rZQAfouhW2WwkjjhYaJxSJfL3nujG5BK7KTlZlJAymMX61J2Rd3jakcx0NZd494ZzB+9tCdydQsX5ZkFrlahmI1DfEggFoCBfungxW65PH+YwE4/JKR5wL9FTnUK9ZGetrLrCSRg4YYP22gIRV4EbdXPX8f/riuTQC+7DQC3EEIxypBNE7xWuOaivM3kUx49hC+hcQxDQ+mC7kheP9J/yNbqBU1JS3Mc6jHM7VcWYUmXsEMIfO0ww==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=XtqGb7vlU22+AgpufBLu2/TVLBjd/Da7BxPVg82LZVA=;
 b=C5CDpJdTTkSIwDrWc/pQrB8Cz52uzxm8S+drMjUUky7UVJzAwucLPUpN5qPpw1ghmqu1TPHEc6RAvM3EoBoKXJLfoKm3Oghy1yRHb3qXc7VdqJgMaVAP6cETzvLA7uH30ncKdTMSCEnMisHy3YASV3x68wlPcRvTqK7OYj4B6dGKNQCRQJgWl1HA4Ir/aTARQeKNvDVfoA4+XXjYTpRfVntYfEFsW0JBRa0CkRCLgIbOk89jOkeh1nvK7T9B5LvpTizUpT4Ut9Sc5n2fjAztT6NIW0dBieOtVEqldzoUOa2M+6mOs+z2DCqwwVL0itkMFMTtkSUGWaGALNjpTNn9Bw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=intel.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=XtqGb7vlU22+AgpufBLu2/TVLBjd/Da7BxPVg82LZVA=;
 b=aJzC66MbaBNHDPKe/j53lwGSxh1gsVxJz1JX7btgjo3pW3Mi2rSRTtJUkPT3ryTukQ6p26//isTugU//ltsa1EZAuuG44rCNSNwB6oSDFaj+inxCvgRJek2DtuR5+MTUtwm7FpT4Dh86LEs6MoCnSpG9J5MJ5xRD8D7dlJOYcrM=
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DS4PPF0BAC23327.namprd11.prod.outlook.com (2603:10b6:f:fc02::9)
 by SN7PR11MB6751.namprd11.prod.outlook.com (2603:10b6:806:265::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.615.14; Tue, 17 Nov
 2026 23:59:57 +0000
Received: from DS4PPF0BAC23327.namprd11.prod.outlook.com
 ([fe80::6fbf:c112:d0a8:f1a8]) by DS4PPF0BAC23327.namprd11.prod.outlook.com
 ([fe80::6fbf:c112:d0a8:f1a8%5]) with mapi id 15.21.0615.013; Tue, 17 Nov 2026
 23:59:56 +0000
Date: Tue, 17 Nov 2026 15:59:53 -0800
From: Alison Schofield <alison.schofield@intel.com>
To: Dave Jiang <dave.jiang@intel.com>
CC: <nvdimm@lists.linux.dev>, <vishal.l.verma@intel.com>
Subject: Re: [PATCH] nvdimm/namespace: Nest mapping locks under the bus lock
Message-ID: <avzqeYNM3DTCtqgc@aschofie-mobl2.lan>
References: <20261117223116.3478672-1-dave.jiang@intel.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261117223116.3478672-1-dave.jiang@intel.com>
X-ClientProxiedBy: MW4PR03CA0084.namprd03.prod.outlook.com
 (2603:10b6:303:b6::29) To DS4PPF0BAC23327.namprd11.prod.outlook.com
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
X-MS-TrafficTypeDiagnostic: DS4PPF0BAC23327:EE_|SN7PR11MB6751:EE_
X-MS-Office365-Filtering-Correlation-Id: 46872421-9993-4259-c202-08df4506e171
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|23010399003|376014|366016|18002099003|6133799003|22082099003|261009223027099003|11063799006|56012099006|261102123227099003|261026121527099003|261021121427099003|261021123027099003|10067099003;
X-Microsoft-Antispam-Message-Info: +AepDU/BDcdCj9QtqR2urERULAYf/KG3pxy30mtefOl8Spy3ijOQnSk4AS+PGcebxY6JSbl9UEeOiJfDyTIB67oHn2KhPwbf+QL0y0FfEWPO9hGPTIf2260Tjk9DDTeqCEFugKxg8K5cIFk9PPlbTi0bfDMtImuE6j4As+i2hccn10h3stSMIBra7LeiWIR2kJslfP5nfgA03GyXKZX2K0KD5H0Y8ZtW+YPjIIyQsTG0dNS0zgvbmuki0aM6+sUCoCs7EtbMLz9kFYwOpE49fGSf2uAKcvzncYrnBI8Nope/s8ypn+VZQHzIx5fKx5CJ0Vwr1dCFL6MVtp8QKM7XnZKkJoq11DzGV6kcCNzf0MSy0kMjiuUUDRR+HqcNw9y/ndy/Xw3PMaqw6iQI7hT1irHRdap7aHG4lRZCodgYkQTXhr12M8ED1d8NIP6tWDdJSkThL9STx4AKvqdrkiD1xfPNy5kbPhbnvONJdfzMKjblv2vjy9Yt8hUhS/dPyhq1AU6QoZZ1SaOZ9hNJtHBRu7odDOx0HZVF7sI6tCZ/UTBSjzXa5VUkWctla+ryijZMowDSJ4ZhSjTMT7WcS5KezilnCYT9z19rMi9zynrV/WMJYq2GkA66zqV4+LzC8yLtUpYDfVwY4JOaMoKWmknxHIOSILxxvlb3KBaZdjs04Ac=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS4PPF0BAC23327.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(23010399003)(376014)(366016)(18002099003)(6133799003)(22082099003)(261009223027099003)(11063799006)(56012099006)(261102123227099003)(261026121527099003)(261021121427099003)(261021123027099003)(10067099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?gGCEU5T1J/raNvdGGcRG7qKpu3q6+GNpfVHXJYBsJ5G0LU0ECmb+62WZutYT?=
 =?us-ascii?Q?0Qk/RBxoAfQ8anm8iGApFpYu7VJOQySPtiLK00X4Q0ejfMZSgUJeS5oZ9rgy?=
 =?us-ascii?Q?YBlNntafplN4LXbSexOkHtN1BVHiBzi7oKOleoL9h3vv1QSZ4zT1qrVppemg?=
 =?us-ascii?Q?0nlqWGt3R4TApee4EXypmegIPZ2l/ixapffWmWPLIhJOMXloOUTVMe/8Ki8g?=
 =?us-ascii?Q?MH/4aeE8TRy+3nWdXZ6BTEc9+3jRVZTjexFJ+ud4Am9Q/QosoWvisOnOPwoJ?=
 =?us-ascii?Q?wwU6GQZqnxmTbDQWWNXyBxwocB2HkTHbciqIvcflXoALJ+wMy5MNDmcIqtO6?=
 =?us-ascii?Q?sSb+bpoPadqRL4aT3abFHj5Cy5SatVIeUGFgvGcioOswhvGSfsEtyMFO/X7a?=
 =?us-ascii?Q?AicwL7TOBGnAn7lWnmfn/U5NrtjJqUNDrsPk9VfSNHZuaB3pCwUAShHlr1M/?=
 =?us-ascii?Q?175bTegO1yW9VyDQoX2p2N4TVwg/ACyLgW7vDho2ySKX5/9s2LfwOKkiL84T?=
 =?us-ascii?Q?3nV+yDtEoRhouf4ZASiCJbJGtZr1PXRvFe+dbIZ350ossk6/N2flbEhw5JoO?=
 =?us-ascii?Q?9Tj8GCaPFZC7P8aG7VkqnHlIzisoWX4z1RnXNtKJX2Y6W5z4hiPk3Ei8Jhjz?=
 =?us-ascii?Q?ujKafUFxCUPL2q3hGY8IHIQUIjQNuI4P5lKY3NY803DQQ9kjQu+cztIaH3jI?=
 =?us-ascii?Q?sMbYW1J6gBsQ/SFKZgI0mNkgekgz8+fjVhNfKgBuU9ln+DpQnLi7edpsagG9?=
 =?us-ascii?Q?1fAJgTP30385QYbeXjGDmJ2x59NXC6D/8TvI/377OVe0LotNtnqkbNqEvrJV?=
 =?us-ascii?Q?YfZtju0nXySqv0lyMAycZRwhgjo2N1vkS4WMkMec/s/byYFpRaIer1PP9j3L?=
 =?us-ascii?Q?i+L4UdhSa9LvCTQB+CHdztYH9aOHsU5IYWWzYEYkfPkGj/yRRZJjRop/YMxe?=
 =?us-ascii?Q?N2AX+1pB7AeWWkm1vAlddVvRs2QP/McZ0S4F9rEsNt+zMwKa+lNWr0ORqhS3?=
 =?us-ascii?Q?QJSrF/dqHWLNhV/C0tuhCN1dsqYmPCgRQ3c17JVg3QOMryA3xb6nhxaVeY9U?=
 =?us-ascii?Q?oTKjPSJ/0RhtpNPnqmIQQAoMKFhFbngoWyABPUl8F8gbC46bZU9IQ7/jamHs?=
 =?us-ascii?Q?Bmwp2q6Pyot0tEB0QOP9CKmRn/LOj+UVhEUIvNbi1Ko07CNHbJ7XDFvNZB2L?=
 =?us-ascii?Q?t2rW9WGOlsfOQ6SARKfaVlMR7diflkfn+IpxIkkO1CL81opIdiCKVCD20M9Q?=
 =?us-ascii?Q?9DLiwhKCY2rV6WpNtC2T9pmN6gbwLYiw9XeVMMF3/XoQMhtKK9Qs8i34UMJg?=
 =?us-ascii?Q?cqsv/d1Ff6hkiCoqGWELEssBzW9I2uvnqKV8Rt8IR9nwJLDNGDLWBEtrbyqM?=
 =?us-ascii?Q?MO6raHdyJEFcRhOuRyKl8NGPuzBysiwVyq0noSEfO43VO9uHJQJhFKhmwSvX?=
 =?us-ascii?Q?26HnGktAXw55DzVAIZMERi8PobmZr54JJmC0aWrsHuMe3i2xrf1QxfFOMTTZ?=
 =?us-ascii?Q?9qJoB2GtzlfcUzFeunENPXF23cPGrtPoD4+pumNjB39gAbMjnQEr9SHY+j1b?=
 =?us-ascii?Q?hUfmnEE1T/I7zZDA0YqS96qCTkYtF3rLY6KcYYfsVCdGlKIdNVnUhYPBeTgq?=
 =?us-ascii?Q?hOovXXDjrAld1qc9ehKCSU54RXEQxhfAAkeAKEQBcmw4e7IMQM8gS8CT+gbO?=
 =?us-ascii?Q?r+hlCZKIXgNZ1uJXbhb/nSVNX2Tn0pFq5/gMqwjRl3cg+d5Uf00Q68OTRr0l?=
 =?us-ascii?Q?LjSx4Pzg3+H6edBvF79Nr1S/067LfFQ=3D?=
X-Exchange-RoutingPolicyChecked: 2sObgpFqk7w1YLTb+d79x3CoOEuHh9CvsvhW5A/aY6rQ62Y7TUhHNatUPcvqWdO61K7vDY6V4H7NY5+E9CmLcMJtQcoKdQRdHwqqH4P5AdQN4v1JNPRx0cDytdzKeSIHCAOMB44E6WNdh7w0d5UMIbaW0+2vYAQsF/sMH+Q22jKLshwusQwf00DtSLwIdQe+K/5lvby95IBsuFKDDuOS9Osl8O5KbieRMw3KRJlKHBgLX8IBeR5Nv2QkxDdd3cprNbmPIXUsTqv1mvTyRekcomtSIWC+JATyX/VBXm+vwcEw4RE/w/pZKVz5v3wipoYrHOvVOPgyr7Q8ECckbE+a+w==
X-MS-Exchange-CrossTenant-Network-Message-Id: 46872421-9993-4259-c202-08df4506e171
X-MS-Exchange-CrossTenant-AuthSource: DS4PPF0BAC23327.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Nov 2026 23:59:56.7895
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: pZqn48K0C7nUUbyP/m3RPKUfWuGzCK3G9glmS8hhiwwHYkM1ZelGtOPt+dN+nTbCtdY64xSHq//iyAuZCjwEqWXmpUbX2pflkR+FINjmKrM=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR11MB6751
X-OriginatorOrg: intel.com

On Tue, Nov 17, 2026 at 03:31:16PM -0700, Dave Jiang wrote:
> create_namespaces() takes every mapping lock in a region with
> mutex_lock_nested() and uses the mapping index as the subclass. Lockdep
> supports only 8 subclasses. A region with more mappings, such as a
> 12-way CXL pmem region, triggers:
> 
>   DEBUG_LOCKS_WARN_ON(subclass >= MAX_LOCKDEP_SUBCLASSES)
> 
> and lockdep turns itself off.
> 
> The caller holds the nvdimm bus reconfig_mutex. Take the mapping locks
> with mutex_lock_nest_lock() under that lock instead. Lockdep then
> tracks any number of mapping locks.
> 
> Fixes: ae8219f186d8 ("libnvdimm, label: convert label tracking to a linked list")
> Signed-off-by: Dave Jiang <dave.jiang@intel.com>


This was testable (and indeed DaveJ found it) with the unit test that
adds a 12-way CXL pmem region, cxl-region-finer-gran.sh.
Thanks Dave!

Tested-by: Alison Schofield <alison.schofield@intel.com>
Reviewed-by: Alison Schofield <alison.schofield@intel.com>


> ---
>  drivers/nvdimm/namespace_devs.c | 11 +++++++++--
>  1 file changed, 9 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/nvdimm/namespace_devs.c b/drivers/nvdimm/namespace_devs.c
> index 557fe0cb43e2..3aa0a9026efa 100644
> --- a/drivers/nvdimm/namespace_devs.c
> +++ b/drivers/nvdimm/namespace_devs.c
> @@ -2031,6 +2031,7 @@ static struct device **scan_labels(struct nd_region *nd_region)
>  
>  static struct device **create_namespaces(struct nd_region *nd_region)
>  {
> +	struct nvdimm_bus *nvdimm_bus = walk_to_nvdimm_bus(&nd_region->dev);
>  	struct nd_mapping *nd_mapping;
>  	struct device **devs;
>  	int i;
> @@ -2038,10 +2039,16 @@ static struct device **create_namespaces(struct nd_region *nd_region)
>  	if (nd_region->ndr_mappings == 0)
>  		return NULL;
>  
> -	/* lock down all mappings while we scan labels */
> +	/*
> +	 * Lock down all mappings while we scan labels. A region can have
> +	 * more mappings than lockdep has subclasses, so nest the mapping
> +	 * locks under the bus lock rather than giving each its own subclass.
> +	 */
> +	lockdep_assert_held(&nvdimm_bus->reconfig_mutex);
>  	for (i = 0; i < nd_region->ndr_mappings; i++) {
>  		nd_mapping = &nd_region->mapping[i];
> -		mutex_lock_nested(&nd_mapping->lock, i);
> +		mutex_lock_nest_lock(&nd_mapping->lock,
> +				     &nvdimm_bus->reconfig_mutex);
>  	}
>  
>  	devs = scan_labels(nd_region);
> 
> base-commit: aebb7274476403040d582c61478df8f4a7bf9cd3
> -- 
> 2.54.0
> 
> 
