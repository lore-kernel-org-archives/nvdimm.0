Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=52.101.46.53
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1795361541;
	b=lcB/Gx6RsGxtMlmiCpohWJtEpuZpYqpxqdndbb98j/0rtAa5ONu/JSX6ihPfNWqp/dsH
	 Xm3nqAvhMRKKb3KQQRAK2LbZOqwehVbJ4ZRbe7EuRbu9dyRTXyY8KIf2qKEduNDJ6l3bo
	 EUa/oyEZQu9Np/BVPZpTf5XcMsmOe90G4EvMt9XBQTm8Js6flBmJ3LjKUdWOkMZjrZxVA
	 1odXIKGG1r0cX6k6820ySKsdc9rmyUTVG0mYTm4ea8IZDZ/oRt+U80WEBDFQYmR7tNnbO
	 heQhHLvbneUhDWjHLheupBG6j6rtBDuyChpuGulWjt7yYz2f4yJFhWkGXfvRU9bbAWw==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795361541;
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
	bh=WhMslJCGDuB5xV6P/V/CS6QxivMchvG1o2S2D3SeU7Y=;
	b=gW27EoVDs8AscMkgTosrkzC1K6Hw8dGhPlVMtGD6WpKGiiVNEcZl5RTORaCXFYDhgkKJ
	 kFXAtgm2zJ8eGg4cLuioAJ+N1kGZYjVgrbcSq/99w9FMoFK1Nw569rrCf0TxZqSYvSk7/
	 mpp4niAw2XsXJUPYzjueXmk2i2RdwFIzZkutSIPJutBEBXqth/RdVITir8s+TAVHlrOlv
	 ScH5et/v0ScVRu/FreWsLnFh3nUdCRj8IrzKiqkXgstzlNRGIWuVVcw9dsM1654Prvpot
	 EXx9pQ+2lDgzMnSTBx1k9OzFxnA3YhKQxQ+pimF+/4MjzpfJLUYSdUE3KoG8OGoMF/g==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=nvidia.com;
	spf=fail smtp.mailfrom=nvidia.com;
	dkim=pass header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=cr8yLoOX;
	arc=pass header.oldest-pass=0 smtp.remote-ip=52.101.46.53
