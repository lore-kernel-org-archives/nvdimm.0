Received: from mail-yw1-f182.google.com (mail-yw1-f182.google.com [209.85.128.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7E4FE1A2547
	for <nvdimm@lists.linux.dev>; Wed,  9 Oct 2024 17:47:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728496046; cv=none; b=cVpGIICdo6Nci0xcOeYMcFGPhNeewPthzMF+xm11QYTjRSLxJLLULj+iUKv4YrbVzpVqpSo2k+6Fu7L0NAwwV9Y+ESVB9G1Eezy3X3ALYvlxGamPaivo1IwvgI0a+cE9Xdal8ZWtpdW2ebhIB9yx9mxkpNisPKMShqER3w0DYKE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728496046; c=relaxed/simple;
	bh=hrduq5hX72SJbr+Ep+RCPMEc9rDr01SBnYcCDcMmYbM=;
	h=From:Date:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=O8CaJbgxzXYV2HyEhkiABRuqWc/0GCj2Typqi4ezlNfciP13jydUzICgVRNC0y0k0U7VTHYXU6lnNLUY8rTBTd8cyxCPNj7ErNieaCm9vuZ17IOySRI4qyRa2F7RKX0ejLx9/Q+/6cpvFIsVp/1E29oIF865NiGbfyiqV/VbHHk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=SIO38Ymz; arc=none smtp.client-ip=209.85.128.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="SIO38Ymz"
Received: by mail-yw1-f182.google.com with SMTP id 00721157ae682-6e2b9e945b9so1313287b3.0
        for <nvdimm@lists.linux.dev>; Wed, 09 Oct 2024 10:47:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1728496043; x=1729100843; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:date:from:from:to:cc:subject:date:message-id:reply-to;
        bh=UC1+s/+UBvzxoqZUG6QZubGws8xau17tsJaWekZSoEE=;
        b=SIO38Ymzatn83D3vOBmK/mwS9J3MIp6cdi7n8o2WoIVjipvSkl1dZCq50OstRFMg8Q
         /XGfwJFH85zOHjoGEtbR5YJyKz57kXhekJwy8Uq1T1WkBjHkz6mcYDkWSQ1vC8yIWuRb
         j614ylhZfagx8ZSA0OSF/JA0p3DNEhHyzxK5LNwqvw5nYGSoEAKwLDLEaSlzVIm3+e/o
         XySeR10w25uWzYFR/7EpMj1nRlXz8GX6YSDxtcxGVp++tv9/JleJCiA4brnuGzPv179l
         BV07M5nwGN/AnXoAocgYvh9DVEBENyoaeLfoyCyrpoh8oKGMaBywxtC4U2ghdcIepKPE
         m/XA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1728496043; x=1729100843;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:date:from:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=UC1+s/+UBvzxoqZUG6QZubGws8xau17tsJaWekZSoEE=;
        b=ZfUi1RS739qqW0zrm7pxdV1tw2k26CWpshUmNcq3dTittYaS1a4NhE8LVPN3zOTJNC
         5JBax/ZTJ9BZHHfOc5VjvGX0YcvdoY0X5xn7xZjZUARFTv+OuzKAztkLpjiwclSe2c4e
         ySn5y7kFh2UsFY+jOq4uux2TdPDWtdpTMyDJmYPRyzG8dRE428+6Y4FT2YKZ9qNQWf8+
         n3J3LBVZEmIfLDxKpjNV3m8PYxn+t/Aq/RCWUtEMXAqnLAXAgkpa43KI2gXFe7NFzm0n
         Ngs5GPIrwPepXTXHuvy6ols2KAcnWQH10EmA8E3SYzcL34Da8AeU7vHHlD4tXHRH6D8Q
         0lrA==
X-Forwarded-Encrypted: i=1; AJvYcCUgaAMHPViNu6+S+yv2Zp7/syS00k9dyZBrhW3zXVbIiDgpk6T//tURMhudwNuo8rKo9OwO3QY=@lists.linux.dev
X-Gm-Message-State: AOJu0Yx5ZycYntUmMs7cFxrNUObilS7Ak4/S8GRjHzHHiKGKpnHUZDWj
	cM6bY9X6nIxB5FA+mOQshg9WId3gBMDWgncBJu/c6lAXZxcUoxJB
X-Google-Smtp-Source: AGHT+IF7Ewv221Glscvu1OZcOfztkqBqsRZZI6mFeYxOjowv6x9OgIFXt36jk+9E6Y2K+UdD8DipVA==
X-Received: by 2002:a05:690c:6a05:b0:6e2:63e:f087 with SMTP id 00721157ae682-6e3221f8577mr35924477b3.42.1728496043387;
        Wed, 09 Oct 2024 10:47:23 -0700 (PDT)
Received: from fan ([50.205.20.42])
        by smtp.gmail.com with ESMTPSA id 00721157ae682-6e2d93f7d31sm19219847b3.135.2024.10.09.10.47.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 09 Oct 2024 10:47:23 -0700 (PDT)
From: Fan Ni <nifan.cxl@gmail.com>
X-Google-Original-From: Fan Ni <fan.ni@samsung.com>
Date: Wed, 9 Oct 2024 10:47:20 -0700
To: Ira Weiny <ira.weiny@intel.com>
Cc: Dave Jiang <dave.jiang@intel.com>,
	Jonathan Cameron <Jonathan.Cameron@huawei.com>,
	Navneet Singh <navneet.singh@intel.com>,
	Jonathan Corbet <corbet@lwn.net>,
	Andrew Morton <akpm@linux-foundation.org>,
	Dan Williams <dan.j.williams@intel.com>,
	Davidlohr Bueso <dave@stgolabs.net>,
	Alison Schofield <alison.schofield@intel.com>,
	Vishal Verma <vishal.l.verma@intel.com>,
	linux-btrfs@vger.kernel.org, linux-cxl@vger.kernel.org,
	linux-doc@vger.kernel.org, nvdimm@lists.linux.dev,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH v4 06/28] cxl/pci: Delay event buffer allocation
Message-ID: <ZwbBqNnKXfNMTGEF@fan>
References: <20241007-dcd-type2-upstream-v4-0-c261ee6eeded@intel.com>
 <20241007-dcd-type2-upstream-v4-6-c261ee6eeded@intel.com>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20241007-dcd-type2-upstream-v4-6-c261ee6eeded@intel.com>

On Mon, Oct 07, 2024 at 06:16:12PM -0500, Ira Weiny wrote:
> The event buffer does not need to be allocated if something has failed in
> setting up event irq's.
> 
> In prep for adjusting event configuration for DCD events move the buffer
> allocation to the end of the event configuration.
> 
> Reviewed-by: Davidlohr Bueso <dave@stgolabs.net>
> Reviewed-by: Dave Jiang <dave.jiang@intel.com>
> Reviewed-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
> Signed-off-by: Ira Weiny <ira.weiny@intel.com>
> 

Reviewed-by: Fan Ni <fan.ni@samsung.com>

> ---
> Changes:
> [iweiny: keep tags for early simple patch]
> [Davidlohr, Jonathan, djiang: move to beginning of series]
> 	[Dave feel free to pick this up if you like]
> ---
>  drivers/cxl/pci.c | 8 ++++----
>  1 file changed, 4 insertions(+), 4 deletions(-)
> 
> diff --git a/drivers/cxl/pci.c b/drivers/cxl/pci.c
> index 37164174b5fb..0ccd6fd98b9d 100644
> --- a/drivers/cxl/pci.c
> +++ b/drivers/cxl/pci.c
> @@ -764,10 +764,6 @@ static int cxl_event_config(struct pci_host_bridge *host_bridge,
>  		return 0;
>  	}
>  
> -	rc = cxl_mem_alloc_event_buf(mds);
> -	if (rc)
> -		return rc;
> -
>  	rc = cxl_event_get_int_policy(mds, &policy);
>  	if (rc)
>  		return rc;
> @@ -781,6 +777,10 @@ static int cxl_event_config(struct pci_host_bridge *host_bridge,
>  		return -EBUSY;
>  	}
>  
> +	rc = cxl_mem_alloc_event_buf(mds);
> +	if (rc)
> +		return rc;
> +
>  	rc = cxl_event_irqsetup(mds);
>  	if (rc)
>  		return rc;
> 
> -- 
> 2.46.0
> 

-- 
Fan Ni
