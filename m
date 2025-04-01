Received: from mail-qk1-f171.google.com (mail-qk1-f171.google.com [209.85.222.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EEC33204F6A
	for <nvdimm@lists.linux.dev>; Tue,  1 Apr 2025 14:44:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.222.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743518662; cv=none; b=k/04RM0LpK+QMPjzuyurPV6CfHrEioKbWa+jisHHHKVhr+mZEwOvtKMyl2zao4x27EoZhOxZiKPmbSw37xlRImoVfGIJR4Ii+wMYo07r1WLJ/AW12NHemCzgSKv/wau9kOLZbGO3QjSBlaKVrm3ktDtafZaxZLaiqoBqVTD7BJA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743518662; c=relaxed/simple;
	bh=eiIdxMyFX8RWJTV9imHd+E2JMVAxGUjJHomwrwPuLMs=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Ytw/j3/ey/k2Yu7yTCg2pnFEm3QKumggE7/EJpXQxYjZ+YA4ECtuzEmo1CNzsgPPriCQ312iT3XqdL3gOy9KvTjurtmNmLYTUcn0ouS/pLyCvAifQgJg4OEZVCwKlax1EbC+tY6NO+nediC+voTwVHM/QHITcdfJdtnOSp0+uLY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=gourry.net; spf=pass smtp.mailfrom=gourry.net; dkim=pass (2048-bit key) header.d=gourry.net header.i=@gourry.net header.b=mKHtKIAn; arc=none smtp.client-ip=209.85.222.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=gourry.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gourry.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gourry.net header.i=@gourry.net header.b="mKHtKIAn"
Received: by mail-qk1-f171.google.com with SMTP id af79cd13be357-7c559b3eb0bso323565985a.1
        for <nvdimm@lists.linux.dev>; Tue, 01 Apr 2025 07:44:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gourry.net; s=google; t=1743518660; x=1744123460; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=7FWXvvIBXjd612osNxdIWGLZO1JiputvQXiNVM/ceGs=;
        b=mKHtKIAnoROptKV/zJAB4o74aZ/XgqqTtpCMUPv9/LzoBw2QdAJiLnesd5mNH1ua1+
         llt6hNIjqaVm6vX1bLYs+4h079rXKjlylwYYF2L0CyARSYcjPYNfHCysuAodZ3mDSiaW
         PBqY1Z2uHOSibuCSnGOPG1Qbvx52ssgiVY84DVV+RFg1pvV2ZGZ78kh3MuzPZ5SXxLDw
         nKU2ZXKw2H+j2Cv8uOt7iKwi0KkURY8D/1emT5vWN9SAntCtaozaGSOp+CJAC7Qj7OQk
         1B6k5frDH1NXA5LLaY3UjGL72RWY+bkSpSdv1KN0Q2zDa4NAO298OjNYZ8pBXeJnRK2Z
         XKww==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1743518660; x=1744123460;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=7FWXvvIBXjd612osNxdIWGLZO1JiputvQXiNVM/ceGs=;
        b=wMffzfEJkbSbvEDkhbuBX1UB/Pp2yI4ewzKbvmADrhIpBohapCYMGhlWcehYP9rYG9
         FOrNRogIZEKxm4cM5HMa5IefA3LA3xmInJC9Z6K74pYLZwlNzI9lmHS6JJMP0lqd0no0
         b79DDlktoAvjCXKFs6kI0swjpcJRe7aGUUHK3UzK3bTw0nvaWrYmeYKwb25rkdTTt6YA
         4Zf7HjM77QpLNnr8rqO2fi5Dxlp1qrKjuJsPNQ8n9J6W6riuTEebWkRzakwMISABq6M/
         librrXeJApVebGXGAczPsKeRX3sni3lRFYi6gTrikZI4/XoAEOk9JYGdQgdH5tz/SoIo
         oSuA==
X-Forwarded-Encrypted: i=1; AJvYcCWYwC6cjZ+YneBKabcjb3yDeKSL6O897mVohzD8jktIrBQANVBezWSa0tCbsLAw5G2xFw2/+Eo=@lists.linux.dev
X-Gm-Message-State: AOJu0Yzp5TJ9CpBhpTgVHcW5lWMK1WcDvjITGLhQPo7asKfvkThtrao7
	J7l5BUo6sewci+h4YT2G7l4hEavwfc6v9utUh6FhWIxFTqEEXLOfYD0bGN18e2Ud8lZOj088XG5
	1
X-Gm-Gg: ASbGncvgA1vOYiKVnE8giaf8p/BQk+dDz05GoFCJPACJahsvRw4DltpRoSgoPsfSr4h
	xK2s36evhapEwH1IJY1pXGogezNbb5ZdUxy0kw4ZdxfNPhX6tneKJX2OYW1LSmHwYEXVi7yEjQ8
	Sx6nQJAsAagbuatPUkB0hRW6ZZe9vP0DJqHOamSXtu/GzWERqh0xbQjnW1qKy7pydwtMl9wm11O
	7FTPBfe5CLyahc2x0Ks6SLoiVpfIRPm3aRBWwjCe2XM7JX5jVYyeuLbvnghIyBhclX8mOBUf9Xw
	vPnMv1brBKwuY5ya1a21Qglguq33lkJ7fUlNrFx+4752kf06uPKDy+zNv5x9MrpappEDeves5E3
	4bgZyLaA0IX2Gcy3eUjT6LkvEIVayzq3/NO6Z/g==
X-Google-Smtp-Source: AGHT+IHWAViNpa9KNwFeFv6Mk2L5a71FCOjF9YatoVlMWR+lTPKcPhRsuUJPd37s2vaScZLIZyzR/g==
X-Received: by 2002:a05:620a:4492:b0:7c5:5286:4369 with SMTP id af79cd13be357-7c69072eecemr1663920685a.28.1743518659907;
        Tue, 01 Apr 2025 07:44:19 -0700 (PDT)
Received: from gourry-fedora-PF4VCD3F (pool-173-79-56-208.washdc.fios.verizon.net. [173.79.56.208])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-6eec9627e9bsm62509246d6.15.2025.04.01.07.44.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 01 Apr 2025 07:44:19 -0700 (PDT)
Date: Tue, 1 Apr 2025 10:44:17 -0400
From: Gregory Price <gourry@gourry.net>
To: David Hildenbrand <david@redhat.com>
Cc: linux-cxl@vger.kernel.org, nvdimm@lists.linux.dev,
	linux-kernel@vger.kernel.org, kernel-team@meta.com,
	dan.j.williams@intel.com, vishal.l.verma@intel.com,
	dave.jiang@intel.com
Subject: Re: [PATCH] DAX: warn when kmem regions are truncated for memory
 block alignment.
Message-ID: <Z-v7waimV3OZq_1H@gourry-fedora-PF4VCD3F>
References: <20250321180731.568460-1-gourry@gourry.net>
 <88bce46e-a703-4935-b10e-638e33ea91b3@redhat.com>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <88bce46e-a703-4935-b10e-638e33ea91b3@redhat.com>

On Tue, Apr 01, 2025 at 11:47:32AM +0200, David Hildenbrand wrote:
> 
> Can't that be done a bit simpler?

Yes, this is better, lets do this.  Thank you!

> 
> diff --git a/drivers/dax/kmem.c b/drivers/dax/kmem.c
> index e97d47f42ee2e..23a68ff809cdf 100644
> --- a/drivers/dax/kmem.c
> +++ b/drivers/dax/kmem.c
> @@ -67,8 +67,8 @@ static void kmem_put_memory_types(void)
>  static int dev_dax_kmem_probe(struct dev_dax *dev_dax)
>  {
> +       unsigned long total_len = 0, orig_len = 0;
>         struct device *dev = &dev_dax->dev;
> -       unsigned long total_len = 0;
>         struct dax_kmem_data *data;
>         struct memory_dev_type *mtype;
>         int i, rc, mapped = 0;
> @@ -97,6 +97,7 @@ static int dev_dax_kmem_probe(struct dev_dax *dev_dax)
>         for (i = 0; i < dev_dax->nr_range; i++) {
>                 struct range range;
> +               orig_len += range_len(&dev_dax->ranges[i].range);
>                 rc = dax_kmem_range(dev_dax, i, &range);
>                 if (rc) {
>                         dev_info(dev, "mapping%d: %#llx-%#llx too small after alignment\n",
> @@ -109,6 +110,9 @@ static int dev_dax_kmem_probe(struct dev_dax *dev_dax)
>         if (!total_len) {
>                 dev_warn(dev, "rejecting DAX region without any memory after alignment\n");
>                 return -EINVAL;
> +       } else if (total_len != orig_len) {
> +               dev_warn(dev, "DAX region truncated by %lu bytes due to alignment\n",
> +                        orig_len - total_len);
>         }
>         init_node_memory_type(numa_node, mtype);
> 
> 
> -- 
> Cheers,
> 
> David / dhildenb
> 
