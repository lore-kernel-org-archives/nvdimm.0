Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4F262375ACF;
	Thu, 16 Apr 2026 22:43:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776379412; cv=none; b=kT2/Xdb5fPzh4MI0WY5JwPnsvH+XKMiKEjJYJjez1M4tUJt6F/Eff28t+Yb+6L7vCX7VApwiaJbVpBR/qVW5sck6W01BHxKkI4ST/5mblRFox8lzOxDQhhvbZ21vbdmvaaoU2N6JXUKjb1faDBtr1MnXSXoJMTQUSOCRQjR2cGw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776379412; c=relaxed/simple;
	bh=qKUpqDrb9Ptsu5hc5LGE0mNm7b8T3hnjmauL6JvvBJQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=n2Sr6CYu95vzsxHD4RQx2HXPrG7VUpsulJoZ/MzgUCFiQTPGT+mwBmkPUmWz+mgj4K5NjgFvasOupusXjJDrVXiBQiAByQy101LDrwSlXoRiNS83rppEestYQhwNH2Fy5LfG5ivwwk4Z9mI8wM63IMyHE2sbi7qx/UCH1yk0yvk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=V+3srfUS; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="V+3srfUS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E01F9C2BCAF;
	Thu, 16 Apr 2026 22:43:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1776379412;
	bh=qKUpqDrb9Ptsu5hc5LGE0mNm7b8T3hnjmauL6JvvBJQ=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=V+3srfUSnBdTShmnHUJ0+HYBHhLJolmNslN4MMY6F+lr2vtuizOwnhixs3OwcxfL5
	 zMTIZoGEqxMJWonHpytQ8Q+fl3SBMrgr6zcsSHW9Lkxlx0IERmvhInsMQLqhWFrlex
	 NPVFoWcf1LhAlJnZs9XST3nOmgPq8TFT+vFRPAykZeiU/qi/5S1pxwjji0HeN4IbtF
	 ktDU8V85DZRT/HbiOEqtLIGwtM5zwq1coG6oyeXmy4FVWfqSfI+o/+aWFE1I8CxtDr
	 dZN1opfhJeWjxxdudK3kIAhQNPFS8zUGgxtvxk42Sy+BlyQidwCsZnk/BoJwrKS7G7
	 SxMz53uLvDrnQ==
Date: Thu, 16 Apr 2026 15:43:31 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Dan Williams <djbw@kernel.org>
Cc: Gregory Price <gourry@gourry.net>,
	Joanne Koong <joannelkoong@gmail.com>,
	John Groves <John@groves.net>, Miklos Szeredi <miklos@szeredi.hu>,
	Bernd Schubert <bernd@bsbernd.com>,
	John Groves <john@jagalactic.com>,
	Dan J Williams <dan.j.williams@intel.com>,
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
	Aravind Ramesh <arramesh@micron.com>,
	Ajay Joshi <ajayjoshi@micron.com>,
	"venkataravis@micron.com" <venkataravis@micron.com>,
	"linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"nvdimm@lists.linux.dev" <nvdimm@lists.linux.dev>,
	"linux-cxl@vger.kernel.org" <linux-cxl@vger.kernel.org>,
	"linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>
Subject: Re: [PATCH V10 00/10] famfs: port into fuse
Message-ID: <20260416224331.GD114184@frogsfrogsfrogs>
References: <adlBcwJjLOQDAR65@groves.net>
 <CAJnrk1a06zkUmXW5EFiUmgAoFauwtzsYvnotaPH0ifVtyh7iDQ@mail.gmail.com>
 <CAJfpegvVTcV89=q3L326aGQjhduBcv7PVg5QKftGLjNZmCLmaw@mail.gmail.com>
 <ad4_jFsR951c2Mtn@groves.net>
 <20260414185740.GA604658@frogsfrogsfrogs>
 <CAJnrk1ZgcMuwfMpT1fXvUwBBiq9eWFHWVeOFQFFKiamGGe1RJg@mail.gmail.com>
 <ad7Tps4tkNbndd9Z@groves.net>
 <CAJnrk1ZWVsKW2dhAWdBkCQskoTE+hmOhPFDhyz4EtExn=GdXGA@mail.gmail.com>
 <aeFDCeqZDPI3rm3s@gourry-fedora-PF4VCD3F>
 <43d36427-4629-4712-a262-391e64006eb5@app.fastmail.com>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <43d36427-4629-4712-a262-391e64006eb5@app.fastmail.com>

