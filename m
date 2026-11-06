Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=52.101.52.61
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1794001417;
	b=mNEBBePmIlkxBInu7XsvDDRqGK2Qpyj/ngbZIN5dQ/Bz1HbYysp8ntmXxjdYlihKgVE2
	 SKtdYcKDW2sEIfEa8JMeNZQ7gAgdiw7Ql9RwQYS8EOHK+XCP+bTKlBcRL9IjixfGd0XvL
	 5rIsES9LNj6Q0U2QUlSEtLW3BgutpjkJ/FvKMKBkmoSnDc4tvNugZIJjLuGMzFcF2Jy7K
	 x78XmvKIua+84/jLRNXBti7nG2VR41rw4hJQ2bD6QoM72HbTB99geViBMhiSbCIwIHQwp
	 pD5zsQ5IfFtgKdHv1LJxYSeCbdgULfqTYPX5E/lH3zQBdywRUi2KNiYHGe7U/8EXg3g==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794001417;
	h=DMARC-Filter:DKIM-Signature:Received:Received:From:Date:Subject:
	 Content-Type:Content-Transfer-Encoding:Message-Id:X-B4-Tracking:
	 X-Change-ID:To:Cc:X-Mailer:X-ClientProxiedBy:MIME-Version:
	 X-MS-PublicTrafficType:X-MS-TrafficTypeDiagnostic:
	 X-MS-Office365-Filtering-Correlation-Id:X-MS-Exchange-SenderADCheck:
	 X-MS-Exchange-AntiSpam-Relay:X-Microsoft-Antispam:
	 X-Microsoft-Antispam-Message-Info:X-Forefront-Antispam-Report:
	 X-MS-Exchange-AntiSpam-MessageData-ChunkCount:
	 X-MS-Exchange-AntiSpam-MessageData-0:X-OriginatorOrg:
	 X-MS-Exchange-CrossTenant-Network-Message-Id:
	 X-MS-Exchange-CrossTenant-AuthSource:X-MS-Exchange-CrossTenant-AuthAs:
	 X-MS-Exchange-CrossTenant-OriginalArrivalTime:
	 X-MS-Exchange-CrossTenant-FromEntityHeader:
	 X-MS-Exchange-CrossTenant-Id:X-MS-Exchange-CrossTenant-MailboxType:
	 X-MS-Exchange-CrossTenant-UserPrincipalName:
	 X-MS-Exchange-Transport-CrossTenantHeadersStamped;
	bh=BgIXGY8SgvP6w3HtFUueuWDoGe84VhugkauvX26/Skg=;
	b=omQNuJCU439+lEQHLtw3IyaYKDDuWTl1OkHXlvNKmHhqOW4qQfN5Lfc+ayQTo6PpAMYg
	 FCxoXuX1aMAO8rzQCyYJa8NlcSY0m8tR6Xr4+CMrOSKfp5qRMM797vgb3hrDLmb6StMI2
	 /K0MTPRuvZFU2OgFYCqWNfxKhCVg+NnhWDlzXZE+A7aZmN0gtvJb7vf8wy9twvFRbp/Kl
	 1JgqJ9wOlNd41MMKGfwf1S/HsPgWwvNatvku16N/sBW9a5CF4cThLc7ARH3YjF8I5gezg
	 vWpJta3YIkgiI39/R2JrTC9eJAHOXAyp5DPhCscRLRCAciwfR/JOb0ihjdkZs+wI5kQ==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=nvidia.com;
	spf=fail smtp.mailfrom=nvidia.com;
	dkim=pass header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=nAYhjlti;
	arc=pass header.oldest-pass=0 smtp.remote-ip=52.101.52.61
