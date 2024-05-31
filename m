Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.7])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B74ACEAE7
	for <nvdimm@lists.linux.dev>; Fri, 31 May 2024 20:02:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.7
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717185780; cv=fail; b=MVg+jIC1AWABGQuOiV02DUmgKYUpR6DV9SarCV+z9Ihe18e5xvyY5LGXPEzZ/epSreKtgOE5m/4Nx9u2eYQmLm7FO6KxzyHNMIhDxpNVukj+3uPp/bCMFKD8+iMb/r1z/s9XqKZ1qwolSkjXBfiY047OTPm1UFzSvJnSrBmBZlg=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717185780; c=relaxed/simple;
	bh=BKrMU5jWLuUhu31CzJmMOlSJe0QnkVZANwX99QWtMlg=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=GDz+6C1/B7u/61T1r7iVEveT7/O+AyDiXKrTJFiUQDsO3qgGsVKzFKqFwAAdRhY5D0/hFRekCCp6oA0iUeYs7b23m+D+yZN5yBv1D5Key5qjDcoqr7WIz77L5oV89Pb8y3Dtf2sa3iSD79uzwmP0LMQgye+lwxduo0KzeTkUZRc=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=a2ApgT65; arc=fail smtp.client-ip=192.198.163.7
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="a2ApgT65"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1717185778; x=1748721778;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=BKrMU5jWLuUhu31CzJmMOlSJe0QnkVZANwX99QWtMlg=;
  b=a2ApgT65y2gAjQxwqFZ0rAmO3gkWra5/tUC/FKtsOMJltOaKBMGk+Id6
   wQYq+GjLNpMvg5xvFCH5IsIgyvCCVqtOvzr1TDwfGDJA8q+iMUp5JBPyn
   0Qm+NPaNKixgcf0HzTZZFfIXw0ZoZj4cqMnVraIswuqi7yoFV6S6nIREx
   cfwFVsEdKUVHG2GiDcypmFaCQpZL0dyVeSHjp9m6ANRe5LjIWSKyuGdlS
   wdgsLqUMAPAHbgWZpEgHGbDLf2XTIoaB6m3vurU9uAIRk/sHuRpVWntTn
   VrDZSvxBOGLaNOZ4G88XeQfLT/T+n1+eA2eN8/5d+QMdMC+iBQEIiA3C7
   g==;
X-CSE-ConnectionGUID: +/rx+Lx4QKS1NK/2Cfe6uQ==
X-CSE-MsgGUID: AnIz5tBrSuKVS+bS/P2Xsw==
X-IronPort-AV: E=McAfee;i="6600,9927,11089"; a="39146582"
X-IronPort-AV: E=Sophos;i="6.08,205,1712646000"; 
   d="scan'208";a="39146582"
Received: from fmviesa001.fm.intel.com ([10.60.135.141])
  by fmvoesa101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 31 May 2024 13:02:55 -0700
X-CSE-ConnectionGUID: RXnsjM+5RPKJUDp2/e1+yA==
X-CSE-MsgGUID: awRKZM/tSICXetA+FBaO4g==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.08,205,1712646000"; 
   d="scan'208";a="67456066"
Received: from fmsmsx601.amr.corp.intel.com ([10.18.126.81])
  by fmviesa001.fm.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 31 May 2024 13:02:54 -0700
