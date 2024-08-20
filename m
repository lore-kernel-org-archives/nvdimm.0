Received: from mail-ed1-f46.google.com (mail-ed1-f46.google.com [209.85.208.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 959ED19068E
	for <nvdimm@lists.linux.dev>; Tue, 20 Aug 2024 14:08:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724162940; cv=none; b=o9fyRAKt9ZhUFCM2N+nxSN2zC6kWaclrS6wrtk4HKcVTbJitTBPWWT+80HP1N3WTSinlmg1Xe6U8oaefIH/k7ttQDj4i5AlN9tl02AWw8wwnvYv3hW/penr64r6h9aby7QleixSOyNaM8vRKI/o5iRBsizAqQMuzaHCHsgf6i6M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724162940; c=relaxed/simple;
	bh=9Segk2rEnzzYLM5UMH/BUuLN5VWq274pJxTiMZnvWZQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=A+rC9rQhhEIJas1TbEQN3QCEaXEEh2X1AJwm2xQcAV+oZA6bXKlrg7qmMqYMeehZhbJXkIyL7npzbsn4M1QA/57H/9MiFONi4FSC5OZH4MQJ9zJmov/LjeVapwptNhDA9+1tU3yPGH9rCAb4FF1reoxP0Fo3jQweuK92SLadGLs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=WX27wRjo; arc=none smtp.client-ip=209.85.208.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="WX27wRjo"
Received: by mail-ed1-f46.google.com with SMTP id 4fb4d7f45d1cf-5bec78c3f85so4775764a12.1
        for <nvdimm@lists.linux.dev>; Tue, 20 Aug 2024 07:08:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1724162937; x=1724767737; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=otzLQkR0nYuxuHzAtdMQ6ZUKW9N3q5AeXiTB9RXH6Zg=;
        b=WX27wRjorCHDbl5JqYsVgwhNz7dqIp2t/HnRbaIvZaw7r/DFNGq2zZsNB+k+5wzXrN
         nolJ6ICLeCzj0NsBGo2mIHpaBRy1rOskFxry7nUkZSuZ8waegwaxWVUqPMlcClQW/opk
         WVb3ps4ZDExq5CeiDVc4GdKZ8m2JwZTWwwAEiBaA//c4rCowwdSVNrSpY0+SM8TOcB7A
         gix5Fl/cUgQ7ijMrUrMeFTl6sG3aOzE/tBpy0S/YBs8HndjFpEDV3qOm0BNIGYCH6Xa4
         /IDXPortT/XYueFwVcvb8n+3eevnvEwxjR/Ypj/zV0Jm3WQDWOQsj39nIU04/yAe7Uyn
         YPQw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1724162937; x=1724767737;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=otzLQkR0nYuxuHzAtdMQ6ZUKW9N3q5AeXiTB9RXH6Zg=;
        b=g5TSUZxuuHizNEsx0iSlz8ny+85llMTZl5YQBLgzC0VBv6f3L723pSaZC7u9Hndc/x
         V1uFeKlAfiQLNAaV634cfFT9M2D48hh3sb5lkEcgbpmntF9oPF6T4V76R/9VVoIcY6iB
         DJH/2OwbHvaar15T/zZ1vbo3C4r6DJtmqvLlJF9N1E2EhTM90lsM6Z0kzQA+m/nZOQfL
         Jz68zlu5YOn0GvPnk09YOEzyP1avzcACvnYYmHEBik1Sl86flUulvDyD7rmmia5ORD95
         Qot6nfpk7DdJfsEV6F0pK4I7Piol6j6t5sx2dOQUQ1NlgxnC+aVpp6UjWKjfnKZgzLCZ
         nUnw==
X-Forwarded-Encrypted: i=1; AJvYcCWVHJaox3ZZPcKIzbPit/igf9rxtgFbNE1pEynvjvrCYXwaRPZvx3deU4UeRv8dSCbSvslsclaJizJYp4Cwb042v/kSa1wz
X-Gm-Message-State: AOJu0YzdN/vUqp+yJqVfiyjG+qWPGKvvh7eem5MiWwulbDcXXRpcZGRU
	Fd9bQsjTOzLz3x+MlhCJZQjhGKVk9eIIccl8XFShOadg8G/rRrIwRAMZ2Qa7n5w=
X-Google-Smtp-Source: AGHT+IG7K42OljGwNDca7BpbBxc9a8ncIPw07BdbgCTDcGsV9LoXCrbLowXk7thOJpwhbZD0g4Oa7w==
X-Received: by 2002:aa7:c54d:0:b0:5a4:6dec:cd41 with SMTP id 4fb4d7f45d1cf-5beca76e4ebmr8107111a12.28.1724162936808;
        Tue, 20 Aug 2024 07:08:56 -0700 (PDT)
Received: from pathway.suse.cz ([193.86.92.181])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-5bebbdfad42sm6871687a12.47.2024.08.20.07.08.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 20 Aug 2024 07:08:56 -0700 (PDT)
Date: Tue, 20 Aug 2024 16:08:54 +0200
From: Petr Mladek <pmladek@suse.com>
To: Ira Weiny <ira.weiny@intel.com>
Cc: Dave Jiang <dave.jiang@intel.com>, Fan Ni <fan.ni@samsung.com>,
	Jonathan Cameron <Jonathan.Cameron@huawei.com>,
	Navneet Singh <navneet.singh@intel.com>, Chris Mason <clm@fb.com>,
	Josef Bacik <josef@toxicpanda.com>, David Sterba <dsterba@suse.com>,
	Steven Rostedt <rostedt@goodmis.org>,
	Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
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
Message-ID: <ZsSjdjzRSG87alk5@pathway.suse.cz>
References: <20240816-dcd-type2-upstream-v3-0-7c9b96cba6d7@intel.com>
 <20240816-dcd-type2-upstream-v3-2-7c9b96cba6d7@intel.com>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240816-dcd-type2-upstream-v3-2-7c9b96cba6d7@intel.com>

On Fri 2024-08-16 09:44:10, Ira Weiny wrote:
> The use of struct range in the CXL subsystem is growing.  In particular,
> the addition of Dynamic Capacity devices uses struct range in a number
> of places which are reported in debug and error messages.
> 
> To wit requiring the printing of the start/end fields in each print
> became cumbersome.  Dan Williams mentions in [1] that it might be time
> to have a print specifier for struct range similar to struct resource
> 
> A few alternatives were considered including '%pn' for 'print raNge' but
> %par follows that struct range is most often used to store a range of
> physical addresses.  So use '%par' for 'print address range'.
> 
> --- a/Documentation/core-api/printk-formats.rst
> +++ b/Documentation/core-api/printk-formats.rst
> @@ -231,6 +231,20 @@ width of the CPU data path.
>  
>  Passed by reference.
>  
> +Struct Range
> +------------
> +
> +::
> +
> +	%par	[range 0x60000000-0x6fffffff] or

It seems that it is always 64-bit. It prints:

struct range {
	u64   start;
	u64   end;
};

> +		[range 0x0000000060000000-0x000000006fffffff]
> +
> +For printing struct range.  A variation of printing a physical address is to
> +print the value of struct range which are often used to hold a physical address
> +range.
> +
> +Passed by reference.
> +
>  DMA address types dma_addr_t
>  ----------------------------
>  
> diff --git a/lib/vsprintf.c b/lib/vsprintf.c
> index 2d71b1115916..c132178fac07 100644
> --- a/lib/vsprintf.c
> +++ b/lib/vsprintf.c
> @@ -1140,6 +1140,39 @@ char *resource_string(char *buf, char *end, struct resource *res,
>  	return string_nocheck(buf, end, sym, spec);
>  }
>  
> +static noinline_for_stack
> +char *range_string(char *buf, char *end, const struct range *range,
> +		      struct printf_spec spec, const char *fmt)
> +{
> +#define RANGE_PRINTK_SIZE		16
> +#define RANGE_DECODED_BUF_SIZE		((2 * sizeof(struct range)) + 4)
> +#define RANGE_PRINT_BUF_SIZE		sizeof("[range - ]")

I think that it should be "[range -]"

> +	char sym[RANGE_DECODED_BUF_SIZE + RANGE_PRINT_BUF_SIZE];
> +	char *p = sym, *pend = sym + sizeof(sym);
> +
> +	static const struct printf_spec str_spec = {
> +		.field_width = -1,
> +		.precision = 10,
> +		.flags = LEFT,
> +	};

Is this really needed? What about using "default_str_spec" instead?

> +	static const struct printf_spec range_spec = {
> +		.base = 16,
> +		.field_width = RANGE_PRINTK_SIZE,
> +		.precision = -1,
> +		.flags = SPECIAL | SMALL | ZEROPAD,
> +	};
> +
> +	*p++ = '[';
> +	p = string_nocheck(p, pend, "range ", str_spec);
> +	p = number(p, pend, range->start, range_spec);
> +	*p++ = '-';
> +	p = number(p, pend, range->end, range_spec);
> +	*p++ = ']';
> +	*p = '\0';
> +
> +	return string_nocheck(buf, end, sym, spec);
> +}
> +
>  static noinline_for_stack
>  char *hex_string(char *buf, char *end, u8 *addr, struct printf_spec spec,
>  		 const char *fmt)

Also add a selftest into lib/test_printf.c, please.

Best Regards,
Petr
