Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6007722CBE6;
	Tue, 14 Apr 2026 18:57:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776193061; cv=none; b=BxaDYL7QC9HdZb8+a84TzhHdkPD/23sb//5Uj5hkAJYCKTfObAx1WNLvrIvp6pTkwM7noqvNQSSIkNgLv1bbIRIcGSQ7lrSGF3sp86ELRyRLZSV9xaLa+Me/mSFCXfFBnM1aQmaQLwMxGLn1/5EukPlXEFI4/oP9Wevxtu2FWnw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776193061; c=relaxed/simple;
	bh=T2DCwUmeF2CDRJ9rvfowj2ye8B+9fWEseli+RqYR8Ck=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=UH/rc0KgiGbA5BjJHijneJcx6Wq4vgpj8HC7+rY4otWH7zl0xcv2P1jR9lK0DNpQD7tjPDcRUsdwqhxbhTsUEJrRNR5Iu5gL1+m9klbpmBYUUaHkV7C8OhGVL+6shs9ZtWDUIrt96sLbsU5EgcvClLJZyllyhcS9ldUrzHYWLJU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=tgTHDMu1; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="tgTHDMu1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0F1E4C19425;
	Tue, 14 Apr 2026 18:57:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1776193061;
	bh=T2DCwUmeF2CDRJ9rvfowj2ye8B+9fWEseli+RqYR8Ck=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=tgTHDMu1ob/fUsM452dCCPhCVPQgXUQ0iupKsKXWUn+JDLf1djqq489v5ivCtzh52
	 kFqgz4KysGyg5yGxRR+Mr8hlcpOUlV0tPcEiU/SV+qgbRQhLaWFIfCZVSJh8/We3F1
	 OZaYNDX3fCsUQggWNhIi3VcTHQtDLyXGN4tfDAXI+tQZS4Kp+SIfC1lDvEeaSLYagI
	 hJtvZI73Yz07UfEWVLDdZcKRKrqGDb6k64vuVJNEuywpa4Q45tZJe2MygR+g9X8lIO
	 CyDbgnYZEDr2mXdOMPcA81ADxLVHK3EjIUwrOAWumh6zd54de48ww2uRGpwr4iXO5E
	 /CtTodyYMyrsQ==
Date: Tue, 14 Apr 2026 11:57:40 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: John Groves <John@groves.net>
Cc: Miklos Szeredi <miklos@szeredi.hu>,
	Joanne Koong <joannelkoong@gmail.com>,
	Bernd Schubert <bernd@bsbernd.com>,
	John Groves <john@jagalactic.com>,
	Dan Williams <dan.j.williams@intel.com>,
	Bernd Schubert <bschubert@ddn.com>,
	Alison Schofield <alison.schofield@intel.com>,
	John Groves <jgroves@micron.com>, Jonathan Corbet <corbet@lwn.net>,
	Shuah Khan <skhan@linuxfoundation.org>,
	Vishal Verma <vishal.l.verma@intel.com>,
	Dave Jiang <dave.jiang@intel.com>,
	Matthew Wilcox <willy@infradead.org>, Jan Kara <jack@suse.cz>,
	Alexander Viro <viro@zeniv.linux.org.uk>,
	David Hildenbrand <david@kernel.org>,
	Christian Brauner <brauner@kernel.org>,
	Randy Dunlap <rdunlap@infradead.org>,
	Jeff Layton <jlayton@kernel.org>,
	Amir Goldstein <amir73il@gmail.com>,
	Jonathan Cameron <Jonathan.Cameron@huawei.com>,
	Stefan Hajnoczi <shajnocz@redhat.com>,
	Josef Bacik <josef@toxicpanda.com>,
	Bagas Sanjaya <bagasdotme@gmail.com>,
	Chen Linxuan <chenlinxuan@uniontech.com>,
	James Morse <james.morse@arm.com>, Fuad Tabba <tabba@google.com>,
	Sean Christopherson <seanjc@google.com>,
	Shivank Garg <shivankg@amd.com>,
	Ackerley Tng <ackerleytng@google.com>,
	Gregory Price <gourry@gourry.net>,
	Aravind Ramesh <arramesh@micron.com>,
	Ajay Joshi <ajayjoshi@micron.com>,
	"venkataravis@micron.com" <venkataravis@micron.com>,
	"linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"nvdimm@lists.linux.dev" <nvdimm@lists.linux.dev>,
	"linux-cxl@vger.kernel.org" <linux-cxl@vger.kernel.org>,
	"linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
	djbw@kernel.org
