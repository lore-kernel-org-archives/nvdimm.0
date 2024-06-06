Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11on2062.outbound.protection.outlook.com [40.107.223.62])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D0F294C97;
	Thu,  6 Jun 2024 00:20:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.223.62
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717633222; cv=fail; b=et10KlFNe2tACJhY+1MZ/JxyNjROTI4Hr09EgWh0J0TDA5uxz2u2NDX5gsB1MLbV3ELBDae+B5z42jkk8sDCmbgs0haCPqNtMZNotxKAzNCCAZtZpMnjsqa3sB7o4784gEV14m+CCoyMGOdnCEPXK13ktms/ccTIW5wqUDOBqt0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717633222; c=relaxed/simple;
	bh=WCcX/EnvvOaxrbjkNFQgamTPvQwvBib9xvD5JN1KSJc=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=C5nEV/tUYneaulX09SmPROV387Lzo6TiOzv7rE3JNvnMXnAxJ1slx/l9GD5yOoXhLIZdGhUQJUNuWx7pAwPv/fDt78koExUWDs9QTxxZpJ7VKXy5Qwdp0TTMgkESozMXmk8PKMBGnwiovgMsTrk6G+pbF7dFVDqsknZ3ceYOXHo=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=LQ36AFAR; arc=fail smtp.client-ip=40.107.223.62
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="LQ36AFAR"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=J7JIt6ql45dw2FNHvdm5MxlOceJGGrVIseVfFzwW9oaMGigNxawfS8P2mxJuC03e4Wur3EzGYKh+L0Mw+ZLIbQCNLMQcxy9w3jTdnwjBHjSST7AB31BvUpKEgue8ZBt9Aisjegh3EVJHMurqPeBz9VcQBlQgBigG4ez9lVAh9h+sYKZH+La3dwwmJG6NXAoX/SIByRsUe/CQdoB+fK3Jf3TG1nXwS/ImUricLdOPUFTT5X1Abmxcue3R0ti08UGyjWqvOyLECYW6dBZgfMhYFq+BvmGCfAFjTD5eE+ZqCtVQb11o7SVU9P8unnbfRhuxDPlxUexx34/cuQHXTiU9hA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=WCcX/EnvvOaxrbjkNFQgamTPvQwvBib9xvD5JN1KSJc=;
 b=VzSi5L29aYAM6CKhgOInY7ckaShhjQG1SO+1oYe8Wdk7uchKnm03/XYZMsuukIIqoHoO7TUoNrTEpT1UgF6rP10IePE+RcBjnuwDmRxiiJ6I8ItMdHD2n0C2B0oA2K4VuW/eSVeESqHDfmwCQl3QWdx4OmueoaC0TAMmWmcnyM3Vf1krvxLhhn4jH11Jnx4c6c8dRz12W09SpulaMf7HeElo1k5tkAJUaptZ4l9kxAUUctR7l4AN3bpfVsvSgjp049WtJAwnd72rEQBS09epu2Mq2norVhCcuwIKJjW6xtuqZ9W8POXI6QdONX7SxFfPWWedTYYbE4rqZBsNUBVmdA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=WCcX/EnvvOaxrbjkNFQgamTPvQwvBib9xvD5JN1KSJc=;
 b=LQ36AFARJvGtpg3Si9r6ztaRwZ2NjTPX8+auKbZ+wB5Z7Bq8JWluiZktMmSjxozgjsCLTVwN70EAf1uKi0v8b6YlwzsJqg7JN/dPxK8C4sUjcX/X/21TMCOH0kdDp//dUZ5skxCaiFOuQ8/Kc0uQ/2UWKoiO659WgPAWfvHn4oWozfjF5VCMFbXGVIw9tYg+iz5beYdCjbrXh359QDVj4Q8vOTlf+q5Eu7L3R2x4zTHdN89WbnFbgZgdKvxwtKke5hgFuIPJXYfg3xbsD0B3oGVeeg1l63hO66eOgX+kQFeF1autdsTVxdvc1YO7kY2QkyJdLeAhkGsGb9cqCmJvfQ==
