Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D7F3F2594B9;
	Sun, 12 Jul 2026 15:54:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783871641; cv=none; b=lJ5h76sXOjELvRgSZw69WHcOtvnu8KXa0fX2UMcCFMtvEbfz17eAuGbY2ggvFMTOkhsHwQ3qMyWH8+pOMXU1kIVsDzZGDYK4T1q9MrmEYG+MpungrosPEIYas2vkyGd2kvN3aaEFSTd9vWleBF0PCtJgboRQkP6AUkO95VCKN94=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783871641; c=relaxed/simple;
	bh=VA5pM9YTYB1O1LYJ8eksuno7RXyL/y7y/YkS2ZMFbKU=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=BZ+z6725ZSAwRsspWlUs3BuXsUw+vqqedMF9YxgqRVRiS7p2RV/uvZmajamw7FFPeDSmpkdr0/OXq2ALYwRZEETPEoKPqFmTsWQ7POVkWWsnAmZwQeJzFS4Pzb9aPG5vGtHH4Rgp2M9Ge0OpLo2Y1dcnsAe/b2he0BQlx3a6l9s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=aBW1fyIs; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="aBW1fyIs"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5D1A91F000E9;
	Sun, 12 Jul 2026 15:54:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783871640;
	bh=9IbvVlOB5gSoINw8GGnbUxxg52nhacJrzrIDBVy2TP0=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=aBW1fyIsusJ2TUSq00XTL0b2dmitP8PSk42uTVYDFThT4hn7QxtViwuq+tiChdQxW
	 PJtSkMjL1q0gdMq9Tqomkz63817NdJ6HZv2qego1LcuITRhDh7HNook3MxuS80TAIC
	 sSROwu6uOI5WpweygceZJnLhO9WnTmwGs2jTc6HSa8LLVKPrcB8xC7ysdX4LZiY2n1
	 e0/+tj/isptuXk7SWNDaFabQ7eb7wuOm+TVVws07MvupkzwhUxkFp8khY3oc+BWSjb
	 492IvBSGOxPcnW0LUNbOjl/pkdPvR8S/dhpUhGo50f56ivNUMzHlKFxRDRnWOfHLK2
	 f3zjC1WBYHaGw==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v7 06/10] mm/memory_hotplug: add
 offline_and_remove_memory_ranges()
Reply-To: sashiko-reviews@lists.linux.dev
To: "Gregory Price" <gourry@gourry.net>
Cc: nvdimm@lists.linux.dev, linux-cxl@vger.kernel.org
In-Reply-To: <20260712154505.3564379-7-gourry@gourry.net>
References: <20260712154505.3564379-1-gourry@gourry.net>
 <20260712154505.3564379-7-gourry@gourry.net>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Sun, 12 Jul 2026 15:53:59 +0000
Message-Id: <20260712155400.5D1A91F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:
- [High] offline_and_remove_memory_ranges() silently discards errors from t=
ry_remove_memory(), falsely returning success and breaking all-or-nothing r=
ollback semantics.
--

--- Patch [6]: [PATCH v7 06/10] mm/memory_hotplug: add offline_and_remove_m=
emory_ranges() ---
commit 5dfae7d4a23ca17c8437f8cb92a4cc3f409e0c37
Author: Gregory Price <gourry@gourry.net>

mm/memory_hotplug: add offline_and_remove_memory_ranges()

This commit introduces offline_and_remove_memory_ranges() to handle the
offlining and removal of multiple memory ranges as a single atomic operation
under the device hotplug lock. It offlines all blocks first, reverting on
failure, before attempting to remove them.

> diff --git a/mm/memory_hotplug.c b/mm/memory_hotplug.c
> index a66346def504b..e33e0f4ae5da1 100644
> --- a/mm/memory_hotplug.c
> +++ b/mm/memory_hotplug.c
[ ... ]
> +int offline_and_remove_memory_ranges(const struct range *ranges,
> +		unsigned int nr_ranges)
> +{
[ ... ]
> +	/* Phase 2: Remove. This should never fail holding the hotplug lock */
> +	for (i =3D 0; i < nr_ranges; i++)
> +		WARN_ON_ONCE(try_remove_memory(ranges[i].start,
> +					       range_len(&ranges[i])));

[Severity: High]
If try_remove_memory() does happen to fail during Phase 2, does wrapping
it in WARN_ON_ONCE() silently discard the error code?

Since rc is not updated here, offline_and_remove_memory_ranges() would
return 0 (success) to the caller even if the removal failed.

Could this mislead the calling driver into freeing its device structures,
leaving the kernel's memory subsystem with stale references to unremoved
memory blocks?

> +
> +out_unlock:
>  	unlock_device_hotplug();
> =20
>  	kfree(online_types);
>  	return rc;
>  }
> +EXPORT_SYMBOL_GPL(offline_and_remove_memory_ranges);

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260712154505.3564=
379-1-gourry@gourry.net?part=3D6
