Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.17])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CEBC734A79D
	for <nvdimm@lists.linux.dev>; Thu, 12 Mar 2026 19:54:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.17
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773345248; cv=fail; b=I77M4ljeLha39kQw/nSXztMxLW5m02B0tPBLDFp+cvGAJQ/l3ppR1+YEu4ToQofzvWJuRVHBSuH5y7On11z9a52o9Snmv7YHcZpE6XnZ1Xs4pW7hjD8yl7qvnkBvQLhlwRjuSjlyuyAJBMhf1Oeo+5VRiKGYGKjDRifwhr6XOtk=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773345248; c=relaxed/simple;
	bh=lph6svjWDVbiSEGdd1Bh7wj/BjNy6il4FJ9wahbBZQM=;
	h=From:Date:To:CC:Message-ID:In-Reply-To:References:Subject:
	 Content-Type:MIME-Version; b=TDURshmc4HkBv99zl4oGA4x44Tp86jFF/QzkXxysztboyG62k4msxW6w0KPN4S6dYmQwIj2ZPD5UgmMPk/ivp2toP1ZrmjvS5FZ4oeiaTa1LRj8czww52k6dre0iIVetK9PjYfsvpyHDN2N2D8JmhsW5cyhXmNjfxCLzZzyBff0=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=ddlR/faO; arc=fail smtp.client-ip=192.198.163.17
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="ddlR/faO"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1773345247; x=1804881247;
  h=from:date:to:cc:message-id:in-reply-to:references:
   subject:content-transfer-encoding:mime-version;
  bh=lph6svjWDVbiSEGdd1Bh7wj/BjNy6il4FJ9wahbBZQM=;
  b=ddlR/faOrWlQP9nCLCyXWjpUnmQYlagrWAewejJhb6URvcFEnow+08as
   Hs1sYd+2Vc4E5OM4imxsaJgh5aqGloBCjDtcHdqcPAqw1XyRMpYwCt28g
   kWhmFv0SG5O6RBAXkV6ygzmbswEP8nITp2fMB/5ljWLahDfIHrprJclvU
   4UhNz265TFMVjFKPKGCvKHiUhI791RSb0oM0rsmT/rmQZOiakYZ54z3ra
   vkn0mqx1JTBouqLQJhpQgf4hY+GCaucuhk285ZaXcgmVDEPndt4Nr1VE/
   KqD28JyoQ1CFbLh3Dq/Iv6LrhSipiGijeUaR+4bal9dt/vqIua2fStHGR
   Q==;
X-CSE-ConnectionGUID: /XX67kMaQZeslV9Bw3F1pA==
X-CSE-MsgGUID: YcvJCmqcT16tr/uP2UybGg==
X-IronPort-AV: E=McAfee;i="6800,10657,11727"; a="74366392"
X-IronPort-AV: E=Sophos;i="6.23,116,1770624000"; 
   d="scan'208";a="74366392"
Received: from orviesa010.jf.intel.com ([10.64.159.150])
  by fmvoesa111.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Mar 2026 12:54:06 -0700
X-CSE-ConnectionGUID: 5FIzWZaJRKe3gIIhSAlOgg==
X-CSE-MsgGUID: kr2/fXmYQqm/LJ5hSOa8hQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.23,116,1770624000"; 
   d="scan'208";a="220189271"
Received: from fmsmsx903.amr.corp.intel.com ([10.18.126.92])
  by orviesa010.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Mar 2026 12:54:04 -0700
Received: from FMSMSX902.amr.corp.intel.com (10.18.126.91) by
 fmsmsx903.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37; Thu, 12 Mar 2026 12:54:03 -0700
Received: from fmsedg901.ED.cps.intel.com (10.1.192.143) by
 FMSMSX902.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37 via Frontend Transport; Thu, 12 Mar 2026 12:54:03 -0700