Subject: Re: [PATCH V10 00/10] famfs: port into fuse
Message-ID: <20260414185740.GA604658@frogsfrogsfrogs>
References: <20260331123702.35052-1-john@jagalactic.com>
 <0100019d43e5f632-f5862a3e-361c-4b54-a9a6-96c242a8f17a-000000@email.amazonses.com>
 <CAJnrk1ZRTGWjNzkMxS3UkeZMmrpadJDtWKontMx2=d-smXYq=w@mail.gmail.com>
 <adkDq0m5Wt9YhJ8A@groves.net>
 <38744253-efa3-41c5-a491-b177a4a4c835@bsbernd.com>
 <adlBcwJjLOQDAR65@groves.net>
 <CAJnrk1a06zkUmXW5EFiUmgAoFauwtzsYvnotaPH0ifVtyh7iDQ@mail.gmail.com>
 <CAJfpegvVTcV89=q3L326aGQjhduBcv7PVg5QKftGLjNZmCLmaw@mail.gmail.com>
 <ad4_jFsR951c2Mtn@groves.net>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ad4_jFsR951c2Mtn@groves.net>

On Tue, Apr 14, 2026 at 08:41:42AM -0500, John Groves wrote:
> On 26/04/14 03:19PM, Miklos Szeredi wrote:
> > On Fri, 10 Apr 2026 at 21:44, Joanne Koong <joannelkoong@gmail.com> wrote:
> > 
> > > Overall, my intention with bringing this up is just to make sure we're
> > > at least aware of this alternative before anything is merged and
> > > permanent. If Miklos and you think we should land this series, then
> > > I'm on board with that.
> > 
> > TBH, I'd prefer not to add the famfs specific mapping interface if not
> > absolutely necessary.  This was the main sticking point originally,
> > but there seemed to be no better alternative.
> > 
> > However with the bpf approach this would be gone, which is great.

Well... you can't get away with having *no* mapping interface at all.
You still have to define a UABI that BPF programs can use to convey
mapping data into fsdax/iomap.  BTF is a nice piece of work that smooths
over minor fluctuations in struct layout between a running kernel and
a precompiled BPF program, but fundamentally we still need a fuse-native
representation.

That last sentence was an indirect way of saying: No, we're not going
to export struct iomap to userspace.  The fuse-iomap patchset provides
all the UABI pieces we need for regular filesystems (ext4) and hardware
adjacent filesystems (famfs) to exchange file mapping data with the
kernel.  This has been out for review since last October, but the lack
of engagement with that patchset (or its February resubmission) doesn't
leave me with confidence that any of it is going anywhere.

Note: The reason for bolting BPF atop fuse-iomap is so that famfs can
upload bpf programs to generate interleaved mappings.  It's not so hard
to convert famfs' iomapping paths to use fuse-iomap, but I haven't
helped him do that because:

a) I have no idea what Miklos' thoughts are about merging any of the
famfs stuff.

b) I also have no idea what his thoughts are about fuse-iomap.  The
sparse replies are not encouraging.

c) It didn't seem fair to John to make him take on a whole new patchset
dependency given (a) and (b).

d) Nobody ever replied to my reply to the LSFMM thread about "can we do
some code review of fuse iomap without waiting three months for LSFMM?"
I've literally done nothing with fuse-iomap for two of the three months
requested.

> > So let us please at least have a try at this. I'm not into bpf yet,
> > but willing to learn.

