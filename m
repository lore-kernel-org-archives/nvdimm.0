Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DCF0D214A76
	for <nvdimm@lists.linux.dev>; Sun, 13 Apr 2025 22:52:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.18
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744584763; cv=fail; b=Mh6SbTEvWInAHYdh9VFLAk+Gu5YXMEIEjwmt4kSZMOPTPV2EC9azI0LCly9iHFYtsM+XBRX2eFSwInAZxb5U8xbWbU1pZhzVOu/Qi3QStXWU89A/xfcOYEiuDmOscauzV2sZV3FsLrt6IlRHidJ11LkASCOXA0lfJXpE/dlcz1E=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744584763; c=relaxed/simple;
	bh=v08CzPvwsIW/3cMosj4dQJdHClkLH7ghZffHXqhCmhA=;
	h=From:Date:Subject:Content-Type:Message-ID:References:In-Reply-To:
	 To:CC:MIME-Version; b=idNUlbFdO6kiv2/BFdPVBwYdWBPYVlGiCMjiO0JfMHhL8wpWsZuFMJdOQFvEVrPdnsVauNhMH/fCnrB3/NE+8WcHnHiK8x+aPwZYu/fqdlTZROy9nwfy5Rp8/l8F732FQat8Vlns8G4fKmP3aZLfcLXpPSd4XjNzc/ht+ckjtmQ=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=P/NmFzj7; arc=fail smtp.client-ip=192.198.163.18
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="P/NmFzj7"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1744584762; x=1776120762;
  h=from:date:subject:content-transfer-encoding:message-id:
   references:in-reply-to:to:cc:mime-version;
  bh=v08CzPvwsIW/3cMosj4dQJdHClkLH7ghZffHXqhCmhA=;
  b=P/NmFzj7nE9K4J4xjmLNZs1HGNGg0D4bPzR+ipr+wAykXkCzpsxTrDIr
   StR56iGRIcur3QCNjoOdeY+klpjsxXDO+wWgm71Sw5Gf8NP5Eo+PNllPW
   /OXSDMHSruvlA5XNntwk6BQA47oL3ydogGSmkh0NVLgrn+jZXJOWApWgY
   VUkeSsjxx8s7uNXSsyeQpX4iTbEtpv7VYd/8ww16R+nxxUhJ1dMtMHdWb
   6aW8aUkFEg9nft9epawJRLjIbXnUBhbA3jOPGZ041GQhEUHeNC/VZN0AU
   6RdqYpAV+lOI66vjhTMRka+90RrCyB540nAO8/PC84NbuXW8SimBX+yBx
   A==;
X-CSE-ConnectionGUID: 02kzIob1SO+iUcd1zLgntw==
X-CSE-MsgGUID: xX1iCjSxSBm+G3FLIIDeKw==
X-IronPort-AV: E=McAfee;i="6700,10204,11402"; a="45280987"
X-IronPort-AV: E=Sophos;i="6.15,211,1739865600"; 
   d="scan'208";a="45280987"
Received: from fmviesa007.fm.intel.com ([10.60.135.147])
  by fmvoesa112.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Apr 2025 15:52:42 -0700
X-CSE-ConnectionGUID: KdaQ4WoyQUCi1S/+9fKA/w==
X-CSE-MsgGUID: vWJM0oFZRaGP8JkixlF/cw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.15,211,1739865600"; 
   d="scan'208";a="129657644"
Received: from orsmsx903.amr.corp.intel.com ([10.22.229.25])
  by fmviesa007.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Apr 2025 15:52:41 -0700
