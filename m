Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=40.93.195.15
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1795627798;
	b=NbgORLrXlnRButNtgBHOcPTmrHt1BJlyVFmlmQ9NOyPdTyePBnzrGlamDYGWAiYVUc74
	 9LfZ9KCgONhvHS2g4tXFw9gjRtTPPsYwklKPVmesAS0hw0V9zNovTGUGbfdWr4qe/BGtK
	 aYWPU4ZsCzTL9+6Xai4/TSlXmoHYou5o3QPIWYEwIOi0nhcdi+Saw7p/b8835Kqgpohz1
	 OEbYtGms7T/cdGF1IiTMs8jwKm2JPWaRGuMXFCMNRFtYUPKcFcQh+WNtV5Sr9BiDMj+Bj
	 pQj6OaAOFW31QuTnlT0YaXhwr2akplJ+e2mZJ43R0tinGjqvgS0VDr6AW6I52poJmYg==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795627798;
	h=DMARC-Filter:DKIM-Signature:Received:Received:Date:From:To:Cc:
	 Subject:Message-ID:References:Content-Type:Content-Disposition:
	 In-Reply-To:X-ClientProxiedBy:MIME-Version:X-MS-PublicTrafficType:
	 X-MS-TrafficTypeDiagnostic:X-MS-Office365-Filtering-Correlation-Id:
	 X-MS-Exchange-SenderADCheck:X-MS-Exchange-AntiSpam-Relay:
	 X-Microsoft-Antispam:X-Microsoft-Antispam-Message-Info:
	 X-Forefront-Antispam-Report:
	 X-MS-Exchange-AntiSpam-MessageData-ChunkCount:
	 X-MS-Exchange-AntiSpam-MessageData-0:X-OriginatorOrg:
	 X-MS-Exchange-CrossTenant-Network-Message-Id:
	 X-MS-Exchange-CrossTenant-AuthSource:X-MS-Exchange-CrossTenant-AuthAs:
	 X-MS-Exchange-CrossTenant-OriginalArrivalTime:
	 X-MS-Exchange-CrossTenant-FromEntityHeader:
	 X-MS-Exchange-CrossTenant-Id:X-MS-Exchange-CrossTenant-MailboxType:
	 X-MS-Exchange-CrossTenant-UserPrincipalName:
	 X-MS-Exchange-Transport-CrossTenantHeadersStamped;
	bh=gtE1ORfttJBbVDCk2rU4kzSWC8bZM3qjD/p/ShxG7IQ=;
	b=Rf7odWkTrys5+Ge3WCK2EFzSAV1ADl6KP91CPVOC1u1W/FtnoBHAEAo7wXWhrZjECuGH
	 cJKzsE7wYvt6sSvlJxVpgql4A/BeoxhCiIAUrb77FYUF4TdD9qQS40NzFXl1q5yKafcth
	 UQyPsIT0Mtjv7BlACMAsQv7gVsovdm4zV7IwLqQ6ic6MLSq8HTFlplNHuTDK/rMAW17pw
	 rmpSeKeGnvvjSfxcJMe9laQ1aZq6utWBzbnhnB4qbAT1U4M1gotKnsGIdfXbG+k7yi7eT
	 ALVODYtRMW9+c4FI71FQ2D9t6nbZ0dJEUqjq3u8vQt89ijxu90F7ZrlUdKzoj5DHaLw==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=nvidia.com;
	spf=fail smtp.mailfrom=nvidia.com;
	dkim=pass header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=BgYpbJea;
	arc=pass header.oldest-pass=0 smtp.remote-ip=40.93.195.15
