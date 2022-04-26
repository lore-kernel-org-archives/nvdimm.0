Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10olkn2017.outbound.protection.outlook.com [40.92.42.17])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6CF7C33C3
	for <nvdimm@lists.linux.dev>; Tue, 26 Apr 2022 20:53:05 +0000 (UTC)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=VIzoa2r5vX9h8keabp/ZzB1giB5K839+9JcKupODbF2496EMu7BO3fwFOqdusOdtIvFJww5Fba3GCrIsDPzU8Vs9/gtlGW+x2PDaEL8pqn0XcUxyfriyUJY36rz0W2lC6SqOFzfg3McBGKvcJUFnpkgi8eQXw60MMsnCVChZpxMs6CcrhfCJFkiJBCTdMl/NjRAMNRwLHcnkGzru00x7kUAjkIVDWndbVb3yrRp9CZ2V98Qow/YEh+lVDUonhrdGnb7AtWiD64IUmZH2PqgYKejA6qywL60qY09uL9ZPYCbvnTv2dbEEhp1AqlXnLmCLxdZ08yS0eO01qrT2Mxr8Fg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=p9BhG5lVJ3pfmfEwdbRzlRTERBQxRTcyHKzew/6r7FU=;
 b=afe89sHClz0f2NkkbLQQ7tHyOqPN4p8JanzJA3GGijP0dhvBkVN8x+BtbS8v/hBVgZsa6Y80zuWp8DyNUXHdYldhU5BsYLbH0mRXa7ekf6R9xBpxxT5gxtE4NHc9QWZpu9czW4z6EtZQVzzVzCMzWtHIJyl0B2CbFxBpFS1awje0KXcukJaG+QPMMASQNqEnHuY9mcntfMOFzH9cWj4P+E9e4mhxkmuunfBv/EJvm9eOHmfFbWWAkFlDLYSAiD8eS35vKjRbcTRyNjjnAgHIyvGvjLwR6Luv4F+Nqea4afrqC03f+AJl9cR+6U2PiyDFuJxnm+xaEKXtJ9JPPTf5LQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=hotmail.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=p9BhG5lVJ3pfmfEwdbRzlRTERBQxRTcyHKzew/6r7FU=;
 b=kUKRdxOeeJ+NOwiX++oAOEu74Z/Pu7ylLjk8H4JQCBVpGcwW15iQURcGIzPr9uv2XLp8LrXFgO0iuYEc1aUx4FodeJtpVNABa2ULXuBJ57he7U7t4Lj7ELiBgrPGv15nEU8YyEPTL4RnNz7d6ZeNNRTrM/qkR63wb3s/U78VivXmvDQW3GKQj2yu1ufdFG/w0a1FGa5H/R0f9j1gAUjEmOePGsmJkAIIQq3ajGqXJNV+GvJGwkMTTh6hTZHF1pDiSJFZhGQfy7C+4loFwPkVhfWZNJltpRF0eX4lveY6c2nqcyu/3SjHzv9ipX9MsTQ7XJp8efWnMYxgPUQ2bUiYEg==
