Received: from DM5PR21CU001.outbound.protection.outlook.com (mail-centralusazon11011004.outbound.protection.outlook.com [52.101.62.4])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 98F90487BE;
	Sat, 18 Jul 2026 02:56:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.62.4
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784343418; cv=fail; b=sNVMVqG9NiP45jurC715RR9EL0SLq84dLjWz9u/UQxdRqBhGHoD0psUhPlpaaqxHoUoMTWeuwznxTqSUN8vKAjvqoJZ9UTHFI37upJl3jGYMy3Kj3owJioN4kJ2Ju43xf5PA4DEQTxfApyjDL7zi1tv/891ubgZ3tIIcHXKd+f0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784343418; c=relaxed/simple;
	bh=k24bDpycGY6lev3n/I30S8cSCDkkWUaGRUhrQHxqpQw=;
	h=Content-Type:Date:Message-Id:Subject:Cc:To:From:References:
	 In-Reply-To:MIME-Version; b=qWAGGHxJV6NceYQ77jM3ZYNqlC6+gxh+DrnZoG6aS4lTnAbwHi1U6z65/67J4N6L+bhoyEflAqSRvuOkgy/RnycWGkTZs+upOr+rI0wAyUgFEWiLACDaqJMQzFh2bBlIcZTQ0Kv7kEIsEVmAsZLUDOo9o2cRFglQszxT9R829l8=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=SsZB9CIr; arc=fail smtp.client-ip=52.101.62.4
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="SsZB9CIr"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Cmfwn/XNGsQ3Sqbj84APcfijCsDttXnvFuUVUnzcM8u+jBn43LgByv1vOaPgXsWVQQeNdMTy93erFbEe2tdA8TLLEefKaya6btaYrowUrCTfcnrnqJMklOT0V/avRP6YTndJDGFfrNRNDQKbal/VZCNnID4VhsDG7kBEXxoLYMyGDQw9izRXFQyp1WFcN7Ip3bce5+nno6sPjJf6OGRcZLGaH7CGUGjwBxM6FOt9psLFOYOV95gCceohEFGOJkoVI9E6qvAVYQ6dnj1gM+ZjoE8zCBM8d2/N5OUoz74+SjupMqyrhSf8hLMQTxTJg1Hg976C1oxSUc6HOTbI4aY3UQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=YWTZJmHaFm1PVg8IT5RTMgoWcm1YnbUp1qGylNNBPgo=;
 b=ZMqY0t7Hh6fZmu9SQHRMi1+YWVJI6evWhkNFliNNCB8TK/dCmMScsLurFKQcgJPLNJOih62AM+HhrEsZiwkM79iknD3uss5earAD2UiuuO5PnbUl2O63M8ivNpWRKoVsCFzb8kjHrzd90wrt50Lh9abmlRADGqfOVYI+YbO6OWbUu8Q0NcjRff+YacdfxnmUPoj4bdUm1cyKjXj48AN86eTt0SdhLrHELtpdSDzdas+YwRr9/A1clL2PUHJEhL7tC1yY3onvmpxVu/7SnSaB0XYCWLNBRh+UlPhJ7wUv9wROGJQBJG6XgKaNH1H2H2Zd2xMGLcwnT0OyZxZ7DecVMw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=YWTZJmHaFm1PVg8IT5RTMgoWcm1YnbUp1qGylNNBPgo=;
 b=SsZB9CIrHujdnV9uSP3KbGZkIiSikZgVo3v7GR5VMj4LS2GJFCjvRgRiDBvf1lr4P4CZa+l7liRqrMiF96+heWpPNwrz97fz81R1W2HaQrPGjwTY5fG+9AxbKdFL3tvkDWy+rzoyDqvTancZyOiR7NtJt+fo8C4J8MkDGCnKQuRmILEZymJmvAKm4F9IsUyZ5hPO1zahzmjX/ENbFg9AcxsRagNOx2lK/Nuj/Dmywy8hfXVPBBzpej9sU2ewS+GmtyYqLN+UucF5PGip0n9PfNQvzKETXBikYA3ZO+C7jwMCnyNbDjQgyE7ZzzmoBhyxW4YQZyvFMNvjUMy1VwrW3Q==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from IA0PR12MB8374.namprd12.prod.outlook.com (2603:10b6:208:40e::7)
 by SN7PR12MB6885.namprd12.prod.outlook.com (2603:10b6:806:263::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.223.10; Sat, 18 Jul
 2026 02:56:48 +0000
Received: from IA0PR12MB8374.namprd12.prod.outlook.com
 ([fe80::d85f:4c87:ae84:3f16]) by IA0PR12MB8374.namprd12.prod.outlook.com
 ([fe80::d85f:4c87:ae84:3f16%5]) with mapi id 15.21.0223.012; Sat, 18 Jul 2026
 02:56:48 +0000
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8
Date: Fri, 17 Jul 2026 22:56:44 -0400
Message-Id: <DK1CY3WXQV1F.OIL1AD6JY8N8@nvidia.com>
Subject: Re: [PATCH v2 09/33] mm/rmap: parameterise
 anon_vma_interval_tree_*() by anon_vma
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
 <20260710-b4-pre-scalable-cow-v2-9-2a5aa403d977@kernel.org>
In-Reply-To: <20260710-b4-pre-scalable-cow-v2-9-2a5aa403d977@kernel.org>
X-ClientProxiedBy: MN2PR07CA0017.namprd07.prod.outlook.com
 (2603:10b6:208:1a0::27) To IA0PR12MB8374.namprd12.prod.outlook.com
 (2603:10b6:208:40e::7)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: IA0PR12MB8374:EE_|SN7PR12MB6885:EE_
X-MS-Office365-Filtering-Correlation-Id: 1bca0b87-e3cb-47fd-cd1f-08dee4783595
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|23010399003|376014|7416014|1800799024|366016|11063799006|4143699003|18002099003|22082099003|56012099006|6133799003|10067099003|921020;
X-Microsoft-Antispam-Message-Info:
	BlaqjHg9q8bBi5NO6UI6eMYCDRzvY3tqKuGC+WSKe4PTullAbrJ+Ni6Ie31UC2+lDctOFMzNWEgZufh7SPjYv8fWnSeAp3hH1+oErj56Fh5+PWuAxlKRFxC8NSfP4Mf/6Q45vF84uN9FzULbHRjvaY46iwnzA1GH/DGy4SSP6cuiFaE8WueKlYFsfB8k0nz0+Sg0pWWbNsMvJtRnvcPSngnKk7JE0KK2uVe9b0U8SZwINN0fdb23ZB5y/k0ILuPjM7ijC/UZGVxQhAxF24P3utBICcCcuC8NaV1fJ8AnmNzs0wE+TzLivYDYav9P8phGAwuXvR7ym3fWpy4nOREnNjqCd5zSyhp29TT6qK4WR29FxrLKF1dVcP+NFo7f8hxJmk7v0hmcvhsb9/TPKaYKEU9oR2ua1iYJiQDytgLNJIDXZ06D8qhw+ufI0y/gGF9maVifazIeoSt/YsMVZ0rp4jWn5Zg2EnsjSajEuSMQwukYDTrNF/hbslKkxPNmv9zrp1p7iyLeki2SzZflWRlK9Iay+2ccNeT3Q+wqTtH0fd3nqR8Xk6BzM8XHP8BHuxeqywhQaz1MJYoXnBUUvR48k0CWCayY0ocfDzUYz4PudDtQNVHyGPv5ub6CfPTXzepIepePLvkSKMl7CKmTCMVBKBHNlliT5UjKUNybSB0qk++1Y9EIE4j9/qdWwJtK/HJHVZzgRXfN4Z+7xyRhlK2Agw==
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:IA0PR12MB8374.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(23010399003)(376014)(7416014)(1800799024)(366016)(11063799006)(4143699003)(18002099003)(22082099003)(56012099006)(6133799003)(10067099003)(921020);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?U3VQTHBXdXRiUkwvN3dNMEdXVUlVZ1owZkFEVk94ZEdRbzY5NGY1emt3TUFU?=
 =?utf-8?B?YThrSVR2OGQ1djFYYXQ2a1IrdHFLdUFGSHpKNUpGMzNxNTI1U2crd1V4RjNw?=
 =?utf-8?B?OTN4MWM1NDdVeFhIdmh4b0xrMEI4YlZ5NEdaR1cySXFRd2tQRGV1elBXN1dG?=
 =?utf-8?B?ajhvMWhaVGdGaXhueVdPZlFMcHMvZVpzbVl3ZTcxNndGZUZBVk1NdnJBTlBs?=
 =?utf-8?B?d09wWDFOdzhtNkNxUUIycGsyOGNMWTl6NW9hakdXTWtaRHRRRW5GZlZYNzdm?=
 =?utf-8?B?Z05KTE0wb0N4TjRZUmROWHgxTjNYTE9OUlFCOXpZcGZyR1hxNVp5ZHVCaUYw?=
 =?utf-8?B?MzB6TmRId2RaRnllemtVOG12anZkRjdEaWNWcXNlY1gwalJYMWowRWsydHZy?=
 =?utf-8?B?SmxkSmVhVXJXSWY3SVcrcUhkUC9VZXE5Snpkd2lTRTFIdWxEYzZhVnZTZDVp?=
 =?utf-8?B?RDlLUmtwVjRyOFMxdXo3Z1lGODJ0SXlDbXY3WUppY3BhdzVsWU9xMnZQVmxE?=
 =?utf-8?B?UXF6QTJqZ2ViR0NXWjBWaFZBTFk4UDV0dzVTTzd5L1NyR3hvckhleWdZZTVN?=
 =?utf-8?B?T3Q1b3UxZTZQMXBSU1NXNks5aGY2SG12c2xDNW4zTUtGZWw3S3VaQi9HcUhJ?=
 =?utf-8?B?VkJVOXJvUHRaUDF4T0xSblhCOEZUNGtlZ0N2NkRMMWNJbGVmMVNyaHAyR0ly?=
 =?utf-8?B?UE1XOUxhd0tWNVIxK2srV0NudHZYNnJtSjJKcmtNWUFXdms2djBOTU5RWGN3?=
 =?utf-8?B?bWpseURuQnQxd2wvY0x3aDFtNzZaYVJuelpkcjZoei9lME1GZGxvSllCUllP?=
 =?utf-8?B?SUxpVTVOa0YwMnhHU2UxTXpMRVdHWGRaeW8rK0FOdFJycXRsYmpyMEVOaGZZ?=
 =?utf-8?B?UVgwdmRuUDVwS243anh6S2dRKzJmNHZGUTFzOXFzd2s0WU1WN1RwejA1dnFp?=
 =?utf-8?B?TlVSMEVhVTg5Z21SZm1UVUEvQ0NOOHhVMm9Fd1IwbTFmelY4MlFVNnZxT2FL?=
 =?utf-8?B?UXQ3ZW44ZmovNHRpNTNHdXNGUzFTVDZpNG8yR1VheUZJNldSSXFmS2V1dFpX?=
 =?utf-8?B?SVNFWlVuendZVFl1cVpXN2RhVkd5U0t2eDBWNHJoRkpzL2lleUNTL3lycmow?=
 =?utf-8?B?UFNGNmJYcVNUeEFHM3dhTkFEMG1DODhkUlpzNXhtYk00eEJZSGVWck8rUUg2?=
 =?utf-8?B?bHJEdk9JalFDMlBJaHB4eXJiTDI4d2tyQlY0ejAxdS91ak80WFdTWjNueGth?=
 =?utf-8?B?bmxJVUU4VUoreGkzdzZDUkowMTlqTXd5TktrT3BNczRXQ0JIM1V2akZSL3Qy?=
 =?utf-8?B?MmI2WmpTR1pkZEE4ZE8rREkzMnNQQ2x6eVBsYjZ1U3ZQbS9qUDJLV21SQmsv?=
 =?utf-8?B?bEJpUVdKRnR2b0hnb1dGbEFLZXZNZ2VydU5GTG5uZnJ3bHpuMjZNSHlEZVcv?=
 =?utf-8?B?dWZwenpzalpOK1FBMG0vdHZHcE9XQ0laeUJDMXJlNUhiSWxNYVlqTzhQUFVY?=
 =?utf-8?B?RUFSRXQ5YUlMdW5td25wYnpjM0F2K3lWb3g1UGNPKzl6cmwrTFpkZEF2WWtQ?=
 =?utf-8?B?disrUVZjc0U2aWo5Z2Ruek9qV3kyUmtxMnJzWHlFS2ljSkptZ0VUa3ZHRFdv?=
 =?utf-8?B?TXRLL0JYRE1JeExLSDMweWVULzNSbmNUZTFueGF4aC9DdnRITkFuSW1NQzJO?=
 =?utf-8?B?WnE4bDErcFlIMDJXa1NyU2VycEFPOUMwbGVUd3UvSEtNMzloSWNKeW9STGhB?=
 =?utf-8?B?dkFrZTVjd1RGS2JMWVFIS3dMNmhNMk5KN0tBL2JLZ2ZnRjNsdFo3WlNRTUFm?=
 =?utf-8?B?dzB3d3EyQitmeVBNSm54Ym1OaHpHcEMxdEFtQVdVUzFDOVE3cVU3MlkybGpD?=
 =?utf-8?B?ODdBVnpPSGZkRnhHZklWSHVmdEJPR1ZaNXoyNmp4R0VndkNMZERBUnBvZjV0?=
 =?utf-8?B?Z0kwS0tKVnoxd0QzVHNNeEJhOHR3Y2dFUFJ6Q0UvMHhRUlEwT0lmbE40dHZh?=
 =?utf-8?B?S2ZKU0Nlcld4SkQyWWl4NGhRcEVueENTemdmQTVqbVBGZElXc2MzNVBMNktt?=
 =?utf-8?B?bFZGRW5kY3o1UUJadFF3NVRkcW8vWG5iY21mdjVyZlRScFNVK25ScjNQa1ZF?=
 =?utf-8?B?aDdkd0RnNXc3L0xJNFUwa0VUYVBmQmJXdCtrbkJDQWh1ZEZzNytxVkoyc2tK?=
 =?utf-8?B?dmFTVEx4NUdJc215OGVqTzA1U283UjFCUWNUNm0zQk9Zc3RGa3pYUUdhdzND?=
 =?utf-8?B?b0dMMlh5dUxFd3JURytwMStsRWlTZkpkK1hmZFpFRWliOGtvclNqeDJIUVFt?=
 =?utf-8?Q?NFmeo51pYz+SHAA5dn?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1bca0b87-e3cb-47fd-cd1f-08dee4783595
X-MS-Exchange-CrossTenant-AuthSource: IA0PR12MB8374.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Jul 2026 02:56:48.0592
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: OsNGjc62p799U+Ktff2ZnjSKF7DnNA8NAd+5hpDbSY5ZaI8ldj4zsBvwC93+bXQe
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR12MB6885

On Fri Jul 10, 2026 at 4:16 PM EDT, Lorenzo Stoakes wrote:
> Similar to what we did with mapping_rmap_tree*(), let's declare
> anon_vma_interval_tree*() in terms of anon_vma rather than rb_root_cached=
.
>
> In each case the rb tree referenced is &anon_vma->rb_root, so just pass
> anon_vma and the functions can figure this out themselves.
>
> Also update the VMA userland tests to reflect the change.
>
> No functional change intended.
>
> Reviewed-by: Pedro Falcato <pfalcato@suse.de>
> Signed-off-by: Lorenzo Stoakes <ljs@kernel.org>
> ---
>  include/linux/mm.h                | 11 ++++++-----
>  mm/interval_tree.c                | 13 +++++++------
>  mm/ksm.c                          |  7 ++-----
>  mm/memory-failure.c               |  3 +--
>  mm/rmap.c                         | 11 +++++------
>  mm/vma.c                          |  4 ++--
>  tools/testing/vma/include/stubs.h |  4 ++--
>  7 files changed, 25 insertions(+), 28 deletions(-)
>

Reviewed-by: Zi Yan <ziy@nvidia.com>

--=20
Best Regards,
Yan, Zi

