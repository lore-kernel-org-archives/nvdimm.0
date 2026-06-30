Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 34C1C35CB7F
	for <nvdimm@lists.linux.dev>; Tue, 30 Jun 2026 10:42:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782816147; cv=none; b=sUr407Lh3dfGC9+aeDXCX50MVcGiOaY8ZZVMY65Fj5pfGl4BgvLJSzlQKqKydZBsLiOWGxLwDTJaIJP5XlCYjzGeHfebhlj+U8EiHPC4/Vk2XHNWvtpXKnO8fSaEs8ZwuR7Ig4ikAMsa9iiOJknl5PKwLlTk/YWykbRTfw20wy4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782816147; c=relaxed/simple;
	bh=rCyLnRgdpfbf2RaXDCaUSUhOwQzzu5+GtU8K1uvktHA=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=gWwsaprfo9KcAkwbYRWbvnr6z5kSxVMsqkQcftFJcK230wt0faCvN1K3JSwWzDY59wcCidMVoDVXY6Q2Q+vGZJV8VIdQIKuk36BDt7EUR5vD6a3PU0UiyPHbuUvfEOIPsHuBTNf3T3q2o1bk0N33b5FECEvhutji2zYNEgONESY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=m2NWzgE8; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="m2NWzgE8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0D78C1F000E9;
	Tue, 30 Jun 2026 10:42:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782816145;
	bh=7eIqYMLXmZ+K8dPf0eSDoSzLLmH/oFUTuk+jnwkhBAU=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=m2NWzgE8LVRQKCB5vKRWSuBM6Yidaa6tTK6vx7JtwqEIRZgP7WK+bYIUQoJQbmvaX
	 kdF88PHwMyBFreCuaqg1PI8OtLF+LZY6ZqMA+V6tCcABKzmpzMJV7oKA4a1+5nIrh2
	 1D1303B8ytOkLaGuxdKET5R9nyd0o53VgsKXdf0r3TgYcosBkHzeI7O8bxcrwZz6c5
	 e843LBfHIlXBEbrkh6zxlwoT0CgTGZNSzHeazLja/6+lzcprqdL8/BeZt/wOQ6RthP
	 4rMkzHZOo4Izz8aQZ8C2Go4tsqGfpPwrNPvSDdPzJYH7uA0AqJ9S7OZGsJgZ/vvRE3
	 5o9ofO4rH4gYg==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v7 05/12] nvdimm: virtio_pmem: use GFP_NOIO for flush
 requests
Reply-To: sashiko-reviews@lists.linux.dev
To: "Li Chen" <me@linux.beauty>
Cc: nvdimm@lists.linux.dev
In-Reply-To: <20260630092338.2094628-6-me@linux.beauty>
References: <20260630092338.2094628-1-me@linux.beauty>
 <20260630092338.2094628-6-me@linux.beauty>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Tue, 30 Jun 2026 10:42:24 +0000
Message-Id: <20260630104225.0D78C1F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:

Pre-existing issues:
- [High] Dynamic allocations with `GFP_NOIO` on the block IO submission pat=
h without a mempool cause spurious IO failures under memory pressure.
--

commit 74fa63081d89bf3b9f9f1dec68f5b9b9595e7390
Author: Li Chen <me@linux.beauty>

nvdimm: virtio_pmem: use GFP_NOIO for flush requests
   =20
virtio_pmem_flush() can run from pmem_submit_bio() while filesystem IO
is waiting on the flush completion. The request object allocation can
sleep, but it should not enter filesystem or block IO reclaim from this
flush path.

> diff --git a/drivers/nvdimm/nd_virtio.c b/drivers/nvdimm/nd_virtio.c
> index 8e16b7780be1a..a35044afddf34 100644
> --- a/drivers/nvdimm/nd_virtio.c
> +++ b/drivers/nvdimm/nd_virtio.c
> @@ -61,7 +61,7 @@ static int virtio_pmem_flush(struct nd_region *nd_regio=
n)
>  		return -EIO;
>  	}
> =20
> -	req_data =3D kmalloc_obj(*req_data);
> +	req_data =3D kmalloc_obj(*req_data, GFP_NOIO);

[Severity: High]
This is a pre-existing issue, but does this allocation lack a mempool?

Since this dynamically allocates memory on the block IO submission path
without a mempool, plain kmalloc with GFP_NOIO can fail under high
memory pressure because it does not wait indefinitely for reclaim.

When the allocation fails, virtio_pmem_flush() returns -ENOMEM, which
propagates up to pmem_submit_bio() as BLK_STS_RESOURCE. Since the block
layer does not retry BLK_STS_RESOURCE for bio-based drivers like pmem,
the error immediately propagates to the filesystem, potentially causing
unexpected data loss, read-only remounts, or journal aborts.

Should the request structure allocations here (and similarly in
async_pmem_flush()) be backed by a mempool_t to guarantee forward progress?

>  	if (!req_data)
>  		return -ENOMEM;
>

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260630092338.2094=
628-1-me@linux.beauty?part=3D5
