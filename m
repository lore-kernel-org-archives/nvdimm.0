Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=192.198.163.9
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1795118317;
	b=cYJepgwh72roS7OY1AL8JQHrWGX0fi5TqiDAQKmxFMrDzq8Ymryp9EzFzNaWa/a8dDVl
	 XWJgVW5ctYCoNJMSasckhw9h/uz1MYeOZEGDvnO0AKbQp0AnRJJ/DOmlYm3T/le49ihXw
	 BmY6VMYA/vp8xqhePJu05hSZ7h/Pj0EacqOvbPyhT667BWJP2A8xpGsjsJDbxqegH4eXe
	 TGwvh2Pnka7vVrUo0E4R5PGQwk2e/KGsPl+5IyDbKghabPtIvTLVbhF04+YiXowfT12gn
	 q/nMH+NSVpE8P+G2HnaG8v2XBhflBu6K7a/meacV52ApUobI/pQCDMLGF3spzLJ5/cg==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795118317;
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
	bh=YJMOIlt8HKQ29D4upTnDPH973nfqHSe5tJCzwZ/5zBc=;
	b=shxe4N3E6QVVoq8c3XnymmQVRDkSeTT4QytZOEg/PNhie5b8MUqzWSfWS7Iao6JxEK36
	 +BXPqkb4mTXYsVxUNDdl0Eep3qztsyhwq6q+Sy4nX3rJMQu7+myJEwCSqhY/LdeiPpOSy
	 r8zLLqMsVhmTfhXKgpZUGLgRSnMNt6SMvCSD4MNm6kIdz8HhjjNLf2HtzhzpMXAtwFnp+
	 wj/NPt3R+hgrc24ErxOsS4L1j2aGsk1Y+na/y4g4fEErD0SEZA+ccjoRaWWBHXlo7s7MG
	 kj9+N8NLTs9Yp5xHocxqf3arcpFLO8Qq8cAPHvCBjgiQ+bhB4WOqsOtVJN4cEoF+SWA==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=intel.com;
	spf=pass smtp.mailfrom=intel.com;
	dkim=pass header.d=intel.com header.i=@intel.com header.a=rsa-sha256 header.s=Intel header.b=BYR5n9YQ;
	dkim=pass header.d=intel.com header.i=@intel.com header.a=rsa-sha256 header.s=selector1 header.b=cKWSMLwq;
	arc=pass header.oldest-pass=0 smtp.remote-ip=192.198.163.9
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.9])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8D98F606A320
	for <nvdimm@lists.linux.dev>; Thu, 19 Nov 2026 19:58:36 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 8D98F606A320
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.a=rsa-sha256 header.s=Intel header.b=BYR5n9YQ;
	dkim=pass (1024-bit key, unprotected) header.d=intel.com header.i=@intel.com header.a=rsa-sha256 header.s=selector1 header.b=cKWSMLwq
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1795118316; x=1826654316;
  h=date:from:to:subject:message-id:references:in-reply-to:
   mime-version;
  bh=zoguE5TyCf5y0SzZMomETYoXXe73ojZ9Hf2/xItG15U=;
  b=BYR5n9YQcvJLY9Rr/5R18WlzQojg/wASdoOeha4tiCFk/FtK+EkpAl5X
   HrdQrGPplKbgy4j6IWx+mHVPL6R6mk05nwxoB24ELteMVzoYY7wcC13nR
   TLac9IUO30tZ38EFBks/KFIS9+Z9LrjXrh95LOTndQt9hGEjEondDa9G8
   1J4BW9tPBRa9ncEvTDC5K8tUv1++qzctyMn2ueeqUWHQWiQJa7OxOrCZj
   PPgmRsmUBRRlOeNvwl7RMQUFsE9+OS26cyNkSqsruxMMm/cPxpFDqoTKn
   +2/mK90bG0qtU7+WaGXwBH+D9LTF9tp7J0ZkRoE2z23cJYbkhMeM9OEu9
   Q==;
X-CSE-ConnectionGUID: rwN7ih06Q6aOmNGYQ1ZbCQ==
X-CSE-MsgGUID: 2/rNTRc9SS6yYwhnOP/hbQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11971"; a="3870383"
X-IronPort-AV: E=Sophos;i="6.27,221,1787036400"; 
   d="scan'208";a="3870383"
Received: from fmviesa008.fm.intel.com ([10.60.135.148])
  by fmvoesa103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Nov 2026 11:58:33 -0800
X-CSE-ConnectionGUID: rR3izlRdTgKJvpoUHgBElg==
X-CSE-MsgGUID: FggBp2/yTBiVp3tmthrWtw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.27,221,1787036400"; 
   d="scan'208";a="10775503"
