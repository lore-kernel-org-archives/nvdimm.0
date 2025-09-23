Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.8])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B7F6A301464
	for <nvdimm@lists.linux.dev>; Tue, 23 Sep 2025 18:32:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.8
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758652350; cv=fail; b=OlLPi1KG751qOE3BYVz1K8TDIOSQZb1VcmqWRjCUqMDlq4kR1jIQOBGx62M7LGvnXHFj9Zsf0ahV2r4tkGvzZdkoUUgjWOMFm1P9FHzhbzFCiyYd2WdDekVJbmxOG7kwU/nHDfujMQEfbXcGm3oMDA647r9ncNiQOJCBffk2fkA=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758652350; c=relaxed/simple;
	bh=6vsz9/4KXyl35G+pYIKBdH8DW2Z9TvD5sgrTtqxMjvo=;
	h=From:Date:To:CC:Message-ID:In-Reply-To:References:Subject:
	 Content-Type:MIME-Version; b=iEr4DHeIvevywaAgYo6LrqIMDI9ae4aI3je1wkXxYeLCCZ0BN7Z0AYaNdLgy/M/2blAdjH1BXaCSZm4AsFSxA8leYmpzHaX+6Jnz4Qy3b8ErwG95/eh/zmfuPf8ugKUwqI8r/Zxm3/6HH0M7Ax+Ppv0iv8QJwun6ZZw+ItFTPN4=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=Qo/I22wA; arc=fail smtp.client-ip=192.198.163.8
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="Qo/I22wA"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1758652349; x=1790188349;
  h=from:date:to:cc:message-id:in-reply-to:references:
   subject:content-transfer-encoding:mime-version;
  bh=6vsz9/4KXyl35G+pYIKBdH8DW2Z9TvD5sgrTtqxMjvo=;
  b=Qo/I22wAwPm4ZdCbEtGs0LCyLIfo8rkTXSJN9mgWCe48YgEYUd7SluyK
   V6RQ8+/BxU1TsWbqzn0eY2lMBbFkj1IlYP5LkbdfqLxnxXdAlIC1mS/QC
   1vVugyNRrY8j+7NW7y0I4b9XGUc/GwbeZ5YnZINivJRmzT3o+eVRZTdCM
   gHZ5io1VNvckTQ0sYCOABu3rbAv8kE+nrDeEHmc1i5wfMvXBI/JoaZd+h
   CG9gBILp4wQNZdDhxkZpC/Sy5a4vNIYtz2iaxg/V7Uw3SsgAh27D0OSKg
   RP0MIx99/wfYJTnxT0P12WLiFOsnyIoXBV00t+l1aCULGop59vj9TirZz
   g==;
X-CSE-ConnectionGUID: JofL4bAKR+WeUhxLYNX7EQ==
X-CSE-MsgGUID: D/WfbxmCQlSSY2JOgWzWrQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11561"; a="78548597"
X-IronPort-AV: E=Sophos;i="6.18,288,1751266800"; 
   d="scan'208";a="78548597"
Received: from orviesa004.jf.intel.com ([10.64.159.144])
  by fmvoesa102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Sep 2025 11:32:27 -0700
X-CSE-ConnectionGUID: R0RNaVjwQ+u3tz9pdosKcw==
X-CSE-MsgGUID: 3JBmGkwgSPmn8QKRc8ZjJw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.18,288,1751266800"; 
   d="scan'208";a="181148095"
Received: from orsmsx901.amr.corp.intel.com ([10.22.229.23])
  by orviesa004.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Sep 2025 11:32:26 -0700
