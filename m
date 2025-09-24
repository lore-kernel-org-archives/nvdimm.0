Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B713E2C18A
	for <nvdimm@lists.linux.dev>; Wed, 24 Sep 2025 01:50:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.16
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758678656; cv=fail; b=h7XXxLrVMY/WTBiq9tG6ZYZiLp7szjXq+VijY8qtLCxAQ1A4c9T/awNdw/lxM2kbCLaXR2BllNz43BEqwz7tanYV2dJrHm0PQu6vQrNmX3DSfRLPA82cqlWYcdDXdMKo2oIc9D7FZct3ZpfqJtTKQqr1IXTCApl29cVw8LvKu0M=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758678656; c=relaxed/simple;
	bh=FdT4XXbYSAEz9aLPtr3QcJhAOVZ9p2KhSDiKpqBOlHg=;
	h=From:Date:To:CC:Message-ID:In-Reply-To:References:Subject:
	 Content-Type:MIME-Version; b=qd/o4C/9cyTGS3jIzGlhdyyNq44v34mfgpz76FCvBemd11e/6fQK2tRqNkMC4NqusZt6kthgQo1+6TEwQF4yziO9hpVwxvCxAUibdaqgWqbXCZBmNogOSMeUt/9FJGKAHT4o/E9/GbH7IiNuaiLvcDJEcc+v2q5Ypnz1SXPGco4=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=J1ypSBDz; arc=fail smtp.client-ip=198.175.65.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="J1ypSBDz"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1758678654; x=1790214654;
  h=from:date:to:cc:message-id:in-reply-to:references:
   subject:content-transfer-encoding:mime-version;
  bh=FdT4XXbYSAEz9aLPtr3QcJhAOVZ9p2KhSDiKpqBOlHg=;
  b=J1ypSBDzjxx6A9caLmk5/K/H5aiJWC2qb1a4mho1vpAOrTAw9CHMHpDh
   Kpcl2YW2tX1JiQLkt/m95pNeR6kRhpYYhNM/gxLCoNayFRadVvbQ0cpqH
   xhlj5D1FSbKVGMs/BEZPY4Wkr/WJ+K/p1WJcIfTqSV5UjDuKZ/7zfqOEm
   YfLrKgaFd1d5R3IkosYY1bagwOBSUQA18Fn4LmwvZffLxqWET46rzM5Ir
   aTyGAXYguQ/3TfoYSGPGgBVwDX50TLWViDCXJGXHZpMh5UB8zWuMl2JXd
   JvTajOeA16Q07qOWbJgWDefLEux42rz3qJdFQC+8arRCeZ1eP4Zt1BbdC
   Q==;
X-CSE-ConnectionGUID: x3Vpdys4Sg6+2oQO6D948Q==
X-CSE-MsgGUID: BXmmCzRjSCaWnyZhdqoW0A==
X-IronPort-AV: E=McAfee;i="6800,10657,11561"; a="61139518"
X-IronPort-AV: E=Sophos;i="6.18,289,1751266800"; 
   d="scan'208";a="61139518"
Received: from fmviesa004.fm.intel.com ([10.60.135.144])
  by orvoesa108.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Sep 2025 18:50:53 -0700
X-CSE-ConnectionGUID: wc2KpYvJQRGkevWp1mUJAA==
X-CSE-MsgGUID: mHjOPKE/RwuzYwJ8bUIMiw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.18,289,1751266800"; 
   d="scan'208";a="182178394"
Received: from fmsmsx901.amr.corp.intel.com ([10.18.126.90])
  by fmviesa004.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Sep 2025 18:50:53 -0700
Received: from FMSMSX903.amr.corp.intel.com (10.18.126.92) by
 fmsmsx901.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.17; Tue, 23 Sep 2025 18:50:52 -0700
Received: from fmsedg902.ED.cps.intel.com (10.1.192.144) by
 FMSMSX903.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.17 via Frontend Transport; Tue, 23 Sep 2025 18:50:52 -0700
