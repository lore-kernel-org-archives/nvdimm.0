Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=198.175.65.18
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1794947864;
	b=TjjucuTHNz5cchkWfk9QTA8eGdBmdTFPWVyeq9fSzNdi93tFF5bRWxofX4/MUbh+mjrC
	 7Kcw7UV/VH+eIhROS1rP53hhNDRE/vFvfubfL5xyU3UeCoFmsGFp0iFw3LQsh1Qy+dn2/
	 +sCCy+Jx5sfczB1zBrFmWK0J/Zm34hye1p2DQxsnpo9MvnibnGZDCOZ/5sDbJ9XJqR0kC
	 cEpvp49aX26Pu0V2VSUH50tbIZoD4tIcS08TiOi3RWY9Vrs+Niq68XC2362VEde/nUQ1E
	 K4GF/ak/XWnrq7BOyGB160VDPAjUuacq5dRw54fbdTlLtPrE8i8/nsEa1jeejC4SFCQ==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794947864;
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
	bh=+iKKR6VD1TCYCRsHLVc5eR9z+sNThDeI51KTnKmWK1s=;
	b=zriIJYSxg2djbbQWQXbASdz29pPWOhu1FpUeuUIRBL6woe/DME+8l45dyPiW8BBLDkba
	 PhHMgH6sJKYv4kZ+DzfmKQ0AjzZaxAkArb6Q0ZC47ieGzz3Hn4kb4fZrvB2NfyHXVrzlB
	 BeszbDTLmxKW/SiPzvTQZdbiPPPB+ecr8MGoF26Qf9400uh6syinMw3KEHxDa+mcuiv3x
	 1Y1Cr/+wh3wbeVrDa3YierfHDGaLIzhBbquK0L46FnL1I8XpIrt+cO3fbYwU9Z2wGgiJT
	 DDrw6p5tTz12iEZ4Ctr/96HPO1sdcPSrfSLxxefRhNhUfzjX1dJdz25pcnwBLn6sLXg==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=intel.com;
	spf=pass smtp.mailfrom=intel.com;
	dkim=pass header.d=intel.com header.i=@intel.com header.a=rsa-sha256 header.s=Intel header.b=jtVIwg3F;
	dkim=pass header.d=intel.com header.i=@intel.com header.a=rsa-sha256 header.s=selector1 header.b=KmAzRmP+;
	arc=pass header.oldest-pass=0 smtp.remote-ip=198.175.65.18
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.18])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 06A27606A31C
	for <nvdimm@lists.linux.dev>; Tue, 17 Nov 2026 20:37:42 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 06A27606A31C
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=intel.com header.i=@intel.com header.a=rsa-sha256 header.s=Intel header.b=jtVIwg3F;
	dkim=pass (1024-bit key, unprotected) header.d=intel.com header.i=@intel.com header.a=rsa-sha256 header.s=selector1 header.b=KmAzRmP+
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1794947864; x=1826483864;
  h=date:from:to:subject:message-id:references:in-reply-to:
   mime-version;
  bh=W7gbHBn0aqFp4UQYfGih/QqHvlD055i6n7BeQUGHbv0=;
  b=jtVIwg3FfLw7CDyhZh63b1E10Cqwc+QvZO6zeHaml38TEM4THuDSO33M
   f9rfUpvi/KEO1bgQjFXHUBQrNzdedz1Y4IDbjkM4ER78RUoNrKdK4MB4/
   0ckroVSVErEMi7bFV/YbOQapOJLDDHbW11gh/pN3c6XDW3CeDfKMq8qMb
   KClDK2IKgB3LkEQcW89g/eCsH8hvhkGeVe82vWY52J0cV4jU0ohnboVIg
   JuJr8o3bfJAPMXq+InENnmC+1fGkFrOLNOO4U4Rd5pCIGB14hNHaqYRRR
   4hBPcjNIeyQjT324f+NZrxvPQbo5bn3TJu/vUu0YKl7/RbEi0Dxn6zEoc
   g==;
X-CSE-ConnectionGUID: SIMlYTXuTrCU899aEUlyrQ==
X-CSE-MsgGUID: m8SFgVv1Qw68EuJd2nheLw==
X-IronPort-AV: E=McAfee;i="6800,10657,11969"; a="3758183"
X-IronPort-AV: E=Sophos;i="6.27,218,1787036400"; 
   d="scan'208";a="3758183"
