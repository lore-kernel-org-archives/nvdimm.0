Received: from frasgout.his.huawei.com (frasgout.his.huawei.com [185.176.79.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B17E8143C69;
	Tue,  1 Jul 2025 13:44:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=185.176.79.56
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751377445; cv=none; b=euF07cj0+YGJDe0QN3TgsFvhM9WmPRjfJoRNGZQgtecyf93LxyijjfkjKt3DrLoZBEI0/3Rsyas4//MlTZXu9al1TR5PxbWS0pVYx+K706HD6DiZ1HrE4liVsRMyEFlTKXNkrMifSREJRV6MHEYrtoHI+mvWtSFrDiUtt+UJOQE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751377445; c=relaxed/simple;
	bh=VjAD8KdF7m2BlM+Sf9sezN5FLxjUffGtPGY5q9p3ZXM=;
	h=Date:From:To:CC:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=tcxaUVMHxP65JsYtGHwbUj4JPL3NKV7Sd7Vw+eDuMX158OY2GUTaXvr1i9R7CwctYxMT4iNP2gBd/1kbokoJuezHZ8PRO5oYw+y9F03yHFNMwmI1Jw86hTOfueAD4+Zp+85N6BedNM+n8+sB3lIL/8aIm7+j0HCiXtjG4+yNTDs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; arc=none smtp.client-ip=185.176.79.56
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Received: from mail.maildlp.com (unknown [172.18.186.231])
	by frasgout.his.huawei.com (SkyGuard) with ESMTP id 4bWkkL22CXz6M4sF;
	Tue,  1 Jul 2025 21:43:06 +0800 (CST)
Received: from frapeml500008.china.huawei.com (unknown [7.182.85.71])
	by mail.maildlp.com (Postfix) with ESMTPS id 72B481402F8;
	Tue,  1 Jul 2025 21:44:00 +0800 (CST)
Received: from localhost (10.203.177.66) by frapeml500008.china.huawei.com
 (7.182.85.71) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.1.2507.39; Tue, 1 Jul
 2025 15:43:59 +0200
Date: Tue, 1 Jul 2025 14:43:58 +0100
From: Jonathan Cameron <Jonathan.Cameron@huawei.com>
To: Dongsheng Yang <dongsheng.yang@linux.dev>
CC: <mpatocka@redhat.com>, <agk@redhat.com>, <snitzer@kernel.org>,
	<axboe@kernel.dk>, <hch@lst.de>, <dan.j.williams@intel.com>,
	<linux-block@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
	<linux-cxl@vger.kernel.org>, <nvdimm@lists.linux.dev>,
	<dm-devel@lists.linux.dev>
Subject: Re: [PATCH v1 01/11] dm-pcache: add pcache_internal.h
Message-ID: <20250701144358.000061a5@huawei.com>
In-Reply-To: <20250624073359.2041340-2-dongsheng.yang@linux.dev>
References: <20250624073359.2041340-1-dongsheng.yang@linux.dev>
	<20250624073359.2041340-2-dongsheng.yang@linux.dev>
X-Mailer: Claws Mail 4.3.0 (GTK 3.24.42; x86_64-w64-mingw32)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: lhrpeml500010.china.huawei.com (7.191.174.240) To
 frapeml500008.china.huawei.com (7.182.85.71)

On Tue, 24 Jun 2025 07:33:48 +0000
Dongsheng Yang <dongsheng.yang@linux.dev> wrote:

> Consolidate common PCACHE helpers into a new header so that subsequent
> patches can include them without repeating boiler-plate.
> 
> - Logging macros with unified prefix and location info.
> - Common constants (KB/MB helpers, metadata replica count, CRC seed).
> - On-disk metadata header definition and CRC helper.
> - Sequence-number comparison that handles wrap-around.
> - pcache_meta_find_latest() to pick the newest valid metadata copy.
> 
> Signed-off-by: Dongsheng Yang <dongsheng.yang@linux.dev>
Hi,

I'm taking a look out of curiosity only as this is far from an area I'm
confident in.  So comments will be mostly superficial.


> ---
>  drivers/md/dm-pcache/pcache_internal.h | 116 +++++++++++++++++++++++++

As a general rule I'd much rather see a header built up alongside the
code that uses it rather than as a separate patch at the start.

>  1 file changed, 116 insertions(+)
>  create mode 100644 drivers/md/dm-pcache/pcache_internal.h
> 
> diff --git a/drivers/md/dm-pcache/pcache_internal.h b/drivers/md/dm-pcache/pcache_internal.h
> new file mode 100644
> index 000000000000..4d3b55a22638
> --- /dev/null
> +++ b/drivers/md/dm-pcache/pcache_internal.h
> @@ -0,0 +1,116 @@
> +/* SPDX-License-Identifier: GPL-2.0-or-later */
> +#ifndef _PCACHE_INTERNAL_H
> +#define _PCACHE_INTERNAL_H
> +
> +#include <linux/delay.h>
> +#include <linux/crc32c.h>
> +
> +#define pcache_err(fmt, ...)							\
> +	pr_err("dm-pcache: %s:%u " fmt, __func__, __LINE__, ##__VA_ARGS__)
> +#define pcache_info(fmt, ...)							\
> +	pr_info("dm-pcache: %s:%u " fmt, __func__, __LINE__, ##__VA_ARGS__)
> +#define pcache_debug(fmt, ...)							\
> +	pr_debug("dm-pcache: %s:%u " fmt, __func__, __LINE__, ##__VA_ARGS__)

Use pr_fmt() in appropriate files and drop these.

> +
> +#define PCACHE_KB			(1024ULL)
> +#define PCACHE_MB			(1024 * PCACHE_KB)

Generally avoid defines where they just match the numbers.  1024 * 1024 is
commonly used directly in kernel code as everyone can see it's a MiB.

> +
> +/* Maximum number of metadata indices */
> +#define PCACHE_META_INDEX_MAX		2
> +
> +#define PCACHE_CRC_SEED			0x3B15A
> +/*
> + * struct pcache_meta_header - PCACHE metadata header structure
> + * @crc: CRC checksum for validating metadata integrity.
> + * @seq: Sequence number to track metadata updates.
> + * @version: Metadata version.
> + * @res: Reserved space for future use.
> + */
> +struct pcache_meta_header {
> +	__u32 crc;
> +	__u8  seq;
> +	__u8  version;
> +	__u16 res;

Why not u32 and friends given this seems to be internal to the kernel?

> +};
> +
> +/*

You've formatted most of this stuff as kernel-doc so for all of them use

/**

And check for any warnings or errors using scripts/kernel-doc

It's a good way to pick up on subtle typos etc in docs that a reviewr
might miss.

> + * pcache_meta_crc - Calculate CRC for the given metadata header.
> + * @header: Pointer to the metadata header.
> + * @meta_size: Size of the metadata structure.
> + *
> + * Returns the CRC checksum calculated by excluding the CRC field itself.
> + */
> +static inline u32 pcache_meta_crc(struct pcache_meta_header *header, u32 meta_size)
> +{
> +	return crc32c(PCACHE_CRC_SEED, (void *)header + 4, meta_size - 4);
> +}
> +
> +/*
> + * pcache_meta_seq_after - Check if a sequence number is more recent, accounting for overflow.
> + * @seq1: First sequence number.
> + * @seq2: Second sequence number.
> + *
> + * Determines if @seq1 is more recent than @seq2 by calculating the signed
> + * difference between them. This approach allows handling sequence number
> + * overflow correctly because the difference wraps naturally, and any value
> + * greater than zero indicates that @seq1 is "after" @seq2. This method
> + * assumes 8-bit unsigned sequence numbers, where the difference wraps
> + * around if seq1 overflows past seq2.

I'd state the assumption behind this which think is that we will never
have a sequence number getting ahead by more than 128 values.

> + *
> + * Returns:
> + *   - true if @seq1 is more recent than @seq2, indicating it comes "after"
> + *   - false otherwise.
> + */
> +static inline bool pcache_meta_seq_after(u8 seq1, u8 seq2)
> +{
> +	return (s8)(seq1 - seq2) > 0;
> +}
> +
> +/*
> + * pcache_meta_find_latest - Find the latest valid metadata.
> + * @header: Pointer to the metadata header.
> + * @meta_size: Size of each metadata block.
> + *
> + * Finds the latest valid metadata by checking sequence numbers. If a
> + * valid entry with the highest sequence number is found, its pointer
> + * is returned. Returns NULL if no valid metadata is found.
> + */
> +static inline void __must_check *pcache_meta_find_latest(struct pcache_meta_header *header,
> +					u32 meta_size, u32 meta_max_size,
> +					void *meta_ret)

Not sure why you can't type this as pcache_meta_header.  Maybe that will
become obvious later int he series.

> +{
> +	struct pcache_meta_header *meta, *latest = NULL;

Combining declarations that assign and those that don't is not greate
for readability.  Also why not set meta where you declare it?

> +	u32 i, seq_latest = 0;
> +	void *meta_addr;
> +
> +	meta = meta_ret;
> +
> +	for (i = 0; i < PCACHE_META_INDEX_MAX; i++) {
> +		meta_addr = (void *)header + (i * meta_max_size);

Brackets around i * meta_max_size not needed.   Whilst we can't all remember
precedence of all operators, + and * are reasonable to assume.

> +		if (copy_mc_to_kernel(meta, meta_addr, meta_size)) {
> +			pcache_err("hardware memory error when copy meta");
> +			return ERR_PTR(-EIO);
> +		}
> +
> +		/* Skip if CRC check fails */

Good to say why skipping is the right choice perhaps.

> +		if (meta->crc != pcache_meta_crc(meta, meta_size))
> +			continue;
> +
> +		/* Update latest if a more recent sequence is found */
> +		if (!latest || pcache_meta_seq_after(meta->seq, seq_latest)) {
> +			seq_latest = meta->seq;
> +			latest = (void *)header + (i * meta_max_size);
> +		}
> +	}
> +
> +	if (latest) {
I'd flip

	if (!latest)
		return 0;

	if (copy...)

> +		if (copy_mc_to_kernel(meta_ret, latest, meta_size)) {
> +			pcache_err("hardware memory error");
> +			return ERR_PTR(-EIO);
> +		}
> +	}
> +
> +	return latest;
> +}
> +
> +#endif /* _PCACHE_INTERNAL_H */

