Return-Path: <linux-kernel-owner@vger.kernel.org>
MIME-Version: 1.0
In-Reply-To: <1439363150-8661-30-git-send-email-hch@lst.de>
References: <1439363150-8661-1-git-send-email-hch@lst.de>
	<1439363150-8661-30-git-send-email-hch@lst.de>
Date: Wed, 12 Aug 2015 09:01:02 -0700
Message-ID: <CA+55aFxsH9Lde7wqZi555vqfH2uxeQqC9cjeca9L6Wr=XpyzXA@mail.gmail.com>
Subject: Re: [PATCH 29/31] parisc: handle page-less SG entries
From: Linus Torvalds <torvalds@linux-foundation.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>
Cc: Jens Axboe <axboe@kernel.dk>, Dan Williams <dan.j.williams@intel.com>, Vineet Gupta <vgupta@synopsys.com>, =?UTF-8?Q?H=C3=A5vard_Skinnemoen?= <hskinnemoen@gmail.com>, Hans-Christian Egtvedt <egtvedt@samfundet.no>, Miao Steven <realmz6@gmail.com>, David Howells <dhowells@redhat.com>, Michal Simek <monstr@monstr.eu>, the arch/x86 maintainers <x86@kernel.org>, David Woodhouse <dwmw2@infradead.org>, Alex Williamson <alex.williamson@redhat.com>, grundler@parisc-linux.org, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, "linux-arch@vger.kernel.org" <linux-arch@vger.kernel.org>, linux-alpha@vger.kernel.org, "linux-ia64@vger.kernel.org" <linux-ia64@vger.kernel.org>, linux-metag@vger.kernel.org, linux-mips <linux-mips@linux-mips.org>, Parisc List <linux-parisc@vger.kernel.org>, ppc-dev <linuxppc-dev@lists.ozlabs.org>, linux-s390 <linux-s390@vger.kernel.org>, sparclinux@vger.kernel.org, linux-xtensa@linux-xtensa.org, "linux-nvdimm@lists.01.org" <linux-nvdimm@ml01.01.org>, Linux Media Mailing List <linux-media@vger.kernel.org>
List-ID: <linux-nvdimm@lists.01.org>

On Wed, Aug 12, 2015 at 12:05 AM, Christoph Hellwig <hch@lst.de> wrote:
> Make all cache invalidation conditional on sg_has_page() and use
> sg_phys to get the physical address directly.

So this worries me a bit (I'm just reacting to one random patch in the series).

The reason?

I think this wants a big honking comment somewhere saying "non-sg_page
accesses are not necessarily cache coherent").

Now, I don't think that's _wrong_, but it's an important distinction:
if you look up pages in the page tables directly, there's a very
subtle difference between then saving just the pfn and saving the
"struct page" of the result.

On sane architectures, this whole cache flushing thing doesn't matter.
Which just means that it's going to be even more subtle on the odd
broken ones..

I'm assuming that anybody who wants to use the page-less
scatter-gather lists always does so on memory that isn't actually
virtually mapped at all, or only does so on sane architectures that
are cache coherent at a physical level, but I'd like that assumption
*documented* somewhere.

(And maybe it is, and I just didn't get to that patch yet)

                   Linus
