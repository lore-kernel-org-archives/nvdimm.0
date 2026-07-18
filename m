Received: from MW6PR02CU001.outbound.protection.outlook.com (mail-westus2azon11012025.outbound.protection.outlook.com [52.101.48.25])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6FD4F275AFD;
	Sat, 18 Jul 2026 02:37:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.48.25
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784342264; cv=fail; b=cGoSGa/Mz1IA3WTneGum24365vPGGlOYyU1CQXXbIHvFwqFID5Rhqy0mu/dZv4WMqnc5gSMZD5tTOM88gpnQsDTMQUB+z6s5r74a1Qaie92A4jap8sBcX8hOq347vlYBdG6g629zg6Bg0Yx2OReVhXFpJTDaEMecqx+sT/Ngngc=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784342264; c=relaxed/simple;
	bh=ORAobv5/AFp7YFIcFiTqHLMYUpoj2nEJMX5KHQj7gcg=;
	h=Content-Type:Date:Message-Id:To:From:Subject:Cc:References:
	 In-Reply-To:MIME-Version; b=Th+zjiaIIzWVMPVdm6mF8m32vhxWUXzwXA++FHEc3J2oT2KDjFDZag7b0CAE9ESc3xEuU5DmDzC1PR9PKPfFqX7aGZWW6/Fydrs9VfpkXbXqWcwx5NuC6oobHnKJNbAZp8fY6v4Id6VYseM2eMNbXyZDqCQUae3otmPwLGfeaQ0=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=OyaCi7mF; arc=fail smtp.client-ip=52.101.48.25
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="OyaCi7mF"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=WUhKJQcZimDYMFPzBTHLmnSDBWwJZRn12MTsszRnMb5HzFoG1bNtCJVDFRxIGyQOp+3ZV92IiOh2+CmFQOQZrJST20xcmIXfOak3cBAz3bUyxBRxEw9K7kVyUVNPGi3z4l7r139DhLojd+NPaoS4tbOKXKAPXUP8Ea8oCUfIGYpXM2JKj23eD8LV6yd5iLUiYJ3L9826t/x88+eMDmkspEyQ6rqyGtgwU9TCzClCRZb2dvAulxa3dcmwj0AcvytjIv2JQj2rXH7zdChQpcAs7QjA3bkk806g+se/GWJI9TpUyvcXCJIPTuZUY8WDeNUHYCmaW+m+wla0rdYiAp/DHg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=DR/oJFuRDPkSyVNyFpSraBTM8YaOoiPBBNNfaatksfk=;
 b=CLJqB8GmAi6nHQEr+qVrADsXHNluxDQNDc63GNT+qzYPBnoWSXrCp1en738H/CheCfvkMVldrlVniRJjzuX0klRhlyaakF9Z0114g2F21Wz3rUtOse+pYhT3AmRI8GQnA35y46v41hNbsC6rxRUv/63YBmhWQY1ilBVtj0XL3cd90UqKiBuPemR9JXPReN6kbzzjejHCLj4ZN8pB2eDuUJx5x5J7b2swlXOIl1hzEpoXjMjsNmKjYFPWMq1JlDC3kWlfgtQNMFAydyuAR1HVswbK84ARUSeYSMZWeEjUmXiOH59roEd/11L9aEGw1oHLAUuNDMAXqaOuNlmoR46FcA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=DR/oJFuRDPkSyVNyFpSraBTM8YaOoiPBBNNfaatksfk=;
 b=OyaCi7mFPqDuCy4YSozt/2Ps/zbxsdEfyjEgY0y9Y2Z5iqPqRvkrMC5qMBCFB0Y+JrtEKjV3SiICqBojYGensIOXzVj244O8pgnG3Z6+4VXjZrprTGz6oyXCRh3sb3w43MsAqTpgUuLcqQ5aUBhnFUw/yk6urwmGe4BuWiNQEwp+8qvM9IFoLLJwCG2sjCxukFJEt4agIdUwlUAbIbymJQa6Y3NJusvaTsJ8rzRr1tGF81VkpZYYKR/QQLYdnsuCA6+IigkGHfEtxkA5aBZJNMxo83DXCOES0hi6KJRlTRFD9b8BlK1VwoqwXC1wIPmW6R9JXYAsLnb0maWG7qQU+w==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from IA0PR12MB8374.namprd12.prod.outlook.com (2603:10b6:208:40e::7)
 by CH3PR12MB7571.namprd12.prod.outlook.com (2603:10b6:610:147::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.223.12; Sat, 18 Jul
 2026 02:37:24 +0000
Received: from IA0PR12MB8374.namprd12.prod.outlook.com
 ([fe80::d85f:4c87:ae84:3f16]) by IA0PR12MB8374.namprd12.prod.outlook.com
 ([fe80::d85f:4c87:ae84:3f16%5]) with mapi id 15.21.0223.012; Sat, 18 Jul 2026
 02:37:24 +0000
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8
Date: Fri, 17 Jul 2026 22:37:21 -0400
Message-Id: <DK1CJ9GBQXI9.1EP8BKPIRK3PZ@nvidia.com>
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
Subject: Re: [PATCH v2 05/33] mm/rmap: update mm/interval_tree.c comments
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
X-Mailer: aerc 0.21.0
References: <20260710-b4-pre-scalable-cow-v2-0-2a5aa403d977@kernel.org>
 <20260710-b4-pre-scalable-cow-v2-5-2a5aa403d977@kernel.org>
In-Reply-To: <20260710-b4-pre-scalable-cow-v2-5-2a5aa403d977@kernel.org>
X-ClientProxiedBy: BL0PR05CA0004.namprd05.prod.outlook.com
 (2603:10b6:208:91::14) To IA0PR12MB8374.namprd12.prod.outlook.com
 (2603:10b6:208:40e::7)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: IA0PR12MB8374:EE_|CH3PR12MB7571:EE_
X-MS-Office365-Filtering-Correlation-Id: b20562c3-e7a8-43e3-7928-08dee4757fdc
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|7416014|376014|23010399003|1800799024|921020|56012099006|11063799006|4143699003|10067099003|18002099003|22082099003;
X-Microsoft-Antispam-Message-Info:
	z+Pj09Yayo7/DK/V0JZG+KZJzu1BY3joe60TJfq9mci2SjnBF9Gy9tKhV3VuAsaert1WFxkR/A1dvPdIqU92rGMv/RMjsZHTJJluAUlyaoPeMUlV6G9qq9olAKNldBotvyqp8T6Z0ToUbjNTs3ejLqcixwUwVBnj/zultYiGBjQMOnxE2+xnU/Yb5wRNvHSgbe/7Rx6mMCvSmvGCYY96zgfId/FHwuZ3lvrF6oFQ7/WJERmvHwR6dTF53QnENnBFeVdOg6QFc14Q0EGrEiLyjE2SaSFFruVnB4iiWv7vhmsfgjOVU34VRcMkuJ69JhNHsUKMEWpw7jsGt9y94ko64KVVdP4GyCXt7FPJ1N4QIcx9lPaig/hpUzGb6JNXqa1INicjKLZg9Kt/3MXX8NfOOBCpV6u6B8XxixqvzDCaELMh3Lvgm9CYwleJdYBgKrSRoHHwxss3LrW5MP1Ot1LbHw6P3gsGyH573ZK8Ovh7KI0BhtaR9kkPY0YqrDzr/2b31YLlxsteB7AoYtlg/d4tIl8qlCyPcyJX023ohVQUN6ySeL8/Dmq0asjHVDTFArIdZol7V58nnWdb0066HeKrwC8ZtMFVFPgLBywntTjLth6+3A7ra72V/KVLrzY+OM/6d6VAewqumEu3ElQ4/j9M+MzuGjMVhw1o6r3orf6e/eoxwZDMBWsQORdE+K4udmUOXNTssH33CusVUhY9v+dk2w==
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:IA0PR12MB8374.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(7416014)(376014)(23010399003)(1800799024)(921020)(56012099006)(11063799006)(4143699003)(10067099003)(18002099003)(22082099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?b0RSd1V5Vm1KdzI0OWx2TUxiVnphb2NIcWFTYUdralBPaldWcjZuejBoMC90?=
 =?utf-8?B?b1F0cnJ4cjM1QzlXZjc4L1hGSVR1bEtvM1RvamE4OXdZVzlNRHR5TTFkdEFh?=
 =?utf-8?B?RzE2alZNSVQ2VWhKRlRTeWNBaGFrYjBwWUtFYVYxQ0dQRFhka2pTaXNBVzds?=
 =?utf-8?B?ZUloTEVPZE0wTFdqM3lEL3FWNDU2bWJIaWUwblBuWnF4aDBkZzlTdXJTTmR5?=
 =?utf-8?B?aUt6OHcyTFV3Q1VXelVDQi9NNWdnSUVZRXpXWEladG1iZG1OSzYxZUtrYWh6?=
 =?utf-8?B?cjNOSUtqL2duWXBQVXZuNUR3bWZxazVtN3lKRDNPQ3hSRDlWWGMvNEtGRGh3?=
 =?utf-8?B?YlFRclJPWnlRT3UwNFBGSTRXVlR5TTZYait2Z2wzTWJhbWpnSzhzaE1zbHFi?=
 =?utf-8?B?aWwreG55UHVJY3REdS9HT1VtYTlSOXAxWFprWGlCTlFjeFViZVZyL1NXWUFQ?=
 =?utf-8?B?N3VLekhmMzB4blMvVkwzelNESjl1empadVVJNERXQjRTOERPZHE2M21Va0lo?=
 =?utf-8?B?a1dVNmRCM1BYT2U3QWZYS3VGV0VEemx6SW1QdkxGMmU4SC8xZW9uZ2E4ZXBI?=
 =?utf-8?B?cndWdmtLV1ZFTUF4MVFaTlF4em1wVkxOSjIrY2dqa2VEVXFjZVRNT1FFd0VI?=
 =?utf-8?B?d0NyS1QxSFhUSzA3b1BkVVE1QzJQYXRTSEcySFhwUWlZZVRKUUpWb3BsRTZ2?=
 =?utf-8?B?NUk2YitYSmlKYnZZS2RGaEs5ZGxIRDZXU0l2dlZ2dFF6VE9wU0JRUnZ3SURB?=
 =?utf-8?B?bDAvdFJzcDlmQTErTTlqN1ZPaERmRm9WdXpWeit3ZEl1dW0vZGtJR094TVBa?=
 =?utf-8?B?THRzWXNES3A3M3lYUGszemNBTldhSWJrL0VaT2kxZW0rNld5bjRjZHk2L255?=
 =?utf-8?B?VTMybjRhcUdHWUNBaXZnaDBTaWpNK1NmNTNWYWZ4YlpPa0dvMlJHbkROdi90?=
 =?utf-8?B?RkRrYithdmh1R2o3bmU2SmlEdFV1L0JpaEoyalBTaHVvYzFwUnpPSUh6NFNC?=
 =?utf-8?B?UWJRcS9XRlkrRjhWMzZPNlpmRXdUZk84ckJ3SkJ5SG4zQjlldGpVUnNsUE56?=
 =?utf-8?B?bjBQbkQ1Uzg5VG1ITkdtN3RyMFk3STFnNDZoTWJiSEFtSGlmOHFUcjJTSWJv?=
 =?utf-8?B?YmE5Ui9wWWFsVEFzekU4WFIrK2dEY2Q3bkVIQnFzR2xSY0JhMFNJaW01L01s?=
 =?utf-8?B?QXppSng0R0IzY1QxcGFKUFFjWE0wVGNFTzU2c1kwT0FneVV3RWZieGgwSndY?=
 =?utf-8?B?UUtDcmkzM3owTkUxT1VhbU9LeUVRUjdpaWFyeWZBZGM5ZVY4aGp4VnRvWU5I?=
 =?utf-8?B?bytLanZkYUptM0hiR3Nhby8vQytpL2pwaFhnZFJDMTMrU3d1K2hDQXlVQUZE?=
 =?utf-8?B?V1FGNVBGYUhtSDQxaWYzT3B0dC9UY3ZNc2RJdUxqbTF5NlkyRTBDQnlnV09i?=
 =?utf-8?B?V1FNWmhIbHdNMjRKQXZaeERHV1ZKRWFVRHNkUHhFc3F3R1pSTktGUGh6ZkRm?=
 =?utf-8?B?YXR6dlAvUFpXakdVOUVja01pOWUvbGFHTTF4a2RoVS84YTkxQXN3bUtxZnAy?=
 =?utf-8?B?eXY3Y3VmTjB4ajlrWERKRGI1QkdJMEVrT3pzQWdoK210NG9Db0J6UlBnK0tU?=
 =?utf-8?B?RHJWTmFnZ1o2czIxM2xSK1FDa1FpYVp3bUFhZWVQK1QzQWN3b2U5TUF0MnJu?=
 =?utf-8?B?NE1hN28vR1ZYK3pvSFQ0aHphaGsvVVM2a213WHlUL1lLd3RuM215S3JoZ2hZ?=
 =?utf-8?B?QWV2R2tBSEM4cldRRlVJUXVXVUI4S29RbktyN09McGt6RFJXeS9JYk5ob3pC?=
 =?utf-8?B?V2gzUzVIZnp0QWd3b3VCMTJ0dk1KSmtxdlhsSkFsOUJwSEI5cHZLUjdYNkdr?=
 =?utf-8?B?Ym45dk5mVzE5T09LRG84dytOZy91a0RQRUFBUWRNZnNRLzdEd2o1OHNNdnVY?=
 =?utf-8?B?L0RKSnh6QjJ0WHJud2JzR1dybzQ1QUpaOFZnY0dCbjVuR3QzTkJjRlc3ampM?=
 =?utf-8?B?N1RRbkNlQXZ1M000ZmFaNnFOc1p5UkFRUjNmSWZYWUhwVDFNQTVyd0laWkxM?=
 =?utf-8?B?WmtaaWxPVGNjK3hsOFdIWDFBT2tvc2tBeU91UVViVEFRMkNNQi83NDhiSWJ1?=
 =?utf-8?B?QnNQUXdTd1RFQXNCQ0s0NWU0TzJ1bEd1Z0JhVkxNRDhjcjQzcWUyZ3R5WGNT?=
 =?utf-8?B?VGZPY054Tnd6Q1dDQXM3SmJSUXlzVXhjbkVGdThDVzY4U3hiVDdodnV6TVhB?=
 =?utf-8?B?T2Yrbk01aHhRUGJPeG1WREVGclNEQkZhUndJSnRROXJ4Yzg2ZHFTbGFkZXE4?=
 =?utf-8?Q?itarxlNkIGOHx31fvG?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b20562c3-e7a8-43e3-7928-08dee4757fdc
X-MS-Exchange-CrossTenant-AuthSource: IA0PR12MB8374.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Jul 2026 02:37:24.2323
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: d0Xh1Yp+bzp3TNzw48Us3ZZH5ieUrF2dIVRAgSNHD6x4oMJVkJVjReA7xNd1rUGg
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH3PR12MB7571

On Fri Jul 10, 2026 at 4:16 PM EDT, Lorenzo Stoakes wrote:
> Update the file comment to clarify that both file-backed and anonymous
> interval trees are provided, referencing the relevant data types for
> clarity.
>
> Also add comments to indicate which parts of the file apply to each.
>
> While we're here, convert the VM_BUG_ON_VMA() to VM_WARN_ON_ONCE_VMA().
>
> Reviewed-by: Pedro Falcato <pfalcato@suse.de>
> Reviewed-by: Gregory Price <gourry@gourry.net>
> Signed-off-by: Lorenzo Stoakes <ljs@kernel.org>
> ---
>  mm/interval_tree.c | 9 +++++++--
>  1 file changed, 7 insertions(+), 2 deletions(-)
>

Thanks for the comments.

Reviewed-by: Zi Yan <ziy@nvidia.com>

--=20
Best Regards,
Yan, Zi

