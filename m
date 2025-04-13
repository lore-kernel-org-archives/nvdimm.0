Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 826271A314E
	for <nvdimm@lists.linux.dev>; Sun, 13 Apr 2025 22:52:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.18
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744584759; cv=fail; b=pos7dUR5FRetVbOpdLZoG3/bCFK5OcOUHscylsfaq/IIwfN8RybXImzHCd8+c+QjHAs5jYMlLYfPbPJtlpDgWyd0j5AR5ernr6rIiVGaLqkrCPV/WWQqFZUKEYZY4puObvQX8EHreQp4nQjJDS8Pr0u734DylsdmvoubskagOBE=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744584759; c=relaxed/simple;
	bh=wHMVv6tL4QfxMTR8qMmB+pCG/N575jfvmo5YYo0K9xY=;
	h=From:Date:Subject:Content-Type:Message-ID:References:In-Reply-To:
	 To:CC:MIME-Version; b=cKTK9skHLjPwubW/+n3S3h24bUK1T82jwUn8D1M/VxjxbdKGNAIWF+k3d07n1QPpcm9ppLkE0Bq9VaYJm0xhisFlCCXxtBfFrCslCmKKmRgd1zr/Rpi+lSynGGyJysjdBSGXLmQ+VzYzUCdtL0YYKyqMcBQGnvrRvsAXxTQEq60=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=HPugc1yl; arc=fail smtp.client-ip=192.198.163.18
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="HPugc1yl"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1744584757; x=1776120757;
  h=from:date:subject:content-transfer-encoding:message-id:
   references:in-reply-to:to:cc:mime-version;
  bh=wHMVv6tL4QfxMTR8qMmB+pCG/N575jfvmo5YYo0K9xY=;
  b=HPugc1ylEzxnhuOoBctrGQ7LBunfX21GtBl8cJKg4tTiTvslQayZMPgH
   saKzKSqU7tLbjr35kbJ+p1c/ede9rxWAfD2mukRkLhWO7NC+ZlVVGvImz
   Rnb8kMFK8JIEYWQGhirsbrqBCnLwtzS2qwTayQsy9Ci7joKp5nYbu+7lJ
   wLAdgk3CLly0hkz5vUdxC3j5cRSVZDNSF9IWAP89LVtJgj/8B0v6P2DSH
   HBDnd8sCtvp4ou+qildDHf/IMsiWMOA1OdIMT+RzxyxNzXcO242BvQ4ak
   KbKzci3XMwLufAXd9qm4WNsphsxk0PuNH5v6uBycW8uhYenjxJqCHLKOw
   A==;
X-CSE-ConnectionGUID: L1exXZI0Qn+FIRmh9uthRg==
X-CSE-MsgGUID: U14AMLJ1Q4CVDei31heLzg==
X-IronPort-AV: E=McAfee;i="6700,10204,11402"; a="45280966"
X-IronPort-AV: E=Sophos;i="6.15,211,1739865600"; 
   d="scan'208";a="45280966"
Received: from fmviesa007.fm.intel.com ([10.60.135.147])
  by fmvoesa112.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Apr 2025 15:52:36 -0700
X-CSE-ConnectionGUID: o7R247WxT/Wm5SM001gjTg==
X-CSE-MsgGUID: u1yOuR2GQ1aK8M7st7UCTA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.15,211,1739865600"; 
   d="scan'208";a="129657635"
Received: from orsmsx902.amr.corp.intel.com ([10.22.229.24])
  by fmviesa007.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Apr 2025 15:52:36 -0700
