Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 220AB14CAAA
	for <nvdimm@lists.linux.dev>; Fri, 23 Feb 2024 22:07:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.18
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708726068; cv=fail; b=sthsXmmyrvLiGKN1WMVpS0lwOtBQh1lEE34hNjJPmg+oo/HxKokLFkCQGK9AGoGG+0nx4FinUnnzXVjX1XVvd5dUA/blV/VW+L5l45Cq9YW9NYJ3dDWgNrKzZe3i1pp2hwL7FqEIIaM+YScKwokDC7/JMhMwriI5YibAIbTA2Fo=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708726068; c=relaxed/simple;
	bh=q7HJUm/zaTnCW2NUe7C1juXMpcsQ2vuyW+O8HXEbav0=;
	h=From:To:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=PhYWq9RQNbH3c5sFQlGrK+Rt6z0OvdCRFqET9E2ZQs0ZJS7CiSdZy7kJ7ww7SjuR7ToxrsHUZjAN5zZ+XvNwpNq/bLvRU6CTGLvY8OOISIF6JAY17oC8AduLYeDqvq4M0uQRzR/kVrD99ilhCsPf+N3nZsP7noWpMlKyr/2mJnk=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=a+LskQFH; arc=fail smtp.client-ip=198.175.65.18
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="a+LskQFH"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1708726066; x=1740262066;
  h=from:to:subject:date:message-id:references:in-reply-to:
   content-id:content-transfer-encoding:mime-version;
  bh=q7HJUm/zaTnCW2NUe7C1juXMpcsQ2vuyW+O8HXEbav0=;
  b=a+LskQFHaort7OPR/N+/Hvxff8rTXQBDNoyrEYcBSAZeLBcYe88h7+hA
   S/mP6Q1wfYtGw4cREeWZNl9df6D4B6WNWWtEKkpnSvyd54WnAHZ8a1QDn
   hUiaEuN2BzfVv/BnEfD7pltOw+P2BNkHuDP3e2cZoHHHttaI+zvL6+Ig3
   uUMRuqn9H3qTo3zQmdAnhzd4OsuaiA3Mw+LU1QBkC6lyQEZqhGtuLaLXB
   FASET1XOwzo5SoHW/CqA3YSrC0PftPtRKCNigf2lR6wgL+cgXFMri8Rp8
   lNnIxmaG2lW0oqMhmnx6gJlGinYzPQvW8OvfScQ3u9VWbVDiYDLN7R1wI
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10993"; a="3196206"
X-IronPort-AV: E=Sophos;i="6.06,180,1705392000"; 
   d="scan'208";a="3196206"
Received: from fmviesa008.fm.intel.com ([10.60.135.148])
  by orvoesa110.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Feb 2024 14:07:46 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.06,180,1705392000"; 
   d="scan'208";a="6186488"
Received: from orsmsx602.amr.corp.intel.com ([10.22.229.15])
  by fmviesa008.fm.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 23 Feb 2024 14:07:45 -0800
Received: from orsmsx611.amr.corp.intel.com (10.22.229.24) by
 ORSMSX602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35; Fri, 23 Feb 2024 14:07:44 -0800
Received: from orsmsx612.amr.corp.intel.com (10.22.229.25) by
 ORSMSX611.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35; Fri, 23 Feb 2024 14:07:44 -0800
