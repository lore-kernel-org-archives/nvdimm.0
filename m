Received: from mail-lf1-f52.google.com (mail-lf1-f52.google.com [209.85.167.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 69BF917C9BE
	for <nvdimm@lists.linux.dev>; Mon, 26 Aug 2024 13:23:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724678636; cv=none; b=rnqhl/ryh6jCtfA2uJckRcEo1W7mkd+Cs3CU4lt7FPaVM6r+6hzAUVcsFAuZR5maNpWX40/zDW4tUzjIhczpptmoLGNgqh3NZY4Zk7trK0Jz+M87DiNnvtGei5vDdG/nup2XVK3t6pPoWWch2Rtp5d0WIezubLA53FEKW8kX7UI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724678636; c=relaxed/simple;
	bh=jeztrx2wemey1pVY0c62bFmR4t/EoPdY6f0cjjxFm3E=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=VHdqFhMxQgLg1YDBoYdYh8TMKa+w9xplzmXRK01aOJmfQuMZYkIJbRqnEeMHiKkFXSrzsrMEKteZvAnyygHJ5mIIJRKvTxnVSX6Os//t4b0vw8hQrH0DPYmVQSx7H0iVouuG8S4Oxciejd9eLv5Vl74OrlWMuQhOOGuMKmxj4Dg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=Ek7ixGbj; arc=none smtp.client-ip=209.85.167.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="Ek7ixGbj"
Received: by mail-lf1-f52.google.com with SMTP id 2adb3069b0e04-53349ee42a9so5060861e87.3
        for <nvdimm@lists.linux.dev>; Mon, 26 Aug 2024 06:23:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1724678632; x=1725283432; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=IQCe7McW9E8hf61lrcG6VB7x1ye3Lq6gKShLHGG32KE=;
        b=Ek7ixGbjbRc+yee+5w2jSqnj0hM8DJX21jN2cNEXWdR223Z7uRNGK7I3zyfCx4UmA/
         wmmg1+P9A8KbCiMhm302kuZpq8+41wylrsiIVxjK1mMl0J3dQCOSqPiY+cSN/Pjp+yLo
         jFq4vr2GxMQ4UM53NubrfkQfeMxgRIkSKuoxTn2fMvwEWg9YRQX+UkzmyYAurSgOgtJN
         aH7cinmEXPdy/ie2QspWQIooIeSO341qLA34NxZXB5P1XaXShYbOTzOSehqzHLnpliON
         yIv/Dv/HmlaYQqDBD+aHLXFWgMXADQ337J8Rz5iPIkVzWBxaZczawGMQJ6NSpiMtAA+S
         kD8Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1724678632; x=1725283432;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=IQCe7McW9E8hf61lrcG6VB7x1ye3Lq6gKShLHGG32KE=;
        b=QAH8KM1o0RXIeLcolPULNlCS/8Stz+KkJXeCWkMWqc7yiFXAY4LU46jGH6jYTL274t
         86AsHkByOdQI3dfRx8DBFgHuedLqj4KyC0gdarH9ySYbXY4M/3vdtTM+KAJXoeeQO7ng
         XiUjcKvAjGmvN++KMH7DYIcH9n4u2uDwTkOuHqL4ll1SFBYdgM1UBhAreCyjKOOrBz9q
         +GIQ+slD9F3+zbcnouTjBk/NdUVYy8skd/dkEezfK2S7C+f1a/NfPkTK62VpvhEj6j3o
         nvtykDjlGV0UeEs6E/xLR9sdBaBJ2u2oqBw7Hti85R8HyiAzk7naRUsjIQ7sQYzo1JQN
         x8VA==
X-Forwarded-Encrypted: i=1; AJvYcCUlL8MtZfzFPx+Oho04xchOovu1DViq4pkzXIEvlao6UzrV59ijx4LL3hpqkAngpKtVL3nSotA=@lists.linux.dev
X-Gm-Message-State: AOJu0YzAJc0yZflvNZtw7S7kNWRqkOos7AdIc2zcjCRaPn/P3IH0SIsM
	efyOMsQY331+5W3Ylx/SLBmJSM7WvAG5RoCUPQGUhJzQ03srz5csi+X4CHmKyVU=
X-Google-Smtp-Source: AGHT+IHb9h8+cB84cqvegDS1MyMJPEFI1QyTGHUhHtl3xRFQzxT2+gqbftjjzsxNnZRT1RRhuK0Sgg==
X-Received: by 2002:a05:6512:3d24:b0:533:44a3:21b9 with SMTP id 2adb3069b0e04-534387681d2mr6366176e87.1.1724678632351;
        Mon, 26 Aug 2024 06:23:52 -0700 (PDT)
Received: from pathway.suse.cz ([193.86.92.181])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-a868f436330sm665305066b.112.2024.08.26.06.23.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 26 Aug 2024 06:23:52 -0700 (PDT)
Date: Mon, 26 Aug 2024 15:23:50 +0200
From: Petr Mladek <pmladek@suse.com>
To: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Cc: Ira Weiny <ira.weiny@intel.com>, Dave Jiang <dave.jiang@intel.com>,
	Fan Ni <fan.ni@samsung.com>,
	Jonathan Cameron <Jonathan.Cameron@huawei.com>,
	Navneet Singh <navneet.singh@intel.com>, Chris Mason <clm@fb.com>,
	Josef Bacik <josef@toxicpanda.com>, David Sterba <dsterba@suse.com>,
	Steven Rostedt <rostedt@goodmis.org>,
	Rasmus Villemoes <linux@rasmusvillemoes.dk>,
	Sergey Senozhatsky <senozhatsky@chromium.org>,
	Jonathan Corbet <corbet@lwn.net>,
	Andrew Morton <akpm@linux-foundation.org>,
	Dan Williams <dan.j.williams@intel.com>,
	Davidlohr Bueso <dave@stgolabs.net>,
	Alison Schofield <alison.schofield@intel.com>,
	Vishal Verma <vishal.l.verma@intel.com>,
	linux-btrfs@vger.kernel.org, linux-cxl@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org,
	nvdimm@lists.linux.dev
Subject: Re: [PATCH v3 02/25] printk: Add print format (%par) for struct range
Message-ID: <ZsyB5rqhaZ-oRwny@pathway.suse.cz>
References: <20240816-dcd-type2-upstream-v3-0-7c9b96cba6d7@intel.com>
 <20240816-dcd-type2-upstream-v3-2-7c9b96cba6d7@intel.com>
 <ZsSjdjzRSG87alk5@pathway.suse.cz>
 <66c77b1c5c65c_1719d2940@iweiny-mobl.notmuch>
 <Zsd_EctNZ80fuKMu@smile.fi.intel.com>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Zsd_EctNZ80fuKMu@smile.fi.intel.com>

On Thu 2024-08-22 21:10:25, Andy Shevchenko wrote:
> On Thu, Aug 22, 2024 at 12:53:32PM -0500, Ira Weiny wrote:
> > Petr Mladek wrote:
> > > On Fri 2024-08-16 09:44:10, Ira Weiny wrote:
> 
> ...
> 
> > > > +	%par	[range 0x60000000-0x6fffffff] or
> > > 
> > > It seems that it is always 64-bit. It prints:
> > > 
> > > struct range {
> > > 	u64   start;
> > > 	u64   end;
> > > };
> > 
> > Indeed.  Thanks I should not have just copied/pasted.
> 
> With that said, I'm not sure the %pa is a good placeholder for this ('a' stands
> to "address" AFAIU). Perhaps this should go somewhere under %pr/%pR?

The r/R in %pr/%pR actually stands for "resource".

But "%ra" really looks like a better choice than "%par". Both
"resource"  and "range" starts with 'r'. Also the struct resource
is printed as a range of values.

> > > > +		[range 0x0000000060000000-0x000000006fffffff]
> > > > +
> > > > +For printing struct range.  A variation of printing a physical address is to
> > > > +print the value of struct range which are often used to hold a physical address
> > > > +range.
> > > > +
> > > > +Passed by reference.

Best Regards,
Petr
