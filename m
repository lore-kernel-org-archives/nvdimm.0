Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=52.101.201.14
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1794263462;
	b=owhxaM+5wEJUVX8hiG3cgidwsFg3uxREM9dv14MZHWQAWfVGlsmevSz9I9XaIzyMXvvV
	 OPEkrWw028JMEoa55EUUFFndGnHPU62dM3Ejzzn/uyVOxx2aDMamvSeL5ToIy97fzChrQ
	 wCT1cvZkiTErAVgIVkVRd4T32RyXIG7KvufJveSAMJYbRhnoUwiR6nBilLgD8HfvYVdS7
	 urpzx5DAgxcipe+ma3ehNTg7gYJ56GOwDQkW1zqwR7TFbQX4sRcXqp72MVkjpKb8umc/C
	 OQEmx8P+mXZl18rkq4spuxnqdiN0XGRxk9Lra5R4W2O59wUZUblSz3fBGnKVvp2FyqA==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794263462;
	h=DMARC-Filter:DKIM-Signature:Received:Received:Date:From:To:Cc:
	 Subject:Message-ID:References:Content-Type:Content-Disposition:
	 In-Reply-To:X-ClientProxiedBy:MIME-Version:X-MS-PublicTrafficType:
	 X-MS-TrafficTypeDiagnostic:X-MS-Office365-Filtering-Correlation-Id:
	 X-MS-Exchange-SenderADCheck:X-MS-Exchange-AntiSpam-Relay:
	 X-Microsoft-Antispam:X-Microsoft-Antispam-Message-Info:
	 X-Forefront-Antispam-Report:
	 X-MS-Exchange-AntiSpam-MessageData-ChunkCount:
	 X-MS-Exchange-AntiSpam-MessageData-0:X-OriginatorOrg:
	 X-MS-Exchange-CrossTenant-Network-Message-Id:
	 X-MS-Exchange-CrossTenant-AuthSource:X-MS-Exchange-CrossTenant-AuthAs:
	 X-MS-Exchange-CrossTenant-OriginalArrivalTime:
	 X-MS-Exchange-CrossTenant-FromEntityHeader:
	 X-MS-Exchange-CrossTenant-Id:X-MS-Exchange-CrossTenant-MailboxType:
	 X-MS-Exchange-CrossTenant-UserPrincipalName:
	 X-MS-Exchange-Transport-CrossTenantHeadersStamped;
	bh=WOTFv6VJX6Xsjhv76PyixKH+T28COjVb1Ygxx/2pcso=;
	b=yGYHLO1coMXxUMp4yz5y+Bx+6rhP9kXDkcHe/Ba1/emFPKD3mPigUymyk0HJAsogas63
	 qUXKpWxeo6BY7pOiQMKWLQkBfKvcC+HD+IIl1Q/8OhlWqiKd3+AzG8s6kmiwRcacjrFsE
	 TW4SylfFCcbdyDlY0WwuW4mh7djmx0m8SiWq8utTptP0DiMyOuSnXBEo3ynj9GpwBHT+R
	 6zkXGGR3BrSPZq0hLdU8bKmMtOFzrt2okYl1Ioda8B/C14modhM0VO1shdxe36txTwdj6
	 2xSOD4oJ2NjLMYcQ8bfyXunoOtASo6gBGBj0suKRypfHP9lVEb/e2EKjyIWi5lPrEJQ==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=nvidia.com;
	spf=fail smtp.mailfrom=nvidia.com;
	dkim=pass header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=hTIw2MTj;
	arc=pass header.oldest-pass=0 smtp.remote-ip=52.101.201.14