Received: from BL2PR02CU003.outbound.protection.outlook.com (mail-eastusazon11011061.outbound.protection.outlook.com [52.101.52.61])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (secp384r1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A5807606A329
	for <nvdimm@lists.linux.dev>; Fri,  6 Nov 2026 21:43:36 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org A5807606A329
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=nAYhjlti
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=xNAKsUCCYVtB58GNH9KpIuAxcfve7+vqN0Wy1mMTcxJskqYTxifAtQCYAiqWkwvu1RDpi88U16o9Y8iZlMYen3bknqHTY2SFoWv0LP7pfh5h433TDxH9+9o8aJxyTXoHhH3JqtdXCsI1LvbBxBbe9amKTl9n2UiD191H7KUs5nXQNg16kBA0hSmq7sQ/LMm+/leER3y76ubQn5CweVntso0nuR1ikK3G2ASHJsdmgIaHRhwQjYfj4f0GWuEK+1sb6Me7KVDo4GNwPu+h2XKInf93ZhHbYk2t98f5W54x1soBqhywOox44GbQRYzK91d378USg2siOWVIqh3sm+8qig==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=BgIXGY8SgvP6w3HtFUueuWDoGe84VhugkauvX26/Skg=;
 b=pfzWMrlpqbbZKAoRN5OjkwlY+XPEF+dvmY0KOzRLMkWPZ2BC8ZBkPaftAalxnIckDWXLflWUJVB9LuDCfCJfIk6pVfOdxaFYwxIJxesOB67YyJpwn3pP8iPQYjs6xu7/R4C2orXXXPUPbSL61FKIelUP+PnQVR1XhCwR8Zmm133ESnPoq52d5mwfoh30P3HY8f0QdrTHfhmFHZoM0fYgqEbl0oePvbVWi1TVQ50+uVVGwzBwX/2AFpSLoph9rZqeuzgpMzq69owfqy1bXk3cYLlQu0d3JqkGq7B0MzKEWUiJWu7qGbwGP7RKUqTI+Hc0iEBHHvvCHOpVrUHH+z5SyA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=BgIXGY8SgvP6w3HtFUueuWDoGe84VhugkauvX26/Skg=;
 b=nAYhjltiMHlBNfEBH+GfGmaCf+aeGkTCk5Z9oagdpQ+PT0B/R6TeMqC86oJXkdwD7sWYjX9d9n1UBT3fDplCAW93XDVMB2YGwMSEH6JLEwfOwdRCRynCnGI9PXqnCnHjchIQNvwHenhKDiK2T3NBAX19P6zVeCgsU48onsf13Aff4h6s8xND+yu/bwKTdLPxPBdoNub2WOwETAPsf7U5CQLO2ebh08pKxS0OqZwgJNWa2wITe17QKdoOMXihSowvAPw/A8TifJ623ZwNEUa+9YcNdHoWlMHS7XKpQJTdKx8NhZxpwLGIZdXGBG+s/Gh9Urtfe1Rgug4C24QaTnEXiQ==
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from IA0PR12MB8374.namprd12.prod.outlook.com (2603:10b6:208:40e::7)
 by SJ2PR12MB8875.namprd12.prod.outlook.com (2603:10b6:a03:543::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.592.11; Fri, 6 Nov
 2026 21:43:32 +0000
Received: from IA0PR12MB8374.namprd12.prod.outlook.com
 ([fe80::d85f:4c87:ae84:3f16]) by IA0PR12MB8374.namprd12.prod.outlook.com
 ([fe80::d85f:4c87:ae84:3f16%6]) with mapi id 15.21.0592.007; Fri, 6 Nov 2026
 21:43:32 +0000
From: Zi Yan <ziy@nvidia.com>
Date: Fri, 06 Nov 2026 16:43:20 -0500
Subject: [PATCH] mm/truncate: unmap DAX entries before invalidating them
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261106-fix-dax-invalidate-mapped-v1-1-292ce5958d67@nvidia.com>
X-B4-Tracking: v=1; b=H4sIAAAAAAAC/yXMywqDMBCF4VeRWXcgiRdoX6V0Mc2MOtKmIbEii
 O9uWpcfnPNvkCWpZLhVGyRZNOsnFNhLBX6kMAgqF4MzrrPW1NjrikwraljopUyz4JtiFEY23rl
 r17dtU0P5xyRl/G/fH6fz9zmJn39B2PcDE2T3KX0AAAA=
X-Change-ID: 20261103-fix-dax-invalidate-mapped-d0c2296f5543
To: Dan Williams <djbw@kernel.org>, Matthew Wilcox <willy@infradead.org>, 
 Jan Kara <jack@suse.cz>, Alexander Viro <viro@zeniv.linux.org.uk>, 
 Christian Brauner <brauner@kernel.org>, 
 Andrew Morton <akpm@linux-foundation.org>
Cc: David Hildenbrand <david@kernel.org>, 
 Alistair Popple <apopple@nvidia.com>, John Groves <John@Groves.net>, 
 Miklos Szeredi <miklos@szeredi.hu>, "Darrick J. Wong" <djwong@kernel.org>, 
 Carlos Maiolino <cem@kernel.org>, linux-xfs@vger.kernel.org, 
 linux-fsdevel@vger.kernel.org, nvdimm@lists.linux.dev, 
 linux-kernel@vger.kernel.org, linux-mm@kvack.org, stable@vger.kernel.org, 
 Zi Yan <ziy@nvidia.com>
X-Mailer: b4 0.16.0
X-ClientProxiedBy: BLAPR05CA0039.namprd05.prod.outlook.com
 (2603:10b6:208:335::20) To IA0PR12MB8374.namprd12.prod.outlook.com
 (2603:10b6:208:40e::7)
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Post: <mailto:nvdimm@lists.linux.dev>
List-Help: <mailto:nvdimm+help@lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
List-Owner: <mailto:nvdimm+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: IA0PR12MB8374:EE_|SJ2PR12MB8875:EE_
X-MS-Office365-Filtering-Correlation-Id: fd73c8b0-14d4-41c2-ad5c-08df3c4f008a
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|23010399003|7416014|1800799024|366016|376014|261102123227099003|261102130727099003|261021123027099003|261021121427099003|261022075727099003|261022105027099003|261026121527099003|261009223027099003|261026140227099003|261028144727099003|5023799004|11063799006|56012099006|10067099003|18002099003;
X-Microsoft-Antispam-Message-Info:
	2vhq7AR+dP1XPpbyE5eA26Xzm5LhYog4aE15PBLZ7OOglfBZu2GiYcOYMaZCGlvKhXbodAiNyGR/f4gbZ3ueSk8tPcPU+PAO2q95cn9zE+63vkY70I5muBgRjF1zgxEK2iQSxLlnzHyNo3FqEZPKylu3Toa4mqnHR2RPGz+3c46RQnGvZlxoq59Fgpy8zfa+66lAoEUiaGFaflStpBQFUSp2h7TtuO+xadLMr5vrm1dUqvab+dqda5exnMYNrrH3AMp7hT1m2XQpZFcAANxw7fb6PtdIZ4uEmO499AcNCLyT0/UP8plW3/XEEoT2oE9+FsDC/7bCVDg2XI2DzY8C8a1tk57YBjKxPXMRivmvvNsm9uHeg7SsyoJkleGvuIm1nWig5sO7jzUgy2IZzCYR4lXVBqsfGNZYjeQGQEnAiE/OtEqruvRJUGGVZ/tqo/qdFZxIwPVmDQTLNx7GMEvVgwKnzGES4Ki7uzKQrZtckQ+5INccrqZEI1Xv5wMTLuH6I1tAi/IFv+jpEVKNWLYx1lKdXCpN+zpUOvnmXqUuX42wZF8RaNiN5PqGmkfFsax0SdBawOwc6C/knHvvRYtWgsqajPKPfHTE7R+++YXmsXNSP1oiJeeDil9wAHRw1TAFralCjbzlZz7Lzkfinyvx8xAfgPLf3J7BWI35cqkXphw=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:IA0PR12MB8374.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(23010399003)(7416014)(1800799024)(366016)(376014)(261102123227099003)(261102130727099003)(261021123027099003)(261021121427099003)(261022075727099003)(261022105027099003)(261026121527099003)(261009223027099003)(261026140227099003)(261028144727099003)(5023799004)(11063799006)(56012099006)(10067099003)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?aXNOcllLM01zZjNrUmg3YWo4RGl1ZTJXamlHY3VETzNoSjIzOHJGZlF6dVUr?=
 =?utf-8?B?Zk1xRkRaSEJBTE5xb3hmajVOQ3BCMnQ1d251QjlJSXhMWkZTem1vazhjV01B?=
 =?utf-8?B?dS94NTdrd1ZkVkF6RHIvZ2RpZXB1eTFPaTY3bTBQMUs5N1dKdkQ4MG5Bc050?=
 =?utf-8?B?WHZSZzVVZ1JZMGc0WjB3YlpndTQvZC9lcG1IeWgxRXNzSEpReHFscUZGL2lS?=
 =?utf-8?B?RHpYRElKYzI5NGlIR0tHK3hLVC9ydTM4TWl5V2twazFmOEkwdWxacVVoLzJH?=
 =?utf-8?B?Rzk2cngwK0dTaW1oSE5LVlF1SFpRWmIwVHkwRUY4dWpUVTFLVDN5UnZ2amg1?=
 =?utf-8?B?cnN4cnN0MkpLb3ZIQ0dzVGFaaW5OSjh5YURLV1JEZUoySTlpeFVxdHZMNlBV?=
 =?utf-8?B?ZVRFMDc5WnZBazgrK3poc1R6RjVsdUpxbDNYeFYveUN3SERWTXVaVTQxM0pq?=
 =?utf-8?B?bFIwVXc3SDk5U1crRWMvRnovei9NWHhHd0xxWEhUSDNLYVZFOHZUMGJ3QTFX?=
 =?utf-8?B?azJIYU5wVCtLVTkwNTM1NENoM0x6Wkd3NGJrOXlndFYrNmdteG9tME01Tjhi?=
 =?utf-8?B?K2s1eXNicDk2YTBUcDFRRUZDdXN4R2tJTlBORkpxNWU0TG55ZER5U0ZraVA1?=
 =?utf-8?B?d1Q1bWlaajZtWHc3TjFKcVJGWW9FelJHZDFyWnZhbStvNU45YzhhMG5HR01C?=
 =?utf-8?B?UC9nS3U5RG5OVFRuU0lKa05KSVp5b0lnemZMNmdQZERTYlhUSjBRVzhBUlB5?=
 =?utf-8?B?UlZ3TXhTaUxUNlA0eUJIK2g5WmNnbjUwejJkLzRHMi9rd2dqZ29jaDVTbE9P?=
 =?utf-8?B?Y0c2d0Qvbld0clU0ZVNPOWpHbHZJRlZZN3R5ajZMdnNkOXB2amNwOEhFVHZX?=
 =?utf-8?B?SnlCckwwSjN2eDM5WEtoZkJSajhtYUQ4NldZak5TRHBISVZhWnRjb2xLYkty?=
 =?utf-8?B?R0tzQlJPc1NYVWNiTktDY3hITGp2Qk9wTzMwMElyTG5zbjl2K3VHQkM0UDVq?=
 =?utf-8?B?di9DbmJpeS92NXU1SWFLa3JEUGxmeU1sTGU0TzFNRHQrV2VKclRBeTNzZ0dI?=
 =?utf-8?B?NldmUUtZZVJQVndTdG14NlROM2lnNlMzTFVseXk5OC9WeGZzcXRXdnpUSHNO?=
 =?utf-8?B?dVBNOHZkcGs4R2VjZWRzYmtLT0N0ZGNwM2V4U3NYWHZEMjFTcDZPVDFpb1Z6?=
 =?utf-8?B?S2F4YVNuOVgwMHNlbm12SmhCdjQydFpQaGNJb2pxbm54SGRrdjNyU3o5TjBZ?=
 =?utf-8?B?bE5EeWl0MkxrOXh4SmxubEMyVHkzaUE5UDBZUE5STjdqRVM2MUp4NWwxTjZj?=
 =?utf-8?B?d1U0NE5YL1VXRE9yV2lqUmpvOUFYTUdIQTZuV3cvOWZoVHNJTWx2Qm1HY1pk?=
 =?utf-8?B?N0xZd200SWo5ZTZ6dWtVNkY5cnBJQkJxTE9wbjBnM0FYa0JhaG8wdXNsTVpy?=
 =?utf-8?B?WVkwN1E1dXJ4YTFWZlNqNXhzdlRqdzJrSmNpODA4OE0wblNFQnk0R29nakQ4?=
 =?utf-8?B?Z1NObzI3U2ZUR3BDUFJrLzcrR1c1SGZjQUo4QzBoTGZ0a1hSemVmaE1NL1pH?=
 =?utf-8?B?dVBSWmlhSldJUm8wWi9DdTBaUGtYVTR1WGc3Yk1ZZlhJQkdJR3VIZURIVUZ2?=
 =?utf-8?B?VUt2U1ArS0lQaUNIUGpVVXVwS2x0b2JBZFFpK3BQU3ZKWGtQMVgySy9pZWYr?=
 =?utf-8?B?Y0lOcWdBSDBIdUJzdEZhcm8xVGIzQWh4YncvMll0NGRSSFlQcC9wQXQ3OTE0?=
 =?utf-8?B?Ym0xZjh0QlppUk53ZTlMMGg2dk01YWwveWExQ2k1Z0RnZEtYYVFJWjZPZUx2?=
 =?utf-8?B?Zk4zcGFnbkUvTVpDcjcvMmN3SW41YnVhWmFYWkRNVjBMOVpLZExoV0RpdmpF?=
 =?utf-8?B?KytMem9OeER3RVBBQzBDbVpHZUpCaU02SWVqdEw5RktMWnpoS1NucTI3YTVm?=
 =?utf-8?B?bG5MYmdlYlJyVnhNU3pobzd2VFZhY2puZ1RqdFlhK25PRENOZStGU2NGTGtB?=
 =?utf-8?B?eUhUdHp2dDJPejBITXhFdVRjSDRHQmg5MVB4MFlyNEY2SHM5cklFbzg4dFZ3?=
 =?utf-8?B?TWJHcmM0UVRhdkRLcDZQZU15R3JPaTdwYXJiZlRjUlFaMTZFNGF0K2p5bWgz?=
 =?utf-8?B?a1B2V3ZJSUFZQkM2a2ZjZlpHZFpOMmxNNllrbE1oSWNPZTJQSW1KNnZweFJl?=
 =?utf-8?B?Z1BBNGpaTDBWa3VxZEI4aSs3OTBuYU9idFo2ek4wTFVJejZieTBvZFJ2VWsy?=
 =?utf-8?B?c09XZkl2NHl3RnhLaE5qaktwMWkxVnJGQ05mblNabDVLRXhmZ0RaUlJzRGVN?=
 =?utf-8?Q?lAIDe/mFCFvrKTtPeY?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: fd73c8b0-14d4-41c2-ad5c-08df3c4f008a
X-MS-Exchange-CrossTenant-AuthSource: IA0PR12MB8374.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Nov 2026 21:43:32.0515
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 5VWymNtuEi5JTuxLgHU3To/jemZjlXmq7RAJxUxf3VMpzzvS5MZl+dyr/45l7dKC
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ2PR12MB8875

invalidate_inode_pages2_range() invalidates the clean DAX entries in the
range through dax_invalidate_mapping_entry_sync() and only unmaps the range
afterwards. Dropping the last association of an entry releases its folio
by dissolving the folio into order-0 ones. If the entry is still mapped,
1. dax_folio_put() warns;
2. if the folio order is PMD, folio_remove_rmap_pmd() during the unmap
   afterwards operates on an order-0 folio (the original head page) and
   corrupts the original first tail page metadata.

This is reachable from userspace with a copy-on-write write to a mapped
reflinked file on XFS with DAX:

  WARNING: fs/dax.c:452 at dax_disassociate_entry.isra.0+0x147/0x1c0
  Call Trace:
   __dax_invalidate_entry+0x106/0x320
   invalidate_inode_pages2_range+0x3ce/0x830
   dax_iomap_rw+0x421/0xcc0
   xfs_file_dax_write+0x252/0x9e0
   vfs_write+0x53a/0xe70
   __x64_sys_pwrite64+0x195/0x250
   ...
  WARNING: ./include/linux/rmap.h:351 at folio_remove_rmap_pmd+0x8b2/0xaf0
  Call Trace:
   split_huge_pmd_locked+0x751/0x2350
   __split_huge_pmd+0x1bb/0x310
   ...
   unmap_mapping_pages+0x133/0x150
   invalidate_inode_pages2_range+0x700/0x830
   dax_iomap_rw+0x421/0xcc0
   ...

To fix it, unmap DAX ranges before invalidating them, as the page cache
path does for mapped folios. In __dax_invalidate_entry(), when
invalidating, skip an entry if the code is dropping its last association
but its folio still has outstanding references. -EBUSY is returned for the
skipped entries. The unmap before invalidation works because any remap of
the folio between the unmap and invalidation will bump the folio refcount.

Fixes: 38607c62b34b ("fs/dax: properly refcount fs dax pages")
Cc: stable@vger.kernel.org
Signed-off-by: Zi Yan <ziy@nvidia.com>
---
I found this while auditing the paths that map pages into user page
tables. invalidate_inode_pages2_range() releases the folios of DAX
entries that are still mapped. For a PMD-mapped folio this corrupts what
used to be its first tail page, and a copy-on-write write to a mapped
reflinked file on XFS with DAX is enough to hit it.

In QEMU with emulated NVDIMMs and XFS on an fsdax namespace:

- Copy-on-write with the script below, PTE- and PMD-mapped, with only a
  mapped and with a and b mapped. Before this patch, the WARNs in the
  commit message and a corrupted first tail page in the PMD case. With this
  patch: the mapping of a sees the new data, b keeps the old data, and
  nothing warns, except for item 4 below.

  mkfs.xfs -f -m reflink=1 -d su=2m,sw=1 /dev/pmem1
  mount -o dax=always /dev/pmem1 /mnt && cd /mnt
  xfs_io -f -c "extsize 2m" -c "pwrite -q -S 0x5a 0 4m" -c fsync a
  xfs_io -f -c "reflink a 0 0 4m" b
  (echo "mmap -r 0 4m"; echo "madvise -h 0 4m"; echo "mread 0 4m";
   sleep 4; echo "mread -v 0 16") | xfs_io a &
  sleep 2; xfs_io -c "pwrite -q -S 0xa5 0 8k" -c fsync a; wait

Open issues that this patch does not address. They are races or
already exist without it.

1. A refault, or a short-term or speculative reference, between the
   early unmap and the invalidation keeps a last association in place,
   and invalidate_inode_pages2_range() returns -EBUSY.
   dax_iomap_iter(), dax_unshare_iter() and dax_zero_iter() ignore that
   and write the new extent anyway, which leaves a stale entry. Without
   this patch the same race tears down the referenced folio. Should
   these paths retry, or fail?

2. XFS device pre-removal ignores the result as well, so an entry kept
   because of a short-term reference is not revisited before the
   memmap goes away.

3. folio->share is updated under each file's i_pages lock, so the
   shared-count check here, like dax_folio_put() itself, can race with
   another file dropping its share.

4. With reflink, after a copy-on-write write, a PTE fault can associate
   an order-0 entry with a shared folio that another file still maps
   with a PMD. That trips WARN_ON_ONCE(dax_entry_order(entry) !=
   folio_order(folio)) in dax_associate_entry(), with and without this
   patch.

Based on an LLM's analysis, 1 and 2 can be fixed by holding the invalidate
lock and breaking DAX layouts in the callers; 3 needs a per-folio lock
for ->share; 4 needs a way to share a folio at different granularities,
or no PMD mappings of shared extents as a simple fix.

LLMs were used to analyze the issue, write the patch, and review the code.
---
 fs/dax.c      | 28 ++++++++++++++++++++++++++--
 mm/truncate.c | 16 +++++++++++-----
 2 files changed, 37 insertions(+), 7 deletions(-)

diff --git a/fs/dax.c b/fs/dax.c
index 94ba41273347c..e448552d8080d 100644
--- a/fs/dax.c
+++ b/fs/dax.c
@@ -527,6 +527,24 @@ static struct page *dax_busy_page(void *entry)
 		return NULL;
 }
 
+/*
+ * Determine if an entry can be disassociated. It cannot be if it is its folio's
+ * last association and the folio still has a reference.
+ */
+static bool dax_can_disassociate(void *entry)
+{
+	struct folio *folio;
+
+	if (dax_is_zero_entry(entry) || dax_is_empty_entry(entry))
+		return true;
+
+	folio = dax_to_folio(entry);
+	if (dax_folio_is_shared(folio) && folio->share > 1)
+		return true;
+
+	return !folio_ref_count(folio);
+}
+
 /**
  * dax_lock_folio - Lock the DAX entry corresponding to a folio
  * @folio: The folio whose entry we want to lock
@@ -853,9 +871,14 @@ static int __dax_invalidate_entry(struct address_space *mapping,
 	entry = get_next_unlocked_entry(&xas, 0);
 	if (!entry || WARN_ON_ONCE(!xa_is_value(entry)))
 		goto out;
+	/*
+	 * Removing the last association of a folio releases the folio, so make
+	 * sure the folio has no reference.
+	 */
 	if (!trunc &&
 	    (xas_get_mark(&xas, PAGECACHE_TAG_DIRTY) ||
-	     xas_get_mark(&xas, PAGECACHE_TAG_TOWRITE)))
+	     xas_get_mark(&xas, PAGECACHE_TAG_TOWRITE) ||
+	     !dax_can_disassociate(entry)))
 		goto out;
 	dax_disassociate_entry(entry, mapping, trunc);
 	xas_store(&xas, NULL);
