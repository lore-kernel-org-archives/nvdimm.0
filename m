Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8F9303A9D8C;
	Tue, 14 Apr 2026 23:36:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776209792; cv=none; b=dgn4q7a1cZIZF7bySoCpUid4XDA7zpEgYaTGkQa+MewAKV7Myt74HoDOAIgsmlgbG5rSwvLAh0UO9vIJh5uvzN6xFejct8I4qJY17GrV4uFs579P9H1cfJDwEcmj/gftUv87PG+TOwhywUVT1GJpD/oyX5I16Qrn+ymvh2mB/xg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776209792; c=relaxed/simple;
	bh=rxUd7XCmGwYPflWrq4r1HiP5IMAX6d5Du043iI4kRAk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=AcAA0FZZwUzy185F+3RUolzw8RYun4FKyzf7kFpXEnOGn+WcDjy9/8jZwYHqHzCWQHNf7DL+OtaBNjCNIKpL29LexfjVgHiQyWf0H6+piAtkLW31a1f7QCOvG0hdJ3XywzTWkfaKH1b2yl/2iTgVoSc/AAH4y02kE+8FwG902Xo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=MmKEbGBp; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="MmKEbGBp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2D208C19425;
	Tue, 14 Apr 2026 23:36:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1776209792;
	bh=rxUd7XCmGwYPflWrq4r1HiP5IMAX6d5Du043iI4kRAk=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=MmKEbGBpuICpMfpNkpupUnQ/TUm7P4o7xbuiQ3iknW3QlaewRWjHn9aHqeS5LpDaI
	 WMcBAKZ5TANtDWodOYA3yBChkT/NbnWDsYFSDwQ1PPh/JO0My8wug4mlG+wWE5y9wd
	 KpQlLMQFQaBdwPos9RnvIHA2wOg8KtBgSHHZmF2GvsIaPYyQZLSb2b4cAYOiwacoZU
	 Fz+Q9UKPr2wUiydG5FwAeNdlLU/2F3Xea6RuRrCmFkkZOtOIrgOwfD9PL0EZbxVHC4
	 35lxmPtFgSHS93rRz5NYoqUmCN+7ZpHEkWniFeprl1DW5kd/U3nK7Vp14skycUKM/E
	 sy6eGI0Y7wpqw==
Date: Tue, 14 Apr 2026 16:36:31 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Joanne Koong <joannelkoong@gmail.com>
Cc: John Groves <John@groves.net>, Miklos Szeredi <miklos@szeredi.hu>,
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
Message-ID: <20260414233631.GB604658@frogsfrogsfrogs>
References: <0100019d43e5f632-f5862a3e-361c-4b54-a9a6-96c242a8f17a-000000@email.amazonses.com>
 <CAJnrk1ZRTGWjNzkMxS3UkeZMmrpadJDtWKontMx2=d-smXYq=w@mail.gmail.com>
 <adkDq0m5Wt9YhJ8A@groves.net>
 <38744253-efa3-41c5-a491-b177a4a4c835@bsbernd.com>
 <adlBcwJjLOQDAR65@groves.net>
 <CAJnrk1a06zkUmXW5EFiUmgAoFauwtzsYvnotaPH0ifVtyh7iDQ@mail.gmail.com>
 <CAJfpegvVTcV89=q3L326aGQjhduBcv7PVg5QKftGLjNZmCLmaw@mail.gmail.com>
 <ad4_jFsR951c2Mtn@groves.net>
 <20260414185740.GA604658@frogsfrogsfrogs>
 <CAJnrk1ZgcMuwfMpT1fXvUwBBiq9eWFHWVeOFQFFKiamGGe1RJg@mail.gmail.com>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAJnrk1ZgcMuwfMpT1fXvUwBBiq9eWFHWVeOFQFFKiamGGe1RJg@mail.gmail.com>

