Received: from BN1PR04CU002.outbound.protection.outlook.com (mail-eastus2azon11010030.outbound.protection.outlook.com [52.101.56.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 691B025B08B;
	Sat, 18 Jul 2026 02:29:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.56.30
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784341761; cv=fail; b=O40YF7QMUIcPAz8GuwWBfoCHwcs6+UcnPP6kv+iNf5Aj/ygrfbB/FtdWU4S3lAOTvPCIzHgpQy0x6yv4gQQW8cvXIuUHyWIo3M9jzKTBUjnjHKrPuXbcmlrcrqC8GGq7IR14cUhrQlXIvs4Q8PHBpbnUEyt3Z0utk3XtZNhsyzI=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784341761; c=relaxed/simple;
	bh=t5s1beX22HEgOi+4xRnFk9o1Nlsu6qB0Kn2ejJAUxVQ=;
	h=Content-Type:Date:Message-Id:From:Subject:Cc:To:References:
	 In-Reply-To:MIME-Version; b=BSt7NxoMw5PL4QdP/HlClkdf033ye9SAMf8UJdgfB9gPXZeZDsgjr1JWv6nfJ5t0e9fKJITpm/dscY+QQS75WXxXy2KA/APvarv14UzU1Pxor1RySFGk5y4B35jbma775uOM8u5EoX3lM7QIehZy7h4soatZ7xWvboFv4+jKMC0=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=QkJ9lzv5; arc=fail smtp.client-ip=52.101.56.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="QkJ9lzv5"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=yeknUtwfkgS5WqRe+fnd5QACydjsHcbV99V18heNUjnamZnoG1GZxRs9Ky/EY7ZtJO77YYq7L33BPfEMOFaDKczIeaTq/JEA1HjondK3upueMDXBxBNSGA3/o5QVe7cwKPN3ECReSomziK35Kfqh3e70ptrw1g6O2taAsTpXhVeMO+V/dXflFuT2Ouu1Mz3T6u1gO4kiYjjDjNGPhga4RB97PtyLG/7uUWU8YayExlJ0HGJcrjsV5afLqY8zsZjKKVE4wJUBpJbC72dEcy9a9G8lcTwS8O1HmB08MPIOYRiv/Ignil0YGn7fJyLrlXcEKIPWL7+ulMSkxhpTny9Gjw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=oXj8bnBdLhkKSDZOuc1OyK/vquSlEaXtBgRHVDjXnE0=;
 b=n1RxgTrkQGnIXt5TzXm5F1yIura7dn5b7bXhz5S5NC4L6kCD7j0G+H1eX4z9JrwLMkW1FiOv5Yqngd3GqPihhHLzfOUmoSy3n5fe/HyjY6sIshZ3hk33uHy+21CdLT9PWauSg57lUcDg/CbgyAJKXaun5X4TUJbjJQQd7xEEHkhpK+sxk2EpqrOFHBG+ra/+dI7HjV3vhtV9qBo17lv+eRp7HjzT1T/mwlRxL5oHqT1CAfvx60DsLfIVTL8GyzT0hCBtje5f+fe3eVsFGCD2K6ntaV8ygbQlpwgPQsDOVhKqTRAt/pwxSSxNGlJB0SVqMHNZoTc9WxSTbUDNLkkqRw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=oXj8bnBdLhkKSDZOuc1OyK/vquSlEaXtBgRHVDjXnE0=;
 b=QkJ9lzv5UiTBRPyJe09J9xmBYAuZq2yv/ib81XnEWhnnALsQqjj1eVwaHA0EbAfK+8h9ve7i86kVFdVx9rGWHQupTngMFWf4Sjh5Y1pq5Up1BDJwfSMqQHlYm3/e3TpxgMJ9nNEinXngJptEHsTaQ6viK3cS5YYAIAUJid9tBJM55ISr6tni/bUxBhcy5r7tNQzj+muY1i8nzAJcr8AZZu6Ul3BJqJiDh4jm6C9jhe3SQPHm6dGe2kGMQtlzfqQzGq3r5T3Kp889wN+FD24epqJ2QLKyxCye5aF5JXQNpXdnW8MbUYACJL7fcsMpsgWo5J8n3aTztMijT3pjuvcTDg==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from IA0PR12MB8374.namprd12.prod.outlook.com (2603:10b6:208:40e::7)
 by LV9PR12MB9782.namprd12.prod.outlook.com (2603:10b6:408:2f2::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.223.13; Sat, 18 Jul
 2026 02:29:13 +0000
Received: from IA0PR12MB8374.namprd12.prod.outlook.com
 ([fe80::d85f:4c87:ae84:3f16]) by IA0PR12MB8374.namprd12.prod.outlook.com
 ([fe80::d85f:4c87:ae84:3f16%5]) with mapi id 15.21.0223.012; Sat, 18 Jul 2026
 02:29:12 +0000
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8
Date: Fri, 17 Jul 2026 22:29:09 -0400
Message-Id: <DK1CCZLJK94M.M2YF388E68NK@nvidia.com>
From: "Zi Yan" <ziy@nvidia.com>
Subject: Re: [PATCH v2 01/33] mm: move vma_start_pgoff() into mm.h and clean
 up
Cc: <linux-mm@kvack.org>, <linux-kernel@vger.kernel.org>,
 <linux-arm-kernel@lists.infradead.org>, <linux-parisc@vger.kernel.org>,
 <linux-fsdevel@vger.kernel.org>, <nvdimm@lists.linux.dev>,
 <linux-perf-users@vger.kernel.org>, <linux-trace-kernel@vger.kernel.org>,
 <damon@lists.linux.dev>, <iommu@lists.linux.dev>,
 <kasan-dev@googlegroups.com>, <linux-sgx@vger.kernel.org>,
 <etnaviv@lists.freedesktop.org>, <dri-devel@lists.freedesktop.org>,
 <linux-arm-msm@vger.kernel.org>, <freedreno@lists.freedesktop.org>,
 <linux-tegra@vger.kernel.org>, <kvm@vger.kernel.org>, "Russell King"
 <linux+etnaviv@armlinux.org.uk>
To: "Lorenzo Stoakes" <ljs@kernel.org>, "Andrew Morton"
 <akpm@linux-foundation.org>, "David Hildenbrand" <david@kernel.org>, "Liam
 R. Howlett" <liam@infradead.org>, "Vlastimil Babka" <vbabka@kernel.org>,
 "Mike Rapoport" <rppt@kernel.org>, "Suren Baghdasaryan"
 <surenb@google.com>, "Michal Hocko" <mhocko@suse.com>, "Rik van Riel"
 <riel@surriel.com>, "Harry Yoo" <harry@kernel.org>, "Jann Horn"
 <jannh@google.com>, "Lance Yang" <lance.yang@linux.dev>, "Pedro Falcato"
 <pfalcato@suse.de>, "Russell King" <linux@armlinux.org.uk>, "Dinh Nguyen"
 <dinguyen@kernel.org>, "Simon Schuster"
 <schuster.simon@siemens-energy.com>, "James E.J. Bottomley"
 <James.Bottomley@HansenPartnership.com>, "Helge Deller" <deller@gmx.de>,
 "Alexander Viro" <viro@zeniv.linux.org.uk>, "Christian Brauner"
 <brauner@kernel.org>, "Jan Kara" <jack@suse.cz>, "Dan Williams"
 <djbw@kernel.org>, "Matthew Wilcox" <willy@infradead.org>, "Muchun Song"
 <muchun.song@linux.dev>, "Oscar Salvador" <osalvador@suse.de>, "Masami
 Hiramatsu" <mhiramat@kernel.org>, "Oleg Nesterov" <oleg@redhat.com>, "Peter
 Zijlstra" <peterz@infradead.org>, "Ingo Molnar" <mingo@redhat.com>,
 "Arnaldo Carvalho de Melo" <acme@kernel.org>, "Namhyung Kim"
 <namhyung@kernel.org>, "Mark Rutland" <mark.rutland@arm.com>, "Alexander
 Shishkin" <alexander.shishkin@linux.intel.com>, "Jiri Olsa"
 <jolsa@kernel.org>, "Ian Rogers" <irogers@google.com>, "Adrian Hunter"
 <adrian.hunter@intel.com>, "James Clark" <james.clark@linaro.org>, "Baolin
 Wang" <baolin.wang@linux.alibaba.com>, "Nico Pache" <npache@redhat.com>,
 "Ryan Roberts" <ryan.roberts@arm.com>, "Dev Jain" <dev.jain@arm.com>,
 "Barry Song" <baohua@kernel.org>, "Miaohe Lin" <linmiaohe@huawei.com>,
 "Naoya Horiguchi" <nao.horiguchi@gmail.com>, "Xu Xin"
 <xu.xin16@zte.com.cn>, "Chengming Zhou" <chengming.zhou@linux.dev>, "SJ
 Park" <sj@kernel.org>, "Matthew Brost" <matthew.brost@intel.com>, "Joshua
 Hahn" <joshua.hahnjy@gmail.com>, "Rakie Kim" <rakie.kim@sk.com>, "Byungchul
 Park" <byungchul@sk.com>, "Gregory Price" <gourry@gourry.net>, "Ying Huang"
 <ying.huang@linux.alibaba.com>, "Alistair Popple" <apopple@nvidia.com>,
 "Hugh Dickins" <hughd@google.com>, "Peter Xu" <peterx@redhat.com>, "Kees
 Cook" <kees@kernel.org>, "Marek Szyprowski" <m.szyprowski@samsung.com>,
 "Robin Murphy" <robin.murphy@arm.com>, "Andrey Konovalov"
 <andreyknvl@gmail.com>, "Alexander Potapenko" <glider@google.com>, "Dmitry
 Vyukov" <dvyukov@google.com>, "Steven Rostedt" <rostedt@goodmis.org>,
 "Mathieu Desnoyers" <mathieu.desnoyers@efficios.com>, "Jarkko Sakkinen"
 <jarkko@kernel.org>, "Dave Hansen" <dave.hansen@linux.intel.com>, "Thomas
 Gleixner" <tglx@kernel.org>, "Borislav Petkov" <bp@alien8.de>,
 <x86@kernel.org>, "H. Peter Anvin" <hpa@zytor.com>, "Ian Abbott"
 <abbotti@mev.co.uk>, "H Hartley Sweeten" <hsweeten@visionengravers.com>,
 "Lucas Stach" <l.stach@pengutronix.de>, "Christian Gmeiner"
 <christian.gmeiner@gmail.com>, "David Airlie" <airlied@gmail.com>, "Simona
 Vetter" <simona@ffwll.ch>, "Patrik Jakobsson"
 <patrik.r.jakobsson@gmail.com>, "Maarten Lankhorst"
 <maarten.lankhorst@linux.intel.com>, "Maxime Ripard" <mripard@kernel.org>,
 "Thomas Zimmermann" <tzimmermann@suse.de>, "Rob Clark"
 <robin.clark@oss.qualcomm.com>, "Dmitry Baryshkov" <lumag@kernel.org>,
 "Abhinav Kumar" <abhinav.kumar@linux.dev>, "Jessica Zhang"
 <jesszhan0024@gmail.com>, "Sean Paul" <sean@poorly.run>, "Marijn Suijten"
 <marijn.suijten@somainline.org>, "Tomi Valkeinen"
 <tomi.valkeinen@ideasonboard.com>, "Thierry Reding"
 <thierry.reding@kernel.org>, "Mikko Perttunen" <mperttunen@nvidia.com>,
 "Jonathan Hunter" <jonathanh@nvidia.com>, "Christian Koenig"
 <christian.koenig@amd.com>, "Huang Rui" <ray.huang@amd.com>, "Matthew Auld"
 <matthew.auld@intel.com>, "Jason Gunthorpe" <jgg@ziepe.ca>, "Yishai Hadas"
 <yishaih@nvidia.com>, "Shameer Kolothum" <skolothumtho@nvidia.com>, "Kevin
 Tian" <kevin.tian@intel.com>, "Ankit Agrawal" <ankita@nvidia.com>, "Alex
 Williamson" <alex@shazbot.org>, "Paolo Bonzini" <pbonzini@redhat.com>,
 "Shakeel Butt" <shakeel.butt@linux.dev>, "Usama Arif"
 <usama.arif@linux.dev>
X-Mailer: aerc 0.21.0
References: <20260710-b4-pre-scalable-cow-v2-0-2a5aa403d977@kernel.org>
 <20260710-b4-pre-scalable-cow-v2-1-2a5aa403d977@kernel.org>
In-Reply-To: <20260710-b4-pre-scalable-cow-v2-1-2a5aa403d977@kernel.org>
X-ClientProxiedBy: IA4P221CA0009.NAMP221.PROD.OUTLOOK.COM
 (2603:10b6:208:559::11) To IA0PR12MB8374.namprd12.prod.outlook.com
 (2603:10b6:208:40e::7)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: IA0PR12MB8374:EE_|LV9PR12MB9782:EE_
X-MS-Office365-Filtering-Correlation-Id: 73d19c07-b58c-4be1-4125-08dee4745afe
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|23010399003|376014|7416014|1800799024|22082099003|18002099003|10067099003|11063799006|56012099006|4143699003|921020|6133799003;
X-Microsoft-Antispam-Message-Info:
	Uk7dNbIES91Jw5bLDfNNIhIzoMWljZeDLhn9j0zTCUhpB6WBeP3wbnzP4dEYTMOeMVlWQXrgKSXgZ2Fj0Nv93ee3l/+jP2SRn1vk1/cSbWAIChvKcfxwJXS979uMzTBrh5SeBTOsgY8li83s0lcqS8Nm0Uf7iONYGSNF9MyTLdXM+h41HDp48BhxjW4WdwPbg54Sk3G02gJkDBbD6fysY4WrNPxTwKF+juCG/z/6815zNCAtJ5HJMFTgrm5wP8208PuGCkR5FlWZfc90MMx0Yhvn8iRSAFk8JQdFlrwh/TXNZpxUz/8qtPa9yx7E9ViH9HZRaa0l+2+tCSrqgJde8FxAOCBQXGq26JJEDmBMPilxHE+WBAPGxWrrZeMgd2rCrt8tssBcWDO6tex4UBiIKFW3wyOR6KRbzd+XsZif9chy3CDMF39Oq8ah/G4gUOy32/cDSQWXrGrxYgJwBJZXpy4DcCdHiqjq1g60p6SHXUc1DCAT8A91J9yjXZVmQfnpj7wxcb/brD8VqS0KGJFyJjjrwPzYRLk3JkVlimxtUpdP8AAThIrNzZoTHVbApXNCkIBkZVZcreG4hDZEoGwOfYHftZrGz6IsWHEG8Zu8QcYKXviU0Wrhb8HgK+PsJOTFTCsUDd+08J7mU5N0M4CpJ9SgT7Ov12NqBWDlb6hOh2koUjGcIRhwhQyB4vqfQA0IEZAcb1DeYPBpWbeC2AiP3Q==
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:IA0PR12MB8374.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(23010399003)(376014)(7416014)(1800799024)(22082099003)(18002099003)(10067099003)(11063799006)(56012099006)(4143699003)(921020)(6133799003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?cFE0TDZuTXJSclRaTis0eEMzdGp2elRRNURRQnl1TnoxWS9tSEdJQVZRUnVv?=
 =?utf-8?B?SVlzNEV3NUxqdjYxSUhEWitKYW9RTXF4bGVSVnFpYTB5QVk0V1I0ZjRXWGlT?=
 =?utf-8?B?SWdsdjZnMlBzT0ZYQ1FHa2VvM1hQb0tHbzl2bmVHeFNqUllRQ3Z6bGpwZ0RW?=
 =?utf-8?B?Myt0ciswemlLRGNUWjdNWEZsVXJQVVQxUFc1VnJGNEZFWXhGOThiQmFhcmVV?=
 =?utf-8?B?UE5kWjNBSkdTMlVVbjZCRTdvTHBZSjcvdjlwWFQ3NjFjd1RSQ0VJWk5FTjYz?=
 =?utf-8?B?Wnorb0szaDlPWEl3cjRvenJNR2luNWFjRDRuQzRraU5HR1N6NUNkL1M0aWZa?=
 =?utf-8?B?MnN6dDZhMXdGUGt0eEtiYXBJUi9zSnV2a0hieGUxbi81NzZMQzVHOVJyVElU?=
 =?utf-8?B?Y0poRTdYc1ZwbmVSUDh1QURid0s4LzhCTGd3Y0pCN01kU1h5N3JFeUlTUkNz?=
 =?utf-8?B?RzZCS2NKSjZCMGhWUXZXTlNrY3ZRZno4M1BKSk9TWXQ5R2hUTTZTNEplTFk2?=
 =?utf-8?B?SytqRG96ZGZwdFRlTVhCeEdhclhOc0RQVTNhcU9DVGpiczdnblovM3FzdUtm?=
 =?utf-8?B?U2tTeFZ4bTVCMlFPYmlYYzhtMWNqb3p0RFhvWHZyRkVnNHgrcG1NMFBKSGtm?=
 =?utf-8?B?aFprQys2cWlSRnUwYUowU0Q5enFFU3JIMVY1L1VDNWFHZlJkRlZIMDdWRmhY?=
 =?utf-8?B?emVxWms0MzhyZGMvZmk4a0xlaEQvUDE1M2ZnWTJOMFJ4cE5YaTRBaFNzd0Nx?=
 =?utf-8?B?QS9jYlVpRWc4aXB0Qm0rdWhyeS9NUEl1NndMV1JUN2U2ZXY0MThqWjd3SHB4?=
 =?utf-8?B?VUNrN2g2ckdqcXg1N0U5S2FCK1ZpRmN1UVUwTmszaGpreTFRTE4zMHNERDJ2?=
 =?utf-8?B?U1h0S1JJVHUyV0lVc08vQzFleXdFWkROMmFETHB0QktCREFrUEtMNFdTWlAr?=
 =?utf-8?B?OVM3aUR0RW5uWDlzTjBibkM2L0pkQTJ6dVpUalRndXhhaTBESDZzcjlUZ1RT?=
 =?utf-8?B?akl3ODZzRmJpdTFXUEEzN3Z6RHNPUlRhcFFRZEErV3F1TWJ0cTFNOFJDQlZi?=
 =?utf-8?B?YTk0NzBYTzJuRDdwa2pUTkExRHZ3akNPdFpsS1dsSzBlS1ROU2dmNWw4VWkr?=
 =?utf-8?B?cFVpYTFWYzhUdjVlL25sdHBpbkxmdUhISEY0ZzUxVXh2WHBNRVFTK204QU1D?=
 =?utf-8?B?d21TUVo2TnZkbnVjaE93TUVoc2R1OEFKYUF5RENZeERzOHp6OXFTMGkwTDdF?=
 =?utf-8?B?TUc3ZmJpSmthUEJ4QVBMM0gxVG9CTURBakUycUdFN1BMU0NQdmhIMzB3TFRM?=
 =?utf-8?B?bHNzRkZERnNhR0sraklLUkREc3Z3NG5HSTNMRXA1NEtOKzlhZDI0M3dZaXM0?=
 =?utf-8?B?STdJRCtkQnpWSTBDb0FRejcrM01wQy9oQy80bVVVd2xaRU55WFNOeUt4VWxX?=
 =?utf-8?B?c1hBOHBWbjEvbDNudVRnRzN0ZkZCQ2psN0V5VkFLOXhIQUNqRm9PMks1RXJ6?=
 =?utf-8?B?bGRvc3R1Z0ZDU3hHSW1sT0VsZHhqNEdHVmdaV2dSKy85THlLOGVDYm1TRXlS?=
 =?utf-8?B?RHlpT0pJSFBvR0ltWmVMZEpkZEU0MFNrWWtEYk5PVFNUdFRrbGR0NWdwMHcw?=
 =?utf-8?B?L2FtR1Evb0dCb0ZmalR3YURPdDdNOFRwRWZucVozNmR6SzN1aWZCT0dVRWM1?=
 =?utf-8?B?RVJpZGhPeGEyQnpxdjUrQ2VwK1lva09yNkZXTlhJVE9WalV5eGl2MXVKNlNt?=
 =?utf-8?B?bGkrMksyaUpiMkxQWUlOSkdHbW10dkNWY3lvWEd3K2NwWStKQXFtaUVtNGtD?=
 =?utf-8?B?UnU0c3JwUjc4dWh2RUVNYkFGS3FiTkdnVmRuTlZ1UmlrSVU2WlBSMkpGdmZ3?=
 =?utf-8?B?MVpQR3dNYURjcUpHVmZwT0ZhTTNTd1RvVjVjWVYwdVJ5UGFGeUMwZ2xONGx1?=
 =?utf-8?B?c2xTYWkzUTVkQmhLN2UyU3V2ZkE5RTBzSjcxSkI2Z2xtKy9CdXRkTmhHbEN6?=
 =?utf-8?B?NUpsaHBYdFBvTHNXT0RNVldwL2RGQnlod3lRQnNNMXNaOEtHZXZYOUgxY3VX?=
 =?utf-8?B?T05aZXhMMTN2WkJOazFQTUdBRzNwUHN2NHpBYzVLd09uYjZpWVBxN2w2c1lR?=
 =?utf-8?B?VXIyMmpuQkpLQndpbjVlcjRFQks1VTR6Z1RrSWRMMGtxV0V3SnQvcTdoSGd0?=
 =?utf-8?B?THV1M24rZXN6MW93bVFXdDI1VkZYUmNUKzlBcVd1SkhETHUxZm9TZnVIdm5z?=
 =?utf-8?B?VTIvZFdrT0NvOGNtZ1dDcWxwaTArcGIvOXd3S3dQVTI2VVVyVU03c3Y5aGtl?=
 =?utf-8?Q?g2CA3RSpfU1yyyWa8Q?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 73d19c07-b58c-4be1-4125-08dee4745afe
X-MS-Exchange-CrossTenant-AuthSource: IA0PR12MB8374.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Jul 2026 02:29:12.8409
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: VNx1oIY2hUrlouv2w4t+/TaMcE4gXfb02xxyttS9NxunUen8ih+ifNnJ9Ze7GV1S
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LV9PR12MB9782

On Fri Jul 10, 2026 at 4:16 PM EDT, Lorenzo Stoakes wrote:
> vma_last_pgoff() already lives there, so it's a bit odd to keep
> vma_start_pgoff() in mm/interval_tree.c. Move them together.
>
> These each return unsigned long, which pgoff_t is typedef'd to. Make this
> consistent and have these functions return pgoff_t instead.
>
> Additionally, express vma_last_pgoff() in terms of vma_start_pgoff(), sin=
ce
> we wrap the vma->vm_pgoff access, we may as well use it here.
>
> Also while we're here, const-ify the VMA and cleanup a bit.
>
> Also update the VMA userland tests to reflect the change.
>
> No functional change intended.
>
> Reviewed-by: Gregory Price <gourry@gourry.net>
> Acked-by: David Hildenbrand (Arm) <david@kernel.org>
> Reviewed-by: Pedro Falcato <pfalcato@suse.de>
> Reviewed-by: Vlastimil Babka (SUSE) <vbabka@kernel.org>
> Signed-off-by: Lorenzo Stoakes <ljs@kernel.org>
> ---
>  include/linux/mm.h              | 9 +++++++--
>  mm/interval_tree.c              | 5 -----
>  tools/testing/vma/include/dup.h | 5 +++++
>  3 files changed, 12 insertions(+), 7 deletions(-)
>
LGTM.

Reviewed-by: Zi Yan <ziy@nvidia.com>

--=20
Best Regards,
Yan, Zi

