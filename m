Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CA242267F58
	for <nvdimm@lists.linux.dev>; Tue, 30 Sep 2025 19:34:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.16
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759260867; cv=fail; b=s+Av4zD0RTHZAU5pD7LY/nw+zXcz84y6U3LhuY3M5pSouYOoOPVA+OCA7bx31lAfasPAF8MKmUeenzcBD5nxX7VOm99j2gt0mqi8T3Kb1nEZGh4Os7NgM2mP+BJGN/dUnvmYvLGrNGQN6CfQ4TWgy56nu9fgV88qVQMMX2gZbR8=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759260867; c=relaxed/simple;
	bh=c3SNSEzzM5GJB6nb05kBPC9aumVDTw3ZIBfSsU+yYBU=;
	h=From:Date:To:CC:Message-ID:In-Reply-To:References:Subject:
	 Content-Type:MIME-Version; b=gb37zfoIZGlhy3H6RKc2qw5T0Uu0JYpeyfVkjIKJceI/XBMMyD5/z6LlrjIQoscq1VeSUOKCRdgyLHbP4B3BjSIVbeWgwU6jzuSuj9ms37T27PZHq5MZZhv7BZuFK89JbqyoK2f5KrxQe7femYBdM8IortM1GQ4UHRA+Kk+K4Ts=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=XAzwpUpy; arc=fail smtp.client-ip=192.198.163.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="XAzwpUpy"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1759260866; x=1790796866;
  h=from:date:to:cc:message-id:in-reply-to:references:
   subject:content-transfer-encoding:mime-version;
  bh=c3SNSEzzM5GJB6nb05kBPC9aumVDTw3ZIBfSsU+yYBU=;
  b=XAzwpUpyrbeQB7MTDD+zvoMxOM9u8NsdRTZkNq8qw+1ZNimMfdnJVLRp
   Q27TQr1oyfSlHvuKRs/WA9oe8LBwiDRiaEC40/0zcnwSfqr6rLzomDb5e
   FVh5fgoPobGviTrIFwciQG63ONkdBTNlEE+/mCpEDBfnNFFZeHyjotNEu
   cELDVmhdnGI2YK1mtqX08O3bidFxBgRf+vY42XDu8SpuGfVfBo2HXPvxb
   33uNyZeZ/5ljaGkWgUzMbDlsncnauYYWYSxmz9hinfGSrsqx6Oijy7Tvs
   cCpMRdp/pHypneMSUCOB7HYJMcOg4702M2H5wo2tzKeF8QL5f7GDratZB
   A==;
X-CSE-ConnectionGUID: GpnrlHQnRIGdk5AJ/GMcxg==
X-CSE-MsgGUID: 15mAIhgkR5qvddDSM3KpgA==
X-IronPort-AV: E=McAfee;i="6800,10657,11569"; a="49087377"
X-IronPort-AV: E=Sophos;i="6.18,304,1751266800"; 
   d="scan'208";a="49087377"
Received: from fmviesa002.fm.intel.com ([10.60.135.142])
  by fmvoesa110.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Sep 2025 12:34:25 -0700
X-CSE-ConnectionGUID: QhcE8DaZTf2uJwc95Hv/Xw==
X-CSE-MsgGUID: 1z1WOsskQCOfMZBFrB0Lfg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.18,304,1751266800"; 
   d="scan'208";a="202292789"
Received: from fmsmsx901.amr.corp.intel.com ([10.18.126.90])
  by fmviesa002.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Sep 2025 12:34:25 -0700
Received: from FMSMSX901.amr.corp.intel.com (10.18.126.90) by
 fmsmsx901.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27; Tue, 30 Sep 2025 12:34:24 -0700
Received: from fmsedg901.ED.cps.intel.com (10.1.192.143) by
 FMSMSX901.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27 via Frontend Transport; Tue, 30 Sep 2025 12:34:24 -0700
