Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DF87B388876
	for <nvdimm@lists.linux.dev>; Thu,  3 Sep 2026 05:12:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788412371; cv=none; b=fK2zYsW5lN6Gq50FVZnxKla/S66KbzYqvzTV5u928DtWucBR1N83GdTV/9py5G/cA6AN6CPu0o++9l3mooVHDEWuCX3eozw/eut5Ay0B/r9+cx5F5yofOfXlPwDMpmrTR4uUJ6u5FNPGUhHw2dv0iriDifQ3pdx5qFQrqvECjlE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788412371; c=relaxed/simple;
	bh=5dn3lRIZ2EgRWza5uyaU0WwNj0pCGMS6noiMVC1Ogjs=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=hidTamPsEr3x+o4cyafu9eRukJTd1Hh8AFa+AOr1XbJuYPOdFX3xwDr4zM3QOAZgthktJSG46nFL5262nhFX0Emfw4hvIHpPTGAy22ZGcwmRif8zo1EHIyBvolW6IaQSex9mWGeg3ZOg9YcVft1dnmJ0WzUg0g1x6JhArvS1rH0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ag7x9vTc; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ag7x9vTc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6F1661F000E9;
	Thu,  3 Sep 2026 05:12:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788412369;
	bh=8/t7iTOmcmnMpb67iroE7vFH0D4LD4LrnVpIFXulvy4=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=ag7x9vTcs+p+mIP/3ZYNgSWedFgRmnVj0O1WygxAVk5wa/4VWeP07YdkzIU4hZvK3
	 i3NWuaz2wla3fa/+0Wnd0hSZojer+A96zli91pXfKMtYX9cCMsRo57O9cHOpf6J9HS
	 mBBeI9uUit70NjSYsF6RU4GHh7ABGMKpyqnFzOUBh89NLIdAF6ikgUquX1+tmUUs8x
	 LmYxZgcYtNofja0Ze0TqtApfeMorvpOM5mwj0OTcXDhz/4Pbx0OFfB2ssbhGOj9UNZ
	 5lx2IqusZd9ynhSUJguHa38pkLjsaUQkU51T+r3XVoidZLq0TDXKOdjLPANWILNAFT
	 9/25zI0raqwrw==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH] fs/dax: Remove redundant deferred list initialization
Reply-To: sashiko-reviews@lists.linux.dev
To: "Kaitao Cheng" <kaitao.cheng@linux.dev>
Cc: nvdimm@lists.linux.dev
In-Reply-To: <20260903050207.7015-1-kaitao.cheng@linux.dev>
References: <20260903050207.7015-1-kaitao.cheng@linux.dev>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Thu, 03 Sep 2026 05:12:48 +0000
Message-Id: <20260903051249.6F1661F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:

Pre-existing issues:
- [Critical] dax_delete_mapping_range() splits PMD entries and causes dupli=
cate processing leading to nrpages underflow
--

commit ab9d688e10fd86aba4bb8d5161b095d144b422c0
Author: Kaitao Cheng <chengkaitao@kylinos.cn>

fs/dax: Remove redundant deferred list initialization

This commit removes the redundant initialization of folio->_deferred_list
for large DAX folios in dax_folio_init(). This is because prep_compound_hea=
d()
already handles it, leaving compound folio initialization centralized.

> diff --git a/fs/dax.c b/fs/dax.c
> index 1fbba0d21c13d..4ea0f13d53a65 100644
> --- a/fs/dax.c
> +++ b/fs/dax.c
[ ... ]

[Severity: Critical]
This isn't a bug introduced by this patch, but I noticed a potential
pre-existing issue in dax_delete_mapping_range() when it processes
multi-order DAX entries:

fs/dax.c:dax_delete_mapping_range() {
    ...
    XA_STATE(xas, &mapping->i_pages, start_idx);
    ...
    xas_for_each(&xas, entry, end_idx) {
        if (!xa_is_value(entry))
            continue;
        entry =3D wait_entry_unlocked_exclusive(&xas, entry);
        if (!entry)
            continue;
        dax_disassociate_entry(entry, mapping, true);
        xas_store(&xas, NULL);
        mapping->nrpages -=3D 1UL << dax_entry_order(entry);
        put_unlocked_entry(&xas, entry, WAKE_ALL);
    }
    ...
}

When deleting a mapping range on a DAX filesystem containing PMD-sized
entries, this loop uses an order-0 XA_STATE. If xas_store() encounters an
order-9 PMD entry, doesn't it split the entry into 512 order-0 entries
(one NULL and 511 copies of the PMD value)?

Because xas_advance() is not called after the store, will the iterator
continue to visit the remaining 511 split sibling slots and process the same
PMD entry again?

Since mapping->nrpages is decremented by 1UL << dax_entry_order(entry) (whi=
ch
is 512 for a PMD entry) on each iteration, could this underflow the counter=
 by
262,144 per PMD entry and result in catastrophic memory accounting corrupti=
on?

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260903050207.7015=
-1-kaitao.cheng@linux.dev?part=3D1
