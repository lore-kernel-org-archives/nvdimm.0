Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C61311EB5D6
	for <nvdimm@lists.linux.dev>; Wed, 24 Sep 2025 01:08:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.14
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758676112; cv=fail; b=DSDgcZSftgRrdzo9LZMAGelhtsw4NW9tOi2am+5TIlfuBs8iOKe/g/WPn5mcgMCoUZthrXU3D5AcY+3cu2eeA1wW3CGu0W0ryezVXO0tbblGK90fJK5libZkIXm+Rw5VXHzKeN50KOMVgqcupBiwE8qNG5vn0dBzm6FEVsngG90=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758676112; c=relaxed/simple;
	bh=/7ufeWSfefo98Dxqv2aW+5YKbpwGnL2GvdtR0FfJrnM=;
	h=From:Date:To:CC:Message-ID:In-Reply-To:References:Subject:
	 Content-Type:MIME-Version; b=bRbWOoM+So2F/rjAx7y0OQdstDWgsbF3+5VUrYD64+q3gEE6ki4nHEWweZSE8tz9IxrhpoqJUjugJMO5JwgxJZP5LDn1Tdr4yEGGhG12kPx7BSlhBkTqscddRPQ4tqglDKD2clcOlFKHlwZrM0115/w7F9TCpl+QkS1fLsYTB0Y=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=Zh+YoX7U; arc=fail smtp.client-ip=198.175.65.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="Zh+YoX7U"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1758676111; x=1790212111;
  h=from:date:to:cc:message-id:in-reply-to:references:
   subject:content-transfer-encoding:mime-version;
  bh=/7ufeWSfefo98Dxqv2aW+5YKbpwGnL2GvdtR0FfJrnM=;
  b=Zh+YoX7UmOxy+p0rnfyisytNh1e4yaAhfgF6D3eXasWZIgv39saRUUVD
   SJuUuUZ8k+/sec1E1MJuFpVd7keuVdHj63FhHhC1fmVUjXXxPQ1FPN7uF
   ZHWrF6mjsXCykzobO7OrNz4cdffhgAhnitM0V1vx1Mkx0hZx1cvkQwysD
   W04Zx0b9Yd3hhakz5dG11D2vcJWFUp6xZIdGr6LdumbkGaoWhkkj+osnD
   vDkK9sFQ97C363X7kR4E4CsgPbwUN+XlpvEmeN0uwhg2txIEmfPseM8eg
   BaUl3RgONMGhYJsK8nhqur156se0bkdSze+oYa039t28GztGlvj+Tvf+e
   w==;
X-CSE-ConnectionGUID: M614vXXQS/2EUKpr8YubMQ==
X-CSE-MsgGUID: vXGivRWORJSw/Fcnq8wpNw==
X-IronPort-AV: E=McAfee;i="6800,10657,11531"; a="64772803"
X-IronPort-AV: E=Sophos;i="6.17,312,1747724400"; 
   d="scan'208";a="64772803"
Received: from orviesa009.jf.intel.com ([10.64.159.149])
  by orvoesa106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Sep 2025 18:08:30 -0700
X-CSE-ConnectionGUID: amtgueiBTpeYfN6UzEw8vg==
X-CSE-MsgGUID: G8Pg5spHTimFctkikylYQg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.18,289,1751266800"; 
   d="scan'208";a="176485233"
Received: from orsmsx902.amr.corp.intel.com ([10.22.229.24])
  by orviesa009.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Sep 2025 18:08:31 -0700
