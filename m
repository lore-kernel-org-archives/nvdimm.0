Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 211CA3F12EC;
	Thu, 30 Jul 2026 10:06:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785406019; cv=none; b=O5g75dj0AHf7x9a6svsfJOao5f9Uiyv9eWbXlf7oX8lcluNyoksFp6Zbz2xpcVStQgvs0o1ADopXpFFNWKngnKNDKOEdGlnM/Q+P/1jR5p0k08bpr2RrzqMRhDlHRJl/tq1SqqTQFT122BfzodJNyfEFWxCNoquDIgFh1P1Lt4k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785406019; c=relaxed/simple;
	bh=UUei0lD/EDb7h2v7ToPNN5nuFxLeREbeKm0rMZyUnpk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=gCgq1VE1gSMaE/XA4jHVYMtZTOVll5TERjx7MgcGDY8Xvjl2rGWBnAEgOKXTINXSVu3MKGVmkTsvvSmbgpQH0Rk0UfFeKwnu3cjorBKm5tpRX4HSkidUK5SPReA1Zo/jvPzJ/FcNdqy0dqwTVtRersWH1SzySNVmphbfBd2VRzg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=i/APtpjF; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="i/APtpjF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 83E0B1F000E9;
	Thu, 30 Jul 2026 10:06:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785406017;
	bh=UUei0lD/EDb7h2v7ToPNN5nuFxLeREbeKm0rMZyUnpk=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=i/APtpjFfiUT/jwTB0X6v6oJZclMp055NF0CkBCD3J2nPkV89Jb8UtbLPeNNCRNRl
	 EknI0ZySGCU3e0qUKusebo8eOUMFTKtX+9U/WCYY0kfVzvZCWuya2JnoHmaA6lgTRH
	 GtHApMybmJNIXjWCNYHA2YsFvfZGjCl5LlOUTjG1zQ4OIqSvBikIjQI73QVhLPSxUY
	 z2z9rn2N8Qm4gOJ2y0ksh0jhvcniBL8ZLeel0Tq+tmBN2C/n8R6tSbilYsv6dUAnXr
	 IxmkYDU6XBKfun/Ho6JEv71ZRQLzPCUJhtEvxpwmnWOkQaBLN6a5aBhLGDxTu4pdDX
	 cmaCsWWVW9zqw==
Date: Thu, 30 Jul 2026 11:06:33 +0100
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, Zi Yan <ziy@nvidia.com>, 
	Baolin Wang <baolin.wang@linux.alibaba.com>, "Liam R. Howlett" <liam@infradead.org>, 
	Nico Pache <nico.pache@linux.dev>, Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>, 
	Barry Song <baohua@kernel.org>, Lance Yang <lance.yang@linux.dev>, 
	Usama Arif <usama.arif@linux.dev>, Vlastimil Babka <vbabka@kernel.org>, 
	Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, 
	Michal Hocko <mhocko@suse.com>, Jonathan Corbet <corbet@lwn.net>, 
	Shuah Khan <skhan@linuxfoundation.org>, Heiko Carstens <hca@linux.ibm.com>, 
	Vasily Gorbik <gor@linux.ibm.com>, Alexander Gordeev <agordeev@linux.ibm.com>, 
	Christian Borntraeger <borntraeger@linux.ibm.com>, Sven Schnelle <svens@linux.ibm.com>, 
	Alexander Viro <viro@zeniv.linux.org.uk>, Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>, 
	Dan Williams <djbw@kernel.org>, Matthew Wilcox <willy@infradead.org>, 
	Kees Cook <kees@kernel.org>, Ingo Molnar <mingo@redhat.com>, 
	Peter Zijlstra <peterz@infradead.org>, Juri Lelli <juri.lelli@redhat.com>, 
	Vincent Guittot <vincent.guittot@linaro.org>, Dietmar Eggemann <dietmar.eggemann@arm.com>, 
	Steven Rostedt <rostedt@goodmis.org>, Ben Segall <bsegall@google.com>, Mel Gorman <mgorman@suse.de>, 
	Valentin Schneider <vschneid@redhat.com>, K Prateek Nayak <kprateek.nayak@amd.com>, linux-mm@kvack.org, 
	linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, linux-s390@vger.kernel.org, 
	linux-fsdevel@vger.kernel.org, nvdimm@lists.linux.dev, Pankaj Raghav <pankaj.raghav@linux.dev>
Subject: Re: [PATCH RFC] mm/huge_memory: eliminate reference-counted huge
 zero folio
Message-ID: <amsf4_v4EDcU6ePJ@lucifer>
References: <20260728-persist-huge-zero-folio-v1-1-e7b604eaf416@kernel.org>
 <04d881f4-419c-450e-b9b4-1341497fa93a@kernel.org>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <04d881f4-419c-450e-b9b4-1341497fa93a@kernel.org>

On Tue, Jul 28, 2026 at 09:16:08PM +0200, David Hildenbrand (Arm) wrote:
> On 7/28/26 15:06, Lorenzo Stoakes (ARM) wrote:
> > The reference-counted huge zero folio is problematic - it's prone to subtle
> > races, it can introduce allocation latency and it is confusing and
> > complicated code.
>
> Just a note that the subject is misleading: the huge zero folio is always
> refcounted (e.g., GUP must take references), it's just that the persistent huge
> zero folio never drops the refcount to 0 to free it.

I meant huge_zero_refcount not folio refcount :) but maybe could have been
clearer.

>
> What you probably mean is "mm/huge_memory: eliminate dynamically allocated huge
> zero folio".

Well that's not really getting to the core of it, the problem is the
huge_zero_refcount meaning it can come and go and you have races.

But agreed refcount is imprecise + clearly confusing vs. folio refcount given
you immediately assuemd that.

So 'mm/huge_memory: eliminiate dynmaically alloc'd/freed huge zero folio' maybe?

>
> If we go down that path here, we can also teach GUP to not take a reference on
> the huge zero folio anymore on the FOLL_PIN path, similar to how we handle the
> zero folio.
>
> See the occurrences of is_zero_folio() in mm/gup.c.

Ah yeah. Can do that on a respin, thanks.

>
> The reason we do it for now for FOLL_PIN is that a remote pin might outlive the
> process, meaning the huge folio could otherwise get freed by the shrinker even
> though someone still holds a reference. Bad. So that would no longer apply if
> the huge zero folio can no longer get freed.

Incredible that we have to think about this...

>
>
> I recall there was a discussion (dropping dynamically allocated huge zero folio)
> on this topic while upstreaming the persistent huge zero folio.
>
> I don't have time right now to dig, but it would be worthwhile to look at that
> history if there was a good reason to keep it buried in that discussion.

Maybe this:

https://lore.kernel.org/all/20250811084113.647267-4-kernel@pankajraghav.com/T/#m4100481232bae8a7b661e8f6e86ecc74532c69a4

Generally seems 'smaller systems blah blah'. But smaller systems that set
CONFIG_THP get bigger reserves etc. so the argument doesn't really work.

I suppose they might default CONFIG_THP on but not enable THP but at that point
are you really so tiny a system that 2 MiB matters?

Obviously it's more problematic for 64 KiB page size, but then if you have THP
at all your reserves will already be problematic, and any read fault on a THP
page gets you the exact same issue.

>
> --
> Cheers,
>
> David

Cheers, Lorenzo
