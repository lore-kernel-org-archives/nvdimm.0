Received: from de-smtp-delivery-102.mimecast.com (de-smtp-delivery-102.mimecast.com [194.104.109.102])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4401F173
	for <nvdimm@lists.linux.dev>; Tue, 22 Jun 2021 00:16:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=mimecast20200619;
	t=1624320959;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=JUFrz8jC3dnsHao2y5xN/Wit902iYV28jfx6pgJQ//E=;
	b=bZF9bsGv6oihSitiUgGN+M8qegdeZHdCuTej155N84wld7aPDLAOB8IRNvpOQsUt6KdMaj
	SXMs1rZBIyoO3/5ccmeN8LnbjbiLhu8sOPTE7fBtemVX0Y8ULfOlfpftUPNIAuaDSKZAbu
	DHR5BK513N5zTZk2javP8yR+MvV/bRw=
Received: from EUR02-AM5-obe.outbound.protection.outlook.com
 (mail-am5eur02lp2058.outbound.protection.outlook.com [104.47.4.58]) (Using
 TLS) by relay.mimecast.com with ESMTP id
 de-mta-27-bBTgW7ihPZCj9VEolMBxYQ-1; Tue, 22 Jun 2021 02:15:58 +0200
X-MC-Unique: bBTgW7ihPZCj9VEolMBxYQ-1
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=AUFrc5jwqyJsPMg7Qsja3bvv5MrwxgsP4orZDw5V3dHy6TlTtS3bSTQ5iJFWv+pgbdh24vmrVriaJs1xPzGbWpJCd8E+grsH13qebL3+1SCrw6/N5ppeRDWnyCAiRnKhF8XfPMVTNo7KOjutP9aDQEzocpVMbDVeD/Okb1JdbySNPc1xHigrMx8ve+LOHWLMWKQSIPrB0npK6Tkjv/X8O9q/O2YKmmi/jxt2SihFofMFXOKeQUmNZT1cLc09J1M/daLrJTQBuGJVvE60g01/hjGeQkclD7yc3YAKQu/pTfDrDdESQ7rcWyXAXtecBMWpQYnYEQFTrhvwrzs5OTycww==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=gDFkyeUUX+GCiw5avQmVUPk20T7XmDgzJAC/mMhHVvg=;
 b=ixeX1YHycPHMAw/S/H2mID2EsHeRsOld2I41/eaYwUU+IbVP34lW9RafhJ8qvu2vhafPUAa2xoaxKmIgoop61iEWWfBpQh84KrZDvS53Y8NAiqO++v/TiY5QiiJnOw7pugc0WN5UB2z5fAWOgKM8IbuYrchSRy8VH7RpVk0VxnBaivDfvnS+GnkUllX81w7S5NVsAn5mRt5RK8VyyKU01H4dkEj0lNkPmZLgcSWuYJ9KiIkMJjISssnGEeQfRuS7mWMmh5CNgnvLC/cUAn8HVa25chLnrYRrhvaHYG95uy6oJf12kAOs/jOXQoWg1vW6/CP3tL9DI0DmG/Yjl3/bQQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=suse.com; dmarc=pass action=none header.from=suse.com;
 dkim=pass header.d=suse.com; arc=none
Authentication-Results: oracle.com; dkim=none (message not signed)
 header.d=none;oracle.com; dmarc=none action=none header.from=suse.com;