Received: from ORSMSX902.amr.corp.intel.com (10.22.229.24) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.17; Tue, 23 Sep 2025 18:08:29 -0700
Received: from ORSEDG903.ED.cps.intel.com (10.7.248.13) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.17 via Frontend Transport; Tue, 23 Sep 2025 18:08:29 -0700
Received: from SN4PR2101CU001.outbound.protection.outlook.com (40.93.195.50)
 by edgegateway.intel.com (134.134.137.113) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.17; Tue, 23 Sep 2025 18:08:29 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=IvEqUf0kGNfGA1WFh42sDA5VfDBrFvIE2lCKzpD+UvAln4T26bxpBQZQcuf19nFhjdJXd6ifkTAnwiV0nEpWe8qY4migTPIuu1TzkBk/AxBEhVz4HsAF2tc0LYj4sfN7wWaZ8oQYiP1Ej98EY48hQ2F/5MERIpGRQvSs7bPImNa9142b6+JqnvmR4oDg0OwrZCenx5KM95FFWeAcDIRGf4G2GnLlIBlhi2Vu1gdr8NbuvnmjXVJ1z6Ewnou76CFlGwt9K5TgpM9kFfMAGZ3iPFB97Tc8kb7DXZTjsOk5ThsnX7f1BwKfHcj+Y/GLBfAG5E17MvSXfk/mnGQQT4LG7Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=gxCKmHz7xbJ93+u6W407AKmHMXmFqSqxBUMhHLkeXe4=;
 b=rX6s9fq9on9fsvyW7y0sxfLD3WQLmYkcAhdvwe66Sxr+bSND43/BjuEbF3ERa/P/h5HhU9skAqJHK7c7EKesP5Telf1jGPVXNvTYRr3wcprQz+DfRJAv6jfe+auVoIqzjfPLnjgtlEUDBHw90Cg9kQCM4yWXyqvJFZhx/rvaGxLYURILPPMemTcu+3eA2XOP9BYYfkBoJzNC38bwM6g8RhuJwOtIw4yfvu//R8pQKR1MSubkcq9QUXEIDZZ/F4uqAI5BnHh4ZZPox2gnqg6MWEjkVrKa4DJsHd8BMnCE2ZDz0I8fB2n6hGREeCRs9LhU2+4W/ljOBf0kgupPZvuwFg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from PH8PR11MB8107.namprd11.prod.outlook.com (2603:10b6:510:256::6)
 by SA1PR11MB6712.namprd11.prod.outlook.com (2603:10b6:806:25c::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9137.19; Wed, 24 Sep
 2025 01:08:26 +0000
Received: from PH8PR11MB8107.namprd11.prod.outlook.com
 ([fe80::6b05:74cf:a304:ecd8]) by PH8PR11MB8107.namprd11.prod.outlook.com
 ([fe80::6b05:74cf:a304:ecd8%2]) with mapi id 15.20.9160.008; Wed, 24 Sep 2025
 01:08:26 +0000
From: <dan.j.williams@intel.com>
Date: Tue, 23 Sep 2025 18:08:24 -0700
To: Mike Rapoport <rppt@kernel.org>, Dan Williams <dan.j.williams@intel.com>,
	Dave Jiang <dave.jiang@intel.com>, Ira Weiny <ira.weiny@intel.com>, "Vishal
 Verma" <vishal.l.verma@intel.com>
CC: <jane.chu@oracle.com>, Mike Rapoport <rppt@kernel.org>, Pasha Tatashin
	<pasha.tatashin@soleen.com>, Tyler Hicks <code@tyhicks.com>,
	<linux-kernel@vger.kernel.org>, <nvdimm@lists.linux.dev>
Message-ID: <68d34488c5b8d_10520100b6@dwillia2-mobl4.notmuch>
In-Reply-To: <20250826080430.1952982-2-rppt@kernel.org>
References: <20250826080430.1952982-1-rppt@kernel.org>
 <20250826080430.1952982-2-rppt@kernel.org>
Subject: Re: [PATCH 1/1] nvdimm: allow exposing RAM carveouts as NVDIMM DIMM
 devices
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: BYAPR04CA0008.namprd04.prod.outlook.com
 (2603:10b6:a03:40::21) To PH8PR11MB8107.namprd11.prod.outlook.com
 (2603:10b6:510:256::6)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH8PR11MB8107:EE_|SA1PR11MB6712:EE_
X-MS-Office365-Filtering-Correlation-Id: 3c783491-af1a-4d03-32e4-08ddfb06dd69
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|376014|366016|7053199007;
X-Microsoft-Antispam-Message-Info: =?utf-8?B?dkQ1K25xTG1SOUZvMVpXZ0JuMlNreGtLU254NXAreWtva096UE1NcHc1eU9L?=
 =?utf-8?B?bmdVSzBxTS9SNm5zeTV3eWY5UUVNTWVCaHN4b3FjeXJERFlYS3NDT2E5bzk4?=
 =?utf-8?B?UHgzQUI0c3RidHhXUHp5MUdIM0ZzMEVmcnVkYmsvUHdNS1hXakpKajQzTTBK?=
 =?utf-8?B?ZjlVRW9Id1ZUb0lycGhPQ0ZLOGV1SU9iYUFLMTRZeW9OQXJwVkZYUkt2MVNY?=
 =?utf-8?B?eVY0S3FWNFk2QThpbVRBOUNMbGJjOTYxNkFhY3RGQlpGV2p5TEZoS2xNalpB?=
 =?utf-8?B?YWVJLzVMSG9RRWNQYUZZM0c4enlYZm5iMEcrc1FDQ25kT3l2QmJmS01pWEFS?=
 =?utf-8?B?NXVtSEtPQ3M0SCtya085U0RncTRzdEVPTzhmcWo2YjhWazJPUEs4S2FYNm9I?=
 =?utf-8?B?S2p3empUTFhEeDUzdVpXS1cxMGNlQ3RJZ0JJejkyVzF5SUFSZjRlUVY0VHlP?=
 =?utf-8?B?T2JDeGRMRDdyMU1FNi9GcTA4b0pEZmFyTmVXK3MvU09hYWt4VitaTE9KL0ty?=
 =?utf-8?B?VU9VT3Z2WllsQTlGZHhRb1VwdTlBYVlvYlNHL2dtdVNMVFNpQmFNNWRxdFV0?=
 =?utf-8?B?Y1VQZm9zZG80dUJZSnNUQlQwV3p3cGhkeUdkSDQ1YXYyY3Y3ZklkM2ora3lH?=
 =?utf-8?B?NWxzaGlVcXMrM2J5aytVRHYxWWpKVC9NR2RHc09HNG9mbzdqUUs0d0ZiTWlq?=
 =?utf-8?B?ajU4Q1VQYUdCaXBrbEV5cExIa1RHZS8wVVJDdWJuN01RQUkzZHlyMjVKdGlI?=
 =?utf-8?B?TGdIVDAydVJsR1R6V2Zack9MYmFJUGV1VEhUQlZVSmxCbURLL2JHakFFKzlX?=
 =?utf-8?B?LzA5Rm9LSXFHYmVnWDVjSGdXMTYrWUsrUWdXbUxTbHhQc1dydkxvTEFYbmtS?=
 =?utf-8?B?QUFhdk5UR1VJNXJDcXg0OVdwMjAzcFh1eEk5YVpUdFBMUk9uUUhqQWhQU3lH?=
 =?utf-8?B?STgySkg1RkdrNlFQYStWVzE5dmNiUDNSdTBtM1Z1UEE5MlpnQnhOUytOeFNK?=
 =?utf-8?B?WUVTK1VuNjNiZmlsNU5HUDUzL1k5RWdRZHJWUFhFU0dtSTVJcW50VDRJWFZJ?=
 =?utf-8?B?ZDFtaXA1aVRlMFNEUWV2SWxDd0JWdnNTSys2U0V0VStqMWwzcklUREgzdUJk?=
 =?utf-8?B?Smpwc0t5UE1MTEFOajc5NHhGbXo4MXQvWkpXT0lHZHg1YnlPTERJVlRGWGk3?=
 =?utf-8?B?aVdBMGFka2Y2Q1Y1UDRGMEE0U0dPTUROUUZicUxMcVJLTG4vSDd4TThaWEV0?=
 =?utf-8?B?N3FUZG1JcFpJNG9KMTg3K1JGRHBGVm1WelA4eFd6eWUvWkVUYis1cGVwK29E?=
 =?utf-8?B?cGtIcHRRdjgzM0pqTDJFaVB1d21VNXozOHdwZXdQcW5XQnYza1dqbysxQStO?=
 =?utf-8?B?N3lVT2RvejloZm1qOXdROFE0Q2RrTXMrekNVQ2JHeWRrWTNxU3FhZzN5bmtP?=
 =?utf-8?B?eGVEOE9KeDFyNERyNHVpeEdUV2JUbXZZeDUyTjd5WUtzRkFmY3VOQ2ZYTUt3?=
 =?utf-8?B?dlRZMEsvYnU5N0dTektnaHJNV3ZvTFRnNzVaMmpRdHR1enllU08wNUdYT0F0?=
 =?utf-8?B?WFp4b2I2OTZ3TFRwUjA3SFpzTXRDQ001YXQrc0phZ3IxNnJKU1A5S3hpWFU2?=
 =?utf-8?B?KzFEWFJNeGFlU1NSM2ZqQnJtbzIwUTRpRk10WjFjd09Jb1A4Sk9kamJxbkZ6?=
 =?utf-8?B?TzVjd05haHRYMVlDaEFKOU9YVXhGUU54WEJNYUZ1eVgvVGVHajBuTUNHamIy?=
 =?utf-8?B?QUtFZGVZL2U0aWNjWDFiYk9aS3hhNUtsNHVrZzN2MkxrQjhOYTN2RDE4eGRZ?=
 =?utf-8?B?V1dYdE1qUUl2UUZHVFpRSXB4dFBaV0ZCRG8wYVVHZy9YYzBHSGVyVTlJN1hJ?=
 =?utf-8?B?bk9YNTFKalBKT3ZNRnlrZ0pYc0NvaUlITVQ0RmJodTZzZWU3cUN3aE1ZODU2?=
 =?utf-8?Q?Jiasm3buFlY=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH8PR11MB8107.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(366016)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?Njh2TlM4ZW1XL0ZoL2FnQjdQQ0E5ZW5VSU1Xc0FoWG5WK2UwM256WEVPQ090?=
 =?utf-8?B?dXBOTmVwY3BRSkVCOFJmSk5CQk5iM3Zzdm5oRklsNUNmSC8zdGJ5c1lZNWVa?=
 =?utf-8?B?TGN0MEFOU1lTUzJBOWplQm04Z21yaHI4QVR3TEpYU1FHcmlwOHlzcXRWYUJK?=
 =?utf-8?B?bmJXWVd5S3VhL25BcEw1NkZ6dUc1REZoWEtMNzhYVER2aFg5cmk0QkpPRnZF?=
 =?utf-8?B?dS9PNDlvSXhraERSSTZvWWMvVnRoblp3N1k4bDdsVlFLUDZCK3VlWlA5Uy9C?=
 =?utf-8?B?VjZhUzY5TjNCVVltYTR3SGxxYzhuUmY1dUNBQkY2TWY5QjVSZE0xU3h1N2l2?=
 =?utf-8?B?bVVTTlE2c0xHQzg1dnpxcEVYSGsvS1NYcUdhU2Q0djE3aEp6MkwvZUlHekY2?=
 =?utf-8?B?NVVGd01Ma20xQVA3Z05adHdKN1NHL2JxL29kcWxNTXhCcW1oWlBCNXNTVmVF?=
 =?utf-8?B?VFYzVjZCNnJLQnhOME0zQW5salR0NDBKMUtCMEd6eS9wUG1JMzZBbnJiL1Ny?=
 =?utf-8?B?dkY2bnNnWmxweVhuNXRNaDQrOXdwdHRSSFhaZkVnNTBYamVkMHJIcHVJbndj?=
 =?utf-8?B?aGc4VTEzTEVORVRIT1VCR3JKRGR4aUhPeXN3Skxhd1dPUVY1OUo4SEdQVmd2?=
 =?utf-8?B?eUVuWFNPNzBTaHVjTFVrZjNrdGw4NmJmMVpYdU12NVVmRmNGdXc0U3p4alZv?=
 =?utf-8?B?TVhEQWZVcFRzb2VuR1lpZGVYNHEzMkwybWVFeEZYVy9oODJJYXEvYldhNm0x?=
 =?utf-8?B?WHVOSWNmeEJyZWxNaXpKMnQyempBZjZxOEVYVzhodzZVT3NnME1FaFNIby83?=
 =?utf-8?B?OXVvazhYNlZpeTBLNlVubHREUnByZDE4em5BaDJ6SGJoaDZyNUNFdFZtK0ZB?=
 =?utf-8?B?b0xyK3VtUU9QOUNVL1FSZkRZQXBFTzRtME9ickRSNXBHU2txaThmbzlEaWVq?=
 =?utf-8?B?SFpZbjRURS8wZWN3S3B4NVN5U2dFVDV4RG13Q282aVFHMjdIRTFmdkw1andj?=
 =?utf-8?B?VHlodVJzNlpFNmI0MzFlK0FTK2lvZUhKaTNNOTYxK1ppWER6QnRmZjZwRDBQ?=
 =?utf-8?B?Nm5XNFVRZXZjeTNSL1RFTmlnaVkzeXl4RElvVUExU2hBejQraExEMzRTeHZ0?=
 =?utf-8?B?cDFtd0c1U2ZmTm1DZGE5V1Fob2RLaVYzcjZRTDlpSHFDbGFkc1oxSjEzRmdC?=
 =?utf-8?B?citJTHNQT2d5RUQyUDhTc3hpUG80UHptTnV1c1ZMNDYyYTREVS9tb3lPOWxm?=
 =?utf-8?B?bGNEdkx5SWJzVTQzZzNIVDQ2MkM3ck1jYUhMN0NhU3c4L3NoMHNRMTBuWVda?=
 =?utf-8?B?Y0JtbVg5VjVNeTQxaE04dUEvZG1sSWN0enk5VDZUOHIzaGVJVUlKZ1JWTkZT?=
 =?utf-8?B?Z2VkZUwrV3hBSEZlcU1wMjExMHBBb3VPN2pUelM3djhCM25ERTFxVjVMMEt3?=
 =?utf-8?B?VGpOeSt4bm95cWk1Y1lEdmU3MDNRTE9uM2RtbUNJZCs0SGFuMUlUdnE0b2Jq?=
 =?utf-8?B?L2NtMDh3RlJJQUErZldMYTBnQmcvVDR2Nk8wRTMxOHl3UWJIckxXcy95WXhO?=
 =?utf-8?B?Q2NHbktNR3lKdFIvUDhHTERuNm9xcmk1YUtWYk1vWEVEeWpmTG9KS2E3UjBx?=
 =?utf-8?B?Y285Mk9nUjJBTTRSd3lVYkxIWjlPNjdoa09DWFhDNzBNcE1DUGlzS2l4OGZK?=
 =?utf-8?B?UE9MV2J5R0hRbzl4aHVXQWZvaHBWQS9JS0UxbGVHWjJQL1RlenhGRTZTc2NM?=
 =?utf-8?B?ZUtacmpZQTJZbTJFZjArTDY5ako0V2NTSnd2Wlpla0tSR2RMVkFCRW45UjU5?=
 =?utf-8?B?b1BSdFNuWGVySGpZMzdydnNCcC83Z1padWlQODVJVWE1RWJjMFc1Ym1pVVVW?=
 =?utf-8?B?TWpSWWFrc3Zpa2dyNU5zSVZnVmVsZWNJMkI3U2lNRER4c0xsUUErdUpRUjRR?=
 =?utf-8?B?dGhSN1psSDhBbTRpTm1nL2hDcE9Sa2hkVE5ZbUdiYURGc1V4NHJYZ1FydmlJ?=
 =?utf-8?B?TUlhNjBIeGo3QlRQWE5HNVlNcm1oNU5ldnZ6Z1JGSGpoYlZ1VlYzbnF2U0pX?=
 =?utf-8?B?a3NSdmp2djZnSTA3b2ZrWFgvcTJ4L091UmtyMVlicHBRMnhKY045RnVUODF2?=
 =?utf-8?B?bHRoNk0zVWs4L2t1c1J2VTF2WlA3Y3VsQ0JSSG43MG50dTU2UU5qcGkxMHlD?=
 =?utf-8?B?eHc9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 3c783491-af1a-4d03-32e4-08ddfb06dd69
X-MS-Exchange-CrossTenant-AuthSource: PH8PR11MB8107.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Sep 2025 01:08:26.2149
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: kJEPwlFHHe4jFY+5ZW9oyYu4kDHhxc0YaKyl76PKz5+qCWqKIwkpzMx1I+Q+RzRfYAbKL7jUA9znqtoiZcFw3nwPhMgf+lb2AMNVWKApK4M=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR11MB6712
X-OriginatorOrg: intel.com

Mike Rapoport wrote:
> From: "Mike Rapoport (Microsoft)" <rppt@kernel.org>
> 
> There are use cases, for example virtual machine hosts, that create
> "persistent" memory regions using memmap= option on x86 or dummy
> pmem-region device tree nodes on DT based systems.
> 
> Both these options are inflexible because they create static regions and
> the layout of the "persistent" memory cannot be adjusted without reboot
> and sometimes they even require firmware update.
> 
> Add a ramdax driver that allows creation of DIMM devices on top of
> E820_TYPE_PRAM regions and devicetree pmem-region nodes.
> 
> The DIMMs support label space management on the "device" and provide a
> flexible way to access RAM using fsdax and devdax.

Hi Mike, I like this. Some questions below:

> +static struct platform_driver ramdax_driver = {
> +	.probe = ramdax_probe,
> +	.remove = ramdax_remove,
> +	.driver = {
> +		.name = "e820_pmem",
> +		.of_match_table = of_match_ptr(ramdax_of_matches),

So this driver collides with both e820_pmem and of_pmem, but I think it
would be useful to have both options (with/without labels) available and
not require disabling both those other drivers at compile time.

'struct pci_device_id' has this useful "override_only" flag to require
that the only driver that attaches is one that is explicitly requested
(see pci_match_device()).

Now, admittedly platform_match() is a bit more complicated in that it
matches 3 different platform device id types, but I think the ability to
opt-in to this turns this from a "cloud-host-provider-only" config
option to something distro kernels can enable by default.