Received: from CO1PR03CU002.outbound.protection.outlook.com (mail-westus2azon11010053.outbound.protection.outlook.com [52.101.46.53])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (secp384r1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 79EBF606A336;
	Sun, 22 Nov 2026 15:32:21 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 79EBF606A336
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=cr8yLoOX
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=EHDbKitQys4tuIJDtOY5hUPO4Aj3x5WFLIkuQAlApmE2Q4b3YqB9ZH0lsXrMWpNWZv4NiqHhOCcsrGr1WeDorLAYdBe1EzhEuzo2hwf3RVevCgsz1wlZEVWlQABbgcVrtJ8r1wQqeHnlPLJd2OdiWxyCZjL9Go+lUtuOSoVTC0G5YC0SI4AJiCrgdjAPFdMQHWKwcwbNF9OnQ5yHFjl2oO8pdHHQMvJl7Ia5UdOGppFcn48kN6aHfWbXqupCUbc1C7Fv8api71Og+633PRFwVKA1tguNsATBHjC3/Jq9NMFwtyQX7ElH6E9N1POgmukkKV0hqNphXQmGmk0auArSCA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=WhMslJCGDuB5xV6P/V/CS6QxivMchvG1o2S2D3SeU7Y=;
 b=G5n5JBi3HZk5TpGj4hj4HR3PdWpu1EqeSUnhBqlDdM8kTUi8QzX+4jKpS5z3HihfW7cgxr9rTFIcU/mtuF7qo8JX4b5ixE3Y796dIzL/qDhx3kXMeZHAltsyrGLj4c/1zvnrE2YhlSjtq9bDac67FJJi1D0XOakMJdgW87uYiH2xI3NAvHVuTZpZnMABCBW/QcUyisX6Tko9D2YkmOt3rOk2oWeLUiSpJZY/LWNCCGy+XABBr6SAiD8/gz+eVZgL496UwaGRxc9KVynJchUZ6Tu/tZMIR5hYe5X6v4Hh9MZzuWijV4SRMj8oNUq5A/Dt+/niX22GJOel+IJ81JH/OA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=WhMslJCGDuB5xV6P/V/CS6QxivMchvG1o2S2D3SeU7Y=;
 b=cr8yLoOXqwaA1c+Xblj201hZ1aXiuuG6UWySgT+ibVPblnFFwvfbrVnxM7sGd3KkhRmA2335SaSiM8fZqoNrGRi2RbSq/mgJHcohbQinfFYLUSw6O2nnFuWCqXKi8ZTDrSJLjpTIwmTLeeXEt3xlYsnRA9PfhT2aQyHh2pjEInlpjG1OQhcURJAY26uUDk94yMcwxH9cHtKmDxRRVRXiurMMIfz34Ge7WZvlu4M9eBLogajqQTY9a1QHUrmdfgVKr3OLxPARno8sqbFL3EjM7/qRiuhvjoB8FqpCZKWwBzJIqxACXORlL9mu+pndzSpz3bgdplgOAMfYw18VkOyLxw==
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from LV3PR12MB9356.namprd12.prod.outlook.com (2603:10b6:408:20c::21)
 by CH3PR12MB9284.namprd12.prod.outlook.com (2603:10b6:610:1c7::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.639.14; Sun, 22 Nov
 2026 15:32:07 +0000
Received: from LV3PR12MB9356.namprd12.prod.outlook.com
 ([fe80::1c36:31b4:c420:6286]) by LV3PR12MB9356.namprd12.prod.outlook.com
 ([fe80::1c36:31b4:c420:6286%4]) with mapi id 15.21.0639.012; Sun, 22 Nov 2026
 15:32:07 +0000
Date: Sun, 22 Nov 2026 10:32:05 -0500
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
Subject: Re: [PATCH 01/60] nodemask: add node-state iterators
Message-ID: <awMK9V6TbU9Xtzn9@yury>
References: <20261120-private_nodes_v6-v1-0-74f5f9a115c2@gourry.net>
 <20261120-private_nodes_v6-v1-1-74f5f9a115c2@gourry.net>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261120-private_nodes_v6-v1-1-74f5f9a115c2@gourry.net>
X-ClientProxiedBy: BN9PR03CA0336.namprd03.prod.outlook.com
 (2603:10b6:408:f6::11) To LV3PR12MB9356.namprd12.prod.outlook.com
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
X-MS-TrafficTypeDiagnostic: LV3PR12MB9356:EE_|CH3PR12MB9284:EE_
X-MS-Office365-Filtering-Correlation-Id: c6485a54-1825-442f-628f-08df48adc424
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|23010399003|366016|10070799003|1800799024|7416014|376014|10067099003|56012099006|11063799006|4143699003|261021121427099003|261102123227099003|261009223027099003|18002099003|22082099003|6133799003;
X-Microsoft-Antispam-Message-Info:
	LadQk4uEsSebAaX36T2UMlD0k4aavvFJnGPyxq+sADDdoHz7h1S6cTm+9lwN2JuY+RhbZsAgBtH6HMrwaEs/1qoNwhCMXCD2HnT3piotu6CJhWi/zGa/x2kT3WvqgBYvrCRtXMV5byjJlFSa1Jfz2Z8Es8KqjJ/gP6DZ2VArDv3yVj5pPa+ZBvrppiFRCswwB+ZHiGKW9YWzBKGuNP+swVrsTET4lfSO/bT6JGwcEJAk4oAymrrQuP4kHwUsgRG0ONuqW69rZz34qgY2VzJiBrdY0IloGE1UIWWnNTM49Lemtc0UUlQ1LWF+KQtBZLWotV+9HucWijaFAQeLEouCDhaBiHWDCbkPaIYs1ijCLrdLfbpQWCHOIeZDVBboKpLNdpwAH5yTbh9XuDiHQjnOa52O8UH8hVIkGKvO4rmzHkJ4zuxhAeJV5BVjZs1dnRrbf+Zr2yALfauusWyHdhBvzh8mpkvQhguRY1p1v7/SaRa0p2DHBXmd805eyd7d+XI/367SUORKBEhSqopdRKVQQ+s3kmJ5FGjbepuputL8d/8bDEKKf4r1mwN+speML64l5Uja4AhFfhfUX2fQ9bcmlGAVrQbpl3yTTwZajpRZ59PJG/gbGGmT9vfmPokHenri9636b4Tgb3WBRlCk3okioAUGEdJsQCDwDgsbtAGC2bA=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV3PR12MB9356.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(23010399003)(366016)(10070799003)(1800799024)(7416014)(376014)(10067099003)(56012099006)(11063799006)(4143699003)(261021121427099003)(261102123227099003)(261009223027099003)(18002099003)(22082099003)(6133799003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?0878Rh0OU0ASRuFo6sTdoF3SxBqX7ikevLQHYzhknEeGzOQ2B2i3oyhkWmcB?=
 =?us-ascii?Q?vdC0RV17nq5Ut/rsXr2QZcjCnVcWfnPDwx4CE/S/3ITrkFrSxtRIVb57b5TE?=
 =?us-ascii?Q?12ScIl2aqKaC61hbvkut8h1CScZIOXaKEOSAPZQlVJeBESw1+J54nNhRYJpj?=
 =?us-ascii?Q?q+N7YQPfjLLtxxFDpFRzb7RZaMPPwn+ImCVVh3yYk0zz1skuph4r4OrNDGtl?=
 =?us-ascii?Q?qkoqiahw6e2odkS6anbXxrt2Om8f/9pUD9dTILttqGt9LbpROxJ2/A+rs8qB?=
 =?us-ascii?Q?skcevIIA70HVfuwop8HFzHVfAmhOJh4uX008ShwOtG0uBJHCj0LkE1B75U4A?=
 =?us-ascii?Q?ebER04WVfRArUCB8JwqdTJcNJXiX9d1MAOsYaEIbQts0iZodjls9ft6wDHFH?=
 =?us-ascii?Q?r6P+wOoklKSj/vKZOZpZu8J9O6dY9tbmeo5yYfLC2K4WRf53iCXXF23bfd+9?=
 =?us-ascii?Q?tIFtYp/soKOKQydkgswzkr+ZfFk5L8KWagu2ysOvEfxlM3ztcxZDMt9wPV/a?=
 =?us-ascii?Q?kD1BPzvOZDDVr8SZPmJ3hEMWqLo5Hwe/zE+iBtxu2MWiZs7YFKFntevkZ/A9?=
 =?us-ascii?Q?p7RCcL9+gTx8Y3GetF7l+gaEZUFd3mgEyTRwUdkMKMy1AXmt7471f8TFYrAE?=
 =?us-ascii?Q?ppqEIDUMRaQinZdGh1ahBy2iFSvmNh5qX064NaVJo2nh3I66QQmSzAVKzYHC?=
 =?us-ascii?Q?h1h2//nE+Ngekq3CW/h9KEsqk+iIvzl5cLCZ42JTQsbpDBnI72HIChThNP8q?=
 =?us-ascii?Q?7rczyuAAqbWQo/bNvfd3slvoGpWdsjtQBfjyXmHha7ZSsdmPnqhO70FlNKLo?=
 =?us-ascii?Q?DxPExNWZL3O7MPko9uFk2GpM8EsiD/kdfJtC1ofMNInyivne/bbGTSmeeiif?=
 =?us-ascii?Q?6Gg7r5MtxZ8tjLyV0WuNqgoEHbohtKw+hpHTortmoZmsTVnhcjvbg7Lm9HL/?=
 =?us-ascii?Q?dFVu0Pdgj+HSAbUj6Y9zY1DBu0lAdO16r94YDlXyd4TiPnHhK3QOMiMNJZuO?=
 =?us-ascii?Q?icAU7Udp7fOt7HjE2sFh1hVsMbLTRoANkXvwWs6QKFecXZO7DSJ3eT490eHY?=
 =?us-ascii?Q?QDnjQ5uCNL+Ao8ZIXN1qwATdl6d4j6vswBAHClf5u5W1wcyA2dCm7+/mXrDe?=
 =?us-ascii?Q?8l4RUOVPDgu3N28TZqS83YQ27xcjHf2Yb+ijh2PMGCtZpD+WX6XdNwP/1Dve?=
 =?us-ascii?Q?JgXMO5RnzA8CcoCenR6pxc06iEAxz71/MjWF3b0oXzaMKWDblsxxvi0qL6wk?=
 =?us-ascii?Q?suYN7jZCmtP8qRBLGWqXe53Ug4Cib3eRbS/Ta4K5zjwgSbKzRZM6axMETgM2?=
 =?us-ascii?Q?cPDKiMuak1fpXPue32bB10pQn7QbxG8x4LKK3mUC011F2mau0n0MMV2OehIN?=
 =?us-ascii?Q?pal+m9ZylTSgCp9ICXUOUiMgAjacNp1DuAL5iwETjyo7fiCsC/qbCN9T/wpV?=
 =?us-ascii?Q?g1qHrtgXxOuaHmAXoVHC4sSB7hGeNfd0gDvODHF17K0jBEWnNdqzAEO/5ZWO?=
 =?us-ascii?Q?PguKAGxJWxeP2VTmK69UWOvI7hIWQQSbh6PAjuWtGlMY/JQy/91+7SGAHJnf?=
 =?us-ascii?Q?vjvkTx0LQVwjsvvg2B5FKpNt+c9DmlMgWm79kZ/gKUY3O+/EdnWTD1Pgp4Gq?=
 =?us-ascii?Q?pjLJ4vb+cGoeqVvNk+Eg72QSgLlZSW0TCWAeyVkAxZnoExgRM3QCTiOyGXdo?=
 =?us-ascii?Q?jYlbLkU89rqfHTdlofrWERfbLIhveKByfPLzZ3P/Og8PCd8Y5LTrHWML7ZH1?=
 =?us-ascii?Q?F2/DTg4BcCxL1MBVmHECkDpT6XYb12pDshSJ+5onFzgnC8b4MOgR?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c6485a54-1825-442f-628f-08df48adc424
X-MS-Exchange-CrossTenant-AuthSource: LV3PR12MB9356.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Nov 2026 15:32:07.0533
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: rew2IPNPi3eMjUW2rOx/D54VR1hE34BYSZEp/L4/4gyRLjUNdp187rMrRSfQ73nncADw0FzzNhR/N3gz2QevhA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH3PR12MB9284

On Fri, Nov 20, 2026 at 01:08:52PM -0500, Gregory Price via B4 Relay wrote:
> From: "Gregory Price (Meta)" <gourry@gourry.net>
> 
> Add first_node_state() and next_node_state(), so callers can walk any
> node state the way first_memory_node and next_memory_node walk N_MEMORY.
> 
> Add for_each_node_mask_state(), which iterates a nodemask intersected
> with a node state using the bitmap intersection helpers, without a
> temporary nodemask.
> 
> Signed-off-by: Gregory Price (Meta) <gourry@gourry.net>
> ---
>  include/linux/nodemask.h | 17 +++++++++++++++++
>  1 file changed, 17 insertions(+)
> 
> diff --git a/include/linux/nodemask.h b/include/linux/nodemask.h
> index 607373bd83ee..90bdcffa42ea 100644
> --- a/include/linux/nodemask.h
> +++ b/include/linux/nodemask.h
> @@ -411,6 +411,11 @@ enum node_states {
>  
>  extern nodemask_t node_states[NR_NODE_STATES];
>  
> +/* Iterate the nodes in a mask that also belong to the specified state. */
> +#define for_each_node_mask_state(node, mask, state)			\

for_each_node_state_and? We've got for_each_node(), and we've got
for_each_node_state(), so let's figure out consistent naming.

Did you check the codebase for exsisting candidates for this helper?

> +	for_each_and_bit(node, nodes_addr(mask),			\
> +			 nodes_addr(node_states[state]), MAX_NUMNODES)
> +

Please use nr_node_ids instead of MAX_NUMNODES.

>  #if MAX_NUMNODES > 1
>  static __always_inline int node_state(int node, enum node_states state)
>  {
> @@ -435,6 +440,12 @@ static __always_inline int num_node_state(enum node_states state)
>  #define for_each_node_state(__node, __state) \
>  	for_each_node_mask((__node), node_states[__state])
>  
> +#define first_node_state(state)	first_node(node_states[state])
> +static __always_inline unsigned int next_node_state(int nid, enum node_states state)
> +{
> +	return next_node(nid, node_states[state]);
> +}

At least the following {first,next}_{online,memory}_node must be
switched to the new helpers. Can you check through the rest of the
kernel to make sure all candidates of the proposed helpers are
converted?

>  #define first_online_node	first_node(node_states[N_ONLINE])
>  #define first_memory_node	first_node(node_states[N_MEMORY])
>  static __always_inline unsigned int next_online_node(int nid)
> @@ -481,6 +492,12 @@ static __always_inline int num_node_state(enum node_states state)
>  #define for_each_node_state(node, __state) \
>  	for ( (node) = 0; (node) == 0; (node) = 1)
>  
> +#define first_node_state(state)	0
> +static __always_inline unsigned int next_node_state(int nid, enum node_states state)
> +{
> +	return MAX_NUMNODES;
> +}
> +
>  #define first_online_node	0
>  #define first_memory_node	0
>  #define next_online_node(nid)	(MAX_NUMNODES)
> 
> -- 
> 2.56.1
> 