Received: from PH0PR18MB5071.namprd18.prod.outlook.com (2603:10b6:510:16b::15)
 by PH0PR18MB4624.namprd18.prod.outlook.com (2603:10b6:510:c4::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5186.21; Tue, 26 Apr
 2022 20:53:04 +0000
Received: from PH0PR18MB5071.namprd18.prod.outlook.com
 ([fe80::cc99:a515:38e8:2f9e]) by PH0PR18MB5071.namprd18.prod.outlook.com
 ([fe80::cc99:a515:38e8:2f9e%5]) with mapi id 15.20.5186.021; Tue, 26 Apr 2022
 20:53:04 +0000
From: An Sarpal <ansrk2001@hotmail.com>
To: "nvdimm@lists.linux.dev" <nvdimm@lists.linux.dev>
Subject: How to map my PCIe memory as a devdax device (/dev/daxX.Y)
Thread-Topic: How to map my PCIe memory as a devdax device (/dev/daxX.Y)
Thread-Index: AdhZr3Dz3peOUCWVT+66vwkDKQ0fFw==
Date: Tue, 26 Apr 2022 20:53:04 +0000
Message-ID:
 <PH0PR18MB50713BB676BBFCBAD8C1C05BA9FB9@PH0PR18MB5071.namprd18.prod.outlook.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
x-tmn: [k+p9a+9IH3LZ8LhQnG0dVliMJeGVqQ7r]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: dd9ed544-2676-4805-8591-08da27c6c233
x-ms-traffictypediagnostic: PH0PR18MB4624:EE_
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info:
 ZhfR7Innoq9yCNr5I23dWkL9c+DiM4cU9x2i71w8orBypwMCfgJwYPMwpNLbB6xuFl3Vvjp+JjHcRMEAoFniGpK6Ei71hSAugU2Qb8uDzSZJ+TIyvKMqaULrFmbo24y1mOgpFa998K/3LTD1bnfuPE8aW1b0O+Z7dygHGd3qiEGQQldgme8Edm3Cs4W83kCZ26Myait1xcnDLVPbF9DLOMpl/8I8BstXutVp7oWBcTsCtIb4FAqcFRdcz/3iajVlTIlEXJhjlSxblsLfHaBThLrWkTmGrhLp8TasTFnjkwhserY81oJ1COTPRQzpS+vWDMqkeT9WgKZ2ussZNNnIGtt3sSHL7b+G5n9fSLoGX67A/l2efWC7FEms/vCHpbPc5iD352GgTI6touowL+yOGWXu+TRI7idwV+qhUYRQRVHrD8OCe8VTZF28RYlA84+uKH/gB7jZyHn5YzXmW2bF3QvPSRG0MM1XuLnk4GHa5keZZz3HTtDyCkLmjgxUm7A+N1yLMfuK4BCBWq1XVj34DeheEQydM1TEgw+wo3oz9ggHnZn4W+OTaCkyKS5jwY9D4tDxtN9+x3eaQaijCk5mtQ==
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?us-ascii?Q?fPs7M2UjsjyDq7n1znoFOoKPUiCt52YhlvUnZ45zxIQ9G8DdGr0tkW46wcKn?=
 =?us-ascii?Q?L55FB6BCr+Zq2wi/l5i7xoo0Ud8bouN8JrvYKmhww6tpJF+cZmlkIN7zHeli?=
 =?us-ascii?Q?Oa47cIHl4B0ngU4dectTs6e/f5i0aH11D2TPwbon6L002cALjM/ZdhMqs1m3?=
 =?us-ascii?Q?5yliF31Ijm9ItvzIEjBpMLpJmc9M1aZBJfYJgxWr3rw+MAzVno4iWiexV6hd?=
 =?us-ascii?Q?Og7xoNbN/shnNw3OYypG7DGfLM6wGZ1tExqyKUaBEGyS0Qvun/A8rEfUlVnA?=
 =?us-ascii?Q?zm/Ec1s805QEOyHl6lHvMnrMxiT7PYT+Xcj12ztvkUxHyTse9cm7k1zuGsM8?=
 =?us-ascii?Q?lTl2BhowjRzJ6y5nkSnLgiAxr3UBCobwHucMWHzW2PGPInIzqz7E3ZeXQYJ2?=
 =?us-ascii?Q?oBxD+5JrjSEndJ+1orYMa9w86Bq90BaHPohY/mUb239hSzDzEqgNxSHS5rCl?=
 =?us-ascii?Q?9SAWT2gD/EE5Sw56FmPzjOUpBpS8CSuAvEz4Qr5qfOq3ri9Zth1i5o1nMYTm?=
 =?us-ascii?Q?kWQ+4D8y6JL96N7yGt4/sG773DFbEvlOWqFijyftMbefSooxk6qJFtExtvqY?=
 =?us-ascii?Q?vKavfLvYqUHc1p2B+AXOs/wRRYkTTnp0//ikBny0ELzx7pUkHYooIPLkR5gc?=
 =?us-ascii?Q?KHYgAk5unGXbkkepDJSwkgQ9j17HKUDoTiBHrgffMQ0A2rN44yVrIr3r7Dl/?=
 =?us-ascii?Q?f9cTZjzDwQqk6n0n2UIoRLhV8pZzMh1rCvRCbd/ZM0molv5tqXO+UTdKh9NR?=
 =?us-ascii?Q?eG7ZZZOsaki1NNQU0a8oNJhG4AQyPqa9u+ktaOElPHgL5IAJw/pyv4TwN9Lt?=
 =?us-ascii?Q?Qc/0HreAYIvG12psY0bfQz8lbpyUfZuI5uo+FCWa5hz2EZmVo5t8qZKyu1yg?=
 =?us-ascii?Q?Y0jylUFNVRrlNa7I2cm+Avg03QHaohwRRsr/keTYTa3U7FT+BOEdePMpdL70?=
 =?us-ascii?Q?UAFnVkm5bunBC0RhzS38M5P/YBi4ZIeD30ufeTwNJTVysvHEt02W3oHvNWnB?=
 =?us-ascii?Q?/GIIjhHp2lkzPsPUi359RKmjWp4Y/0Ygw81k1bhgd5z+MT9ALbjmiqQwZkUL?=
 =?us-ascii?Q?+iyjITdqU3bvV+XcChAHHdZOLpu5UvRBlgqhMbeKJ/2fXwzUhT5AwV1cMH6R?=
 =?us-ascii?Q?Sb8QqGKOP77dRXl9v7083Y5ODWSxkZPLCIy48mbGcYQsj4vE0arO9/rusobj?=
 =?us-ascii?Q?RfNTIhYKHlqiUNly2qQg5BPrYnBVLUs8PQFQZ63uRdBgmG70XBubH70g+1GN?=
 =?us-ascii?Q?x22Par8yUujmbqdXIPu5VurkDxx2NLNcLxHVvvXmfY9pIyXlGd5RGY6+CJfu?=
 =?us-ascii?Q?YDZtT7uyyo6Ez7eoTh93k9LwcMcMQDpy8186yu4AxhoPLdwH0xAzDDZVQXwe?=
 =?us-ascii?Q?GnClu7JwASlVa4AUADasLDOu74LNm3nQ4rzqtvh1Xdom9pIkQNaG4m4vZOjK?=
 =?us-ascii?Q?va7c1X3GKgs=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-OriginatorOrg: sct-15-20-4755-11-msonline-outlook-db494.templateTenant
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PH0PR18MB5071.namprd18.prod.outlook.com
X-MS-Exchange-CrossTenant-RMS-PersistedConsumerOrg: 00000000-0000-0000-0000-000000000000
X-MS-Exchange-CrossTenant-Network-Message-Id: dd9ed544-2676-4805-8591-08da27c6c233
X-MS-Exchange-CrossTenant-originalarrivaltime: 26 Apr 2022 20:53:04.0885
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 84df9e7f-e9f6-40af-b435-aaaaaaaaaaaa
X-MS-Exchange-CrossTenant-rms-persistedconsumerorg: 00000000-0000-0000-0000-000000000000
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR18MB4624

I have a PCIe FPGA device (single function) that has a 2GB RAM mapped via a=
 single 64-bit PCIe BAR of length 2GB.

I would like to make this memory available as /dev/daxX.Y character device =
so some applications that I already have that work with these character dev=
ices can be used.

I am thinking of modifying drivers/dax/device.c for my implementation.

To test drivers/dax/device.c, I added memmap to my kernel command line and =
rebooted. I noticed I have /dev/pmem0 of the same length show up. ndctl sho=
ws this device. This is obviously of type fsdax.
I then ran ndctl create-namespace -mem=3Ddevdax on this device which conver=
ted it to /dev/daxX.Y.=20

When I ran ndctl that converted from fsdax to devdax, I noticed that the pr=
obe routine was called with the base and length as expected.

So I am hoping using drivers/dax/device.c is the best way to go to expose m=
y PCIe memory as /dev/daxX.Y.

Or maybe there is another option.

Thanks a lot in advance,
AneeshS
