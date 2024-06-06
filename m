Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2076.outbound.protection.outlook.com [40.107.94.76])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 32D3938D;
	Thu,  6 Jun 2024 00:12:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.94.76
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717632762; cv=fail; b=Qe/jpkGRsVRAGuatZa8JubchXXkcAVDViMb0zGJ3ykia/CD9/8CTKqBjVANNfJbf5Ag2Nwe0tVrJriKSjCAuFnek32rpeJgGqoj7405Fdk3JrAYL9nr8hR3VEbwGO6qoQs7mPJIYN7VwjiYUgHKGIr9KUr66dHtRB+FNlahRoX4=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717632762; c=relaxed/simple;
	bh=UlcrWK5sP8rtVB1IbCP/7P7ZfK5yCHsphHwbC60YNq8=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=mWKRL+hcPQjugqEmANLD7cdVQS7zPC3wMvWilMDBGOXysXHQww8Prxhouf39I62dxKXQoAr1yPTx+zf1ZfGJ++38bmUcOtuea76DCmgZ6IhAP/LaI/jvyXbRNQyW/kJFFa/vSvhM0k5UVa7Udti7nHdV1WPaBWh21S9SUstF7fI=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=mkDGDxae; arc=fail smtp.client-ip=40.107.94.76
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="mkDGDxae"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=L1focvksl0TASo6nLGx2feZuWNhbAaB/qdfUc9Tu/O1oYAREesIC3rYkd/m6E91KGWe/oA1FFPruRF4MpLemEYXpNE7DMyx1cqpb5WvWpt8CCeos8OuwKiy/VZHUKH5XHJivJu6VJW3WLbkoVMXiYKvcu7W8FuG4ivrQ6Ixtt1RAMBqW+e3JRo4w/ymaWUZZ68QwiDuKirlefaUngbX6If4GybMjMcSgbMst0w8T8suCf0u11iRRflWwxtYQhaVVt3aRGx5piwIAoL1i4E4U3Wk2uJ3Y3m6PQWP/YtquqTIjUJ0oxo47gIIyTfTCkCOiQt/MgBT4NLT4TpmKiwrWLQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=UlcrWK5sP8rtVB1IbCP/7P7ZfK5yCHsphHwbC60YNq8=;
 b=YLO5Q57sQKMHSrltHzLqrv3Yudwm93FaO1L+cWIM7IO6sTqZzZ0isnO6cG9cqMqIYuUUVnWMATm30RpbQEPbSaq1i6IFLQ72gu8WAhMZ3M4l50gbmALgHR+XmsWr1qAob/xQs7XCaSfbnpf3QdMX3CL6fpeBXqC/ahNuspkEVh5jzOq0fdZajiMt2w7tPhOiNfbRkp9iVqqemD5dxbEgqsOQ18BcOiW9HK3JrhotafC1fnKA646Nocln/DpRaR9+zT6DzjxzgxKlMt7cLrLWO1Zsr0FI/R6fIGjGseN+xAwc1AP0eCXHIBOxyeJ7TgxOfpY4kcyaAzvjBpPejLHGaw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=UlcrWK5sP8rtVB1IbCP/7P7ZfK5yCHsphHwbC60YNq8=;
 b=mkDGDxaegevLC5WZcxqd5ah7zjr6PaNT7R/6ehn+D9hq/V4teYmcK89BOWKm+bPW1ab/QxXuQZQDW+SZ3GUtSa3AR1EP97C8iuFDh/qR05pMBbC1G8uZBlt9IGdhLQ5jDdyxPC1+zaSHR4TMKsG9fvoBXBg1CQwnpPiV95C5uS34dQGqCRY4PxuC8QibwzuJ+SNaPioXaMmneyt8HaWDfpNUQyIYiaIUp4/0tils3MP7VB66jBXtkxPXpxR3N9RCzVqQmP0CMqtaP1dXShDy3Srid5z9oDy+1JIF/ZRpnO66i+q4BA4XzQELj2cUjO5UCyiTDDi0ZRE+K9OOU6VQXg==
