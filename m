Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.21])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A88EA15572C
	for <nvdimm@lists.linux.dev>; Mon,  6 May 2024 19:11:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.21
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715022695; cv=fail; b=r2HpM7/HCkzAZLNl4FFiT5JCH7t7xbde25NUAiloPepCl1JR1w9htWf6upkiV9RUgmHK9N539zyitOTpVkfx+vyN8XfcKrsNZtDnNoLIfj/oF4kvSM/OKMGBvoq3bCyaDW/RJuLbKP96WbgR7/FR9D0rUW5fEjURv4MMfk6CXtM=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715022695; c=relaxed/simple;
	bh=tjqbPrruO4HlNBCKGgT6wgRPeGe5dfWulbxhv/NB41w=;
	h=From:To:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=dfje6C2U5UUA397BY6lDfCInKihCtSx2qJ/TRXZswqucZgmFIPMyTB7P0s0vHd/mNBPngvbpMdQex6k/BqaCHk/whip6f4v49lR6l1hqlQMFOQel2bFqpaR7FEsERCqw190o4/rPatac3BHnMSrjEjIBRGljITQYgrmrJbNFMV8=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=TFjJJLBp; arc=fail smtp.client-ip=198.175.65.21
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="TFjJJLBp"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1715022694; x=1746558694;
  h=from:to:subject:date:message-id:references:in-reply-to:
   content-id:content-transfer-encoding:mime-version;
  bh=tjqbPrruO4HlNBCKGgT6wgRPeGe5dfWulbxhv/NB41w=;
  b=TFjJJLBpTizh6c7e4u9OCoo9P3KJZMDu0NzXGs1S0e9mkvnKv6fmePEL
   /+SL+fkfA7GMdRsb3Na52TBDOWXz1EBOh1OtWaH5Aj+aOnBJ+Pyr/qNS4
   z6GCg/B8eANUzlGJKD8CfgaQ0lXtPD5z24dLi+gCNymL4JavmJI2wgdpp
   /P4sBMKkcDtjYqXSqqyuGw70o4XieyQWn3s0fIELAXCEpRKYWStkp7/J4
   dPYh80cSJYR1/kgpX4nZi/N6a5/2i6KDGZoeujMR3xU41c8V0F2cm7AAW
   OQMz1BJUWUorDdNDMY+h4UuETRnyxcEsmEpfPSfZXi9DC/l5JUQkIw4ep
   g==;
X-CSE-ConnectionGUID: L3x3ppenQb2ERLBlI5dG7Q==
X-CSE-MsgGUID: jBPNnvaoT2C8UPxhh3r0Vw==
X-IronPort-AV: E=McAfee;i="6600,9927,11065"; a="10716109"
X-IronPort-AV: E=Sophos;i="6.07,259,1708416000"; 
   d="scan'208";a="10716109"
Received: from orviesa005.jf.intel.com ([10.64.159.145])
  by orvoesa113.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 May 2024 12:11:34 -0700
X-CSE-ConnectionGUID: rRgCAz+PQXOAHP3peGzuxg==
X-CSE-MsgGUID: QL6ow3AcQuWZXaHymtEJsw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.07,259,1708416000"; 
   d="scan'208";a="33053820"
