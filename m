Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792892334;
	b=aaSysrFrcJpYgTsD9ziFlVJMj9DAbD5aTGHa1dvAWRdtdCuzi5iSQ6dBS8U1XQBSp17i
	 l0LSkgp+159LYddLNwtmvHx50Vz55qPgD7sYMZCESRNPl2iaI+xrL1Bv4/3aQtC+EG/TY
	 KThtu+3zU1tZjbSEw0aHI1h6eLmdPLs2rt1Pffhwv9PC/toVFD0bQjp+ftglzPeEst2/P
	 HU8FvC2Gckm/zq3gcePxu7Mt64MDhHwux/mzw6viXMR+/L0EdIVqJRiGdQEpGpk+/Ftiq
	 xdQuow9gZm7ioFY/lxkqe90eCvpey6spNo0eRIwcIvv2ySwLw69nPmU507nYXFFk6mQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792892334;
	h=Received:DKIM-Signature:Date:From:To:Cc:Subject:Message-Id:
	 In-Reply-To:References:X-Mailer:Mime-Version:Content-Type:
	 Content-Transfer-Encoding;
	bh=Kj9d3feJvTjeYV4Da2OC673rnOJy04TyWVBM+KtMPWk=;
	b=0DGoOLu9cZ5/LoHIaLp/xc3GV1jolhAMBuxBf1q6L/ZU+zjUKVKxOeiLJ0F8e80cRcEs
	 5dZ3Sz+UemNhL3BUTXaEKkpllRPRxKvg5Ybin9LIawqdmt+k5/xxVXOCN6s6C6ip4alsU
	 hxqzz9asxPWKLn2kw2IYric/w07Rusy2AayeVr4aqFGKpLolRSnzF5WGTUF28gELz4e5m
	 0dRY+opEXObCn2e2n2Q2cyNBakmgcuRYsPB0oiVhaWJGUdQLuqWz7oJZic+W5tCmncnXS
	 hTbhM/zob+vAJeMvsMP7zwSl5w41V1l2Tj+UQwGNBpnf9Hyq39otP7QnT2Fb79hYMgQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=YNVDvNgJ;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 68B0D606A31D;
	Sun, 25 Oct 2026 01:38:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=YNVDvNgJ
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BA9231F01829;
	Sun, 25 Oct 2026 01:38:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1792892334;
	bh=Kj9d3feJvTjeYV4Da2OC673rnOJy04TyWVBM+KtMPWk=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=YNVDvNgJxI0FF/BqKiZwqSeHSQ1fC5seH7RfoRjO3KoztATPsQWrcjD0Mt21L6XQQ
	 RtmvXdg14N5CP49xOTr42Z/RI/ZgABVV3DjCb7EuwsKh5ZH3BWOV+lT9HQeqjfrSoB
	 eTdqZjhaqgCoMaQWwYHQHs2iBF2Mvd0Gld+g5HAg=
Date: Sat, 24 Oct 2026 18:38:53 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Muchun Song <songmuchun@bytedance.com>
Cc: Dan Williams <djbw@kernel.org>, Vishal Verma <vishal.l.verma@intel.com>,
 Dave Jiang <dave.jiang@intel.com>, Alison Schofield
 <alison.schofield@intel.com>, Joao Martins <joao.m.martins@oracle.com>,
 nvdimm@lists.linux.dev, linux-cxl@vger.kernel.org,
 linux-kernel@vger.kernel.org, stable@vger.kernel.org, Muchun Song
 <muchun.song@linux.dev>, Ritesh Harjani (IBM) <ritesh.list@gmail.com>
Subject: Re: [PATCH v5] dax/bus: Fix Device DAX range alignment validation
Message-Id: <20261024183853.6803ce81788636e94d8c16a4@linux-foundation.org>
In-Reply-To: <20261024112555.2476001-1-songmuchun@bytedance.com>
References: <20261024112555.2476001-1-songmuchun@bytedance.com>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Post: <mailto:nvdimm@lists.linux.dev>
List-Help: <mailto:nvdimm+help@lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
List-Owner: <mailto:nvdimm+owner@lists.linux.dev>
Precedence: list
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Sat, 24 Oct 2026 19:25:55 +0800 Muchun Song <songmuchun@bytedance.com> wrote:

> Only range sizes are currently validated against dev_dax->align. A
> dynamic device can therefore select a large-page alignment and allocate a
> range whose start is not naturally aligned.
> 
> Sashiko found that memmap_init_zone_device() could then initialize the
> struct pages with a large-page order for a physical range that is not
> naturally aligned. A subsequent write to a userspace mapping then
> triggered a kernel panic in testing.
> 
> The automatic resize path can also split a size-aligned request across
> arbitrary free gaps. When devices with different alignments fragment a
> region, this can extend a range by less than the device alignment. A later
> allocation then fails, leaving the failed resize partially applied.
> 
> Initialize the device alignment before its first allocation. Validate both
> the start and size of allocated and adjusted ranges. Use the same
> aligned-gap iterator for free-space accounting and range allocation so the
> pre-check and allocation path cannot diverge. Skip unusable gaps and
> serialize size validation with alignment updates.
> 
> Static Device DAX already has a pre-populated pgmap whose full range was
> validated against memremap_compat_align(). Its usable data range may begin
> after namespace metadata, so require only dev_dax->align for static
> devices. Dynamic Device DAX builds its pgmap from the allocated ranges and
> must continue to satisfy both alignments.

Thanks.  This is now a must-have for 7.4.

I suggest that the changelog mention that the bug becomes hittable once
your series "mm: Unify device DAX and HugeTLB vmemmap population paths"
exposes it.  That's 

4b77739fe789 ("mm/sparse-vmemmap: drop VMEMMAP_POPULATE_DAX").

I intend to send this to Linus next week.

Maybe also a Fixes: 4b77739fe789.  That series didn't create the bug,
but this data provides notification to people who are backporting this
series (unlikely) "hey, you need to add this fix as well".

Also
Reported-by: Ritesh Harjani (IBM) <ritesh.list@gmail.com>
Closes: https://lore.kernel.org/wlrkqqvg.ritesh.list@gmail.com

I don't believe that Ritesh has tested this?  He wasn't cc'ed...