I sent out the patches to enable exactly this sort of experimentation
two months ago, and have not received any responses:

https://lore.kernel.org/linux-fsdevel/177188736765.3938194.6770791688236041940.stgit@frogsfrogsfrogs/

I would like to say this as gently as possible: I don't know what the
problem here is, Miklos -- are you uninterested in the work?  Do you
have too many other things to do inside RH that you can't talk about?
Is it too difficult to figure out how the iomap stuff fits into the rest
of the fuse codebase?  Do you need help from the rest of us to get
reviews done?  Is there something else with which I could help?

Because ... over the past few years, many of my team's filesystem
projects have endured monthslong review cycles and often fail to get
merged.  This has led to burnout and frustration among my teammates such
that many of them chose to move on to other things.  For the remaining
people, it was very difficult to justify continuing headcount when
progress on projects is so slow that individuals cannot achieve even one
milestone per quarter on any project.

There's now nobody left here but me.

I'm not blaming you (Miklos) for any of this, but that is the current
deplorable state of things.

> > Thanks,
> > Miklos
> 
> Thanks for responding...
> 
> My short response: Noooooooooo!!!!!!
> 
> I very strongly object to making this a prerequisite to merging. This
> is an untested idea that will certainly delay us by at least a couple
> of merge windows when products are shipping now, and the existing approach
> has been in circulation for a long time. It is TOO LATE!!!!!!

/me notes that has "we're shipping so you have to merge it over peoples'
concerns" rarely carries the day in LKML land, and has never ended well
in the few cases that it happens.  As Ted is fond of saying, this is a
team sport, not an individual effort.  Unfortunately, to abuse your
sports metaphor, we all play for the ******* A's.

That said, you're clearly pissed at the goalposts changing yet again,
and that's really not fair that we collectively keep moving them.

It's a rotten situation that I could have even helped you to solve both
our problems via fuse-iomap, but I just couldn't motivate myself to
entwine our two projects until the technical direction questions got
answered.

> Famfs is not a science project, it's enablement for actual products and
> early versions are available now!!!
> 
> That doesn't mean we couldn't convert later IF THERE ARE NO HIDDEN PROBLEMS.

Heck, the fuse command field is a u32.  There are plenty of numberspace
left, and the kernel can just *stop issuing them*.

> What are the risks of converting to BPF?
> 
> - I don't know how to do it - so it'll be slow (kinda like my fuse learning
>   curve cost about a year because this is not that similar to anything
>   else that was already in fuse.

...and per above, BPF isn't some magic savior that avoids the expansion
of the UABI.

> - Those of us who are involved don't fully understand either the security
>   or performance implications of this. It 

Correct.  I sure think it's swell that people can inject IR programs
that jit/link into the kernel.  Don't ask which secondary connotation of
"swell" I'm talking about.

> - Famfs is enabling access to memory and mapping fault handling must be
>   at "memory speed". We know that BPF walks some data structures when a 
>   program executes. That exposes us to additional serialized L3 cache 
>   misses each time we service a mapping fault (any TLB & page table miss).
>   This should be studied side-by-side with the existing approach under
>   multiple loads before being adopted for production.

Yes, it should.  AFAICT if one switched to a per-inode bpf program, then
you could do per-inode bpf programs.  Then you don't even need the bpf
map, and the ->iomap_begin becomes an indirect call into JITted x86_64
math code.

(The downside is that dyn code can't be meaningfully signed, requires
clang on the system, and you have to deal with inode eviction issues.)

> - This has never been done in production, and we're throwing it in the way
>   of a project that has been soaking for years and needs to support early
>   shipments of products.

Correct.  I haven't even implemented BPF-iomap for fuse4fs.  This BPF
integration stuff is *highly* experimental code.

> If this is the only path, I'd like to revive famfs as a standalone file
> system. I'm still maintaining that and it's still in use.

Honestly, you should probably just ship that to your users.  As long as
the ondisk format doesn't change much, switching the implementation at a
later date is at least still possible.

--D