On Thu, Apr 16, 2026 at 01:53:27PM -0700, Dan Williams wrote:
> 
> 
> On Thu, Apr 16, 2026, at 1:14 PM, Gregory Price wrote:
> > On Thu, Apr 16, 2026 at 08:56:46AM -0700, Joanne Koong wrote:
> >> On Tue, Apr 14, 2026 at 5:10 PM John Groves <John@groves.net> wrote:
> >> >
> >> > There is a FUSE_DAX_FMAP capability that the kernel may advertise or not
> >> > at init time; this capability "is" the famfs GET_FMAP AND GET_DAXDEV
> >> > commands. In the future, if we find a way to use BPF (or some other
> >> > mechanism) to avoid needing those fuse messages, the kernel could be updated
> >> > to NEVER advertise the FUSE_DAX_FMAP capability. All of the famfs-specific
> >> > code could be taken out of kernels that never advertise that capability.
> >> 
> >> I’m not sure the capability bit can be used like that (though I am
> >> hoping it can!). As I understand it, once the kernel advertises a
> >> capability, it must continue supporting it in future kernels else
> >> userspace programs that rely on it will break.

So don't break fuse servers.  If you wanted to (say) get rid of
GET_FMAP in favor of IOMAP_BEGIN, you could alter libfuse to translate a
fuse server's ->get_fmap implementation into the equivalent
->iomap_begin, and eventually the kernel can stop making GET_FMAP calls
to userspace.

The trouble here is that I've also seen half a dozen projects vendoring
libfuse so that's a nightmare that will have to be dealt with.  But
maybe that doesn't even matter, because...

> > FUSE_DAX_FMAP is already conditional on CONFIG_FUSE_DAX, the kernel is
> > not required to continue advertising FUSE_DAX_FMAP in perpetuity.
> >
> > Setting CONFIG_FUSE_DAX=n does not mean userland "is broken", this would
> > only be the case if FUSE_DAX_FMAP was advertised but not actually
> > supported.

...the memory interleaving is a rather interesting quality of famfs.
There's no good way to express a formulaic meta-mapping in traditional
iomap parlance, and famfs needs that to interleave across memory
controllers/dimm boxen/whatever.  Throwing individual iomaps at the
kernel is a very inefficient way to do that.  So I don't think there's a
good reason to get rid of GET_FMAP at this time...

> > If DAX were removed from the kernel (unlikely, but stick with me) this
> > would be equivalent to permanently changing CONFIG_FUSE_DAX to always
> > off, and there would be no squabbles over whether that particular
> > change broke userland (there would be much strife over removing dax).

...however the strongest case (IMO) would be if (having merged famfs) we
then merge fuse-iomap after famfs.  Then we extend the existing
fuse-iomap-bpf prototype to allow per-mount and per-inode iomap bpf ops.
That enables us to analyze thoroughly the performance characteristics of:

a) Using GET_FMAP as-is

b) Uploading raw iomaps (HA)

c) Uploading a single bpf program to make iomaps, exchanging fmap-style
mapping data into a bpf map, and having the single bpf program walk
through the map

d) Uploading a custom bpf program per famfs file to make iomaps.  No
bpfmap required, but the setup and compilation are now much more complex

Then we'll finally know which approach is the best, having broken the
Gordian Knot of how to merge famfs and fuse-iomap.

If we decide that (c) or (d) are actually better, then guess what?  To
get any of the iomap functionality, you have to set an inode flag, and
that (FUSE_CAP_FAMFS && FUSE_CAP_IOMAP && FUSE_ATTR_IOMAP) is the signal
for "don't call GET_FMAP".  FUSE_CAP_FAMFS && (!FUSE_CAP_IOMAP ||
!FUSE_ATTR_IOMAP) means "call GET_FMAP".

Yes, we burn a couple of fuse command values to find out, but that's all.

(TBH I still dislike GET_DAXDEV, that really should just be another
application of backing files, and the backing file id gets passed to
GET_FMAP.)

What do you all think of doing that?

> > While not a deprecation method, this is what capability bits are
> > designed for. Same as cpuid capability bits - just because the bit is
> > there doesn't mean a processor is required to support it in perpetuity.
> >
> > They're only required to support it if the bit is turned on.
> >
> 
> Right, if the protocol on day one is "user space must ask which method
> is available", then userspace can not be surprised when one option
> disappears. So to give time for the bpf approach to mature the kernel
> can do something like "famfs and bpf  mapping support are available".
> In some future kernel the famfs native option disappears after a
> deprecation period.
> 
> When folks ask 10 years from now why this ever supported optionality
> the explanation is "oh because famfs enjoyed first mover advantage to
> prove out fs semantics layered on dax devices", or "turns out there
> are some cases where bpf is not fast enough but it still stops the
> proliferation of more in kernel mapping implementations".

Yes.  We're not *capable* of determining the best mechanism unless we
can start shipping these things to users to get their feedback.  Only
then can we iterate and make real improvements.

> Something like FUSE_DAX_FMAP is always available but the backend to
> that is optionally native vs bpf. ...or some other arrangement to make
> it clear that native might be gone someday.

--D
