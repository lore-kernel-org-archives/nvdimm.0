Received: from frasgout.his.huawei.com (frasgout.his.huawei.com [185.176.79.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2CBCD279DCE;
	Tue,  1 Jul 2025 14:59:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=185.176.79.56
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751381976; cv=none; b=svBwMqGa4e8ZKWzwvhzKNR71D1KFBEgzKT8fFSxvPSwk3RQ3zJzj9AQu139I0ezh0NSsGefsx23eHHr6mLfmS3j+CIHbcizCM6Uj+5SF+KuUR5S/SNtFzNVRpGuFILoxnQhY07a8gQUfOIczuzuyL2Lj9RMuE7O4DQP01Hg4Hq8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751381976; c=relaxed/simple;
	bh=q7W5eCoZyGNKhRbQGrx9TjWx1gnAK95QWJ3Qko4ZTjE=;
	h=Date:From:To:CC:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=pKc4AUSTF27/jU4aT7TQ4Yr4loTN6skD9mJFrG1Re4OHfEWDPmGPjzCHPVtkT9cDgFpTSpoRGbuJqurjCLFwG3czBCPpFrqNtoZZ2rHrFzD6yh+WlVXsPkot6t8GV0aFD5cZCr67dGALsL9xhvFawSHQdyPiip19YYxyGkPJIb0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; arc=none smtp.client-ip=185.176.79.56
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Received: from mail.maildlp.com (unknown [172.18.186.31])
	by frasgout.his.huawei.com (SkyGuard) with ESMTP id 4bWmQ361mkz6L5GG;
	Tue,  1 Jul 2025 22:59:07 +0800 (CST)
Received: from frapeml500008.china.huawei.com (unknown [7.182.85.71])
	by mail.maildlp.com (Postfix) with ESMTPS id C86FC14011A;
	Tue,  1 Jul 2025 22:59:30 +0800 (CST)
Received: from localhost (10.203.177.66) by frapeml500008.china.huawei.com
 (7.182.85.71) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.1.2507.39; Tue, 1 Jul
 2025 16:59:30 +0200
Date: Tue, 1 Jul 2025 15:59:28 +0100
From: Jonathan Cameron <Jonathan.Cameron@huawei.com>
To: Dongsheng Yang <dongsheng.yang@linux.dev>
CC: <mpatocka@redhat.com>, <agk@redhat.com>, <snitzer@kernel.org>,
	<axboe@kernel.dk>, <hch@lst.de>, <dan.j.williams@intel.com>,
	<linux-block@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
	<linux-cxl@vger.kernel.org>, <nvdimm@lists.linux.dev>,
	<dm-devel@lists.linux.dev>
Subject: Re: [PATCH v1 05/11] dm-pcache: add cache_segment
Message-ID: <20250701155928.0000160a@huawei.com>
In-Reply-To: <20250624073359.2041340-6-dongsheng.yang@linux.dev>
References: <20250624073359.2041340-1-dongsheng.yang@linux.dev>
	<20250624073359.2041340-6-dongsheng.yang@linux.dev>
X-Mailer: Claws Mail 4.3.0 (GTK 3.24.42; x86_64-w64-mingw32)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-ClientProxiedBy: lhrpeml500002.china.huawei.com (7.191.160.78) To
 frapeml500008.china.huawei.com (7.182.85.71)

On Tue, 24 Jun 2025 07:33:52 +0000
Dongsheng Yang <dongsheng.yang@linux.dev> wrote:

> Introduce *cache_segment.c*, the in-memory/on-disk glue that lets a
> `struct pcache_cache` manage its array of data segments.
>=20
> * Metadata handling
>   - Loads the most-recent replica of both the segment-info block
>     (`struct pcache_segment_info`) and per-segment generation counter
>     (`struct pcache_cache_seg_gen`) using `pcache_meta_find_latest()`.
>   - Updates those structures atomically with CRC + sequence rollover,
>     writing alternately to the two metadata slots inside each segment.
>=20
> * Segment initialisation (`cache_seg_init`)
>   - Builds a `struct pcache_segment` pointing to the segment=E2=80=99s da=
ta
>     area, sets up locks, generation counters, and, when formatting a new
>     cache, zeroes the on-segment kset header.
>=20
> * Linked-list of segments
>   - `cache_seg_set_next_seg()` stores the *next* segment id in
>     `seg_info->next_seg` and sets the HAS_NEXT flag, allowing a cache to
>     span multiple segments. This is important to allow other type of
>     segment added in future.
>=20
> * Runtime life-cycle
>   - Reference counting (`cache_seg_get/put`) with invalidate-on-last-put
>     that clears the bitmap slot and schedules cleanup work.
>   - Generation bump (`cache_seg_gen_increase`) persists a new generation
>     record whenever the segment is modified.
>=20
> * Allocator
>   - `get_cache_segment()` uses a bitmap and per-cache hint to pick the
>     next free segment, retrying with micro-delays when none are
>     immediately available.
>=20
> Signed-off-by: Dongsheng Yang <dongsheng.yang@linux.dev>
Minor stuff inline.

> ---
>  drivers/md/dm-pcache/cache_segment.c | 293 +++++++++++++++++++++++++++
>  1 file changed, 293 insertions(+)
>  create mode 100644 drivers/md/dm-pcache/cache_segment.c
>=20
> diff --git a/drivers/md/dm-pcache/cache_segment.c b/drivers/md/dm-pcache/=
cache_segment.c
> new file mode 100644
> index 000000000000..298f881874d1
> --- /dev/null
> +++ b/drivers/md/dm-pcache/cache_segment.c
> @@ -0,0 +1,293 @@
> +// SPDX-License-Identifier: GPL-2.0-or-later
> +
> +#include "cache_dev.h"
> +#include "cache.h"
> +#include "backing_dev.h"
> +#include "dm_pcache.h"
> +
> +static inline struct pcache_segment_info *get_seg_info_addr(struct pcach=
e_cache_segment *cache_seg)
> +{
> +	struct pcache_segment_info *seg_info_addr;
> +	u32 seg_id =3D cache_seg->segment.seg_id;
> +	void *seg_addr;
> +
> +	seg_addr =3D CACHE_DEV_SEGMENT(cache_seg->cache->cache_dev, seg_id);
> +	seg_info_addr =3D seg_addr + PCACHE_SEG_INFO_SIZE * cache_seg->info_ind=
ex;
> +
> +	return seg_info_addr;

Little point in this local variable.

	return seg_addr + PCACHE_SEG_INFO_SIZE * cache_seg->info_index;

> +}
> +
> +static void cache_seg_info_write(struct pcache_cache_segment *cache_seg)
> +{
> +	struct pcache_segment_info *seg_info_addr;
> +	struct pcache_segment_info *seg_info =3D &cache_seg->cache_seg_info;
> +
> +	mutex_lock(&cache_seg->info_lock);

guard() here to avoid need to release below.

> +	seg_info->header.seq++;
> +	seg_info->header.crc =3D pcache_meta_crc(&seg_info->header, sizeof(stru=
ct pcache_segment_info));
> +
> +	seg_info_addr =3D get_seg_info_addr(cache_seg);
> +	memcpy_flushcache(seg_info_addr, seg_info, sizeof(struct pcache_segment=
_info));
> +	pmem_wmb();
> +
> +	cache_seg->info_index =3D (cache_seg->info_index + 1) % PCACHE_META_IND=
EX_MAX;
> +	mutex_unlock(&cache_seg->info_lock);
> +}
> +
> +static int cache_seg_info_load(struct pcache_cache_segment *cache_seg)
> +{
> +	struct pcache_segment_info *cache_seg_info_addr_base, *cache_seg_info_a=
ddr;
> +	struct pcache_cache_dev *cache_dev =3D cache_seg->cache->cache_dev;
> +	struct dm_pcache *pcache =3D CACHE_DEV_TO_PCACHE(cache_dev);
> +	u32 seg_id =3D cache_seg->segment.seg_id;
> +	int ret =3D 0;
> +
> +	cache_seg_info_addr_base =3D CACHE_DEV_SEGMENT(cache_dev, seg_id);
> +
> +	mutex_lock(&cache_seg->info_lock);

As below guard() will improve this code though you will need to change how =
the error
message is printed.

> +	cache_seg_info_addr =3D pcache_meta_find_latest(&cache_seg_info_addr_ba=
se->header,
> +						sizeof(struct pcache_segment_info),
> +						PCACHE_SEG_INFO_SIZE,
> +						&cache_seg->cache_seg_info);
> +	if (IS_ERR(cache_seg_info_addr)) {
> +		ret =3D PTR_ERR(cache_seg_info_addr);
> +		goto out;
> +	} else if (!cache_seg_info_addr) {
> +		ret =3D -EIO;
> +		goto out;
> +	}
> +	cache_seg->info_index =3D cache_seg_info_addr - cache_seg_info_addr_bas=
e;
> +out:
> +	mutex_unlock(&cache_seg->info_lock);
> +
> +	if (ret)
> +		pcache_dev_err(pcache, "can't read segment info of segment: %u, ret: %=
d\n",
> +			      cache_seg->segment.seg_id, ret);
> +	return ret;
> +}
> +
> +static int cache_seg_ctrl_load(struct pcache_cache_segment *cache_seg)
> +{
> +	struct pcache_cache_seg_ctrl *cache_seg_ctrl =3D cache_seg->cache_seg_c=
trl;
> +	struct pcache_cache_seg_gen cache_seg_gen, *cache_seg_gen_addr;

Don't mix pointer and none pointer in one line of declaration. Just
a tiny bit tricky to read.


> +	int ret =3D 0;
> +
> +	mutex_lock(&cache_seg->ctrl_lock);

guard() to allow returns on error paths without worrying about the lock
being released as leaving the scope will do it for you.


> +	cache_seg_gen_addr =3D pcache_meta_find_latest(&cache_seg_ctrl->gen->he=
ader,
> +					     sizeof(struct pcache_cache_seg_gen),
sizeof(cache_seg_gen) perhaps?
> +					     sizeof(struct pcache_cache_seg_gen),
> +					     &cache_seg_gen);
> +	if (IS_ERR(cache_seg_gen_addr)) {
> +		ret =3D PTR_ERR(cache_seg_gen_addr);
> +		goto out;
> +	}
> +
> +	if (!cache_seg_gen_addr) {
> +		cache_seg->gen =3D 0;
> +		cache_seg->gen_seq =3D 0;
> +		cache_seg->gen_index =3D 0;
> +		goto out;
> +	}
> +
> +	cache_seg->gen =3D cache_seg_gen.gen;
> +	cache_seg->gen_seq =3D cache_seg_gen.header.seq;
> +	cache_seg->gen_index =3D (cache_seg_gen_addr - cache_seg_ctrl->gen);
> +out:
> +	mutex_unlock(&cache_seg->ctrl_lock);
> +
> +	return ret;
> +}

> +
> +static void cache_seg_ctrl_write(struct pcache_cache_segment *cache_seg)
> +{
> +	struct pcache_cache_seg_gen cache_seg_gen;
> +
> +	mutex_lock(&cache_seg->ctrl_lock);

Consider guard(mutex)()

> +	cache_seg_gen.gen =3D cache_seg->gen;
> +	cache_seg_gen.header.seq =3D ++cache_seg->gen_seq;
> +	cache_seg_gen.header.crc =3D pcache_meta_crc(&cache_seg_gen.header,
> +						 sizeof(struct pcache_cache_seg_gen));
> +
> +	memcpy_flushcache(get_cache_seg_gen_addr(cache_seg), &cache_seg_gen, si=
zeof(struct pcache_cache_seg_gen));
> +	pmem_wmb();
> +
> +	cache_seg->gen_index =3D (cache_seg->gen_index + 1) % PCACHE_META_INDEX=
_MAX;
> +	mutex_unlock(&cache_seg->ctrl_lock);
> +}

> +
> +static int cache_seg_meta_load(struct pcache_cache_segment *cache_seg)
> +{
> +	int ret;
> +
> +	ret =3D cache_seg_info_load(cache_seg);
> +	if (ret)
> +		goto err;

		return ret;

in these paths simpler to follow.  If DM always does this pattern fair enou=
gh
to follow local style.

> +
> +	ret =3D cache_seg_ctrl_load(cache_seg);
> +	if (ret)
> +		goto err;
> +
> +	return 0;
> +err:
> +	return ret;
> +}

> +int cache_seg_init(struct pcache_cache *cache, u32 seg_id, u32 cache_seg=
_id,
> +		   bool new_cache)
> +{
> +	struct pcache_cache_dev *cache_dev =3D cache->cache_dev;
> +	struct pcache_cache_segment *cache_seg =3D &cache->segments[cache_seg_i=
d];
> +	struct pcache_segment_init_options seg_options =3D { 0 };
> +	struct pcache_segment *segment =3D &cache_seg->segment;
> +	int ret;
> +
> +	cache_seg->cache =3D cache;
> +	cache_seg->cache_seg_id =3D cache_seg_id;
> +	spin_lock_init(&cache_seg->gen_lock);
> +	atomic_set(&cache_seg->refs, 0);
> +	mutex_init(&cache_seg->info_lock);
> +	mutex_init(&cache_seg->ctrl_lock);
> +
> +	/* init pcache_segment */
> +	seg_options.type =3D PCACHE_SEGMENT_TYPE_CACHE_DATA;
> +	seg_options.data_off =3D PCACHE_CACHE_SEG_CTRL_OFF + PCACHE_CACHE_SEG_C=
TRL_SIZE;
> +	seg_options.seg_id =3D seg_id;
> +	seg_options.seg_info =3D &cache_seg->cache_seg_info;
> +	pcache_segment_init(cache_dev, segment, &seg_options);
> +
> +	cache_seg->cache_seg_ctrl =3D CACHE_DEV_SEGMENT(cache_dev, seg_id) + PC=
ACHE_CACHE_SEG_CTRL_OFF;
> +
> +	if (new_cache) {
I'd flip logic so
	if (!new_cache)
		return cache_seg_meta_load(cache_seg);

	cache_dev_zero_range()
etc.

Sometimes it's better to exist quickly in the simple case and have
the straight line code deal with the more complex stuff (indented a little =
less)

> +		cache_dev_zero_range(cache_dev, CACHE_DEV_SEGMENT(cache_dev, seg_id),
> +				     PCACHE_SEG_INFO_SIZE * PCACHE_META_INDEX_MAX +
> +				     PCACHE_CACHE_SEG_CTRL_SIZE);
> +
> +		cache_seg_ctrl_init(cache_seg);
> +
> +		cache_seg->info_index =3D 0;
> +		cache_seg_info_write(cache_seg);
> +
> +		/* clear outdated kset in segment */
> +		memcpy_flushcache(segment->data, &pcache_empty_kset, sizeof(struct pca=
che_cache_kset_onmedia));
> +		pmem_wmb();
> +	} else {
> +		ret =3D cache_seg_meta_load(cache_seg);
> +		if (ret)
> +			goto err;

In this case we return immediately whether good or bad, so

		return cache_seg_meta_load(cache_seg);

> +	}
> +
> +	return 0;
> +err:
> +	return ret;
As in earlier patch reviews, don't have a label that is just return.  Retur=
n instead
of the gotos.

> +}


> +static void cache_seg_invalidate(struct pcache_cache_segment *cache_seg)
> +{
> +	struct pcache_cache *cache;

Might as well do the more compact
	struct pcache_cache *cache =3D cache_seg->cache;

> +
> +	cache =3D cache_seg->cache;
> +	cache_seg_gen_increase(cache_seg);
> +
> +	spin_lock(&cache->seg_map_lock);
> +	if (cache->cache_full)
> +		cache->cache_full =3D false;

Perhaps just write cache->cache_full =3D false unconditionally?
If there is a reason to not do the write, then add a comment here.

> +	clear_bit(cache_seg->cache_seg_id, cache->seg_map);
> +	spin_unlock(&cache->seg_map_lock);
> +
> +	pcache_defer_reqs_kick(CACHE_TO_PCACHE(cache));
> +	/* clean_work will clean the bad key in key_tree*/
> +	queue_work(cache_get_wq(cache), &cache->clean_work);
> +}
