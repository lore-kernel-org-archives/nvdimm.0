Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794943891;
	b=WPZmfBonbAsPU+Glc3C2boefIFZ73vt3c4ib7qMhqs0BTS/7QGALYbbEC06VxKkuVI2E
	 WkQlxpsxSSbvzTz9n8edxwrGkO5Ne+JVJrUw9zsDsAQjb3dYWOt7Snf7odRD41TeUXpfd
	 +EHM+ErUVGjSzj4z2YZ4wZl1qt6cGhuK5SEwM66MKit6ytwbGP1T8wuRtl2mk3vjh11tK
	 Zbrt0JXR0I1fNpsSSs9z72c46l13En+eEVsaBVoDJcgGoUQY1NDH8QNZJyHIBinRwt660
	 g48/czs+ZXvviaJHG2xT2xMnRhOChRKD927YmcBa/I7R7o6EoZ3biSeCT/9gQMtDmaA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794943891;
	h=Received:DKIM-Signature:Date:From:To:Cc:Subject:Message-ID:
	 References:MIME-Version:Content-Type:Content-Disposition:In-Reply-To;
	bh=nCo75ty0Aujy0KouEOqop0m/uhiJYaP585U75o493OY=;
	b=cCgMJJaQSIVbZu/5iw4Kfj0zYXJw7+cLPx1DeT/qiSLbEg+0r2IREtyzj/QBH2Lt4mPB
	 pY+dwtZvjKlDb0KHo/BhljTR3CRwog25lMpKdG2ifcDmpX+KbBZleOzEOU++tziq4X68Q
	 cwfvJ5haNRb0XUhBgRQ8Qp7WfwhWX3tII1EvVivOXmXKsysZ0l9cr36ShqXSreerLBRp7
	 X87fVPRXxpqt1Y01hRUrquxQBTJfU4YAWpaSb+qW6ZO+fqk5k8gdNPUAhkwgXY72pBrsW
	 qIKX2XEoCTbeN6EP/ODc6K6WNHTckgiHHH4dop1SPrYOX/GTkqXwCpJT/ipk4uq8BDQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=d1vONByq;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 33B1D606A31C;
	Tue, 17 Nov 2026 19:31:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=d1vONByq
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 038431F000C4;
	Tue, 17 Nov 2026 19:31:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794943891;
	bh=nCo75ty0Aujy0KouEOqop0m/uhiJYaP585U75o493OY=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=d1vONByq+DDyy6hoJWEKC68lOH75ploQoY1NLx+0O5oC94nqHsUDXPalbkANcNki6
	 ++gQfJgcvQNpWgizWI1PgBa+fCWPvowl9hqQr6QanrmNsEUacbVHokluhHkK+XJPlb
	 Sr7iAfbN684agAd4VT2T/gQv95c2KbCwBgq0WAeovaHc5SNxGdHxXDUlet8x5Lgx2r
	 fZ5U7rruCNi1DEt0M0d8Gb82ZTOBYeLYUO9X7KcFh1feo/sW7kZ/VHTRbPLlYvDxeE
	 gdWkQcIvOHAE3/GUJNQ+QVtVpvwuVAblhZglWCkd+vkKd3kO/kcAAFgwTI3MkWFWyl
	 QdSFrLqWqfj9w==
Date: Tue, 17 Nov 2026 21:31:23 +0200
From: Mike Rapoport <rppt@kernel.org>
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, Jan Kara <jack@suse.cz>,
	Jingyi Sun <1045704958@qq.com>,
	"Liam R. Howlett" <liam@infradead.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	Matthew Wilcox <willy@infradead.org>,
	Michal Hocko <mhocko@suse.com>,
	Muhammad Usama Anjum <usama.anjum@arm.com>,
	Peter Xu <peterx@redhat.com>,
	Suren Baghdasaryan <surenb@google.com>,
	Vlastimil Babka <vbabka@kernel.org>, linux-kernel@vger.kernel.org,
	linux-mm@kvack.org, nvdimm@lists.linux.dev
Subject: Re: [PATCH 0/3] mm/memory: fix handling of PTE markers in
 insert_page_into_pte_locked()
Message-ID: <avyri3PoPUriTmxN@kernel.org>
References: <20261117-uffd-dax-async-wp-fix-v1-0-c9a30f27f452@kernel.org>
 <7ae17206-829d-4fdb-afd0-cc14c5411b74@kernel.org>
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Post: <mailto:nvdimm@lists.linux.dev>
List-Help: <mailto:nvdimm+help@lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
List-Owner: <mailto:nvdimm+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <7ae17206-829d-4fdb-afd0-cc14c5411b74@kernel.org>

On Tue, Nov 17, 2026 at 05:22:09PM +0100, David Hildenbrand (Arm) wrote:
> On 11/17/26 16:58, Mike Rapoport (Microsoft) wrote:
> > Jingyi reported that a uffd-wp marker in a DAX mapping causes endless
> > refaults on reads and SIGBUS on writes [1].
> > 
> > The root cause is that insert_page_into_pte_locked() treats every PTE that
> > is not none as a present mapping. Besides uffd-wp markers, this also
> > affects guard markers that MADV_GUARD_INSTALL can put into a DAX mapping
> > concurrently with a write fault.
> > 
> > The first patch restructures insert_page_into_pte_locked() to make room
> > for the fixes, the second patch fixes the reported issue and the third
> > makes write faults back off on non-present PTEs.
> > 
> > Both issues were reproduced on ext4 with dax=always on emulated pmem, and
> > the fixes were verified with these reproducers.
> > selftests.
> > 
> > [1] https://lore.kernel.org/all/tencent_1874C71D4177A1624528043E008DB1A5EF05@qq.com
> > 
> > ---
> > Mike Rapoport (Microsoft) (3):
> >       mm/memory: install new PTEs first in insert_page_into_pte_locked()
> >       mm/memory: replace uffd-wp markers in insert_page_into_pte_locked()
> >       mm/memory: don't upgrade non-present PTEs in insert_page_into_pte_locked()
> > 
> >  mm/memory.c | 68 +++++++++++++++++++++++++++++++------------------------------
> >  1 file changed, 35 insertions(+), 33 deletions(-)
> > ---
> > base-commit: 93d7a816a2df3e907e2719bd12b0073f1285fc5c
> > change-id: 20261117-uffd-dax-async-wp-fix-867acc8dc78f
> > 
> > --
> > Sincerely yours,
> > Mike.
> 
> 
> I have here a fix to disallow uffd on DAX entirely. It's completely broken.
> 
> I was staging it to send with others, but I can send it out separately.
 
Nah, no need.

But patch 3/3 here is for MADV_GUARD_INSTALL on DAX unrelated to uffd.

> -- 
> Cheers,
> 
> David

-- 
Sincerely yours,
Mike.