Received: from orsmsx601.amr.corp.intel.com ([10.22.229.14])
  by orviesa005.jf.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 06 May 2024 12:11:33 -0700
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35; Mon, 6 May 2024 12:11:32 -0700
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35; Mon, 6 May 2024 12:11:32 -0700
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35 via Frontend Transport; Mon, 6 May 2024 12:11:32 -0700
Received: from NAM04-DM6-obe.outbound.protection.outlook.com (104.47.73.40) by
 edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.35; Mon, 6 May 2024 12:11:32 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=E5aOPu/KZh1R3pmn17jPU2IdX5rZm/nlkoCJMppGrtLUAfkB1Q9L4rnMO8tR96XmL5xnvb4Ugn8bjxKFCpQ+Ghebksx5TEIIyYSUveGH6ymm+yj0jt7rf5vRDh0gqxqJ0hzgo/ziVlxLZPtuIGn0B16HCvipBdcYUzeAghjtWiJNtgVyCD2ywelWIoidNjovdmZxCjsvEVU1Jz4Crl8de7IulE1QeaWEnUzAp+BGt5aTopEr1VVittgkhr1MfgxPcBCQJgnl+pE2Y3ixOE3Gl1zF+vF2LHAKghDeo7oMiqZUrBkPR5+1Sra0lV0VoB6t1kRQdInUxO/wWNe5Yyo5Aw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=tjqbPrruO4HlNBCKGgT6wgRPeGe5dfWulbxhv/NB41w=;
 b=JaxK+D3ohSMqYw4G7kPEg7GHcZx05HbjX0fIt1KZXb37ETGD1nTqvZa9uDE0OfUVn7WbWaHgOZxNaKY9oil/Wnsjp6eJ/giER/bQdEzbuIm7HVG/ZSaDcKsOoXd4Kh/Eum73w/gEW6jfmm+lxhz4STEonbfpb9mW/V+dg/U8tKYrWbWWvpuusL+LQHVGs1BhqUd2ZSlGmnAIXZM+Mvvh5YVt1RFl5jnCNQvXJDPnQrQrSVF9s0MFYm8MAfstRn+C5pBZn6GaFqKeEvzCAh4t00aHyPP3VtPYTf5Ya1ealFaeWs2MdXdxgGL22VhDOtlr6Sl1ZmLK52gWpwOcdBdHRQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from MW4PR11MB7125.namprd11.prod.outlook.com (2603:10b6:303:219::12)
 by SN7PR11MB7490.namprd11.prod.outlook.com (2603:10b6:806:346::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7544.39; Mon, 6 May
 2024 19:11:30 +0000
Received: from MW4PR11MB7125.namprd11.prod.outlook.com
 ([fe80::ed72:f69c:be80:b034]) by MW4PR11MB7125.namprd11.prod.outlook.com
 ([fe80::ed72:f69c:be80:b034%4]) with mapi id 15.20.7544.041; Mon, 6 May 2024
 19:11:30 +0000
From: "Verma, Vishal L" <vishal.l.verma@intel.com>
To: "jmoyer@redhat.com" <jmoyer@redhat.com>, "nvdimm@lists.linux.dev"
	<nvdimm@lists.linux.dev>
Subject: Re: [PATCH ndctl 1/2] ndctl/keys.c: don't leak fd in error cases
Thread-Topic: [PATCH ndctl 1/2] ndctl/keys.c: don't leak fd in error cases
Thread-Index: AQHanZw6BLuACYmGdkytu4l+K5aVO7GKlywA
Date: Mon, 6 May 2024 19:11:30 +0000
Message-ID: <02a2425a8576ff86b5f1741521ccf7c25714b7d7.camel@intel.com>
References: <20240503205456.80004-1-jmoyer@redhat.com>
	 <20240503205456.80004-2-jmoyer@redhat.com>
In-Reply-To: <20240503205456.80004-2-jmoyer@redhat.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.50.4 (3.50.4-1.fc39) 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: MW4PR11MB7125:EE_|SN7PR11MB7490:EE_
x-ms-office365-filtering-correlation-id: 7a0b5704-e689-4903-19b2-08dc6e005601
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230031|1800799015|376005|366007|38070700009;
x-microsoft-antispam-message-info: =?utf-8?B?UHJPUzNMV2p3QlRXZGtUTVVTOUVON0pLY0RZOEpaK1NzQnVFZm10aWFNa0RK?=
 =?utf-8?B?MG1QVWRvdGg5SC9GOHpvWDlxM0RXZmg3cFV0QXNPYkVicnlvM0RiTkx4Vy9q?=
 =?utf-8?B?ck81WUMrYWhTSVUxS2I5eVhKT2FweHl2NzdrdWk5L0Q2aWhjU1JRS0NORVVr?=
 =?utf-8?B?c1lkZDZnaldXT0x0VXoyWHdxME5yZGtiUW5XRERuckhSaVp6T1BMK3EwMytn?=
 =?utf-8?B?djltQ0ZrUHM0Zy8yWFdLUTdMQy9Ob3ErOFBPT000aVVGN0FoV21iRUJ3aGdp?=
 =?utf-8?B?TGxac01hVDFCQ2JGOGU1NjA1QVBzRGxhUmNQOXp3ZjF5a1l0Q1VnMm5nN0VX?=
 =?utf-8?B?Y1hoRThzZmNjQ1R4bndqNW9ScWJQeFUzbkt0NnFaY0pNT0tqaUVvbFdkcXpp?=
 =?utf-8?B?ZnphU200M2pIM0ZqNXRTdVRuejZUOFh6ZStIYU0vWDM3aEFkdktlVldUVjA1?=
 =?utf-8?B?b3JPUU5Fd2RCUlBSWkVJVWdkYzJoak5CZjRGaHpoOWkyYS9mYWVOMDBaL3Bx?=
 =?utf-8?B?Z0hRQVZLaUJrNTlCSjUxTFFaNllsT0V3STg0YkVyWjZzK003T1ljTDJlTklD?=
 =?utf-8?B?NnNGcmk4bXZMNXFDam91NUQ3UnEyWlB1T2xpbnBKS3hqeEEyaERxaVcweTA0?=
 =?utf-8?B?RkRNdlRaY21qYnYrWEpVRUFpODRkdzNjRFR0NXZBc2c3VUZDay9kSEVid2RC?=
 =?utf-8?B?b1IvVFFFK0FiUmg2SFIvZWZKYzhoMnV5Q1JVZzlxQ1lUZnM2NHlNc3NBeVJY?=
 =?utf-8?B?NWRWOTdQRmNCci9URDFTbHdDaW9HN21GUkVydEpxTXZBbGpWdmFwWFFCb1BM?=
 =?utf-8?B?VllUbHRGRWpWMDBGakYxRERKV2lCenRVbGFqZWd5UGFZNDQ4d1NSOXdiSElI?=
 =?utf-8?B?STQ1TXp4WDNUU3dNNmZ0QmV2S0Y0Tlh1M2ZmWXdEalRoQVpKWGtsdloyYzlX?=
 =?utf-8?B?bjYwZzZacDYxVTE2SzRtdGhZSG1ua25IVE95ZERRWERMK1psL2JCZVBVejFo?=
 =?utf-8?B?SzBVZ1dmazRsbGNua2grL2Q0L1dHTVRJWVJPcnQ2WEFnUVpJaFlYT21Jay91?=
 =?utf-8?B?cS9jd1dsVzQralNHWG5BaDBYNXI3b0ZSNmZEdkhEQk1pSWlBak0ya1NoQVBj?=
 =?utf-8?B?ZUVhQjhnTkFBejRsRlh0b1E5UHhxWkp2YWloNFprRldRT1l0SGt6aXg5azlM?=
 =?utf-8?B?ejMrQ0FBMDEwYVhVc09JblNoRGd2OWpjWXNqdlJkcG1ZL2Q0R1d4NmVqRFRY?=
 =?utf-8?B?NGYwSzBSSWNndVR0a0h0bEo2UHJtOXVjR08zeHhxS0R3c21qUWE5YzRJWTRI?=
 =?utf-8?B?cmtMdGFsUnVqOXgvZDRhU1VRQ1M5eXYzeE1lT0EzbFJTeFBuWFNmLzk2OGNM?=
 =?utf-8?B?Wkl4clVKa2VYTlFJc3FQM3VtRTc5enNUMWxCU3RlV0JLaWV0SlUvQktKb2Ry?=
 =?utf-8?B?aXlyZGZBTWw4YVdGSk1BUEFNQnhHSEN0ZWc4SWRzRXR6YzFxa2xoVUNZSjc3?=
 =?utf-8?B?TkZoUDEzOGRlZDN2RzdtWU9za2lYT0taWlhpS3lSZFVEZlduWVR1c3Z2Mnpu?=
 =?utf-8?B?eHg5cjlDdnJpWjJXMy90QlUwbmpTdjBtc2U5cy8yUEd3cVRlN1dIT3RxYnJR?=
 =?utf-8?B?dlVETmdXMUYza1VSVDc5RmxzbFdwZVlKaHIzRkNSWWlvYkJHMGh1bjBJVUxW?=
 =?utf-8?B?eStQeEtnYWJUWDlGYlhlTEE5a0pQY2kxUkx2ZDRnRGpxWW4xemUzdnRoWXdn?=
 =?utf-8?B?dDRRdXgwc2NWdVFTdnY0bXhtWTBkTTlWRndIS013UE11V1ZYV2ZkanVzaUdr?=
 =?utf-8?B?UlFjZ1FZazNsRGwvdTJrZz09?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MW4PR11MB7125.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(1800799015)(376005)(366007)(38070700009);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?UVBNWkxKVlgvc0dpZjJSN0U0SUpLK3VwNnQ2NzMrL1BhcU5xVFBaNTlLQi95?=
 =?utf-8?B?WlVPUGhDb1BFVEcxSFZsRjhLcVA3NlhTajFKVlpHck9jQWNid1E0STBWMVZW?=
 =?utf-8?B?V3VuN3dMMjZqYkp1RWpJSXlMdzdrdmt1czk4djBUK2krWTZHdHo0dy8xdFht?=
 =?utf-8?B?RFlubzFRNzF4N3dvSkUxTVpHMU5yMXdrSnU1cHkwRGxsSWNwUU9PaXZMSGw1?=
 =?utf-8?B?MnVWMEcwSE1Rc2xxQi9iVDRCTXM4WlRWWmZpWWdaYzR0NnFpcVpDVTVFL2hM?=
 =?utf-8?B?eWROWURnUW11dUJtdUZGcGhUeFZlUFdRK0FIS3BFYXdraUFwejVYSWFPbEN4?=
 =?utf-8?B?NWNxQXBPcnNXdVF0aStRdUtXaERoakp1cGxzQ2tzMXFFRm1tUncxV1lBNEhk?=
 =?utf-8?B?YXlhbmZzUldRd1ZoVExlajhBdGpQTzZlSERjSmd1a2d4b0dNS0NxSnk0VGdr?=
 =?utf-8?B?QkdNRU5sZEV3U1F6QVhkUEwrQWIydENpanFHVGdNS3ZSbXdQSEYyNkl5dTVv?=
 =?utf-8?B?b2dIUlpCakxISDlycG96Mm1ZcVI4cFRldFZhTnRMSGViNjh3TFcwTFkxd3d1?=
 =?utf-8?B?VVdmUzhocU1CQ1U3R0ZHdWFVbStoVVJIWDNxemN3K2tIUlJRY3hSNStBNHZv?=
 =?utf-8?B?YjFuWjRYbTRyaExadml3cEpXYk9GRTBkaG9aR3dqcUx5dDFWVjNzUHhIMUNy?=
 =?utf-8?B?MzRpLzl3NFI0VXhCVkxiTTN3RHNzNzRrNGh2MHFlNFlkR3R0M1VQdktpNnNl?=
 =?utf-8?B?UjZNL0FsdFpPU0FSMUtncml6RWcrRXZTc0MxQlR4UXR6V0QwdVJCc2dMeDVO?=
 =?utf-8?B?YXlST3NRZUhONFhtK2t5Y2dwS3VHcU5ZUUlBYlVoQTVTNHFNYjVPQ094czRr?=
 =?utf-8?B?OU5idS9NdzlRVmRoclNIRko0dUxMQk1pdlhyZ3JoV1doK2o5ZVM4QXQ3MC9L?=
 =?utf-8?B?N1lyMS9nNlUyWlVTTVFJOXlvV2cvRlRHbHdEV1pqOUNqS1drdXU5QXlWVExx?=
 =?utf-8?B?Y2RxNEFzYUdQZ2Q0clhhNFNoZmVsdEFndloxSUVBTGlqenNTdHpRTGdOcGxB?=
 =?utf-8?B?OXhzaERZMThJTlZNNkpXczUxK2xEQUVOMlBLQ21heXE3R1FrS2c1SC95eGI5?=
 =?utf-8?B?L1ZqM2E4dEh6SksxUGpwMExrU214V2JWVHovSVZRam5waVJVZDRWYjAzNVhM?=
 =?utf-8?B?NmJJNlJxQzVFblRFZFFibFBVM3RrS0NGT2pLNGtzdXcrL25lckNaSCtIM3J4?=
 =?utf-8?B?VHVRT0pFZ3ppeUphZHlGa0Y1UFdubzRCc2JPZGtVZXV5MHNDMlhMYVFxNXhT?=
 =?utf-8?B?VHBFb0c3SGJ2bkRCaUVJbCtMbU1CcDAxWkZvZENnd2s0amRBQ2JRREhTQktB?=
 =?utf-8?B?Nmt5VG1nL3pnTjh2cm9UaXZUOHExYzRQSXpNakV2ajNtSUFpazhUTUFFczFs?=
 =?utf-8?B?YmZsbGNWN3RSMTQ5ejVDOXQrdGRleTR0UlZJamk0RGN3bU9vcnRLbzhuY1ZU?=
 =?utf-8?B?eXBqSytzSzB3YmEvclFNNjNMbktwQnRBNDA3QkdoTmsvVCt3N0ZpWUo4cUlt?=
 =?utf-8?B?dmRnNjBPb0JkVlVVTE1obmIxazk4aXpINFBENnd5REN5VHBCMnRiR0ozWkNx?=
 =?utf-8?B?akpYV3JyeDlOSU1EeG9MMGhIazhPNEs4anNvMmVVbHdEb2V5NU1BR1hBTUp6?=
 =?utf-8?B?S20zY1Y2dHV1ZUhLNmJHcFRLNkVHbnR6OStwQkhIbFJTWFhFVE1XakJQU1RJ?=
 =?utf-8?B?MUlVanVsTDJnQWVOWCtSTFRyRWhRak1ROXR4UWtIT21TeCtMQ3ExdFF2S0ox?=
 =?utf-8?B?cWxxUVhSdjRYWkhiTFdtbUxYd2t3dm8zNjFkSFZCcnRJa2RHWUI5aFptOGZ1?=
 =?utf-8?B?VWd0NnE3ZXRyZU9iMjVGeE1FdFlPTHE5dW5ZVGlrMkhkeWxaejdMbnJQYU1Q?=
 =?utf-8?B?eC81eHRNZVgxYVdoZEFNM3dWQlRFUUViVjlWYWNlcUwwTlJYQkcrV0FWNUxw?=
 =?utf-8?B?RlhETEpSVjViMzFYN1FidGx0b1lGYUpOQ3U4N0lLL0k0MVE5cFc0TWVSWG5R?=
 =?utf-8?B?OTJXa3VFZGN3cXpEajFYOXNwRStpWWtWWG1KR1lpaXorY2I2cmlnNlQzOVdV?=
 =?utf-8?B?WDVST1M4ZHVOaHEzNXVoU21PUUdUSk9KSUp3KzJXZG5IaXV0bkdLUmQ1V3RD?=
 =?utf-8?B?M3c9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <740FD9469E5D944F919A795A6C0348A7@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MW4PR11MB7125.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7a0b5704-e689-4903-19b2-08dc6e005601
X-MS-Exchange-CrossTenant-originalarrivaltime: 06 May 2024 19:11:30.1197
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: nLQNTtQiwqned1oeG3+mNwkC+eHTq2xoO+tWxaXwazpE5LwawQ8G1hD97zMDWGJ9ZpKLx/flLSN+1eqw5HTEgvGVes2AVakPpMK/lCvU9GM=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR11MB7490
X-OriginatorOrg: intel.com

T24gRnJpLCAyMDI0LTA1LTAzIGF0IDE2OjU0IC0wNDAwLCBqbW95ZXJAcmVkaGF0LmNvbSB3cm90
ZToNCj4gRnJvbTogSmVmZiBNb3llciA8am1veWVyQHJlZGhhdC5jb20+DQo+IA0KPiBTdGF0aWMg
YW5hbHlzaXMgcG9pbnRzIG91dCB0aGF0IGZkIGlzIGxlYWtlZCBpbiBzb21lIGNhc2VzLsKgIFRo
ZQ0KPiBjaGFuZ2UgdG8gdGhlIHdoaWxlIGxvb3AgaXMgb3B0aW9uYWwuwqAgSSBvbmx5IGRpZCB0
aGF0IHRvIG1ha2UgdGhlDQo+IGNvZGUgY29uc2lzdGVudC4NCj4gDQo+IFNpZ25lZC1vZmYtYnk6
IEplZmYgTW95ZXIgPGptb3llckByZWRoYXQuY29tPg0KDQpMb29rcyBnb29kLA0KUmV2aWV3ZWQt
Ynk6IFZpc2hhbCBWZXJtYSA8dmlzaGFsLmwudmVybWFAaW50ZWwuY29tPg0KDQo+IC0tLQ0KPiDC
oG5kY3RsL2tleXMuYyB8IDE2ICsrKysrKysrLS0tLS0tLS0NCj4gwqAxIGZpbGUgY2hhbmdlZCwg
OCBpbnNlcnRpb25zKCspLCA4IGRlbGV0aW9ucygtKQ0KPiANCj4gZGlmZiAtLWdpdCBhL25kY3Rs
L2tleXMuYyBiL25kY3RsL2tleXMuYw0KPiBpbmRleCAyYzFmNDc0Li5jYzU1MjA0IDEwMDY0NA0K
PiAtLS0gYS9uZGN0bC9rZXlzLmMNCj4gKysrIGIvbmRjdGwva2V5cy5jDQo+IEBAIC0xMDgsNyAr
MTA4LDcgQEAgY2hhciAqbmRjdGxfbG9hZF9rZXlfYmxvYihjb25zdCBjaGFyICpwYXRoLCBpbnQN
Cj4gKnNpemUsIGNvbnN0IGNoYXIgKnBvc3RmaXgsDQo+IMKgCXN0cnVjdCBzdGF0IHN0Ow0KPiDC
oAlzc2l6ZV90IHJlYWRfYnl0ZXMgPSAwOw0KPiDCoAlpbnQgcmMsIGZkOw0KPiAtCWNoYXIgKmJs
b2IsICpwbCwgKnJkcHRyOw0KPiArCWNoYXIgKmJsb2IgPSBOVUxMLCAqcGwsICpyZHB0cjsNCj4g
wqAJY2hhciBwcmVmaXhbXSA9ICJsb2FkICI7DQo+IMKgCWJvb2wgbmVlZF9wcmVmaXggPSBmYWxz
ZTsNCj4gwqANCj4gQEAgLTEyNSwxNiArMTI1LDE2IEBAIGNoYXIgKm5kY3RsX2xvYWRfa2V5X2Js
b2IoY29uc3QgY2hhciAqcGF0aCwgaW50DQo+ICpzaXplLCBjb25zdCBjaGFyICpwb3N0Zml4LA0K
PiDCoAlyYyA9IGZzdGF0KGZkLCAmc3QpOw0KPiDCoAlpZiAocmMgPCAwKSB7DQo+IMKgCQlmcHJp
bnRmKHN0ZGVyciwgInN0YXQ6ICVzXG4iLCBzdHJlcnJvcihlcnJubykpOw0KPiAtCQlyZXR1cm4g
TlVMTDsNCj4gKwkJZ290byBvdXRfY2xvc2U7DQo+IMKgCX0NCj4gwqAJaWYgKChzdC5zdF9tb2Rl
ICYgU19JRk1UKSAhPSBTX0lGUkVHKSB7DQo+IMKgCQlmcHJpbnRmKHN0ZGVyciwgIiVzIG5vdCBh
IHJlZ3VsYXIgZmlsZVxuIiwgcGF0aCk7DQo+IC0JCXJldHVybiBOVUxMOw0KPiArCQlnb3RvIG91
dF9jbG9zZTsNCj4gwqAJfQ0KPiDCoA0KPiDCoAlpZiAoc3Quc3Rfc2l6ZSA9PSAwIHx8IHN0LnN0
X3NpemUgPiA0MDk2KSB7DQo+IMKgCQlmcHJpbnRmKHN0ZGVyciwgIkludmFsaWQgYmxvYiBmaWxl
IHNpemVcbiIpOw0KPiAtCQlyZXR1cm4gTlVMTDsNCj4gKwkJZ290byBvdXRfY2xvc2U7DQo+IMKg
CX0NCj4gwqANCj4gwqAJKnNpemUgPSBzdC5zdF9zaXplOw0KPiBAQCAtMTY2LDE1ICsxNjYsMTMg
QEAgY2hhciAqbmRjdGxfbG9hZF9rZXlfYmxvYihjb25zdCBjaGFyICpwYXRoLCBpbnQNCj4gKnNp
emUsIGNvbnN0IGNoYXIgKnBvc3RmaXgsDQo+IMKgCQkJZnByaW50ZihzdGRlcnIsICJGYWlsZWQg
dG8gcmVhZCBmcm9tIGJsb2INCj4gZmlsZTogJXNcbiIsDQo+IMKgCQkJCQlzdHJlcnJvcihlcnJu
bykpOw0KPiDCoAkJCWZyZWUoYmxvYik7DQo+IC0JCQljbG9zZShmZCk7DQo+IC0JCQlyZXR1cm4g
TlVMTDsNCj4gKwkJCWJsb2IgPSBOVUxMOw0KPiArCQkJZ290byBvdXRfY2xvc2U7DQo+IMKgCQl9
DQo+IMKgCQlyZWFkX2J5dGVzICs9IHJjOw0KPiDCoAkJcmRwdHIgKz0gcmM7DQo+IMKgCX0gd2hp
bGUgKHJlYWRfYnl0ZXMgIT0gc3Quc3Rfc2l6ZSk7DQo+IMKgDQo+IC0JY2xvc2UoZmQpOw0KPiAt
DQo+IMKgCWlmIChwb3N0Zml4KSB7DQo+IMKgCQlwbCArPSByZWFkX2J5dGVzOw0KPiDCoAkJKnBs
ID0gJyAnOw0KPiBAQCAtMTgyLDYgKzE4MCw4IEBAIGNoYXIgKm5kY3RsX2xvYWRfa2V5X2Jsb2Io
Y29uc3QgY2hhciAqcGF0aCwgaW50DQo+ICpzaXplLCBjb25zdCBjaGFyICpwb3N0Zml4LA0KPiDC
oAkJcmMgPSBzcHJpbnRmKHBsLCAia2V5aGFuZGxlPSVzIiwgcG9zdGZpeCk7DQo+IMKgCX0NCj4g
wqANCj4gK291dF9jbG9zZToNCj4gKwljbG9zZShmZCk7DQo+IMKgCXJldHVybiBibG9iOw0KPiDC
oH0NCj4gwqANCg0K