Received: from SN4PR2101CU001.outbound.protection.outlook.com (mail-southcentralusazon11012015.outbound.protection.outlook.com [40.93.195.15])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (secp384r1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CA853606A330;
	Wed, 25 Nov 2026 17:29:57 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org CA853606A330
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=BgYpbJea
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=XGv8ggejiKYgRA4XwsTymacWQ39bbQUHST68Bl4b+D855cbhD0+SM76FGtqkw/uEBgvr0Diq6czkq/U1hBs+jntAbNCa81KMU+V1sp7Wus2Khg6YbBk/9NCbc89LF20N8F4G6NHphoIibHajoYmzQO4Ez1cUyINdwt0XUuuAhyAC4Uv6i0QWisb2RmbdJFaFbvp9VUfvvAXFG3QGOarzKGR6ZMVGMeDgjwqoBD4uenQUH9Ijc/widgZTXNmcFsZcKlW9EK+ytGpDKQpaB3+t66nrsTeGCxEiNNWNPy4cpKHB9YEHFUFjBfeXSTNI2JieRrW6v8lbn0ndoVZweBwuHg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=gtE1ORfttJBbVDCk2rU4kzSWC8bZM3qjD/p/ShxG7IQ=;
 b=L7McMASK1mUIcTk3hOiBE1eSm0Opyij8BXpuI8L1xfr4QYaGwo2AKVTLC3Z2O0t2vzHBPShnVDZMDI/CKws+tHVm+re1TQJaFAaEAKOg50VvKfl7trCsEIz3SbzZ7kGNE4DxvExVnf2AJ41dtD6SUQ4Xq1amIWscv/teKagIQ1wJpkSin1SHqnrIOeP2l7XgPBVZV9DPTvApBl7lOCVj8JGBfB6fh/2LoFFMZSxFyQX9M5ByZLsL6Uq745qwQNIC28qJ8bWfVXxOPyaXiuY2WB0coDfslcvd+3I/VcEAVN9eXtACHSgesal98xI1SgttWF3MrAAN0QMX3oTLR1fL7g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=gtE1ORfttJBbVDCk2rU4kzSWC8bZM3qjD/p/ShxG7IQ=;
 b=BgYpbJea/YbiFFCZEzOo8FWTJ9qPRWfxAA9ZGBLGhBAAI8CVXdn5P2QftclCa74HmxwRqwzR22aMHjpRSfZ3+2731EcG2pk1H+G7XqjGBYsHiD9fMQBSWiK25gvee5hE8PibETajrBS8MZFeNMa8CKgcatA/PZ/fR/5w0R3e6JXzSMWpSAbViL9MqwdJudK2bI1E9oTg3RByg3Fjfh/cNstV3r1aHQSt4oT5HX4wTHR9Ez2xGfuMUvZxPv+Vg9nVNm121XDPiY0A5Opc2kK2ilEXAlMeyE80Dw8UotYrFXr3KWx3dfw/g8LeW2B3VRqaS8OHK1tRuNYOFgJYBvM6sQ==
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from SN6PR12MB2814.namprd12.prod.outlook.com (2603:10b6:805:72::33)
 by CY8PR12MB8314.namprd12.prod.outlook.com (2603:10b6:930:7b::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.639.14; Wed, 25 Nov
 2026 17:29:49 +0000
Received: from SN6PR12MB2814.namprd12.prod.outlook.com
 ([fe80::9a18:413c:9702:8f59]) by SN6PR12MB2814.namprd12.prod.outlook.com
 ([fe80::9a18:413c:9702:8f59%6]) with mapi id 15.21.0639.012; Wed, 25 Nov 2026
 17:29:47 +0000
Date: Wed, 25 Nov 2026 12:29:46 -0500
From: Yury Norov <ynorov@nvidia.com>
To: "Gregory Price (Meta)" <gourry@gourry.net>
Cc: Yury Norov <yury.norov@gmail.com>,
	Rasmus Villemoes <linux@rasmusvillemoes.dk>,
	David Hildenbrand <david@kernel.org>,
	"Liam R. Howlett" <liam@infradead.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Mike Rapoport <rppt@kernel.org>, Michal Hocko <mhocko@suse.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Oscar Salvador <osalvador@suse.de>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Brendan Jackman <brendan.jackman@linux.dev>,
	Zi Yan <ziy@nvidia.com>, Jonathan Corbet <corbet@lwn.net>,
	Shuah Khan <skhan@linuxfoundation.org>,
	Randy Dunlap <rdunlap@infradead.org>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	"Rafael J. Wysocki" <rafael@kernel.org>,
	Danilo Krummrich <dakr@kernel.org>, Johan Hovold <johan@kernel.org>,
	Joshua Hahn <joshua.hahnjy@gmail.com>, Rakie Kim <rakie.kim@sk.com>,
	Ying Huang <ying.huang@linux.alibaba.com>,
	Matthew Brost <matthew.brost@intel.com>,
	Byungchul Park <byungchul@sk.com>,
	Alistair Popple <apopple@nvidia.com>, SJ Park <sj@kernel.org>,
	Ingo Molnar <mingo@redhat.com>,
	Peter Zijlstra <peterz@infradead.org>,
	Juri Lelli <juri.lelli@redhat.com>,
	Vincent Guittot <vincent.guittot@linaro.org>,
	Dietmar Eggemann <dietmar.eggemann@arm.com>,
	Steven Rostedt <rostedt@goodmis.org>,
	Ben Segall <bsegall@google.com>, Mel Gorman <mgorman@suse.de>,
	Valentin Schneider <vschneid@redhat.com>,
	K Prateek Nayak <kprateek.nayak@amd.com>,
	Kees Cook <kees@kernel.org>, Kairui Song <kasong@tencent.com>,
	Barry Song <baohua@kernel.org>, Qi Zheng <qi.zheng@linux.dev>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Axel Rasmussen <axelrasmussen@google.com>,
	Yuanchu Xie <yuanchu@google.com>, Wei Xu <weixugc@google.com>,
	Baoquan He <baoquan.he@linux.dev>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	Michal Hocko <mhocko@kernel.org>,
	David Rientjes <rientjes@google.com>,
	Pavel Machek <pavel@kernel.org>, Len Brown <lenb@kernel.org>,
	Nico Pache <nico.pache@linux.dev>,
	Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>,
	Lance Yang <lance.yang@linux.dev>,
	Usama Arif <usama.arif@linux.dev>, Kiryl Shutsemau <kas@kernel.org>,
	Xu Xin <xu.xin@linux.dev>,
	Chengming Zhou <chengming.zhou@linux.dev>,
	Lorenzo Stoakes <ljs@kernel.org>, Pedro Falcato <pfalcato@suse.de>,
	Jann Horn <jannh@google.com>, Chris Li <chrisl@kernel.org>,
	Kemeng Shi <shikemeng@huaweicloud.com>,
	Nhat Pham <nphamcs@gmail.com>,
	Youngjun Park <youngjun.park@lge.com>,
	"Matthew Wilcox (Oracle)" <willy@infradead.org>,
	Jan Kara <jack@suse.cz>, Waiman Long <longman@redhat.com>,
	Ridong Chen <ridong.chen@linux.dev>, Tejun Heo <tj@kernel.org>,
	Michal =?iso-8859-1?Q?Koutn=FD?= <mkoutny@suse.com>,
	Dan Williams <djbw@kernel.org>,
	Vishal Verma <vishal.l.verma@intel.com>,
	Dave Jiang <dave.jiang@intel.com>,
	Alison Schofield <alison.schofield@intel.com>,
	Shuah Khan <shuah@kernel.org>, linux-kernel@vger.kernel.org,
	linux-mm@kvack.org, linux-cxl@vger.kernel.org,
	linux-doc@vger.kernel.org, driver-core@lists.linux.dev,
	damon@lists.linux.dev, linux-pm@vger.kernel.org,
	linux-fsdevel@vger.kernel.org, cgroups@vger.kernel.org,
	nvdimm@lists.linux.dev, linux-kselftest@vger.kernel.org
Subject: Re: [PATCH 00/60] Private NUMA nodes
Message-ID: <awcbCkFUNfBp3ANM@yury>
References: <20261120-private_nodes_v6-v1-0-74f5f9a115c2@gourry.net>
 <awMdeK8O-5mffg2m@yury>
 <179537469194.412063.13456998694958645706.b4-reply@b4>
 <awNavE8dAGr-amfQ@yury>
 <179542121527.412063.3452837736734095837.b4-reply@b4>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <179542121527.412063.3452837736734095837.b4-reply@b4>
X-ClientProxiedBy: MN0PR04CA0019.namprd04.prod.outlook.com
 (2603:10b6:208:52d::33) To SN6PR12MB2814.namprd12.prod.outlook.com
 (2603:10b6:805:72::33)
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Post: <mailto:nvdimm@lists.linux.dev>
List-Help: <mailto:nvdimm+help@lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
List-Owner: <mailto:nvdimm+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SN6PR12MB2814:EE_|CY8PR12MB8314:EE_
X-MS-Office365-Filtering-Correlation-Id: b5d88457-3d2b-4b10-0448-08df4b19b3e5
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|1800799024|376014|7416014|23010399003|10070799003|261009223027099003|22082099003|10067099003|18002099003|6133799003|261028144727099003|261026140227099003|261021123027099003|261102123227099003|261022105027099003|261022075727099003|261021121427099003|261026121527099003|4143699003|56012099006|5023799004|11063799006;
X-Microsoft-Antispam-Message-Info:
	S6a7ir1CjBjuN1oV+qaB35nNB4bQGn5y/wfHeFzO4FdU0Ur+JtBtCwKtb05ZDx4TsmyJ7AZCB4neEi96R+tWIJ/vBRRJqmwzBN2EynZNaUXfjL2lQL8YfHQ+N7c7+BTWXC6kaSRNjbw9rltkecIxW66pAmiNs4HckJfh+mMI+ybrywCiWzomYg8BY23U1IhsQwIJldYP9UPHRv/VtjujSDL9EK/l2Ov6HXWKXEl32IOHcXjCE3DTbxyPlntX0P9KTmcG0mS1bhFZquxoNz8T+Tpdcb0bsB0Twwn71THBuWTDNKB2t8Xvvxd3HQQv4GGq9vEau9z45W6RogYZ40BKRo9ay9PbDtAw3OTBNsEPD+Kt4xrIE+44MuschiBtQZJDqiS9eOvOKttEHDBG7XG+AzeDp8ta5cMyj3j7eb0qQuoUzl1DofDGnML9M0dm3aQiWwvgg0mlYPelqgWFsxt+UPZx64nqsYOWrZfsoa20WbdXUcQajmuyaOAOUEryE8lyS9aVtMBx1Amdl5tmX4d18IJs5tX8Jczw77t+I5tVc0sAaslUw89bmF+yFasSujac/87ggGXVE/u6aI22ynHtdssBBlIPBuJ+zgcA/ShWUzJ7UgU8D5hFaqgONzoJ0TbKcYyiL1TsX9fpKwnm/xpe9mU5fYNYuibSpYeVzbTXl54=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR12MB2814.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014)(7416014)(23010399003)(10070799003)(261009223027099003)(22082099003)(10067099003)(18002099003)(6133799003)(261028144727099003)(261026140227099003)(261021123027099003)(261102123227099003)(261022105027099003)(261022075727099003)(261021121427099003)(261026121527099003)(4143699003)(56012099006)(5023799004)(11063799006);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?wJ3WfKdNOzaNDTQKLpLp26qyY/Yenu41z+NJ6qCYXXXBOYbXGa/jxipQYAfi?=
 =?us-ascii?Q?/RH8t+w7BabiOqko9r+QLr/z+Ez9mPVfX4EIjxEHrCNtPq5PZs1oBphPV9U7?=
 =?us-ascii?Q?CQNmDqYaNLkXZg1xKQZLOqPVlJ5m9VMLe9i6w6XfwqJkkRtzXNK+dn6fgeKP?=
 =?us-ascii?Q?P0Nwy8FmrVad4YE7kA4Sqv+QMuPbPQgpzveFino/VDckdPK8pNVvHOMdvbZ3?=
 =?us-ascii?Q?h/X9SBqmnZiE+bz3M79jT+2ghYXm9YYRtf9GbFvy/oHBT3M+iD4nYAS61Ipz?=
 =?us-ascii?Q?Vwmuq0MzWckFxQ3NuxzDHpTIj5Pgq45z7BWa/QqFqfHhkDsehlv4LIXVPjYW?=
 =?us-ascii?Q?JsS4C37Ij2qz01fDj8iG82aNaE8rDKWZ7vU1mPoxpMy50RA3HDIYKo1pSn4v?=
 =?us-ascii?Q?dCP+FfyA1F5azHHZQ3LvRhlqFmOzWSnulSaEanj1X5qJLIn+054rCPsiu8RM?=
 =?us-ascii?Q?ytlzQV4iX5tYQj2w294ILZRx6YRi2sDjXsWWuasx5BRz0ypR+suDkt0/dKWD?=
 =?us-ascii?Q?u/GaGp8u4frIavMByyr9k8dlokzbB9IyuUovDsyPWZuZn5sd6Klg/LkbrjHQ?=
 =?us-ascii?Q?Bs2qIVANsHj02VgTpUAVzD2M1/anddkxOAp3jLLg3nZ/t/qkKuh+Eaznm1Ur?=
 =?us-ascii?Q?L/E1knY8HOHIwj+/MV3UutdLSMoXXEKXoFqcLdNG1CFDpAefKvlGFoNlo5wu?=
 =?us-ascii?Q?LjHrpQBCJJPDtAARgUfx6gD9AlWUim5xzzP382LRfDFuakQjfP1QQ0/lMEXF?=
 =?us-ascii?Q?ylU/f5ZGFnrdQxvNaXl3npHrllQ7BDuZ+R2CgEnnv6lUyUEiEOGJqnp1TZoF?=
 =?us-ascii?Q?3qRxEWEG3isJq4qcX2gjorAXBdrHHjnnmCdHP0VpYoP/6fHWeh5LE1XgmCXe?=
 =?us-ascii?Q?dE8ShDfs+oSTGiGV22Kcc6gqpWK6IZ2oQOjogV7MtJ5TNsrntnA0JVH+VblA?=
 =?us-ascii?Q?5QeLB0bbabhQ8VAT5pORPKImriLvQ3uFWmnfCjnWziI1HpxL07aofgVVnYTS?=
 =?us-ascii?Q?k8luCkMAuRgJttOyyzUnUplEn8OmVHljRl314SkGzcUdjJ/P9F0ammXh2mEs?=
 =?us-ascii?Q?tUEsS6EQhcClN3n1RQMBLwa5XrycrZ77taqdkPLvUc1vf+lgDXSSmzfEAo8K?=
 =?us-ascii?Q?7FfHaEo0Jh6ncaJ1Q+tISamzveSmdWc2mSWtHzUfw3kcw9fh2m8jqJJJ0cQ3?=
 =?us-ascii?Q?ORJAECzM0aT15DMaSnsUH8J+yiAgeQNpHRMuNN6385sZtjjSrQyAPm2zRBAW?=
 =?us-ascii?Q?hKCULe+SSWU5Ygz+Dkfbe5yo8F/Wa8G/qe+3IOhT0lHnzJYP+3qQGEXBfouv?=
 =?us-ascii?Q?Ry2LMabSh7zQWGy7RUGSHHyZ04hiCWNomg7FIVjNZZFjp4ZXdY/aPlpRG5hF?=
 =?us-ascii?Q?QlIQaLc14KU7Q3g+gJ/pr3429+aveCP04a0JXHpS5KiDVHgo5YPvo4eWG7Aw?=
 =?us-ascii?Q?i/DA5XxjSMM5dgsEURsA7Y7Uja1e5071wRM9ed7K16ych/IsNYzwSBkSYZNP?=
 =?us-ascii?Q?Pt9P+g6vSvfh4Sl5Sn4cue8q7zNvnn1y/jEHZltnoYDnkrnNDSR6CJZ9Xpiz?=
 =?us-ascii?Q?tv7lU0gcXzMMwzw1iZEK+w0Q2cnqTRNKskhAacQGZZsuxDZwTuzc4eLW8hgt?=
 =?us-ascii?Q?HZduGXrRI7Ma4uTyelrPof9+w6vlHs9ubCMAH+Bo9/q9++Ok7ZRe+Xv1LpsV?=
 =?us-ascii?Q?x+Mt5QY6t1EFtryt8qabgPseHjTTDnKfXf36m0iWfI6+BwqGWCfDkbsoCYwF?=
 =?us-ascii?Q?/1glgq5ypjqNx5oa7HwOAsuTSob5JSK6S7C2pf7FVIPhwaLihmAH?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b5d88457-3d2b-4b10-0448-08df4b19b3e5
X-MS-Exchange-CrossTenant-AuthSource: SN6PR12MB2814.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Nov 2026 17:29:47.6685
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: efay+3I/SGVXTOgozIoQvNMiu2Rw1tWrsU7vICz6j0zKlJYopkRTzZVUnSP4yfoxaqwvwfqxWbP5Xb5vM51/SA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY8PR12MB8314

On Mon, Nov 23, 2026 at 03:06:55AM -0500, Gregory Price (Meta) wrote:
> On 2026-11-22 16:12 -0500, Yury Norov wrote:
> > On Sun, Nov 22, 2026 at 02:11:31PM -0500, Gregory Price (Meta) wrote:
> > > On 2026-11-22 11:51 -0500, Yury Norov wrote:
> > > > On Fri, Nov 20, 2026 at 01:08:51PM -0500, Gregory Price via B4 Relay wrote:
> > > > > This is v6 of the Private NUMA node series. The series falls into four
> > > > > parts, each building on the one before:
> > > > > 
> > > > >    1-18  mm: introduce N_MEMORY_COMMON
> > > > 
> > > > I walked through this part, mostly. It looks like you can substantially
> > > > decrease the patch count if you keep N_MEMORY meaning unchanged, and
> > > > add another type, like N_MEMORY_NOALLOC.
> > > > 
> > > 
> > > I don't see how this would reduce the patch count substatially, you
> > > still need to convert existing N_MEMORY users and need to differentiate
> > > between general purpose memory nodes and private memory nodes.
> > 
> > Please check this quick attempt with my codex. The patch count is reduced
> > to 52:
> > 
> > https://github.com/norov/linux/tree/private-nodes-v6-n-memory-folded
> > 
> ... snip ...
> 
> Patch count is not what we want to be optimizing for here.
> 
> Your branch carries the same code (+3 lines net actually).

Line count is neither the metrics.
 
> The patch reduction comes from squashing the per-subsystem conversions
> into one 16-file commit.

No, and I mentioned that.

> It also broke get_mempolicy(MPOL_F_MEMS_ALLOWED) - it now returns
> memoryless nodes even if the system doesn't have a private node.
>
> > The more important thing is that N_MEMORY and the proposed N_MEMORY_NOALLOC
> > is a disjoint, contrary to N_MEMORY and N_MEMORY_COMMON.
> 
> The proposal here is not novel - version 5 was also disjoint:
> https://lore.kernel.org/linux-mm/20260720193431.3841992-5-gourry@gourry.net/

Alright, this is the important piece of information, and it's not
highlighted in the cover letter at all.

For the next iteration, please use the [PATCH v7] tag to highlight that
there's some history and background for the current design.

The cover letter is wordy enough to exceed my ability to perceive the 
plain text, TBH. I followed it to, maybe, a MODEL section, and then
switched to the actual code. I don't think I'm alone here.

Can you please structure it so the really important things will be
mentioned in the first ~20 lines, and please provide links to the
previous iterations.
 
>    N_MEMORY and N_MEMORY_PRIVATE are mutually exclusive states.
> 
> I moved away from that because it changes the definition of N_MEMORY.
> 
> The subset model is easy to understand
> 
> N_MEMORY               - a node has memory
>  -> N_HIGH_MEMORY      - subset of N_MEMORY
>  -> N_NORMAL_MEMORY    - subset of N_MEMORY
>  -> N_MEMORY_COMMON    - subset of N_MEMORY
>  -> N_MEMORY_PRIVATE   - subset of N_MEMORY
>                          (COMMON and PRIVATE partition N_MEMORY)
>  -> N_MEMORY_<FEATURE> - subset of N_MEMORY
>                          all N_MEMORY_COMMON
> 			 some N_MEMORY_PRIVATE
> 
> It's additive. Users pick the set of nodes they want for their purpose
> and don't have to cobble sets together or remember special helpers.
> Users don't even need to know about private nodes most of the time
> (mempolicy being the one major exception here).

Do you support private nodes for HIGH_MEMORY? 

If yes, it would look like:

N_MEMORY
 -> N_HIGH_MEMORY
    -> N_NORMAL_MEMORY
 -> N_MEMORY_COMMON
 -> N_MEMORY_PRIVATE

If no, I'd organize it like:

N_MEMORY
 -> N_HIGH_MEMORY
    -> N_NORMAL_MEMORY
       -> N_MEMORY_COMMON
       -> N_MEMORY_PRIVATE

Does it mean that COMMON and PRIVATE is a disjoint in this model(s)?
If so, the COMMON is excessive. If not, can a node be COMMON and
PRIVATE at the same time? What would it mean?

I didn't understand the N_MEMORY_<FEATURE> passage. Can you please
elaborate on the 'all this, some that' part?

> In the disjoint model, N_MEMORY no longer means "has memory". Recovering
> that set requires new helpers, and the meaning changes silently for
> every in-tree and out-of-tree user. Anything that wanted "has memory"
> quietly misses private nodes.
> 
> Either way you have to audit each N_MEMORY reference and decide whether
> it wants that state or a feature variant (N_MEMORY_RECLAIM, COMPACTION).
> 
> The difference is how a missed site fails. In the joint model the
> zonelist and the common-memory folio checks backstop allocation and
> access, so a missed placement site costs some additional work.
>
> In the disjoint model a missed site silently drops a node from stats
> and accounting - or worse fails to allocate per-node meta data.
> 
> So no, I do not think we should go back to the disjoint model.

You already did that analysis I was looking for, but discussed it only
in reply to my question... In v7 please wrap the design decision up in
the cover letter.

I feel convinced, despite that hierarchical approach seemingly
requires to touch more subsystems. But I would like to get feedback
from those followed v5 and earlier discussions.  
 
> > > and n_memory_noalloc is not a good name.
> > 
> > sure, i'm not attached to any particular name. although,
> > n_memory_common nothing better to me. it answers the question
> > 'what for this thing' even worse.
> > 
> 
> happy to wordsmith the names here.
> 
> N_MEMORY_GENERAL? _DEFAULT?  _COMMON felt intuitive but I am happy
> to rename it whatever.

If common and private is a disjoint, you need a single flag to cover
both states. Or I miss something on it?

Also, it looks like the 'COMMON' memory is one that available to MM
allocator and other API. Maybe N_MEMORY_MM then, if you still need the
name?
