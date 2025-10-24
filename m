Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.9])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CD049139D
	for <nvdimm@lists.linux.dev>; Fri, 24 Oct 2025 15:19:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.9
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761319179; cv=fail; b=DsfMZPq/6HCi3mG1nnTiFjoRt8fQzmRQk+g/LLXYs0L3DkaxM5JTpYxT8caqY+0Sthr45w2wfwjSyy58ozlHQjolWYVQMMDqDD2MrgftWD9rWboVW7aSLJvmlSTVkSCNVm7XSb2afUW6RBZBatno3o75cVDLbav5YBFNMbEgaIU=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761319179; c=relaxed/simple;
	bh=kN8w8adC06cRSZr/XeJ2a4P+Ykzvy0tPtD/clieFFeo=;
	h=From:Date:To:CC:Message-ID:In-Reply-To:References:Subject:
	 Content-Type:MIME-Version; b=KAeoJYlrkf0Ih/S47rqV3uWpT99yfCYQqbpIGKIRjOTEX2He7Eutksl4DAUptpvmCsZvqv23s89rQxRgalx5of99wwBmwErsPLnFt5NyXjpk+1ByVgJVcOIQyM9oOB5esoluTHYTDqtO0tnyEPekxf6RMNgFmS51GKOUBinayB8=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=d3gJm9LL; arc=fail smtp.client-ip=198.175.65.9
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="d3gJm9LL"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1761319178; x=1792855178;
  h=from:date:to:cc:message-id:in-reply-to:references:
   subject:content-transfer-encoding:mime-version;
  bh=kN8w8adC06cRSZr/XeJ2a4P+Ykzvy0tPtD/clieFFeo=;
  b=d3gJm9LLzpI02Mg7lj95XaPRxWFNDh9C2W7wwmWqdNXrJplJHbY9/gUE
   /QlSaxj4AgUpLyP3HrBu5xIFaS7lxWJoauo0dkZK1S/oxxxwKXA7BrXL7
   Cw+lb4xJDsS2lnoJlOK2x4XYC+RpuqSLAIv65Zux6sd3tPOtE9Ai+BDMV
   m0mJTreJtfQNIErmYNczG1h7QfDgaguX45mZsp+vtRJ6tnKNiCrETxApX
   MkUg7HHx060+Yod0xIJulhGG1PqOa24VSD0txXNl6BNlZWA4aedhZ97gx
   Iht9jm/DlqIbiqPxZDH1uDv66jknCsSLuFOAwVn85FimfjBXu6rV/woYM
   A==;
X-CSE-ConnectionGUID: wm8uo8MhSPuT64x8TcSZfg==
X-CSE-MsgGUID: q4IvwMFRRPKrpjYvDehg2g==
X-IronPort-AV: E=McAfee;i="6800,10657,11586"; a="86132832"
X-IronPort-AV: E=Sophos;i="6.19,252,1754982000"; 
   d="scan'208";a="86132832"
Received: from orviesa009.jf.intel.com ([10.64.159.149])
  by orvoesa101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Oct 2025 08:19:38 -0700
X-CSE-ConnectionGUID: b3gKXU7tSGmA4c5Q20cNwA==
X-CSE-MsgGUID: mEdYvRpHTbG6h/hoEHb7ww==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.19,252,1754982000"; 
   d="scan'208";a="184061480"
Received: from orsmsx902.amr.corp.intel.com ([10.22.229.24])
  by orviesa009.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Oct 2025 08:19:37 -0700
