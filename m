Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2D8F022ACCE
	for <nvdimm@lists.linux.dev>; Fri, 21 Mar 2025 13:41:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.16
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742564500; cv=fail; b=gylHD04/IY8sISkrjEq3XYFlbVLpEADCGCvZm9UgJa8AxyOd+cHyGyW+LNhJbcd7KVygp7X9/5H+c66RJ6QZsAP6CDWnM2YHllnIV8x5MsbXZRBCJLz9AcxhqmQmDnD5S9PpXlU+MVbjrV5JTFhxRwSSM4M4lfufZK+oY4nL47A=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742564500; c=relaxed/simple;
	bh=1ldajKprA4POSjWwza+ySugY6calZzMTUIUjMSGF9ss=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=WRwZ7kctMHPE6o3jd/Lc40HCeEjWrszhtM61jw10Hd8r2RrBeUQK0YjhNPoenKaBSRZXkRrw/8+rNMV/5y7xW81hV7Pdfrt3K5VKpIpCGf930cXdyhsN/PqhG6vRUUljYBt4EOldhldjJ/hrO7xp9dw+AZq4oaq0/2AN7aDGKtM=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=aOPiWavl; arc=fail smtp.client-ip=198.175.65.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="aOPiWavl"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1742564497; x=1774100497;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=1ldajKprA4POSjWwza+ySugY6calZzMTUIUjMSGF9ss=;
  b=aOPiWavlDhN+ppMXtOd9lV6pi83vtzzY/wvrKH4IxBUKPjulvpxCo+V9
   Y2oC6zlZv/AzdPCj3EbVO1OujXN/CJ649FEcUz9u7jCXCBunsCakFMbae
   LD4k5pdcM861hRsDb7YHOaC3jR4PM96Nv4auroJQKS5Vx12ajvN9DTCf5
   uG7lDJHYkUAVP7vMLDvhdURR3Hsg5s91s4HMcsk1UGsSyz21HzmBaWzKG
   ueCKu75fCY4/sdaN+3CHhBuRHcROT/5+/+czy4HuskEjyjDJyLaX5Nq+M
   4rGatXm7A02YM2MX7kHR9zqO+Bv0xg4VqrzXs7MXnr4B08xlYaH5B7MTM
   A==;
X-CSE-ConnectionGUID: BgUaWG7MRwmflANZ6LoxSg==
X-CSE-MsgGUID: I1KLajmhRnGC9crqDmWwOg==
X-IronPort-AV: E=McAfee;i="6700,10204,11380"; a="43949478"
X-IronPort-AV: E=Sophos;i="6.14,264,1736841600"; 
   d="scan'208";a="43949478"
Received: from orviesa008.jf.intel.com ([10.64.159.148])
  by orvoesa108.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Mar 2025 06:41:37 -0700
X-CSE-ConnectionGUID: Qp4zOncnT3yMy9qSRQVb9g==
X-CSE-MsgGUID: 9HrQgk48STCRELSSkV6z4w==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.14,264,1736841600"; 
   d="scan'208";a="124347210"
Received: from orsmsx903.amr.corp.intel.com ([10.22.229.25])
  by orviesa008.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Mar 2025 06:41:36 -0700
