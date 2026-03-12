Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.17])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 926072C178D
	for <nvdimm@lists.linux.dev>; Thu, 12 Mar 2026 00:27:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.17
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773275270; cv=fail; b=o2S5fvsrXnPeAmriUQ3d47CkZ0TbU5bT2YeckeBKWMt5Vh5pqNChKemJygdYA1oJ17XiZ5SMBx4+yUiCBpdNKCylXN5RT26oXGFDsMcxgbSxsESwQEm1+mN3EaabbZf16V5VjbeMMixhg5vmbUQ0ciRMXFoawu5RfaHPY/CkYWg=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773275270; c=relaxed/simple;
	bh=9m91W+KaQlb57eMibsncTJ9BStnl3G9VOI4A45KFpOI=;
	h=From:Date:To:CC:Message-ID:In-Reply-To:References:Subject:
	 Content-Type:MIME-Version; b=SL28Zp+WKD24061GdCDCh2xPz7bCchpP7mK0ui0w3XKF6vWLmTFeN7dgjqzY17te0WXOr/5bWRRZJi+v6F2KZIdtMckToVHdR3fq2bKhJpx4nD6kyKXNhN/myR9n1DVSR7rFGuXglo5KKVjJN4JehoHyPd56oUn/D030ypBoLak=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=iMmT2tlc; arc=fail smtp.client-ip=198.175.65.17
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="iMmT2tlc"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1773275267; x=1804811267;
  h=from:date:to:cc:message-id:in-reply-to:references:
   subject:content-transfer-encoding:mime-version;
  bh=9m91W+KaQlb57eMibsncTJ9BStnl3G9VOI4A45KFpOI=;
  b=iMmT2tlcohUFFWa19ETzhMbPheHdovcEdLGjCyCcvKCHSTnkICzZl9rr
   cqknyAdslS4BD/tDMX/jFQb7epzz98M7Lxkv+quce630IMLcTGZ2jxytO
   rmW2y+cPX8Zv+n9raw4JEFJMIwQUZCMuTshyAIhOn+5R1BjUX1dYEZf2x
   58F6ieLjc+whE8r0iLgq2Q+66ZZn7YVAQYiHAhyb8a7YpuGRQYJAh1aKH
   SZg9TsiQxaG3SOWBnVXgoWVuFnZgtNirUIyRnaVHUsSvtYhB1L+7v62S8
   X1uK/gVlRyxJ7o0ZZqRUqAFbXcocuX0CM5HPBjx/f/xM98I3R/haQJIKG
   g==;
X-CSE-ConnectionGUID: FbqXA0OjQ5KhZtwHHKdj7Q==
X-CSE-MsgGUID: Q3153dEST7aoRzvnW9/e9Q==
X-IronPort-AV: E=McAfee;i="6800,10657,11726"; a="74326460"
X-IronPort-AV: E=Sophos;i="6.23,115,1770624000"; 
   d="scan'208";a="74326460"
Received: from orviesa008.jf.intel.com ([10.64.159.148])
  by orvoesa109.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Mar 2026 17:27:47 -0700
X-CSE-ConnectionGUID: WAwdmqmMStS8375kXf+FfA==
X-CSE-MsgGUID: EsVMz5rtT1CqCg2Qj/DujA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.23,115,1770624000"; 
   d="scan'208";a="220696374"
Received: from fmsmsx902.amr.corp.intel.com ([10.18.126.91])
  by orviesa008.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Mar 2026 17:27:47 -0700
Received: from FMSMSX903.amr.corp.intel.com (10.18.126.92) by
 fmsmsx902.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37; Wed, 11 Mar 2026 17:27:45 -0700
Received: from fmsedg903.ED.cps.intel.com (10.1.192.145) by
 FMSMSX903.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37 via Frontend Transport; Wed, 11 Mar 2026 17:27:45 -0700
