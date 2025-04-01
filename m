Received: from mail-qk1-f172.google.com (mail-qk1-f172.google.com [209.85.222.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 198E12147E8
	for <nvdimm@lists.linux.dev>; Tue,  1 Apr 2025 18:27:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.222.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743532027; cv=none; b=pYcH+t/3QQmV/pfAvSoyLQQsyeMm/o0TKaW2ejTmM7FFGclwNcdC4cpXEOlUOPjWYRXeCPxPGFBNHDINTkJDQsus/dTLLC813+nAz7GHzB6zt9o2fBAlHBB1g3RdL3Bfvy0A+ALr8OCBDAiIGKPaJfMk31js3je9A+ukXenuncI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743532027; c=relaxed/simple;
	bh=VmOW25Uu18kqJ/Q/c2B326aYuZrol3Vn7zIK9xewLxU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=CS2lJTgMjYN919kl0YIuk1HxjZQ4uvTCIfd5Ap+gps+nz5r5QjomVfuQwTuzLa7E7YfzVGU/doGXnX3HWM4dkqqKo7FD0MmhoYoGKCiEvYCSfnkT1RQDnETErtjeXwvPbVPQJhkhBgGDO1ZukmEse0/VE7FN9bFFuLCmw1ZC/2I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=gourry.net; spf=pass smtp.mailfrom=gourry.net; dkim=pass (2048-bit key) header.d=gourry.net header.i=@gourry.net header.b=X46dBT2s; arc=none smtp.client-ip=209.85.222.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=gourry.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gourry.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gourry.net header.i=@gourry.net header.b="X46dBT2s"
Received: by mail-qk1-f172.google.com with SMTP id af79cd13be357-7c58974ed57so613453585a.2
        for <nvdimm@lists.linux.dev>; Tue, 01 Apr 2025 11:27:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gourry.net; s=google; t=1743532023; x=1744136823; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=R4nLQiuuG0BM5akZJEC7W4RuhjTkTJm6pS8m+94wOjs=;
        b=X46dBT2s7whDHEgsjinl+DKvPhpBi6REAFuZ/5nF7y+7kJxwJieL4Qo6NI2ojAhBHS
         abwmZK42gwAcrc7V8m0MMkr9MQSQLdzGZP2l5E6lyjvObz0iqg9QNxBp2H9il6VYUiM6
         aqBGfJqV1JesngFU+KXbDuiqwkSR7+A7B2rb1SzrEc+W9mE+Fq26Jiix8SYyXtHBeEl2
         EniKpYFhXzqjzkT0PQxRf8NTZLbV59lb0Zs9OTujRzLodE3x1zaEY+PT8yASxPdszF5y
         xJO6UlbfC6RrzJri/SWRzjzBwgrV/MJcJFSellNF+qrN6mdDRpmMfPFLNVDw8Twcilo3
         kqKg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1743532023; x=1744136823;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=R4nLQiuuG0BM5akZJEC7W4RuhjTkTJm6pS8m+94wOjs=;
        b=M4Cgk4LFU03zI17m2sE1Ff1AjBBtqrq7wX5GUhKT17EJ6ignaamDijJFrSQPDtUoaN
         GE63UUxKgIIGIViDrLbGNGJx4l08kvL4IUQwOSo3Mi3i9pyUvHCjHJ/bEbuyGAV3ilwO
         afMhP3LxSjb/w/E5V5EwuxTakQm7SHgrXvDaJ+lcEEwRJxsD7Bl73Qwu6DalSUaSC753
         iJNRmUERmfaZaBm69FXi3sy1fpkT5LyQPB86yjzKa1yI2CeeFXY1b59Gwyv0j0swp38N
         KMgUpDdAhMFZbro8BZfnZ6eau1OJiFY/2ABOjUKhfyery8EbyxDi5A8rARf5+/TV/nDp
         BD9w==
X-Forwarded-Encrypted: i=1; AJvYcCWs5XY7Qt/hIN9xvw6w+TFlPGn86bQmSg4Fd4jvapUep9Muo/V516d7V9wIy14jP71qYuz19Mk=@lists.linux.dev
X-Gm-Message-State: AOJu0YzSG7x7yqpXn303qRV6sSGfI3yBVq/M+wpwsRLz1AJvPR79jdf7
	SpFDRAtitOADrL6vuGa+6kBbcvhDNiwgirfFCXruMTztbRuGhUAshrqfkvnLnmI=
X-Gm-Gg: ASbGnctNJXFOYw6FN2EBVVChwrX4TDvLJFR3x0Q2SJcenK2z6td52KGoBfnq6Gjn5sG
	B0PVnTPsNq9e+peD+GEb7W6kT1Yf8kw7TQ1VYpgXW+cHxsR9sjNl/2N1XBdD6uRXdOhsPYOCgAl
	fCep/sVP7Dmy7Zu7yMGdCjRw6KlWDs17XE7pW+wPa4jOQ5WKvg9QNpUSZJyqnkG1ZG88ltgQgOg
	8KoLSdkAqpTmLbVydrqbNKTumOMEnyK6g5kE3bpE/jBmf6FlkLg/sCO7UtLbvozL8yESafz7wbx
	Ap0TfaAXTbhXG1p5TUzlOJ4Q5nbNvSvu6VLsvunTZLnLWpxUc/BvM7xaGVeWxXlORHFjVmtJYMw
	Lfo0Za0uh2pjN8LoUQzuF9TZqcllVPCUmoSQbaA==
X-Google-Smtp-Source: AGHT+IE//7WmRy4WvbmmnLPRDvsXu2U7k4fZcFYB5c3Vi7xo2dtuIJzgM4INTs+uuefr8FqjZv2loQ==
X-Received: by 2002:a05:620a:4507:b0:7c5:5206:5823 with SMTP id af79cd13be357-7c75bbde5c9mr527101585a.29.1743532023000;
        Tue, 01 Apr 2025 11:27:03 -0700 (PDT)
Received: from gourry-fedora-PF4VCD3F (pool-173-79-56-208.washdc.fios.verizon.net. [173.79.56.208])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-7c5f765f94fsm687963385a.20.2025.04.01.11.27.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 01 Apr 2025 11:27:02 -0700 (PDT)
Date: Tue, 1 Apr 2025 14:27:00 -0400
From: Gregory Price <gourry@gourry.net>
To: Dan Williams <dan.j.williams@intel.com>
Cc: David Hildenbrand <david@redhat.com>, linux-cxl@vger.kernel.org,
	nvdimm@lists.linux.dev, linux-kernel@vger.kernel.org,
	kernel-team@meta.com, vishal.l.verma@intel.com,
	dave.jiang@intel.com
Subject: Re: [PATCH] DAX: warn when kmem regions are truncated for memory
 block alignment.
Message-ID: <Z-wv9NQr2pE1U8w5@gourry-fedora-PF4VCD3F>
References: <20250321180731.568460-1-gourry@gourry.net>
 <88bce46e-a703-4935-b10e-638e33ea91b3@redhat.com>
 <67ec269dc51da_1d47294c8@dwillia2-xfh.jf.intel.com.notmuch>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <67ec269dc51da_1d47294c8@dwillia2-xfh.jf.intel.com.notmuch>

On Tue, Apr 01, 2025 at 10:47:09AM -0700, Dan Williams wrote:
> David Hildenbrand wrote:
> > diff --git a/drivers/dax/kmem.c b/drivers/dax/kmem.c
> > index e97d47f42ee2e..23a68ff809cdf 100644
> > --- a/drivers/dax/kmem.c
> > +++ b/drivers/dax/kmem.c
> > @@ -67,8 +67,8 @@ static void kmem_put_memory_types(void)
> >   
> >   static int dev_dax_kmem_probe(struct dev_dax *dev_dax)
> >   {
> > +       unsigned long total_len = 0, orig_len = 0;
> >          struct device *dev = &dev_dax->dev;
> > -       unsigned long total_len = 0;
> >          struct dax_kmem_data *data;
> >          struct memory_dev_type *mtype;
> >          int i, rc, mapped = 0;
> > @@ -97,6 +97,7 @@ static int dev_dax_kmem_probe(struct dev_dax *dev_dax)
> >          for (i = 0; i < dev_dax->nr_range; i++) {
> >                  struct range range;
> >   
> > +               orig_len += range_len(&dev_dax->ranges[i].range);
> >                  rc = dax_kmem_range(dev_dax, i, &range);
> >                  if (rc) {
> >                          dev_info(dev, "mapping%d: %#llx-%#llx too small after alignment\n",
> > @@ -109,6 +110,9 @@ static int dev_dax_kmem_probe(struct dev_dax *dev_dax)
> >          if (!total_len) {
> >                  dev_warn(dev, "rejecting DAX region without any memory after alignment\n");
> >                  return -EINVAL;
> > +       } else if (total_len != orig_len) {
> > +               dev_warn(dev, "DAX region truncated by %lu bytes due to alignment\n",
> > +                        orig_len - total_len);
> 
> This looks good, I agree with it being a warn because the user has lost
> usable capacity and maybe this eventually pressures platform BIOS to
> avoid causing Linux warnings.
> 
> In terms of making that loss easier for people to report / understand
> how about use string_get_size() to convert raw bytes to power of 10 and
> power of 2 values? I.e.
> 
> "DAX region truncated by X.XX GiB (Y.YY GB) due to alignment."

Will pick this up in v2.