Received: from ORSMSX901.amr.corp.intel.com (10.22.229.23) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.14; Sun, 13 Apr 2025 15:52:35 -0700
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.14 via Frontend Transport; Sun, 13 Apr 2025 15:52:35 -0700
Received: from NAM02-SN1-obe.outbound.protection.outlook.com (104.47.57.44) by
 edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.44; Sun, 13 Apr 2025 15:52:34 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=h9zHSybtzuUf6yYMpirbERwz6ZLqtBbYZvKYmQdWS49xATYQikoq7/6HouGFT/ueT8+TnZpKRa4G4EsC5qEIdEnCHNpMD0HVmDQ0t1v+NdJxxvuU1YkS3nThkbR07onndcu8TsPEBszKd/pHFmZYVeGvomOSReAv5PlmW584KGOZb+y8uuU8A7jVFy2ff4NGwdXxLtnPxV1t9ty/536lo4fHcT/tGK5uZ9eE2NUvJX5RmtjvW8z23uVpAIHpcBpsOjlxXqF0C0mPmszrxdW5qmxW4QV/TX5248ImK7ypELVBz5kYQBdGpFBmk8ac+tg5Y2OdElpxLOkRUdERdVr5YA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=DxjHic46EGVica6+xsSexw+RIXWnwKQtDZaXL+uUKYI=;
 b=tjJ9XFk9WqT9IUfo5NElho/FHD0ju/lfSOiknd0DK8nRW8XM7eEyyrHoj8uC2vZe5uSoaqcOj8O50xBXQ0Bwv9rymMk/ZwFzTejeYUo2Z9ytupi+2K0unrIkNsIGaokIQg3hAf3XRoLEcfKvaNy/AyphsuGbW3OXwj7/BYwSFAzfzbDkBbheVIMJl7WPR3gUqX2CNzuKd35yPt4PCDNFveQ3PILR4gsK2xDk6ssS8yrERc+Ox7fMl+40SkPMy2oWFu8/LYmVlUPLRAF+F6PBSBLOGoAv736NioTteEEAJWazIbLda7Y3PUlrDbsuBOsYfeAMmwp88OntVQkITHwkcA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from MW4PR11MB6739.namprd11.prod.outlook.com (2603:10b6:303:20b::19)
 by PH7PR11MB7003.namprd11.prod.outlook.com (2603:10b6:510:20a::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8632.33; Sun, 13 Apr
 2025 22:52:14 +0000
Received: from MW4PR11MB6739.namprd11.prod.outlook.com
 ([fe80::a7ad:a6e8:fced:3f24]) by MW4PR11MB6739.namprd11.prod.outlook.com
 ([fe80::a7ad:a6e8:fced:3f24%4]) with mapi id 15.20.8606.033; Sun, 13 Apr 2025
 22:52:14 +0000
From: Ira Weiny <ira.weiny@intel.com>
Date: Sun, 13 Apr 2025 17:52:27 -0500
Subject: [PATCH v9 19/19] tools/testing/cxl: Add DC Regions to mock mem
 data
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-ID: <20250413-dcd-type2-upstream-v9-19-1d4911a0b365@intel.com>
References: <20250413-dcd-type2-upstream-v9-0-1d4911a0b365@intel.com>
In-Reply-To: <20250413-dcd-type2-upstream-v9-0-1d4911a0b365@intel.com>
To: Dave Jiang <dave.jiang@intel.com>, Fan Ni <fan.ni@samsung.com>, "Jonathan
 Cameron" <Jonathan.Cameron@huawei.com>
CC: Dan Williams <dan.j.williams@intel.com>, Davidlohr Bueso
	<dave@stgolabs.net>, Alison Schofield <alison.schofield@intel.com>, "Vishal
 Verma" <vishal.l.verma@intel.com>, Ira Weiny <ira.weiny@intel.com>,
	<linux-cxl@vger.kernel.org>, <nvdimm@lists.linux.dev>,
	<linux-kernel@vger.kernel.org>
X-Mailer: b4 0.15-dev-c25d1
X-Developer-Signature: v=1; a=ed25519-sha256; t=1744584735; l=24753;
 i=ira.weiny@intel.com; s=20221211; h=from:subject:message-id;
 bh=wHMVv6tL4QfxMTR8qMmB+pCG/N575jfvmo5YYo0K9xY=;
 b=DOc2lTVyHjID6tyGD8eW/iq+KW9krVGXgzdgNV3Z5RxYkzav+D9Xat2LtZVixYJ8J3I00wMD4
 4PfhTkqhfC+DGsjJ/sQG1gQQbMLCGSyzr0wKUm5gTRMh9QQHdAx6lmq
X-Developer-Key: i=ira.weiny@intel.com; a=ed25519;
 pk=noldbkG+Wp1qXRrrkfY1QJpDf7QsOEthbOT7vm0PqsE=
X-ClientProxiedBy: MW4PR03CA0227.namprd03.prod.outlook.com
 (2603:10b6:303:b9::22) To MW4PR11MB6739.namprd11.prod.outlook.com
 (2603:10b6:303:20b::19)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: MW4PR11MB6739:EE_|PH7PR11MB7003:EE_
X-MS-Office365-Filtering-Correlation-Id: 16ec98af-ac4b-466e-1458-08dd7addd553
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|376014|1800799024;
X-Microsoft-Antispam-Message-Info: =?utf-8?B?eW11SERrcTVOT0FFWEx1QlRHbGlObC96MWMzcktXQXFtZWZjVWVuR3JrK3l5?=
 =?utf-8?B?Q3lETUF1RlEreDNpWllMM2VCUlljMHBnZlN3VjJkYWVZK0xxNnpRM2VLdVZF?=
 =?utf-8?B?aU1LRjFmazgxNHgwZVVFaUZvd0lXQzNmK2o0RTJnaDJ6eDgzQU5CaXBpWENr?=
 =?utf-8?B?VzNvTXo5RmkyYlpwcmdsam82eFRwRWdXYnVGdWpSdURhc2w3MGM1aDFTcUIz?=
 =?utf-8?B?YXc0LzZFLzhELzhGQXF2LzBKMHEvK29KcHI3SDdSZ3ZzT3J3aGpUMklpWC9X?=
 =?utf-8?B?NHgwMUk5V1g1K1R2S2RxMTdVb2xZT1VJVnM3aHlGSFRjRWxzUlNHcUlpVHhQ?=
 =?utf-8?B?OWlRU05wUk84OXZreXdWMDB6L3RFNDB0MnFzUm1Fdks0c0U2SDNoYjByRndU?=
 =?utf-8?B?bzJxU0tNME5XVU1HM1JRcUQwTWNDaHFLU0N5NGdGRzQrbW5RMllsWUcwS0NK?=
 =?utf-8?B?Tld6WHdLN2hvQjFHZ0drbkQzT21GNEhabHpTN0w3TlBkSlpXQ3lGL2d1aG5I?=
 =?utf-8?B?MXNiMDZsK2V3bHorMXdtM1ExWFBjdG5qaFZ3azZHVlFkODc2YVFmc1E1U1E3?=
 =?utf-8?B?SUNzN2FCUGRqQVA1YmxtdGgveVVaUExzMnIxMzdxbkNiUVQrYUpveUEvK2Fj?=
 =?utf-8?B?ZEdPVzdlUS9Wb2ZoV29SNElzTW1NRi80alAxc1gvOW5FSTcvaGxtRHAyMVpR?=
 =?utf-8?B?RUcvNjhZbVNwWnFhV1o5aEJmWUNtZ3g5Q3VuSnNhUjFZdkU0VWgxK2h5QWZF?=
 =?utf-8?B?S1hVeVd5TTY0ZFgyWlNPZkptK1dESWVGaWt2eEJIQUF0OC9XOUZMajdZcTh3?=
 =?utf-8?B?N1pYQUNhWllGVk1LM3VBNThiM0M4bFhzcFlFQWRXY2d3SUc3QjVTbytpYm1R?=
 =?utf-8?B?MFFyUVN4OHFNUFpRYmE1aE5DUitoSDJ4OCtKcXBmaDg3ZHdRQXRaaG5YTzFG?=
 =?utf-8?B?WVlXZ3RJQW5zOXZXRndNaFlhemZLUHlzbjJNam9Xam5BV1FYYTZMN0MvSll1?=
 =?utf-8?B?N1grTS9VWXNxL2trYjJPbXZwMmI5UGdhSW1LV2MzRGQ0M3Y4MUJDQXpYWllY?=
 =?utf-8?B?Z1RtZzNRYTdUZjdJdlhteXlyd3ZXRTU3Ulh1VFRlYWZUZGlMbkwrcFFrcytl?=
 =?utf-8?B?TG9kbllObjk0TXVTa2pPeXlGemxHbGNuSE9adGxZVGpPVFZ4VEI2NlRTbStF?=
 =?utf-8?B?OG9yK2F3bFQwUkVmWXY2RU8rWjBYZGlrTDJXa2lJMndVL0Zha3B0R0YrNm9o?=
 =?utf-8?B?d0xsb2h2cGRBL01rWHYrTVJISEhHdStFaFE0RUhnMkJDS3F1bmI2QmZlT1h5?=
 =?utf-8?B?OWhXdmM5QUxZM3Bzb3FBZDk4LzY1SUplU3haN3FOcXZnQzBtKy9pUlFNOW9w?=
 =?utf-8?B?QjZyamdGMjlLeHVCYUpaY3RJbElSaXoyelVUeWptaEM2cU5YT2dVZDlhcnlP?=
 =?utf-8?B?dWFCTGRIdTNsTm1JbmVWNWw2SWRudXMzNWJtTUVZL1dTbmtpSlhRSlMwb0Jt?=
 =?utf-8?B?LzltODVFRlhxSWhDbFVPRlNXUXlsbTVIeUJETXB4d2JJL2hpZDhHRW9ucDgr?=
 =?utf-8?B?YTZkUVJCNStYOWppbXJ1d3QrSWZNSExJVjl5VHBaNTliL01aTXRJZTdOZ2dD?=
 =?utf-8?B?cExqbmZ0SGpRc1g3SHBlZzNkU1o4L2RBV042Yk5SckhSbGVzSHJWUEM2SDQv?=
 =?utf-8?B?TTdBcGtKYkpuRXUxT2d0Ry9IOUplV3QzNUN6QXBJNU1oVWtsWDhqMWg2Y1I5?=
 =?utf-8?B?Q2p5N3Q1dzMzNGdiNUsrcGc3Z2JFOVNOUVpSdjNjQ0RCUSs0UlVZZkVtK3VU?=
 =?utf-8?B?aHFYMmJyUmlzSDBkQVBsVzVVSE1oWDNkeE9TNmd3TTJxdFp6YUNkYno5ZGh4?=
 =?utf-8?B?K1ZLMlhBOUVZMGI5NUpiVThRaVZWSWozRXhCT0tPaWRPZUVwZW0xYnlXS2ZI?=
 =?utf-8?Q?KP3TBPL7JKU=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MW4PR11MB6739.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?WjdkTUlnUENUY1pSdUlYb0Rla3JDc1R2cXJQUExNWUhyUG1WTHBtUk5DMms5?=
 =?utf-8?B?VXZwSjE4dldhb0U4ZHF2blhIUmdqdFg3SHZBb2pBUUt5N2dIbjJpd0VDUUwx?=
 =?utf-8?B?Y0orMU01aGJYY0oycTVtb3VWZUhkcjNPUlExM3NxK2t5am1tb2pjRUtQdnIz?=
 =?utf-8?B?L21sNmxQRENYb20rUWpRK3V5WkRSaVJkY3pvSGtaUFFyZlRIUHhtS2VHa3pG?=
 =?utf-8?B?Y1FTU0ZRcWhuUWJxeEsyVTNPRTJrUzFGcXlGNnFJdmFpdVNJM1pOV0F0L0du?=
 =?utf-8?B?eDhvZG8xVkl6WTJkTk9LdStaUFFmRzc1YVFGYXRjMVk1bUY0VktPZWxvVm1l?=
 =?utf-8?B?UzIwdXU4U0o4NCtSeWlUbGxzWjg2S3JYbm96WC8rL2xnQ3o2dGZ4TnFabnMy?=
 =?utf-8?B?RGhkRG1KZGs3V0FyQitZWk02TlBURHFMUS9MaUs2M3JOVUpVMXdobXJoM3V3?=
 =?utf-8?B?R2pjbVEyZmMwd2VLNTB1V1pPQWFycEtvS2ZKSlpPT05kQmw4RlROMytUb3dp?=
 =?utf-8?B?MVZRVVNWTXV0SkVrTDJFa0xIb2Jic1VFSEVjUWJwZTJQMjhyTm0yclRJV0hY?=
 =?utf-8?B?ZkduLzZEYk1Bb09jZHphT0NObUYyNVpoSlAvQldhZUFTc0Q1UWpQb2ZqQzlM?=
 =?utf-8?B?Y09DYmdzdTUvZ1IrekptK2QvQ251NEcvNFFsK2lxaVg3SDZoWGJsYjZZeGRR?=
 =?utf-8?B?akNnQ1dYd1dkVFU5VTY4UnVlL3JaVDdtTXJ5NDNVZHNvaEc0QzN2dERSandB?=
 =?utf-8?B?cVlvSmtrenJzSjhIUUZDSDNlc0pBNlF5THVIbnp4SFFTTnFLbUJldHZ6R2RH?=
 =?utf-8?B?NHdmSWJRYjBOYnhkQTRmZEwxbld6NlpHNGVMQm5NOGhZQU5Vb2E2Nno2VXNQ?=
 =?utf-8?B?RndaUlFzK09MN05IMVA4SXJFOS81MUN2T1cxU0w5T3BCZ2hUaTR3UEtCZGdY?=
 =?utf-8?B?alVjNHBlVm9GMkRWdnhBT3pGbCtUcWh2MWhScEROZ3U2YlRHaktKUTRPcDE1?=
 =?utf-8?B?bHQ3b25HUytNclV3YmszV2RXOE84Rmo2UVQ0YW91ZEZaOGloaGdkdjAvUFBu?=
 =?utf-8?B?WUxZUlVqTjBDTy9DUVZ0cEI2OFd2ekZldVpqenpoRitjblRheHQ1Q3V1Z3Zl?=
 =?utf-8?B?a3hGRkRCMlBOVVR4WFRYQzFCbGZGUjIxQUZaTlVjRnk3NEZqYmQxZCswWWRZ?=
 =?utf-8?B?alBOdEpKTWpLZFlXSXVNalIzRmxhMkhsb3MyTzJJRzhRTVR3aG5GNGxhcVV6?=
 =?utf-8?B?OFo3SHlldEtORmVMODZjV1Q2OXYzL0lES0wrazZobXFsY1NLTVJaaVFXeTdQ?=
 =?utf-8?B?cmszVmluekR2QzEvRmN5NUtuRko3d2Q4TmZzY0IwU2dMcHkreGJzTUJRTFZs?=
 =?utf-8?B?SDBnSEdTTVJ2T2xyZjg4bEsvUGV3bHFwMHkwaUdTSlg4WjQ2ZlBxZ2h2MjVt?=
 =?utf-8?B?RXFKMEtTL2FodU53NU9ZRkttS2RzRlQ1bk1tNTZ1RDBVdWd0TXNvQ25HSDc2?=
 =?utf-8?B?cENuTmtodDBzQ0tUbTRpVDl5UUwvM2pwQzY4NktDUVNVRWowYWE4Qkx0b3RR?=
 =?utf-8?B?clFUdzh3RWFRNXBmUHpibTdwekk4aG5ub0l3RVIzUU9tSTJBVGE5dk9ES2FO?=
 =?utf-8?B?NEVWNjJXNXZOZDdVMU5lN1MvRmVpMFhPZzhodXhOQWhINGFEQkp2TTZTeXgx?=
 =?utf-8?B?RksvbHkySTU2QUJOQk1tbjZsWmhiYnVaVWp4bjdYaFBpU1A3UG5vM1E0NzJV?=
 =?utf-8?B?UFUzYmtjUUxvajd3L0Fhb2o5SUhDdTg5cVBkQzBUaWcrNGsxZlY2anI1ck1i?=
 =?utf-8?B?UE5XdmRmTDdlTFZUYXRzeHBTeTJ6eVoxZ3NHeG55UmNXUmFSTXFCaUtiTlFC?=
 =?utf-8?B?UVVxWmhTVGJFekRtb2xjUzNQWDVNV1BOdGtzM2dHME1uemZlUWk1d1pVaVBB?=
 =?utf-8?B?TEhTRnFxWm50S05ycHVOMVp3c29mb2pjbzlmcndSbzdTVEZxc3gxTFRNM3VZ?=
 =?utf-8?B?c0s2Qnc2VmhJMW1GaFRCc0wwcW9RcEl6MzBpdFRWOXpOSGZvSDVEa3A4NzdS?=
 =?utf-8?B?TS82WGI1cDA3Lyt5Y2FXdHhpMFNjR2FlZmRwTU9NWGdGU2htTDUxRkZBeTM0?=
 =?utf-8?Q?C53JXlmkZoAn4Q6wTCtEkUI1/?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 16ec98af-ac4b-466e-1458-08dd7addd553
X-MS-Exchange-CrossTenant-AuthSource: MW4PR11MB6739.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Apr 2025 22:52:14.4720
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: UQJ2ufx/jBtLpUYZpyf5DhFF3mlzBclywOH1z8Z+ZvdTxnZdYBphVW/3SBO+6yITUau93kvWIB3KrxJxq3vefQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR11MB7003
X-OriginatorOrg: intel.com

cxl_test provides a good way to ensure quick smoke and regression
testing.  The complexity of Dynamic Capacity (DC) extent processing as
well as the complexity of the new sparse DAX regions can mostly be
tested through cxl_test.  This includes management of sparse regions and
DAX devices on those regions; the management of extent device lifetimes;
and the processing of DCD events.

The only missing functionality from this test is actual interrupt
processing.

Mock memory devices can easily mock DC information and manage fake
extent data.

Define mock_dc_partition information within the mock memory data.  Add
sysfs entries on the mock device to inject and delete extents.

The inject format is <start>:<length>:<tag>:<more_flag>
The delete format is <start>:<length>

Directly call the event irq callback to simulate irqs to process the
test extents.

Add DC mailbox commands to the CEL and implement those commands.

Reviewed-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Reviewed-by: Dave Jiang <dave.jiang@intel.com>
Signed-off-by: Ira Weiny <ira.weiny@intel.com>

---
Changes:
[iweiny: rebase]
[djbw: s/region/partition/]
[iweiny: s/tag/uuid/]
---
 tools/testing/cxl/test/mem.c | 753 +++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 753 insertions(+)

diff --git a/tools/testing/cxl/test/mem.c b/tools/testing/cxl/test/mem.c
index a71a72966de1..a85a04168434 100644
--- a/tools/testing/cxl/test/mem.c
+++ b/tools/testing/cxl/test/mem.c
@@ -20,6 +20,7 @@
 #define FW_SLOTS 3
 #define DEV_SIZE SZ_2G
 #define EFFECT(x) (1U << x)
+#define BASE_DYNAMIC_CAP_DPA DEV_SIZE
 
 #define MOCK_INJECT_DEV_MAX 8
 #define MOCK_INJECT_TEST_MAX 128
@@ -113,6 +114,22 @@ static struct cxl_cel_entry mock_cel[] = {
 				      EFFECT(SECURITY_CHANGE_IMMEDIATE) |
 				      EFFECT(BACKGROUND_OP)),
 	},