On Tue, Apr 14, 2026 at 03:13:57PM -0700, Joanne Koong wrote:
> On Tue, Apr 14, 2026 at 11:57 AM Darrick J. Wong <djwong@kernel.org> wrote:
> >
> > On Tue, Apr 14, 2026 at 08:41:42AM -0500, John Groves wrote:
> > > On 26/04/14 03:19PM, Miklos Szeredi wrote:
> > > > On Fri, 10 Apr 2026 at 21:44, Joanne Koong <joannelkoong@gmail.com> wrote:
> > > >
> > > > > Overall, my intention with bringing this up is just to make sure we're
> > > > > at least aware of this alternative before anything is merged and
> > > > > permanent. If Miklos and you think we should land this series, then
> > > > > I'm on board with that.
> > > >
> > > > TBH, I'd prefer not to add the famfs specific mapping interface if not
> > > > absolutely necessary.  This was the main sticking point originally,
> > > > but there seemed to be no better alternative.
> > > >
> > > > However with the bpf approach this would be gone, which is great.
> >
> > Well... you can't get away with having *no* mapping interface at all.
> 
> Yes but the mapping interface should be *generic*, not one that is so
> specifically tailored to one server. fuse will have to support this
> forever.

<nod> On second thought, there's a way to read Miklos' sentence that I
hadn't thought of before:

"However, with the [fuse-iomap] bpf approach, this [famfs specific
mapping interface] would be gone, which is great."

vs. the way I had thought:

"However, with the bpf approach, this [famfs specific mapping interface]
would be gone [in favor of filling out a struct iomap directly], which
is great."

So maybe Miklos actually /has/ at least read all the way through the
February posting, though I have no data to make such a conclusion. :/

> > You still have to define a UABI that BPF programs can use to convey
> > mapping data into fsdax/iomap.  BTF is a nice piece of work that smooths
> > over minor fluctuations in struct layout between a running kernel and
> > a precompiled BPF program, but fundamentally we still need a fuse-native
> > representation.
> >
> > That last sentence was an indirect way of saying: No, we're not going
> > to export struct iomap to userspace.  The fuse-iomap patchset provides
> > all the UABI pieces we need for regular filesystems (ext4) and hardware
> > adjacent filesystems (famfs) to exchange file mapping data with the
> > kernel.  This has been out for review since last October, but the lack
> > of engagement with that patchset (or its February resubmission) doesn't
> > leave me with confidence that any of it is going anywhere.
> >
> > Note: The reason for bolting BPF atop fuse-iomap is so that famfs can
> > upload bpf programs to generate interleaved mappings.  It's not so hard
> > to convert famfs' iomapping paths to use fuse-iomap, but I haven't
> > helped him do that because:
> >
> > a) I have no idea what Miklos' thoughts are about merging any of the
> > famfs stuff.
> >
> > b) I also have no idea what his thoughts are about fuse-iomap.  The
> > sparse replies are not encouraging.
> >
> > c) It didn't seem fair to John to make him take on a whole new patchset
> > dependency given (a) and (b).
> >
> > d) Nobody ever replied to my reply to the LSFMM thread about "can we do
> > some code review of fuse iomap without waiting three months for LSFMM?"
> > I've literally done nothing with fuse-iomap for two of the three months
> > requested.
> >
> > > > So let us please at least have a try at this. I'm not into bpf yet,
> > > > but willing to learn.
> >
> > I sent out the patches to enable exactly this sort of experimentation
> > two months ago, and have not received any responses:
> >
> > https://lore.kernel.org/linux-fsdevel/177188736765.3938194.6770791688236041940.stgit@frogsfrogsfrogs/
> >
> > I would like to say this as gently as possible: I don't know what the
> > problem here is, Miklos -- are you uninterested in the work?  Do you
> > have too many other things to do inside RH that you can't talk about?
> > Is it too difficult to figure out how the iomap stuff fits into the rest
> > of the fuse codebase?  Do you need help from the rest of us to get
> > reviews done?  Is there something else with which I could help?
> >
> > Because ... over the past few years, many of my team's filesystem
> > projects have endured monthslong review cycles and often fail to get
> > merged.  This has led to burnout and frustration among my teammates such
> > that many of them chose to move on to other things.  For the remaining
> > people, it was very difficult to justify continuing headcount when
> > progress on projects is so slow that individuals cannot achieve even one
> > milestone per quarter on any project.
> >
> > There's now nobody left here but me.
> >
> > I'm not blaming you (Miklos) for any of this, but that is the current
> > deplorable state of things.
> >
> > > > Thanks,
> > > > Miklos
> > >
> > > Thanks for responding...
> > >
> > > My short response: Noooooooooo!!!!!!
> > >
> > > I very strongly object to making this a prerequisite to merging. This
> > > is an untested idea that will certainly delay us by at least a couple
> > > of merge windows when products are shipping now, and the existing approach
> > > has been in circulation for a long time. It is TOO LATE!!!!!!
> >
> > /me notes that has "we're shipping so you have to merge it over peoples'
> > concerns" rarely carries the day in LKML land, and has never ended well
> > in the few cases that it happens.  As Ted is fond of saying, this is a
> > team sport, not an individual effort.  Unfortunately, to abuse your
> > sports metaphor, we all play for the ******* A's.
> >
> > That said, you're clearly pissed at the goalposts changing yet again,
> > and that's really not fair that we collectively keep moving them.
> >
> > It's a rotten situation that I could have even helped you to solve both
> > our problems via fuse-iomap, but I just couldn't motivate myself to
> > entwine our two projects until the technical direction questions got
> > answered.
> >
> > > Famfs is not a science project, it's enablement for actual products and
> > > early versions are available now!!!
> > >
> > > That doesn't mean we couldn't convert later IF THERE ARE NO HIDDEN PROBLEMS.
> >
> > Heck, the fuse command field is a u32.  There are plenty of numberspace
> > left, and the kernel can just *stop issuing them*.
> 
> I don't think the problem is the command field. As I understand it, if
> this lands and is converted over later, none of the famfs code in this
> series can be removed from fuse. If fuse has native non-bpf support
> for famfs, then it will always need to have that. That's the part that
> worries me.
> 
> >
> > > What are the risks of converting to BPF?
> 
> I think maybe there is a misinterpretation of what the alternative
> approach entails. From my point of view, the alternative approach is
> not that different from what is already in this series. The only piece
> of the famfs logic that would need to use bpf is the logic for
> finding/computing the extent mappings (which is the famfs-specific
> logic that would not be applicable to any other server). That famfs
> bpf code is minimal and already written [1], as it is just the logic