Received: from ORSMSX901.amr.corp.intel.com (10.22.229.23) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.14; Sun, 13 Apr 2025 15:52:40 -0700
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.14 via Frontend Transport; Sun, 13 Apr 2025 15:52:40 -0700
Received: from NAM02-SN1-obe.outbound.protection.outlook.com (104.47.57.44) by
 edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.44; Sun, 13 Apr 2025 15:52:40 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=ooYA/JWuSX46lKnnoaWF9YHIQyQGhM87n8Cwvw+GaS8Zut1FUQptGuQ00+GmPOraewi3XwD17sAlAhnbaNlhXHVplZv2nXQoGQTxTuX7PuvwqsemIYUZwkzwjGvxzK8irVH9fyoNeIOATMCcrsrNkztU5M22mNyJwGFnJQdZg8MQcUFQak45rWsxaAiWllKlTYj8f0jP7Fq2dr0LacKKJCFEP9Ptk1qBOhyw7DC6IZMVUv+XpSpjZcHp6A78v08E9k0tvxCAaDznr6ppgkaQhaiRxpP0yQm2Hl9gpho64vp5VWgKVl7DDN2hVoP1Xx5qYVAz9Vl8ASXINpo8iv7WGA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=oU8VHnoQLeoj8UGJVPUR011rbMDtdHIvG+2LUNPpCXg=;
 b=Z46SkVvRAu5f+nPZuZSPywjGKFuSzWLSkjeOjDswQXcRY+sqlFyQcZOUTixnu3vcN8xcsqpzQSnX3DouLC0aO4+fTuuYEXj66or8YxflkgOfImvVtKm98OvWN8c84m9MK7wf5s+zaPHXke5fva/BaI1rL1hkPHz88jiwLwpghCZYgo9y/UUyer8J8BKZ+/XGzKvu5DGpkXlHgd1ujVFn3MQM5625xK7axgDlYtWffoT6HJ+8T/eZiEZefO4YzR4sPiKiCjFbPq0nKcSm8kcMhGulo/YCHk43qI3EJUeaKyDs8M/AqES77Mtq2In550lrTPXWDIGjdY9j52i0jpSn9Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from MW4PR11MB6739.namprd11.prod.outlook.com (2603:10b6:303:20b::19)
 by PH7PR11MB7003.namprd11.prod.outlook.com (2603:10b6:510:20a::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8632.33; Sun, 13 Apr
 2025 22:52:38 +0000
Received: from MW4PR11MB6739.namprd11.prod.outlook.com
 ([fe80::a7ad:a6e8:fced:3f24]) by MW4PR11MB6739.namprd11.prod.outlook.com
 ([fe80::a7ad:a6e8:fced:3f24%4]) with mapi id 15.20.8606.033; Sun, 13 Apr 2025
 22:52:38 +0000
From: Ira Weiny <ira.weiny@intel.com>
Date: Sun, 13 Apr 2025 17:53:00 -0500
Subject: [ndctl PATCH v5 3/5] libcxl: Add extent functionality to DC
 regions
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-ID: <20250413-dcd-region2-v5-3-fbd753a2e0e8@intel.com>
References: <20250413-dcd-region2-v5-0-fbd753a2e0e8@intel.com>
In-Reply-To: <20250413-dcd-region2-v5-0-fbd753a2e0e8@intel.com>
To: Alison Schofield <alison.schofield@intel.com>
CC: Vishal Verma <vishal.l.verma@intel.com>, Jonathan Cameron
	<jonathan.cameron@Huawei.com>, Fan Ni <fan.ni@samsung.com>, Sushant1 Kumar
	<sushant1.kumar@intel.com>, Dan Williams <dan.j.williams@intel.com>, "Dave
 Jiang" <dave.jiang@intel.com>, <linux-cxl@vger.kernel.org>,
	<nvdimm@lists.linux.dev>, Ira Weiny <ira.weiny@intel.com>
X-Mailer: b4 0.15-dev-c25d1
X-Developer-Signature: v=1; a=ed25519-sha256; t=1744584788; l=8746;
 i=ira.weiny@intel.com; s=20221211; h=from:subject:message-id;
 bh=v08CzPvwsIW/3cMosj4dQJdHClkLH7ghZffHXqhCmhA=;
 b=xaMFgB4JKIixVteVOlgNiJdHDgaeLHIPrsQ8l2MHsaC4mjK2AmYeESyB8uJTzHA3YpSvXjAOQ
 e5VrHqpqCjqBvzDHTmWy0/yktDfiDIUlYaw67D9xOm7S+SF5ezgMvvF
X-Developer-Key: i=ira.weiny@intel.com; a=ed25519;
 pk=noldbkG+Wp1qXRrrkfY1QJpDf7QsOEthbOT7vm0PqsE=
X-ClientProxiedBy: MW2PR2101CA0016.namprd21.prod.outlook.com
 (2603:10b6:302:1::29) To MW4PR11MB6739.namprd11.prod.outlook.com
 (2603:10b6:303:20b::19)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: MW4PR11MB6739:EE_|PH7PR11MB7003:EE_
X-MS-Office365-Filtering-Correlation-Id: 492e38ec-ec6a-4152-8716-08dd7adde3be
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|376014|1800799024;
X-Microsoft-Antispam-Message-Info: =?utf-8?B?c3dzYThuaXdjMjRGUytZU09ncDhPUElSUWtHSGdCeXdqYVR5RlFaK3g2TVZW?=
 =?utf-8?B?RlJIb3p6TkRvTHNJVGRZZ1Qvc0xjV0k4TjQrNkJzR1ZYZ0VudDBhMTBleWt2?=
 =?utf-8?B?a2lNOVF5Z0pCYUFRcjVaODQwM3pyZExEQ2RaRlF2bTFLbTlKQk10WVgvMFd1?=
 =?utf-8?B?aTdQbXZWeXpiYnhTWkJDU0NxYXA0L21ieVRaQXFqZWEvRm9RNi9XSXd0L2g5?=
 =?utf-8?B?V0pKTzg2M3o1SCtEMjNkcHI2a3craWZndForaXdGRElCVW1kdHAxM1l2SjNB?=
 =?utf-8?B?YlozajJqc2wzMk9WYVB4QlZXS0E1OHRRT0dGdzVwMTAxd1RnV20wbEI5bUFH?=
 =?utf-8?B?WjRWSWZtTHlFUWVtSUJCYkhGT254bjVLSm1WaVpqQi94RHBGczV4cWJibzJP?=
 =?utf-8?B?QTBBaWl3ZERxSHhuOW9iL1BGeWJvajl0bUFhOGZmRUtGWlFvam5YZGNTMlRa?=
 =?utf-8?B?b0hVYTNXSUFrOUtza25PQ2ZOODFlNjhYbXIyMHZMRzZCamxRVndqMlJsMGZ5?=
 =?utf-8?B?Kzl3dTZHaFRjRmw2UmdYSG0wbDNIYno1aTExMENhVEVvUFl1NlVPUDdVZFA1?=
 =?utf-8?B?dGdYTXJGanpXbG4xY0NNWTQ1RzVUWXl1a3BkeXRzNHZDOUFBNm5OajU2bExG?=
 =?utf-8?B?Y0JaQ1pCZ2l5TENxTCszbmF5TThkWDF3RHVYZlJ3WVFhMHJmM2dmcDFBY2Fw?=
 =?utf-8?B?d2JlZThnYU9CbWJLc3dSYVFUUEN1TjJXN2xic21aeDZBV1c4K0syYnNsVC9Q?=
 =?utf-8?B?Y1laMHlacHBZTVMrelU5RnFlRk4xbWV6TW1sUVMwY1ZGSUtSNEowemtGemw4?=
 =?utf-8?B?dDRTTVJaRGJJNEo4YktKOUNYanU2dkhUWUdUUVR5eGlOWWk2MnB3c2F0WnBn?=
 =?utf-8?B?YlpMa0c2VUpGd1lZTDJIUkJEOGxOdXpvODJPUVNHQ0laNlByM1pSOEV4NFUz?=
 =?utf-8?B?dFlMTjl4TVRSSHRuTy9CZFlTM1BmUFZLeDhYUGZ3TkUwRnV2eGFvOXVtWnlN?=
 =?utf-8?B?S3lYTnhUYmFTOVF2YzB4VU5YMWpqU3h4bUJGL1RRVFF6dzZyQkh4STAzWFpw?=
 =?utf-8?B?Q3dZVHAzVEtCbDZqVjNqZG5xd1ZaK3FxRWVUNXFGaDBTRjFEY0hwQzRQNUhk?=
 =?utf-8?B?QjY3cFdBZXFlWGhtN3BZNTVUekxSZzZob3QyamprTWxFM0xtb0Vsa3U2NldE?=
 =?utf-8?B?eUJIQTJxeVEvRG5QY2M2Nkc5ZGlvL2hJVkNDRHh2TnZYZkZCZm5TbGFEeVEw?=
 =?utf-8?B?aHlZZ3VRZDFnMmdGVk9WNzVjbVJsTG5GeTM2QWFMQVNLeVNUcjU4MGlGRkZ6?=
 =?utf-8?B?cnVKVVhoeXU2QThhS1orUUNJdVQ0a0lMM2syejR3c3BSS2s4ekZ3SzhDOE9w?=
 =?utf-8?B?RS9Gck1VOWdmMEhFMytMcTgwbVpKMU5IbmZJT2FIOFlDVko5VVJkOC9OOEZQ?=
 =?utf-8?B?eWErdm9uR1hTRDZGVEtxanlRSlRiMjJNSkpvc012QkhoaTBPZ3F4Z0tPTmNk?=
 =?utf-8?B?cTFWeVNEUkpiOGJIUG9OdXJqUFNZcFZDR2lMc1BJVStFZEFra0VwMmJwS1Y2?=
 =?utf-8?B?b2t6Y3BhcGx4Y3RnU3dkMENpSlJQRUM0ZlZqMjRQckdlaFF2aW5md2cvOGVr?=
 =?utf-8?B?TXdEekFuVzJRN0duc3RER08yS05pYjFLdzNyalFycnFuMHE3c0gwQkJIMnEv?=
 =?utf-8?B?dUdKaExFYlRiRzMrbW9Ra3lNdklCSWl1KzZkeTZYSUt6RVc5STNlN3FpRkY5?=
 =?utf-8?B?dFVmdE1jMWVFZmRmdXRxa2tPbGZ0U2JCbVhPVXlLRWJWeXN1L25mazJCZmll?=
 =?utf-8?B?TWtRakdoZDVKS0xWTzBFRVAzbWNob0ZBb1h6TTRLS0lXSTRDcXR3TmVPQTY3?=
 =?utf-8?B?NnQrRHJQWkc4aGVzL1RUSWNaVEE5b0txNnFyMnJlRldjOW1mOEFvU2NHSFg5?=
 =?utf-8?Q?DRTlFyY/OVc=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MW4PR11MB6739.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?WHBOT3JXU3ZtMU12VVBMTWsrbDQ3MFJOdmVKUnNjQThNcW9NR3RpZm5ObFpz?=
 =?utf-8?B?cVBQK1plbUcxMkR6cHFyQnIxOFZzaDE0emY2QWw0VStPclBaUWptSkRQYXFu?=
 =?utf-8?B?NkhkdEgwREpIdFRZb2tBTEQ3c1ExV2ZGakdjZG5ZYS9jdHh6NWZ5L0xsTDBt?=
 =?utf-8?B?N1h4VjVQRUJHK09mc3pDTTlZbGpjRW9xSzhleVBrbDIwUlRPL3pFUlJJaDlu?=
 =?utf-8?B?VjhsK2ppK0dudi9ZOENYWno4TmtxVmFBR01DSUlwYlBUaEFCKzlldld4QUh1?=
 =?utf-8?B?QmRXbkE4T3ZSS0xKZ3FtYnpwNTlCTklpZE5KVEdDa0VVY05qU1V0Nm03cXhi?=
 =?utf-8?B?Z0M5NnBsek1ERlpQTWF5NXB5YWlYaG9xVUhOcWJySW54LzR4RllPMjZhWkxR?=
 =?utf-8?B?RjRaendkZnI1SVRBSDFKamR1cFdISzZrSUhqYnZoeDVCSnpUMll1QmgxYi9m?=
 =?utf-8?B?TlpzY2hrMUtZb3BXWDE5RUhpcC81UEtNTTdsTDc2SFlPV25ZTnhHR1JYSVRp?=
 =?utf-8?B?aXRIR2NWOEFYSk1XZFk0TUJlSE1iVXJpVStWZnNEeEU1dWpBYTk0RXhlQWda?=
 =?utf-8?B?cFQxeHZYY09KU1JRSXo1d09kN1ovRlgyVUdIZ1N2QmpjL3BzeUtlb1dkYUVt?=
 =?utf-8?B?UEo0Ny9kUjljM1pXcG1CSjdQVDVWY21TNjh6NTlHeGJGajU1Uy8yVmZiRnI5?=
 =?utf-8?B?NFN5N2UrQVhuNGM4YnJhMXdhSlBaRUkwQzBLWnBPUnU2aGZUYnc4NmxVWHV0?=
 =?utf-8?B?UnpmTW12d0lVR2xaK0FPc2E5NEtRK3NvVG9aTVZYemtkRG1ZeUFLZkM0RjQr?=
 =?utf-8?B?Z3VoTmQ5dlg5RFVSa2ZxY1NwM2c3T2JOUk55NDAzc25rR3BxOGRFL1NRSThR?=
 =?utf-8?B?aFlxMmRYMG9EdXUzQm5scWpYSEdYRm16eWYvMGt0dVdST0hXaWhrV0pVdGM2?=
 =?utf-8?B?djJ4SStiWmRyQkplWEtXTm1sRkRPeGJxeDg1L2FLU3RQZ3pneHZhWE9GdmRE?=
 =?utf-8?B?QU9KRHdQZkl2UWRGeDBTZjZVZFNWaGlXb0ZXOVhhUDdKclUvRVgxblVNeDFT?=
 =?utf-8?B?VGdsYjRtUUtOdXBvZGVwUFZwUkMrTkE2NEZYcWovbHczTkE0Z29obUE4cnZu?=
 =?utf-8?B?M2NnYU5hRytacWpkWGw5MmdWcURuSGo1SGxVWXZTQVU5WmV0YUoySUd5YTN1?=
 =?utf-8?B?WWhmMHFISWhGcXl0YWdyZld1SEIvMFg0OTZVNUEzU0dhMHVGaS9VMVpkL0ha?=
 =?utf-8?B?bDNia0Q4RGlDM1dDSDcrTmpQUC96NTNQL0N1dm5qUDdFMDFJSGM5Y2ZtYmFn?=
 =?utf-8?B?TG1hU3U1Z1RUSnhxUy9rWXhpR01zcmoxeEhHejZkMWdUTUJvSktBZk1pV0k2?=
 =?utf-8?B?emt6QnFZWWVoalZHaTJXSm1qNTVoV1NTMENBai9nQ2Y5RGNpeDdOVGdaUEhX?=
 =?utf-8?B?MDllWnNJUWFJOHZWNWdIK0s5U3J1RWVtZVUvTnNrcy9ZM2IvYW80RUZWZkp4?=
 =?utf-8?B?NU1WK3JhdG5rNUZtbkM5bXF4aW1IQ0lNVU1qQlk2czBPalVwL1NNMzNwZHhD?=
 =?utf-8?B?SlJmdnh2Nkc3N2RJN05ORGxPM0g3ZjFYQ0wzaWMxYStYMWVNT1dWRGtIeDVl?=
 =?utf-8?B?TkE2WnZpOFJtcW5sc05TUHd5R3FMVnR4VXNCUFNTcm5kREdKVjNxYUZ3MEJ0?=
 =?utf-8?B?M25UeUZaeWRscStLcTdidTJyOWs3bnVlcHc5QkQ0ckF5azRVbVJrLzRYWnIv?=
 =?utf-8?B?Z043Uk1TblF3SmNpSXFtb0JJMkMzZHgvT09LWlZtNXpSZk8zbUt6SENLZmtu?=
 =?utf-8?B?OURuWlF1NzBJQWZScWVpYURvWHYxMnNSR2wvMy8xVXhJVkxIdks5NFhqaE5u?=
 =?utf-8?B?WVV2M0VEQlgwOVk3QUtlMmc0UUloMVVGdzNKZ0E5Nlk4RWdPWFUxdzNNS29U?=
 =?utf-8?B?S2dLUEZCeER4elJKN3E4bkZzMytNemtmU2lCUDZ1bWFYVzRGbWlIM2dkSHd5?=
 =?utf-8?B?dVdJdmpQd0hEL29qMm10QWVTQ0t4SWJmSTlzTWZDQnZrOTNBMUFaRXMxL0Jz?=
 =?utf-8?B?czBrS3h3NmkxV1IzdTVHdVZsL1dYZC9IZ3B2MTY5Y3V5Z3FSR1dCTFpDcHlZ?=
 =?utf-8?Q?SD9TUGkf6pYzMVeryAb6jntYT?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 492e38ec-ec6a-4152-8716-08dd7adde3be
X-MS-Exchange-CrossTenant-AuthSource: MW4PR11MB6739.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Apr 2025 22:52:38.5376
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: frUscTsUFrhBNzZi5o1YMuqKFbkKmXuh2SmMsS9MSC5uOGI/YZyXw0sfeoa17pnfpNhpg0YS6IM/iws4qWrhjg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR11MB7003
X-OriginatorOrg: intel.com

DCD regions have 0 or more extents.  The ability to list those and their
properties is useful to end users.

Add extent scanning and reporting functionality to libcxl.

Signed-off-by: Ira Weiny <ira.weiny@intel.com>

---
Changes:
[alison: s/tag/uuid/ for extents]
---
 Documentation/cxl/lib/libcxl.txt |  27 ++++++++
 cxl/lib/libcxl.c                 | 138 +++++++++++++++++++++++++++++++++++++++
 cxl/lib/libcxl.sym               |   5 ++
 cxl/lib/private.h                |  11 ++++
 cxl/libcxl.h                     |  11 ++++
 5 files changed, 192 insertions(+)

diff --git a/Documentation/cxl/lib/libcxl.txt b/Documentation/cxl/lib/libcxl.txt
index 7e2136519229..84f39d2eda6c 100644
--- a/Documentation/cxl/lib/libcxl.txt
+++ b/Documentation/cxl/lib/libcxl.txt
@@ -603,6 +603,33 @@ where its properties can be interrogated by daxctl. The helper
 cxl_region_get_daxctl_region() returns an 'struct daxctl_region *' that
 can be used with other libdaxctl APIs.
 
+EXTENTS
+-------
+
+=== EXTENT: Enumeration
+----
+struct cxl_region_extent;
+struct cxl_region_extent *cxl_extent_get_first(struct cxl_region *region);
+struct cxl_region_extent *cxl_extent_get_next(struct cxl_region_extent *extent);
+#define cxl_extent_foreach(region, extent) \
+        for (extent = cxl_extent_get_first(region); \
+             extent != NULL; \
+             extent = cxl_extent_get_next(extent))
+
+----
+
+=== EXTENT: Attributes
+----
+unsigned long long cxl_extent_get_offset(struct cxl_region_extent *extent);
+unsigned long long cxl_extent_get_length(struct cxl_region_extent *extent);
+void cxl_extent_get_uuid(struct cxl_region_extent *extent, uuid_t uuid);
+----
+
+Extents represent available memory within a dynamic capacity region.  Extent
+objects are available for informational purposes to aid in allocation of
+memory.
+
+
 include::../../copyright.txt[]
 
 SEE ALSO
diff --git a/cxl/lib/libcxl.c b/cxl/lib/libcxl.c
index 81810a4ae862..306a46682b71 100644
--- a/cxl/lib/libcxl.c
+++ b/cxl/lib/libcxl.c
@@ -571,6 +571,7 @@ static void *add_cxl_region(void *parent, int id, const char *cxlregion_base)
 	region->ctx = ctx;
 	region->decoder = decoder;
 	list_head_init(&region->mappings);
+	list_head_init(&region->extents);
 
 	region->dev_path = strdup(cxlregion_base);
 	if (!region->dev_path)
@@ -1176,6 +1177,143 @@ cxl_mapping_get_next(struct cxl_memdev_mapping *mapping)
 	return list_next(&region->mappings, mapping, list);
 }
 
