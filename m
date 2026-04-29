Received: from flow-b3-smtp.messagingengine.com (flow-b3-smtp.messagingengine.com [202.12.124.138])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 84E233FCB11
	for <nvdimm@lists.linux.dev>; Wed, 29 Apr 2026 13:21:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=202.12.124.138
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777468866; cv=none; b=ewA3RdUlueNrVOdHRjyUX/UkwjR03gge3hXBwaX845sNsbhWljoB3xSzcYkqEIMfzJepynPz9i6FpaUrPlyIDkPhAdMrncOwNoRiGQg3RtovVJUi6GGChOXc+v0zqCwEhnXCv0FA4vuaalD9dWQn7S6NgQqSai8NItdRgbf7Qtg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777468866; c=relaxed/simple;
	bh=pzJ/qG10b1lCwB/0UOW/lcCQO56z/awJcxiZVRpdSdA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=BRszRe9ndqCKajFRWuXP1dlji+1TYk/RctoTAFseWhVtX4vfUfE48uo/jPvP0Uzk2/zydkX1424YWtydphQHuGzU0qDbUHav+qOLu0pKoBUt/AKUrIq2qnfp+4UpTfuLZ8+oJioY2Fpro/d+ZWKf/1mYfCkPajAnXmxp00Nlc0s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=fastmail.com; spf=pass smtp.mailfrom=fastmail.com; dkim=pass (2048-bit key) header.d=fastmail.com header.i=@fastmail.com header.b=kKLI4qoq; dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b=KTPOY0eL; arc=none smtp.client-ip=202.12.124.138
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=fastmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fastmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fastmail.com header.i=@fastmail.com header.b="kKLI4qoq";
	dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b="KTPOY0eL"
Received: from phl-compute-01.internal (phl-compute-01.internal [10.202.2.41])
	by mailflow.stl.internal (Postfix) with ESMTP id 544F01300376;
	Wed, 29 Apr 2026 09:21:03 -0400 (EDT)
Received: from phl-frontend-03 ([10.202.2.162])
  by phl-compute-01.internal (MEProxy); Wed, 29 Apr 2026 09:21:03 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fastmail.com; h=
	cc:cc:content-type:content-type:date:date:from:from:in-reply-to
	:in-reply-to:message-id:mime-version:references:reply-to:subject
	:subject:to:to; s=fm2; t=1777468863; x=1777472463; bh=P8NC0IrWWB
	TtdfFvxUWf/RfJn/4nc1gz9nUb703qgPw=; b=kKLI4qoq6J16nElcAFahftSiCL
	WValQP36YI4vEANAztB3N1w0Zn6Zvri7L5SWWOpj38I+QMBjE2qFwKSwhNncAvbO
	rCLwlXDPbmjGLJBxLuLeL7x18QnkQ0dxZA93vu0J4MtHGTjzMhIeihygWwE7XUr6
	fAwoq0CyfUqVQuoEHrE6VSu5kQ2IDFNOIhjLAdgSLATHKCjRbYYmVW2f7qepnTcY
	Ybm9bw7PJgfr5Ou00Xn66CJfsL5WW9b1A5XWXyJX4BGIAYAFlC7FYECFUaXJLVkz
	odKj3nFqnJc7k2WSbJ/wnb2xbwvONDImmmwFFDNcBfgCqjZ6DbJQmpf1q3Qw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-type:content-type:date:date
	:feedback-id:feedback-id:from:from:in-reply-to:in-reply-to
	:message-id:mime-version:references:reply-to:subject:subject:to
	:to:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; t=
	1777468863; x=1777472463; bh=P8NC0IrWWBTtdfFvxUWf/RfJn/4nc1gz9nU
	b703qgPw=; b=KTPOY0eLAbWmc6iTWrVv4hvd73q14JlKSxObjV0qFLxFHPTOoEZ
	a5YPHAxlL66YPXjptSwFmrbNweEs0zt6slshzWlLVYdQZMIDHOXefGJJ2ErmOrkj
	/0nspvnFRHuKkavhmsD6sVNLCY/I9OvTABx3eRlTRYwJIsSKJoUJmcV5g06auDrn
	9t5ARld+f/8wdv2sq+OJsTaUbSBcDf+Dg0KXniOFvCfmNYk08R5PSq+zb0rvtEV5
	5Yb1/pvkt/avBobvqGk2Fta4QZu+Bp7KodZR9bVj/dXwQbL0SZEek0txH/LPeSZK
	ngJVRBG+1RLgv6UsYGhywDwYd7xd63CGUqw==