+	{
+		.opcode = cpu_to_le16(CXL_MBOX_OP_GET_DC_CONFIG),
+		.effect = CXL_CMD_EFFECT_NONE,
+	},
+	{
+		.opcode = cpu_to_le16(CXL_MBOX_OP_GET_DC_EXTENT_LIST),
+		.effect = CXL_CMD_EFFECT_NONE,
+	},
+	{
+		.opcode = cpu_to_le16(CXL_MBOX_OP_ADD_DC_RESPONSE),
+		.effect = cpu_to_le16(EFFECT(CONF_CHANGE_IMMEDIATE)),
+	},
+	{
+		.opcode = cpu_to_le16(CXL_MBOX_OP_RELEASE_DC),
+		.effect = cpu_to_le16(EFFECT(CONF_CHANGE_IMMEDIATE)),
+	},
 };
 
 /* See CXL 2.0 Table 181 Get Health Info Output Payload */
@@ -173,6 +190,8 @@ struct vendor_test_feat {
 	__le32 data;
 } __packed;
 
+#define NUM_MOCK_DC_REGIONS 2
+
 struct cxl_mockmem_data {
 	void *lsa;
 	void *fw;
@@ -191,6 +210,20 @@ struct cxl_mockmem_data {
 	unsigned long sanitize_timeout;
 	struct vendor_test_feat test_feat;
 	u8 shutdown_state;
+
+	struct cxl_dc_partition dc_partitions[NUM_MOCK_DC_REGIONS];
+	u32 dc_ext_generation;
+	struct mutex ext_lock;
+
+	/*
+	 * Extents are in 1 of 3 states
+	 * FM (sysfs added but not sent to the host yet)
+	 * sent (sent to the host but not accepted)
+	 * accepted (by the host)
+	 */
+	struct xarray dc_fm_extents;
+	struct xarray dc_sent_extents;
+	struct xarray dc_accepted_exts;
 };
 
 static struct mock_event_log *event_find_log(struct device *dev, int log_type)
@@ -607,6 +640,251 @@ static void cxl_mock_event_trigger(struct device *dev)
 	cxl_mem_get_event_records(mdata->mds, mes->ev_status);
 }
 
