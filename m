Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DD3A61AAA1E
	for <nvdimm@lists.linux.dev>; Tue, 20 May 2025 20:47:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.10
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747774031; cv=fail; b=DuIKAZmw2QQF76gm5+/E1GY1QsMr23izHTfnILdsYcee/TKNXi1/HQ0GpkFg+AbF5cU7Fw8Gsl2x19yKdvqDhzNnP2QzZ+IKm/h0i3yPcVyx57c+q7YVVwJp44XpFTdeybjibUwHexNb9G8XVtw4Fguw0FgEagAaVhp6kD1+XeE=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747774031; c=relaxed/simple;
	bh=Vq5NE7F41uzzHUof2dIXILA69FqOXawo/JJpGWmFIG8=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=rBzSeWNtW21dVef4oJ2JJT+cb3hamE64lpP2kn83un9JejFoS018JUfJIFndvqFwwEvaIImTXslrr4BQX7kweiQe8CPCx42NKDa2vPMvzKiQbGszVrcYo6r4Mi60db0YqLdrKPxcCUXsxday6sTwKTNZHmKfvtwU9PAqmgt1wxA=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=ULuFW0Sh; arc=fail smtp.client-ip=198.175.65.10
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="ULuFW0Sh"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1747774030; x=1779310030;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=Vq5NE7F41uzzHUof2dIXILA69FqOXawo/JJpGWmFIG8=;
  b=ULuFW0Sh1C+6DvFlYetQb0tcg41i0v/C17D5/Jv77oQpxL1ktRtwVexk
   KLX/CzKsiMUp1YCX8D4ORfH2LZhOVZ8vXHcMPQt49+dMPQhFZyH+5+O+p
   GuSB15R6cO1b1R1Xwg/X0tRaQP/U9ZgCb8eiqqHgS9R1Q82l8XF384XA7
   OHgaCsYXlsCi+qHvuCCaDjQV6PVmbcYBLr0WIvw8LFXmrB4+RiDCQ+Ktz
   /I6d4/cDUhJ6/Ca77xesfHPF7dNTkLxF/UqwblgwBm+mrGJbaCQastlZa
   6RTgFQ9e/95QQ8mbD6Nc4kICC6y9VQu/C69HMEfLhQbmP8j7oHcF/X+Ca
   g==;
X-CSE-ConnectionGUID: V34VOu4kROqeAdWUnaGLhw==
X-CSE-MsgGUID: G6Rn9FgxQbCJ2rm+bi62gQ==
X-IronPort-AV: E=McAfee;i="6700,10204,11439"; a="67141054"
X-IronPort-AV: E=Sophos;i="6.15,302,1739865600"; 
   d="scan'208";a="67141054"
Received: from fmviesa005.fm.intel.com ([10.60.135.145])
  by orvoesa102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 May 2025 13:47:10 -0700
X-CSE-ConnectionGUID: 8GqulDXhQhKfeBgORVyHuw==
X-CSE-MsgGUID: FbtD2LVZRiKKhX0esKnMHQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.15,302,1739865600"; 
   d="scan'208";a="144671980"
Received: from orsmsx902.amr.corp.intel.com ([10.22.229.24])
  by fmviesa005.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 May 2025 13:47:09 -0700
