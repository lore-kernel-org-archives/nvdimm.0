Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 781B63BA225;
	Tue, 21 Jul 2026 20:49:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784666981; cv=none; b=MxtfU4hIjTHggGqd5HVmV1XCTTIksADxuOhwFaXCBqN5Up6IzWQARtw9Rj0gbsNcSClqOsUc09aY+I+gDeBPvNTMssxN5EJKf9KKNqEr+sO3AJuSYWSC6nR+ij/oq5JBAfAVblNr0mpRkaZCXuANDvA+lwbF3V3aze4MmUuNWiM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784666981; c=relaxed/simple;
	bh=Pj1fI84D5lpfNBclX82UKsGaNaYjILLyPjcrSTz0sAE=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=n15JnJttHPgUEmO+WvkCsaNCeV+kIFy6hPegv37V1N76qgF6A/IAEXlVzy8ke5e4qz9gyHfa0Y1y/qI0fMdTathm3mCNu0WyA/08PsR2NO++vzp/8mJy9aTEnEZIOW8JFS04AVS0/GkaeRyR57ND/SuIXSdYvnZa7WR9TNZmdfY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=LsWxTuw4; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="LsWxTuw4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C4B4F1F000E9;
	Tue, 21 Jul 2026 20:49:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784666980;
	bh=hnNX6VoBOpN3XW8q2pIpGNihQ4N8a+ztKf1fonXvn/Q=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=LsWxTuw4XmCVn/OQ1WxsIMNZHGU0S223esj1Mx4AzZEuG0FVwDMhWe0uOFWdu2oQj
	 oN5wPdFdK5WpvvFlzys/LpR9J4z0sqS/JJCYWLdw3ZBlL9L0MLiyok8TE/1bsYvfzv
	 yescxB16937BUgga1JyUL/tx0bmjnh9B5ZmoWe/1lnS/uWmyllSXl5QPhp0wtgY82M
	 rWM6wAysLeKvEgjhAJH9lAYCMgoAdq3YDa/oTE72qYKvcjt5YC7ZCCXFDrh9EwfVww
	 /wNnFLVYu9VtDVWOcAxvEw9eMGGgRL4o6LwYhqTgaCoAGuTV5CYZWfp0oGM22J2C22
	 7YYuLK8IfyeTQ==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v5 32/36] mm/khugepaged: base private node collapse
 eligiblity on actor/cap bits
Reply-To: sashiko-reviews@lists.linux.dev
To: "Gregory Price" <gourry@gourry.net>
Cc: kvm@vger.kernel.org, linux-cxl@vger.kernel.org, hannes@cmpxchg.org, nvdimm@lists.linux.dev, tj@kernel.org, mkoutny@suse.com, damon@lists.linux.dev
In-Reply-To: <20260720193431.3841992-33-gourry@gourry.net>
References: <20260720193431.3841992-1-gourry@gourry.net>
 <20260720193431.3841992-33-gourry@gourry.net>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Tue, 21 Jul 2026 20:49:39 +0000
Message-Id: <20260721204939.C4B4F1F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:
- [High] Missing `folio_allows_collapse()` checks in `collapse_scan_file` a=
llows khugepaged to silently migrate file-backed/shmem folios off private n=
odes.
--

--- Patch [32]: [PATCH v5 32/36] mm/khugepaged: base private node collapse =
eligiblity on actor/cap bits ---
commit e336e94fb86a5e84bcd43a7f17af3bf83d2b9126
Author: Gregory Price <gourry@gourry.net>

mm/khugepaged: base private node collapse eligiblity on actor/cap bits

Collapse can move base pages across nodes.  The khugepaged daemon does
this transparently, while MADV_COLLAPSE is a userland construct.

Isolate private nodes from khugepaged exactly like ZONE_DEVICE.
Never collapse private node folios silently (the owner may not
support migration).

> diff --git a/mm/khugepaged.c b/mm/khugepaged.c
> index fb4378cc17b10..5f20839857738 100644
> --- a/mm/khugepaged.c
> +++ b/mm/khugepaged.c
[ ... ]
> @@ -1687,7 +1696,8 @@ static enum scan_result collapse_scan_pmd(struct mm=
_struct *mm,
>  		}
> =20
>  		page =3D vm_normal_page(vma, addr, pteval);
> -		if (unlikely(!page) || unlikely(page_is_private_managed(page))) {
> +		if (unlikely(!page) ||
> +		    unlikely(!page_allows_collapse(page, cc->is_khugepaged))) {
>  			result =3D SCAN_PAGE_NULL;
>  			goto out_unmap;
>  		}

[Severity: High]
Since this patch updates collapse_scan_pmd() to check
page_allows_collapse(), does collapse_scan_file() need a similar check?

Looking at collapse_scan_file(), the loop scans folios and tallies their
residency without verifying collapse eligibility:

mm/khugepaged.c:collapse_scan_file() {
    ...
		node =3D folio_nid(folio);
		if (collapse_scan_abort(node, cc)) {
			result =3D SCAN_SCAN_ABORT;
			folio_put(folio);
			break;
		}
		cc->node_load[node]++;
    ...
}

If an unprivileged process maps file-backed memory to a private node, this
allows the scan to proceed. alloc_charge_folio() will then deny allocation
on the private node (since is_khugepaged is true) and fall back to a normal
node via ALLOC_DEFAULT.

Once the fallback THP is allocated, collapse_file() copies the memory from
the private node to the newly allocated THP on the normal node. Could this
result in a silent migration that bypasses the intended isolation guarantee=
s?

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260720193431.3841=
992-1-gourry@gourry.net?part=3D32
