Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8ABBD43B6C1;
	Mon,  5 Oct 2026 23:37:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=216.40.44.12
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791243477; cv=none; b=jP/yM9E9nCl4ifOQbKIPiTkn0cG7FYnZA9FD2B7Bpi98O4VeohBoFt97KE6IQF1+wrt/qoZ1+c/EdmoqfNqhfl/EyJ/mNxh/b6kNgqO2JNjbNQJA6hWxLyoGLW4mi0CNGZ9aC58+4P+YpF40G+JU/ftuGqUI+mQIIGRVOUZfyGE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791243477; c=relaxed/simple;
	bh=9II7e20rC3YRtMC9ZN9hnzcEONlfjBuITelQhDbx2AE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=JP90Lq2Rz8l2P2Ry6i9bbReGC0sevBqE1fgX/9F5Sej+w69Dlciz6BSOezcJNV/NQ5zQfxtPTY6B2heUy5txHo1nrWEFAEw9HR9y09wEREhiFKRzxBNTvq6Z8fPKDfdQet3g/WJkb0lU67qwFn4wYmkbEGrQWGuRO+l7sdGFt/Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=groves.net; spf=pass smtp.mailfrom=groves.net; arc=none smtp.client-ip=216.40.44.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=groves.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=groves.net
Received: from omf17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 3F3E9A04C8;
	Mon,  5 Oct 2026 23:27:47 +0000 (UTC)
Received: from [HIDDEN] (Authenticated sender: john@groves.net) by omf17.hostedemail.com (Postfix) with ESMTPA id 7FE9F18;
	Mon,  5 Oct 2026 23:27:44 +0000 (UTC)
Date: Mon, 5 Oct 2026 18:27:43 -0500
From: John Groves <john@groves.net>
To: Miklos Szeredi <mszeredi@redhat.com>
Cc: fuse-devel@lists.linux.dev, Amir Goldstein <amir73il@gmail.com>, 
	"Darrick J . Wong" <djwong@kernel.org>, Vishal Verma <vishal.l.verma@intel.com>, 
	Dave Jiang <dave.jiang@intel.com>, Alison Schofield <alison.schofield@intel.com>, 
	nvdimm@lists.linux.dev, linux-cxl@vger.kernel.org, linux-fsdevel@vger.kernel.org, 
	david@kernel.org, willy@infradead.org, brauner@kernel.org
Subject: Re: [PATCH v2 0/8] fuse: DAX device based extent maps (famfs)
Message-ID: <asQcBebepPb9CXzS@groves.net>
References: <20261001150935.655979-1-mszeredi@redhat.com>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261001150935.655979-1-mszeredi@redhat.com>
X-Rspamd-Server: rspamout06
X-Stat-Signature: uo6wdaohey8iduce9nknm48zq973gpe6
X-Rspamd-Queue-Id: 7FE9F18
X-Session-Marker: 6A6F686E4067726F7665732E6E6574
X-Session-ID: U2FsdGVkX1/8NysK9/Gsulo4cuV+NGDnPd91igPQ7DI=
X-HE-Tag: 1791242864-711983
X-HE-Meta: U2FsdGVkX1+6uSTZIM+DeWgPC6Kyumy1z9XWtSk2yK1zL1dea3ycghq9QlZAKH+fZaqbZ9E41aYkRCAS16OC3LeULd2i9Yc5Jkr079BLSvFn11qev6T42egEtUcgc6MgVpfgcTB94L6Ak1oPOdAkQQPeX7Mn2eQUhzIc4A4gOaqlt5ZOBe6yZQyEJjZ1VU2pkgJHTQh0bcScVuTUNJZfLBRztfS8yaH03b5ljVq5HXurmtV8GY3NEocGTzXgzIuv7iKlvA0mkPokdwk74M2jHlI0ObQNza3n4HGmlZFoDmG3BrmqsI08QD3kx8gWN6ojIR6TpBLoncu7b3nj2Z3YuCXCx6ur9DrBrFwkckna72eEqOZaov1DUQ==

On 26/10/01 05:07PM, Miklos Szeredi wrote:
> This is the FUSIfication of the famfs-fuse patchset.

This series (v1) was sent on the day I left on a vacation from which I
returned at the end of last week.

I feel I should acknowledge this and assure everybody that I'm working
through it. This really runs my famfs/fuse patches through a 
chipper/shredder, and it is gonna take me some time to review it, 
understand it and test it.

A few comments below, and specific patch comments should start trickling out.

One very high level quip though: If you're comfortable with this, go ahead 
and merge it. We can fix bugs and performance problems, if any, in due 
course. I'm serious about that.

> 
>  - extent maps are assigned to a backing ID
> 
>  - 64 bit backing ID's managed by server

I thought we agreed you weren't gonna do these two, but if it does no harm,
whatever.

> 
>  - maps can be linear or cyclic (striped)

Please correct me if any of my analysis below is wrong...

Here what you've done is remove my explicitly interleaved extent lists,
which have a header containing a chunk size and a set of strip extents (which
are basically fully self-describing), and replace is with just simple extent 
lists that have an optional CYCLIC flag in the header. If the flag is set on 
an extent list, (and let's say the strip extents need to be 1GiB and the 
chunk size is 2MiB), each CYCLIC extent gets its size set to the chunk size 
and the kernel trusts that the actual size allocated per stirp is actually 
sufficient that i_size will not cycle past the end of the *actually* 
allocated size of each strip extent.