@@ -1017,7 +1040,8 @@ void dax_break_layout_final(struct inode *inode)
 EXPORT_SYMBOL_GPL(dax_break_layout_final);
 
 /*
- * Invalidate DAX entry if it is clean.
+ * Invalidate DAX entry if it is clean and dropping it would not release a folio
+ * that is still in use.
  */
 int dax_invalidate_mapping_entry_sync(struct address_space *mapping,
 				      pgoff_t index)
diff --git a/mm/truncate.c b/mm/truncate.c
index 9e9bf029635cf..b03cd99c4bba8 100644
--- a/mm/truncate.c
+++ b/mm/truncate.c
@@ -732,6 +732,15 @@ int invalidate_inode_pages2_range(struct address_space *mapping,
 	if (mapping_empty(mapping))
 		return 0;
 
+	/*
+	 * Invalidating a DAX entry can release its folio, so unmap DAX entries
+	 * before invalidating them. dax_invalidate_mapping_entry_sync() skips
+	 * the last association of a folio that still has references, e.g.
+	 * because it was faulted in again in the meantime.
+	 */
+	if (dax_mapping(mapping))
+		unmap_mapping_pages(mapping, start, end - start + 1, false);
+
 	folio_batch_init(&fbatch);
 	index = start;
 	while (find_get_entries(mapping, &index, end, &fbatch, indices)) {
@@ -787,11 +796,8 @@ int invalidate_inode_pages2_range(struct address_space *mapping,
 		cond_resched();
 	}
 	/*
-	 * For DAX we invalidate page tables after invalidating page cache.  We
-	 * could invalidate page tables while invalidating each entry however
-	 * that would be expensive. And doing range unmapping before doesn't
-	 * work as we have no cheap way to find whether page cache entry didn't
-	 * get remapped later.
+	 * For DAX, also zap the mappings that were faulted in while we were
+	 * invalidating.
 	 */
 	if (dax_mapping(mapping)) {
 		unmap_mapping_pages(mapping, start, end - start + 1, false);

---
base-commit: 63919467fb5239ab824de6a7a128b882055b24af
change-id: 20261103-fix-dax-invalidate-mapped-d0c2296f5543

Best regards,
--  
Yan, Zi