Received: from PH7PR06CU001.outbound.protection.outlook.com (mail-westus3azon11010014.outbound.protection.outlook.com [52.101.201.14])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (secp384r1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 427B1606A326
	for <nvdimm@lists.linux.dev>; Mon,  9 Nov 2026 22:31:02 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 427B1606A326
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=hTIw2MTj
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=vPB8V8CFDDMqcIWa+bYQb1M35AAaZI6ImQf/gEDy9Ca5dkVdjPwF/GVLkKGOREGMOcY52ADsUMpaJQxgZma4nqCJSaaitP8UpG2aNmMdefRgJWuohrsMdTXr6t3NjlUJjwqWA9CxPK2fhQnjwC9krKmlYDIIkgeXL3b0ehxNWiPeAcs4m2yHKXaKZZGpDaiM1+UcouAMqBldUJkfC4QD00q3Ofvh1eGiBfivYCN+ARdqqF9pomlVq6VNweVJ4FetURTQZqhf1WpnEAfjpSWtuDCxRY5Qtzr+gDNciE5P+JJqj9uyHFUCecq4B6Lr1IsDFWLXiK+H9UCpRkyh6JYZ/g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=WOTFv6VJX6Xsjhv76PyixKH+T28COjVb1Ygxx/2pcso=;
 b=isEyNOpPLwPiQFqoXYCZekJJQzPOyx7fRBG6x0UwTBzldhH6+GEUCksjS8K4dFLzU48MWsGx1PX7N0CtrXCBfjHEuRv/TKilWisatdbbzw5sgoUm66dGOaA8r1jahIK6TEb+mOs7YWqnSGA2BufVSHYUQe89f/b4YAZLJbZXO8ytsUJpDDOkEUyaE7L1Txd7qGSeesYB9yqTSF/DOBcrRs5QlWwmzBbBE6onRFFmPvoj6VMVag3rymuFM6Ip3RiAyWRKtnDIBXKyE0Q600/GTC+/QIqK2ha5IzhjA64HteTxeeBhc5E/NoRpmnacTl/MfisubYH8QBIqXpjQPx4nFw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=WOTFv6VJX6Xsjhv76PyixKH+T28COjVb1Ygxx/2pcso=;
 b=hTIw2MTjba/OAHoneV+Se0kqpLcwle7Z9kPvKFUzDDHdqXg9ExGy5a+SlTZHouYl/v0e6i0cX3kMlxEzQSRa7yCq/1CyfsbaIcMbDoWWo3T+CbdECDWcTGAlwYWJPDf1GbFVdaF93dhT59zB4hpwhTpF7/nnWWnGaxat/Ol3xn7ZLQen0Z6HOV2igKDGMDUJDgInab4l1mHPooSiKMBH1FqoDKrmQ+ifbqgsCnuswpOOOzK4SlLwE92d3B/BKBYqI1xFzsVGKHpjnaRWtcHMjDSaJ114BgGnxkVrWZlC25ul2dIG1oLyIANYq7Q4McoEkbOySjXtlPpn6QL56j1l/A==
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from SA3PR12MB598757.namprd12.prod.outlook.com
 (2603:10b6:806:52d::14) by SN7PR12MB8170.namprd12.prod.outlook.com
 (2603:10b6:806:32c::15) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.592.12; Mon, 9 Nov
 2026 22:30:57 +0000
Received: from SA3PR12MB598757.namprd12.prod.outlook.com
 ([fe80::e206:100:5946:a777]) by SA3PR12MB598757.namprd12.prod.outlook.com
 ([fe80::e206:100:5946:a777%5]) with mapi id 15.21.0592.010; Mon, 9 Nov 2026
 22:30:57 +0000
Date: Tue, 10 Nov 2026 09:30:52 +1100
From: Alistair Popple <apopple@nvidia.com>
To: Zi Yan <ziy@nvidia.com>
Cc: Dan Williams <djbw@kernel.org>, Matthew Wilcox <willy@infradead.org>, 
	Jan Kara <jack@suse.cz>, Alexander Viro <viro@zeniv.linux.org.uk>, 
	Christian Brauner <brauner@kernel.org>, Andrew Morton <akpm@linux-foundation.org>, 
	David Hildenbrand <david@kernel.org>, John Groves <John@groves.net>, 
	Miklos Szeredi <miklos@szeredi.hu>, "Darrick J. Wong" <djwong@kernel.org>, 
	Carlos Maiolino <cem@kernel.org>, linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org, 
	nvdimm@lists.linux.dev, linux-kernel@vger.kernel.org, linux-mm@kvack.org, 
	stable@vger.kernel.org
Subject: Re: [PATCH] mm/truncate: unmap DAX entries before invalidating them
Message-ID: <avJEEEL-9L-ycVW9@nvdebian.thelocal>
References: <20261106-fix-dax-invalidate-mapped-v1-1-292ce5958d67@nvidia.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261106-fix-dax-invalidate-mapped-v1-1-292ce5958d67@nvidia.com>
X-ClientProxiedBy: SY5P300CA0036.AUSP300.PROD.OUTLOOK.COM
 (2603:10c6:10:1fd::8) To SA3PR12MB598757.namprd12.prod.outlook.com
 (2603:10b6:806:52d::14)
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
X-MS-TrafficTypeDiagnostic: SA3PR12MB598757:EE_|SN7PR12MB8170:EE_
X-MS-Office365-Filtering-Correlation-Id: 07faa934-f6b7-40bf-fbdd-08df3eb11fa8
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|23010399003|7416014|366016|1800799024|376014|5023799004|11063799006|56012099006|261021121427099003|261021123027099003|261022075727099003|261028144727099003|261009223027099003|261026140227099003|261026121527099003|261102130727099003|261102123227099003|261022105027099003|10067099003|22082099003|18002099003;
X-Microsoft-Antispam-Message-Info:
	xqitOJy98/CS34PvzGwEqkm2dczp3ddybnveZ1TNhRgl1a8v0aWreGZFGoT/CpIX60xem2K6MGyRzXQkuh9BIRwoGugwscCGX85K00XNLGMTieXNvLQ7sEywDWV1KLg0v1Zf66x3BlaaUhJlS16WCtKaB8wuJ28opxwfSjta5hsEHOeWXRalerWfsr+n1tiVq6xkv2+cuVZq+9MJKsxyph4+KgKTIRm2HZtDQDVuqqlY6vtumZuYpFi1qCk+Fk5rWL6pT6q+wYqVNgriSmUNFNEbrdyhh9FiXkLDkm2vhtnoKB0Iz0/UgPLCd8SEHYu51EbMtYgSXS7c1wPGFIVE5MfvgHGPrUiwChWF2IlU3xQCHF5Fmt+7JiD3UaiHJHv0xqQzqFHv3upzmWZx4D/hTtrai+SDngLjb17GGs4g36EZ4q+INdSot2qp2Rr9BgPyGCDco1YFPzxlh7Carj4xHm95RpD7fYby6RWbsp8oPU71AV+M36/+P8Wkdd1wt8lLoVTFaIJ63r1k2Oc7tJ5+KhFEsZXRWNgf0R0L7a7DTicEqQAl6DjIlDSeo+PI1xdOfJ8OmF8/N0wOJkZMvNlikTdKyOKnscj19jYBU2vzC1sxU1sNlcbe8yeQpbD5L4RF0oWGhQ9xy/fW2KwN96C5KQaiITdOsiAx2uGliKHXI8g=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA3PR12MB598757.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(23010399003)(7416014)(366016)(1800799024)(376014)(5023799004)(11063799006)(56012099006)(261021121427099003)(261021123027099003)(261022075727099003)(261028144727099003)(261009223027099003)(261026140227099003)(261026121527099003)(261102130727099003)(261102123227099003)(261022105027099003)(10067099003)(22082099003)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?2MJl2VcuWxf0z5OBdVHA6qp/xik/pLNER/4fS+bBfP0sVfzPxekSBgTBVPJM?=
 =?us-ascii?Q?jncCQPh7MZkaYQVW0/87JqQ3uNJ6BkaxLdlvKMSYdx5jYrz1SNCYMQkM/jZm?=
 =?us-ascii?Q?XRCAczeRdGS1N2wvrth618zPI+UgfWp1jTkH4COGH2DJ2pX2v0x07yhZjnhf?=
 =?us-ascii?Q?4zXHT949omXkwvmBU4vZzd1nUOZIY6V9CdMV2yuR6ohKAa6Nb6GKGFyHHH+B?=
 =?us-ascii?Q?4E1ZN2XgOBiVUIyNMvZR5//Eoq1DVnxJlLX4N8kwE6s1F+GaPKwAugUO5w9R?=
 =?us-ascii?Q?djLxofptfHDC8HU6+rlBBBy5SkkrrGtNvFd+xa+N5wwKlB/1ojAfS1tpx/dt?=
 =?us-ascii?Q?WkseI1LRFhcRzhPkmWyLA3foqaO3xsEjzOzJj5Xo0B3zh9MhdO+MxQlcwGO7?=
 =?us-ascii?Q?hYb3//Y1bCu+8Kx3Ywnj6zMxdh5c4bn1D0FmSeqxnqmE41T3Z7wa9XMHKzdI?=
 =?us-ascii?Q?8goBsnS7sJAarTSmigB/oVykAT+qwKd3tR/n6jGHsm+ZKftE//+b1+TuNPdI?=
 =?us-ascii?Q?JFvq0A0KeMD5+rq7SL/BEBNcIWzxtaFNs6Up1IXYdOBCQe213gY6SOBX6afx?=
 =?us-ascii?Q?j/DgB/dDs5r2dDvbtZoxXH7sTw19CbdznRuaU3aaXYPu6SjHnqzar6kNywRP?=
 =?us-ascii?Q?K0qgfdiJjxKyWxaeCfPuIr5JiMv2tKQJC4ujVcAEB0cPig4mOn5BArB71Dq/?=
 =?us-ascii?Q?jYt3hdH46ZHJtsXQ1F2tBQX6gXQkePWn3n0ii1eqW9zTWlzicF0lF+OZwX5z?=
 =?us-ascii?Q?bE6qv5tvzs9Xya79MOcxSNKlEV/ywrjK140DXGEJIold/1CyyEmF84acMy2J?=
 =?us-ascii?Q?H53HxqTjL4DwowT46OlN1ebrlOLsVjVC8/kKtwWoOgXhkEa1D2vnbFgFvSE4?=
 =?us-ascii?Q?vI+5AO2nUNATiF7Rl/VxzhZD+WPoyGoIqI0+g1recd7IyVi2IJldKZSxf4Ci?=
 =?us-ascii?Q?GQ3K/aKrMv3JB8ELUvsRvOllfpwy5lq5AF9otgz4nxgErGQHDrrgYsrUybKt?=
 =?us-ascii?Q?7+rq9+pxei2ufD3U/UaHjHw6TnObfncy9XHJam3ky8c0SW7VekOX9yXqE1ng?=
 =?us-ascii?Q?1xRkHplskFoZHm2uVZdhkX4GqLHmcPQ0tyNNj7HNxW4Xke3JIhtb/XNpchG7?=
 =?us-ascii?Q?DKTHsg4TfcJ3Y1Nj+StWSVCIBuA6uqyra1QzRg45Xg6I8w37aTdBQy2G17hN?=
 =?us-ascii?Q?SOEah/M/CwwgXTr6KrJ1lgrC0pMd7cl2HHYl3gZstbtQ7WAnqaMh6wVdXfWu?=
 =?us-ascii?Q?3JF0ZyBCGGGMYsR2ZOwwjoFz4BMJfMux1gyiRuTTm6gqo9kQgPTY73tJeRQR?=
 =?us-ascii?Q?Q0Ub3cKIzB9C/sCTU4tq1vTsmyOI67YUQ6IxoryxnTwXORhBXh9x7oRSKv/r?=
 =?us-ascii?Q?NNSO8BXipKXLAPqOzqDzEaBdFKPlMA4W/yKxKxcn0xi5nIWsnm8pxuBedMhz?=
 =?us-ascii?Q?herlBje3NJDlvfdP1CtUenbgRedmmc9rFCb2hITWkoUU1PI1fWqjt3Uiy4yd?=
 =?us-ascii?Q?Ky52bX/t9E1EcvrfxoAzm5c4LFAzfONQ0UwH7+rJshlilOHTIhPe4X1fU3qz?=
 =?us-ascii?Q?ui3S6B6lKnkSfzJvUHy8ZfhNO/fHt1PRo5IVNxcghehChfu6CzZWRlvzFT3y?=
 =?us-ascii?Q?PLdmVXgJDV3mXoahgGhSZkHGxGPB5ByY4wQ4DkPGw5tRzVSs383xt+qYuT0F?=
 =?us-ascii?Q?zUtgzvpGkRH/3gAzHRiJeLcV1YJiBw8Uu8/vuUUETSRQFM7Ktc0XarJv0yqU?=
 =?us-ascii?Q?n3dGSN/oMg=3D=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 07faa934-f6b7-40bf-fbdd-08df3eb11fa8
X-MS-Exchange-CrossTenant-AuthSource: SA3PR12MB598757.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Nov 2026 22:30:57.1918
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: UToODkYNpBpxmUI5J/x6PXhd+rHvkGem9o1RVDAHCebcsUh+sGQQLeeJ3jJzvXgyd+a3vqyOrg76xHzgTaAbKg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR12MB8170

On 2026-11-07 at 08:43 +1100, Zi Yan <ziy@nvidia.com> wrote...
> invalidate_inode_pages2_range() invalidates the clean DAX entries in the
> range through dax_invalidate_mapping_entry_sync() and only unmaps the range
> afterwards. Dropping the last association of an entry releases its folio
> by dissolving the folio into order-0 ones. If the entry is still mapped,
> 1. dax_folio_put() warns;
> 2. if the folio order is PMD, folio_remove_rmap_pmd() during the unmap
>    afterwards operates on an order-0 folio (the original head page) and
>    corrupts the original first tail page metadata.
> 
> This is reachable from userspace with a copy-on-write write to a mapped
> reflinked file on XFS with DAX:
> 
>   WARNING: fs/dax.c:452 at dax_disassociate_entry.isra.0+0x147/0x1c0
>   Call Trace:
>    __dax_invalidate_entry+0x106/0x320
>    invalidate_inode_pages2_range+0x3ce/0x830
>    dax_iomap_rw+0x421/0xcc0
>    xfs_file_dax_write+0x252/0x9e0
>    vfs_write+0x53a/0xe70
>    __x64_sys_pwrite64+0x195/0x250
>    ...
>   WARNING: ./include/linux/rmap.h:351 at folio_remove_rmap_pmd+0x8b2/0xaf0
>   Call Trace:
>    split_huge_pmd_locked+0x751/0x2350
>    __split_huge_pmd+0x1bb/0x310
>    ...
>    unmap_mapping_pages+0x133/0x150
>    invalidate_inode_pages2_range+0x700/0x830
>    dax_iomap_rw+0x421/0xcc0
>    ...
> 
> To fix it, unmap DAX ranges before invalidating them, as the page cache
> path does for mapped folios. In __dax_invalidate_entry(), when
> invalidating, skip an entry if the code is dropping its last association
> but its folio still has outstanding references. -EBUSY is returned for the
> skipped entries. The unmap before invalidation works because any remap of
> the folio between the unmap and invalidation will bump the folio refcount.

A quick check of callers of invalidate_inode_pages2_range() either ignore
the return code or produce a WARN_ON if the invalidation fails. For example
xfs_fs_commit_blocks(). I don't think anything makes that inherently safe
against COW for example.

That's pre-existing of course - but this patch does increase the likelihood of
error. Overall though I think this patch is still an improvement, and based on
code comments my AI agent concluded that these kind of issues are somewhat known
anyway.

> Fixes: 38607c62b34b ("fs/dax: properly refcount fs dax pages")

I suspect this issue actually preexists my changes here. Prior the page
meta-data was still getting modified on disassociation even if the folio was
referenced. In some ways proper refcounting just made it easier to catch these
kind of problems, which was partly the point of doing it :-)