Received: from orsmsx902.amr.corp.intel.com ([10.22.229.24])
  by fmviesa008.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Nov 2026 11:58:31 -0800
Received: from ORSMSX903.amr.corp.intel.com (10.22.229.25) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.56; Thu, 19 Nov 2026 11:58:30 -0800
Received: from ORSEDG903.ED.cps.intel.com (10.7.248.13) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.56 via Frontend Transport; Thu, 19 Nov 2026 11:58:30 -0800
Received: from BL0PR03CU003.outbound.protection.outlook.com (52.101.53.64) by
 edgegateway.intel.com (134.134.137.113) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.56; Thu, 19 Nov 2026 11:58:30 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Rr4ITp6UKiygLGsJ38yuqy+OTcE9qMCMR3jLEYWcG0yIuDQP+slenqZrHHVucEWDTHs01WMZYT2+CsWHgLpeFicV9aTJGpwR1QcQvux6QCXLZPOv0TZr5tGyjhU9HtfrbRPicaS0OvtGT2fXooaOHNO6ziHSM24BEtI/Ry/zU6kNUz3Ec+Nu2jHBNYDbnq1GEWXSWziArgblW7Ls3mJDMjpBdMXxLC9B5QyzoR8tjflij9uqNzwG9mUyeBzt1PJNCeIm1r8qCyZ3V8d+1shzTrmtlvS9qaDaydMTnSRYX7kL5DRpEWg7q+DNKFkYGQPGLWxTxXDO354nkOMQcVPwsQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=YJMOIlt8HKQ29D4upTnDPH973nfqHSe5tJCzwZ/5zBc=;
 b=yHaKaNuxt/uRqKblalq0HnFtd/OaqkNKDjelcHvQ5qxEzoijcSY0qCDf9udvBh6jtp6RnFBmB7P60ivUOOEj28eIZtDSmqSnTqlMvqW/apmhjKVUNTcJ0qMomDCiEx02UFx32PdZYrzTbeRDlVHk2cJmEqSt4ZDguOhd+c85SX+7MvFNHZ1RymLnGuD6fbLDIg56mT8jhrkSOjcni+5OLHQkfDL1tB92+V5lTmwMVumwH/W0ElUenH1z/FeOX+Sa3ZKogMgSKMJWG9y6+c+W3g1WR8/Imftk/2w+vOIOdM1rTBdOp2cCE0AtHh4mUWqRtVMUCJuNrkLJ887PVZQKMQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=intel.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=YJMOIlt8HKQ29D4upTnDPH973nfqHSe5tJCzwZ/5zBc=;
 b=cKWSMLwqZtGOdjfVaxtavC4LbVVWlJop7nnFbCUVwysiBIMom4iMqntj8dNMK5ufbM6N0lXbWpY4NcNt6r53nw1TCjagIY5x/DVCi3KjZmZjr1dkb6pC+YXWc1eheJYKnDkWLJDDm08uHZZrcrpsf8MAUUdMkDs+p+n3hRGGtRg=
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DS4PPF0BAC23327.namprd11.prod.outlook.com (2603:10b6:f:fc02::9)
 by SN7PR11MB6899.namprd11.prod.outlook.com (2603:10b6:806:2a7::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.639.12; Thu, 19 Nov
 2026 19:58:28 +0000
Received: from DS4PPF0BAC23327.namprd11.prod.outlook.com
 ([fe80::6fbf:c112:d0a8:f1a8]) by DS4PPF0BAC23327.namprd11.prod.outlook.com
 ([fe80::6fbf:c112:d0a8:f1a8%5]) with mapi id 15.21.0615.013; Thu, 19 Nov 2026
 19:58:28 +0000
Date: Thu, 19 Nov 2026 11:58:24 -0800
From: Alison Schofield <alison.schofield@intel.com>
To: <nvdimm@lists.linux.dev>
Subject: Re: [ndctl PATCH] test/common: make kernel version checks RC-aware
Message-ID: <av9U4HzAQnFKOjPc@aschofie-mobl2.lan>
References: <20261119023451.165214-1-alison.schofield@intel.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261119023451.165214-1-alison.schofield@intel.com>
X-ClientProxiedBy: MW4PR04CA0108.namprd04.prod.outlook.com
 (2603:10b6:303:83::23) To DS4PPF0BAC23327.namprd11.prod.outlook.com
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
X-MS-TrafficTypeDiagnostic: DS4PPF0BAC23327:EE_|SN7PR11MB6899:EE_
X-MS-Office365-Filtering-Correlation-Id: e21b6c5b-b671-4290-28f6-08df46777a47
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|1800799024|376014|23010399003|261009223027099003|18002099003|22082099003|261026140227099003|261028144727099003|261022075727099003|261022105027099003|261021123027099003|56012099006|10067099003|11063799006;
X-Microsoft-Antispam-Message-Info: 790ngkOe3WcMn3dIOJFxOcvoq8SiUwrCshgxKz7EcEqG6EZnhw4tuYTZ4RsXMzQ9omYVXimCA+Xw2n7njADWf9qXQZNSH9nDfSuIj0rPrN/Shbul2JtwoBRSd+fkciCTg1IrNtCkmhiO+rpA+HnFCjTbkNLUM58JM6YoA556tWejaNcvXfZIHZx1Y8gXpN+rwPR+r5YkoPHUWvF9/IZDcLdm0Ko/6iKfTEbMIoQUFumXCBvL405DsFus35KqzHyjYaxPMI+rLEwvc6N/DpKIWV69VAQS4vrKvqznazmjNo8g1mjPPQ4zG8VBEIWQfRkRQdrOu00sS02MzqameZO/+G/42nBat6zfAdVWj01ow6NnBv0t8iFc2QCc70hPV9pZFjFNrVPK8DpxvFc+YqR12uRMHSyG4ukUGv5OVbqGNKWYdycgEtbVxYiHIjzxmvO2LZeLc0J+tN8Q6XKZ4/2F8muNp7+loO3d+9XTvhT+buaz5BP9Cw4MoYmOf/CiqtIO/RwHgmmzH1dvbUP514E3nLly3KDdMhvjI6DoPbNZogrR4bOWEAHlzCdsjh1qgaHWHOz1YXVkfNIxO10c7i5hSSSFKRMCAQjOZZCYGTEEntihg/nfu5WpjnjF1k+6FIP3ahRn91fSUE+h9w/Myrhb4b9jPWYaX6hfZW2WFa0Dzr0=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS4PPF0BAC23327.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014)(23010399003)(261009223027099003)(18002099003)(22082099003)(261026140227099003)(261028144727099003)(261022075727099003)(261022105027099003)(261021123027099003)(56012099006)(10067099003)(11063799006);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?8+LTNSg9kaF5SaCsLvr3sw8WUkoCamgjgqJi3+EuClaBGoqa2tZI8ViOJXvc?=
 =?us-ascii?Q?w9gsAshnbR6npCljat4tEHsvC7MYFt6JjgIRRNGYCeYADtEuu1/LAYYfJf7M?=
 =?us-ascii?Q?R4d/aItI4BnU08E/IhvC3x1G697AGon481+W9uI7zn5iTmZ33b4gvpKEd+L1?=
 =?us-ascii?Q?24ah4fWdVvSdCvsufJGOgn15u+Sj8ky1Ya24Z/90n1O2XhxZGJudlEKjEUZU?=
 =?us-ascii?Q?6sV777rVmXdK49WjHlGd39tLiNQZ1FkI3mFntyddR3zJHghCRAEinVWBu/l/?=
 =?us-ascii?Q?cMiTgDcgvJAJ1kSn5NOPgRKhyHdSyrqi151J+UM/kRBg16EcwbUDiDXBUiat?=
 =?us-ascii?Q?K2lLJdpVgohHO4wvrZEqlsYy6M8/2L7rr+n9Bn+/WMoYPV5LUXI05xCmulmq?=
 =?us-ascii?Q?Dq7GQlgKVQ+iIyPQrgPDS9lmW26Iy6/rykLAT1a6bPjEE0NZ3a3LzQX+nb3e?=
 =?us-ascii?Q?OqjZieLOQaxCqya4s7SF57y3SywIPFd1qwzMw2DRv1hScFSW0aJdEqpJo+XD?=
 =?us-ascii?Q?1GhYd3lsd7no6iXnTyBLtCXCcdI9I8vxEqOHB6cqxJ94vPVLqCR1X8QofDxn?=
 =?us-ascii?Q?2lICXiB198YtMtcLcmwDyfIKned3+gJep0HQsUYSdkqw9T3C4Z4ZXqVD8gCM?=
 =?us-ascii?Q?LWg+ohF1MqNuUXMcE9JebhXh/jTnRULPdAqxJPlLv9dFQ+8nqWs0D4G7Ohwv?=
 =?us-ascii?Q?Vyhbs9ybTCW/53IxBfeTnDDWwrNimA66EXjbYAKV7zTN85cuKwM+S9eESXgv?=
 =?us-ascii?Q?zGqRSwv6FUt3OtuUahZS+UYPwspQyU2F9tZBUzx3QLy23bnuky8RFC2Z+ao6?=
 =?us-ascii?Q?pspJ1D5kWsZupV9MQ6bFts8IHUk8cDKKAMESOrbj6J5yAGQSitIUGFT93msV?=
 =?us-ascii?Q?LbirkWCAiYafpzQOMrdr1HnpvSsqd0DLJYJLzl5z6hBbMOBpeX0g03bXC8w7?=
 =?us-ascii?Q?rHniPKdPho/TRx1AOQ8LDygiPWrCepkTRjaTe3Ltf5SArEBmLz0fvn/WOSKm?=
 =?us-ascii?Q?xaig/HiZeMdWjzTUIGZRmbv8OrCEnuWBfDMwGvegqrbo7GzxLYln+qhkbn+R?=
 =?us-ascii?Q?9tLTQd9/Z7vUuAR3fwY29dCvBa3oonUNJsuFpudZCuxzSgjdb78AJZ5GRwM6?=
 =?us-ascii?Q?ZfxzrMlYOFkfSBnu0mquQlzdvIzYSuiKdHVMqjxxiVLNxPkQ6lqy+hjniHsh?=
 =?us-ascii?Q?L1+quY9zadACpGRQv512wzWLkwhr8+U7bjwoMH+LKlgIdNukGoHo98XvBMCt?=
 =?us-ascii?Q?ElhqgiO9+nfvdSoUMl6tXw4+06R8Xjzi3fn0NeBhehzVTHKHbiss0HoKi+3r?=
 =?us-ascii?Q?pvWoN9wKUL/PkzViZxhf0JshIfrAhv8G2EmDkMJFopBTlDw9imSS7QhzB7wb?=
 =?us-ascii?Q?PSMxGBTTMOIOVTuDW66+uCoof/5uN1vN6o8K0hbUh4pZmNPWV6doVBtFtCou?=
 =?us-ascii?Q?KI1PT+zjZZhb0Fj2CEEU401OhBNC+eCm2nZ9hhV4RzihjZpgHqoWc7SkDJ5U?=
 =?us-ascii?Q?qfrgGSBfY36R9GtcNB5Uz8iCQWxQvWs+1WGHPPo5nzZImpHCIM9E3bAvVmNg?=
 =?us-ascii?Q?OYZ2Vj7F9WpTjo7qoGF065cxlOuKNRaJrrj5OzDKN4C+QVRzUigzUbUXczx+?=
 =?us-ascii?Q?JXVsViYpsEwNQT5HCsZ0/MBtTWQuPODBrg0YpmY/NrdcZcZvyWLReTp6Oz7M?=
 =?us-ascii?Q?hYdRMaiYMQ8aSBKI1EJUGeNet3ZDcM83v1fo6AF51pdyCGENukZzAEOuTXrR?=
 =?us-ascii?Q?sBIjyMxlNfDxHLZ7ufuXB997Ls6jYOA=3D?=
