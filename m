Received: from mailout4.samsung.com (mailout4.samsung.com [203.254.224.34])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 13D9C41E6D8
	for <nvdimm@lists.linux.dev>; Tue,  4 Aug 2026 07:29:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=203.254.224.34
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785828565; cv=none; b=Q0YYWgj73NzFQPqn+qmFwHK2Ij/ASNjedb/Oov956YX3iC9/lKCfk1WLfe725ldbdLta/bW3d5TtKuPga06Nw/5P47RjH0a98UWhHHmTYRF/Y8tZmTnsotVRUjxToyD5E9f4TrUoLsgfqD1DlOkaekIeykGtLyo8cRWkyRl6+3U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785828565; c=relaxed/simple;
	bh=u4QIQZTdswptGzA7Ts6wBB+sdxAXlbuqrjMHMB4he5M=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:From:In-Reply-To:
	 Content-Type:References; b=sd7c39qfXbN/NAS4BKKLKZjJHZz/cCXfgAGwwE6mlBNcNGqQYwzXboz3h7Cva8v8FL4KOkXumanvKTjAQsuyUSDs5H3uMvAyOPrUJIrzMW6cM4psGFbtc02ARnfTgfvlI8Hv3BYzC+I29w3GvYZ8XQ1e5eJDCShK0JZaDi/ah2U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com; spf=pass smtp.mailfrom=samsung.com; dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b=YuL9mR3P; arc=none smtp.client-ip=203.254.224.34
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samsung.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b="YuL9mR3P"
Received: from epcas5p2.samsung.com (unknown [182.195.41.40])
	by mailout4.samsung.com (KnoxPortal) with ESMTP id 20260804072913epoutp04b2724a46ccadd1b18bd949674f82d210~IiZuL9H_y3069030690epoutp04I
	for <nvdimm@lists.linux.dev>; Tue,  4 Aug 2026 07:29:13 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout4.samsung.com 20260804072913epoutp04b2724a46ccadd1b18bd949674f82d210~IiZuL9H_y3069030690epoutp04I
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
	s=mail20170921; t=1785828553;
	bh=oq3WXJu/SsF/yYJkxmJpNIikAfWrsHK6PFkUbOrSyxQ=;
	h=Date:Subject:To:Cc:From:In-Reply-To:References:From;
	b=YuL9mR3PGb2opeFZiYN0zNin1lKqXZc/cCNGngvIs07OjuKhr0shXabI7kR3ToXg4
	 m9eu0VhaMLeIMH0kAURIYdc6jWK1UzL4Ga89eE+9NWPW/uLnZVQbYCgfFY8TbDhK0f
	 rLSzDKGyEGvDXov2c9EdXQ2JUy6DIGmt0glyRSes=
Received: from epsnrtp02.localdomain (unknown [182.195.42.154]) by
	epcas5p2.samsung.com (KnoxPortal) with ESMTPS id
	20260804072912epcas5p2adb2d94e9dbee254b808fbe3e7596043~IiZtxp_B41422314223epcas5p25;
	Tue,  4 Aug 2026 07:29:12 +0000 (GMT)
Received: from epcas5p4.samsung.com (unknown [182.195.38.94]) by
	epsnrtp02.localdomain (Postfix) with ESMTP id 4hDlXm00m2z2SSKd; Tue,  4 Aug
	2026 07:29:12 +0000 (GMT)
Received: from epsmtip1.samsung.com (unknown [182.195.34.30]) by
	epcas5p1.samsung.com (KnoxPortal) with ESMTPA id
	20260804072911epcas5p11ac571c654cc6f9181d41e68c1d776f7~IiZsQAmmo3024630246epcas5p1l;
	Tue,  4 Aug 2026 07:29:11 +0000 (GMT)
Received: from [107.122.10.194] (unknown [107.122.10.194]) by
	epsmtip1.samsung.com (KnoxPortal) with ESMTPA id
	20260804072906epsmtip1f5a677211ba3b877f3e13174d1789292~IiZnod7M11634816348epsmtip18;
	Tue,  4 Aug 2026 07:29:06 +0000 (GMT)
