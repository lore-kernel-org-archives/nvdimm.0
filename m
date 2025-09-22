Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.20])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B629B1F4191
	for <nvdimm@lists.linux.dev>; Mon, 22 Sep 2025 23:24:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.20
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758583475; cv=fail; b=OZJzseoxwD12wBwcy9nm7C/D2Ho48RKzMStZS5tzpGatrwtlZ7XYybcB4C7NQo3hayYeZCPm3GYJsNtgeNiLcIF9v+8ghcyB7URLB08EI2+cyRxc51T+j7y+0R9l1euw+YR/OpG/gDtPxg5PrM7apLRGyYshjE0dutZHfs/Ebfc=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758583475; c=relaxed/simple;
	bh=mMhVK9vZ/0VB7Ai1dO9l3t75q6miVfVtNySj3oBmbfw=;
	h=From:Date:To:CC:Message-ID:In-Reply-To:References:Subject:
	 Content-Type:MIME-Version; b=YtrcOkKETy3DN8+dWJ+muhj/FZkXxkoek3JXhsjiEC2kvukCmFk1beLgZ6VrTkUeJHQ688vKoWbtVsTbSEK2iDpP2DJj8dgz7RXTywbhklLlv5Tr83cvNysEyZCpSNcMWzDWlMLDWiFqMHeTnq+vbMSf3hKMFrZk/CUVTIR972Q=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=MbwkJLOq; arc=fail smtp.client-ip=198.175.65.20
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="MbwkJLOq"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1758583474; x=1790119474;
  h=from:date:to:cc:message-id:in-reply-to:references:
   subject:content-transfer-encoding:mime-version;
  bh=mMhVK9vZ/0VB7Ai1dO9l3t75q6miVfVtNySj3oBmbfw=;
  b=MbwkJLOqbs4ZNutLLI2k5h2OeF7endmO7ZXVCr7GL9r0xd2JBaBM2OnW
   0PGjzJsuLF8L+3ijWoURUU8fi0o1twtWUk/Aw3iz42yMFZaM7L/Qf+vol
   4By2iivHXl4IRkv1Z5Bhbw0YyKUUATTTvaNzaz9N+b3cpPvUA2Ksu1GAs
   bb5rKpElp3QkgzPX5XQc6bk64jBT3SK2a7Jae/giMea7p/6rCKK36Kr+5
   wQKMJ3Eq8V8s4+0gQoZmjPzZgqebtq4Yd76La2Pys4eYMZW23BWM1nsAw
   DCC/86OawoNxOiROK6WeoqbxN26zFTXFd2dB3K8hKQgb6RmhJGM8luVGv
   A==;
X-CSE-ConnectionGUID: nDW5MxBsQP6tpefAQFKBcQ==
X-CSE-MsgGUID: br07aQDYSrWnvY8YvYw+iA==
X-IronPort-AV: E=McAfee;i="6800,10657,11561"; a="60555367"
X-IronPort-AV: E=Sophos;i="6.18,286,1751266800"; 
   d="scan'208";a="60555367"
Received: from fmviesa007.fm.intel.com ([10.60.135.147])
  by orvoesa112.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Sep 2025 16:23:54 -0700
X-CSE-ConnectionGUID: j4Fkm0kFSbmnL0TrxJkR1Q==
X-CSE-MsgGUID: 0LDH5WCDThqQcN1Ah5xnng==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.18,286,1751266800"; 
   d="scan'208";a="176206325"
Received: from fmsmsx901.amr.corp.intel.com ([10.18.126.90])
  by fmviesa007.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Sep 2025 16:23:54 -0700
Received: from FMSMSX902.amr.corp.intel.com (10.18.126.91) by
 fmsmsx901.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.17; Mon, 22 Sep 2025 16:23:52 -0700
Received: from fmsedg902.ED.cps.intel.com (10.1.192.144) by
 FMSMSX902.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.17 via Frontend Transport; Mon, 22 Sep 2025 16:23:52 -0700