Received: from ORSMSX903.amr.corp.intel.com (10.22.229.25) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27; Fri, 24 Oct 2025 08:19:37 -0700
Received: from ORSEDG903.ED.cps.intel.com (10.7.248.13) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27 via Frontend Transport; Fri, 24 Oct 2025 08:19:37 -0700
Received: from CY7PR03CU001.outbound.protection.outlook.com (40.93.198.20) by
 edgegateway.intel.com (134.134.137.113) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27; Fri, 24 Oct 2025 08:19:36 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=lxJQTORhWJCeCJ5BCnqrUv+ZJUJQizkEJzA1tRW3WgPp15H6tGjlZ1X8EzYGtQ2Ex0HaIVD28FMxaTfqkCwGcjlc0cOuUn5+rZWJ0r7tBnLF5B0eKsd3rH/S2XM3szew/iep431gUb9x3m1se5treAHurNB42CXb06VIhq7kmrqGAqJzkFI4P14/iHpwfOSzlN6raIyHCov+qOGRXER4gKtRSDCPNcQNribUwvM9pAx2h3u4bJGDetCJDCijz02oZOrQcgAeVBhgMEStwOg6nAkSk0dzL0Pj3Iaf+AfMtMaUsPD2aCZ5THofk+NCIUH6Iqj4HFmXov1P8GB8ci4kFQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=wgOclBkV6xXoj2morOCHg3usxq/a/LdwLo/UB/RXhw8=;
 b=IBGPKhP3oYcTan9S9A/WU10r9YDGo0+aw2LWgQip9POSXNbtEJlFZqfTzO164XxjQ8+RXYUQtvcZ4CFSs/9ttunG8pBHCHOEvAQA2LdMCDe8rjLhZcJ7D8cZki1IFoIzhbq53NEmVvoaaEwff23ozJt/2s61ezn0rEkjiub7b4uWZplEfB6PNfgvgHyoat7Or0dbnFWgJ64aOsX2XlBUCUobWtdcIBrirjA9llZNxOTOUn24chhhlZpV3FbhQSy7RxHn2RSz5kfNtLCrLoMA/9jgHn8DZ7/BuGiDtMDIg1L7DQaQxYCIB3LCGp4PUJIIfHK1x5fnj9HeOLfmcq1+kQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from PH8PR11MB8107.namprd11.prod.outlook.com (2603:10b6:510:256::6)
 by IA3PR11MB9424.namprd11.prod.outlook.com (2603:10b6:208:583::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9253.13; Fri, 24 Oct
 2025 15:19:34 +0000
Received: from PH8PR11MB8107.namprd11.prod.outlook.com
 ([fe80::6b05:74cf:a304:ecd8]) by PH8PR11MB8107.namprd11.prod.outlook.com
 ([fe80::6b05:74cf:a304:ecd8%5]) with mapi id 15.20.9253.011; Fri, 24 Oct 2025
 15:19:33 +0000
From: <dan.j.williams@intel.com>
Date: Fri, 24 Oct 2025 08:19:32 -0700
To: Michal Clapinski <mclapinski@google.com>, Dan Williams
	<dan.j.williams@intel.com>, Vishal Verma <vishal.l.verma@intel.com>, "Dave
 Jiang" <dave.jiang@intel.com>, <nvdimm@lists.linux.dev>,
	<linux-cxl@vger.kernel.org>
CC: Pasha Tatashin <pasha.tatashin@soleen.com>,
	<linux-kernel@vger.kernel.org>, Michal Clapinski <mclapinski@google.com>
Message-ID: <68fb990418251_10e9100fc@dwillia2-mobl4.notmuch>
In-Reply-To: <20251024012124.1775781-1-mclapinski@google.com>
References: <20251024012124.1775781-1-mclapinski@google.com>
Subject: Re: [PATCH v2 1/1] dax: add PROBE_PREFER_ASYNCHRONOUS to all dax
 drivers
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SJ0PR03CA0335.namprd03.prod.outlook.com
 (2603:10b6:a03:39c::10) To PH8PR11MB8107.namprd11.prod.outlook.com
 (2603:10b6:510:256::6)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH8PR11MB8107:EE_|IA3PR11MB9424:EE_
X-MS-Office365-Filtering-Correlation-Id: c4626a15-5d27-4266-a6ba-08de1310bc80
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|1800799024|366016;
X-Microsoft-Antispam-Message-Info: =?utf-8?B?anJ4cXVMYjNNNnFCREhDTlY2MjZ0cEJQMWFUdlJuc0J5eGlPUWZIL2NNMmRs?=
 =?utf-8?B?bnlyYnN6dEdrdGkzSE42Wnp5enZNU1dGVFdaYUVVSzFjTUIrNHFzNEs1VFEv?=
 =?utf-8?B?Ry9haVNGTEFUcUtIZU1NTEZDT2J3S0FldHhiR2ZQU1JhM2drZ3pRZGs5b0lR?=
 =?utf-8?B?cTZ1NVpVeDRsbGpuaHIvcTZjK2VCQSs2UVRNcUdIWm9qR0FyZFp6N2JMVjl3?=
 =?utf-8?B?NkY2NFhkQ1ozb290N3BRY1dWVnBJdTlQR0VwREFNQXJCQjg5azlGb1QyYmFw?=
 =?utf-8?B?K3RleW1SWXpxaFMxSk9JMXYvU1BTWk10S0Zlc0dFT0hMdDROOFVJYkpsc0Zn?=
 =?utf-8?B?aElHTUZVbHNmNXBxVzZ4MVdSN0cxOUFMV0tBNkEyZk9VYTBWTk9QYWMvN1ZD?=
 =?utf-8?B?VDYybDJrb0h1VXJabU45VGl3V0RqZFl1L0pOVUxsR2IzVVZ3dThJeEdkMUxJ?=
 =?utf-8?B?emg0enRsYzRXOGJoZ1cxV2lNa3RYR2RwMXdEdGxNQ0pBdDFnbzNqTjYwRzdy?=
 =?utf-8?B?bFh3c0dzejhkK3d3YVZ2SXVaN1A5SDlvbURvQ0toUkhnVGtBTUk3Ti9Db1VP?=
 =?utf-8?B?WnhEN0RMSGtjcll3VEZKTnZ6Zi9TYW5DYWV3SDc4WHI3SDNIZDB1SWovcmly?=
 =?utf-8?B?YWREYjA1aWd1bHlKdmowalZRMVNvVnFialliSzhFc29hQXpKRUMxc2tGZUxQ?=
 =?utf-8?B?UEo1ejlrWlhYMTZEeFpTQVY3T21vbGh2TVV1MWJSVm1PNGlLVzl5M2ZYdU95?=
 =?utf-8?B?NnRROHJRb0NoeUtxTkRnWHRNWVIvQ3R0blU1Y2N1R3RKdnFwU0VCQTlnTjBp?=
 =?utf-8?B?OVBscWVKUnA4cWpwblJVaHFabzlFY1k5L1NjVHZGdlE4WnpPU21xcGhzRDAv?=
 =?utf-8?B?Rlp4K1k0RFBtbXk5ajlVc2xTR1h5UDNkajVqK1ZBNzRwVzllbitnaVlXQyt6?=
 =?utf-8?B?ZzFQZ0t2dWc5QXNkWTRYbjRnOXF5VmZ2NTJjc0dYR3I4KzJVRHVzbWZDZ2Ry?=
 =?utf-8?B?bWtseTkzTThHdGRGekNLYU0vSXF4TEtER1k3ckM0cGdDdUJlcUp4eEw2bXRG?=
 =?utf-8?B?dnNQdVdvMlNYKzNYV1ZzSXkwUUZyc3FkUk16N2M0WFMrVDhqWGxkV29Tc25O?=
 =?utf-8?B?bmFlL2k1bDNyaWp2VnhYdHZiVzN0U2VJZkxyb0x5Y0xCQmxCeURDY0M2QTdr?=
 =?utf-8?B?cmFqeDNobURhcTV4cWVBclpwempIeTUvRkQ4ZVpYM1N3NUJKQnJVc1dRYlpF?=
 =?utf-8?B?VXZoRVJtRVkvYURjY3VDUHVyT2pqZXFWeWZNQ2djRjZna216a0loU3Z4OHUy?=
 =?utf-8?B?UHViaGdJSWh6YUlFWnZocUNTd3VCNHAxcFJxdXlUbER6WnBSd01YRTZrcmZO?=
 =?utf-8?B?K2x6TExnWk1wUlRubjdxamtTTDBEaW41dElINjB6MGFoMVRRWkpHNlRDNzFG?=
 =?utf-8?B?enNmZGN0SGpyQVR1REw0akM1a3N2Mmh6ZTY5aVAvWnlRNzViRVB4QjExM0JU?=
 =?utf-8?B?cy9IaXZDMVk2c0FTZ3BtajJzZGRMd3pyZlViaGovem9ZR2tlZXU1UHhxTHRT?=
 =?utf-8?B?bVI5dHU1RzBJSTZVMU56cld5UDFCZVRhT0l5UWxMVTdIOFRVTmhaWWpoY3Ex?=
 =?utf-8?B?cjgzTXZBRUlDRnFjMVc3UmFZNElSZGV0MTdmNkJqVHNSMVBOQ0xJMXh0QkZZ?=
 =?utf-8?B?cFBCV0p1Z3djd1cvUG1vQzIrcTJZNWp0UGhpUXc0Q1paRVQ0RVovK2wwRU1M?=
 =?utf-8?B?alFLT3cwSTFMZWE3ODBOcGt3NGtiN2p3cUMvdDJZeGNDaUMwSnM2UzVibDVx?=
 =?utf-8?B?K3h1N2I2Ukl0ZWU4eWhXNUZWOTFyS1ZvdjVrbE5CdnhQOHFENVFEaS9ld2RM?=
 =?utf-8?B?NVlRc0RieW9HVVZJUFZNcFY3eFNTdTdqYjRwKzBrSE1WNGVFMzNnUmNGNXIr?=
 =?utf-8?Q?+ANUZNpVgBkDWaXcAn08NIWlrCf02u8W?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH8PR11MB8107.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(1800799024)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?WnZXdURidnBYa0wxNlp5cEVqSXk3VFJOUVNYejhSejQyaUJyTXpQU3gyQ2Ja?=
 =?utf-8?B?RUE3T3N6bGJCUlpibDZiSmREWXpRNTdtQnhSVDF2THB6cDJWOFV2VGtsUjJB?=
 =?utf-8?B?U1FJUUxKQzE4NTJLcHk2Ym02a2V0aE1HVHhQVWl4bEFuMktCcE5oOHRVMjUr?=
 =?utf-8?B?Uzh1ZHVsNWJOWjh0cDNOTExnbmpJV21CckZuR1BmcWNCTEwyMGR1VmlYd3oz?=
 =?utf-8?B?VldPbkxoUW5HQWZEYUNWVmh3MHBCTGszY0JGR2pyaHIxdk91a1NxVXBkWlF3?=
 =?utf-8?B?MWJuZ1Q3eTNBNUdHYktkUnFEczU2Y3Izek1maTFMMkVzdFU4SUh3Vmh0bXZY?=
 =?utf-8?B?M0UzNFA3OEsxak1OSW9JK1BrSjBrdEMwWXZybEpPUzJuWm9KRlZKNGlneS9l?=
 =?utf-8?B?T0xRaHFuNEt4ZWdCTEZTZ3hmUkxMeHpRaldPUnZ1aXEySXdPNTZBRkNSR2lt?=
 =?utf-8?B?M0d6UG1pQk1QRFJPSFg4UVRCRStEZ1NoYytzS1ZtSGo1ZFlYZldRMHpoMHVm?=
 =?utf-8?B?cjhrQklxWjVZblh2MmV6WmlpR0ZJTVREeUFoWThZcXNWYmQ4VUxzUlBYRVBJ?=
 =?utf-8?B?Y2F5ZGl5d3N0bTBycDV0TExxOVBEV0trdzZQYWdyUXhtdXNHMVpzYTZXZWtl?=
 =?utf-8?B?MHRpRXhIYnZxWDRXTUhKM2tCUVJ3dWZDdE5ycHNhb2I2NytHekhWVVd3SUVu?=
 =?utf-8?B?MmxuTkdBaDU3VkUxRlJTcStxWE4wMDM4RUdOTzdpSWp5c05BOVp5T1BxT25N?=
 =?utf-8?B?SGRyZTN2WHJraWVpSXp5VndHTW5rMGFMVXRWZVBDVUd1TkpleDZKV0NEaHph?=
 =?utf-8?B?czJsL1Q3TXZvRmdWNVpsNnNmbENpUy9kakg0RExmQmgzVzhKbW1IZUg2ZEpM?=
 =?utf-8?B?MFJQYk1nZ1Rnd3VmYUp2bzdUUGxXR3luZmdwM0NyQmh0QVFEQ1E5aVhVUjBw?=
 =?utf-8?B?eHNpQktJS3NnY2h4QUU5TjRNWTVYdWZVa0ovYUdsREdRdnlyakJZSm5uU1ZC?=
 =?utf-8?B?RHZTNmg1eUJsZmYzczk5ZGhHWHZyVUtSZ3VQTmR2MDl5QWtBRmF4N2Q4NnhH?=
 =?utf-8?B?dGFITXhqUmxwVTcvMWZrUXJFRnBzTnpTVkdqM0dRMTBUV1BaWGN1ZDkrcnln?=
 =?utf-8?B?Z1pMcG1sOUcybnZaOUp5Si93N1hYbWVjNDZQMHNxa0E3NEVDRnlJSUFiY1NG?=
 =?utf-8?B?NVVTM1Z0czd6Y3l3ZGRjNmIwbE1XWnArc2dxT2Q1TC8rN29yMHFaWDAwcWJt?=
 =?utf-8?B?US8wNG9id2tEQlRnaVZnZWRiNEhnZDNBUHU5d1hNaHRON0MyYzlVTitKRURu?=
 =?utf-8?B?bmhSdXhYWjdxY29NYjFaQzNoUWVwMEtQZHpBTlZRenV1VUkyR2ZOcHRHL1hC?=
 =?utf-8?B?SnJkQWl6UkpGV21DT1JuNTJFNDcwOHBnc0VXMW94alNta0IxUXZpN3Fjellq?=
 =?utf-8?B?VitkbUtWTVFzSXdNVlVBSnp1VGZwd1hUb2xmUUY5S1NYcXR0dGpUUmd4NHBZ?=
 =?utf-8?B?MWtkaG9rQnViaE9TVnBCcHFibGkrNHR3ak45M215U0doMjJzQjhMZ2NYY1Br?=
 =?utf-8?B?MDVLNzhnTHFoVmhNVGhjSzVhR2pRZkp4eUpqTGFWeWJwZVB2dlFxUDBLQmJR?=
 =?utf-8?B?NEpPVUZEWmJWVWRTNjF5Y2o3b080NFI0RVlVNFFXQTY2cWc2bGFWcUJacGtp?=
 =?utf-8?B?OUM2MEpvcFRWcUk5VDlQTWVIZm1EUitWKzl2WE9kK2lsb1QzOWhvSlRaVU5t?=
 =?utf-8?B?Q0IxSGtEZnJXK080L0NsT1QxWnY2QUFrUTdBRW9zRVRRdFBJTWVDa1Znd0Js?=
 =?utf-8?B?a3RHNmx2YUUxaysrOVJ6YWJHS2NwazhabGZuUElkZnVDN25OSXJRRFFIemxE?=
 =?utf-8?B?aHI2MEhDWHBUbTY0MDQvd29rYnhsaXN2Y2E2Q3BYa2RCVU1aNEo0TDZOa2p3?=
 =?utf-8?B?dVJtbWNlQ3dBM3dLTWQzRXB4MGNva0R6akxMeElmTzhBMWRGTTFIc2JFOVJT?=
 =?utf-8?B?dHp2cTgrSWtMOFBIRWttZ0lUdmZzcjhKQ2tVbkNqWWIzL3cvalVOZEh0OHZ0?=
 =?utf-8?B?bTVKZ1cydGI4QUVvRWJNQ2hIbGdzcUJqdlplM1Y5cVdZcjRuRndqbVkyWW1q?=
 =?utf-8?B?UkpIRlZwZmlBMXFya3YvREFtVEU3QlBVZG9TWVhSUC9PUUg4ZnZQS2Z1SzVl?=
 =?utf-8?B?b3c9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: c4626a15-5d27-4266-a6ba-08de1310bc80
X-MS-Exchange-CrossTenant-AuthSource: PH8PR11MB8107.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Oct 2025 15:19:33.8870
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: dOF3vHRj/pSpHiJDTB5cDHyl//BOvQDjlekbHPxN/yy4OHxHelN6HE3iRTqxDBE9IcEMVK9HL9HkDlRoB0/M1NmWNelaWC5kl2G7rfrYrtM=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA3PR11MB9424
X-OriginatorOrg: intel.com

Michal Clapinski wrote:
> Comments in linux/device/driver.h say that the goal is to do async
> probing on all devices. The current behavior unnecessarily slows down
> the boot by synchronously probing dax devices, so let's change that.
> 
> For thousands of devices, this change saves >1s of boot time.

Please split this into 5 patches just so each can cause independent /
bisectable regressions, but other than that you can add:

Reviewed-by: Dan Williams <dan.j.williams@intel.com>