Message-ID: <c4cec417-24b8-428a-853f-4e1ff1e29a6a@samsung.com>
Date: Tue, 4 Aug 2026 12:59:05 +0530
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v5 09/16] nvme-pci: implement dma-buf backed requests
To: Pavel Begunkov <asml.silence@gmail.com>, Jens Axboe <axboe@kernel.dk>,
	Keith Busch <kbusch@kernel.org>, Christoph Hellwig <hch@lst.de>, Sagi
	Grimberg <sagi@grimberg.me>, linux-block@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-nvme@lists.infradead.org,
	linux-fsdevel@vger.kernel.org, io-uring@vger.kernel.org,
	linux-media@vger.kernel.org, dri-devel@lists.freedesktop.org,
	linaro-mm-sig@lists.linaro.org
Cc: Alexander Viro <viro@zeniv.linux.org.uk>, Christian Brauner
	<brauner@kernel.org>, Andrew Morton <akpm@linux-foundation.org>, Sumit
	Semwal <sumit.semwal@linaro.org>, =?UTF-8?Q?Christian_K=C3=B6nig?=
	<christian.koenig@amd.com>, Nitesh Shetty <nj.shetty@samsung.com>, Kanchan
	Joshi <joshi.k@samsung.com>, Jason Gunthorpe <jgg@nvidia.com>, Damien Le
	Moal <dlemoal@kernel.org>, Alasdair Kergon <agk@redhat.com>, Mike Snitzer
	<snitzer@kernel.org>, Mikulas Patocka <mpatocka@redhat.com>, Benjamin
	Marzinski <bmarzins@redhat.com>, David Sterba <dsterba@suse.com>, Ilya
	Dryomov <idryomov@gmail.com>, dm-devel@lists.linux.dev,
	nvdimm@lists.linux.dev, linux-btrfs@vger.kernel.org,
	ceph-devel@vger.kernel.org
Content-Language: en-US
From: Anuj Gupta/Anuj Gupta <anuj20.g@samsung.com>
In-Reply-To: <9e3dd1b2d71dc0f9bd556b6a6d6e48fb6a8d727b.1785596451.git.asml.silence@gmail.com>
Content-Transfer-Encoding: 7bit
X-CMS-MailID: 20260804072911epcas5p11ac571c654cc6f9181d41e68c1d776f7
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
CMS-TYPE: 105P
cpgsPolicy: CPGSC10-542,Y
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20260801155005epcas5p4ecdcdf532aa2c2ff4e94638eedaa435b
References: <cover.1785596451.git.asml.silence@gmail.com>
	<CGME20260801155005epcas5p4ecdcdf532aa2c2ff4e94638eedaa435b@epcas5p4.samsung.com>
	<9e3dd1b2d71dc0f9bd556b6a6d6e48fb6a8d727b.1785596451.git.asml.silence@gmail.com>

On 8/1/2026 9:16 PM, Pavel Begunkov wrote:
> +	map = kmalloc_flex(*map, dma_list, nr_entries);
> +	if (!map)
> +		return ERR_PTR(-ENOMEM);
> +
> +	sgt = dma_buf_map_attachment(attach, ctx->dir);
> +	if (IS_ERR(sgt)) {
> +		ret = PTR_ERR(sgt);
> +		sgt = NULL;
> +		goto err;
> +	}
> +
> +	for_each_sgtable_dma_sg(sgt, sg, tmp) {
> +		dma_addr_t dma_addr = sg_dma_address(sg);
> +		unsigned long sg_len = sg_dma_len(sg);
> +
> +		if (sg_len % NVME_CTRL_PAGE_SIZE) {
> +			ret = -EINVAL;
> +			goto err;
> +		}
> +		seg_shift = min(seg_shift, __ffs(sg_len));
> +
> +		while (sg_len) {
> +			map->dma_list[i++] = dma_addr;
> +			dma_addr += NVME_CTRL_PAGE_SIZE;
> +			sg_len -= NVME_CTRL_PAGE_SIZE;
> +		}
> +	}
> +
> +	if (WARN_ON_ONCE(seg_shift < NVME_CTRL_PAGE_SHIFT))
> +		return ERR_PTR(-EFAULT);

This should be 'goto err;' instead of a direct return. If this ever 
triggers, it leaks the map and already established sgt mapping.

> +
> +	ret = dma_buf_io_init_map(ctx, &map->base);
> +	if (ret)
> +		goto err;
> +	map->base.seg_shift = seg_shift;
> +	map->nr_entries = nr_entries;
> +	map->sgt = sgt;
> +	return &map->base;
> +err:
> +	if (sgt)
> +		dma_buf_unmap_attachment(attach, sgt, ctx->dir);
> +	kfree(map);
> +	return ERR_PTR(ret);
> +}

