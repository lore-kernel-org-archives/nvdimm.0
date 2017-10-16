Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mx2.suse.de (mx2.suse.de [195.135.220.15])
 (using TLSv1 with cipher ECDHE-RSA-AES256-SHA (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 314FF202E614D
 for <linux-nvdimm@lists.01.org>; Mon, 16 Oct 2017 00:53:22 -0700 (PDT)
Date: Mon, 16 Oct 2017 09:56:55 +0200
From: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH v9 1/6] mm: introduce MAP_SHARED_VALIDATE, a mechanism to
 safely define new mmap flags
Message-ID: <20171016075655.GE32738@quack2.suse.cz>
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

On Thu 12-10-17 09:32:17, Linus Torvalds wrote:
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

I have two concerns:

1) IMHO it supports sloppy programming from userspace - if application asks
e.g. for MAP_DIRECT and doesn't know whether it gets it or not, it would
have to be very careful not to assume anything about that in its code. And
frankly I think the most likely scenario is that a programmer will just use
MAP_SHARED | MAP_DIRECT, *assume* he will get the MAP_DIRECT semantics if
the call does not fail and then complain when his application breaks.

2) In theory there could be an application that inadvertedly sets some high
flag bits and now it would get confused by getting different mmap(2)
semantics. But I agree this is mostly theoretical.

Overall I think the benefit of being able to say "do MAP_DIRECT if you can"
does not outweight the risk of bugs in userspace applications. Especially
since userspace can easily implement the same semantics by retrying the
mmap(2) call without MAP_SHARED_VALIDATE | MAP_DIRECT.

								Honza
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
