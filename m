Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A88F2329E5A;
	Tue,  4 Aug 2026 00:16:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785802610; cv=none; b=GHMBN6cIMNUI64FRw+LbToOTFkrmZfk/PeNx0QsFrBNUjfZ24DSOz0nAahaZe4vLKP8/kpgFIeJKQB+rqrIIXOfpNBKdu6DWmbDPVc3yfQBSI0xs1wtvtZfUFw+qMD1b8kdyT+j4vBcwBgOTe6Q6cy9hjWXMu42ZoY+/YP3qZu8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785802610; c=relaxed/simple;
	bh=51+hOX2kVwxRfeyUxfro/F8L0bg11qfWyqwX/SnKS28=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=eF+SnS9t3Y1Mwid9i2fJrjMjQM3hHKVNX+N4b6nQz2h2WK++gegmhoDZchI6cVo8Pk1xTwC4hYsrAyqiCIG7EVssEoGibuGRMOC4eQcdGpYvSZ9AXitr1Nq+rf4N6FxaypRDWeGkkxLgXYw+P/9MS9znI/ApIvmKN08Nz43TE7g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=FnFZ9rHW; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="FnFZ9rHW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E7B301F000E9;
	Tue,  4 Aug 2026 00:16:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785802607;
	bh=6yoxi9AtZgvkBiWEDSsH8aOZN/3wvEkOo0S9Z2LrE4o=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=FnFZ9rHWi+ZEFoja/LkInuFGan/8m8uOL9h2yHesv6Rnezd/7QkShkpAHoZWRoMEQ
	 FhE+4lVKeeyuM52HKiRjjhb+u71SL3gr99rm8SbJlC54WzQB7t7F+g5BvxDLiRv1/1
	 fQXlV6GhH757nZRTgWbO4PzTtGXtXOjZPH+i0LBecgxpMfzj27MAL+HmelaWQ2Kub5
	 IohRHYPDT6bYr02ecKHhjUdwK8AvvkHRVYFqxyJ+sQHsIZTznswnTqG5fIClnas8eT
	 IKdzAYhDXfxP0Ct+x9qlUXAvvrAx/QFUz8SgdaSEhecSrl7NLarm6iSIkMpgDgD1Nx
	 ahzmQpKQgDm1w==
Date: Tue, 4 Aug 2026 01:16:40 +0100
From: Jonathan Cameron <jic23@kernel.org>
To: Anisa Su <anisa.su887@gmail.com>
Cc: linux-cxl@vger.kernel.org, nvdimm@lists.linux.dev,
 linux-kernel@vger.kernel.org, Dave Jiang <dave.jiang@intel.com>, Alison
 Schofield <alison.schofield@intel.com>, Fan Ni <nifan.cxl@gmail.com>, Li
 Ming <ming.li@zohomail.com>, Vishal Verma <vishal.l.verma@intel.com>,
 Davidlohr Bueso <dave@stgolabs.net>, Ira Weiny <iweiny@kernel.org>,
 Benjamin Cheatham <benjamin.cheatham@amd.com>, Wonjae Lee
 <wj28.lee@samsung.com>, Junhee Park <jh9934.park@samsung.com>, Heesoo Kim
 <habil.kim@samsung.com>, Anisa Su <anisa.su@samsung.com>
Subject: Re: [PATCH v12 8/8] cxl/core: Enforce partition order/simplify
 partition calls
Message-ID: <20260804011640.2749cf1f@jic23-huawei>
In-Reply-To: <20260731084901.1512819-9-anisa.su@samsung.com>
References: <20260731084901.1512819-1-anisa.su@samsung.com>
	<20260731084901.1512819-9-anisa.su@samsung.com>
X-Mailer: Claws Mail 4.4.0 (GTK 3.24.52; x86_64-pc-linux-gnu)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Fri, 31 Jul 2026 01:48:13 -0700
Anisa Su <anisa.su887@gmail.com> wrote:

> From: Ira Weiny <iweiny@kernel.org>
> 
> Device partitions have an implied order which is made more complex by
> the addition of a dynamic partition
> 
> Remove the ram special case information calls in favor of generic calls
> with a check ahead of time to ensure the preservation of the implied
> partition order.
> 
> Signed-off-by: Ira Weiny <iweiny@kernel.org>
> Signed-off-by: Anisa Su <anisa.su@samsung.com>
> Tested-by: Wonjae Lee <wj28.lee@samsung.com>
> Tested-by: Junhee Park <jh9934.park@samsung.com>
> Tested-by: Heesoo Kim <habil.kim@samsung.com>
> Reviewed-by: Dave Jiang <dave.jiang@intel.com>
Seems fine
Reviewed-by: Jonathan Cameron <jonathan.cameron@oss.qualcomm.com>
