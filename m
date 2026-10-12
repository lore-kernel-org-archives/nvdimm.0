Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E80A1418348;
	Mon, 12 Oct 2026 11:56:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791806192; cv=none; b=lz8iWj4p87eQDdySf+ZAmUu4qlCpc6RCUHkDfBDKYvF4+rcJfUi+pqtP0zkANkatmygV1SfcmuvQOIid9kc4ZgTjld5KYMfgIxYyinbuyFuEGIA5kjwFKBuCepixJfRMLJjx8k3QNsP6HNJ2QPDlp4prxYzXS2532qPF8fbu+4Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791806192; c=relaxed/simple;
	bh=ONuwEjTgCSaLDxzQxl+SiKkU9Cpl3gEfToe2nPLi0uE=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=dJGjNUS8qWgT3GKmGjvtJnVmcunjgNP9bCvdZmLkB4Hj4mfpE3c1ecRh2yCZ+Ic+07BIC9qggIyNfa5M8llRmbzqfrY/FfDHPbTcGsw6G20TW1g5yCjsYTyM3GIGA+2iYw+oGD0ptLkvkx7xy9d9M4oaYe4nGpw946uXoiBujYI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=c/UN5FDw; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="c/UN5FDw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6D8901F0089B;
	Mon, 12 Oct 2026 11:56:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791806190;
	bh=MahVg9N3cLVa4ehQhYTf13dkd1YOjdNRZ90BmZiPcLs=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=c/UN5FDwRQ6jwcCGzPTg70O5PuhAVO+VnskZiFaYq5LlMsOfYpJ7anUYSPEKAPH9f
	 P2x4QAemjz0U2sGVgaH2P/3AE6+IiZcDKoWKmFQVQteZxyJWTkeuuEIuJ7ZlPw+YlW
	 ig7hWkTG2XpMh6jeTPfKp714gWUg6pSnGuriKxK7/ZPubAO3iaPQcBOYr9vRlCkrYm
	 xR9hDy0RBzsz1mXT+kKt14U9ja745ACvp8nku9Fl1uAtZmTswe8hTtSq0Ng/HabDLM
	 VuKHfgBfMwjO2gn3nNTIM271tBOt6z+EUcQ+OeWbiQbIiN5fejj1Kx8f/q13VAisww
	 5IrLeuJWKcF4Q==
Date: Mon, 12 Oct 2026 12:56:08 +0100
From: Jonathan Cameron <jic23@kernel.org>
To: Anisa Su <anisa.su887@gmail.com>
Cc: linux-cxl@vger.kernel.org, nvdimm@lists.linux.dev,
 linux-kernel@vger.kernel.org, Dave Jiang <dave.jiang@intel.com>, Alison
 Schofield <alison.schofield@intel.com>, Davidlohr Bueso
 <dave@stgolabs.net>, Ira Weiny <iweiny@kernel.org>, Vishal Verma
 <vishal.l.verma@intel.com>, Fan Ni <nifan.cxl@gmail.com>, Li Ming
 <ming.li@zohomail.com>, Benjamin Cheatham <benjamin.cheatham@amd.com>,
 Gregory Price <gourry@gourry.net>, Richard Cheng <icheng@nvidia.com>, Anisa
 Su <anisa.su@samsung.com>
Subject: Re: [PATCH v16 3/8] cxl/cdat: Gather DSMAS data for DCD partitions
Message-ID: <20261012125608.4b7cbcd8@jic23-hlaptop>
In-Reply-To: <20261010225852.10727-4-anisa.su@samsung.com>
References: <20261010225852.10727-1-anisa.su@samsung.com>
	<20261010225852.10727-4-anisa.su@samsung.com>
X-Mailer: Claws Mail 4.4.0 (GTK 3.24.52; x86_64-pc-linux-gnu)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Sun, 11 Oct 2026 07:54:54 +0900
Anisa Su <anisa.su887@gmail.com> wrote:

> From: Ira Weiny <iweiny@kernel.org>
> 
> Additional DCD partition (AKA region) information is contained in the
> DSMAS CDAT tables, including performance, shareable and read-only
> attributes.
> 
> Match DCD partitions with DSMAS tables and store the meta data. A DCD
> shall describe its DC partition in a DSMAS entry (CXL r4.0 9.13.3), so
> if the CDAT is absent, fails to parse, or has no entry matching the DC
> partition, disable DCD rather than run with unknown attributes.
> 
> DSLBIS is optional, but cxl_cdat_endpoint_process() treated zero DSLBIS
> entries as a parse failure, which would now disable DCD on a device with
> a valid DSMAS. Accept an empty DSLBIS, and skip DSMAS entries with no
> DSLBIS coordinates.
> 
> Signed-off-by: Ira Weiny <iweiny@kernel.org>
> Co-developed-by: Anisa Su <anisa.su@samsung.com>
> Signed-off-by: Anisa Su <anisa.su@samsung.com>
> Tested-by: Wonjae Lee <wj28.lee@samsung.com>
> Tested-by: Junhee Park <jh9934.park@samsung.com>
> Tested-by: Heesoo Kim <habil.kim@samsung.com>
> Reviewed-by: Alison Schofield <alison.schofield@intel.com>
> 
Reviewed-by: Jonathan Cameron <jonathan.cameron@oss.qualcomm.com>
