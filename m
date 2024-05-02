Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AA7A357C85
	for <nvdimm@lists.linux.dev>; Thu,  2 May 2024 21:50:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.12
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714686623; cv=fail; b=CwltKwkDPeH0SvsHp63rQtQyFpabkM6dFyPvGpYI1SYFCj/SCG7vBc7kVgaDvDR+gR6wyINNqplWUtgDICRkZFiIrY0VlZkM1DqaMqHv8jPmIIunZeUpuHhQhb7iHKMGKqZ4zNEkEumHymBOn11zzfF5nQu7dmf54HU52Guh4YY=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714686623; c=relaxed/simple;
	bh=kKiF3Uw4XCc46jAugjY+44xJeM1Oi2gqra2I+VJYETM=;
	h=From:To:CC:Subject:Date:Message-ID:Content-Type:MIME-Version; b=LTlXXAa2Xxn4OIuCOyegQom4cXn/WtcPE9u+jgQefJb06Pl/42mSwikcKr2nTQ2P29cm5kiVlwDe/bFJ4AS5d8Rocec7l4hIo5SZhD6hFzyyNI96KGag29LojVEPy3pQm3Ri0fyEUqRqPz/97vMSUUCEFM2Kjyci4hUZjiz7+9s=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=Ex3kxDsZ; arc=fail smtp.client-ip=198.175.65.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="Ex3kxDsZ"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1714686621; x=1746222621;
  h=from:to:cc:subject:date:message-id:content-id:
   content-transfer-encoding:mime-version;
  bh=kKiF3Uw4XCc46jAugjY+44xJeM1Oi2gqra2I+VJYETM=;
  b=Ex3kxDsZS9GuhCahruRj/LIEfX8vhYwkLJ2kanDPRNCrsnvWBtNu8iu3
   7YRtJStcEGp1GeqTftH5iM9rnRF1fzTtheMRii5wBviWl5QMjuNVWmmJ2
   LPhfqmWH+JRO0SoF5SHU4Qvc0AuEEPluZtyLwjYPS/bAuC1rfTMYaBBhr
   hvgtKUjrMZqdMNZ3m/+8KZeZ5jF6SfDDMMOLIVvWzcVTEqgpCLZyx3eRr
   qwJKuVdmWhDvrgoCpMxzejt70H5bBb+vw4v0irl80Mr3qOfLyRZMx+JY5
   Di5gXkpW4YiiEcD6v1iKZCNfEVl0d6kXtgp1OWUkxOCSZ4fD21s9QDWA9
   Q==;
X-CSE-ConnectionGUID: aAYzhOtPQm63oMb9b5bC9A==
X-CSE-MsgGUID: /PdPLL4iRU28TjLcuwTGNQ==
X-IronPort-AV: E=McAfee;i="6600,9927,11062"; a="21898372"
X-IronPort-AV: E=Sophos;i="6.07,247,1708416000"; 
   d="scan'208";a="21898372"
Received: from fmviesa010.fm.intel.com ([10.60.135.150])
  by orvoesa104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 May 2024 14:50:21 -0700
X-CSE-ConnectionGUID: rTXXxpSVTSyHy5vkgKI5Vw==
X-CSE-MsgGUID: wc1JusaWRf2ik03j1FoaSA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.07,247,1708416000"; 
   d="scan'208";a="27342352"
Received: from fmsmsx603.amr.corp.intel.com ([10.18.126.83])
  by fmviesa010.fm.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 02 May 2024 14:50:21 -0700
