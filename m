Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=40.107.208.9
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1795366274;
	b=AOxPYi1cm++WQjcLlzS1vUO1mz0m4RgiKTElVeLXnJ/htsORMJ1c7yGt1rFRo8Q5Kj6o
	 56+1Y/1M2PDquZed6Msx02HEdqCpqe1Z1xHWMxcxK4+TgWRVc1x4F331LjHj2JL5WLh4Y
	 K1/ILDLF7p3FrciogKV4bVO4MCYu6WkDn8i6C077txLx4p/EKZ2HsvV8Y64qEnaXGtQ+V
	 rTKjLqW2/dSRxMsA7ZJQZAV2nWBXNQM8z0v6c2G9XfTRCOEQNgVyByC0przRzuW3Licbr
	 hdkUYrCyo/SVxemAOdwZQNc4KfuBVOlJ+oHTA68crps84FY85xHBjSte8+DkEcibrkQ==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795366274;
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
	bh=xwwj7s2YvnOoTIEaUz9/4ji1HZIr7vkyVR73snNQDBo=;
	b=15iJsjZsQcTJn2bpXiTpToTxydCTMp/EdqGqWUUDh/lFIJSlz5TT/xAOVgXfz190uPlJ
	 O/Yecjf0pXOCMIlMag3LuLymeVwDkYX1rCF7ytfrBq04efz2KIvC9fkUzW41fx7r1y2m5
	 gHG7Vw6Lo+AMR4zepzH6OwBLOa1p2Co+qlwXtAPNvKYslrxTkd06xlW15Y41iuDKSqpJh
	 NxsS8QpHEpbbI2QJl9BdtW5xJR5KfYO7RrTKSdREFqF3JHuKo7dt4jN2/Dg5APh2sdiBM
	 VTN7vDWe6j+mr+ScBjSdbVuUf3pzM2ST4S/jvZiFoaA4/E8NV58I7H8XBSZREKGCOgQ==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=nvidia.com;
	spf=fail smtp.mailfrom=nvidia.com;
	dkim=pass header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=XWKRVhuA;
	arc=pass header.oldest-pass=0 smtp.remote-ip=40.107.208.9
