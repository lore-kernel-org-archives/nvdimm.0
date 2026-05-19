Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0D18B64
	for <nvdimm@lists.linux.dev>; Tue, 19 May 2026 00:04:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.14
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779149097; cv=fail; b=XmyLDSr8U+vBzrNm+Z81OlVhp9j37Ty0rYFSoknLViU9jwhRU/zqnhpGW4adGw8y0PkE0yaLwIfRKSbwBjhQ2O8ItdfubJ2/P8AXsJ0bOGdM7Ko8mwr4e/NlSfmKMYwWjqpxQnkdt4WBhzeamd1GKczrn72NBizz0M+BsSecsdc=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779149097; c=relaxed/simple;
	bh=Z3ea24fKHdZgKUTsDJbAmUFDml44XsDG10K8m1vjXhQ=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=IBn5fFeHphO4wAqqESGdSqHx/KxWgV73jMalwGQNqyJQlcdRzJ0svzL+bk96APGYG6RJasc7EwAtxoQNutLAFoZQx1DkkOenzEXqQv/NHFZ2i3an3CVk5xMSg7hjNYVhDFa3q6lqPzbL1qbyVvlFwK1+lcYB3QmL9OQsPl9Vh9s=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=cBVzoIW2; arc=fail smtp.client-ip=198.175.65.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="cBVzoIW2"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1779149097; x=1810685097;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=Z3ea24fKHdZgKUTsDJbAmUFDml44XsDG10K8m1vjXhQ=;
  b=cBVzoIW2YubWgxMfqu8DDQVPa/aWwFUApE1y+GDfv9SuS0pvAGwkAFaM
   8gVPv/Hnhpni5yhJq9h5bvg6Q8zUez4B81h3dUPvjAOzBLXute5awvnA+
   a4auLZonkRfgY5LgVOcR+U1yzh9CQwUQIj3AGGB5FG7VfkgxsjXvMlUbG
   YGKz7ijPz+PRtkkHwgM5DrAZcpHiMykbzm104rkpiEE3TpqsRQUmF4SZe
   I87SA3wmu1vx/Xt8y1ydzh6wOTCthNt0fuAs57G/wRzcRhw0f3oy8Vf57
   wZPyItCj36obeldf/jTHc3j60gH0I90NfaH/F1uJyktsnIoSuFJjLd7kj
   Q==;
X-CSE-ConnectionGUID: +78TQeJVTfuBVchVMtwX6g==
X-CSE-MsgGUID: n+DXH5OKQTm7YY9NQX5gug==
X-IronPort-AV: E=McAfee;i="6800,10657,11790"; a="83893059"
X-IronPort-AV: E=Sophos;i="6.23,242,1770624000"; 
   d="scan'208";a="83893059"
Received: from fmviesa005.fm.intel.com ([10.60.135.145])
  by orvoesa106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 May 2026 17:04:56 -0700
X-CSE-ConnectionGUID: QL5KldVMR5yVzl64esKAKw==
X-CSE-MsgGUID: xt+oKH90SMawcJwmqcOJTA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.23,242,1770624000"; 
   d="scan'208";a="244588680"
Received: from orsmsx903.amr.corp.intel.com ([10.22.229.25])
  by fmviesa005.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 May 2026 17:04:55 -0700
