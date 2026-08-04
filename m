Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6DD4332B10D;
	Tue,  4 Aug 2026 07:08:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785827305; cv=none; b=GAP/PnsP9fuF0UDsfxJxe5P6qYjgetyGdz+/japLTtxEwpy/b7V2u2yRwusRsCNh/8gkye5kBremxtqiQUXVYwhZLP2i0OzGROC6EPhGJ7lUK0A1OsBKkP1lsk/q8/ZQunRIzWay/dI1DhmeILHVzLj/oMWAlTxDCluiEn5gVwM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785827305; c=relaxed/simple;
	bh=xgm68m3WzPKg3wVz6TnbLyATp/Wc9Gc5YYa3Xx01JFg=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=DUz0HbOzdcWxdWOlAjnrRn+qpJD9ByzkrvmdvihgeZCKksH6XFXQetdxZZZORm9SEntYwbjuBPxPboCFTCg3acW5U4h8yh3bGaJC+TfXzGC0wbZtTE6zHjDGHxjwSA/EBWfPWCJlmxsRNvEcZ3lqFis/BDhRq2118MYBsmotxFY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=bvj+QmZu; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="bvj+QmZu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5C0361F00A3A;
	Tue,  4 Aug 2026 07:08:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785827304;
	bh=LwMjNAixvj4gtZkxyVaGJ56c4/Xtz7ybK/1GS+leaEY=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=bvj+QmZuVP6H3vHvHFvqb176gIWcHX0YQ4544AcjIKRaSPLa7KWtNnc8aYzBsepOk
	 T3N372mokH7PgHQd2zZCnvAJnjkJJEGETCpJM44EMVj4RvMSBFNQKoWstCnq4zgL/S
	 yOwXsvJAjElXeyRf6uq6WV4ywjmFMrlCz7CtKNBsdTjsZj57EL+aSr2q1rIDiE9t61
	 3+bBcPAzpac22PNTCLFnjODzgLRehNeBZAXZsjl3/LMIVGGLY/heC6pMtjeJdHPowY
	 6umU7hMGuJjaLPeIS4ClNmkr+iGdWEF7NOAXRtFCsmyW0NuqlFcdgq4m2BF/vgMzYz
	 9ttsc8LILSRTQ==
From: sashiko-bot@kernel.org
Subject: Re: [RFC PATCH v1 1/3] blk-cgroup: add helpers for bio cgroup state
Reply-To: sashiko-reviews@lists.linux.dev
To: "Yu Kuai" <yukuai@kernel.org>
Cc: linux-raid@vger.kernel.org, yukuai@fygo.io, tj@kernel.org, hannes@cmpxchg.org, mkoutny@suse.com, nvdimm@lists.linux.dev
In-Reply-To: <20260804065313.2092022-2-yukuai@kernel.org>
References: <20260804065313.2092022-1-yukuai@kernel.org>
 <20260804065313.2092022-2-yukuai@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Tue, 04 Aug 2026 07:08:22 +0000
Message-Id: <20260804070823.5C0361F00A3A@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:

Pre-existing issues:
- [High] Potential Use-After-Free of `cgroup_subsys_state` (css) when re-as=
sociating a bio's block cgroup.
--

--- Patch [1]: [RFC PATCH v1 1/3] blk-cgroup: add helpers for bio cgroup st=
ate ---
commit 00d4f5448146c9d8e060d7ebf96b61cd64d0f752
Author: Yu Kuai <yukuai@fygo.io>

blk-cgroup: add helpers for bio cgroup state

This commit introduces helpers like bio_blkg() and bio_blkcg() to replace
open-coded cgroup state accesses throughout the block layer. The helpers
are applied to read-side and release paths to prepare for future changes
to bio internal cgroup state storage.

> diff --git a/block/blk-cgroup.c b/block/blk-cgroup.c
> index d9676126c5b5d..52e7faaff0e5b 100644
> --- a/block/blk-cgroup.c
> +++ b/block/blk-cgroup.c
> @@ -2113,8 +2113,8 @@ static inline struct blkcg_gq *blkg_tryget_closest(=
struct bio *bio,
>  void bio_associate_blkg_from_css(struct bio *bio,
>  				 struct cgroup_subsys_state *css)
>  {
> -	if (bio->bi_blkg)
> -		blkg_put(bio->bi_blkg);
> +	if (bio_blkg(bio))
> +		blkg_put(bio_blkg(bio));
> =20
>  	if (css && css->parent) {
>  		bio->bi_blkg =3D blkg_tryget_closest(bio, css);
> @@ -2141,7 +2141,7 @@ void bio_associate_blkg(struct bio *bio)
>  	if (blk_op_is_passthrough(bio->bi_opf))
>  		return;
> =20
> -	if (bio->bi_blkg) {
> +	if (bio_blkg(bio)) {
>  		css =3D bio_blkcg_css(bio);
>  		bio_associate_blkg_from_css(bio, css);

[Severity: High]
This is a pre-existing issue, but could this sequence lead to a use-after-f=
ree
of the cgroup_subsys_state (css)?

In bio_associate_blkg(), we extract the css pointer from the bio's blkg
without acquiring a new reference or holding an RCU read lock:

bio_associate_blkg()
    css =3D bio_blkcg_css(bio);
    bio_associate_blkg_from_css(bio, css);

Then in bio_associate_blkg_from_css(), we immediately drop the bio's blkg
reference:

bio_associate_blkg_from_css()
    if (bio_blkg(bio))
        blkg_put(bio_blkg(bio));
       =20
    if (css && css->parent) {  <-- potential UAF

If this was the final reference to the blkg (for example, if the cgroup was
removed while I/O was in-flight and a stacked block driver remaps the bio),
the blkg and its css are queued for destruction.=20

If the thread is preempted right after blkg_put(), could RCU grace periods
pass and the css memory be freed via workqueues before it is dereferenced
at css->parent?

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260804065313.2092=
022-1-yukuai@kernel.org?part=3D1