X-ME-Sender: <xms:vgXyadjYJ56Kntoukak2lGkVk8sHj3nCGnLTdoe5jAWSeR_0pS9kGg>
    <xme:vgXyaYgDV8C0Zw3BgE7-9gt8Irbrh5ZnGp1Vb5pwhd-_UVwaTVFDwcENsOGbYw0ES
    94qSPJ-yjHHWQX_DWOBVFoZ3KNkZkdCUPgDhVSxPN0QRHcFvgXlKKv7>
X-ME-Received: <xmr:vgXyabG7gty04k6jkFxEx3weFnLEr-ihl-iz4vVlmVFdBXlPHmvHnOKy_wheMHqHi5_ug2nsEs5StQx3GzGJjFFb>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeefhedrtddtgdekgeehgecutefuodetggdotefrod
    ftvfcurfhrohhfihhlvgemucfhrghsthforghilhdpuffrtefokffrpgfnqfghnecuuegr
    ihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmdenucfjug
    hrpeffhffvvefukfhfgggtuggjsehttdertddttddvnecuhfhrohhmpefkrhgrucghvghi
    nhihuceoihifvghinhihsehfrghsthhmrghilhdrtghomheqnecuggftrfgrthhtvghrnh
    epueeitddvteehvdfgffejfeeuieehtdeftddtffdtjeefueeghfduffeutdehuedtnecu
    vehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpehmrghilhhfrhhomhepihifvghinh
    ihsehfrghsthhmrghilhdrtghomhdpnhgspghrtghpthhtohepudefpdhmohguvgepshhm
    thhpohhuthdprhgtphhtthhopehgohhurhhrhiesghhouhhrrhihrdhnvghtpdhrtghpth
    htohepuggrvhgvrdhjihgrnhhgsehinhhtvghlrdgtohhmpdhrtghpthhtoheplhhinhhu
    gidqtgiglhesvhhgvghrrdhkvghrnhgvlhdrohhrghdprhgtphhtthhopehnvhguihhmmh
    eslhhishhtshdrlhhinhhugidruggvvhdprhgtphhtthhopegujhgsfieskhgvrhhnvghl
    rdhorhhgpdhrtghpthhtohepihifvghinhihsehkvghrnhgvlhdrohhrghdprhgtphhtth
    hopehprghshhgrrdhtrghtrghshhhinhesshholhgvvghnrdgtohhmpdhrtghpthhtohep
    mhgtlhgrphhinhhskhhisehgohhoghhlvgdrtghomhdprhgtphhtthhopehrphhptheskh
    gvrhhnvghlrdhorhhg
X-ME-Proxy: <xmx:vgXyaVA8Ies_Urc8ubeb_wT1o-58P_QMCMhlxbQ9GMZ_Gh2vVWbs9A>
    <xmx:vgXyaRBxBG1n0bpqg3T7WoVEukUJlRUurPgUdd4wA3N7yEgpaVxTiw>
    <xmx:vgXyaTN3_iA8kYpmZ8VkAoYxKQSnivA8YPeYzdb8g7jC4k5vq12ZyQ>
    <xmx:vgXyaVPg649rVggQTUkTB6vja6orT0g0tv9gKozeoUUhQ4nYi9PBfQ>
    <xmx:vwXyackVLNN1Vx7vz4KcxKl6i48Jq05tzNmU8s_UM_PFFclShjhy-7V9>
Feedback-ID: i7ace4b6e:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Wed,
 29 Apr 2026 09:21:01 -0400 (EDT)