Received: from fmviesa010.fm.intel.com ([10.60.135.150])
  by orvoesa110.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Nov 2026 12:37:43 -0800
X-CSE-ConnectionGUID: c3PfNDRnTBy3br4LJk+j5g==
X-CSE-MsgGUID: gpKhK7/dR1Ku12Jqy5sU0g==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.27,218,1787036400"; 
   d="scan'208";a="10459472"
Received: from orsmsx903.amr.corp.intel.com ([10.22.229.25])
  by fmviesa010.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Nov 2026 12:37:42 -0800
Received: from ORSMSX902.amr.corp.intel.com (10.22.229.24) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.56; Tue, 17 Nov 2026 12:37:41 -0800
Received: from ORSEDG901.ED.cps.intel.com (10.7.248.11) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.56 via Frontend Transport; Tue, 17 Nov 2026 12:37:41 -0800
Received: from CH5PR02CU005.outbound.protection.outlook.com (40.107.200.28) by
 edgegateway.intel.com (134.134.137.111) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.56; Tue, 17 Nov 2026 12:37:40 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=BPWXrmlSU8XFOpG903uBggq2ZnKJxLYWyJHfBeQXjXiISxfSUSLbxr5FvF+4mu/6NXtM5+ipWtrXA5AMrZxJE+F8IRHa4YIf5HR4i2lm9OsTy7dZdvzNmn3fnzIXidT3tvcES1/mrp1mDSS7RJLIcMxt5mEqCPV3/eoG7/whb5M8YYF6G9WmE3gQ4lz6z3xzSsb8T5467jkqzD6nuOhyi/kK1LRXUHq8yQvqH1ulMqsA9we9c2BYzGznCK3IeYFzdNLNyZLjfLqOZleetbEPtqmigCvL2xgynIVSIL2Bdp7hKnsmrwM1ijQ5mokX+Ams0TBSTG0SKvkJyYlkLe14IA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=+iKKR6VD1TCYCRsHLVc5eR9z+sNThDeI51KTnKmWK1s=;
 b=mUxs5U2gS63iQWNLTk85CFtdvNH1ABXScQEx7ae2skZZf9t4eaAFTxNvJ382GOxHiWB3b2LFkL4WZFa45290BUM4j5pD4r4gBb4NXOPp402CWKhz5XONu3oLvf8g7vAE+3gdqaC82oN1+fjMj/Fqiw9Zu2xTJEp3Wew8PXP0moDfXqst944lBf7A7mo8zx+jCX4pZ7HSJ6YREu1ATNLRErv/Yit1prPl5473sN8ExPceFu2SDbjKpg9KtK1iOogh+FJ+hzqnDCgAhJQ+dPiLEP3Zf6xXso6duGTIKd+8M3AzF8jHLgU+WweLXP/LxETWkF01i+UkOuHzUa/uD5M8HQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=intel.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=+iKKR6VD1TCYCRsHLVc5eR9z+sNThDeI51KTnKmWK1s=;
 b=KmAzRmP+rA2hOC/cyQSP4QpgAzTtRPREL3zXlaTFaO/RKCa8PYCpKidRPIZDm+LYcPVKI5/CGtDbzE/mcdlWxD5acAiNwMqtQSj/eDkZkuz9NEpMTm2PkQSgHg4dNJ+fZrpZjtoV2OY1ef5frLoDg8c7qiF5kWWr+Lon9NzLUjE=
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DS4PPF0BAC23327.namprd11.prod.outlook.com (2603:10b6:f:fc02::9)
 by CH3PR11MB8546.namprd11.prod.outlook.com (2603:10b6:610:1ae::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.615.10; Tue, 17 Nov
 2026 20:34:33 +0000
Received: from DS4PPF0BAC23327.namprd11.prod.outlook.com
 ([fe80::6fbf:c112:d0a8:f1a8]) by DS4PPF0BAC23327.namprd11.prod.outlook.com
 ([fe80::6fbf:c112:d0a8:f1a8%5]) with mapi id 15.21.0615.013; Tue, 17 Nov 2026
 20:34:33 +0000
Date: Tue, 17 Nov 2026 12:34:29 -0800
From: Alison Schofield <alison.schofield@intel.com>
To: <nvdimm@lists.linux.dev>, <linux-cxl@vger.kernel.org>
Subject: Re: [ndctl PATCH v3 0/3] cxl: support region granularities finer
 than the root
Message-ID: <avy6Vd-aEzBqmZC2@aschofie-mobl2.lan>
References: <cover.1791863817.git.alison.schofield@intel.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cover.1791863817.git.alison.schofield@intel.com>
X-ClientProxiedBy: MW4PR04CA0381.namprd04.prod.outlook.com
 (2603:10b6:303:81::26) To DS4PPF0BAC23327.namprd11.prod.outlook.com
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
X-MS-TrafficTypeDiagnostic: DS4PPF0BAC23327:EE_|CH3PR11MB8546:EE_
X-MS-Office365-Filtering-Correlation-Id: 9d55a649-74b1-4b9d-637b-08df44ea302d
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|23010399003|366016|1800799024|261026121527099003|261026140227099003|260925021911599003|260925022911599003|260925021311599003|56012099006|11063799006|261021123027099003|261021121427099003|261021135927099003|261022075727099003|261009223027099003|261022105027099003|261102123227099003|10067099003|261028144727099003|6133799003|18002099003|22082099003;
X-Microsoft-Antispam-Message-Info: ABq13PhdlcK2LQqfNI4s3G+mtwpg/oowI2X+BRnBe2FLFCeBV6NNlSZtm/TKBx1119/yncFnLi76TRo+iuRNGpVx9KdKoVaKccbdeAjLBPz8g3WWDdn2c7r42FUyqDRbHe95UqhKTSKMlkCTasTXilOVOFmEMT/EW+e0+TlOYxYA/IdxrpFZ1Usr92zTClxvKb2HtqIWZ9LappE4V7j5lhmSsKAbLZTFlohuDWknLlLHuqXYWd0xFlFgU+Aa5vYG2mFZSNu2BCyOlPT7ER/LUR/c53ZQxWiREdNJGx7h2rDbaJHzDNtP/Q4xlQt2p5b/mU4851AIc3a3RtJGvkp+PM2FRzy8/MsRoQaMnjYUtmxpRNMIqeFp6975pRVfpbBOtLx6EbeGZYRTP7JWOYio6KhBs1eIH91EOQ4Vrohaqriqn7taJiONxMzrHN9RCUq5uyCk/X/5zLygmq2uELI6P6E3MlG4yT2+SS1Oj0WnRuTa/AF9lOM32T0RddAdvU18tARJyi4r8G3oYxFF6bvM+Jxyti58EJoKJyxoRI5yOR1z0NSokCTJCQXaecvR3Nb7VgU851egmNZ+0cdxE2hwglfaxA/Xa06vQ2CzzP/MKFWQvsCUpPaiowWJgtDQrafa
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS4PPF0BAC23327.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(23010399003)(366016)(1800799024)(261026121527099003)(261026140227099003)(260925021911599003)(260925022911599003)(260925021311599003)(56012099006)(11063799006)(261021123027099003)(261021121427099003)(261021135927099003)(261022075727099003)(261009223027099003)(261022105027099003)(261102123227099003)(10067099003)(261028144727099003)(6133799003)(18002099003)(22082099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?6b5Kk4wiXl/l454I+N4ILaBa7B13erMz/haGupJEdvqf9ikE2sitwm8Quvl2?=
 =?us-ascii?Q?mopN0zZOlcuwV5WZJ12iN89OG0IZg2SZq8P/unrt4/+nxzvmKXEFxnCcq97I?=
 =?us-ascii?Q?syXqzUbyPpI/+m204DZ9mXIyXRxAxc2DGKB5TZ6hyd9P7sTrKxhSCT2tZUzx?=
 =?us-ascii?Q?B6GTnfSSEhHhyGCVp6PC07QjTMXdTyKKg7s7P8/0dWEBm5RYuutGVqjQy80x?=
 =?us-ascii?Q?3ob0a17Lb1J4MM7RrOS5WSe/L7zkrtVTOi21LeGjiEFguQl1KQtmOB/ke2VG?=
 =?us-ascii?Q?LSWqG1iTmcBDccS0fqxeIXn/XHXW0/cSeVs48MYSmBgkPkMlMbhJPLiIT+ZT?=
 =?us-ascii?Q?DkfWzmfhde/pdO9+SaaSvXz0/J+B9GLXqh24rk4sdor9IML6QfE8+f8KKSnW?=
 =?us-ascii?Q?wOcP8fkCe3LsLhrBU0mKg0KIvVUmpnQ0t8W7A40bK4b+x71TK1zCteUFZQjl?=
 =?us-ascii?Q?a+DqWVeDD8QH2ZUuM5sLikA4R/W7QwjgLJBBEs/qGvm9whwPkFFVrBKDcNZ9?=
 =?us-ascii?Q?kGWfWT59uL1FcPgIfohFtu9iemVmSzVIPH55NilGD2/IHKb5AdmeQfl7geWJ?=
 =?us-ascii?Q?EEYpaSleeNVJNLZkDRHVfEzmUaNAr2vigmdVl1temg1ijbS6BIu/YbgIBx1D?=
 =?us-ascii?Q?Qh33zLu7h42q0R9fBYGcR9ren6kQCcqhVbYxJ6MY6Kn+7yYOe9c3P27km2VT?=
 =?us-ascii?Q?8dgZ5ZMrM8WuH/9ovn/KPNSw2kaBzKUps5iiPalxWNq4YguC+9m71VBNIIVV?=
 =?us-ascii?Q?oIy3fniVaRBe0ENzwvY14DgMR3l9f4KUtClcSGRlHOWkXJTgQpN2aXxWqQUl?=
 =?us-ascii?Q?hxACsApU1PvNnCq2caNvzp6zcsWiNRnb/VrwCzqOsD6MRE1VT8x2USC32Wqf?=
 =?us-ascii?Q?guV4yU1FHdMeeQ8trhbDA6xywDMrnneT60rddTJTXOO8CLbGIPbnQRSIWDDj?=
 =?us-ascii?Q?41+gTBs9/8mJ3iofrWe/yzAoacgmhGyNCiIVesfW4GC605UnSTKyVrKTRF5+?=
 =?us-ascii?Q?y2g17ifX4w/+7EsBnPELWg19DTzwe1uZ1OBMOAfB2J6heXLreB4dN0u8Z61C?=
 =?us-ascii?Q?EIJ2YPQi83NpvD3fCFfS3l0dcBK5mhQHc6GoeiLJQRdBfT2U+ap4oDP2h6o4?=
 =?us-ascii?Q?33TAqC90iWDc5KnHA+P0s47C5BkP8fj5DWpIcZmCHOdw02qMoE7oYT4MYz74?=
 =?us-ascii?Q?d3dsl8mAu3VMpZwPDtqsTng3asJVg5EhNID46rfLjOS++haSUL/+94rOZwPp?=
 =?us-ascii?Q?xouKXQXncKSVmwoeJjKF+itPZGGiXB8qW/+0WaY1Qk8iNtL9uFmjoBOUzfT+?=
 =?us-ascii?Q?Htyj4gmmBovIKNnAK/xeAb14iBHK1MSeLsWRSXJ9xaCyQqPOh893eR0+2EGo?=
 =?us-ascii?Q?Ox7JVLf+UO4Oh5/TJBDxN8yfmzm/q3LI9O+OycMJsytv/hvagkudSUdb8cGL?=
 =?us-ascii?Q?N3ctumKFybnB/QmilN6ibILJ+jjGYgnyWO+s9PYR+4jUhX7iYeyJUamk3NqQ?=
 =?us-ascii?Q?EQLKNnBueufuB3vdJvZ9mh8hDVIdGFyMcLGgMG1QCveR1vnFAAo4axymkvTY?=
 =?us-ascii?Q?nEnOBZ5b986KmdAq+47/kHl/bLHE148zesPHKRpVJHvvkBVX4lxe6seupRBc?=
 =?us-ascii?Q?eyxR1x4DlPec+viF5tDJgYUh8GNdBr3SUDKlTH8gpTg3Mi2zGcX7BBUET0FN?=
 =?us-ascii?Q?yDiQGcHy1pbSfMW1vikHTSfyWCWZVV+iwxNym8vgmOXHdtHg+MxsaOXYhC3c?=
 =?us-ascii?Q?tZm+StdpFjbWD0XAtrrs/jmMq7twuh8=3D?=
X-Exchange-RoutingPolicyChecked: HpLVJVi3KN8SEBB5j4mjYwK6kfpJiqWpbTnZzUxRAciZw8x/xwDvszea2/friKeOfmEWq7W025Aa6q1JBlEePmsgWDLdObzD3zoy4f6gmPuhrY1EWlL4JGr4j+Edmez5WBDOXiRIrdYWFlhBA9gZtQWcWczBIcq1Ub5NH/kVEZ+aPZujOOPbJTiemQiKRPjlWv+SwniTu5iCC3PchyaaHVMQFPPLXKxLRnEmPEKSFN84E3elTRx+TBHfVm8jQTZKA7gtzReXcac+go5UQHMm43+LvLQ3q9sQTHFUZNVYLH4H94pyOhqzuQjjykBUuc6g1paTl3+tpxyhpEZfq7sGPw==
X-MS-Exchange-CrossTenant-Network-Message-Id: 9d55a649-74b1-4b9d-637b-08df44ea302d
X-MS-Exchange-CrossTenant-AuthSource: DS4PPF0BAC23327.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Nov 2026 20:34:33.4791
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: U6OhJ+gs1p11DeOpEBiIvTNru/ZN4QyzAyS0D5dwFyBURFmZlM9sozUz5XtdbzXnoOGKw5MxWy5iYmQmcG2aaNZuprbyO/UMxef4EVM368k=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH3PR11MB8546
X-OriginatorOrg: intel.com

On Mon, Oct 12, 2026 at 09:14:32PM -0700, Alison Schofield wrote:

Applied to https://github.com/pmem/ndctl/tree/pending

Note that pmem/pending runs latest/greatest to keep pace w the cxl/next
kernel branch.

Folks running cxl/fixes or any other mainline branch can expect two skips:
16/21 ndctl:cxl / cxl-kunit.sh                     SKIP             0.04s   exit status 77
17/21 ndctl:cxl / cxl-region-finer-gran.sh         SKIP             0.02s   exit status 77

Holler if you see any FAILS.

> *** Use to be cxl: Support mixed-granularity region interleaves *** 
> 
> Changes in v3:
> - Reframe series to match kernel series which now describes the feature as
>   region granularity finer than the root, refining monotonically toward the
>   endpoints. Drop the term "mixed-granularity" from the patch subjects,
>   commit messages, code comment, and man page
> - Rename test/cxl-region-mixed.sh to test/cxl-region-finer-gran.sh and load
>   cxl_test with the renamed finer_gran_regions module param.
> - cxl-create-region man page: describe the levels below the root as refining
>   monotonically toward the region granularity, rather than interleaving at it
> - Patch 1 is unchanged
> v2: https://lore.kernel.org/nvdimm/cover.1788469004.git.alison.schofield@intel.com/
> 
> Changes in v2:
> Patch 1: cxl/region: round default region size within root decoder extent
> - New patch to fixup the ALIGN_DOWN usage that doesn't always work
> Patch 2: cxl/region: allow mixed-granularity regions
> - Reject a granularity that is not power of 2
> - Update man page -g section
> Patch 3: test/cxl-region-mixed.sh: test mixed-granularity region creation
> - Cover the third pmem window, a 3-way at 1KB across 3 HBs
> - Add two test cases, a 6-way and 12-way, for more spec defined coverage
> - Select endpoints by walking hierarchy instead of handbuilding lists per case
> - Assert 2 switches below each HB and 2 EP below each switch
> - Require negative test cases to fail at first target write
> - Skip rather than fail when kernel has no registry
> - Drop selector walk language to align with kernel language
> v1: https://lore.kernel.org/all/fa5c109f08824180f58341ebd9055545a2ff3142.1780099216.git.alison.schofield@intel.com/
> 
> 
> Alison Schofield (3):
>   cxl/region: round default region size within root decoder extent
>   cxl/region: allow region granularity finer than the root
>   test/cxl-region-finer-gran.sh: test region granularity finer than the
>     root
> 
>  Documentation/cxl/cxl-create-region.txt |  21 +-
>  cxl/region.c                            |  39 ++-
>  test/cxl-region-finer-gran.sh           | 413 ++++++++++++++++++++++++
>  test/meson.build                        |   2 +
>  4 files changed, 462 insertions(+), 13 deletions(-)
>  create mode 100644 test/cxl-region-finer-gran.sh
> 
> -- 
> 2.37.3
> 
