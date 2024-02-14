Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.15])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E0F8813A86D
	for <nvdimm@lists.linux.dev>; Wed, 14 Feb 2024 19:28:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.15
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707938938; cv=fail; b=NJkOPVfLQi+xRsRo6Uc9hdbJm9vALJVbzhn23GGVmZbWgFAorUmRrB/4PM7Mgo+gTXknn7Cb3nKYl7TR78CR9EXOyw8EoFvS0OBs5Y5iXXkUibW9L03+S8AtELfO/rT1qges7zrfNW9eKBC2Bd53+g+t9QNvUYrejYHgMIMMxfg=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707938938; c=relaxed/simple;
	bh=H/0wi5G+ANo2ZF1/JyAadyW7oEPDtzWfUT/umZ3tL3c=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=nVFNBu75F+i54O+K2pOVfcnsTf1H41KU0UOsr3Y33o7k2PtnP0FQMjPLOcQnJwngh4LwHcsUJoSKOeDpPkGhPgcUNR49ZqkneXnL3ilR6Okr12+WNyrxOWLg99u5SyA5QGRDOa1dO0zO7IhA2FLyIU+Q53DHu1AybT2Y0WxH+q8=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=dKEm0YfT; arc=fail smtp.client-ip=192.198.163.15
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="dKEm0YfT"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1707938934; x=1739474934;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=H/0wi5G+ANo2ZF1/JyAadyW7oEPDtzWfUT/umZ3tL3c=;
  b=dKEm0YfTLauGO5mNoyIqIKo+k+zwzU7HR1J9QQonjXrAFzMO8ibIqatz
   h9ena3XSs6jvSOFi1J9YdR3stYldWoWT3frfwGpERfcmlHlmLMHyueSB3
   l0/xgWM3cstMvKHfcfmEsNGy0cEqtFvAYlc0FtcdreGxNLNjJnxDHg8E1
   QlWxSKDVqevYa065XcbfhvSSCKYBYHmjcHI3F5eHT8fuG5jOkFSV7hkhz
   ya+ZBEe7a44NAbHGyqyiufaK/acwSdIAVzjYYp5nhBfBBL5g6I5xd8ewG
   +NDw8vmL7EU8I2iW/L/wLAl/W0imMe+8BP5zh+cANE5ZO45i1CKEIRikK
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10984"; a="2130520"
X-IronPort-AV: E=Sophos;i="6.06,160,1705392000"; 
   d="scan'208";a="2130520"
Received: from orviesa003.jf.intel.com ([10.64.159.143])
  by fmvoesa109.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Feb 2024 11:28:53 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.06,160,1705392000"; 
   d="scan'208";a="7941750"
Received: from fmsmsx601.amr.corp.intel.com ([10.18.126.81])
  by orviesa003.jf.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 14 Feb 2024 11:28:53 -0800
Received: from fmsmsx611.amr.corp.intel.com (10.18.126.91) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35; Wed, 14 Feb 2024 11:28:52 -0800
Received: from fmsmsx603.amr.corp.intel.com (10.18.126.83) by
 fmsmsx611.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35; Wed, 14 Feb 2024 11:28:51 -0800
