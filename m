Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DE11318C008;
	Thu,  8 Oct 2026 23:00:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=216.40.44.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791500423; cv=none; b=mlogPH4UVkaEJtM4/+cvIvrX1Ir3V1FtS636y5OVh/QxhpOCYKmUyO4kU7VND0cEG20Or0BxzYX5u5HETCmR3gW+HBRBsaU8smxe3gPEJwh8wxFYLUrgFKEnMcOoWtmxMQRiD9PdIvLd1TplOI78mjgYT5JHN42Z+2hsDjk55jc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791500423; c=relaxed/simple;
	bh=Ja8do/4D5F7vuAAxmZtna8Ilm34MfuHphBldFbW3Cbw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=SyeiQev9mFnbaAxtGEhAuKxxezCckprTTQSV0Npc1YWpKYB0Q1n4zkiAJPKrLJqmfC71CiF4mNvpM0ZIxQVzg74bXbzX6D7XLZNMebkJ3NFOgxKUlhMX2Hpw5yys7fBvFM64zzFczs9/R0GLCnSzeIbsIkSG38HeYUfsWbzsEuc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=groves.net; spf=pass smtp.mailfrom=groves.net; arc=none smtp.client-ip=216.40.44.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=groves.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=groves.net
Received: from omf15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id CE50C16015E;
	Thu,  8 Oct 2026 23:00:13 +0000 (UTC)
Received: from [HIDDEN] (Authenticated sender: john@groves.net) by omf15.hostedemail.com (Postfix) with ESMTPA id B3DD318;
	Thu,  8 Oct 2026 23:00:10 +0000 (UTC)
Date: Thu, 8 Oct 2026 18:00:09 -0500
From: John Groves <john@groves.net>
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: Miklos Szeredi <mszeredi@redhat.com>, fuse-devel@lists.linux.dev, 
	Amir Goldstein <amir73il@gmail.com>, "Darrick J . Wong" <djwong@kernel.org>, 
	Vishal Verma <vishal.l.verma@intel.com>, Dave Jiang <dave.jiang@intel.com>, 
	Alison Schofield <alison.schofield@intel.com>, nvdimm@lists.linux.dev, linux-cxl@vger.kernel.org, 
	linux-fsdevel@vger.kernel.org, david@kernel.org, willy@infradead.org, brauner@kernel.org
Subject: Re: [PATCH v2 0/8] fuse: DAX device based extent maps (famfs)
Message-ID: <asZcsPT-Q8qga0SU@groves.net>
References: <20261001150935.655979-1-mszeredi@redhat.com>
 <asQcBebepPb9CXzS@groves.net>
 <CAJfpeguEUTYk9m7g2gZTMui0yFDYWSGL1SZ9PvoYiCqjDmHp9A@mail.gmail.com>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAJfpeguEUTYk9m7g2gZTMui0yFDYWSGL1SZ9PvoYiCqjDmHp9A@mail.gmail.com>
X-Stat-Signature: uggu67ce7tkzo5rn37wytz5yem7y363y
X-Rspamd-Server: rspamout08
X-Rspamd-Queue-Id: B3DD318
X-Session-Marker: 6A6F686E4067726F7665732E6E6574
X-Session-ID: U2FsdGVkX1+d2FLPXecql2qrUG0JgwtNhkdj6Arpje4=
X-HE-Tag: 1791500410-415219
X-HE-Meta: U2FsdGVkX19dU2svEPZ26FkYYvu54m7Y44DruVzPevwz9YLyqixNrWhyyF98aOMWUUMw+tVkwgzadfWEMq/ELmvWu1xmK5doh4qtvY0bg+RpPlFzVtfJEGKd7lmSH964idwHL2cX4bj9R4U0MquvZSho5/8c+azgNGLQp3LgyFs8kR0Wwko1gs6S1vCR/H4oHPnBBIII4On6rq9Pgs97h1gkI2iSqEfYp3tScMjc1XMiWmJkfzBNf9Uijj171voTUuv14T73PGjRDXrmEVzPRKJDTAuh41ZJTu8VIiq6atOB4QC2QOUb6FhH6BI4Wd+UAzoIHrXccTr0YNqgm60KESNukHYCmIRqumoxpCZ4tE34tMq3UmNDJTlrFLQii7kL

