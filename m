Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A9B9F14D2A8
	for <nvdimm@lists.linux.dev>; Wed, 21 Aug 2024 21:50:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.12
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724277046; cv=fail; b=o+G5pHVbt1jxn/2GGgOhZ4ZOusMcYMgTmVuc9kHPqjjHKIL2CxQ9gb0iFb7iBT5tZ2PEzryRrpvSrQeh9O7MTEgceQmcO77mA06d2E65HGctlv22UO1vEFYEzcRx/MOf2jF/i2e56IVd+UKholvhgte091SgCY9IMiKQ7HdQD2M=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724277046; c=relaxed/simple;
	bh=slGy1UNoz8bLw9WX2ifJ8gIX9LFBlm5eqOgKzltYBso=;
	h=From:To:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=NJtvDrB/DTpE85Xl7MZ1qkooZMHaqX3B4emU7P/pVahFs4T1VZdYih7yezclD/D3MBpeGapAVxTRlvwZPztv/wUYxy51mP1KMxK5+786CWrPtuOme/MFOyMczeAu1K/y91K3rLzFA84L/ZmK3k7cJiPky3f4K8P8REK0Z1gjOXk=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=EotspgVB; arc=fail smtp.client-ip=192.198.163.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="EotspgVB"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1724277045; x=1755813045;
  h=from:to:subject:date:message-id:references:in-reply-to:
   content-id:content-transfer-encoding:mime-version;
  bh=slGy1UNoz8bLw9WX2ifJ8gIX9LFBlm5eqOgKzltYBso=;
  b=EotspgVBZVG8sFe9gIgVqodvVQqr4F5R41Ui+QupkEg3ukj30ApRwTv6
   DdVWfKxPyLlkd4TwYgv8mVHFUUjLqFvwbKDLbsysNNB8coA2tOVykmCPK
   zb+ANA+MW2cIM6SWY4+cl9Ju89W5u6rkX1YEiYskV6EEWn+ckQha08SB7
   3CqJerJSR46f/DQ0ssdvIm704SLATjgdYN94KXGPoxaPSiF9H1SldVHo9
   VoU6MYJM8a5Xwae68k7wRvGEeUkOvb+WNC/Az6mEqEQlAxMyuyQjtf5gC
   WCh/BRGsTlhot6k3UpVXzph8bjQJKdjJrdK65Kgof6fuzyX3552X+/qy1
   A==;
X-CSE-ConnectionGUID: g9quRh0BSdmFliPqLY0SIQ==
X-CSE-MsgGUID: 0R/rRfA5Qwu3x5kDDxDrGg==
X-IronPort-AV: E=McAfee;i="6700,10204,11171"; a="26530134"
X-IronPort-AV: E=Sophos;i="6.10,165,1719903600"; 
   d="scan'208";a="26530134"
Received: from fmviesa009.fm.intel.com ([10.60.135.149])
  by fmvoesa106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Aug 2024 14:50:36 -0700
X-CSE-ConnectionGUID: WS7ThTtjTcW/Vw2sI4t9ag==
X-CSE-MsgGUID: WTwi/lRwTDaJMJ+djTSk1w==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.10,165,1719903600"; 
   d="scan'208";a="61252407"
Received: from fmsmsx603.amr.corp.intel.com ([10.18.126.83])
  by fmviesa009.fm.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 21 Aug 2024 14:50:36 -0700
