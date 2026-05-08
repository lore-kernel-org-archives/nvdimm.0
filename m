Received: from flow-b2-smtp.messagingengine.com (flow-b2-smtp.messagingengine.com [202.12.124.137])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9D3181891A9
	for <nvdimm@lists.linux.dev>; Fri,  8 May 2026 01:09:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=202.12.124.137
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778202572; cv=none; b=A797JbNo/VZUMm58YAWK3QYnq4hJuGS3oRDkmkFiC080d2ZVoZUbN99LfG6emfXICEdHW6pOZEwMkSwZuwkfNOE7Nc2bP9GoQR4qqC3VDEUoq2v1mDZv9/t+zHvGxElsn/pA6ILkrC0PXVJiipM5tcG11ZrFf0B4nAo1sZDdNDA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778202572; c=relaxed/simple;
	bh=SsRwpVm4j9QY9NKLdsuljSWmsrJgGrE8xtzLmYtVlCE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=U7zKEWVjN1zRYXbNlVTzS1KMOUwg+Gf63bqVAiEQgCcYDc2DHzufXNzoZWJohlpMrKTojo2NZLhE/hGmeLxcct7nD82T+Di1NiiQth+kzvMama1ETPlDRJ8ZvPT6JfiLUElnXYWeY1fSh4tiZ+nYmUxvDulu+t8sXUIweWHq4sA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=fastmail.com; spf=pass smtp.mailfrom=fastmail.com; dkim=pass (2048-bit key) header.d=fastmail.com header.i=@fastmail.com header.b=isV+Y6eF; dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b=cCEsZfvp; arc=none smtp.client-ip=202.12.124.137
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=fastmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fastmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fastmail.com header.i=@fastmail.com header.b="isV+Y6eF";
	dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b="cCEsZfvp"
Received: from phl-compute-11.internal (phl-compute-11.internal [10.202.2.51])
	by mailflow.stl.internal (Postfix) with ESMTP id 2562513005A4;
	Thu,  7 May 2026 21:09:29 -0400 (EDT)
Received: from phl-frontend-04 ([10.202.2.163])
  by phl-compute-11.internal (MEProxy); Thu, 07 May 2026 21:09:29 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fastmail.com; h=
	cc:cc:content-type:content-type:date:date:from:from:in-reply-to
	:in-reply-to:message-id:mime-version:references:reply-to:subject
	:subject:to:to; s=fm3; t=1778202568; x=1778206168; bh=GaS7S8sB1N
	BISn4/DuEd/QllRqEGT1kvPc2rO4mML/0=; b=isV+Y6eFSaLuAjXOr7KiymZRPN
	1niBGyUeDvDj+9bbew286FZilRbpri6JkTMN2sh9bhr5Zfc8E5sl9vcOlMgHt7tF
	DWSsGYFYClLRWpluCPXhQhevsYVKZ0NZipoiAXFmdAZJrGHiRZgI1sL56wdAjk1X
	bah86rhMTpibwQXVLr1+p3mTI8QqjIhqHj2pvkP+9UEsirHNAf+Q0pFTKwV1B3mu
	VLqAzd5M3DhKiYLz/DmvjwJdMoUGphfmizV5fn1J7nqlurpyowd7UufujwIPHPpQ
	wAB7nkFP+vcbDAOmQ2R10Vd1De9qHggKKkRbrA/XSGYnoTWD5IyfA/4nFt7g==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-type:content-type:date:date
	:feedback-id:feedback-id:from:from:in-reply-to:in-reply-to
	:message-id:mime-version:references:reply-to:subject:subject:to
	:to:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; t=
	1778202568; x=1778206168; bh=GaS7S8sB1NBISn4/DuEd/QllRqEGT1kvPc2
	rO4mML/0=; b=cCEsZfvpHC95Fl4JojRUciqEBstetOyV6lhy3kFFEBnyZezFJ/f
	GZZN1QOnbmRh8l1bGd5gAWmbX0t0rwOeaHqcpSbfH/lIB28Lm8EaNacJfPJ8iwTE
	JS7rM+fs52SIFG+4U/SQshbm/oqhS1GRNGgS3nhTBvcvUuE00XRuYxQ/0//VTn3l
	8li1K3/yzsVJfHsWrxDZ+4H3V4mOyHbogI6QexUIepeNMFdl6VNvBnlWLqcrBqZ7
	weuC7SeAjzKTp/NFRi2rGugR0kSrWKNcnAZu1GIlEsW4xCB1hhItlIfkvQ5zdawV
	WRogFBB7CWyZhP9m2dXq04mDk8j8I2uSGRg==