Received: from ORSEDG602.ED.cps.intel.com (10.7.248.7) by
 orsmsx612.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35 via Frontend Transport; Fri, 23 Feb 2024 14:07:44 -0800
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (104.47.56.168)
 by edgegateway.intel.com (134.134.137.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.35; Fri, 23 Feb 2024 14:07:43 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=P5mncZBW4YBy99GZdJWyNdmqOYEhfaiTjzxs7VJ7WN7mSUxLpUKmlABG2xq6kf+Hq6RrQ/tEo4dDPa78qSPCLTIls+t/R5bKxTX+a9pu+Af0fhZVuynaYlMdJ1uUxnvkro7dTekwDeO6ca6SMhSDI5snQXctICwm+3srTx7T5EUo/WdXQdLjE33X3qby+7U4BazUVID/st9QmV6Pgee8cglygqk+PUbLsnet3bEciWuKUgpQBFTlJehCBcjR+uvDVgv+89wFd9bQP8bHtYL34+/Le3Tj1l85fFfCmoV9JEqx1wYYcyK+/TlBOiJAq6RctWFhDs4RbpOLrSBUzGJbiw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=q7HJUm/zaTnCW2NUe7C1juXMpcsQ2vuyW+O8HXEbav0=;
 b=Jdec0FDDarEPRJsrd7fndOIj72KoJ3potBm/Ld6UkiMgjnjGqh3ZDFknDnz0Tx0FfyyBUsqz45ZTdWg5vBHF4jVBLAAw8mlProL7LKe7i4MZmZM9Ee0b7iasWqtwHC/tB2DDSpKPERwRFVdYEDXX+7yG3IjVyviz8EdBwxuedUTFaFu1MupVe5jnweBr+LWHQNnXQhUvwiCQj3o4uwAmrun06ENVKB/yewZlafJmTtaFpF+USrpdFrBanL0MhxR/mcTAOaZR7i6I1g994Yswhz2xBJ1w3W0ScY7IvTNCO8u1SnAkJwGaEIS1BzX3BHrJDW/MyMc6mQzSFMVbXvExmw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from MW4PR11MB7125.namprd11.prod.outlook.com (2603:10b6:303:219::12)
 by DS0PR11MB7532.namprd11.prod.outlook.com (2603:10b6:8:147::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7339.10; Fri, 23 Feb
 2024 22:07:41 +0000
Received: from MW4PR11MB7125.namprd11.prod.outlook.com
 ([fe80::e28a:f124:d986:c1d0]) by MW4PR11MB7125.namprd11.prod.outlook.com
 ([fe80::e28a:f124:d986:c1d0%5]) with mapi id 15.20.7316.018; Fri, 23 Feb 2024
 22:07:41 +0000
From: "Verma, Vishal L" <vishal.l.verma@intel.com>
To: "Jiang, Dave" <dave.jiang@intel.com>, "linux-cxl@vger.kernel.org"
	<linux-cxl@vger.kernel.org>, "nvdimm@lists.linux.dev"
	<nvdimm@lists.linux.dev>
Subject: Re: [NDCTL PATCH v7 4/4] ndctl: add test for qos_class in CXL test
 suite
Thread-Topic: [NDCTL PATCH v7 4/4] ndctl: add test for qos_class in CXL test
 suite
Thread-Index: AQHaWsuQDbCrvgUh4UO76ILaNpl9J7EYk9cA
Date: Fri, 23 Feb 2024 22:07:41 +0000
Message-ID: <fab7eaa31a7211bc62f17afb5aea47c2cc8dfe87.camel@intel.com>
References: <20240208201435.2081583-1-dave.jiang@intel.com>
	 <20240208201435.2081583-5-dave.jiang@intel.com>
In-Reply-To: <20240208201435.2081583-5-dave.jiang@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.50.3 (3.50.3-1.fc39) 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: MW4PR11MB7125:EE_|DS0PR11MB7532:EE_
x-ms-office365-filtering-correlation-id: 1d4cd61d-3ab1-4bc6-4f97-08dc34bbdacf
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: /NEdEg77IrLU9KXpMgPkPIVrBb7HldCerpSimJiQda6tgR+UdXDmc1xm4fRh1BxEIcEEjT5PL5ikqyJqepUisnPJAIormeyQB7QS7czRNTpXAiG2CzgQ5vtinSJicVFLaxYWZgNAWHZDICmwdp03t9qxWDKGBxHjOIwPvOLHLxWn6s7aHDiYI0fZwXw3cBJdSm9v72gx5zRm5O0pMeh02zjOHvnKiR6CS7fA9XVXG3wrqylTbw+q32dJ67RwvckfwhQrEyTkiyuolfdiXFvG63z7Aa0qQE+utmXPg9uGeH2svqxLPQdPuqxY4GrGelwRJEjkVqdfxEgK5WzJz1y3ksaGsqp+S9N2+ykuCIHRVouUUUPYDLBhgwUZ869AQ5fwmqSxQVUamAZDXZun9JOWgihsgvORK9aVeIX1aFct10m1choRoPS92aLwNLM/hEBhQPUIV+fTPFD35wuoJ7l2d/WhJmyTbKT+vosRfqxgDhflCuFItpjfi4mCzi9+AdPJqvCf7exwj+FzLNo4n14s5Jbqgds5KG2caLt2EgiJEoYiaMKfbesesZj3n500w3w4H03AVC7smGOUoznDrRSFMkD0mt7t2Gbw8zWkpm9rxFi689sk0zDUGr8bcV5YaeCH
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MW4PR11MB7125.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(38070700009);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?NWczUVJQTllLQVA5c3pmemxzdXdycTExaFgxNENNY09uT29WemVPS0UyZlFH?=
 =?utf-8?B?L3Q0YkhuK0d0RUFKbzVNeGVSZk9jNDZPcURsUXJUZDZYcnpKS0xXRVJnZlJJ?=
 =?utf-8?B?d2ZBNzRGWk1lcGp6dkN1ZE9LVThiVnRNSjAzVVRGdmp2RnEzZmFxcFlQdEZr?=
 =?utf-8?B?SVhJNmdzTkREeFdUZ1VZNEZLUFpTT3IySW0raDdJbkVHamlzVFhadjJDV1RP?=
 =?utf-8?B?by9vYXp2L21mc0FZckg1NzZtbVczcTVjYUlxWk1YVmNRdDBXUks2bFUrcEJt?=
 =?utf-8?B?c3pzbDd2ZnEyQUdxOW8xRWtPS083NytmNmFiSWlYUEZrWGErLzY0QkxIR002?=
 =?utf-8?B?a2x1SXR0OURGdWNmbHJTQzFFNzhFRkJoYVc0Z0tDRmRaakVjVUMrdnkwSW9x?=
 =?utf-8?B?UTVjcytQZ292NHphSjFJbVQvb1RVVnJsYkdWQ295NitKLzlpRG9lSHY0VVFL?=
 =?utf-8?B?cUgzWGw3cGREck9DUnpkTXMyc2RlU1VkMStsUlZ1RUlyQXBwN2FKK1Nua2do?=
 =?utf-8?B?eUpmd21LWEQvc280VEV0UDlXM2IwMm1KemVrQzJjV2M4NGRwd1dYTlV5dmlC?=
 =?utf-8?B?N0JkNWtKMDZVdnhJMHRlakdORWh0bGlMOHJhNDVPaWZaajZoNXdSMS94ODNN?=
 =?utf-8?B?VW00R29BMnFEZmlJaW80TFVDRW83TWRkMFkzclhHR0VjZjdjWitDS1QwZWxr?=
 =?utf-8?B?NkR1U2pqTWZFdUU3eTR1eHdPdnh1NmdyeDVZTlUzejNZZzlXNmk0VmNrcVFl?=
 =?utf-8?B?REtiaDlJbk5KTUFPdUE5WUFnOTBTOWhxYlArQzlCQjFnU0VoUFpUMFRqRUx5?=
 =?utf-8?B?RXZPK1RpZlVJTXc2SldwcUJqaHlBK2p0bnVlUWJkYUV1cU5CbHJNRW5sRXRJ?=
 =?utf-8?B?VU51MU1MZENiRHZlZHFUa3BxTkp1SStNS05CK2cvck9jZGVvZ3o0bGhGeTVu?=
 =?utf-8?B?dGVlRGc3SUI4TFB4R045SmFHdFR4WXJlb3EvY3dYaEE5bGNxTTZDVmluSVJG?=
 =?utf-8?B?QnVOUTZ5UTd4OXB0M29wdVBJNkIrcFFqdE13UGQvUnA0c1ZUSXhGcndkT2Rh?=
 =?utf-8?B?cXlPNU1FRkxBVEYvL1p2RjcxMWVCR2lLZFFMTkdHeTZlOGV0ZHFWRlhRSm1o?=
 =?utf-8?B?aEF5MDR3R2NWRjZ4d2lsTE9VR0dnZE10cTM2aEovU2xJcVF1OWlTa1kwWkYr?=
 =?utf-8?B?Z1E5elVjN1NhbXBYVWwrRmh2NlppcmN5WUZsdjZNS2RidFo1QTdyK3c3Q3hI?=
 =?utf-8?B?OUZKTE1mb1V2SExNWFRaUm1pZlFwMzNtWUFoNkNkMGFCNTM0c3pJWVZpWXZy?=
 =?utf-8?B?V2NLMnFoVmYyRGlZVEdZenZkQ2dVVGZ5cks4YittUEpnQ2VyREExa1pHNUZO?=
 =?utf-8?B?TlVPUk14Z2RmSnJrWnBOK2FCOHI0djQ0d01QQ2pQSnd4bnVaQWtTb2hkVG9V?=
 =?utf-8?B?Tm1aRUlQT3ZDQ3pGWXpJK0Q5aVhmdDlUN2pZdW92RGdUSU5kWnc5eUNyQmtI?=
 =?utf-8?B?Z21Xb3pNQUFsbFVRY295RUMxVFQzbkFyVmloNWtDdUlEM0I1N3R6OWp2cGUr?=
 =?utf-8?B?S1I5blJQTmYzMm45Sm9hcXZzalpXd3JVdW83OGdONjJvL3YyVWFKNS9DcDc3?=
 =?utf-8?B?UnladXhVMGZQbWRoVWNHTitrTjRra0QraE80a3RVQ2NwQ29vWGdJSmNmNy9w?=
 =?utf-8?B?SkN3OGdaRWdyMjY0RmZmSjFwQmM2ekp3SWU0TzZNYXRPdG4wYnptb2VEbytS?=
 =?utf-8?B?STEyVmZlWkhURXcvbFdvcmpvMmlVREtzaFpzNGVjSElnL2paNlNjOS9vU3Mw?=
 =?utf-8?B?YUs2amZjTWdDbkpUbjVESjZRZUpYdkI4SmlBOFdVemRyMTJxRjdsNnlrOWJz?=
 =?utf-8?B?WHFmR0pmYlNvTFJOOURDTGlqcWxPRkJLeEg3VGxmUlBOemRXQzNPQlJTRWZu?=
 =?utf-8?B?aHdXNXB1MGp6ZWhHeG1lWFRFT1lLa0VIcExFRjRsT0ljeDBTTHQrM0Mrakpa?=
 =?utf-8?B?eXRuRG9JTGk5a1FtSWJGY1RuRDFISDFVbFZ6UllJQkZKcFlzK0NTYWpBdi9R?=
 =?utf-8?B?RkViSkM5S0xqSkhaWVBTbG5SQ0plV3huTUxZQUIvT1pPNFhtWGZUN1RRMVNr?=
 =?utf-8?B?Z1gxZG11RURXMUUxN1ZidU83TmdqQmZjVGFQUjUyQkF1b0RnQ0dFU0Nub2Va?=
 =?utf-8?B?M2c9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <B6D29590FF3B9C4E93A97705425A8842@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MW4PR11MB7125.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1d4cd61d-3ab1-4bc6-4f97-08dc34bbdacf
X-MS-Exchange-CrossTenant-originalarrivaltime: 23 Feb 2024 22:07:41.4147
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: rId0VjkGfCRaPe+4wm98FGi/pgRDEM6bzavdyhPsHEeKPAH39fxtCniV2roDJcHNi6xb9rLazZs9idWjBHogzV0+jccJStiCJp7qrlC3zAE=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR11MB7532
X-OriginatorOrg: intel.com

T24gVGh1LCAyMDI0LTAyLTA4IGF0IDEzOjExIC0wNzAwLCBEYXZlIEppYW5nIHdyb3RlOg0KPiBB
ZGQgdGVzdHMgaW4gY3hsLXFvcy1jbGFzcy5zaCB0byB2ZXJpZnkgcW9zX2NsYXNzIGFyZSBzZXQg
d2l0aCB0aGUgZmFrZQ0KPiBxb3NfY2xhc3MgY3JlYXRlIGJ5IHRoZSBrZXJuZWwuwqAgUm9vdCBk
ZWNvZGVycyBzaG91bGQgaGF2ZSBxb3NfY2xhc3MNCj4gYXR0cmlidXRlIHNldC4gTWVtb3J5IGRl
dmljZXMgc2hvdWxkIGhhdmUgcmFtX3Fvc19jbGFzcyBvciBwbWVtX3Fvc19jbGFzcw0KPiBzZXQg
ZGVwZW5kaW5nIG9uIHdoaWNoIHBhcnRpdGlvbnMgYXJlIHZhbGlkLg0KPiANCj4gU2lnbmVkLW9m
Zi1ieTogRGF2ZSBKaWFuZyA8ZGF2ZS5qaWFuZ0BpbnRlbC5jb20+DQo+IC0tLQ0KPiB2NzoNCj4g
LSBBZGQgY3JlYXRlX3JlZ2lvbiAtUSB0ZXN0aW5nIChWaXNoYWwpDQo+IC0tLQ0KPiDCoHRlc3Qv
Y29tbW9uwqDCoMKgwqDCoMKgwqDCoMKgwqAgfMKgwqAgNCArKw0KPiDCoHRlc3QvY3hsLXFvcy1j
bGFzcy5zaCB8IDEwMiArKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysN
Cj4gwqB0ZXN0L21lc29uLmJ1aWxkwqDCoMKgwqDCoCB8wqDCoCAyICsNCj4gwqAzIGZpbGVzIGNo
YW5nZWQsIDEwOCBpbnNlcnRpb25zKCspDQo+IMKgY3JlYXRlIG1vZGUgMTAwNzU1IHRlc3QvY3hs
LXFvcy1jbGFzcy5zaA0KPiANCj4gZGlmZiAtLWdpdCBhL3Rlc3QvY29tbW9uIGIvdGVzdC9jb21t
b24NCj4gaW5kZXggZjEwMjNlZjIwZjdlLi41Njk0ODIwYzdhZGMgMTAwNjQ0DQo+IC0tLSBhL3Rl
c3QvY29tbW9uDQo+ICsrKyBiL3Rlc3QvY29tbW9uDQo+IEBAIC0xNTAsMyArMTUwLDcgQEAgY2hl
Y2tfZG1lc2coKQ0KPiDCoAlncmVwIC1xICJDYWxsIFRyYWNlIiA8PDwgJGxvZyAmJiBlcnIgJDEN
Cj4gwqAJdHJ1ZWANCj4gwqB9DQo+ICsNCj4gKw0KPiArIyBDWEwgQ09NTU9ODQo+ICtURVNUX1FP
U19DTEFTUz00Mg0KPiBkaWZmIC0tZ2l0IGEvdGVzdC9jeGwtcW9zLWNsYXNzLnNoIGIvdGVzdC9j
eGwtcW9zLWNsYXNzLnNoDQo+IG5ldyBmaWxlIG1vZGUgMTAwNzU1DQo+IGluZGV4IDAwMDAwMDAw
MDAwMC4uMTQ1ZGY2MTM0Njg1DQo+IC0tLSAvZGV2L251bGwNCj4gKysrIGIvdGVzdC9jeGwtcW9z
LWNsYXNzLnNoDQo+IEBAIC0wLDAgKzEsMTAyIEBADQo+ICsjIS9iaW4vYmFzaA0KPiArIyBTUERY
LUxpY2Vuc2UtSWRlbnRpZmllcjogR1BMLTIuMA0KPiArIyBDb3B5cmlnaHQgKEMpIDIwMjQgSW50
ZWwgQ29ycG9yYXRpb24uIEFsbCByaWdodHMgcmVzZXJ2ZWQuDQo+ICsNCj4gKy4gJChkaXJuYW1l
ICQwKS9jb21tb24NCj4gKw0KPiArcmM9NzcNCj4gKw0KPiArc2V0IC1leA0KPiArDQo+ICt0cmFw
ICdlcnIgJExJTkVOTycgRVJSDQo+ICsNCj4gK2NoZWNrX3ByZXJlcSAianEiDQo+ICsNCj4gK21v
ZHByb2JlIC1yIGN4bF90ZXN0DQo+ICttb2Rwcm9iZSBjeGxfdGVzdA0KPiArcmM9MQ0KPiArDQo+
ICtjaGVja19xb3NfZGVjb2RlcnMgKCkgew0KPiArCSMgY2hlY2sgcm9vdCBkZWNvZGVycyBoYXZl
IGV4cGVjdGVkIGZha2UgcW9zX2NsYXNzDQo+ICsJIyBhbHNvIG1ha2Ugc3VyZSB0aGUgbnVtYmVy
IG9mIHJvb3QgZGVjb2RlcnMgZXF1YWwgdG8gdGhlIG51bWJlcg0KPiArCSMgd2l0aCBxb3NfY2xh
c3MgZm91bmQNCj4gKwlqc29uPSQoJENYTCBsaXN0IC1iIGN4bF90ZXN0IC1EIC1kIHJvb3QpDQo+
ICsJZGVjb2RlcnM9JChlY2hvICIkanNvbiIgfCBqcSBsZW5ndGgpDQo+ICsJY291bnQ9MA0KPiAr
CXdoaWxlIHJlYWQgLXIgcW9zX2NsYXNzDQo+ICsJZG8NCg0KRm9yIGNvbnNpc3RlbmN5LCB0aGUg
c2NyaXB0IGJhc2VkIHRlc3RzIGFsbCBoYXZlIHRoZSB3aGlsZS4uZG8sDQpmb3IuLmRvLCBpZi4u
dGhlbiBiaXRzIG9uIHRoZSBzYW1lIGxpbmUuIFdvdWxkIGJlIG5pY2Ugbm90IHRvIGJyZWFrDQp0
aGF0IHByZWNlZGVudC4NCg0KPiArCQkoKHFvc19jbGFzcyA9PSBURVNUX1FPU19DTEFTUykpIHx8
IGVyciAiJExJTkVOTyINCj4gKwkJY291bnQ9JCgoY291bnQrMSkpDQo+ICsJZG9uZSA8PDwgIiQo
ZWNobyAiJGpzb24iIHwganEgLXIgJy5bXSB8IC5xb3NfY2xhc3MnKSINCj4gKw0KPiArCSgoY291
bnQgPT0gZGVjb2RlcnMpKSB8fCBlcnIgIiRMSU5FTk8iOw0KPiArfQ0KPiArDQo+ICtjaGVja19x
b3NfbWVtZGV2cyAoKSB7DQo+ICsJIyBDaGVjayB0aGF0IG1lbWRldnMgdGhhdCBleHBvc2UgcmFt
X3Fvc19jbGFzcyBvciBwbWVtX3Fvc19jbGFzcyBoYXZlDQo+ICsJIyBleHBlY3RlZCBmYWtlIHZh
bHVlIHByb2dyYW1tZWQuDQo+ICsJanNvbj0kKGN4bCBsaXN0IC1iIGN4bF90ZXN0IC1NKQ0KPiAr
CXJlYWRhcnJheSAtdCBsaW5lcyA8IDwoanEgIi5bXSB8IC5yYW1fc2l6ZSwgLnBtZW1fc2l6ZSwg
LnJhbV9xb3NfY2xhc3MsIC5wbWVtX3Fvc19jbGFzcyIgPDw8IiRqc29uIikNCj4gKwlmb3IgKCgg
aSA9IDA7IGkgPCAkeyNsaW5lc1tAXX07IGkgKz0gNCApKQ0KPiArCWRvDQo+ICsJCXJhbV9zaXpl
PSR7bGluZXNbaV19DQo+ICsJCXBtZW1fc2l6ZT0ke2xpbmVzW2krMV19DQo+ICsJCXJhbV9xb3Nf
Y2xhc3M9JHtsaW5lc1tpKzJdfQ0KPiArCQlwbWVtX3Fvc19jbGFzcz0ke2xpbmVzW2krM119DQoN
CkhtIGluc3RlYWQgb2Ygc3BsaXR0aW5nIGludG8gbGluZXMsIGFuZCB0aGVuIGxvb3BpbmcgdGhy
b3VnaCB0aGVtLCB3aHkNCm5vdCBqdXN0IGludm9rZSBqcSBmb3IgZWFjaD8NCg0KcmFtX3NpemU9
JChqcSAiLltdIHwgLnJhbV9zaXplIiA8PDwgJGpzb24pDQpwbWVtX3NpemU9JChqcSAiLltdIHwg
LnBtZW1fc2l6ZSIgPDw8ICRqc29uKQ0KLi4uZXRjDQoNCj4gKw0KPiArCQlpZiBbWyAiJHJhbV9z
aXplIiAhPSBudWxsIF1dDQo+ICsJCXRoZW4NCj4gKwkJCSgocmFtX3Fvc19jbGFzcyA9PSBURVNU
X1FPU19DTEFTUykpIHx8IGVyciAiJExJTkVOTyINCj4gKwkJZmkNCg0KVGhpcyBtaWdodCBiZSBh
IGJpdCBtb3JlIHJlYWRhYmxlIGFzOg0KDQppZiBbWyAiJHJhbV9zaXplIiAhPSBudWxsIF1dICYm
ICgocmFtX3Fvc19jbGFzcyAhPSBURVNUX1FPU19DTEFTUykpOyB0aGVuDQoJZXJyICIkTElORU5P
Ig0KZmkNCg0KPiArCQlpZiBbWyAiJHBtZW1fc2l6ZSIgIT0gbnVsbCBdXQ0KPiArCQl0aGVuDQo+
ICsJCQkoKHBtZW1fcW9zX2NsYXNzID09IFRFU1RfUU9TX0NMQVNTKSkgfHwgZXJyICIkTElORU5P
Ig0KPiArCQlmaQ0KPiArCWRvbmUNCj4gK30NCj4gKw0KPiArIyBCYXNlZCBvbiBjeGwtY3JlYXRl
LXJlZ2lvbi5zaCBjcmVhdGVfc2luZ2xlKCkNCj4gK2Rlc3Ryb3lfcmVnaW9ucygpDQo+ICt7DQo+
ICsJaWYgW1sgIiQqIiBdXTsgdGhlbg0KPiArCQkkQ1hMIGRlc3Ryb3ktcmVnaW9uIC1mIC1iIGN4
bF90ZXN0ICIkQCINCj4gKwllbHNlDQo+ICsJCSRDWEwgZGVzdHJveS1yZWdpb24gLWYgLWIgY3hs
X3Rlc3QgYWxsDQo+ICsJZmkNCj4gK30NCj4gKw0KPiArY3JlYXRlX3JlZ2lvbl9jaGVja19xb3Mo
KQ0KPiArew0KPiArCSMgdGhlIDV0aCBjeGxfdGVzdCBkZWNvZGVyIGlzIGV4cGVjdGVkIHRvIHRh
cmdldCBhIHNpbmdsZS1wb3J0DQo+ICsJIyBob3N0LWJyaWRnZS4gT2xkZXIgY3hsX3Rlc3QgaW1w
bGVtZW50YXRpb25zIG1heSBub3QgZGVmaW5lIGl0LA0KPiArCSMgc28gc2tpcCB0aGUgdGVzdCBp
biB0aGF0IGNhc2UuDQo+ICsJZGVjb2Rlcj0kKCRDWEwgbGlzdCAtYiBjeGxfdGVzdCAtRCAtZCBy
b290IHwNCj4gKwkJwqAganEgLXIgIi5bNF0gfA0KPiArCQnCoCBzZWxlY3QoLnBtZW1fY2FwYWJs
ZSA9PSB0cnVlKSB8DQo+ICsJCcKgIHNlbGVjdCgubnJfdGFyZ2V0cyA9PSAxKSB8DQo+ICsJCcKg
IC5kZWNvZGVyIikNCj4gKw0KPiArwqDCoMKgwqDCoMKgwqAgaWYgW1sgISAkZGVjb2RlciBdXTsg
dGhlbg0KPiArwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgIGVjaG8gIm5vIHNpbmdsZS1w
b3J0IGhvc3QtYnJpZGdlIGRlY29kZXIgZm91bmQsIHNraXBwaW5nIg0KPiArwqDCoMKgwqDCoMKg
wqDCoMKgwqDCoMKgwqDCoMKgIHJldHVybg0KPiArwqDCoMKgwqDCoMKgwqAgZmkNCj4gKw0KPiAr
CSMgU2VuZCBjcmVhdGUtcmVnaW9uIHdpdGggLVEgdG8gZW5mb3JjZSBxb3NfY2xhc3MgbWF0Y2hp
bmcNCj4gKwlyZWdpb249JCgkQ1hMIGNyZWF0ZS1yZWdpb24gLVEgLWQgIiRkZWNvZGVyIiB8IGpx
IC1yICIucmVnaW9uIikNCj4gKwlpZiBbWyAhICRyZWdpb24gXV07IHRoZW4NCj4gKwkJZWNobyAi
ZmFpbGVkIHRvIGNyZWF0ZSBzaW5nbGUtcG9ydCBob3N0LWJyaWRnZSByZWdpb24iDQo+ICsJCWVy
ciAiJExJTkVOTyINCj4gKwlmaQ0KPiArDQo+ICsJZGVzdHJveV9yZWdpb25zICIkcmVnaW9uIg0K
PiArfQ0KPiArDQo+ICtjaGVja19xb3NfZGVjb2RlcnMNCj4gKw0KPiArY2hlY2tfcW9zX21lbWRl
dnMNCj4gKw0KPiArY3JlYXRlX3JlZ2lvbl9jaGVja19xb3MNCj4gKw0KPiArY2hlY2tfZG1lc2cg
IiRMSU5FTyINCj4gKw0KPiArbW9kcHJvYmUgLXIgY3hsX3Rlc3QNCj4gZGlmZiAtLWdpdCBhL3Rl
c3QvbWVzb24uYnVpbGQgYi90ZXN0L21lc29uLmJ1aWxkDQo+IGluZGV4IDVlYjM1NzQ5YTk1Yi4u
NDg5MmRmMTExMTlmIDEwMDY0NA0KPiAtLS0gYS90ZXN0L21lc29uLmJ1aWxkDQo+ICsrKyBiL3Rl
c3QvbWVzb24uYnVpbGQNCj4gQEAgLTE2MCw2ICsxNjAsNyBAQCBjeGxfZXZlbnRzID0gZmluZF9w
cm9ncmFtKCdjeGwtZXZlbnRzLnNoJykNCj4gwqBjeGxfcG9pc29uID0gZmluZF9wcm9ncmFtKCdj
eGwtcG9pc29uLnNoJykNCj4gwqBjeGxfc2FuaXRpemUgPSBmaW5kX3Byb2dyYW0oJ2N4bC1zYW5p
dGl6ZS5zaCcpDQo+IMKgY3hsX2Rlc3Ryb3lfcmVnaW9uID0gZmluZF9wcm9ncmFtKCdjeGwtZGVz
dHJveS1yZWdpb24uc2gnKQ0KPiArY3hsX3Fvc19jbGFzcyA9IGZpbmRfcHJvZ3JhbSgnY3hsLXFv
cy1jbGFzcy5zaCcpDQo+IMKgDQo+IMKgdGVzdHMgPSBbDQo+IMKgwqAgWyAnbGlibmRjdGwnLMKg
wqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqAgbGlibmRjdGwsCQnCoCAnbmRjdGwnIF0sDQo+IEBA
IC0xOTIsNiArMTkzLDcgQEAgdGVzdHMgPSBbDQo+IMKgwqAgWyAnY3hsLXBvaXNvbi5zaCcswqDC
oMKgwqDCoMKgwqDCoMKgIGN4bF9wb2lzb24swqDCoMKgwqDCoMKgwqDCoCAnY3hsJ8KgwqAgXSwN
Cj4gwqDCoCBbICdjeGwtc2FuaXRpemUuc2gnLMKgwqDCoMKgwqDCoMKgIGN4bF9zYW5pdGl6ZSzC
oMKgwqDCoMKgwqAgJ2N4bCfCoMKgIF0sDQo+IMKgwqAgWyAnY3hsLWRlc3Ryb3ktcmVnaW9uLnNo
JyzCoCBjeGxfZGVzdHJveV9yZWdpb24sICdjeGwnwqDCoCBdLA0KPiArwqAgWyAnY3hsLXFvcy1j
bGFzcy5zaCcswqDCoMKgwqDCoMKgIGN4bF9xb3NfY2xhc3MswqDCoMKgwqDCoCAnY3hsJ8KgwqAg
XSwNCj4gwqBdDQo+IMKgDQo+IMKgaWYgZ2V0X29wdGlvbignZGVzdHJ1Y3RpdmUnKS5lbmFibGVk
KCkNCg0K
