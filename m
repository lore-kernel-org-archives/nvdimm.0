Received: from CH1PR05CU001.outbound.protection.outlook.com (mail-northcentralusazon11010051.outbound.protection.outlook.com [52.101.193.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 087913515FF;
	Thu, 23 Jul 2026 02:40:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.193.51
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784774446; cv=fail; b=L9BvO7UvT1CW0EVcD9EOWULKIhNMlkwP0QjWGIf5HKfSm8lJLrw+fCxqqBwM7Sqh5WpF3HSiGUXFZNQik/83h7fAYEhOoOTqCcMlfq+Q63oUeOtrQNTaYpQ05DkkHStS8KceduwTW9CcOgVPzn5Qm9TjZ+A0fsG/a62pQ7FDi9I=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784774446; c=relaxed/simple;
	bh=VvjI1CCG9vdeeA6udi2nue96btq8Xik8n5cvbcm0mdo=;
	h=Content-Type:Date:Message-Id:Subject:Cc:To:From:References:
	 In-Reply-To:MIME-Version; b=YRuIy4mlFy7GOSzKeQo9aSpnPL1FXcwMUR+580xkFpdiNvx5E4ZJ2GRTKnuouoIA53pr3JlVzm9ck002JSveWng0CD7nd417YZjT/EEHYwyf1uI3fREs5vBdP62XuRSHMOzlCxg8mXlHu9CSZmTfNdXEnt2DoeV0QUSVWHu7594=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=ruesJsNr; arc=fail smtp.client-ip=52.101.193.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="ruesJsNr"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=LqjOYCf2JLbUzXWzebcjG6Z9DvO2wP/N7aX/FLxn2ZU9Yf68Jy2Lxjxh5mIFUGjj+aPskAk118fgHUpHn6F++7XnBjOrFIhsbzuc6JRXZM2A+SKe2IxrlkT6a2n4Vdb3CrFdZ1CRFIggyHlkEllF2O+uwfHlOa9PeH49BWxDUb7CSQH1GSVrae8YvoT9XT9kMj2M/MJdPWnnto6tFD3qEc51v6pk3QDmokFAK88ZpVRg5ul0cg3Fp5BgSYKB6O/Pz3aliTpwBBUGV24H55rJd+Fx5Up+vhqFfK8jWt9RQRWyhmOE3B340Me/Ap6UI/1IW42ZZxGd0vOC8oo510LFCg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=u7otvIjCVoKFhsIm9JxfwZUcIZbI9IR3kjXNkrWj07o=;
 b=LRPumcVBIArVyUvDp5HN8JdvP8nuOyEcNyVBUa/X65W5SwhQ8GgalOAaF2Qe3znbf1EIqqF+I8QYM0csyPVux/bxCB1lDOcVbQR41U92NcP7chgkUxsmZMgaMPXMcTzxwU7jsTrEswc0P8ewNU2kutD3OECGVjgw3/xsOq7o0NqWEVxiKHEsbgmKy4pnZLztoJzG2xR/1Z0sUP1xxB0LHdGKHS7/T1hmvYqLYtC9taHLzVIeDjD2vcLaW26dcMfTYcRrHKj+K7fiElU29l6VZhrTbcHl4cuoMv2nt0dPvaTNXOf5CHSsowNCY12XLRuYmNTkDgvniGvbl6I1KI73zQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=u7otvIjCVoKFhsIm9JxfwZUcIZbI9IR3kjXNkrWj07o=;
 b=ruesJsNrUQNnn6T+T3wcKUAKg3pq8y6rvqbohuyLrNebNFiTUV6SPc6jdQPgu2g9eaJx/WKZb2bV8/Zd4jXthpwuBfyJcJDmjl6C8kTk4Q+iUHS055s8O9R3+x7PUdibrCG/oPKU1Ha1jvql6E0yyK/Ol1k8GtAHzzRtjcgqaUSu2CUgKEFBhtL4Aq2iMX/5cFVH6+sbGWnhsiat9MBLvwtvS6GPT3b/gDqE9jpaQk7eiFiMlG2LD05k5sH0Xzx0rFDEDdkckoEZtvbGOGYS/CEMe/wYyy6rFAGOF4u1sGO/XqaJ0GMTDTlZ5XAJZbStdZ9q7cL6k4F4xpvbv8/Iow==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from IA0PR12MB8374.namprd12.prod.outlook.com (2603:10b6:208:40e::7)
 by SA3PR12MB8022.namprd12.prod.outlook.com (2603:10b6:806:307::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.245.10; Thu, 23 Jul
 2026 02:40:34 +0000
Received: from IA0PR12MB8374.namprd12.prod.outlook.com
 ([fe80::d85f:4c87:ae84:3f16]) by IA0PR12MB8374.namprd12.prod.outlook.com
 ([fe80::d85f:4c87:ae84:3f16%5]) with mapi id 15.21.0245.009; Thu, 23 Jul 2026
 02:40:34 +0000
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8
Date: Wed, 22 Jul 2026 22:40:28 -0400
Message-Id: <DK5LQDITFCNI.2L8RIH70ZZ9RI@nvidia.com>
Subject: Re: [PATCH v2 13/33] mm/vma: introduce and use vmg_pages(),
 vmg_[start, end]_pgoff()
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
X-Mailer: aerc 0.21.0
References: <20260710-b4-pre-scalable-cow-v2-0-2a5aa403d977@kernel.org>
 <20260710-b4-pre-scalable-cow-v2-13-2a5aa403d977@kernel.org>
In-Reply-To: <20260710-b4-pre-scalable-cow-v2-13-2a5aa403d977@kernel.org>
X-ClientProxiedBy: YQBPR0101CA0334.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:c01:6b::9) To IA0PR12MB8374.namprd12.prod.outlook.com
 (2603:10b6:208:40e::7)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: IA0PR12MB8374:EE_|SA3PR12MB8022:EE_
X-MS-Office365-Filtering-Correlation-Id: ffc8d255-ceb1-4ef6-9120-08dee863c554
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|7416014|376014|23010399003|366016|921020|22082099003|18002099003|11063799006|56012099006|4143699003|10067099003;
X-Microsoft-Antispam-Message-Info:
	Wh/m0DDDqzEvWVWvKwlHvYP6Q5K+3eOkzu8GZP8PfNRWNYP77mxJcAy3jx5/u43OUINsMQQkyv75aJV4wt+HRM53C0xrAtTgsvnnaQ2nQMVf1pRmd6IUz8rVzH3k8CHz6tf3rBp/cLga9L6yJ2QL9/1SRlCyLXVLB3WcPSSDFM5GGyVW2TZIxZ+5GBmLVvwqZWZcee2PNQZCAQrHFyv8tIfhjCx9luFt92FzkasZ+9K8cWSw/tVfbkmw/bpzaUazHjX4yQ7mtMMFkpAT7pIhezHQZghwZnOvYTZB+sRF7C+OUHqPar49pISW6HwR+LbJio1Aleik57L49xKUG/h+ee7V581BvJ0oAPfJRVHNSH2O5w8dagxgR3MybK0R52JlMap48o0riBXqarcb74mMeuhPmRC+3OFM2Vq3mr8R537qt2zW4PFcHyzTFlu7K2hPJSv8vje4T8Qn+/uK6ElvuOgGmZEkKgiCLCi324Afmj2wjgYB3qlCnmdV0dfJER+XtcU2NvsKaZ9THIUcWld6cWE4eqBFu/OPwyTexAayLkAV2RNtUUsq9VJQcKPGgnY3VHKEgoWp/I+oJh8QuOg2IiUx+yi+Svp9PYOT4NMRXe0f8T4W+ZuUQRsRJwYxnRlq3a1jGSvkwMs8lFTB/zaNDEoVOfDizSIRpo/kZBco/lhj089jkSW4VfTAgCgwLtrV6loELhRv+eLju9yL5rJzIQ==
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:IA0PR12MB8374.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(7416014)(376014)(23010399003)(366016)(921020)(22082099003)(18002099003)(11063799006)(56012099006)(4143699003)(10067099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?V0YyMjl4NEZlL0ZkWTlMZExudldaSVBHQVFMdGErKzN0OWdMSHhwV2ZJanNY?=
 =?utf-8?B?N3BMVVo2Vys3dytBWnVaZ0Q5QlpyeHFnMVE0SUhRcWhPVzJjYWNXdC81cEND?=
 =?utf-8?B?SW9GaTJhSDlJK0gxZDZBRXIzYXg1YTQvMVZzY1Zmc3duN1N0SnlldEh2YWZ4?=
 =?utf-8?B?bHg5d00xVkptZldobW02em1ZM1FTMUlqODFYWjlOazJLa0VFcG9jdGhma3Vq?=
 =?utf-8?B?Yis1S3VYQWlMR2tQL3JDaHA2ZWhBWmNnZE1wM3ptaW8rbEQ4c0s0NGx4dy9m?=
 =?utf-8?B?QlRvMzNVUnlZWXB5WWRuSnM0R3RRRWpKOWs1dFBFL0grOWdFYXdWNFJPU2Ev?=
 =?utf-8?B?b3lxV3J2ay9lWnc0TEFqRlVCbi96c0lIbzgwL3o5UTk3ajVyWS9ZL1BnYzM1?=
 =?utf-8?B?MEp0WnlFUlFwaC8xQnhHYWZUVXV5aCthUkhDTEg3Y2lJRDZoWDBacWpzdVRp?=
 =?utf-8?B?bTVUUnZHZWF0cUVlZDVPSXNJVkVGV28vYmJjZGhpcjFxd2Q2Kzl0bnRPZjNy?=
 =?utf-8?B?U2tyc1dhYkdEY2FsY2cvSjdIRTlkd3UvWUxEek5aeHhTamlrdmFkcjJPc1Nu?=
 =?utf-8?B?SGFHam51aHdCdVRxNGJ6MzhrUFRybVBrTjQ2ZW9LRG02OWJhcFBOUnd5N1Zq?=
 =?utf-8?B?QmNPbVErSUJxTS9vTllvbm1GYktZbU9NOVptTnhiaUpHSVJSemU5NDlOY3RT?=
 =?utf-8?B?V29RSVUwQ2FHeWtuQlNJdGJsaWIvNUJOa2RDRjltNXdJbXIvWjFNOCtpdkVo?=
 =?utf-8?B?OURFYkRvWXU5aGNTMEZPRzhhZ2M1T2lZU3lWTnN2SlE0OGRKdjBWWUF1TXZs?=
 =?utf-8?B?MjZSaWd0aks3aXlkK21lTWM3M0JtdzFRcmEyYU9FM0pHRWZkV1p3bDNsaGNC?=
 =?utf-8?B?YUsxV0lra2lYRWprWEc1OXY1THBjQlZGcHZzb3RRc1hXdmpYTjAzQkUyL2Fz?=
 =?utf-8?B?OXA1MXJTQ2I5RThFemRWbFI0SXFjZGFIbkRpOWVXTHdFbUh5Y1pQbUI0Tjdw?=
 =?utf-8?B?SUR3T0pFYTFvRGk1TWtTdW11WllaWW1yb0R4ZzA3L3c3ZjVycWliaEdDQStU?=
 =?utf-8?B?UXNMRGdCcmNOMldUOVhGUTBqTUNtVVdJM21JOFhNcll2emF6VnQxaFBPTFZB?=
 =?utf-8?B?SzdYb05zTU5jcXZLTjhTOE0xS3VlUE1BdDV1c0p1eHE4VEN0Z25nM2NGTEFH?=
 =?utf-8?B?Wmp1RGV0eVFyenhXeUtNQVUyc2Y4SjZpRHVGa2NFTU01M2JJUktsZWlDVUxz?=
 =?utf-8?B?Y3NISFR6bUU2djlZNUlORjFTOWQ2N1pjQUUrdE1ndXBoVm9TcGpJMDEyTUpE?=
 =?utf-8?B?NHFoM29DYVhidk5DT0pOTHY0T0IxTldtUGxST1V3L1Z0SUEzM095MDlBL00y?=
 =?utf-8?B?Q0xlN0crNFB6NGdoZS8vUjJkeUVLZTRUbFcrSDZRQjZUQjdXUGlJSkZQRXli?=
 =?utf-8?B?VjhUWGpjT21vR0FETDBYREc4YmxhSUZkRHRYeVU4WElVQWc1NitjVTVvWWVC?=
 =?utf-8?B?aDFMVkYvOERrL3VnN3UrYS9LekhJdzZ2b1V4K1piV1pMSGRQNWFTclFBQVRx?=
 =?utf-8?B?Y25nVDY0cjVIV1ZjbmtDWFVlU2JuRlgzdCs2TzFibk5oNGFQSC9HNGJ6WnFL?=
 =?utf-8?B?OElJTUhOL0xhUCswd09iS3hnL1VZa29ScGRRYm1uMlAyc241N2pWd3c2eGRM?=
 =?utf-8?B?Q2FUSTZ1bzdXOFF2YUlFaGovaHdoeWRnTmpmNzk0cGVYY3ZFYVpwaEVNVVhQ?=
 =?utf-8?B?VGd3bkFHVThrMFpBNTF4V0M2SlBXZEdjNVlqQmc3SmZNSklLRTUycTdyS05i?=
 =?utf-8?B?eUpwdUR0ckxGYkVGQ0gzdkgxZzN1Uld6aHA5aDFSMlI4WFNzdVRBTmt6WTJt?=
 =?utf-8?B?RjhSbWxoL0VMZFBiblFxbXlqekpYdVY2UHVSeUpxdktCTnB4ZHNqN1JoYzhF?=
 =?utf-8?B?VWIyclFybDNaOHlLa3R1QTEzd2tLMEQ2MGNMdksrRG8zS0l0YkxEUi9rWGhm?=
 =?utf-8?B?TE1Cb1JQMVpEc25VNDFNYlIwK2thaTFaV0dhdnpoMG5ncEVrek93U2NoK2c3?=
 =?utf-8?B?QUtrNWlyWnlRRHQ2MEFsWm9OZ3c3dE8xVW82L2hvUTZlbzdOWUtvcTljTS9J?=
 =?utf-8?B?Y1g4Rnp5cXVVZk53bmM4R1JBejU1T3RFZ0FzRlRxYTZHUld0Z2luNXdNKzBZ?=
 =?utf-8?B?Rks0UG1RUVczMjJtMDRMakxEMkU1OTkvcjVOSEJuakRaS1YxSlFqaFpNLzZs?=
 =?utf-8?B?L3pod1VtNXQxZUk1VVZXeFNUN3F1WFRUeXp5aG8rcTBiOFNNQnJVR1I5ZGVq?=
 =?utf-8?Q?gqIVdgusZ4eeERF0zv?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ffc8d255-ceb1-4ef6-9120-08dee863c554
X-MS-Exchange-CrossTenant-AuthSource: IA0PR12MB8374.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Jul 2026 02:40:34.4531
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: pA+5eyvV37WzLxoQ5PaactjZIbJCljRmkeh0tkZpswESwo/jLgtvdUqPJ0B1Ul9L
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA3PR12MB8022

On Fri Jul 10, 2026 at 4:16 PM EDT, Lorenzo Stoakes wrote:
> In the VMA logic we often need to determine the number of pages in the
> specified merge range, as well as the start and end page offsets of that
> range.
>
> Introduce and use helpers for these purposes.
>
> No functional change intended.
>
> Reviewed-by: Pedro Falcato <pfalcato@suse.de>
> Reviewed-by: Gregory Price <gourry@gourry.net>
> Signed-off-by: Lorenzo Stoakes <ljs@kernel.org>
> ---
>  mm/vma.c | 11 ++++-------
>  mm/vma.h | 17 +++++++++++++++++
>  2 files changed, 21 insertions(+), 7 deletions(-)
>
LGTM.

Reviewed-by: Zi Yan <ziy@nvidia.com>

--=20
Best Regards,
Yan, Zi

