Received: from NAM11-CO1-obe.outbound.protection.outlook.com (mail-co1nam11on2044.outbound.protection.outlook.com [40.107.220.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8509033E1;
	Thu,  6 Jun 2024 00:16:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.220.44
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717633002; cv=fail; b=C9k4FEKfLrNEgK8HeAopaQD5ePqvleoZyrR42vKUzgQPgP+yyLszLMSc1fSqFRPtewRMoZDJFCA+/sazigJ3Tfx1a0mYjbISM1NVDbFpsmTX5sSE+A40t9o1cDe6cmS9p0+DQRuRn/6HL1kMZ92i1mvrGzDWZzL//va96gTuV9I=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717633002; c=relaxed/simple;
	bh=yaVxf02Jry0+SsFX/wfKERFLEqPq/1Jo5pAq8QrnDg8=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=RCUZPEDpzBTLp8EsaMJK1cWz6pT4mYnQo4sYNhX1X3K395QZw5WA0ubOgYO+IWBd2ecIhCL4qF7WXfqWnss7Hj3evlUMHEXj+2gV0OE0J8wQUM+Rd0eLV7pl8nIRRSAooXA/G5OxGKtCIQufZ6jUaZZCArCGVx6UrYfD88MXWjs=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=ZZ+zYFt5; arc=fail smtp.client-ip=40.107.220.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="ZZ+zYFt5"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=kaZZnemXOrCl3hxMlHq4NFi377PnlStRcoR1nJFKQiUlSYaTt9h0PzGpK3AnyIdz0NWJcdLG/9U+CB1Pc9CA/RWJGbCxxkDtz0G65yWxM3TC9mCevefXfSbteKDTzbMCTe6QEtsjf1l8uXjd0jYDHWktgp6Qs+/1B5F1dwldi7GFPAtqIo9nqRsoaSGTMQml/iyPJ09+GjEXqxUHsUDZvNOOblwEZkmpkFHLP26ZmMOiRvplKMppyGj0I6sgyOzRy6tc9kZD7ahuwIC/k3Krnh2U7dEsNyIQflymfQIiK0x1zADVXurhAAJQRZHW7M/DAVA9c72+dXANhh/1l6yINw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=yaVxf02Jry0+SsFX/wfKERFLEqPq/1Jo5pAq8QrnDg8=;
 b=m60DpwhSVqs9HXe7ebFfrhMQs/2DEJQHfPNsbDYATP2oIB4BYAGYOre7U76FZw5bmikCkUeTcuMaiA/G9LuIBFr4pUXzKMu3lNTJkWjqHhIqcdshLGEF2WkFOW1LKwtYWSeODvXeVQ/oh1dVFJjmyHm84mypEYgHGH4nUj+iD0IPy38StD8yUd/wAILOPo7jW+8a3WxGQkkoX1on9USZvYyNoQ2undL04+i9Dz8kqEfIGrYmBIbcsDEu5dqzGBGkCKShHGhQZRriYHU8EPp5qiwF4bITyHPxGdvdnZ/xuVSiEE2LAPu4lypxxpkMhorLQ5BnBHk1u/6wNwVdMrFp+w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=yaVxf02Jry0+SsFX/wfKERFLEqPq/1Jo5pAq8QrnDg8=;
 b=ZZ+zYFt5a4Sv5To9A2WEKXd24x4c0PsbBTUvaJoRjmnx6waRSFa5THMilxTsGbt9r85tq3o9XCFnJF9DzOV2v+qJ8ZBdPIUIyZRveSELIA4+V7zGLS5eORaAaquRQH1WXSVOjr1Jl9R9LD3TFvnGlpFRDGc+fUrEe8BVDb79mO5oUoQ33Yfc1BxtQMkUhXA+wBAefH45TgykqckWHMDtV6C8n6kFJZ1uAyVRdpC3Gx81TEX1ynR3jTq5DRg1/XZkFgZMA9CHE20ZaR2SaaUn/HLb+e1poVgyfvy+MNOku32VPBcIuu4OspfNnS0m7YMkSGh69nH5mcU7UXJd3lTQ4g==
Received: from LV3PR12MB9404.namprd12.prod.outlook.com (2603:10b6:408:219::9)
 by CH3PR12MB8511.namprd12.prod.outlook.com (2603:10b6:610:15c::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7633.31; Thu, 6 Jun
 2024 00:16:38 +0000
Received: from LV3PR12MB9404.namprd12.prod.outlook.com
 ([fe80::57ac:82e6:1ec5:f40b]) by LV3PR12MB9404.namprd12.prod.outlook.com
 ([fe80::57ac:82e6:1ec5:f40b%5]) with mapi id 15.20.7633.021; Thu, 6 Jun 2024
 00:16:38 +0000
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
Subject: Re: [PATCH 07/12] block: use kstrtoul in flag_store
Thread-Topic: [PATCH 07/12] block: use kstrtoul in flag_store
Thread-Index: AQHatxHxSoCd6cKmGU2kp978DYURE7G533QA
Date: Thu, 6 Jun 2024 00:16:38 +0000
Message-ID: <fe8da7c9-fff4-490b-84e9-dcf6ae1be327@nvidia.com>
References: <20240605063031.3286655-1-hch@lst.de>
 <20240605063031.3286655-8-hch@lst.de>
In-Reply-To: <20240605063031.3286655-8-hch@lst.de>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Mozilla Thunderbird
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: LV3PR12MB9404:EE_|CH3PR12MB8511:EE_
x-ms-office365-filtering-correlation-id: 3e2bd345-0def-4cf7-8fc3-08dc85bdef08
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam:
 BCL:0;ARA:13230031|366007|1800799015|7416005|376005|38070700009;
x-microsoft-antispam-message-info:
 =?utf-8?B?WEFDRG1ZaHJuMk90YStpRlhVY1hKeEdUTDlHdGhDN3Q5ZGVWM3J1MEhYQUtB?=
 =?utf-8?B?SzNuUUE1QVlzVW5LZERXVllvcG05UW5qRDBjaW4vMG5MSmtKNWl5dXVHK1ky?=
 =?utf-8?B?TXdZMjNmSmF5cncrdjA5QlAyMndLU21TNjBqZFJNQ1BxKzNqOU4yRmc1bGFN?=
 =?utf-8?B?MzVGWm9BRTNwT2U2QVdSNC95RTR1bTVvZlh4c1RXQ25aZkxFZlBTQlZnc2p4?=
 =?utf-8?B?RU45OG5ZTldyNG44SlRFbEhLVi9VN0ZNQWJyL1pCbXZZQXAxTFNXWDk2ODdH?=
 =?utf-8?B?QlM1U2FVQThRODRhUC9XTkF3b0RuUzRzWTh5b1lvc0lvbWJEZ1JYMGZRdlRw?=
 =?utf-8?B?WlVWS3NzN2lMZHgwT2NweFAvUlBneFZLSDdkWHFKS1lwWU1RSkN4M1N2UlNv?=
 =?utf-8?B?Q285VXVRdFBmU0xNbWlEczdRajlEL09zWkZKK0NxMEsyU3crUmxDcDNLWW0w?=
 =?utf-8?B?ckQwT2FhSm55M2FZYThwMEk3ZzRmODNRRU5SSzZ1VnpKN1BOL1VxOG5WaXYw?=
 =?utf-8?B?WTM2L3ZyRHFIRkhpdmd6dkkrRFpXZk9ncVFmOGdaQlhnQ01JQTlOSDBzVk5S?=
 =?utf-8?B?bldabVB4SzNWbERhZDNQV1RCcitnalFjYUhDQ05LdHZJNUgvSVovWlhEcU5i?=
 =?utf-8?B?OUlNSndXbHh0VlR1T2I5N3ovTTBSbEZDeGgzZW9pRERGcUdIWVFkaG1MY1hG?=
 =?utf-8?B?cGE3U0ZPZWFkR2ZDWmZnbktNaWh3MmxVdzJjUWV6TWdiNDdXeC9oY25YUExK?=
 =?utf-8?B?QnJwUHRrbS9uTXY3OE9EZXFiWG40M0RoSmFPYW0zNUQ3M1pKRm9LMGN2WXRJ?=
 =?utf-8?B?NWdaVVFJZWlSem8zVTkySTRwZkpuZDdaclpiZ3NyTmZjMEZYYUxUMUZON1pM?=
 =?utf-8?B?S0wzZ2VUM0FXMnZVcjZXSC91UEpNK2J4QWc3ei9jT2pGM1FFVGdqRXNZdDI5?=
 =?utf-8?B?dTRPTE1JL21sTlZMRVIxdmNCc3ZDakZvYi9lcDZreDErYW5LbEpzTXY4NnR4?=
 =?utf-8?B?dUJDOEFVOGgzNTBhWHo3SDMrdUxkOTV2dlorK1piRE5uUGY2OU1nUnJ5Q0Vj?=
 =?utf-8?B?U0RCZ0pzZzBxd3h3dUIyMlFnZ3FnbEszd2E3U3BxWlpzVGw1SW9TYkltek5m?=
 =?utf-8?B?b3V3cTRFTU9ZeDlBemdzSThUdTZXT2VDY1lIZHRGZENyaEVnVTBIQU8rMk95?=
 =?utf-8?B?c0NCV052ZWVQdm04SlZoSXBqY1NleDNYMmYzbWJMTURTV0pSbVBESnJnNnlx?=
 =?utf-8?B?RUNsL0MwT0dhYjJnUGQ3MVAxY2dJYWo3dk1lQ3hNQmdMNHNlOGlXRUl1TnYw?=
 =?utf-8?B?VFB2bTNhVlpJZ3lBZXJmajJqYzFPWTlMMXR1a2dOTTJCWlEwZityYzBEUUUy?=
 =?utf-8?B?eGl5em5aT21aQkNwUW5ubjFhTFdKWHpWTndwL1pEZkphRHZqVVk4VkdjOTFR?=
 =?utf-8?B?RnhFemJIOU83VWF2dHhQY2RGam0zZWxWcE1uSkJvYUk5d1lmVUhPTlloMCta?=
 =?utf-8?B?VzFFV2NldWF5em1kUHRvTXJQRVVUUmtnUXVuNkxlWW1mZjEwSW5pOEh5VzFP?=
 =?utf-8?B?MDN2bUZib3MwTFZQNGQxMi90aHpadTg3QkdGRStlWUE1ZEpKOGZSQzFSMDFh?=
 =?utf-8?B?OGNKVWk3MXhxNEI1T0RNVTJ6Mm1ENWVlM1J6QytGL3FpazZlbW5CYllXZ2sz?=
 =?utf-8?B?eStXRmx4UU9GOW5BUk40WXYzM1RFTy84MjkyNzFZZlhIYzNSbzQwVFRaVERQ?=
 =?utf-8?B?bGJ5L0tBbmRpQVJDMmVaSnNsd29iK0RzaXhOemRDTllLYTdNRlBzWUEwMnJn?=
 =?utf-8?Q?h1u9p831Y+RY73pBxU78IHYyv9VC+j/NuUguw=3D?=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV3PR12MB9404.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(366007)(1800799015)(7416005)(376005)(38070700009);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?utf-8?B?bDlmbUp1REJBeGthRXg2dHpGSFovYWlCazg2ODV0ckhyS2dCWUJGNm1kSmdL?=
 =?utf-8?B?bmJqRkNiSGdLVDFHNkdZYWhPQk9UbnBYYXRrTE91dHhBdGw1QkswOUVPbHRx?=
 =?utf-8?B?N2VkM082NHFCSlArMVBlSjlMTVdmWjkvNUNaaWVGbm9zZGFseDE0YWtiVytU?=
 =?utf-8?B?cjhvcWl1RWJTRmU2YmxxNmtNRjFtUmkyS09XTDdZUndGc2Q5Z0NkbU50TGdk?=
 =?utf-8?B?aTZmQ01CeG9IN0UwMXNUTFpVc09PanF6R0t3ZUxhbFFYQVRlRzZTcWczbkpE?=
 =?utf-8?B?U3AzLzN3UTRpa2E0MTJDRkQxdy9IZUhwSFRIRTlnT3E5NEt6aS85TlpSVnQ5?=
 =?utf-8?B?TnpJaVF3TGlRU2ZkWjJpbU1kbUNlbXJ4T2kwNi81WnlyZFh3SWJkSitKdEs2?=
 =?utf-8?B?Y0YzOHFSSWdzZVpteisyb2dvNCs0aFAzbXowRnAzMmM2cHp0UW5uakd5dU50?=
 =?utf-8?B?b3VnZ3FvQ2pja2d6R21KQ2xIc29vSUozQkMwWVFaT3lVbklDSXNybDd1eFhQ?=
 =?utf-8?B?ZlNKMUhNSzBaVkduRjVTRDdQMGw5ekFUd0ZtT1IrZ0tHR1l6dStoQlF6bU5L?=
 =?utf-8?B?VHg4S0p1ZzB1UUg5MTlYK1plMXppZUVzSXdyQVhSYlVWTUxIay9TM2pPbW5K?=
 =?utf-8?B?aDRUbTNScFh3R09XelVZZUUvbjg4am1ESzl0RmQzS3NpQjlkOTF4TTdrYWNT?=
 =?utf-8?B?cUZYMEdJaDBEWHZocDhHZkg0N3FnaStSeVJtSzVwU1E5UVJLa1Q5QTVSSFI5?=
 =?utf-8?B?dlAxUk9jSmpJZ1gra0NGSGF4dUtMaWNBQlNDSnpiQmZDZTlieHRMQmZPd1dr?=
 =?utf-8?B?Q2syZlErNFdZNitaYTV4dHlCWURhU0NaTWc4Q21TdWQ0cVhXcFpDQXV4Z0pM?=
 =?utf-8?B?N3plQzc2QWZ5VjBpb2RXcUdsSnlFWlg3dEtmY25nOUprSXFXN3kvUCt4c1hT?=
 =?utf-8?B?czJsYTBkUkpPVmEreHZndFVvMDZwSVBkOXVydERhcGRoekd0Nk1lTGdhbjJm?=
 =?utf-8?B?TURCK0hua2NwbnFYRU1JZUxIN1J5cExVUFFKdGNBQnVQOXpidjdBeGNMUlV0?=
 =?utf-8?B?OHo0RDBGbERoWHZ0QTRrZmlyZkJGa1dPREhQY1hsMzliTjlraWdrYWZHQzR2?=
 =?utf-8?B?cDI4UHFJeGVzN0hHRWJ0cnRud1hRVml6eDdhOFRSWFZSNnVKNFR1TitUN091?=
 =?utf-8?B?czZ3U0pyKzVLM1JobURnQ1BBYkRFdDM2K2I3S21hNm1aSTJhclRxWWgxTWx4?=
 =?utf-8?B?RHllR3lvK0VzT0E2RTB4M3ZtRDFtV25SSWxLVHJXQ0Y4Z0xtYkx2TzAxN1Rh?=
 =?utf-8?B?UCtONmtMZWM3d0xyZXFBZnE5b3hKb3JrMWMxVVlYdldDZXE3QWVFTXRzS3pE?=
 =?utf-8?B?a3kvMDZwU1dsK3JHenU1cXlWRnJCYjc2UXIvd2g2Z2ozU2liNldROVRtNVRD?=
 =?utf-8?B?LzRYRXJGcldYNUFsZkZEeUw0ckZScGpQZmRvZFZPbXlHZVdKTllxaWJrU2hJ?=
 =?utf-8?B?U0RyNkVpT1VYUVNvM3gweDJQbGc0UXZBdUlvS3R4R1N2bUkxdXRaZEx4d05O?=
 =?utf-8?B?aTFTMFV6Y2JkSVdpb3Q2WkV6Yjg5bnRKR1FTWVRveG9TOFVkUU9rSUViNTZa?=
 =?utf-8?B?T2RBYVFKZWxlY1RjQ3VBRlZsTXNIVzlWVmluVHJPaWZ2M2dpYWt4eGgxb2RS?=
 =?utf-8?B?QVVFaTZyMDhIaDExb0lTSEFyVmtWajRXeVVmQmhhd3loSkx4Vy9TblFhMlZL?=
 =?utf-8?B?Qi9uNlVPNFZML1ZTOGtYRFFBSlN0eGxDQzYxYWVLdkt6R1d3UklxL2J4cUc2?=
 =?utf-8?B?UUhlanNuR29jUS8xelRaYXl4MzA0ZDEvSHk0azFZODh0V1QvWmVGQ25uTHpE?=
 =?utf-8?B?N3N4amtnbURidmNJVHdyck1QZDE3SG5qZzBXdDRjTmlSeithdkh4a3hxQXQx?=
 =?utf-8?B?aVpiLytkbmZSMVFmbkxBSVpGbFM0ek5hVlZLRUxPcnVKWjdJZEo1Rlkyc1d5?=
 =?utf-8?B?UHhjanlVWDNqUEFFaUhPTDJlRUxKL3NpcEsvVnpsWEp4cDNDUzVqSzQvZnVv?=
 =?utf-8?B?SGZhWkp5ajA0L2F1RSswMFhQWlA5MFBLaUJQdEF1d3FPcThLUFhXTHVHdkxD?=
 =?utf-8?B?TmUxam55YlRvV2dQSTl0SmxKU0haMDcrMmZEdmpSOVNqVzJWOXBwcVo5Rkdn?=
 =?utf-8?Q?tDYldRTASu47MvPDC2QmEN1yGrTOePUoyn13MMJrXIYR?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <B8BFFC966F8AAB41BB15514432E48246@namprd12.prod.outlook.com>
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
X-MS-Exchange-CrossTenant-Network-Message-Id: 3e2bd345-0def-4cf7-8fc3-08dc85bdef08
X-MS-Exchange-CrossTenant-originalarrivaltime: 06 Jun 2024 00:16:38.5356
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: ziWjjgyKz+cmrh/kR0mcxbuP35pOGE5KhsEKRhInN7oo5wF0TWzpd/Ip9reDjsHXS9xuAVBL+fTzi66kvxzC8A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH3PR12MB8511

T24gNi80LzIwMjQgMTE6MjggUE0sIENocmlzdG9waCBIZWxsd2lnIHdyb3RlOg0KPiBVc2UgdGhl
IHRleHQgdG8gaW50ZWdlciBoZWxwZXIgdGhhdCBoYXMgZXJyb3IgaGFuZGxpbmcgYW5kIGRvZXNu
J3QgbW9kaWZ5DQo+IHRoZSBpbnB1dCBwb2ludGVyLg0KPiANCj4gU2lnbmVkLW9mZi1ieTogQ2hy
aXN0b3BoIEhlbGx3aWc8aGNoQGxzdC5kZT4NCg0KTG9va3MgZ29vZC4NCg0KUmV2aWV3ZWQtYnk6
IENoYWl0YW55YSBLdWxrYXJuaSA8a2NoQG52aWRpYS5jb20+DQoNCi1jaw0KDQoNCg==
