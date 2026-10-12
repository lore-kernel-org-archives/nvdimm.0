Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C9F163D8902;
	Mon, 12 Oct 2026 14:48:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791816507; cv=none; b=V9jeSupatnJtCadgDL7ztlRr4zdhYmnDa8VAEMdcWMpSTCfHTdlypT53M+w5f5FHKvfD9FK/SCfS0+uSKupADHNhByAkS4Jn7lbIN6FSvp3UyM/0NF67mKQzfmZXxzqzeY+v5HZJe7e6tQvwwbxiln0KRt0mcIwEvOpWqfAJ5So=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791816507; c=relaxed/simple;
	bh=yIM8lxIM4nwOTva6lIHbyZD4GX0+4++YzhtQHCO8CdI=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=OOUnCHzJzS159BI6I2JpmYxtw27TqBh1BZPA+ViXKwjRYe0cBRJIGktOaqXlcopCvRqkFHwFO4h8ske0cOBMccxWhwCECGb3S9GTmNE5rLVsMye6r6SOL9IfQo/4rWQNDU3O+hxJXSHJxnVA1kFPDSRIhw06SDQb/KPg5wz4RS4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=LgSWFl0L; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="LgSWFl0L"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3EB501F0089B;
	Mon, 12 Oct 2026 14:48:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791816506;
	bh=2JmtNNGsQ6gXthWHmY2GYVjAYE1sxJ8hwkk0A4TdoEw=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=LgSWFl0LwEZyyzuM65lG114h7Bpi4nZtr/jB85mElHNJByp9zML/uwC/BSK3kMBC8
	 OtyFbDv7nDiAdeKYT2BQgeyBHkc0t0AtGZ+m8a2dyn2g+erU3NOzk/J+902OpFMb/4
	 ZdugfgNuq2bjLJ24aC1MNd/NtJRQJjPcwVm+LiCfSg5tiyMZhCfj+NK76P+hZPR8pM
	 PeAIXrc3lUo54cVrzgv+JlecebR7xeQakVVPLWz8KpCPL92EQplHC0EC+cr62e9vVL
	 mYEMd+NlvwfX7ZhgAbjRin1tuAaNaYZ/vTRyUnIZaMkTd9GOyEm7CuCK01SfUYFuNf
	 XIOlmKwjNVCWg==
Date: Mon, 12 Oct 2026 15:48:17 +0100
From: Jonathan Cameron <jic23@kernel.org>
To: jianyungao89@gmail.com
Cc: linux-kernel@vger.kernel.org, Dan Williams <djbw@kernel.org>, Vishal
 Verma <vishal.l.verma@intel.com>, Dave Jiang <dave.jiang@intel.com>, Alison
 Schofield <alison.schofield@intel.com>, nvdimm@lists.linux.dev (open
 list:DEVICE DIRECT ACCESS (DAX)), linux-cxl@vger.kernel.org (open
 list:DEVICE DIRECT ACCESS (DAX))
Subject: Re: [PATCH] dax: fix mapping_store() returning 0 instead of error
 code
Message-ID: <20261012154817.11c30692@jic23-hlaptop>
In-Reply-To: <20261011131857.30481-1-jianyungao89@gmail.com>
References: <20261011131857.30481-1-jianyungao89@gmail.com>
X-Mailer: Claws Mail 4.4.0 (GTK 3.24.52; x86_64-pc-linux-gnu)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Sun, 11 Oct 2026 21:18:57 +0800
jianyungao89@gmail.com wrote:

> From: Jianyun Gao <jianyungao89@gmail.com>
> 
> When the region driver is not loaded, mapping_store() returns rc
> which is 0 at that point, instead of an error code. Set it to
> -ENXIO to match the equivalent check in size_store().
> 
> Fixes: 9567da0b408a ("device-dax: Introduce bus + driver model")
> Signed-off-by: Jianyun Gao <jianyungao89@gmail.com>

Looks correct to me.
Reviewed-by: Jonathan Cameron <jonathan.cameron@oss.qualcomm.com>

I'm curious, found by inspection or some tool?

J

> ---
>  drivers/dax/bus.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/dax/bus.c b/drivers/dax/bus.c
> index b809e1a264af..262f97b5e7aa 100644
> --- a/drivers/dax/bus.c
> +++ b/drivers/dax/bus.c
> @@ -1192,7 +1192,7 @@ static ssize_t mapping_store(struct device *dev, struct device_attribute *attr,
>  		return rc;
>  	if (!dax_region->dev->driver) {
>  		up_write(&dax_region_rwsem);
> -		return rc;
> +		return -ENXIO;
>  	}
>  	rc = down_write_killable(&dax_dev_rwsem);
>  	if (rc) {