Received: from ORSMSX903.amr.corp.intel.com (10.22.229.25) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25; Tue, 20 May 2025 13:47:08 -0700
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25 via Frontend Transport; Tue, 20 May 2025 13:47:08 -0700
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (104.47.55.42) by
 edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.55; Tue, 20 May 2025 13:47:07 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=r2OeChd9YAVqcJguUvEanYJjahlL5yeP++dPXp/MJwUJje69aYuFgnF82NcPdC4mvdsGTSprKT9spW5B/0jg4ta7P4iQPPVqEBx1Fz1M4XjujnH7km1Evh2lAwvQn8agJl4zZ0BkKVf2FmvfPMNvhziC98+3dBIRnWTIjE7+4VOJDkpqtERUeHjHMXajGFJfPqH7JOUBvYzBX2xbuG618JM34kygaH/FDLKqx49QkCJMWd/rfE5uCnZha9MB6yC2W0STTNPpa8Yk8n6oUOQxmjILKtHWffaWNoeSPHGMG10UppjO3IqaHahW+3bAubSmKrpjRnol3Q+XQ54HrMWrkA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Vq5NE7F41uzzHUof2dIXILA69FqOXawo/JJpGWmFIG8=;
 b=MvvvcvaBhFFPPfvz7xcc2ZeivdkGfWgDo3jcANAJLTC3RHB39xn1lFwL4Vq7Mz+eaiU6HrY9huqeCXi7J5yxVsmgcLDvmll1MH8C39JGmQzDZa6nqCsG5nQMLh7ih/ryhmrT6Diz0thLRtRFqv+Kg2V4rFJOxPJVKr550FV7e8GCswTsjC2izgU/X4iNLrbv8N7p49mM1DYOG160Wf3ZQhOmSebDfJDfgz22hJDWJm97svZpMa4+xqJGJZUaOv1gygwGjSyJ/VY8tMAhvB2+NULdqUK3cIt8zRF4UCAS/1xIWp3xK8oH73vDPtOcgOPkJK/9F8Nm2usXK1Ajy0kfdw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from MW4PR11MB7125.namprd11.prod.outlook.com (2603:10b6:303:219::12)
 by PH0PR11MB5095.namprd11.prod.outlook.com (2603:10b6:510:3b::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8746.31; Tue, 20 May
 2025 20:47:02 +0000
Received: from MW4PR11MB7125.namprd11.prod.outlook.com
 ([fe80::eff6:f7ef:65cd:8684]) by MW4PR11MB7125.namprd11.prod.outlook.com
 ([fe80::eff6:f7ef:65cd:8684%4]) with mapi id 15.20.8746.030; Tue, 20 May 2025
 20:47:02 +0000
From: "Verma, Vishal L" <vishal.l.verma@intel.com>
To: "lizhijian@fujitsu.com" <lizhijian@fujitsu.com>, "nvdimm@lists.linux.dev"
	<nvdimm@lists.linux.dev>
CC: "Williams, Dan J" <dan.j.williams@intel.com>, "Jiang, Dave"
	<dave.jiang@intel.com>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, "Weiny, Ira" <ira.weiny@intel.com>
Subject: Re: [PATCH 1/2] nvdimm/btt: Fix memleaks in discover_arenas()
Thread-Topic: [PATCH 1/2] nvdimm/btt: Fix memleaks in discover_arenas()
Thread-Index: AQHbxiF1UV4rW9nYXE2eyqMjMmRzFrPcBGcA
Date: Tue, 20 May 2025 20:47:01 +0000
Message-ID: <52333be1169e543561c0a55d614f3097373a652b.camel@intel.com>
References: <20250516051318.509064-1-lizhijian@fujitsu.com>
In-Reply-To: <20250516051318.509064-1-lizhijian@fujitsu.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.54.3 (3.54.3-1.fc41) 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: MW4PR11MB7125:EE_|PH0PR11MB5095:EE_
x-ms-office365-filtering-correlation-id: 50aade0a-d535-4aa4-4ecd-08dd97df78fa
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|376014|1800799024|366016|38070700018;
x-microsoft-antispam-message-info: =?utf-8?B?TitpcnJLZjF4ZUJhVXpGdzlmd1FuVWRwNFhrV0hLMGFNVk5TRngzRFlrTlo2?=
 =?utf-8?B?bzlKZjY3TCt0SitHREVyYkptd2xuS2laM1N1Uk5aaGMyY0dpVENjWGdPaDAv?=
 =?utf-8?B?ZFFKLzc2djg4SGFFbmNDWlVJWU5QaTIxNmNlbHRkN3FnM0cwM2JscmN6N29m?=
 =?utf-8?B?MWQ4aTRLdHpRYXRsNWEzdkE3ZUZtbUhFbE5NOEJCZnYwUVEzdUszcmJ1SWlp?=
 =?utf-8?B?amlTbVJmM0k3Q1doVkZ5MkVOYmpvbFJpWWY0WXJnZWZscjJRZ2ZvWFRESDJh?=
 =?utf-8?B?VjIxZWJJMDdRZzE4V1NTbk9LTkFlVjJUaXhzakljSkoxdkFiY01ySHJILyty?=
 =?utf-8?B?MmtRcllOMSs2cmpOU1Uwc1ZjODg3djFUaEhyRWdXN3RNdnhPQnk5UGpUTUVM?=
 =?utf-8?B?aFIyOVVMSXlOVmJJZmRONm1VdjdncEdRS2dsbXE5ZkNoRit4OVpFQlFoZWJC?=
 =?utf-8?B?dWh4Mm1Bazc0YjdiUlpmVXMxUmxXVklCT0Q5eXJNUk1nUjAvbmRBVzlrWGs2?=
 =?utf-8?B?dUJzUnoxWVljTGM0amdnVUczN1BNeElKYUdmL0drcGxCWnR0WFErUmcwdnA1?=
 =?utf-8?B?Znc5Y1I0ZFRzaE45cSsyT1B5VG5rR3E4NGFSTFRBaTNEUXlsMWYyY295cno1?=
 =?utf-8?B?bVczeFFwSnZLQytVR3V3bHJkNnJSNGhrZHF3NFM1YWtkbGx0TmdwN2JmTEhD?=
 =?utf-8?B?bVpnVnBkeWpQTnlyK3JlMGdFRzN4dG42V21QQkhGRmJqRkJkRmtvK2M1WVY3?=
 =?utf-8?B?NFlSOVdDTFlCSHpjdVJMS3J1amRkSU5CU0N0Tk9jTGRLaDNiZjhubTY2NG9k?=
 =?utf-8?B?cXVjRmpqKzBhRGw1a2pKNHpCcTYrWDRzbnFkRGlVT2xiVmlHVm0zdUpYQ3dh?=
 =?utf-8?B?eFdlOGhTNjRMYjgvelY5YXNCMmlUeGJHZE8vY3AxcFMra2hGQ0NzWVd6bHV6?=
 =?utf-8?B?aWNRdmJnM2VBMVNKVmdIKzd4L211VUYxc0sveTliQ0ZQZFh1WVd0RG51Znh2?=
 =?utf-8?B?MDhMY01rSk1MbnJZQWR4UWkvUkIrOHViZ0xua0ovdDJjbDVqZmVYY21JRU9l?=
 =?utf-8?B?N3UzN21PYTRDQXZTNVZ0WjcxbEFJS2xPVjJ5aWh0c1ZaU3ZuMCtNMjdEeVZq?=
 =?utf-8?B?bHFXQlczekRpYlZ5SUkxU3dXa1R5WDBLdmtMdEJ5WUNlUUtvRVBkcHFHN0NE?=
 =?utf-8?B?aDZ0OHpERmF3TTZNMHRLSnJPTEpseFdKd1REQTk1aGtvVUsrOGZaQVd4Tm4v?=
 =?utf-8?B?VU00c1JFMlRTU2E2VlBFT0VvTHh3Z1dpT1ZLZFFsUzczeDFaY0JwT3NNeHVj?=
 =?utf-8?B?VmlSR21sekUyQ0hVK2FySmdnNXFXZWtIQ0ZuWHZRalpQTXNtcnZkR2pQbmZr?=
 =?utf-8?B?QnB2azRPUW8vWGdnblpTQUMyTGM2dHVGeDd4TnFEb0J2amkyZUd6VlNlTFo0?=
 =?utf-8?B?b1dUNW9uNll0S3ZOenVEdEdydHh0aWliNHIvRzBCSzFBeE42M1pQL2ppTEZk?=
 =?utf-8?B?cXFOanUzNXhYK0ViUHVMV3F3Wkh5a2lkN21VY1JWc2kyK25OVmZLclNTUVV5?=
 =?utf-8?B?aUFLV0E4b012QjJwcUdPZUw5T1JaNnhRcjFUb0RSSzNUaWR3VmpaaFloWm5G?=
 =?utf-8?B?cm44Q0REUkJSeGFaMWh3a1FPSHBzSHAvRXlqcnpKa05KaWxhUUVsU2podWVO?=
 =?utf-8?B?Qk0wdExLanNGeHhqWmJFNGFvU1RURFg4dzRvQi8zTmw2aFVMMmd2d0N4QTlr?=
 =?utf-8?B?VytYY1JaUGxLSXRCV2xocEZtUFRCTVJjV0dRWjhHUE51Q1FDa3p0elUxbVZ1?=
 =?utf-8?B?YVRiVWgxU2ZwYTBZVHZrVWNZYW5zNHRTRGxBN2xkUDBwREdtVVVuRk9MTUxI?=
 =?utf-8?B?bFNPRG1jcmtuRzR1d2xWRWd4Zk9HQ1d3R1YydEFpRUNzMU9PWUU3SGZONnAr?=
 =?utf-8?B?QVJmTUNITWw5MnhSenNSZ2pjdHR1aTB3SDNZZU1GTCtPRnJsM2lJcE5reTFR?=
 =?utf-8?Q?Gbbo45lyzeKgTzSHZZpwDAwm6L0mrE=3D?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MW4PR11MB7125.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(1800799024)(366016)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?K1hpM3dYVk16NldvM0o4aU9Cc25xTXUwNFRJNWhLLzltOVovakxTY1BkZzRh?=
 =?utf-8?B?NGE4bkVCZ2JqYXQ2Z3NvNW1OZnBLY2Y1bk5xU2pCVzc5SmsrTkNJYmdZK0cr?=
 =?utf-8?B?eGpRNDVQbkFoVFpXUkNObDdvTy9GYVowVmZuQ1JVMTJNeUtIVHJ4WE5QdVNo?=
 =?utf-8?B?UjFTTGtkUWw5bUhMNDlhVU1wUHhyVDlvd2h3M3dpbmhjbTJUdnFGQTUzeDc4?=
 =?utf-8?B?NEFza1YrTHdwM2d1a21DcVNxOWNJZkhLUEZDWll1eUFQUzhDTWxQSzg3NGdp?=
 =?utf-8?B?QmRIZ2tEZDNOcFdTMFJITENJTVk4SmlZL0ZCZm1TVGJLT3YvUUN2MHBpRVhu?=
 =?utf-8?B?TmZzMEduMU9XaGJjdEsyN0RtM2VtKzkvZ1NENzFRbFVyWWNDWFdha2dhbi9I?=
 =?utf-8?B?RUM3NEhoZ0dUSlpWaWpqbEZmRC9GWE1lWVcyZjd1dlcyRGhLY2xudWFXaHV3?=
 =?utf-8?B?elBRTGtJUG9DWk5aSXJoL1J0YTdmekJ0c3hobFIrVEcxQThITHdHMVFGVXoy?=
 =?utf-8?B?dmNLRWNTc0dsa3NmOUZ6RFBYcG1Sc0xOUUt1cFAvT0pjSFR2QloxbHJzVTRS?=
 =?utf-8?B?YTZManN4bmYxSDJXbDNtcEFuc2owRENWQm8vbUVQM0pzSk8raW03dGpzZ3E2?=
 =?utf-8?B?NXNKdGZsQjRsKzlYdzZUbmsrRzAzck5YL05UNEJaL0N6eDJiNWMyL2JRSTdB?=
 =?utf-8?B?Q2xyaUxVeGIrRDRQR1dlVUhFUFlOK2RjL1ZXb2pUMVdjdjZ0R2tOQUNlc3VS?=
 =?utf-8?B?Y0JENTREYkFudGNybFZ4TngvWXhQNXdUTlRpeTEvbGF4b2pmWFhQM3grYUoz?=
 =?utf-8?B?RmNFVDl5RnhGcnFDV2pnWWc5RXZEaUdmc3FHTlVldXlDOHZzd2tqdXgxK01s?=
 =?utf-8?B?aFRpSmN4V2VRYWZpbWhBRFVlNmJFY2U2ck9pbEI5K1YvVlNqbEdldTluWVJB?=
 =?utf-8?B?RG9NS052UkUwbEN2WTBnSHRvdFZQK25LdG1reUZzRmIxM2w2anFYN1g0NjBw?=
 =?utf-8?B?NzdwbVJQZyswK3E4SVFSaGpnMDhlamp4K1doQzZZV1A1bU1jVEtiUVppQzZI?=
 =?utf-8?B?d05jOWhqM2RUMHBDMzRMM3g5WWxYc2poaDB1SjVoZGx5OEozRFB2S2IzZTZ5?=
 =?utf-8?B?bmUzaHhnMXI3ekk5M0IxdTFSaU9yY01UUm91SFFKZG9QbmIrdnhUViswbHRQ?=
 =?utf-8?B?VDRqM2k5V2tUSFBSYWxLaWNNdTV5b2NRd2U1ZGVxU0VQQ1lpaHp5ZXlHMUVq?=
 =?utf-8?B?QkM1YTRaRHRnT09paWl4aFJoeldnZExpdXhpdjdvNUtYUFppWU1UL293eS9k?=
 =?utf-8?B?RE83NlVRT1RVNkhOZFNtRUE0ZHlpQ3M2Z3RpRDFaenJ1aEVyRWNBQjNDZk9a?=
 =?utf-8?B?SlV3ZTlWNkhoUUFnUEg4MnpucWpaTDI4b3luYkN0ZEIxZ0hYS1VkRjJnRFk4?=
 =?utf-8?B?RndsYnhzbXdvbHZ3V1FwZk03aU0wMWE5cEJXbnJRVm5Ja1l5YytXZWJkbk5V?=
 =?utf-8?B?TWZibVNsUTgyRmpDK2kvUU0zRCsyR0NPenBONmp4THFOK1ZCbkJrbXEzeHVL?=
 =?utf-8?B?Y2E1ZWM2YzVSOTF3Nk5aN01ZamFrN1pESzlvenVaa0Z1REpSS2x4QWNBdjdt?=
 =?utf-8?B?bGtMMFE3QWRDNnlKK3VKb0hreEJrRmV0RG9TeXRmQ0JvemdWcE02VDNvTHRi?=
 =?utf-8?B?ZzJ1OXgvclpNV2lvZHhuTUtRcXN6U3VXdzBmMlB1Rm9nMCtoVmRHaW45bnRm?=
 =?utf-8?B?Nk56RjBGRnJKL3EveXhhOGFkc0EvOVh5bkI5OGJZOWk4RnpJaXJlbms2ZVFF?=
 =?utf-8?B?cXZodjg1U3hEdVVNelVmR01jQldXOHpWV0x1THk3UjlWb1JtSzhrQk83Vm5Q?=
 =?utf-8?B?N1FUQWdtNWlxZ2I3MnM1NTV5NEVOc3h2K3pkVWszSW8vbEpNeUNkRDBwdkd4?=
 =?utf-8?B?V3NXUzRvZlNYYlpub3dudHJsVXdMS1RsaTlNMDFpdjlDcXdYangzc3NDQ2lQ?=
 =?utf-8?B?eUgxTEdscjUrbzhvTjlMSldoZ21PM1k0c1BwbS9MSzJXeWN0clA1dVQ2MXBx?=
 =?utf-8?B?aGFPZTVJUVBtcUlIZEs3VWJJSjhUSk0vQzhBeTBDaFdKaTFMeHJlNUIxQzZZ?=
 =?utf-8?B?WHVaclBnUXFVSTJDWkhuUk9VaVE3VXNuUFE1NlVDK3NsVnI3ZzIzbDY3Ullu?=
 =?utf-8?B?RFE9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <EB28971CECEE244AB80A9DD2C92514AB@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MW4PR11MB7125.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 50aade0a-d535-4aa4-4ecd-08dd97df78fa
X-MS-Exchange-CrossTenant-originalarrivaltime: 20 May 2025 20:47:01.9590
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: ro5f30jaIUOizEgDy34RgWCYIkAdOTneetXslsO6yMQoFE0pf3Fl1GF3B3EQ/RUkBPyjqn/T/e2Eyb1LBxW4l2rdnkjImfg9N5nWsSp19wY=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR11MB5095
X-OriginatorOrg: intel.com

T24gRnJpLCAyMDI1LTA1LTE2IGF0IDEzOjEzICswODAwLCBMaSBaaGlqaWFuIHdyb3RlOg0KPiBr
bWVtbGVhayByZXBvcnRlZCBhIG1lbWxlYWsgYWZ0ZXIgdGhlIG5kY3RsX3Rlc3QNCj4gdW5yZWZl
cmVuY2VkIG9iamVjdCAweGZmZmY4ODgwMGU2Y2YyYzAgKHNpemUgMzIpOg0KPiDCoCBjb21tICJt
b2Rwcm9iZSIsIHBpZCA5NjksIGppZmZpZXMgNDI5NDY5ODY5MQ0KPiDCoCBoZXggZHVtcCAoZmly
c3QgMzIgYnl0ZXMpOg0KPiDCoMKgwqAgMDMgMDAgMDAgMDAgYTAgMGEgMDAgMDAgMDAgYjAgYjQg
MDAgMDAgYzkgZmYgZmbCoCAuLi4uLi4uLi4uLi4uLi4uDQo+IMKgwqDCoCAwMCAwMCAwMCAwMCAw
MCAwMCAwMCAwMCAwMCAwMCAwMCAwMCAwMCAwMCAwMCAwMMKgIC4uLi4uLi4uLi4uLi4uLi4NCj4g
wqAgYmFja3RyYWNlIChjcmMgODA3ZjNlMjQpOg0KPiDCoMKgwqAgX19rbWFsbG9jX2NhY2hlX25v
cHJvZisweDMzMS8weDQxMA0KPiDCoMKgwqAgbnZkaW1tX25hbWVzcGFjZV9hdHRhY2hfYnR0KzB4
YTliLzB4Y2MwIFtuZF9idHRdDQo+IMKgwqDCoCBwbGF0Zm9ybV9wcm9iZSsweDQ1LzB4YTANCj4g
wqDCoMKgIC4uLg0KPiDCoMKgwqAgbG9hZF9tb2R1bGUrMHgyMWY5LzB4MjJmMA0KPiANCj4gZmFk
ZHIybGluZSB0ZWxscyB0aGF0IChiYXNlZCBvbiB2Ni4xNS1yYzQpOg0KPiAkIC4vc2NyaXB0cy9m
YWRkcjJsaW5lIGRyaXZlcnMvbnZkaW1tL25kX2J0dC5vDQo+IG52ZGltbV9uYW1lc3BhY2VfYXR0
YWNoX2J0dCsweGE5DQo+IG52ZGltbV9uYW1lc3BhY2VfYXR0YWNoX2J0dCsweGE5Yi8weGNjMDoN
Cj4gbG9nX3NldF9pbmRpY2VzIGF0IGxpbnV4L2RyaXZlcnMvbnZkaW1tL2J0dC5jOjcxOQ0KPiAo
aW5saW5lZCBieSkgZGlzY292ZXJfYXJlbmFzIGF0IGxpbnV4L2RyaXZlcnMvbnZkaW1tL2J0dC5j
Ojg4OA0KPiAoaW5saW5lZCBieSkgYnR0X2luaXQgYXQgbGludXgvZHJpdmVycy9udmRpbW0vYnR0
LmM6MTU4Mw0KPiAoaW5saW5lZCBieSkgbnZkaW1tX25hbWVzcGFjZV9hdHRhY2hfYnR0IGF0DQo+
IGxpbnV4L2RyaXZlcnMvbnZkaW1tL2J0dC5jOjE2ODANCj4gDQo+IEl0J3MgYmVsaWV2ZWQgdGhh
dCB0aGlzIHdhcyBhIGZhbHNlIHBvc2l0aXZlIGJlY2F1c2UgdGhlIGxlYWtpbmcgc2l6ZQ0KPiBk
aWRuJ3QgbWF0Y2ggYW55IGluc3RhbmNlIGluIGFuIGFyZW5hLg0KPiANCj4gSG93ZXZlciBkdXJp
bmcgbG9va2luZyBpbnRvIHRoaXMgaXNzdWUsIGl0J3Mgbm90aWNlZCB0aGF0IGl0IGRvZXMgbm90
DQo+IHJlbGVhc2UgYW4gaW5pdGlhbGl6aW5nIGFyZW5hIGluc3RhbmNlIGFuZCBpbnN0YW5jZXMg
aW4gYnR0LQ0KPiA+YXJlbmFfbGlzdA0KPiBpbiBzb21lIGVycm9yIHBhdGhzLg0KPiANCj4gU2ln
bmVkLW9mZi1ieTogTGkgWmhpamlhbiA8bGl6aGlqaWFuQGZ1aml0c3UuY29tPg0KPiAtLS0NCj4g
wqBkcml2ZXJzL252ZGltbS9idHQuYyB8IDI2ICsrKysrKysrKysrKysrKysrLS0tLS0tLS0tDQo+
IMKgMSBmaWxlIGNoYW5nZWQsIDE3IGluc2VydGlvbnMoKyksIDkgZGVsZXRpb25zKC0pDQoNClJl
dmlld2VkLWJ5OiBWaXNoYWwgVmVybWEgPHZpc2hhbC5sLnZlcm1hQGludGVsLmNvbT4NCg0K
