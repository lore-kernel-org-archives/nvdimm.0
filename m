Received: from CH5PR02CU005.outbound.protection.outlook.com (mail-northcentralusazon11012022.outbound.protection.outlook.com [40.107.200.22])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8F6512459C5;
	Sat, 18 Jul 2026 02:46:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.200.22
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784342812; cv=fail; b=HNrLGf0KwRz9oaEBhAhIz+wLP9Cd2Uxyc64YlqA8YEdF29NThOL76Qdvrn+6HDup/cVTj4BLhEf2mjNnx9tMmAvEnDJ3JWGCxIDN8ImAYNdnEltoxnDNR2PJfuOU55XIFqEpEjtG2v0S/3z2f1/nGE5w13ltKPTs6OvmQoRpGvA=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784342812; c=relaxed/simple;
	bh=kZ7OqWRcc/XjnzBToQ75MoPQY7AIqsWK/AhQk3QPHf0=;
	h=Content-Type:Date:Message-Id:Cc:To:From:Subject:References:
	 In-Reply-To:MIME-Version; b=o4g7l0m2EMDpoFztV6KgVHiPDAtULt9oEKwGKP37PFEWgThkHs13eFACDfNBP9myMMc3kViMkR/c6SB9abR1VmFyT8S19uoa88qpM+r6vehxyqEbJFaLZ1F7Qs5Dkg6BH8kDNRNdU268jWQ6L4IKCsYKScA+oMrH6ZPfk7Ctml0=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=uqF2iuEV; arc=fail smtp.client-ip=40.107.200.22
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="uqF2iuEV"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=PrT+qt2i2iQJSl3ClzK1C/HLzBtMww5FRPJGSNOPQjjUnpCQwXaYi5P3oBbEqPLA71sFYZdPvKlyuZEF99srQlAZVpitr4+KsonpVkwtGiJ3RFob1rAp3ObyUjxQblDPMASiP9NkRok3jUlegYJAlh0d368DfqfPyEWEuBpolmp0Uq4pS9JBJkb+OO/C0r8IiSlRxKDooalDkA1wL3CCbXW8iVqktuB6nLt6bom6QjtIQJpkXIBctqxHuBRM0/hEmTLtBNpEqKpkhZYL6AoES701VwzXmfQqy3rBVVvw4c3vVcAYWwHKtOxuIuz4U6iHgaue8AVteZe59gvcyR38rw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=IE4o4KFflr6AJH8l9Jtq3Ng3xv8AQ2eFq7ryhqkzop8=;
 b=M63vQGbJCOUyvPx2egASE/xtCKCiscFEAX87dJBVj04WcHHIpyExl9XVnaW6v5resn+xGxrAvvyzkZqiybcUT8GA5IxRSPofNySw5ehI53OXGnh9l7o/68mKs5ulxzsDi+/sNWEQHz3fGpCswnPGopWTHai47xtt9KBaJFuBIs2awM4UvSMD0OpSG3yVnSxE888lnZwQfBGZOOCthNvRPnytxNhWRlCUg+MZB79hS1qlPNL0BusuZQzLBP9KPWIoEOWc5qREkUTtYgB7C6MXN5uHBHmT9WXoIAnbS/RTeXbC2OvO/GLFfql4ks2Gopvl//EjVBe5NGM0JPFhk1zk2w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=IE4o4KFflr6AJH8l9Jtq3Ng3xv8AQ2eFq7ryhqkzop8=;
 b=uqF2iuEV96qGiGu7lZScYJKCWSkqaS8qK2UHbF2zd/5aUNWW93cJoRbBfHS9rMWgmY7koUgj1ZqtWB/SHZD2u+djgTc+mRdvU6SufppoW35Y9rLP9/U3XJ2t6iMVRMQ2pPG1uK6WP3Q4Q4Gq6n23Y5LfuSt97OVfZJWK26/v3xUXi7Sij4gcFny5TBzsSBN4Y2XML/t/U2oQVCirna/dsyyPkDIEekWAuORTDR48WtLYHt/7HFzBs+NwRZvKlxLpULzOIpOvTex5eedEUa1V+dmmHR/sJ+SxADgGjy8ZCFxZcDhT+PYKWEyzIHSLMbO911VGILa9XyRLFKIIgAy5Ag==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from IA0PR12MB8374.namprd12.prod.outlook.com (2603:10b6:208:40e::7)
 by CH3PR12MB7571.namprd12.prod.outlook.com (2603:10b6:610:147::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.223.12; Sat, 18 Jul
 2026 02:46:32 +0000
Received: from IA0PR12MB8374.namprd12.prod.outlook.com
 ([fe80::d85f:4c87:ae84:3f16]) by IA0PR12MB8374.namprd12.prod.outlook.com
 ([fe80::d85f:4c87:ae84:3f16%5]) with mapi id 15.21.0223.012; Sat, 18 Jul 2026
 02:46:32 +0000
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8
Date: Fri, 17 Jul 2026 22:46:28 -0400
Message-Id: <DK1CQ8VE2HNU.3O89F8A7K6WOZ@nvidia.com>
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
From: "Zi Yan" <ziy@nvidia.com>
Subject: Re: [PATCH v2 07/33] mm/rmap: elide unnecessary static inline's in
 interval_tree.c
X-Mailer: aerc 0.21.0
References: <20260710-b4-pre-scalable-cow-v2-0-2a5aa403d977@kernel.org>
 <20260710-b4-pre-scalable-cow-v2-7-2a5aa403d977@kernel.org>
In-Reply-To: <20260710-b4-pre-scalable-cow-v2-7-2a5aa403d977@kernel.org>
X-ClientProxiedBy: MN2PR14CA0021.namprd14.prod.outlook.com
 (2603:10b6:208:23e::26) To IA0PR12MB8374.namprd12.prod.outlook.com
 (2603:10b6:208:40e::7)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: IA0PR12MB8374:EE_|CH3PR12MB7571:EE_
X-MS-Office365-Filtering-Correlation-Id: 62b1feeb-a0ab-445d-2c34-08dee476c668
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|7416014|376014|23010399003|1800799024|921020|6133799003|56012099006|11063799006|4143699003|10067099003|18002099003|22082099003;
X-Microsoft-Antispam-Message-Info:
	oePMsU6b5fTH9NcDJmCfUt9DDWvKgBtsS4kOkvbWefijHH8JmEJDFos/+kekKDII18zBkGesWV27kmI4QXcREalRWoA04Q9OEoUsaIQO2mLKqtkytjz/Qsqy60UED517v6vzzjqP0WPIwm5VSWkCZCCakE8aH2qoQzQyNODiJgxaUfR9UzIvOSRrc06+DuQJBzXAH9ZaRbLCi6m/pYvcZHKqiEjmN1K5jInoBhkg/pb7Q7YX8erprW5H9LimzNPkCD1fByJ9nmeO7yLxtm2r8RHTtrBo0Z8I9zr6ZZ5p2/1CXye/93V2v8BNW4q1+N8ik9sN0r3RZQIfuJd0ZA4MGlxESZMlScaFrfiWjXWfsJ1wNeDpqy0JGM2QzoUnuWH4wI9Wyp6vTe9eS/1KsN9RAoMi6tYrPp3ead/YZNmx8d66+KQK1oYBZEGtek7bKEL8fq0v4uZt6NOiTbxsZw42vOgfGVgnNxR4povDyH+xSr2LBq5FpNOgX3c7UvHwEfj23nuSB0j+E49WQPaZQ1jQ1ryneRfMhZGNNPo8yH/SaaheNBSMkoOzDBQDglEfgpE2q0x0ISokWl+NGyUtWSUNJdh5ns5woZk7sCQtQ2BNQvecKfFREtts5bsLGUArA/51ydv1Zv5i+Zox89dSosmqqJTEUroaqwB9P8UEDA+xFqFkfPMe2OqbNBUsA4ciWJrhiBAEr4Nuyizmt9A8TI+YCw==
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:IA0PR12MB8374.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(7416014)(376014)(23010399003)(1800799024)(921020)(6133799003)(56012099006)(11063799006)(4143699003)(10067099003)(18002099003)(22082099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?UFZlTG5rbjIzclVUQmNjLy82OFpjOXhvcVkxOU1HenpXbEtwOTRFKytNRGRO?=
 =?utf-8?B?emc3Nk5Gb2gwOVlkN2duUU1jS01DOTlqU21RbjhnZDhxdFp1VkN1R2RxY0wy?=
 =?utf-8?B?dkhjTXJ1R0oyVHVodldRaW9idDhudmc1MXVUQnJ1UVZvalFMTm1QWUdrWE54?=
 =?utf-8?B?N080cUkyT0pjMkZMQVI5NnhCNUh1aTBVN0NvRmtXcjVVOXVsVXA2WHI1MG1P?=
 =?utf-8?B?aEhEVmFFa2tlUmhSSUU2Tng3djl0V3BCd1czMStwOU9aVG9aTGovVHBLZUlJ?=
 =?utf-8?B?eG9ZY1lFWExCTWtQN0oweW9jb2xyWXRhR1JKOVBLUk80S0xNVlk2UmRKR2VJ?=
 =?utf-8?B?ZHJTV2hzN1poY2hpLzJxeHlGa0N0MVozdzc2SGVZUFF6YUpRY0tsZnJOQy9s?=
 =?utf-8?B?dW9yQUtzRmxxMFVrSzY0a3BXSVBJOXllbDExcG5RQWw0ZkRWSzIyNGlrWkpH?=
 =?utf-8?B?SXRtMUFjUXVaQjVPcmJNMEhQa0E4Y0hBbk8xZ09KSkVtMnZOdUJtZVlwemp3?=
 =?utf-8?B?SHZSUjhaZ1FzVlVaOC9ud3A3NmM3ZjRSNndzb3hBTG5aV2IvODBhNTI5ekh2?=
 =?utf-8?B?N3NET0FmWnQ1bkhsV0YvQ2QwcVJYSFB6dlhXeU5FaGNMT3VDTUIxRXJzS3FF?=
 =?utf-8?B?RnFYeUIxUGZmZ1ZqYzFKa1ZVSlVhRTVsZXlLblE2UVBaRDRDWVd6Qmh3RnBL?=
 =?utf-8?B?OHVvcTg4UTJUbUFiUmlPazBJNnJVSy9ZdHVvNmlFeGxldFpUZ3E4d0djQks5?=
 =?utf-8?B?N01kejcycmtvQkVwdkdzQ1lwN1NydXdJTjRxYk1sZ2NPRUJNWGRkaU5FM0F6?=
 =?utf-8?B?MStRcHg2S3ZRV21HNjFDTUNiV1BPRGpWcGlQUjR0V2kxRkxPY3gyeUQvTFlX?=
 =?utf-8?B?ODRCaE8zNHEwLzRiK3VYS1lUUGRabDJOaGZiUU96U01JMTlsWnUvZ1VvWlNm?=
 =?utf-8?B?ejNFcXNmRWc1Tm9PVkxWS0lGZ0VRcGpXMWlOOCt3R2NlR2U5OGZmVVVodVVu?=
 =?utf-8?B?V1FZWG1sa3FqSytsTERkRnRiYWtyT0F0c1J0QTd6Y21hbjdPR2tRVTR3d2ti?=
 =?utf-8?B?K1ZCTEFXa25TbVpVWitONStLRVE2VXNMc1BPNUlyVU1VVExCYUw1VlU1ZUR5?=
 =?utf-8?B?MmRic0FobVBZVW5oVVIyTWRJekZaYmNTR1RDY3NhQXc5RFFuMXRMVkZGZ0Rw?=
 =?utf-8?B?bURVTzJUMFRuZWFObk9VUlJ1MlJwUUl5dlljcm4yZDYwWm5GQ1hPRTFVNFlO?=
 =?utf-8?B?RWV3YkJ6bitCTXlIYWZtWTZ1VkZ4MGlBRlBYaURFZ0liZktNQ2Z5aUpmNDRT?=
 =?utf-8?B?ZmUrYnRlNHZ5YUkxYjFMZTRKYnZmMmd1TFJnOURjWW0rQnBLWEh3SUdaZ2pw?=
 =?utf-8?B?UEMzR3pxdDI5T0xWQXFNWTZ4QmdaWk03MmpnR29hU0RCNjExOHVwRlRLZkhT?=
 =?utf-8?B?NHBuNEt2eU43dkVPdGIxWEcyUG8vYlc5NVUvSWVkdjY2Y3pGdlJQb2FuUzdO?=
 =?utf-8?B?QjQ4T1pOV1M1VjJaOEI2d3BlenplallkQldrT0NWY3pIcndpZnFibWxBcFZL?=
 =?utf-8?B?K3BMZWI0eVo1bTVTNU1mS1lJcldNZ2w5TXdIS1g3a0h4L2w1dUEzOC83VU50?=
 =?utf-8?B?czV3cTNpVnM0aUVMeGFGbkZ6QzQ1MzlTNXVEYjNoaFVnWmFUVzdoWk1LZTB5?=
 =?utf-8?B?aWp1cUsyRWpBMzlEY3RieUoxbVdJSlhzSzFVQmhiWFBubDAraUVXSzU5RmxQ?=
 =?utf-8?B?R1ZOR3JvZHFEYnRxdzhwL1VTQ2NOWkYwR01zU2NZbXdKc2tSTE5rd2txOGp4?=
 =?utf-8?B?NU1aNHRGQlA0TER6M3ZKMnRaajRQNTBka0cxeHFJTjRrQkFWVWhDNDRkY3Fv?=
 =?utf-8?B?aU5ieFp1RlYwRUlZaVZXRk1UVjEyc2JUazhTc010d2lpV3oyWDRnQy93R2ll?=
 =?utf-8?B?WGhFOVFOVzZVR0d0a0ttMy94cDNMMGd2N3lLYUpwb08vQmY4a0l1Tm5meHlo?=
 =?utf-8?B?NHFMZnN3aTBFR2UxeEw5bjVIQ21RWHZhQ0E5MHB6djJzOXFuYVBHZVozUmph?=
 =?utf-8?B?WFVTUWdYWTVnRUlDbW5xUEo0VmdOemtJdE9pWGpiYzJLVi85bytWV2tGUnZ4?=
 =?utf-8?B?bDZOMGgvY0RtMUJ2dmJUQUZiK2w0RGhNelA3V29qeUtaSTQxVG92SnVWRDNK?=
 =?utf-8?B?U0NkbklJMFVtdm0vN3hyMjR2VUdLS3pJcm1JSUlLUm1QNmFld2NIQzJlOVF1?=
 =?utf-8?B?MHM5TjZTVHRZZnJlQWppUEFrYUk3c1dleGJCM2FjcUYrU29QRjN6em9WTkVr?=
 =?utf-8?Q?amaGz1KvNiABfXZv/E?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 62b1feeb-a0ab-445d-2c34-08dee476c668
X-MS-Exchange-CrossTenant-AuthSource: IA0PR12MB8374.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Jul 2026 02:46:32.0640
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: LD8i9lgvH7v9htBbrI7hJOZBqxlpHwnpbIK314HfRwuURoCeEDt7h90DqYRNdrvT
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH3PR12MB7571

On Fri Jul 10, 2026 at 4:16 PM EDT, Lorenzo Stoakes wrote:
> It's not necessary to declare these functions static inline as they are
> contained within a single compilation unit.
>
> This makes the anonymous interval tree code consistent with the newly
> updated file-backed interval tree code.
>
> No functional change intended.
>
> Reviewed-by: Pedro Falcato <pfalcato@suse.de>
> Reviewed-by: Gregory Price <gourry@gourry.net>
> Signed-off-by: Lorenzo Stoakes <ljs@kernel.org>
> ---
>  mm/interval_tree.c | 6 +++---
>  1 file changed, 3 insertions(+), 3 deletions(-)
>
Reviewed-by: Zi Yan <ziy@nvidia.com>

--=20
Best Regards,
Yan, Zi