Remember where struct fuse_iomap_io came from -- the fuse-iomap
patchset.  It would be rather odd to start accepting fuse_iomap_io
objects from a user's bpf program without examining the rest of the fuse
iomap stuff.

> that is in patch 6 [2] in this series copied over. No other part of
> famfs touches bpf. The rest is renaming the functions in
> fs/fuse/famfs.c to generic fuse_iomap_dax_XXX names (the logic is the
> same logic in this series, eg invoking the lower-level calls to
> dax_iomap_rw/fault/etc) and moving the daxdev setup/initialization to
> connection initialization time where the server passes that daxdev
> setup info/configs upfront. I don't think this would delay things by
> several merge windows, as the code is already mostly written. If it
> would be helpful, I can clean up what's in the prototype and send that
> out.

I agree that you and I and John could probably get the code and review
part wrapped up in perhaps two merge windows -- one for fuse-iomap,
and the second for famfs.  The userspace parts of both are more or less
done, which would minimize the amount of rework when we get to the
libfuse part.

(Let's be honest, with LSFMM happening during the week between -rc2 and
-rc3 and everyone's travel thereto, that's going to blow a big hole in
the 7.2 schedule)

The question is, would Miklos acquiesce to merging a large ball of code
that the three of us have been collaborating on?  Even if he wasn't
deeply involved in that collaboration?

> I think the part that is not clear yet and needs to be verified is
> whether this approach runs into any technical limitations on famfs's
> production workloads. For example, does the overhead of using bpf maps
> lead to a noticeable performance drop on real workloads? In the

I see a custom hashtable map implementation in kernel/bpf/hashtab.c,
and no particular evidence that it can rehash itself to cut down on
bucket list chasing.  That's too bad, because rhashtable rehashing is
generally effective at keeping the xfs icache pointer chasing down.

If we have a per-inode famfs_file_meta object, I wonder if we could just
attach it to the fuse_inode as a void *private pointer?  That wouldn't
be any worse than current famfs.

> future, will there be too many extent mappings on high-scale systems
> to make this feasible? etc. If there are technical reasons why the

I've asked that question (are we going to have millions of mappings?)
before.  From what John has told me and what I've seen with cxl and pmem
devices before that, the memory manager is heavily incentivized to give
out large static(ish) allocations to constrain the metadata overhead,
enable the use of PMD/PGD TLB entries, and minimize pointer chasing
through mapping structures.

The only reason we let that happen in the disk filesystems is that the
IO service times are so high nobody cares about L3 misses.

> famfs logic has to be in fuse, then imo we should figure that out and
> ideally that's the discussion we should be having. I am not a cxl
> expert so perhaps there is something missing in the approach that
> makes it not sufficient on production systems. If we don't end up
> going with the alternative approach, I still think this series should
> try to make the famfs uapi additions to fuse as generic as possible
> since that will be irreversible.

