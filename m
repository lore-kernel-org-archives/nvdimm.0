Received: from DM5PR21CU001.outbound.protection.outlook.com (mail-centralusazon11011037.outbound.protection.outlook.com [52.101.62.37])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BC7471DF74F;
	Sat, 18 Jul 2026 02:58:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.62.37
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784343497; cv=fail; b=LbrPSohV/1klJQ76j5lf8xZxq2xMPfEGps1+m5QwLZoblsF7tXoVK/a1TezM/sffOgxJLrI8SMCdh4c6967qtmuzCzWl5DPa/RCcZfnizu1cXoqgxojWRqjZrF4Gym3knFkZhsc8Sn55DFCTv2QKplI/TgRqCbmSjPh2588DOa0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784343497; c=relaxed/simple;
	bh=Vmq/4wHW8Ib3Q5NT0dpDh7QPgcZ5ymUs+6dLAGg0fa8=;
	h=Content-Type:Date:Message-Id:Subject:Cc:To:From:References:
	 In-Reply-To:MIME-Version; b=XWkMx2sCRBWjsf3t8A8xwmJTmOV0brDuhflFbd/0yFTF7wikDIJEqN8nMG04tI2HMNreLkVBH62yFLJAi70+YdehcMZNkmAOEYuqbMAZ3LWcWzQpGkawYELpxufcPTjC6WbHoYdKpizAisKea+R/dzB06pavge0aNZ+z4Q0z7TI=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=cAqi7ZOf; arc=fail smtp.client-ip=52.101.62.37
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="cAqi7ZOf"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=zI1/l9no+9UJj5UEql5KJ9GY7dwMCk4Ulq9ndq47Fp4sfZ2iVj/Et/8bcAhIiUbdDS01xrf0RDw8mr1Owp+pgaN7C80Df+ekdL2EJBnmgs7fXza15PJ9DIH37cuuBt+5mbNah7N4035VrAEAj+IQcXsEjllRIigm5A9fYo2x99eSo019WPzFXzNGVQnrYLTvom2x40lLM8aXHyryzVow65M2END3FFo36t+gYzr4t5OFzH5Q7x4HsEpu3fZEStXXj09ZTLvh+Qo4D6jelxI26AUNMOrQ+A/WkHrkzBUb/JFDHkSavnBpW4o75wq9ZF6en8RvY3DEPaHVRZHBoOCwuw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=pbv0cJvkOEKjICRi4SQ7TnNuet1IcesU8v7qsaMMuvU=;
 b=ak+h5BvpJ1FbfxrDk+4T2FAHBcbTDQNKE3NDUzX8FL9hL/stLXtdDXK3Q+JOLIO6zet78R5Q9FxIvq5/aX0Vm2HaksXBKRj400s3DQkXnni95+7ACxSsY44TqBawKDAMdMzcLmmYn4o9HJnvL92cEPCATQU9i28RS4SFvyJjdqMkrryte4wyka2HkEr13UFR9wPaL1zFHn1iM0noQBrkHLwSOkMfekZa24O+/+43Yapyfp3VEPno+ioQdFv+GHIreX16NWaw4eHLbq8wY3xRX+rQOQKSqK1Ouz6fWMJl/g0Ve5C0OFCWSaK6US9jKyNamxfX/mrFSdtPrc13tnECWA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=pbv0cJvkOEKjICRi4SQ7TnNuet1IcesU8v7qsaMMuvU=;
 b=cAqi7ZOfj6C49EVhtOUnpsa0hqN2LMmvV1vAFgBcXvczHVSgD5GkQikP67yS+QNVpCSTBzIJVANU/QDvvFcXWYvOnkT7kZAF+1YCW+IyAEpTelz2bxSkJaLLGv78tLlB3lti2SAybg8Y8/LtUSLLpf4KsiqgWfV7CnPOfS0XcocaAtJhGBCiuLjWfmQJRTP4SvUfDFv6TWqd6xocZ1NuOh4UekOPBzU/5fF4aBMinM1faQ5AZO0lW3qtfZBm7xEfG9Pv19hZ52mZ5RO4ZDXlTOFf5v8fzvhN5X1jq3gIeyvXMRTncCDpWHbXtFkVgh3cGFoqwUd69P7y8D5h78qarQ==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from IA0PR12MB8374.namprd12.prod.outlook.com (2603:10b6:208:40e::7)
 by SN7PR12MB6885.namprd12.prod.outlook.com (2603:10b6:806:263::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.223.10; Sat, 18 Jul
 2026 02:58:05 +0000
Received: from IA0PR12MB8374.namprd12.prod.outlook.com
 ([fe80::d85f:4c87:ae84:3f16]) by IA0PR12MB8374.namprd12.prod.outlook.com
 ([fe80::d85f:4c87:ae84:3f16%5]) with mapi id 15.21.0223.012; Sat, 18 Jul 2026
 02:58:05 +0000
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8
Date: Fri, 17 Jul 2026 22:57:58 -0400
Message-Id: <DK1CZ1UWKE81.OPZGIN3NM1GF@nvidia.com>
Subject: Re: [PATCH v2 10/33] mm/rmap: rename anon_vma_interval_tree_*()
 params and use pgoff_t
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
 <20260710-b4-pre-scalable-cow-v2-10-2a5aa403d977@kernel.org>
In-Reply-To: <20260710-b4-pre-scalable-cow-v2-10-2a5aa403d977@kernel.org>
X-ClientProxiedBy: YQBPR0101CA0197.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:c01:67::34) To IA0PR12MB8374.namprd12.prod.outlook.com
 (2603:10b6:208:40e::7)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: IA0PR12MB8374:EE_|SN7PR12MB6885:EE_
