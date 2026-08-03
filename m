Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3FFAF489863;
	Mon,  3 Aug 2026 02:43:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785724996; cv=none; b=rx3mFsSZhUl/lqNAuN/2u08fu/aSD6uJjleV68a1Vb8stsjHOelRYeorZqeNCr0QKEtRLWlZ3Q1IDtsNXyXq+8EYBtAuPEjbCt1xteaNdmTkBaRdRkeVii6WHVQ4iUQBSOPc2krVdYYIWxm3Mh1FoQPAdFInpYBsU5XTOohW5EE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785724996; c=relaxed/simple;
	bh=6IOYUL9lqr/iKz2LORFvdM3XgMUjbYyUXZ078Zzscjs=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=nOqqbY3Fr4ebpeDWh36Hnq6ND4RA9Z0NIYEV0z+r7ptpgZ3PiivRg+1pUSm6T/7/YQQMyPA2tnCLF10YatgumSlwZWrozivX72U/ibqCik2VrQoWCHFRSO1m+l/K9/rTBY+WtpfmZkdQtU4kV3e5blNhTyaqblYCoIz0Hq0SUzk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ioiNcYA0; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ioiNcYA0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9CFD71F000E9;
	Mon,  3 Aug 2026 02:43:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785724994;
	bh=Infkt2jW5kOdgqPYlUx9VPeEYqbY/ZftLOMSPwCHsiE=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=ioiNcYA0n9XzP6DZ1b7AFnkbs7O/G5geKtD/MRp9WCvrR0agsTs8a9i0ND13eY/GC
	 JIklBFrUQz3dRPBd7Ki8IASlL+cQkDeOw+qHnN+thV/SyWnrLjpUPObpuBxgDbb6Mn
	 ju/SAw3wQkbepsr5e1I6rg+byHuSTTBzVcPzipqqDodjFiUa4x2gbTTaqGy8MeI3OH
	 D6pQCeyAjQBwgMp9MRi0sRe+DFcH5GtCGakePHnUWnENdHpxJLBAZtjTBCAODen7vW
	 46+1LB3T8mz0aahjKxFQM/6ca6wNdyx3GwqIR4PI7YjFv0nJOFLmcTUN4XnblngCAP
	 n9UAc0YuzxRkw==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH V12 01/12] dax: replace exported dax_dev_get() with
 non-allocating dax_dev_find()
Reply-To: sashiko-reviews@lists.linux.dev
To: "John Groves" <john@jagalactic.com>
Cc: linux-cxl@vger.kernel.org, nvdimm@lists.linux.dev
In-Reply-To: <0100019fc5737596-636bde4f-7fc7-46a4-b011-63870098df09-000000@email.amazonses.com>
References: <0100019fc572ca94-ec363dd7-3a77-484b-b4b7-f2503a0931a6-000000@email.amazonses.com>
 <20260803022817.75759-1-john@jagalactic.com>
 <0100019fc5737596-636bde4f-7fc7-46a4-b011-63870098df09-000000@email.amazonses.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Mon, 03 Aug 2026 02:43:14 +0000
Message-Id: <20260803024314.9CFD71F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:

Pre-existing issues:
- [High] Race Condition / Uninitialized Data Access during DAX device alloc=
ation.
--

--- Patch [1]: [PATCH V12 01/12] dax: replace exported dax_dev_get() with n=
on-allocating dax_dev_find() ---
commit ff957b44b15e4c0e4aaedcf9cd2d12118ab1bb27
Author: John Groves <John@Groves.net>

dax: replace exported dax_dev_get() with non-allocating dax_dev_find()

This patch introduces dax_dev_find() to look up existing DAX devices
without allocating a new inode, preventing empty inodes from being created
when external callers provide user-supplied device numbers. It also makes
dax_dev_get() static and updates external references.

> diff --git a/drivers/dax/super.c b/drivers/dax/super.c
> index 25cf99dd9360b..0fc14d4f81989 100644
> --- a/drivers/dax/super.c
> +++ b/drivers/dax/super.c
[ ... ]
> @@ -544,7 +544,41 @@ struct dax_device *dax_dev_get(dev_t devt)
> =20
>  	return dax_dev;
>  }
> -EXPORT_SYMBOL_GPL(dax_dev_get);
> +
> +/**
> + * dax_dev_find - look up an existing dax_device by dev_t
[ ... ]
> + */
> +struct dax_device *dax_dev_find(dev_t devt)
> +{
> +	struct dax_device *dax_dev;
> +	struct inode *inode;
> +	int id;
> +
> +	inode =3D ilookup5(dax_superblock, hash_32(devt + DAXFS_MAGIC, 31),
> +			 dax_test, &devt);
> +	if (!inode)
> +		return NULL;
> +
> +	dax_dev =3D to_dax_dev(inode);
> +	id =3D dax_read_lock();
> +	if (!dax_alive(dax_dev)) {
> +		dax_read_unlock(id);
> +		iput(inode);
> +		return NULL;
> +	}
> +	dax_read_unlock(id);
> +
> +	return dax_dev;
> +}

[Severity: High]
This isn't a bug introduced by this patch, but could a concurrent caller of
dax_dev_find() obtain a partially initialized device here?

In dax_dev_get(), unlock_new_inode() clears I_NEW and makes the DAX device
visible to ilookup5(). However, alloc_dax() sets the ops and private
pointers after dax_dev_get() returns:

alloc_dax() {
    ...
    dax_dev =3D dax_dev_get(devt);
    if (!dax_dev)
        goto err_dev;

    dax_dev->ops =3D ops;
    dax_dev->private =3D private;
    ...
}

Because dax_dev_find() retrieves the device from the inode cache and only
checks if DAXDEV_ALIVE is set, could an external caller using a guessed
device number observe NULL ops or private pointers?=20

If the external caller attempts to use the returned device before alloc_dax=
()
completes, could this lead to a NULL pointer dereference and kernel panic?

> +EXPORT_SYMBOL_GPL(dax_dev_find);

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/0100019fc572ca94-ec=
363dd7-3a77-484b-b4b7-f2503a0931a6-000000@email.amazonses.com?part=3D1
