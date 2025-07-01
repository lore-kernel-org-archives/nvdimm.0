Received: from frasgout.his.huawei.com (frasgout.his.huawei.com [185.176.79.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0706C27A12B;
	Tue,  1 Jul 2025 13:56:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=185.176.79.56
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751378217; cv=none; b=lOR6UoFBo3kZ+UEBSM7iKpJxVgqO3Xu/7CGipXzxTlswtYgTE06uaHhXEhWCqe+E1alcQfhfHPCiYmzrZUYF6goZASYHP/w7eGMr5PWCjLM6uM4ZsjbMV4kw4/C4FqEc2FxgIjmJ/fQy+N+mwpkLXX4ozyuZu2GkMyLVUwOs7MU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751378217; c=relaxed/simple;
	bh=Z1BzRknngBIxH7d9GNoJJiTwd8p6a5uKI4XIyALfOTc=;
	h=Date:From:To:CC:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=bCYyMJkPVu673kQtw9E08av4LOvXHf9v4sGIBXC9klDyTjVJ31zkVob3e7Bp58PFP7HOoS9YXObUPJ1uUlKPkb8vaxgKuxtWz+1wbNQE8/DxIEuRNTz1A4EWeLuWs1voMsDF16ckXzbssSni04e5Azvp0ZYGnj8wOOcNEWAsiJg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; arc=none smtp.client-ip=185.176.79.56
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Received: from mail.maildlp.com (unknown [172.18.186.31])
	by frasgout.his.huawei.com (SkyGuard) with ESMTP id 4bWl1B487yz6M4jF;
	Tue,  1 Jul 2025 21:55:58 +0800 (CST)
Received: from frapeml500008.china.huawei.com (unknown [7.182.85.71])
	by mail.maildlp.com (Postfix) with ESMTPS id BBC9C1402F4;
	Tue,  1 Jul 2025 21:56:52 +0800 (CST)
Received: from localhost (10.203.177.66) by frapeml500008.china.huawei.com
 (7.182.85.71) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.1.2507.39; Tue, 1 Jul
 2025 15:56:52 +0200
Date: Tue, 1 Jul 2025 14:56:50 +0100
From: Jonathan Cameron <Jonathan.Cameron@huawei.com>
To: Dongsheng Yang <dongsheng.yang@linux.dev>
CC: <mpatocka@redhat.com>, <agk@redhat.com>, <snitzer@kernel.org>,
	<axboe@kernel.dk>, <hch@lst.de>, <dan.j.williams@intel.com>,
	<linux-block@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
	<linux-cxl@vger.kernel.org>, <nvdimm@lists.linux.dev>,
	<dm-devel@lists.linux.dev>
Subject: Re: [PATCH v1 02/11] dm-pcache: add backing device management
Message-ID: <20250701145650.00004e72@huawei.com>
In-Reply-To: <20250624073359.2041340-3-dongsheng.yang@linux.dev>
References: <20250624073359.2041340-1-dongsheng.yang@linux.dev>
	<20250624073359.2041340-3-dongsheng.yang@linux.dev>
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

On Tue, 24 Jun 2025 07:33:49 +0000
Dongsheng Yang <dongsheng.yang@linux.dev> wrote:

> This patch introduces *backing_dev.{c,h}*, a self-contained layer that
> handles all interaction with the *backing block device* where cache
> write-back and cache-miss reads are serviced.  Isolating this logic
> keeps the core dm-pcache code free of low-level bio plumbing.
>=20
> * Device setup / teardown
>   - Opens the target with `dm_get_device()`, stores `bdev`, file and
>     size, and initialises a dedicated `bioset`.
>   - Gracefully releases resources via `backing_dev_stop()`.
>=20
> * Request object (`struct pcache_backing_dev_req`)
>   - Two request flavours:
>     - REQ-type =E2=80=93 cloned from an upper `struct bio` issued to
>       dm-pcache; trimmed and re-targeted to the backing LBA.
>     - KMEM-type =E2=80=93 maps an arbitrary kernel memory buffer
>       into a freshly built.
>   - Private completion callback (`end_req`) propagates status to the
>     upper layer and handles resource recycling.
>=20
> * Submission & completion path
>   - Lock-protected submit queue + worker (`req_submit_work`) let pcache
>     push many requests asynchronously, at the same time, allow caller
>     to submit backing_dev_req in atomic context.
>   - End-io handler moves finished requests to a completion list processed
>     by `req_complete_work`, ensuring callbacks run in process context.
>   - Direct-submit option for non-atomic context.
>=20
> * Flush
>   - `backing_dev_flush()` issues a flush to persist backing-device data.
>=20
> Signed-off-by: Dongsheng Yang <dongsheng.yang@linux.dev>
> ---
>  drivers/md/dm-pcache/backing_dev.c | 292 +++++++++++++++++++++++++++++
>  drivers/md/dm-pcache/backing_dev.h |  88 +++++++++
>  2 files changed, 380 insertions(+)
>  create mode 100644 drivers/md/dm-pcache/backing_dev.c
>  create mode 100644 drivers/md/dm-pcache/backing_dev.h
>=20
> diff --git a/drivers/md/dm-pcache/backing_dev.c b/drivers/md/dm-pcache/ba=
cking_dev.c
> new file mode 100644
> index 000000000000..590c6415319d
> --- /dev/null
> +++ b/drivers/md/dm-pcache/backing_dev.c
> @@ -0,0 +1,292 @@
> +// SPDX-License-Identifier: GPL-2.0-or-later
> +#include <linux/blkdev.h>
> +
> +#include "../dm-core.h"
> +#include "pcache_internal.h"
> +#include "cache_dev.h"
> +#include "backing_dev.h"
> +#include "cache.h"
> +#include "dm_pcache.h"
> +
> +static void backing_dev_exit(struct pcache_backing_dev *backing_dev)
> +{
> +	kmem_cache_destroy(backing_dev->backing_req_cache);
> +}
> +
> +static void req_submit_fn(struct work_struct *work);
> +static void req_complete_fn(struct work_struct *work);
> +static int backing_dev_init(struct dm_pcache *pcache)
> +{
> +	struct pcache_backing_dev *backing_dev =3D &pcache->backing_dev;
> +	int ret;
> +
> +	backing_dev->backing_req_cache =3D KMEM_CACHE(pcache_backing_dev_req, 0=
);
> +	if (!backing_dev->backing_req_cache) {
> +		ret =3D -ENOMEM;

return -ENOMEM;=20

and drop the err label.

> +		goto err;
> +	}
> +
> +	INIT_LIST_HEAD(&backing_dev->submit_list);
> +	INIT_LIST_HEAD(&backing_dev->complete_list);
> +	spin_lock_init(&backing_dev->submit_lock);
> +	spin_lock_init(&backing_dev->complete_lock);
> +	INIT_WORK(&backing_dev->req_submit_work, req_submit_fn);
> +	INIT_WORK(&backing_dev->req_complete_work, req_complete_fn);
> +
> +	return 0;
> +err:
> +	return ret;
> +}

> +static void req_complete_fn(struct work_struct *work)
> +{
> +	struct pcache_backing_dev *backing_dev =3D container_of(work, struct pc=
ache_backing_dev, req_complete_work);

Very long line.  Wrap it somewhere.

> +	struct pcache_backing_dev_req *backing_req;
> +	LIST_HEAD(tmp_list);
> +
> +	spin_lock_irq(&backing_dev->complete_lock);
> +	list_splice_init(&backing_dev->complete_list, &tmp_list);
> +	spin_unlock_irq(&backing_dev->complete_lock);
> +
> +	while (!list_empty(&tmp_list)) {
> +		backing_req =3D list_first_entry(&tmp_list,
> +					    struct pcache_backing_dev_req, node);
> +		list_del_init(&backing_req->node);
> +		backing_dev_req_end(backing_req);
> +	}
> +}
> +
> +static void backing_dev_bio_end(struct bio *bio)
> +{
> +	struct pcache_backing_dev_req *backing_req =3D bio->bi_private;
> +	struct pcache_backing_dev *backing_dev =3D backing_req->backing_dev;
> +	unsigned long flags;
> +
> +	backing_req->ret =3D bio->bi_status;
> +
> +	spin_lock_irqsave(&backing_dev->complete_lock, flags);
> +	list_move_tail(&backing_req->node, &backing_dev->complete_list);
> +	queue_work(BACKING_DEV_TO_PCACHE(backing_dev)->task_wq, &backing_dev->r=
eq_complete_work);
> +	spin_unlock_irqrestore(&backing_dev->complete_lock, flags);
> +}
> +
> +static void req_submit_fn(struct work_struct *work)
> +{
> +	struct pcache_backing_dev *backing_dev =3D container_of(work, struct pc=
ache_backing_dev, req_submit_work);

Very long line.  Wrap after =3D


> +	struct pcache_backing_dev_req *backing_req;
> +	LIST_HEAD(tmp_list);
> +
> +	spin_lock(&backing_dev->submit_lock);
> +	list_splice_init(&backing_dev->submit_list, &tmp_list);
> +	spin_unlock(&backing_dev->submit_lock);
> +
> +	while (!list_empty(&tmp_list)) {
> +		backing_req =3D list_first_entry(&tmp_list,
> +					    struct pcache_backing_dev_req, node);
> +		list_del_init(&backing_req->node);
> +		submit_bio_noacct(&backing_req->bio);
> +	}
> +}

> +
> +static void bio_map(struct bio *bio, void *base, size_t size)
> +{
> +	struct page *page;
> +	unsigned int offset;
> +	unsigned int len;
> +
> +	if (!is_vmalloc_addr(base)) {
> +		page =3D virt_to_page(base);
> +		offset =3D offset_in_page(base);
> +
> +		BUG_ON(!bio_add_page(bio, page, size, offset));

		BUG_ON(!bio_add_page(bio, virt_to_page(base), size
				     offset_in_page(base));

Seems readable enough. Obviously that depends on whether those
local variables get more useage in later patches.

> +		return;
> +	}
> +
> +	flush_kernel_vmap_range(base, size);
> +	while (size) {
> +		page =3D vmalloc_to_page(base);
> +		offset =3D offset_in_page(base);
> +		len =3D min_t(size_t, PAGE_SIZE - offset, size);
> +
> +		BUG_ON(!bio_add_page(bio, page, len, offset));
> +		size -=3D len;
> +		base +=3D len;
> +	}
> +}

> +
> +static struct pcache_backing_dev_req *kmem_type_req_create(struct pcache=
_backing_dev *backing_dev,
> +						struct pcache_backing_dev_req_opts *opts)
> +{
> +	struct pcache_backing_dev_req *backing_req;
> +	struct bio *backing_bio;
> +	u32 n_vecs =3D get_n_vecs(opts->kmem.data, opts->kmem.len);
> +
> +	backing_req =3D kmem_cache_zalloc(backing_dev->backing_req_cache, opts-=
>gfp_mask);
> +	if (!backing_req)
> +		return NULL;
> +
> +	if (n_vecs > BACKING_DEV_REQ_INLINE_BVECS) {
> +		backing_req->kmem.bvecs =3D kmalloc_array(n_vecs, sizeof(struct bio_ve=
c), opts->gfp_mask);
> +		if (!backing_req->kmem.bvecs)
> +			goto err_free_req;
> +	} else {
> +		backing_req->kmem.bvecs =3D backing_req->kmem.inline_bvecs;
> +	}
> +
> +	backing_req->type =3D BACKING_DEV_REQ_TYPE_KMEM;
> +
> +	bio_init(&backing_req->bio, backing_dev->dm_dev->bdev, backing_req->kme=
m.bvecs,
> +			n_vecs, opts->kmem.opf);

Odd alignment.  Align second line under &

> +
> +	backing_bio =3D &backing_req->bio;
> +	bio_map(backing_bio, opts->kmem.data, opts->kmem.len);
> +
> +	backing_bio->bi_iter.bi_sector =3D (opts->kmem.backing_off) >> SECTOR_S=
HIFT;
> +	backing_bio->bi_private =3D backing_req;
> +	backing_bio->bi_end_io =3D backing_dev_bio_end;
> +
> +	backing_req->backing_dev =3D backing_dev;
> +	INIT_LIST_HEAD(&backing_req->node);
> +	backing_req->end_req	=3D opts->end_fn;
> +	backing_req->priv_data	=3D opts->priv_data;

Bit of a mixture of formatting between aligned =3D and not.  Pick one style.
I prefer never forcing alignment but others do like it.  I'm fine with that
too, just not a mix.


> +
> +	return backing_req;
> +
> +err_free_req:
> +	kmem_cache_free(backing_dev->backing_req_cache, backing_req);
> +	return NULL;
> +}
> +
> +struct pcache_backing_dev_req *backing_dev_req_create(struct pcache_back=
ing_dev *backing_dev,
> +						struct pcache_backing_dev_req_opts *opts)
> +{
> +	if (opts->type =3D=3D BACKING_DEV_REQ_TYPE_REQ)
> +		return req_type_req_create(backing_dev, opts);
> +	else if (opts->type =3D=3D BACKING_DEV_REQ_TYPE_KMEM)

returned in earlier branch so go with simpler

	if (opts->type..)

Or use a switch statement if you expect to get more entries in this over ti=
me.

> +		return kmem_type_req_create(backing_dev, opts);
> +
> +	return NULL;
> +}
> +
> +void backing_dev_flush(struct pcache_backing_dev *backing_dev)
> +{
> +	blkdev_issue_flush(backing_dev->dm_dev->bdev);
> +}