Received: from MW6PR02CU001.outbound.protection.outlook.com (52.101.48.70) by
 edgegateway.intel.com (192.55.55.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.17; Tue, 23 Sep 2025 18:50:51 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=n8uMzNjXfoVw8dBJFIVcyaCNlZDM0SCgb5MM1r+vPx4ytWelMcYLzUxjbeEEj7sdhAIYiBBoFZ8FB4WagPHJTahb6QVbczIvZryPSVba5QhKY6DzaHkk9oR9Ag7MSCylsKj6q/y6XBL3Y/vbixK9diCd0budujkrwYZH+pCvZUuOW9hq+eORuP4kTkdFZ9kprDTlyxxCdblxOP0w9ML0OVe/DRKoeph0OwOK0UZfQauiafm6cYmtUKajiJiH89pkZRRrJ2jGcwEH8Z8Tr8cZnf5bm1/3aZabuNquRYHunhsLQYzv52nglhilQ044++O7eE2BTj4SRzDZKqDJ1sTmhA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=dkKjf1jIk1KttAPUeSK6WE3nqpHTl5vqBN1PY3r87oQ=;
 b=K3KRD1P4Kz+iPkpOvqZUWKcRjf3GwmjHwHdECCMXgJI2jacTE3xTJfHQH0unhhwFVgeduOt3LyPuwsBvEekue2nJgKRDkLxsehZXUwcNWZ7pmTIC3Kj0N8uOgpdJiIn2ppZ8fIAo+44e8LjigwiL4R6yHGqDJ5nFEe9wcWZjajsRjbu7IwlkN3ckCFBenUGh2f1yCbycjknuhpI2TjlNvYVpwIS+VPZ8ZAlC4iZsxsUp55+AGrvtn/y5OZLSlPQ7xpajNkGkib9WWKPMxiSkn+DGliXSzEQ1HeYYm5EZD1jyH11+b/vHG4gXT6QlAADNU3rnDAas9m2bhMWhH8F1gg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from PH8PR11MB8107.namprd11.prod.outlook.com (2603:10b6:510:256::6)
 by PH7PR11MB6054.namprd11.prod.outlook.com (2603:10b6:510:1d2::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9137.19; Wed, 24 Sep
 2025 01:50:49 +0000
Received: from PH8PR11MB8107.namprd11.prod.outlook.com
 ([fe80::6b05:74cf:a304:ecd8]) by PH8PR11MB8107.namprd11.prod.outlook.com
 ([fe80::6b05:74cf:a304:ecd8%2]) with mapi id 15.20.9160.008; Wed, 24 Sep 2025
 01:50:49 +0000
From: <dan.j.williams@intel.com>
Date: Tue, 23 Sep 2025 18:50:47 -0700
To: Alison Schofield <alison.schofield@intel.com>, <nvdimm@lists.linux.dev>,
	<linux-cxl@vger.kernel.org>
CC: Alison Schofield <alison.schofield@intel.com>, Andreas Hasenack
	<andreas.hasenack@canonical.com>
Message-ID: <68d34e77bb7b2_1052010056@dwillia2-mobl4.notmuch>
In-Reply-To: <20250924013537.84630-1-alison.schofield@intel.com>
References: <20250924013537.84630-1-alison.schofield@intel.com>
Subject: Re: [ndctl PATCH] cxl/list: remove libtracefs build dependency for
 --media-errors
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: BYAPR21CA0028.namprd21.prod.outlook.com
 (2603:10b6:a03:114::38) To PH8PR11MB8107.namprd11.prod.outlook.com
 (2603:10b6:510:256::6)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH8PR11MB8107:EE_|PH7PR11MB6054:EE_
X-MS-Office365-Filtering-Correlation-Id: 26477c71-4378-4e99-f553-08ddfb0cc97d
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|366016|1800799024;
X-Microsoft-Antispam-Message-Info: =?utf-8?B?K1l3a2VuMjdtaFVSRmxHb2EvMnR5dklONFU4czZvQ1NnT2UzdFZNSGsyOHBL?=
 =?utf-8?B?clBuUElrV0hLMmxxTlhKUTQ2eTZIb3BkWlNoK2lFZ1RML0IvY0ZDczN5ZGF1?=
 =?utf-8?B?elVXUG94UEYreUdWdm9qY3dWcGdTd2VGUnVOQWpld01jcGVtWGlTQlc3dUpH?=
 =?utf-8?B?UEJ1cVJMVC96ekdsTUVZMGRvSHg5SlVMT1VrdVBYVGJXc3dHa3hJMnlUNEw0?=
 =?utf-8?B?QVlJMDBDQUYybXVEUlU2UThSalpHWWhuejBhWGpYQXZTbFFUY0MxT2o3Q3ky?=
 =?utf-8?B?RTBYOEN5eG9GbFNYM2kxcVZhOFlEWjJ3NlZCYSsxQ251RWJ2Uy9pSzROeFNs?=
 =?utf-8?B?cGJMWGNnbnhtZy9WTFc2NEwzcVRFTUNOQUdPZGRsZUVwYkRSdlhLM29zNDdT?=
 =?utf-8?B?T2ljNENCQ3QyZHhyWU5pKy9ubEltMXVKdnMrYTBnMnZIdVl6K3NEREJHQnF2?=
 =?utf-8?B?bUZIYThKK1hCN1J6MXNadTdYQnJWejRnUjRVWVZsVmxodFZ2NzNxTTRPaWRy?=
 =?utf-8?B?RTFyRmJuU0JqZkdKaGE5dGFFUmZ0dHo2NHpGeURzQllJeVViYmpEanV4dldJ?=
 =?utf-8?B?aHE5TW9pUWQxR3Nicmh1NjJjS3N2VEhiekx6QjN6SkNoN3BOZitVVldqbEpq?=
 =?utf-8?B?MmxZRnZJdDF0UnQwcHlYa3NtZExmN05GZW4wZmllQ292NGlNVldJNzdtdGhL?=
 =?utf-8?B?TlJyN2pYVy9aM1hDdm1zWHZYUEtVcFFqaFlZMDBYTUZoR2tlNS9QT0VtK25x?=
 =?utf-8?B?RDNkSmZCZW5KdDBiVDhBTnRTOWcvMjJrTGw3N21CVCtvaHdQSEIyR0ErTXNI?=
 =?utf-8?B?VnhuWXQ3bXpNdW5wdjdaRGpaWERoUC96eVNDWmhLak9IYWpsUHdmR2JNRnFy?=
 =?utf-8?B?eUxpOUV5OVZKSHZoWDBXZ0I0RytEWmFqSXBDbCtPZ2t2RlBZTnNnSVIwMGV5?=
 =?utf-8?B?MHNtTnBqTTFHUWZuR0VpT3g5WXJ3Nyt6d084WTdvOWxsY2o3NXcwVzFyMlcx?=
 =?utf-8?B?QWt0Q2FkSXZnY1cvL04yTGg5bkNXVXZVS3lnMHY3WWI1WjVpV05YejRQOGQ3?=
 =?utf-8?B?eG9qOGpjWFducXVWR0lxYmtJbFZIL3VtVHQ0a0RCK1IyTUgySEo2L2plbklD?=
 =?utf-8?B?R3I3aENXb3lweWtnQUNPbGtuTGRLejZuSzVGZDBCU0NSOGcvUXBQbEJrR0Zq?=
 =?utf-8?B?ZmNlYjNVczdqZGpoTVIwRm5hQjZ2MmEva1NQTHE3T1dtTmRsNmRUa1FPQXN5?=
 =?utf-8?B?ZFp2KzZOVndrRkd3clhSYnFzb3gyVThmdG5IVGFZc2lpY0pPMVovUzJ4WGhn?=
 =?utf-8?B?djRaMHBjM0QyelMrOHdCelBhZ2Yzb0RKRFIrK3JkU0FsaTNwWVVtUGhUVnlN?=
 =?utf-8?B?Qkw3T2ZKc1pyU3dmSmpiQ2dDRU1VR001Vm1KSWRZd0R0L2ozei9rT2tocUlV?=
 =?utf-8?B?b1lrcUxUTVBXdnFxeGs2VVhLc0QwT3duOVRHOFYrRVlZNXR1ZkM1cVUyOG1h?=
 =?utf-8?B?VFNYUDdkTWNhbFppdXU0eXQ4NmFnUVo5b1Yzc0ZvT3dmSkx1MnM0MlIwaTB2?=
 =?utf-8?B?MGN3Z0Y5K1gzNCtqclFyaVM4VHd0TldBdURkSFpUd1M3T1k3MXJJWkVsNlVw?=
 =?utf-8?B?U2JxcUVYaW5SaWF1UEtpM0MrWVBwU0lUenN6Q0RyV3plMWY5R0hzLzdMRzBP?=
 =?utf-8?B?SDBtNm9UUzNtYlY3TEJPRWlsaklGazZoRUZyVW9NTldrUzIxOUNwSWxjdHoy?=
 =?utf-8?B?NnExOWs0Vzk1R3NnQjdzVDlESVRtQWlmV2I3TW82cjVyNCtQTDBXaXZkU3RX?=
 =?utf-8?B?YVo5RGNCRFBjVUNuTGhWU2FzUStuZzNldG5XMGV6bklDcTJLa2k0eVFZWFA2?=
 =?utf-8?B?bVBBYThFSUVBWHRGdVRWNDluYkZLU29aRHk3MkF3VzQ0dk5jd2FlZUJCRFlu?=
 =?utf-8?Q?Jp1/SYVt594=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH8PR11MB8107.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(366016)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?RlRnakJCSFNpNy9nQmVlT2FzR3NidHM4TkNMamQ3SCtCT3hGMXZuTlVOUG0r?=
 =?utf-8?B?RkpyeElLWS9td05rc0RpaG5pY3Z6LzVFVUxZTU8vZUxvT1NaNCtVKy9TSEN6?=
 =?utf-8?B?Z21ueGxrQ0p6djQzSUxhbW44cmdmUCtyMGg3Q3hVS2c5NzVlNnRlWHQ4cCtJ?=
 =?utf-8?B?Yy9xYXdqM2RaaUdsNmc5aElUakVWSXZYUE5OeXA0NEs4S2ltOElsZ21iWkpp?=
 =?utf-8?B?SkJRZ0xGUFQyb3NDS1BCelpUQzFpczlZdUZXOGllL1VabWxxSzNkZCtXSURz?=
 =?utf-8?B?Tk5XTUtKQ1B1aUVQNitnOStnemJPMUVNWTV5K2pFWHlTSGdBd2o1ZHJIZlJ3?=
 =?utf-8?B?bFhlQkh4S0I1SXBCRm4xbTJyNWtFRmVLYWJNN1hGcVJnSWZOeDhOR2xYWmhy?=
 =?utf-8?B?OEFqZVhlYUVwck4rbDRIZmxIOTJBTHczb3VwcVB1RHE2a0Z4aFZMT1R6RHdu?=
 =?utf-8?B?V0kyVTRISGFqMUs4QzdXeDQ3aVJBQm03cnVWb3dHU04xd1R5dEZxS0Njb0ZN?=
 =?utf-8?B?QVFNZThLRGJ4MHVTaStkUHJyaHZNOUZSekhhRjNnOWFVWGZLanFXWWlBUDFx?=
 =?utf-8?B?enJYWUNKQk1mMzhtQTluWkhiTDhIK0F3Qkd6Y1hPVnpGY2V0UHVXYzZFWVdG?=
 =?utf-8?B?TXJmeU1nSnVqTG43dExwUmV0VmU2Unh4T254ekdXL01EbHpINTlXM1NkS3BB?=
 =?utf-8?B?ZTVxK2FGam5FTC9KeXA4MkxHVFE2VnZLOFA1Q2xxNXA4SklkQjN5VFV5Vmkr?=
 =?utf-8?B?M01tVlkrcnRMN0czVW5HYWhUNmtUejFCUGtpOE01QUxkanBYS1o3dy9PWHdF?=
 =?utf-8?B?TkQ3aWFJckJFeDF2MlYwSHlQaEk2T1FTelZBSmRadk5xQnlPRjRWTkxBbDVE?=
 =?utf-8?B?UDMvUjd2NUd1L2xtN3Q2dzdEeDhZK0FqTldabDl4RVpTZnV5NnQvN3R4U2JU?=
 =?utf-8?B?Um5EbHIzakFKZnRwdWQ4WmtEbkY2SFVmdWtaOE4wS2NiS2w1L0hiWG1WTHJM?=
 =?utf-8?B?a2xjU1RjMHFselF0bEprcUt4RS92NXdQTnJGQVN3M1Zsbmg3U2NHSjVURlVx?=
 =?utf-8?B?aDk2WWtpWUI1eS9DUjFqYTJiRHplczc0OGhKMjNPNmZsdTREaEozRXZCNm8w?=
 =?utf-8?B?em5PSXA4aE1ubFdJOTF1N1hXeXhocCs3MnNkMXdweXlxYTZrTGJhTmdCZjRI?=
 =?utf-8?B?b1lxVTdCeWxjY2FNWFh6UkNRbWVtQ0gwUlBTVHVPMmxCR1VoV0N0NVk1aUpH?=
 =?utf-8?B?d2tYb3FZLzVFY2NLMytpSWxVdVhuYlQ0Q3Rha0R2N2VPek91MlM1V0N6ekJ3?=
 =?utf-8?B?NCtZZFhTcld4dUEya3pMVmtONlhQVWUyVm9pWG05NVkyd3VlQUdTUEtqVmZx?=
 =?utf-8?B?T09NSEdQWllxc3NFSTVDd3NHbkJxUEw0T0NBUVI4ZzllMDV3cUEvSlAxZjJR?=
 =?utf-8?B?dDVFTTZEYVBZSUFiVW5aSnpuS3E0UVVUSVFpbGg1K0ttclZSSTFpQmhoaFFp?=
 =?utf-8?B?K2ZDcUNESEJ2VUJybHpnOFYvODJWSWMrd3dxK2lDYkloTlFiQVBFS3pYbmxO?=
 =?utf-8?B?aUJVd1hnSk1wY0wzR1Y1Zi9McGViNFFRaVNiQ3hTQ0N5aW9CK0RFbjlJRHdH?=
 =?utf-8?B?MWtjODlndFhhbE1ERGE4MEVjRzJUZlUvcnljb296QzRHK1lQakcrSUowL1BS?=
 =?utf-8?B?TUd1Zngwd0p1Q2o1MWtPOGZUbU5Ha21rYzJXQVpXeFdQUzE0ZGhmcEZSSUlV?=
 =?utf-8?B?RUdPVUo5S1VzTWpHZS9XTElkVmtPazgvVmU0T2xGMnVVemhTMm1oek5JcVVX?=
 =?utf-8?B?UnpHWmhTOWZxZlAxcjVaVWRaOEVJbGZLZ0ZXK0RqMGZ3dnhUSGppc2lDVFVj?=
 =?utf-8?B?OXFwZ2xHN2NsMUcxNlhEc2RYU21ocXNRUVd1dHNMWDFraGcybkNXbWNwNGVJ?=
 =?utf-8?B?U3AwR3YyYldSRXhRUFhESHo5NFJsYk9KWmYyUCtDSk14UDFrQk16VjF0ZGpM?=
 =?utf-8?B?V1BCMVB2bSt1SEs5bHVTMFRJL1BlZ25aSzBxWllBeFZZTUFQRU9uN3RLaGRC?=
 =?utf-8?B?eGNpV1YzckFiNWVoOGUveWVGL0xTRHR4VGUyUDhNSlB1azE4dW5qTktaQkpZ?=
 =?utf-8?B?c3B5RDF3dFBtRTlwZjdrRTlxTHZtcXpvek5rME1SUk1CVDU4dlFYSXRoSU5P?=
 =?utf-8?B?TWc9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 26477c71-4378-4e99-f553-08ddfb0cc97d
X-MS-Exchange-CrossTenant-AuthSource: PH8PR11MB8107.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Sep 2025 01:50:49.6243
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 2uG+sUEW+BNDhZT6HaX+BMzf1o7jYATAuAwKeCfaiTzQpbd0ccFDum3TWvmf516dUxvNlXgkudYhu+q7CjU+KKp+/c0/rC7pUGa+dz29T40=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR11MB6054
X-OriginatorOrg: intel.com

Alison Schofield wrote:
> When the --media-errors option was added to cxl list it inadvertently
> changed the optional libtracefs requirement into a mandatory one.
> NDCTL versions 80,81,82 no longer build without libtracefs.
> 
> With this change, NDCTL builds with or without libtracefs.
> 
> Now, when libtracefs is not enabled, users will see:
> 	$ cxl list -r region0 --media-errors
> 	Error: unknown option `media-errors'

...but it is a known option that is documented. I.e. I would have
expected:


  $ cxl list -r region0 --media-errors
  Notice: --media-errors support disabled at build time.
  [
    {
      "region": "region...

Let the command continue because that would also match the behavior of:

  $ cxl list -vvv

...which does not fail when media errors can not be retrieved, and would
also make things like:

  $ cxl list -R --media-errors --health

...at least give some useful data and succeed rather than fail and
require the script to be re-written to drop the option.