<nod>

> If we expedited the alternative approach in terms of reviewing and
> merging, would that suffice? Is the main pushback the timing of it, eg
> that it would take too long to get reviewed, merged, and shipped?

I think John's been pretty clear that he doesn't want to drag this out
even a day longer.  Given current trends this month, I might run out of
time soon too.

> > > - I don't know how to do it - so it'll be slow (kinda like my fuse learning
> > >   curve cost about a year because this is not that similar to anything
> > >   else that was already in fuse.
> >
> > ...and per above, BPF isn't some magic savior that avoids the expansion
> > of the UABI.
> 
> It doesn't avoid the expansion of the UABI but it makes the UABI
> generic (eg plenty of future servers can/will use the generic iomap
> layer).

(Oh good, nobody's talking about going the evil route and just fill out
struct iomap directly!)

> >
> > > - Those of us who are involved don't fully understand either the security
> > >   or performance implications of this. It
> >
> > Correct.  I sure think it's swell that people can inject IR programs
> > that jit/link into the kernel.  Don't ask which secondary connotation of
> > "swell" I'm talking about.
> 
> bpf is used elsewhere in the kernel (eg networking, scheduling). If it
> is the case that it is unsafe (which maybe it is, I don't know), then
> wouldn't those other areas have the same issues?

Well ok, here we go -- I don't think there's any serious technical
problems with BPF.  The ability to read (and in some cases write) to
kernel memory looks like it's flexible enough to do the classification
and data collection stuff that most current bpf users want to do.

The issues I was alluding to are BPF being used as a means to get around
slow/unresponsive maintainers; and the kernel community's collective
refusal to explore any other path to building new user APIs besides
designing everything generically perfectly up front in the kernel UABI
along with all the stress that involves.

Once upon a time I tried to push on these UAPI stressfulness issues and
Linus told me I had a loose grip on reality.  He's probably right.

> > > - Famfs is enabling access to memory and mapping fault handling must be
> > >   at "memory speed". We know that BPF walks some data structures when a
> > >   program executes. That exposes us to additional serialized L3 cache
> > >   misses each time we service a mapping fault (any TLB & page table miss).
> > >   This should be studied side-by-side with the existing approach under
> > >   multiple loads before being adopted for production.
> >
> > Yes, it should.  AFAICT if one switched to a per-inode bpf program, then
> > you could do per-inode bpf programs.  Then you don't even need the bpf
> > map, and the ->iomap_begin becomes an indirect call into JITted x86_64
> > math code.
> >
> > (The downside is that dyn code can't be meaningfully signed, requires
> > clang on the system, and you have to deal with inode eviction issues.)
> >
> > > - This has never been done in production, and we're throwing it in the way
> > >   of a project that has been soaking for years and needs to support early
> > >   shipments of products.
> >
> > Correct.  I haven't even implemented BPF-iomap for fuse4fs.  This BPF
> > integration stuff is *highly* experimental code.
> 
> I think what fuse4fs needs for bpf is significantly more complicated
> and intensive than what famfs needs. For famfs, the extent mapping
> logic is straightforward computation.

Agreed.  For fuse4fs I'm content to let it manage the iomap cache.

> > > If this is the only path, I'd like to revive famfs as a standalone file
> > > system. I'm still maintaining that and it's still in use.
> >
> > Honestly, you should probably just ship that to your users.  As long as
> > the ondisk format doesn't change much, switching the implementation at a
> > later date is at least still possible.
> 
> I recognize this is an unfair situation John as you've already spent
> years working on this and did what the community asked with rewriting
> it. What I'm hoping to convey is that the approach where the extent
> computing/finding logic gets moved to bpf is not radically different
> from the famfs logic already in this patchset. In my view, moving this
> logic to bpf is more advantageous for both fuse *and* famfs
> (decoupling famfs releases from kernel releases) - it would be great
> to consider this on technical merits if expediting the timeline of the
> alternative approach would suffice.
> 
> Thanks,
> Joanne
> 
> [1] https://github.com/joannekoong/libfuse/blob/444fa27fa9fd2118a0dc332933197faf9bbf25aa/example/famfs.bpf.c
> [2] https://lore.kernel.org/linux-fsdevel/0100019d43e79794-0eadcf5e-b659-43f7-8fdc-dec9f4ccce14-000000@email.amazonses.com/
> 
> >
> > --D
> 
