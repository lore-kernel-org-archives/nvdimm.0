Received: from MW6PR02CU001.outbound.protection.outlook.com (mail-westus2azon11012016.outbound.protection.outlook.com [52.101.48.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7DBBF3E5EEC;
	Wed,  5 Aug 2026 08:28:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.48.16
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785918486; cv=fail; b=lnm1BvYAXtBeo/MBJ8PDYOjllv4fD8YxverV44ocLSSH3ImvdZdjyavhOblRuHuJ7jAgwvMIbjjTdYwrnkp48J4ERyDs0VRL3ZoXZOAYHzXtgOtADT5BAZuR5iJJKw8YCEee6Z7+2L+OOTzln+OF9zvqXzMQpziBsP6drDZgxpA=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785918486; c=relaxed/simple;
	bh=/HWtMKXFuLtm8sGvnqThRhvrF68vhO8LgYKNBeAo2BA=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=jKoIEMsvywnea7qI4zbJPl0iV3tUDpYI10tsm8atWMvNzc0Aco/9JqdRWcChxu+v0aw2svmh4ITVHdBN1+vgKpDg3scJF4AqUWbGMtPL7RPiOPvFtU56Qto+JDeWV/9nSUYkyl26DyUYLI0Pv0nG4eW590wdmWrNCpPEa4aLzRE=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=Ok+CJhFY; arc=fail smtp.client-ip=52.101.48.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="Ok+CJhFY"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=YztHbbTbp4cD9x8/FB8Ajhl81yessIVzEPUgerHjQVuM0uYCrdw/4aiNwRLb6ghEP3VZQP/409jvBUwAfyeZeK4OXy+Z7XjrFh7GYtENWYP35+A9pgT7Twih2X+69QsaXdwBGzxqj7J9WGY8wzeFa+qiKtLMpPNxSzzQ+I+qTrC4E0smJ70L0CY2czBHAmYa+8vOu9tpl91Id0B6/NxLSIbrYIkrXALTkJboTfb+4FqIn/8ETrVINjyMKRLW0FU5t+tQ43mElzmvPd4/NYmtliaGmvp87POyQNNxkzys/kk2pbE5jbOESbLHB/QHvG13r6QFcaXsZ88S+3IbEAd5bg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=+IEWPhCSv0t8f4UbMWG8L9dSVBC2VuVF7EqC7EI2LnM=;
 b=aD/eJRcb9G5o2wZdhzPs7FBFnd3RiDUmhyINBu0aBHPQI0POx7n12OM7dwX40RpkxnJVKwD6nBl8hj2m0ZnE1XFZkeE400he6940wJltxKb39vKvFV3iI0WvD7fLDnJJZZe+hRySRrxdvicrSARYm1QG0WBjGlR+D14vYzkrCoe9GGuFudpKt287V4LsxRbOOi/rbk95iXWFMWT0q4S41aZAAsLss29TY9n+TuRxtD/37ZZJluXUHEEhke0IkVoErwTvIMaG99NdpkA9H9FL1lnWbeq9eoNUVtYml3bWsJgRYRRO821Jm+AW7+7bXIcgFUxF0kxrkvcJx16T3sHPtA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=+IEWPhCSv0t8f4UbMWG8L9dSVBC2VuVF7EqC7EI2LnM=;
 b=Ok+CJhFY6F+g7uubgsv4y8xpIomxCr1DqUXdp49yqfTjq2O9yipUd1usHVhKtZIlBd4scJdadA1gfnsBCWDEtwGTM6TAddxR/PK9km6zpt0d1UsQcsuA4s7oZtPl4WjKyDXu6YUY1bYwEAA6Zvj5GZnSp6x7R7rAkYvzMnfpEfY=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from PH7PR12MB5685.namprd12.prod.outlook.com (2603:10b6:510:13c::22)
 by SA1PR12MB6726.namprd12.prod.outlook.com (2603:10b6:806:255::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.270.18; Wed, 5 Aug
 2026 08:27:59 +0000
Received: from PH7PR12MB5685.namprd12.prod.outlook.com
 ([fe80::ce69:cfae:774d:a65c]) by PH7PR12MB5685.namprd12.prod.outlook.com
 ([fe80::ce69:cfae:774d:a65c%5]) with mapi id 15.21.0270.017; Wed, 5 Aug 2026
 08:27:58 +0000
Message-ID: <181b08be-04bc-4ae9-bb88-15321a82440f@amd.com>
Date: Wed, 5 Aug 2026 10:27:49 +0200
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 01/14] dma-buf: introduce initial file I/O
 infrastructure
To: Pavel Begunkov <asml.silence@gmail.com>, Jens Axboe <axboe@kernel.dk>,
 Keith Busch <kbusch@kernel.org>, Christoph Hellwig <hch@lst.de>,
 Sagi Grimberg <sagi@grimberg.me>, linux-block@vger.kernel.org,
 linux-kernel@vger.kernel.org, linux-nvme@lists.infradead.org,
 linux-fsdevel@vger.kernel.org, io-uring@vger.kernel.org,
 linux-media@vger.kernel.org, dri-devel@lists.freedesktop.org,
 linaro-mm-sig@lists.linaro.org
Cc: Alexander Viro <viro@zeniv.linux.org.uk>,
 Christian Brauner <brauner@kernel.org>,
 Andrew Morton <akpm@linux-foundation.org>,
 Sumit Semwal <sumit.semwal@linaro.org>, Nitesh Shetty
 <nj.shetty@samsung.com>, Kanchan Joshi <joshi.k@samsung.com>,
 Anuj Gupta <anuj20.g@samsung.com>, Tushar Gohad <tushar.gohad@intel.com>,
 William Power <william.power@intel.com>, Phil Cayton
 <phil.cayton@intel.com>, Jason Gunthorpe <jgg@nvidia.com>,
 Damien Le Moal <dlemoal@kernel.org>, Alasdair Kergon <agk@redhat.com>,
 Mike Snitzer <snitzer@kernel.org>, Mikulas Patocka <mpatocka@redhat.com>,
 Benjamin Marzinski <bmarzins@redhat.com>,
 Vishal Verma <vishal.l.verma@intel.com>, David Sterba <dsterba@suse.com>,
 Ilya Dryomov <idryomov@gmail.com>, dm-devel@lists.linux.dev,
 nvdimm@lists.linux.dev, linux-btrfs@vger.kernel.org,
 ceph-devel@vger.kernel.org
References: <cover.1785274111.git.asml.silence@gmail.com>
 <bc20381e8daf85ac58811c344325d8192cde9d1e.1785274111.git.asml.silence@gmail.com>
Content-Language: en-US
From: =?UTF-8?Q?Christian_K=C3=B6nig?= <christian.koenig@amd.com>
In-Reply-To: <bc20381e8daf85ac58811c344325d8192cde9d1e.1785274111.git.asml.silence@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MN2PR20CA0052.namprd20.prod.outlook.com
 (2603:10b6:208:235::21) To PH7PR12MB5685.namprd12.prod.outlook.com
 (2603:10b6:510:13c::22)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH7PR12MB5685:EE_|SA1PR12MB6726:EE_
X-MS-Office365-Filtering-Correlation-Id: 1f93b8f1-d756-437c-adac-08def2cb74da
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|23010399003|366016|376014|7416014|1800799024|921020|6133799003|56012099006|11063799006|10067099003|4143699003|18002099003|22082099003;
X-Microsoft-Antispam-Message-Info:
	NlI6l0j8r8SFGGyjC0EiOp6OJ0S4sz9jDfB+FqZc/Ie/MVMzKeHEFKKxw0W7y/7ho661lUpuqwNdkf1WFgJu0YI7bUd7sMVKuG5qd3TFvDiXDU4e1tnTzd+goNkB5Scg3Xq9fVIRCS3aNZ9ksY6GdMkbNnKuw5nAKdTrp+EA42nr/TKGgjAapuL/Pm3m1ULBhtcakkH9PDmumFIoqQFRJzRZ0xD/kGiXtCBBaLo9Ne/tE1Eia91KQQMLTyjGLghoK6JeiAUYYAwubPmpvzPZc8TvD5214NLpxdIg8PidzKWc9QSo15jiyuNXVs5RnAJPBb+Z8br5+0euYX9XSzEXXtwXHFpHuzjilS5zQvlzb1UyuRkbqRsd0ZlMboCqH5OG16LNQb/Sd4YoI/1ZS6BOvXSTonNgwEPSClKJZZxYEheJxqI0KtWr8zIa9YwV5GgJZa/m3PpA2aANO3UiaeIVimF/gts8+oXGdWpK+3Ft2Jrn3uHk+CMQrLER3B4x46iLr4Fbr9Y4/bbd9qVmjwWoVBJX7VUAPQrnB2nSeIhHd6V18PFMQRqcHi4Ux5IgGGdd4WFdA+zD4FqdmAqTAmWv1VAhQR1uNGq5ZQ+R+XyNhw8OJmnfz51KxSF7wXsXXaxgi6L8r5Q7XPvzHbmvDWozuPRo0rMLBGoEv1h5Y9dsi0l+hpuqpdWOuhISQB8bOuQvHFCvrDzhyX8urOAupav1OA==
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH7PR12MB5685.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(23010399003)(366016)(376014)(7416014)(1800799024)(921020)(6133799003)(56012099006)(11063799006)(10067099003)(4143699003)(18002099003)(22082099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?eWlvWGRVeTBkd1Rab1NKRnRRQ2pEWFhvS2pLUUY3aUVIVjlxSGJIMTBtWmY4?=
 =?utf-8?B?ZTJkTDNtMkpQNFNpSVM2Tm4yVU1WQkN6S1Y0V2JKOXlOaWh5aWR5WFRnSGEr?=
 =?utf-8?B?TFNSU1g0WUhISTFxcG8vRTJTSytuR1hLd29raEZ3ajNCSWVFS0dRVEFuS0Uy?=
 =?utf-8?B?ZS9HTGQxVHd2SEcrZjF2TTZpVTJNUUx6WEo1WVpEWW51NUpZS3ZVYy9zczBN?=
 =?utf-8?B?bC9NZlkrYXlkeFF4VkNlbTZWR0EvZWhxY0JDZlZLYmxnRlBIa3J0L3YrRU1T?=
 =?utf-8?B?MWdXcTNjREQxYkFQczQyUUJPT28yRmZzOUdNMDlVb3VOSzhXaUsxY0MvWGQ1?=
 =?utf-8?B?ZzRtdUpYeG9ua1ZCYjY4eHk0NnRRWGFnSFpsSDBpK2daQTNJanMreVljeW5Y?=
 =?utf-8?B?Z0Y2N1dnck9yTDVBYjBGYUVvamptV21EeWIvRHFuTVJiUjZuK1pEanVnQ1hs?=
 =?utf-8?B?QnVRdy80S0lITzBadjY3ekNQMkRmYzlIUVZPUEc4MWJMWnZNMFdEbGlacDhG?=
 =?utf-8?B?b2ltU2xYMWh5T2VnamJ2d0haa2c3V3pQZWRqTW40MklNM1RpUjNXK2ZhZW9h?=
 =?utf-8?B?dExRVGtBSlg1MVlNMnA3anQvOHBTT0lnNDllQjFLSk9jMUVDTldseFBzcHNT?=
 =?utf-8?B?UkdiYXlrMnRKQ21jUU53ZjRXNkdQV1RBRlZqWHpoN3o5Y2hDUUVGb0JKRzE2?=
 =?utf-8?B?b0ZCalRvTHBCUUtjc2RxQU1mckhyMWpKYjl4ZkdaQmlYU0J0N2tLT2NtK25P?=
 =?utf-8?B?QkxvSlR4Ump4TVhRS00zd2wyUlZTOUZkSllOZ1pha25kSkdzcHpHaWowSFZ1?=
 =?utf-8?B?MEp2a0hsU3JSK1pHSkx2cFFkbGRUTTdPZkU0MVBPNWV3VU5abVBXVVBKSDNH?=
 =?utf-8?B?R3paRHpSWXRuS3lZWXFOV1dSR04wVTBEYjlibUpDdXRDQnJUQ0d0bExiR2xy?=
 =?utf-8?B?Q21lU1c3OFJFNng2VUR2Z3lKdlVJU3ZNTDg3VjgzMUM5RUlDUGlPZit3cTBh?=
 =?utf-8?B?YkRqSXZmNjVJT2ZnSGlPREYrSmZ3dGc1cmM4bk1hZWdrVEhxeHhEZk41MzFx?=
 =?utf-8?B?MEpaTXJ3R0pxeVUySXpYREhpVXlGcVVqbmN0eGx2ay8yV3MwYmlWaEM0cWY4?=
 =?utf-8?B?TC9HTTN4UVBYMmNObml5UlRYOGdWVzlpcVdKSlBicHE2a05xU2ErcWVMN2Y1?=
 =?utf-8?B?WTZXRVBiZDFESmhMVHVadmdOR2FYTFE5Si9FYkZLYTZYQXRFQnFmdTZid1Rk?=
 =?utf-8?B?dTJKR3gzWmQ4bi9ESW5vTmhDMDMzRHRZU1lLTGZsSjZCb3Z5VWlFSDJMNy9q?=
 =?utf-8?B?SE5MQ0IveWtSTTcySVJZOEE1RExYK29zaEtzUDFKZkd5MUVEajFnYTFoY0NF?=
 =?utf-8?B?SjFNd1YrOW9memRGZC9rNXZKNDBXMVdJc00xRjFic1NIemNPWlc4dE5iT3lw?=
 =?utf-8?B?ZU1kQld1elJWWXdRVGIrTVhxRzlzdWxyaXUwSmRFYk5qNWtwVWE0c3JncEpl?=
 =?utf-8?B?WUVTUHpZRDllQmZBVTJJUGRxT0NtNG04WDh3MWdEZHR6UDQ0ZWtBNFJlWXBw?=
 =?utf-8?B?WEVFUXJ4UEdjM1JmNmxpU0cvVlV5SllYbmg1Ym5KdytNZ09DL0djc0xSd2pz?=
 =?utf-8?B?ZUlXaVQ1NnJCNi94U2dFbFpXTnljUG9OWkk0MjI2OC9BUkhSNFlHS0ZqT25j?=
 =?utf-8?B?eisyMGxtQUU4SmNFNWtqMk5PaW9FYW93R2R2dkE5eFNSZ2thZThxaTRqVzRG?=
 =?utf-8?B?ZHI5MS9uNzAvOEs0YkxPbUxkeHZMdVN5Zk9nK1J4Lzg0d3ovYzFXWkpSRUxZ?=
 =?utf-8?B?bGY4Sy84VytBQ0JRWU83WkFZOTZ4MXh1TjFCK0t2dkNqTEpxWUFlUlM2Rzdh?=
 =?utf-8?B?bnlrcGc0R1hRRFNtK2o0dDhLMWEyeXh0YTZ3N2drVDFITkx4WU5xZHgxY2ww?=
 =?utf-8?B?YkQ5R0RIK1dUZUZpZUJ1eU5ob0czeWZzV3hvdHAvMGViby9WZ2wwelI4WTVn?=
 =?utf-8?B?cmVhVURTa2RocTdCaTdPMThhN0YwVW1YaElhcS90djVvekFpMG9aTDZFdExV?=
 =?utf-8?B?ZnBsOXArN2pybmlmRC9ESE4rQVd5NkJkNnZucXJyZS8yR1ZYSERYMzRMd21v?=
 =?utf-8?B?ajdFZmhFWkZIT0x3SXRaMFVOTFYyYm9QSEFmWm15N0lHbkR2TW5JYjllTDF2?=
 =?utf-8?B?blA5NEM4alZUWjdreEFpNWR0VktjVHhydDlQdTJuZXVNZUhKNUFxa2pLRDJk?=
 =?utf-8?B?N3hYcWNncUhGc3JiN1hpTCswMXV3eWZmQytCMUFKakMwd2FIdDJWbWdYRWVz?=
 =?utf-8?Q?OawAQnETBfZQBeViUm?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1f93b8f1-d756-437c-adac-08def2cb74da
X-MS-Exchange-CrossTenant-AuthSource: PH7PR12MB5685.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Aug 2026 08:27:58.7722
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: xku7HjA4Bk+e0FzLW+Sqwl2taIhlR9rxULNdrx8vQl7oDqvoTCKcnG16x5DpSSyC
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR12MB6726

On 7/28/26 23:29, Pavel Begunkov wrote:
> The goal is to be able to natively use dma-buf in the read-write / IO
> path. This patch adds basic building blocks serving as a glue and API
> between drivers and upper layer subsystems providing the uAPI. Later
> patches implement it for NVMe raw block devices and expose it to the
> user space via io_uring.
> 
> There are two main objects. struct dma_buf_io_ctx and struct
> dma_buf_io_map. The ctx is used during initial registration and serves
> as an interface between the upper layer user like io_uring and to the
> importer subsystem / driver. The map represents the actual dma map
> established for the target device[s] with dma_buf_map_attachment() and
> stored in a device specific format. The context is created via a new
> file operation ->init_dma_buf_io_ctx.
> 
> The ctx-map separation exists to support map invalidation (see
> dma_buf_io_invalidate_mappings()). A ctx can create
> multiple maps during its lifetime, but there can only be no more than
> one (active) map attached to it. Invalidation drops the active map
> if present, and the next map will only be attempted to be created
> once there is a new request that wants to use the dma-buf IO ctx.
> 
> The primary task of the dma_buf_io_map object is to count requests
> using it and to wait for their completion when we want to destroy the
> DMA map. Invalidation is delayed by inserting a dma fence, which is
> signaled when all flight requests are completed.
> 
> [un]mapping and any work with dma addresses is delegated to the
> importer driver via an ops table stored in the ctx, see struct
> dma_buf_io_ops. Only the target driver / subsystem knows about devices
> it wants to use the dma-buf with, especially in case of multi-device
> filesystems or stacking in the future.
> 
> Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
> ---
>  drivers/dma-buf/Makefile     |   2 +-
>  drivers/dma-buf/dma-buf-io.c | 275 +++++++++++++++++++++++++++++++++++
>  include/linux/dma-buf-io.h   |  91 ++++++++++++
>  include/linux/fs.h           |   2 +
>  4 files changed, 369 insertions(+), 1 deletion(-)
>  create mode 100644 drivers/dma-buf/dma-buf-io.c
>  create mode 100644 include/linux/dma-buf-io.h
> 
> diff --git a/drivers/dma-buf/Makefile b/drivers/dma-buf/Makefile
> index b25d7550bacf..523731b0f83e 100644
> --- a/drivers/dma-buf/Makefile
> +++ b/drivers/dma-buf/Makefile
> @@ -1,6 +1,6 @@
>  # SPDX-License-Identifier: GPL-2.0-only
>  obj-y := dma-buf.o dma-fence.o dma-fence-array.o dma-fence-chain.o \
> -	 dma-fence-unwrap.o dma-resv.o dma-buf-mapping.o
> +	 dma-fence-unwrap.o dma-resv.o dma-buf-mapping.o dma-buf-io.o
>  obj-$(CONFIG_DMABUF_HEAPS)	+= dma-heap.o
>  obj-$(CONFIG_DMABUF_HEAPS)	+= heaps/
>  obj-$(CONFIG_SYNC_FILE)		+= sync_file.o
> diff --git a/drivers/dma-buf/dma-buf-io.c b/drivers/dma-buf/dma-buf-io.c
> new file mode 100644
> index 000000000000..5f545a1bcf32
> --- /dev/null
> +++ b/drivers/dma-buf/dma-buf-io.c
> @@ -0,0 +1,275 @@
> +/* SPDX-License-Identifier: GPL-2.0 */
> +/*
> + * Common infrastructure for supporing dma-buf in the I/O path.
> + *
> + * Copyright (C) 2026 Pavel Begunkov <asml.silence@gmail.com>
> + */
> +#include <linux/dma-buf-io.h>
> +#include <linux/dma-resv.h>
> +
> +struct dma_buf_io_fence {
> +	struct dma_fence base;
> +	spinlock_t lock;
> +};

Upstream has change to allow embedding the spinlock into the dma_fence, so this structure here is most likely not necessary any more.

> +
> +static const char *dma_buf_io_fence_drv_name(struct dma_fence *fence)
> +{
> +	/* default fence release kfree's the base pointer */
> +	BUILD_BUG_ON(offsetof(struct dma_buf_io_fence, base));
> +
> +	return "dma-buf-io-ctx";
> +}
> +
> +static const char *dma_buf_io_fence_timeline_name(struct dma_fence *fence)
> +{
> +	return "dma-buf-io-ctx";
> +}
> +
> +const struct dma_fence_ops dma_buf_io_fence_ops = {
> +	.get_driver_name = dma_buf_io_fence_drv_name,
> +	.get_timeline_name = dma_buf_io_fence_timeline_name,
> +};
> +
> +static void dma_buf_io_ctx_destroy_work(struct work_struct *work)
> +{
> +	struct dma_buf_io_ctx *ctx = container_of(work, struct dma_buf_io_ctx,
> +						  release_work);
> +
> +	if (WARN_ON_ONCE(refcount_read(&ctx->refs)))
> +		return;
> +
> +	ctx->dev_ops->release(ctx);
> +	dma_buf_put(ctx->dmabuf);
> +	kfree(ctx);
> +}
> +
> +static void dma_buf_io_map_release_work(struct work_struct *work)
> +{
> +	struct dma_buf_io_map *map = container_of(work, struct dma_buf_io_map,
> +						  release_work);
> +	struct dma_buf_io_fence *fence = map->fence;
> +	struct dma_buf_io_ctx *ctx = map->ctx;
> +	struct dma_buf *dmabuf = ctx->dmabuf;
> +
> +	/* the release path must wait for fences */
> +	if (WARN_ON_ONCE(refcount_read(&ctx->refs) == 0))
> +		return;

Stuff like that is usually illegal.

And why are you using refcount directly instead of kref?

> +
> +	/* Prevent from destoying the ctx while unmapping */
> +	refcount_inc(&ctx->refs);

> +
> +	/*
> +	 * There are no more requests using the map, we can signal the fence.
> +	 * It should be done before taking the resv lock as someone could be
> +	 * waiting for the fence while holding the lock.
> +	 */
> +	dma_fence_signal(&fence->base);

Signaling fences has a whole bunch of very strict rules associated with it. E.g. you can't alocate memory for example.

Are you sure you actually need and want a dma_fence here?

> +
> +	dma_resv_lock(dmabuf->resv, NULL);
> +	ctx->dev_ops->unmap(ctx, map);
> +	dma_resv_unlock(dmabuf->resv);
> +
> +	dma_fence_put(&fence->base);

You should probably set map->fence to NULL after that.

> +	percpu_ref_exit(&map->refs);
> +	kfree(map);
> +
> +	if (refcount_dec_and_test(&ctx->refs)) {
> +		/*
> +		 * Destruction needs to wait for I/O and dma fences. Defer it to
> +		 * simplify locking.
> +		 */
> +		INIT_WORK(&ctx->release_work, dma_buf_io_ctx_destroy_work);
> +		queue_work(system_wq, &ctx->release_work);
> +	}
> +}
> +
> +static void dma_buf_io_map_refs_release(struct percpu_ref *ref)
> +{
> +	struct dma_buf_io_map *map = container_of(ref, struct dma_buf_io_map, refs);
> +
> +	/* might sleep, use a worker */
> +	INIT_WORK(&map->release_work, dma_buf_io_map_release_work);
> +	queue_work(system_wq, &map->release_work);
> +}
> +
> +int dma_buf_io_init_map(struct dma_buf_io_ctx *ctx, struct dma_buf_io_map *map)
> +{
> +	struct dma_buf_io_fence *fence = NULL;
> +	int ret;
> +
> +	fence = kzalloc(sizeof(*fence), GFP_KERNEL);
> +	if (!fence)
> +		return -ENOMEM;
> +
> +	ret = percpu_ref_init(&map->refs, dma_buf_io_map_refs_release, 0, GFP_KERNEL);
> +	if (ret) {
> +		kfree(fence);
> +		return ret;
> +	}
> +
> +	spin_lock_init(&fence->lock);
> +	dma_fence_init(&fence->base, &dma_buf_io_fence_ops, &fence->lock,
> +			ctx->fence_ctx, atomic_inc_return(&ctx->fence_seq));
> +	map->fence = fence;
> +	map->ctx = ctx;
> +	return 0;
> +}
> +EXPORT_SYMBOL_NS_GPL(dma_buf_io_init_map, "DMA_BUF");
> +
> +struct dma_buf_io_map *dma_buf_io_create_map(struct dma_buf_io_ctx *ctx)
> +{
> +	struct dma_buf *dmabuf = ctx->dmabuf;
> +	struct dma_buf_io_map *map;
> +	long ret;
> +
> +retry:
> +	/*
> +	 * ->dmabuf_map() will be calling dma_buf_map_attachment(), for which
> +	 * we'll need to wait for fences. Do a bit nicer and try to wait
> +	 * without the resv lock first.
> +	 */

Clear NAK to that. Always wait while holding the resv lock if you can!

It is absolutely not beneficial to do this outside of the lock and usually just hides problems instead and prevent fixing them.

> +	ret = dma_resv_wait_timeout(dmabuf->resv, DMA_RESV_USAGE_KERNEL,
> +				    true, MAX_SCHEDULE_TIMEOUT);
> +	if (!ret)
> +		ret = -EAGAIN;
> +	if (ret < 0)
> +		return ERR_PTR(ret);
> +
> +	ret = dma_resv_lock_interruptible(dmabuf->resv, NULL);
> +	if (ret)
> +		return ERR_PTR(ret);
> +
> +	map = dma_buf_io_get_map(ctx);
> +	if (map) {
> +		ret = 0;
> +		goto out;
> +	}
> +
> +	if (dma_resv_wait_timeout(dmabuf->resv, DMA_RESV_USAGE_KERNEL,
> +				  true, 0) < 0) {
> +		dma_resv_unlock(dmabuf->resv);
> +		goto retry;
> +	}
> +
> +	map = ctx->dev_ops->map(ctx);
> +	if (IS_ERR(map)) {
> +		ret = PTR_ERR(map);
> +		goto out;
> +	}
> +
> +	percpu_ref_get(&map->refs);
> +	rcu_assign_pointer(ctx->map, map);
> +out:
> +	dma_resv_unlock(dmabuf->resv);
> +	if (ret < 0)
> +		return ERR_PTR(ret);
> +	return map;
> +}
> +
> +static void dma_buf_io_drop_map(struct dma_buf_io_ctx *ctx)
> +{
> +	struct dma_buf *dmabuf = ctx->dmabuf;
> +	struct dma_buf_io_map *map;
> +	int ret;
> +
> +	dma_resv_assert_held(dmabuf->resv);
> +
> +	map = rcu_dereference_protected(ctx->map,
> +					dma_resv_held(dmabuf->resv));
> +	if (!map)
> +		return;
> +	rcu_assign_pointer(ctx->map, NULL);
> +


> +	ret = dma_resv_reserve_fences(dmabuf->resv, 1);
> +	if (WARN_ON_ONCE(ret)) {
> +		struct dma_fence *fence = &map->fence->base;
> +
> +		dma_fence_get(fence);
> +		percpu_ref_kill(&map->refs);
> +		dma_fence_wait(fence, false);
> +		dma_fence_put(fence);
> +		return;
> +	}
> +
> +	dma_resv_add_fence(dmabuf->resv, &map->fence->base,
> +			   DMA_RESV_USAGE_KERNEL);

That sequence is clearly incorrect!

The fence must be created after dma_resv_reserve_fences(), otherwise you definately have an illegal memory operation here.

Regards,
Christian.

> +	/*
> +	 * Delay destruction until all inflight requests using the map arefence->
> +	 * gone. It'll also signal the fence then.
> +	 */
> +	percpu_ref_kill(&map->refs);
> +}
> +
> +void dma_buf_io_invalidate_mappings(struct dma_buf_io_ctx *ctx)
> +{
> +	dma_buf_io_drop_map(ctx);
> +}
> +EXPORT_SYMBOL_NS_GPL(dma_buf_io_invalidate_mappings, "DMA_BUF");
> +
> +static void dma_buf_io_ctx_release_work(struct work_struct *work)
> +{
> +	struct dma_buf_io_ctx *ctx = container_of(work, struct dma_buf_io_ctx,
> +						  release_work);
> +	struct dma_buf *dmabuf = ctx->dmabuf;
> +	long ret;
> +
> +	dma_resv_lock(dmabuf->resv, NULL);
> +	/* Remove the last map, there should be no new ones going forward. */
> +	dma_buf_io_drop_map(ctx);
> +	dma_resv_unlock(dmabuf->resv);
> +
> +	/* Wait until all maps are destroyed. */
> +	ret = dma_resv_wait_timeout(dmabuf->resv, DMA_RESV_USAGE_KERNEL,
> +				    false, MAX_SCHEDULE_TIMEOUT);
> +
> +	if (WARN_ON_ONCE(ret <= 0))
> +		return;
> +	if (WARN_ON_ONCE(rcu_dereference_protected(ctx->map, true)))
> +		return;
> +
> +	if (refcount_dec_and_test(&ctx->refs))
> +		dma_buf_io_ctx_destroy_work(&ctx->release_work);
> +}
> +
> +void dma_buf_io_ctx_release(struct dma_buf_io_ctx *ctx)
> +{
> +	/*
> +	 * Destruction needs to wait for I/O and dma fences. Defer it to
> +	 * simplify locking.
> +	 */
> +	INIT_WORK(&ctx->release_work, dma_buf_io_ctx_release_work);
> +	queue_work(system_wq, &ctx->release_work);
> +}
> +
> +int dma_buf_io_ctx_create(struct file *file,
> +			   struct dma_buf_io_ctx *ctx,
> +			   struct dma_buf *dmabuf,
> +			   enum dma_data_direction dir)
> +{
> +	int ret;
> +
> +	if (!file->f_op->init_dma_buf_io_ctx)
> +		return -EOPNOTSUPP;
> +
> +	memset(ctx, 0, sizeof(*ctx));
> +	ctx->fence_ctx = dma_fence_context_alloc(1);
> +	ctx->dir = dir;
> +	ctx->dmabuf = dmabuf;
> +	refcount_set(&ctx->refs, 1);
> +	get_dma_buf(dmabuf);
> +
> +	ret = file->f_op->init_dma_buf_io_ctx(file, ctx);
> +	if (ret) {
> +		memset(ctx, 0, sizeof(*ctx));
> +		dma_buf_put(dmabuf);
> +		return ret;
> +	}
> +
> +	if (WARN_ON_ONCE(!ctx->dev_ops ||
> +			 !ctx->dev_ops->map ||
> +			 !ctx->dev_ops->unmap ||
> +			 !ctx->dev_ops->release))
> +		return -EINVAL;
> +
> +	return ret;
> +}
> diff --git a/include/linux/dma-buf-io.h b/include/linux/dma-buf-io.h
> new file mode 100644
> index 000000000000..bcffc6202556
> --- /dev/null
> +++ b/include/linux/dma-buf-io.h
> @@ -0,0 +1,91 @@
> +/* SPDX-License-Identifier: GPL-2.0 */
> +#ifndef __DMA_BUF_IO_H__
> +#define __DMA_BUF_IO_H__
> +
> +#include <linux/dma-buf.h>
> +
> +struct dma_buf_io_fence;
> +struct dma_buf_io_ctx;
> +struct dma_buf_io_map;
> +
> +struct dma_buf_io_ops {
> +	/*
> +	 * Create a new map for the given ctx. Called with the reservation
> +	 * lock held.
> +	 */
> +	struct dma_buf_io_map *(*map)(struct dma_buf_io_ctx *ctx);
> +
> +	/*
> +	 * Clean up device specific parts of the @map. Called with the
> +	 * reservation lock held.
> +	 */
> +	void (*unmap)(struct dma_buf_io_ctx *ctx, struct dma_buf_io_map *map);
> +
> +	/*
> +	 * The user tries to destroy the ctx. Release all device specific
> +	 * parts of the token.
> +	 */
> +	void (*release)(struct dma_buf_io_ctx *);
> +};
> +
> +struct dma_buf_io_map {
> +	/*
> +	 * Counts attached requests and other users. Device specific unmapping
> +	 * is deferred until all refs are dropped.
> +	 */
> +	struct percpu_ref		refs;
> +
> +	struct work_struct		release_work;
> +	struct dma_buf_io_fence		*fence;
> +	struct dma_buf_io_ctx		*ctx;
> +};
> +
> +struct dma_buf_io_ctx {
> +	struct dma_buf_io_map __rcu		*map;
> +	struct dma_buf				*dmabuf;
> +	enum dma_data_direction			dir;
> +
> +	atomic_t				fence_seq;
> +	u64					fence_ctx;
> +	struct work_struct			release_work;
> +	refcount_t				refs;
> +
> +	void					*dev_priv;
> +	const struct dma_buf_io_ops		*dev_ops;
> +};
> +
> +int dma_buf_io_ctx_create(struct file *file,
> +			   struct dma_buf_io_ctx *ctx,
> +			   struct dma_buf *dmabuf,
> +			   enum dma_data_direction dir);
> +void dma_buf_io_ctx_release(struct dma_buf_io_ctx *ctx);
> +
> +struct dma_buf_io_map *dma_buf_io_create_map(struct dma_buf_io_ctx *ctx);
> +
> +static inline struct dma_buf_io_map *
> +dma_buf_io_get_map(struct dma_buf_io_ctx *ctx)
> +{
> +	struct dma_buf_io_map *map;
> +
> +	guard(rcu)();
> +
> +	map = rcu_dereference(ctx->map);
> +	if (unlikely(!map || !percpu_ref_tryget_live_rcu(&map->refs)))
> +		return NULL;
> +
> +	return map;
> +}
> +
> +static inline void dma_buf_io_map_drop(struct dma_buf_io_map *map)
> +{
> +	percpu_ref_put(&map->refs);
> +}
> +
> +/*
> + * Device API
> + */
> +
> +void dma_buf_io_invalidate_mappings(struct dma_buf_io_ctx *ctx);
> +int dma_buf_io_init_map(struct dma_buf_io_ctx *ctx, struct dma_buf_io_map *map);
> +
> +#endif
> diff --git a/include/linux/fs.h b/include/linux/fs.h
> index d10897b3a1e3..9fe349a279c7 100644
> --- a/include/linux/fs.h
> +++ b/include/linux/fs.h
> @@ -1914,6 +1914,7 @@ struct dir_context {
>  #define COPY_FILE_SPLICE		(1 << 0)
>  
>  struct io_uring_cmd;
> +struct dma_buf_io_ctx;
>  struct offset_ctx;
>  
>  typedef unsigned int __bitwise fop_flags_t;
> @@ -1962,6 +1963,7 @@ struct file_operations {
>  	int (*uring_cmd_iopoll)(struct io_uring_cmd *, struct io_comp_batch *,
>  				unsigned int poll_flags);
>  	int (*mmap_prepare)(struct vm_area_desc *);
> +	int (*init_dma_buf_io_ctx)(struct file *, struct dma_buf_io_ctx *);
>  } __randomize_layout;
>  
>  /* Supports async buffered reads */