+static void cxl_extents_init(struct cxl_region *region)
+{
+	const char *devname = cxl_region_get_devname(region);
+	struct cxl_ctx *ctx = cxl_region_get_ctx(region);
+	char *extent_path, *dax_region_path;
+	struct dirent *de;
+	DIR *dir = NULL;
+
+	if (region->extents_init)
+		return;
+	region->extents_init = 1;
+
+	dax_region_path = calloc(1, strlen(region->dev_path) + 64);
+	if (!dax_region_path) {
+		err(ctx, "%s: allocation failure\n", devname);
+		return;
+	}
+
+	extent_path = calloc(1, strlen(region->dev_path) + 100);
+	if (!extent_path) {
+		err(ctx, "%s: allocation failure\n", devname);
+		free(dax_region_path);
+		return;
+	}
+
+	sprintf(dax_region_path, "%s/dax_region%d",
+		region->dev_path, region->id);
+	dir = opendir(dax_region_path);
+	if (!dir) {
+		err(ctx, "no extents found (%s): %s\n",
+			strerror(errno), dax_region_path);
+		free(extent_path);
+		free(dax_region_path);
+		return;
+	}
+
+	while ((de = readdir(dir)) != NULL) {
+		struct cxl_region_extent *extent;
+		char buf[SYSFS_ATTR_SIZE];
+		u64 offset, length;
+		int id, region_id;
+
+		if (sscanf(de->d_name, "extent%d.%d", &region_id, &id) != 2)
+			continue;
+
+		sprintf(extent_path, "%s/extent%d.%d/offset",
+			dax_region_path, region_id, id);
+		if (sysfs_read_attr(ctx, extent_path, buf) < 0) {
+			err(ctx, "%s: failed to read extent%d.%d/offset\n",
+				devname, region_id, id);
+			continue;
+		}
+
+		offset = strtoull(buf, NULL, 0);
+		if (offset == ULLONG_MAX) {
+			err(ctx, "%s extent%d.%d: failed to read offset\n",
+				devname, region_id, id);
+			continue;
+		}
+
+		sprintf(extent_path, "%s/extent%d.%d/length",
+			dax_region_path, region_id, id);
+		if (sysfs_read_attr(ctx, extent_path, buf) < 0) {
+			err(ctx, "%s: failed to read extent%d.%d/length\n",
+				devname, region_id, id);
+			continue;
+		}
+
+		length = strtoull(buf, NULL, 0);
+		if (length == ULLONG_MAX) {
+			err(ctx, "%s extent%d.%d: failed to read length\n",
+				devname, region_id, id);
+			continue;
+		}
+
+		sprintf(extent_path, "%s/extent%d.%d/tag",
+			dax_region_path, region_id, id);
+		buf[0] = '\0';
+		if (sysfs_read_attr(ctx, extent_path, buf) != 0)
+			dbg(ctx, "%s extent%d.%d: failed to read uuid\n",
+				devname, region_id, id);
+
+		extent = calloc(1, sizeof(*extent));
+		if (!extent) {
+			err(ctx, "%s extent%d.%d: allocation failure\n",
+				devname, region_id, id);
+			continue;
+		}
+		if (strlen(buf) && uuid_parse(buf, extent->uuid) < 0)
+			err(ctx, "%s:%s\n", extent_path, buf);
+		extent->region = region;
+		extent->offset = offset;
+		extent->length = length;
+
+		list_node_init(&extent->list);
+		list_add(&region->extents, &extent->list);
+		dbg(ctx, "%s added extent%d.%d\n", devname, region_id, id);
+	}
+	free(dax_region_path);
+	free(extent_path);
+	closedir(dir);
+}
+
+CXL_EXPORT struct cxl_region_extent *
+cxl_extent_get_first(struct cxl_region *region)
+{
+	cxl_extents_init(region);
+
+	return list_top(&region->extents, struct cxl_region_extent, list);
+}
+
+CXL_EXPORT struct cxl_region_extent *
+cxl_extent_get_next(struct cxl_region_extent *extent)
+{
+	struct cxl_region *region = extent->region;
+
+	return list_next(&region->extents, extent, list);
+}
+
+CXL_EXPORT unsigned long long
+cxl_extent_get_offset(struct cxl_region_extent *extent)
+{
+	return extent->offset;
+}
+
+CXL_EXPORT unsigned long long
+cxl_extent_get_length(struct cxl_region_extent *extent)
+{
+	return extent->length;
+}
+
+CXL_EXPORT void
+cxl_extent_get_uuid(struct cxl_region_extent *extent, uuid_t uuid)
+{
+	memcpy(uuid, extent->uuid, sizeof(uuid_t));
+}
+
 CXL_EXPORT struct cxl_decoder *
 cxl_mapping_get_decoder(struct cxl_memdev_mapping *mapping)
 {
diff --git a/cxl/lib/libcxl.sym b/cxl/lib/libcxl.sym
index 06f7d40344ab..b9d99ec80cec 100644
--- a/cxl/lib/libcxl.sym
+++ b/cxl/lib/libcxl.sym
@@ -297,4 +297,9 @@ global:
 	cxl_memdev_get_dynamic_ram_a_qos_class;
 	cxl_decoder_is_dynamic_ram_a_capable;
 	cxl_decoder_create_dynamic_ram_a_region;
+	cxl_extent_get_first;
+	cxl_extent_get_next;
+	cxl_extent_get_offset;
+	cxl_extent_get_length;
+	cxl_extent_get_uuid;
 } LIBECXL_8;