Received: from ORSMSX901.amr.corp.intel.com (10.22.229.23) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.17; Tue, 23 Sep 2025 11:32:25 -0700
Received: from ORSEDG901.ED.cps.intel.com (10.7.248.11) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.17 via Frontend Transport; Tue, 23 Sep 2025 11:32:25 -0700
Received: from PH8PR06CU001.outbound.protection.outlook.com (40.107.209.48) by
 edgegateway.intel.com (134.134.137.111) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.17; Tue, 23 Sep 2025 11:32:25 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Qfp066u8jdIF80hQKkfXCpWqvcsZPGV3RHfasMBvsFOI6Bg2U0yC+bgWjU4D5lBbz2ST9SXuUqRn6OT2Yz6a1qijFPc/pPr1V+DlAE9mtZWmlVw9t7dW+1yPBFtuLuVh6MDdFgnngXsuttxu7lO+EDgq/g3iHq+x0GqExR5L6p9Hv65S8z5sgLlG01jVzWulwhOfAsLd2YYlqFTDBD2yoQHLHfE5E+QW4pvwlyr0OENieLBbE+EFafp84t/ciXadKn0Gczq100MCrtI+avjdd42V5raEd0FntMIoqFP9Lq2s+QGhlvCxCycSV9nyhAPXai+aDvxiPqwyiCEFUze4QQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=0TzfdJMATl60Ek+IQoCgrlAlcV4TNND6QnsXP6p4Flo=;
 b=IT4PTlmSd/ZEne3c5GwO1Rx1WFtankK41uobDLJxReaK0ZQvFhKVgOZ3K+YagApQKP3PLAhgmWQG8o1uq62wezxS2GBX1Grurvusv0zL3DY1H8F2uzIBr3+/QNOWAq6oklorRCeumG7TljXxmTjfb4NFCiP0SNGnhcGeu8umhp+6DBq97+dfDwY5UZrvfuOLFqha3PdaUyAyahjsEODg9k8LDioUIkGMoKban1HPLpUEn2SnXEb8kVvqsjJEs0byBscUitdWqwcxvFkI4spJNHdX6AKZbSw+fGktuHuVh8RpU6cg+tOdlOxBK+6Cnv4cPZ3fh0YUxZBkRTHcD+17cw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from PH8PR11MB8107.namprd11.prod.outlook.com (2603:10b6:510:256::6)
 by PH8PR11MB6756.namprd11.prod.outlook.com (2603:10b6:510:1cb::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9137.20; Tue, 23 Sep
 2025 18:32:23 +0000
Received: from PH8PR11MB8107.namprd11.prod.outlook.com
 ([fe80::6b05:74cf:a304:ecd8]) by PH8PR11MB8107.namprd11.prod.outlook.com
 ([fe80::6b05:74cf:a304:ecd8%2]) with mapi id 15.20.9160.008; Tue, 23 Sep 2025
 18:32:23 +0000
From: <dan.j.williams@intel.com>
Date: Tue, 23 Sep 2025 11:32:22 -0700
To: Dave Jiang <dave.jiang@intel.com>, <nvdimm@lists.linux.dev>
CC: <ira.weiny@intel.com>, <vishal.l.verma@intel.com>,
	<dan.j.williams@intel.com>, <jonathan.cameron@huawei.com>,
	<s.neeraj@samsung.com>
Message-ID: <68d2e7b6dc6a_1c79100ba@dwillia2-mobl4.notmuch>
In-Reply-To: <20250923174013.3319780-2-dave.jiang@intel.com>
References: <20250923174013.3319780-1-dave.jiang@intel.com>
 <20250923174013.3319780-2-dave.jiang@intel.com>
Subject: Re: [PATCH v2 1/2] nvdimm: Introduce guard() for nvdimm_bus_lock
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MW4PR03CA0243.namprd03.prod.outlook.com
 (2603:10b6:303:b4::8) To PH8PR11MB8107.namprd11.prod.outlook.com
 (2603:10b6:510:256::6)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH8PR11MB8107:EE_|PH8PR11MB6756:EE_
X-MS-Office365-Filtering-Correlation-Id: 85b48533-325b-4dd7-24cb-08ddfacf89dd
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|376014|1800799024;
X-Microsoft-Antispam-Message-Info: =?utf-8?B?ek55cG15bU1HM1J4aWhZSWY4bnJocFdUV256UjE2ZjR1cjZGLzhzR3lTUDcy?=
 =?utf-8?B?cEI2QUtFeUo3NHJTYW54b1FKLzZmZk8raFJvVTBVWHRDL2UxNmpsMHB4Ynlu?=
 =?utf-8?B?WUh0UmdJdjh3K2lGMm53UkEwYTZxSEIxaGR4d1EvRTN6WnRJb3RUeWJ0NzZk?=
 =?utf-8?B?S2VDd1g4RCt6V091YmdKRDAwMmNma2Q4TisvdGVEdWRac1RPMjZuY3N5akV5?=
 =?utf-8?B?eFU5VVFkNmw0VzRvbk1udXNGbVBBSXZPYm96WTNTY0d4VnZSUnk2SEdBQjZS?=
 =?utf-8?B?dTBEdk51U2pwaEFsQjFtS2JJZEh6cy9GcVg3blVlalJyVUNKeURML01YYXRt?=
 =?utf-8?B?YUU5SUVtaC91T3V0SmZSMGFkbVlFVWZObUZCNW9FUGZnK0x5cjZlMkRxdkFW?=
 =?utf-8?B?bmI5clROcWoyaDB6Nm5Ya3NtQXljYSt5T3h3RmFhanA5clFCaU5wZ3RQMDh0?=
 =?utf-8?B?bkJ6TFRpMmlDUTBUd3RWd3huaG1SQlJUbm14cWZPZ2FMRVhpbzdvM2IwWENk?=
 =?utf-8?B?RWw0M1p2SHFUWHhFSDRTZVJRVnJMRHVCdUJqbXAyV04yaWZQZ1N6RHZXTWJw?=
 =?utf-8?B?RHVuSjZDcDlZbFBzVG16YkN2ZVB3SWtKNGZwakpnME4yWHZXaVczTHVHTVkv?=
 =?utf-8?B?d09vMHBYOWVzZlRZWTNuWWRsQ2ZySW8wUkw5S1BOYm1zNkFiYlpzay9yeTNI?=
 =?utf-8?B?enB4c0o1aFVCckdHOVNCK1IrN1h4Tnk1MFYrSklMUVF2eGJsMml1anU4U0Ux?=
 =?utf-8?B?RlNkY0pUVzM2bFdWUmhWUVNISHVDOCs4Mm0zSTUwRXpyMHJkdlF5Yk1XeW5X?=
 =?utf-8?B?ZjJQT3V3Nm9iTGlOVnc2bUF6Wlh1NTJGMkR6ejB0UWZWS1dOQ1FuUHBEV1Rr?=
 =?utf-8?B?WWxYUldrdmR0MlplLzRKVDc1WFpFWGdtOUxyTjBMdHFuMGpzWTBoQTZRYnIx?=
 =?utf-8?B?TittWU80d294bk0xWDAzNnRQVXBuZkdxaDFjOVlxNEkxSEhibVB2Y3daK3ZM?=
 =?utf-8?B?dW5Vck5UV0ovMjRZUFdmNG9KbGk5R0Z4RzdMeHkyUUE4OVpoMDJ1alBjWGk3?=
 =?utf-8?B?ZjJReHNMdEZ1TGNNRm02QSt1NXlvR0xQekQ3aWQ1U0owbWQ2TVVVVmNsR25m?=
 =?utf-8?B?ay9NNmlTN1h2MThIeEVUOERHNi9TOWppWUdTVng3ZFpnYjgweDdhM09rMVJm?=
 =?utf-8?B?cjFKN0g5cE1pWEV1T0tZRzRKVTdrMUFNZXp6WkhFMnl3Nkc1VzlranhWVVVv?=
 =?utf-8?B?VUM4bHpLY0tHY1VBY0F0ZFZCTUxvUXJ4WFZCMmhVRXZST2N3QUhJSFcwZW42?=
 =?utf-8?B?RkpiK1dVWTBYNUVIWE5hSmIvZEE3V3I5dHBWZk4zd2kwUlZ4RlRRamFUS2xP?=
 =?utf-8?B?bWR2bEFUa3pPelpKQlhhWXFRaGx1YzdvWlhWM1loalljTnZPVEk2eVdGcytF?=
 =?utf-8?B?MkFzdjNMWXFOSkFXRnVuT1lwZmhsZEV0SXFRMCtnMUxmYXZzbUg3MWFySito?=
 =?utf-8?B?UHBJVW0rc1p5T3Z2T1VjOTZSeXdFTnNyMUhWSXFnUGdZS0dDdFdjU3ZvRFFG?=
 =?utf-8?B?VzVLSWZTRXRSRytrbldsTDBKbGM4R0hIY3kxQk10VkVoQTRhZ3VkSmVRRjhz?=
 =?utf-8?B?WmdvWXJ6dGxIKzFqNnAwTUJLZzRsM25MZlhvZ3VCTjljWU5aT1JGcEsxemZ0?=
 =?utf-8?B?TGQ3Wm1uUFhqWmsvMDVEem1ZYUxhVzZibVBkYUJsc1hxNjNoZ3ZxUEJNeHJy?=
 =?utf-8?B?dUltUWsvQndldzl4NXVWdU14bHZFd3pzWko0UXJacXVFRE4xeGE3ZlE5WW5P?=
 =?utf-8?B?OGZNdFFRdFBuSEhGU1hkc0U4WTBlNjRKcjdMUXE4SFVmVHM1YmxQK0Z2REd1?=
 =?utf-8?B?aDBIOXlwU3IwM1NlWDk1eVUxYUxQV2R1TWxvZ0dMMlJVejZjYTBpU1g2NmJw?=
 =?utf-8?Q?bURa/Jkh5UI=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH8PR11MB8107.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?dVBPMTc1RHpWaVgrMlBGRHlMcENqVzU3aVVraUdQVjVqcFM4bGI0cW9ucW12?=
 =?utf-8?B?UnFnRmRFZGdGR2ZQMkNPekV6c1hhSHh0YXI1T3czSWZFTlZLR3VZejYrcWMx?=
 =?utf-8?B?M2VpL3BBN0owbDFOSkdZbFZDdkFjRVk3ZzA0NGZ3YWNLWGE1Y0VDUTc1Rith?=
 =?utf-8?B?WDY5SnlBcll4S2lLODhhK3lKN3RzNlZGcUtWUEtseHlDRk1kRjNnUk1yQzJN?=
 =?utf-8?B?MWFVQlRSSXhGSXg2dVkwTE1Idmw2ZGJ4U3g5RnZtbXdzaUp0VHZvSnV1N243?=
 =?utf-8?B?emQ4L252bkpSbjZnRENSeFlIS1dkWmxCcFJYY1paODg5MnpFWjhleFlqRnlE?=
 =?utf-8?B?dHJrVCs1UWhNaWdtaGZOVmlCWlcwdTdkRU1jZzgyTExWaWx1dzRMelZ3VTN3?=
 =?utf-8?B?YjIwTnlCWXpuVkdTaGFkcWlHL2t6ajNrTlAxN0M3SnMyeGJSR09ncGxXMS92?=
 =?utf-8?B?Q1EzREloblB1NGRUNFJmaHU1Qm0wUlo0K2tZdXV3WmJDTDVoRjFGUUpzdG9L?=
 =?utf-8?B?TzlvRk04WjVTVllhbkhTZEVmRkdXdzJIUy90T0Y5TEk2NWhoTFR1eTl6VzYz?=
 =?utf-8?B?R1hGZVJhWTlJb0tOWVNqbEZFMkxZTG9oR2E2TitwS0Z0algvMWlibTJCOVpi?=
 =?utf-8?B?b2lvR2lFbkZOS1FOeWZyMEk3VFVhbTdDYWMvcUExVjR2SU5Idzc1c1FGQVhQ?=
 =?utf-8?B?MEtlMUsyeU84SElBZU5STkdBL3A0bCsxUVNYZDhiR0xweXJIZ1lmWEx3M29T?=
 =?utf-8?B?VXNPZXprVmhXUEc4U05jdUF5clBWWFU2b2FhYlUzNCtVa01qMFVvMHdiMWVN?=
 =?utf-8?B?bS9BMjEzeWhRL1NEU0lQZHRWMjJ6YjlVVGdxMDlmYTRvcDIrOGZLQ1FIZjJv?=
 =?utf-8?B?Q05oVzc0WWU1Y1NlWGRvUnA2a0NBZGdBd1BsbjlXOXVmRk1XSXM3WXBHbEhH?=
 =?utf-8?B?d3Jjb0NDbHRsRGhLRlB1MWcyMFcxN0pRTnc4Mm8zL1l4dFlkdWNnTG9FaE1B?=
 =?utf-8?B?d01jZk5hWElkTmZEMW5LTmYxQjlzQ1ZHTkxqWG9pdG9PZWJrV2hRQmNsSW9C?=
 =?utf-8?B?dGZHMUpPQlRPNVRTNGlyWTVSWk5CZEM2SGJZU0lWdWNqVDRQMVlmUk5NbGVH?=
 =?utf-8?B?eGxqRytrRGNGNmgyaHJ4QURac05pWjg3Z0cyY3hnanF5UXJzd1JzQS90djZR?=
 =?utf-8?B?M0piVm9lWkZsYzRKbTRLZlBNdjhvc25XdXFCa0owVyt5ZkFXRFRJdzdQZ1Mw?=
 =?utf-8?B?ZUFEcWRwaFE4T2VrbTZOS3ZWV1dTRHZEN3pabjV3SkJzTklyY1BpdHNsSkxE?=
 =?utf-8?B?Wm40TGhDdHBSY2I5Q3cxZHF5RHl4aDdCNU92VWZWdTE0SiszUGZrTWdMeEdp?=
 =?utf-8?B?SmlqLzVPdGJ4T2V5cjczaCtBcGV3Tm1KQnJnODVsRmxzSlVtRTRvZzRLVTFI?=
 =?utf-8?B?Sk9rT1NXb1o1L0h6NWdKSS9kWWVWMERNM3IyQWJHNFZSdFV6aHRYOGVoTUY5?=
 =?utf-8?B?NCttMzBSN09hb2o0WWc4c2orZ0w4Tk1ieXBkVVhTMytrUkc0dVlnakFtR2Zh?=
 =?utf-8?B?ZEU3dHdvNE1pdG1lMDFVQmdGbmlaT0x4UlJOekRwb0NtQTFxOFcvOERyOXBB?=
 =?utf-8?B?REJyNHM3dlhpOEVvdlRSR2xuOGIvVnlkN1E5MVZBbXEybnh3VHpCMEtCaTdW?=
 =?utf-8?B?bXhsZVdNd0M2amk3NGFVcWVXaUFNNG1ZSnNGRmJZVUJTSHZjQ3lGUExQSGRp?=
 =?utf-8?B?Nzk2aHNBYnoxZFd3Y1V1MVVKYmdtZGNlU3RtM090LzJKOGhzUk5WaVZ6WDJm?=
 =?utf-8?B?RnVIVDlmRWtmWDlqcm9nS0VSUXF4WnBMNmN1aHFrdDFGTnVIQnBlUnQ4UlFj?=
 =?utf-8?B?SWFlWEpVaHNFeS9IeHc3T1Q1YjNDczBmbC92UGlkU0grbVB5eDY2emZ3TEp6?=
 =?utf-8?B?OWhMdGpNUTMyM0xkZGNqdDZoSTEwSjZ6STk1TkNFNmIyUzdCeDgraXFiU0xM?=
 =?utf-8?B?ZWxyd211S3NIYlN5dmNhUEhNbDFxeG9oTktzd1VrS0lkNzAvSUFmV1hiVmE2?=
 =?utf-8?B?bWFBUHQyeGEwN29rN1JEN2pwMFAyZHp3aGVEMmI4d1JxRTdxZ05ZczNobHhn?=
 =?utf-8?B?TU93NHlYbEJFbEhGSzNCRzN0RGRxb2w2TytaMmZXMXFBUnV2UmQ2djN4eGgv?=
 =?utf-8?B?Ymc9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 85b48533-325b-4dd7-24cb-08ddfacf89dd
X-MS-Exchange-CrossTenant-AuthSource: PH8PR11MB8107.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Sep 2025 18:32:23.6235
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: hUVzCmLRhNMD08NmMGN58NylNVW+o52RP+E5qLjAi3fz5zFxJ4UryDf0Ad2uhjXlNhNXpcflPdi0aAbDuoeqTEqKDls7aEbugp6waDpwZdQ=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH8PR11MB6756
X-OriginatorOrg: intel.com

Dave Jiang wrote:
> Converting nvdimm_bus_lock/unlock to guard() to clean up usage
> of gotos for error handling and avoid future mistakes of missed
> unlock on error paths.
> 
> Link: https://lore.kernel.org/linux-cxl/20250917163623.00004a3c@huawei.com/
> Suggested-by: Jonathan Cameron <jonathan.cameron@huawei.com>
> Signed-off-by: Dave Jiang <dave.jiang@intel.com>
> ---
> v2:
> - Moved cleanup of __nd_ioctl() cleanup to a different patch. (Dan)
> - Various minor fixes and cleanups. (Jonathan)

While I am not a fan of the indentation damage that scoped_guard()
conversions inflict, in this case there is other cruft that gets in the
way of wider cleanups.

Acked-by: Dan Williams <dan.j.williams@intel.com>
