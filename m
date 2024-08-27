Received: from mail-ed1-f42.google.com (mail-ed1-f42.google.com [209.85.208.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F004812F5B1
	for <nvdimm@lists.linux.dev>; Tue, 27 Aug 2024 07:43:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724744618; cv=none; b=SmIXg6tAyuCXNrioCvhPsyvZiHwKqap5fyXMEeI+N11rMUuCFQ1v5otLoyCh5J88HuOxocb5SHtf9Ps7NnfOmGw/VZMUGvWB6ZfvmGwqPoCxMCW6PzGrvIBEnspfr6ykEf6W+KMeCvNOpYmkIcOVuxx83wEoTj2kiXL6TZSJRu0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724744618; c=relaxed/simple;
	bh=9O+wV+FDw4hvHkak6u5i2N5UmUmRnNZjiSFhsZp5OhQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=HtnC4017NH3xVkY5fZEBngrgrckh5XPs6RlyHeLTDSef1owggQESR80SrSm8yoVyi745D/6wBsgE/OhM6+rKklSkjU0YeK8nCqZHEK6ECqUqWwuP0DnTJq45JYBaC9MfZgmrXC+369vqrWDa2pp6KQrE6393QObOaPcjbVQHH9g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=Ddupzn0x; arc=none smtp.client-ip=209.85.208.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="Ddupzn0x"
Received: by mail-ed1-f42.google.com with SMTP id 4fb4d7f45d1cf-5bf009cf4c0so5476378a12.1
        for <nvdimm@lists.linux.dev>; Tue, 27 Aug 2024 00:43:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1724744614; x=1725349414; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=oTDyalBaKZ6GvpyVhJbU4E6wPQv70hj8wtzNRSfGJVc=;
        b=Ddupzn0xNH0pyJvkG83TAfeIGpM5J0GKgSWPPBZVsucpLq3txAf+LkUBXjtpw/fttU
         pxTAleKO0vS2q3oBc80zPiV49BDSI/JIb0SN/+ZWeiQFfwg0lmdQS1Mt/XUEg5RWdP8t
         6ASr9BfyXsY1Ib29BtjqUwvkspt3KjeeBR/MFFS9w0SKodicd1SbrrDv0TKAAHYmTkNF
         q0zS9VKov/ZCZ6LmO26sZPxJwgrWcVCXaqQhutD/vd4YzvEUAd8AofpLStUMTxV+qulD
         CQdB0pu5TJSik/evfMJ0F2cKuoxWt65dU970hiVCMb7EXSfaW0I1IJ1Cgbdo+xQE93U3
         UqhQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1724744614; x=1725349414;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=oTDyalBaKZ6GvpyVhJbU4E6wPQv70hj8wtzNRSfGJVc=;
        b=DzBDcSBkprb5WuTn4AZpz6mt2bZXh/b+qBjqdlpQt6KacPjqgcHo+ussyl0nhviTNA
         AEbq776IDGkeLi2fZqhYRdOIL8pb9t0QtvVzKZfR9rkdfG0kWwtHzgxpDXAXVCj2YCa7
         Os8yD8Fh2gwgfrXox3iGMtSvyMUBYITHF7K3ZY04VuPkI1jqd4eOY6s8MlUp525/hBVF
         egrzd1mc+Scbs6dMXhO4IPEFAKbpa1RcYviXq6+ANcSer8okSIzjp7fYgtj08u92eR1+
         xpDutwMAgpdqf5qBqOEbovADI+AP79YH7LRaNNvlohOQWvtlcOCTcauCH4eIRlHy06Ot
         W1Ag==
X-Forwarded-Encrypted: i=1; AJvYcCWPjG+GQAehTj05YF5OCjrU+KFGltMRgAhvKj/AsbzA8I1uxsOOwf/dqkqh26jtKUqDQGTa7GU=@lists.linux.dev
X-Gm-Message-State: AOJu0YzUsy0PwAhMkh4C5+OgXtvjgdpHJnk9yAvZZ923FXJNZfNFoXHF
	kB8Zij5lbeD5lamJ4Bx8r445pUDjFTK0Ist+1wQDxFYeHC4VAN1nrdFsJg4CBDc=
X-Google-Smtp-Source: AGHT+IH7Fgf/EB0JBJKuUh2fTIXnJD3jA6O0dLLhMvQDq4Jq6cjKeLWS5uYP/wIJcEcCmyeKJ1TGAA==
X-Received: by 2002:a05:6402:5203:b0:5be:d63a:4608 with SMTP id 4fb4d7f45d1cf-5c0ba299682mr1136660a12.3.1724744614148;
        Tue, 27 Aug 2024 00:43:34 -0700 (PDT)
Received: from pathway.suse.cz ([176.114.240.50])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-5c0bb209c2csm687412a12.41.2024.08.27.00.43.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 27 Aug 2024 00:43:33 -0700 (PDT)
Date: Tue, 27 Aug 2024 09:43:32 +0200
From: Petr Mladek <pmladek@suse.com>
To: Ira Weiny <ira.weiny@intel.com>
Cc: Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
	Dave Jiang <dave.jiang@intel.com>, Fan Ni <fan.ni@samsung.com>,
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
Message-ID: <Zs2DhzbLK_LU6B0a@pathway.suse.cz>
References: <20240816-dcd-type2-upstream-v3-0-7c9b96cba6d7@intel.com>
 <20240816-dcd-type2-upstream-v3-2-7c9b96cba6d7@intel.com>
 <ZsSjdjzRSG87alk5@pathway.suse.cz>
 <66c77b1c5c65c_1719d2940@iweiny-mobl.notmuch>
 <Zsd_EctNZ80fuKMu@smile.fi.intel.com>
 <ZsyB5rqhaZ-oRwny@pathway.suse.cz>
 <Zsy6BbJiYqiXORGu@smile.fi.intel.com>
 <66ccf10089b0_e0732294ef@iweiny-mobl.notmuch>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <66ccf10089b0_e0732294ef@iweiny-mobl.notmuch>

On Mon 2024-08-26 16:17:52, Ira Weiny wrote:
> Andy Shevchenko wrote:
> > On Mon, Aug 26, 2024 at 03:23:50PM +0200, Petr Mladek wrote:
> > > On Thu 2024-08-22 21:10:25, Andy Shevchenko wrote:
> > > > On Thu, Aug 22, 2024 at 12:53:32PM -0500, Ira Weiny wrote:
> > > > > Petr Mladek wrote:
> > > > > > On Fri 2024-08-16 09:44:10, Ira Weiny wrote:
> > 
> > ...
> > 
> > > > > > > +	%par	[range 0x60000000-0x6fffffff] or
> > > > > > 
> > > > > > It seems that it is always 64-bit. It prints:
> > > > > > 
> > > > > > struct range {
> > > > > > 	u64   start;
> > > > > > 	u64   end;
> > > > > > };
> > > > > 
> > > > > Indeed.  Thanks I should not have just copied/pasted.
> > > > 
> > > > With that said, I'm not sure the %pa is a good placeholder for this ('a' stands
> > > > to "address" AFAIU). Perhaps this should go somewhere under %pr/%pR?
> 
> I'm speaking a bit for Dan here but also the logical way I thought of
> things.
> 
> 1) %p does not dictate anything about the format of the data.  Rather
>    indicates that what is passed is a pointer.  Because we are passing a
>    pointer to a range struct %pXX makes sense.
> 2) %pa indicates what follows is 'address'.  This was a bit of creative
>    license because, as I said in the commit message most of the time
>    struct range contains an address range.  So for this narrow use case it
>    also makes sense.
> 3) %par r for range.

