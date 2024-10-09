Received: from mail-yb1-f181.google.com (mail-yb1-f181.google.com [209.85.219.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C99C048CDD
	for <nvdimm@lists.linux.dev>; Wed,  9 Oct 2024 17:10:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.181
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728493821; cv=none; b=kQxbT/IgQ/yagcM/gFWzwjYHnNg3fDHxb578j3ooXnOqzje7NrFbc93+lFvHfx/UWqBl1QPVk8wmlnUcH6Xi+tEnWawSLieMQAoe2R8/Cgy1G6huwnPejsrIvsKBgvT2OMl/W4HIyS6pwgq5vGPpeGzXB+DP8kMneVXGDjynj80=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728493821; c=relaxed/simple;
	bh=ji/gakLu/qIT18qKQ000acOtbeI7Zd5eSJ/x/GSUR+U=;
	h=From:Date:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=MXd9M/5oOEqpkbr0n8fW6DQb0XdBqXocRBfb9wJoPTLWMxCk9wuDlMSERvmbHLrxc+AqrJ6VlpCn1bRTT1fF7CLL7paViQyNBqXw7gFi7H8glxqOqeger4yFeGc1CP2rRPbQpM51HaCoSh27z5UeA2Zu149eFS/H46/fXPwx0d4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=J+gyzhdq; arc=none smtp.client-ip=209.85.219.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="J+gyzhdq"
Received: by mail-yb1-f181.google.com with SMTP id 3f1490d57ef6-e28fa28de37so1366441276.3
        for <nvdimm@lists.linux.dev>; Wed, 09 Oct 2024 10:10:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1728493819; x=1729098619; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:date:from:from:to:cc:subject:date:message-id:reply-to;
        bh=Chk44cch0ltIQeofSD5CiqT4vY5iO0SSNHIRHVLIjtY=;
        b=J+gyzhdq6Khg+6gjS9YM8/F7HcQaR8uLU6B7Y/XeLwy3UMyobrrwiD5X9/IqIWdnba
         5GyxGlpYSxtzBZlg8/GwxtDLh4jBSpPur7Ogm6ySIxWVWuFrTrdFTWOf+DQ5kH+KHTVL
         jBXknbuOO9PQEdZAPZFPbPOJst9avIGnJ6uK6D71UxWXqqjnNzPL2lRS+P+Fvim7xL9A
         cZ9sc5AjzcYfJH9VOO5ywC8rqLQPwHGcmf7Vo4ns/HA0n+J68SiPIcDA9O6Da0cDun5c
         omFavsvDcdkhYdfyqwLWa4KeHva5BvYYiW3Sl+8Ko7TiWpTrjN1ooH7Alv0M6TMEPmCi
         21GQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1728493819; x=1729098619;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:date:from:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Chk44cch0ltIQeofSD5CiqT4vY5iO0SSNHIRHVLIjtY=;
        b=v5XmP2GsQh8MJlaU3tZJzmDzojBJT6vdBhmW45USmwLLZeQYHbw7lsBX6Hs21Ufrc5
         iXYfHYbkBwXYObeofXYDnINvGk6GJmL7iof/0f9d5aA1UA6R37gtw0JnpMRPlDWaFagR
         0IIt7xUJ8cW90gVEClJPn5i/pFrx1zneFkxX8QOJV0L9DH0b42/KbOmQ3899nvYZzU0B
         mcLEuvbvGwDy2EwlNAERnmVrcS4jyQUO23hPStIwSHGus+MHbBl8d96frbMv0p8yYhr6
         90lQnR6UkZOuFvFq+b37GcQY94FvIEpieVon0+T6+ysb2rbgjOSsBp0ld11APBEqUnAO
         bsqw==
X-Forwarded-Encrypted: i=1; AJvYcCVo8zDcs9Q5byXtsUGIUtu26buvvfnjb0Ok8kTRuNlBtOHxzWB2h0qW7rXWH1R7HQ1nwWbiaJ0=@lists.linux.dev
X-Gm-Message-State: AOJu0YyuFNtmKO4omGG1+a4PjIB/P+y3jJIkJYqRWzkZ6oKJ7ILPBQeK
	bjUIoKkY4zC+8ug79UJLRPbPZp53Y8hrx2vuk0mEHCaU258fEeAx
X-Google-Smtp-Source: AGHT+IE3r5HC98b7ltN7b94kiIbfr65zeIie3Egdm+UMr/y40gIfmJ3yDynf8CUNg4QQRZxCtnDuuw==
X-Received: by 2002:a25:fc12:0:b0:e28:fee0:e971 with SMTP id 3f1490d57ef6-e28fee0eae8mr2393108276.22.1728493818638;
        Wed, 09 Oct 2024 10:10:18 -0700 (PDT)
Received: from fan ([50.205.20.42])
        by smtp.gmail.com with ESMTPSA id 3f1490d57ef6-e28a5dbd3a7sm1828233276.63.2024.10.09.10.10.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 09 Oct 2024 10:10:18 -0700 (PDT)
From: Fan Ni <nifan.cxl@gmail.com>
X-Google-Original-From: Fan Ni <fan.ni@samsung.com>
Date: Wed, 9 Oct 2024 10:09:41 -0700
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
	linux-kernel@vger.kernel.org, Petr Mladek <pmladek@suse.com>,
	Steven Rostedt <rostedt@goodmis.org>,
	Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
	Rasmus Villemoes <linux@rasmusvillemoes.dk>,
	Sergey Senozhatsky <senozhatsky@chromium.org>
Subject: Re: [PATCH v4 01/28] test printk: Add very basic struct resource
 tests
Message-ID: <Zwa41SFUfDH0LCPJ@fan>
References: <20241007-dcd-type2-upstream-v4-0-c261ee6eeded@intel.com>
 <20241007-dcd-type2-upstream-v4-1-c261ee6eeded@intel.com>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20241007-dcd-type2-upstream-v4-1-c261ee6eeded@intel.com>

On Mon, Oct 07, 2024 at 06:16:07PM -0500, Ira Weiny wrote:
> The printk tests for struct resource were stubbed out.  struct range
> printing will leverage the struct resource implementation.
> 
> To prevent regression add some basic sanity tests for struct resource.
> 
> To: Petr Mladek <pmladek@suse.com>
> To: Steven Rostedt <rostedt@goodmis.org>
> To: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
> To: Rasmus Villemoes <linux@rasmusvillemoes.dk>
> To: Sergey Senozhatsky <senozhatsky@chromium.org>
> Cc: linux-doc@vger.kernel.org
> Signed-off-by: Ira Weiny <ira.weiny@intel.com>

Reviewed-by: Fan Ni <fan.ni@samsung.com>
Tested-by: Fan Ni <fan.ni@samsung.com>

> 
> ---
> [lkp: ensure phys_addr_t is within limits for all arch's]
> ---
>  lib/test_printf.c | 44 ++++++++++++++++++++++++++++++++++++++++++++
>  1 file changed, 44 insertions(+)
> 
> diff --git a/lib/test_printf.c b/lib/test_printf.c
> index 8448b6d02bd9..5afdf5efc627 100644
> --- a/lib/test_printf.c
> +++ b/lib/test_printf.c
> @@ -386,6 +386,50 @@ kernel_ptr(void)
>  static void __init
>  struct_resource(void)
>  {
> +	struct resource test_resource = {
> +		.start = 0xc0ffee00,
> +		.end = 0xc0ffee00,
> +		.flags = IORESOURCE_MEM,
> +	};
> +
> +	test("[mem 0xc0ffee00 flags 0x200]",
> +	     "%pr", &test_resource);
> +
> +	test_resource = (struct resource) {
> +		.start = 0xc0ffee,
> +		.end = 0xba5eba11,
> +		.flags = IORESOURCE_MEM,
> +	};
> +	test("[mem 0x00c0ffee-0xba5eba11 flags 0x200]",
> +	     "%pr", &test_resource);
> +
> +	test_resource = (struct resource) {
> +		.start = 0xba5eba11,
> +		.end = 0xc0ffee,
> +		.flags = IORESOURCE_MEM,
> +	};
> +	test("[mem 0xba5eba11-0x00c0ffee flags 0x200]",
> +	     "%pr", &test_resource);
> +
> +	test_resource = (struct resource) {
> +		.start = 0xba5eba11,
> +		.end = 0xba5eca11,
> +		.flags = IORESOURCE_MEM,
> +	};
> +
> +	test("[mem 0xba5eba11-0xba5eca11 flags 0x200]",
> +	     "%pr", &test_resource);
> +
> +	test_resource = (struct resource) {
> +		.start = 0xba11,
> +		.end = 0xca10,
> +		.flags = IORESOURCE_IO |
> +			 IORESOURCE_DISABLED |
> +			 IORESOURCE_UNSET,
> +	};
> +
> +	test("[io  size 0x1000 disabled]",
> +	     "%pR", &test_resource);
>  }
>  
>  static void __init
> 
> -- 
> 2.46.0
> 

-- 
Fan Ni
