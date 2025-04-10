Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D34FE1EEA5D
	for <nvdimm@lists.linux.dev>; Thu, 10 Apr 2025 08:48:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744274909; cv=none; b=QKW+wwVxyIk9bb4eUQlWeGG6VsAB8tIjosv8O7MNDG74LVG6J/bzI+UMmN/EnletKsR9JXw8squLI28DYeG16YXplSVgl7U6pfyVgeXl4sPF2fgdVEKTZNUSMGHEcNCDSPXQK+fyfV8L+h99e3Lm4giVWHpzLm/wvWU4nqCO4C4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744274909; c=relaxed/simple;
	bh=47xCBNw7cruIIE4oNUTsPdgsxrE+vWzsHCO+aIbxmto=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=aoHzSpwh8bitqyetjFkRcUwlCMnwkEe2cRTeK1SLZ9ryW++7IJYzXBukcvbjxkMrL1KlbHX3vhYHcXxBr3Dy8r+ASXdh4gKs6GOiaYCaz07hGtwy6V/26ElzSzoU+iJ4IIOeoGd8MNRh9/3f+h5dEpHE/9rzJyG9jTnSS4zrL6w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=ZrS5xCvS; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="ZrS5xCvS"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=m4KfqS8TEuyZgijAbdlQez3pD7H6o8Hu2DstyvBPqHE=; b=ZrS5xCvSGPxJALvHKTyYaMkS/R
	pet5V59mbGQkMd3XVdIKe9+L37I0fCrDhsR531H1mYrMx72qDqCJ3xBBIGcvctEbkIEObT9Rr9RjJ
	JphX9jU8CQfmPSbu3GxHaFEfc6M5yaB1/9qAU87QhF9C4d5WJX/kNossy/KQSeEhaBgKWkM46IPLR
	fM7JqgtgcjYbCU3MNKtOWEQjq0TxG4NTt8XartOkevJVzz5FX1kaRrIW7FRgELE8rMOudFhM3+ldt
	oGRp9T/FmV15fMZy3or5y5n4FqDlQ/9OEzGlmiUrpQjCJv6+ejfE14F+4deXknvo/y7Rg8ft+qxrj
	L4zM+neQ==;
Received: from hch by bombadil.infradead.org with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1u2naD-00000009o1t-2QYA;
	Thu, 10 Apr 2025 08:48:25 +0000
Date: Thu, 10 Apr 2025 01:48:25 -0700
From: Christoph Hellwig <hch@infradead.org>
To: Dan Williams <dan.j.williams@intel.com>
Cc: David Hildenbrand <david@redhat.com>,
	Alison Schofield <alison.schofield@intel.com>,
	Alistair Popple <apopple@nvidia.com>, linux-mm@kvack.org,
	nvdimm@lists.linux.dev
Subject: Re: [BUG Report] 6.15-rc1 RIP:
 0010:__lruvec_stat_mod_folio+0x7e/0x250
Message-ID: <Z_eF2YOaidw6OmVZ@infradead.org>
References: <Z_W9Oeg-D9FhImf3@aschofie-mobl2.lan>
 <322e93d6-3fe2-48e9-84a9-c387cef41013@redhat.com>
 <89c869fe-6552-4c7b-ae32-f8179628cade@redhat.com>
 <67f6d3a52f77e_71fe294f0@dwillia2-xfh.jf.intel.com.notmuch>
 <edf48c4b-1652-4500-a2e0-1cb98a1f0477@redhat.com>
 <67f6e97a4dc0b_72052944@dwillia2-xfh.jf.intel.com.notmuch>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <67f6e97a4dc0b_72052944@dwillia2-xfh.jf.intel.com.notmuch>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

On Wed, Apr 09, 2025 at 02:41:14PM -0700, Dan Williams wrote:
> The p2p-dma use case does not map into userspace, and the device-dax
> case has static folio order for all potential folios. So I think this
> fix is only needed for fsdax.

p2pdma pages can be mapped to userspace.  Or do you mean something else?