Received: from fmsedg602.ED.cps.intel.com (10.1.192.136) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35 via Frontend Transport; Wed, 14 Feb 2024 11:28:51 -0800
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (104.47.59.169)
 by edgegateway.intel.com (192.55.55.71) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.35; Wed, 14 Feb 2024 11:28:48 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=WRnUlYTL1rxGCZwj/yjoaHX25trfuVWu7Des5WSI9L4+NdPwDYSe+3JIf3ahWrkKfgGrG94AiOgKs2NLhQCA0bquYNrII48QZViBRkmIy1MxHYvYEKVq6vP3zqT8skBw1ahxi+3PZ519P76RR5XBtwhEQqaEpM3A9QsVaCgJh1+DqwmoDiWo4J4sowEPDoTqv9LnpbRIdwtMnz3LgdSUZzixKRLeQenT6MB9JBB7b2k8DDLGHeCqmAblKT0T0usBhNrnXlYVicHBAs1eSg4YbZNqWaBhpsID6Du+5SKLsMftFFVwITVEPIfnrSXQU0SdijPTBTFqDuAPSqgRc7mVoA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=H/0wi5G+ANo2ZF1/JyAadyW7oEPDtzWfUT/umZ3tL3c=;
 b=oX480JPupLvzGH4bpiJOW+xqtGKC1iEeCSwwdSA+ZbyHkPjoqvp0K8CrbzYkVXPF3xCb+bm9vnrD0eG5wRDYFfTFmoYdZHjnal+loO/do8C/igmC4xS2aer0hkKRNd3qExlWMINPiGQvfQWnQTv20XR5VDW2P5H7PHHbZAZABAuIUnDO3pk16cDWD66Bu5qiWDj3j+MruA89if6kmEje932K1GqtQRD7JoIzCfOPMq+6Umc/u8Ksi5DwhhzK2DGfWxUMyYUc9Iw4pbOEGyAH4ZdVEJNUbVeAOxBjp/qCcJi98Dvf7VpsBWPCiHSE5Pr2AJygGiRGXoebzDrtxUiQ0g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from MW4PR11MB7125.namprd11.prod.outlook.com (2603:10b6:303:219::12)
 by SA1PR11MB6760.namprd11.prod.outlook.com (2603:10b6:806:25f::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7249.39; Wed, 14 Feb
 2024 19:28:45 +0000
Received: from MW4PR11MB7125.namprd11.prod.outlook.com
 ([fe80::e28a:f124:d986:c1d0]) by MW4PR11MB7125.namprd11.prod.outlook.com
 ([fe80::e28a:f124:d986:c1d0%5]) with mapi id 15.20.7270.033; Wed, 14 Feb 2024
 19:28:45 +0000
From: "Verma, Vishal L" <vishal.l.verma@intel.com>
To: "Schofield, Alison" <alison.schofield@intel.com>
CC: "linux-cxl@vger.kernel.org" <linux-cxl@vger.kernel.org>,
	"nvdimm@lists.linux.dev" <nvdimm@lists.linux.dev>
Subject: Re: [ndctl PATCH] cxl/test: Add 3-way HB interleave testcase to
 cxl-xor-region.sh
Thread-Topic: [ndctl PATCH] cxl/test: Add 3-way HB interleave testcase to
 cxl-xor-region.sh
Thread-Index: AQHaXxWHUNrtpA8TZ0GOOrAg0jrpBLEKOd+A
Date: Wed, 14 Feb 2024 19:28:45 +0000
Message-ID: <3740aad81564f41c7d4e175682a1881253fc2cd6.camel@intel.com>
References: <20240214071447.1918988-1-alison.schofield@intel.com>
In-Reply-To: <20240214071447.1918988-1-alison.schofield@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.50.3 (3.50.3-1.fc39) 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: MW4PR11MB7125:EE_|SA1PR11MB6760:EE_
x-ms-office365-filtering-correlation-id: af04d593-8980-42f6-cb30-08dc2d932948
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: m4Gu7vAevIn9Kl3wRFjX9X0IIp7g8rTTrackntg82fJ6Ba2ZH+9NG8XVD7WBNZguj9BeW02RnZ4rQ9N2hRDn4MrOpv7JXOdLOfYwmkkOj/Nrn3cpvLcioZN9ipB8HLQBh5K6KBd9KsBwJOgjJgvGAxJ8R2xaIPCLkaJ92xgV0NzRkYnNNs0pIXDshrkOaZh8tIDeAmrQb24wXP45FTj85OhIJEwhVfIxEWWaTkYsgpKIvGR4RY1emFZ/KvIkZpnak5pCWD7xQGmpazWiwtA0nDlBr2xuqsDSbqKQzLro4limulyLBBcCndFysn2FL78uJ2Ger2VRr3G++MKvXonQSer5Al8zx2Yp2uVPWF6mj6gwf29nUE22MxfUE4+4J/BgOaYjT4xbI+tVF2gh6Amlxuw1cFUVbP3350CAG/wCl1kMHFlTieBQdUbJ3pMpOoPK/KO0uOSp11N7o17WvmnS+8wKleHq5wXhyJ1tvQj6wxI5AQbwbEYobLqHwGW/BJu3+B4/AQM3qsV4uODGjIf3pe7HbThqdJKmGG/43PDXQNbhvK1E3n8f9nJPjrNbpv4UPSqgMgmreUgKz19Lo1gvnXVKoezS6x1ZYpvjNKovB+rMUuR2SDyIUOYiKI4d7v4u
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MW4PR11MB7125.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(346002)(39860400002)(396003)(376002)(366004)(136003)(230922051799003)(186009)(451199024)(64100799003)(1800799012)(2906002)(4326008)(86362001)(6486002)(66476007)(6512007)(26005)(6506007)(36756003)(71200400001)(478600001)(38070700009)(122000001)(8936002)(82960400001)(38100700002)(64756008)(6862004)(2616005)(76116006)(66556008)(8676002)(66946007)(5660300002)(66446008)(37006003)(54906003)(316002)(6636002)(41300700001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?WTBDeVFiWi85ZXFrNVB0b0J3STVZWnZSWWJSTXQzRHVLcTNTeHdZV2ErZit4?=
 =?utf-8?B?SVZuMUxTbUNtRTlTc1BTbUdWdnhEOGEvNGJIL2YxU1VVeThtTHhVQ29oZDJP?=
 =?utf-8?B?VWsxQVNlclkrTktLUEl4eHlvL1k5ay9ZV1BBSlRuUk1ZaFFjUUJsUGpaWE5q?=
 =?utf-8?B?MUlWd0hpT0hiN01HOFE0YVZwRVBXcVU0RkYzVHgreTJLUTJuNEljSE5jTTBC?=
 =?utf-8?B?V0s1ZStDVnN2WUJnRzJhYXVVMm5hNEtWTWs1OVkvV3dpWGpVUm5UQytveDc2?=
 =?utf-8?B?NzdIN2d3bTRRNXU3R3lXN1BUWlNFZFlLM0lMemVXdHV6UkFBTWczdlVSTHpM?=
 =?utf-8?B?bGF4RzYzcFFMYk1WeCsvaUt4S1pDTndGL0l2WVY0cE5kN011UnNkQXVSajhK?=
 =?utf-8?B?dDZLY2tYMUNOc0UxTStKZlRqZ3dWTnNjYjZsRmdwYi9uTWVnZWFpajNDOEdM?=
 =?utf-8?B?WXNWZExFV25hME5SS2F6SkhIUXZ3REY5SWR4OCsrcXIwM05TQy96WHkxcFdX?=
 =?utf-8?B?eTYyM04zaHlzZC9pWXQ2OFNCYmU5V1luZ2puTllwTjBzOE8yRlNDT2taaVdr?=
 =?utf-8?B?NWJxZExjbDZ0ZDJYMGxVcEpWajE3SUNVM1liV2dnd2p4NktxR2V3anQ2QjRt?=
 =?utf-8?B?ZGUvYVpMQlUwRmMwT1hVOVgrN3o0MXNqekhHUi8wcFByUWtSbW5qUzliTVJL?=
 =?utf-8?B?QWxXWVBHalJOTXBCTWxGUmdKZW5Yam1yN1dTVmhHL3JSWnV0NW51YkVTK3Yv?=
 =?utf-8?B?SzBrd05tOVVWODc1QWwyT1lKVlZOb1BtMGJjajhoVU8wZXF6RkpOTW55M2RG?=
 =?utf-8?B?YVFqL0NPWTlBTWRLaEU1Z3JZMEg2QUxWanZPbG1wWlZ6U2lwMFpmSzNSV2wy?=
 =?utf-8?B?SXllUmlMbjFMVHNYSU9DdHB4QkJpdzBKYWpYU1N0UkY4d3lXaytmNGZvcmUr?=
 =?utf-8?B?VjVzc1hWVklDRHNPUkVLUEdLemVHVDlHTGh3eXNYYnZrMVRYYUo2dUkvN1E1?=
 =?utf-8?B?cjh6OTgvemxCM0NSOURQeGZSZEtnL2huekNDa1J0QXBqMVpLbm8yWkpMRmZJ?=
 =?utf-8?B?OVNic282RUxDSWxJcGY3ZUNaWWEwb2Z2M2JCMnZ3MjRWM1crWXJFR0VNdkNO?=
 =?utf-8?B?dUNHa1dCMkVwMmZudjFpazhuVTk3VVJoSTUvVUw3U1hERWszY1VXdHoyL1hX?=
 =?utf-8?B?eXh0S3ZpUmt6RHhJUW44dHhub1djRjM0ZXhWUS9wcDExRHphUDVYOWJDV1kz?=
 =?utf-8?B?NDNiVXdNdkdObDl4V3FBODB0ZVJ5Zkh0dVh3M2U0dzZ6eGhFSHB6ckJVTHJr?=
 =?utf-8?B?S0dmdUpFV3l6bVhJK1BNa1E3Ri9hcWwxQjR2TlhDeXZDRjRROXNMazVXRHZD?=
 =?utf-8?B?dUlFcGxvRVprYllHWEVIalZQNVV6MHhvQUFONkNOcDN1K3U0RDdUN1hBczZw?=
 =?utf-8?B?TEhEY2VqbGh2T0RUV3lTWXJpS3hKcmJUVXU2bHR3MFQ3cTZIR01BVlVieTFI?=
 =?utf-8?B?d1ZBK2xsMXZwUHlVR1pocnlYOFJzTzVHb3VvUTVueldWNTl5aUZ3YlgzZDRV?=
 =?utf-8?B?d3ZPaU1NLy9xS2gwQ2Z0K1dWR1dOSVNPdnBRdzhnZ0pzaGN6MTBpR1BCa3Uy?=
 =?utf-8?B?ajRlYnBocjlTaHREblp1UzA3MVpMRkExbUhlQ0d3d04yRkJxbXNGNUlEQUxr?=
 =?utf-8?B?UFB5dHVCNk5YMUxva1BWMFNBdTkxb3dFVXVTR2RBSDJUbFZzU2x4SDhNc1BU?=
 =?utf-8?B?cVpqbDIvcUYzRTNKZGtqNHVWNk1RenFXV1dycmV2MjRjTTFmRmFBT3M5SnNw?=
 =?utf-8?B?a0owTFQ4emxZaGhYaklUa2FIemFzNWkrM09vbWd2K1l6TkNiMDZoaGdwR2F2?=
 =?utf-8?B?b25Xbytpc3hqYXd6VFdCSldzU2d1TitmL1NHMHo5VjJCRUZ0QUNZbTRrWXBI?=
 =?utf-8?B?cXRZeWhYbXYyWkhZczhmSW9YcTh0WDBHNnVjRWVrU2FZMklvU3hyeHhQMXZi?=
 =?utf-8?B?cFBLOXYrM1V6UEN1SitSUkJnWWpJbDFQWEZNK1p3U1kwUm5WR2lPeExrOElX?=
 =?utf-8?B?ejN1OENhOEI1dHFTRDkzRHp2aDdlM2orcWJaV005MFpYN1hwQVFxeFAzTFRp?=
 =?utf-8?B?T1B5eVRuQjdCbmpUNlh0OHkvdFdaWDVkRk9kVkhZb25LTlhsYTcweUVMa09l?=
 =?utf-8?B?UkE9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <DE752DCEB2FF9743B1230A18D60D1FFA@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MW4PR11MB7125.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: af04d593-8980-42f6-cb30-08dc2d932948
X-MS-Exchange-CrossTenant-originalarrivaltime: 14 Feb 2024 19:28:45.5519
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: C9KsjtrHZmMFFlqeLC5jl/PqjsTFmTATQGn6dq10qM8cLjp581KKVyculBX90GHo+mUnaWxrRXR7M5WUlo+dXzeIzgLLfVE4bG9HHr98tPs=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR11MB6760
X-OriginatorOrg: intel.com

T24gVHVlLCAyMDI0LTAyLTEzIGF0IDIzOjE0IC0wODAwLCBhbGlzb24uc2Nob2ZpZWxkQGludGVs
LmNvbSB3cm90ZToNCj4gRnJvbTogQWxpc29uIFNjaG9maWVsZCA8YWxpc29uLnNjaG9maWVsZEBp
bnRlbC5jb20+DQo+IA0KPiBjeGwteG9yLXJlZ2lvbi5zaCBpbmNsdWRlcyB0ZXN0IGNhc2VzIGZv
ciAxICYgMiB3YXkgaG9zdCBicmlkZ2UNCj4gaW50ZXJsZWF2ZXMuIEFkZCBhIG5ldyB0ZXN0IGNh
c2UgdG8gZXhlcmNpc2UgdGhlIG1vZHVsbyBtYXRoDQo+IGZ1bmN0aW9uIHRoZSBDWEwgZHJpdmVy
IHVzZXMgdG8gZmluZCBwb3NpdGlvbnMgaW4gYSAzLXdheSBob3N0DQo+IGJyaWRnZSBpbnRlcmxl
YXZlLg0KPiANCj4gU2tpcCB0aGlzIHRlc3QgY2FzZSwgZG9uJ3QgZmFpbCwgaWYgdGhlIG5ldyAz
LXdheSBYT1IgZGVjb2Rlcg0KPiBpcyBub3QgcHJlc2VudCBpbiBjeGwvdGVzdC4NCj4gDQo+IEFk
ZCB0aGUgbWlzc2luZyBjaGVja19kbWVzZyBoZWxwZXIgYmVmb3JlIGV4aXRpbmcgdGhpcyB0ZXN0
Lg0KPiANCj4gU2lnbmVkLW9mZi1ieTogQWxpc29uIFNjaG9maWVsZCA8YWxpc29uLnNjaG9maWVs
ZEBpbnRlbC5jb20+DQo+IC0tLQ0KPiDCoHRlc3QvY3hsLXhvci1yZWdpb24uc2ggfCAzMyArKysr
KysrKysrKysrKysrKysrKysrKysrKysrKysrKysNCj4gwqAxIGZpbGUgY2hhbmdlZCwgMzMgaW5z
ZXJ0aW9ucygrKQ0KPiANCj4gZGlmZiAtLWdpdCBhL3Rlc3QvY3hsLXhvci1yZWdpb24uc2ggYi90
ZXN0L2N4bC14b3ItcmVnaW9uLnNoDQo+IGluZGV4IDExN2U3YTRiYmE2MS4uMmYzYjRhYTUyMDhh
IDEwMDY0NA0KPiAtLS0gYS90ZXN0L2N4bC14b3ItcmVnaW9uLnNoDQo+ICsrKyBiL3Rlc3QvY3hs
LXhvci1yZWdpb24uc2gNCj4gQEAgLTg2LDExICs4Niw0NCBAQCBzZXR1cF94NCgpDQo+IMKgwqDC
oMKgwqDCoMKgwqAgbWVtZGV2cz0iJG1lbTAgJG1lbTEgJG1lbTIgJG1lbTMiDQo+IMKgfQ0KPiDC
oA0KPiArc2V0dXBfeDMoKQ0KPiArew0KPiArwqDCoMKgwqDCoMKgwqAgIyBmaW5kIGFuIHgzIGRl
Y29kZXINCj4gK8KgwqDCoMKgwqDCoMKgIGRlY29kZXI9JCgkQ1hMIGxpc3QgLWIgY3hsX3Rlc3Qg
LUQgLWQgcm9vdCB8IGpxIC1yICIuW10gfA0KPiArwqDCoMKgwqDCoMKgwqDCoMKgIHNlbGVjdCgu
cG1lbV9jYXBhYmxlID09IHRydWUpIHwNCj4gK8KgwqDCoMKgwqDCoMKgwqDCoCBzZWxlY3QoLm5y
X3RhcmdldHMgPT0gMykgfA0KPiArwqDCoMKgwqDCoMKgwqDCoMKgIC5kZWNvZGVyIikNCg0KQXJl
IHRoZXNlIGxpbmVzLi4NCg0KPiArDQo+ICsJaWYgW1sgISAkZGVjb2RlciBdXTsgdGhlbg0KPiAr
CQllY2hvICJubyB4MyBkZWNvZGVyIGZvdW5kLCBza2lwcGluZyB4b3IteDMgdGVzdCINCj4gKwkJ
cmV0dXJuDQo+ICsJZmkNCj4gKw0KPiArwqDCoMKgwqDCoMKgwqAgIyBGaW5kIGEgbWVtZGV2IGZv
ciBlYWNoIGhvc3QtYnJpZGdlIGludGVybGVhdmUgcG9zaXRpb24NCj4gK8KgwqDCoMKgwqDCoMKg
IHBvcnRfZGV2MD0kKCRDWEwgbGlzdCAtVCAtZCAiJGRlY29kZXIiIHwganEgLXIgIi5bXSB8DQo+
ICvCoMKgwqDCoMKgwqDCoMKgwqDCoMKgIC50YXJnZXRzIHwgLltdIHwgc2VsZWN0KC5wb3NpdGlv
biA9PSAwKSB8IC50YXJnZXQiKQ0KPiArwqDCoMKgwqDCoMKgwqAgcG9ydF9kZXYxPSQoJENYTCBs
aXN0IC1UIC1kICIkZGVjb2RlciIgfCBqcSAtciAiLltdIHwNCj4gK8KgwqDCoMKgwqDCoMKgwqDC
oMKgwqAgLnRhcmdldHMgfCAuW10gfCBzZWxlY3QoLnBvc2l0aW9uID09IDEpIHwgLnRhcmdldCIp
DQo+ICvCoMKgwqDCoMKgwqDCoCBwb3J0X2RldjI9JCgkQ1hMIGxpc3QgLVQgLWQgIiRkZWNvZGVy
IiB8IGpxIC1yICIuW10gfA0KPiArwqDCoMKgwqDCoMKgwqDCoMKgwqDCoCAudGFyZ2V0cyB8IC5b
XSB8IHNlbGVjdCgucG9zaXRpb24gPT0gMikgfCAudGFyZ2V0IikNCg0KLi5hbmQgdGhlc2UgbWlz
LWluZGVudGVkPw0KDQpMb29rcyBnb29kIG90aGVyd2lzZS4NCg0KPiArCW1lbTA9JCgkQ1hMIGxp
c3QgLU0gLXAgIiRwb3J0X2RldjAiIHwganEgLXIgIi5bMF0ubWVtZGV2IikNCj4gKwltZW0xPSQo
JENYTCBsaXN0IC1NIC1wICIkcG9ydF9kZXYxIiB8IGpxIC1yICIuWzBdLm1lbWRldiIpDQo+ICsJ
bWVtMj0kKCRDWEwgbGlzdCAtTSAtcCAiJHBvcnRfZGV2MiIgfCBqcSAtciAiLlswXS5tZW1kZXYi
KQ0KPiArCW1lbWRldnM9IiRtZW0wICRtZW0xICRtZW0yIg0KPiArfQ0KPiArDQo+IMKgc2V0dXBf
eDENCj4gwqBjcmVhdGVfYW5kX2Rlc3Ryb3lfcmVnaW9uDQo+IMKgc2V0dXBfeDINCj4gwqBjcmVh
dGVfYW5kX2Rlc3Ryb3lfcmVnaW9uDQo+IMKgc2V0dXBfeDQNCj4gwqBjcmVhdGVfYW5kX2Rlc3Ry
b3lfcmVnaW9uDQo+ICsjIHgzIGRlY29kZXIgbWF5IG5vdCBiZSBhdmFpbGFibGUgaW4gY3hsL3Rl
c3QgdG9wbyB5ZXQNCj4gK3NldHVwX3gzDQo+ICtpZiBbWyAkZGVjb2RlciBdXTsgdGhlbg0KPiAr
CWNyZWF0ZV9hbmRfZGVzdHJveV9yZWdpb24NCj4gK2ZpDQo+ICsNCj4gK2NoZWNrX2RtZXNnICIk
TElORU5PIg0KPiDCoA0KPiDCoG1vZHByb2JlIC1yIGN4bF90ZXN0DQoNCg==
