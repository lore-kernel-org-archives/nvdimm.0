Received: from BN1PR04CU002.outbound.protection.outlook.com (mail-eastus2azon11010005.outbound.protection.outlook.com [52.101.56.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 154C01FC8;
	Sat, 18 Jul 2026 02:59:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.56.5
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784343570; cv=fail; b=JOtMWxsrm8F1RaiBEIlIv6OTykqOCZlNq7syqEu7uEHVZG48D2A3DlM05894ByGCzBzsNeitRzLur7K68xIsznqUYWx1RgIz4LSjJ1mi7HUXFz6PRfIC9SGFsescsAvU+k61kdCz/u7j8ldN5tUpf9biaGFJXmMVp7g5pePw/KM=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784343570; c=relaxed/simple;
	bh=5PpHx2YBXTF2MEKXZO0ethiEoNVBmkJjs+cq5auumDY=;
	h=Content-Type:Date:Message-Id:From:Subject:Cc:To:References:
	 In-Reply-To:MIME-Version; b=Mucklp1zzLZvYbi3culXzZs3DUZrCE9PzsIZ0KS3lOcWT/ZnnLak/9XvQyRZOVCoRqWyjNDHVt/D8jM+oZfon5yjuo70HJUkRq3Zt9InzHHvZE/Nv03gfs0IcOmUj7fz0WkuAmrmuKEvQLBQCVS6gaY8ZygLi4oeGYW17dNt/2I=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=JHImd7qC; arc=fail smtp.client-ip=52.101.56.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="JHImd7qC"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=CyYywtu13fL9HY4gLAcQ2dsg/uyBa6b5pclwscuNqLmpc+5AVgA+AtKOGas5wduQDYLrTkHDuQq2SDVfk89lHc+MCFie+j48H6p5G8VjFYzHl+7E0KN8qUvHIXF+lQaCwyi3uKW+wuZNFiM+LYvZVXTT3Li3CqvMDl7OSbMNJhjRo8HRr6WACsXyNKxdI50eD3AKePPOe242FfuEVtCRlYV/gNYmd3mx8MSdqRZgOjvFz9ZTsBzBc1Jwu90t3pinlo/YF+t4/SlWh0Ksiyksc58g/s5JKEcPTwBzkxzSg5LEZq7hDVNPzKurjKgWXxpRN7fT5+sPV5vTs/CHx0BAsg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ASbSlZDWv3PeJuTVovQJ0NjojerD54BpOVj/wUmavig=;
 b=D6TMzOHt7oBu8h3+XnM6VnCU94dcIm4zT0j9vZejglDSXXfUlVdt4R8Quxg/A+sF1iSqADuuZzTWn86G6t/r1Il/e8Q/Yref+P511JaH5YUOzgPdygRiPBDcezHwpi17TdC+oXqy2xNS/VEfaspVMlwnDtaYEt3Qx9NS9STMJ9n+RIFN81t/g31bs8HN69INJPlaQVs817GboVurzoj6Vk5njUSFhNswwpcoci7va0E8Rn9N4bl8GwwciD/qwuxE1KbPzn1HSSA06CXWFWSvBMJxwVxLm8UiXN0/tDS7XuMELPXIwkCCS7p/CZ6c5JzH/HpPuOwG8acQowNEUpgJGw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ASbSlZDWv3PeJuTVovQJ0NjojerD54BpOVj/wUmavig=;
 b=JHImd7qCYbjKxTkKYWQSVwf+OMRnSDKSyLt31UHfDWM2fbGGs7sxN1axD+MgA12Wz8xxDi6X1i6Cj/j4gNCrTv/FSfgUTgt+TA52+bMNbtAI9M0iruEzvrZhCtqvLNsYCbqllQil8UlYq5v4dvKoM752Q/neM/5Jvi2B+/99FJH+cHohIkXt6KUcpSh/VnCg0l+bT1I/1fABzJIhvFFHiVf0FuvshVEmyOUi1aYbaAp9cPEwOhrZuuAY1gh4Xu0Q0i6NFXzXitdjbTi8u1lIijRYFJWji1QNgkC7sLmoXVAeskUOQwBinsOnlBHLcjLP8ou00fRN64DRtydIv3Q+3w==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from IA0PR12MB8374.namprd12.prod.outlook.com (2603:10b6:208:40e::7)
 by DM6PR12MB4483.namprd12.prod.outlook.com (2603:10b6:5:2a2::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.223.12; Sat, 18 Jul
 2026 02:59:13 +0000
Received: from IA0PR12MB8374.namprd12.prod.outlook.com
 ([fe80::d85f:4c87:ae84:3f16]) by IA0PR12MB8374.namprd12.prod.outlook.com
 ([fe80::d85f:4c87:ae84:3f16%5]) with mapi id 15.21.0223.012; Sat, 18 Jul 2026
 02:59:13 +0000
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8
Date: Fri, 17 Jul 2026 22:59:11 -0400
Message-Id: <DK1CZZ56P7VX.QW1V2F906OSZ@nvidia.com>
From: "Zi Yan" <ziy@nvidia.com>
Subject: Re: [PATCH v2 12/33] MAINTAINERS: Move mm/interval_tree.c to rmap
 section
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
 <20260710-b4-pre-scalable-cow-v2-12-2a5aa403d977@kernel.org>
In-Reply-To: <20260710-b4-pre-scalable-cow-v2-12-2a5aa403d977@kernel.org>
X-ClientProxiedBy: BL1PR13CA0398.namprd13.prod.outlook.com
 (2603:10b6:208:2c2::13) To IA0PR12MB8374.namprd12.prod.outlook.com
 (2603:10b6:208:40e::7)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: IA0PR12MB8374:EE_|DM6PR12MB4483:EE_
X-MS-Office365-Filtering-Correlation-Id: a67dfe31-1370-4e76-9d7b-08dee4788c5b
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|7416014|376014|23010399003|366016|1800799024|22082099003|18002099003|4143699003|10067099003|11063799006|56012099006|921020|6133799003;
X-Microsoft-Antispam-Message-Info:
	21TszfEzCY6F/MVddR/0NsHbiGs1twaLk8TKOoYi7PbYSd/Kdev7mUKLiXZw3EpK8BOLA1hbzTHLe4jxXLwLEGCYdyGshQgIxoQRWf2ziHP8OM9Y4sFB1MjWFel6m15gDx64vVDUf373jf+I6zV6mnJkMHBQ0waRtRsniQFEjCFf79dDRqCjt7mfbvN/E7L8jgx5xKFNxuXupikEgomsCqIexDxDaVXsq943PlpuF7Xr6ke4nwlstNuFid4ipv+Y33bFakwnbu21/JXv2mPTsS3tJJxtO3vEsnY2GargmOlUwXPudQ5OGeyk61ZbT9hGmHssbxiuZiB7VBn/0NVPx1FVK8pfhzVejYp6HTmDHoTejJTEXQLAkF6hpLRl/4LYLOsjf5ITvTt0/iuxd5HjuPioiCqQ0V4EgF+eFZZG8fCKkQ1rOkiSFDqvAkkMQU5QJmcmvE8u2AWtLcb2aFIrGXiLbXWO/jwfXAmvqo337+c/TrfRfylLeBztrdktT6Ks/S1xiI68rEGVn3r3SCXiWiugF+rok+AcF+M12a3YDKMdKdd+pUAWI06tFREcGT7+nQCIDcOBB0kNyqZHdAVFanNydLqPYarDHYZzVatzYVnLmFnx97Vc7E+Cv4Quz6k8WrumuKIe0Ky26+uQbCSiaktwG24qka6omxhn8aWVYSBEEC+MSp8XrA95u9c4FP9pvqFGw5mZFKNworfOhCWrjA==
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:IA0PR12MB8374.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(23010399003)(366016)(1800799024)(22082099003)(18002099003)(4143699003)(10067099003)(11063799006)(56012099006)(921020)(6133799003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?MlZkTVhXc2U5NllVZ3VtY0dDS2YwR213ZnRtVTRZbEdFRDhHWVhZdklTQW9V?=
 =?utf-8?B?TXJTQlBRVXdJSmdtMm1jMzV5T0JEOElsRm02VlkvSmJEeWF0VVIyQjJVSmQ4?=
 =?utf-8?B?dkxZWlVHUjM1N0xrL1lOOGJQeVpqODBQY3doYis5WXMzSG1xbzJyZkhxUzFn?=
 =?utf-8?B?dXk2K2QvL05yZzdHWTFBQlhjR0NkbjhRQXo3RFNkdWNpWDBnMlZ0alIyRHZ1?=
 =?utf-8?B?MHFKNmE3a2FjNnBEOWtqVmRtSHpBZ3ZjdnZOZHhpYWZTQlRvZ1dPaS9vRlhx?=
 =?utf-8?B?MDJWVzN1S3cwNWV2czJCM2dYSjI4bFB1S3ZhbnViYzVpdnoveWMvb2JQdXB2?=
 =?utf-8?B?dmFvWTlsem15bXY5Q21sLzZ5bVEvSlQzMXNBRkl4dEdnS1ZVci9lTVhkSWpJ?=
 =?utf-8?B?NUx4dkhIUGtscjNRRXdWWjBpdlV2bkhnR01NaUNxUkJOblltQzltc2wyKzk2?=
 =?utf-8?B?ZzVCWkF4ejB5VEtMYnJhQ1hFcnRzRjR3Q2xpYWt2OFR2YW93SlJlVWRUaDJ3?=
 =?utf-8?B?SzVveTdzUFVpZ1dNMm8wc0FXM2ZjZVNIUStsR1NQWWs1RTVoSVZ3Yzc0MG1s?=
 =?utf-8?B?b2ZGQ0xWb2lqZ2kzVS9OUEdMVTF1NWJRSW5rVVlLUEhYTythajFUeVJXT2lG?=
 =?utf-8?B?ZGVJdkZETGI0TEdFM2tsVVhxQ0dKRnN1aGYrdE5KckFveGEwOHl6cUdYaHg0?=
 =?utf-8?B?d3UwdE5rVWN4TURWeENmSCtNMU02ejM5MWtjRzhHTWdZeUdHekFRMmRFTEdP?=
 =?utf-8?B?THY2Q3owWERWa3czN2FPNVA0TS9mMGQxcnJ2NTd4ZC9GK0xJSWdKMzl6V29m?=
 =?utf-8?B?N21IM1o4Q0p3eTVtanpkdTFFd21RMWxJWDJqSytEZENRR28vNmsxaS9iZHlq?=
 =?utf-8?B?Yk11RXRKQ1VoaGl4bVZ2YnhjR3VjU3diMFR1S1ptNUtYek5WcHkvcHdTd0tz?=
 =?utf-8?B?OFYwOVVqbEtHRWZ2RWlOSVNiR3hYMi9PVkljTFR4aFZIaDJKSzE2S1pIN0M1?=
 =?utf-8?B?dkxtWCtYTlRDT0hDNjA1SHMwY3d4WVNqRDNkVHRnMTZvcEFheWVheERaZXI1?=
 =?utf-8?B?NWk5Vk81dU9Rb2ZIK2d2Vk5RbHBpamx6bzkzWW50VWdFVngvUDFwRW4yM0Zy?=
 =?utf-8?B?TkdGbUl2Vm9obE14TzRGOVdiTVJXNm1hYU10MXczekpNS2RjYzRsNEZiRjhI?=
 =?utf-8?B?MHFUdWJBcXJaRllPdGxVYmczb001VUZUUEF3dHQrSkIrNkVFUE9hazZKYnRt?=
 =?utf-8?B?MXMyKzBDL24rdG9CVDE3elQwL2FMdDRSY2VXNEF1WU1reHcxb0RzVTN2YzhS?=
 =?utf-8?B?QmpWZHZTZTh6RkFkTVNpYmRFamtXL1orZDdCaFpBZUpmRTNFTE9jM28wZG5i?=
 =?utf-8?B?TnZteXZzT3ZEUnpWNUg1WmRVbWQySldJRFR0bzFZSFl2cUJSM1ZLQXYxeUVY?=
 =?utf-8?B?UlYrZzhlVWdseEdBbGNtSi9SZlR6Um9rN2VlQ2NLS3FNL0tsOFJZbVBlejNu?=
 =?utf-8?B?eVlFSnoyOVpIR0dadnA2TjUwREk2Zm9oNm1BLytKN0lDdUVYcCtOZXF6dldj?=
 =?utf-8?B?YjJkUXFaQ1Fpd3I4MGlRQUpGQmV6anorV2ZMVlBkb0x2SjNyVjFHVmZEMTZm?=
 =?utf-8?B?eGQ0S082QW1wa1A1NDU1aHNnZ3RVeS9KNTBZNkNmZnBCNy9lZy9wVEVXV0pq?=
 =?utf-8?B?Szd1dTdIWWVzT0wyWFd3b1ZtSWt5bWF3amlhdGladzlNSTV6aGFaMmVVd25P?=
 =?utf-8?B?QWlqQlk3L1FPQXdiQzdGbU85Wks3aU1ZTENmNGlRWmZ6OEZDdUlVU2tHa3Rr?=
 =?utf-8?B?UjhPUmxBUUhKbmNGYVpNVFZkcklwNVlCLzV5VVR5THp2ZnFJbWxtM0EwT0dM?=
 =?utf-8?B?aU1xQWJOWW1HaGN4emwySUtINk9RVW9Sa0xEMVBrdWNDRTRUQmJjeWJGbmNN?=
 =?utf-8?B?bUwrZ2Rlb1RiN3UvdnNwVHBONUFYemx6cVVKNENkZGpJczlPbW1wUnJtV1Jv?=
 =?utf-8?B?dEZQaytLZXJwODhtK3B3T1hNbDRMQWFKVWlLTkNoczFpeWJWSWo1SFVwT2hn?=
 =?utf-8?B?cEdzcFlkVno3bkE0dVFLZkpGL3JsQ3hRS1R1ZlBnTm9hc2grblFNTXNjNkhX?=
 =?utf-8?B?VXQyUUp0b3I0VXI2VjlSS2h3MGk1ZHIxcTUydDVJTjZrS3JCQjFzeDdGR1JX?=
 =?utf-8?B?dWxVbWhzOVhwOXRPOXB6WDJ6a3AzZElLTm9jNURJVWlubzQzYjRjTEdHSkdl?=
 =?utf-8?B?REJGOUxmdXlValhBZjF3T3NQSzZoMEZNdkxUTlFmNlh5NlZpcHhnMDBheHVM?=
 =?utf-8?Q?wy7xha+bOJ1XsLam6o?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a67dfe31-1370-4e76-9d7b-08dee4788c5b
X-MS-Exchange-CrossTenant-AuthSource: IA0PR12MB8374.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Jul 2026 02:59:13.7135
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: GnGTsLh8gdMWlOK7mO60KJqScSH8QZDx741/xH1SPGqZSRaD0l+K8NJBO88U4VUE
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB4483

On Fri Jul 10, 2026 at 4:16 PM EDT, Lorenzo Stoakes wrote:
> This file implements code for the interval trees used by the file and ano=
n
> rmap implementation, so belongs in the rmap section.
>
> Acked-by: Pedro Falcato <pfalcato@suse.de>
> Signed-off-by: Lorenzo Stoakes <ljs@kernel.org>
> ---
>  MAINTAINERS | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/MAINTAINERS b/MAINTAINERS
> index c3e535ca4bef..ef168b583325 100644
> --- a/MAINTAINERS
> +++ b/MAINTAINERS
> @@ -17208,6 +17208,7 @@ R:	Lance Yang <lance.yang@linux.dev>
>  L:	linux-mm@kvack.org
>  S:	Maintained
>  F:	include/linux/rmap.h
> +F:	mm/interval_tree.c
>  F:	mm/page_vma_mapped.c
>  F:	mm/rmap.c
>  F:	tools/testing/selftests/mm/rmap.c
> @@ -17313,7 +17314,6 @@ T:	git git://git.kernel.org/pub/scm/linux/kernel/=
git/akpm/mm
>  F:	include/trace/events/mmap.h
>  F:	fs/proc/task_mmu.c
>  F:	fs/proc/task_nommu.c
> -F:	mm/interval_tree.c
>  F:	mm/mincore.c
>  F:	mm/mlock.c
>  F:	mm/mmap.c

Acked-by: Zi Yan <ziy@nvidia.com>


--=20
Best Regards,
Yan, Zi

