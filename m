Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 551AA8C11
	for <nvdimm@lists.linux.dev>; Wed, 24 Sep 2025 01:16:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.16
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758676571; cv=fail; b=u2rTN2R85OD2XUQfXr7KhirRobhrCbERQMkAMhw92B65o4t5Fv12SayAMCJxCeD7BaxTCOeKis/w2+DAB4fvUkSMIb6Wfw2QutoB4aJgC1Dt3dwM5hqTeO6qIis2jb0b+bv3a6jXwpztVBJ6/sdGzIDWxRMi2DreSoF+kk7WYws=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758676571; c=relaxed/simple;
	bh=MGJjD4vEL/eH/fuG1Lv7w4ej5MlRjCiBLYuhi//RzyY=;
	h=From:Date:To:CC:Message-ID:In-Reply-To:References:Subject:
	 Content-Type:MIME-Version; b=psxpjwA7qzC+4ADk0H65uKUZy3JPguFtgWZdE9VcxW7lARQ4Eo8EErVIgd1Ff8hmWLoFdvnN+TeyWBhWBj86/ExAxOgN/lf4WTcksgFNVdlU1W2Iowx4NMJs/DwviEpFV/WsMyVYBoz5Lebzz7ILBRtUKzR9CltcenMNYfq9kUs=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=hCsd/oY9; arc=fail smtp.client-ip=198.175.65.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="hCsd/oY9"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1758676570; x=1790212570;
  h=from:date:to:cc:message-id:in-reply-to:references:
   subject:content-transfer-encoding:mime-version;
  bh=MGJjD4vEL/eH/fuG1Lv7w4ej5MlRjCiBLYuhi//RzyY=;
  b=hCsd/oY9Dz+ftSi7NcNpqF2K9zaBiSHpvW4Mv8pwAO4JCC8U9s/+JQ0y
   9qM/YeZz8202O8Qcp0WvcpTI7FN4HQLOe4VDSXQLCQ2eO36RXTzlR0QNY
   OQFNghLZRylWAnYzF4hSpGqDlm9EFKWA5cMQefNAsZrmYAxCmg2ZlXYM3
   1Z+fEdbA7mEaU9nE3KBama2NjWV9hXpUHEv9p4n11/PdZBBx69HCeW3oT
   KB834cjIPAdyOJvBXzsyjwMGREdQTJVuYVKylA2rPybBcUZK9ueoPt7wj
   ZJAAHdabUFuMJLaiNvo1K+ANiyxhInWAk/m7htgZpqzPlTGiWLCH9vxfo
   Q==;
X-CSE-ConnectionGUID: 6XAjXFmzTuOnb7X914NPvQ==
X-CSE-MsgGUID: +YkN/ETsRaufL6r1zh+KYA==
X-IronPort-AV: E=McAfee;i="6800,10657,11561"; a="61136922"
X-IronPort-AV: E=Sophos;i="6.18,289,1751266800"; 
   d="scan'208";a="61136922"
Received: from orviesa006.jf.intel.com ([10.64.159.146])
  by orvoesa108.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Sep 2025 18:16:10 -0700
X-CSE-ConnectionGUID: 25hUuq+KSCydNsZJv+YP4A==
X-CSE-MsgGUID: uooAzigtSFKKoxgP8kqtJQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.18,289,1751266800"; 
   d="scan'208";a="176024572"
Received: from orsmsx902.amr.corp.intel.com ([10.22.229.24])
  by orviesa006.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Sep 2025 18:16:10 -0700
