Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4CED6388890;
	Tue, 21 Jul 2026 19:39:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784662762; cv=none; b=d/1hEnBGsgByjHtU9A8yTdfI2DWnkArTffrv6cwFZh3DH2ggJ5Pb+RCwNaMEXUUYeTztszLdlfXhxHQyPXzybe8j5rnLM2vthCGZQahZy5ZMN2T0O721eFNCzjQcS4fMylBX8IazJTIL2iTJA/0JMaDfjmU6cNOeVL57h7jXhZI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784662762; c=relaxed/simple;
	bh=6I2mzRPD2efxH5ezJODx7f5EXawKwwqqZtL+0lUQvB8=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=ZJdgLhpzYUQvK6vUkdamqf7E7dZnRntYGadFsEieX6yzh7tCLA/Ev8XIskQZnLuFRIrB0+OQKx9JV15dedro9GGYg+B8zBElY+278X609iAWB74X0aCknufDMMk1ZwaSoDM/awkU8lW7Pxp4LNh7Q2/9pXecuE+C74HHVJteymk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=IF0sei47; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="IF0sei47"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C2C801F000E9;
	Tue, 21 Jul 2026 19:39:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784662761;
	bh=YsBHmlj5+tRAdHhgE7kSAZ6hw87QmF4TUacxBMtdplQ=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=IF0sei47tSENllX2cJy95XbJe/3HBOu0gH2hN0zprQ7vUTHxn1OEz0dqFloETQkSu
	 yIqNEWIeS1VaRY8nuHwdsKwfjca79E94OOESXppp0/yp2w4nRIJhTZIgp4bZdnR3Na
	 93NCNChm/TLIIPympeynbIc4gZqeca9/NF2I5h+kCSxoPQ2k1zffeTls6MK2KyPL+B
	 VM6knDUbXuwhgoqAG//vK3eb3lZ9ECuHP4QYRiIbcHB2pNo/VAnZL7fDX7sB/sc4eT
	 vnulYl+ALk5QRQ3hzBTH+B0qGG2tmn9NHBfoJFbyvAnCv6Ad4g65P6AFdbW5npZCRW
	 rXV1X8VQ1M7Vw==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v5 23/36] mm/mempolicy: apply policy at the kernel zone
 for private-node binds
Reply-To: sashiko-reviews@lists.linux.dev
To: "Gregory Price" <gourry@gourry.net>
Cc: nvdimm@lists.linux.dev, kvm@vger.kernel.org, tj@kernel.org, linux-cxl@vger.kernel.org, hannes@cmpxchg.org, mkoutny@suse.com, damon@lists.linux.dev
In-Reply-To: <20260720193431.3841992-24-gourry@gourry.net>
References: <20260720193431.3841992-1-gourry@gourry.net>
 <20260720193431.3841992-24-gourry@gourry.net>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Tue, 21 Jul 2026 19:39:20 +0000
Message-Id: <20260721193920.C2C801F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:
- [Medium] The `policy_private_has_kernel_zone()` function incorrectly skip=
s checking `ZONE_DMA` and `ZONE_DMA32`, which causes mempolicy bypass for p=
rivate nodes possessing only lower-zone memory.
--

--- Patch [23]: [PATCH v5 23/36] mm/mempolicy: apply policy at the kernel z=
one for private-node binds ---
commit 04782bb72086af5fe29a7dbf4184affd04c79df6
Author: Gregory Price <gourry@gourry.net>

mm/mempolicy: apply policy at the kernel zone for private-node binds

This commit introduces policy_private_has_kernel_zone() to prevent mempolicy
bypass when private nodes have non-movable memory.

> diff --git a/mm/mempolicy.c b/mm/mempolicy.c
> index 90110e9761122..e83c2c7a94c1d 100644
> --- a/mm/mempolicy.c
> +++ b/mm/mempolicy.c
[ ... ]
> @@ -2091,6 +2091,34 @@ bool vma_policy_mof(struct vm_area_struct *vma)
[ ... ]
> +static bool policy_private_has_kernel_zone(const struct mempolicy *pol)
> +{
> +	int nid;
> +
> +	if (!(pol->flags & MPOL_F_PRIVATE))
> +		return false;
> +
> +	for_each_node_mask(nid, pol->nodes) {
> +		pg_data_t *pgdat =3D NODE_DATA(nid);
> +		enum zone_type zt;
> +
> +		if (!node_is_private(nid))
> +			continue;
> +		for (zt =3D ZONE_NORMAL; zt < ZONE_MOVABLE; zt++)

[Severity: Medium]
Does this loop miss checking ZONE_DMA and ZONE_DMA32 by starting at
ZONE_NORMAL?

If a user process sets a mempolicy binding to a private NUMA node that only
contains memory in ZONE_DMA or ZONE_DMA32, this loop will return false
because it skips those populated lower zones.

This would cause apply_policy_zone() to incorrectly raise
dynamic_policy_zone to ZONE_MOVABLE, resulting in kernel allocations
falling back to other system nodes and bypassing the policy intent.

> +			if (managed_zone(&pgdat->node_zones[zt]))
> +				return true;
> +	}
> +	return false;
> +}

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260720193431.3841=
992-1-gourry@gourry.net?part=3D23
