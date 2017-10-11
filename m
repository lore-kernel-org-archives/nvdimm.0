Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from bombadil.infradead.org (bombadil.infradead.org [65.50.211.133])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256
 bits)) (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 7E44E21EA15B3
 for <linux-nvdimm@lists.01.org>; Wed, 11 Oct 2017 08:36:48 -0700 (PDT)
Date: Wed, 11 Oct 2017 08:40:13 -0700
From: Matthew Wilcox <willy@infradead.org>
Subject: Re: [PATCH] Fix mpage_writepage() for pages with buffers
Message-ID: <20171011154013.GA11800@bombadil.infradead.org>
References: <20171006211541.GA7409@bombadil.infradead.org>
 <20171010124421.c545e6308fed5a585acd43cd@linux-foundation.org>
 <CA+55aFxcMhj1TfBbk3G4XKzu8fjQDYPiFNS0W8pFqMJ6bdA46Q@mail.gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <CA+55aFxcMhj1TfBbk3G4XKzu8fjQDYPiFNS0W8pFqMJ6bdA46Q@mail.gmail.com>
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
Cc: "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, Andrew Morton <akpm@linux-foundation.org>, OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
List-ID: <linux-nvdimm@lists.01.org>

On Tue, Oct 10, 2017 at 01:31:44PM -0700, Linus Torvalds wrote:
> On Tue, Oct 10, 2017 at 12:44 PM, Andrew Morton
> <akpm@linux-foundation.org> wrote:
> >
> > This is all pretty mature code (isn't it?).  Any idea why this bug
> > popped up now?

I have no idea why it's suddenly popped up.  It looks like it should
be a bohrbug, but it's actually a heisenbug, and I don't understand
that either.

> Also, while the patch looks sane, the
> 
>         clean_buffers(page, PAGE_SIZE);
> 
> line really threw me. That's an insane value to pick, it looks like
> "bytes in page", but it isn't. It's just a random value that is bigger
> than "PAGE_SIZE >> SECTOR_SHIFT".
> 
> I'd prefer to see just ~0u if the intention is just "bigger than
> anything possible".

Actually, I did choose it to be "number of bytes in the page", based on
the reasoning that I didn't want to calculate what the actual block size
was, and the block size surely couldn't be any smaller than one byte.  I
forgot about the SECTOR_SIZE limit on filesystem block size, so your
spelling of "big enough" does look better.

Now that I think about it some more, I suppose we might end up with a
situation where we're eventually passing a hugepage to this routine,
and futureproofing it with ~0U probably makes more sense.
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