+struct cxl_extent_data {
+	u64 dpa_start;
+	u64 length;
+	u8 uuid[UUID_SIZE];
+	bool shared;
+};
+
+static int __devm_add_extent(struct device *dev, struct xarray *array,
+			     u64 start, u64 length, const char *uuid,
+			     bool shared)
+{
+	struct cxl_extent_data *extent;
+
+	extent = devm_kzalloc(dev, sizeof(*extent), GFP_KERNEL);
+	if (!extent)
+		return -ENOMEM;
+
+	extent->dpa_start = start;
+	extent->length = length;
+	memcpy(extent->uuid, uuid, min(sizeof(extent->uuid), strlen(uuid)));
+	extent->shared = shared;
+
+	if (xa_insert(array, start, extent, GFP_KERNEL)) {
+		devm_kfree(dev, extent);
+		dev_err(dev, "Failed xarry insert %#llx\n", start);
+		return -EINVAL;
+	}
+
+	return 0;
+}
+
+static int devm_add_fm_extent(struct device *dev, u64 start, u64 length,
+			      const char *uuid, bool shared)
+{
+	struct cxl_mockmem_data *mdata = dev_get_drvdata(dev);
+
+	guard(mutex)(&mdata->ext_lock);
+	return __devm_add_extent(dev, &mdata->dc_fm_extents, start, length,
+				 uuid, shared);
+}
+
+/* It is known that ext and the new range are not equal */
+static struct cxl_extent_data *
+split_ext(struct device *dev, struct xarray *array,
+	  struct cxl_extent_data *ext, u64 start, u64 length)
+{
+	u64 new_start, new_length;
+
+	if (ext->dpa_start == start) {
+		new_start = start + length;
+		new_length = (ext->dpa_start + ext->length) - new_start;
+
+		if (__devm_add_extent(dev, array, new_start, new_length,
+				      ext->uuid, false))
+			return NULL;
+
+		ext = xa_erase(array, ext->dpa_start);
+		if (__devm_add_extent(dev, array, start, length, ext->uuid,
+				      false))
+			return NULL;
+
+		return xa_load(array, start);
+	}
+
+	/* ext->dpa_start != start */
+
+	if (__devm_add_extent(dev, array, start, length, ext->uuid, false))
+		return NULL;
+
+	new_start = ext->dpa_start;
+	new_length = start - ext->dpa_start;
+
+	ext = xa_erase(array, ext->dpa_start);
+	if (__devm_add_extent(dev, array, new_start, new_length, ext->uuid,
+			      false))
+		return NULL;
+
+	return xa_load(array, start);
+}
+
+/*
+ * Do not handle extents which are not inside a single extent sent to
+ * the host.
+ */
+static struct cxl_extent_data *
+find_create_ext(struct device *dev, struct xarray *array, u64 start, u64 length)
+{
+	struct cxl_extent_data *ext;
+	unsigned long index;
+
+	xa_for_each(array, index, ext) {
+		u64 end = start + length;
+
+		/* start < [ext) <= start */
+		if (start < ext->dpa_start ||
+		    (ext->dpa_start + ext->length) <= start)
+			continue;
+
+		if (end <= ext->dpa_start ||
+		    (ext->dpa_start + ext->length) < end) {
+			dev_err(dev, "Invalid range %#llx-%#llx\n", start,
+				end);
+			return NULL;
+		}
+
+		break;
+	}
+
+	if (!ext)
+		return NULL;
+
+	if (start == ext->dpa_start && length == ext->length)
+		return ext;
+
+	return split_ext(dev, array, ext, start, length);
+}
+
+static int dc_accept_extent(struct device *dev, u64 start, u64 length)
+{
+	struct cxl_mockmem_data *mdata = dev_get_drvdata(dev);
+	struct cxl_extent_data *ext;
+
+	dev_dbg(dev, "Host accepting extent %#llx\n", start);
+	mdata->dc_ext_generation++;
+
+	lockdep_assert_held(&mdata->ext_lock);
+	ext = find_create_ext(dev, &mdata->dc_sent_extents, start, length);
+	if (!ext) {
+		dev_err(dev, "Extent %#llx-%#llx not found\n",
+			start, start + length);
+		return -ENOMEM;
+	}
+	ext = xa_erase(&mdata->dc_sent_extents, ext->dpa_start);
+	return xa_insert(&mdata->dc_accepted_exts, start, ext, GFP_KERNEL);
+}
+
+static void release_dc_ext(void *md)
+{
+	struct cxl_mockmem_data *mdata = md;
+
+	xa_destroy(&mdata->dc_fm_extents);
+	xa_destroy(&mdata->dc_sent_extents);
+	xa_destroy(&mdata->dc_accepted_exts);
+}
+
+/* Pretend to have some previous accepted extents */
+struct pre_ext_info {
+	u64 offset;
+	u64 length;
+} pre_ext_info[] = {
+	{
+		.offset = SZ_128M,
+		.length = SZ_64M,
+	},
+	{
+		.offset = SZ_256M,
+		.length = SZ_64M,
+	},
+};
+
+static int devm_add_sent_extent(struct device *dev, u64 start, u64 length,
+				const char *tag, bool shared)
+{
+	struct cxl_mockmem_data *mdata = dev_get_drvdata(dev);
+
+	lockdep_assert_held(&mdata->ext_lock);
+	return __devm_add_extent(dev, &mdata->dc_sent_extents, start, length,
+				 tag, shared);
+}
+
+static int inject_prev_extents(struct device *dev, u64 base_dpa)
+{
+	struct cxl_mockmem_data *mdata = dev_get_drvdata(dev);
+	int rc;
+
+	dev_dbg(dev, "Adding %ld pre-extents for testing\n",
+		ARRAY_SIZE(pre_ext_info));
+
+	guard(mutex)(&mdata->ext_lock);
+	for (int i = 0; i < ARRAY_SIZE(pre_ext_info); i++) {
+		u64 ext_dpa = base_dpa + pre_ext_info[i].offset;
+		u64 ext_len = pre_ext_info[i].length;
+
+		dev_dbg(dev, "Adding pre-extent DPA:%#llx LEN:%#llx\n",
+			ext_dpa, ext_len);
+
+		rc = devm_add_sent_extent(dev, ext_dpa, ext_len, "", false);
+		if (rc) {
+			dev_err(dev, "Failed to add pre-extent DPA:%#llx LEN:%#llx; %d\n",
+				ext_dpa, ext_len, rc);
+			return rc;
+		}
+
+		rc = dc_accept_extent(dev, ext_dpa, ext_len);
+		if (rc)
+			return rc;
+	}
+	return 0;
+}
+
+static int cxl_mock_dc_partition_setup(struct device *dev)
+{
+	struct cxl_mockmem_data *mdata = dev_get_drvdata(dev);
+	u64 base_dpa = BASE_DYNAMIC_CAP_DPA;
+	u32 dsmad_handle = 0xFADE;
+	u64 decode_length = SZ_512M;
+	u64 block_size = SZ_512;
+	u64 length = SZ_512M;
+	int rc;
+
+	mutex_init(&mdata->ext_lock);
+	xa_init(&mdata->dc_fm_extents);
+	xa_init(&mdata->dc_sent_extents);
+	xa_init(&mdata->dc_accepted_exts);
+
+	rc = devm_add_action_or_reset(dev, release_dc_ext, mdata);
+	if (rc)
+		return rc;
+
+	for (int i = 0; i < NUM_MOCK_DC_REGIONS; i++) {
+		struct cxl_dc_partition *part = &mdata->dc_partitions[i];
+
+		dev_dbg(dev, "Creating DC partition DC%d DPA:%#llx LEN:%#llx\n",
+			i, base_dpa, length);
+
+		part->base = cpu_to_le64(base_dpa);
+		part->decode_length = cpu_to_le64(decode_length /
+						  CXL_CAPACITY_MULTIPLIER);
+		part->length = cpu_to_le64(length);
+		part->block_size = cpu_to_le64(block_size);
+		part->dsmad_handle = cpu_to_le32(dsmad_handle);
+		dsmad_handle++;
+
+		rc = inject_prev_extents(dev, base_dpa);
+		if (rc) {
+			dev_err(dev, "Failed to add pre-extents for DC%d\n", i);
+			return rc;
+		}
+
+		base_dpa += decode_length;
+	}
+
+	return 0;
+}
+
 static int mock_gsl(struct cxl_mbox_cmd *cmd)
 {
 	if (cmd->size_out < sizeof(mock_gsl_payload))
@@ -1582,6 +1860,192 @@ static int mock_get_supported_features(struct cxl_mockmem_data *mdata,
 	return 0;
 }
 
+static int mock_get_dc_config(struct device *dev,
+			      struct cxl_mbox_cmd *cmd)
+{
+	struct cxl_mbox_get_dc_config_in *dc_config = cmd->payload_in;
+	struct cxl_mockmem_data *mdata = dev_get_drvdata(dev);
+	u8 partition_requested, partition_start_idx, partition_ret_cnt;
+	struct cxl_mbox_get_dc_config_out *resp;
+	int i;
+
+	partition_requested = min(dc_config->partition_count, NUM_MOCK_DC_REGIONS);
+
+	if (cmd->size_out < struct_size(resp, partition, partition_requested))
+		return -EINVAL;
+
+	memset(cmd->payload_out, 0, cmd->size_out);
+	resp = cmd->payload_out;
+
+	partition_start_idx = dc_config->start_partition_index;
+	partition_ret_cnt = 0;
+	for (i = 0; i < NUM_MOCK_DC_REGIONS; i++) {
+		if (i >= partition_start_idx) {
+			memcpy(&resp->partition[partition_ret_cnt],
+				&mdata->dc_partitions[i],
+				sizeof(resp->partition[partition_ret_cnt]));
+			partition_ret_cnt++;
+		}
+	}
+	resp->avail_partition_count = NUM_MOCK_DC_REGIONS;
+	resp->partitions_returned = i;
+
+	dev_dbg(dev, "Returning %d dc partitions\n", partition_ret_cnt);
+	return 0;
+}
+
+static int mock_get_dc_extent_list(struct device *dev,
+				   struct cxl_mbox_cmd *cmd)
+{
+	struct cxl_mbox_get_extent_out *resp = cmd->payload_out;
+	struct cxl_mockmem_data *mdata = dev_get_drvdata(dev);
+	struct cxl_mbox_get_extent_in *get = cmd->payload_in;
+	u32 total_avail = 0, total_ret = 0;
+	struct cxl_extent_data *ext;
+	u32 ext_count, start_idx;
+	unsigned long i;
+
+	ext_count = le32_to_cpu(get->extent_cnt);
+	start_idx = le32_to_cpu(get->start_extent_index);
+
+	memset(resp, 0, sizeof(*resp));
+
+	guard(mutex)(&mdata->ext_lock);
+	/*
+	 * Total available needs to be calculated and returned regardless of
+	 * how many can actually be returned.
+	 */
+	xa_for_each(&mdata->dc_accepted_exts, i, ext)
+		total_avail++;
+
+	if (start_idx > total_avail)
+		return -EINVAL;
+
+	xa_for_each(&mdata->dc_accepted_exts, i, ext) {
+		if (total_ret >= ext_count)
+			break;
+
+		if (total_ret >= start_idx) {
+			resp->extent[total_ret].start_dpa =
+						cpu_to_le64(ext->dpa_start);
+			resp->extent[total_ret].length =
+						cpu_to_le64(ext->length);
+			memcpy(&resp->extent[total_ret].uuid, ext->uuid,
+					sizeof(resp->extent[total_ret]));
+			total_ret++;
+		}
+	}
+
+	resp->returned_extent_count = cpu_to_le32(total_ret);
+	resp->total_extent_count = cpu_to_le32(total_avail);
+	resp->generation_num = cpu_to_le32(mdata->dc_ext_generation);
+
+	dev_dbg(dev, "Returning %d extents of %d total\n",
+		total_ret, total_avail);
+
+	return 0;
+}
+
+static void dc_clear_sent(struct device *dev)
+{
+	struct cxl_mockmem_data *mdata = dev_get_drvdata(dev);
+	struct cxl_extent_data *ext;
+	unsigned long index;
+
+	lockdep_assert_held(&mdata->ext_lock);
+
+	/* Any extents not accepted must be cleared */
+	xa_for_each(&mdata->dc_sent_extents, index, ext) {
+		dev_dbg(dev, "Host rejected extent %#llx\n", ext->dpa_start);
+		xa_erase(&mdata->dc_sent_extents, ext->dpa_start);
+	}
+}
+
+static int mock_add_dc_response(struct device *dev,
+				struct cxl_mbox_cmd *cmd)
+{
+	struct cxl_mockmem_data *mdata = dev_get_drvdata(dev);
+	struct cxl_mbox_dc_response *req = cmd->payload_in;
+	u32 list_size = le32_to_cpu(req->extent_list_size);
+
+	guard(mutex)(&mdata->ext_lock);
+	for (int i = 0; i < list_size; i++) {
+		u64 start = le64_to_cpu(req->extent_list[i].dpa_start);
+		u64 length = le64_to_cpu(req->extent_list[i].length);
+		int rc;
+
+		rc = dc_accept_extent(dev, start, length);
+		if (rc)
+			return rc;
+	}
+
+	dc_clear_sent(dev);
+	return 0;
+}
+
+static void dc_delete_extent(struct device *dev, unsigned long long start,
+			     unsigned long long length)
+{
+	struct cxl_mockmem_data *mdata = dev_get_drvdata(dev);
+	unsigned long long end = start + length;
+	struct cxl_extent_data *ext;
+	unsigned long index;
+
+	dev_dbg(dev, "Deleting extent at %#llx len:%#llx\n", start, length);
+
+	guard(mutex)(&mdata->ext_lock);
+	xa_for_each(&mdata->dc_fm_extents, index, ext) {
+		u64 extent_end = ext->dpa_start + ext->length;
+
+		/*
+		 * Any extent which 'touches' the released delete range will be
+		 * removed.
+		 */
+		if ((start <= ext->dpa_start && ext->dpa_start < end) ||
+		    (start <= extent_end && extent_end < end))
+			xa_erase(&mdata->dc_fm_extents, ext->dpa_start);
+	}
+
+	/*
+	 * If the extent was accepted let it be for the host to drop
+	 * later.
+	 */
+}
+
+static int release_accepted_extent(struct device *dev, u64 start, u64 length)
+{
+	struct cxl_mockmem_data *mdata = dev_get_drvdata(dev);
+	struct cxl_extent_data *ext;
+
+	guard(mutex)(&mdata->ext_lock);
+	ext = find_create_ext(dev, &mdata->dc_accepted_exts, start, length);
+	if (!ext) {
+		dev_err(dev, "Extent %#llx not in accepted state\n", start);
+		return -EINVAL;
+	}
+	xa_erase(&mdata->dc_accepted_exts, ext->dpa_start);
+	mdata->dc_ext_generation++;
+
+	return 0;
+}
+
+static int mock_dc_release(struct device *dev,
+			   struct cxl_mbox_cmd *cmd)
+{
+	struct cxl_mbox_dc_response *req = cmd->payload_in;
+	u32 list_size = le32_to_cpu(req->extent_list_size);
+
+	for (int i = 0; i < list_size; i++) {
+		u64 start = le64_to_cpu(req->extent_list[i].dpa_start);
+		u64 length = le64_to_cpu(req->extent_list[i].length);
+
+		dev_dbg(dev, "Extent %#llx released by host\n", start);
+		release_accepted_extent(dev, start, length);
+	}
+
+	return 0;
+}
+
 static int cxl_mock_mbox_send(struct cxl_mailbox *cxl_mbox,
 			      struct cxl_mbox_cmd *cmd)
 {
@@ -1673,6 +2137,18 @@ static int cxl_mock_mbox_send(struct cxl_mailbox *cxl_mbox,
 	case CXL_MBOX_OP_GET_SUPPORTED_FEATURES:
 		rc = mock_get_supported_features(mdata, cmd);
 		break;
+	case CXL_MBOX_OP_GET_DC_CONFIG:
+		rc = mock_get_dc_config(dev, cmd);
+		break;
+	case CXL_MBOX_OP_GET_DC_EXTENT_LIST:
+		rc = mock_get_dc_extent_list(dev, cmd);
+		break;
+	case CXL_MBOX_OP_ADD_DC_RESPONSE:
+		rc = mock_add_dc_response(dev, cmd);
+		break;
+	case CXL_MBOX_OP_RELEASE_DC:
+		rc = mock_dc_release(dev, cmd);
+		break;
 	case CXL_MBOX_OP_GET_FEATURE:
 		rc = mock_get_feature(mdata, cmd);
 		break;
@@ -1755,6 +2231,10 @@ static int cxl_mock_mem_probe(struct platform_device *pdev)
 		return -ENOMEM;
 	dev_set_drvdata(dev, mdata);
 
+	rc = cxl_mock_dc_partition_setup(dev);
+	if (rc)
+		return rc;
+
 	mdata->lsa = vmalloc(LSA_SIZE);
 	if (!mdata->lsa)
 		return -ENOMEM;
@@ -1812,6 +2292,9 @@ static int cxl_mock_mem_probe(struct platform_device *pdev)
 	if (rc)
 		return rc;
 
+	if (cxl_dcd_supported(mds))
+		cxl_configure_dcd(mds, &range_info);
+
 	rc = cxl_dpa_setup(cxlds, &range_info);
 	if (rc)
 		return rc;
@@ -1936,11 +2419,281 @@ static ssize_t sanitize_timeout_store(struct device *dev,
 
 static DEVICE_ATTR_RW(sanitize_timeout);
 
+/* Return if the proposed extent would break the test code */
+static bool new_extent_valid(struct device *dev, size_t new_start,
+			     size_t new_len)
+{
+	struct cxl_mockmem_data *mdata = dev_get_drvdata(dev);
+	struct cxl_extent_data *extent;
+	size_t new_end, i;
+
+	if (!new_len)
+		return false;
+
+	new_end = new_start + new_len;
+
+	dev_dbg(dev, "New extent %zx-%zx\n", new_start, new_end);
+
+	guard(mutex)(&mdata->ext_lock);
+	dev_dbg(dev, "Checking extents starts...\n");
+	xa_for_each(&mdata->dc_fm_extents, i, extent) {
+		if (extent->dpa_start == new_start)
+			return false;
+	}
+
+	dev_dbg(dev, "Checking sent extents starts...\n");
+	xa_for_each(&mdata->dc_sent_extents, i, extent) {
+		if (extent->dpa_start == new_start)
+			return false;
+	}
+
+	dev_dbg(dev, "Checking accepted extents starts...\n");
+	xa_for_each(&mdata->dc_accepted_exts, i, extent) {
+		if (extent->dpa_start == new_start)
+			return false;
+	}
+
+	return true;
+}
+
+struct cxl_test_dcd {
+	uuid_t id;
+	struct cxl_event_dcd rec;
+} __packed;
+
+struct cxl_test_dcd dcd_event_rec_template = {
+	.id = CXL_EVENT_DC_EVENT_UUID,
+	.rec = {
+		.hdr = {
+			.length = sizeof(struct cxl_test_dcd),
+		},
+	},
+};
+
+static int log_dc_event(struct cxl_mockmem_data *mdata, enum dc_event type,
+			u64 start, u64 length, const char *tag_str, bool more)
+{
+	struct device *dev = mdata->mds->cxlds.dev;
+	struct cxl_test_dcd *dcd_event;
+
+	dev_dbg(dev, "mock device log event %d\n", type);
+
+	dcd_event = devm_kmemdup(dev, &dcd_event_rec_template,
+				     sizeof(*dcd_event), GFP_KERNEL);
+	if (!dcd_event)
+		return -ENOMEM;
+
+	dcd_event->rec.flags = 0;
+	if (more)
+		dcd_event->rec.flags |= CXL_DCD_EVENT_MORE;
+	dcd_event->rec.event_type = type;
+	dcd_event->rec.extent.start_dpa = cpu_to_le64(start);
+	dcd_event->rec.extent.length = cpu_to_le64(length);
+	memcpy(dcd_event->rec.extent.uuid, tag_str,
+	       min(sizeof(dcd_event->rec.extent.uuid),
+		   strlen(tag_str)));
+
+	mes_add_event(mdata, CXL_EVENT_TYPE_DCD,
+		      (struct cxl_event_record_raw *)dcd_event);
+
+	/* Fake the irq */
+	cxl_mem_get_event_records(mdata->mds, CXLDEV_EVENT_STATUS_DCD);
+
+	return 0;
+}
+
+static void mark_extent_sent(struct device *dev, unsigned long long start)
+{
+	struct cxl_mockmem_data *mdata = dev_get_drvdata(dev);
+	struct cxl_extent_data *ext;
+
+	guard(mutex)(&mdata->ext_lock);
+	ext = xa_erase(&mdata->dc_fm_extents, start);
+	if (xa_insert(&mdata->dc_sent_extents, ext->dpa_start, ext, GFP_KERNEL))
+		dev_err(dev, "Failed to mark extent %#llx sent\n", ext->dpa_start);
+}
+
+/*
+ * Format <start>:<length>:<tag>:<more_flag>
+ *
+ * start and length must be a multiple of the configured partition block size.
+ * Tag can be any string up to 16 bytes.
+ *
+ * Extents must be exclusive of other extents
+ *
+ * If the more flag is specified it is expected that an additional extent will
+ * be specified without the more flag to complete the test transaction with the
+ * host.
+ */
+static ssize_t __dc_inject_extent_store(struct device *dev,
+					struct device_attribute *attr,
+					const char *buf, size_t count,
+					bool shared)
+{
+	struct cxl_mockmem_data *mdata = dev_get_drvdata(dev);
+	unsigned long long start, length, more;
+	char *len_str, *uuid_str, *more_str;
+	size_t buf_len = count;
+	int rc;
+
+	char *start_str __free(kfree) = kstrdup(buf, GFP_KERNEL);
+	if (!start_str)
+		return -ENOMEM;
+
+	len_str = strnchr(start_str, buf_len, ':');
+	if (!len_str) {
+		dev_err(dev, "Extent failed to find len_str: %s\n", start_str);
+		return -EINVAL;
+	}
+
+	*len_str = '\0';
+	len_str += 1;
+	buf_len -= strlen(start_str);
+
+	uuid_str = strnchr(len_str, buf_len, ':');
+	if (!uuid_str) {
+		dev_err(dev, "Extent failed to find uuid_str: %s\n", len_str);
+		return -EINVAL;
+	}
+	*uuid_str = '\0';
+	uuid_str += 1;
+
+	more_str = strnchr(uuid_str, buf_len, ':');
+	if (!more_str) {
+		dev_err(dev, "Extent failed to find more_str: %s\n", uuid_str);
+		return -EINVAL;
+	}
+	*more_str = '\0';
+	more_str += 1;
+
+	if (kstrtoull(start_str, 0, &start)) {
+		dev_err(dev, "Extent failed to parse start: %s\n", start_str);
+		return -EINVAL;
+	}
+
+	if (kstrtoull(len_str, 0, &length)) {
+		dev_err(dev, "Extent failed to parse length: %s\n", len_str);
+		return -EINVAL;
+	}
+
+	if (kstrtoull(more_str, 0, &more)) {
+		dev_err(dev, "Extent failed to parse more: %s\n", more_str);
+		return -EINVAL;
+	}
+
+	if (!new_extent_valid(dev, start, length))
+		return -EINVAL;
+
+	rc = devm_add_fm_extent(dev, start, length, uuid_str, shared);
+	if (rc) {
+		dev_err(dev, "Failed to add extent DPA:%#llx LEN:%#llx; %d\n",
+			start, length, rc);
+		return rc;
+	}
+
+	mark_extent_sent(dev, start);
+	rc = log_dc_event(mdata, DCD_ADD_CAPACITY, start, length, uuid_str, more);
+	if (rc) {
+		dev_err(dev, "Failed to add event %d\n", rc);
+		return rc;
+	}
+
+	return count;
+}
+
+static ssize_t dc_inject_extent_store(struct device *dev,
+				      struct device_attribute *attr,
+				      const char *buf, size_t count)
+{
+	return __dc_inject_extent_store(dev, attr, buf, count, false);
+}
+static DEVICE_ATTR_WO(dc_inject_extent);
+
+static ssize_t dc_inject_shared_extent_store(struct device *dev,
+					     struct device_attribute *attr,
+					     const char *buf, size_t count)
+{
+	return __dc_inject_extent_store(dev, attr, buf, count, true);
+}
+static DEVICE_ATTR_WO(dc_inject_shared_extent);
+
+static ssize_t __dc_del_extent_store(struct device *dev,
+				     struct device_attribute *attr,
+				     const char *buf, size_t count,
+				     enum dc_event type)
+{
+	struct cxl_mockmem_data *mdata = dev_get_drvdata(dev);
+	unsigned long long start, length;
+	char *len_str;
+	int rc;
+
+	char *start_str __free(kfree) = kstrdup(buf, GFP_KERNEL);
+	if (!start_str)
+		return -ENOMEM;
+
+	len_str = strnchr(start_str, count, ':');
+	if (!len_str) {
+		dev_err(dev, "Failed to find len_str: %s\n", start_str);
+		return -EINVAL;
+	}
+	*len_str = '\0';
+	len_str += 1;
+
+	if (kstrtoull(start_str, 0, &start)) {
+		dev_err(dev, "Failed to parse start: %s\n", start_str);
+		return -EINVAL;
+	}
+
+	if (kstrtoull(len_str, 0, &length)) {
+		dev_err(dev, "Failed to parse length: %s\n", len_str);
+		return -EINVAL;
+	}
+
+	dc_delete_extent(dev, start, length);
+
+	if (type == DCD_FORCED_CAPACITY_RELEASE)
+		dev_dbg(dev, "Forcing delete of extent %#llx len:%#llx\n",
+			start, length);
+
+	rc = log_dc_event(mdata, type, start, length, "", false);
+	if (rc) {
+		dev_err(dev, "Failed to add event %d\n", rc);
+		return rc;
+	}
+
+	return count;
+}
+
+/*
+ * Format <start>:<length>
+ */
+static ssize_t dc_del_extent_store(struct device *dev,
+				   struct device_attribute *attr,
+				   const char *buf, size_t count)
+{
+	return __dc_del_extent_store(dev, attr, buf, count,
+				     DCD_RELEASE_CAPACITY);
+}
+static DEVICE_ATTR_WO(dc_del_extent);
+
+static ssize_t dc_force_del_extent_store(struct device *dev,
+					 struct device_attribute *attr,
+					 const char *buf, size_t count)
+{
+	return __dc_del_extent_store(dev, attr, buf, count,
+				     DCD_FORCED_CAPACITY_RELEASE);
+}
+static DEVICE_ATTR_WO(dc_force_del_extent);
+
 static struct attribute *cxl_mock_mem_attrs[] = {
 	&dev_attr_security_lock.attr,
 	&dev_attr_event_trigger.attr,
 	&dev_attr_fw_buf_checksum.attr,
 	&dev_attr_sanitize_timeout.attr,
+	&dev_attr_dc_inject_extent.attr,
+	&dev_attr_dc_inject_shared_extent.attr,
+	&dev_attr_dc_del_extent.attr,
+	&dev_attr_dc_force_del_extent.attr,
 	NULL
 };
 ATTRIBUTE_GROUPS(cxl_mock_mem);

-- 
2.49.0

