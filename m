Received: from BN1PR04CU002.outbound.protection.outlook.com (mail-eastus2azon11010013.outbound.protection.outlook.com [52.101.56.13])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D9D251862;
	Sat, 18 Jul 2026 02:59:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.56.13
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784343553; cv=fail; b=YX2XKN9Cf6FDI4I67TTD01ORjuTbjIjUmahq0I1pf3vljj4PNsT2ARhhrS6Wzd8cLm05Iuth5Tx2tVABQqzg4jnOvXdUt34r5JZKulWPAC7vGNEBeVYmDtrtzG4ZMPeIkAfijsKSQBvX6TT+ZBYfrPdZNRdNZzc1m7edAZU7+nw=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784343553; c=relaxed/simple;
	bh=AuZA3klKKhA6cuXWX3ufrPJ1P26g4eU98nrjhJ/jB/Y=;
	h=Content-Type:Date:Message-Id:Subject:Cc:To:From:References:
	 In-Reply-To:MIME-Version; b=u+nO/c6xYws35BAf9IGYuKuUOG9ss93npQt8C0VO37zgRKCtSY0O1YUNP6JZVnLoC/IWOZEfWu7vEYlj7s+0G2wXUmxtRsCfwlUj3yQ2MFoER6msWRcaZIGXbZyOcNYKIFd2/7ctED2LrfXb97VP6NdXkBVzqReP+jsDVHGN1wg=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=Ck/x6pgA; arc=fail smtp.client-ip=52.101.56.13
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="Ck/x6pgA"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=P6rAouNL8/mpVkO55GtL7NJbVoNKz/XEWmC8WGy3CZo8nhnU6UkqLE//KH+xfVOmiORtr7/SFKPQ5LKUMfTEjhEw43kgrDee1YkmcU7uy9IyNyqNZcZvkb5YGerA90/dgV9EfoxS1xGa+n+o/bTcJVLXkZL73XxTGZRdr/cbljI7yQRiKuLbPnz+c2qfKvPJokpm3jTr8Rc+yPv5WmUPo1IjKW23dr+jQfKFn4SLgojLSfx6vEv+nsI98PSxSf6jZruQTfHovho0YffdaGgMqFdV/+XmT5hm0SW1Ta44yZODcAZoL9pS0YF3r4YFTwSz+jv1CXqK43Peu9+3M9tv9A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=PCptvaLlxbm7FcYPJfke/0xXk8q1AOLpmJSEJVJOJeA=;
 b=e9SgWoCCMHkTHHDmeg0UVc9KBwJxGXlGy+1XRbjQdktFJSx8v172tLSkMmzxbM8KeBus0R8uT4jN3KUApiexkRxf1/FNc44B4wbSu+A6FyCqnDrhmj2oRR6wLDm633bxFmvtFGMYebcTFuup/S0+DIMa4z1X0E9QtioAuMERPTFn8EknEV690aix1otEq81DqPtddW13o2JA5nzZPzBmG4f6F9Op2qGY1i/ovuBmR52NKN9RwL1XPH1H+AKfmP2IYNemIsLqfIIuq21ewA/+ncrjmfDxBxYLw+/tbOc1/TG7OBMAAFDRzcq+7DUe1G2B+O1AtIaWzE3GzJeq61TyiA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=PCptvaLlxbm7FcYPJfke/0xXk8q1AOLpmJSEJVJOJeA=;
 b=Ck/x6pgAU3koGDqcQ7RDLX0FX2tfWTA2KJ9niKnpIaaaHhf0T6IQEOL0KF3oX5sGwMUuTARnzmj2EYhik9g4ys9ak320NpYm4V65qZXNo4WpcNEQ2RkhtC+miiI5tl8hIKNMvJanCwQoKtHG+uWk3wI8jQ8xZ0GRYnSaAICZHd8E4T9C5+ktKYbf3+663ekP1xfmKMVEvXWmzPVLCsnV9GmtErG9gWnhlZloOGHYNX819UTU6TB8+K+4nxvHMac23u6jkxZHDDhJ0rDmOLiQ5j803tC6hrlEQ1JP1jMRhAI2aNN51IbkPI1dVWw41DdrfuDowIgtyILZS+Ru7cHi9w==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from IA0PR12MB8374.namprd12.prod.outlook.com (2603:10b6:208:40e::7)
 by DM6PR12MB4483.namprd12.prod.outlook.com (2603:10b6:5:2a2::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.223.12; Sat, 18 Jul
 2026 02:58:55 +0000
Received: from IA0PR12MB8374.namprd12.prod.outlook.com
 ([fe80::d85f:4c87:ae84:3f16]) by IA0PR12MB8374.namprd12.prod.outlook.com
 ([fe80::d85f:4c87:ae84:3f16%5]) with mapi id 15.21.0223.012; Sat, 18 Jul 2026
 02:58:55 +0000
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8
Date: Fri, 17 Jul 2026 22:58:49 -0400
Message-Id: <DK1CZPAXCD7O.26RPEAG1YS7I9@nvidia.com>
Subject: Re: [PATCH v2 11/33] mm/rmap: rename anon_vma_interval_tree_*() to
 anon_rmap_tree_*()
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
 <20260710-b4-pre-scalable-cow-v2-11-2a5aa403d977@kernel.org>
In-Reply-To: <20260710-b4-pre-scalable-cow-v2-11-2a5aa403d977@kernel.org>
X-ClientProxiedBy: YQZPR01CA0156.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:c01:8c::28) To IA0PR12MB8374.namprd12.prod.outlook.com
 (2603:10b6:208:40e::7)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: IA0PR12MB8374:EE_|DM6PR12MB4483:EE_