X-MS-Office365-Filtering-Correlation-Id: 477853e2-520c-44a5-c08b-08dee4786356
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|23010399003|376014|7416014|1800799024|366016|3023799007|11063799006|4143699003|18002099003|22082099003|56012099006|6133799003|10067099003|921020;
X-Microsoft-Antispam-Message-Info:
	qqVmLXDeIWIJ5sYnYoiThDXLdsD0lYf4CgBA/gU1SFcR6TGNBAlecXc/jPRSBvFSmz8/rCvaSwk9sOUG5KMhOCPDVlKIm6lE4g9St8rW6XRnG/7jUcigg41UdXypPgHym1EYNtK+QIfxaEtF0SOoXZN7A4Z4BQFhKCyxcVhppnvDpBztX9buHiAmeWdzZZsie3GkSZv7l0xubHmEFfO5bjc9FQETl+PVgy7lCObw4uhCB5ZXWeRPNQJAlGbXzlg72Fk0ENYHYVRCv8UiISkuVLjplfWOFGguXhPb8U4M1Kd5R2lCTZnvmcwI49oLN+QadxI4rsXausFBSNVvTKWCnPeOrVaQwvQ6bc+uDGLRlmGKneIfJpQ4XWXtIIieX9vIwj3P4R2eqI3zuynJ/ppZWBtjIsmbeZ2FjID1srPJEpggJSPVoHLmTBXH7/VeARgpWb9Cmr7tP/gaSJzpGBtlyEjI9S/1COmhtvzj8OS+3KlUnMQBWFfusBKUIVAxqNP7BqZ/fgqt0Yn8Tc2q7opsJERqr24FNB38Hu6Tp1aij+46lallrDnOvK4bQ+bMWy/SIEbsPu05pAlUSfxJnEy9wAFwngmgJrHA9m6/0e1TATog0jVpvnjgLqkZxwaLlGr5XYUq4Q65Syw5Mf/AX9F8a1kSV0NHuNS9ZQ4vxQkUgiTLaT5oGlRxJTciQ3BhsbgsUoY0kSB+tgu+NwhU3aplRA==
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:IA0PR12MB8374.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(23010399003)(376014)(7416014)(1800799024)(366016)(3023799007)(11063799006)(4143699003)(18002099003)(22082099003)(56012099006)(6133799003)(10067099003)(921020);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?QlZzNTZpRFFxb1YwbktLTVNzbDJjUUtpa0gybEZncWR3WTAzMUx5UjZSbmpj?=
 =?utf-8?B?ZWRuU1RYVEp0WUljWUZobDUyZVFFRFM5T0JwUmRNb096Z29PbnJFWDlkMXox?=
 =?utf-8?B?TXdRK3VVdWJ2cGJuVnlKeGlCTHJiS1RMUWgreXdGUG9OelJsSUM3cVI3amVp?=
 =?utf-8?B?R0VEaDc3blVkQVkyM2w5UVFIWFU3SHFqV285T1pBVFcrK24zZjAxQjBPQ21y?=
 =?utf-8?B?ZGV6VGhQRDRnNEhxbndEVFhwdXZSb0pWOTY0SzNUeWkyZFk1TlFKMDZmWHVy?=
 =?utf-8?B?R3BNZ1VJaC9hdEhleXJCQm1nT3VUT2pZM09vcFBzNG5GdWg5MUhyazZEUVdC?=
 =?utf-8?B?SUE2djl3ZDEwYVY3VXRGZzlHUmQreXRPdlFQM2hxM3pXUVFzYXZBL0NOa1px?=
 =?utf-8?B?ejNncWk3Z3ZtUXVHem5ZWHBsWlc5azh2aVp2bnRMbVVpSytjMTk5eFdMUEtO?=
 =?utf-8?B?UkxIVHdxTE1zTG1wL250d3lYbER1MzBZdURJdDVNdFBRLytPdVJrSFdwMW53?=
 =?utf-8?B?QlVoa3dlTGFWcXowR2syQ0xHdXl5VDdtamVvZXZMMTlPcjRZOWFnRjdaN05u?=
 =?utf-8?B?Q2VtL3h3cHZEdWpGUEdXM2N5MGgyOWdmODd3THlGOHBjTmk1bUtjSzRHbzNv?=
 =?utf-8?B?NjBzRjlSQmpUakVTcVJqbDZsV3dVd2c3cE1jejZOR3FtZjRzeTRjSDFkcUIw?=
 =?utf-8?B?SGpMQ1BCMEpPNndtaERWVFZJM2xaNytmRFZtYWF1NjRzb1hFTFU2cjJucmQy?=
 =?utf-8?B?bWVjbGJuQkI1M0g4aTRNQW9SbjZSem0yMytCZ2w4WFFPZXp5eVFEQ01mRmox?=
 =?utf-8?B?a3N2RlBURmdJdFFlMDd5enJqSWUzZllFc0ZlUVIwYzNTdk9tZ2N3N3lBOHhl?=
 =?utf-8?B?c0JKZkNmcmRBeE9JQTVYbGp5LzBOU3A0ekZSSW9KV1R0QmVPbGM3S0haK3dT?=
 =?utf-8?B?OXhhcy9NV2tpNW9Cblh3WlArN2xISGtyOVpzQzBCcXpQblpndkpNWFhyT1hk?=
 =?utf-8?B?WHByc3Uvend3K1pSeWJhYTZxWFZJdEMxR2psQTJONG1KVHVBdXRXbHgvMEov?=
 =?utf-8?B?VTJRRjUrbXdyWmdrUXRRRDAvTVhveFRNOWlqYzVxZ0d6ai85T0hoNWRhUmVp?=
 =?utf-8?B?ampPbCtzTjdnWVFycVd0SGlzandndGNhc2NFZzlGWEdUdlN5MUF2MnJtSmNO?=
 =?utf-8?B?U2xtNkxIa3ZULzdTWnc4STNZais2eTZUUk42R2lYYTFpd1RtMzBZVkp1dGla?=
 =?utf-8?B?YUF4ZCs0UGdnOGRGdG14TEVIZDJuRkpEN0YwN01HazNGcUVjT2hUVGpzRmF1?=
 =?utf-8?B?bkNEZE9RR3ZtdTBGbk1mcnhYUHVmSmJDcktrSUdvc1ZrV0NXYjQzV1Bpbkwz?=
 =?utf-8?B?bzIxTFdUbmFEb29SZ3VBZ1BIeGJLdHhCOTBkT3VKVC9vdnpLc0tURHZ5QWYy?=
 =?utf-8?B?WEIvUEI1VlExVWMzTlVpaHNSOVFKSVYySG02ZzRwTXdjTDczQjVpKzl5S2dE?=
 =?utf-8?B?TzRnd2xSRjlTWmFlb0RKUWJ4Y1Q1ZW9xWXZtZjRaclhwMndWUlhSQWpiZG14?=
 =?utf-8?B?MVAyTTBMcGE1WXM5ZEY3WWxrWVl2RjJ5OWlIOTdHb3JmeWRFaCtmeUlFb1Jx?=
 =?utf-8?B?RjNNMjNnQWEzcVM0MWVGZDZpUWtFays5eUdsMjlmbE1QMS9kRFliTkxTeUY2?=
 =?utf-8?B?YmxoUFhsSDFBZTFHWUFXNTdKYXRLNThuQ2VCUHNpUENjenFmRXB1a0w3S2RF?=
 =?utf-8?B?djRYOGdrU1dYV0pZeVZ4UndUSTh2VHBvbjN0aGd1SlVTUXNiYVY4N2pFQ3Fi?=
 =?utf-8?B?ZURMVEtyc2dsT1VHWnpQNkpaeGY4SGttT0MyTjcvRzhUc3hLam4zeGN1a3dv?=
 =?utf-8?B?emorMXc3VGs3bFhyTU1RaDFkZWVMVEUzc1A2WnNpV2wrZDJEbGRFanNvLzhJ?=
 =?utf-8?B?TDNrZDVDNmZTYXRDcFo2OXZwdkxwRis4alNYSXdYYzdacm1sVlY4dlQ4NDAr?=
 =?utf-8?B?Q0QwRVliYllUbGp4YWxNT2puRFl2ZVFFNDZ0eTNZSFR4dHJVMVlZQVRhUG52?=
 =?utf-8?B?Y01ZQkNRWGk1MS92Qy9hZGdRejlWQTZNNmJ0NkpBbDNaU29ZWHNjczkwWkdR?=
 =?utf-8?B?U04vODR2TFNOMzQzMXZhQlRKWlVFOG1weGdEcFJPYVkxdXNWUkVxU2dWb0VQ?=
 =?utf-8?B?aG0zQ3VGZ3JXY0xWR3lOVmxJYnlLeThVaUpIL0xDdGZzbnpWa3BJSHVnOXNJ?=
 =?utf-8?B?Mk5JU1h5WWhhV25hM3I1dW45bFYzTFdIRXNpeS9ocUZnREF4NndTNStCb0ky?=
 =?utf-8?Q?wT4/w+JNZQdAJmNQHl?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 477853e2-520c-44a5-c08b-08dee4786356
X-MS-Exchange-CrossTenant-AuthSource: IA0PR12MB8374.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Jul 2026 02:58:04.9041
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 3BYNZCT6tL10JC4+CXy9hqpGS8AXcC4+sIUFrZGBbI/y8bs5RWJf4SlrdPk1LTYf
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR12MB6885

On Fri Jul 10, 2026 at 4:16 PM EDT, Lorenzo Stoakes wrote:
> Rename parameters used by anon_vma_interval_tree_*() functions: 'node' to
> 'avc', 'start/first' to 'pgoff_start', and 'last' to 'pgoff_last' to make
> clear what is being passed.
>
> Also, express page offsets in terms of pgoff_t to be consistent.
>
> No functional change intended.
>
> Signed-off-by: Lorenzo Stoakes <ljs@kernel.org>
> ---
>  include/linux/mm.h | 19 +++++++++++--------
>  mm/interval_tree.c | 34 +++++++++++++++++-----------------
>  2 files changed, 28 insertions(+), 25 deletions(-)
>

LGTM.

Reviewed-by: Zi Yan <ziy@nvidia.com>


--=20
Best Regards,
Yan, Zi

