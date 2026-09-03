Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5296D4908BE;
	Thu,  3 Sep 2026 12:41:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788439320; cv=none; b=E2HdoGvZDg3Qn+orLr3OG5qLpXnU/+YL+ljX89uaovCQbTTbs5/4f1fT6D1y9YFP4O1EZSabix1MyrR1SUpXbX+cQr1sOxJ7pEWAbVRDVtbuSqAeSiIpgNJxgaA8039Aekii43W7NqIgonRy8ItmLBPnINQNL4mEYfrTlbidJ7E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788439320; c=relaxed/simple;
	bh=gXN0TkKx21WDgz2jrQy+dL0/OI1dCZs3zjYZiLynhVc=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=LQjcz5yduiJeBs3bu7mJnOUyfGDHhLNVa3D4UtbioaUAnmXocpKdG9lyCf/mrptmfaX6/izsnanSEVKsNWSvokhKJzMdKiQSM9GvaB5AUC5BLeSJM0ypnTrARSMciw0BYz1wI+2S8YqMBZIYEnjdrHxS4FL5F/YPnvXsN6Qvsz4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Hvnzly/+; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Hvnzly/+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C62D81F000E9;
	Thu,  3 Sep 2026 12:41:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788439319;
	bh=c2ktBh0LB+3cbCnYaFOkKw04DqytprWNIFmlIrDJ1dY=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=Hvnzly/+16SyCjufzvgsYfbGS5tVU2ytK9qdZwKjUuzzZM5pZvdNO4bsHur/AyCMj
	 4xy07eJgemY275ziZ/pYqV76DlvQ51oKGs9HcehWlbB9j7nAXdF6RORPNCPgOV7t7J
	 B/2//H59rcgC+9I2CS0ZlwSkCuX1POL0ZS/6Rj2OdeFlE1KlC6xc35j6nC6Jy8B9l+
	 NuA/Mn0ClJEoOYBEWpjMOG7xwXvllAcI4gfV+fut8X+rwxOsw9NVEflu+qe8kcQaNF
	 eiQv0pwNh6j3ZEPW7GpteW0Mqn5NOc2u6RkRbgk1OJZiIBSOLCccdMHHuGfvmA/RvT
	 PbWPXLi0SxpJQ==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH 2/4] nvdimm/pmem: avoid HWPoison flag updates for clean
 pages
Reply-To: sashiko-reviews@lists.linux.dev
To: "Muchun Song" <songmuchun@bytedance.com>
Cc: linux-cxl@vger.kernel.org, nvdimm@lists.linux.dev
In-Reply-To: <20260903122128.12264-3-songmuchun@bytedance.com>
References: <20260903122128.12264-1-songmuchun@bytedance.com>
 <20260903122128.12264-3-songmuchun@bytedance.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Thu, 03 Sep 2026 12:41:58 +0000
Message-Id: <20260903124158.C62D81F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>

Thank you for your contribution! Sashiko AI review found 2 potential issue(=
s) to consider:

Pre-existing issues:
- [High] Unaligned physical offsets or lengths can cause PG_hwpoison to be =
prematurely cleared on partially poisoned pages.
- [High] pmem_mkpage_present() fails to clear PG_hwpoison and MCE nospec st=
ate for poisoned tail pages when FS-DAX compound pages are used.
--

commit 70db5695d2bfd34aa8380a01c117956722afebc5
Author: Muchun Song <songmuchun@bytedance.com>

nvdimm/pmem: avoid HWPoison flag updates for clean pages

This commit updates pmem_mkpage_present() to avoid atomic clear operations
on clean PFNs. It checks PageHWPoison() before clearing the poison state,
preventing conflicts with FS-DAX vmemmap optimizations where clean PFNs
might be backed by shared read-only metadata.

> diff --git a/drivers/nvdimm/pmem.c b/drivers/nvdimm/pmem.c
> index 30a51c365ce8b..b14f75daeda78 100644
> --- a/drivers/nvdimm/pmem.c
> +++ b/drivers/nvdimm/pmem.c
> @@ -80,7 +80,7 @@ static void pmem_mkpage_present(struct pmem_device *pme=
m, phys_addr_t offset,

[Severity: High]
This isn't a bug introduced by this patch, but unaligned physical offsets or
lengths can cause PG_hwpoison to be prematurely cleared on partially poison=
ed
pages.

If pmem_do_write() processes a block I/O bio segment and calls
pmem_clear_poison(pmem, pmem_off, len) with an unaligned physical offset and
length resulting from a partial page write, it will eventually call:

pmem_mkpage_present(pmem, offset, cleared)

Which calculates the bounds earlier in this function:
    pfn_start =3D PHYS_PFN(phys);
    pfn_end =3D pfn_start + PHYS_PFN(len);

This truncates the physical address bounds. Does this mean the loop will
call test_and_clear_pmem_poison() for an entire PFN, even if only a subset
of its bytes were actually overwritten and cleared by hardware, causing the
kernel to lose memory failure tracking for the remaining poisoned bytes?

>  		 * here since we're in the driver I/O path and
>  		 * outstanding I/O requests pin the dev_pagemap.
>  		 */
> -		if (test_and_clear_pmem_poison(page))
> +		if (PageHWPoison(page) && test_and_clear_pmem_poison(page))

[Severity: High]
This is a pre-existing issue, but this conditional checks the tail page
directly rather than the compound head, failing to match the state set
during the memory failure.

If a hardware memory failure occurs on a tail page of an FS-DAX compound
folio, memory_failure_dev_pagemap() sets PG_hwpoison exclusively on the
head page. Because PageHWPoison(page) relies on PF_ANY which strictly
checks the provided page struct (the tail page), it evaluates to false.

Since this patch modifies this condition by adding PageHWPoison(page)
without resolving the compound page interaction, will clear_mce_nospec(pfn)
be skipped for the tail page, causing the head page to permanently retain
the PG_hwpoison flag?

>  			clear_mce_nospec(pfn);
>  	}
>  }

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260903122128.1226=
4-1-songmuchun@bytedance.com?part=3D2