Received: from ORSMSX901.amr.corp.intel.com (10.22.229.23) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37; Mon, 18 May 2026 17:04:54 -0700
Received: from ORSEDG902.ED.cps.intel.com (10.7.248.12) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37 via Frontend Transport; Mon, 18 May 2026 17:04:54 -0700
Received: from SJ2PR03CU001.outbound.protection.outlook.com (52.101.43.14) by
 edgegateway.intel.com (134.134.137.112) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37; Mon, 18 May 2026 17:04:54 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=XAbDHnTQJVg4m70dN0TIa+zbiKvecJG2vcLoH9cwhw9USJJTfvShEncAZHz5KTXFnR1dXsCtUQj6CEaDXh+7hc/A1d9TBpJOIFf6wqyW6dWxNVqYVtsxiQz7L77ZPkpY7UqK8wG5/eHI82PNXbHl0+4tM+xIBRT/ro6MwswtQ+lPOf0LZRD97IDz8pVzeR3DFn5Qk+8HhCxxHD0A2XpE/bNuw8mDWCy3W1BavwZi0BihbDp6ct1u6s/1a2y3tBVgIuzuziijSQCBFwVVbP05tYoU7KmBeMnV0+ur0Jh6Rnurmv1jfqadW6ccqgLyDze6as1ODbEjLNmsjPuVT67c9A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Z3ea24fKHdZgKUTsDJbAmUFDml44XsDG10K8m1vjXhQ=;
 b=hJPQHutp3gzKm95ptnnf8k8KSOZn14PUl3/bwHMLx11wHXscdp+OgyjeRnp+73f93U6bXlTadM4rZ85ihcRn0mvt8ork8e+BmwYmCjlG7v45KDQw7HNW4CDxyFPTzaJZbHoiUacUzHG3U/jNQMJqEkhp/wbqyA6vnKHWzwr4/Ip/oVd/QbGIPwIE7DPuCLD8Rw1ZY4AHBUuuES2niehArT6mPOoOe/Y1R0WO5LXBLv5ZZwT/rpo3UMotvcr9kJMoCQ6XVC6HICL6lUfwvtpF2GfakjDqNyjTmmRTRfDngHbWKp3/fsxLan0Kq7HgqIuYjR9sY9O/N1GFQsRtsbhVQw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from MW4PR11MB7125.namprd11.prod.outlook.com (2603:10b6:303:219::12)
 by CY8PR11MB7084.namprd11.prod.outlook.com (2603:10b6:930:50::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.25.22; Tue, 19 May
 2026 00:04:52 +0000
Received: from MW4PR11MB7125.namprd11.prod.outlook.com
 ([fe80::690e:5fd2:b08b:52af]) by MW4PR11MB7125.namprd11.prod.outlook.com
 ([fe80::690e:5fd2:b08b:52af%5]) with mapi id 15.21.0025.023; Tue, 19 May 2026
 00:04:52 +0000
From: "Verma, Vishal L" <vishal.l.verma@intel.com>
To: "Schofield, Alison" <alison.schofield@intel.com>, "Jiang, Dave"
	<dave.jiang@intel.com>, "iweiny@kernel.org" <iweiny@kernel.org>,
	"djbw@kernel.org" <djbw@kernel.org>, "aboorvad@linux.ibm.com"
	<aboorvad@linux.ibm.com>
CC: "nvdimm@lists.linux.dev" <nvdimm@lists.linux.dev>
Subject: Re: [PATCH v5] nvdimm/btt: Handle preemption in BTT lane acquisition
Thread-Topic: [PATCH v5] nvdimm/btt: Handle preemption in BTT lane acquisition
Thread-Index: AQHc5A1Xr8xWqvpOVkmdAqq9ifMh/bYUfh4A
Date: Tue, 19 May 2026 00:04:51 +0000
Message-ID: <626a3d0da9df07d26ea2ab4ef0994e02822fbae7.camel@intel.com>
References: <20260515014729.107329-1-alison.schofield@intel.com>
In-Reply-To: <20260515014729.107329-1-alison.schofield@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.58.3 (3.58.3-1.fc43) 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: MW4PR11MB7125:EE_|CY8PR11MB7084:EE_
x-ms-office365-filtering-correlation-id: b4b491c6-a6a2-4d46-01c7-08deb53a4011
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|366016|376014|1800799024|22082099003|56012099003|18002099003|38070700021|11063799003;
x-microsoft-antispam-message-info: JW0zLGfUKhKu1VbijWhIDrro9fako8j4lmZzA57eNOrCFS4rC74i6im6+ODXNxlksvmy4fJGP8im6TkqzVtc3exI7BA99JFyK8ANb6D0SbZN/k5dJgG1JD4eaOGSDnN5PjXP/5i6aim4RpcjAZKu9bGW2gk/JaLrnQsQEnyNRXHGP/QwjUkPHaaW29/6NNVOZT9LnojOeyucZA4SZ4ntvWxifdpkITg34ZiBVo1BipgqDlHOr+XheebeT/Dtv38CYjNW4tKxQwFHXI1rR8EQEgDejurvPn9RR5pOha7fzr4UI7PnlqVK6gu2jl1t4J4L7TYtC93/bv9oZ1hF7OlmlKxx4vY+w2u61r8gbcWRkq/egU2RF/LsGipHOlctcdiPK5Db3ZMjg6HBSIukJhIGkrnKcO3Wi55Kat6PmVpUnYbMk9CC+OXyoetLGbohnbxwaUFlVyNPNisYQ5xDLiIX+f2HP7gXY5RCxxsvlGYCe8mC+d3SCAE98L2fzKpcXayc8txh/zIzBqTTECXX3y5RiY5A7sfBJc55n8GaCWOfP0Sdy/3cvHhuDT53XE/m2DYO4bqmVKm3dx4nL2FNM9mxg8ns9x2LS8IjYmfg9+DoG9/waehw/xkaAuvTrHbVMu0WPOFK+DhTIphoAEf3y8Om6gW9ad5aVn23Ldn5PjE+BFuBb3xplhJ7qrgMZH26TL73QcAetWYy88q7/ZjUq7FLdQ==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MW4PR11MB7125.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(1800799024)(22082099003)(56012099003)(18002099003)(38070700021)(11063799003);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?bUFLQXExNTUwSW9hNmVzRVQxeFFXa3NsR3JrRjNXbklERDMwWTZ6WFROUmFu?=
 =?utf-8?B?L0xDWHFvNEhBTVlYSU5mNGVmZ0trNWN6MjdBRDI5Wk14MkE2T1VtbHZEVkJZ?=
 =?utf-8?B?VjY2bEU4M0FHa0sreU50UTBFRmhWSFZQd2JvQ1Zkb3FqWkEzSGRqMExqUXBr?=
 =?utf-8?B?cTY0Misyb1VleGY2TldLVHhDS3JnUTFBRVo3dTd5MkE4ZHRLZ0kwTHpzU2NF?=
 =?utf-8?B?VFE2YWtiUEtCK0g4RGdTZGtzZExxb0s3MEVBcmRnSkZERDN6VHlRd2c0ZEJF?=
 =?utf-8?B?OXE2MzhTM3Vab3BZNDM5WmFwM0xUQXRQamZ3Q0tHZzRxLzZNdWI5RmJPdUw4?=
 =?utf-8?B?anFvRFM3N0JlRnkyUkhsWFhZYXBxc2pBenRrMVU0QlBJaHVpYmkxMTdXMjlt?=
 =?utf-8?B?MXlvTjRzQ0ZIOUpsc2FlZ2kxMCsxL2E2RTlMLzBLYmFxM1RDeU9Zejd4Smxm?=
 =?utf-8?B?a3JGZmczeWJ0NjdDMlZ2VFVDWVRiTE9XMUFHdW9OOHRTTlRFN28vbFViRGh1?=
 =?utf-8?B?cndhTEY4VW8xM1Z5OUhxN0M3YjR2djd2a1RQcUtza21hQ0wweUxwTnlvaU5i?=
 =?utf-8?B?dFkyMzRyVVRzWjhkb1dRMThBMHJuaDVka29tRXBub25Bc0FwUUVDSFJxSVVG?=
 =?utf-8?B?M24xbDBuQi9qZjZyaFpDbTdYQWJkTWVNZVN6UFNVQWVQT1c0U2RPOUdnOEp2?=
 =?utf-8?B?SVEybCtMcFdvVzB3QWxKdHZmMGlweE5wZFVKenFhUDZBd3djdCtySnU1OURI?=
 =?utf-8?B?VnIrTGxGMUpsdEp2VE1YUlBtLzF5Y3FzV3Q4Z2ZCVDlDY05rMGcwczA2Wllr?=
 =?utf-8?B?cG1ZZTEvK1QzTGNsU3BBRFFDbUM0bFdSeEEvcXhvOWEwV3ptWXpaT1czOUpO?=
 =?utf-8?B?VTZJb0VPQnczUGVqWHVDbjBjRzRScHZjc2Rxc05kelJwK0V0RE11V0s0SS91?=
 =?utf-8?B?YWwrblJsSkkzd2s1Y1IrbWdMRUtwR3Z5aDlqMkxrTFlHNlRSTWJoQ3BCdGl0?=
 =?utf-8?B?d0M5aUwyRlBTZElkam5YTGhDK1ZHQXkzM2g2OUlmMTA4S3BGSnMwVGNOM0Jq?=
 =?utf-8?B?SjYwL0xxQTdDaGtiR3Z3dkV3NlAxVDAvSi8zcXNEaEJPbXNxZkh3WW80WFBa?=
 =?utf-8?B?M2xQRXJ6clh1SGlxWXFIWEt2SnZpK1lON3R4YmZZMzZpZFUxOGpEdStFaFly?=
 =?utf-8?B?Rm9aRDhvMnJlUG1EbHk0WFh6VE5hM2k0bDcwWkI5SFFaT0x4MzYzSXNqc01M?=
 =?utf-8?B?U09qUWFsZjljVVJiaHdwWFJNc2Fwc3pqWXc3bXVNb0FPWWJRbU42N2FkNnVE?=
 =?utf-8?B?TzlYVE10aFhqN0xxZ2p6dXE4MmQ1N2Z0R2pSTEMxVzFxVkxJT1ZjaC92MEpl?=
 =?utf-8?B?RnF4MERSb0lRem1pNzZYSlVYd25JUGpGMXU2bnljRHk1bzN2bGlYZzh4Vi9h?=
 =?utf-8?B?QXJxTEdIOVRuQ2g3bW1aSkdCQlg0MWZwSE92S0pYYzJVMms0bWVJSkQwYm5K?=
 =?utf-8?B?VkhpRU9keU5Vb1NSTTdBajBtYnVsb1NqemtJdjNaY052OFpIWm9UNG15cUM2?=
 =?utf-8?B?Q3RSM0pZU0UvQ1prWlE4ejdRUUpHUTROOVFXQ0JlY0s1YVRRTXZzSDdQTkEr?=
 =?utf-8?B?UXBMMGFBeHhueS9IM0x0RUIxZVJVOFNYTmhHOVJ2REo2emdnYTRiY0JrbXhs?=
 =?utf-8?B?MFRTeFU2WWJaR2ExWm9OcnVObnFLVVpKdUhjb2pZOERnbmVZY1NYb0JlbmF5?=
 =?utf-8?B?Zi8wVGFYVTF1VkRMeWx0c25rc29YY0VPRFRncnJkam0rQUw5UW83aTlzRU5I?=
 =?utf-8?B?UEVoQXZNOWZsWTRKUkJTZXROUkJUQ3d1U1ZVSVV6cUk0djQvNkxXK0RLbTIy?=
 =?utf-8?B?RE1EZUFCUTdzVTdXTGxCT0hRNWptNFhBTkRWVUg2TXF4dVZpYzhyL1ZxNW1Z?=
 =?utf-8?B?QmxNa0pYdDQyQWVocmNjM3RJS0oxejhNNlZXNjF2Mm1kbzFoL0FIblU3UXl6?=
 =?utf-8?B?UHhua0N4YkZucVM3U3JjM2ppN1VCRTR0VENPemM1U1VjSlBucThwOHRUSk8y?=
 =?utf-8?B?SEZpQ1M1Z1doZlVhM1JLc2RxaVAzQkJFRjFhVnJhUEU5UWhSQTF0MnZpYTRV?=
 =?utf-8?B?R0V0RXJKSW9XTWRYUTlxSTRacm12cHFjR1NKb3FOSC8rNy9qbkg1aStyT2xm?=
 =?utf-8?B?Z3dGMnBLZm9qdktxRFlGRE9pbUYyY2ZRLzAyN29ub1NVK2Fpd1k0Z21aSVNp?=
 =?utf-8?B?dmZDR00zRm5Ca0Q5MkpzWGZIdVRvTjBUdUpoaDNoeXBBMjFaSkpVcVhzckpp?=
 =?utf-8?B?SVI0dUladXp5andqbkhXWWEwUTlkUFA1RDNSaTh5Z2ZQOUwrQTI2WExsbkVw?=
 =?utf-8?Q?feMh/7gBularJ0Aw=3D?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <1932D095D85E8B4EAA79F6BA6B137216@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Exchange-RoutingPolicyChecked: q7GuDkhTrl+stzXhr3dix+TjtHdwk80FDZfL9z2AQYvZjWLgD37F6Qrzio+fQ6rpEVsrHq4pXRNPc1NDHbgEE1yUxYUN69/Py3BuEn+7D3mEoMC1cdIEmskQHIMoGgV6KCs0cFGfSUJZaSosLGXWffmJI5+ezc7pPQW84GZ64+L+0wA4sfjB+hCV9b7/Ki71t4mS7qxd0Ie7umbpaTJyJ3LcyZJygrpRGiG9V+MZEPNNsLIf13dTB38GKDTDGUUE60u8wAiOfaXC4Ee3QjarjtvDqy4NXmiCfueN11RZIr/6+Eu9KB1qKAD6xSgOEw+EpfEv1PNdklcipFg3KmoB3A==
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MW4PR11MB7125.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b4b491c6-a6a2-4d46-01c7-08deb53a4011
X-MS-Exchange-CrossTenant-originalarrivaltime: 19 May 2026 00:04:52.0667
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: xSUTvNZqRsQQozI9zhUMfxCpS+HwsTM9UxXEiuam7er/bzJATqZi0rjRNugxPsBE6EzN7RBDndVS13tz7PUwyqozseWAJQNmUkuMzHWVt1g=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY8PR11MB7084
X-OriginatorOrg: intel.com

T24gVGh1LCAyMDI2LTA1LTE0IGF0IDE4OjQ3IC0wNzAwLCBBbGlzb24gU2Nob2ZpZWxkIHdyb3Rl
Og0KPiBCVFQgbGFuZXMgc2VyaWFsaXplIGFjY2VzcyB0byBwZXItbGFuZSBtZXRhZGF0YSBhbmQg
d29ya3NwYWNlIHN0YXRlDQo+IGR1cmluZyBCVFQgSS9PLiBUaGUgYnR0LWNoZWNrIHVuaXQgdGVz
dCByZXBvcnRzIGRhdGEgbWlzbWF0Y2hlcyBkdXJpbmcNCj4gQlRUIHdyaXRlcyBkdWUgdG8gYSBy
YWNlIGluIGxhbmUgYWNxdWlzaXRpb24gdGhhdCBjYW4gbGVhZCB0byBzaWxlbnQNCj4gZGF0YSBj
b3JydXB0aW9uLg0KPiANCj4gVGhlIGV4aXN0aW5nIGxhbmUgbW9kZWwgdXNlcyBhIHNwaW5sb2Nr
IHRvZ2V0aGVyIHdpdGggYSBwZXItQ1BVDQo+IHJlY3Vyc2lvbiBjb3VudC4gVGhhdCByZWN1cnNp
b24gbW9kZWwgc3RvcHBlZCBiZWluZyB2YWxpZCBhZnRlciBCVFQNCj4gbGFuZXMgYmVjYW1lIHBy
ZWVtcHRpYmxlOiBhbm90aGVyIHRhc2sgY2FuIHJ1biBvbiB0aGUgc2FtZSBDUFUsDQo+IG9ic2Vy
dmUgYSBub24temVybyByZWN1cnNpb24gY291bnQsIGJ5cGFzcyBsb2NraW5nLCBhbmQgdXNlIHRo
ZSBzYW1lDQo+IGxhbmUgY29uY3VycmVudGx5Lg0KPiANCj4gQlRUIGxhbmVzIGFyZSBhbHNvIGhl
bGQgYWNyb3NzIGFyZW5hX3dyaXRlX2J5dGVzKCkgY2FsbHMuIFRoYXQgcGF0aA0KPiByZWFjaGVz
IG5zaW9fcndfYnl0ZXMoKSwgd2hpY2ggZmx1c2hlcyB3cml0ZXMgd2l0aCBudmRpbW1fZmx1c2go
KS4NCj4gU29tZSBwcm92aWRlciBmbHVzaCBjYWxsYmFja3MgY2FuIHNsZWVwLCBtYWtpbmcgYSBz
cGlubG9jayB0aGUgd3JvbmcNCj4gcHJpbWl0aXZlIGZvciB0aGUgbGFuZSBsaWZldGltZS4NCj4g
DQo+IFJlcGxhY2UgdGhlIHNwaW5sb2NrLWJhc2VkIHJlY3Vyc2lvbiBtb2RlbCB3aXRoIGEgZHlu
YW1pY2FsbHkNCj4gYWxsb2NhdGVkIHBlci1sYW5lIG11dGV4IGFycmF5IGFuZCB0YWtlIHRoZSBs
YW5lIGxvY2sNCj4gdW5jb25kaXRpb25hbGx5Lg0KPiANCj4gQWRkIG1pZ2h0X3NsZWVwKCkgdG8g
Y2F0Y2ggYW55IGZ1dHVyZSBhdG9taWMtY29udGV4dCBjYWxsZXIuDQo+IA0KPiBGb3VuZCB3aXRo
IHRoZSBuZGN0bCB1bml0IHRlc3QgYnR0LWNoZWNrLnNoLg0KPiANCj4gRml4ZXM6IDM2Yzc1Y2Uz
YmQyOSAoIm5kX2J0dDogTWFrZSBCVFQgbGFuZXMgcHJlZW1wdGlibGUiKQ0KPiBBc3Npc3RlZC1i
eTogQ2xhdWRlIFNvbm5ldCA0LjUNCj4gU2lnbmVkLW9mZi1ieTogQWxpc29uIFNjaG9maWVsZCA8
YWxpc29uLnNjaG9maWVsZEBpbnRlbC5jb20+DQoNCkNvdXBsZSBvZiBtaW5vciBuaXRzIGJlbG93
LCBidXQgb3RoZXIgdGhhbiB0aG9zZSB0aGlzIGxvb2tzIGdvb2QgdG8gbWUuDQoNClJldmlld2Vk
LWJ5OiBWaXNoYWwgVmVybWEgPHZpc2hhbC5sLnZlcm1hQGludGVsLmNvbT4NCg0KPiAtLS0NCj4g
DQo+IA0KPiBDaGFuZ2VzIGluIHY1Og0KPiAtIEFsaWduIGxhbmUgbXV0ZXggZW50cmllcyB0byBj
YWNoZWxpbmVzIGluIFNNUCBidWlsZHMgKFNhc2hpa28gQUkpDQo+IC0gQWRkIHNwYXJzZSBsb2Nr
IGFubm90YXRpb25zIGZvciBsYW5lIG11dGV4ZXMgKERhdmVKKQ0KPiAtIHMvc3BpbmxvY2svbXV0
ZXhlcyBpbiB0aGUgZHJpdmVyLWFwaSBkb2MgYnR0LnJzdA0KPiANCj4gQ2hhbmdlcyBpbiB2NDoN
Cj4gLSBSZXBsYWNlIHBlci1DUFUgbGFuZSBzdG9yYWdlIHcgZHluYW1pY2FsbHkgYWxsb2NhdGVk
IG11dGV4IGFycmF5IChTYXNoaWtvIEFJKQ0KPiAtIFJlbW92ZSB0aGUgcmVjdXJzaW9uIGZhc3Qg
cGF0aCBhbmQgdGFrZSB0aGUgbGFuZSBsb2NrIHVuY29uZGl0aW9uYWxseQ0KPiAtIFVwZGF0ZSBj
b21taXQgbG9nDQo+IA0KPiBDaGFuZ2VzIGluIHYzOg0KPiBSZXBsYWNlIHNwaW5sb2NrIHdpdGgg
YSBwZXItbGFuZSBtdXRleCAoQXJib29ydmEpDQo+IA0KPiBDaGFuZ2VzIGluIHYyOg0KPiBVc2Ug
c3Bpbl8odW4pbG9ja19iaCgpIChTYXNoaWtvIEFJKQ0KPiBVcGRhdGUgY29tbWl0IGxvZyBwZXIg
c29mdGlycSByZS1lbnR5IGFuZCBzcGlubG9jayBjaGFuZ2UNCj4gDQo+IEEgbmV3IHVuaXQgdGVz
dCB0byBzdHJlc3MgdGhpcyBpcyB1bmRlciByZXZpZXcgaGVyZToNCj4gaHR0cHM6Ly9sb3JlLmtl
cm5lbC5vcmcvbnZkaW1tLzIwMjYwNDI0MjMzNjMzLjM3NjIyMTctMS1hbGlzb24uc2Nob2ZpZWxk
QGludGVsLmNvbS8NCj4gDQo+IA0KPiDCoERvY3VtZW50YXRpb24vZHJpdmVyLWFwaS9udmRpbW0v
YnR0LnJzdCB8wqAgNCArLQ0KPiDCoGRyaXZlcnMvbnZkaW1tL25kLmjCoMKgwqDCoMKgwqDCoMKg
wqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgIHzCoCA3ICsrLQ0KPiDCoGRyaXZlcnMvbnZkaW1tL3Jl
Z2lvbl9kZXZzLmPCoMKgwqDCoMKgwqDCoMKgwqDCoMKgIHwgNjQgKysrKysrKystLS0tLS0tLS0t
LS0tLS0tLQ0KPiDCoDMgZmlsZXMgY2hhbmdlZCwgMjUgaW5zZXJ0aW9ucygrKSwgNTAgZGVsZXRp
b25zKC0pDQo+IA0KPiBkaWZmIC0tZ2l0IGEvRG9jdW1lbnRhdGlvbi9kcml2ZXItYXBpL252ZGlt
bS9idHQucnN0IGIvRG9jdW1lbnRhdGlvbi9kcml2ZXItYXBpL252ZGltbS9idHQucnN0DQo+IGlu
ZGV4IDJkODI2OWY4MzRiZC4uZTMyMTg4NjNlYzk2IDEwMDY0NA0KPiAtLS0gYS9Eb2N1bWVudGF0
aW9uL2RyaXZlci1hcGkvbnZkaW1tL2J0dC5yc3QNCj4gKysrIGIvRG9jdW1lbnRhdGlvbi9kcml2
ZXItYXBpL252ZGltbS9idHQucnN0DQo+IEBAIC0xNjIsOCArMTYyLDggQEAgcHJvY2Vzczo6DQo+
IMKgDQo+IMKgQSBsYW5lIG51bWJlciBpcyBvYnRhaW5lZCBhdCB0aGUgc3RhcnQgb2YgYW55IElP
LCBhbmQgaXMgdXNlZCBmb3IgaW5kZXhpbmcgaW50bw0KPiDCoGFsbCB0aGUgb24tZGlzayBhbmQg
aW4tbWVtb3J5IGRhdGEgc3RydWN0dXJlcyBmb3IgdGhlIGR1cmF0aW9uIG9mIHRoZSBJTy4gSWYN
Cj4gLXRoZXJlIGFyZSBtb3JlIENQVXMgdGhhbiB0aGUgbWF4IG51bWJlciBvZiBhdmFpbGFibGUg
bGFuZXMsIHRoYW4gbGFuZXMgYXJlDQo+IC1wcm90ZWN0ZWQgYnkgc3BpbmxvY2tzLg0KPiArdGhl
cmUgYXJlIG1vcmUgQ1BVcyB0aGFuIHRoZSBtYXggbnVtYmVyIG9mIGF2YWlsYWJsZSBsYW5lcywg
dGhlbiBsYW5lcyBhcmUNCj4gK3Byb3RlY3RlZCBieSBtdXRleGVzLg0KDQpUaGlzIGlzIHVuY29u
ZGl0aW9uYWwgbm93LCByaWdodD8gaS5lLiBhIG11dGV4IGlzIHVzZWQgcmVnYXJkbGVzcyBvZg0K
bnVtYmVyIG9mIENQVXMuIE1heWJlIHJld29yZCB0byBzb21ldGhpbmcgbGlrZSBqdXN0ICJMYW5l
cyBhcmUNCnByb3RlY3RlZCBieSBtdXRleGVzLiINCg0KPiDCoA0KPiANCj4gwqBkLiBJbi1tZW1v
cnkgZGF0YSBzdHJ1Y3R1cmU6IFJlYWQgVHJhY2tpbmcgVGFibGUgKFJUVCkNCj4gZGlmZiAtLWdp
dCBhL2RyaXZlcnMvbnZkaW1tL25kLmggYi9kcml2ZXJzL252ZGltbS9uZC5oDQo+IGluZGV4IGIx
OTllZWEzMjYwZS4uMjYzYjdkZGUwZjg3IDEwMDY0NA0KPiAtLS0gYS9kcml2ZXJzL252ZGltbS9u
ZC5oDQo+ICsrKyBiL2RyaXZlcnMvbnZkaW1tL25kLmgNCj4gQEAgLTM2Niw5ICszNjYsOCBAQCB1
bnNpZ25lZCBzaXplb2ZfbmFtZXNwYWNlX2xhYmVsKHN0cnVjdCBudmRpbW1fZHJ2ZGF0YSAqbmRk
KTsNCj4gwqAJCQlyZXM7IHJlcyA9IG5leHQsIG5leHQgPSBuZXh0ID8gbmV4dC0+c2libGluZyA6
IE5VTEwpDQo+IMKgDQo+IMKgc3RydWN0IG5kX3BlcmNwdV9sYW5lIHsNCj4gLQlpbnQgY291bnQ7
DQo+IC0Jc3BpbmxvY2tfdCBsb2NrOw0KPiAtfTsNCj4gKwlzdHJ1Y3QgbXV0ZXggbG9jazsgLyog
c2VyaWFsaXplIGxhbmUgYWNjZXNzICovDQo+ICt9IF9fX19jYWNoZWxpbmVfYWxpZ25lZF9pbl9z
bXA7DQoNCkRvZXMgdGhpcyBhbHNvIG9ic29sZXRlIHRoZSBuZF9wZXJjcHVfbGFuZSBuYW1pbmc/
IE1heWJlIHJlbmFtZSB0aGUNCnN0cnVjdCB0byBuZF9sYW5lIHRvbyB0byBhdm9pZCBhbnkgZnV0
dXJlIGNvbmZ1c2lvbj8NCg0K