Received: from ORSMSX902.amr.corp.intel.com (10.22.229.24) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.17; Tue, 23 Sep 2025 18:16:09 -0700
Received: from ORSEDG901.ED.cps.intel.com (10.7.248.11) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.17 via Frontend Transport; Tue, 23 Sep 2025 18:16:09 -0700
Received: from CH5PR02CU005.outbound.protection.outlook.com (40.107.200.14) by
 edgegateway.intel.com (134.134.137.111) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.17; Tue, 23 Sep 2025 18:16:09 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=fsRyxcN9I2HL40C9XEqH+FFp9PHytl6rat74OLPJdHjauoFmHEgL4mruQJdp7yxe5gPIHT7UzRRxPJ0qw2eCyPu/pKoZC6Mn5g4RPVvb+r8Mb4EhRm9mKSyfkcGTUb+Wl/OXfXX49enW4npCz+Ht9gtP2FM8Ro2eUC689pQqgPLwhIPH+4upa2BfIqzTYJCNYa+nbjru6zxOcAm5hec/AfPff1Dp5B5dxtxs+P7iVaH7EKiTwKyaTC0UmEivDkg+ID3IJjjBb8jlCS3sorLOk2MW7F/2jR3Fd3mRTmUm8xv1NxVLQtaja92YRXUeipDd1F6RaiXmQsXF+RebL01biQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=6F+E6EvjBWFEM7hhHMmVLRruKJa9TuTBv0XWeeHcnJg=;
 b=U68pVoC0Ch+yofzUXxMwV8ZgcOcLkUs1DXzPPX/5nfnoZsLLggYJYQIdt1NZG5e9VmZOg/mlCbHi5w5fkw2sSfjBwkEqIzz6kokVtCkEk5kA1FOcn3yDY2vl693eFQOQBCNINmYg2ftTd+4lM7HeAQ8kfY78+mUBixfc5kgY4c0V4HFY+ohIXa/V24F9UMlEA1JV0RXOghYx3SVEuwwI2PIPD1SthS7a4sZeaeVi757X47OBugKCdxA0QAPJaKkTZDsWLZ0NdIUqviGqejMyBu2QtA8ktJ67u1I9DTJ1vj2tQeF8I0x2DcpfTgdQqBK97mXWLHZMA5i5+3K/Y3RP2w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from PH8PR11MB8107.namprd11.prod.outlook.com (2603:10b6:510:256::6)
 by CH8PR11MB9505.namprd11.prod.outlook.com (2603:10b6:610:2bb::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9137.19; Wed, 24 Sep
 2025 01:16:07 +0000
Received: from PH8PR11MB8107.namprd11.prod.outlook.com
 ([fe80::6b05:74cf:a304:ecd8]) by PH8PR11MB8107.namprd11.prod.outlook.com
 ([fe80::6b05:74cf:a304:ecd8%2]) with mapi id 15.20.9160.008; Wed, 24 Sep 2025
 01:16:07 +0000
From: <dan.j.williams@intel.com>
Date: Tue, 23 Sep 2025 18:16:05 -0700
To: =?UTF-8?B?TWljaGHFgiBDxYJhcGnFhHNraQ==?= <mclapinski@google.com>, "Mike
 Rapoport" <rppt@kernel.org>
CC: Ira Weiny <ira.weiny@intel.com>, Dan Williams <dan.j.williams@intel.com>,
	Dave Jiang <dave.jiang@intel.com>, Vishal Verma <vishal.l.verma@intel.com>,
	<jane.chu@oracle.com>, Pasha Tatashin <pasha.tatashin@soleen.com>, "Tyler
 Hicks" <code@tyhicks.com>, <linux-kernel@vger.kernel.org>,
	<nvdimm@lists.linux.dev>
Message-ID: <68d3465541f82_105201005@dwillia2-mobl4.notmuch>
In-Reply-To: <CAAi7L5eWB33dKTuNQ26Dtna9fq2ihiVCP_4NoTFjmFFrJzWtGQ@mail.gmail.com>
References: <20250826080430.1952982-1-rppt@kernel.org>
 <20250826080430.1952982-2-rppt@kernel.org>
 <68b0f8a31a2b8_293b3294ae@iweiny-mobl.notmuch>
 <aLFdVX4eXrDnDD25@kernel.org>
 <CAAi7L5eWB33dKTuNQ26Dtna9fq2ihiVCP_4NoTFjmFFrJzWtGQ@mail.gmail.com>
Subject: Re: [PATCH 1/1] nvdimm: allow exposing RAM carveouts as NVDIMM DIMM
 devices
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable
X-ClientProxiedBy: SJ0PR03CA0377.namprd03.prod.outlook.com
 (2603:10b6:a03:3a1::22) To PH8PR11MB8107.namprd11.prod.outlook.com
 (2603:10b6:510:256::6)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH8PR11MB8107:EE_|CH8PR11MB9505:EE_
X-MS-Office365-Filtering-Correlation-Id: c9836c32-e6d5-4ab7-800c-08ddfb07f012
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|376014|366016;
X-Microsoft-Antispam-Message-Info: =?utf-8?B?dnlreTNZVmhwTVBGVEx3QlVyYmtyRnNkdmJldm9nbmI0NFdiZ2VqeGhYR1Av?=
 =?utf-8?B?WDZ4ZmpRSU1UbEhsSG10K2F1UWtlQVRvK0swK3lqaXRuMmJVOG8xNzNoZmwv?=
 =?utf-8?B?a0RBUkUwdCtRRlJQQ0JxRzYrckhvR3lXNmxuWDFiUTVETzEwOTZMN3JjUm1z?=
 =?utf-8?B?L0NsSDdhcEQvQkpwR3FDZ0twQm9QM0NhQ2w1K2pKK3p2VHdRd0tRam5mOUNQ?=
 =?utf-8?B?V1JSSVdDUGxOcnlmSGorL2pjZFd0dkhpaTdWQkFoMmtMZlRsQU1SZVhyWGwx?=
 =?utf-8?B?R3o5aUhVV1k0ZGltVDh0aU9jNEd1b1B1MThqbGpqN241RnZzSk95bmVzMnEw?=
 =?utf-8?B?M2JxR2VHSlRibWlPWHBLT2kzSjlCaE1wcGVqOTJvamExZTBsNGtHTlJWRDZl?=
 =?utf-8?B?WE5aQnFVdEpsUUFWQm1kM0hSS2YySkNpamhaeWx5WVNUV2UyVHVLMC8wQ0Fk?=
 =?utf-8?B?SDdlT0U5ZytDb3ZBS3NZSUtVU093Zy9ndXZkYkp5K25rczN6MHQxYWpIN3Ex?=
 =?utf-8?B?c1lCTjE2VnpITFJnRDdwbWt6aVBETlg2SlJtOG1BbklmRnhZNEdaMzNCQVFS?=
 =?utf-8?B?dmlDczJCOVlxQTVhWkV6elQwTi9uOGxNeURXNDlucUxlZmw0N29YakNVRjFQ?=
 =?utf-8?B?Mkw4NjNUV2FTcXZsUTFtaTFuSGRyaXEvSTI5QTRTMUd2ZkwxYVZzQmJHUU9n?=
 =?utf-8?B?RkhMWUczL2tLVlhEUkVzUXVvSEFWWEFIbzlGdWdKYmVlWS9WdDc0TUlpNEE3?=
 =?utf-8?B?TkhDd0o1OXV6OVZ6cjA0UUtjRUF5RnZyS1h3WC80WHE1TXNHSmlxSVpCdDND?=
 =?utf-8?B?RXFkdmtMM256a25xUkV5eVNWSGtNNmM1aGIzd25Lc0FDYkkySVJVOS9OVkFR?=
 =?utf-8?B?Y3o0ZGVSRDh0WUFWVVUyTVhTcUQ2TkNySFlJZU5Ia2hDc1BwOFhxNFVYdU9F?=
 =?utf-8?B?WElXUWcyUys0U0pyaW1DNnNKVy8yUXZHeEh1UnFjV3VKaHNDOTViYVpjK3NL?=
 =?utf-8?B?cXMxZVhSNXNVQlpycTZBS1o0UWdScngyclpYZnQydWQwVFZhSkI3VVJBRU03?=
 =?utf-8?B?RSsvOVBqdytaM3FyQWV4OXJVZCtlcWozd2Z5YTlqNk9PT29LcWJXQTM4d21T?=
 =?utf-8?B?L3lFcUZQbXlBS0pPSkVIc3BmUnpTd1JGa3kwdDJzMjdDenVuSjBzTFFmM1RI?=
 =?utf-8?B?a0FkTmJPdGRrNzZ4ZkExVitPTzZGeFlRdTJvV1lHVm5PSjQ4b3N2ZUo5UUVE?=
 =?utf-8?B?MThTZFQzdlJnRU5zU3BEbk5kRWVlNjNHNEVUeUpLUzZ2bnZCcG9ZNjVKZ3Z2?=
 =?utf-8?B?OHZRVG1zb3kvTFY5RDNweXpxRXFlM004MDZENkZKcE12RmZUejF0WE01WFB4?=
 =?utf-8?B?aXp6SXRuZ0FqUWVlcjEzclNEZ3J0WjJYUHQwYUJ0cHRUeml1YUxRMlI5MnBm?=
 =?utf-8?B?Kzh1UnhTT2M0cGh4LzFyVEFzcDE0b3ZDVTlLOTFqQzkrZE5XYzQ1Ry9pcUxE?=
 =?utf-8?B?d2tra2p2NTZmdlcxZ2V2RkIwakFUVmE0enFGMHdiNG4xYUFLVHc2amZtT1Vl?=
 =?utf-8?B?SzY3OFZRQ3FTQnFrQWRqaHQxN2FrK2U3c2lNSEhtaFZtSmVZYTFvMWo2LzNK?=
 =?utf-8?B?bmVMVDZhcy9lL0R1ZXFXR3pwZUZVM3JDZXlBY2IxZWNHbERMbDdQcnVnRmk5?=
 =?utf-8?B?UEFxWkJweEljTTU5eUNlSjc0M0s4d09JaHhFbnZYVTdxY2M3MnBLQmFvc3ha?=
 =?utf-8?B?QU83ei84Vkt0aFdNQnZ1KzZEYU1BdG5NcmRsc3hWdmVGWUZibC8yVGxmVHcv?=
 =?utf-8?B?WnhkRlNoVUp3d0t0aExneFhPQ2tEUFlRd1EzVGtVT2taUDUvMm9VTVAzUVdH?=
 =?utf-8?B?R2FyT1Vpcitsb0hRZXRSemVCTktOQXZjTEFIK0RWdzdsQXZyeVAxaUpEd05X?=
 =?utf-8?Q?kqJJtO0CxUI=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH8PR11MB8107.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?c2pObDlOUm1CSExrR2ljRWRLV2ZPT0FnWitZRzBBUlVpQlBoa1lOM0RnaHJq?=
 =?utf-8?B?bFNBdmMrMVJFMWJqSHVkOXpWb1lkSFQ5WGFaVW1wL0JvbUpsZzA3M1dJeE9R?=
 =?utf-8?B?VURJd2VLcW1zbFErSDlBeU53RHpSdGJ4Wk85K2JvWHRXbGR3SVJJNVQzeDBV?=
 =?utf-8?B?MXMzWHFTK1pCNGdQNjg4NjMvdmNmTGVqN2hVelN3K0tHN0VjL2tnaDZud095?=
 =?utf-8?B?OXhZbW0rQ2NFTGtTeWw3blQrZ0twT1ZPVHkvN3RseXRxRUhHQnZFS0h4M0ow?=
 =?utf-8?B?aVRSR052YmVpT2hnVmZxWTU0d2hPSXBLdFVGeEU4dTR6VkxXbDM2aWtwVk42?=
 =?utf-8?B?MzNRMXFBUUxQdHNPL0g5Vno2K1lHc3N5dm9ObjF2dnp2a2VISFJlbFZBWnZN?=
 =?utf-8?B?bzY5RkJjaUh3NkkyemhJelkyT0V5STFYTW5xZ3drMFdGaEh5N2JTR1pmOWhF?=
 =?utf-8?B?WnIrVS95TGhzV0dMOEsvbTdVb0JYZ25WTHJtMDlhbnhYRVNGR0FUUDVmdzB4?=
 =?utf-8?B?VU9rNURpNUpjbFRkVktLVXhNUXJrMUJ6SFl3NmI3eEwrcnJaR3hjeTFmTWZW?=
 =?utf-8?B?VDFjUTNVSUo1b3JEb0pZTEJzU0RETytVcUtvVXQwekE2TVdPSVg5b3RFb0tz?=
 =?utf-8?B?VmFIdFl2b2JUbkNrU1lFNWo2enVBOGVkQm5IYXNVUmNaOVEwS1dBQ0plWWJQ?=
 =?utf-8?B?Y25yYXgrcW1pRWRGa2owSktaTk1LVzY2YTVRd0IwdEJPZ1VrYjVHSzJ1TGFq?=
 =?utf-8?B?N2U2YldDNzlkekRKOFJZSE9SZS9TUFhveW9LQWVZblliRENPOHJpOHJwUys1?=
 =?utf-8?B?L0UxYlhwdlVWTkpTSmd6RmcyeFNtRVZSQ2xldVEyV2hIajB3aG1JUDdGTUFM?=
 =?utf-8?B?UWN6bkNCVDVUVUNQN053TTR3blpvdDFGZTRFVW8xMitkV215TGJWTTlMSC9Q?=
 =?utf-8?B?T1phaVRTdXRMMXI0T0ljZm1SQWZ6cklrWjFTSGZVaDVnUTNFcWtDd3hNVkp0?=
 =?utf-8?B?Rm1uL1IxL3MzUHRwRWo5UmpCN2QwME4wdWhHTjRQZy82ZkUwYjVjdnVLMTgw?=
 =?utf-8?B?OEw5UEswUUE5NzNnMExsQ09nT1lHTHIybzgwTUNMblBUT2hNdW1INENQT3Iz?=
 =?utf-8?B?R21nbW5xcjhVUklZNWN5WGMrcWFOSmo2ei9tMVJBTUJWVGV1Z0srSFVIQlUr?=
 =?utf-8?B?Q3JYcXQvSkwwMjN0YzExNVpmU0RKOUhBT3RqS0R6OTZURzcwSlFXQW5qbWx0?=
 =?utf-8?B?V0Fjc0xpYm8xT0hPaVlwS0Exc3k1aFhoSzRwMEVPVm85NFV4enhIbk5PMWhK?=
 =?utf-8?B?Z2krUkxEa2VaSDRqRGVYaG9KbG1IVHZjR2NCVzRtQTVDT29SOHpyL0g0WU1h?=
 =?utf-8?B?ZEpWY1ZoUFBYcmw2WDRzcWZqbVgvaXRCc1I5aU1scWVUQjJhNXVVeWIvVUJk?=
 =?utf-8?B?Z2FkTm00QlcvYklxamt3RnRQVlZVck15RFVEZlN2SUpNNlQ0SzkzNGtKbFhE?=
 =?utf-8?B?ajlQa1JhcjJHQXJBZlNCaHpidlR6cS8xbVVwcU82M3g1dGpzTjFPZ1RTV3k0?=
 =?utf-8?B?S3pqMUJjY0dGbFNaeHlOUGN4YjBqa0REaENKQXZHMXl1ejF0S0dVajE1Wkxj?=
 =?utf-8?B?NEtOMHV2QlNvekJOVWFkMWVoN2ZqRnJlbTU3enRDUEZ0OEZ1WmZyd3hBcWcr?=
 =?utf-8?B?bjdybHo5MGF2Z0JBc2V1Snp1WFpRUmZpb0grdWhxM1FMT3o1a0JPT0h4cm9D?=
 =?utf-8?B?UVdEeXNBRHV5R3VsNEhZQWN4OEg0YXJTckxId3pIMkNSamdzM01Bb1FSZVZH?=
 =?utf-8?B?ODJRUXg4OXR4QW1JT1loZ1dOQy9oMlRKNkxUZGUrVWh0elpGaW9IZ1YzeVJO?=
 =?utf-8?B?bzlPZW1iTEE0azVkcFpHR3lxWmlyNDlKYmozaXBEK1E4V1JHTVBnZU5TbDdt?=
 =?utf-8?B?bUhHWFdiU1ZWNzk0bFlPTkIrTGxZTFF4L0dSMnpUblBBc0ZFUHJweE9NSUU0?=
 =?utf-8?B?cklqOVd1RWNmZGVjSUxEc3B1aU9yTWh5L1lscmN6YzN4Wll0SjZKc2tucFlt?=
 =?utf-8?B?SDQzUmFCbEcvdHMvd3BZa3MyUCs0MGhhT1dIMEI4Wk9xT0hOZDdxTzdnd2RJ?=
 =?utf-8?B?SlNkNTVnUVM0QW9YYlhZUDZPdEU2MDlFVm5saHZ2SHk3TyttekNpajBUc3Rn?=
 =?utf-8?B?b0E9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: c9836c32-e6d5-4ab7-800c-08ddfb07f012
X-MS-Exchange-CrossTenant-AuthSource: PH8PR11MB8107.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Sep 2025 01:16:07.5715
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: aTaSqitqv3mKxRVj7WB5MPiB1Aeosyusi3OKWCwQC8iqn6q+LXM+7FMqQysyFhaGhKYOqShSth8F5g+dlZ4Itl9ccpnTPMk/e8pgHdPyCLc=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH8PR11MB9505
X-OriginatorOrg: intel.com

Micha=C5=82 C=C5=82api=C5=84ski wrote:
> On Fri, Aug 29, 2025 at 9:57=E2=80=AFAM Mike Rapoport <rppt@kernel.org> w=
rote:
> >
> > Hi Ira,
> >
> > On Thu, Aug 28, 2025 at 07:47:31PM -0500, Ira Weiny wrote:
> > > + Michal
> > >
> > > Mike Rapoport wrote:
> > > > From: "Mike Rapoport (Microsoft)" <rppt@kernel.org>
> > > >
> > > > There are use cases, for example virtual machine hosts, that create
> > > > "persistent" memory regions using memmap=3D option on x86 or dummy
> > > > pmem-region device tree nodes on DT based systems.
> > > >
> > > > Both these options are inflexible because they create static region=
s and
> > > > the layout of the "persistent" memory cannot be adjusted without re=
boot
> > > > and sometimes they even require firmware update.
> > > >
> > > > Add a ramdax driver that allows creation of DIMM devices on top of
> > > > E820_TYPE_PRAM regions and devicetree pmem-region nodes.
> > >
> > > While I recognize this driver and the e820 driver are mutually
> > > exclusive[1][2].  I do wonder if the use cases are the same?
> >
> > They are mutually exclusive in the sense that they cannot be loaded
> > together so I had this in Kconfig in RFC posting
> >
> > config RAMDAX
> >         tristate "Support persistent memory interfaces on RAM carveouts=
"
> >         depends on OF || (X86 && X86_PMEM_LEGACY=3Dn)
> >
> > (somehow my rebase lost Makefile and Kconfig changes :( )
> >
> > As Pasha said in the other thread [1] the use-cases are different. My g=
oal
> > is to achieve flexibility in managing carved out "PMEM" regions and
> > Michal's patches aim to optimize boot time by autoconfiguring multiple =
PMEM
> > regions in the kernel without upcalls to ndctl.
> >
> > > From a high level I don't like the idea of adding kernel parameters. =
 So
> > > if this could solve Michal's problem I'm inclined to go this directio=
n.
> >
> > I think it could help with optimizing the reboot times. On the first bo=
ot
> > the PMEM is partitioned using ndctl and then the partitioning remains t=
here
> > so that on subsequent reboots kernel recreates dax devices without upca=
lls
> > to userspace.
>=20
> Using this patch, if I want to divide 500GB of memory into 1GB chunks,
> the last 128kB of every chunk would be taken by the label, right?
>=20
> My patch disables labels, so we can divide the memory into 1GB chunks
> without any losses and they all remain aligned to the 1GB boundary. I
> think this is necessary for vmemmap dax optimization.

As Mike says you would lose 128K at the end, but that indeed becomes
losing that 1GB given alignment constraints.

However, I think that could be solved by just separately vmalloc'ing the
label space for this. Then instead of kernel parameters to sub-divide a
region, you just have an initramfs script to do the same.

Does that meet your needs?=