Received: from CY7PR03CU001.outbound.protection.outlook.com (40.93.198.11) by
 edgegateway.intel.com (192.55.55.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.17; Mon, 22 Sep 2025 16:23:52 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=dBg8YupOjpDZaBg0+RXgreFDVi4HEt6+RnOe4axbthOY/kJLUmZ3nFW5+bZJZSLQdSSywA1NDoyeVKEP0IJGQHEAZIeJ/kTmIdd4pByeXjxbQ+rMvZGro9XndstNxh4N3keh4gYC+x2Zkfu8ubHKM5oLu1UwjStOTyUFfL72Txnsk/eT7rMStu8786J81c2Z8egP8FaUx7Sp8qFQTiA1uyOnqRSKo4O6X1fWHUAkLrjlJdbAk+VsxSnbBMWCwZf24NV4thlmRq4MzYDVlgX/za8VrWLq5wjxTChrUQpgECV1/ktBlJcy8Ilh2QRYVkPj89mm+EvWQuIAPXUBQaCTFQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Bdy+7+U3AUnLIn9ZQLKzlqdnIuJrnHGvE7siaCt3Ckk=;
 b=BQyo0rfEnKQ1oAmlifkRhzfmGYH7BWFM4CA8X1toKW3qoM4OS6SeKlTBtF2X1ngIPtqhkLBsEDIq1nQL3Y+f58My5+0rUOe2C67dOEqtm95J5W8DGKp3elXJWzcOgvvhxTXPH9UDVlGztM0zbwaoINf1D46LV7sbjN2shBoOOhlP9R1I0G5nc/2os1Sr+DwAkvgxiLMLEAaXWmQrIOjBem7iRYvOrPmMzfn5pni+orr5WwvwglVhVkT0QiiNAwTUTdzXRGOTuOgJiShZI7xHpthCjRaV5Qc5AWnszTYKDv6DNAvdoPVtpkSiT9d2ZtgjY2vmNeEJGxzZGtKmNE1cTw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from PH8PR11MB8107.namprd11.prod.outlook.com (2603:10b6:510:256::6)
 by DS4PPF1DFB73954.namprd11.prod.outlook.com (2603:10b6:f:fc02::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9137.14; Mon, 22 Sep
 2025 23:23:45 +0000
Received: from PH8PR11MB8107.namprd11.prod.outlook.com
 ([fe80::6b05:74cf:a304:ecd8]) by PH8PR11MB8107.namprd11.prod.outlook.com
 ([fe80::6b05:74cf:a304:ecd8%2]) with mapi id 15.20.9137.018; Mon, 22 Sep 2025
 23:23:45 +0000
From: <dan.j.williams@intel.com>
Date: Mon, 22 Sep 2025 16:23:44 -0700
To: Dave Jiang <dave.jiang@intel.com>, <dan.j.williams@intel.com>,
	<nvdimm@lists.linux.dev>
CC: <ira.weiny@intel.com>, <vishal.l.verma@intel.com>,
	<jonathan.cameron@huawei.com>, <s.neeraj@samsung.com>
Message-ID: <68d1da8041e5b_1c7910038@dwillia2-mobl4.notmuch>
In-Reply-To: <1b1ee40a-401b-4839-9c63-77ecefb94315@intel.com>
References: <20250922211330.1433044-1-dave.jiang@intel.com>
 <68d1d2bdc0181_1c79100ae@dwillia2-mobl4.notmuch>
 <1b1ee40a-401b-4839-9c63-77ecefb94315@intel.com>
Subject: Re: [PATCH] nvdimm: Introduce guard() for nvdimm_bus_lock
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SJ0PR13CA0169.namprd13.prod.outlook.com
 (2603:10b6:a03:2c7::24) To PH8PR11MB8107.namprd11.prod.outlook.com
 (2603:10b6:510:256::6)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH8PR11MB8107:EE_|DS4PPF1DFB73954:EE_
X-MS-Office365-Filtering-Correlation-Id: 115a980e-9f94-4d80-218e-08ddfa2f1388
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|1800799024|376014;
X-Microsoft-Antispam-Message-Info: =?utf-8?B?WXQ2M3ZxVmQ3Rm9MWEFab0JxR3lhS3Izak43eWFKY3VIRURmMHUrTHgvY2lk?=
 =?utf-8?B?T2VhU0F1aEtNckJvWmpON2pCYXBxUVlVeGcrZk5EVHNFV1hXdHRPcHNEVXFu?=
 =?utf-8?B?OWRETUU5WWlrZHdySTdyMHd6a2VlUkhoR3Zjd2xqYlRxV2QzaTFlN1FNaWpk?=
 =?utf-8?B?d1hEcDdQVUxhSGl1SVlsUDZlK2pUakRZSVRaeG92VFJVdUF0c1pOUmpiQmxH?=
 =?utf-8?B?bWdEcXA2eUo2blJHa250dksrN3Z5YktObE5CWGtQc3gwYmlNY3RPTWhXLzRV?=
 =?utf-8?B?WjZOTzdoK1U4K2JJTnM2RGovREwzUE9NVHRWNkdZcitTNE4vM3pSVVR3bWdG?=
 =?utf-8?B?Zy9oanBPZlUzQ0xTQWlYM1EvMVFOV0xla2gwSFh2ZGxHaWhCYXhpV2hJZTF5?=
 =?utf-8?B?Z0loMzBaMVB2ZnVjR0QxankyM3VmV0pPMm9pQVE5N2RXVXdqdlZ2aWFEVkg3?=
 =?utf-8?B?R21tTkUyM3owQS9IQ2paL2NKV2plNEpwYTNVblA3cGNIRWowQ3VXbDdqUmox?=
 =?utf-8?B?MW16Rld2VllqVnQ0TzRHTCsyWGtURVY1VzhyaEtzcGJzbld6VVRZNWxUQVBv?=
 =?utf-8?B?bjZ1eldQeW5VYmd6TXV1akFwblZ1YlU2VEVJSVNlU2trSGpWbk1EeU9nRzln?=
 =?utf-8?B?TXA1MTRBUHBPakZHQkdYYkxDaS9qUUpDdlVTZGVDeE5MNklBKy9BVTJHSEQz?=
 =?utf-8?B?Q3RhL3YrTHRmYU02QTRzVDNxQjFKSzZ2S29NOVRVbnhWRFRTK3UyWHZBZ1ZE?=
 =?utf-8?B?S1JvNm13ZDRHQ25LQkRaRU91OHE5M0ZhR1ZFNm5vRTIyWUhEdzVvK05Rcllr?=
 =?utf-8?B?Sm9RbmFBZDNNUnd5UDVLOGFCVWszbmxBYkdFL0s5ZUhyZ01LbERWdStBOVZB?=
 =?utf-8?B?ZXllNjRQM2NYeWpsK0oyZ0dibHh3cTBTVjVzcUc3dDhaVEw1K2hLR0RDaDB4?=
 =?utf-8?B?N01OMURVV05mTUQzYWdZZUF5RjlpVktqdGVqSTcyNncxOUlRZjJ1UVhVOGQ3?=
 =?utf-8?B?VHYzeUFQSkh4QU5FSFF0U3JzYWlvTDlDRGxzYi9OQ251cEpqNGhyUE1sL1k1?=
 =?utf-8?B?eFNaV0IyVTBRdll3NUdkMU1zcHQyNHA1dzhOYllQWFFSS0Y2N0lnYXBhTEpS?=
 =?utf-8?B?ZFo4SFNsRVdVemdMOUFBaVppcStpeVlPZVE1ZDhqbnFiMVpxMWtVNDVoNGFX?=
 =?utf-8?B?VlA3WnovbjByamFlRG11Z0RuSHlDZkpaUnFSOENJY2kvZDJWMDRrS1F5R3FY?=
 =?utf-8?B?NkFtWWZ2aWM1Nm1WQmJWZXB3VVM5bDF3ZThIVzJ4L2JmQ2M5VFNHS0Q1MzFR?=
 =?utf-8?B?bnp5dHZkaWJPeVpUT25HSnQwamdheUR5bWU3SzBvZFgxekhoRks2cHFjMUNO?=
 =?utf-8?B?aEFhRFVGNHpsUUczSGE1UzZ3SmJJYjE5TDVueVRKbzNtVXZJS0ZuUTFtcFVq?=
 =?utf-8?B?aE03WnByRHI0NDVNei9CSjJDcUtvZ0EySSttcXJJT3dtejBYb2FHbWhyTGRj?=
 =?utf-8?B?L1NOYWhleTczdjgwUTlVc1BZZkZ4ZElzSk9YdHVZOXVaZHpXUEFwWnl2UDda?=
 =?utf-8?B?VlN6bWJxdE1Zc01LSjk2cFNEemJnalgxUmhSeUN6M0FLWUNpYWxHLzd2WFAy?=
 =?utf-8?B?NVVhSkU3RHZLR1pqQWRPZm9aRk5tTXllQTYxajZPSDBjOTBqVW1kVXBuWFBp?=
 =?utf-8?B?SWN0UnViS21QSkhWdm42Q3dHd05hMnRudVAyODlGTGNERktVSUlYWm9SWTQz?=
 =?utf-8?B?ODBHWEp2VzdqME9nbGZOV2VtR3V0QXY0V1pMVDZPei9uQ2ZielRtTktMd00w?=
 =?utf-8?B?TVhtM3JsRW5iSDRuQ0ZhNnZIRFpsTWs2Nyt1ZXZmb0Jhd1VaR2krSXQwcElI?=
 =?utf-8?B?R0g4VXVHNXczWXkvcDBtT3cwM21LUFAvOWFGM1BtaWNTdnU0OXhPdnZqZ1RE?=
 =?utf-8?Q?7RKu10CGAP0=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH8PR11MB8107.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?WUNvR2pKR0xnT3Z5YTNFenhlSnd6eHFwS3dQa1NLQXhkdmFXSk1FZEI5bXYw?=
 =?utf-8?B?bHFhMVpBQ1U5K2Raa2JWNjg1TlRua2dDVFRaaXRqY2R3SWJ1SUxoeW54YmZl?=
 =?utf-8?B?NTFiREJCL0oyNHlUM3lXWGNsQ29jY01sdHZqczlkUEhjT2RoUnJYUlRZTUFV?=
 =?utf-8?B?RDVKZmJxbWtlZnRrNHIraUVSY3gzRTdFLzJmS1pBRzVLQWpSTWpSakRvVTg3?=
 =?utf-8?B?ZU5xNk1hTGhlM1hWOEl3VWRqWGpPeVdLb0Z3dzVCRjZvdUtjZHRCdlp0Qjdj?=
 =?utf-8?B?UHhlV3MyUHoxYkVXbW1od3JKT3cwczVWWEZKb2RYc1ZtZ2lLSE1JSWFGbE5w?=
 =?utf-8?B?THFYaUFtcUx0NW5PN3RBUHpVTGpRVmk1bDRnNTRQTGtzKzdjS0IrRStnY1lk?=
 =?utf-8?B?RmpjUVN5K0MzV2FNTk1nTnlFVDVmRkthMVZNRmFBU0V3L25nRlFXTm1QM0tL?=
 =?utf-8?B?eDdNWFhHVXBCaGhTZHU5czRJVjVBa2hPY0M5b2hCMVNzTTZqRlV0NitZZVRI?=
 =?utf-8?B?bWU2cFViOXdJY2xRQ1Z1SHg1ekVzakNyMHdsVm9tUnFuemxOZ3dnSmU5T3hD?=
 =?utf-8?B?Ylo1VzlVbHBkN09NY0I1eGFkcy9FdDgvb0VqWDFYakZzaHppQWtPVHpmeU96?=
 =?utf-8?B?dmhpUmRheDF3NmVPZ2dYWXNUTk1vaUlnTGdna0VWbnJKbjJCYU1ySkpiVGNS?=
 =?utf-8?B?c2dHZXdOVGdFZFVma2VUak5OSHVuMmtvbGh5TlpSZkhCMXdTam01cEI0TEx4?=
 =?utf-8?B?MktyVXNCSWZKbE5wTlhjMXVvOGQ3VmQxWmEzNTRja3ZramNJdVA1cDFGVTVC?=
 =?utf-8?B?T1pacFYyWWN6b0o4V2NwZTRVLytmNkYrU0dPNGZQbkVQd2RIdjVEelhKWmJJ?=
 =?utf-8?B?SnVqOW5wejV0QS8xa2NYc0ZaNStTMldJeVkwa20xS1F5VThadGJ0OVBxUFlN?=
 =?utf-8?B?VEdvSFhBMERHSXFkS1F5VmUycmRWcHV0MnhNRElIWWE0UnVVcWdsRnJzVFRo?=
 =?utf-8?B?NzFuOVlnK2FIcURjb01kOTBIOXBHUDRBUnlPMXh1RHo5L3lPSVkyNFgrUERo?=
 =?utf-8?B?UzF0TGhhZ3lGdTRQZ3Jqbi9nVEp6RnZmL0VJNExpaDNCUlpQaDhWdkJlby90?=
 =?utf-8?B?UWljV0xKQnpIZG9GRVpxZEgxTHBYZDdLRWs5akQyWGkrcGpGaWpad0hWOE9u?=
 =?utf-8?B?Z255YVlobHpsYnBSSUZ5UEFtVDRJdDlhTEJiMU8wL3VvTmhvT2NZTlc2bXll?=
 =?utf-8?B?b1Q1RS8vM2hnNGY3dkpaN0tLT2JWNm11V1dLUkozY0NFUHIybXR6TmF1TU1K?=
 =?utf-8?B?WFh2dFJmVFdlTkdIQmlhT3RpTVVMbnVnd0dNYVp1VHZrTzNzb05BbVkzbkdU?=
 =?utf-8?B?dFRsR3cxN3JXZ25GL0FuMS9pZ3NqVjhJS0U2SWEzWmNMKzRiSElvYW5NUDZl?=
 =?utf-8?B?MExyeVdiUmlKakNlY1VWVCs1UGpsam1zTlZ6eFpsckdydkVKd2hkVHlub3dO?=
 =?utf-8?B?WU8yVXFjSUgvR1FVeWNkcUhiZ2REMHhqbDZjc3Q2ZGFCc0ZVUUZYckJkejFZ?=
 =?utf-8?B?eUMwK2FYZ0t4cmt3OVF4dWkyWnA3Mnk2WjhqSnV0ZUFVWTNlTjNRcTNvRVBi?=
 =?utf-8?B?K2ltUUFjZnhEMysrdFRGR1JxaXQ0QkI1ZkdKOTBDUnZ3MGlmVWVjNXQ3WFNE?=
 =?utf-8?B?MXgzdVpJRUhVbTBicnRBMllWL01BTUtQZE0wQjJXcm84N3ExZm0xQnJyS2pE?=
 =?utf-8?B?RWh0S1ZaTGh3MVQwMGRkbGl4U3dHc1ZrVjhoUU1JY0NpNnVBOW5nT3NsYWNH?=
 =?utf-8?B?TGxyWDdnZ2h6Sm85cm01TUdzUHhEQmFxc0hDZ2RhbFp4cjBmck9oaXkvL01B?=
 =?utf-8?B?TFpINm5keG1oR0xjV0FQMmRuZExxWHQ2R2xmOGk3RENxeVYvOXdDZGFsd3VL?=
 =?utf-8?B?elVtM0p5cHVEckVBK3NIT3ZzbmNWaVRxQ2VmaFNVaXZISkh5TFZhNERsTzNL?=
 =?utf-8?B?b3hHdlNzekdGZVdIMHVkZWFxMDRjRzNwZ2tZWFRBUW05cUtQTFkzWklyNE5O?=
 =?utf-8?B?OFFTUmNaREdYdkZLTy91enhMVG9kckh0NUI1OVZaRVord3ZhOWpqaUd3TVla?=
 =?utf-8?B?ekFnc3FYcTVzUUYyOGJTNDdRa3NvbzRtaFJ3aEh1b2tvbmtuM3lLREVLc3cz?=
 =?utf-8?B?Z3c9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 115a980e-9f94-4d80-218e-08ddfa2f1388
X-MS-Exchange-CrossTenant-AuthSource: PH8PR11MB8107.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Sep 2025 23:23:45.5778
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: yqiizRBhUigfg6uJKInafgDyn1v1tg3deVGOUQ7Ja9oHbbFiSjX3+PzJfiV/bgXsyc7UuvE+FMKHp69XGxqj5vifo2e7QKNf8V0cJnHVBL4=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS4PPF1DFB73954
X-OriginatorOrg: intel.com

Dave Jiang wrote:
[..]
> This needs a bit more changes. I was undecided if I should include
> those changes in this patch or if they push out of scope. But it
> sounds like I should include them. 

You can do them in their own patches, but I would keep those patches
together in a series.
