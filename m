Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from newverein.lst.de (verein.lst.de [213.95.11.211])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id BD18E202E6145
 for <linux-nvdimm@lists.01.org>; Mon, 16 Oct 2017 00:35:03 -0700 (PDT)
Date: Mon, 16 Oct 2017 09:38:36 +0200
From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH v9 1/6] mm: introduce MAP_SHARED_VALIDATE, a mechanism
 to safely define new mmap flags
Message-ID: <20171016073836.GB28778@lst.de>
References: <150776922692.9144.16963640112710410217.stgit@dwillia2-desk3.amr.corp.intel.com>
 <150776923320.9144.6119113178052262946.stgit@dwillia2-desk3.amr.corp.intel.com>
 <20171012135127.GG29293@quack2.suse.cz>
 <CA+55aFyy-nz99c6erFh=aeyCOzsk0td5wHaVLpwBNA-sWNDZkA@mail.gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <CA+55aFyy-nz99c6erFh=aeyCOzsk0td5wHaVLpwBNA-sWNDZkA@mail.gmail.com>
List-Unsubscribe: <https://lists.01.org/mailman/options/linux-nvdimm>,
 <mailto:linux-nvdimm-request@lists.01.org?subject=unsubscribe>
List-Archive: <http://lists.01.org/pipermail/linux-nvdimm/>
List-Post: <mailto:linux-nvdimm@lists.01.org>
List-Help: <mailto:linux-nvdimm-request@lists.01.org?subject=help>
List-Subscribe: <https://lists.01.org/mailman/listinfo/linux-nvdimm>,
 <mailto:linux-nvdimm-request@lists.01.org?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: linux-nvdimm-bounces@lists.01.org
Sender: "Linux-nvdimm" <linux-nvdimm-bounces@lists.01.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Jan Kara <jack@suse.cz>, Arnd Bergmann <arnd@arndb.de>, "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>, Linux API <linux-api@vger.kernel.org>, Christoph Hellwig <hch@lst.de>, linux-xfs <linux-xfs@vger.kernel.org>, linux-mm <linux-mm@kvack.org>, Andy Lutomirski <luto@kernel.org>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, Andrew Morton <akpm@linux-foundation.org>
List-ID: <linux-nvdimm@lists.01.org>

On Thu, Oct 12, 2017 at 09:32:17AM -0700, Linus Torvalds wrote:
> On Thu, Oct 12, 2017 at 6:51 AM, Jan Kara <jack@suse.cz> wrote:
> >
> > When thinking a bit more about this I've realized one problem: Currently
> > user can call mmap() with MAP_SHARED type and MAP_SYNC or MAP_DIRECT flags
> > and he will get the new semantics (if the kernel happens to support it).  I
> > think that is undesirable [..]
> 
> Why?
> 
> If you have a performance preference for MAP_DIRECT or something like
> that, but you don't want to *enforce* it, you'd use just plain
> MAP_SHARED with it.
> 
> Ie there may well be "I want this to work, possibly with downsides" issues.
> 
> So it seems to be a reasonable model, and disallowing it seems to
> limit people and not really help anything.

I don't think for MAP_DIRECT it matters (and I think we shouldn't have
MAP_DIRECT to start with, see the discussions later in the thread).

But for the main use case, MAP_SYNC you really want a hard error when you
don't get it.  And while we could tell people that they should only use
MAP_SYNC with MAP_SHARED_VALIDATE instead of MAP_SHARED chances that they
get it wrong are extremely high.  On the other hand if you really only
want a flag to optimize calling mmap twice is very little overhead, and
a very good documentation of you intent:

	addr = mmap(...., MAP_SHARED_VALIDATE | MAP_DIRECT, ...);
	if (!addr && errno = EOPNOTSUPP) {
		/* MAP_DIRECT didn't work, we'll just cope using blah, blah */
		addr = mmap(...., MAP_SHARED, ...);
	}
	if (!addr)
		goto handle_error;
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
