Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 44C673D904C;
	Wed, 24 Jun 2026 15:11:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782313917; cv=none; b=WIVYmab25hxvz9TbWltsKf1piDChPORWhQyqX3QZTqucy9NKJilPIiZ89uZ8GsjhOXAzPyDXDTA3KqUZdQ5taMr5tIZNU75gBzuoiRSHrNHNywSd8BFAQbokeyosEQIYs52FE4lAQqy6vNPdw8hR/pN2PvRtabx5c6TzIFBzkMc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782313917; c=relaxed/simple;
	bh=kzEANo6DjOaCpZ+8fiCyntMzJeGE7BkX079aWkn7VAo=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=WtP36uHBTagCUXgynVMtypDy4k0FTVPAzltbulkZvw0D9T6C9znLvIjAEa+3ymu8QAfCmbQQqNbx/lQ1MWeJnVFrYsgKwBQLuM/3hHutCTlcLs/mUUvy7Zsf0NRFGj1bt72ICugkQPngOrz/IFavWcVr6Jm2F/wQUlk2WwroK1g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=iowoJVSl; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="iowoJVSl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E973D1F00A3A;
	Wed, 24 Jun 2026 15:11:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782313916;
	bh=7Xo6o8gTawcsZ4b1vzqu9qelyodwtCn46fA+SfwT+ps=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=iowoJVSlCi6ZpMgxQS31i42UFYDQAgSuoPxsZgeKo8vqd3DDnJQWj4KoJVV0zl78E
	 4C2OHIlp12oRIlArMfSfiucasTkKqWY3r/e1JKu3Wlnjb24F4hG5UfbQ2eE0KDN3AN
	 k9qXozEkpHzm90Ssn/tTlshdGkChOv4dz+sqBlVzMmNw5lRabsv1vWVtNd25t4ovHn
	 8pewrHAfTCo2pDFNq2GweAxttdYmbm6ZfCedcKxDGOcP1VaE9+zr0fa35FAhyfTi40
	 EosbqysxUQ6wmHc9ECxfduVA8RJ4xU07pw775KUJolL+Wyev6g8cEmUCBjcZNs0Z7R
	 DpusQTbfeMrrg==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v5 5/9] mm/memory_hotplug:
 offline_and_remove_memory_ranges()
Reply-To: sashiko-reviews@lists.linux.dev
To: "Gregory Price" <gourry@gourry.net>
Cc: nvdimm@lists.linux.dev, linux-cxl@vger.kernel.org
In-Reply-To: <20260624145744.3532049-6-gourry@gourry.net>
References: <20260624145744.3532049-1-gourry@gourry.net>
 <20260624145744.3532049-6-gourry@gourry.net>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Wed, 24 Jun 2026 15:11:55 +0000
Message-Id: <20260624151155.E973D1F00A3A@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:
- [High] Failure in Phase 2 causes partial memory unplug without structural=
 rollback, leading to permanently unmapped kernel memory and array pointer =
desynchronization.
--

commit e98e55bd875fd49e00562bd6591c9e44420c4e52
Author: Gregory Price <gourry@gourry.net>

mm/memory_hotplug: offline_and_remove_memory_ranges()

This commit adds offline_and_remove_memory_ranges() to offline and remove
multiple memory ranges atomically under a single lock_device_hotplug(). It
splits the operation into a phase that offlines all ranges, followed by a
phase that removes them, reverting the offline step if any failure occurs.

> diff --git a/mm/memory_hotplug.c b/mm/memory_hotplug.c
> index a66346def504b..7d56e0c6ede0c 100644
> --- a/mm/memory_hotplug.c
> +++ b/mm/memory_hotplug.c

[ ... ]

> @@ -2429,58 +2429,98 @@ static int try_reonline_memory_block(struct memor=
y_block *mem, void *arg)

[ ... ]

> +int offline_and_remove_memory_ranges(const struct range *ranges, int nr_=
ranges)
> +{

[ ... ]

> +	/*
> +	 * Phase 2: Remove each range. This essentially cannot fail as we hold
> +	 * the hotplug lock . WARN if that assumption is ever broken.
> +	 */
>  	if (!rc) {
> -		rc =3D try_remove_memory(start, size);
> -		if (rc)
> -			pr_err("%s: Failed to remove memory: %d", __func__, rc);
> +		for (i =3D 0; i < nr_ranges; i++) {
> +			rc =3D try_remove_memory(ranges[i].start,
> +					       range_len(&ranges[i]));
> +			if (WARN_ON_ONCE(rc)) {
> +				pr_err("%s: Failed to remove memory: %d",
> +				       __func__, rc);
> +				break;
> +			}
> +		}
>  	}
> =20
> -	/*
> -	 * Rollback what we did. While memory onlining might theoretically fail
> -	 * (nacked by a notifier), it barely ever happens.
> -	 */
> +	/* On fail: roll back. Blocks that were already offline are skipped */
>  	if (rc) {
>  		tmp =3D online_types;
> -		walk_memory_blocks(start, size, &tmp,
> -				   try_reonline_memory_block);
> +		for (i =3D 0; i < nr_ranges; i++)
> +			walk_memory_blocks(ranges[i].start,
> +					   range_len(&ranges[i]), &tmp,
> +					   try_reonline_memory_block);

[Severity: High]
What happens if try_remove_memory() fails for a subsequent range after
successfully removing an earlier one?

If rc is set and we break out of the phase 2 loop, we enter this rollback
path. For the ranges that were already successfully removed,
walk_memory_blocks() will skip their blocks because memory_block_get()
returns NULL:

drivers/base/memory.c:walk_memory_blocks() {
    ...
    for (block_id =3D start_block_id; block_id <=3D end_block_id; block_id+=
+) {
        mem =3D memory_block_get(block_id);
        if (!mem)
            continue;

        ret =3D func(mem, arg);
    ...
}

Because try_reonline_memory_block() is not called for these skipped blocks,
the tmp pointer into online_types won't be advanced. Could this cause the
rollback to apply the saved states of the removed blocks to the remaining
valid blocks, corrupting their state?

>  	}
>  	unlock_device_hotplug();
> =20
>  	kfree(online_types);
>  	return rc;
>  }

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260624145744.3532=
049-1-gourry@gourry.net?part=3D5
