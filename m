Received: from mail-qt1-f175.google.com (mail-qt1-f175.google.com [209.85.160.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 416E7387357
	for <nvdimm@lists.linux.dev>; Mon,  2 Feb 2026 18:02:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.175
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770055335; cv=none; b=WZewBq1Dr0aOZWLsiH7+bxQshRadR3AQwNlQwQ5l5pY7KdNaCS/306v52RHxHDqaL9MY/fURT0bkfRiYvGM3pD3TnPvyv6I/f1mUrkLHllMsQV9C3u0hZ9SZHELyVWF6TqccaICUCp5v+X39/9CShOCO8E0QScq664O19WuvZ6s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770055335; c=relaxed/simple;
	bh=MbAgTX+hDTfHzpvyoNvAv/VH86Gp5D8IWac2rvKmaY0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=YXTtgzx8czA7WHDyqrlx0GM0LaA52nJojQSVLRyDhI47mT/99CIIkp8jWmGimiaNZ5T1xAwkFTajxAhtHi3xFi1CYmZA28oJL45eZXzLIWA0qP3z6W5X13zHxkreZmcr8+wl909bdmrgINNlb/9urLwyfO6RDwuBO1WlAAbjl9k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=gourry.net; spf=pass smtp.mailfrom=gourry.net; dkim=pass (2048-bit key) header.d=gourry.net header.i=@gourry.net header.b=YAa33V6Y; arc=none smtp.client-ip=209.85.160.175
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=gourry.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gourry.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gourry.net header.i=@gourry.net header.b="YAa33V6Y"
Received: by mail-qt1-f175.google.com with SMTP id d75a77b69052e-502a4e3e611so73371cf.0
        for <nvdimm@lists.linux.dev>; Mon, 02 Feb 2026 10:02:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gourry.net; s=google; t=1770055333; x=1770660133; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=NMO26NJqLzUacsptvD643N0i+a1yKYqxDegqXwZutbI=;
        b=YAa33V6YaI4MYexf+CZul0xIqf58+7JUzYEkKj9IxPl12cGCcA3MOETpAuq5SA2eGu
         k70JsHHuqvVO+Q0cXIt+Z9/EZCraZ+QEAsgafh/DCOED4V9HLgaMjSWUvwZKN/y1EEa2
         L+/d85/HAsEdhF9QQkTFDQlPyDQQmSwLnfoK2eUC8WaNkN6DZQAMNabj6pms/TJk5tgv
         QX0OUeyTz4X69B9BqlaD+YiWOG6i0AEdZC2vcRgBFnkSfynNyWQf/XpCIClbxhsoqBLi
         9MhEtpjmu9zUCSNxxm2KkX73GGxhL47b+48jTP7mWPYSuK0X7hjbPHm7D32fYYZYvTCC
         ZRHg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1770055333; x=1770660133;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=NMO26NJqLzUacsptvD643N0i+a1yKYqxDegqXwZutbI=;
        b=sWxaTPgEvs1htQN3UtmLVDf+oJknzoFuPjF/P4rGCaX9t1NkQN28nvRuQTieLJvBmV
         uF8ZDD9gPz3CJdqsbquRShzr7ZrF6nM8dmowMUf/TTIslexhSF6qM9Zc3C339SBzxd1d
         i2MUHTHPOz9BSGR0cXbgDG5x319kYH8uZ8t+6/9LFyjDMbas9QN4fEn1vFVN0Y2qh6E9
         Z9H4hGljUU8wZHAl8q8ByHh/Ka/0IAzqfVHz8NE/XzWqaYHhPsRoepAD/IOdgXPMZ3IM
         DFcnurC+Y8aDNkIh1yaOiL/WWIDUqEaT2+FcrgoI/hySklcErJjlJRSjHa6nP//GtuME
         OE5A==
X-Forwarded-Encrypted: i=1; AJvYcCXpWShDsFheEqo67aCb8LuR4EVRrZflgU40pXv5NpbpHeJZG5WF/oBbSNRzV4PBAMBQXUrFNII=@lists.linux.dev
X-Gm-Message-State: AOJu0YxNhJKugM5OjiVQiX9bulKYjyYVvJzsglk3Uz4FXCZQjVhQ6uFW
	EDy50QsqueoES7akQEhWL/XWW5yiDJv6lDg2hUEuO/Wih7qtGVhiFiqvLrD2cdIXxyc=
X-Gm-Gg: AZuq6aJuctQcx9U0ioYg91KEsFFyrq+L6H0QsVrCackIuEBXnblNUJlB+3fp/BUvDj6
	twKEopTcqyFzKaFaku3vfFACa76tZIOjWPsyQHp3TeFcHn5ZE5hsnvIK4uvcvOR08PXx38fclNa
	7I5IIqS9qeDxR2oUp2cPVhc8055MuZMA+2Drgolei3+zhdWkJqpahbi3X0WwgpoVxCE2+g2oHhz
	PvjeKW14mW7zbxTAt4uLdjPkJAG9vukGt31Fi0b8fCQLz/LKO/ZTrU/445XrrV4XI/pchUKu63e
	5eI8nNjvz0mSULptuDnapZOoBvycbpMHLdisdP+QT1oFnr9Cf/2qnJom2XySmpR6JTo5nb6NMfe
	c+IC1n6tTziQZ7TzO5/xX9uUro8WlZWgnEiwh6mLEKBV8G25bDjnZ8FlmlWjb/VW4yc25nfqHXm
	jG28kO3kximDar7QutKzkSCC0RfSuX4/7vLmBLv+GZNdbuZolLmZYVur9npHPsrjqIvUZ1Pg==
X-Received: by 2002:ac8:5a54:0:b0:501:45d7:10cd with SMTP id d75a77b69052e-506092c7f24mr3163751cf.20.1770055332821;
        Mon, 02 Feb 2026 10:02:12 -0800 (PST)
Received: from gourry-fedora-PF4VCD3F (pool-96-255-20-138.washdc.ftas.verizon.net. [96.255.20.138])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-894d36c5430sm119862196d6.22.2026.02.02.10.02.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 02 Feb 2026 10:02:12 -0800 (PST)
Date: Mon, 2 Feb 2026 13:02:10 -0500
From: Gregory Price <gourry@gourry.net>
To: Jonathan Cameron <jonathan.cameron@huawei.com>
Cc: linux-mm@kvack.org, linux-cxl@vger.kernel.org, nvdimm@lists.linux.dev,
	linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-doc@vger.kernel.org, kernel-team@meta.com, dave@stgolabs.net,
	dave.jiang@intel.com, alison.schofield@intel.com,
	vishal.l.verma@intel.com, ira.weiny@intel.com,
	dan.j.williams@intel.com, willy@infradead.org, jack@suse.cz,
	terry.bowman@amd.com, john@jagalactic.com,
	David Hildenbrand <david@kernel.org>,
	Oscar Salvador <osalvador@suse.de>,
	Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH 2/9] mm/memory_hotplug: add __add_memory_driver_managed()
 with online_type arg
Message-ID: <aYDmor_ruasxaZ-7@gourry-fedora-PF4VCD3F>
References: <20260129210442.3951412-1-gourry@gourry.net>
 <20260129210442.3951412-3-gourry@gourry.net>
 <20260202172524.00000c6d@huawei.com>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260202172524.00000c6d@huawei.com>

On Mon, Feb 02, 2026 at 05:25:24PM +0000, Jonathan Cameron wrote:
> On Thu, 29 Jan 2026 16:04:35 -0500
> Gregory Price <gourry@gourry.net> wrote:
> 
> > Enable dax kmem driver to select how to online the memory rather than
> > implicitly depending on the system default.  This will allow users of
> > dax to plumb through a preferred auto-online policy for their region.
> > 
> > Refactor and new interface:
> > Add __add_memory_driver_managed() which accepts an explicit online_type
> > and export mhp_get_default_online_type() so callers can pass it when
> > they want the default behavior.
> 
> Hi Gregory,
> 
> I think maybe I'd have left the export for the first user outside of
> memory_hotplug.c. Not particularly important however.
> 
> Maybe talk about why a caller of __add_memory_driver_managed() might want
> the default?  Feels like that's for the people who don't...
>

Less about why they want the default, more about maintaining backward
compatibility.

In the cxl driver, Ben pointed out something that made me realize we can
change `region/bind()` to actually use the new `sysram/bind` path by
just adding a one line `sysram_regionN->online_type = default()`

I can add this detail to the changelog.

> 
> Other comments are mostly about using a named enum. I'm not sure
> if there is some existing reason why that doesn't work?  -Errno pushed through
> this variable or anything like that?
> 

I can add a cleanup-patch prior to use the enum, but i don't think this
actually enables the compiler to do anything new at the moment?

An enum just resolves to an int, and setting `enum thing val = -1` when
the enum definition doesn't include -1 doesn't actually fire any errors
(at least IIRC - maybe i'm just wrong). Same with

   function(enum) -> function(-1) wouldn't fire a compilation error

It might actually be worth adding `MMOP_NOT_CONFIGURED = -1` so that the
cxl-sysram driver can set this explicitly rather than just setting -1
as an implicit version of this - but then why would memory_hotplug.c
ever want to expose a NOT_CONFIGURED option lol.

So, yeah, the enum looks nicer, but not sure how much it buys us beyond
that.

> It's a little odd to add nice kernel-doc formatted documentation
> when the non __ variant has free form docs.  Maybe tidy that up first
> if we want to go kernel-doc in this file?  (I'm in favor, but no idea
> on general feelings...)
>

ack.  Can add some more cleanups early in the series.

> > +	if (online_type < 0 || online_type > MMOP_ONLINE_MOVABLE)
> 
> This is where using an enum would help compiler know what is going on
> and maybe warn if anyone writes something that isn't defined.
>

I think you still have to sanity check this, but maybe the code looks
cleaner, so will do. 

~Gregory
