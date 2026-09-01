Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A5EC8459AEE;
	Tue,  1 Sep 2026 20:51:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788295910; cv=none; b=U9CDg4Jx0yF45uPDVBCASz1ibZahknBEuRkkVtQs2OG56AqQh2CHpFw9mgs4LQgBIDKDPwMQ+ImIktr48g51stD0OSnRDa0Hqk7xgLxaNCfa0zdl1MabG5ja8zPkPEekWM40K8hht3t2vTdTRL5MwSxa3MlZf4NN6EuZVYOI8UI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788295910; c=relaxed/simple;
	bh=DB/AMlfy2yKH8hXtWGrGiG2dLENJRIIMYTQVFbknl+A=;
	h=Date:From:To:Cc:Subject:Message-Id:In-Reply-To:References:
	 Mime-Version:Content-Type; b=K8JSovO6lkgfU4HC5ucclIc7Z0fo0voddc+84NeohnZRJDlUY3lHoNqGLNo0zW/OR+xVxP6CPcdjlx9XEQhwCsggtA+fjcNiVDRH/irUKED/o9Gs5cR7L8EFSzJxyDBM4I5Uhn6JBf+GSCgDV5D0/iS20yODhnAVDnC/kYrhSE8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=D4e1u0m7; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="D4e1u0m7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C34A31F000E9;
	Tue,  1 Sep 2026 20:51:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1788295909;
	bh=24yofMVlvAnQcKXXccDiWXnrggrsYS1Pgj1ApyJFv0Q=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=D4e1u0m71TNgOJpoqNqHJcMg5RYmJcMUttQpJj6OSfdWrx3uJxQtosAlLcKlyqIUr
	 7ZR6WtKBPtu4HgNmCId7yyFS4jZoDI+rp1K92xu9rE5n0/tJF71ame6O2SP0W4OjeK
	 SmPigpCS+3QPr2j6ivL0KBjmHbezfbjK8wr3Zscc=
Date: Tue, 1 Sep 2026 13:51:48 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Kiara Grouwstra <cinereal@riseup.net>
Cc: Dan Williams <djbw@kernel.org>, Christian Brauner <brauner@kernel.org>,
 Alexander Viro <viro@zeniv.linux.org.uk>, Alistair Popple
 <apopple@nvidia.com>, David Hildenbrand <david@kernel.org>, Jan Kara
 <jack@suse.cz>, Matthew Wilcox <willy@infradead.org>,
 linux-fsdevel@vger.kernel.org, nvdimm@lists.linux.dev,
 linux-kernel@vger.kernel.org, Seunguk Shin <seunguk.shin@arm.com>
Subject: Re: [PATCH] fs/dax: get the folio of an entry only after the entry
 has one
Message-Id: <20260901135148.3f43c87fda6515a34541648e@linux-foundation.org>
In-Reply-To: <20260901195658.4027962-1-cinereal@riseup.net>
References: <20260901195658.4027962-1-cinereal@riseup.net>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Tue,  1 Sep 2026 21:56:58 +0200 Kiara Grouwstra <cinereal@riseup.net> wrote:

> dax_associate_entry(), dax_disassociate_entry() and dax_busy_page() each
> compute dax_to_folio(entry) in the declaration, one statement before the
> test that returns early when the entry is a zero entry or an empty entry.
> An empty entry holds no pfn, so dax_to_folio() reads vmemmap[0].
> 
> Where the memory map starts at pfn 0 this reads a struct page that exists,
> the value is discarded, and nothing shows. Where the lowest present section
> is above pfn 0 there is no struct page for pfn 0 and the read faults.
> grab_mapping_entry() gives the first fault on a file an empty entry, so on
> such a machine every first DAX fault on a file ends in:
> 
>   BUG: unable to handle page fault for address: ffffea0000000008
>   RIP: 0010:dax_to_folio+0x14/0x60
>    dax_insert_entry+0xb2/0x3c0
>    dax_fault_iter+0x200/0x600
>    dax_iomap_pte_fault+0x193/0x3d0
> 
> Found on a kernel that boots on one high region of system RAM, which has
> no struct page for the memory below it.
> 
> Move each call after the early return. The other callers of dax_to_folio()
> in this file already only run for an entry that holds a pfn.
> 

Thanks.  This is near-identical to
https://lore.kernel.org/all/m2y0enxtzk.fsf@arm.com/, which I have
queued for 7.3-rcX, with cc:stable.

Seunguk's fix was set a month ago, but balls were dropped :(

