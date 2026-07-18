Received: from BN1PR04CU002.outbound.protection.outlook.com (mail-eastus2azon11010004.outbound.protection.outlook.com [52.101.56.4])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8CA4E282F02;
	Sat, 18 Jul 2026 02:46:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.56.4
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784342786; cv=fail; b=Zbyz5X1Gg7irqCfetG7eQD/BDbZy4K8evIOJZYAxDYhKOkVV6vDN5Vq5NiDN2gOzksFy87vvpLQlNYv6qjwNa3gt3dY0TxOxoiMjW8qY64ZK8I84x3MFT3n3ECwR5gBzBngZIhQCob2oHx61tXeJS4oJxEPHrBVOVn3xDTOXbro=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784342786; c=relaxed/simple;
	bh=b9C378Aj041U9GABxn0XKcB5WN271gzZP/FF+JOdnUE=;
	h=Content-Type:Date:Message-Id:Subject:Cc:To:From:References:
	 In-Reply-To:MIME-Version; b=ShI8isMfyy5DaYyqPZJ59vPy/5weGc+jmdpqmTI4/7sqfahnXC+hBrkvdNxaVqtq3oCyq1qVSp09mACJaWpHZ6KC/GbcwkjiOMTXYtyiPRvndP8u4lA/JSWuQKMk1EtJ3xyzQ6O7SDT5IGoE6hjjWfgA74WJC8/EaSd9LrMegi8=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=gA9NP4HB; arc=fail smtp.client-ip=52.101.56.4
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="gA9NP4HB"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=yrDEmwfiu16q73Zf+8XjcPjnwpufC9DZ7HaBqkBrs0adSNG8L1oX9GpkXRDh1hgmy42Ny0wyGtGNQ0TqQ6yCrHrjA/dMC3Q2WOrQcuSzH7Z5IPCzQOngYxEhCX8dpTbp2UaWmCw8+kfpC1apkQnlJS2mbzoGww5l2HgcNzTEubs0pjH8Fp59+W0e/r5nbLX6vpqzYZNSQ2hnL5wBn9WhC/0RQoD41/JByJojUPK4naHgw7zxMVzQfTvI3r0/c+4kFInaBin+/MJauWu8X6fji8IGffnhR83pKYwJDwR/IlaUTf845wlzz2XIlC+jM2dO30FuA7ifhFMumr+0s0q3Dw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=rN4Th1+pO0v51ps14kZ9sxg7w38DmItOS/VU4cdy1bk=;
 b=Hma3oY0+X975HqWjbijsJMt5F5iCOf3optKCJnQooGECJzpGZlxKY/gNGSMDOL0FQgJBhMl8VFT0cpniKkrwZYF3CKWiRNbwoAVxFneCpVfww21xgn58xxktMqf6aIXoqdX4m25PfBszsoLQAEvdt7QVMTnepEi947zu491buhS2/ocCt+btQfpTHy7sIllIOo4d1S0hGyTdffv7EixrjEl5g8LdcTFmCCVDbRlcMHJZ/A5107EcaSBDs3F6l0rMyTVd+0IJ0swPb06O/Rh3h6Unkhki12iZyhTFmKzCxGLw37naW5+69Rm7eGDmX0uSR1gk42Hgm7XQPzwob4CpBw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=rN4Th1+pO0v51ps14kZ9sxg7w38DmItOS/VU4cdy1bk=;
 b=gA9NP4HBi/7cCob/1T+3JyH0hrCGK6G/EiR03qj1seQcgfGG5/VWWmBM2/+rk11nZiXFvmnbYQFSXIzfdvU5WmI4fo5wwP9anG8sAWK7WJHDCp+S3k+5pG4H91DRzc5FLwT3iOhXDNA7LPONjwy52mbMSHnEpFA8cWi4YSqtNJT3iYxB+62xTw0dg8FOstErSc/2kC2afifrYLZKmpUgpEv3dhK0MWK1gX8+0rcM6O2yWjdg3//+HrDeMEotf5X67lm7aGGn2gcWlLLGwVpaM+R0XdhVLmJe8kIAw7VL12YFnIae3vu7XpVX9wVQTJUCxNNEB0V1ZtzJTR/oJVZEPw==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from IA0PR12MB8374.namprd12.prod.outlook.com (2603:10b6:208:40e::7)
 by CH3PR12MB7571.namprd12.prod.outlook.com (2603:10b6:610:147::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.223.12; Sat, 18 Jul
 2026 02:46:04 +0000
Received: from IA0PR12MB8374.namprd12.prod.outlook.com
 ([fe80::d85f:4c87:ae84:3f16]) by IA0PR12MB8374.namprd12.prod.outlook.com
 ([fe80::d85f:4c87:ae84:3f16%5]) with mapi id 15.21.0223.012; Sat, 18 Jul 2026
 02:46:04 +0000
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8
Date: Fri, 17 Jul 2026 22:46:01 -0400
Message-Id: <DK1CPW8JK0UC.194RLAY6RVQDY@nvidia.com>
Subject: Re: [PATCH v2 06/33] mm/rmap: parameterise vma_interval_tree_*() by
 address_space
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
 <20260710-b4-pre-scalable-cow-v2-6-2a5aa403d977@kernel.org>
In-Reply-To: <20260710-b4-pre-scalable-cow-v2-6-2a5aa403d977@kernel.org>
X-ClientProxiedBy: MN2PR18CA0006.namprd18.prod.outlook.com
 (2603:10b6:208:23c::11) To IA0PR12MB8374.namprd12.prod.outlook.com
 (2603:10b6:208:40e::7)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: IA0PR12MB8374:EE_|CH3PR12MB7571:EE_
X-MS-Office365-Filtering-Correlation-Id: 95fef3f7-19db-4254-e308-08dee476b5f4
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|7416014|376014|23010399003|1800799024|921020|6133799003|56012099006|11063799006|4143699003|10067099003|3023799007|18002099003|22082099003;
X-Microsoft-Antispam-Message-Info:
	+qRVs8T4Aa/LXc28alBD0asz1HphROAbEEmlCHRMjOVyDDYaopM9evK5S/Z1c4QC1O6oWBnL3EN0Ebj0QnszS88v9IkK8YW7r3Y64kQwI+ywpSYM00O2h68iSxs8p3EM1RxCrOSi68LC6f9suGxN9F8RWK5axeP2eJaHZ+IARnrNVSG/yB6QtFb9NjqmO4KcL6ISoq9g3YKCUnOCeGkA74OLTh0xeLdewUee0QpuSr+JfEhUjjNwNLZNSIHcHDcgdERuiB+BeAdVQ1t08S49wRH8Y3fTH+U6Vc+Z3WoKfgDqr+ilsQ1acepgWNzuRgKnb+91BuHl6/5RMlMjrs1YtAkANv4+dlpaAYgZXuuHnBWE6gKCArpmKh/LGupHxrFLGuSPNoyq0y9yhGt7cE51mTAlLodVL4tR8NNFLwpNBgocXFvatbQcgi6K3zETDXo0N1yI2dZp404zDpXwrx9iLZXFHU5z6r8l80A8ZiuIwvjBZvfCMO9P+57JtBxV3pk0ZFC71U/4F5vDfRFTKwBHnsXRbfhESqLmBClESre4ia+GU1GI5yIrDjNKVsr0jd2rqbrt50WO+dhJYbtpZWf6KSwv8UlnEDgbxKTZgX/kJY6R8t+ZiGK40w+cLUkods+rbjZ2rQVjhoOJH+v67jxtapdcdlm3yHzdV5gGxNj59j31bSe0LuHApRMeHqpxHQzOY77wDeLUFrINzdZGHsfEXw==
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:IA0PR12MB8374.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(7416014)(376014)(23010399003)(1800799024)(921020)(6133799003)(56012099006)(11063799006)(4143699003)(10067099003)(3023799007)(18002099003)(22082099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?YzBRNFJqWXh3Vk9ZeXBaTWw5SGMxWHJPZGkxc1ZpVUo1bEF0Vjh5SDRmcDg4?=
 =?utf-8?B?dWtUcWlteGlhTFM4cWoxOGJneWF1MjRmODB5a1MwMUc4NzBSWEo2UmZ4ZXdz?=
 =?utf-8?B?dUp6ZVlCWE1TaUN0ZWJNUnpNNHgxbzZLaitJMlp3SnRFa0dOV0JyNDJMK3hX?=
 =?utf-8?B?cjFqd2h0Y3JCMDRnZUZjVmo1Nk5aVlU5N3gvME1sRzdGdU5NNEZIR3AyZVNx?=
 =?utf-8?B?emJCUnorcm1WOVBHU1FDU0xNUkdDQVZnMWFLR0dqOGxpSDZJNFA5UEJhcUIw?=
 =?utf-8?B?ZWF1WjZGUW9YTXRUNEovVm5vU2hVT21VdzNBUkVabEdKRGZTQ3NVODRxVjVz?=
 =?utf-8?B?MVB0SVBHbWEvalErdUE0QmxnTzBIN0puWVc1VWdqUDgrUEQ0N1BtODJFSWNW?=
 =?utf-8?B?VFVTUElHT2tkS0NabWs2OTZMWXNGdER0S1RXejIxZTFmdXpqVTd0OGVmN1RP?=
 =?utf-8?B?L05TVFZkdzBGYXNoeGMraVhUZ2F6MVluZERiZVA0ZEpUK0JSUGtaRlBhV29G?=
 =?utf-8?B?RlN4V1k3VUlLSnpwR1NSZXZHQ3pkYk5FZE9nWG9YUTdLY2RCVWd4NzZvdGRQ?=
 =?utf-8?B?RW9nR1JqYWZVeEN6Z2t4TEtZamJXcCtnZUNtZ1JuOVVXV0xtSCsrUEZUZWRF?=
 =?utf-8?B?dU11K3BORmsyVGk2QmhWdWttdkZzWVJSZjhsd2FIUHhIL0hxNVlGOExJL1FW?=
 =?utf-8?B?Y05uRXRuTlBPWEg0TXgvTVBmUHp5dFc4eWhMWFBJdWlwS3kxOWl5dzU4aDdX?=
 =?utf-8?B?WWpBRDdKb0YvdDFFUVZsMmJFM2xMYW1BejFjaHZ1LzBEdm5wbHNXQWJPSlh6?=
 =?utf-8?B?OGkyNFNVSnZmdWM3MFhoQU51RlZYWHhtUk5JQUtIMFV6T3haUFJqSFh2S0w5?=
 =?utf-8?B?dFdSSi9kSW5obkNuK24zZjFCWEhOMXFmMXh4MndVUHdmYVRkT05xUDR4T3I2?=
 =?utf-8?B?N2xMdUZvNzNRVXpIdDhiMXRPeUdacWx1Tno3YWdOVnJzVjd3QWk3ZXNROWpu?=
 =?utf-8?B?NWg3amx1b0owWWpHTGYxN25WVXVXM1p3Nnlob3JwbWpwemZyQ3d1dUdFd1hW?=
 =?utf-8?B?MkN6bUJHdlgwb0tXT1BiVno5Y1ZBZHEreVJIYkpUeUZMVkZyaUp6M3hQeFVy?=
 =?utf-8?B?Ti9VVWptcXRkbHoza1U5ekxLK1FXK0ptWXFWbXBENmhmSDJQM09WSjJvM2p5?=
 =?utf-8?B?K1ZYdi83M0ludkZWZFZxRGFLQnpEeE1FVDVtR201VW1lcGU0VWtZWDdjUzM2?=
 =?utf-8?B?bWgxRzFTblJPOFF5eUo5UUF6aEtraGdFQTVaUmRuZEcrbTcvTmRuazBPNDBF?=
 =?utf-8?B?bTFoNkQzWWl2dlVkV3hBRjIyWUNtemhxb0wvQ3JjYkJRNzZhdVBOSmRvRTFI?=
 =?utf-8?B?WkdGUFpBR0FucTk3ZGl5TTNuZ2RKQkFSN2lDbTdpQnd2cnR3TnJFMG8wL2Zn?=
 =?utf-8?B?amt6eWIwQTRkd0IwejBJSWxIelo5Z2J6SDBMZE5vdUtmcGZUL1U0ald6MEJG?=
 =?utf-8?B?TGZrVWI1eHRXNGljbjdXV04rKzNnZmNiMDdlOXJLYWFwazBGbGNRL0NCenFW?=
 =?utf-8?B?TzZsNFM4a1QveHNjcnpjZGxmQzRUbDAxWFRLRWxYamU1emZUUFlocGtxcXVS?=
 =?utf-8?B?QmRXdjNaajl2VG9pUG5saGFHaTgva21WL1l5TnN6eW14T0VSd2UxZE1UUHVp?=
 =?utf-8?B?QUxSWXU0ODNQc3ROelhQeWc3Vmh6UXg3ZlBOc2YwRVorbXcyN1J2WDZTV21N?=
 =?utf-8?B?THFaYmJwV1BHVy8zazMzOUtza1VrOEs5UzZKR1JXUG5VUVJSQVJxczRxQUVv?=
 =?utf-8?B?VlBnY1Fkc0Q0Zmp4OW1JS2xjNFg2S3VoNEduU0RRWXlJSmtrRlJzSVVpUnpF?=
 =?utf-8?B?WmJnYkc0SkdsL09SdHpUNGp1aG50N0JXQW80dUdCbGZqZFJkd1RFV3ZPWkFR?=
 =?utf-8?B?QitZd052ZTlkQ241WlNGbVZQMjluMUtHU21ELzB1Z2JjVjdyWmtBWmVZbXFQ?=
 =?utf-8?B?eVlmOEFiOVpyS1NVUjZnRXFodUt6ZmZSQ2UyNHpCcVpVUTVXcktMbHc0bStB?=
 =?utf-8?B?V1pZNE94SHJlNDhZYnpuT2pYOFFETFhwbTN0c3NwL2NRUFR4eklFNkRKRGtU?=
 =?utf-8?B?Z1hObTdnTGU2U3FxOXZ5VUh2SlVHcWJ0U0RKaHk4T2NhWVhkWWU5cFNLbXEr?=
 =?utf-8?B?Z2REUWIxa2VDdlBaQTErUEU4SUdDVFN6MmlNcE5OTy9sVHd2Y1duSytXWnor?=
 =?utf-8?B?NjBSdkxzek9EWjFEV0tPYlVheXd5ZDV3cWQvUThCNEF1TDlJTXZVQWpmR0ha?=
 =?utf-8?Q?D/zh73ZbZxNV92Tz2m?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 95fef3f7-19db-4254-e308-08dee476b5f4
X-MS-Exchange-CrossTenant-AuthSource: IA0PR12MB8374.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Jul 2026 02:46:04.4489
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: qc3N0KyxBUzQYzv8scuRxpPyDfDRlRgc5/mqyDxfPPPFqvQ93HsTJormcP8HPxrR
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH3PR12MB7571

On Fri Jul 10, 2026 at 4:16 PM EDT, Lorenzo Stoakes wrote:
> The file-backed mapping interval tree functions vma_interval_tree_*()
> accept a raw rb_root_cached pointer to determine the tree in which they a=
re
> operating.
>
> However, in each case, this is always associated with an address_space da=
ta
> type.
>
> So simply pass a pointer to that instead to simplify the code, and more
> clearly differentiate between these operations and those concerning
> anonymous mappings.
>
> While we're here, make the generated interval tree functions static as th=
ey
> do not need to be used externally (any previously existing external users
> have now been removed).
>
> We also rename VMA parameters from 'node' to 'vma' as calling this a node
> is simply confusing, update the input index types to pgoff_t since they
> reference page offsets and rename the parameters to pgoff_start and
> pgoff_last.
>
> No functional change intended.
>
> Reviewed-by: Pedro Falcato <pfalcato@suse.de>
> Reviewed-by: Gregory Price <gourry@gourry.net>
> Signed-off-by: Lorenzo Stoakes <ljs@kernel.org>
> ---
>  arch/arm/mm/fault-armv.c          |  2 +-
>  arch/arm/mm/flush.c               |  2 +-
>  arch/nios2/mm/cacheflush.c        |  2 +-
>  arch/parisc/kernel/cache.c        |  2 +-
>  fs/dax.c                          |  2 +-
>  fs/hugetlbfs/inode.c              | 15 +++++-----
>  include/linux/mm.h                | 34 ++++++++++++-----------
>  kernel/events/uprobes.c           |  2 +-
>  mm/hugetlb.c                      |  4 +--
>  mm/interval_tree.c                | 58 +++++++++++++++++++++++++++++----=
------
>  mm/khugepaged.c                   |  4 +--
>  mm/memory-failure.c               |  7 ++---
>  mm/memory.c                       |  8 +++---
>  mm/mmap.c                         |  3 +-
>  mm/nommu.c                        |  8 +++---
>  mm/pagewalk.c                     |  2 +-
>  mm/rmap.c                         |  3 +-
>  mm/vma.c                          | 14 ++++------
>  tools/testing/vma/include/stubs.h |  4 +--
>  19 files changed, 100 insertions(+), 76 deletions(-)
>

Thanks for the cleanup.

Reviewed-by: Zi Yan <ziy@nvidia.com>

--=20
Best Regards,
Yan, Zi

