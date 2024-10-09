Received: from mail-lj1-f177.google.com (mail-lj1-f177.google.com [209.85.208.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0E1B7198A34
	for <nvdimm@lists.linux.dev>; Wed,  9 Oct 2024 13:30:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.177
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728480615; cv=none; b=tHCMRRdYqxmtm6RDWRZQ0ar0mexQT81CPfEVAJ1sRsj0pXBPsi0Ae78C3BfzGcVZYJ8tbtCJKBYTTD2XUgFb52hViyNtdNxTcFjzGFgQ1jW757azDqYe7duKxF8BkiUU6T4PSXLpnSLX0S5NbZ+F57mixFhoXFKyFWNTIxFzwqI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728480615; c=relaxed/simple;
	bh=l1EOQkhxaNMEb0c23pFrQuttKWwlPFuD+SnneqwfcII=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:Message-ID:
	 MIME-Version:Content-Type; b=GFy7tlQcDEekyBBiIyXVQ+lCpUX2Ddxhhb7/qP15r0KD1Le1Fu2J5xwr4Fu1MjLLb3wz2E7PFT58AlzWkH77oxEVv5zzdGDnnWQrCPQKY4MMQh6P440uQBnZZCeJKFsz1D1NdAQfePwhPScnbv9iZgkIuI5bEv9B8J2GC1jrmiQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=rasmusvillemoes.dk; spf=pass smtp.mailfrom=rasmusvillemoes.dk; dkim=pass (1024-bit key) header.d=rasmusvillemoes.dk header.i=@rasmusvillemoes.dk header.b=djFnT1Qo; arc=none smtp.client-ip=209.85.208.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=rasmusvillemoes.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=rasmusvillemoes.dk
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=rasmusvillemoes.dk header.i=@rasmusvillemoes.dk header.b="djFnT1Qo"
Received: by mail-lj1-f177.google.com with SMTP id 38308e7fff4ca-2fad15b3eeeso73212901fa.2
        for <nvdimm@lists.linux.dev>; Wed, 09 Oct 2024 06:30:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=rasmusvillemoes.dk; s=google; t=1728480611; x=1729085411; darn=lists.linux.dev;
        h=mime-version:user-agent:message-id:date:references:in-reply-to
         :subject:cc:to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=47baqCnQCvkfvrwoy37anFk6NSMQvffBtJAu5gT3YZk=;
        b=djFnT1Qo60O9eIi5Y769QnTo6twvR5+bzBZ4cb9Q1tPy6wCF+JFuPCfxV9DBNn/21f
         nW5LkdkHcVjQgc3OCewtzeoV5X690MQe7KkGpyPWVkmR3x2o77qaNku5sWCgFcqmgY8Y
         hSsuzm1FtWaO3Gm3Np00lVP74nyO6I/25+czM=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1728480611; x=1729085411;
        h=mime-version:user-agent:message-id:date:references:in-reply-to
         :subject:cc:to:from:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=47baqCnQCvkfvrwoy37anFk6NSMQvffBtJAu5gT3YZk=;
        b=gN3t55WFTr2PuMyUE1I/0dX9M4jgmSchjWlAvuZGc53qwBpp2iuOWrr3r4WUQi2mrj
         /mTv/kNptG1j02E+xXbtBYJ4zBWevjcg4l5+XRPlgPbLm2aQz1dLYIvUz0TyROnh1ZLn
         FSpwzOQb7LMRI8zuWRzNqWb4qIu7hucHpgODzBPthuLepwQB7ksjOohE4RxuzJCtPJN2
         yBibAem1Gkzv9lA8/0u0sGWJEyNbRYPDtfJ3JJTMM1h9boxIDY0+8z8RmU6pLMVc7If6
         vTAOPGs6RMxcrmraM/uoV9cYzT/yD7bZUhAfmIQU/x21YxMEXI9d+g4vsGbL9DHa51+t
         FfWw==
X-Forwarded-Encrypted: i=1; AJvYcCX6JZHLufPiy5b0+fgtLeZSvcbGQ9QMUVVuTbA20yB1oQ+RYYQXzJZt6U9RnTcrPq+zPeDOJcA=@lists.linux.dev
X-Gm-Message-State: AOJu0YxRwoVRaywOgoR9hmNp6MHREWrGA61REWW6t2Z+RGGuO4L68H9G
	Bo9Ru5ad8mLuoRccVelE27Lk7ouD9qLnpfrOx80X1Aqvcy1y/zihcbU+3R7QYmA=
X-Google-Smtp-Source: AGHT+IGzs8AU/VidaqWomdqq3zlWcnDvu5kW/cZXUPcR7Heq9OLcNFfOUxKuKAPf8diwyUfBEMfPRw==
X-Received: by 2002:a2e:1312:0:b0:2fa:cdac:8723 with SMTP id 38308e7fff4ca-2fb1f849b4fmr193341fa.29.1728480610830;
        Wed, 09 Oct 2024 06:30:10 -0700 (PDT)
Received: from localhost ([81.216.59.226])
        by smtp.gmail.com with ESMTPSA id 38308e7fff4ca-2faf9adcb62sm14228011fa.63.2024.10.09.06.30.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 09 Oct 2024 06:30:10 -0700 (PDT)
From: Rasmus Villemoes <linux@rasmusvillemoes.dk>
To: Ira Weiny <ira.weiny@intel.com>
Cc: Dave Jiang <dave.jiang@intel.com>,  Fan Ni <fan.ni@samsung.com>,
  Jonathan Cameron <Jonathan.Cameron@huawei.com>,  Navneet Singh
 <navneet.singh@intel.com>,  Jonathan Corbet <corbet@lwn.net>,  Andrew
 Morton <akpm@linux-foundation.org>,  Dan Williams
 <dan.j.williams@intel.com>,  Davidlohr Bueso <dave@stgolabs.net>,  Alison
 Schofield <alison.schofield@intel.com>,  Vishal Verma
 <vishal.l.verma@intel.com>,  linux-btrfs@vger.kernel.org,
  linux-cxl@vger.kernel.org,  linux-doc@vger.kernel.org,
  nvdimm@lists.linux.dev,  linux-kernel@vger.kernel.org,  Petr Mladek
 <pmladek@suse.com>,  Steven Rostedt <rostedt@goodmis.org>,  Andy
 Shevchenko <andriy.shevchenko@linux.intel.com>,  Rasmus Villemoes
 <linux@rasmusvillemoes.dk>,  Sergey Senozhatsky <senozhatsky@chromium.org>
Subject: Re: [PATCH v4 02/28] printk: Add print format (%pra) for struct range
In-Reply-To: <20241007-dcd-type2-upstream-v4-2-c261ee6eeded@intel.com> (Ira
	Weiny's message of "Mon, 07 Oct 2024 18:16:08 -0500")
References: <20241007-dcd-type2-upstream-v4-0-c261ee6eeded@intel.com>
	<20241007-dcd-type2-upstream-v4-2-c261ee6eeded@intel.com>
Date: Wed, 09 Oct 2024 15:30:14 +0200
Message-ID: <871q0p5rq1.fsf@prevas.dk>
User-Agent: Gnus/5.13 (Gnus v5.13)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain

Ira Weiny <ira.weiny@intel.com> writes:

> ---
>  Documentation/core-api/printk-formats.rst | 13 ++++++++
>  lib/test_printf.c                         | 26 +++++++++++++++
>  lib/vsprintf.c                            | 55 +++++++++++++++++++++++++++----
>  3 files changed, 88 insertions(+), 6 deletions(-)
>
> diff --git a/Documentation/core-api/printk-formats.rst b/Documentation/core-api/printk-formats.rst
> index 14e093da3ccd..03b102fc60bb 100644
> --- a/Documentation/core-api/printk-formats.rst
> +++ b/Documentation/core-api/printk-formats.rst
> @@ -231,6 +231,19 @@ width of the CPU data path.
>  
>  Passed by reference.
>  
> +Struct Range
> +------------

Probably neither of those words should be capitalized.

> +
> +::
> +
> +	%pra    [range 0x0000000060000000-0x000000006fffffff]
> +	%pra    [range 0x0000000060000000]
> +
> +For printing struct range.  struct range holds an arbitrary range of u64
> +values.  If start is equal to end only 1 value is printed.
> +
> +Passed by reference.
> +
>  DMA address types dma_addr_t
>  ----------------------------
>  
> diff --git a/lib/test_printf.c b/lib/test_printf.c
> index 5afdf5efc627..e3e75b6d10a0 100644
> --- a/lib/test_printf.c
> +++ b/lib/test_printf.c
> @@ -432,6 +432,31 @@ struct_resource(void)
>  	     "%pR", &test_resource);
>  }
>  
> +static void __init
> +struct_range(void)
> +{
> +	struct range test_range = {
> +		.start = 0xc0ffee00ba5eba11,
> +		.end = 0xc0ffee00ba5eba11,
> +	};
> +
> +	test("[range 0xc0ffee00ba5eba11]", "%pra", &test_range);
> +
> +	test_range = (struct range) {
> +		.start = 0xc0ffee,
> +		.end = 0xba5eba11,
> +	};
> +	test("[range 0x0000000000c0ffee-0x00000000ba5eba11]",
> +	     "%pra", &test_range);
> +
> +	test_range = (struct range) {
> +		.start = 0xba5eba11,
> +		.end = 0xc0ffee,
> +	};
> +	test("[range 0x00000000ba5eba11-0x0000000000c0ffee]",
> +	     "%pra", &test_range);
> +}
> +

Thanks for including tests!

Rather than the struct assignments, I think it's easier to read if you
just do

  struct range r;

  r.start = 0xc0ffee00ba5eba11;
  r.end   = r.start;
  ...

  r.start = 0xc0ffee;
  r.end   = 0xba5eba11;
  ...

which saves two lines per test and for the first one makes it more
obvious that the start and end values are identical.

>  static void __init
>  addr(void)
>  {
> @@ -807,6 +832,7 @@ test_pointer(void)
>  	symbol_ptr();
>  	kernel_ptr();
>  	struct_resource();
> +	struct_range();
>  	addr();
>  	escaped_str();
>  	hex_string();
> diff --git a/lib/vsprintf.c b/lib/vsprintf.c
> index 09f022ba1c05..f8f5ed8f4d39 100644
> --- a/lib/vsprintf.c
> +++ b/lib/vsprintf.c
> @@ -1039,6 +1039,19 @@ static const struct printf_spec default_dec04_spec = {
>  	.flags = ZEROPAD,
>  };
>  
> +static noinline_for_stack
> +char *hex_range(char *buf, char *end, u64 start_val, u64 end_val,
> +		struct printf_spec spec)
> +{
> +	buf = number(buf, end, start_val, spec);
> +	if (start_val != end_val) {
> +		if (buf < end)
> +			*buf++ = '-';

No. Either all your callers pass a (probably stack-allocated) buffer
which is guaranteed to be big enough, in which case you don't need the
"if (buf < end)", or if some callers may "print" directly to the buffer
passed to vsnprintf(), the buf++ must still be done unconditionally in
order that vsnprintf(NULL, 0, ...) [used by fx kasprintf] can accurately
determine how large the output string would be.

So, either

  *buf++ = '-'

or

  if (buf < end)
    *buf = '-';
  buf++;

Please don't mix the two. 



> +		buf = number(buf, end, end_val, spec);
> +	}
> +	return buf;
> +}
> +
>  static noinline_for_stack
>  char *resource_string(char *buf, char *end, struct resource *res,
>  		      struct printf_spec spec, const char *fmt)
> @@ -1115,11 +1128,7 @@ char *resource_string(char *buf, char *end, struct resource *res,
>  		p = string_nocheck(p, pend, "size ", str_spec);
>  		p = number(p, pend, resource_size(res), *specp);
>  	} else {
> -		p = number(p, pend, res->start, *specp);
> -		if (res->start != res->end) {
> -			*p++ = '-';
> -			p = number(p, pend, res->end, *specp);
> -		}
> +		p = hex_range(p, pend, res->start, res->end, *specp);
>  	}
>  	if (decode) {
>  		if (res->flags & IORESOURCE_MEM_64)
> @@ -1140,6 +1149,34 @@ char *resource_string(char *buf, char *end, struct resource *res,
>  	return string_nocheck(buf, end, sym, spec);
>  }
>  
> +static noinline_for_stack
> +char *range_string(char *buf, char *end, const struct range *range,
> +		   struct printf_spec spec, const char *fmt)
> +{
> +#define RANGE_DECODED_BUF_SIZE		((2 * sizeof(struct range)) + 4)
> +#define RANGE_PRINT_BUF_SIZE		sizeof("[range -]")
> +	char sym[RANGE_DECODED_BUF_SIZE + RANGE_PRINT_BUF_SIZE];

I don't think these names or the split in two constants helps
convincing that's the right amount. I have to think quite a bit to see
that 2*sizeof is because struct range has two u64 and we're printing in
hex so four-bits-per-char and probably the +4 are for two time "0x".

Why not just size the buffer directly using an "example" string?

  char sym[sizeof("[range 0x0123456789abcdef-0x0123456789abcdef]")]

> +	char *p = sym, *pend = sym + sizeof(sym);
> +
> +	struct printf_spec range_spec = {
> +		.field_width = 2 + 2 * sizeof(range->start), /* 0x + 2 * 8 */
> +		.flags = SPECIAL | SMALL | ZEROPAD,
> +		.base = 16,
> +		.precision = -1,
> +	};
> +
> +	if (check_pointer(&buf, end, range, spec))
> +		return buf;
> +
> +	*p++ = '[';
> +	p = string_nocheck(p, pend, "range ", default_str_spec);

We really should have mempcpy or stpcpy. I don't see the point of using
string_nocheck here, or not including the [ in the string copy (however
it's done). But yeah, without stpcpy() that's a bit awkward. 

Rasmus