Yes. I got it.

Well, is struct range really used for addresses? It rather looks like
a range of any 64-bit values.

> %p[rR] is taken.  %pra confuses things IMO.

Another variants might be %pr64 or %prange.

IMHO, there is no good solution. We are trying to find the least
bad one. The meaning should be as obvious and as least confusing
as possible.

Honestly, I do not have a strong opinion. I kind of like %prange ;-)
But I could live with all other variants, except for %pn mentioned below.

> > > The r/R in %pr/%pR actually stands for "resource".
> > > 
> > > But "%ra" really looks like a better choice than "%par". Both
> > > "resource"  and "range" starts with 'r'. Also the struct resource
> > > is printed as a range of values.
> 
> %r could be used I think.  But this breaks with the convention of passing a
> pointer and how to interpret it.

How exactly does it break the convention, please?

Do you passing a pointer to struct range instead of a pointer to
struct resource?

It should not be a big problem as long as the vsprintf() code is
able to guess the right pointer type from the %pXX modifier.

> The other idea I had, mentioned in the commit
> message was %pn.  Meaning passed by pointer 'raNge'.

This looks like the worst variant to me.

> > Fine with me as long as it:
> > 1) doesn't collide with %pa namespace
> > 2) tries to deduplicate existing code as much as possible.
> 
> Andy, I'm not quite following how you expect to share the code between
> resource_string() and range_string()?
> 
> There is very little duplicated code.  In fact with Petr's suggestions and some
> more work range_string() is quite simple:
>
> +static noinline_for_stack
> +char *range_string(char *buf, char *end, const struct range *range,
> +                     struct printf_spec spec, const char *fmt)
> +{
> +#define RANGE_DECODED_BUF_SIZE         ((2 * sizeof(struct range)) + 4)
> +#define RANGE_PRINT_BUF_SIZE           sizeof("[range -]")
> +       char sym[RANGE_DECODED_BUF_SIZE + RANGE_PRINT_BUF_SIZE];
> +       char *p = sym, *pend = sym + sizeof(sym);
> +
> +       *p++ = '[';
> +       p = string_nocheck(p, pend, "range ", default_str_spec);
> +       p = special_hex_number(p, pend, range->start, sizeof(range->start));
> +       *p++ = '-';
> +       p = special_hex_number(p, pend, range->end, sizeof(range->end));
> +       *p++ = ']';
> +       *p = '\0';
> +
> +       return string_nocheck(buf, end, sym, spec);
> +}

I agree that there is not much duplicated code in the end.

> Also this is the bulk of the patch except for documentation and the new
> testing code.  [new patch below]
> 
> Am I missing your point somehow?  I considered cramming a struct range into a
> struct resource to let resource_string() process the data.  But that would
> involve creating a new IORESOURCE_* flag (not ideal) and also does not allow
> for the larger u64 data in struct range should this be a 32 bit physical
> address config.

This would be nasty. I believe that this is not what Andy meant.

Best Regards,
Petr

PS: I have vacation until the end of the week, so my next eventual
    reaction would be delayed.
