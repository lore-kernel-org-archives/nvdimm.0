Received: from frasgout.his.huawei.com (frasgout.his.huawei.com [185.176.79.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 48C8C27466D;
	Tue,  1 Jul 2025 14:07:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=185.176.79.56
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751378849; cv=none; b=OAS6RM1nxU+DWAV8MW0qZYGRx7gWNxpNkAoqWz0zZuQurotUpNdqHC3g0Y7w3lWfe8bbD+xOC0f5a84zPiZA87bsac3Koau60Q/7kRAiTqE6yn87iAWYdNGhmtqstSxKcA6BjmKXTbFcVbHnjeWamIg607wCsShYxJ2wxHGXEcg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751378849; c=relaxed/simple;
	bh=UPnoahqZpQxa6C4f25PSY/O5uLDsByabLi7HuBuSwEY=;
	h=Date:From:To:CC:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=B0VEFeEG6oLIvGc49xGq6V+eAJO8rYWdMSk94xM/FMCwDfOZ/3rXswymUcnw5rnyIJ+Rr+8yU2rzeEUN0Jfpd20MGdzWhOWq2EScg3jHyKBH0qHQukAspay9p8xqXouzi9PQxIbxo9rcxZ26TjSaQHORxQCVpjiC4IDTGcxihLw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; arc=none smtp.client-ip=185.176.79.56
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Received: from mail.maildlp.com (unknown [172.18.186.231])
	by frasgout.his.huawei.com (SkyGuard) with ESMTP id 4bWlFJ6Bylz6M4jF;
	Tue,  1 Jul 2025 22:06:28 +0800 (CST)
Received: from frapeml500008.china.huawei.com (unknown [7.182.85.71])
	by mail.maildlp.com (Postfix) with ESMTPS id 13A511402EA;
	Tue,  1 Jul 2025 22:07:23 +0800 (CST)
Received: from localhost (10.203.177.66) by frapeml500008.china.huawei.com
 (7.182.85.71) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.1.2507.39; Tue, 1 Jul
 2025 16:07:22 +0200
Date: Tue, 1 Jul 2025 15:07:21 +0100
From: Jonathan Cameron <Jonathan.Cameron@huawei.com>
To: Dongsheng Yang <dongsheng.yang@linux.dev>
CC: <mpatocka@redhat.com>, <agk@redhat.com>, <snitzer@kernel.org>,
	<axboe@kernel.dk>, <hch@lst.de>, <dan.j.williams@intel.com>,
	<linux-block@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
	<linux-cxl@vger.kernel.org>, <nvdimm@lists.linux.dev>,
	<dm-devel@lists.linux.dev>
Subject: Re: [PATCH v1 03/11] dm-pcache: add cache device
Message-ID: <20250701150721.00003e67@huawei.com>
In-Reply-To: <20250624073359.2041340-4-dongsheng.yang@linux.dev>
References: <20250624073359.2041340-1-dongsheng.yang@linux.dev>
	<20250624073359.2041340-4-dongsheng.yang@linux.dev>
X-Mailer: Claws Mail 4.3.0 (GTK 3.24.42; x86_64-w64-mingw32)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-ClientProxiedBy: lhrpeml500004.china.huawei.com (7.191.163.9) To
 frapeml500008.china.huawei.com (7.182.85.71)

On Tue, 24 Jun 2025 07:33:50 +0000
Dongsheng Yang <dongsheng.yang@linux.dev> wrote:

> Add cache_dev.{c,h} to manage the persistent-memory device that stores
> all pcache metadata and data segments.  Splitting this logic out keeps
> the main dm-pcache code focused on policy while cache_dev handles the
> low-level interaction with the DAX block device.
>=20
> * DAX mapping
>   - Opens the underlying device via dm_get_device().
>   - Uses dax_direct_access() to obtain a direct linear mapping; falls
>     back to vmap() when the range is fragmented.
>=20
> * On-disk layout
>   =E2=94=8C=E2=94=80 4 KB =E2=94=80=E2=94=90  super-block (SB)
>   =E2=94=9C=E2=94=80 4 KB =E2=94=80=E2=94=A4  cache_info[0]
>   =E2=94=9C=E2=94=80 4 KB =E2=94=80=E2=94=A4  cache_info[1]
>   =E2=94=9C=E2=94=80 4 KB =E2=94=80=E2=94=A4  cache_ctrl
>   =E2=94=94=E2=94=80 ...  =E2=94=80=E2=94=98  segments
>   Constants and macros in the header expose offsets and sizes.
>=20
> * Super-block handling
>   - sb_read(), sb_validate(), sb_init() verify magic, CRC32 and host
>     endianness (flag *PCACHE_SB_F_BIGENDIAN*).
>   - Formatting zeroes the metadata replicas and initialises the segment
>     bitmap when the SB is blank.
>=20
> * Segment allocator
>   - Bitmap protected by seg_lock; find_next_zero_bit() yields the next
>     free 16 MB segment.
>=20
> * Lifecycle helpers
>   - cache_dev_start()/stop() encapsulate init/exit and are invoked by
>     dm-pcache core.
>   - Gracefully handles errors: CRC mismatch, wrong endianness, device
>     too small (< 512 MB), or failed DAX mapping.
>=20
> Signed-off-by: Dongsheng Yang <dongsheng.yang@linux.dev>
> ---
>  drivers/md/dm-pcache/cache_dev.c | 299 +++++++++++++++++++++++++++++++
>  drivers/md/dm-pcache/cache_dev.h |  70 ++++++++
>  2 files changed, 369 insertions(+)
>  create mode 100644 drivers/md/dm-pcache/cache_dev.c
>  create mode 100644 drivers/md/dm-pcache/cache_dev.h
>=20
> diff --git a/drivers/md/dm-pcache/cache_dev.c b/drivers/md/dm-pcache/cach=
e_dev.c
> new file mode 100644
> index 000000000000..4dcebc9c167e
> --- /dev/null
> +++ b/drivers/md/dm-pcache/cache_dev.c
> @@ -0,0 +1,299 @@

> +static int build_vmap(struct dax_device *dax_dev, long total_pages, void=
 **vaddr)
> +{
> +	struct page **pages;
> +	long i =3D 0, chunk;
> +	pfn_t pfn;
> +	int ret;
> +
> +	pages =3D vmalloc_array(total_pages, sizeof(struct page *));

Perhaps if DM allows it, use __free() here to avoid need to manually clean =
it up and
allow early returns on errors.

> +	if (!pages)
> +		return -ENOMEM;
> +
> +	do {
> +		chunk =3D dax_direct_access(dax_dev, i, total_pages - i,
> +					  DAX_ACCESS, NULL, &pfn);
> +		if (chunk <=3D 0) {
> +			ret =3D chunk ? chunk : -EINVAL;
> +			goto out_free;
> +		}
> +
> +		if (!pfn_t_has_page(pfn)) {
> +			ret =3D -EOPNOTSUPP;
> +			goto out_free;
> +		}
> +
> +		while (chunk-- && i < total_pages) {
> +			pages[i++] =3D pfn_t_to_page(pfn);
> +			pfn.val++;
> +			if (!(i & 15))
> +				cond_resched();
> +		}
> +	} while (i < total_pages);
> +
> +	*vaddr =3D vmap(pages, total_pages, VM_MAP, PAGE_KERNEL);
> +	if (!*vaddr)
> +		ret =3D -ENOMEM;
> +out_free:
> +	vfree(pages);
> +	return ret;
> +}
> +
> +static int cache_dev_dax_init(struct pcache_cache_dev *cache_dev)
> +{
> +	struct dm_pcache	*pcache =3D CACHE_DEV_TO_PCACHE(cache_dev);
> +	struct dax_device	*dax_dev;
> +	long			total_pages, mapped_pages;
> +	u64			bdev_size;
> +	void			*vaddr;
> +	int			ret;
> +	int			id;

combine ret and id on one line.

> +	pfn_t			pfn;
> +
> +	dax_dev	=3D cache_dev->dm_dev->dax_dev;
> +	/* total size check */
> +	bdev_size =3D bdev_nr_bytes(cache_dev->dm_dev->bdev);
> +	if (bdev_size < PCACHE_CACHE_DEV_SIZE_MIN) {
> +		pcache_dev_err(pcache, "dax device is too small, required at least %ll=
u",
> +				PCACHE_CACHE_DEV_SIZE_MIN);
> +		ret =3D -ENOSPC;
> +		goto out;
		return -ENOSPC;




> +int cache_dev_start(struct dm_pcache *pcache)
> +{
> +	struct pcache_cache_dev *cache_dev =3D &pcache->cache_dev;
> +	struct pcache_sb sb;
> +	bool format =3D false;
> +	int ret;
> +
> +	mutex_init(&cache_dev->seg_lock);
> +
> +	ret =3D cache_dev_dax_init(cache_dev);
> +	if (ret) {
> +		pcache_dev_err(pcache, "failed to init cache_dev %s via dax way: %d.",
> +			       cache_dev->dm_dev->name, ret);
> +		goto err;
> +	}
> +
> +	ret =3D sb_read(cache_dev, &sb);
> +	if (ret)
> +		goto dax_release;
> +
> +	if (le64_to_cpu(sb.magic) =3D=3D 0) {
> +		format =3D true;
> +		ret =3D sb_init(cache_dev, &sb);
> +		if (ret < 0)
> +			goto dax_release;
> +	}
> +
> +	ret =3D sb_validate(cache_dev, &sb);
> +	if (ret)
> +		goto dax_release;
> +
> +	cache_dev->sb_flags =3D le32_to_cpu(sb.flags);
> +	ret =3D cache_dev_init(cache_dev, sb.seg_num);
> +	if (ret)
> +		goto dax_release;
> +
> +	if (format)
> +		sb_write(cache_dev, &sb);
> +
> +	return 0;
> +
> +dax_release:
> +	cache_dev_dax_exit(cache_dev);
> +err:

In these cases just return instead of going to the label. It gives
generally more readable code.

> +	return ret;
> +}
> +
> +int cache_dev_get_empty_segment_id(struct pcache_cache_dev *cache_dev, u=
32 *seg_id)
> +{
> +	int ret;
> +
> +	mutex_lock(&cache_dev->seg_lock);

If DM is fine with guard() use it here.

> +	*seg_id =3D find_next_zero_bit(cache_dev->seg_bitmap, cache_dev->seg_nu=
m, 0);
> +	if (*seg_id =3D=3D cache_dev->seg_num) {
> +		ret =3D -ENOSPC;
> +		goto unlock;
> +	}
> +
> +	set_bit(*seg_id, cache_dev->seg_bitmap);
> +	ret =3D 0;
> +unlock:
> +	mutex_unlock(&cache_dev->seg_lock);
> +	return ret;
> +}
