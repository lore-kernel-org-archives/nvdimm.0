Received: from MW6PR02CU001.outbound.protection.outlook.com (mail-westus2azon11012045.outbound.protection.outlook.com [52.101.48.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 079C82356D9;
	Sat, 18 Jul 2026 02:32:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.48.45
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784341978; cv=fail; b=hWaKHiAf6AYMI1RJNdhtHoU/9e7FBkAn9xSSu62WK0wbNHGjTQOZmDiItjUOFvM3dOTLFuswgSJiRhWgMDNLiTKBMYlIWL4NtPdjUejPQQXmsNrS8PiMOB6KjkgYtICAEOfvxLX0c6rPuDyOJ1YlHI2x7jeK1Uikko+qzBb3Ke4=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784341978; c=relaxed/simple;
	bh=p4HClTwtKWlXhL/5/u/AsvG7rxmgHdNiBUV8Cj9n7xs=;
	h=Content-Type:Date:Message-Id:From:Subject:Cc:To:References:
	 In-Reply-To:MIME-Version; b=QimuGTe4k8y9CwDVy9lpKPrc9vvpS5m2Se/TUXZAZZfnev7fz9o82chqdLteFuIyRCXf5KyGpS3DX0fD32+DzpiEpNU37BYxLbT8FECxJ5GkjFKDHKQXtxA2cCEMtYcbVOtjKTtU1PzvsGnK/5sdF2B/mRrOnwmXUZJ/+okDMsw=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=iVkZ02R+; arc=fail smtp.client-ip=52.101.48.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="iVkZ02R+"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=kWTZ7gm0Pig9U5ns9wDpvX282M+QRRXuXqYRP2HANiGMefsJQ4+8sGz2pFAsWM/zP6ehLQau+PYHUgGCsmc+U08LFeAZgwrB7guDQee9YYL9DM/s87IFu8AgYMF4HVm/98DnXmSP55p/6A4XTJDbx8YDTHQnzRaYS4fr5iVZ+XafHWJvGYzPmEp4/iKHLJr+kvpcLgtv1FVcWkGoXlCRW8ndzubScsdEeG4Ci/NA1FCX+C4akPvxXIAl69y6CfNGGwoCuD0oOhbYraZoCP2fci6aW+OS2r/rx0jJk3GnWn++NE1NaU1KPSHvrCK96HIObZe52AuvpncJ9NvjYEavRw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=bS+RTRAUJWEhSEBz9wSgFRO611zQJ1yvU2JKV3L5v9o=;
 b=tCgT08YKV/GiKtm2jmHBIGV77r3YjsjBOTxy7OPKK5rHvrGHM4iwhqVaIvUUDrqm7mnceXoALhe9NI1qtd9LMl8RSfqK+adej/hJnA7QnWDANk0DEnx1VmCmzReX3fMaqHmPiH6tNJ17SUfKwPyQgbNxQcp0ouQNo1xoHQHJVWhVdooYffS/czIrPIAB3bVIlqhs4z6xcIaKi1tisQjWJRCBl5gIKcSA4beMGTNY1dXnCjg9UuutzxsxPZQmc0g6y3Y4zmYBv6/aRTWSi4UeyT/B6brznz57XjEYatb/BRgIRRrZpYI9IvaSr5gSZBZYDmN396NTvkibM55iDPIrGw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=bS+RTRAUJWEhSEBz9wSgFRO611zQJ1yvU2JKV3L5v9o=;
 b=iVkZ02R+DDELjbAdYxecF/T2rTr/nbB6CX4dl05yyi8ATeCTUF067CAGfy6P9ZQ01+VKIOPDYSCfs3ngDjDlWTAl0bCBKftOYqW1nhj6z5gp252Wqdnf6oDk71sFSJt8gJQfNrGHywk99MsqU40UMPRozJmRwlWIqwQc9Qk40zdEoWilU6z3USbuRtcrnN1XxxbqGERiNwBIMz0xvrMjMD6muNxpav85EIaBzxKuzy4wUtg13GMiaMS9YOEzgiJjT7xbMWYD7Wegv08YfKWaMdzaHoMeXz+zeO3013qNMvCcCUecb3AI9sEZ+3Y3VvMoP7GkcqTWLzLEP/lkMXCIjQ==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from IA0PR12MB8374.namprd12.prod.outlook.com (2603:10b6:208:40e::7)
 by LV9PR12MB9782.namprd12.prod.outlook.com (2603:10b6:408:2f2::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.223.13; Sat, 18 Jul
 2026 02:32:50 +0000
Received: from IA0PR12MB8374.namprd12.prod.outlook.com
 ([fe80::d85f:4c87:ae84:3f16]) by IA0PR12MB8374.namprd12.prod.outlook.com
 ([fe80::d85f:4c87:ae84:3f16%5]) with mapi id 15.21.0223.012; Sat, 18 Jul 2026
 02:32:50 +0000
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8
Date: Fri, 17 Jul 2026 22:32:47 -0400
Message-Id: <DK1CFRK7F8IT.13JN4XI36R8W6@nvidia.com>
From: "Zi Yan" <ziy@nvidia.com>
Subject: Re: [PATCH v2 03/33] tools/testing/vma: use vma_start_pgoff() in
 merge tests
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
 <20260710-b4-pre-scalable-cow-v2-3-2a5aa403d977@kernel.org>
In-Reply-To: <20260710-b4-pre-scalable-cow-v2-3-2a5aa403d977@kernel.org>
X-ClientProxiedBy: MN2PR06CA0017.namprd06.prod.outlook.com
 (2603:10b6:208:23d::22) To IA0PR12MB8374.namprd12.prod.outlook.com
 (2603:10b6:208:40e::7)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: IA0PR12MB8374:EE_|LV9PR12MB9782:EE_
X-MS-Office365-Filtering-Correlation-Id: 25c3ba29-a11d-4679-3e6e-08dee474dcd5
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|23010399003|376014|7416014|1800799024|22082099003|18002099003|10067099003|11063799006|56012099006|4143699003|921020|6133799003;
X-Microsoft-Antispam-Message-Info:
	wY6Fa/LVjbXuXpWrKIN7lTFm5yPdHAe/J+o1Uv0BmPCye5WzzEEve+C2NXUWC6VdryCyS/xcYOsbPwlyBBxF93Syto6ZsFty//T0sWs7cCH6jbHu/Ws7kUjUSWMLfhzLsfC3qDDdBOmuPlZMI3FyZ5H9TC6XJ7Sk8lX0l0k6hImklQjwUvz2JlTlBJncDEwKgG0h/TfNUT+MjkUutI1jk37dkHpp7lx9iXp29r161+FZZaPt8rZvjF9VLWg4fS7Duxe+oP3jNQIPnd9zLvfsIfEBmbYx4fnAE+ZO0i4Zom10zFBXUSIbxKSIa+oUzVnA/OMi7ICS1pNuk45yWC/WV1q2+Q3J6QVbYpOMNyFlVeVEV8mX6IPlVLxgMTKm0pYvDAXMlKlrRFJvDxmeqytqQlGDIVtV3oO4IalHz6/UlCKwN2yoo/a1FSTKTDIKf86bR8T9EDx6eOzEUZUBl5nKbkwpe4/fJDpI2DgvNBT9s+1SnLGpQxhEYNs8TISKTYl8fPtbngb6k8Zyy2McJGlh6HZ/OwvRYRuxBPQaVTd4I7vMQRPRFbc12FI6QRhKUQ32y8xuP2REA+qzsiJUY4ao3am02nrBXfkOfnYDtfejxYaZNK9HqTQgEkKEHi2xBAkBRL5Ereqiwubfy0nyexnY04bJ8d4rD7tsm0E9UegwFUWz8gl76aBTD3AMbc+sWTHPrO5YJIVnsYGc0mrbcfa8Eg==
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:IA0PR12MB8374.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(23010399003)(376014)(7416014)(1800799024)(22082099003)(18002099003)(10067099003)(11063799006)(56012099006)(4143699003)(921020)(6133799003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?dmRqQ01XcjhycE1QYTkyZzF2elpUOHA4ekdvWERhckpjakwyZXlSQWZlbkFo?=
 =?utf-8?B?M3RrMG5RT2UzeUFCY0VFYUNjOXVheUZWSmJyV2s3ZlJBNzQ1aFRaUjNncWlk?=
 =?utf-8?B?R2hNREg0Sm9ybVpCa1FZc0ZTUUpIdExWZ01nY255cVhOZEo3a255MzB2cTln?=
 =?utf-8?B?enB2ODQ4dFpIbHQ2OTFUUjhxMmlRRFROMmY5Rnp6VlhQM28wSFZjR0FGcEFh?=
 =?utf-8?B?Mitra1lSaVcxR09wOGRMdE9haFFZZ2duMEx6SHpNTEEvVStRbU9hL3V6c21t?=
 =?utf-8?B?TTRrZTdiaElwRGdCQmNKTDRiM20xckVJd2szNTNhejEvRlZiMHpoWDRhbzZo?=
 =?utf-8?B?UENGVUhJSTU0N0hKZEg4aFVuMGZubHJhdXVWVzhGZy9LNVY3ZmdxMFlWNnBm?=
 =?utf-8?B?T1VkSTB0MnVRYkM4d2JFZzJCcUJHalhsbWhWZm5aUzh5Mml0b1ZDSnZXZlVp?=
 =?utf-8?B?STRTQ0p5ZVBhNDU4cXpSd2JkVmFaUU9IeENlRk9qZHQ5bUZDS1o1djEzUVNO?=
 =?utf-8?B?R0lWM1Z6Z1hxTkRzc0tGcGkxakRZVU1zRGtGT1VCM3FiSFZaUWNOUWVKekkr?=
 =?utf-8?B?L05rUFhPT1MvTTBudStrcEJ5NHlwNU9yaWRsd0grcXVrYXVqc25Yc2VvVEw4?=
 =?utf-8?B?Y2s2cUs1NjZDbUt6Ylo3aDM3OWl5Sm84V0h4bWh2c1llN3NteXBtWlpiVk5o?=
 =?utf-8?B?QlBtWjJXL1pTV1d6clYreDcwWXdxbDR1NFI4ZmExY0NPWklCUzkrOTA2U3Jh?=
 =?utf-8?B?akl2T002Q3BBdFN1R1RXY0VyZ1dxNm9GOEJZZWE3bWI2T0VJbGQ2b25yQ0Nw?=
 =?utf-8?B?NlQ4ci9mOUlsZmpmRGhZbHdpQUdmYVl5UTFBcS9sekZFbEtWY0VFVEZVUWZI?=
 =?utf-8?B?MHB5Q2gxVkhHTnhYVy90WFB4d3NncFQ1M1VjaS9wR3ZDb1BHRVNqdEhNN0do?=
 =?utf-8?B?R21JVEx5eXhOYVloNzlCSmtYcHFPSmxsMG9uTzM4Smx0Y2R5TUt4aVMvK1lN?=
 =?utf-8?B?Mm42KzlieExMN0dkSk9XSnowMzNHNnhLU0duRzBqdllKL0V5VFdRdlNhMi9s?=
 =?utf-8?B?ekU3WkkwWThpTW1qendpMXQ2a3l2a3pZaVVXTWFmUzRVbUp2a1IvdVVDM1BI?=
 =?utf-8?B?VzRMTnNIejIyY1pwd04vc2lpYThhcXl2ZG96N2Z5S0Jta2FVY2VhOGtmVFNl?=
 =?utf-8?B?M2JQVGtKRkVzcE5BRWVnb1VsUlpKendHME53aDFoZnBrUWdQRUxRcFBZRURP?=
 =?utf-8?B?RzE4bVdPN3Y4M2JZQVVjbSs1WXppVVRZMzNOREZXTGtHQ2VZUllPWmhLa3pp?=
 =?utf-8?B?cHJrY2NSVlFSbGxEdlpuOTBWSzlSQmlFaVRFZXl5T2xwOXJZMWZZdVUvMm42?=
 =?utf-8?B?RGRoNkszMmVhRGlEL2QvUjY0d0paVVhsM3llcnBmSnRiM0xNR25PbGFJVGgz?=
 =?utf-8?B?SVgyaEJ0dU1PTFhCemZRemtZWHVKdkFIWlRCcnBER1NnRlY3R3VoZGd2MWdE?=
 =?utf-8?B?alJ2TEN5anVrcVFzcXBQeE5zTVFkMU02cXkvL2lmMHdpUFFjNTArSlNqMElt?=
 =?utf-8?B?UUFUUnEyVjJBb3NPZFJ3YnlsYjc3Wk5jcTVhSEhYRy9CV0lIRzJjZEpOWGFl?=
 =?utf-8?B?WTBBR3dCMExUVnROQWJ5TUVTbThwbXh1T2FESUZyOURNa2JUMFBGb2FiNGp6?=
 =?utf-8?B?K2JJU3ZiKzVMZHVEM0haUHJyK2ZQb09EQzBBN0VoTXhTVTJ6eWJEbnNYS1h5?=
 =?utf-8?B?SHVRZ0lQYlU3b1dQL1V5WUNXbU5KZU9WL1VrSzBrS1l3VmFzTmZaMVdLdlV6?=
 =?utf-8?B?czZGY1F3cmt0UWRTT3d1VGROQzNnbU9uTW1oVzBUcStoZkZSNnZCWjFLL0dV?=
 =?utf-8?B?dVk5QUtBRUd2bzgzUXZCZlNYclFGem5lRnFuc3VSVnpkQiswaitCMy9weWl3?=
 =?utf-8?B?NFhyVDRiYlNvem9uS2NqK3FFMlpmQlp0R1ZDNEhLdldMQXJlU2QvNU1BeVlH?=
 =?utf-8?B?NE9uY0lVNmFSbnB3eDRLaXBaMGN2d0tmbE00bk5ncmk5SUtVZ3lrdCtqQlFF?=
 =?utf-8?B?N1lQNVZuN0hyVzZ1MzR5dmx3NDIzdFhiZVMxYlZtV2xzMWRwbXphMFQ3Y2wz?=
 =?utf-8?B?NTUxNGlYQnZUNUpRZFU2dC9xd0UyVVhUc3pzcnJHQmVaeXpLcHRUdU80Y0Nk?=
 =?utf-8?B?WktteDM0MFFPN3hETDBzSEtjN0s3dXQzdE5kK3kzN3BEMUVOQ0NxRVlpMmQv?=
 =?utf-8?B?eldjdExVU0dkOHk1dDRqcEdRUTkzNFpUR3ZTaTFUaGxoS0hLaXZlaEgzcGNL?=
 =?utf-8?Q?ZuoxosBMZWBwuO+5ZF?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 25c3ba29-a11d-4679-3e6e-08dee474dcd5
X-MS-Exchange-CrossTenant-AuthSource: IA0PR12MB8374.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Jul 2026 02:32:50.6679
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: rF2+NUGWv6M28UDWYwtV7QMq3x74/UGPxrrlgvJmlSOQQ6U4f3CgqmD0LeGuxwst
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LV9PR12MB9782

On Fri Jul 10, 2026 at 4:16 PM EDT, Lorenzo Stoakes wrote:
> Now we have the vma_start_pgoff() helper, update the merge tests to make
> use of it for consistency.
>
> No functional change intended.
>
> Reviewed-by: Pedro Falcato <pfalcato@suse.de>
> Reviewed-by: Gregory Price <gourry@gourry.net>
> Reviewed-by: Vlastimil Babka (SUSE) <vbabka@kernel.org>
> Signed-off-by: Lorenzo Stoakes <ljs@kernel.org>
> ---
>  tools/testing/vma/tests/merge.c | 38 +++++++++++++++++++----------------=
---
>  1 file changed, 19 insertions(+), 19 deletions(-)
>

LGTM.

Reviewed-by: Zi Yan <ziy@nvidia.com>

--=20
Best Regards,
Yan, Zi

