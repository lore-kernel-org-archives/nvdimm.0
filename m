Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DEAB02F8E9F;
	Thu, 25 Jun 2026 18:19:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782411586; cv=none; b=XFL9UvbxCAW2m4JGiTK1V0DmUyQlvlqOGO1TIaaURqzfa8RwZSm4aQMY6n4j0cYFFnQLZ0ejVPGErC/6wOmj9o/PjNyQzhNR5TAMPByFi8vkUfINIU+pTuxoBG4bLKOHJWsonzxD/aRKVV2d/jeMofpiOmQVNIjZA+VPwvnPzqc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782411586; c=relaxed/simple;
	bh=LFpDp31rWkSWLBFtSvZWEG6R6DdfpeTikPQNTyvpoJc=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=ZoJsoDEedFuoh6CR951+us+MLiWaYoPa2fj23KmUerg/mOwKaNXbQAuuVijoAe7Ghz+HPIaydzY1u0iLV4id4j4tkI0aibGuufWz6GM5BO3gMtU7MvF71xsD2zdsrKu0Nvls4E/4E6E1DTMzmOZy25YbbcRqMZbRdu1n3JQmOrY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=oqtQbvnx; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="oqtQbvnx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 41C431F000E9;
	Thu, 25 Jun 2026 18:19:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782411585;
	bh=jwvxhbn3uBBmJLSWq2Pdqp83rjyhglXlEyp+dQYmeKo=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=oqtQbvnxlIodhdTbmHRndruTidEWjy17CujcjcJJa+bNAxv5JBx2O72/b4tqE5D3S
	 zYvsCEjnhKJno6wQasftl9/KV/7NrniQtE6Xg8AbIBTEOC6u1tSIM/gScAsBsbCx7u
	 LyMSNbVPgyeknrhH5yq5UbPeMBYuGnRsnKiThjG96DGn5AtsXLKBYhPghEyFHGzwSh
	 VZT7VYwnSG4NsypFzfUxLqe5vUS1DwaT5T9/6VMknzWpdHUsJqZ5anL9TOLDW7XVMH
	 zrWsQ7JOPqlzeb89UqScX1Mf2ufVpdybWfWFKlhpC/cizyXo7TTLwqF4TvO/6EQjUo
	 PKDbGxmPAGj/Q==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v11 15/31] cxl/mem: Drop misaligned DCD extent groups
Reply-To: sashiko-reviews@lists.linux.dev
To: "Anisa Su" <anisa.su887@gmail.com>
Cc: nvdimm@lists.linux.dev, linux-cxl@vger.kernel.org
In-Reply-To: <20260625112638.550691-16-anisa.su@samsung.com>
References: <20260625112638.550691-1-anisa.su@samsung.com>
 <20260625112638.550691-16-anisa.su@samsung.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Thu, 25 Jun 2026 18:19:44 +0000
Message-Id: <20260625181945.41C431F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:
- [Medium] Un-ratelimited `dev_warn` on invalid CXL device input can lead t=
o log flooding and Denial of Service.
--

commit 2eb192d0644cd71e7046e47b82d5b1422081590e
Author: Ira Weiny <iweiny@kernel.org>

cxl/mem: Drop misaligned DCD extent groups

This commit adds an alignment check to cxl_add_pending() to ensure that
extents in a tag group are aligned to the dax region's mapping granularity.
Misaligned extents now cause the entire group to be dropped.

> diff --git a/drivers/cxl/core/mbox.c b/drivers/cxl/core/mbox.c
> index 08f51b8807c06..14ba263044f08 100644
> --- a/drivers/cxl/core/mbox.c
> +++ b/drivers/cxl/core/mbox.c

[ ... ]

> @@ -1395,11 +1410,38 @@ static int cxl_realize_group(struct cxl_memdev_st=
ate *mds, const uuid_t *tag,
>  	return group_cnt;
>  }
> =20
> +/*
> + * Validate a tag @group before realizing it.  Returns 0 if the group ma=
y be
> + * added, or a negative errno if it must be dropped.  Further gates laye=
r in
> + * here in later commits.
> + */
> +static int cxl_validate_group(struct cxl_memdev_state *mds, const uuid_t=
 *tag,
> +			      struct list_head *group)
> +{
> +	struct device *dev =3D mds->cxlds.dev;
> +	struct cxl_extent_list_node *pos;
> +
> +	/* Alignment gate =E2=80=94 drop the group if any member fails */
> +	list_for_each_entry(pos, group, list) {
> +		if (!cxl_extent_dcd_aligned(pos->extent)) {
> +			dev_warn(dev,
> +				 "Tag %pUb: dropping group, extent DPA:%#llx LEN:%#llx not %#llx-ali=
gned\n",
> +				 tag,
> +				 le64_to_cpu(pos->extent->start_dpa),
> +				 le64_to_cpu(pos->extent->length),
> +				 (u64)PMD_SIZE);

[Severity: Medium]
Could this un-ratelimited dev_warn() lead to log flooding?

If a malfunctioning or compromised CXL device rapidly sends DCD_ADD_CAPACITY
events with misaligned extents, it appears this could spam the kernel log
and cause high CPU overhead.

Should this use dev_warn_ratelimited() instead, since it is driven by
untrusted device input?

> +			return -EINVAL;
> +		}
> +	}
> +
> +	return 0;
> +}

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260625112638.5506=
91-1-anisa.su@samsung.com?part=3D15
