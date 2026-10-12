Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D332F48EBF7;
	Mon, 12 Oct 2026 14:28:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791815320; cv=none; b=Gzew2OdgoSNC0+i2aIAxJnYjVZq4/nzWAl3fv0Rum/0MYRe6WN/ir/7P1/SjVIfODVzi0+igaKqUijMJVdt/qfOSAqoYEGKm03a6+AeFqgpUJm4Yx/0Qqwfxo/E37jCpLkTsbdTtcl7/SNQDGBrdFxvlD1Wo10csIPO+ZPAWDwk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791815320; c=relaxed/simple;
	bh=LSC1F0gNJ/tf/eKcy6aMkllJELOSTn3WRLxZHRhf+iM=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=cBkJ9llJPceP/VbW7F7oog5bXVGcrLI5rv/lAtkKbjDw2LbHB6ZoNGTuNu2au/LrMhcEA6gLE3Tc9Jok/D+6RvW5Q817iXCRNkpcS3UkJYZ++ZTDSq+E2HBEAzy9tKoXZqehAueNWB2UHOg5piTpu5LhzHTX8t4GbDIBYyPaLe4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=GcfbZTTg; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="GcfbZTTg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E317C1F0089B;
	Mon, 12 Oct 2026 14:28:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791815319;
	bh=7Ra23l3UluV2Cpx9BMhq8NI40t3M4atItfHJ192B4XQ=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=GcfbZTTgbU0fzk+m7DOLqejre/IO+PHAtVQLLD05wEBbqN6Ix6qcG+FzaUpQM5pfi
	 mDKkkPhL8npi39hBD9RtV4P2Bh6fD8dat3R0Jdj9CMD+ystKPFTBLNrf0fjhJ/QFoI
	 2PktMRB/yq3By/b9J3NHFBdeTLN7s0t2ga2MoxlwYBAupJesc9Uq/QdIEOnDPYjPbN
	 O8oiN5MtRfZ38OTAPaTdRqtlCWJg8Fvy+xyTwyvrcLBa5BsIe5UPrFUnGKZw61Zc+j
	 VTEideLjpP6kpWhGfV56rfzViBtrXNqsdVdYhRNruy4Kpzmf5EbaW4lH0DGkc668eW
	 7DdIq/vOhFwOg==
Date: Mon, 12 Oct 2026 15:28:30 +0100
From: Jonathan Cameron <jic23@kernel.org>
To: jianyungao89@gmail.com
Cc: linux-kernel@vger.kernel.org, Dan Williams <djbw@kernel.org>, Vishal
 Verma <vishal.l.verma@intel.com>, Dave Jiang <dave.jiang@intel.com>, Alison
 Schofield <alison.schofield@intel.com>, nvdimm@lists.linux.dev (open
 list:DEVICE DIRECT ACCESS (DAX)), linux-cxl@vger.kernel.org (open
 list:DEVICE DIRECT ACCESS (DAX))
Subject: Re: [PATCH] dax: fix dax_core_init error return code
Message-ID: <20261012152830.5406d532@jic23-hlaptop>
In-Reply-To: <20261011132017.31131-1-jianyungao89@gmail.com>
References: <20261011132017.31131-1-jianyungao89@gmail.com>
X-Mailer: Claws Mail 4.4.0 (GTK 3.24.52; x86_64-pc-linux-gnu)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Sun, 11 Oct 2026 21:20:17 +0800
jianyungao89@gmail.com wrote:

> From: Jianyun Gao <jianyungao89@gmail.com>
> 
> dax_core_init() mistakenly returns 0 on error paths. Change the
> error return to use rc so the actual error code is propagated
> to the caller.

What is the user visible impact of this failing?

> 
> Fixes: 9567da0b408a ("device-dax: Introduce bus + driver model")
> Signed-off-by: Jianyun Gao <jianyungao89@gmail.com>
> ---
>  drivers/dax/super.c | 5 +++--
>  1 file changed, 3 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/dax/super.c b/drivers/dax/super.c
> index 45f84b0eb909..0f35f65363ee 100644
> --- a/drivers/dax/super.c
> +++ b/drivers/dax/super.c
> @@ -723,7 +723,7 @@ static int __init dax_core_init(void)
>  
>  	rc = dax_fs_init();
>  	if (rc)
> -		return rc;
> +		goto err_fs;
I don't see an advantage in this bit.  It is a fairly common preference
to error out directly where there is nothing to do.

>  
>  	rc = alloc_chrdev_region(&dax_devt, 0, MINORMASK+1, "dax");
>  	if (rc)
> @@ -738,7 +738,8 @@ static int __init dax_core_init(void)
>  	unregister_chrdev_region(dax_devt, MINORMASK+1);
>  err_chrdev:
>  	dax_fs_exit();
> -	return 0;
> +err_fs:
> +	return rc;
I'm not sure about this one.  Will need input from the DAX
folk on whether they were deliberately eating the error return
here. Not that I can immediately think of a reason to do so!

Jonathan


>  }
>  
>  static void __exit dax_core_exit(void)