But I think it makes sense to use this as the "Fixes" tag - backporting this to
anything prior would be difficult and a rewrite of this fix anyway.

> Cc: stable@vger.kernel.org
> Signed-off-by: Zi Yan <ziy@nvidia.com>
> ---
> I found this while auditing the paths that map pages into user page
> tables. invalidate_inode_pages2_range() releases the folios of DAX
> entries that are still mapped. For a PMD-mapped folio this corrupts what
> used to be its first tail page, and a copy-on-write write to a mapped
> reflinked file on XFS with DAX is enough to hit it.
> 
> In QEMU with emulated NVDIMMs and XFS on an fsdax namespace:
> 
> - Copy-on-write with the script below, PTE- and PMD-mapped, with only a
>   mapped and with a and b mapped. Before this patch, the WARNs in the
>   commit message and a corrupted first tail page in the PMD case. With this
>   patch: the mapping of a sees the new data, b keeps the old data, and
>   nothing warns, except for item 4 below.
> 
>   mkfs.xfs -f -m reflink=1 -d su=2m,sw=1 /dev/pmem1
>   mount -o dax=always /dev/pmem1 /mnt && cd /mnt
>   xfs_io -f -c "extsize 2m" -c "pwrite -q -S 0x5a 0 4m" -c fsync a
>   xfs_io -f -c "reflink a 0 0 4m" b
>   (echo "mmap -r 0 4m"; echo "madvise -h 0 4m"; echo "mread 0 4m";
>    sleep 4; echo "mread -v 0 16") | xfs_io a &
>   sleep 2; xfs_io -c "pwrite -q -S 0xa5 0 8k" -c fsync a; wait