X-ME-Sender: <xms:yDf9abtiMlZx9UJ8xRvGEcmgVfboLSVOTmOUYrgmjzH80q6qGgLkNQ>
    <xme:yDf9aW0gwa125SPZPEU2JsaQHMgl7GucVzbaFfXcGEh6M1Ne1644XeR8DzWplrAsj
    xC5BzgKIxBIGkW-dGKmmhv8gsIJk62iQjk8UzFedFyEhcIuMhNmUcU>
X-ME-Received: <xmr:yDf9aU5cn5XnIGWVTFZQ8rbrPEy12HG92PwWsBz_xth-W2bM6w8XUYaYcow-vdL4rVHEO0R9hdV9FDgG6aMRDIJT>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeefhedrtddtgddutdekleelucetufdoteggodetrf
    dotffvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfurfetoffkrfgpnffqhgenuceu
    rghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmnecujf
    gurhepfffhvfevuffkfhggtggujgesthdtredttddtvdenucfhrhhomhepkfhrrgcuhggv
    ihhnhicuoehifigvihhnhiesfhgrshhtmhgrihhlrdgtohhmqeenucggtffrrghtthgvrh
    hnpefhvddthedtiedtffejkefhlefghefgtdehgedvheelgedugfeitedvfeekgeeufeen
    ucffohhmrghinhepkhgvrhhnvghlrdhorhhgnecuvehluhhsthgvrhfuihiivgeptdenuc
    frrghrrghmpehmrghilhhfrhhomhepihifvghinhihsehfrghsthhmrghilhdrtghomhdp
    nhgspghrtghpthhtohepudehpdhmohguvgepshhmthhpohhuthdprhgtphhtthhopegrtg
    hkvghrlhgvhihtnhhgsehgohhoghhlvgdrtghomhdprhgtphhtthhopegurghvvgdrjhhi
    rghnghesihhnthgvlhdrtghomhdprhgtphhtthhopehfvhgulhesghhoohhglhgvrdgtoh
    hmpdhrtghpthhtoheplhhinhhugidqtgiglhesvhhgvghrrdhkvghrnhgvlhdrohhrghdp
    rhgtphhtthhopehnvhguihhmmheslhhishhtshdrlhhinhhugidruggvvhdprhgtphhtth
    hopegujhgsfieskhgvrhhnvghlrdhorhhgpdhrtghpthhtohepihifvghinhihsehkvghr
    nhgvlhdrohhrghdprhgtphhtthhopehprghshhgrrdhtrghtrghshhhinhesshholhgvvg
    hnrdgtohhmpdhrtghpthhtohepmhgtlhgrphhinhhskhhisehgohhoghhlvgdrtghomh
X-ME-Proxy: <xmx:yDf9aVWFF7n4q7iBNRXR3oFd8o9-mLMAK_Lkq5Lxqs_bdu0uWJXUEA>
    <xmx:yDf9aUgoVSVkDWLMD9RLVjpjz1b5VwXJO4Q8UQtVIDKjTqeKBkjltg>
    <xmx:yDf9addJfS2204mbwmnRFFjQrqMy3ddXakddWBDqlgczaeFeCO81Rg>
    <xmx:yDf9ab0Kx9PvI0USFudaIw3dUxdwUHc1kbshKNy4FnfhD_3-HKRatA>
    <xmx:yDf9abLBr8NjILl_D1mt1lDoBihb1zWyaml45oTc9lAJhveoj8JkuRJC>
