Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 050B421ABA5
	for <nvdimm@lists.linux.dev>; Thu,  8 May 2025 06:48:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.12
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746686933; cv=fail; b=u9g2/Z16QAD2pJN4p7puYWUUXDjcz48EuWU/JHwzuqg6+0exwkfS2FbepQWT8ZHMbYEtwTvZb0g5+1SKF+HfGQzzae3aZHEWU5uJz6O6BvVKfHBcTLbAdB1bdrN6K3MQ7DtH986DEsKKrL5dGlcqb0lXfaLC6VYAo4bKWuil1yU=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746686933; c=relaxed/simple;
	bh=oPC+OKKruQ3oXUzn+G3hXHxJ72taDKScome5BF1dUxU=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=MjtnAf1sEZUo6/fGhu9+sBxtaK1ut0QJnMM7jGjlfGwPzYRrvEvl7cbCPJHUqxe3L4oWRyWs8ohgAlr9M8fClZJpBvJjx3Vvze5Fu8OuQlGrmr3PrtAXPaPXDXpQcv0DPbYW6SQrP1oqH+yRpZuJUUSBGD1Oc0UgMcE690vEaWQ=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=cLI74stQ; arc=fail smtp.client-ip=198.175.65.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="cLI74stQ"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1746686932; x=1778222932;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=oPC+OKKruQ3oXUzn+G3hXHxJ72taDKScome5BF1dUxU=;
  b=cLI74stQadI9GPrBe4z3tkWA5+6Pw7X/S72KQxwsMianNDsC3vV4b+eU
   euQM+klSam0SmStxbAtyQ4qyVkpQ0xgrj3sH2/SzORITZ3/4/hKR+tMmW
   iQM8zDHVkbOY/Q060U7Wic4DtFgBOQF5Dkf2BwQzMXvVeoMUw/tqUqPss
   6DUo75KpeWBr25XVMDIXF6lq0Qd8i5cdtjKwHR7KezNinoiy/eP1FTh7F
   Nqhvl2plCDi92JtmeeqFnoVNrsa6w+D+BONlDgsakNVRzAUOnPXendRdc
   jhbuhH/gyX98wnQtJca7lFBlhiRj6kjQn7nlDk+aUAxIVL6mIlilaBMMX
   Q==;
X-CSE-ConnectionGUID: m3yLndA0S8KaaOUqj+mvNQ==
X-CSE-MsgGUID: uV8HyOWiTj+xXOtXkk7Wkw==
X-IronPort-AV: E=McAfee;i="6700,10204,11426"; a="59848552"
X-IronPort-AV: E=Sophos;i="6.15,271,1739865600"; 
   d="scan'208";a="59848552"
Received: from orviesa006.jf.intel.com ([10.64.159.146])
  by orvoesa104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 May 2025 23:48:52 -0700
X-CSE-ConnectionGUID: yT+ImqUjS/eAunBCcH9iQg==
X-CSE-MsgGUID: 8ll3YahYQSuR6MCWAembIQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.15,271,1739865600"; 
   d="scan'208";a="136132687"
Received: from orsmsx902.amr.corp.intel.com ([10.22.229.24])
  by orviesa006.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 May 2025 23:48:52 -0700
