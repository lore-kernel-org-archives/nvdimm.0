Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2BC874A0EE2;
	Tue, 22 Sep 2026 08:37:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790066234; cv=none; b=gea53OzVe+XFnLlO7sBv4F74PsOrcdAeFcIjsP4jOWXkBoCTOB7HHDb+7ati2lteEpgt/Un7iYZBRmhFqcRcOo+T9SQYmnu2a6+hNWPEsOpD45V0jY+axIIKPAJUwfwL9l17Gbz5FNfN5GhQBXF73Z0livcP01vodc4IZcdh9Ck=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790066234; c=relaxed/simple;
	bh=mKEFetnlmInRxZ4QrsCg2KrnkuJ6bMnK6r6o6kagh4Y=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=U2oqxagvYUQdFhxQwoiK46uKhI/E8xx3a2kCT5sSNZvl6JgQAi3QzZgXNgxEE1xOU9XllLOUk+yLS5QX+Quq2o78RJMKqwF4AZ3EsH63yFONkulN42s70v+I1qB89F1V4q/HW4GMVEmV7fh8sXUPxK4UF9QO+bFavw6nc0vaQPY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=nwU6c9a6; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="nwU6c9a6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A89111F00893;
	Tue, 22 Sep 2026 08:37:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790066232;
	bh=ZLr4S/uTnb5phFIvk96AmLiMbU3VZWPrglSTTljzmmc=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=nwU6c9a6TEnLuagXpY3zmgL85NYu1lUe3gXUb0BpoGFQfYToIL9L3zeX8mwoL0VCN
	 0KZX44OESeRxm9OUou1axh++Ug3inQPnw0v9IGV8BHq+nCX1h8rGyHF/HUYMMyO9XQ
	 vrVn5sgSGGJbbenPxowS1oRLKL/f87ee1CKpuTqeFixlv127rofmi/GEQ3HGYhcZUp
	 CnEXeZZBIkLE3tiMkVei7itKtRC8vIJzuKz1U00DVKqRWi3Oz+iP+qJ9M6Cyv1ExcF
	 Zp7HkRChK/lyD802J3ygk+2i72o1KfHkDd0oBpVY7Lf5qyO6TdsQ1bxYrB3vp31iR7
	 2P7UdyiOdEroQ==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v2 2/2] dax/bus: fix Device DAX range alignment
 validation
Reply-To: sashiko-reviews@lists.linux.dev
To: "Muchun Song" <songmuchun@bytedance.com>
Cc: linux-cxl@vger.kernel.org, nvdimm@lists.linux.dev
In-Reply-To: <20260922082551.874901-3-songmuchun@bytedance.com>
References: <20260922082551.874901-1-songmuchun@bytedance.com>
 <20260922082551.874901-3-songmuchun@bytedance.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Tue, 22 Sep 2026 08:37:12 +0000
Message-Id: <20260922083712.A89111F00893@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:
- [Medium] dax: TOCTOU race in size_store causes partial shrink failure
--

commit 519db297333e73581e0bbd5524e7d6959d7610a7
Author: Muchun Song <muchun.song@linux.dev>

    dax/bus: fix Device DAX range alignment validation
   =20
    dev_dax->align describes the page size used by a Device DAX mapping.
    Both the start and size of every range must therefore be aligned to it;
    otherwise the starting PFN cannot represent a naturally aligned page of
    that size.

> diff --git a/drivers/dax/bus.c b/drivers/dax/bus.c
> index e40c25401cf06..277c3ce23b831 100644
> --- a/drivers/dax/bus.c
> +++ b/drivers/dax/bus.c
[ ... ]
> @@ -923,6 +964,9 @@ static int adjust_dev_dax_range(struct dev_dax *dev_d=
ax, struct resource *res, r
>  	if (dev_WARN_ONCE(dev, !size, "deletion is handled by dev_dax_shrink\n"=
))
>  		return -EINVAL;
> =20
> +	if (!range_is_aligned(dev_dax, range->start, size))
> +		return -EINVAL;
> +

[Severity: Medium]
Does this new strict alignment check introduce a regression where partial
shrink fails if the device alignment changes concurrently?

In the sysfs interface, size_store validates the size alignment before
acquiring dax_region_rwsem. If a root user concurrently writes to align_sto=
re
and changes the alignment requirement under lock, the shrink path proceeds
with an outdated alignment assumption.

During a shrink, dev_dax_shrink irreversibly deletes fully trailing ranges =
by
calling trim_dev_dax_range. When it reaches the final range to be partially
shrunk, it calls adjust_dev_dax_range.

If the concurrently updated alignment causes this new range_is_aligned check
to fail, it returns an error mid-operation after trailing ranges have alrea=
dy
been deleted.

Since sysfs writes require root privileges, can this time-of-check to
time-of-use race leave the local resource state corrupted, with the device
configuration permanently broken due to missing ranges and an inconsistent
size?

>  	rc =3D adjust_resource(res, range->start, size);
>  	if (rc)
>  		return rc;

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260922082551.8749=
01-1-songmuchun@bytedance.com?part=3D2
