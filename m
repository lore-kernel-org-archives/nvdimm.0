Received: from mail-oi1-f182.google.com (mail-oi1-f182.google.com [209.85.167.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2D7E929D26E
	for <nvdimm@lists.linux.dev>; Sat, 10 Jan 2026 19:13:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768072425; cv=none; b=f9+r6djCJIQzkilCYjQpizrtekHXPj9LTLsKim//v3n/ab4SEb1xtlvC+QWDhJHlTt6/L3OCUqUrmCn6Np3+wzS4NdxlL9byJbX2aX7OMOGxNG64UMgYO0wkrHceBpUb2jnLfg21d0UxqUo6nNrfp70eWLi8Pq2NPEX/0r+ICPc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768072425; c=relaxed/simple;
	bh=gsgoliyVDjM234wOQ6XNJCElfvV/BWp+oyiqwvbqWYk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=cMHO22G0x3X3v1SYNsQ+nxciDs946e7vAn4KF1Orzx3uGrRkYIREi068oGg+t+MnDYTMtXY2ug/QV28S6u6dg7BhFcmt/o9esUEtR75IJ9lqdlEqoVxI7JDP7QeDT8qMsZH2PLX9NRjnMFaOix77GaJn0XpsmftqYNcrG8awvd0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=groves.net; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=iZentYG6; arc=none smtp.client-ip=209.85.167.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=groves.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="iZentYG6"
Received: by mail-oi1-f182.google.com with SMTP id 5614622812f47-45358572a11so3244566b6e.3
        for <nvdimm@lists.linux.dev>; Sat, 10 Jan 2026 11:13:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1768072423; x=1768677223; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc:subject:date:message-id
         :reply-to;
        bh=Wc+4dGtNJwImkk4e3z1oLydA4nRcQFRWdxyLMHd1ydM=;
        b=iZentYG6m4EbvodXVxoT6TYIim912ukB3QJ16V3FS1J7OiekiPzzFxJ/aHBgVOS3sS
         e32qVlV0gxPQw5otFjVe0i+LkHU2uZLMTOQRAL62Z1OGqHSQVC3QgMTAsF//GDKXYMeU
         i9srwYl5JVhN+UQH6oAcm6GexXK68Zt17vofsHQwRQVWfXZALuUsyhA9OvfWVlLx6iqq
         EadVbpVhODOm3mLbI4BhzsYet2Z1MRG1xxQOcmJpKK/gEa9whTlCA9KMe8jIZTwuMKyI
         2sl/QbL/0fLiRIQj8t2kLcqPy3wM/QsFJjIB3h1HKw8AKRjeWmzBMmMg0TgglNkXITD6
         NVGg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1768072423; x=1768677223;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:x-gm-gg:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=Wc+4dGtNJwImkk4e3z1oLydA4nRcQFRWdxyLMHd1ydM=;
        b=OIaFf68KOE7HCx3idwiQPWhI8Yh4WTMAO4BNFtoKtWoWeR2wSexgBC4gtpkBjLMg4Y
         NjMtxBTxqAJWvKq6nUxw7akcFh8YQjlbGiu3PXhbZF9cO2b17waG4/FlDvHdDpBpV/hm
         DRgx+4GvWHr8CZxPzm/lg9NZTYPUonc1Z7ILUEIkea+pWzE6Fkch1Q+pbjeDAgS02XZ4
         CAdHYGglu7IhMP0q/0y5Rywdy+rGeV09oz3Sg5QpHVtrBvxfP3Hd65rXCwA6roB7nYXy
         W2yXLSrwuoAuR/N/1EKV7inSE59A7vRN12g7SFcN+oLkTtglzLuuLjlIMHICmkxCufRt
         eoKw==
X-Forwarded-Encrypted: i=1; AJvYcCU2k8zC/Udl+l2bvz5vCNTx+GEgFnVVsgYeS+PjfY9O7GHy1mTPlBtaw1dmVp9+toVDBTaTJxg=@lists.linux.dev
X-Gm-Message-State: AOJu0YyfksaNaOIfahgXcAiPLLQ6QzYWsfpJfNVNPrp2Qbf/cvUrn3Gf
	zPi9EhQKjjKNysj4oglvLvjL4zfEAGahFvMSyCtquYIHMnrcQBXS4LgU
X-Gm-Gg: AY/fxX6ANttO++JO7ioQ07gyhWJeXRzDIYUmZEfxnp/oEHei0865S2pyPyVQoHwGNg0
	um9CnUAUBSNMa4lqmOgnanWEOWwtkbE+FFKmskRcKYckiLlbvNUVQVgZu3RrVlv6kIZpShEiBNf
	s624q6rRA8Fu+4fakBcd83A8z5WaFEgJemtjcTEyml5DUH8faAybDrBQBbmA6QBEOViCo35QH5Z
	p2kxHCpVO9N9EhksCVVGw81/5l7ney6AC0OO0+rbs75byT6gT5vTJUJCECVqNI/TzhRz1okYWyn
	3QAjRIcbMQWYGa06glFlRLFJDhZGtXFB1E9ujdifFoMmNoT8TkDJkGhLlU/kY1tV+dVaDAFMfrC
	sB7eUBrBQWgMkw39vmLsg+EmOk8OeLp8Y9kOJzb5jIiKRmtd8RQTbJue8h/GgVyS5qGGePL/1dR
	l7UmPGJNH3Hi9EsPc2bTSSZW1Fxg1onZ38AKTOpkJL
X-Google-Smtp-Source: AGHT+IFQIHIwmdD3f0srffHy+uB/kjZS5o3+PdDs29M5EQ2Amx3bbRZ+yCxL3+7h4N3jY9ouVmS52A==
X-Received: by 2002:a05:6808:4f66:b0:45a:683b:7442 with SMTP id 5614622812f47-45a6bf0d211mr7204726b6e.65.1768072422851;
        Sat, 10 Jan 2026 11:13:42 -0800 (PST)
Received: from groves.net ([2603:8080:1500:3d89:7d36:1b0c:6e77:5735])
        by smtp.gmail.com with ESMTPSA id 586e51a60fabf-3ffa4a9099csm9257173fac.0.2026.01.10.11.13.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 10 Jan 2026 11:13:42 -0800 (PST)
Sender: John Groves <grovesaustin@gmail.com>
Date: Sat, 10 Jan 2026 13:13:41 -0600
From: John Groves <John@groves.net>
To: Dan Williams <dan.j.williams@intel.com>, 
	Vishal Verma <vishal.l.verma@intel.com>, Dave Jiang <dave.jiang@intel.com>, 
	Andrew Morton <akpm@linux-foundation.org>
Cc: John Groves <jgroves@micron.com>, 
	Joao Martins <joao.m.martins@oracle.com>, Jonathan Cameron <Jonathan.Cameron@huawei.com>, 
	David Hildenbrand <david@kernel.org>, Ying Huang <huang.ying.caritas@gmail.com>, 
	Aravind Ramesh <arramesh@micron.com>, Ajay Joshi <ajayjoshi@micron.com>, venkataravis@micron.com, 
	nvdimm@lists.linux.dev, linux-cxl@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Add some missing kerneldoc comment fields for struct
 dev_dax
Message-ID: <dpsovlsss4mwzao55t4clx4skxy7dtyka3igx55godmdq6rliw@kngcblth5yw3>
References: <20260110190723.5562-1-john@groves.net>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260110190723.5562-1-john@groves.net>

On 26/01/10 01:07PM, John Groves wrote:
> Add the missing @align and @memmap_on_memory fields to kerneldoc comment
> header for struct dev_dax.
> 
> Also, some other fields were followed by '-' and others by ':'. Fix all
> to be ':' for actual kerneldoc compliance.
> 
> Fixes: 33cf94d71766 ("device-dax: make align a per-device property")
> Fixes: 4eca0ef49af9 ("dax/kmem: allow kmem to add memory with memmap_on_memory")
> Signed-off-by: John Groves <john@groves.net>
> ---
>  drivers/dax/dax-private.h | 13 +++++++------
>  1 file changed, 7 insertions(+), 6 deletions(-)
> 
> diff --git a/drivers/dax/dax-private.h b/drivers/dax/dax-private.h
> index 0867115aeef2..a7c4ff258737 100644
> --- a/drivers/dax/dax-private.h
> +++ b/drivers/dax/dax-private.h
> @@ -65,16 +65,17 @@ struct dev_dax_range {
>  };
>  
>  /**
> - * struct dev_dax - instance data for a subdivision of a dax region, and
> - * data while the device is activated in the driver.
> - * @region - parent region
> - * @dax_dev - core dax functionality
> + * struct dev_dax - instance data for a subdivision of a dax region
> + * @region: parent region
> + * @dax_dev: core dax functionality
> + * @align: alignment of this instance
>   * @target_node: effective numa node if dev_dax memory range is onlined
>   * @dyn_id: is this a dynamic or statically created instance
>   * @id: ida allocated id when the dax_region is not static
>   * @ida: mapping id allocator
> - * @dev - device core
> - * @pgmap - pgmap for memmap setup / lifetime (driver owned)
> + * @dev: device core
> + * @pgmap: pgmap for memmap setup / lifetime (driver owned)
> + * @memmap_on_memory: allow kmem to put the memmap in the memory
>   * @nr_range: size of @ranges
>   * @ranges: range tuples of memory used
>   */
> 
> base-commit: 9ace4753a5202b02191d54e9fdf7f9e3d02b85eb
> -- 
> 2.52.0
> 

Oops, I somehow truncated the first line. V2 coming shortly.

Nothing to see here...

John

