Received: from CY3PR05CU001.outbound.protection.outlook.com (mail-westcentralusazon11013049.outbound.protection.outlook.com [40.93.201.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 79D6C3D667D;
	Thu,  6 Aug 2026 07:30:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.93.201.49
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786001401; cv=fail; b=e4pNja8i3C3yCfCdBmTZ7G89fan7z9kcEE40RXC0kDV41DwuDSuEYBV3ZuHtrTV91vgCKW22H51xQmuNjZbmGb2LTVKPTABEz9mjsif82UrTC71rA0Rrpk/PICrln1hcl482NjDCxEW6OI/SQkZGwI/pR4TFQR8BjpRKVS68ae8=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786001401; c=relaxed/simple;
	bh=tXCg9XS5qaZWsZT+Mfkw1K9bmOhdA//5snvEcFJYCNI=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=VEFzBr+IpfV56wXo64QZASDl3v92X0es2eukoRn+U+Jmme1BnFldjGjLFv9fcQrW+IFObMsoSiDOnu5XGQqv545gyFuEL/sURM5AjScQyZnTRoyfpfNd+ozWdbvKC5QTnR58+IgFX5GJ7cnVtIXDX3FboU2lv3iHQ5xvTalv/gU=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=1RY7idE2; arc=fail smtp.client-ip=40.93.201.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="1RY7idE2"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=a/T3sXza7qZj4Z3keDUpip1lIb7/VE5CHRt3Ub+fmesZxo0ezAahf81poijajiEq19h+g97paMTKHluZyFZkPKx2tN5w5XRHRlwSJVVwy+ErYCS/R+nBnr6YOFHnDhJod/ML/dwWelnS64BeIZfb3t0g+o76nxhdEG8Gbx8LxmnmzCdum+W3pbDPI+MruCg64K32i2cbkqpnqldxKxQDI0fXL8T2lR4FoFao+0cpVFy+Hynlkh1zaracnZ3HK+5ntOXjufg5tyVybJLGZ+KM+RsoSZiZWEWRQWQ0KIjkL2G5hfHmnrjv6XwOp+5UwJamOS0Dneo1H94gcVPSGUUnfg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=2Qjx11DI63SXND0MN48iCUVVhUe2PqkhXolIVCSP95U=;
 b=UDGZX8mUyCMl8QrXBIr+WqENpo+Es4GEBVyJFEm42QCFGIMf2U8E88UmNubfulvEMadI84Grsv+Tly1OtEc/cJ12sEF7rbozLNrkgb7QsSRoNUmixWxVVSGtMi8x6jRE1X1XHdM0hQz4RTJrJo8cOIUdG5zzZ/UBUi4jzHPDW0SRu1Dwd+mCCICG9eBX4VR20RhBGCCLegO/xHAY8Dvu7LEqFzE6Nfvb5G7+sGv9rSJtc+eCtKqcnLoKHj4uEJQZC+amUF/QGbA3S5AUW8aJuHwdSvOFOKASmgT4l3SlTFc8FjL+uBWOiqZY3v/6Hsqt10jup5rB5r4ePE8Rzcs4/w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=2Qjx11DI63SXND0MN48iCUVVhUe2PqkhXolIVCSP95U=;
 b=1RY7idE2kt4H5eYA5aES2QQsQgIW2X1cB1usWgjr0aUnlBLzfOeU2n+WsIPGQrJn+QAwtbr2cX53i/Q59AEuZkX7u5DL+K5j5RygLSGO1Et6GYcMs/9UmI8YIGFPNP0UJQXY6yvVBgVHMT8kY4kPOQRLZuHk58TIdSVdQQcIh54=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from SJ0PR12MB5673.namprd12.prod.outlook.com (2603:10b6:a03:42b::13)
 by SJ1PR12MB6051.namprd12.prod.outlook.com (2603:10b6:a03:48a::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.292.19; Thu, 6 Aug
 2026 07:29:54 +0000
Received: from SJ0PR12MB5673.namprd12.prod.outlook.com
 ([fe80::c3e5:48f8:beb6:ea68]) by SJ0PR12MB5673.namprd12.prod.outlook.com
 ([fe80::c3e5:48f8:beb6:ea68%6]) with mapi id 15.21.0292.019; Thu, 6 Aug 2026
 07:29:54 +0000
Message-ID: <0113c49a-a364-4df6-9ab4-681c789d9d3b@amd.com>
Date: Thu, 6 Aug 2026 09:29:44 +0200
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
 <181b08be-04bc-4ae9-bb88-15321a82440f@amd.com>
 <8285ede8-bebb-403a-8a37-b9987cd37a8f@gmail.com>
Content-Language: en-US
From: =?UTF-8?Q?Christian_K=C3=B6nig?= <christian.koenig@amd.com>
In-Reply-To: <8285ede8-bebb-403a-8a37-b9987cd37a8f@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: FR3P281CA0126.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:94::16) To SJ0PR12MB5673.namprd12.prod.outlook.com
 (2603:10b6:a03:42b::13)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ0PR12MB5673:EE_|SJ1PR12MB6051:EE_
X-MS-Office365-Filtering-Correlation-Id: 19859351-ec84-4a37-34c5-08def38c81f4
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|23010399003|376014|7416014|366016|1800799024|921020|6133799003|10067099003|11063799006|56012099006|4143699003|18002099003|22082099003;
X-Microsoft-Antispam-Message-Info:
	Yc3bxCpz0fVdIn4oqVkLPoXqYLnpztat74wkptBOCBJ2KvX811trvuyYRWPeLq2Ls7aMXOwOFhzr6QK7mif+HTXlhuUPorO6Hiuqm53miJJw8vysjDODMIrkTBJfF4GI1/g6ULmnOYjdu1dJcsjgTJJrbfDZRHzQJyLNpyYsdEhC6PIdhskriA1i7MyJt5dr+dnX1g3neMbUsNS0lth2XXFuKmxkLDupKhym9mC8lfCr5cBt+gaKWwUyM9CQH7e5hV8TnM0ykmHk8hbJmfy/xQNzfSv0wetWYfWgBEm7lvtQslmZx5REcfrD5mfJmIsv9jg5YC67bT8BTLM+aQNV1v65T/O31efZErD5S52YLurdMsq+QmzkrMhdwfGiyBypgy32MtteLYI9FUd7wJgeOGijXhL6pAl/q3gFeOPA4G0MJ07y2cIyjcaA1EQZrcDeKNeWxJVD+VcxDSKQPEff24IMq1dcN28vgFXv3ZC5y4dSjkyOO9YNK1H9oSP7UgU33R5ZMCITLQa8YcPupUxy4LQsCyODLRW5ZqFgshG9b11SE+wVpCv/B+5zclxHIbjvBrhUegFJOoGE4VPtskeiKswfLhY628C/jnHMucnUXdavUIKkRO8efuEmQXULgf9wEf+Yl1euYiPwNtnyQa5x2D+tFGOmuxurIfvcujW+0b2FCdi28VgI+irFG5Q8SSEoEZzLeHzHF2TNNK1fw/OvNg==
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ0PR12MB5673.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(23010399003)(376014)(7416014)(366016)(1800799024)(921020)(6133799003)(10067099003)(11063799006)(56012099006)(4143699003)(18002099003)(22082099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?U3Z3WjZyM2lxeXUxQnplNVpJMm4xUjFxZmxKS2owSzdRZTZReHZuWStrVlAw?=
 =?utf-8?B?bzhXM3ZRZGgzUG9mYjBXbmg0YUE5aTNWZDZWVEF4Q3l1eDJYcWlySTdGclV1?=
 =?utf-8?B?T3NsY3NQMmp3aDl4L0dPak55M1pIYjl4NFJ6S0IzTTBmVHIwcmRFSmR5Yzk1?=
 =?utf-8?B?elp3QWJkNk9RcXhQcXhpY0xKQXdRZ3BXUDR6eEkrVXlhaGFSOXlJQk9oZ2do?=
 =?utf-8?B?SmhuZENYWWkwcWFiUzg0M3JSNjhWdEhiRFlyZWZMWk5ZTjkxeVMya2RKcWd6?=
 =?utf-8?B?ZzA4S05DVVZGN09yN3AvRUZwdEgzUlQyanBsaGlLSHR5cmZTWFc2Nzg5ZXA5?=
 =?utf-8?B?dnphYy9FS2hTSXhnMTJDL3FnNzk1eU5sOGdNRXROTDBoMCszc3FMcE44ZlFT?=
 =?utf-8?B?OGo4WllTQThjbC8xQjBGVnBKTlRBM0hIVDlBN1k1Mi9jUmNZckIyVlVuVGpD?=
 =?utf-8?B?OUhPdDROU2Z0Z0xmb0hKLzF0MlNNajZjQUtpWDlROUtsblBmalF6Q0ZiN2Fs?=
 =?utf-8?B?V21HS0xxL0Npc2dXa3NoRUd6NGdJQ0VXUS9NaDdJekRvY1ZLaVEvRUxxMGgy?=
 =?utf-8?B?cWt5dEhlaHRocklhWWY1cHc3c2lYRFlRbGg2aGc5Z2MwaG03ZkUvNldZYm9q?=
 =?utf-8?B?MXFLY08xa2hlT1lRNGlWZEZMNkMyN1loaUQzWUk0WEExK3Y0K1VCUDduVE9E?=
 =?utf-8?B?U1B1VTFib0hsSUhVMnhTU2lXTjlMS1hURzFucHZrT2VCaW9rZC9FNEFraS9u?=
 =?utf-8?B?Q3ZKeHVHSWtHNGFGR3dyU0ErK0RXS20zK1JEYkhDL1dqdENhbytSUm5iRjl1?=
 =?utf-8?B?MnZOZkJtWlZDVE9YaGpHSFVycDk4dm95MVkxMXY3dFlwaktPbG5oTDhLajJW?=
 =?utf-8?B?bVIvQWFXMW04S3JsMDdPRXo3b1ZTWVBqSHdFM05rTnZuUGlOcmh0V2pjUXZM?=
 =?utf-8?B?UnJjZjZsSnA5dmJIOFN1R3hpanVCQXhrSGhPYWcxNC8rYlIrd083SkRSUktV?=
 =?utf-8?B?N3k1UytKajQ0OHZUQXc5SlRsUzNlNWJEYUV3MTFVT2wrWFUxam1SRnBmNVc3?=
 =?utf-8?B?NTZnNHI0ZXBwczNsdG0rMFVWRWhvaWlzdlhYa2w3Y1dmaVk1Y212ZXRnMXlK?=
 =?utf-8?B?YnpSR2NLTE45UDhZTE5RbnRPcnAvSVhCY2pHYkZMTjlETVFDV0JWd3IybXhE?=
 =?utf-8?B?TlcrclFLVzVGYVdXRFh2a2ZibjMwQlBJL1pYd2kreExpQU9UYXJ0YTNRcU8x?=
 =?utf-8?B?L0dRYXhrdmxlbUIxM0hyNVVhODNXWHY1aWVBRkd6ODJlVS9WMWozc09HRlh0?=
 =?utf-8?B?NCtvdS9md1dsT2R2bXp0R0t1OUpVYyt1eGsxNE9Qa2ZYR0JXMkplRVQ2QmtC?=
 =?utf-8?B?Y3BHVXBCb05FMXZGVUZjcU96S0ZDanpxQmxjVi9BcHg3STNwc3lpY1dVc2J2?=
 =?utf-8?B?Y25OYmREeE9CSFplSC9aQ2VtY1FReXpXcWhSU1pxaHNEOVJhbXhuMG5oT0dG?=
 =?utf-8?B?TUttUVZ2Q3ZuV25uYnhOdWtzWHJYcC8wdGRqMG83Ym1RUHplKzZOZnpzL0xT?=
 =?utf-8?B?dFpqblZqbnRvNG00ZzZtbWh2MkNUQVVVOUxNYjhkeHRBTnQ2T2x1d2g1VnZz?=
 =?utf-8?B?T3JrMkpYSGtYUXBnaUU4K2x1TmRXOFNrZ0NTcVhTZnRkT1VsblU1REFyWEQ0?=
 =?utf-8?B?Z0JCUGYraVpGSkppcU5wQnRoYllvSm9ZengrK29kNnhBcXh5RmpORmZNRmtK?=
 =?utf-8?B?TFMvaWRSUkdHNDFrbzZ0UU9Cb09lV1Zqc2UvejBqS0RUQmVidTlRMEVVY2Nw?=
 =?utf-8?B?U3JZREZDT0ZvNGRTaHdwS242SEF3RFJMeW5mQjl1Q0pTL2lXRUxPSkRyQmJ2?=
 =?utf-8?B?YnY3UXYxbkJBd3BtRlBnL25GUitoVTQ1VTBVUEhUbnR2Uk5TL1Vub0NjTklF?=
 =?utf-8?B?dW15N1U3UWllR2N1OWVWdFVhYU1hMjJxSjFFVUdlcEN1UDd0TnR0SlpTRzEx?=
 =?utf-8?B?dGt1Wkw1WFJ6NnZ2VW1BVVRHUVR0bC9mbjFXWGNRbS9PUzdqYjJKQ0RQZzBF?=
 =?utf-8?B?aFBVYUcrOEVQL0U4RHlTRkhpUDVJRnBMQ24yQ0VFQ1BoVnNrVk5TVzVFV0FK?=
 =?utf-8?B?bWE1SUVvcnU0Q2ZWeTFaVERNRThCUUpIWlFUbWsvV0pML3dLOTFJT1MzZXdi?=
 =?utf-8?B?MllJTEtaazBOWFREZytrQzFMMFFXb1RHOG5zanBiSHUvTm4rMy9zM044VHN6?=
 =?utf-8?B?d0c2WnRIak5yUEtxWnEvNmFia0NqbUtibXlTZHNQcUVCTGRZRHUxVU5VblVp?=
 =?utf-8?Q?tqE63w0M2J9CRVI3oj?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 19859351-ec84-4a37-34c5-08def38c81f4
X-MS-Exchange-CrossTenant-AuthSource: SJ0PR12MB5673.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Aug 2026 07:29:54.0100
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: HBzycDVwOvXe0w2rtRaOADja93Gpj5OkC5vGxsilDJLPhS+BpP/dABx7EuBeg697
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ1PR12MB6051

On 8/5/26 12:59, Pavel Begunkov wrote:
> On 8/5/26 09:27, Christian König wrote:

>>> +
>>> +    dma_resv_lock(dmabuf->resv, NULL);
>>> +    ctx->dev_ops->unmap(ctx, map);
>>> +    dma_resv_unlock(dmabuf->resv);
>>> +
>>> +    dma_fence_put(&fence->base);
>>
>> You should probably set map->fence to NULL after that.
> 
> The map is freed two lines below, but I can add it as
> a defensive measure.

In that case it's ok, I've just haven't seen the kfree(map) below.

> ...
>>> +    ret = dma_resv_reserve_fences(dmabuf->resv, 1);
>>> +    if (WARN_ON_ONCE(ret)) {
>>> +        struct dma_fence *fence = &map->fence->base;
>>> +
>>> +        dma_fence_get(fence);
>>> +        percpu_ref_kill(&map->refs);
>>> +        dma_fence_wait(fence, false);
>>> +        dma_fence_put(fence);
>>> +        return;
>>> +    }
>>> +
>>> +    dma_resv_add_fence(dmabuf->resv, &map->fence->base,
>>> +               DMA_RESV_USAGE_KERNEL);
>>
>> That sequence is clearly incorrect!
>>
>> The fence must be created after dma_resv_reserve_fences(), otherwise you definately have an illegal memory operation here.
> 
> I'm not sure what you mean, can you elaborate? I only cared about
> pre-allocating it to avoid allocations here. We add / signal the fence
> only once, no reuse. The map is going to be killed here, and if we
> create a new map, it'll have its own fence.
> 
> I can move the dma_fence_init() call here if that makes a difference?

Yeah that is a good start, but you might need a bit more.

Here is a summary of the usual procedure you need to follow when implementing a dma_fence backend:

1. Allocate your operation object, in this case here it's your mapping I think.
2. Prepare your operation, including all memory allocations.
3. Call dma_resv_reserve_fences() to reserve a fence slot.
4. Allocate and init your dma_fence object.

After this step no memory allocation is allowed any more until your dma_fence object signals.

The only exception is optional logging or crash dumping using GFP_NOWAIT (can fail trivially!) or minimal allocations using GFP_ATOMIC if you absolutely have to.

5. dma_resv_add_fence() to publish the fence.
6. dma_resv_unlock().

Having a dma_fence is certainly nice to have, but the tricky part is that memory allocations using GFP_KERNEL (or GFP_IO, GFP_FS etc...) can cycle back and wait for your dma_fence to signal which essentially can cause a deadlock very deeply inside memory management.

Since those deadlocks happen only on memory contention situations they are usually just hard to reproduce but still totally break your neck if you manage to mess this up. So that needs to be super carefully implemented.

Regards,
Christian.