Date: Wed, 29 Apr 2026 08:21:00 -0500
From: Ira Weiny <iweiny@fastmail.com>
To: Gregory Price <gourry@gourry.net>, Dave Jiang <dave.jiang@intel.com>
Cc: linux-cxl@vger.kernel.org, nvdimm@lists.linux.dev, djbw@kernel.org,
	iweiny@kernel.org, pasha.tatashin@soleen.com, mclapinski@google.com,
	rppt@kernel.org, joao.m.martins@oracle.com, jic23@kernel.org,
	john@groves.net, rick.p.edgecombe@intel.com
Subject: Re: [RFC PATCH 00/12] dax: Add DAX to guest memfd support for KVM
Message-ID: <69f205bc6402_3a7a81004d@xwing.notmuch>
References: <20260423170219.281618-1-dave.jiang@intel.com>
 <aerm4yDVYpOhxXEF@gourry-fedora-PF4VCD3F>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aerm4yDVYpOhxXEF@gourry-fedora-PF4VCD3F>

Gregory Price wrote:
> On Thu, Apr 23, 2026 at 10:02:07AM -0700, Dave Jiang wrote:
> > This RFC series is created as a proof of concept to connect device DAX to guest
> > memory by riding on top of guest memfd in order to prove out that device DAX
> > can be used as guest memory. The series seeks to jump start a discussion on
> > if there are interests in creating a DAX bridge to utilize CXL memory for guest
> > memory until the N_PRIVATE implementation by Gregory [1] is available upstream
> > and DAX users are ready to move to the new scheme. Once there's an established
> > consensus of interest, we can move the discussion to the best way to implement
> > the DAX bridge and the future of device DAX as guest.
> >
> > I did the bare minimal to get the PoC to pass a modified version of KVM gmem
> > selftest (guest_memfd_test) in order to prove out that DAX can go in the gmem
> > path. A DAX char dev is created and the fd is passed in user space with
> > vm_set_user_memory_region2(). The DAX region is passed in as a whole when used
> > unlike memfd where any size can be passed in to be allocated.
> > 
> > The folks on the cc line are people that Dan Williams has mentioned that may be
> > of interest to this.
> 
> I see these as *mildly* orthogonal, but I think maybe you should propose
> a discussion at LSF to talk about this.

Sorry I was a bit delayed on this thread due to some email issues.

Yes this should be talked about at LSF if possible.  But I also think this
is something which is a ways off based on the responses we have seen here.

> 
> guest_memfd in particular wants the host to never map the memory - and
> guests *generally* want 1GB huge page support (TLB go brrrrr).

That is _not_ going to be true forever.  There is work ongoing to create
shared gmem for various reasons.  For secure guests this is at least
useful for initial population of memory before handing to a guest.

> 
> There's a real argument for just handing a physical memory region over
> to guest_memfd and making it manage the region manually, rather than
> doing a bunch of nonsense just so you can call alloc_pages_node()

Agreed.

> 
> So I see an extension like this as genuinely useful regardless of
> whether private nodes actually end up merged.  It's a matter of
> flexibility and use cases.

Yep, the initial talks we had with Dan were to try and get DAX FDs to be
more mainstream.  Given some of the other work it may be better to
deprecate DAX FDs.  But deprecations can take a long time so what Dave
came up with here is trying to help modernize those fds to be more useful
for guest computing.

Also depending on existing use cases this may be easier for folks to
adopt?  But it may have more rough edges than it is worth?

> 
> With this plumbing, you get less flexible use of the memory (you're tied
> to dax abstractions), whereas with private nodes you can build slightly
> more flexible general-system support.
> 
> IN THEORY you could add something like an NP_OP_NOMAP to private nodes
> to make the buddy manage pages that don't have a direct map - BUT - in
> practice that's likely to be more of a bodge rather than a good design.
> 
> So I will say - to the detriment of private nodes ;] - I like this idea.

I've investigated using private nodes as a mechanism for guest_memfd to
draw from.  I think this is along the lines of what Frank mentioned
elsewhere in this thread.

> 
> The question is ultimately how much flexibility you need to shuffle this
> capacity from one guest to another.

Yep.  And how much control one needs over which exact CXL/DAX devices the
memory comes from.  As you know from our community calls that is one thing
I'm not sure the private node idea is great at.  But it could be that is
not really required.  Or is best handled as a carve out.

Ira