X-MS-Office365-Filtering-Correlation-Id: a1c767f8-0849-4c36-2a67-08dee478816a
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|7416014|376014|23010399003|366016|1800799024|22082099003|18002099003|4143699003|10067099003|11063799006|56012099006|921020|6133799003;
X-Microsoft-Antispam-Message-Info:
	xVthCd7tmfCIWBgNqNImnsdWMArXsCHkwPNweQQHCzb8Tdxk3nQ14969FxsAO/ep5eE8MZGYIx7FNX40Wd15zMqsLDKbMm+srUTRX/4UPif/mZXVT3rBE6rxMNU2/Ka4qiHGYnLIzI8uQ2w0SzGWGi7L1mdpbOLxJVHmTYwJarEr38wjTF8sY/34ikoSRG75AXtA6JbCdF3gTUHlx4kEqPT+Ki33e+c+HhSKqJictp3wVV9ilVpr+67oG/Em5fe1x0o3y2nkvk2ZTvHM6Q450k5B8aodVkvDTxPuaqIZsJQjqiTALi0Ineyn+leOtGw1VMO+nl2CsHGi02Znq2wTOK/O3Jg6qoEyRnXTfk46lStbA7H6ABMTUG7RlpsTrvP58Px0bOff1XqlRfJfdXl+A9hr1vg4LsLInNfwtkuRCUD4YpqTynor6zxAaKAMiIMhcQFbn/KKkBrVreeEovezsmZd2ohLcszP9Ozl6rnNG/A4HxkVYvu9g6D/d1HtqYpskm0zSiTg0hcWwIKe3qPqnAjd+W0a+dp2xWxcv86AanSqEbJnlDz3FQr5OgMguBG0m/ubQHKFgFl1AXiCiACQB9NbS6fsoFfL1Lz4CZl91UuKHORq+f41hJDPXlfjILooThtUZT/WAZBIlxlymTDYQFvTlJIh2Kv/Jx77rf6vlrJXQnvxLsU9UJF/OCfGLiMmtsETbqp/+hixJQJqLfwL4Q==
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:IA0PR12MB8374.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(23010399003)(366016)(1800799024)(22082099003)(18002099003)(4143699003)(10067099003)(11063799006)(56012099006)(921020)(6133799003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?S0J5Q25QS1NzcENEbnZlUllNU3lsREpYV2h3QjRhazU1M1ptekxaMzhERksv?=
 =?utf-8?B?c0R3VlJtREdGeENoNlZsWnNSZzdHOE1RV1Y5cWZINzYvd3pQWW0vRUNWUFkv?=
 =?utf-8?B?V3o0dDU3YjZxNlB4QmxhV3ZtNStad3V1ckJsdzhiUFJoeFJlYU9WYWRaaUtJ?=
 =?utf-8?B?Smh2Y1ArTFlmSDloM3RBd2FUMXZESkltU2k1OUdTMzA3a3cxN0swSFFVekZk?=
 =?utf-8?B?Z3d6ZURsYlBrK0FhOGJTanpEdGhPVVV1SWc5dC9BMENWWGVGbWFkempPbFpP?=
 =?utf-8?B?WTZGWG1mN05vMXhmT3dzVzhGWWJPcUUwTVN4ZzhPRWNrbDZHMVBCcGpNK0d0?=
 =?utf-8?B?RU10S0k0SGpnVGsvcUZTbjdHS3ZIRENIT1RDN1IxZC9OYXZiSDZ0K0xUMlNk?=
 =?utf-8?B?K0lGWmNVN2xKdWNUY3ZHdGNlUW1USU5nSlJGdEYrckg1cEhhU2tpSFFqL1Rm?=
 =?utf-8?B?M0xkVXFKcGFaTndvWEV1OHgvQU5HVFl4ZWNzRXVIa2xOdmxBOHpEU3VhekEy?=
 =?utf-8?B?d01SdlBJM3k4Z2sxRnRzOFhhQmQ3TjAvQnFicWJPeFVZZHl3Mmd5WTdTZGMv?=
 =?utf-8?B?U3l4RGJzdnJ5a0U4eXM0SnFNK0FiejlIU09NbWJGT3VGRHI5ZS9UL2w3cnBK?=
 =?utf-8?B?ZEhyc0p1d3hBRysxTTFPaHBGTTVQSDY4c1FBRG1yNzl6amc0WUtWR2E2MUdF?=
 =?utf-8?B?by9mMGV6U3U4dittUUd3WkhWRVJjWXFsU1FTM2R5eTVFYTh5TE9zeTlQakt2?=
 =?utf-8?B?OXlmaDRZbmduWjJGUWlLNW45Y0c1ZW1KUkNyZnRwUUM0Uk02YjEzUHBuSjBD?=
 =?utf-8?B?YjVLcmdhU0hVMkNzUzkyR0xqWTJ0Ni9RdlJzcks1MG8zaElFVXo4RWplNG5O?=
 =?utf-8?B?S1BPbkVKOFJLZ2kxQklkYmtkOTdCVElPQWFTNisyN0dNeHZyZHN2ZkQrYitK?=
 =?utf-8?B?Qnk2TWs1MVloVndNZ2UyMUNvTFMwWXNEOS8wdXAxR3VTTC9RUjFJUWNxdmVO?=
 =?utf-8?B?dnBNMzI2VVI2dVhOR0tweC9EclZEelVKRHp0K2N1cHk4ZG5vc1dDRjd4bDRR?=
 =?utf-8?B?dlJFbmlyaHdIdFZ3SUhqQktXMExQWWVLVGpLeWppK2krZGRBTEM1Mmw5RHd4?=
 =?utf-8?B?ZmxlcGVMcThkTnpDUDdVM1B3QTJKYzk2UkZyZGFtYmUyaHBoUkNsY2p2SnhK?=
 =?utf-8?B?YTMyRkt0OEgyd3oxSERzTm1Fd0NSTGVwYU9rLzg3MDNPOVUvNXpLMGRCN29F?=
 =?utf-8?B?NnRISW94WGV0M0ZZS0dWNy9GMm5XYnRqWUREeXdGRmRwRmRrdjU3Tkg1REV1?=
 =?utf-8?B?Szh1V3E3NDM0dVU3YkJUM1IyME82TFByOHdicm5jRFNZMkliZTlVMXY4WExB?=
 =?utf-8?B?TkxZTHNmczdiNm92dHNPMTRjNW14SzYyb2w2aktEMDFKeDFBOTZuMXUzcXRj?=
 =?utf-8?B?TjgzTTZjSVpQbDVIQm5kMnlIbjY4ejlJQVA5bTQ2TlFMS1Yxbnl0d3praUZq?=
 =?utf-8?B?cHNEWlN4V2dlV3ZPT3JWVlRCWlpUUjZ5Y1VqM1pGOXNvcVVudGkvamt4MVNp?=
 =?utf-8?B?TWpLaEMwcTlvMVQrVUtXWk9kU2ZOaG9zdXNnUlBvRDkwOGJ1b3ROWC9YL0NH?=
 =?utf-8?B?aXJZZ1dlWWY5dzZhM2xHVWJXYmJReEF6b2FrbVlGQnRJUDFsWXVrRTJ5SDla?=
 =?utf-8?B?VmNRN0R3cUJQdkJwcEorNC91UXlvQU1qeFhkQmJzeTRQSEt3RktJMG5kQ3k4?=
 =?utf-8?B?c3BuNU9NUEJ6bFBCNmpxZzhkNXB1NEZsZW9pa1FoRUgzWEo2aWJsYktsY0F4?=
 =?utf-8?B?UUNyKy9rdlRBU2NsRTJlQVVJcVlWdEp6aVNxVHByMjVidWxacFljS21tWWl1?=
 =?utf-8?B?RWNISWNYOEZ2VEZJQTBtOU9zKzJsN2xEQ1B5SGNrSTlIZVN3NGw2V3o5VTVl?=
 =?utf-8?B?MlhRZTNhc2F2YVZ0TmdScWxjS3VGem1sL1VBUzY0SlMrSjh0Qm1LYk1sVlBE?=
 =?utf-8?B?UENERlVMSVRlRG9VL3I3RytGaVlIaldtNllRWVlSMWJNUEtMMUhRUGx5L004?=
 =?utf-8?B?YkhpR1NyZ1lmeGwvMUQzM1N3N1JRMTcydmNVTjdMMmhqOVJ1QmtYOUtOK1BE?=
 =?utf-8?B?YWIvTkkwTmN0OXJMMThIaG8xbGVCMmFrelVST2pGV2V5WHFmd2M4NmVKVldL?=
 =?utf-8?B?M0FTSEttMTlHbEMxbjBKaWdUdUt4R3Q1NzRNb1llbXhFL2NEemJiOU5nMElP?=
 =?utf-8?B?bW9SeGZ5bVAxYU9laHFySmZSV1p0SkNHQ012UHI0N0pSWDlzdnhoZWh0N0NB?=
 =?utf-8?Q?FwMwHllI9oPZe3wgbs?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a1c767f8-0849-4c36-2a67-08dee478816a
X-MS-Exchange-CrossTenant-AuthSource: IA0PR12MB8374.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Jul 2026 02:58:55.3135
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: bABKuGnGC2qW71JMbSbHGvzijuagt2Ebz7zz0Qr9JjD5FQhZs0XzlbnV30PvPiBU
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB4483

On Fri Jul 10, 2026 at 4:16 PM EDT, Lorenzo Stoakes wrote:
> To be consistent with the newly renamed mapping_rmap_tree_*(), rename the
> anon_vma_interval_tree_*() helpers to anon_rmap_tree_*().
>
> No functional change intended.
>
> Signed-off-by: Lorenzo Stoakes <ljs@kernel.org>
> ---
>  include/linux/mm.h                | 27 ++++++++++++---------------
>  mm/interval_tree.c                | 30 +++++++++++++++---------------
>  mm/ksm.c                          |  4 ++--
>  mm/memory-failure.c               |  2 +-
>  mm/rmap.c                         | 10 +++++-----
>  mm/vma.c                          | 30 +++++++++++++++---------------
>  tools/testing/vma/include/stubs.h |  8 ++++----
>  7 files changed, 54 insertions(+), 57 deletions(-)
>
LGTM.

Reviewed-by: Zi Yan <ziy@nvidia.com>


--=20
Best Regards,
Yan, Zi