Received: from LV3PR12MB9404.namprd12.prod.outlook.com (2603:10b6:408:219::9)
 by CY8PR12MB8299.namprd12.prod.outlook.com (2603:10b6:930:6c::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7633.30; Thu, 6 Jun
 2024 00:20:17 +0000
Received: from LV3PR12MB9404.namprd12.prod.outlook.com
 ([fe80::57ac:82e6:1ec5:f40b]) by LV3PR12MB9404.namprd12.prod.outlook.com
 ([fe80::57ac:82e6:1ec5:f40b%5]) with mapi id 15.20.7633.021; Thu, 6 Jun 2024
 00:20:12 +0000
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
Subject: Re: [PATCH 11/12] block: invert the BLK_INTEGRITY_{GENERATE,VERIFY}
 flags
Thread-Topic: [PATCH 11/12] block: invert the BLK_INTEGRITY_{GENERATE,VERIFY}
 flags
Thread-Index: AQHatxH5h5Oj0Cs3806wZy342oY1lLG54HKA
Date: Thu, 6 Jun 2024 00:20:12 +0000
Message-ID: <8dfcbc54-d960-433e-8da5-6a5ed5de1586@nvidia.com>
References: <20240605063031.3286655-1-hch@lst.de>
 <20240605063031.3286655-12-hch@lst.de>
In-Reply-To: <20240605063031.3286655-12-hch@lst.de>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Mozilla Thunderbird
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: LV3PR12MB9404:EE_|CY8PR12MB8299:EE_
x-ms-office365-filtering-correlation-id: 8d60de20-07ca-4ea7-fae3-08dc85be6e54
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam:
 BCL:0;ARA:13230031|7416005|1800799015|376005|366007|38070700009;
x-microsoft-antispam-message-info:
 =?utf-8?B?eDJVTDltT2lmUEdNYXI1MVhYamw5clMySE9id3hjZ25ML2NKTXZaQ3pkUnpF?=
 =?utf-8?B?eUJJVEVEek84WWxEbThNbmJRdmhlY09XdXBrVDFQeUw4UzJTUW8rb2RWQnZ2?=
 =?utf-8?B?ZTJmMEw4ZUhoZFFLTEpLb0o3QTFFYmU3aEc0SE44cktrdHJCRUVBYTJ6ZXla?=
 =?utf-8?B?bWFka2ZRVGZBRHVBTWZPamU4VW9EekNTdVgydEdEOG56eUt0Rk9YTVpDY2xR?=
 =?utf-8?B?WGZMK29WakdEYXJKR0VhUThjKzByMGlpQ01DMDV0SnVXMkJpU253RmJ6RENK?=
 =?utf-8?B?N1JOZXRpMUFXMUFXQnEyS2lxVXZ3ZzJ4NXpUcHNDVFVTb2lYZ3ByOUQwcXF3?=
 =?utf-8?B?YXl5NGpSM2tNVEZMQmljMzlPeVFJS3NYYWpNT2NzanpKR3FvTU1LM3ZFVHg3?=
 =?utf-8?B?eTNDNE9EaWJYYk1VR1pUbjBtM0ZqTytFRnJPSWpjb1RpM2orckR2eEVnblJG?=
 =?utf-8?B?N0dXamRtdUVidFkwSVVUb2hxNk5DeWJoSjhIYU5VVHVJaEZ0K3dGQlAybkJC?=
 =?utf-8?B?R0l2L0p4OHpMK1RISEFuai9pVFk2ZEliVHhsL3J1REFrSlZ0WmV1Y2pWb2p2?=
 =?utf-8?B?QUo2Yys5a25mNXlldVQvRXBIOHJJSXpSL2JYcnpQOWV0eFo0N0JMbWY2UGZ4?=
 =?utf-8?B?SjdIQ1hlN2RYK0JMaVBLNWw0ditxMGM1U3RmN3dqbTRBVnFpVjdNNStXZUlU?=
 =?utf-8?B?enRZdXdPTHBvcWhDSnJMbDRYc3RjZnhocHJHaFYreUM1V09lRkFSVXV1WTFx?=
 =?utf-8?B?ay9rekVBSE9VenJmMlVIQ0NvamVUSlo4cmxYanc3MjUrdVVxbDd0L2FWdkYv?=
 =?utf-8?B?U0lYUVNaVnFyUTN2dDVFemVSZU02WGh6N3kySERtak00c3BwT1NRTUtRUDJm?=
 =?utf-8?B?cDBmaFBHbXlveUZMdFlURzcvOVZjTHBvaDFlOWlBNitvVG5Pa0gxYUpZR1ox?=
 =?utf-8?B?NFViUUxmN2IyNnN5aFF6ZC9LVVlIWDRjMTlhMldjbmFUQ0w4RnYyYUFIQzBT?=
 =?utf-8?B?T29LWU8vSXBFSDJiYlRHV0toSHJjczRPZTVmU3F0TkwrYUVHbmp1aloyWVE4?=
 =?utf-8?B?bngzVWo4MENWY3E4Y0JWOXR5SkNtTGxNOXR3Q0xWeWdFdUVoUHNCWS9aMWx6?=
 =?utf-8?B?ZjZkek04dVBrN0U3NFAxUU9RM1JhUG1seW5HVGFic25MWWUrNmJXYXBxUUhN?=
 =?utf-8?B?UlR6ZHVucWtLSHBuZ3JKaHM1TjFnYVQ4Mks4dFd4R1NlbnVKQldOTnFkSVBU?=
 =?utf-8?B?Mlp1ckpXWFJHanlVZm1YZFQxMG1VQzNyd2t6N3ZVUWovRGtYUU10dWNHbkR5?=
 =?utf-8?B?NGxFUWc5K3B0MFhHTXJTNEpYckw0ejlIYm12NU5RZTdxYTFzZ3NiWDZGWHZh?=
 =?utf-8?B?WWFmQUMvNHBHTlNrSkl4UHUxbmJ4SU9uZkJHQ3VRTUZBQzZ3TjdKSzFsaUE2?=
 =?utf-8?B?MXZJaFZEckdJUzJJSXZiOE9DaXo5NFR4TTFRY3lMMDRuL0dYWmlpZTF2RDhE?=
 =?utf-8?B?MngxditNZk53UVpqQnhJdDBiK3lvTU1xRXpWS0JwZkVjUDdZaW1XZ2I0M1Bk?=
 =?utf-8?B?U2FKVFBTMDZXVlBFWnIrUXR5ZHBiK1ZDVlBKSzJ6TU5KSDZ0Q3lhSmcvOEpS?=
 =?utf-8?B?b1A5VVREMGIzVXlBSERwdVdvL21meFVlNXc3MTkxTUNPS0NUeFFaWTBkN0Vj?=
 =?utf-8?B?ajM4YUJRc2xNZXMxUEN6LzRsTHYyMFVxSGFYQkZzdnFMUnlzczFLZE9vQkxx?=
 =?utf-8?B?V0h2SGhzbmxXaG1nUFpTaWZrenZraEI1amt5T1Vsb1Z0aThJY2ZHY1RRbTZH?=
 =?utf-8?Q?rdYCd0vAKhUFg+slac+aiAJWuM4blZLzuQKp0=3D?=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV3PR12MB9404.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(7416005)(1800799015)(376005)(366007)(38070700009);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?utf-8?B?OHhOZXVvZFpYaXl6TEoyOGpzN3Z2NmNUOERCM0laVDNBamxxYiswVm1JL1NU?=
 =?utf-8?B?Y3Y3VzZNdk9qNEVxd0k4VUJnbFhGNUpheVVRenNXYTNkTEJiYllzZS9nY0d1?=
 =?utf-8?B?Y2ZNQkJNZlZVbnlSbTFvTjEvMWxXdmFaaUFJa2hFWVZCejY5U1lWUkMwNnlX?=
 =?utf-8?B?R3FWY0FRWkJJUmthYng4NXRQUWNQQnEycm45L3Ayd3IzTDhCVVRxaStLUFk4?=
 =?utf-8?B?czZudHNqS3JCTW41NDVaNWdqZDhqb2hicGRoLzVNdUV4Qmc5NTF0UFNWRnIv?=
 =?utf-8?B?ZENTQ1VFd2pOOXdiSWRLakZaamVGRGkyaEFDdUZwV0FkMExBbWk1UUdRaWUr?=
 =?utf-8?B?c3RXRnRnSXpsVStiWjFjQUZxUStaMWpsR1d5YUo1c3ZLcXpLd3JaSldHOWlK?=
 =?utf-8?B?aW9pbEdmU2hMWWdDWEJQK0J3SHdqOVJLNUJDWkZYSlhGMmlUVVFaQzBra0lT?=
 =?utf-8?B?NHNVVk1ST2Rwd01SYjdKVjVSUFg2clFnTWNxSHRic0wwbFp3Q2JCeUlqMTFU?=
 =?utf-8?B?bTFTTW5SbGV2VDlxSnVEL2NzMktLYWV6QSs0RU8rdnhoa1RYRHBXVHFNeCtF?=
 =?utf-8?B?MXc1OXlxRnZVWVFTbThWMXhhZi9jWHZZZzRTdFNHN1R3T1dkZU0vdnV3am4w?=
 =?utf-8?B?RXJQRVUrWkVMYTl5MHBzdGh3dXNTVEMybVJGUVc1RDZ0SFN2WXhpeGJ0OVE2?=
 =?utf-8?B?WFRmeUxXenZLa0N2dXZRMGJmMkNaWCs1Zm9LdCs5WGl4bDFwbUpzanpwU0x6?=
 =?utf-8?B?TVZUZVp1Z1VSMUZsRkFORWJVZWNpdkdyOERIWFN0eGRieTBGbjU0bkZ3eXVx?=
 =?utf-8?B?NjJ3RjVTOWh2enYxMHdJQlBDUW9tMVBRcmJRNGtzYzR1YU5lem90TzJqanlK?=
 =?utf-8?B?b21JZlQvWkJnT01KV3Mzakd6R0NsMExJN1h4b0hXUUFuSDF5MURvc0ZkeWJI?=
 =?utf-8?B?Nk1zMDZ0anRJMVNiMUxQMmJDZk9SUERBL2YySWl6eS9qSGhRdm5mdlN3dWM1?=
 =?utf-8?B?S1ZiYU5IK0NNTjAwRS9Hb0VHTUZYQllsRThqM1YzYUovZjkyczM0RFBGN01l?=
 =?utf-8?B?WW9WOXlwVmZ0TFhBN2NjOWowOU9nL01STkpFeGpCU0pNK2RzSisxbnFkZ3hH?=
 =?utf-8?B?TnMxOVBEZEFpc2R5cTZEbWJMRytSdUQ1UWMydEd6SndJU21NQUlsMldqM3ls?=
 =?utf-8?B?dm1taXliQWp3bkxUSW5jMHl0d1dkU2NDdUFpRlV4L2pOUjBwWkc0OWZLWHpC?=
 =?utf-8?B?MmZhdGxWVEpybm9GOTdsbjRZZ3lDYUtkSWwxMGphMmtCbVpyK3pnN3hVVXRp?=
 =?utf-8?B?aGRSVzlBcDRJNzFOaERkREQ0SjZZL1kxSUVrdXVmV2VzbXhOSHZCa3NCRGg1?=
 =?utf-8?B?MER4NEUwMVh6bUxQSS9Ea3JJTm1JSzU4b2YrT0NkeEN5VWZpWTRGQ0dTaFFR?=
 =?utf-8?B?cDlwS3NYMmxid2hFOUQvMzUwd2J3c2VaTEFwVStXQW9aRFJ5WWtGdVpETVpG?=
 =?utf-8?B?b2lzTUowak1jMXh3MVJ4Vk9iNUIxNGhLL0dYbFhaODVIZmZkVzR6Z29qeFh6?=
 =?utf-8?B?RTJyK0h1R0FGS2wwTUhyRVQ1d2VwWDQ0dFRCb3lNREhBZjNYR0RtYnV5R0VL?=
 =?utf-8?B?Y3RpckJJcE5XYVEycHdKYVZXcVhUS2JjVnNEMnU4MFRhNUZTcnJuZ2VtR2Q5?=
 =?utf-8?B?aU5TQ2J5dWpyTW1tOHUzY1k1ZHI0OFFOVWcvTERNMGR2NUZjUW8zWnNQRmNS?=
 =?utf-8?B?OFFYZ1VpcW9kN0Y5ZklRaHd5UG9wNmlQN3pOWG9QWS9sSHQrT3NrRlVZUW5B?=
 =?utf-8?B?UkRKaTVMNHEwb2ZSYW9DUGpjQ05yQ0lXM2krZnZyWXBKVE45NGVwYkJGbjZT?=
 =?utf-8?B?RG5vWXZsTGF2RU90VzJ3WFhxR2JRZk5Dbi9DaEIrMWFlVmF6QjBmYWFZRlMw?=
 =?utf-8?B?bGxWbklVWDNjbDJpR3Backp5VWF5ZnlydldldlRBNXM4T0ZtbHcvWCtCVnF5?=
 =?utf-8?B?bjlWbkprMVE3SDlkb2c3ODdyWlVZbTZ0Tk8yM3RPN3NkTnBuTnQvWGtubnNn?=
 =?utf-8?B?RExHYWY4S0FiYThQcUhaUWxtcTRobktqOHlDSUJWaEk5cHpxNGoxR1IyYWFm?=
 =?utf-8?B?NUhtY0pHUm9nMWxhUS9YV05hWFdMb3Q1dkE1c2lRZkZXMTZlVUdweTVwYlpv?=
 =?utf-8?Q?LW4rUADaciwCstsTXJp3JtZ+ZXlsXcE/e8zARDd0bPD7?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <52B61082CFC5464CBC42A0783646C42A@namprd12.prod.outlook.com>
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
X-MS-Exchange-CrossTenant-Network-Message-Id: 8d60de20-07ca-4ea7-fae3-08dc85be6e54
X-MS-Exchange-CrossTenant-originalarrivaltime: 06 Jun 2024 00:20:12.0706
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: PUa33f6pBhBk9eHNrgBTSe9bIo6hMTSlQQJOawsM4tGBSludVFvhp6BD0ptgqzLUch2SFYLAneQvr1rVIaVO6w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY8PR12MB8299

T24gNi80LzIwMjQgMTE6MjggUE0sIENocmlzdG9waCBIZWxsd2lnIHdyb3RlOg0KPiBJbnZlcnQg
dGhlIGZsYWdzIHNvIHRoYXQgdXNlciBzZXQgdmFsdWVzIHdpbGwgYmUgYWJsZSB0byBwZXJzaXN0
DQo+IHJldmFsaWRhdGluZyB0aGUgaW50ZWdyaXR5IGluZm9ybWF0aW9uIG9uY2Ugd2Ugc3dpdGNo
IHRoZSBpbnRlZ3JpdHkNCj4gaW5mb3JtYXRpb24gdG8gcXVldWVfbGltaXRzLg0KPiANCj4gU2ln
bmVkLW9mZi1ieTogQ2hyaXN0b3BoIEhlbGx3aWc8aGNoQGxzdC5kZT4NCg0KTG9va3MgZ29vZC4N
Cg0KUmV2aWV3ZWQtYnk6IENoYWl0YW55YSBLdWxrYXJuaSA8a2NoQG52aWRpYS5jb20+DQoNCi1j
aw0KDQoNCg==