On 26/10/06 11:48AM, Miklos Szeredi wrote:
> On Tue, 6 Oct 2026 at 01:37, John Groves <john@groves.net> wrote:
> 
> > I see the kernel-side rejects these s/size/chunk_size/ strip extents if they
> > are not all the same size. Why not put the chunk size in the header and let
> > the extents honestly describe the offset and range that they cover?
> > The current design can't test for sufficient strip extent sizes, although
> > it replaces code that did verify this.
> 
> Not adding chunk size to the header is intentional to keep the API as
> simple as possible.

Fewer fields is nice, but it's on the honor system that the server allocated
large enough strips - since strips carry the chunk_size rather than their
actual size when CYCLIC is set. IMO it would be an improvement to add the
chunk_size to the header; then the strip sizes could be validated.

But it's your call, and I won't argue further about this unless something
changes.

> 
> > However, the smoke tests passing isn't fully legit, because the patch to the
> > famfs fuse server passes the entire strip size on CYCLIC mappings, meaning
> > it just produces a concatenation of ranges - which does not achieve the
> > interleaving goal at all. That case degenerates to simple extents.
> 
> Are you talking about the case where there are multiple simple extents
> each with a different striped mapping?

No

I'm saying your patch to the famfs user space, when famfs sends interleaved
file maps, sets CYCLIC but sets strip extent sizes to the actual strip size,
not the chunk_size. So chunking is at the size of the entire strip, which is
to say: the net is a multi-extent file that is not interleaved.

So that's a bug. I've fixed it locally and will share that in the next day
or two. I also needed to refactor your patch the famfs user space because
it disabled ABI compatibility with some older versions of the famfs kernel
that I'm still supporting users with. If you can wait to patch that further
until I share an update, it will be cleaner on my end.

> 
> That case is supported by the API, but not the implementation (since
> there was not test case).  If you do a test case, I'll add the
> implementation.
> 
> > To be specific: each chase/dereference that results in an L3 cache miss adds
> > a stall of (1 * MEMORY_LATENCY) to the fault time. This is the good reason
> > why I didn't do any chasing in the fault path of the famfs code that you're
> > replacing.
> 
> Please benchmark against the in-kernel implementation.  If there's
> significant (meaning it may have a real effect on a real-life
> workload) performance hit from using the rb-tree, then we can add an
> optimization.  I don't want to add complexity without actually being
> able to measure the gain.

I will do that, but it's not a small undertaking. Back to that in a moment.

I have an idea for how to make fault handling order-1 in the normal famfs
cases but fall back to order log-n if necessary (e.g. if not all extents are 
the same size). I'm testing that now and will share it soon if I don't run 
into any significant problems.

I think we can probably agree than things otherwise being equal, order-1
fault handling (or order-1 falling back to order-n if necessary) is 
preferable to order-log-n. If you or anybody doesn't agree with that, I 
hope we can discuss it.

As for benchmarking to "prove" that the rbtree is a problem, I'm sure there
are use cases where it is not a problem (like small virtual daxdevs on
workstations or laptops). What Micron worries about is huge working sets on 
many terabyte disaggregated memory. If the memory is 45TB (the biggest 
system I have "access" to), the data sets exceed the processor cache by a 
substantially higher factor than even in a maxed out server. That means
more L3 cache misses. I'm trying to avoid an approach with built-in chasing
on performance paths, because Micron's experience is that pointer chasing 
becomes L3-cache-miss bound.

Anyway, one workload (and working-set size) that doesn't exhibit significant 
L3 cache miss performance hit does not prove that others won't be negatively
impacted. Proving a negative, etc...

Having said all that, this topic seems to recur and be contentious - we are
working on tests that can demonstrate bottlenecks - but my current ask is
that if I can offer an alternative approach to rbtree that is better on 
paper, can we please use it?

> 
> > OK, one more. You're using the rbtree for indexing by file offset, which is
> > a zero-based non-sparse range in this case. If this could not be avoided
> > (which I think it can) you should use an xarray or radix tree for that...
> > right?
> 
> Unlike xarray, the rb_tree API is one I'm familiar with. But nothing
> prevents switching to xarray if that's a better choice.

That's fair. And I withdraw the xarray suggestion because I have a better
idea - will share that in a day or two, before Monday almost certainly.
Need to run it through all of my CI...

Thanks,
John

<snip>

