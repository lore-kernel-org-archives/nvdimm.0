Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 174662BEFEF;
	Tue,  4 Aug 2026 07:09:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785827373; cv=none; b=nWrVgfXNIu3vJ2cmcCJhQ8fxXsewnO7EIWWOLCLjkOUu9z7vrdpu5+mNzcEml38W6cXZ12pF3FwVcpmGEJKB0ikJLBG5ad8UJCeeh8f+T72sFJ0bqeP4rF5oEiazzeLFY+ht/F+qdclcsCTZzUIlmHj0Mmxb8Rh277YcdX6nxPc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785827373; c=relaxed/simple;
	bh=fqbdfwyRr4lUbv0g7EzimjYYy9ZuGoHX4ceMzDhwc7A=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=PY3HMnpwZfdc671sPJUKK/rmiVvBbuMVzxO331X2PKSf3yZjpg1C2pX1lpahlgnWNtl8W0flWto25IcRfnHuhyG+bh2J7cG5TEk9UsyIRws/pGAVP07R0z9tI+GvYU54lfSotNKO1/ZVCeDQv8cEwZUk1QntJotrqcEZyFksNl4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=RnvAlg2t; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="RnvAlg2t"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 487701F000E9;
	Tue,  4 Aug 2026 07:09:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785827371;
	bh=T7oBtBnnl+xCSWcV9lAewv1tRYAPkQ5SsiDuxXCuOqw=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=RnvAlg2tV0vrabje3ynLF3cxmcTPlLBpEXej/CK7uDHUfhd6T7Y4oBcUm/5GJTqyr
	 nk8Ci/6fjVgehjBffDNy8RcCz65ih55DprmpnnRMSMDpqTZExM46u/FkrtuqZXMC59
	 g2Boh2GVotsr2jYIWc6WyA+udkbWBjugXHrRZLUXqacPrp1e2zpf2vrrwlM2RRPuYM
	 eoYSwytfeVuxRx9GRt4szQvzuaZZuUTL9iq1GmzG0TbL9AFKI4jrqaksXzHWZssxoU
	 +GEOVzARyWp0/Ojm0RB5xoJDPpbYIZD3qw+/4zBLocmnXKLYfOPEJMmWDfPuCgNt4Y
	 EGeKmql9TUmRQ==
From: sashiko-bot@kernel.org
Subject: Re: [RFC PATCH v1 2/3] blk-cgroup: store blkcg in bio instead of
 blkg
Reply-To: sashiko-reviews@lists.linux.dev
To: "Yu Kuai" <yukuai@kernel.org>
Cc: hannes@cmpxchg.org, mkoutny@suse.com, linux-raid@vger.kernel.org, yukuai@fygo.io, nvdimm@lists.linux.dev, tj@kernel.org
In-Reply-To: <20260804065313.2092022-3-yukuai@kernel.org>
References: <20260804065313.2092022-1-yukuai@kernel.org>
 <20260804065313.2092022-3-yukuai@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Tue, 04 Aug 2026 07:09:30 +0000
Message-Id: <20260804070931.487701F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>

Thank you for your contribution! Sashiko AI review found 3 potential issue(=
s) to consider:
- [Critical] Dropping a bio's pinned `blkg` reference fails if the cgroup i=
s offlined while IO is in flight, leaking the originally pinned `blkg` and =
causing a reference underflow on the root `blkg`.
- [High] `bio_blkg()` returns NULL when blkg creation fails and it falls ba=
ck to an ancestor, leading to an immediate kernel panic in blk-throttle.
- [Medium] Standard IO statistics (io.stat) are silently dropped because th=
e block cgroup association no longer creates missing blkgs by default.
--

--- Patch [2]: [RFC PATCH v1 2/3] blk-cgroup: store blkcg in bio instead of=
 blkg ---
commit be98a58b9b6c0f35f61427866bf52e9085c5a028
Author: Yu Kuai <yukuai@fygo.io>
Subject: blk-cgroup: store blkcg in bio instead of blkg

A bio currently stores a queue-local blkg reference. This forces bio
association and remap paths to look up or create a blkg even when the bio
will never enter a blkcg policy. Store the blkcg css association in the
bio instead, and derive the blkg from the bio's blkcg and current bdev
when a policy needs it.

