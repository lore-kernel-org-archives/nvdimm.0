Received: from EUR02-VE1-obe.outbound.protection.outlook.com (mail-eopbgr20048.outbound.protection.outlook.com [40.107.2.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BE90572
	for <nvdimm@lists.linux.dev>; Thu, 29 Jul 2021 14:44:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=armh.onmicrosoft.com;
 s=selector2-armh-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=loWBdrRPcgDSA5HFFdbvUeBeFoYsM2iB2MSEW2TZDPo=;
 b=F6W41OBO8TbbRqpqqG6qYj+bRV/Wgmi1bZdOcLet17G69jYUhLhcjFZurBVzzNJqd4ZsLyyS0eLiVA59tJmwPmUDctH0h+2vbKc4A2Vxf/Gq7wxOr6JPiFjOEeQY7LoIqeJS57ITnvtndb0sQxCaUbMRFBYGMYs1rlvktyumsKE=
Received: from AM5P194CA0001.EURP194.PROD.OUTLOOK.COM (2603:10a6:203:8f::11)
 by DB9PR08MB7100.eurprd08.prod.outlook.com (2603:10a6:10:2c6::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4373.18; Thu, 29 Jul
 2021 14:44:19 +0000
Received: from AM5EUR03FT020.eop-EUR03.prod.protection.outlook.com
 (2603:10a6:203:8f:cafe::e4) by AM5P194CA0001.outlook.office365.com
 (2603:10a6:203:8f::11) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4373.19 via Frontend
 Transport; Thu, 29 Jul 2021 14:44:19 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 63.35.35.123)
 smtp.mailfrom=arm.com; lists.linux.dev; dkim=pass (signature was verified)
 header.d=armh.onmicrosoft.com;lists.linux.dev; dmarc=pass action=none
 header.from=arm.com;
Received-SPF: Pass (protection.outlook.com: domain of arm.com designates
 63.35.35.123 as permitted sender) receiver=protection.outlook.com;
 client-ip=63.35.35.123; helo=64aa7808-outbound-1.mta.getcheckrecipient.com;
Received: from 64aa7808-outbound-1.mta.getcheckrecipient.com (63.35.35.123) by
 AM5EUR03FT020.mail.protection.outlook.com (10.152.16.116) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.4373.18 via Frontend Transport; Thu, 29 Jul 2021 14:44:19 +0000
Received: ("Tessian outbound 072c11bad1a2:v100"); Thu, 29 Jul 2021 14:44:18 +0000
X-CR-MTA-TID: 64aa7808
Received: from c7fc903141fd.1
	by 64aa7808-outbound-1.mta.getcheckrecipient.com id 455B9D60-0DB1-476D-B942-C2E1606C5976.1;
	Thu, 29 Jul 2021 14:44:12 +0000
Received: from EUR05-VI1-obe.outbound.protection.outlook.com
    by 64aa7808-outbound-1.mta.getcheckrecipient.com with ESMTPS id c7fc903141fd.1
    (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384);
    Thu, 29 Jul 2021 14:44:12 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=MXlJkoaHeTgMn2Hj7UMAv7TbEKwGYd7CpKkLBXc9V2vdNlWq9Q4HQzVzWJzG4bSTJSpOr3xWH+a36ApzIRI5nwI3EZw0ez+5R7MTdVp6BR9NAnzRH2KMdrFa9kLknIm77XBb0vfWDqJ/3q4hmfEabslEudLzSa9c9z2OdQtitvjhzZPROfGpB0yMmASfCtqdiH0c0bDGxBKFrzzRgDq8b/rBs0Yk0Mg4OEDFAFNixomZ4CgK3GaReihPclggSvIOieex7kK38IUeX0V2t/cCTBX43IitC9gSA/MmJTXMH6xZfsuevtfQJMYxGP5j5E6LK7G9DOeygCmJFKDHRpV/fg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=loWBdrRPcgDSA5HFFdbvUeBeFoYsM2iB2MSEW2TZDPo=;
 b=bGCit5npQ7AwnPT/pppraCUkldXDACR0B06IAvE8dNDIDK5XuUi4rM6u8+0+G6JjiE3NQLS18aW0cwlBGfo94F98rZsKb/v5za3sYAxrbYFDdGqhtyHy1ti0HdVtTYKwdjfC4ZZNursmgW0MCca8Gd9jg3y1KkCd2ar3EyTc4oJVd/oatvaUoWzYiMBCttoBRyMtuH4nrmizgg88ZIR67O0MZpkFXBEz9AnBGWcJheSc5IFWQwmcrd5jp5MwWC6x1RbhzOTL5X//SVemG6sff+ex4kxT1CbzGwVb8sfmCGHwDYH3AsnEzzXaHVcppdA7G/zWuE/1rCo0UfAa21Sigg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=arm.com; dmarc=pass action=none header.from=arm.com; dkim=pass
 header.d=arm.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=armh.onmicrosoft.com;
 s=selector2-armh-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=loWBdrRPcgDSA5HFFdbvUeBeFoYsM2iB2MSEW2TZDPo=;
 b=F6W41OBO8TbbRqpqqG6qYj+bRV/Wgmi1bZdOcLet17G69jYUhLhcjFZurBVzzNJqd4ZsLyyS0eLiVA59tJmwPmUDctH0h+2vbKc4A2Vxf/Gq7wxOr6JPiFjOEeQY7LoIqeJS57ITnvtndb0sQxCaUbMRFBYGMYs1rlvktyumsKE=
Received: from AM6PR08MB4376.eurprd08.prod.outlook.com (2603:10a6:20b:bb::21)
 by AS8PR08MB6373.eurprd08.prod.outlook.com (2603:10a6:20b:33a::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4373.17; Thu, 29 Jul
 2021 14:44:11 +0000
Received: from AM6PR08MB4376.eurprd08.prod.outlook.com
 ([fe80::3452:c711:d09a:d8a1]) by AM6PR08MB4376.eurprd08.prod.outlook.com
 ([fe80::3452:c711:d09a:d8a1%5]) with mapi id 15.20.4352.033; Thu, 29 Jul 2021
 14:44:10 +0000
From: Justin He <Justin.He@arm.com>
To: David Hildenbrand <david@redhat.com>, Dan Williams
	<dan.j.williams@intel.com>, Vishal Verma <vishal.l.verma@intel.com>, Dave
 Jiang <dave.jiang@intel.com>
CC: "nvdimm@lists.linux.dev" <nvdimm@lists.linux.dev>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, nd
	<nd@arm.com>
Subject: RE: [PATCH] device-dax: use fallback nid when numa_node is invalid
Thread-Topic: [PATCH] device-dax: use fallback nid when numa_node is invalid
Thread-Index: AQHXg4m9IaMvGdbjFEawG5ZIccmDr6tY1AuAgABDhaCAAICiAIAAb5yA
Date: Thu, 29 Jul 2021 14:44:10 +0000
Message-ID:
 <AM6PR08MB43766A114DA6AE971697CA1CF7EB9@AM6PR08MB4376.eurprd08.prod.outlook.com>
References: <20210728082226.22161-1-justin.he@arm.com>
 <20210728082226.22161-2-justin.he@arm.com>
 <fc31c6ab-d147-10c0-7678-d820bc8ec96e@redhat.com>
 <AM6PR08MB437663A6F8ABE7FCBC22B4E0F7EB9@AM6PR08MB4376.eurprd08.prod.outlook.com>
 <f005a360-6669-1da6-5707-00b114831db2@redhat.com>
In-Reply-To: <f005a360-6669-1da6-5707-00b114831db2@redhat.com>
Accept-Language: en-US, zh-CN
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
x-ts-tracking-id: ACE44C2E37343C4199921232C2B7E533.0
x-checkrecipientchecked: true
Authentication-Results-Original: redhat.com; dkim=none (message not signed)
 header.d=none;redhat.com; dmarc=none action=none header.from=arm.com;
x-ms-publictraffictype: Email
X-MS-Office365-Filtering-Correlation-Id: 1723dc0a-8217-4093-ded3-08d9529f58b2
x-ms-traffictypediagnostic: AS8PR08MB6373:|DB9PR08MB7100:
X-Microsoft-Antispam-PRVS:
	<DB9PR08MB7100227F066C23978B9962C2F7EB9@DB9PR08MB7100.eurprd08.prod.outlook.com>
x-checkrecipientrouted: true
nodisclaimer: true
x-ms-oob-tlc-oobclassifiers: OLM:6790;OLM:6790;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam-Untrusted: BCL:0;
X-Microsoft-Antispam-Message-Info-Original:
 j7CrxCVa/m+DChzD2dhLtvX30t1hnJJNy2uma+6Q62rUfmSafG8TF9YwlWWAo98SYmmK3nZN26M18LvCljmxgOwbLHFvC7Q+c+zR+uxSOWR7DwRgTIKUMnJJvTyR3cgcMDBnTcbDqtJFUT4ofTBv+KyN+8K2AEBvg8193l03b9XQDeaT0RU1pnIkKNxz6RhFWKdV8luqMUfKjQkh121g1f7JgwWgrb2oXbOaneQTiBcy3IbRD4uFmCY7ZhlwDRrdzaR+2LENxMisdhWZSMuG1ZxPtBdFk7zNAf1Kl7fmV14DnoxFo4P/JdJ/VHx5jnDExi5IbOSUI03JGt3oW364E0L5TnVQzEYRPYHBq9WjsW6L1eSPN/R0xiBmioCKtgR2zHqbQdxJsBvUHb5usioOGAYHuwPEcLZJBkearvLGcIwRsXUMocN8dGyaE5aVnKAYB4DODUfQ5U4iYCzCEkR+u7JL1Ob0kGe+lKkYGEQJ0n5Ejsx5i3f4qm8pNuJbqLwHO0kNl2ayvwRDRuZidX2JA82f9Q4kH3eJR3OWK/YH11/qhdV9ay4FtyL6LquLO+U2hq7wddEqHyAN8BhnGeB/oOa7k7i6JZnmaIVLvJtMOlcpEHwRcvxHBXlmBs5ldHnG646veBTHhYa8lx6hr/zOOgLpYr2eyslOym1/Rz/DCP2hAWr/jP9hnRlxmc6bmvEF+NLUT9tSZoZKBwC2sjXGqZOirCfFwcNOEJ66gNsa53RQurjMU9CrzWU4Q9HCjhuCr8FMoEvaYCK/jBX+C4Jm+BKRNZfNpD0ZMpLccLU8QmMintWo38McOWLJ69yuOOnAK1A6EWldjHrBIc0CfmJFTw==
X-Forefront-Antispam-Report-Untrusted:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM6PR08MB4376.eurprd08.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(316002)(55016002)(83380400001)(38070700005)(8936002)(52536014)(26005)(38100700002)(5660300002)(122000001)(110136005)(4326008)(86362001)(6506007)(53546011)(71200400001)(64756008)(9686003)(54906003)(8676002)(66556008)(66446008)(33656002)(66946007)(508600001)(66476007)(966005)(2906002)(76116006)(186003)(7696005);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?utf-8?B?SzZaQjBrd1lvbElMRmw0QUR3M2NQMlF3NTFQZDZkbmNWekszVGgrK1ZJZkEw?=
 =?utf-8?B?WkV2RGRWcnFBOHZieUkwYlY3QkIra01ob3gzNUFvM3owY21OdDA2RXN4V1o3?=
 =?utf-8?B?b3FkUTZVeDlKekNLcFFIb3cvWDJPS3UxYnlKRVRnTUZmYmEyN2NpK0xqRHlP?=
 =?utf-8?B?b09lWTdWOEp6bG9nZ0hNWTNVYUI0dVN3ZkdIckVvUk9vTGJXek5xQUxoS1Mv?=
 =?utf-8?B?djBMM1d6clpyS3g5TTFhRHlVOS9ha3FOcW9PT2w1NEQ4a0Z4aWFNK3JOMzlx?=
 =?utf-8?B?WElIQUhHZGFNbUhVSGdZUGNSY3pFdTRCQlhRb3JvcTRWU3pXajBVQWZyTlRH?=
 =?utf-8?B?VStQaXlrRjZtaEdJanJtRG9LRS90VEhzL1UwTVVrQnRZK0lSOHEvcHoxTlhK?=
 =?utf-8?B?cU1PSnQzb3VXNEZMQ1pSZ2E0aHorZnZqZDZpWko4RHh3d1ZMUlV4clBvdGFw?=
 =?utf-8?B?ODRTU0ZkYkZreC9BTm0yZUZoQXhNTTJvNWY0WFp6bExrYTl2czd3ekJKby91?=
 =?utf-8?B?UUt1RklGejFBM2loZGd2U05LNmM0eGVXS09BT0RDc3JjL01xY1JLcmhKL0tM?=
 =?utf-8?B?Y2N2MVRnNmNscWZZOFFQRGZmOTNCNmxaR0wxUll1T1dyZ1ZUSXVzUVByYTB4?=
 =?utf-8?B?WmNXNGZhWHc1NldIYXQ5c25adjhxVWRmSjBmLzBYNVJjOXA1ZFI0M2QyVkpF?=
 =?utf-8?B?UkNBTDlPNXVKNHZFcnR0eGlxMjErYXlIUUJvTEEyWE9OZmdVYk9mSmFhSTY0?=
 =?utf-8?B?d2xrc3FmdHd4N3JKM3M4Z2lGNFQ3NXhrc1MrRXhOcWtrOWJBZ3NxTXZpeGtO?=
 =?utf-8?B?cWxVQTBjamJtMDJmUDdTdDR4VnR3LzBMMklzajBjRm1PNVAzZUxlTU5HVnJX?=
 =?utf-8?B?eVNSQ1o3aGJ0b2lvT1dpNHp4K0t5WEd3ODA1YzFoN2l5bDRlS0x4VnlxNi8y?=
 =?utf-8?B?bTZSNVpSZDRsSWtTWFJnTG1nVHFjRUlqOVdIeFJpeFNsbUJQSERIY2tncGF1?=
 =?utf-8?B?TE1KOXU3NWVueEpHNHJwNzhsd1lkeVBwK3FhcUlZMjRqSDhSbERQY2RFUk5n?=
 =?utf-8?B?MUhwSC8xWWxUc2NLa2FFMG1GaUVwOUJFVjlFaGxKOEpENitkTHRRL2VscmZU?=
 =?utf-8?B?TTE3Ri9qNitqUUF4YXczeWwxRVlZWDFvZ1E3MzJNUGx5NXdDWjNMMHVKVm5v?=
 =?utf-8?B?U3pKaWh4RGw5dkJNbEd0Vnc5Wlg3MXlFNXR1NVJMWUhLYnRBSlEvK0w5Ymk3?=
 =?utf-8?B?bE9TaVFNMmZFa2ljY1hkNkNtTi84TlVLRlV1V2xKTmZVSC91ZTY5Q1NEK1JI?=
 =?utf-8?B?SU0vbUlZcVdjK011cE1FYXd5Z1hlYzA1bWExYjVUa3J2TnJvbng0VGhQcGdM?=
 =?utf-8?B?US9mb2dTNTFucmYwODZaZTdTcUIrVk1ONFphT1pPZko4VGNaVkxkQkJZMlEw?=
 =?utf-8?B?a0hzSXNIcWZZc2NtWVEyWTJUNGMwMHhtSFFSenR4cll5b0xmSmlRWnJLZFk5?=
 =?utf-8?B?MjN4bzJ1WEFBbDYrRXQ1aWxwVGtpYk8xRWZtYWFtL0hTSFNsK1hOM1BJK1hB?=
 =?utf-8?B?d05UdXZCTndSd0VUcW5CbnBVMng1Q04yWktVNDIvblRPRVVsRkVBYlNoY3dn?=
 =?utf-8?B?S0tiVCtzUXVId215OGt4bVJLYkJvb1N3OUY5TE5rejdjenRkUmJxdlVwWEgz?=
 =?utf-8?B?ZVBteG9vQVFsVnpqRWVOTk9BYXQ1VGNTUDJ0cmhzWU5sdnh2Y1AzczZhR3Fz?=
 =?utf-8?Q?D2sN41hRtzLtN6uVzI=3D?=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AS8PR08MB6373
Original-Authentication-Results: redhat.com; dkim=none (message not signed)
 header.d=none;redhat.com; dmarc=none action=none header.from=arm.com;
X-EOPAttributedMessage: 0
X-MS-Exchange-Transport-CrossTenantHeadersStripped:
 AM5EUR03FT020.eop-EUR03.prod.protection.outlook.com
X-MS-Office365-Filtering-Correlation-Id-Prvs:
	3ceb5ef9-33c7-489a-1137-08d9529f53b5
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	DswVMv/RnPgVUDEb6yMzFDv5EV6AeEl31KPdLNdbt9m2yQgGthyKqfTcW80clIFQtua6PBkR9uoBQfS5Gntlk020IN3bOsee+n93HOp0mpgZ76vvJfJq5skP5/GXYChC/rZSBcP+B4YYfgPfXDDF5i9bfEM0eT/nOarcV9QfRQnJosN/WiEoJiiXLd7mBlfzY7/gHO0R4IV3xr/kHinqWVcJa87h6vVmK6PZy3x1Bnm3s55FNENKgzqFH+NPVuW98klboNenhA800jIOUw/vr9b4JYseJGH6Ajrmi9PAWNQ2edrThLxaz+Z10cOvpE/bCTbDd/vqku829IMfiyUr+OqBjpC2rLYtGVErj8ZGsSkmuX46uTdhwsRnfIGPByfM4TLKT7EuaCLwoDCyG1klo0S+Cj72TR04m21NLf02Dtnr2Jh7xkh9RLKiUPCs55CbfHkrk9U1mn5aJbpd1Glds9Qpay0uH8+JkSKOuFokQmrWAp9IGLb7YOB6k7Sb7gjq4syGY+FqKKDnx5FKoXNmwur3/JbKFnziqsgmqS75qeeMRS5meF16xCrOjo+TVozoyQxIStmt21NRvBpbPbnxCG6PwWq+v3ldl70XVO0NY7k8z2QjHBbUn8oZYzEpWc9IEtDlb/gZv1RZVL3AEMQ4MwQkJT0/ppaSVHgWYyl/JiFeWWXSmNcFMmIRTAebP43fWvOQeiIgS7HSXKo39azo7dkaXDxxnX9tN/7etIGwp+cmuVdlTvCM274iAoQIvrvCO0JdTkf+NP8P19cq7ZxvJoz28UTIjX/QSWcJOUh9eV59dwOusUszbOR2SHUosuBP2Cgp84G+F6JfhXPWFWI7JQ==
X-Forefront-Antispam-Report:
	CIP:63.35.35.123;CTRY:IE;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:64aa7808-outbound-1.mta.getcheckrecipient.com;PTR:ec2-63-35-35-123.eu-west-1.compute.amazonaws.com;CAT:NONE;SFS:(4636009)(346002)(39850400004)(136003)(396003)(376002)(36840700001)(46966006)(5660300002)(81166007)(26005)(8936002)(4326008)(55016002)(70586007)(110136005)(82740400003)(83380400001)(478600001)(70206006)(966005)(186003)(47076005)(9686003)(82310400003)(54906003)(336012)(8676002)(2906002)(316002)(53546011)(356005)(7696005)(86362001)(33656002)(6506007)(52536014)(36860700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: arm.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Jul 2021 14:44:19.0471
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 1723dc0a-8217-4093-ded3-08d9529f58b2
X-MS-Exchange-CrossTenant-Id: f34e5979-57d9-4aaa-ad4d-b122a662184d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=f34e5979-57d9-4aaa-ad4d-b122a662184d;Ip=[63.35.35.123];Helo=[64aa7808-outbound-1.mta.getcheckrecipient.com]
X-MS-Exchange-CrossTenant-AuthSource:
	AM5EUR03FT020.eop-EUR03.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB9PR08MB7100

SGkgRGF2aWQNCg0KPiAtLS0tLU9yaWdpbmFsIE1lc3NhZ2UtLS0tLQ0KPiBGcm9tOiBEYXZpZCBI
aWxkZW5icmFuZCA8ZGF2aWRAcmVkaGF0LmNvbT4NCj4gU2VudDogVGh1cnNkYXksIEp1bHkgMjks
IDIwMjEgMzo1OSBQTQ0KPiBUbzogSnVzdGluIEhlIDxKdXN0aW4uSGVAYXJtLmNvbT47IERhbiBX
aWxsaWFtcyA8ZGFuLmoud2lsbGlhbXNAaW50ZWwuY29tPjsNCj4gVmlzaGFsIFZlcm1hIDx2aXNo
YWwubC52ZXJtYUBpbnRlbC5jb20+OyBEYXZlIEppYW5nIDxkYXZlLmppYW5nQGludGVsLmNvbT4N
Cj4gQ2M6IG52ZGltbUBsaXN0cy5saW51eC5kZXY7IGxpbnV4LWtlcm5lbEB2Z2VyLmtlcm5lbC5v
cmc7IG5kIDxuZEBhcm0uY29tPg0KPiBTdWJqZWN0OiBSZTogW1BBVENIXSBkZXZpY2UtZGF4OiB1
c2UgZmFsbGJhY2sgbmlkIHdoZW4gbnVtYV9ub2RlIGlzDQo+IGludmFsaWQNCj4gDQo+IEhpIEp1
c3RpbiwNCj4gDQo+ID4+Pg0KPiA+Pg0KPiA+PiBOb3RlIHRoYXQgdGhpcyBwYXRjaCBjb25mbGlj
dHMgd2l0aDoNCj4gPj4NCj4gPj4gaHR0cHM6Ly9sa21sLmtlcm5lbC5vcmcvci8yMDIxMDcyMzEy
NTIxMC4yOTk4Ny03LWRhdmlkQHJlZGhhdC5jb20NCj4gPj4NCj4gPj4gQnV0IG5vdGhpbmcgZnVu
ZGFtZW50YWwuIERldGVybWluaW5nIGEgc2luZ2xlIE5JRCBpcyBzaW1pbGFyIHRvIGhvdyBJJ20N
Cj4gPj4gaGFuZGxpbmcgaXQgZm9yIEFDUEk6DQo+ID4+DQo+ID4+IGh0dHBzOi8vbGttbC5rZXJu
ZWwub3JnL3IvMjAyMTA3MjMxMjUyMTAuMjk5ODctNi1kYXZpZEByZWRoYXQuY29tDQo+ID4+DQo+
ID4NCj4gPiBPa2F5LCBnb3QgaXQuIFRoYW5rcyBmb3IgdGhlIHJlbWluZGVyLg0KPiA+IFNlZW1z
IG15IHBhdGNoIGlzIG5vdCB1c2VmdWwgYWZ0ZXIgeW91ciBwYXRjaC4NCj4gPg0KPiANCj4gSSB0
aGluayB5b3VyIHBhdGNoIHN0aWxsIG1ha2VzIHNlbnNlLiBXaXRoDQo+IA0KPiBodHRwczovL2xv
cmUua2VybmVsLm9yZy9saW51eC1hY3BpLzIwMjEwNzIzMTI1MjEwLjI5OTg3LTctDQo+IGRhdmlk
QHJlZGhhdC5jb20vDQo+IA0KPiBXZSdkIGhhdmUgdG8gZGV0ZWN0IHRoZSBub2RlIGlkIGluIHRo
ZSBmaXJzdCBsb29wIGluc3RlYWQuDQoNCk9rLCBJIGdvdCB5b3VyIHBvaW50LiBJIHdpbGwgZG8g
dGhhdCBpbiB2Mi4NCg0KQnR3LCBzb3JyeSBmb3IgY29tbWVudGluZyB0aGVyZSBhYm91dCB5b3Vy
IHBhdGNoIDA2IHNpbmNlIEkgZGlkbid0DQpzdWJzY3JpYmUgbGttbCB2aWEgdGhpcyBtYWlsYm94
Lg0KDQorCWZvciAoaSA9IDA7IGkgPCBkZXZfZGF4LT5ucl9yYW5nZTsgaSsrKSB7DQorCQlzdHJ1
Y3QgcmFuZ2UgcmFuZ2U7DQorDQorCQlyYyA9IGRheF9rbWVtX3JhbmdlKGRldl9kYXgsIGksICZy
YW5nZSk7DQorCQlpZiAocmMpIHsNCisJCQlkZXZfaW5mbyhkZXYsICJtYXBwaW5nJWQ6ICUjbGx4
LSUjbGx4IHRvbyBzbWFsbCBhZnRlciBhbGlnbm1lbnRcbiIsDQorCQkJCQlpLCByYW5nZS5zdGFy
dCwgcmFuZ2UuZW5kKTsNCisJCQljb250aW51ZTsNCisJCX0NCisJCXRvdGFsX2xlbiArPSByYW5n
ZV9sZW4oJnJhbmdlKTsNCisJfQ0KWW91IGFkZCBhbiBhZGRpdGlvbmFsIGxvb3AgdG8gZ2V0IHRo
ZSB0b3RhbF9sZW4uDQpJIHdvbmRlciBpcyBpdCBpbmRlcGVuZGVudCBvbiAybmQgbG9vcD8NCklm
IHllcywgd2h5IG5vdCBtZXJnZSB0aGUgMiBsb29wcyBpbnRvIG9uZT8NClNvcnJ5IGlmIHRoaXMg
cXVlc3Rpb24gaXMgdG9vIHNpbXBsZSwgSSBkb24ndCBrbm93IHRvbyBtdWNoDQphYm91dCB0aGUg
YmFja2dyb3VuZCBvZiB5b3VyIHBhdGNoLg0KDQoNCi0tDQpDaGVlcnMsDQpKdXN0aW4gKEppYSBI
ZSkNCg0KDQo=
