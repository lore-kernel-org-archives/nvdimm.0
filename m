Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 90C9942AA6
	for <nvdimm@lists.linux.dev>; Fri, 24 Apr 2026 06:45:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.18
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777013155; cv=fail; b=ec0kgWiWrm64U8DG4RW3yOFZIBflPpFWI/gdU51esclQQtFgBk+HTzSbMYS8ZPWH88J/rrqMfp5DshQMeb6ot/bl5K8MVWwiFy1pwqxfj5hLyGv4PRptI0cNTyvDKOxkqb0LnGtkhO4ERyubOb9rppznq/kRDTwuybaCNjmeR1k=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777013155; c=relaxed/simple;
	bh=gRs7qaQQCD3sVFutROE2I2mQHTPVlugOOVv6br1lcmA=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=e/A9j7S9rrZTfxUM6BPPr1i/zVL7iF8TIrf5YJRa9KQRYSmZFBQn1Rm+E0zL51Y56z7luI2RCIXweuultWPa2FdbdDCEtxR3Kd5AQ3r5hSl7UPYlcniKuouut0wo2+Hf3TcJyLjWKCCGb9X/H03c/YbQO11ytNN1jp1MOlW7FfU=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=ea+hsbJr; arc=fail smtp.client-ip=198.175.65.18
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="ea+hsbJr"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1777013155; x=1808549155;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=gRs7qaQQCD3sVFutROE2I2mQHTPVlugOOVv6br1lcmA=;
  b=ea+hsbJrF4b0w+5bH74lZVYeaT4LhAAcPwA15mQ/BEvjyX/LWMHgh/nW
   Swti3V3YW8ZEJ643rVhf6HtwdLhSuVm3P/Stsh+jS9oi8+nT0+GS/quCg
   0who4il+frMgRfNE/Gk3P10JCJUatli2Aerxhe+19YQQkAE9makWYsQ7T
   mOe9AY6OnSBxBv2muzP7ZLoj08Q7WE/x2Ngg2EB4goPRGXvGoC993csbY
   a9wssQQejOudwqnL9ga2v3pYEGxBs+6+B4cXDquFG0guwtvoVhaWql9ct
   4bVb8j/IsoIWwWjZ+/8Umrm9Z7VUudetfORY6Yc34jhAzAvunNT6BOQ8C
   w==;
X-CSE-ConnectionGUID: l+BcEA+IS/+hUi50DCHv3A==
X-CSE-MsgGUID: jzoD/M1WQ0SRctclnD4CBA==
X-IronPort-AV: E=McAfee;i="6800,10657,11765"; a="78009679"
X-IronPort-AV: E=Sophos;i="6.23,196,1770624000"; 
   d="scan'208";a="78009679"
Received: from fmviesa005.fm.intel.com ([10.60.135.145])
  by orvoesa110.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Apr 2026 23:45:54 -0700
X-CSE-ConnectionGUID: Sncc8gj8RXmDIc5Z4M7bLg==
X-CSE-MsgGUID: pzCXx4HRR92+zLTcR9VZpA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.23,196,1770624000"; 
   d="scan'208";a="237874976"
Received: from orsmsx901.amr.corp.intel.com ([10.22.229.23])
  by fmviesa005.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Apr 2026 23:45:54 -0700