Received: from LV3PR12MB9404.namprd12.prod.outlook.com (2603:10b6:408:219::9)
 by LV8PR12MB9450.namprd12.prod.outlook.com (2603:10b6:408:202::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7633.32; Thu, 6 Jun
 2024 00:12:37 +0000
Received: from LV3PR12MB9404.namprd12.prod.outlook.com
 ([fe80::57ac:82e6:1ec5:f40b]) by LV3PR12MB9404.namprd12.prod.outlook.com
 ([fe80::57ac:82e6:1ec5:f40b%5]) with mapi id 15.20.7633.021; Thu, 6 Jun 2024
 00:12:37 +0000
From: Chaitanya Kulkarni <chaitanyak@nvidia.com>
To: Christoph Hellwig <hch@lst.de>, Jens Axboe <axboe@kernel.dk>, "Martin K.
 Petersen" <martin.petersen@oracle.com>
CC: Mike Snitzer <snitzer@kernel.org>, Mikulas Patocka <mpatocka@redhat.com>,
	Song Liu <song@kernel.org>, Yu Kuai <yukuai3@huawei.com>, Dan Williams
	<dan.j.williams@intel.com>, Vishal Verma <vishal.l.verma@intel.com>, Dave
 Jiang <dave.jiang@intel.com>, Ira Weiny <ira.weiny@intel.com>, Keith Busch
	<kbusch@kernel.org>, Sagi Grimberg <sagi@grimberg.me>, Chaitanya Kulkarni
	<chaitanyak@nvidia.com>, "linux-block@vger.kernel.org"
	<linux-block@vger.kernel.org>, "dm-devel@lists.linux.dev"
	<dm-devel@lists.linux.dev>, "linux-raid@vger.kernel.org"
	<linux-raid@vger.kernel.org>, "nvdimm@lists.linux.dev"
	<nvdimm@lists.linux.dev>, "linux-nvme@lists.infradead.org"
	<linux-nvme@lists.infradead.org>, "linux-scsi@vger.kernel.org"
	<linux-scsi@vger.kernel.org>
Subject: Re: [PATCH 01/12] dm-integrity: use the nop integrity profile
Thread-Topic: [PATCH 01/12] dm-integrity: use the nop integrity profile
Thread-Index: AQHatxHnqHGeTGISlEKSH91uQHyuYrG53lWA
Date: Thu, 6 Jun 2024 00:12:37 +0000
Message-ID: <00f768d5-a41d-4130-86a7-00925c7f1b4f@nvidia.com>
References: <20240605063031.3286655-1-hch@lst.de>
 <20240605063031.3286655-2-hch@lst.de>
In-Reply-To: <20240605063031.3286655-2-hch@lst.de>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Mozilla Thunderbird
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: LV3PR12MB9404:EE_|LV8PR12MB9450:EE_
x-ms-office365-filtering-correlation-id: a1640798-4f62-42ee-e6e4-08dc85bd5f90
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam:
 BCL:0;ARA:13230031|1800799015|366007|7416005|376005|38070700009;
x-microsoft-antispam-message-info:
 =?utf-8?B?UVF0a0FxOVA5bjArYnNtNVozRENLMjQ5RnM2OUQrTFIzdGVJTGJ2Q1JTbEQz?=
 =?utf-8?B?eFlXdUNaV3hoaUsxQnJVbEpzNUtrZTkweXU0dXBobTRLZGpBVXpFcmJvR0th?=
 =?utf-8?B?YjdwQVp1Wjh0djB1U3ZWRzcrSzFDdkQvbEVFeU9LMnBPS1VEL0Fla09Wdm4r?=
 =?utf-8?B?RVBvUFBTQjJKMHJOZmJoOHF0K002ci83N2pHa2xvM3hYZUFUY0lDMHlCdmU0?=
 =?utf-8?B?SVRIYUFIQVptMFltOHMxcEFwbmNXcHNyQUZUSVVZazVIMityUTdYSjFGYXhu?=
 =?utf-8?B?ZlFMQmIwcERnQzFlaTQydWRGRS9yZFQrcmk3NEw2ai9zMFd0WC9HS0NyZlFF?=
 =?utf-8?B?dG9JT2t3YWt6b3dtcGsveVpjYzNVS2Z2eENOVUgvUkJqU3lUbTJXaTE1RGdm?=
 =?utf-8?B?L25CTWx3SHJNQ1BUaHJuekFWTzhxQ2dZVmloV2YzVHdYMVdXRXVMV2ltbXZt?=
 =?utf-8?B?WUJiT0t3Y0QvUmlwTTlVeWdRSk1rSkFJbG9KeWxzVGo1QXlHcmVKR1g4NTVq?=
 =?utf-8?B?ZkY2RzIzZEUyL2ZJd1E1QXJMV0JaVzJwazRCNWd0bUttQWViMDNrOG01akdn?=
 =?utf-8?B?MFlnWVlQcUdYVGtncnJ1MFNqVnNuS3EwVFh6ekNsODZqQlc1Vlk2RXlMZ3pq?=
 =?utf-8?B?alVLWCswNTNqclVVbVg3RXJBMXNZMktrMFpjMi9WZFYzZUZQQmMzNFNrV2Y3?=
 =?utf-8?B?RXNCQ1lSdU1WQUlYYVdFcFFQbmJBQ0RnM3kyU015cUhZUDhTWGIwbFI1NlNo?=
 =?utf-8?B?MndteStBNXV3V0JrU1cxc3krUC9sa2lQM3QyU0hVWGhKTWEvRWhMQ1JaSStm?=
 =?utf-8?B?NlpMQzEwTDdqeFJtdW0yUElHT2FxL2Vyd2ZuLzlObG5IM1dyZGh3SDFiMHlF?=
 =?utf-8?B?WHRqQkFXeEViNlpSaTBsdFlyRFN4TkFDdks2UXVPbjliMyttUkxQWit5Tm4v?=
 =?utf-8?B?a2NhOHhieERVQy9QK0FDQ3FoSWd6QzY5NllGaktLM1NXUEN4S3lxYXNpZVdY?=
 =?utf-8?B?K3NuRy84U2VOMEZCbkNLYTZPVXhWdGZEc0pkSWx0aWVpRXVQTTREYnd2R2ZQ?=
 =?utf-8?B?ZHFFdEkwVGJ3VlhJR0ZGbGU3WlJ5WGZZbUphelVISmVOZTNhTDR2MlJhWjRD?=
 =?utf-8?B?aG1TdXpibVB2QlpxOEhFT3U2YUhldG1nOHJDMUVUUTd2UkpoSlFYU0xUSGhF?=
 =?utf-8?B?OXpYWEtRdEozaGdkTGdXQmh4Y3M3RXdiaXNwUUhqU25aQnBObm9jOFpMa0ox?=
 =?utf-8?B?a3dWUVc4bnA4V0xOK0w4RUprNGJNUnltUTduTHRLOGNMRERsSUJmQVd4U041?=
 =?utf-8?B?MmhzOHBieHpDdUd0WjZLSmJaSlVnay9qTlVha3FUZURaWXQ1a1QzN25SeStK?=
 =?utf-8?B?YVpvVU9sOWlyeXpjMG1saHNVcHQ2OGZnSjc1UzF0R08vWUVLQ0lRdzFYK1BZ?=
 =?utf-8?B?S2dYcExINWlYTE9XTmZ5bjFBNmJvNmRxWi8ycXQzbU1yejlPUVRtV1l1aWJK?=
 =?utf-8?B?U3FvSXhLTXRVMjY3bGNvaUNJUkxqeENqTXBZa2FwaGk0bGRRbWtrd3pTT1Iz?=
 =?utf-8?B?S0RuS3daT2k4T2ZaM0NXbUFyRS9UckRldzRlaHczNkxCb3Rtd0Yydk03d0RE?=
 =?utf-8?B?aVR1bEtxYm5RUUdGaGxJS3VxbTFyUllmQTQrZWpJeHI5KzNsSkYwZlhNTUth?=
 =?utf-8?B?UFBCczNFZXQxYkFmYXErZktmOGxHeHJEVGQ5Z3FucnQ2SloyOTRQelBrYXEr?=
 =?utf-8?B?M09qbGV1S2FSWDZ3b1VFNXdFaW1FYnJtMUxWdGcwb0JWSEo4V25MSy9YYzE5?=
 =?utf-8?Q?FM1YD5H58S83/s7C0daP4zTfrJ0rwWV6NCR/I=3D?=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV3PR12MB9404.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(1800799015)(366007)(7416005)(376005)(38070700009);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?utf-8?B?dUpSajcvSEdDWXBKTGZGeHgrVHZibEFNcnFjTHUrT1Z6aUtDbUFGd2oxUzhI?=
 =?utf-8?B?SFRxcStoa3JUbUlGclZzUzRsNVFCS1FES1VESGUyelAxMFp1V3Q5RXdURDF4?=
 =?utf-8?B?SnU1TU05RngreVAyUk11dmhoanRQT2ZaT0VTMDJQL3RtMDNhS1JSU2psaUR1?=
 =?utf-8?B?SDdFSnhuSDByWEw1N1k4djMyS2cwZHREN2xxdFNhVkxBanJhbnVyN0p0Sm9Y?=
 =?utf-8?B?L3ZscldMOElLZ1lqTjQ1aVF1K2sxVHpkV1ZRZkFEeGVVSEZobWtMb25vMTdF?=
 =?utf-8?B?MWRGOGhkT0U1UEZ3dS9BZUhzWVgyL3dXS05PcWlPL3R2SVprOUloei9BSkxo?=
 =?utf-8?B?SDRaanVKRDdBdGJxbmhJWWVidnMwSzFyanU0aVJLKzhyRXJMTHBvNk9BUU5B?=
 =?utf-8?B?NkJ4K0NpaVpEMVJBdlJkL1RhU0hKMkp3Wnkvd2s2VVozdndSdEVNVDBEbGxT?=
 =?utf-8?B?VG0rajVxbVd1UEErdlRzVE51WU9jZTl4akEzME1vK2Z3LzhCYkU4a1NBd0Jk?=
 =?utf-8?B?TEg0RnNxVGFBTVRBMmJ6bVZlaHlWNkxOb3E0WjB1d0c4Y01zUTVhZHd1d000?=
 =?utf-8?B?TENvU0dYNEV5RmFuSEp5NkhoQjZYL2lRNkFUaldaR1VLTHIzUjRYVDU4NWlO?=
 =?utf-8?B?cWNtS2NkcTB6ZWtwbUhiK1JPbGZkRlladk9IcmEwUFhaN3JoRDhzSTNuYnN0?=
 =?utf-8?B?ZmlkelVhMU5MelRxOGtlMnlCNUJ0NWd6TzQyVGtHaUt2NElSaTd0UUJvMkc4?=
 =?utf-8?B?dWFrYVlpVzJXcENUQ1hxZWpkTnN4OEdibG9seXRUdXdKWWJISUltSkcvYmpk?=
 =?utf-8?B?VDVrTWV5UytWNXBzaGw1L25JenpHdVRaYnRMNmNobGFES3h2RFlLNUYzSzht?=
 =?utf-8?B?cTBWNTlCYm5TWmFUQmpmKzhCWlJabWFycDVGcjhVMmVpKzZ2ODZ1d0VjeUNw?=
 =?utf-8?B?R0FzR3BaUUZhbGkyOHU2VDFFM0wrTldIUWJaWVJxeU04a0F3WGN6ZFR1d0RL?=
 =?utf-8?B?amVNLytIMVNBMmJROTROd3g2dVhQRmtSYjFMM1orc2dSVHNMb2l3L1JwQm9X?=
 =?utf-8?B?NnBVc2FqZldXN0J2S0pIczR5am05V2tvS21nUExHU09CamliQlFYRDFZWDFq?=
 =?utf-8?B?VDhvdGc4K1ZyWk9ETERJT21haUNqekJvK1gwYkZ3RjgvQWxZL0JBN3RtQWF2?=
 =?utf-8?B?YjVjWFAxeGRQTEhlcUJEUjFEWWRNYU1EbnYxMWpnTDhMMFY4emtxakI2VXdD?=
 =?utf-8?B?MUMzUlNsQ3dDWjhhNTkrRnRTSUp3WHQ4TzlHOXNWYlFmY04vZ2lPWU9QVVoz?=
 =?utf-8?B?SG9odFkyRExBUm5wOU16bVczU3FqNG5FWlhGMWtOVjNvL0UyZ0FtVkU4NUpr?=
 =?utf-8?B?cHJnMGx2Zlg3eExUa0dvY0FBaXRWV1pFWnZIWWVLTUJWbDI2d3dRaVZsMTN0?=
 =?utf-8?B?Q2p6OU9IbDhhV0dkSE9KWERvMHM0ZmV2QzY3WmtEVjk5d0dLRGRobEp1ckxQ?=
 =?utf-8?B?a3lFT3VXMWJQZUg2d21rZ01vRDNWWkNHUm1QOWdRajhmNEZ6Znc2cndlaXJ1?=
 =?utf-8?B?TVhNN3RrN1IvVFBBdmk3MiszWHltalQ1ajllSXAzL3FtZjVCYWFLeUJEYnpP?=
 =?utf-8?B?dXNxSm1xTkluNjRxRWorelZjRUlIeGduSG1RSVdveXVSTlYybHc4YzUvMzYz?=
 =?utf-8?B?NmI3UXpxSzhPM1FnOXNZZzBoTk1IQzU3RWZRaTNVcVJqdDZjSjFEUjZHMms3?=
 =?utf-8?B?NlgwRzltaWhzWW1GRk9CamFXZ01keEpHNDExRDhWc3d0Y3lya0tNQmIxOGNB?=
 =?utf-8?B?bUova1NCb2lxeXZPNk0xYkJmb1A0VVp6eHdJT0RsK2JlRlI3V0Zmcy80ZHph?=
 =?utf-8?B?UUZhVk84em1yOExxN01zblQ1eTF2aG05Zm9sZ245YjhSWHdKZ0VSSWY2RFJt?=
 =?utf-8?B?czhaeFJzd205UWpBMmxwNVJzUStuSi9Xb1c2c1ZadE1JRStROFd3c3E5aUU5?=
 =?utf-8?B?Njc1UmtaMFExSWNML1FIZzJUcllrQnJNOGxkclRpVnFDNkxNTUlXZlZmMmlL?=
 =?utf-8?B?UnZjakt2eGh6L2dPM0FEUjZtcEo5WGNBSHhlaHFESmpLdk1zVVFZa3hncTVV?=
 =?utf-8?B?d3VzSlY4VFh5M0Y3VmJiTHBMSFpsRDNJcDVuK0NaakE5T3FmMHNrd1FSV2FL?=
 =?utf-8?Q?ANjde6+Nys2n36D6+Y440pTbFC1AVHdqm9bkfmSTMhSc?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <24930CC8CC70AF41A2D514023CFC2084@namprd12.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: LV3PR12MB9404.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a1640798-4f62-42ee-e6e4-08dc85bd5f90
X-MS-Exchange-CrossTenant-originalarrivaltime: 06 Jun 2024 00:12:37.8291
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: mv+Q8rThPZYVlBDp8xSmYIwXRWf8E/n23wSidboijN4ntUPXcXD4+Jcf6/aeoti8l59Bv3Q/MEAmGF1nZ195Vw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LV8PR12MB9450

T24gNi80LzIwMjQgMTE6MjggUE0sIENocmlzdG9waCBIZWxsd2lnIHdyb3RlOg0KPiBVc2UgdGhl
IGJsb2NrIGxheWVyIGJ1aWx0LWluIG5vcCBwcm9maWxlIGluc3RlYWQgb2YgcmVpbnZlbnRpbmcg
aXQuDQo+IA0KPiBUZXN0ZWQgYnk6DQo+IA0KPiAkIGRkIGlmPS9kZXYvdXJhbmRvbSBvZj1rZXku
YmluIGJzPTUxMiBjb3VudD0xDQo+IA0KPiAkIGNyeXB0c2V0dXAgbHVrc0Zvcm1hdCAtcSAtLXR5
cGUgbHVrczIgLS1pbnRlZ3JpdHkgaG1hYy1zaGEyNTYgXA0KPiAgIAktLWludGVncml0eS1uby13
aXBlIC9kZXYvbnZtZTBuMSBrZXkuYmluDQo+ICQgY3J5cHRzZXR1cCBsdWtzT3BlbiAvZGV2L252
bWUwbjEgbHVrcy1pbnRlZ3JpdHkgLS1rZXktZmlsZSBrZXkuYmluDQo+IA0KPiBhbmQgdGhlbiBk
b2luZyBta2ZzLnhmcyBhbmQgc2ltcGxlIEkvTyBvbiB0aGUgbW91bnQgZmlsZSBzeXN0ZW0uDQo+
IA0KPiBTaWduZWQtb2ZmLWJ5OiBDaHJpc3RvcGggSGVsbHdpZzxoY2hAbHN0LmRlPg0KDQpMb29r
cyBnb29kLg0KDQpSZXZpZXdlZC1ieTogQ2hhaXRhbnlhIEt1bGthcm5pIDxrY2hAbnZpZGlhLmNv
bT4NCg0KLWNrDQoNCg0K
