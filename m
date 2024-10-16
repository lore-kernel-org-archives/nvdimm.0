Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.15])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6CCD0199237
	for <nvdimm@lists.linux.dev>; Wed, 16 Oct 2024 22:45:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.15
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729118754; cv=fail; b=E6Ni9bnQhk72eVu2ar8zh6RED7bXSwHWFNtfel0SKxZ7tgefLCAzX28K4jWP1FLvrqcOqoki6Ir8qkXwuhxU8fevaybwMi8UeoeW2ksAXeMkZxBXjzntXS1mq1DKD/a9lwgYp2pWzFNnCy5n6eSrOFTg6DGHUdxnxCp1/JTL/Xg=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729118754; c=relaxed/simple;
	bh=g1q+8+odkE32GIRvc2Ikv+IxusRMW/zoCYRvoEds0Og=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=NHIL4zO/2MkgovmLEujIWwiwjTpmiPPW/EBOwhKbQ4hbrTawRIXvoZmPBP4Ahc7E8fO7cWiLmPLp8U4wWlG2xzOdVwzL3XMYQZYa++D8pmHUBiPJJCIPIoKc+lGde41/wesSKCnSzY13M/NozWe/EIXWRcbIngjz/0gaFRlDkKk=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=InYtzM1d; arc=fail smtp.client-ip=198.175.65.15
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="InYtzM1d"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1729118753; x=1760654753;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=g1q+8+odkE32GIRvc2Ikv+IxusRMW/zoCYRvoEds0Og=;
  b=InYtzM1d9mM6UqUKrtwbossHCU+qzJUSoqpXvYR6GhgM06qsrJ0zhhiD
   Y3avZukqcMfGLipobHqWN831SCjh/9y69hzD5Ax97gZsA9Z2EEgJ3DCFT
   UTZJ5duwpY/ZXzgTNwr5ODzB8+gL4bp/pNKeUmNhCmAlcirNns/Zsip9t
   4Qe/jQOpVDrDI0gnADuCsLrggFpSxbCwvFVWennoC29++wexIiBvhOBr3
   uxL0Jc0b1aXQn+yTCboIujUuTHZQdxE0yvx+AcRuysT0C0IjBym4Hbv2c
   LgUd+Ccih3nOdMXaGg8gdJhKCd4lWTsKSnEbiTcUR+7q2g3SUm/7XnBPZ
   A==;
X-CSE-ConnectionGUID: g6auOeksTOSAI+EX+o5eLA==
X-CSE-MsgGUID: 7ZesCM6eQEmFK37y72K1lg==
X-IronPort-AV: E=McAfee;i="6700,10204,11222"; a="32278092"
X-IronPort-AV: E=Sophos;i="6.11,199,1725346800"; 
   d="scan'208";a="32278092"
Received: from fmviesa009.fm.intel.com ([10.60.135.149])
  by orvoesa107.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Oct 2024 15:45:52 -0700
X-CSE-ConnectionGUID: 8BYux5XDQwWn5p2Crcj8eA==
X-CSE-MsgGUID: DsA7Q7+HSxiCgLNx2UXlMg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.11,209,1725346800"; 
   d="scan'208";a="78387837"
Received: from fmsmsx602.amr.corp.intel.com ([10.18.126.82])
  by fmviesa009.fm.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 16 Oct 2024 15:45:51 -0700