Received: from fmsmsx602.amr.corp.intel.com (10.18.126.82) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Wed, 21 Aug 2024 14:50:35 -0700
Received: from fmsedg601.ED.cps.intel.com (10.1.192.135) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39 via Frontend Transport; Wed, 21 Aug 2024 14:50:35 -0700
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (104.47.58.176)
 by edgegateway.intel.com (192.55.55.70) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.39; Wed, 21 Aug 2024 14:50:35 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=ER0MxXtAzngxhObEjBHnn6/siVmPhptYGuIVbrENbKzn1yuS/vt+JK9HZC98oIZ3JZdW2aA0KO5gsjEE1bwjSstLKldTrtBLgnpPVUUGAUocyMO7gqhdkCOj7JDyhfrk6lNyvcxNfvdN2pJct0zqPTJtw+hNdm0s66vgB8EzmLAAM1Gcb9uIyr8RTAbuFvEiOoTBP9b+V5gtCsqK5EepZy0q4dFomsmELzzfMPxbQTHi4fW80rFpgFubD0Ime8CfvDQMOUzdUM5uLJmNm+QVD639zdc5JupU0L3wfD8ZmV5RVlIsxBY/wU22WXXJtamsWcOdM+7BYRcwKyS5zpRoyQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=slGy1UNoz8bLw9WX2ifJ8gIX9LFBlm5eqOgKzltYBso=;
 b=ovJipcfCOdzIROxPzmRJOEXuU21zwrzZNyuWGTSK3Jzq6sFFP9Ng6mvNFQWyhVxPdal7w2Lbqt7HBG4RJMZe/eZNmOHjDhv/e+bUW3eV7Uz1QHnOGJGVwAiNhWAbF7qd2JzHRLOBlRLuYqoJwfRcbg60aJI/VPCfHlqlUou6FUZIhNDffyl4qKbMQYjcQsB9Ew7Umj4lknckokL9wJEBIB6XWMCa6tuYyukv1trbjz0MRM9SfCU39HRKVpou0ruFln0RyPg3FkBqOpORdfM8wrHhuXo/u+dPnt10DbA3z8Wbo+EAaBL6imvfV/XtXchG9OWZSDhqG7et7lMwZgfhyg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from MW4PR11MB7125.namprd11.prod.outlook.com (2603:10b6:303:219::12)
 by DS7PR11MB6150.namprd11.prod.outlook.com (2603:10b6:8:9d::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7828.33; Wed, 21 Aug
 2024 21:50:32 +0000
Received: from MW4PR11MB7125.namprd11.prod.outlook.com
 ([fe80::eff6:f7ef:65cd:8684]) by MW4PR11MB7125.namprd11.prod.outlook.com
 ([fe80::eff6:f7ef:65cd:8684%6]) with mapi id 15.20.7897.014; Wed, 21 Aug 2024
 21:50:32 +0000
From: "Verma, Vishal L" <vishal.l.verma@intel.com>
To: "jmoyer@redhat.com" <jmoyer@redhat.com>, "nvdimm@lists.linux.dev"
	<nvdimm@lists.linux.dev>
Subject: Re: [PATCH ndctl 2/2] libndctl.c: major and minor numbers are
 unsigned
Thread-Topic: [PATCH ndctl 2/2] libndctl.c: major and minor numbers are
 unsigned
Thread-Index: AQHa8y6fvSZk1FmCNEyYy84/H0BSk7IyQeuA
Date: Wed, 21 Aug 2024 21:50:32 +0000
Message-ID: <9bafcedf6ee73c461c8a314193928a9a032e34a4.camel@intel.com>
References: <20240820182705.139842-1-jmoyer@redhat.com>
	 <20240820182705.139842-3-jmoyer@redhat.com>
In-Reply-To: <20240820182705.139842-3-jmoyer@redhat.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.52.4 (3.52.4-1.fc40) 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: MW4PR11MB7125:EE_|DS7PR11MB6150:EE_
x-ms-office365-filtering-correlation-id: 42a46eca-3665-413e-c4ec-08dcc22b481e
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|1800799024|376014|366016|38070700018;
x-microsoft-antispam-message-info: =?utf-8?B?MjlRT2o3R1EyVVRsbkNUWXRsTG13alFrK0V4R2lEQXBOeTNBaTBCcGtpeEpj?=
 =?utf-8?B?REYxU0VJeEgyUjZBUkdTZDlVM043MEsySmJ4ejFFRTZ6bDA1NkNPNUJUN0tR?=
 =?utf-8?B?bUsybGk5bVVCUjJuQ2lTWFg1NWNWb1Buc3VFR0VQUmcwMGIzK2lpZjJaNVpW?=
 =?utf-8?B?Z0dseHU4UkN6UHVvcEJnR1VYZkFzbVNFUEVveWVTanZncjZlRnIvKzQxeTgz?=
 =?utf-8?B?d1o5UmJlM2FWdFY1YitxN0xyZU85NUlPcDltK1dhODVlWmFnUmlwWUdHKzBK?=
 =?utf-8?B?Q0JkZk5Qc2l1MkUyU0VVRk1wRHZ5ZVMxSE5tOU8xeEVTQU01VUxDNmU0a1NQ?=
 =?utf-8?B?N2ladmM4UDZsQnBQUk90c1dOWlJUY04wclJxbzhWSVBENC9Bd0FzazNPSG8w?=
 =?utf-8?B?aXF1SFlqYWUwVU9MZXFxNkR2QVh4NXJlR2ZqMGpBQVFsc3dqcWtCSDNIdUJ0?=
 =?utf-8?B?bzdUdHNEWFdnYnlBeE1vZEI1Znk3RVI0NUNsVXB4T2RKNjNuUjdQTHV5bEcw?=
 =?utf-8?B?eHVHK0Urbkp5ZFpQS2ZWN25NNS9RaFJhREw4TWE4RW43WjQxVHA3TWovU3ZQ?=
 =?utf-8?B?WnBCVUdTOTFpQlF5WElCc0dNY3p3K1lrSjM1MWtJNUpmU0djcm1UMSsxWStW?=
 =?utf-8?B?bWtEK1I2OTVpa2pPRWt4S3Y2d3hyaC9nM1dkTFJKZGpjNzMzeWU0OXBrZCtv?=
 =?utf-8?B?ckpteXlqdzRNM1JWSytlelJ0ZzU5NlRSNW1HcXJyM2JQTGFyZ0xsSldKajB3?=
 =?utf-8?B?TE90VDZNdkt2WnplMFE0ZEZEeHZTR0F2OVY0eW5nTGRrQXozc2JHM3ZNRUQ4?=
 =?utf-8?B?d2lPSUNyd0Vpb29hd0NqMW5GUUlhK1dsekE2dVZrSHN0TUo1a3VMVUIxbjN6?=
 =?utf-8?B?Tm9xVUFod2UxRXQrTG1oV29XTmM4QW56SHNwajY2SHZQSEp4QUNQQ2tPSGFD?=
 =?utf-8?B?V0VuNHBmNFl1SEIrOEM4UEJFRjNpNWZyaHoraCtYZjl2dEFkYlJkMXhETnN5?=
 =?utf-8?B?VlR4YXViaXlLeXprWWlFbENiUWQxK3pxMUhxU1dndDd5SUtoNUZzNzhNK25M?=
 =?utf-8?B?YWVIMGNQb2pROVQ1ZVhRSGd6QmFmdERKajJWU2g5QnY2bnN5RE80eEp5eE52?=
 =?utf-8?B?cmNTNWZDSm9WVGlLOFl0SS9UemowSW1Ma3lRUitnb3ZDLytjMkRCQnM0ZXZU?=
 =?utf-8?B?K3d2ZHJRZksxTU95cFMyL3hFN0lmOVhHeGRMZmFsWlhQT29FeU5RVkVCTmxK?=
 =?utf-8?B?cWZGWDVsSFcwajRrQUY1NTlSTUZZOVFFTmNGM0diMU5nS1BWQXZteE9XS29t?=
 =?utf-8?B?cU1RaUUzZGQ5cS82N0Q1QjJGR3ZGWFNvSWFJUDJhK3p6QmhCaXBoNCs2QTZ0?=
 =?utf-8?B?WVkxUVZaYmNzSkI3QUM4T3pmK3JrMERCNDZqb0M2aFNFYkNJRHZWTEZwa2JG?=
 =?utf-8?B?cUxCWUZnc25JNE9aeThMdVMzOEFNOWpHZGErbzMxMGllNjlQKzZkeStoekEz?=
 =?utf-8?B?MEpEOG1nVjBScEpvd2xlbFpQL2lqU0tmc2VhSUU2WkJFVWFJbVBKUzI0bjRS?=
 =?utf-8?B?WUdKVS9FUllRQ1l6T3BuSExoYTladFg2dnRHMnpnN0NvZmkwQnYxYTJ4UXRQ?=
 =?utf-8?B?OWN6MTI0UFJvbzBaUnVZRFJ4NWlMNUNzbFBZWlMwMlZQVjRSalZmSDBtVnR4?=
 =?utf-8?B?UFB0cFpnYlR2dzlCYndHQU5iRWlBYnRxUnlJbEZtWEZVYlEzZ3pYNm8xcEtu?=
 =?utf-8?B?MjB3eHYwL2NKZVA0WC9IWjNJc1M1OWgwd0ErRWFUcmh4RUp2QVUvbzJvUG1O?=
 =?utf-8?B?U2RjOFhReG5Dd3N0Z2M1K1FLTWdIbWVGZmxVWmh6aTJKS1RaamJYWDNqcjlI?=
 =?utf-8?B?TWtpQ2ZsRzJJTHBmSHFrQnVlMHc0UmFsMWVrSmZMV0FiNVE9PQ==?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MW4PR11MB7125.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(366016)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?R1d5S1dtS1VNcHp1cVVwZkwwam5GaGhzSUFzWVhtVUthOTAzOVhweExCRkxJ?=
 =?utf-8?B?Mm5ZblpOazR3dVp5aXdXbFVLUGI4MERNQ0F4TzA0UVhJWWZoWWIzbVVtTnJW?=
 =?utf-8?B?Z2ZIZmR0ZTZlWGVVejR0aDhtOGdIMmxaNjhUZG9zQVhUb1Y4emhFYlljcllo?=
 =?utf-8?B?V1hTOHRzdjFQcE1OV0J0L3ZBTTlPZTM0alE0NUlHWXNrLzZFTklwclJ2cG42?=
 =?utf-8?B?eTM5SVVWNzFHWW82NVA5eUNwRmRMRnpCbHorTHhtb0syU0lhZkxFWm9XMmk0?=
 =?utf-8?B?bHpFR045by9EYjMyV2xzQlJ4bkFxVHp5NnJNNy8yNVl5Ym5oRFEra21NWUtJ?=
 =?utf-8?B?OVQvbkptY2JYRVU3VXQxMDFjQW9GZG5MOXZSMHVwM1BvazhacUQrUXFjU3Z2?=
 =?utf-8?B?UEhYWmtxTE5ZZ2diSk9TS1VKWnJxTWhtTjVUTEtrR2xzcTVYcmtTVGdxYTdr?=
 =?utf-8?B?V0wxSG5yaDFRZyt4YklxdysyQzV4bVE1ZHpuL0ZvVEZQUGQ3ai9EN1hCYVc1?=
 =?utf-8?B?b3dXbTdsbWZXbmxrWGJzVFpqL1pqdHZSWFFPMW1DOVphWFBja2ZLMFpIeGgy?=
 =?utf-8?B?NFQzMnhxYWZTc0JXSTdvWmw3a21NUUhwaHpSc1BXeUpwREhwSUdZOVRiR3dP?=
 =?utf-8?B?RDg2cVB1Y0dyRVdiZW5Wb3BXRU1vaFM3Unk2MHN0UDRZTkNUTHFJbXVKVzhi?=
 =?utf-8?B?Q3NHMzNTZERtci9nUE9LZnNDNnRhLzZaTzYrN2FST2ZwVmZxb0VUS1hCY2N0?=
 =?utf-8?B?K3EyZlhHS0RWdk82UHFMOUx2MXV1aE5iTnlEcGkreDFSYXZncEtrWk42TjlI?=
 =?utf-8?B?emY3WktYUFE0dWpsZHZzNUtUR2kxMUNzbXM4TVEwVFZwOUQvektRR00yVVJB?=
 =?utf-8?B?bWdJWElJR1AzdzV4aEJFMnNXdDhvN1l6djJNWEdqaTZFR1RaSGpYc21XeHFD?=
 =?utf-8?B?R0xvdmNWVGtBZkFuRzVqdWFuZ0EvK0FWcVVIdmkxa1R0OThpMVR1U2JDWXlZ?=
 =?utf-8?B?ejZaRW1XQVRuOFdkelJETW5VUC9GdWpkL0UrUGIxamhNclV0STNIMms5Z0Zx?=
 =?utf-8?B?SGVsSlQvOWh0bHMrdFBCcndXUG04bzFTc2YwSVFEUjlITFY4d1FYcXJkcFdK?=
 =?utf-8?B?b1FzMnMrMXJiTXF3REFqWmlLQXhudDh6ZFN2Tnh3eUh2LzJQUGVjNlVNZkxo?=
 =?utf-8?B?Skd6M1RuWGRGa2FkbHF2ZFBUb1hGTnEwZkhjd1F4bDJPTFFCSjl4N0pKWGYz?=
 =?utf-8?B?akErV0pZdVpaWGdoRGZTZjVzZkJwL014SmsraEZMT0I1MC9zTDNtb3pxcW5w?=
 =?utf-8?B?Ym8wam5TOFRiNXNrNTM1VlVlbnRXc1cybzJUdXRGWElacXd1UE5aTmEzZFd4?=
 =?utf-8?B?MlJwbWx5Z0ovT2czMjFLSExDZmppSHc3SVpFUys0VWZuTFBsekl2V3FmTVpJ?=
 =?utf-8?B?VWMzZ2U5NWZVR2ExNnovdGN6TmZLYkh0T0EwUWVjNFFLOEFZY3I1UTE4V2ZS?=
 =?utf-8?B?MUJCTVNWY2MwcHRDbXlIUnVHSi9Ya2JrNnJMTnpJcDFZVjFCL1ViY1pCNlNo?=
 =?utf-8?B?dUJrN05FUUlxZUx5OXpyalNZckdaUVJLWFJ4SE1FakplMmdYblhMYWJOMFNs?=
 =?utf-8?B?T0FGTGFXSEM0ZlpRS1pxVTZqSklKamdyalVTK0dXVWVMYzVmVWpwZUZoZGhQ?=
 =?utf-8?B?ZTMwbnNWNGxRdFRBZ2hZOWtpMmEyVStJdnFrUlJLem5QcFZqenpEZk1hY0gw?=
 =?utf-8?B?QnN6NlNOUVpsb1h6Q3ZUU2hLOStLdWVFMUFEZHdiZUV6aXBZMkhGaE5JeG5j?=
 =?utf-8?B?RUcwdFErNEZZeEpGWmRNTEgydjVJaFNlNno0RlpsTVJwT01JZ1RPUG40Wm9H?=
 =?utf-8?B?L3lvODd0OTRmMFA0TnNsV09INTR2Mi9JNUljbVRydUlBZ1h4VWo3Vk9SczR1?=
 =?utf-8?B?cE9jZkFQakRHN0VYZTF1OVA1eUQ1ejM0WWR0dXN4Nmp6WVBQRFc2TFRHeWxL?=
 =?utf-8?B?ZG1TWlFjUG9xWDNDK3dMT0h6M2ZJRUV4R2tySHIzdWhMZkJXOEp5K2p1c1M5?=
 =?utf-8?B?SEo4dmc5SVBLb1grbW1Oc3V3YmJ1Ni9ZWWVLWE11cU0xNTN3ZUQrRGJ4Z1Bh?=
 =?utf-8?B?Y1h0NDVZcjRPb0Q2VnRQa00wTHJYelZLbE4zbm0vZ2szUHo3MGl0dytNQzU1?=
 =?utf-8?B?OXc9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <4E88AC22E11D0E48B562B24CCD9BA9EE@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MW4PR11MB7125.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 42a46eca-3665-413e-c4ec-08dcc22b481e
X-MS-Exchange-CrossTenant-originalarrivaltime: 21 Aug 2024 21:50:32.8791
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: CkbXf2XvK8KP261+hY0hwVC5DXkNtWbzcj18UUbydKW9k1IxbiUwJhet6YLIRe8DUIgqX5CPj8dHjROsjSeoFX301gLWktOWZ5M34Dlam3M=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR11MB6150
X-OriginatorOrg: intel.com

T24gVHVlLCAyMDI0LTA4LTIwIGF0IDE0OjI2IC0wNDAwLCBqbW95ZXJAcmVkaGF0LmNvbSB3cm90
ZToNCj4gRnJvbTogSmVmZiBNb3llciA8am1veWVyQHJlZGhhdC5jb20+DQo+IA0KPiBTdGF0aWMg
YW5hbHlzaXMgcG9pbnRzIG91dCB0aGF0IHRoZSBjYXN0IG9mIGJ1cy0+bWFqb3IgYW5kIGJ1cy0+
bWlub3INCj4gdG8gYSBzaWduZWQgdHlwZSBpbiB0aGUgY2FsbCB0byBwYXJlbnRfZGV2X3BhdGgg
Y291bGQgcmVzdWx0IGluIGENCj4gbmVnYXRpdmUgbnVtYmVyLsKgIEkgc2luY2VyZWx5IGRvdWJ0
IHdlJ2xsIHNlZSBtYWpvciBhbmQgbWlub3IgbnVtYmVycw0KPiB0aGF0IGxhcmdlLCBidXQgbGV0
J3MgZml4IGl0Lg0KPiANCj4gU2lnbmVkLW9mZi1ieTogSmVmZiBNb3llciA8am1veWVyQHJlZGhh
dC5jb20+DQoNCkxvb2tzIGdvb2QsDQpSZXZpZXdlZC1ieTogVmlzaGFsIFZlcm1hIDx2aXNoYWwu
bC52ZXJtYUBpbnRlbC5jb20+DQoNCj4gLS0tDQo+IMKgbmRjdGwvbGliL2xpYm5kY3RsLmMgfCA3
ICsrKystLS0NCj4gwqAxIGZpbGUgY2hhbmdlZCwgNCBpbnNlcnRpb25zKCspLCAzIGRlbGV0aW9u
cygtKQ0KPiANCj4gZGlmZiAtLWdpdCBhL25kY3RsL2xpYi9saWJuZGN0bC5jIGIvbmRjdGwvbGli
L2xpYm5kY3RsLmMNCj4gaW5kZXggZGRiZGQ5YS4uZjc1ZGJkNCAxMDA2NDQNCj4gLS0tIGEvbmRj
dGwvbGliL2xpYm5kY3RsLmMNCj4gKysrIGIvbmRjdGwvbGliL2xpYm5kY3RsLmMNCj4gQEAgLTcx
MCwxMSArNzEwLDEyIEBAIE5EQ1RMX0VYUE9SVCB2b2lkIG5kY3RsX3NldF9sb2dfcHJpb3JpdHko
c3RydWN0DQo+IG5kY3RsX2N0eCAqY3R4LCBpbnQgcHJpb3JpdHkpDQo+IMKgCWRheGN0bF9zZXRf
bG9nX3ByaW9yaXR5KGN0eC0+ZGF4Y3RsX2N0eCwgcHJpb3JpdHkpOw0KPiDCoH0NCj4gwqANCj4g
LXN0YXRpYyBjaGFyICpfX2Rldl9wYXRoKGNoYXIgKnR5cGUsIGludCBtYWpvciwgaW50IG1pbm9y
LCBpbnQNCj4gcGFyZW50KQ0KPiArc3RhdGljIGNoYXIgKl9fZGV2X3BhdGgoY2hhciAqdHlwZSwg
dW5zaWduZWQgaW50IG1ham9yLCB1bnNpZ25lZCBpbnQNCj4gbWlub3IsDQo+ICsJCQlpbnQgcGFy
ZW50KQ0KPiDCoHsNCj4gwqAJY2hhciAqcGF0aCwgKmRldl9wYXRoOw0KPiDCoA0KPiAtCWlmIChh
c3ByaW50ZigmcGF0aCwgIi9zeXMvZGV2LyVzLyVkOiVkJXMiLCB0eXBlLCBtYWpvciwNCj4gbWlu
b3IsDQo+ICsJaWYgKGFzcHJpbnRmKCZwYXRoLCAiL3N5cy9kZXYvJXMvJXU6JXUlcyIsIHR5cGUs
IG1ham9yLA0KPiBtaW5vciwNCj4gwqAJCQkJcGFyZW50ID8gIi9kZXZpY2UiIDogIiIpIDwgMCkN
Cj4gwqAJCXJldHVybiBOVUxMOw0KPiDCoA0KPiBAQCAtNzIzLDcgKzcyNCw3IEBAIHN0YXRpYyBj
aGFyICpfX2Rldl9wYXRoKGNoYXIgKnR5cGUsIGludCBtYWpvciwNCj4gaW50IG1pbm9yLCBpbnQg
cGFyZW50KQ0KPiDCoAlyZXR1cm4gZGV2X3BhdGg7DQo+IMKgfQ0KPiDCoA0KPiAtc3RhdGljIGNo
YXIgKnBhcmVudF9kZXZfcGF0aChjaGFyICp0eXBlLCBpbnQgbWFqb3IsIGludCBtaW5vcikNCj4g
K3N0YXRpYyBjaGFyICpwYXJlbnRfZGV2X3BhdGgoY2hhciAqdHlwZSwgdW5zaWduZWQgaW50IG1h
am9yLA0KPiB1bnNpZ25lZCBpbnQgbWlub3IpDQo+IMKgew0KPiDCoMKgwqDCoMKgwqDCoMKgIHJl
dHVybiBfX2Rldl9wYXRoKHR5cGUsIG1ham9yLCBtaW5vciwgMSk7DQo+IMKgfQ0KDQo=