Received: from VI1PR04MB5325.eurprd04.prod.outlook.com (2603:10a6:803:60::14)
 by VI1PR0402MB3775.eurprd04.prod.outlook.com (2603:10a6:803:1a::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4242.18; Tue, 22 Jun
 2021 00:15:56 +0000
Received: from VI1PR04MB5325.eurprd04.prod.outlook.com
 ([fe80::8c62:9178:f0e0:791d]) by VI1PR04MB5325.eurprd04.prod.outlook.com
 ([fe80::8c62:9178:f0e0:791d%7]) with mapi id 15.20.4242.023; Tue, 22 Jun 2021
 00:15:56 +0000
Date: Mon, 21 Jun 2021 17:15:48 -0700
From: Luis Chamberlain <mcgrof@suse.com>
To: Jane Chu <jane.chu@oracle.com>
CC: Dan Williams <dan.j.williams@intel.com>, nvdimm@lists.linux.dev,
	mcgrof@kernel.org
Subject: Re: set_memory_uc() does not work with pmem poison handling
Message-ID: <YNErtAaG/i3HBII+@garbanzo>
References: <327f9156-9b28-d20e-2850-21c125ece8c7@oracle.com>
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable
In-Reply-To: <327f9156-9b28-d20e-2850-21c125ece8c7@oracle.com>
X-Originating-IP: [173.239.198.97]
X-ClientProxiedBy: SJ0PR03CA0173.namprd03.prod.outlook.com
 (2603:10b6:a03:338::28) To VI1PR04MB5325.eurprd04.prod.outlook.com
 (2603:10a6:803:60::14)
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from garbanzo (173.239.198.97) by SJ0PR03CA0173.namprd03.prod.outlook.com (2603:10b6:a03:338::28) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4242.16 via Frontend Transport; Tue, 22 Jun 2021 00:15:54 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 31d1c30e-2818-4db7-e96f-08d93512e766
X-MS-TrafficTypeDiagnostic: VI1PR0402MB3775:
X-Microsoft-Antispam-PRVS:
	<VI1PR0402MB3775C3354C87B239F9E515CEF0099@VI1PR0402MB3775.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:1186;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	vTUVNF5Zm9kko38Y4D2DGzM1LdhXqTKUwTvb51GdP7hHuU39DNaHmEBcEg54bkTT6s5+FenksYVKqXFA1RNP1PPgn21RHSqIra4fJf098P32NSlOI2iHuYzK9AZCsSkx+tC29tf3lD9D6xjs4aM82ZqCKoAp2bFc+06vrBSRve/1mmLqH48lntnoJNnkqf8x97pHK9aLM8NtwMuVVWH5pU2jGI79k6C8ca8r4utEDkrrH8v6XzTCDRHVVJ/BuIua/V6NQyFcRJd3vDHzWALvHK+6M2nGOoodAzlCDei1fWZqETcR4YQoFxAH4PBop44qcNJuqYD/6n46uLblthQMCci6XLd39EjsXOlQzsxaiupLa9hXUtdE9PSBtMtlYdh77dom0MGLYdkis2hG7s5IywBdkZ/iyfFFcSOpZoHATxi8W6pfIWg/TpgBqpWv/rAInkZarlptWIMTkpWD55EbBl/c5fRmu9p4QhezN5yunQrrZE8oePfn0RebdwiOmnOMwoKl374KjmYqbtf5YI1AZ3xmU/0mx3m8HDd2QxJCXIMuYbuiLQvX9yJ/K7Budw1Fcb4pApuQffAEsrk3sf74cL75caJ3n9l4D5IEUB2NdXdikzGHit0kl3kVKEatItPsVJRdiX8VDx2PQ8QPaatc7w==
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5325.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(346002)(39850400004)(136003)(396003)(366004)(376002)(9686003)(55016002)(55236004)(26005)(186003)(16526019)(5660300002)(6666004)(6496006)(83380400001)(33716001)(478600001)(2906002)(38100700002)(4326008)(66556008)(66476007)(6916009)(66946007)(316002)(8936002)(8676002)(9576002)(956004)(78946002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?yEt2xorD1e/YVnRW+Ve83/Pak+wYKUZDHMdGTE3aAMZRTzZ0Fmv025WrS97/?=
 =?us-ascii?Q?d68pptO0sXtpppD2q/pJOVTUsiK8wKFaiUvrOAkE0zsION58Zt+rlXfsYgvy?=
 =?us-ascii?Q?1HmbC9FgrH8PIoa6o0qXLqEqbKp7B0Pz1Ny3FIvHip0wgd3tnU6EzpvD1SWf?=
 =?us-ascii?Q?Lgvnt/V5Hy5u9ubTkzc+EpkLMig/V1ILyLHdbBDd7DgRKu0nqhGoUp7M8fdU?=
 =?us-ascii?Q?AFccVbrTs5MMWEuTAWBKwyZKtRhbooSxAfRv5CnfVuLSd/eBdbpno1Sqm7sj?=
 =?us-ascii?Q?6I16EFt9KAL2ErsNUsZeuEJ8xpqj81K98Kko3Qm5a/PaQesA21kW7d3oVZIb?=
 =?us-ascii?Q?WVonjpmK3+InZ2FhgFr1MOInpgW8JU1BseXDMzqMjzLF2IkSqgVuI5X1q9tH?=
 =?us-ascii?Q?+5QVfh9yVXyqO9JXAnchn3yreo+dWfVv25goz0AH/9P4f8XWKW1i883k9Jqv?=
 =?us-ascii?Q?jRyyVbezjeex7pasNXEYNT8yQ57O95hNO1OpNBqj7wpI5z2KYH23taiZJGko?=
 =?us-ascii?Q?rEik1d8zgB7OU6gXEiYCgIANHiu5tVH/ookf+T8JjWzFU2YGT63IYQZzEZ15?=
 =?us-ascii?Q?hm1vpB1SWhp+O0ywwIMdupelCs56NvFUKGX+a75u67+sudkjbi8yr6gECpJK?=
 =?us-ascii?Q?KE2kyFZPdxVT4ad8aHwVtQRFmChRjmCPCjGDw4pMp512UPhxynXQMJwBQkVg?=
 =?us-ascii?Q?H0dUmjZxM/JOHw+Afjz0zojNh1zjqHpJFZo1UjMQ3N8KMCtMoVp7MvzrM/EU?=
 =?us-ascii?Q?+rI6AraTLUHQbGDtL9dCFIdOfNFaokcEVvFN+Y6vUtUeJcODgK8C0WJMeRyA?=
 =?us-ascii?Q?XLl6c1a1FugFxrTeSH0AMqbhJmlwXvRTl3VfkJ/XMfoI/ahb1GwC+nZLqeXR?=
 =?us-ascii?Q?Dcm8V96Uxs8JZJ9S3ALoY8bNswk6RRUOGYn3IKVwgQtZ1YTFYsG5W0H9zc1u?=
 =?us-ascii?Q?1h0DzeJ87wpNJOAPttuzCDVHygoqzraEUNQLIfgi5IcJtR917ORDbbbjsPCV?=
 =?us-ascii?Q?6G1IhQTeUV89URv9f0EHC+OPPfmyBvaoDxWPQ5YJIXQurlTTGhTci3ThjtKb?=
 =?us-ascii?Q?ok+mRq24UlpclZAnP3gZC5oN3EQOoTH4Ouvdvc8cRRMPwJ1ZH260gdP4lBrf?=
 =?us-ascii?Q?BAX6bEyLQax9AGPDHcgzRkao0sRRTWJq155MdE3fX+j2LsX4+rpWOj/HdEfe?=
 =?us-ascii?Q?HO4fiy7Hbpkp+6I5pjTpW1PGZM/wK4au/mYVtXqAXpcgXqbV+b+hUUPeZE5I?=
 =?us-ascii?Q?Lzx4cp+Gi/YdHODLTRglSKP+UiIQ2Qa5+Ju7YRqPMQbYEfjrasN0t+lwyQCQ?=
 =?us-ascii?Q?GdbcJn0IS4U7b+HoK29qxL+b?=
X-OriginatorOrg: suse.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 31d1c30e-2818-4db7-e96f-08d93512e766
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5325.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Jun 2021 00:15:55.9139
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: f7a17af6-1c5c-4a36-aa8b-f5be247aa4ba
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: KweVncLN9WQeb0zc60sO3XH+6XIYEQ4jnA5WAGGD4rxG23LZOBx0z3aNMm7sbiPnEdWVJQzVa6dqBIAruQKGu4MpsiWB6mI3PrGsvo+UgGI=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR0402MB3775

On Tue, Jun 15, 2021 at 11:55:19AM -0700, Jane Chu wrote:
> Hi, Dan,
>=20
> It appears the fact pmem region is of WB memtype renders set_memory_uc()
>=20
> to fail due to inconsistency between the requested memtype(UC-) and the
> cached
>=20
> memtype(WB).
>=20
> # cat /proc/iomem |grep -A 8 -i persist
> 1840000000-d53fffffff : Persistent Memory
> =A0 1840000000-1c3fffffff : namespace0.0
> =A0 5740000000-76bfffffff : namespace2.0
>=20
> # cat /sys/kernel/debug/x86/pat_memtype_list
> PAT memtype list:
> PAT: [mem 0x0000001840000000-0x0000001c40000000] write-back
> PAT: [mem 0x0000005740000000-0x00000076c0000000] write-back
>=20
> [10683.418072] Memory failure: 0x1850600: recovery action for dax page:
> Recovered
> [10683.426147] x86/PAT: fsdax_poison_v1:5018 conflicting memory types
> 1850600000-1850601000=A0 uncached-minus<->write-back
>=20
> cscope search shows that unlike pmem, set_memory_uc() is primarily used b=
y
> drivers dealing with ioremap(),

Yes, when a driver *knows* the type must follow certain rules, it
requests it.

> perhaps the pmem case needs another way to suppress prefetch?
>=20
> Your thoughts?

The way to think about this problem is, who did the ioremap call for the
ioremap'd area? That's the driver that needs changing.

  Luis

