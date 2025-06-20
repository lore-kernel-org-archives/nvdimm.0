Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.20])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 91EC422576E
	for <nvdimm@lists.linux.dev>; Fri, 20 Jun 2025 20:11:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.20
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750450266; cv=fail; b=mRXWGbEdd3t8dt3PnP3VO7E+T1U2Ag9NkWiBM0F43sJeEz/lvPFwUf4H/0lR+xB0rkaixwmiOA5/9JaiefHZ6PLUEtkrmL6aFGTNNNo0k9nPM+E9kHP2cJuSt/O8GLiR8ZUYbpFegu5WOQaB3+fYCI5veBdvMsDvZTPkKJQ9Zuw=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750450266; c=relaxed/simple;
	bh=SNmtmPdbPdukCragRXoN/k/gogGm7qeimLE1D0UPh4A=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=l19S/U1nisMVSES16sUeDD1IJPj2ZIYftsy7owHFj1lCiVmKXMxLxM+3ng34euKSi1VyMN9zSNALlbN2xfprXiJ3Ttx0n/UnrhDrWaH3nJ7pSCtzIH5raYcX05Exhu0WHGe6iG67v8y0ZDT2U2FceYmI4eN47vAVH4VN1XhTWl4=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=E4uRSHvo; arc=fail smtp.client-ip=198.175.65.20
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="E4uRSHvo"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1750450264; x=1781986264;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=SNmtmPdbPdukCragRXoN/k/gogGm7qeimLE1D0UPh4A=;
  b=E4uRSHvogHCmIUtTuAxPTU6XahCjBEzRJvNuzi3obwLnl6KQuz8JfSy9
   RrAuQl2d3aYr6/RFxxexQBmrlx55WD0sB6GyOmgtzU6xBLGy5so6HAYi1
   B57BphMUzKJ2aT7/5FFBEr5nhptpDENZ/x3vxAuoyUpT1SmrFAIRGfI2X
   un4UADdTBJdyHbR3cp5AqjFLE+TI4z42heidwFYwC22a6/zj+baURfNGb
   zkBpmoEyhKT4IvOtwNamIBNFxx4Se9HDj0i+g907dw7dDZrcl7vz8Fsex
   caKoK3hjatGnHy6WRC4exxtGSuLHPKQ26dfxuTwhqAD5fLDR66tBMiAaG
   A==;
X-CSE-ConnectionGUID: VLRGVUEFQba9C9OlWfqZ/w==
X-CSE-MsgGUID: Rb5EMQfzQPiwoq8CrzEJfA==
X-IronPort-AV: E=McAfee;i="6800,10657,11469"; a="52427804"
X-IronPort-AV: E=Sophos;i="6.16,252,1744095600"; 
   d="scan'208";a="52427804"
Received: from orviesa009.jf.intel.com ([10.64.159.149])
  by orvoesa112.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Jun 2025 13:11:04 -0700
X-CSE-ConnectionGUID: Gqe78O+nR6Oj2cCx95qrMQ==
X-CSE-MsgGUID: VGVOgIryS5OxuK1nEFDKBw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.16,252,1744095600"; 
   d="scan'208";a="150799028"
Received: from orsmsx901.amr.corp.intel.com ([10.22.229.23])
  by orviesa009.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Jun 2025 13:11:05 -0700