Received: from fmsmsx611.amr.corp.intel.com (10.18.126.91) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Wed, 16 Oct 2024 15:45:51 -0700
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx611.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Wed, 16 Oct 2024 15:45:50 -0700
Received: from fmsedg602.ED.cps.intel.com (10.1.192.136) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39 via Frontend Transport; Wed, 16 Oct 2024 15:45:50 -0700
Received: from NAM02-DM3-obe.outbound.protection.outlook.com (104.47.56.44) by
 edgegateway.intel.com (192.55.55.71) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.39; Wed, 16 Oct 2024 15:45:50 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=lUv3IwEp2DJ7pxXYgX4sxziRNNlQyPwRh71eqZKpLJfpvnKfZdzPURJvRKPXLRjucSJzzX0QgHJZa2PgwMGN5k1l1p9vbYHyfuwMC5a4/tU7G/Ya/rBP+mCe7mvSwKJJeBiitxWmdeXW0wRL7TXWawGEtMPCe15vBRIY/bhfaH32XXztVSuP8WUsn5LkZ7SrLRoVfH5rVn/jEhwaYAElgxMb4GwO48d8LE87dH2qtblT4XDEebKZp4p2qYsHlrr2+DBgEdgY4wQY/SCSntWethxomatVFebc0kaKl2PrG2NESPW+Eb/3ecGJFVPzKjiZojR85ZlwepIVzCYXcsahAA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=g1q+8+odkE32GIRvc2Ikv+IxusRMW/zoCYRvoEds0Og=;
 b=ASdkKjFP/pQpFhC7G4zSOei3BV/7YdHr+UOIJWqOA1oW3usVsWQtz6x1vSAkzhxxcTvxSpUEE6I0nherjfa79F6wWix7OWiG43ZlPrmfk7CY77HDEDpzYlHMFmL52NPqQ3mVyeHpfyhKi9/oISYvppEOtsqGDOVaopAefb3t11q0FNlpOhZbK53vCXBG344HfJzWPmzApdQRiXCpAoUOMtyLhR6ERL8gTIYNCVaeio4odkZmkw0J5F6W7Yf9NCwhc5YH1V9xQ+1JvoOghXDKBXKjFJAJ4075VmeNdqNLL4NNX2wbe4Rp9QdwIEs9qcw176kYOhWKEZhsK23LqPg6GQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from MW4PR11MB7125.namprd11.prod.outlook.com (2603:10b6:303:219::12)
 by SA2PR11MB4828.namprd11.prod.outlook.com (2603:10b6:806:110::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8069.17; Wed, 16 Oct
 2024 22:45:48 +0000
Received: from MW4PR11MB7125.namprd11.prod.outlook.com
 ([fe80::eff6:f7ef:65cd:8684]) by MW4PR11MB7125.namprd11.prod.outlook.com
 ([fe80::eff6:f7ef:65cd:8684%6]) with mapi id 15.20.8048.020; Wed, 16 Oct 2024
 22:45:48 +0000
From: "Verma, Vishal L" <vishal.l.verma@intel.com>
To: "lizhijian@fujitsu.com" <lizhijian@fujitsu.com>, "nvdimm@lists.linux.dev"
	<nvdimm@lists.linux.dev>
CC: "linux-cxl@vger.kernel.org" <linux-cxl@vger.kernel.org>
Subject: Re: [ndctl PATCH v2] test/monitor.sh: Fix 2 bash syntax errors
Thread-Topic: [ndctl PATCH v2] test/monitor.sh: Fix 2 bash syntax errors
Thread-Index: AQHbH4s1qPhxFcJeYkqYsJQ9beG6ZbKJ+zGA
Date: Wed, 16 Oct 2024 22:45:48 +0000
Message-ID: <92fec0671d491ce6eecc075233cc0e09ddea52e8.camel@intel.com>
References: <20241016052042.1138320-1-lizhijian@fujitsu.com>
In-Reply-To: <20241016052042.1138320-1-lizhijian@fujitsu.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.52.4 (3.52.4-1.fc40) 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: MW4PR11MB7125:EE_|SA2PR11MB4828:EE_
x-ms-office365-filtering-correlation-id: 8cd0076f-8bc7-42bd-384b-08dcee344761
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|366016|376014|1800799024|38070700018;
x-microsoft-antispam-message-info: =?utf-8?B?QzZ3ZHVNRmJOSEJzRk5SNWRuNG1GR2M3K3UyQVVFUHNDaWsvUGpYS04ybjEr?=
 =?utf-8?B?NXhtMmhranZwOXRDMWhvZHpDSVZEbDVNdkF5d2ZlczUveWdhUXpCblJTQ2Q5?=
 =?utf-8?B?dHZJNEpJS3dVLzFFVkhPckt1TFlTQm8vU2pDZWdWcWt1cDY2elZTcnFHZjhs?=
 =?utf-8?B?cFZNdFpoTXduUHhxa0Yrd2grSjhlVVFqUG9NdE95bU1HSVp3WEFuMVFHWTYz?=
 =?utf-8?B?SnhURk9FZXk2eWZ5QVVsMEVQbGVPKzVqYkxLajZDdEZidlFDWjFiMmlJMVhS?=
 =?utf-8?B?Vis1eExBc01MZzBDY3ZLRUJ0V0c4RUp5eHAyZDY5Q0RrZ2hzMzhhNUFQb0cr?=
 =?utf-8?B?OUpUN2owMExRc3VidlFJSW5YZmNxc1FtaVoyU1p1TTRscC9Ic3FZZWx0NnM4?=
 =?utf-8?B?a2E4RFJaL2syNjJPV0E1Ni96ZWpOTGkva3AwUmg3QmdXRWRTOFVLbisvRHNN?=
 =?utf-8?B?bXpCd2xjT2dtMXRreVg3QWVuSUJGdy81MWdrdHJRMk04L0ZKYnpERlVBYW9U?=
 =?utf-8?B?VkZsaFlJZVFoZXBFSktFOUlST1ZEUks0NFg1R2o2bE5rWXp6VDhBejNRdWxq?=
 =?utf-8?B?aVpjeDBtaCtlU0xSRjlnS2pobWMrQ0ZsSG4xYnZmeXNQWHovdUJsQklOam9M?=
 =?utf-8?B?cldYRlJ3cmRqazJiSXpSanJ5Zm1kQlJUeERONkkyQXp1cS9hUWVSWk13NE82?=
 =?utf-8?B?czNGby9zTHBJSjVwMEVIdjM5bzlVSG82WGJHLzNFOUlSbkdOZ2htdjlxV1Zl?=
 =?utf-8?B?RUIvbGpSQ1k0M1FtQlhkbFkwV2o0bTRtaHArb3pBc1BoYk0zMEk0ZzVMek1T?=
 =?utf-8?B?cnhUTVdZK3VJU1hzV1liS2pqZDFDQkhhQldTMFBLWUloR0ZRQ2k2V093aXdl?=
 =?utf-8?B?enFEdWlrSyt5NlpIbCtCTDRyVkdKbXRPd1pTRGxPdElwRU5aQ1U2YUVVZDhj?=
 =?utf-8?B?REdMb2tTOE5Nc3g2UDdZVXBlZTlXYXhOUlRLYmM3bC92TTdTNnQwWnFjeUJF?=
 =?utf-8?B?VXJRQXZldi9iL1ZnMnFwam0vZ0RRUXFTRDczeGNWMnVLaDRsRG9RZll6V0ov?=
 =?utf-8?B?Q1hjTStnTXVyQjBnYjJodUh0NDVNblRkZW5oVzROY1MwYVVlY0VScXVXOGg5?=
 =?utf-8?B?YTlYdWdpMHB5Z0dEUlNEbUd3UGovc1pBY1NLRytUMWJDYmoyNU9pa2pBOFhy?=
 =?utf-8?B?UHhBNUg4RG1NWHVZRDRDbDZRdzBUeTFqYkxNWlNyVXVNRUY3YmNKQW0vcEND?=
 =?utf-8?B?N1JVdWJnbmJCaG1TVjlqaVhTUUl4YVhZZDJOdlBHaWFTZnlZMlB2eWk3MFQz?=
 =?utf-8?B?ZWZFNC8rN0txcUh0SWZNR0hreEJ5OUQwVDIzaTYwNlY1K0dDK3UzSFJzL2R4?=
 =?utf-8?B?S0tENDJRNGlRQlVHQ2pIQVRYQ3Y1TG1jbnJQVnk5ZHdONXFZTU95T2hYREc0?=
 =?utf-8?B?bXRpRnlNbzlKM2poWGs2NHV3NUl4enk2VlFhZTdXb09iYitjdHcvcHJ2RGRq?=
 =?utf-8?B?L3h2aVFzeGRTMTJBL1BhU0g4YVRVVGhxaTFpZWl3Y3RHUlRXSlo3UklrcllS?=
 =?utf-8?B?cVdtb2x4YXk4aTNnN2h6NXR2dHplUmpqZVF5TjExZzJmb21KZ0I1VVd5VmM1?=
 =?utf-8?B?eEVZbWgybTU0N1NXM0JSdXRCNVh6NFBmU2t0VU9QRG9OVkNPZFZvdENGR1BZ?=
 =?utf-8?B?Mm8yVW5TK01aTU8zUFJLUm9aelRIUitYOHhGa0pQRS80ZWxlQ1UzbmZQSG9v?=
 =?utf-8?B?NVZHems1ckNWdkNYWGdXaVE5SWliZTM5WW1OSnV4Z1NSamN1UGx4Sm5UenZY?=
 =?utf-8?Q?y2imvA1zQxUPqKmYpN+/obDiIcTHeiBJIfyKo=3D?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MW4PR11MB7125.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(1800799024)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?eXdpTXYxSUpmWW1MaWNCazBpZ3NjN1JHL0JtUm5pdGwydnNCUDhBODEvK3Nq?=
 =?utf-8?B?bTUyblV5TmJjZHI1QXM4L240L0N1QXhHQXNFa2ZYK3hOb2Q3N0VQSXc3dTdM?=
 =?utf-8?B?dHFjZDVlUFdEakZIN242SitKRWhyQmZrLzk4c09DYm9iTnNBQUhmbWFTYXJu?=
 =?utf-8?B?WjY4TUM3WEFXL0REbEJqREdBUGdWRmpoNDZBTi8rQ2Z4ZEpCUU1iZzZwOUk0?=
 =?utf-8?B?c3pGbmhTWm5tbzY5MVJDcG9tcnR3VWdMdGFLYjhRc01BanNVNllKTWE1ZG5O?=
 =?utf-8?B?QzYwcGxaY3FqWHVheXhzL3BJZVgya08rUWhFUGRvdG1IN2Z0K3duMVZMNFZ1?=
 =?utf-8?B?STRmSDVUTVJMNDVJanJNRFl6dHhtU3pJajJYdzBlNGJBQnBKSzI1S0xkcGNh?=
 =?utf-8?B?bmt2VjNiZmJ4YUZwMEY3eExXZ1JoQ2Y2a1FUektEQUd1MzFCM0JPV29meE9h?=
 =?utf-8?B?ODhxUWRWY09RcGZkdHhwRkE1Tlc2SC9yd3ZycmJ1a0YrTzFiYTBsSkpSem1X?=
 =?utf-8?B?bDRveXoxdUl4dmVaU05LWFJLQkduUkpkVmppenVRY3MrNFRUS3FCWGdmejlD?=
 =?utf-8?B?M3pTalJXVzN1NXQ4MXZxVmpMV3E3Tm96NitLRDVlS2RPVnUvNTRoTlJIWWR0?=
 =?utf-8?B?QityUkFtNFgrMndxa2p2czFhTFd6YVhBVjk1K2lsK0FTTVFUTlYyVnZNZSsy?=
 =?utf-8?B?OVZtdjRPOEZGRnRqUld3WjRSZ2Y3dTkxekFKRXRqck9zRU5xVWVzcGFsMkQz?=
 =?utf-8?B?bktaNDhKeG9KVzRibWoyejNISTdDMnV6dmhSL0dVOHRPUmo2UEdmZ2FYeDBt?=
 =?utf-8?B?YTU3UGlLNWVWR1d5OE90aE5aZml2Nmhpekw4Z3dDbm50RWZxbHBpUXg2T2JJ?=
 =?utf-8?B?TUlPRm5PSFR0Z2pZK2pjWUkwMzJzczcrVmJGd2JWdGtSOEQrcGFrZkVpdEgz?=
 =?utf-8?B?UUhFMW1jbytkUXp1Q0xxdk9OV3VYT1VDeEwwck42SXpTWjRUYnY5bE94TW5T?=
 =?utf-8?B?dVNTZUhNRlM2a1JZeGU5c0laT3Vsek1LaGp3RTFZaC9vb2xUL0ppRFIzRGZy?=
 =?utf-8?B?TUNud05SY2pwSHkwb0FaUFlPUDROQ2FkN0luK2FSOSt5YWVEWUF1VjJPVlBu?=
 =?utf-8?B?UGJ3aXZ5eStNVWJGaWhLV2JQTFUxcjhHOEVhQlZTNjhERjJMdmFmVXlEdStV?=
 =?utf-8?B?ajgyVEowR1lJelhQVUV5SG5NOTFoM0ljamFGT3R1R2JKaEd2OU9xTDBtTllp?=
 =?utf-8?B?N1hUNlhMS1dNa09kREFuR2I1dlRWeW10Qk1YQk80K255UlpUWXhoZEE4S0lj?=
 =?utf-8?B?ZkhFRjFsZ2NjTE5wcWhwZWN4d3RIMlM2NisxNlFtem9TRXFHVU1aTDVZVnlV?=
 =?utf-8?B?WXl6dFQ0T2xKeS9YMmxNQzkzeFAzK2FCMHUyd3FnTDNoRWxSS3o5UG4wOTFC?=
 =?utf-8?B?cWhHSmJzNStwSDRJTTZRamtwSUdWL2VjVGZrM1ArRlBRTnFtby96WnJvenJ3?=
 =?utf-8?B?Z1Bid29NTUZKU1hYOGVxWW1UQWU0VGl0SlVkMGFLUTQ5Y0tyTzdLOEExYTVU?=
 =?utf-8?B?WjIvYU9qK0IzNzM5UnFvOWh1Mm5vVmc2cm9IVTdSclowMy8yN2VWK2g0M1FK?=
 =?utf-8?B?dmxtK1Z4Tm5RWENqdjZGQVZWN0krVTFaNklhcXQ4WnR6OGhoVFduZk91QWJQ?=
 =?utf-8?B?WXVqQ0QvTnVMTllMenI3V0NrSFhGU25nckx4STJMWXdkRElJa1c4OFBGcU5o?=
 =?utf-8?B?OFZGdFZYL3pZQ3JvV0t6ZDZkVUNiNTBxeFphNHh4WGZEQnRYcmNGQlZrczdt?=
 =?utf-8?B?NTUzcCt3VzNGWFFSYXlHQlo3UW1UWHM4bDA4UGViOW1ZMCtXNHNrMTF2WXNR?=
 =?utf-8?B?ZWtjakdEVHNzVVBxQktEdTZDN2pqdU5vSFZpZWlkY3pwSVloc0xCR0cxaWE4?=
 =?utf-8?B?RW1wSVk2dGZUY0dRaFhZOUxlUm9HL1ZtWkxsek5MVW1qemZZbWxiVEgydEla?=
 =?utf-8?B?b3VnWko5QlhvUFN1c2xuem5XazhCU0w3RG9qdlJHOXcwTUpQSHNpcEhvZjBl?=
 =?utf-8?B?c0N5aG91T0RSdlpJV3hrUkJCSmN4WU1tL3R4STFvQVlJQlNpbU0xTnIvL1FY?=
 =?utf-8?B?UGd1eWduYVVUMjcwSmhLMUlRbHl0QzJJVDhDSVlRVnpwbi9HNkRpc25vM3Zw?=
 =?utf-8?B?VHc9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <468BC7BEF9F50647B8DCF06AA4285A14@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MW4PR11MB7125.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8cd0076f-8bc7-42bd-384b-08dcee344761
X-MS-Exchange-CrossTenant-originalarrivaltime: 16 Oct 2024 22:45:48.2515
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: co24vVR3GxrxxR7GfQx9rx9j3h5WIV6R+ntmRRD/aaD3l5VIKLR1IYxfiP/8Mc/4lLnuo8vl0Dh9gayHQT9kKIv8SgEX5Nd2mNEp8SEruWI=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA2PR11MB4828
X-OriginatorOrg: intel.com

T24gV2VkLCAyMDI0LTEwLTE2IGF0IDEzOjIwICswODAwLCBMaSBaaGlqaWFuIHdyb3RlOg0KPiAk
IGdyZXAgLXcgbGluZSBidWlsZC9tZXNvbi1sb2dzL3Rlc3Rsb2cudHh0DQo+IHRlc3QvbW9uaXRv
ci5zaDogbGluZSA5OTogWzogdG9vIG1hbnkgYXJndW1lbnRzDQo+IHRlc3QvbW9uaXRvci5zaDog
bGluZSA5OTogWzogbm1lbTA6IGJpbmFyeSBvcGVyYXRvciBleHBlY3RlZA0KPiB0ZXN0L21vbml0
b3Iuc2g6IGxpbmUgMTQ5OiA0MC4wOiBzeW50YXggZXJyb3I6IGludmFsaWQgYXJpdGhtZXRpYyBv
cGVyYXRvciAoZXJyb3IgdG9rZW4gaXMgIi4wIikNCj4gDQo+IC0gbW9uaXRvcl9kaW1tcyBjb3Vs
ZCBiZSBhIHN0cmluZyB3aXRoIG11bHRpcGxlICpzcGFjZXMqLCBsaWtlOiAibm1lbTAgbm1lbTEg
bm1lbTIiDQo+IC0gaW5qZWN0X3ZhbHVlIGlzIGEgZmxvYXQgdmFsdWUsIGxpa2UgNDAuMCwgd2hp
Y2ggbmVlZCB0byBiZSBjb252ZXJ0ZWQgdG8NCj4gwqAgaW50ZWdlciBiZWZvcmUgb3BlcmF0aW9u
OiAkKChpbmplY3RfdmFsdWUgKyAxKSkNCj4gDQo+IFNvbWUgZmVhdHVyZXMgaGF2ZSBub3QgYmVl
biByZWFsbHkgdmVyaWZpZWQgZHVlIHRvIHRoZXNlIGVycm9ycw0KPiANCj4gU2lnbmVkLW9mZi1i
eTogTGkgWmhpamlhbiA8bGl6aGlqaWFuQGZ1aml0c3UuY29tPg0KPiAtLS0NCj4gVjE6DQo+IMKg
VjEgaGFzIGEgbWlzdGFrZSB3aGljaCBvdmVydHMgdG8gaW50ZWdlciB0b28gbGF0ZS4NCj4gwqBN
b3ZlIHRoZSBjb252ZXJzaW9uIGZvcndhcmQgYmVmb3JlIHRoZSBvcGVyYXRpb24NCj4gLS0tDQo+
IMKgdGVzdC9tb25pdG9yLnNoIHwgMyArKy0NCj4gwqAxIGZpbGUgY2hhbmdlZCwgMiBpbnNlcnRp
b25zKCspLCAxIGRlbGV0aW9uKC0pDQo+IA0KPiBkaWZmIC0tZ2l0IGEvdGVzdC9tb25pdG9yLnNo
IGIvdGVzdC9tb25pdG9yLnNoDQo+IGluZGV4IGM1YmViMmMuLjc4MDlhN2MgMTAwNzU1DQo+IC0t
LSBhL3Rlc3QvbW9uaXRvci5zaA0KPiArKysgYi90ZXN0L21vbml0b3Iuc2gNCj4gQEAgLTk2LDcg
Kzk2LDcgQEAgdGVzdF9maWx0ZXJfcmVnaW9uKCkNCj4gwqAJd2hpbGUgWyAkaSAtbHQgJGNvdW50
IF07IGRvDQo+IMKgCQltb25pdG9yX3JlZ2lvbj0kKCRORENUTCBsaXN0IC1SIC1iICRzbWFydF9z
dXBwb3J0ZWRfYnVzIHwganEgLXIgLlskaV0uZGV2KQ0KPiDCoAkJbW9uaXRvcl9kaW1tcz0kKGdl
dF9tb25pdG9yX2RpbW0gIi1yICRtb25pdG9yX3JlZ2lvbiIpDQo+IC0JCVsgISAteiAkbW9uaXRv
cl9kaW1tcyBdICYmIGJyZWFrDQo+ICsJCVsgISAteiAiJG1vbml0b3JfZGltbXMiIF0gJiYgYnJl
YWsNCg0KWyAhIC16ICIuLi4iIF0gaXMgYSBiaXQgb2YgYSBkb3VibGUgbmVnYXRpdmUsIHdoaWxl
IHdlIGFyZSBjaGFuZ2luZw0KdGhpcywgSSdkIHN1Z2dlc3QgY2xlYW5pbmcgdXAgYSBiaXQgbW9y
ZSBzdWNoIGFzOg0KDQogICBpZiBbWyAiJG1vbml0b3JfZGltbXMiIF1dOyB0aGVuDQogICAJYnJl
YWsNCiAgIGZpDQoNCk90aGVyIHRoYW4gdGhhdCBsb29rcyBnb29kLA0KDQpSZXZpZXdlZC1ieTog
VmlzaGFsIFZlcm1hIDx2aXNoYWwubC52ZXJtYUBpbnRlbC5jb20+DQoNCj4gwqAJCWk9JCgoaSAr
IDEpKQ0KPiDCoAlkb25lDQo+IMKgCXN0YXJ0X21vbml0b3IgIi1yICRtb25pdG9yX3JlZ2lvbiIN
Cj4gQEAgLTE0Niw2ICsxNDYsNyBAQCB0ZXN0X2ZpbHRlcl9kaW1tZXZlbnQoKQ0KPiDCoAlzdG9w
X21vbml0b3INCj4gwqANCj4gwqAJaW5qZWN0X3ZhbHVlPSQoJE5EQ1RMIGxpc3QgLUggLWQgJG1v
bml0b3JfZGltbXMgfCBqcSAtciAuW10uImhlYWx0aCIuInRlbXBlcmF0dXJlX3RocmVzaG9sZCIp
DQo+ICsJaW5qZWN0X3ZhbHVlPSR7aW5qZWN0X3ZhbHVlJS4qfQ0KPiDCoAlpbmplY3RfdmFsdWU9
JCgoaW5qZWN0X3ZhbHVlICsgMSkpDQo+IMKgCXN0YXJ0X21vbml0b3IgIi1kICRtb25pdG9yX2Rp
bW1zIC1EIGRpbW0tbWVkaWEtdGVtcGVyYXR1cmUiDQo+IMKgCWluamVjdF9zbWFydCAiLW0gJGlu
amVjdF92YWx1ZSINCg0K
