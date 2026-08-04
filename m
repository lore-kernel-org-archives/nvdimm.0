Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A441C2D780A;
	Tue,  4 Aug 2026 07:10:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785827444; cv=none; b=P9MRShZJxa6dZR4ITVzzFO1tJ1RCpfywMzPd+6AGmIeyjevZ/jX7PIpPzs5dHbmTh10ivfOscPSIvP7BNJJczOWt8j0raLnQcVl3VflLQnMHcJnYFYGC+kUnffh8Qb3umQvrCMTh4l6A17IorBc1bHndWCd/pcDg4ZFKAIkxemA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785827444; c=relaxed/simple;
	bh=GZQ0y0cejOaRVDqKr07TqdUi+Fcjlpj4AZO74G66ZsI=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=qNxLZJjyxX/mX+taMjwVDmFKGaz4+Q2DRkhRH1N3ZYfexAD/7D47NyD/0+j4D7TWeYkosaFyK589FiHVF1X6a7VyIrQW+uy3IyDVo7jiTUg5m+k0ra2y9zQ/tTHZr+RV+T5vuzzsFitCAf0i0Ma3mYEyorvw0PTUgQW3qSg/3zY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=hHy0UiQd; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="hHy0UiQd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 695571F000E9;
	Tue,  4 Aug 2026 07:10:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785827443;
	bh=wk1lBiQK/dZ4RSeXqdSbfWN7G+bY/oBP7t1jJOCL9Eg=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=hHy0UiQdjUMW4nAiJmu2x7ciqfPZfSi+iJoJyQY5kjcIxEZSM0JMWY0zCJvEZnG8C
	 EEZSd4ur8FShsBFN62e7Yr03Ru7eTCEZe9cHODxQ1etXzDDWqDnxtiFEJwPS+OkY/H
	 YRvrqfGlwZOjKYm/PXMCmyijBbM7WCNZ6qA3NJfyJPZnR0EZ+0yOA9uMzeeg3QLj4H
	 3ElnBTPymqzqSX1q6yr6VEU37IOdau2oXiVROfzIcuWX7scowsThCSkXuUnD61yJo6
	 ms2B0aO11o3QxlQE3XogcxUlB07xeRZxmBVjk+tepXNZtHyCzW4IhBmFztVZoG6ea0
	 6vUvvBafWFduQ==
From: sashiko-bot@kernel.org
Subject: Re: [RFC PATCH v1 3/3] blk-cgroup: move async bio punt state to
 blkcg
Reply-To: sashiko-reviews@lists.linux.dev
To: "Yu Kuai" <yukuai@kernel.org>
Cc: hannes@cmpxchg.org, nvdimm@lists.linux.dev, yukuai@fygo.io, linux-raid@vger.kernel.org, tj@kernel.org, mkoutny@suse.com
In-Reply-To: <20260804065313.2092022-4-yukuai@kernel.org>
References: <20260804065313.2092022-1-yukuai@kernel.org>
 <20260804065313.2092022-4-yukuai@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Tue, 04 Aug 2026 07:10:41 +0000
Message-Id: <20260804071042.695571F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:

Pre-existing issues:
- [High] A race condition in `blkcg_punt_bio_submit()` allows a use-after-f=
ree on `struct blkcg` because `queue_work()` is called after dropping the l=
ock without holding a local reference to the cgroup.
--

--- Patch [3]: [RFC PATCH v1 3/3] blk-cgroup: move async bio punt state to =
blkcg ---
commit 0ed7c55259ed7cd55caede491e674b21be72ca58
Author: Yu Kuai <yukuai@fygo.io>

blk-cgroup: move async bio punt state to blkcg

This commit moves the async bio punt state from blkg to blkcg.
This preserves priority-inversion avoidance while preventing
blkcg_punt_bio_submit() from creating blkgs that are not needed
by any policy.

> diff --git a/block/blk-cgroup.c b/block/blk-cgroup.c
> index 68a1d93e6584e..a70f92f1541b1 100644
> --- a/block/blk-cgroup.c
> +++ b/block/blk-cgroup.c

[ ... ]

> @@ -239,15 +234,15 @@ static void blkg_async_bio_workfn(struct work_struc=
t *work)
>   */
>  void blkcg_punt_bio_submit(struct bio *bio)
>  {
> -	struct blkcg_gq *blkg =3D bio_blkg(bio);
> +	struct blkcg *blkcg =3D bio_blkcg(bio);
> =20
> -	if (blkg && blkg->parent) {
> -		spin_lock(&blkg->async_bio_lock);
> -		bio_list_add(&blkg->async_bios, bio);
> -		spin_unlock(&blkg->async_bio_lock);
> -		queue_work(blkcg_punt_bio_wq, &blkg->async_bio_work);
> +	if (blkcg && cgroup_parent(blkcg->css.cgroup)) {
> +		spin_lock(&blkcg->async_bio_lock);
> +		bio_list_add(&blkcg->async_bios, bio);
> +		spin_unlock(&blkcg->async_bio_lock);
> +		queue_work(blkcg_punt_bio_wq, &blkcg->async_bio_work);

[Severity: High]
This is a pre-existing issue, but could this race window between
spin_unlock() and queue_work() lead to a use-after-free on the blkcg struct=
ure?

If Thread A calls blkcg_punt_bio_submit(), places the bio into async_bios
under the spinlock, and is then preempted right after unlocking:

Thread A:
    spin_unlock(&blkcg->async_bio_lock);
    <preempted>

A concurrent worker thread might awaken, acquire the lock, extract the
newly added bio, and submit it. If the bio completes very quickly, it will
drop its css reference.

If this was the last reference keeping blkcg alive (e.g. if the cgroup was
being deleted), blkcg_css_free() could execute and free the blkcg:

blkcg_css_free()
    ...
    free_percpu(blkcg->lhead);
    kfree(blkcg);

When Thread A resumes, wouldn't it execute queue_work() on the freed blkcg
memory?

>  	} else {
> -		/* Never bounce if there is no non-root blkg to queue on. */
> +		/* Never bounce if there is no non-root blkcg to queue on. */
>  		submit_bio(bio);
>  	}
>  }

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260804065313.2092=
022-1-yukuai@kernel.org?part=3D3