Ideally I think this should be added to the xfstest suite - that was extremely
useful during some of the refcounting reworks and found all sorts of interesting
corner cases.

> Open issues that this patch does not address. They are races or
> already exist without it.
> 
> 1. A refault, or a short-term or speculative reference, between the
>    early unmap and the invalidation keeps a last association in place,
>    and invalidate_inode_pages2_range() returns -EBUSY.
>    dax_iomap_iter(), dax_unshare_iter() and dax_zero_iter() ignore that
>    and write the new extent anyway, which leaves a stale entry. Without
>    this patch the same race tears down the referenced folio. Should
>    these paths retry, or fail?
> 
> 2. XFS device pre-removal ignores the result as well, so an entry kept
>    because of a short-term reference is not revisited before the
>    memmap goes away.
> 
> 3. folio->share is updated under each file's i_pages lock, so the
>    shared-count check here, like dax_folio_put() itself, can race with
>    another file dropping its share.
> 
> 4. With reflink, after a copy-on-write write, a PTE fault can associate
>    an order-0 entry with a shared folio that another file still maps
>    with a PMD. That trips WARN_ON_ONCE(dax_entry_order(entry) !=
>    folio_order(folio)) in dax_associate_entry(), with and without this
>    patch.
> 
> Based on an LLM's analysis, 1 and 2 can be fixed by holding the invalidate
> lock and breaking DAX layouts in the callers; 3 needs a per-folio lock
> for ->share; 4 needs a way to share a folio at different granularities,
> or no PMD mappings of shared extents as a simple fix.
> 
> LLMs were used to analyze the issue, write the patch, and review the code.
> ---
>  fs/dax.c      | 28 ++++++++++++++++++++++++++--
>  mm/truncate.c | 16 +++++++++++-----
>  2 files changed, 37 insertions(+), 7 deletions(-)
> 
> diff --git a/fs/dax.c b/fs/dax.c
> index 94ba41273347c..e448552d8080d 100644
> --- a/fs/dax.c
> +++ b/fs/dax.c
> @@ -527,6 +527,24 @@ static struct page *dax_busy_page(void *entry)
>  		return NULL;
>  }
>  
> +/*
> + * Determine if an entry can be disassociated. It cannot be if it is its folio's
> + * last association and the folio still has a reference.
> + */
> +static bool dax_can_disassociate(void *entry)
> +{
> +	struct folio *folio;
> +
> +	if (dax_is_zero_entry(entry) || dax_is_empty_entry(entry))
> +		return true;
> +
> +	folio = dax_to_folio(entry);
> +	if (dax_folio_is_shared(folio) && folio->share > 1)
> +		return true;
> +
> +	return !folio_ref_count(folio);
> +}
> +
>  /**
>   * dax_lock_folio - Lock the DAX entry corresponding to a folio
>   * @folio: The folio whose entry we want to lock
> @@ -853,9 +871,14 @@ static int __dax_invalidate_entry(struct address_space *mapping,
>  	entry = get_next_unlocked_entry(&xas, 0);
>  	if (!entry || WARN_ON_ONCE(!xa_is_value(entry)))
>  		goto out;
> +	/*
> +	 * Removing the last association of a folio releases the folio, so make
> +	 * sure the folio has no reference.
> +	 */
>  	if (!trunc &&
>  	    (xas_get_mark(&xas, PAGECACHE_TAG_DIRTY) ||
> -	     xas_get_mark(&xas, PAGECACHE_TAG_TOWRITE)))
> +	     xas_get_mark(&xas, PAGECACHE_TAG_TOWRITE) ||
> +	     !dax_can_disassociate(entry)))
>  		goto out;
>  	dax_disassociate_entry(entry, mapping, trunc);
>  	xas_store(&xas, NULL);
> @@ -1017,7 +1040,8 @@ void dax_break_layout_final(struct inode *inode)
>  EXPORT_SYMBOL_GPL(dax_break_layout_final);
>  
>  /*
> - * Invalidate DAX entry if it is clean.
> + * Invalidate DAX entry if it is clean and dropping it would not release a folio
> + * that is still in use.
>   */
>  int dax_invalidate_mapping_entry_sync(struct address_space *mapping,
>  				      pgoff_t index)
> diff --git a/mm/truncate.c b/mm/truncate.c
> index 9e9bf029635cf..b03cd99c4bba8 100644
> --- a/mm/truncate.c
> +++ b/mm/truncate.c
> @@ -732,6 +732,15 @@ int invalidate_inode_pages2_range(struct address_space *mapping,
>  	if (mapping_empty(mapping))
>  		return 0;
>  
> +	/*
> +	 * Invalidating a DAX entry can release its folio, so unmap DAX entries
> +	 * before invalidating them. dax_invalidate_mapping_entry_sync() skips
> +	 * the last association of a folio that still has references, e.g.
> +	 * because it was faulted in again in the meantime.
> +	 */
> +	if (dax_mapping(mapping))
> +		unmap_mapping_pages(mapping, start, end - start + 1, false);
> +
>  	folio_batch_init(&fbatch);
>  	index = start;
>  	while (find_get_entries(mapping, &index, end, &fbatch, indices)) {
> @@ -787,11 +796,8 @@ int invalidate_inode_pages2_range(struct address_space *mapping,
>  		cond_resched();
>  	}
>  	/*
> -	 * For DAX we invalidate page tables after invalidating page cache.  We
> -	 * could invalidate page tables while invalidating each entry however
> -	 * that would be expensive. And doing range unmapping before doesn't
> -	 * work as we have no cheap way to find whether page cache entry didn't
> -	 * get remapped later.
> +	 * For DAX, also zap the mappings that were faulted in while we were
> +	 * invalidating.
>  	 */
>  	if (dax_mapping(mapping)) {
>  		unmap_mapping_pages(mapping, start, end - start + 1, false);
> 
> ---
> base-commit: 63919467fb5239ab824de6a7a128b882055b24af
> change-id: 20261103-fix-dax-invalidate-mapped-d0c2296f5543
> 
> Best regards,
> --  
> Yan, Zi
> 