X-Exchange-RoutingPolicyChecked: 0Yl5tjdcnr0HV4WNhhvRZ4yL4iA+DVZUgf8CwH5fGYH75SLIYa9loqRtOmg5pJkk5yyxUElppgGGf9G7N6c9CHOQFHwUu8GBxurYXGDDIa2qSXJE0wZmzXo4cAxmZB6q6iIaWTk4IZqM+kFoUAS8/62LmvEpVuk01xHa8AlH3ZpsziQgEG/Td9wh7ilRQe9y5JTisemcy8e5Ebwd7W1vlJ2GIFsdiJ88PBF81PMOY+L9HEj6fJRbqdwh8HVScKHEAH+kYez6zxjTPpA+FHpCV0XWSCoYACJSyqDbZLt4qkcTVyaKGUzZZqHLOcLy1+ioumQdmmwV23Lsvp5o7TUYCw==
X-MS-Exchange-CrossTenant-Network-Message-Id: e21b6c5b-b671-4290-28f6-08df46777a47
X-MS-Exchange-CrossTenant-AuthSource: DS4PPF0BAC23327.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Nov 2026 19:58:27.8772
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 8QnqJ8lHdPQufO0GMoKSfngSxQ6JmQvgvDk/iGwNpkKHhgDp/Bcjo0opHlt+fblYRsq/jA6POHlasfvC5Rl3IARNdMMOmMTHB/04acF6P2o=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR11MB6899
X-OriginatorOrg: intel.com

On Wed, Nov 18, 2026 at 06:34:48PM -0800, Alison Schofield wrote:
> check_min_kver() ignores RC numbers. When a kernel fix lands during an RC
> cycle, tests that depend on it use the next kernel release as their
> minimum. This avoids failures on earlier RCs but delays CI coverage after
> the fix is available.
> 
> Honor explicit X.Y-rcN minimums so CI can run a test starting with the
> first RC that contains the fix. A bare X.Y minimum continues to accept all
> RCs in that cycle.
> 
> Signed-off-by: Alison Schofield <alison.schofield@intel.com>
> ---

Applied to pending for NDCTL v86
https://github.com/pmem/ndctl/commits/pending/
