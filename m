Received: from zeniv.linux.org.uk (zeniv.linux.org.uk [62.89.141.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5FEC13D8E
	for <nvdimm@lists.linux.dev>; Mon, 13 Jun 2022 23:25:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=linux.org.uk; s=zeniv-20220401; h=Sender:In-Reply-To:Content-Type:
	MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=aJziV53ZNLcQpCnTSJ1xxm7rGO6TWzWG0v4urvX8NyU=; b=OT0sULAjLdDaLe/ufoRgRaz7h6
	lrNif+4H2x52/rVv8ukb76PFqzdihC65C1EMUDEvF+Al/I3OixmZVOhwnHVxnbiuj7E2UrBJAcK3i
	jq5BxKMcUf79LcpEbksN/HeGbGhMS59DgwAcyqzfBHXGBAr4eL+w8z1Xhz9hgreXdCcLdwZtYOSwB
	ZYuHacQ5p0oL3Ji5PO+Cu6tPRFt3jXOxRhifbYIa0FpTmQz+qczlVENomVFoigy/tiAnImRolar+O
	VX6TvKMmZD5xYum3sDP3LaVe4eMJSNR1tv14TqHfsPe1Hd8QoCCwuRCuyn+faTB7sA1Dm1z4QhW25
	kX5Ovdfg==;
Received: from viro by zeniv.linux.org.uk with local (Exim 4.95 #2 (Red Hat Linux))
	id 1o0tQd-0005hJ-Th;
	Mon, 13 Jun 2022 23:25:04 +0000
Date: Tue, 14 Jun 2022 00:25:03 +0100
From: Al Viro <viro@zeniv.linux.org.uk>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Dan Williams <dan.j.williams@intel.com>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	linux-fsdevel <linux-fsdevel@vger.kernel.org>,
	nvdimm@lists.linux.dev, David Howells <dhowells@redhat.com>
Subject: Re: [RFC][PATCH] fix short copy handling in copy_mc_pipe_to_iter()
Message-ID: <YqfHT7Ha/N/wAdcG@ZenIV>
References: <YqaAcKsd6uGfIQzM@zeniv-ca.linux.org.uk>
 <CAHk-=wjmCzdNDCt6L8-N33WSRaYjnj0=yTc_JG8A_Pd7ZEtEJw@mail.gmail.com>
 <Yqe6EjGTpkvJUU28@ZenIV>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Yqe6EjGTpkvJUU28@ZenIV>
Sender: Al Viro <viro@ftp.linux.org.uk>

On Mon, Jun 13, 2022 at 11:28:34PM +0100, Al Viro wrote:

> Dave, could you explain what's going on there?  Note that pipe_write()
> does *not* use that thing at all; it's only splice (i.e. ITER_PIPE
> stuff) that is using it.
> 
> What's wrong with
>         p_occupancy = pipe_occupancy(head, tail);
>         if (p_occupancy >= pipe->max_usage)
>                 return 0;
> 	else
> 		return pipe->max_usage - p_occupancy;
> 
> which would match the way you are using ->max_usage in pipe_write()
> et.al.  Including the use in copy_page_to_iter_pipe(), BTW...

The more I'm looking at that thing, the more it smells like a bug;
it had the same 3 callers since the time it had been introduced.

1) pipe_get_pages().  We are about to try and allocate up to that
many pipe buffers.  Allocation (done in push_pipe()) is done only
if we have !pipe_full(pipe->head, pipe->tail, pipe->max_usage).

It simply won't give you more than max_usage - occupancy.
Your function returns min(ring_size - occupancy, max_usage), which
is always greater than or equal to that (ring_size >= max_usage).

2) pipe_get_pages_alloc().  Same story, same push_pipe() being
called, same "we'll never get that much - it'll hit the limit
first".

3) iov_iter_npages() in case of ITER_PIPE.  Again, the value
is bogus - it should not be greater than the amount of pages
we would be able to write there.

AFAICS, 6718b6f855a0 "pipe: Allow pipes to have kernel-reserved slots"
broke it for cases when ring_size != max_usage...