Received: from ORSMSX901.amr.corp.intel.com (10.22.229.23) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.14; Wed, 7 May 2025 23:48:51 -0700
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.14 via Frontend Transport; Wed, 7 May 2025 23:48:51 -0700
Received: from NAM02-SN1-obe.outbound.protection.outlook.com (104.47.57.42) by
 edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.44; Wed, 7 May 2025 23:48:50 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=oMiW1Cgzi2ebYn8eWCiCMno5nTLl12Fc3m/YzB0Bre2gZqijhsKL++f8rnZDkSrMqxT8JPLobNpJWLqTYRPoMn2Vbo9mj2/u+rZaYrt+7ffeojTZPcwddIUh7JN61VE2y+ENZiZ6Tdz7J4Z+vNYoC+h+GlTTjEspaDY+QgGxdopqUOoiRnTQuHkEhE5um6niI50saflNLBcmeuVkepHmwHNYHRik5LJlern+WSnawViojp2m81Skax3FsjwASooYD3eYdJ8jdIdnrZ17CzzYpYkPOx7Tp/SNB0dVPyWlv/IpLtkR6l3jiTviqShzQH67LUysP/9kNS00G31U08/ZqA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=oPC+OKKruQ3oXUzn+G3hXHxJ72taDKScome5BF1dUxU=;
 b=l7OWRpuAs3QxTHRE0xAOSXDpL6bhy8oYhaicFByIDYAlZNaXhLamXM/pnu6Vs9XSlvmBSwsZ9hunzRzbR5rVmeca7MQ3O/wnt/HxAXHiYPmr58+WTdzuUvE9pSBn1fK0yToOkss1J/GWR8tk3Z51hLzTEQV/834ikoPTmC4BzB+bS0JwX5/5yaarmK9gej10dIe+cIT4L6yEOc3Xt9p/qBuhcJ3K1VX2GBC7xoziYRYoM6GC22+s5BbdpLqrnzaBwqqlCK0BmQfqbYtgUgi49BixfqEqVA07KlNwzxqU5gq+yozNAwlkDmuZJxEJimu0NpgwG6XL559VWyPmXAP8pg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from MW4PR11MB7125.namprd11.prod.outlook.com (2603:10b6:303:219::12)
 by IA1PR11MB7246.namprd11.prod.outlook.com (2603:10b6:208:42e::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8699.32; Thu, 8 May
 2025 06:48:17 +0000
Received: from MW4PR11MB7125.namprd11.prod.outlook.com
 ([fe80::eff6:f7ef:65cd:8684]) by MW4PR11MB7125.namprd11.prod.outlook.com
 ([fe80::eff6:f7ef:65cd:8684%4]) with mapi id 15.20.8722.021; Thu, 8 May 2025
 06:48:16 +0000
From: "Verma, Vishal L" <vishal.l.verma@intel.com>
To: "Jiang, Dave" <dave.jiang@intel.com>, "linux-cxl@vger.kernel.org"
	<linux-cxl@vger.kernel.org>, "nvdimm@lists.linux.dev"
	<nvdimm@lists.linux.dev>
CC: "Schofield, Alison" <alison.schofield@intel.com>
Subject: Re: [NDCTL PATCH] cxl: Change cxl-topology.sh assumption on host
 bridge validation
Thread-Topic: [NDCTL PATCH] cxl: Change cxl-topology.sh assumption on host
 bridge validation
Thread-Index: AQHbv2+c03W7lypek0GI1iBTBkDS57PIS3mA
Date: Thu, 8 May 2025 06:48:16 +0000
Message-ID: <ffac09c7154f4c4bc9dff6524a02d8a707ad8b0c.camel@intel.com>
References: <20250507164618.635320-1-dave.jiang@intel.com>
In-Reply-To: <20250507164618.635320-1-dave.jiang@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.54.3 (3.54.3-1.fc41) 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: MW4PR11MB7125:EE_|IA1PR11MB7246:EE_
x-ms-office365-filtering-correlation-id: b3cceb5c-8226-4661-8b6f-08dd8dfc4ff5
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|376014|1800799024|366016|38070700018;
x-microsoft-antispam-message-info: =?utf-8?B?Qk8vUyt1RkxnUnZyUUlPRlptNGlsWmIyVjh5L0Q3ZTlTWGRIbmo3dG1rV1ha?=
 =?utf-8?B?dmRXTmswYVdIZmx1RzBoSzRCNzF0aU1EaUQzUGY0VE1rWko4MDV2YWJNOFlM?=
 =?utf-8?B?dEdCejlLNm16YUpMRTBsOWY3bkNhTVlSeHpwVzhiNTBsNFZRRzBURDJDVnU4?=
 =?utf-8?B?RkluTnY2QzhkUktEaEpkTjRHWmhIRDlZMjlHbEdjUUg0Nm9TdEo0c1VLeDJx?=
 =?utf-8?B?anBmc2JYcVcvY2d1ZWtldUJXZUFSTjVLMGtLcmU2VzFrSWloRkFiRVBoQWF5?=
 =?utf-8?B?dk10U0laMkxpWEx3VUZuU1VYcFY1U2t2Y1Q5SkR5QU1OaFVNTis2eXZmY0NL?=
 =?utf-8?B?RUVJUXdkbmFXTFpjUXVUdG8xUW4reUJKWmY4dm5YRXJ2RnF6MEVlUU5PYm5j?=
 =?utf-8?B?SW9kbyt3UjdCREQ2U085VUNFV1F2ZEsxbTJsdlFGMlZTTjQyYkVlUERKYnVm?=
 =?utf-8?B?N0FNUXF2YVlLYXU4M1AvS0hDRzRUNFRDTmUwME94VldHS2NTL1ROUU8rYWt6?=
 =?utf-8?B?ejBTVDVHR1hNNFdONWZSVmtTSzZlZU16VDVFN25tM0ljNWwwaXA3NW1lUUlq?=
 =?utf-8?B?WldMdFVjQmgyQW9OY1FiVklSWlI2VzExRExrY2tlWDVGd0Y2RE80U3FWODFr?=
 =?utf-8?B?eUR2K3lqUXVlZEZjNm9SVk5YUHl0UUxYblpuOTdhN01EZzZzY2FQeXoxOWpz?=
 =?utf-8?B?em9ibXdCYkdHc2FIS1FBVHFYVlFQTEdZS3MrSXZGQ3ZHS05BbldzbXBJVk9y?=
 =?utf-8?B?bW5CWWdYZ3ZFOTRHZ1JZZVBEMWIyTUVvNjM3anRvY1NONUIwbm1yb0hHY2NG?=
 =?utf-8?B?UTVJVG5QOWR0M1RWVEpMSWtGZ0NVQWlNcTM2V0xaQnBMMjc1N3VPc001NWRk?=
 =?utf-8?B?bndSS1lPdDR6WXRqenRkbUdpUTVGNnhIVmdsOWRwdXFSTk1ibnVhNEp0cmxh?=
 =?utf-8?B?b0tiZHNLWEJHV3k5WFQ3c0dXRWNIYWJqdVlJZW9nQk5pYk1GM044UFRrZ0RL?=
 =?utf-8?B?cWFqRmc3RzlxaVFFVmNXQ0VNU2dUTnVTR3lCclpkKzV2eGdSb0lwRlBYNmEy?=
 =?utf-8?B?WTl1dXJQOEdCdWp1eVpJVkUzUFhHNkQ5RERRaWErVVRIZkU5RU9TTThQSits?=
 =?utf-8?B?RC8xcDRYOEt2WmlRVUR5bEY3ZmNRZC9MUmE1ZmFFS0VWRndwdkFlbEt0enlL?=
 =?utf-8?B?MWtuMkNUcUZ4ODBiMVFBVzgrdUJITDBYMlU1S0NRRWJOYWdYWWpENy9EZTMx?=
 =?utf-8?B?cUF0R0g4Qm9aeG9paXNhWllZNkxydUpyUTN1dHZVZmdDM2tISUFpbzNuM1ha?=
 =?utf-8?B?ZEJKaUdGY1R3dXNPSUJiM3JvYm5yanBGdThiaDIrWTMzQi9aOHpjcEZ6VE9s?=
 =?utf-8?B?eDJ6VExxZ0FsOExQM0YrZkpPSWlvSDltWVdock5uTVdHd2YyM3BiMXYxaHBR?=
 =?utf-8?B?bHFRT3lxanRMZzl0STJWWE5uUXFQQThPT3JvUnVMY0dRdWtOK3VTL1BzSDgx?=
 =?utf-8?B?eldVaXhVbmRmQlE5NG1PT25HM3hpdmRQc0VNZ0s2ak9jUXdqVkg2Q01UUnlm?=
 =?utf-8?B?eVlIckJSS3pxNytpMk45dktwSXp3QWdjUExDMzNhZU9za1pPTkUzUXIzNjlV?=
 =?utf-8?B?aTRjKzBlZ0R5SUZQUXBhNzBGNVdEZlY5TXV3UmpyL1RtSmpjSzRYMW5WWFRS?=
 =?utf-8?B?bS8xWWhaL0xuQjVrb1lGeW9LbFVmUVQzYnhCV2RmeTdybW1DRWxiWXlUMkJJ?=
 =?utf-8?B?NnZWek1CdU5pd1lIZHZ6ZEphdFVQSjI4TzBGRTkyeXpaZGhRNXdqOWNtc0NV?=
 =?utf-8?B?T0JvTHlEekoyVzJTNUYrQWsya1d5RkYwYVhLZkZoWmdSRFZqMDl5N1VHaWdq?=
 =?utf-8?B?Y0dQUVFWMFNtNFJuVk4zWnMwOUN6Zk9odVdLMUhNZGprVU55NFBDVlJDdUwz?=
 =?utf-8?B?WTlpSVFPSThLR2JHdnY4MS9ZeEhMTE1yUXRwT3EvNmc5bmFnYmMxZjBNUVJh?=
 =?utf-8?Q?nJAPeBHWuNFJUochKZmkAvqjN67yTQ=3D?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MW4PR11MB7125.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(1800799024)(366016)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?bnFSeVo5S2tMTUUyOEJzWkgvTEZwcVZPRTRXL3dJcDgzeS9FbTA1MVFFYWhW?=
 =?utf-8?B?Y0wxelhOcG5oRGFUaDhUamJDemV1TFlROU5IMnBvc3BsdEFDdVFwcXFoOHE4?=
 =?utf-8?B?c2xSdnhmQUw1Q2VYMnFuelVxVFBoZVZ3bEtTK3orTXN0UnJ4Zm94YUVzSWp5?=
 =?utf-8?B?c1ExMVR3ejVCQVhwZkpIVXFYVzh1OFRyQlhqQkJtU3h3TU9jbDZudFdMandB?=
 =?utf-8?B?bWtQc2xoamhnRVhzUzZsWUN0dUNBdWZxOGpLWFFacTNzZWo5YVgzWWRLdGZC?=
 =?utf-8?B?UEErL0h6NmpnMEZweVBiUUxoaDZjQVhrM2RTOUUyb2I1VDFPaDZyU1ZveUlo?=
 =?utf-8?B?OXF6NGV4azhxbHNabFJ5L3FBQlcrbnFKMTdwR243MWlzRmdmN2ZwM1paMzhl?=
 =?utf-8?B?RHIzaS9tMkFCWVhSL3pqdHN4OVc4UUdaMlpmQnpPREFtZHlJYTJnQjVFWVJO?=
 =?utf-8?B?SndiUlhvUkdGMUg3d2NUQXF3dlYxLzdBVmtFVkg0NXFXTnBHcDRFaVJrYndL?=
 =?utf-8?B?V25ZbDBJWm9sbFBlZ0tVcEhuOVB6Q2hJNzVzSk1qUWVldU9KN01NdU5USjc1?=
 =?utf-8?B?eG5rMHNtRGViSElkZFJETFB3YnU4UzBqSFhWU05jTk9RbGMwZTUrekF2RVJk?=
 =?utf-8?B?ZVY4dUdVMkFqV0d6S3dNcEMxbjRETFVPNUJ2enFRVlYvemRsbDJ4bWZGdGJZ?=
 =?utf-8?B?WW95RCtFbElydGRmYy8zeHlWTGQ2SEh3akx1VlQ0aWErY1dQYmtlYVZiajlV?=
 =?utf-8?B?WG9KN1c2ZXBTQmV1bERuSituLzdaVXY0S3FWVzhaNFRRLzZxV1dBanl3Z3Y3?=
 =?utf-8?B?MVZVOUxLcFdXdzQrQ2NMK3RZMWdZdjBWWDh4SW5qcmhBelREQnoxTzBBOHBl?=
 =?utf-8?B?SVlFSk9BMFdRdW8vUk8zUElSRDNNd24vZjY3bWtFcG5aNzNzNGp3VllZVlNQ?=
 =?utf-8?B?VUd1b1UwNzNOanNSeFZRcXNkdzlVekdNUGNvUllmQ0hyNVVBd0RGYms4T21L?=
 =?utf-8?B?SysvRU9OcDFNd3B5UVNVZE9SRDR3aG53Y0M4aDMxY1BPZEFFMG5aS2NwQlgy?=
 =?utf-8?B?R3NDV0FQN2RhT3g2cUNjQjN6Y21LY0R6R3JpZ3hVUkVsb3RCcEVaV242THNt?=
 =?utf-8?B?QW44RGdqQjhlVTIzVGtnR1BjOWhGekFDc2d4cjEzQTAwYVhGU04vQUI3bXMv?=
 =?utf-8?B?S2x0SFkyZS9LNXZoMWs3ZUxtaTAybXFOb0c5OU1pUXFtWTNkSnNnN3FTOS9D?=
 =?utf-8?B?cnRvZUE3dnJuc3FGU0hRZ1c0SFAyY0wyL0NzdVJvR25xNWd0eEptQmU0UjRC?=
 =?utf-8?B?bDM4UTM1a25ka3FrZmVWT0FnenJlQ1VJNGZkL0VTTERsUFFadm5sSE9Vd2JK?=
 =?utf-8?B?VklBRHZsc1pBcjZybEZycklQaHdhTEcyTXErSTZidDBJTXE4TU55TnFnWW9m?=
 =?utf-8?B?VkRUaGxRd01UUklBcU5VZmZDd0NiZFlITENQS1RtbytXWUhJbjJXSUh5NHVh?=
 =?utf-8?B?SWlFZXRPRkgrejM3QU5Yck9rYXRQa25jN1kzRG9wRVE1cmVwc1JFYXg3YkJk?=
 =?utf-8?B?eHNvZDFuSUhZYW5hYUg4VjJucHZYcEFwQWtnZWE0d1p3MVJwUVN6VjhmWUto?=
 =?utf-8?B?N3RGSVM1c3FqV2FiUGRQUUFCY0FFN3JDMDA2REtQdTYwUmxTODNtR2tQVkhR?=
 =?utf-8?B?TUZIUFpDOW5pZkZzckc5S2pQWi83UlVQOFE3K2RUck04cFBneDZ5UXpHaHFq?=
 =?utf-8?B?QUlZT3JDOFZDd2lKYmRvK1FTaiszMDNDZEp1NU1tNExLb3dtTHoxU3Q2eVBK?=
 =?utf-8?B?UGV2UW4veWQ0VlVyRDc1dkNHeHpkWUYwVG50VTVlTzR2YUVXRmVDN1BGS1gw?=
 =?utf-8?B?OWUrMmJiRm93ZWVZdFBnWmxHRVo1K0JOYlF0Q3pMYkNMTGVTN0p5aXpZNTJM?=
 =?utf-8?B?ZHJ0TFhJRFNnd2paMUI3N0RoaTM5cHpoSW1KeEVGbzdJWDVxSWVWeTJvWDVR?=
 =?utf-8?B?dURCaTl1UjdQbXFoeEJWV0pybk13NDlNa1kzN2tIM0x2ek8xbEIwV1o1WVFE?=
 =?utf-8?B?Y2JJbHpWRXJyekxzRjU1UU10SW11azFRZkJvZE90T3ZleFI3NFRZYm40eWlh?=
 =?utf-8?B?bG5ydzNKOFdOTDZhV25YdGErbWZKZmIwVGM1aDNVSUNUWFc4R0tnYmlwWm9Z?=
 =?utf-8?B?UVE9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <5AB6D91F35564943BB9D120B90A87C13@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MW4PR11MB7125.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b3cceb5c-8226-4661-8b6f-08dd8dfc4ff5
X-MS-Exchange-CrossTenant-originalarrivaltime: 08 May 2025 06:48:16.9017
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: +8mtCSvYPOmhApR4eGLI1z/PYYwiju0BzmigJDrAE3z1BkJh2E5YmqPZ2VM7nSjBu2EMBE4cDMRxqDld8v8K9YdIemiO810UGRK+Ebu+O1w=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR11MB7246
X-OriginatorOrg: intel.com

T24gV2VkLCAyMDI1LTA1LTA3IGF0IDA5OjQ2IC0wNzAwLCBEYXZlIEppYW5nIHdyb3RlOg0KPiBD
dXJyZW50IGhvc3QgYnJpZGdlIHZhbGlkYXRpb24gaW4gY3hsLXRvcG9sb2d5LnNoIGFzc3VtZXMg
dGhhdCB0aGUNCj4gZGVjb2RlciBlbnVtZXJhdGlvbiBpcyBpbiBvcmRlciBhbmQgdGhlcmVmb3Jl
IHRoZSBwb3J0IG51bWJlcnMgY2FuDQo+IGJlIHVzZWQgYXMgYSBzb3J0aW5nIGtleS4gV2l0aCBk
ZWxheWVkIHBvcnQgZW51bWVyYXRpb24sIHRoaXMNCj4gYXNzdW1wdGlvbiBpcyBubyBsb25nZXIg
dHJ1ZS4gQ2hhbmdlIHRoZSBzb3J0aW5nIHRvIGJ5IG51bWJlcg0KPiBvZiBjaGlsZHJlbiBwb3J0
cyBmb3IgZWFjaCBob3N0IGJyaWRnZSBhcyB0aGUgdGVzdCBjb2RlIGV4cGVjdHMNCj4gdGhlIGZp
cnN0IDIgaG9zdCBicmlkZ2VzIHRvIGhhdmUgMiBjaGlsZHJlbiBhbmQgdGhlIHRoaXJkIHRvIG9u
bHkNCj4gaGF2ZSAxLg0KPiANCj4gU2lnbmVkLW9mZi1ieTogRGF2ZSBKaWFuZyA8ZGF2ZS5qaWFu
Z0BpbnRlbC5jb20+DQo+IC0tLQ0KPiDCoHRlc3QvY3hsLXRvcG9sb2d5LnNoIHwgMTAgKysrKysr
LS0tLQ0KPiDCoDEgZmlsZSBjaGFuZ2VkLCA2IGluc2VydGlvbnMoKyksIDQgZGVsZXRpb25zKC0p
DQo+IA0KPiBkaWZmIC0tZ2l0IGEvdGVzdC9jeGwtdG9wb2xvZ3kuc2ggYi90ZXN0L2N4bC10b3Bv
bG9neS5zaA0KPiBpbmRleCA5MGI5Yzk4MjczZGIuLjQxZDZmMDUyMzk0ZCAxMDA2NDQNCj4gLS0t
IGEvdGVzdC9jeGwtdG9wb2xvZ3kuc2gNCj4gKysrIGIvdGVzdC9jeGwtdG9wb2xvZ3kuc2gNCj4g
QEAgLTM3LDE1ICszNywxNiBAQCByb290PSQoanEgLXIgIi5bXSB8IC5idXMiIDw8PCAkanNvbikN
Cj4gwqANCj4gwqANCj4gwqAjIHZhbGlkYXRlIDIgb3IgMyBob3N0IGJyaWRnZXMgdW5kZXIgYSBy
b290IHBvcnQNCj4gLXBvcnRfc29ydD0ic29ydF9ieSgucG9ydCB8IC5bNDpdIHwgdG9udW1iZXIp
Ig0KPiDCoGpzb249JCgkQ1hMIGxpc3QgLWIgY3hsX3Rlc3QgLUJQKQ0KPiDCoGNvdW50PSQoanEg
Ii5bXSB8IC5bXCJwb3J0czokcm9vdFwiXSB8IGxlbmd0aCIgPDw8ICRqc29uKQ0KPiDCoCgoY291
bnQgPT0gMikpIHx8ICgoY291bnQgPT0gMykpIHx8IGVyciAiJExJTkVOTyINCj4gwqBicmlkZ2Vz
PSRjb3VudA0KPiDCoA0KPiAtYnJpZGdlWzBdPSQoanEgLXIgIi5bXSB8IC5bXCJwb3J0czokcm9v
dFwiXSB8ICRwb3J0X3NvcnQgfCAuWzBdLnBvcnQiIDw8PCAkanNvbikNCj4gLWJyaWRnZVsxXT0k
KGpxIC1yICIuW10gfCAuW1wicG9ydHM6JHJvb3RcIl0gfCAkcG9ydF9zb3J0IHwgLlsxXS5wb3J0
IiA8PDwgJGpzb24pDQo+IC0oKGJyaWRnZXMgPiAyKSkgJiYgYnJpZGdlWzJdPSQoanEgLXIgIi5b
XSB8IC5bXCJwb3J0czokcm9vdFwiXSB8ICRwb3J0X3NvcnQgfCAuWzJdLnBvcnQiIDw8PCAkanNv
bikNCj4gK2JyaWRnZVswXT0kKGpxIC1yIC0tYXJnIGtleSAiJHJvb3QiICcuW10gfCBzZWxlY3Qo
aGFzKCJwb3J0czoiICsgJGtleSkpIHwgLlsicG9ydHM6IiArICRrZXldIHwgbWFwKHtmdWxsOiAu
LCBsZW5ndGg6ICguWyJwb3J0czoiICsgLnBvcnRdIHwgbGVuZ3RoKX0pIHwgc29ydF9ieSgtLmxl
bmd0aCkgfCBtYXAoLmZ1bGwpIHwgLlswXS5wb3J0JyA8PDwgIiRqc29uIikNCj4gKw0KPiArYnJp
ZGdlWzFdPSQoanEgLXIgLS1hcmcga2V5ICIkcm9vdCIgJy5bXSB8IHNlbGVjdChoYXMoInBvcnRz
OiIgKyAka2V5KSkgfCAuWyJwb3J0czoiICsgJGtleV0gfCBtYXAoe2Z1bGw6IC4sIGxlbmd0aDog
KC5bInBvcnRzOiIgKyAucG9ydF0gfCBsZW5ndGgpfSkgfCBzb3J0X2J5KC0ubGVuZ3RoKSB8IG1h
cCguZnVsbCkgfCAuWzFdLnBvcnQnIDw8PCAiJGpzb24iKQ0KPiArDQo+ICsoKGJyaWRnZXMgPiAy
KSkgJiYgYnJpZGdlWzJdPSQoanEgLXIgLS1hcmcga2V5ICIkcm9vdCIgJy5bXSB8IHNlbGVjdCho
YXMoInBvcnRzOiIgKyAka2V5KSkgfCAuWyJwb3J0czoiICsgJGtleV0gfCBtYXAoe2Z1bGw6IC4s
IGxlbmd0aDogKC5bInBvcnRzOiIgKyAucG9ydF0gfCBsZW5ndGgpfSkgfCBzb3J0X2J5KC0ubGVu
Z3RoKSB8IG1hcCguZnVsbCkgfCAuWzJdLnBvcnQnIDw8PCAiJGpzb24iKQ0KPiDCoA0KDQpUaGUg
anEgZmlsdGVyaW5nIGxvb2tzIHJlYXNvbmFibGUsIGJ1dCB0aGUgbG9uZyBsaW5lcyBhcmUgZGVm
aW5pdGVseSBhDQpiaXQgdW5zaWdodGx5LCBub3QgdG8gbWVudGlvbiBoYXJkIHRvIGZvbGxvdy9l
ZGl0IGluIHRoZSBmdXR1cmUuDQoNCkhvdyBhYm91dCB0aGlzIGluY3JlbWVudGFsIHBhdGNoIChJ
dCBwYXNzZXMgdGhlIHRlc3QgZm9yIG1lIHdpdGggdGhlDQpkZWxheWVkIHBvcnQgZW51bWVyYXRp
b24gc2VyaWVzKToNCg0KLS0+OC0tDQoNCkZyb20gOTk2NjEwZmFjMGE3NTFhY2M1ZDY4YTU2ZmY3
ZDY3NDYzNDhhODBjNCBNb24gU2VwIDE3IDAwOjAwOjAwIDIwMDENCkZyb206IFZpc2hhbCBWZXJt
YSA8dmlzaGFsLmwudmVybWFAaW50ZWwuY29tPg0KRGF0ZTogVGh1LCA4IE1heSAyMDI1IDAwOjQ2
OjI3IC0wNjAwDQpTdWJqZWN0OiBbbmRjdGwgUEFUQ0hdIHRlc3Q6IENsZWFudXAgbG9uZyBsaW5l
cyBpbiBjeGwtdG9wb2xvZ3kuc2gNCg0KU2lnbmVkLW9mZi1ieTogVmlzaGFsIFZlcm1hIDx2aXNo
YWwubC52ZXJtYUBpbnRlbC5jb20+DQotLS0NCiB0ZXN0L2N4bC10b3BvbG9neS5zaCB8IDI3ICsr
KysrKysrKysrKysrKysrKysrKysrKy0tLQ0KIDEgZmlsZSBjaGFuZ2VkLCAyNCBpbnNlcnRpb25z
KCspLCAzIGRlbGV0aW9ucygtKQ0KDQpkaWZmIC0tZ2l0IGEvdGVzdC9jeGwtdG9wb2xvZ3kuc2gg
Yi90ZXN0L2N4bC10b3BvbG9neS5zaA0KaW5kZXggZjRiYTczNzQuLmI2OGNiOGIyIDEwMDY0NA0K
LS0tIGEvdGVzdC9jeGwtdG9wb2xvZ3kuc2gNCisrKyBiL3Rlc3QvY3hsLXRvcG9sb2d5LnNoDQpA
QCAtNDIsMTEgKzQyLDMyIEBAIGNvdW50PSQoanEgIi5bXSB8IC5bXCJwb3J0czokcm9vdFwiXSB8
IGxlbmd0aCIgPDw8ICRqc29uKQ0KICgoY291bnQgPT0gMikpIHx8ICgoY291bnQgPT0gMykpIHx8
IGVyciAiJExJTkVOTyINCiBicmlkZ2VzPSRjb3VudA0KIA0KLWJyaWRnZVswXT0kKGpxIC1yIC0t
YXJnIGtleSAiJHJvb3QiICcuW10gfCBzZWxlY3QoaGFzKCJwb3J0czoiICsgJGtleSkpIHwgLlsi
cG9ydHM6IiArICRrZXldIHwgbWFwKHtmdWxsOiAuLCBsZW5ndGg6ICguWyJwb3J0czoiICsgLnBv
cnRdIHwgbGVuZ3RoKX0pIHwgc29ydF9ieSgtLmxlbmd0aCkgfCBtYXAoLmZ1bGwpIHwgLlswXS5w
b3J0JyA8PDwgIiRqc29uIikNCiticmlkZ2VfZmlsdGVyKCkNCit7DQorCWxvY2FsIGJyX251bT0i
JDEiDQogDQotYnJpZGdlWzFdPSQoanEgLXIgLS1hcmcga2V5ICIkcm9vdCIgJy5bXSB8IHNlbGVj
dChoYXMoInBvcnRzOiIgKyAka2V5KSkgfCAuWyJwb3J0czoiICsgJGtleV0gfCBtYXAoe2Z1bGw6
IC4sIGxlbmd0aDogKC5bInBvcnRzOiIgKyAucG9ydF0gfCBsZW5ndGgpfSkgfCBzb3J0X2J5KC0u
bGVuZ3RoKSB8IG1hcCguZnVsbCkgfCAuWzFdLnBvcnQnIDw8PCAiJGpzb24iKQ0KKwlqcSAtciBc
DQorCQktLWFyZyBrZXkgIiRyb290IiBcDQorCQktLWFyZ2pzb24gYnJfbnVtICIkYnJfbnVtIiBc
DQorCQknLltdIHwNCisJCSAgc2VsZWN0KGhhcygicG9ydHM6IiArICRrZXkpKSB8DQorCQkgIC5b
InBvcnRzOiIgKyAka2V5XSB8DQorCQkgIG1hcCgNCisJCSAgICB7DQorCQkgICAgICBmdWxsOiAu
LA0KKwkJICAgICAgbGVuZ3RoOiAoLlsicG9ydHM6IiArIC5wb3J0XSB8IGxlbmd0aCkNCisJCSAg
ICB9DQorCQkgICkgfA0KKwkJICBzb3J0X2J5KC0ubGVuZ3RoKSB8DQorCQkgIG1hcCguZnVsbCkg
fA0KKwkJICAuWyRicl9udW1dLnBvcnQnDQorfQ0KIA0KLSgoYnJpZGdlcyA+IDIpKSAmJiBicmlk
Z2VbMl09JChqcSAtciAtLWFyZyBrZXkgIiRyb290IiAnLltdIHwgc2VsZWN0KGhhcygicG9ydHM6
IiArICRrZXkpKSB8IC5bInBvcnRzOiIgKyAka2V5XSB8IG1hcCh7ZnVsbDogLiwgbGVuZ3RoOiAo
LlsicG9ydHM6IiArIC5wb3J0XSB8IGxlbmd0aCl9KSB8IHNvcnRfYnkoLS5sZW5ndGgpIHwgbWFw
KC5mdWxsKSB8IC5bMl0ucG9ydCcgPDw8ICIkanNvbiIpDQorIyAkY291bnQgaGFzIGFscmVhZHkg
YmVlbiBzYW5pdGl6ZWQgZm9yIGFjY2VwdGFibGUgdmFsdWVzLCBzbw0KKyMganVzdCBjb2xsZWN0
ICRjb3VudCBicmlkZ2VzIGhlcmUuDQorZm9yIGkgaW4gJChzZXEgMCAkKChjb3VudCAtIDEpKSk7
IGRvDQorCWJyaWRnZVskaV09IiQoYnJpZGdlX2ZpbHRlciAiJGkiIDw8PCAiJGpzb24iKSINCitk
b25lDQogDQogIyB2YWxpZGF0ZSByb290IHBvcnRzIHBlciBob3N0IGJyaWRnZQ0KIGNoZWNrX2hv
c3RfYnJpZGdlKCkNCg0KYmFzZS1jb21taXQ6IDkyZDUyMDMwNzc1NTNiZmM5ZjdiZjFjMjE5NTYz
ZGIwZmMyOGU2NjANCnByZXJlcXVpc2l0ZS1wYXRjaC1pZDogZjE3MjYxNjkzZTNhYzM4ODgwYjc3
MDFhOTRhNDY5YmI1MTNiNDA3OA0KLS0gDQoyLjQ5LjANCg==