Received: from ORSMSX901.amr.corp.intel.com (10.22.229.23) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37; Thu, 23 Apr 2026 23:45:53 -0700
Received: from ORSEDG901.ED.cps.intel.com (10.7.248.11) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37 via Frontend Transport; Thu, 23 Apr 2026 23:45:53 -0700
Received: from PH7PR06CU001.outbound.protection.outlook.com (52.101.201.30) by
 edgegateway.intel.com (134.134.137.111) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37; Thu, 23 Apr 2026 23:45:52 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=XUI7HMsrwNk6f3ZynXU43aOS/GIXMgpXYOYcMK5DJT4aI4SJGt9LujYE7zISWq1/L44sgPkoTuYmohW/7tJU4ElRUa+YX4jjt7pdeku9NrAbI6fnCcU7763R1VZT2l8QSqjI3xZsSzGqIqHcrwUxd1CtZm2HpHh9br8KDDkh7+l/YcWpjkxAt4q7qAiz83IdF+FOKw/fpmnypFkGLQv7CXfbQ9bJGAD+ZGKw9IEGV+dEx6twMF7Dfgk2IKua40yZ/l0enzdtPgUIT3lBGmxLB5KJ7EPHFPG4z/DsPU0zRRbjtRll9NAW/0uQK7VyVptckTQMtboU3fArW0Ak2muOTg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=gRs7qaQQCD3sVFutROE2I2mQHTPVlugOOVv6br1lcmA=;
 b=Gn5Nkss//XmC9AY/jHMlxKTbMaVoevrSKYCjb60rZgEAZYixRUfPNWp4Lt+8hnkshOldH+M8tQ2Kjyzr0y91SPGHMFxGNIOFe9cSDUG95mWgDeMPJ13Ukaa/3ut7WfJ5rVvblSjJ+6Rj9XCIXFv0ag+/1DnDhyhbsx9Ls3liUsrghqeOqW0xFTFO5i2kr0lcKoDLMi6azlXa+Jt1klWCHH/pAoPJAu3GJpyJ5x/HhQzAfzEgNxk5isvx4Kjtyccnrzlb8LiyfxxADgyJkARL03BVq69b66wodjiZ4wWruQLxIlegJbeLXXLkTWCg1sSyab6TMxDC/SYKbOqJmD5pwg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from MW4PR11MB7125.namprd11.prod.outlook.com (2603:10b6:303:219::12)
 by MN2PR11MB4696.namprd11.prod.outlook.com (2603:10b6:208:26d::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9846.17; Fri, 24 Apr
 2026 06:45:45 +0000
Received: from MW4PR11MB7125.namprd11.prod.outlook.com
 ([fe80::690e:5fd2:b08b:52af]) by MW4PR11MB7125.namprd11.prod.outlook.com
 ([fe80::690e:5fd2:b08b:52af%5]) with mapi id 15.20.9846.019; Fri, 24 Apr 2026
 06:45:44 +0000
From: "Verma, Vishal L" <vishal.l.verma@intel.com>
To: "Jiang, Dave" <dave.jiang@intel.com>, "linux-cxl@vger.kernel.org"
	<linux-cxl@vger.kernel.org>, "nvdimm@lists.linux.dev"
	<nvdimm@lists.linux.dev>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>
CC: "Schofield, Alison" <alison.schofield@intel.com>, "djbw@kernel.org"
	<djbw@kernel.org>, "Weiny, Ira" <ira.weiny@intel.com>
Subject: Re: [PATCH] MAINTAINERS: Add maintainer info for libnvdimm and DAX
Thread-Topic: [PATCH] MAINTAINERS: Add maintainer info for libnvdimm and DAX
Thread-Index: AQHc0rWcJmDSR1uQdkuJhkaOgvzfHrXtxoaA
Date: Fri, 24 Apr 2026 06:45:44 +0000
Message-ID: <cfe31dff985d836830075e15cfcf20ea52cc12db.camel@intel.com>
References: <20260423001003.2887295-1-dave.jiang@intel.com>
In-Reply-To: <20260423001003.2887295-1-dave.jiang@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.58.3 (3.58.3-1.fc43) 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: MW4PR11MB7125:EE_|MN2PR11MB4696:EE_
x-ms-office365-filtering-correlation-id: a846d61a-e00e-4b17-4260-08dea1cd1bfe
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|1800799024|376014|366016|38070700021|18002099003|56012099003|22082099003;
x-microsoft-antispam-message-info: fSiFH5jCu4ZgERWfx/iWuzYjuZwMjTChXYiBRDTcDId7OVcVHwTjaqYBE3l7h7GkXdUH+4ZV7SSquhp71Mgq55epjEgU+q2mLkn0UWG1Dl4zEBRAhdlFqNa8K2sbqashhVnAphwk0W1n4Tr5Z+8wi/N3ysyRpw3motXdIhQ3akeebHL8Wf8IiZvk+KquI5INu7up6kRPboVcu9KcF3LalJmE1EpVGMSgG3vkhauSn6wPpvI9SbN8mKguuukZABw83+L26JdfmTM9lOIucDC1iof1YB/GP0K9zsZR3+bM553IFdh0l4Pzh/UVztvoTTcNX59FeBkvdOtYwOmxruxKA3K/oghOCA7PKoLWG5j8JK4t6o1tVCM/S9EoWISr4qCWQDBRfOMeDIAQ1E2IwQrPBP1wCPKqq+dKMD/exv15+hOgeLS9O7AZQyHXtKBr2/4TiwQjqJw2Ca72H71SrxQpafLsSXeVn9bJP/qZEQgGBMmbj9lfEDiXB7H7ZyRqI5OJ1oo52c0xOhp0fXQL3d1kgXo6WaFZCX55VKR8ojeT+OJ3Obu2pHOjXMfxuL/+yctxGtQLLnD/ajBfoVtxMTQ5jp8kMByeA/nkdspXe66ZFNQpSm8+/2c6Brk1pa9PctHEK2BAA8aqQDULXopPCjctrbccCqeglxvFmXtAkl9aqdaWM4j/vQ/+IJXsEX/GxzyXEIVYjQ2Up6QQ93gN09fSe8VBiRemDL8GWeYEhNUW68LwZOrbIO+vI+coy8wrlULLJAyxcHnb4QvqwWtXc94yAJyrwcuAV0zepSmHX6u+RLg=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MW4PR11MB7125.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(366016)(38070700021)(18002099003)(56012099003)(22082099003);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?QmhMbmlSdndGRmo1dWxaR0doQUVneWZCZjdxQ2o0bm95Tk5Nbit6R0hKRjFs?=
 =?utf-8?B?eEFXWkorUld2dEpnRDZXRUZia3JyZnVhWjlCY3E1VHNSTC82aVNlc3g2MGd4?=
 =?utf-8?B?ZkJCVEVweW9HUUdacFk5UUYxcGRtT2RTYWw0emUyVUNjc29SM0hCTjFpbWVW?=
 =?utf-8?B?SjNQY2NReWNJclZPcG8vN05ySUdCdDF1Q1hNM0NNVVo4eHRwUXg2S1d0VW9m?=
 =?utf-8?B?K1RXUjRhcGdheTJTYThZVW1QYTR4eUoyUzdSMlB4RHZrUnFKNHE2TmFHNHl0?=
 =?utf-8?B?Sm9LRUc5Ym1xSkJDRDRNRVlrVExZYXJYUEQ3ZXhYZkZMRFcxbFVMNXdvNzFE?=
 =?utf-8?B?bFhOdUdHMXlKUzlZQVdoRmpDaEpndjZoREJ0N0JVckYyWGFJTHo4NmdKbUJY?=
 =?utf-8?B?K0NqVEEzRXh2M2pHNlA4OTQ0N2l5bEk4L2JSNnNzLzkvb3g1VzkrdFhjRitn?=
 =?utf-8?B?K0UyanZTSTh6aEtmM080K0g2d2ljWEQwa2xhLzhnUU5heGpSQ0ZhQlpMcVFG?=
 =?utf-8?B?VlhOM1lrSUZKMHdENmNFSTdOT0hzOE5pcTNVV2M5blN4RjgrcGlYMXJ3bWZT?=
 =?utf-8?B?MnBMSHR2SjV4TFgvWHN1NFZGd244V1lQWDhXdHdONXhoYnF4N05haEZyQUFB?=
 =?utf-8?B?cUE0bG5SRU14djB5bnZmdXVBcDRJQ3M4c0M5RTVrdzMvZlVONXZIemtJTWRZ?=
 =?utf-8?B?S3NFbFpaL0ZDcDZmaERyZU1zeEFER2VQOHg4VnRzbG1sdU4wemZ6QTdHSDBG?=
 =?utf-8?B?bTQzM0c1U25ZdFh2dDlGQ3U3VWs5cXdvcEszYzF1SzdNOFlKcVlKN1daa1RF?=
 =?utf-8?B?R1BtRFI0Q1F4eXhJRm02SlNzNFNFS2YxcEVBaFBKalp2R1krUUJwYlVzeFNo?=
 =?utf-8?B?cG5mTE5YSjhzU2ZTRDE2UlYybkRGcDZ2QmVFR1lvVnlrNXdsWU0rZTFXVS9C?=
 =?utf-8?B?WkVDSW11Mnl4WVpZYllPZEQydFVqV2J0WnBsbUtkUFlLRHRMOVErL1dRdTZa?=
 =?utf-8?B?cVpOR0lodHREL0dQVTlaYlZJL3haQ09WTlZKZkRyUjJaak9aK2lBNWdtbHdY?=
 =?utf-8?B?ei8veGRQa1A2VGlwYjkrS2U5L3JWRzZpSFRLcXl4THl0WWcwcm93UE9HZWtO?=
 =?utf-8?B?V0loZS96a0pHd3lpOFJWRmJOQXJmRG9oMnNReHhuWjVIYk9qdWU3RW91cVU2?=
 =?utf-8?B?Qi80QzRNcExVbGwyS3VWNEpkSUcvWTk4d0J4L2RZUlh2NHFjUy9rS3M0TGhx?=
 =?utf-8?B?V29DbE1IWjV3b2dSTFp5LzYrY243enZSR1kvWTE3L0tydmxpd2FYdlhUMVBY?=
 =?utf-8?B?Ym9jZTVXRjY2Zk9pY1ZOaStFcW0rcCs0VG1jTzRoaTBsRVRhYkt2S0VMaDJL?=
 =?utf-8?B?R3pQbXBzU2RvcHRRNEdwbXZyb3FtWnJ4Q3R2Q0RSZmRoNnR4a254QVZYT2M5?=
 =?utf-8?B?SmUrQUJDc2VacFA5VkU0Q3gxUmwyNmdMSzhqcEZsWFkrMktVVXJZaWJaNXdH?=
 =?utf-8?B?bzRRMnN6UlNPVUZzTzZWTEtlOEwxcmhKaU10dkNGOHpOQU8rSm5zNlhkVTZE?=
 =?utf-8?B?b1dERlVaMzFTMy9QNDBlaHRaQWR6OXNpR08xUWQxMkNUUXpYWWhxbGtNL2JO?=
 =?utf-8?B?SXJwcFprY0hubXFYOTRuR0k1bS84TUtuU0lZY0JCeStTNTlCbHpYZUlzOHdY?=
 =?utf-8?B?aGpmMTdWaVhSY1h3K1NmbTFlcVozNFdNeHVpbForcUV6bENROTlmSEFqVWQ0?=
 =?utf-8?B?MnZiR0RlOFVYZ0ptQzNXM0FqV1NNMzM1ekV3SWRxTER0MnlQR0FUNHFZcXcw?=
 =?utf-8?B?K3RiUU01V0huMFBjWnVqalRaUEdybUxyMWkvZC9OYmJ2ZERWUjJpNFBiVDlF?=
 =?utf-8?B?YzZkSmJZQ1ZCTFBydlZTQkxPUlN6Rk9RRXdVR1lBTVN0TzRHZTdJM3F4YmRR?=
 =?utf-8?B?RlN1QjUxNTBMc0tYUUZjRXVOYzl4dUIvcElSdEgwcVo2MExacDNHNFo4WkNU?=
 =?utf-8?B?WnlGNkZYTlB5WnVvUHBDOGhZei85bWQ0TFgvVlR3UjgxblZmT0FLUVpzR1oz?=
 =?utf-8?B?NU0xTGtUQW5kU2VYRUdpcWpjei90dmZCVWJBa0hPT2l3MkxPM1o5aTByV2I4?=
 =?utf-8?B?N0ZXMUNJZmxWSUJvT1dQeklQS1hmZU1QVXBWS0JPd2xuVUEvMVU3cHpheHpL?=
 =?utf-8?B?d3NaQ3J4L3BOUDBTSDYyR0dwRlZCdTZSY3hVM28vcldOVW5LS2Npa3RGRmJa?=
 =?utf-8?B?YWVFQ3UwUGJZN2RobUI1WlQxUWhSb3RYeWJTT3B4a2xZcmxFdytuVVk5cWpm?=
 =?utf-8?B?VjFJdU5qTWJ1Q09OZFV4TzZBdmZJZlFFSXhORjJtSXFKMnkvT3poMDlhM2dM?=
 =?utf-8?Q?m55Bt9KSCWXkT2EE=3D?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <5B691845F4BDC645AF4D307A3319E375@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Exchange-RoutingPolicyChecked: Zci6NQZrEqBsouHxN6UodCL48GWiKNasirho3hPyvuCZF/U3hXOwKtgN5/AVwuyQlyRuPNciORshE61qGwM8a+XQ75EfUnixaXSIeoMv85DJENBVgTVJOK9qGlTIQtP5ZC8dLp7lFQU/OjHxMngkx0KSoP9BW0flqC6cKAuL5Q4HASmQovpUfoOf0qKyr9K9OAFIe8OXwniwoQw5MtonMFLrKQkscAhvCl+fK8+5BYcshh0JYR5Ir/YozywjsK8XbTFk/vD7G/SYkGUP3+gpQ9IUx8by8KIrHyrKUCxJ7foQi5525eTN9ghY0vPDvX436Ft20SW/SFa1m12LlcuY9A==
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MW4PR11MB7125.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a846d61a-e00e-4b17-4260-08dea1cd1bfe
X-MS-Exchange-CrossTenant-originalarrivaltime: 24 Apr 2026 06:45:44.2633
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: dveOl82td+CA4KDyAgC64ISoH7DyuVAut52nwpmgI4dJgFngPKjTDWM2p9zays7PcCQI5CcMfUrLQOpQwPr9+5cWfJypEzEvOInkbVU4DnI=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR11MB4696
X-OriginatorOrg: intel.com

T24gV2VkLCAyMDI2LTA0LTIyIGF0IDE3OjEwIC0wNzAwLCBEYXZlIEppYW5nIHdyb3RlOg0KPiBB
ZGQgQWxpc29uIFNjaG9maWVsZCB0byBsaWJudmRpbW0gYW5kIERBWCBtYWludGFpbmVyLg0KPiAN
Cj4gQ2M6IEFsaXNvbiBTY2hvZmllbGQgPGFsaXNvbi5zY2hvZmllbGRAaW50ZWwuY29tPg0KPiBD
YzogSXJhIElyYSBXZWlueSA8aXJhLndlaW55QGludGVsLmNvbT4NCj4gQ2M6IERhbiBXaWxsaWFt
cyA8ZGpid0BrZXJuZWwub3JnPg0KPiBTaWduZWQtb2ZmLWJ5OiBEYXZlIEppYW5nIDxkYXZlLmpp
YW5nQGludGVsLmNvbT4NCg0KQWNrZWQtYnk6IFZpc2hhbCBWZXJtYSA8dmlzaGFsLmwudmVybWFA
aW50ZWwuY29tPg0K