Received: from ORSMSX902.amr.corp.intel.com (10.22.229.24) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.14; Fri, 21 Mar 2025 06:41:36 -0700
Received: from ORSEDG601.ED.cps.intel.com (10.7.248.6) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.14 via Frontend Transport; Fri, 21 Mar 2025 06:41:36 -0700
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (104.47.59.168)
 by edgegateway.intel.com (134.134.137.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.44; Fri, 21 Mar 2025 06:41:36 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=A/7mUQOK/Gx9XSLjbd1NpF1ZTd2EnubFurg5SeKp+uzHUAb6JA6Q+SDuw6ObViQlOIxI9NVKEMRIM+cc6q1EDnKonN/WtKsXxAAB+0IGjerrVMy3isFpQcJPKadYe31I58PH8EStg2/IbwIF/BC2OtJk/Mr6NWRY+AckqWSNeLlyd1IsZJhBUs0onD9TE3EQpP/jc7spRS5EAlGqekJz5Cy9CjW0G+Wyd1KrsG3wBmlSpJH4pdD6qCCc4u/2y2EZXhpTVamcqRXtrNED2Px43e55QMF8bbnqX0+iTuwmuATkHnEjY0tfUtPx4pgjMUmQxiBAa6UYwEPuvt8fTw8Zqw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=pRIMuJzbBzrS9dYpTMcJ8dFsy2hMZ6UksqLvhkfwPQE=;
 b=anLL4eWxxfbgD0xcAQO6XqbGpkolGJfGrK9waBn6solocbhD806j0OEfIvMtTP7J3U4iSG8KwTwupcIGDsCABhfg4sJf26Ou83oTX5vV5bDz1dFIj8S4/+uCtWSNEZ3UTW8l7dOu9y4N7ZgBkmmjjeX3+j7gu7Q1hWLfikX/YjgGxwWRzAHwyZ/ijdPOVifIwP33FKBGroKJZOO1J8OVPhcBA0k/f2za7ZwwgeIdlveRMaOzp+aKpsoLE2pZRDn6hdEBHOR52WEeprtIiIXTNbjuhWLQvJMUq1FU3KsAU1A0DhL1V0fXkUYw1mL41rhdUgtW9K5zBCmNgEYCLo/0uA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from SA1PR11MB6733.namprd11.prod.outlook.com (2603:10b6:806:25c::17)
 by CH3PR11MB8703.namprd11.prod.outlook.com (2603:10b6:610:1cd::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8534.36; Fri, 21 Mar
 2025 13:41:34 +0000
Received: from SA1PR11MB6733.namprd11.prod.outlook.com
 ([fe80::cf7d:9363:38f4:8c57]) by SA1PR11MB6733.namprd11.prod.outlook.com
 ([fe80::cf7d:9363:38f4:8c57%5]) with mapi id 15.20.8534.036; Fri, 21 Mar 2025
 13:41:34 +0000
Date: Fri, 21 Mar 2025 08:41:47 -0500
From: Ira Weiny <ira.weiny@intel.com>
To: Robert Richter <rrichter@amd.com>, Vishal Verma
	<vishal.l.verma@intel.com>, Ira Weiny <ira.weiny@intel.com>, Dan Williams
	<dan.j.williams@intel.com>, Dave Jiang <dave.jiang@intel.com>
CC: Alison Schofield <alison.schofield@intel.com>, Jonathan Cameron
	<Jonathan.Cameron@huawei.com>, <linux-cxl@vger.kernel.org>,
	<linux-kernel@vger.kernel.org>, Davidlohr Bueso <dave@stgolabs.net>, "Gregory
 Price" <gourry@gourry.net>, Terry Bowman <terry.bowman@amd.com>, "Robert
 Richter" <rrichter@amd.com>, Pankaj Gupta <pankaj.gupta@amd.com>,
	<nvdimm@lists.linux.dev>
Subject: Re: [PATCH v2] libnvdimm/labels: Fix divide error in
 nd_label_data_init()
Message-ID: <67dd6c9b3727d_7836e2947@iweiny-mobl.notmuch>
References: <20250320112223.608320-1-rrichter@amd.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20250320112223.608320-1-rrichter@amd.com>
X-ClientProxiedBy: MW4PR03CA0250.namprd03.prod.outlook.com
 (2603:10b6:303:b4::15) To SA1PR11MB6733.namprd11.prod.outlook.com
 (2603:10b6:806:25c::17)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SA1PR11MB6733:EE_|CH3PR11MB8703:EE_
X-MS-Office365-Filtering-Correlation-Id: ca0cf64f-a6e5-45a9-d686-08dd687e1841
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|376014|366016|7053199007;
X-Microsoft-Antispam-Message-Info: =?us-ascii?Q?f5L+yVN1aUhK9IFG13UJFZA7XRzWeXQDupBNwnx3aaBfGjxFoh4qNDVi/g2C?=
 =?us-ascii?Q?QxZ2DZopr+L802//nNg2CCrx2iDGVySvH1JsDtisTZNeCg5UOLG1gCpsYqFs?=
 =?us-ascii?Q?FsBXPhLzLeuBRErOjlCxr6olpcugcjELtYEHc2E/TVpLuPwbA1JzqqdEOEN7?=
 =?us-ascii?Q?faCShV9GYU/1nPU20nuTCEy1ACrcbSuWtXwStAgEfM+UGkkwtJu0/WKPEz0C?=
 =?us-ascii?Q?jG4fH/sFOE1UgUxyTIrosBOP6vzV46Zboi4TYVag9ealpnkg3bJ5FEkZ8h+A?=
 =?us-ascii?Q?4D43j8aK/KcRxf/SxwJtXogIXZ2kINRFlkaidtWJs0b5fp3/D2eN1vQeeVHX?=
 =?us-ascii?Q?V2lOli1hxR3zZkj8OR9+EqfFfizOkCJ1X2F1NZplasSxaOBoEck4+rtG9s5B?=
 =?us-ascii?Q?DCu0PhLor0FkTJDbJWsm3LXS7i9uOREigWzGOyLqz5yXDUBKOElopzEkfJbY?=
 =?us-ascii?Q?LSUc/Ojc6hN6AYWcpNypaU2YksIW5sJy1BLa/vPC/AblW9ZtppIiD77H9Ojl?=
 =?us-ascii?Q?Dp9+L4LkzMfD7ae3I3zhW9CCgMcJ57a8x2aVv9pCw7jZ+Lau59fhjn+EsXbA?=
 =?us-ascii?Q?9U9N5RFxPA2pblJY4GnMk5sxj1LZAwyjYn096l4B124PX7a1/u0kj58LXo3S?=
 =?us-ascii?Q?Y8qIcGvuyzZLRCAbuhj73kArZvhBl1Notirk7x/ca8KadF6ZGlMui0tM5j/C?=
 =?us-ascii?Q?utDhutpkfnDjHG9POPk9BPgFtTggzB9LKn1AfBF66Gy42K7g43oWlBCU+TIK?=
 =?us-ascii?Q?KT3IE/iQJdZscL3BvZQ1e3Jd35xMIVqgCwOIC9btgZ/3h1dntQmVqqI3xiOF?=
 =?us-ascii?Q?LqS1ewGGUfyubHmrXkNvVZEsNgJU1jcVsBGWZFLr2RZFSyUWLbnjwVqpiaZq?=
 =?us-ascii?Q?i28/wx+4czDJ1rx45Zp5259ri+i2/UqXvyms4nK0/BlmiaBILj6XCjnZoLsm?=
 =?us-ascii?Q?Zj0WEQ3hAF4LfEW0Mub2KFWA78Ek5kjZEv/EJBFdFuepZOokog5pZ3Iswdbv?=
 =?us-ascii?Q?pO+cEbxLzHycJv66XXgnJ5Ah4ZxxA+J1TuO0sja8miPBrij8Tih+nZgQJR/Q?=
 =?us-ascii?Q?RuJPwkMgVZ/RGw/otSJ6Pl9KqIoJph0qRLoYJw0DhDeFFHtLG+3O1+EvKIEk?=
 =?us-ascii?Q?PeKwH43QgUlicqgTPY1q11X4Wo24RQs01dBKi5MxXkwLKdppA4lVZ48vz37w?=
 =?us-ascii?Q?mCJWCr5G3ijGKXhAu51TzQ24EyKPBGGdqE7fLiSbPFDBVw04Va8uZNuLcaBa?=
 =?us-ascii?Q?CM7sljxdSTQBd5ZBAeyRcLX7aq77/e92GpWos/sg1JiCBFM5JmGcqYeoFxAz?=
 =?us-ascii?Q?LqCeaycGB14BNuK1sRtJ4finlcFgkfwkJZeFRMhfRo5luJGybIlRcp2Sy00u?=
 =?us-ascii?Q?ndWiZ+sK2Wb7Oj3gxT2Sf2MNnZEv?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR11MB6733.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(366016)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?M1TcLVhjhti6BlhnCCiEsiM6TG0RPpvXFEf+BaOIZuxM8SnNtGxqjGK9zWpC?=
 =?us-ascii?Q?j+0y6Y+TxckiXyewhkwZaM0XqziZP2/4DawAmmTNNRhHxZVoHIraEHAIS13Y?=
 =?us-ascii?Q?Rzbbywg8+OhXIrPMaSHY+Ipk9XZWS4lu7JGSstIMg5xrmyy0xnsdI432KA0P?=
 =?us-ascii?Q?w6IcSHYBTOO6r2tB3ryj1swv+eWsjOKRYgDc3Y75+jCTrYkKuxOs5BYHL6/k?=
 =?us-ascii?Q?i8GwxcUEeBf2r65BsmIXkZyibgYfyI73rebi8NlCXO7H5YYbI6LNNYSJEa1J?=
 =?us-ascii?Q?RCCnU7CMp/l5Vqar5Gw9mLblW5JnQU+8BU+KkmKGaCnD33OX5N0XyGRLPAyb?=
 =?us-ascii?Q?/WpLjLbgGO76FwKQ3tFJyy4WxUWB36B/ibh62JSpgoWi0CAJFhsZOAtXYDxI?=
 =?us-ascii?Q?oUJy2Mnnau+zgDqIMV21dD9CSyUG74TjO8BRZmEx5srg6u1YUN9usAEufRKU?=
 =?us-ascii?Q?2IkacsUhexCFLgIgB3SfoQ5xshlsBREkA9Jpk3Kx2KGxr8AVT0RerXLtjKwX?=
 =?us-ascii?Q?U6wtrT/KCa1p3RGoCvVcEIl43MG6SRzZMOZ6qlvczT2Fp0SN4Q7vhbY4Va8k?=
 =?us-ascii?Q?sSn8vdw6RbFohbC4vWEJp23ibYEIorWARuyzhvxM1y4boGKkJhERe089Enkc?=
 =?us-ascii?Q?tODGycxzTuWqZ5Qn83K1QDJH2VR7HlXzrWcQbylE0TzhlrYxD5mMv15uoF8H?=
 =?us-ascii?Q?3RrzBKFkqELJYB2TN7PHMeslpoWlJeWsyjTDiaucaUA6/yOkMXtviEg2CvUj?=
 =?us-ascii?Q?RQOnMb9UVh2MiIZ3QkD2utO7uFAiH3TbGukW2YJ75jcnRU3Sb8YBTcNyORuH?=
 =?us-ascii?Q?985bodNZTDDsVhDqSdp2fZ5k3KPaF0AO4B+HErzvT2IjFrNE/pfHX7E4SLS1?=
 =?us-ascii?Q?KKwKzX3P6JyZoO49bsBcOhcWKNV45lxBBt5mZo/sthznxgNgQ2IKUmWjgsh8?=
 =?us-ascii?Q?11FEN9sO/Vu4ZkpBcER3SX8UzjC3jMC+ScG5eSA3XuVJiKmW5fC45JdcuTeG?=
 =?us-ascii?Q?j4sdo+JZtDVJCywa5ffaKe1VQSXgFhRT8SssyoWRvy349ox8rYpsta47YNWJ?=
 =?us-ascii?Q?34whZOH9voqs3Jy8nFihOjsbOJ/wAJjxXaw1mygt4Le7rCoW9KiAP/Incf80?=
 =?us-ascii?Q?AH6axcLojvSdfrjYpHGx3aWWc1bVrod8WPEybwe7f8Mdc973HUapK2jQUycP?=
 =?us-ascii?Q?ste8hsU2CNyEW4oUSMNfYR9kkU4UoozpXpBytKI+IOO25bzCLZTVicRHu9b3?=
 =?us-ascii?Q?B9IeDbGmY9x0wBwR9bnHDC92+UD4yTU11DHaExzvehQMv0/uKYZSc2O8MfDJ?=
 =?us-ascii?Q?EzgU/vFgEz2N3WC/M9CbPrHVT6KEOGNWI33LMaY6ZNrRng+bULzd83V3Np3l?=
 =?us-ascii?Q?Lv+gsMNH4BKMXrI+DThWIurWSJ1emO/nJXN/zd0HT7JmNzT4S0u8m4ISnA5c?=
 =?us-ascii?Q?mNTzUs64x7wDDRrX+jZOBQRuCDw8728eJfeWMuiCljKfnUfnH938NRgzFHZC?=
 =?us-ascii?Q?T8nwv+LEZAOUeD7cCwOdVlbXIcRmrwjyTZNoEs3UKVC/X/cO7OXYPaKW0wcU?=
 =?us-ascii?Q?mL0X1fV3rjfqsDKLbYEGV2/FVSVs1R5cksR4BN3j?=
X-MS-Exchange-CrossTenant-Network-Message-Id: ca0cf64f-a6e5-45a9-d686-08dd687e1841
X-MS-Exchange-CrossTenant-AuthSource: SA1PR11MB6733.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Mar 2025 13:41:34.0395
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Xocrks0E7UNvB0d4t6xbNtrN8CKyI1HpnOnf+HudOCSpn6LTwmegBQat9yU+6UfYIJ/vlnEQ5JuCnQwekS+fsg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH3PR11MB8703
X-OriginatorOrg: intel.com

Robert Richter wrote:
> If a faulty CXL memory device returns a broken zero LSA size in its
> memory device information (Identify Memory Device (Opcode 4000h), CXL
> spec. 3.1, 8.2.9.9.1.1), a divide error occurs in the libnvdimm
> driver:
> 
>  Oops: divide error: 0000 [#1] PREEMPT SMP NOPTI
>  RIP: 0010:nd_label_data_init+0x10e/0x800 [libnvdimm]
> 
> Code and flow:
> 
> 1) CXL Command 4000h returns LSA size = 0
> 2) config_size is assigned to zero LSA size (CXL pmem driver):
> 
> drivers/cxl/pmem.c:             .config_size = mds->lsa_size,
> 
> 3) max_xfer is set to zero (nvdimm driver):
> 
> drivers/nvdimm/label.c: max_xfer = min_t(size_t, ndd->nsarea.max_xfer, config_size);
> 
> 4) A subsequent DIV_ROUND_UP() causes a division by zero:
> 
> drivers/nvdimm/label.c: /* Make our initial read size a multiple of max_xfer size */
> drivers/nvdimm/label.c: read_size = min(DIV_ROUND_UP(read_size, max_xfer) * max_xfer,
> drivers/nvdimm/label.c-                 config_size);
> 
> Fix this by checking the config size parameter by extending an
> existing check.
> 
> Signed-off-by: Robert Richter <rrichter@amd.com>
> Reviewed-by: Pankaj Gupta <pankaj.gupta@amd.com>
> Reviewed-by: Ira Weiny <ira.weiny@intel.com>

Applied to nvdimm/next

Thanks,
Ira

[snip]