Received: from fmsmsx602.amr.corp.intel.com (10.18.126.82) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Fri, 31 May 2024 13:02:53 -0700
Received: from fmsedg601.ED.cps.intel.com (10.1.192.135) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39 via Frontend Transport; Fri, 31 May 2024 13:02:53 -0700
Received: from NAM02-SN1-obe.outbound.protection.outlook.com (104.47.57.41) by
 edgegateway.intel.com (192.55.55.70) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.39; Fri, 31 May 2024 13:02:53 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=KsAVV6MKZO+Ez1KcGSCYOWgz8D1KtjPf4bqNT34DqL9QU13vqNBftYFzkeV1raIPQI2ef9aXEkavmu1RngrFXJdOKuuSEjXCfFZr2CoHALDphTsOrk60Fm6y9Ryr78MiCl90lr2kOPINaJPp3RtiLOpi6uYgv2Y7+oMoCNl7jap/M3CP7zj0M+Hg4n3ZtvbZEpT37NcbOIJ+ISMT65nGjn90XnzFFXAhiMpEHp92SFi8/n2vf+6AgYFJqWdexX7EAGhuOUziAZ549cOSUSFUs5gox0aiCgFdgGDOpkLH/o9Z3u+w4eP4FBlQeXl5yesY1ou5svciehKgIwK93vctvQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=BKrMU5jWLuUhu31CzJmMOlSJe0QnkVZANwX99QWtMlg=;
 b=VmxZyBENp3WSUi2Se61c6NNDHcXI9R8A0DULGTFMz8not9JJ0S4R0K3bZSqitjXl9LRahYy8+uosPXA6eKf0RKwMjr2kVm1plpEqb5K4io1PoyZxy+dy1h9ctRJxVplaZXo+DBFPVUAJyb2kxMGLFGn75GnAsSRnZNpEkxRu1UhnaKJRDJardpbgiv16L0/Hj2Gr+5FJtGqedZNLNUQKefewVFofOMzXOldhN3BAxqnD3Q0IacunFsZdpNaEP5SO7YMsaaZAsR+OOhAuJ5MKMROKD0PIiWHMtKkokNnyg8U+qxAQvxsYJwemozpSCjCLkQuGMVuMR1P//rTk3UPUbA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from MW4PR11MB7125.namprd11.prod.outlook.com (2603:10b6:303:219::12)
 by MW5PR11MB5764.namprd11.prod.outlook.com (2603:10b6:303:197::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7633.22; Fri, 31 May
 2024 20:02:51 +0000
Received: from MW4PR11MB7125.namprd11.prod.outlook.com
 ([fe80::eff6:f7ef:65cd:8684]) by MW4PR11MB7125.namprd11.prod.outlook.com
 ([fe80::eff6:f7ef:65cd:8684%6]) with mapi id 15.20.7633.021; Fri, 31 May 2024
 20:02:51 +0000
From: "Verma, Vishal L" <vishal.l.verma@intel.com>
To: "lizhijian@fujitsu.com" <lizhijian@fujitsu.com>,
	"linux-cxl@vger.kernel.org" <linux-cxl@vger.kernel.org>,
	"nvdimm@lists.linux.dev" <nvdimm@lists.linux.dev>
CC: "fan.ni@samsung.com" <fan.ni@samsung.com>
Subject: Re: [ndctl PATCH v2 1/2] daxctl: Fix create-device parameters parsing
Thread-Topic: [ndctl PATCH v2 1/2] daxctl: Fix create-device parameters
 parsing
Thread-Index: AQHasyQTNN9OugoSPUeOjRXC7hOw2LGxxL8A
Date: Fri, 31 May 2024 20:02:51 +0000
Message-ID: <afd7d90d89f1929337436d7089291dd601d0b243.camel@intel.com>
References: <20240531062959.881772-1-lizhijian@fujitsu.com>
In-Reply-To: <20240531062959.881772-1-lizhijian@fujitsu.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.52.1 (3.52.1-1.fc40) 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: MW4PR11MB7125:EE_|MW5PR11MB5764:EE_
x-ms-office365-filtering-correlation-id: 87d9bb93-4537-4ca1-2cbb-08dc81aca6e6
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230031|1800799015|366007|376005|38070700009;
x-microsoft-antispam-message-info: =?utf-8?B?SXNOL3pJNVZOKy9xN0JldmpCVnFwUEZCY0NXc2ZrL2g3TzJQU3liT0NuRmNm?=
 =?utf-8?B?cWhTUlNiSzFnWCsrRUFrNUVqa05iRGVGeXQ2bFU5U014UkFXUWlHNWZqdE9k?=
 =?utf-8?B?UXpVSU5NN1NFL09KbzQxdlROTGZHT3pFU1BBNFVxbkZTUHZiM0N3Ym02OHRl?=
 =?utf-8?B?Z0JUT0FNMDJvVm9OYUJ3eXl5d3h5eXNlTmxMR1ZVcncyOGZkRGFEcW84ZzV3?=
 =?utf-8?B?eWpuaVpCd2k5Q1lZd2cwalJTaXh4Vk9vaHdrb3I3OWxNY1NwRlRjSzcweFZ2?=
 =?utf-8?B?YytPelp3cWRJbnNRcGtMRHJvSG5uaS9OTTBmd1lDZkZNaXdNNndYTWVBMkU5?=
 =?utf-8?B?dDlUd1FnemZkdzhaSWd5SGw4RzhJcFBhZUNYdElncmZXUXhnTHBLNUZtcUYw?=
 =?utf-8?B?czBpR0RyQ0tXcUNGb1NNbU9YWnUvM01DSG1TaEhJWHVSOFcxNlpoZCtRdUx5?=
 =?utf-8?B?REdyOFZ6VVlvU2QvM0FxR2xyMlk0WXRueFFENS9ESytPeDhFSTVMTStFNFQx?=
 =?utf-8?B?RXptSDlERmkwR01xbGN4aXoreEFkSUdwSmxJUVZNblpqU2VzMFJTOGE3ZWVC?=
 =?utf-8?B?NGpGa1ZRejQ5MTFmR2oyUWZZTjZNcGVZYlV4dUdxQmoyb3J0Ny9NRllob2NX?=
 =?utf-8?B?VTNoZko1Z0puSWRiZ0VoUjBGbGFaM3VsTmQ0TkdpdUgyWDlncGZaYW1KTU45?=
 =?utf-8?B?MHozWDJtV0tjTFhTZ01iYThGbFZlaGtYTEZMYjFTa3J1emgwam1UWTV6ZFFa?=
 =?utf-8?B?UVhhT2FsNktwYmdSWFpZN3lNRjdDaGZha0l2R0pJMEQ3V2JlbzBzYzRuRXhr?=
 =?utf-8?B?NUxWTE1wbm5Xd3p5U0JwMHFpQllJWm1BeWdJL0sxMlFZd243Vk1ObDUwZTVB?=
 =?utf-8?B?TDlYOW5oUlVkdkV2dDRTUm03RFlSbmhtQzRjTjloTUFiNW0wRmpJL09CZHRK?=
 =?utf-8?B?V1hKcGxaZTN0UjBsZC9vMDkzeFExMG5nWS95UjQxdGFseTJaRWE2Z1N0YVUz?=
 =?utf-8?B?UVpENEFIYmFWQmc1REt1MmZzNmhUcG9FeGpFQVNtc2xTTlBubXNaWkIyY1Ex?=
 =?utf-8?B?Y0o2Q1RTdVg1bFNTK3pQV2dNbVJqWWRJd2FyT0dEVEtUWmFVMXBmSnZadVk3?=
 =?utf-8?B?TGYwRUlnSUNGMkNvV3I3UUFnYzlGUE5sbDhJdmdZa3MzMzNwZTVpUGxTV3Fa?=
 =?utf-8?B?RGdiMUdLNjI5ZmlqT0QwMFdpR2ZFVEFUN0plV0I4d0NEVWFGSng5WDRnMmJ0?=
 =?utf-8?B?Y1J2b29jUjBaS2JydmYvN3FnTENEMWMzUVkxaHhUWG9JbXJVOHZKWi9qK3Jx?=
 =?utf-8?B?SWVneFgrYU5Lb08zdDJZaTU1cGIzY3hUSlpicERkOTlXSVh0OXE3MUYwbWZl?=
 =?utf-8?B?d3E1L1F6dDZRanVzYWl0V0c0QWdZc0Y4N0J6dkdzTkd3RFJlWXhwbDIvbWhQ?=
 =?utf-8?B?VGdBL3pES0ZNbjdzQkxyQzdtK3FzRFBpZnNqaVM4MU14dFg1U21yWDJyVDZZ?=
 =?utf-8?B?RHBVZVJ2SmxPNlpoeFdjQmp6UFg4MGhyblJpR2pYR1IrdlNKRzVnY1pmcG1B?=
 =?utf-8?B?b2NPOTRnQUdvUkFhV3RQU1FQRjc3RU9IVmo0bzVYWHVZWlVOWnBmSDBoTHBo?=
 =?utf-8?B?SjN2bFVYMUs3VVlZelZobmIwY0ZaM3cvYW9na1pQTW1lU2cvZU13RkVJNG9B?=
 =?utf-8?B?aFRLVGNwbHcwalBsRWNHOFJ4Tkcwc3RxWUhvZWZBSkhENUNZbWQ4Zm5BPT0=?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MW4PR11MB7125.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(1800799015)(366007)(376005)(38070700009);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?eCtpc2R0cVZSYmk0NjF5UllRQmJjd3g2WTc3a1IzenNoejQ3RU5Pd3V1SkF6?=
 =?utf-8?B?T3BOaHBBOXoxZGVLK3Z0cE1td3JjYjgvZnlRbGk1ampPcWZLakJUaktTazdQ?=
 =?utf-8?B?cW9vZklBYk15bDNKUHZNN3VOc2lrVm1EZUprOEtWOFQrVk1uWFVqNnQxQWkr?=
 =?utf-8?B?SEt6c2pjRXB6QlVZWUN6dVVwOVg1ZVA2K2RjVTdoSmZsSUNGSWIzYm9IZnkx?=
 =?utf-8?B?RkRoMG5vZ2ZvdEI0MGJxeTlyRDNUWFlKa0w0SzlOSU5vWVd2Rm54bjZsaVFa?=
 =?utf-8?B?OUdQUEtHYnBJMGlJWGtNWGorMVovUEE5VFBCd1hGL1MyVDc2RlIrNjlUVTRa?=
 =?utf-8?B?c2dCeXo3N25sQmQ3M3B2NnhyOTQ1eUVhTUNLeFJhUzRCclcyL0c1aFRsdTF6?=
 =?utf-8?B?U3Q4WkNBTHJQaDZESlBWbkFwNHRDR0RQS2MzcXo4cGxCRG9PRXZIL011eHhQ?=
 =?utf-8?B?R2p0ZGdUWEpWYkxoYk1URCs1RWxyd1V1RmRCbi90V09GU2ROTG1rS1MvOGlX?=
 =?utf-8?B?b3lNMDZJelEyL2tUYStkUXJBWGl2ZlZsN3hBcEY2eENUNEszRUhiQy9NVXVo?=
 =?utf-8?B?TGE0ZFVlRm5ISXY4eHhiM1llTHJUNW1icnoyS3BiRmVVUjFGZlV4bm5zQTVt?=
 =?utf-8?B?Vld5bG5TUlNLRUw0QVIzQTR1QklVaGp0NWlIR29sK1ZHYzY5dHVtZDRQTWtK?=
 =?utf-8?B?VkFyWVB0VEkrUUlENjJjc0pzUzZYei93OHZaSXM0c3NXc3Y1dE15RWtHaTlO?=
 =?utf-8?B?QmhERWt5bjZia3lhYy9WcjlJM3hFcFRFaFEzUS9aaTd5SGRBRUpzTFZsMkpw?=
 =?utf-8?B?T3g5NU1WakFmWW84MkRoYkNBT2tiekY0M0Y2YmZXeitIbDRlQmRxSS9nL3hp?=
 =?utf-8?B?U3ZpSG53cDA0V3NBRTBsVWhzNUdMb1REekNTWmpRRm5iNm9uY1FVQW5UQ0lt?=
 =?utf-8?B?MnVpTmJmZzBncXlvMy9IZVl6MHBETE1VQ2pFVmtxeUFmQ1ZNTU1qYVJ5SFQ5?=
 =?utf-8?B?aGJ6TllTSk92d2hwMVNYMGpraXN3WUVmVlIvM2Ridm1GdzRseHozMzFwR2wx?=
 =?utf-8?B?a25lbzcxWUNLaU1HRjhYbXhXUTlFWk5uWHUydEh0UkhRbDMyNC9maDdjcisz?=
 =?utf-8?B?S1BkNXVKL0dHMXJraUdNR3JlU3FPSEI5RjFYQ2tVYlVPenR4L1lmMmlXRUwy?=
 =?utf-8?B?bnZaZmhFQlloRFkwOUFSbXFmVzYrcWp6YldndHpVMEg2RnFNZnAzUXFURndn?=
 =?utf-8?B?ODR3N0puTTdkZWVVVEJIdmpKNWl4YnRBTjNZZjZuTWg1RFJVb0xIWWpPcHJu?=
 =?utf-8?B?Y0VWSU1CYUQzODc0dzJCYzdjRS9UYkd2ZXE2bURpdjdSRmIrNFRrVzQ1eklE?=
 =?utf-8?B?aUpVdWUrM2xYbGlqanYvWlZUOGpoNDEyYUFUbnQ1QjU3YmFOTVhPTzRMcENP?=
 =?utf-8?B?RS9pR01NWWVBMXF0cXRXL1NJejR2WTc0M3dvbDI3NHIzNlFSTDBUYXRhZmNC?=
 =?utf-8?B?bnJNdkxDUllVaWxBMmczRXV2cVk4c3lRYkR2cmllUWY5VEJLNk84ckMrMmFz?=
 =?utf-8?B?c3JEREMwOVBVOEdBM0NiK0JKL2sxVXc4aUdieitGTjRWc01YWHkzOG0wNGkv?=
 =?utf-8?B?TGIwTjN3VnZZVVBTQWgzc1RESmw4MzdESzhiLzBkQWJJUnZmMUVJUjBIVGJQ?=
 =?utf-8?B?YUJVWGJRNnYwTTRHOHJEbnFlVEJmU2pmNDNBZnJzc2hXWnpyd0laT2Zza3Bo?=
 =?utf-8?B?NS9xREErQ1FJK3RDTUNveFZiWkdmaFdDTTcwbUlLcUpObTN2OWoxNzZjYzVX?=
 =?utf-8?B?WDVuTTJnbHVScXV2WVgwMUtYVG1VRWFVVDdNY3FqM1ZBdEE2WC9HZUxPUE81?=
 =?utf-8?B?dE82R1huUXF3R2hUTi9oMVgyN3VZa3YwU3lpUFZyM0hHYmx3ZjlMS2RmN2ZN?=
 =?utf-8?B?UWZVQjI1Z203NkpnWlc2dUdmK2h2d3ViaGxqMlJVZEY5UlNoZUdXSlA0MENH?=
 =?utf-8?B?Zmk4RVN5NjRtcmlzTThoYTNXbHBTMVVmZ2VoWDNOVHFxTHFwS3FraXU1b05h?=
 =?utf-8?B?bTQzc0FwcjAyUlFSZWtCZVBvc0RZVVZJaDgweS8zR0VlaWpiTld6azE0ZTRQ?=
 =?utf-8?B?WXkxOUROcU9kazVRMzFGWkh0Q1g4eE1oZmh2NWYyc1NrVXhtL0NnZVd0VDVp?=
 =?utf-8?B?cHc9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <F326E8405B163B47B65F84A2CD490C58@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MW4PR11MB7125.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 87d9bb93-4537-4ca1-2cbb-08dc81aca6e6
X-MS-Exchange-CrossTenant-originalarrivaltime: 31 May 2024 20:02:51.3852
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: QNYKuKgs5MmAOX30yIdNSyllJIBGt7TrDZwFZVuWH4yUER9GqObJxrOQEtHR5wPtIjxaQTfeVEJGLeYKGzd27NMVyIDb1rri9yhxInv3AM4=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW5PR11MB5764
X-OriginatorOrg: intel.com

T24gRnJpLCAyMDI0LTA1LTMxIGF0IDE0OjI5ICswODAwLCBMaSBaaGlqaWFuIHdyb3RlOg0KPiBQ
cmV2aW91c2x5LCB0aGUgZXh0cmEgcGFyYW1ldGVycyB3aWxsIGJlIGlnbm9yZWQgcXVpZXRseSwg
d2hpY2ggaXMgYSBiaXQNCj4gd2VpcmQgYW5kIGNvbmZ1c2luZy4NCj4gJCBkYXhjdGwgY3JlYXRl
LWRldmljZSByZWdpb24wDQo+IFsNCj4gwqAgew0KPiDCoMKgwqAgImNoYXJkZXYiOiJkYXgwLjEi
LA0KPiDCoMKgwqAgInNpemUiOjI2ODQzNTQ1NiwNCj4gwqDCoMKgICJ0YXJnZXRfbm9kZSI6MSwN
Cj4gwqDCoMKgICJhbGlnbiI6MjA5NzE1MiwNCj4gwqDCoMKgICJtb2RlIjoiZGV2ZGF4Ig0KPiDC
oCB9DQo+IF0NCj4gY3JlYXRlZCAxIGRldmljZQ0KPiANCj4gd2hlcmUgYWJvdmUgdXNlciB3b3Vs
ZCB3YW50IHRvIHNwZWNpZnkgJy1yIHJlZ2lvbjAnLg0KPiANCj4gQ2hlY2sgZXh0cmEgcGFyYW1l
dGVycyBzdGFydGluZyBmcm9tIGluZGV4IDAgdG8gZW5zdXJlIG5vIGV4dHJhIHBhcmFtZXRlcnMN
Cj4gYXJlIHNwZWNpZmllZCBmb3IgY3JlYXRlLWRldmljZS4NCj4gDQo+IENjOiBGYW4gTmkgPGZh
bi5uaUBzYW1zdW5nLmNvbT4NCj4gU2lnbmVkLW9mZi1ieTogTGkgWmhpamlhbiA8bGl6aGlqaWFu
QGZ1aml0c3UuY29tPg0KDQpSZXZpZXdlZC1ieTogVmlzaGFsIFZlcm1hIDx2aXNoYWwubC52ZXJt
YUBpbnRlbC5jb20+DQoNCj4gLS0tDQo+IFYyOg0KPiBSZW1vdmUgdGhlIGV4dGVybmFsIGxpbmtb
MF0gaW4gY2FzZSBpdCBnZXQgZGlzYXBwZWFyZWQgaW4gdGhlIGZ1dHVyZS4NCj4gWzBdIGh0dHBz
Oi8vZ2l0aHViLmNvbS9tb2tpbmcvbW9raW5nLmdpdGh1Yi5pby93aWtpL2N4bCVFMiU4MCU5MHRl
c3QlRTIlODAlOTB0b29sOi1BLXRvb2wtdG8tZWFzZS1DWEwtdGVzdC13aXRoLVFFTVUtc2V0dXAl
RTIlODAlOTAlRTIlODAlOTBVc2luZy1EQ0QtdGVzdC1hcy1hbi1leGFtcGxlI2NvbnZlcnQtZGNk
LW1lbW9yeS10by1zeXN0ZW0tcmFtDQo+IC0tLQ0KPiDCoGRheGN0bC9kZXZpY2UuYyB8IDUgKysr
LS0NCj4gwqAxIGZpbGUgY2hhbmdlZCwgMyBpbnNlcnRpb25zKCspLCAyIGRlbGV0aW9ucygtKQ0K
PiANCj4gZGlmZiAtLWdpdCBhL2RheGN0bC9kZXZpY2UuYyBiL2RheGN0bC9kZXZpY2UuYw0KPiBp
bmRleCA4MzkxMzQzMDE0MDkuLmZmYWJkNmNmNTcwNyAxMDA2NDQNCj4gLS0tIGEvZGF4Y3RsL2Rl
dmljZS5jDQo+ICsrKyBiL2RheGN0bC9kZXZpY2UuYw0KPiBAQCAtMzYzLDcgKzM2Myw4IEBAIHN0
YXRpYyBjb25zdCBjaGFyICpwYXJzZV9kZXZpY2Vfb3B0aW9ucyhpbnQgYXJnYywgY29uc3QgY2hh
ciAqKmFyZ3YsDQo+IMKgCQlOVUxMDQo+IMKgCX07DQo+IMKgCXVuc2lnbmVkIGxvbmcgbG9uZyB1
bml0cyA9IDE7DQo+IC0JaW50IGksIHJjID0gMDsNCj4gKwlpbnQgcmMgPSAwOw0KPiArCWludCBp
ID0gYWN0aW9uID09IEFDVElPTl9DUkVBVEUgPyAwIDogMTsNCj4gwqAJY2hhciAqZGV2aWNlID0g
TlVMTDsNCj4gwqANCj4gwqAJYXJnYyA9IHBhcnNlX29wdGlvbnMoYXJnYywgYXJndiwgb3B0aW9u
cywgdSwgMCk7DQo+IEBAIC00MDIsNyArNDAzLDcgQEAgc3RhdGljIGNvbnN0IGNoYXIgKnBhcnNl
X2RldmljZV9vcHRpb25zKGludCBhcmdjLCBjb25zdCBjaGFyICoqYXJndiwNCj4gwqAJCQlhY3Rp
b25fc3RyaW5nKTsNCj4gwqAJCXJjID0gLUVJTlZBTDsNCj4gwqAJfQ0KPiAtCWZvciAoaSA9IDE7
IGkgPCBhcmdjOyBpKyspIHsNCj4gKwlmb3IgKDsgaSA8IGFyZ2M7IGkrKykgew0KPiDCoAkJZnBy
aW50ZihzdGRlcnIsICJ1bmtub3duIGV4dHJhIHBhcmFtZXRlciBcIiVzXCJcbiIsIGFyZ3ZbaV0p
Ow0KPiDCoAkJcmMgPSAtRUlOVkFMOw0KPiDCoAl9DQoNCg==