Received: from PH0PR06CU001.outbound.protection.outlook.com (mail-westus3azon11011009.outbound.protection.outlook.com [40.107.208.9])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (secp384r1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B447D606A320;
	Sun, 22 Nov 2026 16:51:13 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org B447D606A320
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=XWKRVhuA
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Scor5niSTeZWXzdLyvWRkXWV07XsD06gsxCDnADNALgSfjtDKr61m8XZJ8+GTE2iSelKn5nwsFjzu1NLffxcBn2X9DTQlb6ixWnS2oGrQI3B7W7T5vKmhz35suqlEbwM5iLOq5lypnl2KuRK11k//1urLHm9+Byn6xdfGg6FxDlk4rNkJwa27VQpZ92ASBpD/Zl3FpRWmkmJEPKQ/ULR3k01nrEjw71juNDrqWUAj9cYXCjt/FUtxCajD7gwuX8hOTsAolbaUDF6RXN4PZVqY3jQTIhJP2eS4c+iZVSQQIIjzXaXVZ1mhnI4rdW7X1o0qoV05zvuD1jQ8f4UGzy0lw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=xwwj7s2YvnOoTIEaUz9/4ji1HZIr7vkyVR73snNQDBo=;
 b=T4rvSl4ZptYMLgImbAglMFn7+/5zSzKIXD3MwZWTohN12RWUjG1pF36bHI9B97A8afGx00UD4hdWKvymqh/vjU3TwCcIlLJMdiy1NlVNLHWC0M78m6bFbX4KkHYes4377qKHIRtQgnVwFYwMAWxl3IDXunSB9Ml1YX8Mudsr7FwARmCypfZ2gq7u6dkbOyxJoqzbR+uZM+HcN6tWc07TN6A/+xMkqLewMO0IycuC9qSqSu5+igtLetsoa0NX8l5mUbXSIvwaDTkRYD/HvNMSb20lNxv0v2Kn9wA3+TmSaoL+TCwjgClc5v1R/ErC0O0vClHcX4pC4758XThbnBNNRA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=xwwj7s2YvnOoTIEaUz9/4ji1HZIr7vkyVR73snNQDBo=;
 b=XWKRVhuAlz1+cRzpfnS3z1Xk/hyCLEGj8jac0Ly/jqOV9lnTL7cPqV+Hrp+KMcV9AwO9Yuzj6LtDpzsle/Rw0OOoB0lU60E8eiNjI2xUS4huiZBE2QteQzaIzeIYmLDxFgl93gNyXHTmP1z4n1TSNDluolPM910bkVE6QLvKQoAEtWoByQktHVNQqh1f7aQG3TEbiTHQy2BrHkNsD4mgxiFHyyS9koPjuymYa+eNZmb2auakSfz2rLXG6BBAYbSkOX6LR+7ZpCf/7Amj8Xec+lmYwvcmCGLaDpmEtODCNPF5AlWm0Z2oCqLzmQxRfN8aV1P9CSEdcCsCXXULFD+ppQ==
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from LV3PR12MB9356.namprd12.prod.outlook.com (2603:10b6:408:20c::21)
 by PH8PR12MB6889.namprd12.prod.outlook.com (2603:10b6:510:1c9::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.639.13; Sun, 22 Nov
 2026 16:51:06 +0000
Received: from LV3PR12MB9356.namprd12.prod.outlook.com
 ([fe80::1c36:31b4:c420:6286]) by LV3PR12MB9356.namprd12.prod.outlook.com
 ([fe80::1c36:31b4:c420:6286%4]) with mapi id 15.21.0639.012; Sun, 22 Nov 2026
 16:51:05 +0000
Date: Sun, 22 Nov 2026 11:51:04 -0500
From: Yury Norov <ynorov@nvidia.com>
To: gourry@gourry.net
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
Message-ID: <awMdeK8O-5mffg2m@yury>
References: <20261120-private_nodes_v6-v1-0-74f5f9a115c2@gourry.net>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261120-private_nodes_v6-v1-0-74f5f9a115c2@gourry.net>
X-ClientProxiedBy: BN9PR03CA0305.namprd03.prod.outlook.com
 (2603:10b6:408:112::10) To LV3PR12MB9356.namprd12.prod.outlook.com
 (2603:10b6:408:20c::21)
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
X-MS-TrafficTypeDiagnostic: LV3PR12MB9356:EE_|PH8PR12MB6889:EE_
X-MS-Office365-Filtering-Correlation-Id: 08f5955b-874c-4212-b2e1-08df48b8cca8
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|23010399003|10070799003|1800799024|366016|376014|7416014|261028144727099003|261102130727099003|261102123227099003|261021123027099003|261021121427099003|261026121527099003|261026140227099003|261022115727099003|261022075727099003|261022105027099003|5023799004|11063799006|56012099006|10067099003|22082099003|18002099003|6133799003|261009223027099003|3023799007;
X-Microsoft-Antispam-Message-Info:
	sNUofpjw19i2nAI015B9ID4XomjNuG35GSTO3COdoUOds4PYv/xy9nfRm4YyculVBJwh4Mc/zgr3eaToJx+pcQfmZC4KANFaontBFxYeR7K5eS0sh01XhWn1WRQPWc7af7RxMdz/PJpQejgT+d53DbELhc+qMakZ3aOiERkyhHKIt4DLgsckG8mijDx5wxybZX/wWuPwmxUGwmF96dP8m36Jin20hJBB1aqZoDZwlo9w6a8GEXb3hzAm5ULumxvax4W3kPftq4IiTVIadXhZUcmuVA5qRhY7xdWh09fe5P8WMyLMQ4J7qLnpcU+q+fAAbqM/HjAsWF7WWudIvWk3FJZyuYZYiBk11vGoeL+Kayh4CrpmwfYahWmqT3hJxy6p/5XIRbvc4aw3q8fJzyUPUNOUAcXRQpIDY25hS88eNg6HrQ822XYpfRtM8cxTD/K3DGwAQNkUX0QmVFv3Ww25OwM0RoXQ5oF4PstHW43AOLxVnCdR4Z8Vp9I+KXmMhFMQM8ZhZuSyFr5/pXQRFQBHKwKjstrqJ0/i5iHe93fTQ3y3p7lY9H7SULGDzYgq7wEM7deGW8wXjqbtq+fE165fqlyvSEBkZZQtrG9H1EVIu6XEXhHXgTmgS/1voWIdR1cwA0+5HoZUoXyn3Li+8zK1laf612KQzOSiNuwF+gZegTY=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV3PR12MB9356.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(23010399003)(10070799003)(1800799024)(366016)(376014)(7416014)(261028144727099003)(261102130727099003)(261102123227099003)(261021123027099003)(261021121427099003)(261026121527099003)(261026140227099003)(261022115727099003)(261022075727099003)(261022105027099003)(5023799004)(11063799006)(56012099006)(10067099003)(22082099003)(18002099003)(6133799003)(261009223027099003)(3023799007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?Wa4C/gHygTwqvY0vPeuYmMOT+NM+VptSKE4U2bW/lXy3pmnGEtmSmJ/H+cYS?=
 =?us-ascii?Q?AJ1Y64MH+1fuYWYuhSxYypYr9IP9M2dsLq45RZOuAiLRNSwG2Lgei2Gvis6A?=
 =?us-ascii?Q?GVunhauCC5R1ygFLUGdIdwtbJG0EuZH0NoikNCUaKdTBs/aq4QyNM9lGd2e7?=
 =?us-ascii?Q?eQ9vIRLipQtb9ViuyGDg61d0r212r+RTsd7h0lEA2wjNR+Y8mQV6IfgORSj0?=
 =?us-ascii?Q?/46z/KB7xTY+PzBxiBP1vkODyeenTNg7c9GZW/ZXNazVzTctjaUQ0z0P8hrS?=
 =?us-ascii?Q?sjDym1cg43tPcXOaTbZBPCX8ZNrlAaE4PvgrvDsDAG4sC3hadVxCaKjWuazW?=
 =?us-ascii?Q?HMRlTrS6EU75wnt0hNMnSyluwPuMg4oeis9Km7okyElqs7KR4ws+isCXddUS?=
 =?us-ascii?Q?JJMgx2ndTgk7oHNkN2MnnrlwdW2e3xaaARJmaPD307OX352aGmSkQxNG+Hot?=
 =?us-ascii?Q?YPlUtmh+3QBk7Ng72lwBF/iyKiM8hv2kc4iyHNc7Cw61QB0CC3KpSfjSl0s2?=
 =?us-ascii?Q?/Iiq7rV+iRU5t+jruJ/hrmQV/Tq3EBSMv79kJQ2QbpuWJ1pdcJpCkeFjycqG?=
 =?us-ascii?Q?eZUEf1yldWDQu/rD8pu/nyIQ9DSzpks/M28ccYEJO99u+pzB4Ec/Vqr0R96N?=
 =?us-ascii?Q?hSJOly+NakUbw9C5BimAQdiKUkn4kq8ITca8eRetREsgKrx8zsJZbDy21AFA?=
 =?us-ascii?Q?ABx19br4AuhkLWW6Qlvxge6BXUEY1d+cu9BHvv1oz424aMJIGbM9na6qunJU?=
 =?us-ascii?Q?CnXeYw7S+vKUAuOzPy6cyR31JKtKAlKuKFAEBULtAyrhQXKqLyeXJXcknmrT?=
 =?us-ascii?Q?d2iavyOph4HwzuDDwy4RnEXAGtqHHfk1dw/KvFa1XOfuTzh4xyHqcewysOrs?=
 =?us-ascii?Q?muIIurlrxzKXx0F2p6Jdnpk7lpqP2fSvjY+lKPMU7MKBFVxIUFWoqYBfRSjy?=
 =?us-ascii?Q?a/8tSXtcTKINg6DHFYtTLKzV3hwcfJzFsqWXLNsWri39mgLMDMwT+7FrOrU1?=
 =?us-ascii?Q?jl0aV1lypyiheJ5icIYwIeS4wAirFlgVFzovFM1QkA8lnYoV7QPeu4XoHKnm?=
 =?us-ascii?Q?E5kKTUi2zEu5zgLDwuw/F0WoBoFXnJw5prV803br+iyYwNQHqJvxfbdSeFBg?=
 =?us-ascii?Q?4Wyt604hU/JqVFxlc6QIG9cZQj8tTHIRcEKKuv5IcQWtcKHoyKZpnJz/ehgW?=
 =?us-ascii?Q?xlgul03QqTdP/DDyVKTAGQ5mqFG7VH+/HdVqwqKr8HYlr2+zwn0yHeaYOXiz?=
 =?us-ascii?Q?vOP0xEBUbVnVt/ZsMitvtw6YObjsVQIV/Abn5BkRYlVIDjdZ77/sIU2kp0X3?=
 =?us-ascii?Q?QmRsf0vpPFuIq4+YquSvXIpr5wj974KbgVtTUXvooVLAY3Qm7J2ogCd4tin6?=
 =?us-ascii?Q?fmRUXzxGE0TPBernqcE8MZ1Jlf8VpBPk/4QTdwjZjCJ2+7hrkSBa8vaXZD9y?=
 =?us-ascii?Q?mEm2WZAOcTehwSavn4nTMYzM4V+EdUP8ZMm/NpOq475jI6U76KnjNtIZWxQd?=
 =?us-ascii?Q?p3tvnYzjMNZY7E/+GdYNfhbH3usikfYrMyb8I1NdYCosArVFbrCxVBIsnoJk?=
 =?us-ascii?Q?pRciIHqve965Ll/0eiPTjTaITzgGWpDngA9Eu6lf7k73BHE8IjkMV1X4/xwT?=
 =?us-ascii?Q?G7+j84fRhch0W04pfdXTwBJlQzW9780N2S4heK+fQf2eBdKGc57c8pIPgam6?=
 =?us-ascii?Q?1rcB61zAawtq4qdDwvU0y+RbOHIU50urTAOG6QZvnp5eX9LR3QpMheOllOAa?=
 =?us-ascii?Q?MvvqV1eokoXw935GhZ7dHylQpCoEDxjU6IducQ2ZJsiSHw/qpt6c?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 08f5955b-874c-4212-b2e1-08df48b8cca8
X-MS-Exchange-CrossTenant-AuthSource: LV3PR12MB9356.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Nov 2026 16:51:05.8509
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Mwca3S5flLeKSN6mZrKlk000ZdI2WED1V4HY3me9l3WLpnRNfxGGlPw8wHfgaGNxhkVCOM8AfFhY6q37Y4Vy/Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH8PR12MB6889

On Fri, Nov 20, 2026 at 01:08:51PM -0500, Gregory Price via B4 Relay wrote:
> This is v6 of the Private NUMA node series. The series falls into four
> parts, each building on the one before:
> 
>    1-18  mm: introduce N_MEMORY_COMMON

I walked through this part, mostly. It looks like you can substantially
decrease the patch count if you keep N_MEMORY meaning unchanged, and
add another type, like N_MEMORY_NOALLOC.

>   19-26  restrict folio-walking MM services to common memory
>   27-44  N_MEMORY_PRIVATE, kept out of cpusets, mempolicy, accounting
>          and the page allocator's ordinary paths
>   45-61  private node features, memory hotplug of private memory,
>          dax/kmem private mode, selftests and documentation
> 
> Patches 1-26 change no behavior on any system and can be reviewed and
> merged on their own. Without private nodes, every path in patches 27-61
> behaves as before.
> 
> The full stack is also available at:
> https://github.com/gourryinverse/linux/tree/scratch/gourry/managed_nodes/private_nodes_v6
> 
> Motivation
> ==========
> 
> Some memory should be visible as a NUMA node without becoming part of
> the general allocation pool: HBM, coherent GPU or accelerator memory,
> or device memory a driver hands out itself.
> 
> Today such memory is either ordinary System RAM, where any allocation
> can fall back onto it and every MM service manages it, or ZONE_DEVICE,
> where the buddy allocator and the MM services are not available at all.
> 
> Private nodes sit in between. Their memory is managed by the buddy
> allocator, but ordinary allocations never land on it, and generic MM
> services leave it alone unless the node opts back in.
> 
> Model
> =====
> 
>   N_MEMORY = N_MEMORY_COMMON + N_MEMORY_PRIVATE
> 
>   - N_MEMORY keeps meaning "this node has memory".
>   - N_MEMORY_COMMON means ordinary allocations and kernel services
>     may use it.
>   - Allocation isolation comes from the zonelists: a private node is
>     on no fallback zonelist and has an empty __GFP_THISNODE zonelist.
>     It is reached only through its own private zonelist.
>   - Services that walk existing folios check folio_is_common_memory()
>     where they already skip ZONE_DEVICE.
>   - A private node can opt into compaction, reclaim and userspace
>     placement through per-node features. The services are written in
>     terms of their own node state (N_MEMORY_RECLAIM, ...), so services
>     don't need to be "aware" of anything but themselves.
> 
> The node state use / filtering model goes as such:
>   1) If you're walking the normal zonelists, you're already filtered
>   2) If you're walking nodelists to touch memory, filter on
>      N_MEMORY_COMMON by default (replacing N_MEMORY).
>   3) If you're walking structures to operate on folios / pages,
>      check folio_is_common_memory() (replacing zone_device checks)
>   4) If the service allows private memory interactions, use the
>      N_MEMORY_<FEATURE> bit corresponding to the service.
> 
>      e.g.: reclaim checks N_MEMORY_FEATURE when walking N_MEMORY
>      or when walking the private memory zonelist.
> 
> N_MEMORY_COMMON (patches 1-18)
> ==============================
> 
> N_MEMORY has two meanings today:
>   1) this node has memory
>   2) ordinary allocations and MM services can use this node's memory
> 
> The two are the same today. They stop being the same once a NUMA node
> with memory isn't part of the general allocation pool.
> 
> N_MEMORY_COMMON takes the second meaning, and the N_MEMORY users that
> mean it are converted. N_MEMORY continues reporting memory topology.
> 
> The rule for choosing between them:
> 
>   N_MEMORY         the node has memory: topology, per-node metadata and
>                    statistics, cpuset.mems.
>   N_MEMORY_COMMON  ordinary allocations or a kernel service may use the
>                    node's memory: zonelists, allocation and migration
>                    targets, per-node service threads, and sizing or
>                    accounting meant for ordinary allocations.
> 
> Code that walks the existing zonelist needs no check. The zonelists
> are built from N_MEMORY_COMMON, so they already hold only memory the
> allocation may use.
> 
> Unless a system actually has a private node, N_MEMORY and
> N_MEMORY_COMMON are the same set, so behavior should be unchanged.
> 
>   1-3   node-state helpers, N_MEMORY_COMMON itself, and the
>         `has_common_memory` sysfs ABI.
>   4     zonelists: the fallback lists hold common nodes, and a node's
>         __GFP_THISNODE list is built only for a common node
>   5-11  allocation and migration targets
>   12-13 kswapd and kcompactd
>   14-18 sizing and accounting meant for ordinary allocations
> 
> has_common_memory lists the same nodes as has_memory until memory
> outside N_MEMORY_COMMON exists. It is added now so that userspace, such
> as libnuma, can start choosing allocation targets from it, and so that
> the meaning is fixed before anything makes the two lists differ.
> 
> Folio-walking MM services (patches 19-26)
> =========================================
> 
> Patches 1-18 decide where memory comes from: zonelists, allocation
> targets and per-node services follow N_MEMORY_COMMON. Some MM services
> instead reach folios that already exist, wherever they are: through
> page tables (KSM, khugepaged, NUMA hinting, madvise, mbind() and
> migrate_pages(), move_pages()) or through physical addresses (DAMON).
> 
> These services skip ZONE_DEVICE folios with folio_is_zone_device() and
> page_is_zone_device().
> 
> Patch 19 generalizes those checks into folio_is_common_memory() and
> page_is_common_memory(), which reject ZONE_DEVICE folios and folios
> on a node outside N_MEMORY_COMMON.
> 
> The rule: a service that walks folios checks folio_is_common_memory()
> where it would otherwise check folio_is_zone_device().
> 
> Rather than add new hooks to page-table and pfn walkers, this reuses the
> places that already opt ZONE_DEVICE memory out.
> 
>   19    folio_is_common_memory() and page_is_common_memory()
>   20-26 ZONE_DEVICE checks in folio-walking services become
>         page/folio_is_common_memory(). One component per patch.
> 
> N_MEMORY_PRIVATE (patches 27-44)
> ================================
> 
> Patches 27-44 add the memory that makes N_MEMORY and N_MEMORY_COMMON
> differ. A private node has online System RAM that ordinary allocations
> do not use and MM services leave alone, so neither an allocation that
> names no node nor a node-local kernel allocation can land on it.
> 
> Most of these patches add the explicit opt-outs that the N_MEMORY ->
> N_MEMORY_COMMON conversion did not cover, largely concentrated in
> cpuset, mempolicy and migration.
> 
> In the page allocator, each node gets a private zonelist holding its
> own zones only if it is private. MM code reaches private memory only
> through that zonelist (ALLOC_ZONELIST_PRIVATE plus a nodemask).
> 
> A private request whose node becomes ineligible relaxes onto common
> memory, and exhausting private memory fails the allocation (SIGBUS on
> fault) instead of invoking the OOM killer (this can change in the
> future with additional work).
> 
> Nothing in patches 27-44 creates private memory. Memory hotplug of
> private memory, with dax/kmem as its first user, comes in patches
> 56-57, after the feature bits that let a private node opt into
> reclaim, compaction and userspace placement.
> 
>   27-28 N_MEMORY_PRIVATE, exported as has_private_memory.
>         A per-node feature mask on the pgdat.
>   29-30 accounting: MemTotal/MemFree/other limits ignore private mem.
>         the auto-movable online policy ignores private memory
>   31-35 cpusets and mempolicy: private nodes are inherited only on
>         request, never rebound onto, never spread over, and never
>         migrate_pages() destinations
>   36    explicit reclaim and compaction requests refuse private nodes
>   37-44 page allocator:
>         37-38 the reserves and watermarks, and contiguous allocation,
>               skip/refuse private memory
>         39-40 the private zonelist and its selection by MM callers
>         41    a private request whose node becomes ineligible relaxes
>               onto common memory to ensure forward progress
>         42    exhausting private memory fails with SIGBUS, like an
>               exhausted HugeTLB pool
>         43    an alloc_flags-aware folio allocator (Brendan Jackman)
>         44    a bind policy whose nodes became private falls back to
>               common memory
> 
> Private node features and providers (patches 45-61)
> ===================================================
> 
> Patches 1-44 keep every generic MM service off private memory.
> 
> Some private memory wants a few of them back: HBM or coherent GPU
> memory that userspace manages with mbind() and migrate_pages() needs
> reclaim and compaction, while staying out of incidental allocation
> (no fallback onto it, only explicit placement).
> 
> Patches 45-55 add three opt-in feature bits and corresponding node
> states:
> 
>   N_MEMORY_COMPACTION   kcompactd, proactive and explicit compaction
>   N_MEMORY_RECLAIM      kswapd, memcg and explicit reclaim
>   N_MEMORY_MEMPOLICY    mbind() and explicit migration may target it
> 
> The states cover what the kernel does on its own initiative. Direct
> reclaim and compaction serve an allocation within its own zonelist, so
> an allocation from a private node may reclaim and compact it either way.
> 
> RECLAIM requires COMPACTION, and MEMPOLICY requires both. Userspace
> control (mbind, migration) generates fragmentation, and as a result
> private allocations would fail unpredictably without reclaim/compaction.
> 
> Relcaim and compaction are required by mempolicy because otherwise
> order-N allocations cause unpredictable out of memory conditions due
> to fragmentation.
> 
> Demotion and NUMA balancing support are deferred to a later series
> but can be trivially support to allow demotions from HBM to DRAM
> as a way of cheap tiering.
> 
> Every common node carries all three, so the existing N_MEMORY_COMMON
> users that mean "reclaim" or "compaction" move to the new states.
> 
> Service support:
> 
>   45-46 N_MEMORY_COMPACTION, and compaction switched to it
>   47-48 N_MEMORY_RECLAIM, and reclaim switched to it
>   49    madvise reclaim advice only for reclaim-capable memory
>   50    memcg reclaim also visits private nodes that permit reclaim
>   51    N_MEMORY_MEMPOLICY
>   52    explicit migration acts on N_MEMORY_MEMPOLICY memory
>   53    N_MEMORY_MEMPOLICY memory counts as general-purpose.
>         MemAvailable (free and file pages) and dirty limits count
> 	only common memory.
>   54    MPOL_F_PRIVATE_NODES: mbind() flag that binds a mapping to
>         one private node.
>   55    migrate_pages() support for N_MEMORY_MEMPOLICY nodes
> 
> Creating a private node
> 
>   56    memory hotplug of private memory, with a feature mask
>   57    dax/kmem private mode
> 
> Testing and Documentation:
> 
>   58-60 selftests: private kmem devices and services, memory policy
>         bindings, migration and exhaustion, and cpuset interaction
>   61    Documentation/mm/numa_private_nodes.rst
> 
> MPOL_F_PRIVATE_NODES is new uapi. Without it, private nodes in an
> mbind() mask are ignored, similar to nodes outside the cpuset.
> 
> libnuma and numactl need a matching change to reach private nodes.
> 
> There is no sysfs list of the nodes that accept private bindings.
> userspace can probe with MPOL_F_PRIVATE_NODES.  Otherwise - we can
> discuss how service support should be discoverable to userspace.
> 
> Memory hotplug is the only source of private memory right now.
> 
> All System RAM on a node shares one configuration: hotplug with a
> different one fails with -EBUSY.
> 
> Costs and known limits
> ======================
> 
>   - ZONELIST_PRIVATE is a third zonelist per pgdat; with NODES_SHIFT=10
>     that is about 80KB per possible node, though a private zonelist
>     holds at most one node's zones.
> 
>     local-only zonelists can be space-optimized if this matters.
> 
>   - Free page reporting reports free private pages like any others.
> 
>   - Tasks are OOM-scored by all of their resident memory,
>     private pages included.
> 
> Changes since v5 ("Private Memory NUMA Nodes")
> ==============================================
> 
>   - Reordered so the N_MEMORY audit (patches 1-26) comes first and can
>     be reviewed (and merged) on its own if desired.
>   - Capabilities became memory features with node states, so a service
>     can be written in terms of itself: reclaim walks N_MEMORY_RECLAIM,
>     compaction N_MEMORY_COMPACTION.
>   - The capability set is pared down to COMPACTION, RECLAIM and
>     MEMPOLICY for the first run.  DEMOTION, NUMA_BALANCING, and
>     compressed RAM support are deferred.
>   - The private zonelist is now local-only. A fallback variant can be
>     added if a use case needs one.
>   - cpuset and OOM semantics are worked out:
>       - cpuset.mems governs private nodes
>       - private-only request inherits the parent's common nodes.
>   - Private bindings are an explicit uapi flag, MPOL_F_PRIVATE_NODES,
>     rather than inferred from the nodemask.
>   - Exhausting private placement fails the fault with SIGBUS, as an
>     exhausted HugeTLB pool does, instead of invoking the OOM killer.
>     OOM support can be added later, but this keeps initial support
>     reasonable simple.
> 
> Signed-off-by: Gregory Price (Meta) <gourry@gourry.net>
> ---
> Gregory Price (Meta) (60):
>       nodemask: add node-state iterators
>       mm: publish and clear node memory states via helpers
>       mm: introduce the common-memory node state
>       mm/page_alloc: build zonelists from common memory
>       mm/mempolicy: keep interleave and tmpfs mount policies on common memory
>       mm/memory_hotplug: migrate offlined pages to common memory
>       mm/memory-tiers: restrict demotion topology to common memory
>       mm/migrate: reject move_pages() destinations outside common memory
>       mm/damon: reject migration destinations outside common memory
>       sched/numa: restrict NUMA migration targets to common memory
>       fork: check cached stack locality only on common memory nodes
>       mm/vmscan: restrict reclaim to common memory
>       mm/compaction: restrict compaction to common memory
>       mm: base hash distribution on common memory nodes
>       mm/page_alloc: count common memory nodes for kswapd recovery
>       mm/oom_kill: compare OOM constraints against common memory
>       PM: hibernate: size the image from common memory
>       mm/khugepaged: base the recommended min_free_kbytes on common memory
>       mm: add folio_is_common_memory() and page_is_common_memory()
>       mm/ksm: restrict merging to common memory
>       mm/khugepaged: restrict collapse to common memory
>       mm/mempolicy: don't NUMA-hint folios outside common memory
>       mm/damon: restrict DAMON-native folio operations to common memory
>       mm/madvise: restrict reclaim advice to common memory
>       mm/mempolicy: queue only common memory for mbind() and migrate_pages()
>       mm/migrate: leave pages outside common memory in move_pages()
>       mm: add the private-memory node state
>       mm: select memory features per node
>       mm: keep private memory out of the system memory totals
>       mm/memory_hotplug: keep private memory out of the auto-movable ratio
>       cgroup/cpuset: inherit common memory when a nodemask is private only
>       cgroup/cpuset: keep spread page cache off private nodes
>       cgroup/cpuset: ignore private nodes when matching OOM victims
>       mm/mempolicy: don't rebind policies onto private nodes
>       mm/mempolicy: keep private nodes out of migrate_pages() destinations
>       mm: refuse explicit reclaim and compaction of private nodes
>       mm/page_alloc: keep private memory out of reclaim reserves
>       mm/page_alloc: refuse contiguous allocation from private memory
>       mm/page_alloc: add a private-node zonelist
>       mm/page_alloc: let MM callers select the local private zonelist
>       mm/page_alloc: relax a private request whose node becomes ineligible
>       mm: fail private placement on exhaustion instead of OOM killing
>       mm/page_alloc: fall back when a bind policy's nodes become private
>       mm: add N_MEMORY_COMPACTION node state
>       mm/compaction: restrict compaction to N_MEMORY_COMPACTION
>       mm: add N_MEMORY_RECLAIM node state
>       mm/vmscan: restrict reclaim to N_MEMORY_RECLAIM instead of N_MEMORY_COMMON
>       mm/madvise: restrict reclaim advice to reclaim-capable memory
>       mm/vmscan: reclaim private nodes for memcg
>       mm: add N_MEMORY_MEMPOLICY node state
>       mm: restrict explicit migration to N_MEMORY_MEMPOLICY
>       mm: count memory with userspace placement as general purpose
>       mm/mempolicy: add MPOL_F_PRIVATE_NODES for private node bindings
>       mm/migrate: route explicit NUMA migration to private nodes
>       mm/memory_hotplug: online and offline private memory nodes
>       dax/kmem: add a private memory mode
>       selftests/dax: test private kmem devices and services
>       selftests/dax: test memory policy on private nodes
>       selftests/dax: test cpuset interaction with private nodes
>       Documentation/mm: describe private memory nodes
> 
>  Documentation/ABI/stable/sysfs-devices-node        |  27 +
>  Documentation/ABI/testing/sysfs-bus-dax            |  19 +
>  Documentation/admin-guide/cgroup-v1/cpusets.rst    |   7 +
>  Documentation/admin-guide/cgroup-v2.rst            |  13 +-
>  .../admin-guide/mm/numa_memory_policy.rst          |  22 +
>  Documentation/mm/index.rst                         |   1 +
>  Documentation/mm/numa_private_nodes.rst            | 223 ++++++++
>  Documentation/mm/physical_memory.rst               |  25 +-
>  drivers/base/node.c                                |   9 +-
>  drivers/dax/kmem.c                                 |  55 +-
>  include/linux/memory_hotplug.h                     |   2 +-
>  include/linux/mmzone.h                             |   6 +-
>  include/linux/nodemask.h                           |  74 ++-
>  include/linux/sched.h                              |   2 +
>  include/linux/swap.h                               |   4 +-
>  include/uapi/linux/mempolicy.h                     |   4 +-
>  kernel/cgroup/cpuset.c                             |  85 ++-
>  kernel/fork.c                                      |   2 +-
>  kernel/power/snapshot.c                            |  15 +-
>  kernel/sched/fair.c                                |   2 +-
>  mm/compaction.c                                    |  10 +-
>  mm/damon/core.c                                    |   5 +-
>  mm/damon/ops-common.c                              |   7 +-
>  mm/damon/vaddr.c                                   |   2 +-
>  mm/huge_memory.c                                   |   2 +-
>  mm/internal.h                                      |  71 +++
>  mm/khugepaged.c                                    |  20 +-
>  mm/ksm.c                                           |   8 +-
>  mm/madvise.c                                       |   6 +-
>  mm/memory-tiers.c                                  |  23 +-
>  mm/memory.c                                        |   5 +
>  mm/memory_hotplug.c                                | 120 ++--
>  mm/mempolicy.c                                     | 165 ++++--
>  mm/migrate.c                                       |  15 +-
>  mm/mm_init.c                                       |  20 +-
>  mm/mmap.c                                          |   6 +-
>  mm/nommu.c                                         |   4 +-
>  mm/oom_kill.c                                      |   7 +-
>  mm/page-writeback.c                                |   7 +-
>  mm/page_alloc.c                                    | 199 ++++++-
>  mm/page_alloc.h                                    |  22 +-
>  mm/show_mem.c                                      |  49 +-
>  mm/vmscan.c                                        |  58 +-
>  tools/testing/selftests/dax/.gitignore             |   3 +
>  tools/testing/selftests/dax/Makefile               |  10 +
>  tools/testing/selftests/dax/config                 |   6 +
>  tools/testing/selftests/dax/kmem_private.sh        |  94 ++++
>  tools/testing/selftests/dax/kmem_private_cpuset.sh |  70 +++
>  tools/testing/selftests/dax/kmem_private_policy.sh |  58 ++
>  .../selftests/dax/kmem_private_policy_tool.c       | 620 +++++++++++++++++++++
>  tools/testing/selftests/dax/kmem_private_rebind.sh | 301 ++++++++++
>  .../selftests/dax/kmem_private_rebind_tool.c       | 495 ++++++++++++++++
>  .../testing/selftests/dax/kmem_private_services.sh |  97 ++++
>  tools/testing/selftests/dax/private_node_common.sh | 268 +++++++++
>  tools/testing/selftests/dax/settings               |   2 +-
>  55 files changed, 3249 insertions(+), 203 deletions(-)
> ---
> base-commit: 15f114dac9a7bde1796f0e54e22726fd31cfa8a5
> change-id: 20261120-private_nodes_v6-64d04596e126
> 
> Best regards,
> -- 
> ~Gregory
> 