Received: from BYAPR05CU005.outbound.protection.outlook.com (52.101.85.55) by
 edgegateway.intel.com (192.55.55.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27; Tue, 30 Sep 2025 12:34:24 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=wEh77q7ryLp4i/MAOvO0F80vuOD1xCAD5+vhqcA9qvwxiPWr/6v4HvGfuUGPZj3yPdBe5A6FyVCqdgPp7mZpBHgJR1/OMjAkOYCKLryYaad4PsvhQCy8cGrIROO/uIJFLb+Rq9Mt9rDjuEIGFF0JTosYAS7CEgPMONHDO1Kgbp9UrqgP2kBa+iwm+trHAGhWxXhEqN7zRU8jLV80gjY2yNYoMVxc4T0QPwvq8bESAQ3YJ5zSnkmgCbnZHqTPF5uyHYEYebN6b5Uoago+MxXSYOB+3p6pjDWS1c0RaY/LnscXe4Su62cYledOEgFex5NwbPyzNzYfR4O8C0qtRRlzLg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=MzLjHvqaXv8llGDqX0zbzhzFUZ/Jle7tD0PNVW8Umns=;
 b=dE69h3V8TrVnFdwv6fcoFF5hcWAyDPDU1CUUvQjltFNTyWBunrsXWhBp5oCoQin0ZpWBzE7VotXxG00WHyPUorXdeM4ZSHB2JfcSYdlpaWNuLR+/PZj8lvxTOumXHWR4pReAZWB/2XVvedhfTFj3UH3w6vgfBNQxMjpwZZ8bUQytTvJXp9qtof8QAPaMIPrq2XFO3SGIy4/2Ompz1ogPI6VfNFenguwM/bEShrUR7kNUbq9If6jsoC8xiqeDfEwCvlHWy9xncc/TKkMg8TICfE/duxuzUVPYsp2Apna9sHu1arGu6meYO9UNiiN08xxeYCs9Ge9GBNKrJL4wtziK9Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from PH8PR11MB8107.namprd11.prod.outlook.com (2603:10b6:510:256::6)
 by CH3PR11MB8752.namprd11.prod.outlook.com (2603:10b6:610:1c2::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9160.17; Tue, 30 Sep
 2025 19:34:22 +0000
Received: from PH8PR11MB8107.namprd11.prod.outlook.com
 ([fe80::6b05:74cf:a304:ecd8]) by PH8PR11MB8107.namprd11.prod.outlook.com
 ([fe80::6b05:74cf:a304:ecd8%2]) with mapi id 15.20.9160.008; Tue, 30 Sep 2025
 19:34:22 +0000
From: <dan.j.williams@intel.com>
Date: Tue, 30 Sep 2025 12:34:18 -0700
To: Alison Schofield <alison.schofield@intel.com>, Ira Weiny
	<ira.weiny@intel.com>
CC: Jiapeng Chong <jiapeng.chong@linux.alibaba.com>,
	<dan.j.williams@intel.com>, <vishal.l.verma@intel.com>,
	<dave.jiang@intel.com>, <nvdimm@lists.linux.dev>,
	<linux-kernel@vger.kernel.org>, Abaci Robot <abaci@linux.alibaba.com>
Message-ID: <68dc30bacdee2_1fa2100c4@dwillia2-mobl4.notmuch>
In-Reply-To: <aNrAnhYMyvZ-farN@aschofie-mobl2.lan>
References: <20250928013110.1452090-1-jiapeng.chong@linux.alibaba.com>
 <aNngNaDpVJAyYKYx@aschofie-mobl2.lan>
 <68daa03bbd9a5_270161294bd@iweiny-mobl.notmuch>
 <aNrAnhYMyvZ-farN@aschofie-mobl2.lan>
Subject: Re: [PATCH -next] nvdimm: Remove duplicate linux/slab.h header
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SJ0PR13CA0214.namprd13.prod.outlook.com
 (2603:10b6:a03:2c1::9) To PH8PR11MB8107.namprd11.prod.outlook.com
 (2603:10b6:510:256::6)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH8PR11MB8107:EE_|CH3PR11MB8752:EE_
X-MS-Office365-Filtering-Correlation-Id: 8d5724a8-a023-4753-4fd8-08de00585b16
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|366016|376014;
X-Microsoft-Antispam-Message-Info: =?utf-8?B?Qm9aOTl1anFlanVJUGtCajNBWUlXN3FmRG92OElWa0xsOCtzOGZlRDhZcjl4?=
 =?utf-8?B?bFhzWUhLQ0JobzNicXVZVzFsY2g0VDhPY1J3L3ZmSG45cGluZW9iTGFZZ3Fq?=
 =?utf-8?B?aExvTEtteS9BTjNGVXk4U1hLRitreGZUQnpZUHRjQmUwZGxOblVFWjJSK2xK?=
 =?utf-8?B?QVNNZ2tCelE5ZENTNmpzNHk4VE05d0IrbzlpWGJyVjA2bDFCWTlreGhvZ216?=
 =?utf-8?B?N1JuVGEzb2NjclhQR2tSRWUxdmluc0dEb216RzFOWTNEUENERzY0Wm9ES21l?=
 =?utf-8?B?SXJIeVZHbDNuVUw4YlNBRzBFSVBaMUdCdWdTNjNDclZUTVdhazNocXI1bHhF?=
 =?utf-8?B?YUMvQWxtVjViZkdHejljbTBQaEhGc1piWXZIS01yYzhiUHdJNDgreWllK0hn?=
 =?utf-8?B?OERIbm5MUm5yZWV5UzA5TWc1eFlQL09Td0FEdTNNVnhIVDgxU0xhajBQbmU2?=
 =?utf-8?B?eWdSOTZSRGo0elNjU2c0dXYvbXozRm1GaytxMWhqV3NVTDk5T3pUdHJOMjdP?=
 =?utf-8?B?SnpGbzNOZDNES2tCZi9TS3ZWM29kZDlEeExOaTVsanVpZW43aWZDZnpGNS9R?=
 =?utf-8?B?OWZ6T21xZGJTT3F3bnpQSFN3aG1qb2dlSndaK25WSkV4aXVWMER6QXE3Nnlj?=
 =?utf-8?B?QXRBOVFzbmF1dkpyK2hESEFpQjM2MzdHdFJsK3ZJRFZvZG56dXNoRVkvdm50?=
 =?utf-8?B?L052RDJJYXBQdEhJVHVNaGM3bzRwMStqZ2xzOXZQZWlDNEJUVlFTQnpjQUNi?=
 =?utf-8?B?cnRXSHg1cDJKZXVGdllobkN6UVhZZXFBMFg5MEU0ZkhpSDVXL0lNTlY4QkRo?=
 =?utf-8?B?MFlXYllERkxqeHBLckdBTTJseWNnY095bC91NEJFTDBkZUU3QVFvWnF6TkVZ?=
 =?utf-8?B?bXVxaytsUzNZWUtDOGRJUFkrZFhZUy94NEtRR2VRZ1kvUzlzYmNjKzRwenB1?=
 =?utf-8?B?M01OWElWaFltWlJFdi9jTnlQT2tJaEVaeEtFNm5BZ0pYTE5xY3p5QW5icE8v?=
 =?utf-8?B?TjFCYmpDeW0xTnphVm5Pb2VCMlR5a0dCRnRnN2VqVDc0RTFQWDNieHBDQ1J5?=
 =?utf-8?B?WWw4UWZ5TW9tL0c2YjRuZFAzUGJIMHIzTnIwRzZkSlB1R1djekFTWlNyaktr?=
 =?utf-8?B?bytBTFczS3VOZWpTVU1CZDZxVHNmODBaT0g2SWdNOUMvYnhnWjJ0VFhpb0Yv?=
 =?utf-8?B?Nk1EQ1JxL2lHYlZrcmJuREg0M3FETnF2SUVLY2trMHBlVkZOSXFVUU9Sd3Np?=
 =?utf-8?B?QTVubFRDK0lTWmlPWnFaZnZuZUJ5WUE1aXhibVI1VUIzTWdreHc0Sk1TVUoz?=
 =?utf-8?B?WWdveXdiOVNmWGgzelRXKzBxbVpqK1YxY2lJTTYwYVdnSkNwR1Q3ZG91TXdy?=
 =?utf-8?B?TUFBMFpYWkRCU21IUFVYcW5uZWIrS0g2MHIyUGYxZzQ4ZnYrd0FhNnBKMTdt?=
 =?utf-8?B?S0QwNEhiREQwSVZQZUpvK2EzUXVybklaK0hkZVc4N1BHaWpuN3JsWlMvQ1N1?=
 =?utf-8?B?cXBDemQ0THVyRTl6QXVHb21adkNFYjFTSkxKZ1pFTENGalRHSzNIVnRDT3lh?=
 =?utf-8?B?alJRZ0tnc1BTSWRwTjBhRWpLTTlXdnllUUdFeG8vWnpnZFNtQkNEMFNZbVZF?=
 =?utf-8?B?YlJjbzNZc0ZSVytYNEhlQWJVRFptbUhCS3pzdEY0OWJhNnF4N2Uzc0kzUTlY?=
 =?utf-8?B?WWpFN2hVYWtUZkQxbktaNW5ScGZpMm1TZkp4Z2wzdWliZmhobXpSeVJqQk44?=
 =?utf-8?B?YWk5Ky9UK09oWGpCS0YxV1M2MUl1UVU0MWkwdVB3RDNFenMvczhUTDByckJi?=
 =?utf-8?B?c3I2M01jaEFmZG1tdi9iQm9ZOFhMOThGZFV6cXl1b2I3UDAvUlNlaTBqOVNz?=
 =?utf-8?B?VVFUT2c4YXVsMTN2alBNYWNncjIwL0NRRWVKNWkxZExKVngvQWVLZW96MnAw?=
 =?utf-8?Q?EGC+ORQN49E=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH8PR11MB8107.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?RXNsSEFsaW55aW1GMmp2dEgxK3BZc3BtTGlZQmJHbzUxVTV1Mm9ua3B1ZHhk?=
 =?utf-8?B?cmlVSW1wVWt6M3p3b3NxN2xTM3hNblJhM0h4L0U3MjhWeVY2bTFweDRmUWVu?=
 =?utf-8?B?NDIremFHdkNURW4ySDl2bFVjM240dzB5VWM3cU1kK08wSisrYkpraUV1REp0?=
 =?utf-8?B?UitzdmNqSDh1Y2VURDJSUjloSXltL0hQcDd3cThWQlR1Z29HMmtLRFZINWFt?=
 =?utf-8?B?ZHhkUm1WdEgrcDQ3RUNWTzh1VUViM3oyWnZhTVJNbG9YcXliOU91bXBERzlw?=
 =?utf-8?B?aUVINTNTeE1ZTklaTVJEZ29tcEtHYWdkQ3d0R01XSmx3ZGdVTkRiRjlKYXF2?=
 =?utf-8?B?d3lkWkF3cDNjMTdjaHBRTWxFcUVEWUxHbGU5SHdtMVpoSFI3VnhsdmVFNzNj?=
 =?utf-8?B?Uzg3M1BIK3J2dGNxc3duRUpmNFRIYkFxbzBFNm1RenE0MnZORjVnVE53TGhh?=
 =?utf-8?B?L1pnZHp6aXhhQzJEcWxXMDhrY3BtUmg4c0ViTHJMUGVIVkI1UUYrVURxMFJt?=
 =?utf-8?B?R00yM3JQL1cvdnlaK2pWQW9YeTFMQWl0RGNFTU41dVkydFBZOHJ4ZisxaXQ5?=
 =?utf-8?B?QlhzYnM5bzRmeFpFNUZINUhMUS8yMmR2d3Bxa0hWKzFPWE1ldno5MmNKVysr?=
 =?utf-8?B?a3FkaWhJSmdOSGFVUGh1bDRiL21lTWZsSEY1RVg4MkpKNHNFQmtMSEpjemJ3?=
 =?utf-8?B?RWZDWGp2Q29EY1lBSXBva1BKYUVIQmhySTFUbWNtL2xtSzB6eDZoZm5QaFFn?=
 =?utf-8?B?M1hVN3FSUHVwbmh6eTVuYnA3TENPQVlINUwyVkUrdHdEYmY4aW92UDFva1Z1?=
 =?utf-8?B?a2ZyK0QzcGZVbXo4SnlZZEc2WlQwZlpnREh2dFlPMkthdDVNRXFjWXI1VUxU?=
 =?utf-8?B?TlhtZENwbVlwL1doWjk4VDNCR0dBdjNwL1VaR0JpL3dHU09wYUxCYVpUb2l6?=
 =?utf-8?B?UUEzbE9kZFZCK1Y1d1psL0hGK2x3alZyNGlqWUk4YWV0SldsMWgzYTlXQjha?=
 =?utf-8?B?M2piejFSd1JEVFUvaC9COHVNWm9zK3pFSTI4OUJTa0o5VlkybTYrTlpBSTlK?=
 =?utf-8?B?SHhQeE9jZkNjQ0RuZzlmS2sxaFFheW1STk9KNDA2RXV4OXZMR016TGdkcyti?=
 =?utf-8?B?L3V4V2tRUVcrWWxZZXBFVnloZVMzajBQL09hY3JxR2xwTXRLZjlaRWcrTjNx?=
 =?utf-8?B?SDFRZ0t6WVJVVGNrQTZ5bzlKYlRrcTBhWXF2SmZmR2RWM0E3Q2luWVo2TW5P?=
 =?utf-8?B?QVNmOFJaVjVDSWp6MjdkYWRMSEdRTDJxT2c4bUJTRTBQT1M1M1RxbGhiM2J6?=
 =?utf-8?B?VWd3ck5talhlaWtncWNuZmhMTDVIZWRyd3YzKzNYK0V2L0dPcS9tdjJZUGRi?=
 =?utf-8?B?Rlp3eWZadWRUSUtRUEdMNFIvanFMSy9HeUJ2Z1pSdEhUUmRmVGlpV1ZWK3hy?=
 =?utf-8?B?Z3dWREN0UUdlVU4yQ21PYk1Ic29qWHJOOEdPTmxSc0Z0ZFZVbDJ1ZlJLQUJL?=
 =?utf-8?B?S3g4TnM3aXo3bjJCMWdPRkVCZGFQNEY4ZkhvSmdxOW9iV29KMHpOdWl3WlVi?=
 =?utf-8?B?ZmNkeCtKL2o0dHZBbDE2MWJCRlZ6MURORXJxNHZyUWZQNlh0am9Tdll6c1dT?=
 =?utf-8?B?c1p2ZCtybDJLTjZhblhxa0JlRTRtQU12WXJnSHVFb3hqdFRudzkzU1JvTkZ5?=
 =?utf-8?B?ZmxZb1g1Y0l5aG1LTUVYT1IvYWcvcDcwZHJlZkpzM0QxbVZ0eWc1VU1IUSs0?=
 =?utf-8?B?ckhDWEFZd1FhT01xeUpjTkNLUURqamxsYnNYQ05MOVJvaG1mVFNXRmRRSGU1?=
 =?utf-8?B?cEg3ZFlzcG1mQitjalFaYXJmME1ZcEF2RHZoamdvUFVzSVk1MUE4Vm82NStM?=
 =?utf-8?B?ZmVmUzFLNS9aUUdPc0c3L1FZUEpFUXZCc0pNaG5iMFdkUkxmcjF3WkMya0ZE?=
 =?utf-8?B?dkU0a3o4aVBONzE2MWFxdjdCZDA5NjR2MUtlem5oYlVIUjVBVDlnRlNXb0pX?=
 =?utf-8?B?UVNVWER1UHhBbnlFV1c1NXAzUWhDQ0VVZFRkVHZucURKZmNMM2tZZGRVU0ti?=
 =?utf-8?B?WXRoUmtzS25vbjdWMTFMbGp1eGxjZk1wcXp0Q0pQRFE3QjhULzRwaEF1aDRD?=
 =?utf-8?B?RWpEakJsOVJrT29JeU1ySkFjTWp1Ym52dDBrQ05LaWRlTjhXK2NqUDBsbzdo?=
 =?utf-8?B?NEE9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 8d5724a8-a023-4753-4fd8-08de00585b16
X-MS-Exchange-CrossTenant-AuthSource: PH8PR11MB8107.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Sep 2025 19:34:22.1254
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 0WFZwJbX9RDdfGxlBTYUFVXBJFhVpcfWA75W2C2zx4I+m+EmrPyLBqj1NqZXP8nzHZCzpz6+PgD8SOzKGY2T6sGX6n/DsOXOoWs76jYwMtw=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH3PR11MB8752
X-OriginatorOrg: intel.com

Alison Schofield wrote:
> On Mon, Sep 29, 2025 at 10:05:31AM -0500, Ira Weiny wrote:
> > Alison Schofield wrote:
> > > On Sun, Sep 28, 2025 at 09:31:10AM +0800, Jiapeng Chong wrote:
> > > > ./drivers/nvdimm/bus.c: linux/slab.h is included more than once.
> > > 
> > > Hi Jiapeng,
> > > 
> > > It would have been useful here to note where else slab.h was included,
> > > since it wasn't simply a duplicate #include in bus.c.
> > 
> > Actually Alison this is a bug against linux-next where it was an issue
> > with Dave's patch here:
> > 
> > https://lore.kernel.org/all/20250923174013.3319780-3-dave.jiang@intel.com/
> 
> Ah, I see this removes the dup that the above patch added.
> 
> Why not remove fs.h instead of slab.h and get a clean up and de-dup
> in one shot?

fs.h is included for 'struct file_operations', so no clean up
opportunity there. Recall the "include what you use" recommendation:

https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/tree/Documentation/process/submit-checklist.rst?id=v6.17-rc7#n17
