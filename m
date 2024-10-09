Received: from mail-yw1-f179.google.com (mail-yw1-f179.google.com [209.85.128.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 329F915C15E
	for <nvdimm@lists.linux.dev>; Wed,  9 Oct 2024 17:33:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.179
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728495228; cv=none; b=nFVEtNviAiwTZVgfsFVjQNvAGz9iszUj69Vx3w94qFjtDPmry8rzZw3NCMGpvSSwbz1FdTTrWs6m9TGD/WZg1UY+T3xQbtmzCkpeKkmEdfAtgM21NT8nDbo1DOLzI1Y78KfJGCQlYMn+syqsU37tvFBt0Krxm5X1JTAU4pDLN4E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728495228; c=relaxed/simple;
	bh=5+d3p/uEKo1tv34nr+5R5ivdsIqjFVPAciWFglkA+RE=;
	h=From:Date:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ASWuVn8riVlS5LEFaJczedoXzpbzx5Ip3/BNXbfj2/CJc9kER7UeGM/ndXnW8uURLBLGcA1MeslHbnRCzqW/Dw9Ew9h3JhQel4GpIW7iDizychK8CwoNcYdj7bJ2ZX3f/2V8r8W0Ir3MpBWc6H2Vral//bnTABV3SVSMCZ/RM4Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=I6CrAqZI; arc=none smtp.client-ip=209.85.128.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="I6CrAqZI"
Received: by mail-yw1-f179.google.com with SMTP id 00721157ae682-6db836c6bd7so833207b3.3
        for <nvdimm@lists.linux.dev>; Wed, 09 Oct 2024 10:33:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1728495226; x=1729100026; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:date:from:from:to:cc:subject:date:message-id:reply-to;
        bh=kdIWw6YeNqBuFnAq+SVqtF9+ypPyeZ31a/GstolXt5g=;
        b=I6CrAqZIFDhqdhN43PSgFZClmBqLhhKYZjkUEoRGgw82M6oyrEq/nKSI0QsUlp5CIO
         BEuodySOxVvcVNYp9YjHtud1aVLESoQVpZXUIPSPzCQnjdW2XB3T4qvg4IVXV87Lz6t6
         yxCzvWaNIJ6RTSmohJ/9bGPfP23KDYV6URU/cMT8cLdOukGNwooYg2hPh3PbdDqvwqZg
         3wNW6NKw7oxUOd79oXqbN7+iHHRCKCkte6A/SsfEWvh6cezsT3WAulY6OE3SzEmpYm1+
         hcWeokDwm6G+Q2fMqJLxp5Kz/Zr89hLFFsXbcmOVX4uL3B9smG4rtwNgFfJ9yvUtUp15
         6Shg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1728495226; x=1729100026;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:date:from:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=kdIWw6YeNqBuFnAq+SVqtF9+ypPyeZ31a/GstolXt5g=;
        b=EDKuAq2pZoXgnJIozw2y7DYkPmGrzAA6AcyB/agRcy18xPzGh+g96tL4QFZHZ1WUJW
         oAKFLmkoMDi5LCk8ufQO1PwyYJ55Pw4z1U7ICWNDZVum3ZiGllebCVaXzOcvWsM4M5o2
         qrEbu4QHN5gGYgaI5nC7bomjSoC4hECNJ/BWXKlNIqD2dOL4RVE19kGp3b1+oFqEuNwv
         zVcrEJCu6kH9gFvSDMCHYViEC47ULMzPpgXTOUVy8NqDYzLrkVU4gqEksY1eeiJPrM+/
         yLgLt/44odHL8Gl405bTdBw0CDV+qVJiTX+JYbLE2YW6A8YyUdSbYfYoUzHd8IIR9Pav
         aQUg==
X-Forwarded-Encrypted: i=1; AJvYcCUjxcGQszB/MEyw78wbBo+qBrl4MKKJQjRrGyFNqGk8iVt8FgYri5S/WGlRXtzJSFNohd3ZYSc=@lists.linux.dev
X-Gm-Message-State: AOJu0YwUiGKkX1fmSgKrGTEt20WI5WLCLkgi63AXqpq0qW7BnAiEOdpE
	tJwoWFsDJyX1CYBHmh0jkaFtJr19VMEbk1jp+sk0MsnBc+qQtIYg
X-Google-Smtp-Source: AGHT+IGYDXoiIVsZD4D1VMdAVzKWO5yqoecM7leCzcRbETTKF2cR52wcXBVELZjVeQW9kZpZAYQigA==
X-Received: by 2002:a05:690c:5:b0:650:a1cb:b122 with SMTP id 00721157ae682-6e32e22164amr12486607b3.27.1728495226148;
        Wed, 09 Oct 2024 10:33:46 -0700 (PDT)
Received: from fan ([50.205.20.42])
        by smtp.gmail.com with ESMTPSA id 00721157ae682-6e2d9280254sm19287527b3.46.2024.10.09.10.33.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 09 Oct 2024 10:33:45 -0700 (PDT)
From: Fan Ni <nifan.cxl@gmail.com>
X-Google-Original-From: Fan Ni <fan.ni@samsung.com>
Date: Wed, 9 Oct 2024 10:33:42 -0700
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
Subject: Re: [PATCH v4 02/28] printk: Add print format (%pra) for struct range
Message-ID: <Zwa-dtJ21zwBWZpY@fan>
References: <20241007-dcd-type2-upstream-v4-0-c261ee6eeded@intel.com>
 <20241007-dcd-type2-upstream-v4-2-c261ee6eeded@intel.com>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20241007-dcd-type2-upstream-v4-2-c261ee6eeded@intel.com>

On Mon, Oct 07, 2024 at 06:16:08PM -0500, Ira Weiny wrote:
> The use of struct range in the CXL subsystem is growing.  In particular,
> the addition of Dynamic Capacity devices uses struct range in a number
> of places which are reported in debug and error messages.
> 
> To wit requiring the printing of the start/end fields in each print
> became cumbersome.  Dan Williams mentions in [1] that it might be time
> to have a print specifier for struct range similar to struct resource
> 
> A few alternatives were considered including '%par', '%r', and '%pn'.
> %pra follows that struct range is similar to struct resource (%p[rR])
> but need to be different.  Based on discussions with Petr and Andy
> '%pra' was chosen.[2]
> 
> Andy also suggested to keep the range prints similar to struct resource
> though combined code.  Add hex_range() to handle printing for both
> pointer types.
> 
> To: Petr Mladek <pmladek@suse.com>
> To: Steven Rostedt <rostedt@goodmis.org>
> To: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
> To: Rasmus Villemoes <linux@rasmusvillemoes.dk>
> To: Sergey Senozhatsky <senozhatsky@chromium.org>
> To: Jonathan Corbet <corbet@lwn.net> (maintainer:DOCUMENTATION)
> Cc: linux-doc@vger.kernel.org
> Cc: linux-kernel@vger.kernel.org (open list)
> Link: https://lore.kernel.org/all/663922b475e50_d54d72945b@dwillia2-xfh.jf.intel.com.notmuch/ [1]
> Link: https://lore.kernel.org/all/66cea3bf3332f_f937b29424@iweiny-mobl.notmuch/ [2]
> Suggested-by: "Dan Williams" <dan.j.williams@intel.com>
> Signed-off-by: Ira Weiny <ira.weiny@intel.com>
> 
> ---
> Changes:
> [Andy: create new hex_range() and use it in both range/resource]
> [Petr/Andy: Use %pra]
> [Andy: Add test case start > end]
> [Petr: Update documentation]
> [Petr: use 'range -']
> [Petr: fixup printf_spec specifiers]
> [Petr: add lib/test_printf test]
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
 ...
>  static noinline_for_stack
>  char *hex_string(char *buf, char *end, u8 *addr, struct printf_spec spec,
>  		 const char *fmt)
> @@ -2277,6 +2314,7 @@ char *rust_fmt_argument(char *buf, char *end, void *ptr);
>   * - 'Bb' as above with module build ID (for use in backtraces)
>   * - 'R' For decoded struct resource, e.g., [mem 0x0-0x1f 64bit pref]
>   * - 'r' For raw struct resource, e.g., [mem 0x0-0x1f flags 0x201]
> + * - 'ra' struct ranges [range 0x00 - 0xff]

Maybe follow the existing examples here, like
'ra" For struct ranges, e.g., ...

fan

>   * - 'b[l]' For a bitmap, the number of bits is determined by the field
>   *       width which must be explicitly specified either as part of the
>   *       format string '%32b[l]' or through '%*b[l]', [l] selects
> @@ -2399,8 +2437,13 @@ char *pointer(const char *fmt, char *buf, char *end, void *ptr,
>  		fallthrough;
>  	case 'B':
>  		return symbol_string(buf, end, ptr, spec, fmt);
> -	case 'R':
>  	case 'r':
> +		switch (fmt[1]) {
> +		case 'a':
> +			return range_string(buf, end, ptr, spec, fmt);
> +		}
> +		fallthrough;
> +	case 'R':
>  		return resource_string(buf, end, ptr, spec, fmt);
>  	case 'h':
>  		return hex_string(buf, end, ptr, spec, fmt);
> 
> -- 
> 2.46.0
> 

-- 
Fan Ni