diff --git a/cxl/lib/private.h b/cxl/lib/private.h
index 57c9fa0b8f52..d5e0c0528c42 100644
--- a/cxl/lib/private.h
+++ b/cxl/lib/private.h
@@ -164,6 +164,7 @@ struct cxl_region {
 	struct cxl_decoder *decoder;
 	struct list_node list;
 	int mappings_init;
+	int extents_init;
 	struct cxl_ctx *ctx;
 	void *dev_buf;
 	size_t buf_len;
@@ -179,6 +180,7 @@ struct cxl_region {
 	struct daxctl_region *dax_region;
 	struct kmod_module *module;
 	struct list_head mappings;
+	struct list_head extents;
 };
 
 struct cxl_memdev_mapping {
@@ -188,6 +190,15 @@ struct cxl_memdev_mapping {
 	struct list_node list;
 };
 
+#define CXL_REGION_EXTENT_TAG 0x10
+struct cxl_region_extent {
+	struct cxl_region *region;
+	u64 offset;
+	u64 length;
+	uuid_t uuid;
+	struct list_node list;
+};
+
 enum cxl_cmd_query_status {
 	CXL_CMD_QUERY_NOT_RUN = 0,
 	CXL_CMD_QUERY_OK,
diff --git a/cxl/libcxl.h b/cxl/libcxl.h
index de66f2462311..3b3f6ae9a07d 100644
--- a/cxl/libcxl.h
+++ b/cxl/libcxl.h
@@ -373,6 +373,17 @@ unsigned int cxl_mapping_get_position(struct cxl_memdev_mapping *mapping);
              mapping != NULL; \
              mapping = cxl_mapping_get_next(mapping))
 
+struct cxl_region_extent;
+struct cxl_region_extent *cxl_extent_get_first(struct cxl_region *region);
+struct cxl_region_extent *cxl_extent_get_next(struct cxl_region_extent *extent);
+#define cxl_extent_foreach(region, extent) \
+        for (extent = cxl_extent_get_first(region); \
+             extent != NULL; \
+             extent = cxl_extent_get_next(extent))
+unsigned long long cxl_extent_get_offset(struct cxl_region_extent *extent);
+unsigned long long cxl_extent_get_length(struct cxl_region_extent *extent);
+void cxl_extent_get_uuid(struct cxl_region_extent *extent, uuid_t uuid);
+
 struct cxl_cmd;
 const char *cxl_cmd_get_devname(struct cxl_cmd *cmd);
 struct cxl_cmd *cxl_cmd_new_raw(struct cxl_memdev *memdev, int opcode);

-- 
2.49.0

