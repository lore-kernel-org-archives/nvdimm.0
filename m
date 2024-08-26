Received: from mail-lj1-f171.google.com (mail-lj1-f171.google.com [209.85.208.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3754917E01F
	for <nvdimm@lists.linux.dev>; Mon, 26 Aug 2024 13:17:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724678252; cv=none; b=hlJGWGfL8uRHnCdVr6RWblZuj9KCO8a7wmNQ96SkDEOZsfVydH8ASmo5A6gG107qErYiTRAuAJbpNtIU5uDyrfS4sanBPkEmJrQfYAJGHiXXUZ37YExZfkMcoL3PsqNSZCYJzf4Xh5HjoDxTZPOeDmvfbSeqjRkSp2w6xl9t84w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724678252; c=relaxed/simple;
	bh=JSH8SqpNQbSt6NhrXIE9u7Eh0AndPutbj+FZ/nav9j8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Q52xCp8y8auS7tgZqsS+EWyVakBEqFPZUxu7RMj23JxkO8xD1Lo6T58P77q2UYRa2VXqykY4L0b26wdebpnoRSMRgsboRtqJmy2kaY53VsJSYmBSUxv1tcYwuhA2gML2YF3uwCh46gF2HM+kFPWOGvol5KL/X0iYDDx6a7Mkhss=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=JhcJalK9; arc=none smtp.client-ip=209.85.208.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="JhcJalK9"
Received: by mail-lj1-f171.google.com with SMTP id 38308e7fff4ca-2f3f0bdbcd9so47896361fa.1
        for <nvdimm@lists.linux.dev>; Mon, 26 Aug 2024 06:17:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1724678248; x=1725283048; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=sAQ6M5i9O8EydHcTNPBCvK0jtmZ3cgr0b0dzil6s4RI=;
        b=JhcJalK90RfVeL+EMq1lGFUN0oL4qGg+6W0oIKJSFpyfo2WYweDStlqGVnM6BFW61U
         R9z0t8FRJ9Kp2YRhtZUvKwVdDj50HO0QeGIFDJIJxsVsCxksE31fs+WQPVCVZItarw7D
         sqjOt6aMK7HTohy/UJqi6qqANQMJAKu4zZP4OJ2o7OT0xPFP/O+52FDFHpGgdf95Ut7P
         gsRMLKcCcXaXhmC70yx+Cvr16cBMtRw5Xvk6Zjf+a2Iu2Sb1uVr3iNmXwDiMoMl8q2BM
         hdl7Pmr5VJCEqMaziCnJjImGrXmwimcCWEE/1LugbIJb3ut8Whp+WJ8TKka5NUoWLwoN
         kYDw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1724678248; x=1725283048;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=sAQ6M5i9O8EydHcTNPBCvK0jtmZ3cgr0b0dzil6s4RI=;
        b=mX8DQDtBpUQBoGqH6z/MN81x64BzUUWTU4FI8GL1qG+z33ofvyWqDRBhbEDiNUm6zU
         JCXOmfwixCLyGYsykSc1T2LuTOqqg2/Nlf5YTHT6HS6qi4E+SGnaMxrjOEEafBKVpCHf
         HJZqRGW342h3lCdTO9xNnqx6qsoTgHYmwykArNWtKdLVqCoHPg2V4m5aZdO7ZNNE7EMX
         T4MdvB14ayCpV6ZBEKjhOFxH9SvFU0dkYF4/ETSt+2vAepRggwO7xbtBRU8JJwsFPCgF
         /TMXD4QtH6yTEOW2q92We+D6Hl342tzg97UOCYt+65V5r5boit6d6hGzhVCYnnpLHVvM
         v4AA==
X-Forwarded-Encrypted: i=1; AJvYcCWypA/d791ICxsXzYuXMSxfSX3ImMHXARR7LWtTPs6kgHwTqYBtzxc04GLsdqOlT8IZPwryxmY=@lists.linux.dev
X-Gm-Message-State: AOJu0YzNTQe5KotNiqhODa4sPT8FL2VvhcfE+hZo/kB9EWPzT3dPPZY3
	XajLp9tRAbw+bOLe7XjOr7MXTgnSccvuA2oXv+AYcjXscGH5VMie5EO/tJh8LhQ=
X-Google-Smtp-Source: AGHT+IF23h3rP35OdQrEVkqc47eRF5yl1OaSv9GaxlcrSNP3KudzCHntUQv44MhoMobTuNvYO7e7Lw==
X-Received: by 2002:a2e:71a:0:b0:2ec:637a:c212 with SMTP id 38308e7fff4ca-2f4f493a108mr65127501fa.39.1724678248005;
        Mon, 26 Aug 2024 06:17:28 -0700 (PDT)
Received: from pathway.suse.cz ([193.86.92.181])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-5c044ddc6basm5590989a12.12.2024.08.26.06.17.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 26 Aug 2024 06:17:27 -0700 (PDT)
Date: Mon, 26 Aug 2024 15:17:26 +0200
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
Message-ID: <ZsyAZsDeWLNvSec9@pathway.suse.cz>
References: <20240816-dcd-type2-upstream-v3-0-7c9b96cba6d7@intel.com>
 <20240816-dcd-type2-upstream-v3-2-7c9b96cba6d7@intel.com>
 <ZsSjdjzRSG87alk5@pathway.suse.cz>
 <66c77b1c5c65c_1719d2940@iweiny-mobl.notmuch>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <66c77b1c5c65c_1719d2940@iweiny-mobl.notmuch>

On Thu 2024-08-22 12:53:32, Ira Weiny wrote:
> Petr Mladek wrote:
> > On Fri 2024-08-16 09:44:10, Ira Weiny wrote:
> > > The use of struct range in the CXL subsystem is growing.  In particular,
> > > the addition of Dynamic Capacity devices uses struct range in a number
> > > of places which are reported in debug and error messages.
> > > 
> > > To wit requiring the printing of the start/end fields in each print
> > > became cumbersome.  Dan Williams mentions in [1] that it might be time
> > > to have a print specifier for struct range similar to struct resource
> > > 
> > > A few alternatives were considered including '%pn' for 'print raNge' but
> > > %par follows that struct range is most often used to store a range of
> > > physical addresses.  So use '%par' for 'print address range'.
> > > 
> > > diff --git a/lib/vsprintf.c b/lib/vsprintf.c
> > > index 2d71b1115916..c132178fac07 100644
> > > --- a/lib/vsprintf.c
> > > +++ b/lib/vsprintf.c
> > > @@ -1140,6 +1140,39 @@ char *resource_string(char *buf, char *end, struct resource *res,
> > >  	return string_nocheck(buf, end, sym, spec);
> > >  }
> > >  
> > > +static noinline_for_stack
> > > +char *range_string(char *buf, char *end, const struct range *range,
> > > +		      struct printf_spec spec, const char *fmt)
> > > +{
> > > +#define RANGE_PRINTK_SIZE		16
> > > +#define RANGE_DECODED_BUF_SIZE		((2 * sizeof(struct range)) + 4)
> > > +#define RANGE_PRINT_BUF_SIZE		sizeof("[range - ]")

[...]

> > > +	static const struct printf_spec range_spec = {
> > > +		.base = 16,
> > > +		.field_width = RANGE_PRINTK_SIZE,
> 
> However, my testing indicates this needs to be.
> 
>                 .field_width = 18, /* 2 (0x) + 2 * 8 (bytes) */

Makes sense. Great catch!

> ... to properly zero pad the value.  Does that make sense?
>
> > > +		.precision = -1,
> > > +		.flags = SPECIAL | SMALL | ZEROPAD,
> > > +	};
> > > +
> > > +	*p++ = '[';
> > > +	p = string_nocheck(p, pend, "range ", str_spec);
> > > +	p = number(p, pend, range->start, range_spec);
> > > +	*p++ = '-';
> > > +	p = number(p, pend, range->end, range_spec);
> > > +	*p++ = ']';
> > > +	*p = '\0';

Best Regards,
Petr