Received: from PH0PR06CU001.outbound.protection.outlook.com (40.107.208.31) by
 edgegateway.intel.com (192.55.55.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37; Thu, 12 Mar 2026 12:54:03 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=HgY7kvakvXwmJg/gcJQlPHo8tV/AqxHEgwKuFjkKs8wY7revpZIURTib7Xu116STPurV0TJuSaWu5rYdwSv4rOmCZUbTYWzusUStweoiASXs1ETOyPcEJPn1WcrwYAfWhCZ1pvY1dT0YXGpQnFtxpj2QMrd1U42VL0AptsPMBplNiu2iWVbtP7AFCzwmgVJ78+ofKTY14hd1Ha+EZsmEuWS/HiQeiluRzMbfG5wju5yQtrz2wCYz1u6aNTMLhPeNXnggjYW9eqdnBsBTXHNLRCf/d8ItyU0K1wZAZ0JnvG40BiVYuSNySWvZNB2Sq0gSvo992L9tQTwOhfjXGAWaZw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=lph6svjWDVbiSEGdd1Bh7wj/BjNy6il4FJ9wahbBZQM=;
 b=l0NqB4FlbHuH5jJ+fdbhC9Jk9luMEGzZS1YtPpxaILBQVNn5aVIA1EqYRVmHb/o+R1krVoV91XcwIYjMSdKlyoVNp+WmuV5GTWU9GqPabNxyYsICP82ZKtNKZVCeuhWod8n17UaZjK+BbVU/qZiaK0PLF6N90OlzN6wIf3s3hLOm2aMVIesvRqOFdz0VomqSq2Yg1ZvRtykxKQ5CqadTK5kKU7I/kK+UT0f6M0ipLbKawgv/c73dnIIchD3PvjY+zdiVTj3By25MBOioopQjXi4hhT66ldfXOQkxHUMKcgg+Aprj/FfvnmzcOJ8d5rVtmc8UVOS299UPtbrYjLI0GQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from PH8PR11MB8107.namprd11.prod.outlook.com (2603:10b6:510:256::6)
 by MW3PR11MB4555.namprd11.prod.outlook.com (2603:10b6:303:2e::24) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9723.6; Thu, 12 Mar
 2026 19:54:01 +0000
Received: from PH8PR11MB8107.namprd11.prod.outlook.com
 ([fe80::1ff:1e09:994b:21ff]) by PH8PR11MB8107.namprd11.prod.outlook.com
 ([fe80::1ff:1e09:994b:21ff%3]) with mapi id 15.20.9723.004; Thu, 12 Mar 2026
 19:54:01 +0000
From: Dan Williams <dan.j.williams@intel.com>
Date: Thu, 12 Mar 2026 12:53:59 -0700
To: Dan Williams <dan.j.williams@intel.com>, Smita Koralahalli
	<Smita.KoralahalliChannabasappa@amd.com>, <linux-cxl@vger.kernel.org>,
	<linux-kernel@vger.kernel.org>, <nvdimm@lists.linux.dev>,
	<linux-fsdevel@vger.kernel.org>, <linux-pm@vger.kernel.org>
CC: Ard Biesheuvel <ardb@kernel.org>, Alison Schofield
	<alison.schofield@intel.com>, Vishal Verma <vishal.l.verma@intel.com>, "Ira
 Weiny" <ira.weiny@intel.com>, Dan Williams <dan.j.williams@intel.com>,
	Jonathan Cameron <jonathan.cameron@huawei.com>, Yazen Ghannam
	<yazen.ghannam@amd.com>, Dave Jiang <dave.jiang@intel.com>, Davidlohr Bueso
	<dave@stgolabs.net>, Matthew Wilcox <willy@infradead.org>, Jan Kara
	<jack@suse.cz>, "Rafael J . Wysocki" <rafael@kernel.org>, Len Brown
	<len.brown@intel.com>, Pavel Machek <pavel@kernel.org>, Li Ming
	<ming.li@zohomail.com>, Jeff Johnson <jeff.johnson@oss.qualcomm.com>, "Ying
 Huang" <huang.ying.caritas@gmail.com>, Yao Xingtao <yaoxt.fnst@fujitsu.com>,
	Peter Zijlstra <peterz@infradead.org>, Greg Kroah-Hartman
	<gregkh@linuxfoundation.org>, Nathan Fontenot <nathan.fontenot@amd.com>,
	Terry Bowman <terry.bowman@amd.com>, Robert Richter <rrichter@amd.com>,
	Benjamin Cheatham <benjamin.cheatham@amd.com>, Zhijian Li
	<lizhijian@fujitsu.com>, Borislav Petkov <bp@alien8.de>, Smita Koralahalli
	<Smita.KoralahalliChannabasappa@amd.com>, Tomasz Wolski
	<tomasz.wolski@fujitsu.com>
Message-ID: <69b319d7e6adf_213210086@dwillia2-mobl4.notmuch>
In-Reply-To: <69b1e0aacb9d0_2132100c5@dwillia2-mobl4.notmuch>
References: <20260210064501.157591-1-Smita.KoralahalliChannabasappa@amd.com>
 <20260210064501.157591-4-Smita.KoralahalliChannabasappa@amd.com>
 <69b1e0aacb9d0_2132100c5@dwillia2-mobl4.notmuch>
Subject: Re: [PATCH v6 3/9] cxl/region: Skip decoder reset on detach for
 autodiscovered regions
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: BY3PR04CA0001.namprd04.prod.outlook.com
 (2603:10b6:a03:217::6) To PH8PR11MB8107.namprd11.prod.outlook.com
 (2603:10b6:510:256::6)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH8PR11MB8107:EE_|MW3PR11MB4555:EE_
X-MS-Office365-Filtering-Correlation-Id: 7ea2912f-6929-49ae-2f69-08de80711b63
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|366016|376014|7416014|3122999024|18002099003|22082099003|56012099003;
X-Microsoft-Antispam-Message-Info: sieh5dwTGVDlmjMISYNyfpmarRSKfMYwFfd4KLQVha1myIed5Niv077vj5BAGyY97u7l4vjB5Hvg3pToiV2wvNz3rDOIEsJL5CcaS2U0X8M+EY8NO4SE8te+fJk6RuwMQrHCXvXtMdkTwguFwx43ugMzeD41R5nKUjWK/yPfbeAVHkR+uJdoZd+n6qd48QZSG5c2+4Jf9wT8ztawQX8ssyqDsOd+sHkV4w8FOOGwnSj7oQpm8OXTjT4pHx3osC8RN9P1en8Jm352mJVzDCKwODV7+1RpXGQ7fJigqkqVHyM+tFbliUgey6r/RvHC0J37+J5b5THsD4zy4TYzAi8aig6RNqXyUDagBUkefsowJk4Xf7UZQ9Fk7fX6MHnaLaouqENe7/Y0dBr0p9jVAkq5j1TcUKAEIiLI3FrJbbMoVUilXNe//LMG1XCOwhHwL5LuhHNFYNnh3SJJNa16tPlVGTGWSzbjKx4NJbrxMZxLzaFlR5exhPPwmizEbyB0wCHM8yM0NpUfvSsIG5zZnTxL4MSK8aXF5czeEy/dfaKiF9uVQ4dV30xVWTsg5p3gN6jLfuFLX+HmRT9y1IWQToYcO8/VImZJLSQJXKmPD8oKcj0KHZsy+D+sPDmpDeuN6kGoz77HpRAeBJsWROC7+GXU4lmcG4b/YL7A8C1sgVqmwJMRk6/2CC0cNo863MW2fE8RwOk2RQ3D98x2yXg6Z0RLU4S5S//aLVyyNQdkJ8/2z/Q=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH8PR11MB8107.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014)(7416014)(3122999024)(18002099003)(22082099003)(56012099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?cUY0YmtYNkR3UjNGL2FseUFnbXpycWJNUzZIb1liWE5zM2YxWlZ1ejZOZTRj?=
 =?utf-8?B?Mm1pb0ZiNmFFeUZRYUJvVFNWOUdkdzhudXdmT09EaEVzNWRhTDR0clhsc0cy?=
 =?utf-8?B?RUtFMlE0dGpHeHZRSU9tdnFBUkl1MHUzdEovMVcvMThKVzZ4R2htWUJjTysv?=
 =?utf-8?B?VTFlQnhVT0hBZjg5RFhZd0xIZm5DTkRWbGk1VVpYNXRMMk5MMXE4MHl4Qk5Y?=
 =?utf-8?B?WUtjNUNMSmlqOWJpalc2MEdRdDc5Znlyb2tsM0sra2lGTlh1OXI3QUFsWnBT?=
 =?utf-8?B?eWZ3MWhMZGFTUjJCQXlpbkZzeUVkZ21wUll5bXJIZ0tYanBYbHc0clhVdzg4?=
 =?utf-8?B?bHRRbzRnT0RJdU04Ykl5c0owelJWOGZOQ09LT3owYWYvNVhWNDNGZ3lQNFln?=
 =?utf-8?B?VHIyekRKQmdzMGdVQ3BxZE5NWjVremluTkpzMklFREVVTXVyS1ZHelhNVzM2?=
 =?utf-8?B?VndGbGlXTEE5V3dUbTJDQ2lla0M5MFN3Z1htWE5wbDM0V0x4SjdlbnZJZzdH?=
 =?utf-8?B?T1lIQ1hnVWh6ZSszS29RQ3ZuSHFFYlI1U0pLNFR6TW16S2pxcWR1bmExMFFx?=
 =?utf-8?B?a3A0bDhCSE1qQzMwV0htYmhLSEhLdjdldzZkL3IvTzQxOFpBRlRnYVVoaG5G?=
 =?utf-8?B?Nk9ZNkJ0VE1ZWU5ua1RWL1prdUhhZlo1cGVyWnprQXROVDV5NFJPeE5IK2ZL?=
 =?utf-8?B?VFpTcUNaVFFjUk1BajBFODVLbzdRMDNLUXNnRXo0LzlJbkhaVlF1Y2FDU2Jr?=
 =?utf-8?B?TnpqODBYeXBNdTBjR3UyNEEzRklCeCtzVlZadUlqUCszYlExdEpMVjZ6cHZ4?=
 =?utf-8?B?L2hoU0RaVVVtd2xRZUM1U2xVQ0drVVBQKzhoLzBCKzhFU1pRNEZyWGRvUjN2?=
 =?utf-8?B?YTMyT2RvcmxUdmJIRGVoWlo3QUFzaW9zV1F5WG1ncE1sRXAzc2ZGcWs4MmdM?=
 =?utf-8?B?c0lJYUp3OU9EV09JZngzNXdZbTl2RVlxK3BoTEM5UHFTZDJmQW8yaXkza1NN?=
 =?utf-8?B?OHlGc3dHY1JTMDM1dzdPeVZ4dk5HZHJrY1k0SllIVnVvK0MyV2I2eWlLMnN4?=
 =?utf-8?B?Z0p0c2hEd2VlaVc1OWcveWNyYmJUWkJtbWFTc2xqMVlLVFBxOHBINTFoTmly?=
 =?utf-8?B?VnRBRDhDS3cvdS92SGtDaHlXYkdDbXJVVmJYRGxQYmJoSDI0b0NjL3ZXb1ZR?=
 =?utf-8?B?Y3FqNVV2Mml2NVJiNEEwUHZsa2RxSGdvT0hxbTl0b0JsdzREcG1yV1pqVlEw?=
 =?utf-8?B?L3FLK0dnbkxlaVNISUk0SHlZMXo4d3BReU1HcW0zVlpjakswME9xUTNSZkxk?=
 =?utf-8?B?VytnRkFMRHFFK1dqaldKZWljRnNUUUJZQXNpUy83ZzllcWxGZ2xFV0kxL280?=
 =?utf-8?B?alVhZURIQlBWL01sVSsrQWR6dWZpSi92OHJkeEY4ejNtZ05PVW5vditIQ0Qy?=
 =?utf-8?B?UkcveGNyWi9pMzQ5NHRTRmJtZU1vOHVrNmI1SWVQZytkdFlrdTQwa2FSaUcw?=
 =?utf-8?B?ZVE5cDFrZjc5L1psVTAyaGFJMGNLTXYwYWlxejR6SlJxckZDUDVpYmJtWk1R?=
 =?utf-8?B?VzdLQzZmOWYvMHdtbkQrZ3AwUFEwL292eTI5Vks2WnBwQUFhYldUZ0poNHpk?=
 =?utf-8?B?bWNpRkd5YlNRZVhUYXptS1FVc0tqODgzV0g3Zm1VNFdERkNPREVmWGFSNW9N?=
 =?utf-8?B?K1djeXdEL1BjVWdwUkhTcURPL1VJa090aHhQNE5jRUJuRk9BNE55Yloxdlpr?=
 =?utf-8?B?NWN2bE53YjlNem9mM2Q3SjNZaTNwK2syblFyMG9ZZ2RXVGdNRDVGbWV3a2lk?=
 =?utf-8?B?c0dldjFubDBTa291WnFmekt3a25zaVNNUWhTNXZNQ0t0RnB0c3ArWVpQVFZ2?=
 =?utf-8?B?Rk1CUnJwdjN3QzV1YjRwR2QwOGMrTDdZVGJ4TUFHc24yV1gwVXdreWlQZ0hu?=
 =?utf-8?B?MENhZmhmWjlkd0o2dmE4TlNlN016MVJqZHN5TmEzbzRENWJDWTZ3d3RaTHE1?=
 =?utf-8?B?WC9mMVFqN2ZaTVJwZmJLK2ZJd09mTUZtS2pVL1l5VDlDVG1TbGFsaldHM3RH?=
 =?utf-8?B?WjBoaTRFblV3MjVvbUd2VkM1dmZOQnJ2VHdSS2sweThzZFpsLzRJdGkrYTNQ?=
 =?utf-8?B?RjNjRkpmUkIvV1dmcE9nZzVFcVF3YjV3MmV0WVlzb3BGU3VHS0V6Y251MW5B?=
 =?utf-8?B?K1RWMzVvYThiQ0RtdmdtdDA5b0RGOHFyazVVSG9kT2ZpdUQvem1MaHdMWmx5?=
 =?utf-8?B?VHpkWXdVYlpiQUhwenBpMzF5d0ZQRytYV2NFVnB3MjVNV0w1czZRT3hwYUd1?=
 =?utf-8?B?L2taTGM2VTVNVUt6OXp1YzlkMHNxZ0orUTNVeFNaWTlOdE5WMm4zS1ZKMXRv?=
 =?utf-8?Q?PLV8dRSwlva2wf1w=3D?=
X-Exchange-RoutingPolicyChecked: qxzO3IP3ylD0XeYt6mvOjGd9TEkj4AovwCuAp8Z6LAFaPO/jHeIq+KvNm5ae5PbE9353XfT+WILZeCHyW0VfBkUoYskjT3QXn0WPKCYBV0KZs23s+7I6v9inPm865+IjncFlxG7eX4YdZV2th4KtqG78wkR6T+hMm73XJOXy7la6gHaEUjhaifPZhPXrPWTlqOJiiBWSAZoRa5F1b7zQsK1pLJYpUpGYlLJYXqe2H6rjF8b9QdBA+385vnWuTCMSQ0einyCpOivjLD0ve+aCAAg5o6JSiFLoXOjIIZcWzLoheXpnmmoGQs22iYmGtINC5u3Ccbpr2XQx2SfF1lqybQ==
X-MS-Exchange-CrossTenant-Network-Message-Id: 7ea2912f-6929-49ae-2f69-08de80711b63
X-MS-Exchange-CrossTenant-AuthSource: PH8PR11MB8107.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Mar 2026 19:54:01.3958
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: eeSgXhJfaYFaU0Lt7Y/R1l5AO1MkFkx7eKvDA9q9ZX/CKjqht/XiLPPsLz59sVROjUqGlOAsakpRaQhA6ADsfaIIrlTL6rrg3Jl2B+XXo9Y=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW3PR11MB4555
X-OriginatorOrg: intel.com

Dan Williams wrote:
[..]
> All of this wants some documentation to tell users that the rule is
> "Hey, after any endpoint decoder has been seen by the CXL core, if you
> remove that endpoint decoder by removing or disabling any of cxl_acpi,
> cxl_mem, or cxl_port the CXL core *will* violently destroy the decode
> configuration". Then think about whether this needs a way to specify
> "skip decoder teardown" to disambiguate "the decoder is disappearing
> logically, but not physically, keep its configuration". That allows
> turning any manual configuration into an auto-configuration and has an
> explicit rule for all regions rather than the current "auto regions are
> special" policy.

Do not worry about this paragraph of feedback. I will start a new patch
set to address this issue. It is the same problem impacting the
accelerator series where driver reload resets the decode configuration
by default. Both accelerator drivers and userspace should be able to
opt-out / opt-in to that behavior.

This will want some indication that the root decoder space is designated
such that it does not get reassigned while the driver is detached.