Received: from ORSMSX901.amr.corp.intel.com (10.22.229.23) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25; Fri, 20 Jun 2025 13:11:03 -0700
Received: from ORSEDG901.ED.cps.intel.com (10.7.248.11) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25 via Frontend Transport; Fri, 20 Jun 2025 13:11:03 -0700
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (40.107.93.43) by
 edgegateway.intel.com (134.134.137.111) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25; Fri, 20 Jun 2025 13:11:03 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=jvRx/by5oWFCIU4ZSE0fIgXqYwO2xLo62K9OXs+48C7HGt9uy4aXp7a2lSBsbEfgVqc3OFdc4zFiS7SClLzX+LeU9WxwtQu01gC9HuCakEz46PZPrfGRoW9uD1LqtF6B4bMPGjfqub7fh153Poho/4MPAqbhgVQEiWFSAiwGsfpmaM2E0DsT97g1l+oQTiy9Y/OVdccR1Uu770Iaz0ZYUMFD0QkFBRM5hNUKjq2wj7riMocXbI7AekVadMCL8zKeMA477z/tJSSk+2pZ6cUzNTJJuaLVyoyJvcfZ8Ppv3JqrZjNJpACEiiL+fPMp7rDR2JvxX2tPajRh+htlJtSn1g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=SNmtmPdbPdukCragRXoN/k/gogGm7qeimLE1D0UPh4A=;
 b=Ip5aHB02X2gZEGkS6Xf9jABLWc+zF0CxvEL+RkVcAQWL25Suz8U98JgYKpvTkwf7yqnvPyi/pUIgbu2z46OdyKSQWzjpJP3qiBcJ7s9OCI+f34ePLYJqAq43HDTPAcSE4iF5O7yJ4ZjAzthJUeL4uzEjvzVeF9Hp16Vsi3rEVsVGIoOsaJHCiq2864eHcSiCaMvIBWmlApCOfBF0ASkY+GHsKYV9u9ou3VCw8AtIX6OuArQVuDRIeItilYfa8BwftKAqhrJkWeJAY+gjS108/h+P4/HVDay5hhFrGsnjqL8pYAbAXDWtjftH+ADrGEMhPtzzOQYIDfvbd6FcnFt7NA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from MW4PR11MB7125.namprd11.prod.outlook.com (2603:10b6:303:219::12)
 by IA1PR11MB6540.namprd11.prod.outlook.com (2603:10b6:208:3a0::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8835.29; Fri, 20 Jun
 2025 20:11:01 +0000
Received: from MW4PR11MB7125.namprd11.prod.outlook.com
 ([fe80::eff6:f7ef:65cd:8684]) by MW4PR11MB7125.namprd11.prod.outlook.com
 ([fe80::eff6:f7ef:65cd:8684%5]) with mapi id 15.20.8835.023; Fri, 20 Jun 2025
 20:11:01 +0000
From: "Verma, Vishal L" <vishal.l.verma@intel.com>
To: "Williams, Dan J" <dan.j.williams@intel.com>, "Schofield, Alison"
	<alison.schofield@intel.com>
CC: "linux-cxl@vger.kernel.org" <linux-cxl@vger.kernel.org>,
	"nvdimm@lists.linux.dev" <nvdimm@lists.linux.dev>
Subject: Re: [ndctl PATCH 3/5] test: Fix dax.sh expectations
Thread-Topic: [ndctl PATCH 3/5] test: Fix dax.sh expectations
Thread-Index: AQHb4J9qxyJ6biOxBkCCKi/q9qYK3rQJq46AgALSE4A=
Date: Fri, 20 Jun 2025 20:11:00 +0000
Message-ID: <7562edbc163fd8953b2b84e4df3f728697fa0c6a.camel@intel.com>
References: <20250618222130.672621-1-dan.j.williams@intel.com>
	 <20250618222130.672621-4-dan.j.williams@intel.com>
	 <aFNimwh65aJIg-BF@aschofie-mobl2.lan>
In-Reply-To: <aFNimwh65aJIg-BF@aschofie-mobl2.lan>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.56.1 (3.56.1-1.fc42) 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: MW4PR11MB7125:EE_|IA1PR11MB6540:EE_
x-ms-office365-filtering-correlation-id: a7441ec4-98fd-40cf-e30b-08ddb03693d3
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|1800799024|366016|376014|38070700018;
x-microsoft-antispam-message-info: =?utf-8?B?aHppRU1YdG9pS29KNHo4VU5saksvaXdZSjh2aGp4OGNxNGd6UmVqUDNhRkl6?=
 =?utf-8?B?dHc4QXFtQWVucEdtVXRGNUUrVUJnd3h0SDVwSVFuUGEwNGcwSC9kNWVJa1hZ?=
 =?utf-8?B?dlUwcENyZUl4UWF0dm9tYVBWc2t4M1BnL0cxRDh4QmEwZnNqNmllYThIK3Nn?=
 =?utf-8?B?bVluRWFDdC8rR2ZSL3pMNFNYT3ZSVzZ2aFQzQkg5U09sMmprdlBMRHNBVjNa?=
 =?utf-8?B?N3IySFM4L1R1M29KbjNqR3ZZUFNaSHlteHF4L3lsdEE0bEZkSWprTER0VnJV?=
 =?utf-8?B?UWZxODZXUWs5TlpOSmZFSnhNeGcvQmFrOE1aUzIrYUZ3S2FLdG5OY0RQWHpM?=
 =?utf-8?B?d0FjWnhmQ0VpaGFIdmFWQi9jbmgyVXBDTWFGdC9tTGgyRllEc3BaaEozbzhP?=
 =?utf-8?B?UWNUZ2RTeDgxTCtsUVJqbFVTM1pvSXdZRTNDRFJDM2hSRy9BdEI5NFhNQjIv?=
 =?utf-8?B?YmNYdWhJNCtRZHU0bVBucWd6VDZjM3l2NlRTM1JJOUh1QVRUa0ZPeXZESGVE?=
 =?utf-8?B?a1YrMGpRUlJwSmZ5b0IyOFd5YVk5cStXTmFTSlB5cjJxNUdGV2pkM3lwN0Jz?=
 =?utf-8?B?eTlablVPYmNJVlhiMHhFMW8zSjRZZ0U4Y0xlT29LYk81L1JHdVZNRmxoU2dL?=
 =?utf-8?B?NWlab3RIK0RLVzN5UEZrV0lVUGljeVRGQ01wRHBLRTkwZFlkWkNqNmhDTTk3?=
 =?utf-8?B?T1JSZVlRenFDNXV3QmpHSHFXaVRBQ05td0JhQXBiZDJ4UW5Rcm1zckRpbTBw?=
 =?utf-8?B?eEhOdFZOblJkNFAwa0xEYndsVXdKNXpWS1UrR1M4aGtHQ1lzT2lWeXczVnVD?=
 =?utf-8?B?L3FadnhlR1dOcG5QNkxkZCtMb0M2TVBSV3IvTWRoMWN0a09RQTlKSnlGRWVE?=
 =?utf-8?B?WG1XOGdlWTVoTDArekhwUXliQ0ZNSjE4TUdNZHpKalZHVU8zcUJZbklBOS9D?=
 =?utf-8?B?TmFvbGtleDNRRWJPS0tCcG1vS1hiYmwxTEJaM3JjcGthcjhOL290OExpWUZF?=
 =?utf-8?B?Zit1YnovMkFiMHZvd3FYd21WY2Excyt1cjE3dURSUHlpZ2xZTmMvb29YQU9C?=
 =?utf-8?B?SHVEU0hTYitEcHU0cXpoNUsvSUo5am5HblRON0l0QU45RUloV1pVTG8yQXI3?=
 =?utf-8?B?RmkvYS9hMnIxNlpxRWJaQTZGY1lscGdudzZhVkJpTDF1NjR0bEVVRTBJTlZF?=
 =?utf-8?B?Qlc5dnJlQU91bjRCSUV0cjU4dmUzanZualBLQ0RCRFdZR1Fjam02TUs0VTNa?=
 =?utf-8?B?VUFIM0NoVk5NWlZ0cWgvaWd6MGtld29ZaDNuTVphZ21icDhaZmhnbDdxR0Fp?=
 =?utf-8?B?TFp6d2JYVW43RU5ncWZqUTVocEJhcGtaTk1wUm9wZjEzbkkzV0dzb285dlBj?=
 =?utf-8?B?T2hzb1B3bGNMcUZrUVdDa0hhNCtKT3NYaktqbHVpWS9Odk5yMTRrV0FyUDg3?=
 =?utf-8?B?c2VNY3hVUzJpdk01ZWxLZkQweGZwTlFsMEJHaFAwbkVCNS8xRnRDQUJFOXIy?=
 =?utf-8?B?TjYvcFpXb3ZQMG02NkpKTVF3MVUrUFBJalZ1T2xwUWlZbVp0dUcyeUtuNHZS?=
 =?utf-8?B?Tkd5Qzl3T1ZqUmhhWEt5YzdmVGkwc1VBL1c3QnRsMVhSbk1Xc2tkUFZubzRm?=
 =?utf-8?B?K1RicG9PREdLU3FVelRtUkNQeHp3M24xenk0MXFLR3BodTRDa2FvSGVMczR5?=
 =?utf-8?B?Qmdjd3JXM293QnJHSTBkRXNKT2ZvUWJPaWZ0QmRTajJuUTVCVEZ0dXJ4WlhF?=
 =?utf-8?B?QXZyeTc2NSs3cHV1WFhJT0tVSnN5ZEFHcDN1SjNiTDNKYitXVENHTGU4T1c4?=
 =?utf-8?B?ZW9IS09hQXVpN3M1M1pZbGZob1pJbWpLRzMxLytCQzRJY3FVU25xTHF5UVdG?=
 =?utf-8?B?Vld4SDd3YzlLcGhsN1FsSExCVG4yRnVJbmVVY0hRSllvR1dNa2lEbHBRMTZu?=
 =?utf-8?B?YXFacFRqVUxjVGozN0Z1WUZQajQwMGxacHd6azhkaUJqSThmTUFnRFZuc0da?=
 =?utf-8?Q?RVXxIPrQyaYWFNAYLkl/dm8jGYKvCc=3D?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MW4PR11MB7125.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?TndjcmkzUDArdFBkYkJlZWNXZVFDUEJQSHpvQUk0UGtiSXpuZWExUU4wQUI2?=
 =?utf-8?B?SHBJbUMwVGl6UDBtNTA5U1Z0VGd2QnpkaHorQ2xrVmFKU2ZvSGxLZFdLa0ky?=
 =?utf-8?B?VlVDUVpPVHhUUFUzcG1YNlQ5SlplV1NBTlVjSTlHZERkcmU5R2I1OWsrb1Rv?=
 =?utf-8?B?SlRMVk1HaExrbU5LVUl2dWVEZ0FzL08xVS9mYTBseUw1cmVWbFhJeUQ5MDRi?=
 =?utf-8?B?ZzNXU3A4dElXS1NNMVozSlNhSEFKb2Y1STNjWEN0dkdXTjFDcDlaSEZUSTNZ?=
 =?utf-8?B?bk82dTJOZ3BhWDFwazBxQnhpWVk4YlZ1aUcxdUM3N2N5MzY0bkRDdmZKR28r?=
 =?utf-8?B?YUMzc0FIV2Izc3prcGpiYmJTZzBqcnZURzdlNXRRam15TDdWR00zN0xTS3A2?=
 =?utf-8?B?eXo4ZWdiOUo5U1N4bEdsWE55ZlVhbDNBRmJIdVBkNmkva0pEZjYyN3NFOGdZ?=
 =?utf-8?B?VmtHN2M4Slc3UjFhNVVxMkZteExjc21mZU5iclJUUzRhK0hNb2ZLcnhPRDFr?=
 =?utf-8?B?OVo0bVRoaGsxTG1IL1ZVejAzMmg2L1l3ZUVuNHNaTG5uaE9Dcmc1Y0NSRktW?=
 =?utf-8?B?RFprTzUzWE1ja2Fqc2JrNkMzMDNlS0xKR2QwN3hsWXAwUVNsUW0ySy9tN0gy?=
 =?utf-8?B?TDlhbHFOcU5QbGtFc1d0RW1rT21CZURDRS9IZTRzdUdycHE2YnZPR08vTE04?=
 =?utf-8?B?ZEJwMUNKa3MzdmxseE1YK3VVUnFYb3lRNXg4NTlLUndLeGcrYWs4Vkhkb2dP?=
 =?utf-8?B?TGxObTVPYjdjQmZQOFQzNGxIZm4xNDR5YUlmWmtQVkRtYXo0UnFqWEZjKzh2?=
 =?utf-8?B?OS8wS1VPRHBMdEhjaUgrdC9HeksweWZCRm5GTXpZWHk2ZENnTnVscXRXTmUz?=
 =?utf-8?B?SktWd1VpbmsvTGw1aEY2Z1JGSTlpNTlNM2ZmejJCdGxjT2Y4WEpINEJKT3JN?=
 =?utf-8?B?MG90ZW5HeXcxTDhlNkloekNGNFY5RGhCdHVuTmsrTDZ5TnF6YmhNNUhmck5R?=
 =?utf-8?B?VHpuNm9yUHhwditGQ2hTWFkxR1cvSHZFQmxWNFU3OS9qWWs0SjIrK2Q2RGtV?=
 =?utf-8?B?TkxFQm9kV21YcFo0eVY4VUE5UWV0UkxLcXd6WTc5ZFE0TzZjbjBPSm9kYWhP?=
 =?utf-8?B?YjJKNlJBeDJGaGN5Y01SQmF4Y3l4Slc5U2UwdW9XZXB6WGplc0VXc1hBUURT?=
 =?utf-8?B?bzFXZlZqZjZXN0pZT2xmWnFyT0haSXhxOTNVNXZWOVZPV21YekFuLytmQnV2?=
 =?utf-8?B?QXBlYjVuZC9jd0tCTzMrWnR6QUtVcFdMUjdSWmVpODllMmJOcUc5VWp0Mmtj?=
 =?utf-8?B?MDRiSGVoTDc4dzhXUDNGaEdkZm1BMWFOTTE1aW01VWRoSU1vYlJxK0FBazg0?=
 =?utf-8?B?OFdKVk1ENTRya0NVbXVFT3htZFVPdjFqbEdCVHlPbGlHbmpDSWdVVUVFdGNR?=
 =?utf-8?B?S0k3SjFQRmdTbVp1MTRmWlpHQ0JxUnhtSnJYZmkvMm9zVzhla2xJTFREM2pi?=
 =?utf-8?B?dGNsdmJHUXk3OGMwYzM1Y3VQbEdGNUwwYkZWdGQwbTlQY29EeHVlSDBPY2dS?=
 =?utf-8?B?dHU1dG5zZjlDUmlhUWlCU0Y3ZjdHamlJQzhSUmlOVksxY3BuNzFXK290cUJJ?=
 =?utf-8?B?R3VrcmppejFROW00aDZWalRnS3ZuTTNpVTdpalRvTTNyZ2VZMmNSSDd6alhk?=
 =?utf-8?B?c2Q5UjlvSkt2Vi9CRkZSOWVBRENvZDZXbHNRbFFSbERFcDJHc2oya3l0bm1J?=
 =?utf-8?B?WEl4U3dFUlJsNjBzSGt1b1Z3REt1M3g5bk5OZWFUa2Q5dTh4NE1Qdmg0TDk1?=
 =?utf-8?B?Sk04cDkrelpPU09SelpXSEx4ek5jYWNtbjRScDdMaTN4Wm9yT0s5bktTME95?=
 =?utf-8?B?VjFsZ1lNTDVOLzh2TUhkdGVFWW9IT3pFdFBoSzJHZ2dQZ0kvSUZHNVM1dUZK?=
 =?utf-8?B?WTduTVo4NkZ4UUFSczU3Zmh4Z1BBenhab0htdmVYUDhnV3dOMkFHQXF1TWZw?=
 =?utf-8?B?QmtJT0dZMjJRRkhBc3lHZW1EWGVuT2lCQldWMVR5Q24xd1B6THp3TUkxSjhQ?=
 =?utf-8?B?TDdTUVBFV2Y1KzYwWWl4b2hMQ3JIOUpSNUlQdTJXM1NveTN0Sm45OGl2THp5?=
 =?utf-8?B?K3AyWEQyajBuNlMyMjJZL2pmdWM3Q1Z0TkpnSi9Gdk1iUmVYbFVlblZ1VS9X?=
 =?utf-8?B?N3c9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <1797521353282B4AB88A6C08AA7D39E2@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MW4PR11MB7125.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a7441ec4-98fd-40cf-e30b-08ddb03693d3
X-MS-Exchange-CrossTenant-originalarrivaltime: 20 Jun 2025 20:11:01.0910
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: tq6ChknaPq99lZvZ7DzKCvcuyTyfxUPazKKZekDe30t8TF2IoTsdByctz2hltkrRV5dpuAJh61JD43I5GxT/5jrzTLhVjNXcwQK0Yg4POh4=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR11MB6540
X-OriginatorOrg: intel.com

T24gV2VkLCAyMDI1LTA2LTE4IGF0IDE4OjA2IC0wNzAwLCBBbGlzb24gU2Nob2ZpZWxkIHdyb3Rl
Og0KPiBPbiBXZWQsIEp1biAxOCwgMjAyNSBhdCAwMzoyMToyOFBNIC0wNzAwLCBEYW4gV2lsbGlh
bXMgd3JvdGU6DQo+ID4gV2l0aCBjdXJyZW50IGtlcm5lbCt0cmFjZWNtZCBjb21iaW5hdGlvbnMg
c3Rkb3V0IGlzIG5vIGxvbmdlciBwdXJlbHkgdHJhY2UNCj4gPiByZWNvcmRzIGFuZCBjb2x1bW4g
IjIxIiBpcyBubyBsb25nZXIgdGhlIHZtZmF1bHRfdCByZXN1bHQuDQo+ID4gDQo+ID4gRHJvcCwg
aWYgcHJlc2VudCwgdGhlIGRpYWdub3N0aWMgcHJpbnQgb2YgaG93IG1hbnkgQ1BVcyBhcmUgaW4g
dGhlIHRyYWNlDQo+ID4gYW5kIHVzZSB0aGUgbW9yZSB1bml2ZXJzYWxseSBjb21wYXRpYmxlIGFz
c3VtcHRpb24gdGhhdCB0aGUgZmF1bHQgcmVzdWx0IGlzDQo+ID4gdGhlIGxhc3QgY29sdW1uIHJh
dGhlciB0aGFuIGEgc3BlY2lmaWMgY29sdW1uLg0KPiA+IA0KPiA+IFNpZ25lZC1vZmYtYnk6IERh
biBXaWxsaWFtcyA8ZGFuLmoud2lsbGlhbXNAaW50ZWwuY29tPg0KPiA+IC0tLQ0KPiA+IMKgdGVz
dC9kYXguc2ggfCAzICsrLQ0KPiA+IMKgMSBmaWxlIGNoYW5nZWQsIDIgaW5zZXJ0aW9ucygrKSwg
MSBkZWxldGlvbigtKQ0KPiA+IA0KPiA+IGRpZmYgLS1naXQgYS90ZXN0L2RheC5zaCBiL3Rlc3Qv
ZGF4LnNoDQo+ID4gaW5kZXggM2ZmYmM4MDc5ZWJhLi45OGZhYWYwZWI5YjIgMTAwNzU1DQo+ID4g
LS0tIGEvdGVzdC9kYXguc2gNCj4gPiArKysgYi90ZXN0L2RheC5zaA0KPiA+IEBAIC0zNywxMyAr
MzcsMTQgQEAgcnVuX3Rlc3QoKSB7DQo+ID4gwqAJcmM9MQ0KPiA+IMKgCXdoaWxlIHJlYWQgLXIg
cDsgZG8NCj4gPiDCoAkJW1sgJHAgXV0gfHwgY29udGludWUNCj4gPiArCQlbWyAkcCA9PSBjcHVz
PSogXV0gJiYgY29udGludWUNCj4gcmVtb3ZlIGFib3ZlIGxpbmUNCj4gPiDCoAkJaWYgWyAiJGNv
dW50IiAtbHQgMTAgXTsgdGhlbg0KPiA+IMKgCQkJaWYgWyAiJHAiICE9ICIweDEwMCIgXSAmJiBb
ICIkcCIgIT0gIk5PUEFHRSIgXTsgdGhlbg0KPiA+IMKgCQkJCWNsZWFudXAgIiQxIg0KPiA+IMKg
CQkJZmkNCj4gPiDCoAkJZmkNCj4gPiDCoAkJY291bnQ9JCgoY291bnQgKyAxKSkNCj4gPiAtCWRv
bmUgPCA8KHRyYWNlLWNtZCByZXBvcnQgfCBhd2sgJ3sgcHJpbnQgJDIxIH0nKQ0KPiA+ICsJZG9u
ZSA8IDwodHJhY2UtY21kIHJlcG9ydCB8IGF3ayAneyBwcmludCAkTkYgfScpDQo+IHJlcGxhY2Ug
YWJvdmUgbGluZSB3DQo+IAlkb25lIDwgPCh0cmFjZS1jbWQgcmVwb3J0IHwgZ3JlcCBkYXhfcG1k
X2ZhdWx0X2RvbmUgfCBhd2sgJ3sgcHJpbnQgJE5GIH0nKQ0KDQpWZXJ5IG1pbm9yIG5pdCwgYnV0
IHNpbmNlIHlvdSdyZSBhbHJlYWR5IHVzaW5nIGF3aywgbm8gbmVlZCB0byBncmVwDQpmaXJzdCwg
aW5zdGVhZCB5b3UgY2FuIHVzZSBhd2sncyAnZmlyc3QgcGFydCcgdG8gZG8gdGhlIGZpbHRlcmlu
ZyAtIA0KDQogIGRvbmUgPCA8KHRyYWNlLWNtZCByZXBvcnQgfCBhd2sgJy9kYXhfcG1kX2ZhdWx0
X2RvbmUveyBwcmludCAkTkYgfScpDQoNCllvdSBjYW4gc3RpY2sgYW55IHJlZ2V4IGJldHdlZW4g
dGhlIC8uLi8gYW5kIGl0IHdpbGwgb25seSBhY3Qgb24gbGluZXMNCm1hdGNoaW5nIHRoYXQuDQo=
