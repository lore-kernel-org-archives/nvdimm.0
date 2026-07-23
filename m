Received: from BL0PR03CU003.outbound.protection.outlook.com (mail-eastusazon11012004.outbound.protection.outlook.com [52.101.53.4])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6EDBB353A79;
	Thu, 23 Jul 2026 02:43:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.53.4
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784774583; cv=fail; b=NUGoJA+44QZlOcsZAbwEL1VEih3LGuAUcc0Y2qdOPONOn0RXYDsJFI8x0ViDuNESk46ja6hGvoP/IPrICcsGGUBDRz014/BYxqZGQSDC+gGGJWSBuqGt2NeD6So1F9rQdU6iakVhu1cwYNqeUOEW44amorIQla1FE1UzxV83j7k=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784774583; c=relaxed/simple;
	bh=S06faMQOytOdxeyFxL/FSyK0WslLfWpgtdJD3M406NA=;
	h=Content-Type:Date:Message-Id:Subject:Cc:To:From:References:
	 In-Reply-To:MIME-Version; b=GSZiG4sJpQb5o10tthM65qjrMaO8Ig8Q0nMt5dQkTpVpWYfeUoacgVgR4D/Fh/Bxm9OXc459UsuXz0mHLqmB1yRuoVGR6v7V0c1mZbmFvXya1nL5dn/4ZckavWkEGjbqCezjfJwhVT9OmO08Dq5WtS8mO9QAczMijYjP1v4guvg=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=TN5L9sqi; arc=fail smtp.client-ip=52.101.53.4
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="TN5L9sqi"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=okjNe04FzwSJsmlJU8eYVMRxQCKjNPMhLHdYbJrjEnsRIZZgbaQNWXWmeTwPkq/xK2XE4UYWNjXpqHZEQY//oDx10XtYZEgqpunxoXaD6VQyfXA7juoRAalOq2zhWPkCKfZ0S4zfO+4s904Ayk7nAWQU/T9GRhLfdSUB5CkD9sI7CcRQI6OlLJvxm9j8AGrKQFiv9Q1EWqVONYJSjxQ4vBWDwZkHDiXlCVUTyuD+4IDYdIZjyeZ3LXWDkLJU2iT/+cSxonPkfUjPvTeQNL8DG4IJ4ywc7RaQn8v2uHjxEz91kEWbpF9xqR0+uVleq1ACqhILcwHWg6PAzln65rQXzw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=LrSNJGuuQtfY7rvM/DphjdryLbbblJmoZVn1f30CWBI=;
 b=KEZZXXQK7IKnHchsiVrbtFX2Xt7nlyysWKGnKOrkBTT0Ruo61MnSG2tYkjyFFx+hXsiDOrXY3cn1NDf1js8SmkYhUgYACaNYoxvcQgER6KOm65LYj4/PuH6fRjyPnbWkqEvOHJXoODDUwQwkWXbED62H9DLpQJcEf19nmnyxk/ZPPWPorq3e+tmRsMIBAWfsttRkPpCMu5cGw+pz1cFjtf+bSwVp33GlJLXilmJnrcIMAT+IbEADGA3zIc4eLJgSCGTqWvXDCYEDaqPy8Cv3/O4ae+GdX1BXFPA1BiwlYngXLWZpXZivzynWWmwRJbYE9fP+IoriLQDS7sfPMCpkwA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=LrSNJGuuQtfY7rvM/DphjdryLbbblJmoZVn1f30CWBI=;
 b=TN5L9sqih88HiiWnof5z/0kY4QKLeSGn+lhzrk6ZlGfg/XLJLM9lmHDggIB+BqHORRAOJ9dzuhfcHbBi1VUTt55kNI1PGEgW4CKp5xPLfUb2ZaqYP8i0WwfNd3TxYpxXB8DJei1OQN1fixzDXEChW4TJvSKgQAJSrDcDqpraqOlR6IDwKVCiPqVs0vKcrAnXjGxqvWxZXOxmxRgU5iZLudh7y1d1CHbXdYcukuRViAzTVqe23XW0RyuAH8q2KwDxfNaTHUF5Qnl6SRYBg1HNPzN4vDl7rNsKglPkrOiJzVDtT7A5om3RDvWZoFzjo6O9JhT899LJ8uvbXG9vgVARfg==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from IA0PR12MB8374.namprd12.prod.outlook.com (2603:10b6:208:40e::7)
 by SA3PR12MB8022.namprd12.prod.outlook.com (2603:10b6:806:307::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.245.10; Thu, 23 Jul
 2026 02:42:47 +0000
Received: from IA0PR12MB8374.namprd12.prod.outlook.com
 ([fe80::d85f:4c87:ae84:3f16]) by IA0PR12MB8374.namprd12.prod.outlook.com
 ([fe80::d85f:4c87:ae84:3f16%5]) with mapi id 15.21.0245.009; Thu, 23 Jul 2026
 02:42:47 +0000
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8
Date: Wed, 22 Jul 2026 22:42:45 -0400
Message-Id: <DK5LS45DW6UF.109DVMKA2G8YE@nvidia.com>
Subject: Re: [PATCH v2 14/33] mm/vma: clean up anon_vma_compatible()
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
 <20260710-b4-pre-scalable-cow-v2-14-2a5aa403d977@kernel.org>
In-Reply-To: <20260710-b4-pre-scalable-cow-v2-14-2a5aa403d977@kernel.org>
X-ClientProxiedBy: BL1PR13CA0229.namprd13.prod.outlook.com
 (2603:10b6:208:2bf::24) To IA0PR12MB8374.namprd12.prod.outlook.com
 (2603:10b6:208:40e::7)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: IA0PR12MB8374:EE_|SA3PR12MB8022:EE_
X-MS-Office365-Filtering-Correlation-Id: 263a0403-15da-44c7-e34c-08dee86414cd
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|7416014|376014|23010399003|366016|921020|22082099003|18002099003|11063799006|56012099006|4143699003|10067099003;
X-Microsoft-Antispam-Message-Info:
	c52IFaKO/V4DkeKhX0N3qQqmPMRzFzOjfcpxTonrqMOuubjzoWbmUyAcjAXML8pS6/fx0pPpPnSZApGoSWe8XR6uCmdCL3AzsSXMlHyxr5gWBllLj4umpBApibBz4a1+Gol2jsY+mM4dBsgR0GI5/5VHygUVorNbDD77WQEvvfeiTzZZck/7qsfd1rJRRbsMGZvaiZFLbA8Q7d5geMWBlFuhh9nQ+X5ukzoKYbxjBO0XaxvqTi1ZwPT/2Br+uMG9bjhCAs7+VVjQdDykR0h+Tgsk647w7bYDu2EDlXoT8gWs8E61vqOqaNDdlbAkYurZtqcWYjWrb91/Dda6GRXUD6IMxgBfVE8ZL/ZfQGQAtgOYHq8QXSX1D/xan07LRzhHgHcHE7uQQiQApAbkChcBDFzrMNgddiVU2QH7mDL9VUO+fWAeaEvHRLDmbKqSFQb9J2/LiSglgeTuHYJ1r9X2Bj3ttTeAqgyyaZtIMsMFGd+0AG2FynWqomeLZTPefzXsmO79rd4AcApywAAOLOh6FQckq26g/8M0p9wKZ45MHPvL9P7mpj49Z9dtmDrN+WHz4Dku5p34ghFzbXhqCDS7c8sxd7VC59rsHliiMZhBJYaWXO67KpDF0WbK/TjgQN0BSZ5bU+LzOfDs+E7nmWa50kGJ2qC4dcDOhJni/FVw6c8thWsCHcpmrN70pj9CvewiTfVKpPKWHZbjUEytNsMB6A==
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:IA0PR12MB8374.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(7416014)(376014)(23010399003)(366016)(921020)(22082099003)(18002099003)(11063799006)(56012099006)(4143699003)(10067099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?eEUwUUoyaUg3ai92T2ZPcUdMS0RBNFRvaFJ3Ym5CVkxsMmpYMGlNVFVjeU5P?=
 =?utf-8?B?U3RKaThUVGFGdGtaUmUrUlcrdW50OUVMUzgxNTcvd2hyVFdnWEpYc2tsYXM3?=
 =?utf-8?B?aVQ4MCtpWFFSd3QxU3BsTnhIenJwT1ZhZ2NUa0ZMa050djIyYklmWjN0VTRm?=
 =?utf-8?B?d0FMcTRQYTRhU2tGQkhaUk44VEY5eWx2VlNGdUNZa2JUVFlDMW9mZWduYlpj?=
 =?utf-8?B?b3VnaXdUWUowQ1FnVVYrcVA0R2xuTk9XTVJ4QVk2T1E5RnpLMDA4Z2RVaHlS?=
 =?utf-8?B?VUM2Z0p0M01Kc1ZqM0hONkcyd1V5dUJBaW8xbHVCMGRVNWYxeE9XRzVjKzBZ?=
 =?utf-8?B?djdDZmpzNjd4M1ZLaE9VdXBxbjlNU05ESVJtcjg3ZmQ2Tit4R0RKbExKc2pt?=
 =?utf-8?B?Z3BVRmtzQXlhL1phaGJqNXlHSUZEZUhSNjR6YkNLMWpXSk9oQjZDVWgwcG1z?=
 =?utf-8?B?UGR3WnU0M01rYUxSdHBMN0pDa2txdklCaUN3bWNTN2tabmlwdjRQVVVPV3FG?=
 =?utf-8?B?cndJMDRDOUhiY0xTQk5lTko2aU1SN2tabFBJN2FyS1JIalZXYUlZREQ3Z056?=
 =?utf-8?B?ZHMzMEJYRmtwUjBMVFVIbVdSeFlXZ2hHc21HYUhVaEpheU9qOUxBM3lMQTBy?=
 =?utf-8?B?VXQ5c0tGSDFhR3k4cVRVOWNaSDBSR1dBaWxlOGQvSjdHQWNCR2pIVVdDZ3Jx?=
 =?utf-8?B?VU1iRU02S0R5Vks5VFc1OGRRMUY2Z1A0YVhWU1AwTExBZ29ER2oxaG0vTjVm?=
 =?utf-8?B?dEkwZjQ5Ris5SWFFRnZSV3NWYUFwd1BiWTNER0EvTS93dm4wK1dYTHphU05D?=
 =?utf-8?B?U0s4VFN6YWlqcms5c21ISU1yeGtta2ZGMTFqLytQOWJFMmhtVlpST0E3ZUJL?=
 =?utf-8?B?T2d4QURaVFdTaGhHT2tYb1hZankwa0F4VXJzQzdIMXpmeUU1dzg3aE45QVo0?=
 =?utf-8?B?S0lKVlRWa1QxN3pvYjZQV1JvQ0ZLa2U4TXBMTUluL3NmWGlEWkFJd2l2RDBl?=
 =?utf-8?B?dTZiQk44NHh4YzZSbTBLU3BLaEQyVi82cHJZNnJoRnZTWTVMZEdqODh2cDYr?=
 =?utf-8?B?V0NXbVFxUFcrbk5KZVMrbHJIS3VyRDBOMzBsT1o0WTFhbVBvSUtkSS9zRksy?=
 =?utf-8?B?UGFPWnJKYTh4RjRiVm9YWSthN29qZHhIcjFaV01rNm5uS2VSa2ZwRVJCcGJE?=
 =?utf-8?B?RXIwMndMYWtXWDVUVzllWElmRGt2OFJRQ3lzdzcwV29uWS9jbnVBL0VVY1hF?=
 =?utf-8?B?K0ozSXp0TGFKUTJyNzJOWm9TYkVBMjdBVkk0bVNDb2ZYUU9QQUhwSzlVclB5?=
 =?utf-8?B?ZVNYVUJsWFJvYUhPQVRIVFlnbjgzWjh2d0ZKSWR6UFAydDZleFUwT0UvaXFG?=
 =?utf-8?B?bkdoVndabHNiU0FTd1pIdFlYaDExSG9VeWxkZzBqeUtMNE9jeXlTV0lneUdX?=
 =?utf-8?B?ME1idzZBb0pORUNrdVNCWUpaNDQxajNVU1d2Qi9pbmVYN3oyL3lrUkZ5NmdC?=
 =?utf-8?B?Z0ZrUk5lRUJZd3l3aHBDL21HdXM1MWI1eHlXOWdyNW04aEQybWUwa2NKT05i?=
 =?utf-8?B?UkMzZE9lWDlpc2xtZ2ROQVhPUld3YmlDZko5dEJyblBJM2RSbDRCazlnYWJO?=
 =?utf-8?B?bS9HdElqMWRnT1p3ZXBZNGgzL04wSlYxSVNHNGx4U0ZxSXRlcUJTY0dzdnJk?=
 =?utf-8?B?VmRRM0VvUzBpaVJOZmd1TjU3VXcrSWo4RlpjRVJPMEJJTk1qQ0dBSVFUOHhL?=
 =?utf-8?B?c3pPUzJpWlJZTXpxbFhpTUh4cVl2eTZVVWdNRjBuYzBTR0JwQ0NjVXdsWGc0?=
 =?utf-8?B?c3d1S0syTTNDazBpS0dWRzZOR2JSNWlBMks0VkpERUJBUXlObGMzUmlQVHBl?=
 =?utf-8?B?eEc3cldVMWwvZzl6REltcG0rbGhicmhiR3lzazkwZ0JpSmR2Wlo4QnN2MWZm?=
 =?utf-8?B?Nkl0Q2xTdlNzYVQ2UEtOUDRZcUZUcTBhWW9aeVE5SyszTG9BMUZubVhwY1lQ?=
 =?utf-8?B?Qk55VUJIRjR3cjFkenZaT0pUNGE1dVpTYTZubzExZXRPa2p0VXQvaXNvU1FK?=
 =?utf-8?B?ZXFkZDF0ZERoWUxVRXAvekoyejFnTlIxQUN3WFZOL0NzOU9WcGs3SHdtd0k5?=
 =?utf-8?B?ZDRhaTlVdEJXOURtdWRiVnhtckhlbTBWZ3dwUktWR0tuYkpVc3hQR1N4SFRW?=
 =?utf-8?B?b2NLRUxxUkVSVkd5SEpodXRRaWVRdEdmY3dia1p2aXA3OHpjR3FiRGxnd1Bw?=
 =?utf-8?B?amF6UEFwZXJZMGpYSnRGWHd1RTZLbVY5UmY5QVhtNk8zRlZYT2dGb1gzcXdy?=
 =?utf-8?Q?e6Fb1PLeKmj8zp0Jw4?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 263a0403-15da-44c7-e34c-08dee86414cd
X-MS-Exchange-CrossTenant-AuthSource: IA0PR12MB8374.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Jul 2026 02:42:47.7950
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: rOlCtWU8S5A2dxIjS9/Te5UcdluJM/L7mLCbEO3LtnCdHilWGOSHfIOSnZq4WWP3
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA3PR12MB8022

On Fri Jul 10, 2026 at 4:16 PM EDT, Lorenzo Stoakes wrote:
> Break up the existing very large conditional, add comments and use
> vma_[start/end]_pgoff() to make clearer what we're doing here.
>
> No functional change intended.
>
> Reviewed-by: Gregory Price <gourry@gourry.net>
> Reviewed-by: Pedro Falcato <pfalcato@suse.de>
> Signed-off-by: Lorenzo Stoakes <ljs@kernel.org>
> ---
>  mm/vma.c | 21 ++++++++++++++++-----
>  1 file changed, 16 insertions(+), 5 deletions(-)
>
LGTM.

Reviewed-by: Zi Yan <ziy@nvidia.com>


--=20
Best Regards,
Yan, Zi

