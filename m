Received: from NAM11-CO1-obe.outbound.protection.outlook.com (mail-co1nam11on2082.outbound.protection.outlook.com [40.107.220.82])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1A10A139D;
	Thu,  6 Jun 2024 00:16:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.220.82
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717632973; cv=fail; b=EYRfKgCeAKD8elPx8D8BqaqfjX6HyyJWlCPvOWlP+1Xfhh2I/lb1OeYJcfkRanPuYiBC6AHQv5ouiyLEnifBzbzJ46itpJTvGU1pCN0JyEse1CuwK5GBw8v4caPab7778ZtyJxHQLzdZe70s0suu/rqhbN0ul/ZBZcSi2PGsT1A=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717632973; c=relaxed/simple;
	bh=X/1CFFZqcKIdcTgazA50IfIjge/M9VN33UxZ7j7Z+mM=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=Gl+0nd8r0HwJdmkVYJ735KS6xi4lSAuuOL1g5PFE7w6cj/ykWXha1nWQEQz6B5cV5vj5OvLUAW+aqT5BRMIGT4osippCeBDxw5kWoWlu6sSpJK3zPjG31Tx8BZ5EtBw285adFRo2nUiWihN/wI5k+kjqniQCa4FhBPrQD1WFAco=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=PzkUvp8f; arc=fail smtp.client-ip=40.107.220.82
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="PzkUvp8f"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=H/bRr9k7BhBGdZfttdJg3VUErzFC4KkpQxBjaEX7ErCLsr5XBlnGie5Ogym77sGmB37XcdB+VRlfw84ZHeYx9pvnG/rBgXJV7Fnwur3/paDM6PH44RLCcAlLyO1QCV0h/a8yEunW0tB+0wRyANwD83BD9Pi+x0gguBKMQ1OMeM8GXdaA9nhsrLOmJoCz/Uy1ClyfBlAU938yKP4zHmuA7JAzBdp8Q3PDKziO4AQNdLvKFhCPfAkuythkJcp0H0CwbJhjUU1NajWZtbdVWvI5STkjyPP7na1HimxrNyKLCvJoFWnRJ/axPgPGt98444K/fn+b5FKTd9SpfV0zxITO7Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=X/1CFFZqcKIdcTgazA50IfIjge/M9VN33UxZ7j7Z+mM=;
 b=Br3eol72BImhL+roGvvIophiSFB0NK6IfGx2/ZtMu5WVtCnU67RqqF5pyZuR9F0YrMtLIotNeRGu18PiX6bPj1N1qb6YFMAh5FAYanufP3S2/8vMzVvZZKn8YdfxF8UqHXhGZgcu4KlHBmE9vHgbQFuTJlY3L/9gr96YD4WjxEnZzHpU+ABS9vYiN/ta7qe4XBDEXMaQynUrSFZlNw1wIzmIsxXUtimvmaXpGYmvesmyUDk+F5cybaBgW+uw28E+NhHNO69WGa7/4zH9feNS5goyxxdHGi+dbT4f1BrvGMaE9S32DjAWfBEzPBNq2R+X0N51ai4Ygb+MGOXEt7MgxA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=X/1CFFZqcKIdcTgazA50IfIjge/M9VN33UxZ7j7Z+mM=;
 b=PzkUvp8fUPBoAEQ/JZ0YVEfCapwVtWnBSQxsPYtPFWtBxzLGdZYdjekrjwUKWPQ6FFk41DPNqRmVemzUzh3knSQ1ibCMlbTWMSYMNw1qFq56jSVaHHmYgW8aMKsNWC9rVcIyYdblaqbqc0u2K54/wT9vpMrZbg74fW4Bpz/mR86T1FVIudlGl3J4Q2fdqhJfJ6+wcuLlD3pU1tjglzu6Djx932A6nXBhIvVZYdsDjXkbSEPsLgO5bixLxHcAe5HChNPVzE3EUBrl7G1t73tA75MmXxF6Qq0ToEIu1dGjemUxxhRxjxSArO1tq3OevINxqcM/cZFUtuCMgXy37e753w==