This resembles an idea I considered, to try to make the metadata *look* 
simpler while still carrying the info that needs to be conveyed. But this 
implementation feels pretty janky to me, and it should at least be 
meticulously documented. Better might be to put the chunk_size in the header,
and then you arguably don't need the CYCLIC flag, since non-zero chunk_size
means the same thing. But actually, you can accept multiple CYCLIC strip
lists if you set chunk_size and then set the CYCLIC flag on the first of
each strip set.

I see the kernel-side rejects these s/size/chunk_size/ strip extents if they
are not all the same size. Why not put the chunk size in the header and let
the extents honestly describe the offset and range that they cover? 
The current design can't test for sufficient strip extent sizes, although 
it replaces code that did verify this.

> 
>  - API supports nesting, but not implemented yet (i.e. multiple striped
>    extents per inode, a-la famfs)
> 
> libfuse/famfs trees for testing:
> 
>  https://github.com/szmi/libfuse.git#extent-map-v2
>  https://github.com/szmi/famfs.git#extent-map-v2
> 
> This patchset:
> 
>  git://git.kernel.org/pub/scm/linux/kernel/git/mszeredi/fuse.git#extent-map-v2
> 
> Passes famfs smoke test on emulated dax device.

Thank you for doing that. Prior to this there have been many strong opinions
but none of the holders of said opinions built or tested famfs.

However, the smoke tests passing isn't fully legit, because the patch to the
famfs fuse server passes the entire strip size on CYCLIC mappings, meaning
it just produces a concatenation of ranges - which does not achieve the 
interleaving goal at all. That case degenerates to simple extents.

If this is the new design for passing cycling maps into the kernel, a test
will be added to catch this - but it's brand new and didn't get a test added,
so it wasn't caught automatically.

> 
> Comments are welcome.

One more... This patch inserts an rbtree lookup into the fault path via the
very-performance-critical fuse_ext_map_iomap_begin() path. This is 
performance-critical because it handles TLB/PTE/PMD faults when the memory
is never sparse (no I/O to amortize over). The code you replaced did several
things to avoid this sort of chasing:

- With interleaved extent lists, strip and strip-offset can be calculated
  in order 1 (and then strip overflow can be checked and avoided)
- Simple extent lists were checked for constant extent sizes; if constant,
  we can just index into the list (also order 1)

Why do I want to avoid an rbtree lookup or the bpf nonsense in the fault path?
"Because this is memory and it must run at memory speeds" --yours truly

To be specific: each chase/dereference that results in an L3 cache miss adds
a stall of (1 * MEMORY_LATENCY) to the fault time. This is the good reason 
why I didn't do any chasing in the fault path of the famfs code that you're
replacing.

OK, one more. You're using the rbtree for indexing by file offset, which is
a zero-based non-sparse range in this case. If this could not be avoided 
(which I think it can) you should use an xarray or radix tree for that...
right?

> 
> Thanks,
> Miklos
> 
> ---
> Changes since v1:
> 
>  - moved 3 prep patches to fuse.git#for-next
>  - introduce FUSE_PASSTHROUGH_V2 (Amir)
>  - lots of small fixes and cleanups (Amir, Sashiko)
> 
> ---
> John Groves (1):
>   dax: replace exported dax_dev_get() with non-allocating dax_dev_find()

Golly, it seems like there's more than 1 patch worth of content from me here,
but the chipper/shredder might meet the letter of copyright law in some 
jurisdictions...

> 
> Miklos Szeredi (7):
>   fuse: add helpers for EIO return value with kernel message
>   fuse: support 64 bit, server allocated backing ID
>   fuse: support opening 64 bit backing ID
>   fuse: add support for opening dax device as backing
>   fuse: add extent map data structure
>   fuse: add extent map I/O support
>   fuse: add support for striped backing
> 
>  drivers/dax/super.c       |  38 ++++-
>  fs/fuse/Makefile          |   2 +-
>  fs/fuse/backing.c         | 292 ++++++++++++++++++++++++++++++-------
>  fs/fuse/dev.c             |  21 +++
>  fs/fuse/dev.h             |   3 +
>  fs/fuse/dir.c             |   3 +-
>  fs/fuse/ext_map.c         | 299 ++++++++++++++++++++++++++++++++++++++
>  fs/fuse/file.c            |  16 +-
>  fs/fuse/fuse_i.h          |  72 +++++++--
>  fs/fuse/inode.c           |  17 ++-
>  fs/fuse/iomode.c          | 108 +++++++-------
>  fs/fuse/notify.c          |  75 ++++++++++
>  fs/fuse/passthrough.c     |  63 ++++----
>  include/linux/dax.h       |   6 +-
>  include/uapi/linux/fuse.h |  53 ++++++-
>  15 files changed, 904 insertions(+), 164 deletions(-)
>  create mode 100644 fs/fuse/ext_map.c
> 
> -- 
> 2.54.0
> 

John