Feedback-ID: i7ace4b6e:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Thu,
 7 May 2026 21:09:27 -0400 (EDT)
Date: Thu, 7 May 2026 20:09:25 -0500
From: Ira Weiny <iweiny@fastmail.com>
To: Ackerley Tng <ackerleytng@google.com>,
	Dave Jiang <dave.jiang@intel.com>
Cc: fvdl@google.com, linux-cxl@vger.kernel.org, nvdimm@lists.linux.dev,
	djbw@kernel.org, iweiny@kernel.org, pasha.tatashin@soleen.com,
	mclapinski@google.com, rppt@kernel.org, joao.m.martins@oracle.com,
	jic23@kernel.org, gourry@gourry.net, john@groves.net,
	rick.p.edgecombe@intel.com
Subject: Re: [RFC PATCH 00/12] dax: Add DAX to guest memfd support for KVM
Message-ID: <69fd37c5cfa4a_1d1951006d@xwing.notmuch>
References: <0e831045-3b01-4934-bf43-b3ef01ce0158@intel.com>
 <CAEvNRgE3ifAvgVS4bLeNp_eVp0=6b3p+myYEXSfyS+Qrw5mrtw@mail.gmail.com>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAEvNRgE3ifAvgVS4bLeNp_eVp0=6b3p+myYEXSfyS+Qrw5mrtw@mail.gmail.com>

Ackerley Tng wrote:
> Dave Jiang <dave.jiang@intel.com> writes:
> 
> > On 4/24/26 10:13 AM, Frank van der Linden wrote:
> >> Dave Jiang <dave.jiang@intel.com> wrote:

[snip]

> 
> >>> [1]: https://lore.kernel.org/linux-cxl/aeWV1CvP9ImZ3eEG@gourry-fedora-PF4VCD3F/T/#t
> >>
> >> One of the main ideas behind guest_memfd is that the memory is managed
> >> by the kernel only, so it knows what it has and that it can trust
> >> the memory. This RFC passes an fd in via the ioctl(), which I think
> >> breaks that model.
> 
> Yup! One of guest_memfd's core purposes is to be able to block host
> accesses to guest private (in the CoCo sense) memory.
> 
> >
> > Don't we issue KVM_CREATE_GUEST_MEMFD ioctl to get a fd in userspace to be passed to KVM_SET_USER_MEMORY_REGION2 ioctl later? We are just passing in a DAX fd instead of a guest mem fd.
> >
> 
> This RFC is passing a DAX fd instead of a guest_memfd when creating a
> memslot, so it's not really using guest_memfd, it's just reusing the
> functions that were first created for guest_memfd to support another
> kind of fd.
> 
> What's the use case you're shooting for? Why not mmap() from the DAX
> fd and then pass the userspace address to KVM when setting up a memslot?
> 
> Is there a requirement to have the DAX memory usable by CoCo guests as
> well, and hence requiring guest_memfd-style protection from host
> accesses for private DAX memory?
> 

I was thinking this would be an eventual use case for DAX/CXL memory yes.

There are a couple of issues with mmaping DAX.

1) DAX is getting a bit long in the tooth.  It may be that users are fine
   with it and it should stick around but there are some who worry that it
   is too deviated from the memfd/gmemfd style of management.

2) What you propose above does not give the gmem 'protection' for CoCo's.
   So yea that is the bigger issue.

Allowing gmem to use DAX/CXL as a backend within the kernel is where I
think this is headed.  But having the gmem fd be allocated with that
backend would need to have more knobs in gmem.  Also I believe there may
be use cases where a _specific_ CXL device is desired.  That case makes
the knobs required more complicated.

What Dave has done here gives the device information via the dax fd.  It
is kind of clunky but it works...

Ira

[snip]
