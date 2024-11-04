Received: from mail-pl1-f171.google.com (mail-pl1-f171.google.com [209.85.214.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 88A731C32E2
	for <nvdimm@lists.linux.dev>; Mon,  4 Nov 2024 22:16:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730758606; cv=none; b=ODLOCGRmrS3BOlgsJayixOKxhB2MLLxcKyETBDi3OYWQ5UW14OVDmPpbV0Y8LDy+BzVHUH4xUHebU48wkqscAroL9as+SEAUo14VQpv0Hg/AxJpjvZ+KSGafwpmMX9hkJlDhbPI1Jv3asUFpSr3a7ynFUxhGxSR4O157sQ34ig8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730758606; c=relaxed/simple;
	bh=KspYLPaVUiBiulhfcb/F9ddte9kdJsUyFpLrtdXID7k=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=RWthWRl6xtyyAFOJmGGyXQnbkUgeo+5uPBLJ3FSDK0wCc78o+fYIVSVVKYquuuwCZLgAkI6EA09gyj9lMeFkh7O7P6oMeOYqsIvZS21z4IYS2SJMyKPs+Vn2gu5LaRCkXUoeLBaHPXWZ+andBOwguh1A6zOe0efCMjJTUghIPYw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fromorbit.com; spf=pass smtp.mailfrom=fromorbit.com; dkim=pass (2048-bit key) header.d=fromorbit-com.20230601.gappssmtp.com header.i=@fromorbit-com.20230601.gappssmtp.com header.b=rKYwT6iG; arc=none smtp.client-ip=209.85.214.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fromorbit.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fromorbit.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fromorbit-com.20230601.gappssmtp.com header.i=@fromorbit-com.20230601.gappssmtp.com header.b="rKYwT6iG"
Received: by mail-pl1-f171.google.com with SMTP id d9443c01a7336-20cb47387ceso45173405ad.1
        for <nvdimm@lists.linux.dev>; Mon, 04 Nov 2024 14:16:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fromorbit-com.20230601.gappssmtp.com; s=20230601; t=1730758604; x=1731363404; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=wx+CQscmonr+En4OMi1iBJFsPpXGN7GSbg6rvgqJS3g=;
        b=rKYwT6iG/yiyI+fxwW1rBg+TLDcU9l05ha7Tx0l6qAW3nTWnbPOkNtD6riDuyUb3FJ
         DO4hVA7xbswVzdngY46T1vTzY/b62RqcMNOyMEIvSi3DGwXpKcSFfXIMl0f5IoA+4z+Q
         C7Xu2rFT8t6DlU3zfaC8rMnBew988IgnFxCidxwHwhFzi53AVp3rjrFBrT95xtjy5Gqc
         0c2E4CwMIfpnGtSrPdiX5ornnlHyTaqe+gX2gsLxaU6oent1E5apMwfYuvMN5KO6qlsc
         qze5ZO6Z+c813IWFMdXnjmYBJznvDPeeyVIZpqBXEGAGgc7ZBEXWesP/KdKRXBkgzZ43
         Ru+A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1730758604; x=1731363404;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=wx+CQscmonr+En4OMi1iBJFsPpXGN7GSbg6rvgqJS3g=;
        b=E7T5CRKAeLaOHWhijT6ZrDd81h2HLqH4eXwTiDi4EotZpDGKHhtGMzCpC9DN6zAk88
         quMef564FxJ11pnxzYUqRGfmEJyJ6M6E+M6NFiRdrUfGjTDgZZ0wDxV9/Wohrx5KlNHl
         MdnXO1d1RMFZhEuH+DiSck0hU9WnEQud8l7LEjlnF0GSUIPmH0q2TMwG/4iYZTwwp0el
         ZO9LFVbCp6dXpNkb9c0j+TAlZ8FFfF9JT3PYNHJROo85BpC4Gcz7FmHxy/GGnzFK+dwl
         uOR12pjWW0eINiAmbsCnnVVy4irWgndx0as5i04TKB7eR3z0P6wN7X85isY+KUPlsL+u
         /eCA==
X-Forwarded-Encrypted: i=1; AJvYcCVpiKo1PfbsY5iCXzNc8G/kGYG+F6ow8mHAF1iqx5K2khNJdTWPOANz7KpPErf+XP/xo02UPPg=@lists.linux.dev
X-Gm-Message-State: AOJu0YxNGlAlRUIxtteYc2eUUijsTIeHNeuo3NHQK/gxXAAzN9tM76hm
	CMhmFLgPCqKlaVk6uxZg8MAQ3iVbR5Uia4ifMbaEaJBay8XGWr5L287d/p4edBI=
X-Google-Smtp-Source: AGHT+IH/GmFwfz/KLQqwABZCJIOJSQdacBDN9n3cToWkKGuNB5vkYCzMkd096fPZfHkRC1ZU+KBkfQ==
X-Received: by 2002:a17:902:e80c:b0:20b:b93f:300a with SMTP id d9443c01a7336-210c6872dabmr463716335ad.7.1730758603626;
        Mon, 04 Nov 2024 14:16:43 -0800 (PST)
Received: from dread.disaster.area (pa49-186-86-168.pa.vic.optusnet.com.au. [49.186.86.168])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-21105708681sm65856185ad.89.2024.11.04.14.16.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 04 Nov 2024 14:16:43 -0800 (PST)
Received: from dave by dread.disaster.area with local (Exim 4.96)
	(envelope-from <david@fromorbit.com>)
	id 1t85NI-00AE83-1f;
	Tue, 05 Nov 2024 09:16:40 +1100
Date: Tue, 5 Nov 2024 09:16:40 +1100
From: Dave Chinner <david@fromorbit.com>
To: Asahi Lina <lina@asahilina.net>
Cc: Jan Kara <jack@suse.cz>, Dan Williams <dan.j.williams@intel.com>,
	Matthew Wilcox <willy@infradead.org>,
	Alexander Viro <viro@zeniv.linux.org.uk>,
	Christian Brauner <brauner@kernel.org>,
	Sergio Lopez Pascual <slp@redhat.com>,
	linux-fsdevel@vger.kernel.org, nvdimm@lists.linux.dev,
	linux-kernel@vger.kernel.org, asahi@lists.linux.dev
Subject: Re: [PATCH] dax: Allow block size > PAGE_SIZE
Message-ID: <ZylHyD7Z+ApaiS5g@dread.disaster.area>
References: <20241101-dax-page-size-v1-1-eedbd0c6b08f@asahilina.net>
 <20241104105711.mqk4of6frmsllarn@quack3>
 <7f0c0a15-8847-4266-974e-c3567df1c25a@asahilina.net>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <7f0c0a15-8847-4266-974e-c3567df1c25a@asahilina.net>

On Tue, Nov 05, 2024 at 12:31:22AM +0900, Asahi Lina wrote:
> 
> 
> On 11/4/24 7:57 PM, Jan Kara wrote:
> > On Fri 01-11-24 21:22:31, Asahi Lina wrote:
> >> For virtio-dax, the file/FS blocksize is irrelevant. FUSE always uses
> >> large DAX blocks (2MiB), which will work with all host page sizes. Since
> >> we are mapping files into the DAX window on the host, the underlying
> >> block size of the filesystem and its block device (if any) are
> >> meaningless.
> >>
> >> For real devices with DAX, the only requirement should be that the FS
> >> block size is *at least* as large as PAGE_SIZE, to ensure that at least
> >> whole pages can be mapped out of the device contiguously.
> >>
> >> Fixes warning when using virtio-dax on a 4K guest with a 16K host,
> >> backed by tmpfs (which sets blksz == PAGE_SIZE on the host).
> >>
> >> Signed-off-by: Asahi Lina <lina@asahilina.net>
> >> ---
> >>  fs/dax.c | 2 +-
> >>  1 file changed, 1 insertion(+), 1 deletion(-)
> > 
> > Well, I don't quite understand how just relaxing the check is enough. I
> > guess it may work with virtiofs (I don't know enough about virtiofs to
> > really tell either way) but for ordinary DAX filesystem it would be
> > seriously wrong if DAX was used with blocksize > pagesize as multiple
> > mapping entries could be pointing to the same PFN which is going to have
> > weird results.
> 
> Isn't that generally possible by just mapping the same file multiple
> times? Why would that be an issue?

I think what Jan is talking about having multiple inode->i_mapping
entries point to the same pfn, not multiple vm mapped regions
pointing at the same file offset....

> Of course having a block size smaller than the page size is never going
> to work because you would not be able to map single blocks out of files
> directly. But I don't see why a larger block size would cause any
> issues. You'd just use several pages to map a single filesystem block.

If only it were that simple.....

> For example, if the block size is 16K and the page size is 4K, then a
> single file block would be DAX mapped as four contiguous 4K pages in
> both physical and virtual memory.

Up until 6.12, filesystems on linux did not support block size >
page size. This was a constraint of the page cache implementation
being based around the xarray indexing being tightly tied to
PAGE_SIZE granularity indexing. Folios and large folio support
provided the infrastructure to allow indexing to increase to order-N
based index granularity. It's only taken 20 years to get a solution
to this problem merged, but it's finally there now.

Unfortunately, the DAX infrastructure is independent of the page
cache but is also tightly tied to PAGE_SIZE based inode->i_mapping
index granularity. In a way, this is even more fundamental than the
page cache issues we had to solve. That's because we don't have
folios with their own locks and size tracking. In DAX, we use the
inode->i_mapping xarray entry for a given file offset to -serialise
access to the backing pfn- via lock bits held in the xarray entry.
We also encode the size of the dax entry in bits held in the xarray
entry.

The filesystem needs to track dirty state with filesystem block
granularity. Operations on filesystem blocks (e.g. partial writes,
page faults) need to be co-ordinated across the entire filesystem
block. This means we have to be able to lock a single filesystem
block whilst we are doing instantiation, sub-block zeroing, etc.

Large folio support in the page cache provided this "single tracking
object for a > PAGE_SIZE range" support needed to allow fsb >
page_size in filesystems. The large folio spans the entire
filesystem block, providing a single serialisation and state
tracking for all the page cache operations needing to be done on
that filesystem block.

The DAX infrastructure needs the same changes for fsb > page size
support. We have a limited number bits we can use for DAX entry
state:

/*
 * DAX pagecache entries use XArray value entries so they can't be mistaken
 * for pages.  We use one bit for locking, one bit for the entry size (PMD)
 * and two more to tell us if the entry is a zero page or an empty entry that
 * is just used for locking.  In total four special bits.
 *
 * If the PMD bit isn't set the entry has size PAGE_SIZE, and if the ZERO_PAGE
 * and EMPTY bits aren't set the entry is a normal DAX entry with a filesystem
 * block allocation.
 */
#define DAX_SHIFT       (4)
#define DAX_LOCKED      (1UL << 0)
#define DAX_PMD         (1UL << 1)
#define DAX_ZERO_PAGE   (1UL << 2)
#define DAX_EMPTY       (1UL << 3)

I *think* that we have at most PAGE_SHIFT worth of bits we can
use because we only store the pfn part of the pfn_t in the dax
entry. There are PAGE_SHIFT high bits in the pfn_t that hold
pfn state that we mask out.

Hence I think we can easily steal another 3 bits for storing an
order - orders 0-4 are needed (3 bits) for up to 64kB on 4kB
PAGE_SIZE - so I think this is a solvable problem. There's a lot
more to it than "just use several pages to map to a single
filesystem block", though.....

> > If virtiofs can actually map 4k subpages out of 16k page on
> > host (and generally perform 4k granular tracking etc.), it would seem more
> > appropriate if virtiofs actually exposed the filesystem 4k block size instead
> > of 16k blocksize? Or am I missing something?
> 
> virtiofs itself on the guest does 2MiB mappings into the SHM region, and
> then the guest is free to map blocks out of those mappings. So as long
> as the guest page size is less than 2MiB, it doesn't matter, since all
> files will be aligned in physical memory to that block size. It behaves
> as if the filesystem block size is 2MiB from the point of view of the
> guest regardless of the actual block size. For example, if the host page
> size is 16K, the guest will request a 2MiB mapping of a file, which the
> VMM will satisfy by mmapping 128 16K pages from its page cache (at
> arbitrary physical memory addresses) into guest "physical" memory as one
> contiguous block. Then the guest will see the whole 2MiB mapping as
> contiguous, even though it isn't in physical RAM, and it can use any
> page granularity it wants (that is supported by the architecture) to map
> it to a userland process.

Clearly I'm missing something important because, from this
description, I honestly don't know which mapping is actually using
DAX.

Can you draw out the virtofs stack from userspace in the guest down
to storage in the host so dumb people like myself know exactly where
what is being directly accessed and how?

-Dave.
-- 
Dave Chinner
david@fromorbit.com