Received: from LV3PR12MB9404.namprd12.prod.outlook.com (2603:10b6:408:219::9)
 by CH3PR12MB8511.namprd12.prod.outlook.com (2603:10b6:610:15c::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7633.31; Thu, 6 Jun
 2024 00:16:09 +0000
Received: from LV3PR12MB9404.namprd12.prod.outlook.com
 ([fe80::57ac:82e6:1ec5:f40b]) by LV3PR12MB9404.namprd12.prod.outlook.com
 ([fe80::57ac:82e6:1ec5:f40b%5]) with mapi id 15.20.7633.021; Thu, 6 Jun 2024
 00:16:09 +0000
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
Subject: Re: [PATCH 06/12] block: factor out flag_{store,show} helper for
 integrity
Thread-Topic: [PATCH 06/12] block: factor out flag_{store,show} helper for
 integrity
Thread-Index: AQHatxHxMFgTg2TzJ0m3SMn1UPteN7G531AA
Date: Thu, 6 Jun 2024 00:16:09 +0000
Message-ID: <574c2dc9-51f0-45bd-b1cf-c80c56f6bf1b@nvidia.com>
References: <20240605063031.3286655-1-hch@lst.de>
 <20240605063031.3286655-7-hch@lst.de>
In-Reply-To: <20240605063031.3286655-7-hch@lst.de>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Mozilla Thunderbird
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: LV3PR12MB9404:EE_|CH3PR12MB8511:EE_
x-ms-office365-filtering-correlation-id: 0ff5be06-5340-4d74-c4bd-08dc85bddda9
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam:
 BCL:0;ARA:13230031|366007|1800799015|7416005|376005|38070700009;
x-microsoft-antispam-message-info:
 =?utf-8?B?NEYvcEFSWVJNTlRrVnRGTXZJUDJ2anNsU1lpRkY4U014WVordklxMXhRSHZ4?=
 =?utf-8?B?M0IwK2pBMjB3STU2cGdDZ1BrUUZtek5wUm5iSnNzaTB3UUhKd3NzUmM2QjhN?=
 =?utf-8?B?bjdGeWZNR3hodC9KNzNXQWtmVkI4TU1lejFYTXFCLzcvNkpsTVdEZnlvdFlu?=
 =?utf-8?B?TjdEMW1OclVTZjZpNFRHM2ZtYlFsRE5hQ3puM3FJS1VWckNHeWZGdXhGWE94?=
 =?utf-8?B?Z3AzeHdHT2IxUWZQZ0pteXNhd0xsVFlDTHNnc3RYVFcyNGhEb2duYUJVbDQ1?=
 =?utf-8?B?elloSERrWThQMTJKQ3l2Q2g2THlwSitwQmFNaWNLMmRBMkF5SUx2L0R4N3pV?=
 =?utf-8?B?RVQxazRBdHVISGV6MW5pdGRMcFpTNUJITGY3MzBGTjdaYy9sSjREZ2VJZW9p?=
 =?utf-8?B?Z0xVRHBIMVQ5U3ZRbDVsK08wWjRtNFgvZVN0bVQ0SEN2WlVROVZKMmJjSzRS?=
 =?utf-8?B?NVcxWURKbllhRVQ4Q1RGTzlQQmk4TCtKZEpFS05oUzlxVm1VSmtxQldWV0xi?=
 =?utf-8?B?Zi9MbUhFVFVGQnQxTUo5YjR4UGsrTjFKSEtyUlZyMEhzOU13dU1TWVk2WFBt?=
 =?utf-8?B?cDZiMi96WjJsSDZQRUFVS2FVcVhSU1dzNlpIL1RBVVQ3RXdzb0JWYjZhakdp?=
 =?utf-8?B?UXpsNy9IZUN4bWJJRmV2RmVXblNLNXYySWE1MkY5Q2Y0bEJHWXVWSVlMVnRJ?=
 =?utf-8?B?SzJWMkZyN04wOTAzYzREK1hTTXFjUUNZTUlDc0xWcEswbjU1ZVQ1WS9VQlV0?=
 =?utf-8?B?WUVVbldhdmU3dDJ0MHRmbFJGR2Jod3ByWkxOUTJsbGEvR0VrT3FSRGFVeDR6?=
 =?utf-8?B?OWdBU2ZBaUpqRUxvTUNoL2NOMUNlTFc0QTMxS00xTHd2QmpBRDlyTmFMYThz?=
 =?utf-8?B?N08wc1pxaUJmSU4rWDFWaldpWEZvbnNZdlhVT2ZWT2x4TDlCWkJlTEs4MWxC?=
 =?utf-8?B?bVczVDYrbnpVYmloNXMzTmgraVc2bkpRUTcxUWZzc0g4aHFuTlRBOHl2VkhP?=
 =?utf-8?B?MVYwS1VKdHJ2bGRPeFJEWXdmcHNOckE5cmNBU0lHRVRaOE04aGRIRUFEVERI?=
 =?utf-8?B?Y25wWE5uQk9leDM2M2czUHl1OURJUmRZZXMyMmtuZ0pOLzdNZml0MDZlVEtQ?=
 =?utf-8?B?RnFTSWUvZUZZN3RnUFc3NU1CazAxUlEwYWx6VTJ0a0tVTW1lQlA3djZ5WGE2?=
 =?utf-8?B?NWxOQW51T1VocGpuVkxhNWIrSEQrNFcrZEk4cXpJbnYwVXkycC8rb0JhZ2tI?=
 =?utf-8?B?ZmVLNWdMR1MxeVhxdGI1V01oNFl6dDdoT3oyY0podUtJb3lySE1ZaGhxSkZ6?=
 =?utf-8?B?ZDIzTUQ3SklmNzVSbHlpZG5UYjVVZDhZVzhQSjE0ZEprc3JRK2pObkRYY1pz?=
 =?utf-8?B?L2ZWQkk5TW1sR1ArejlDQ09wcEJkOEZBZDRRMVoxdm50M3cwNlhKN2Zua256?=
 =?utf-8?B?cDI2TzBUbit2ZzRuSXphU3hDRUx4Wndia2hUTWYra3h2Y09ybS9LVEt3TVBK?=
 =?utf-8?B?NmJGV1hsWXFCeHg4ZVhuNEpCdnNycktXcHptV2hZUlQ3c1llZWVaNGVlMmFE?=
 =?utf-8?B?RGdHeGYyK1EwMjZ0TUdLZitaalpLQzh2QlFiWkxLVDRlMG1Bb3BaSjY4NGxB?=
 =?utf-8?B?RklxKzdBV1FiZFZLRlJsNEwyMHJpMEcwTjcybmFSVUhjNHhrRDBrQ0FNT1RD?=
 =?utf-8?B?QVJEUTgya0ZnTXA3dXJNME1YN3FYMlFydlhzSTlKY1FIZFdYWDkrT05nL1VK?=
 =?utf-8?B?ZTVwVkpEaFZiUTd2bmlBZkJudXlaUU5saXpWRXdGRzdKbFlLdjVreU1jNUVL?=
 =?utf-8?Q?3jKZyFDbac6lBmKtSql1z+AWdBITiwDjM+Zcg=3D?=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV3PR12MB9404.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(366007)(1800799015)(7416005)(376005)(38070700009);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?utf-8?B?dVdCZ1BRL2ZIMWUrR1BQOVNwZllLb2xOUkJQTGREVWtzRHRqMjR5Q1lDN0Rk?=
 =?utf-8?B?MlM3aUJSY0wyYjJuV1FBQzM4eDZvcFkzbzNlNXBCTzZPem8zN0FaRDY5TWFH?=
 =?utf-8?B?b20wV3M3SnUxM0wvd0Y4L0JEWXJRSmZsU1ZTQitUWVJ1YTJyUklxb2Q4UXF1?=
 =?utf-8?B?RE9hSEdmV2JlM0NpS1Q1N0NLejJJMTZXYlVrS0xrVXFrTFdYMUp5cVlmdVJD?=
 =?utf-8?B?Nms3NUdyNnNBc3N1N1BUSk9ldWE0c1BwcmFBTVBMYXBBSFNXQ3BxZ2U3eWJh?=
 =?utf-8?B?alBkVkNkUFptZ1h0dDkvMUpYM0NuTXdtY3hoWHBOYVljeXhrdHloakhSUW9h?=
 =?utf-8?B?dS90VTNRMEFINS9mczBvOTlMSmxGeDVqQ3N4V0lMK3ZOd3d3d1lsaGRnM3k5?=
 =?utf-8?B?S1U2MVFVSTkrZWxQWVB6V3R1TzZYTVVxajFSK3h4UGY0eHVOUzQ2dGtUbU5B?=
 =?utf-8?B?OWQ3eHJhMExBRTFVOUdxWGx1RFNXNnhDemgydDFFb2NDbi9vNEZ5dEhqbzJP?=
 =?utf-8?B?TXFtMS8vT24vUzl6MjFvYm52K3VIdlBrMEptc05qRXpZTisvWG55M1FGYzV3?=
 =?utf-8?B?OGlKWml5d1ZGQlg3UFFScVIzQThZQXpFYzU5UTRzNVpyNWN5T0l5bDE0a3A5?=
 =?utf-8?B?SnFTT2N5R3JQMFpyNUg5V0xyU2JndXMwclptbEx2WTFVNU9IMlQ0Q05qcWd4?=
 =?utf-8?B?bXJlQURqR29DTjZxTEhrU2xiSXJHMjRCSFozZkRBSU9ST0pjNkhTN2J3dXEv?=
 =?utf-8?B?WXNKcFJkNkJtT01nVS9wRHhjbWJMSS9QS3VJOW1rUzJRcXc1VzFaUzBUQS92?=
 =?utf-8?B?RGlkbDMxTEFJcVdjbys1dlVuYW5DalI0MzR4RjMrd1o0M3RKUnpNVVY5TmMx?=
 =?utf-8?B?L0xRWWRlSlJ5eHE0QUczemt2MWYvTGRXa1UzdE5SMUVJRCtXV1pxaVVzelkr?=
 =?utf-8?B?blYwdEZTbnc4ZU9ZSUx6TXlBVUkybGg3RXZHU0p3cGF6dmVPTldzNGJJVUox?=
 =?utf-8?B?VElTK1VhaGxKa1F3amplNFBhSkc3MVIyS2Rrc05iRDg5VU11TmVjNTdZd3dw?=
 =?utf-8?B?NHFqRS9uK1RhOHp2dm9DeU01NWRQa0JCYUN5cFVQV2pwaDVQa2dLVU5iWlJJ?=
 =?utf-8?B?T2FMTmUrTE12c043cXUzZFQ1REhvYWFoSXNCRWpBaUd4b29Nc0FTbjBIQ3hO?=
 =?utf-8?B?T2Y3NlJFU0p4K1pDQjM0MjQ3akRTT2hQV09UMjVIek1ZYnNiWFZtRktXYUdw?=
 =?utf-8?B?bjJHckozc3N4dVNNNUJMTEJxcWphbXFVbDE5RlJiaHdRMmhjZDNrWUFaYkd2?=
 =?utf-8?B?ZjhxVWNRa05mczlRdldTeDJjdTg1THlnNVA3RXkxTzB5MEp5encydjZlQXJw?=
 =?utf-8?B?OVcxL3g5dzZyVFpDK3RGNmV3eUlTd3dIdjEwUFhPaVQzcXpBQllzbStqL3A2?=
 =?utf-8?B?ZjQvb0tnZkJ1bmtId21hVytUWTc3eEhCMHZPajBnRmJQR244L2w3TEhuNmVo?=
 =?utf-8?B?WUhselhLb0xWeWFmZEM0TWVBeERpRDlXZkJiNTdPV2NNbFl4UVNaT0ZWQmRW?=
 =?utf-8?B?REJFd1RKM0hnRHZIa2pkTXZxTzh5RDUwM0xiZXR3OG1Td1U5V3FYejZMN09S?=
 =?utf-8?B?Y0Fsd01rY1BHM3d0emtmcm0wc0hwdjJlaDFYTFgxa0lOa1VpV0tENzBWT1lq?=
 =?utf-8?B?aE1SVVZES090L3pqTkJxbk95Ull1V3p0bTN0V0NFbDIvN1VyS0FJaTFKZHdt?=
 =?utf-8?B?SDM0bFRHU095aC9jWGJ2OU80R1hyb2c1MkVqTWw2WW1STFV2cnJveWYxL3BR?=
 =?utf-8?B?SU9rSlFiUy8vUFRNMlZ4ODBhME5ENVhRYzRCYkU1NUNDUVBlSzlzWUpiMCtG?=
 =?utf-8?B?ZVFxQ2FPb2N2Q1RrV1VySGVDeFNRMitnNkpxRzkwWTFVZXBIbEJXQU0yOWxZ?=
 =?utf-8?B?bXJJUGlNK2Z2dTZqVTF0ZlZBYm05RkVEeUZrQlhMcWxUSFFXaEc3bnhpQnVY?=
 =?utf-8?B?NFlQRU55VkJNUEY5VVpQUUFseWIvYzIvaUR4TUtIdFVkdGFVN2Y2eXBwdDNY?=
 =?utf-8?B?YmV6a1FhZk5ydHM3TUlYMjhCRXpOYVQ2NnVyU0tVN0xiVmxROEQ4aUE5TjBP?=
 =?utf-8?B?SDZDRVRKUDdYaUxQcFAwUVptRnRGYy9uUGhLbGx0bWlpL0p6Y01DZ1VRYzJ6?=
 =?utf-8?Q?T+fxhS3hczvylv/MVHiXikhCVx8UKBZjTIOS+H4VLKgC?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <D8B55A7661A91E4B97EF8BA5A923EA0A@namprd12.prod.outlook.com>
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
X-MS-Exchange-CrossTenant-Network-Message-Id: 0ff5be06-5340-4d74-c4bd-08dc85bddda9
X-MS-Exchange-CrossTenant-originalarrivaltime: 06 Jun 2024 00:16:09.3477
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: DDRxStkwNFjsyuejnBipJJdAbA0lRFCoJqwYD5B5IlQdjpV0KyDqrOEclLNoyr2UxH4zuJ1OcQ9KyKfN/QJjFA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH3PR12MB8511

T24gNi80LzIwMjQgMTE6MjggUE0sIENocmlzdG9waCBIZWxsd2lnIHdyb3RlOg0KPiBGYWN0b3Ig
dGhlIGR1cGxpY2F0ZSBjb2RlIGZvciB0aGUgZ2VuZXJhdGUgYW5kIHZlcmlmeSBhdHRyaWJ1dGVz
IGludG8NCj4gY29tbW9uIGhlbHBlcnMuDQo+IA0KPiBTaWduZWQtb2ZmLWJ5OiBDaHJpc3RvcGgg
SGVsbHdpZzxoY2hAbHN0LmRlPg0KDQpMb29rcyBnb29kLg0KDQpSZXZpZXdlZC1ieTogQ2hhaXRh
bnlhIEt1bGthcm5pIDxrY2hAbnZpZGlhLmNvbT4NCg0KLWNrDQoNCg0K