Received: from fmsmsx603.amr.corp.intel.com (10.18.126.83) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35; Thu, 2 May 2024 14:50:20 -0700
Received: from FMSEDG603.ED.cps.intel.com (10.1.192.133) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35 via Frontend Transport; Thu, 2 May 2024 14:50:20 -0700
Received: from NAM02-DM3-obe.outbound.protection.outlook.com (104.47.56.41) by
 edgegateway.intel.com (192.55.55.68) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.35; Thu, 2 May 2024 14:50:20 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=h2WNYoFbOpdZP+alqSbZfe84jmRLxF6Bm0LFBw/h/e/5Ka38/Guc/1hIUht3mNtU0mXRtPVLPsoMMD+eflLKAJhYtQIyQJrEdtwiF0iux+doUX1HiRgv+z/7ngQ/jvr+X75jINYbBIXnbAsF6usgrvTlAAPkUPBJOifuDwuxn23j4U+ugNrP2/lb3NEh32YegS2hv+yP54EBd+lL0lS4b9yDVzxVyRW0rtLyQuBEA6clegefRCy4S90yF75CEY5n6Wby5ycxKx16VaWJ7OKXvAsPPW9X6/+ntIEnUpRP1lpYupJ65gy9t/RCxWHlzmQKPj18lMZxfOFIUS31VYd+Xw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=kKiF3Uw4XCc46jAugjY+44xJeM1Oi2gqra2I+VJYETM=;
 b=YBpFTIpxttYosqzHSJMiAWbcGbWp8AjZOj3eKMEoi9+OeEfD3T3r3rR/dA7Qy2siQsTSo+WcniHUcK8aPET6I+wzJUOFVUjNq7T9dIQrQ5PlNWKxaJLdn9+Q/ICPDsx7kWAzKBlAzfnUFQ9PG9xZCYwvkIBJ4xNuXB3xxC2PoZwBgab2zUaCp9uEHvPI0uOq80zgaCXAPNoqFQjBVwBlOrMOMhaJ41z2cb9BE3CBpCP2J7+uMtxrpA+wWsyFdTxnRzMuXrPxLGUwsJaAjYQziPB5rxUepUfnwF5YzAGxA/D+OMxIMAivDt+MDv3PlOnS4h6HSH0JOYb7wf3zLJvh5Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from MW4PR11MB7125.namprd11.prod.outlook.com (2603:10b6:303:219::12)
 by MN6PR11MB8102.namprd11.prod.outlook.com (2603:10b6:208:46d::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7519.35; Thu, 2 May
 2024 21:50:16 +0000
Received: from MW4PR11MB7125.namprd11.prod.outlook.com
 ([fe80::ed72:f69c:be80:b034]) by MW4PR11MB7125.namprd11.prod.outlook.com
 ([fe80::ed72:f69c:be80:b034%4]) with mapi id 15.20.7519.031; Thu, 2 May 2024
 21:50:12 +0000
From: "Verma, Vishal L" <vishal.l.verma@intel.com>
To: "linux-cxl@vger.kernel.org" <linux-cxl@vger.kernel.org>,
	"nvdimm@lists.linux.dev" <nvdimm@lists.linux.dev>
CC: "Williams, Dan J" <dan.j.williams@intel.com>, "Schofield, Alison"
	<alison.schofield@intel.com>
Subject: [ANNOUNCE] ndctl v79
Thread-Topic: [ANNOUNCE] ndctl v79
Thread-Index: AQHanNq11gJ677uui063wRVnqmifWA==
Date: Thu, 2 May 2024 21:50:12 +0000
Message-ID: <72bdf880b2cafd42163638d9e7e1d848c1d2d3a9.camel@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.50.4 (3.50.4-1.fc39) 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: MW4PR11MB7125:EE_|MN6PR11MB8102:EE_
x-ms-office365-filtering-correlation-id: fca57669-5755-4474-cdec-08dc6af1d840
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230031|366007|376005|1800799015|38070700009;
x-microsoft-antispam-message-info: =?utf-8?B?YjlUUmNSK2xkNzFaY2J1aVFQeXdZS2NJVTBGSUZhVHBiTXFoRDBhaFl3QW5T?=
 =?utf-8?B?RWcyZU5hend6VGxGUmF2V2ZWOUhTMDNhY084dlQ0SlAzdWhaV2JSd3NUQmJ2?=
 =?utf-8?B?U0VCdDJaUFJ3bk1FZXVZdU1XcGlkZGRvTnZydjBWVWptRGJPTlAxQ0V6YkZR?=
 =?utf-8?B?L2Rtam94azRZeVo4VVJiM2l3U2ZaM2dpZldLYzBCLzBVVSt3bFFBMzU3UndB?=
 =?utf-8?B?SHZzR1NleHhtQ0x6SlRHQzdXRFYwN3FVVVdPdFdxMkJkQW5vL2NjbXNkZU5a?=
 =?utf-8?B?REdLY0hlWGZOWEtFUStMUExnaGE2eG1Ob1p3ZC9VbVhDaWJ3NFFINGc0N0NF?=
 =?utf-8?B?SEVjYUpnMEpYdnVqYjI0K2VjeXF0c2lTWndncW1MbTJFZ0ttTnd1eUZkUVRH?=
 =?utf-8?B?RXF3R0ZmbUJoWXd5NXQvQzBWeVNtc2VUajdaTVBoaGR2eDF3dnNLSkhFQUZV?=
 =?utf-8?B?MExnOVl5TlBucEcybXhhTmhMYWp1cWxZTTNDdmY5WkFtbHNaUWphTjZ6SlIz?=
 =?utf-8?B?eFNCbUpkREpibWtIOGEzL0Y0aGM4NDdXUktxS0J5NjFhbVpEeGZOQlNxaXhN?=
 =?utf-8?B?SktZSHQxS2RxSnQzN3JWc01FNlV4Z3JUU2JOTFJvMGtPSTJPTENUaDRxV0Vl?=
 =?utf-8?B?bHJ4QTRtYzhJNmVzWGVYeTFvaHdUMDNCWXVXSFpsZ2NTeFo0M0VBRExrQW12?=
 =?utf-8?B?MUJqUVhxeVJhakRhVDIxM3hpb3lWeHQ1STVDVlRrc081NDlpMnAxdmxiRUtH?=
 =?utf-8?B?U24zUVZsYkE1WGJ0NjZOVC9YOXRHUDE3QTRXSTB6aVE1aFZNNmFxUmFVSVFj?=
 =?utf-8?B?aS91dUxhVkZPUUd0UWpqQTBockUxTFgzL0JvQVJmRHRPMGlOYmlkUkJRbWtN?=
 =?utf-8?B?cGpCSWJDZVA0bFd2SEdCekEzcXRFZ2VsbjJQbXFNcmhNaC8xQmRxQjh3TXpI?=
 =?utf-8?B?bCs2MVVxY256amluOXYyM1hpTkNnTUM1NlQ2SURmdEJPV2xHdHVQbjc2TDUw?=
 =?utf-8?B?cU4ybEhtaXgyRXhuOHlxOXNveWo4UGxTZ0VVejdRM2IwTjFFcEpkNHJvWmpS?=
 =?utf-8?B?VkhTaTNmQU5vYmpsV3VvdnE0eVZkUmNMajFOZ0txY0Fsb2NrWVIwY25Gak1t?=
 =?utf-8?B?LzJBUEVoTlJoT1FjZlhQWHgxdWtCalpkYVhibXEyWHJYS21KZmZzTlQ3M1FD?=
 =?utf-8?B?ZXZ2a0tid2tiN1gxOWpucGdKc2Q0bHdDTG8rd3oxcnQvbnNKVGxURGQ3a01I?=
 =?utf-8?B?V3hlcnZhVWtpdjFZYXBUZ0I2Y0FDaFdOVmNKZjYrOVZ1ZzFidEM1VEdtYmN5?=
 =?utf-8?B?TjJBajJGVklGWVJOV09PNC9CaGRkbU5rY3A5TmJJcjluK1ZBQ1RXMkRONUJY?=
 =?utf-8?B?NkhqTHB5UmtYbEJTTXU5dXpKZWo1cXRQVitkVWZSR1RJVEN0aFAyRmhSazBS?=
 =?utf-8?B?Vm1mZTB6alNINDQ1ekozOUc0UCtvczloVjRlVkdYd3dyZGcyaUNjWXNKYmpI?=
 =?utf-8?B?aVRKYTRIejFVS2tvM2NmcVdlWXB5a2UrMTI1clhuWnE4VE56U3FnUzUvdEd4?=
 =?utf-8?B?MkU1TytpRnNuejlkVlZ2SUI0dVlLWFVocGx5QysxNE01aEJER3RmYXpaa2NS?=
 =?utf-8?B?dTRKL0R0eWJDVkFGNkFDUWg5c1pHZVA5V0p2b3liYmtoZDkrZ25lZzh5N25o?=
 =?utf-8?B?NHo2dE00RnVDRDM5YXlUeFN0Y1FtcDBoaCtPQVhkYmJYWUQyV0FLK3RDOEcv?=
 =?utf-8?B?TE9ZeWVlZlpMQmwvcURRVEhBV1p2MkcrTkJWUU9xMEgvTzZndnpKL0JteDNq?=
 =?utf-8?B?MkhIUFZUenVoR1ZRRHl3Zz09?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MW4PR11MB7125.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(366007)(376005)(1800799015)(38070700009);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?elFxNEZxeCtaNE13SmVkbXlXQ3Y4VTkzSE9XbDJhL1pRUFUxM3RJS2hGc3di?=
 =?utf-8?B?eS9mYWp1UFpoV0lwa1h6TXJZbnBZdHdieUNGc1M1UDU4YnlsT2RPL1dLaHFO?=
 =?utf-8?B?dEFwSEF0VHc3dUZEdWcrV0VrL25FSHViQTM2c1p0VG5pMi90OEhnNklQbVpZ?=
 =?utf-8?B?c1Fnc3A2OFBFYUxicEQwZ1ByKytrZisvNkJYNzVRZUhWMTVvYTI2TFFsZDdL?=
 =?utf-8?B?Q3k0dGo3WVAzUVd4OWZzZDFMQkZtZzNwNEE4UTJrdGxOc2x4bmFEOGFMK3ZJ?=
 =?utf-8?B?ZEFESU44QmY0Vjd0c3AxWnQ0R3QwMjg0a0RIME1uNXc2SmlTMC9GMEJDWEQ3?=
 =?utf-8?B?cis3cCtTNHFDTUtKU1R2ZDA0dmlHTEwrTjNodWdaY0tYcG1HUHV5VlI1b2FZ?=
 =?utf-8?B?dW5yL3lIVmdPTEt5c3hZZm96bVhBVUhZM1ZLc3ZUL1MwaFd3TlJKSGZ1Nnlw?=
 =?utf-8?B?amhMcGVCTnJodlp2RUZ5NmNYNVRsSFJJSVJqaW8valNlWE5JeEZpOEZ6VE5n?=
 =?utf-8?B?SkNHYllQWVJpS0NRLzV2ckRXclNKT1dXM1FrNVBSVC9SWUUzMnZMV1c0WGlL?=
 =?utf-8?B?QW5wL1lrZXdWcGI3em9JUEFpRnJ2Qk56TXVHZTRrSmxiVWhTNTNPY1hUVlNF?=
 =?utf-8?B?Tjc0c2M3djNIYnBESm96SVhVK1M2bTNRdFJwU3FMWThrMXJ3dlNzZTVldFBz?=
 =?utf-8?B?UmdoWEJLWXhNUjI2NGlyakYxaEYycGhXbkN4VmtVL0ZPdzJPMExpcStDT2VM?=
 =?utf-8?B?czlxcHJBZ1dPSmsrQ2pSMkNXb2hTOTdhZ05uZWttUUZwWFE4VmVYS0g5Z0hy?=
 =?utf-8?B?a29IdVRXUWpwTzg2WVJCT003dmYvNkJMZmlWN0s4OUpRM3N0Rmp4QUpKNTFt?=
 =?utf-8?B?dTB5bHNzQVZmeEkxS2RzbGZ4YnM2b0tla0c4cE1ZVlQ1NnpCQXVpTWJKczFa?=
 =?utf-8?B?aXdWcFcrZ2Q3aEZpay9ZT2hoWnRoUkxiNStySiszamhFS01hN1ZMT25nSVVm?=
 =?utf-8?B?MTZIU2dhYnNGYzF1SUV3Unk3aUJXQWl5RHdkMU83VGxmKzZVbmlnSDJKMENJ?=
 =?utf-8?B?NWNMRnI2VlZmaGtTYVovZ0hFdVN2VjBYWGJxOGxyYTZjVTVxL3BPZjJaeGJL?=
 =?utf-8?B?UTEwS0txYlJGOHFTMGVNM3A5S3ZqV1VjUmNNNWhQR1lqNjhNbWxtZkpzZ3lm?=
 =?utf-8?B?Z0VqU01LVm5zRkxEL05uUDkwaEpISlorcU5nSGFiQ1k4NG1MVXlxUHFEM1lO?=
 =?utf-8?B?aEhUQSsvQ3d3TmF1b1RPb3BzdTN0RjF0N0hoZFhCbWd0WG9kY2JFMUpxWmFk?=
 =?utf-8?B?YW8vY1hQcEcvUzZzUDFDV2t4QmtFT05ib3ZnNERjeVpxR2tMTFlGd2NmaTlZ?=
 =?utf-8?B?cktvWnY3ZlJtMElDUHR0RnN1NzNCeEROdFVTVWt0MDVJcU80bytmb0xHcTlR?=
 =?utf-8?B?a0M1SmFnTStXMllBQlQrNkhKL2hvQkhxQ0ZCZmdvUzdhTEpvSlljWEs5ZEJy?=
 =?utf-8?B?RExQTkZ6bTY0QkNsaDM5Y2ZBQjQ3eFYyR2tSSGQ0Wng4UUJVVEVnVzFlL055?=
 =?utf-8?B?MkpCZGhIR1lpZ2NROXNWNTBZclpWb2orSjR1cjJoQXZ2cWNsMHhpSTQvT2JY?=
 =?utf-8?B?ZEJNR1VQNFgzWGVnNEo1ZjZ0aVdmTWw4QlhyL0NTWkprV1FmZlJhM1VjNHg0?=
 =?utf-8?B?RmNKQW5GVytJOTc3ZnBXTzAzYyt0aDZRUlArbmJaNnZLMVlSNENxaXJZNjJk?=
 =?utf-8?B?ZWZrMHhZWDdBNXhaZzIzQWJvWnZISm1YTndoeXR5QiswbXhZWE5mUnJIZTl4?=
 =?utf-8?B?Q20wY3RrM21VVGxaVGs0S095bnNoVHlMaXdwd2xIbmo0TTVhcWp5azIzTUhJ?=
 =?utf-8?B?QkZ3Ui92K0ZoenVIYVZrM1ptcHNMdG9VT0p6QWNxcGVKQU9MN24yK3ZqY3cw?=
 =?utf-8?B?QzRrVUF6VGtaQmc2eHlqMDBuZ0tHN0JQMmxxYUlTdFFnS3hzcjdsNXM3cE9l?=
 =?utf-8?B?UFpZZmNLRlB1TWhzWDFtWG1lZmxFRHZaclhMdTQzcit2WjdkZnBhS3NjRXlS?=
 =?utf-8?B?d0tXZjdEUWJSdHlBVDFXSHBtTGVweUt5M0lrWTB1MnVhWHFuRHM5WEdldFdZ?=
 =?utf-8?B?M1BxSzRhTmJLeWZkYWdMNVBVWGpsamdaNXQvNzB4TkZORnFVNTUyNVlQWXc0?=
 =?utf-8?B?TWc9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <9D812C4E4DD4D3448211A8AB71E8C950@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MW4PR11MB7125.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: fca57669-5755-4474-cdec-08dc6af1d840
X-MS-Exchange-CrossTenant-originalarrivaltime: 02 May 2024 21:50:12.6941
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: CRkS2/MOrEUEdgYYL7IudIyAmcSuhFubcENNYPA+g1kAMOw+JfTTNuWxmU7zWlAGXwyjwOw9IJc3shtiiPUEpDbBZdVerNGuGePW3MzVFTQ=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN6PR11MB8102
X-OriginatorOrg: intel.com

QSBuZXcgbmRjdGwgcmVsZWFzZSBpcyBhdmFpbGFibGVbMV0uDQoNCkhpZ2hsaWdodHMgaW5jbHVk
ZSB0ZXN0IGFuZCBidWlsZCBmaXhlcywgYSBuZXcgY3hsLXdhaXQtc2FuaXRpemUNCmNvbW1hbmQs
IHN1cHBvcnQgZm9yIFFPUyBDbGFzcyBpbiBjeGwtY3JlYXRlLXJlZ2lvbiwgYW5kIGEgbmV3DQpj
eGwtc2V0LWFsZXJ0LWNvbmZpZyBjb21tYW5kLg0KDQpBIHNob3J0bG9nIGlzIGFwcGVuZGVkIGJl
bG93Lg0KDQpbMV06IGh0dHBzOi8vZ2l0aHViLmNvbS9wbWVtL25kY3RsL3JlbGVhc2VzL3RhZy92
NzkNCg0KDQpBbGlzb24gU2Nob2ZpZWxkICg4KToNCiAgICAgIGN4bC90ZXN0OiByZXBsYWNlIGEg
YmFkIHJvb3QgZGVjb2RlciB1c2FnZSBpbiBjeGwteG9yLXJlZ2lvbi5zaA0KICAgICAgY3hsL3Rl
c3Q6IHZhbGlkYXRlIHRoZSBhdXRvIHJlZ2lvbiBpbiBjeGwtdG9wb2xvZ3kuc2gNCiAgICAgIGN4
bC90ZXN0OiByZXBsYWNlIHNwYWNlcyB3aXRoIHRhYnMgaW4gY3hsLXhvci1yZWdpb24uc2gNCiAg
ICAgIGN4bC90ZXN0OiBhZGQgZG91YmxlIHF1b3RlcyBpbiBjeGwteG9yLXJlZ2lvbi5zaA0KICAg
ICAgY3hsL3Rlc3Q6IGFkZCAzLXdheSBIQiBpbnRlcmxlYXZlIHRlc3RjYXNlIHRvIGN4bC14b3It
cmVnaW9uLnNoDQogICAgICBjeGwvZXZlbnRfdHJhY2U6IHBhcnNlIGFycmF5cyBzZXBhcmF0ZWx5
IGZyb20gc3RyaW5ncw0KICAgICAgY3hsL2RvY3VtZW50YXRpb246IHRpZHkgdXAgY3hsLXdhaXQt
c2FuaXRpemUgbWFuIHBhZ2UgZm9ybWF0DQogICAgICBjeGwvdGVzdDogdXNlIG1heF9hdmFpbGFi
bGVfZXh0ZW50IGluIGN4bC1kZXN0cm95LXJlZ2lvbg0KDQpEYW4gV2lsbGlhbXMgKDMpOg0KICAg
ICAgY3hsL21lbWRldjogQWRkIGEgd2FpdC1zYW5pdGl6ZSBjb21tYW5kDQogICAgICBjeGwvdGVz
dDogVmFsaWRhdGUgc2FuaXRpemUgbm90aWZpY2F0aW9ucw0KICAgICAgQnVpbGQ6IEZpeCBkZXBy
ZWNhdGVkIHN0ci5mb3JtYXQoKSB1c2FnZQ0KDQpEYXZlIEppYW5nICgxMCk6DQogICAgICBjeGwv
cmVnaW9uOiBBZGQgLWYgb3B0aW9uIGZvciBkaXNhYmxlLXJlZ2lvbg0KICAgICAgY3hsL0RvY3Vt
ZW50YXRpb246IENsYXJpZnkgdGhhdCBuby1vcCBpcyBhIHN1Y2Nlc3MgZm9yIHhhYmxlIGNvbW1h
bmRzDQogICAgICBjeGwvcmVnaW9uOiBNb3ZlIGN4bCBkZXN0cm95X3JlZ2lvbigpIHRvIG5ldyBk
aXNhYmxlX3JlZ2lvbigpIGhlbHBlcg0KICAgICAgY3hsOiBTYXZlIHRoZSBudW1iZXIgb2YgZGVj
b2RlcnMgY29tbWl0dGVkIHRvIGEgcG9ydA0KICAgICAgY3hsOiBBZGQgY2hlY2sgZm9yIHJlZ2lv
bnMgYmVmb3JlIGRpc2FibGluZyBtZW1kZXYNCiAgICAgIGN4bC9saWI6IEFkZCBBUEkgdG8gcmV0
cmlldmUgUW9TIGNsYXNzIGZvciByb290IGRlY29kZXJzDQogICAgICBjeGwvbGliOiBBZGQgQVBJ
cyB0byByZXRyaWV2ZSBRb1MgY2xhc3MgZm9yIG1lbW9yeSBkZXZpY2VzDQogICAgICBjeGw6IEFk
ZCBRb1MgY2xhc3MgY2hlY2tzIGZvciByZWdpb24gY3JlYXRpb24NCiAgICAgIGN4bDogQWRkIGEg
dGVzdCBmb3IgcW9zX2NsYXNzIGluIENYTCB0ZXN0IHN1aXRlDQogICAgICBuZGN0bDogY3hsOiBS
ZW1vdmUgZGVwZW5kZW5jeSBmb3IgYXR0cmlidXRlcyBkZXJpdmVkIGZyb20gSURFTlRJRlkgY29t
bWFuZA0KDQpJcmEgV2VpbnkgKDQpOg0KICAgICAgdGVzdC9jeGwtdXBkYXRlLWZpcm13YXJlOiBG
aXggY2hlY2tzdW0gc3lzZnMgcXVlcnkNCiAgICAgIHRlc3QvY3hsLWV2ZW50OiBTa2lwIGN4bCBl
dmVudCB0ZXN0aW5nIGlmIGN4bC10ZXN0IGlzIG5vdCBhdmFpbGFibGUNCiAgICAgIGN4bC9yZWdp
b246IEZpeCBtZW1vcnkgZGV2aWNlIHRlYXJkb3duIGluIGRpc2FibGUtcmVnaW9uDQogICAgICBu
ZGN0bC90ZXN0OiBBZGQgZGVzdHJveSByZWdpb24gdGVzdA0KDQpKZWZmIE1veWVyICgxKToNCiAg
ICAgIHRlc3QvZGF4Y3RsLWRldmljZXMuc2g6IGluY3JlYXNlIHRoZSBuYW1lc3BhY2Ugc2l6ZSB0
byA0R2lCDQoNCkplaG9vbiBQYXJrICgyKToNCiAgICAgIGxpYmN4bDogYWRkIHN1cHBvcnQgZm9y
IFNldCBBbGVydCBDb25maWd1cmF0aW9uIG1haWxib3ggY29tbWFuZA0KICAgICAgY3hsOiBhZGQg
J3NldC1hbGVydC1jb25maWcnIGNvbW1hbmQgdG8gY3hsIHRvb2wNCg0KSmltIEhhcnJpcyAoMSk6
DQogICAgICBsaWJjeGw6IGRvbid0IGNhbGN1bGF0ZSBtYXhfYXZhaWxhYmxlX2V4dGVudCB3aGVu
IHN0YXJ0ID09IFVMTE9OR19NQVgNCg0KSnVzdGluIEVybnN0ICgxKToNCiAgICAgIHV0aWwvanNv
bjogVXNlIGpzb25fb2JqZWN0X2dldF91aW50NjQoKSB3aXRoIHVpbnQ2NCBzdXBwb3J0DQoNCkxp
IFpoaWppYW4gKDMpOg0KICAgICAgdGVzdC9zZWN1cml0eS5zaDogdGVzdCBrZXljdGwgYmVmb3Jl
IGV4Y3V0aW5nDQogICAgICB0ZXN0L2N4bC1yZWdpb24tc3lzZnMuc2g6IHVzZSAnW1sgXV0nIGNv
bW1hbmQgdG8gZXZhbHVhdGUgb3BlcmFuZHMgYXMgYXJpdGhtZXRpYyBleHByZXNzaW9ucw0KICAg
ICAgdGVzdC9jeGwtcmVnaW9uLXN5c2ZzOiBmaXggYSBtaXNzaW5nIHNwYWNlIHN5bnRheCBlcnJv
cg0KDQpPc2FtYSBBbGJhaHJhbmkgKDEpOg0KICAgICAgUkVBRE1FOiBGaXggYSBVUkwgcmVuYW1p
bmcgJ21hc3RlcicgdG8gJ21haW4nDQoNClZpc2hhbCBWZXJtYSAoNCk6DQogICAgICBuZGN0bC5z
cGVjLmluOiBVc2UgU1BEWCBpZGVudGlmaWVycyBpbiBMaWNlbnNlIGZpZWxkcw0KICAgICAgdGVz
dC9kYXhjdGwtY3JlYXRlLnNoOiByZW1vdmUgcmVnaW9uIGFuZCBkYXggZGV2aWNlIGFzc3VtcHRp
b25zDQogICAgICBkYXhjdGwvZGV2aWNlLmM6IEhhbmRsZSBzcGVjaWFsIGNhc2Ugb2YgZGVzdHJv
eWluZyBkYXhYLjANCiAgICAgIGRheGN0bC9kZXZpY2UuYzogRml4IGVycm9yIHByb3BhZ2F0aW9u
IGluIGRvX3hhY3Rpb25fZGV2aWNlKCkNCg0KWGlhbyBZYW5nICgyKToNCiAgICAgIGxpYmRheGN0
bDogQWRkIGFjY3VyYXRlIGNoZWNrIGZvciBkYXhjdGxfbWVtb3J5X29wKE1FTV9HRVRfWk9ORSkN
CiAgICAgIGRheGN0bDogUmVtb3ZlIHVudXNlZCBtZW1vcnlfem9uZSBhbmQgbWVtX3pvbmUNCg==