> diff --git a/block/blk-cgroup.c b/block/blk-cgroup.c
> index 52e7faaff0e5b..68a1d93e6584e 100644
> --- a/block/blk-cgroup.c
> +++ b/block/blk-cgroup.c
[ ... ]
> +static struct blkcg_gq *bio_pinned_blkg(struct bio *bio)
> +{
> +	struct request_queue *q =3D bdev_get_queue(bio->bi_bdev);
> +	struct blkcg_gq *blkg;
> +
> +	rcu_read_lock();
> +	blkg =3D blkg_lookup(bio_blkcg(bio), q);
> +	rcu_read_unlock();
> +
> +	if (WARN_ON_ONCE(!blkg))
> +		return q->root_blkg;
> +	return blkg;
> +}

[Severity: Critical]
How does this handle a cgroup being offlined while IO is in flight?
If an unprivileged user issues async IO and then immediately removes the
cgroup via rmdir, blkg_destroy() will remove the blkg from the radix tree.
When the bio completes, blkg_lookup() here will fail to find the child blkg
and fall back to returning q->root_blkg.

[ ... ]
> +void bio_put_blkg_ref(struct bio *bio)
> +{
> +	if (bio_flagged(bio, BIO_BLKG_REF)) {
> +		struct blkcg_gq *blkg =3D bio_pinned_blkg(bio);
> +
> +		blkg_put(blkg);
> +		bio_clear_flag(bio, BIO_BLKG_REF);
> +	}
> +}

[Severity: Critical]
Because bio_pinned_blkg() falls back to q->root_blkg when the child blkg is
no longer in the radix tree, blkg_put() here will drop the reference on the
root blkg instead of the actually pinned child blkg. Will this leak the
child blkg and eventually cause a use-after-free panic on the root blkg
due to the reference underflow?

[ ... ]
> +struct blkcg_gq *bio_blkg(struct bio *bio)
> +{
> +	struct blkcg *blkcg =3D bio_blkcg(bio);
> +	struct gendisk *disk;
> +	struct request_queue *q;
> +	struct blkcg_gq *blkg;
> +
> +	if (!blkcg || !bio->bi_bdev)
> +		return NULL;
> +
> +	if (bio_flagged(bio, BIO_BLKG_REF))
> +		return bio_pinned_blkg(bio);
> +
> +	disk =3D bio->bi_bdev->bd_disk;
> +	q =3D disk->queue;
> =20
>  	spin_lock_irq(&q->queue_lock);
> -	blkg =3D blkg_lookup_create(blkcg, bio->bi_bdev->bd_disk);
> -	if (blkg)
> -		blkg =3D blkg_lookup_tryget(blkg);
> +	blkg =3D blkg_lookup_create(blkcg, disk);
> +	if (blkg && blkg->blkcg =3D=3D blkcg && blkg_tryget(blkg))
> +		bio_set_flag(bio, BIO_BLKG_REF);
> +	else
> +		blkg =3D NULL;
>  	spin_unlock_irq(&q->queue_lock);
> =20
>  	return blkg;
>  }

[Severity: High]
Is it intentional to return NULL when blkg_lookup_create() falls back
to an ancestor? If blkg creation fails due to ENOMEM, it correctly
returns the closest alive ancestor. But this strict blkg->blkcg =3D=3D blkcg
check fails, explicitly returning NULL. Since blk-throttle unconditionally
dereferences the returned blkg (for example in __blk_throtl_bio() via
blkg_to_tg(blkg)->td), won't this cause a kernel panic under memory pressure
instead of gracefully falling back?

[ ... ]
>  void blk_cgroup_bio_start(struct bio *bio)
>  {
> -	struct blkcg_gq *blkg =3D bio_blkg(bio);
>  	struct blkcg *blkcg =3D bio_blkcg(bio);
> +	struct blkcg_gq *blkg;
>  	int rwd =3D blk_cgroup_io_type(bio), cpu;
>  	struct blkg_iostat_set *bis;
>  	unsigned long flags;
> =20
>  	if (!cgroup_subsys_on_dfl(io_cgrp_subsys))
>  		return;
> +	if (!blkcg)
> +		return;
> =20
>  	/* Root-level stats are sourced from system-wide IO stats */
>  	if (!cgroup_parent(blkcg->css.cgroup))
>  		return;
> =20
> +	blkg =3D bio_blkg_lookup(bio);
> +	if (!blkg)
> +		return;

[Severity: Medium]
Can this silently drop standard IO statistics (io.stat)? Before this
patch, bio_associate_blkg() proactively created the blkg. Now, missing
blkgs are not created by default. If no other active IO policy like
throttle or BFQ processes the bio and explicitly calls bio_blkg() to
create the hierarchy, bio_blkg_lookup() returns NULL and
blk_cgroup_bio_start() aborts. Does this completely lose cgroup IO accounti=
ng
on disks without active block IO policies?

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260804065313.2092=
022-1-yukuai@kernel.org?part=3D2