Received: from PH7PR06CU001.outbound.protection.outlook.com (52.101.201.69) by
 edgegateway.intel.com (192.55.55.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37; Wed, 11 Mar 2026 17:27:45 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=cg7VV6/yItrDzUX+PPkIxQ/qNxZ0skMCXLc8t2eeKaxjTYAufg+8JHhNiADo4o1juUROwCW9hf0BVEi1+Po2hqOKWayTCAXmFM6vR4AtnOyVbIVZnVB4SgxZtWOKJqBgRjS1limSgJ9eqBeCtb78C65pd9bd7Kt7UYxCacNJ+bMjWeKF52KnWCMCY1jSr2wzejMR6z8//eYeYgp4/5CUjXaGh63vjeaeLV8jq0Th0KRcNXkLAz3vHTtJ4gApxf6uIpFSl192nKDmY6RsDi9eqy4b3k2Wccx7Irbfmio8Pc3asN06D4/j9p9XRUr6QUV7lQgBI1dPNGOKGtgROnVA7Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=savOKAwPHgXbszXHcs66etPF5YQo3Ge1rpzzLwWzhz8=;
 b=E6v9b3tO+xUXNFsZhwNHzrbsr5kOvI/gr2fwU7+rijZ5qU6RVPAisfNQkjeMt/7M3L3jfh53/Pi+7M7Qvj7zJmeissil7ZBWrS6L3UWeJ0UsXFL/CqXh0P766zjNAgFRfVVoQt/13ecQ/1uxHSTkaduZd99ooFAUqAOX0FP9hKXmk8ONpVzpMPqiqnINS7BuhunsIkqC4ICOGmaQ57QO0BXp/sLASUrZtti7tr/qyASSL+fBtmG3JcnDl6yrdRrJzUYCWCnZsY4xvKXP/XO2Q1pGYiKA1yPYWG7KLbJc86xi/3lov7/8+4evg0mGARWWrfoVF60sRr6SWaWUPLihKA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from PH8PR11MB8107.namprd11.prod.outlook.com (2603:10b6:510:256::6)
 by DS7PR11MB6175.namprd11.prod.outlook.com (2603:10b6:8:99::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9700.12; Thu, 12 Mar
 2026 00:27:42 +0000
Received: from PH8PR11MB8107.namprd11.prod.outlook.com
 ([fe80::1ff:1e09:994b:21ff]) by PH8PR11MB8107.namprd11.prod.outlook.com
 ([fe80::1ff:1e09:994b:21ff%3]) with mapi id 15.20.9700.010; Thu, 12 Mar 2026
 00:27:42 +0000
From: Dan Williams <dan.j.williams@intel.com>
Date: Wed, 11 Mar 2026 17:27:40 -0700
To: Smita Koralahalli <Smita.KoralahalliChannabasappa@amd.com>,
	<linux-cxl@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
	<nvdimm@lists.linux.dev>, <linux-fsdevel@vger.kernel.org>,
	<linux-pm@vger.kernel.org>
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
Message-ID: <69b2087cb0cb7_2132100c2@dwillia2-mobl4.notmuch>
In-Reply-To: <20260210064501.157591-6-Smita.KoralahalliChannabasappa@amd.com>
References: <20260210064501.157591-1-Smita.KoralahalliChannabasappa@amd.com>
 <20260210064501.157591-6-Smita.KoralahalliChannabasappa@amd.com>
Subject: Re: [PATCH v6 5/9] dax: Track all dax_region allocations under a
 global resource tree
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: BYAPR21CA0020.namprd21.prod.outlook.com
 (2603:10b6:a03:114::30) To PH8PR11MB8107.namprd11.prod.outlook.com
 (2603:10b6:510:256::6)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH8PR11MB8107:EE_|DS7PR11MB6175:EE_
X-MS-Office365-Filtering-Correlation-Id: 5240b581-8a0e-4209-01e8-08de7fce2c73
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|376014|7416014|366016|7053199007|22082099003|18002099003|56012099003;
X-Microsoft-Antispam-Message-Info: FulI380cg2yClMA3Un6Kt1uDLEpEth1sMQm7T6sNP8cZXxiUAldskMxRe4e7Rhko+oXyXmOP6H86gh9Gcr4/ar0cZu/QdPpc/YR+MwqSS3Dis/MWRcdrkBy2tqrT1xM3wVvE+cIoyRhz5lOfn/ri8DWpTMEi1c8gUu+hVk6Mu+JAVnZ6vl1OcdAyBvvGREld4JZpkxiUBDZcUsNtZn56eBBp3rHkIrfX9SBcH+y1wcsio1S8dOAZ6GRgRYVL/axoehETEGrO0YcwJw/g6WcXmDXjCzDDbsa8IfPzmwEHu1+xSL1O7mlfejcz9+DLXQpZ1TFDgqqzFWjWj0CdGTgFlnZOO4UNCYfidRpgsS20L4mEe0gauAzt+Yzo8AGAeS8ERGTw3rPdE5lZmP/lLv6VMquSPPlhBUHNQthZ8LXj6JALaVU7u7E92trZ3QeWKYqQP7GV6/rSFReRPc1PtedCdll0DWnA05X/dGH1OVH77fExe1w+oqYV7XRuKz3gfEa+fqsqzQS8uOzg45s+b0tN2NRxa1hb5owdhY4pIAxbBM4sddB/vz0PtM2dHuUUTuMNjm08wwqFgA11NiUS/ak3VYLEPvJ3SajfuY3c8lZVL/+J1cv5qtyibReIoIw8aTDwicrsHa0WmD7Dxnou0agO26TZgS4ohAd+iCdqM13PuZeIgbMgW7tWsDIUVfC4SWTGxMWZrU6it3D/rB+non8djwyYL42oLtTWuJ2E5m0Etns=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH8PR11MB8107.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(7416014)(366016)(7053199007)(22082099003)(18002099003)(56012099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?SFY4czJDQlFpeXFJV1RJc3MrdHYzR0daL3hoNVhOelFIUmxMd1Z1UUxPb0lp?=
 =?utf-8?B?Y1pEQVUrU2tsb0x0OWtublVIb05kbXpPc3Z0L3ZHcXZ4cnUrVXBjL252MjRS?=
 =?utf-8?B?NzU4UGM2cXJQL21LWVhEbEl3WDBhMnYyN3B2T1d3QjFUeTJ5c2J5VnNDMmh1?=
 =?utf-8?B?VVJialgrcmZTUm5LR0FhbHVNZ1JQeTR4b0FmQThrMUtmTGpEb0xTaDYzYm5m?=
 =?utf-8?B?R28vWjQyVTdKeDkyaml2VUdvTFlHS2tFMWJuNFNWbVpmd09BNmdhaUgzOXVW?=
 =?utf-8?B?ZVVEZlluNi9aNW9GSjlsZFBQQTRrdlpadkxuZEUxRlBIdGs3ZHVvVThURzVl?=
 =?utf-8?B?VVM0UEhuM29DbGZXVEtETzdSV0xkZ0FCNXhWcGlCbnF2dnVHRlQyZkZjSkJE?=
 =?utf-8?B?ZlVlYU5CWDN2TlN5YUQ5WFZ1ditkb3dGMXFyOWFIKzVMaVk4QjFITysya1Fj?=
 =?utf-8?B?MjdjazAxVDZEcVlRaTVlcGpzN1RXNStOWEYzUmhvT01hTEhHbFR2bFZEWEZt?=
 =?utf-8?B?Q0xLdGU2NmE5VFRGeGl5ZkZXb0RrbjNBRnhRN2JCaUlRRTZUSVVPNTA3Y1VC?=
 =?utf-8?B?NGNSdm5hcXoycTdHUDJKL1NxMkEyYzNoTmFyanJTNnFxcUZJYkV0MjU2RUt1?=
 =?utf-8?B?YWdpMXNQcGYwdnZrUmNhdDZiUlRpYm03VmN3NnJuWlNBZ2RJSVZXOUhHSVFk?=
 =?utf-8?B?MWo1Qm41dmwzaEhiTWVaZldiRUtjdExIUmRRUHErMGd5WEtnc1NlU21iTkFt?=
 =?utf-8?B?TGdEOU1OdXJiaHYwQkhxZ2VUeFltdDlSSml3WElFUU81Z1dlNE9haU1zazhC?=
 =?utf-8?B?bW51clA4czRBMjJLcGRnbjc0TUxBM2lCSXd6S2kzMnF2YUFwT1l6dlVLbDBx?=
 =?utf-8?B?b3k4a0pqdFhtaWdtQVI4Vm1paVdtaFhsQWxnL0ZjK2JrZ0VJN2ZEanEyRGor?=
 =?utf-8?B?ZkgraDlOVHhST0tkTm8vdTBwTkhLRHlLN0kwWEZUZllHa2hPMnZ1TVBiY1Fw?=
 =?utf-8?B?cHJzZmxGdVhwSlcwWGRINGV2bEYrMnZaOUhnTXlkWDVRSHpNUDBSRTB3eGlo?=
 =?utf-8?B?WVpIazZtUzVXclNFRjlNazBxdHNFMXFYZnY4TXEwY1E3R3lpUXAwRmFUMTlm?=
 =?utf-8?B?REhkUk00UFdtWTc0VVhzWjZwRnlaa3FwbjFCdEpPVC9KS3h4RWdXc2dEQ2Y1?=
 =?utf-8?B?OHRvZVhnTEZqQndkbDM2MTVRN3EreXFNQzhHTVl3Zkpod2R1NFNyVXVLWU91?=
 =?utf-8?B?YWxPWGI0cVJLWjJySGNKNnNhVHhHMWVmL0YyMExzVUhWNDJUeUo4UzNxQlYy?=
 =?utf-8?B?dVFjKzhkRHJDMkRqQW04bWE4eWxXalZaQlYxTkZLRVlCYW85TTBmZ3Rsbk8z?=
 =?utf-8?B?eDJZNmlYdUdvS3M2WVJoTEZLUGIvdXVmRHgyQ3RPdUtVZGN6WTRRNUpORG9v?=
 =?utf-8?B?OHlXTGNuMEZUTTBIWlB1bElGbHdxT0xBbXVwTGpKM2d2aC9xRVZiYzAyVmhm?=
 =?utf-8?B?SzJRTFJZUUFzMWg1Tmo5aXpBcFkvTDRjTC91bEdiVENTTDVtQnJCa2FiTU84?=
 =?utf-8?B?WWVSb1FqOXc0bEE0ME5QV1RhMU9VVGhQSUxFbFU1VkhzU2h2enVXMkJqWUNR?=
 =?utf-8?B?cnFuYVQrWlhIU0FTRUJTYjZueFFrMlVTTmZZTlVObnVQYW5uOW9iRTVZMFdw?=
 =?utf-8?B?Nnp6OXRjWHZBQ1BVdGRBL2Rya2IweGhmdThtWmZkNlUzNWsxZkZNaVNMK25N?=
 =?utf-8?B?cUUya1FEcUFOYVRpUFFraE1UQWJVOWgvWU5ZY1dQaG5GOHk0UEFJWGMvUDQ1?=
 =?utf-8?B?aWErZGVJc2lycXB4UlhKb0IvYnlsOFdmeWl6RDdaOXFJb3k5eTd6NWVIR3dO?=
 =?utf-8?B?ODQ3emVOOFBQNnVvbk8vTlB1REdDMVl5Tko3a3BTdk9KdVdaRFB4MUxSbXBP?=
 =?utf-8?B?Y1lWam1IR29zYjk1R0cxUUZSNUYvamwyNndUTUFFYjJkS1V4VzYxdVZ1WVc3?=
 =?utf-8?B?NTNpSnppVXE2SmI0WE9QS1hLWEFtUld1QlAyeHU1Umw0NU9CZ21FRk9NSXox?=
 =?utf-8?B?WDh6dldrMElIMm9iaXpOQ3lxSjkxSHdaa1dIWTZzUHROWG1hM28vTVM3N1dF?=
 =?utf-8?B?d0lsNkJqUVZpaVVKVFpGWmN6aUpZYkx2cU5hcmhldkdNZG9PNUZabnhQVVpm?=
 =?utf-8?B?dHdvUXF2VVBpcURJZ2ZKMnBOd0p1dlQyVGUwTDgxUTg4dkxRSC9wTGhlWjZ4?=
 =?utf-8?B?SEViUU1kcUJMQSt3WVhFbnFSdklSRFBtMUpwMG5tdTlTQndvUDkvWHkrY1Jk?=
 =?utf-8?B?aVhCd1o4dEJiUnpjd2dJYnJDdUM5TkJNNlFLSWdjYnA4T2tXZ1VhZm84UklW?=
 =?utf-8?Q?35gTYNqfE5Gc97Ek=3D?=
X-Exchange-RoutingPolicyChecked: USUEIAFY3TW+EhXgTCMfjZBL5+X6eWFh/C+HAEGTmXBAFAZwT7j9uQpxKR6t4l/ERHqiB96Xbo+/VniNQsfFWwfikdpI8tUdmFfu6qMok7kIRldbxZRE1Rzbytu8kNYxktv7DMOVEE4VT5AInB2kBI5i2nfqbsdsMg6gNpIbYW2MLrAP8Vte+6vF4xGbMFMXr9J6YtSCGeVQ9iL4WLoOJWr4ttwKDVBxR58VpW535pnDWKM3bhKsvxhr6WVHMvAhKHjxA2/ryD/pN4UDg9yKTlHtVfCd0xcKEk6zjOsydhiDHWsMF7/3SGMQgPsC59BNDe3vLQNUNbkAlYmw+IMngA==
X-MS-Exchange-CrossTenant-Network-Message-Id: 5240b581-8a0e-4209-01e8-08de7fce2c73
X-MS-Exchange-CrossTenant-AuthSource: PH8PR11MB8107.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Mar 2026 00:27:42.1791
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: mvwrrJtDK75n6sWes3dBIRz5HkTDSBIbmOp6tcXF5beXYKQL7zbFEvIFsn4c0Vp4svnshc/A5xqyVg4mGig4gs5vdXyNIGZ04zs7L9RAtno=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR11MB6175
X-OriginatorOrg: intel.com

Smita Koralahalli wrote:
> Introduce a global "DAX Regions" resource root and register each
> dax_region->res under it via request_resource(). Release the resource on
> dax_region teardown.
> 
> By enforcing a single global namespace for dax_region allocations, this
> ensures only one of dax_hmem or dax_cxl can successfully register a
> dax_region for a given range.
> 
> Co-developed-by: Dan Williams <dan.j.williams@intel.com>

Did I send any code for this? If I suggested the locking below,
apologies, otherwise Suggested-by is expected unless code is adopted
from another patch.

> Signed-off-by: Dan Williams <dan.j.williams@intel.com>
> Signed-off-by: Smita Koralahalli <Smita.KoralahalliChannabasappa@amd.com>
> ---
>  drivers/dax/bus.c | 23 ++++++++++++++++++++---
>  1 file changed, 20 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/dax/bus.c b/drivers/dax/bus.c
> index fde29e0ad68b..5f387feb95f0 100644
> --- a/drivers/dax/bus.c
> +++ b/drivers/dax/bus.c
> @@ -10,6 +10,7 @@
>  #include "dax-private.h"
>  #include "bus.h"
>  
> +static struct resource dax_regions = DEFINE_RES_MEM_NAMED(0, -1, "DAX Regions");
>  static DEFINE_MUTEX(dax_bus_lock);
>  
>  /*
> @@ -625,6 +626,8 @@ static void dax_region_unregister(void *region)
>  {
>  	struct dax_region *dax_region = region;
>  
> +	scoped_guard(rwsem_write, &dax_region_rwsem)
> +		release_resource(&dax_region->res);

I continue to dislike what scoped_guard() does to indentation. Often
scoped_guard() usage can just be replaced by "helper that uses guard()"

However, dax_region_rwsem protects subdivision of a dax_region, not
coordination across regions.

Also, release_resource() and request_resource() are already protected by
the resource_lock, why is a new lock needed?
