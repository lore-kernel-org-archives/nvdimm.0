Return-Path: <linux-kernel-owner@vger.kernel.org>
Date: Thu, 13 Aug 2015 16:31:50 +0200
From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH 29/31] parisc: handle page-less SG entries
Message-ID: <20150813143150.GA17183@lst.de>
References: <1439363150-8661-1-git-send-email-hch@lst.de> <1439363150-8661-30-git-send-email-hch@lst.de> <CA+55aFxsH9Lde7wqZi555vqfH2uxeQqC9cjeca9L6Wr=XpyzXA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+55aFxsH9Lde7wqZi555vqfH2uxeQqC9cjeca9L6Wr=XpyzXA@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Jens Axboe <axboe@kernel.dk>, Dan Williams <dan.j.williams@intel.com>, Vineet Gupta <vgupta@synopsys.com>, =?iso-8859-1?Q?H=E5vard?= Skinnemoen <hskinnemoen@gmail.com>, Hans-Christian Egtvedt <egtvedt@samfundet.no>, Miao Steven <realmz6@gmail.com>, David Howells <dhowells@redhat.com>, Michal Simek <monstr@monstr.eu>, the arch/x86 maintainers <x86@kernel.org>, David Woodhouse <dwmw2@infradead.org>, Alex Williamson <alex.williamson@redhat.com>, grundler@parisc-linux.org, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, "linux-arch@vger.kernel.org" <linux-arch@vger.kernel.org>, linux-alpha@vger.kernel.org, "linux-ia64@vger.kernel.org" <linux-ia64@vger.kernel.org>, linux-metag@vger.kernel.org, linux-mips <linux-mips@linux-mips.org>, Parisc List <linux-parisc@vger.kernel.org>, ppc-dev <linuxppc-dev@lists.ozlabs.org>, linux-s390 <linux-s390@vger.kernel.org>, sparclinux@vger.kernel.org, linux-xtensa@linux-xtensa.org, "linux-nvdimm@lists.01.org" <linux-nvdimm@ml01.01.org>, Linux Media Mailing List <linux-media@vger.kernel.org>
List-ID: <linux-nvdimm@lists.01.org>

On Wed, Aug 12, 2015 at 09:01:02AM -0700, Linus Torvalds wrote:
> I'm assuming that anybody who wants to use the page-less
> scatter-gather lists always does so on memory that isn't actually
> virtually mapped at all, or only does so on sane architectures that
> are cache coherent at a physical level, but I'd like that assumption
> *documented* somewhere.

It's temporarily mapped by kmap-like helpers.  That code isn't in
this series. The most recent version of it is here:

https://git.kernel.org/cgit/linux/kernel/git/djbw/nvdimm.git/commit/?h=pfn&id=de8237c99fdb4352be2193f3a7610e902b9bb2f0

note that it's not doing the cache flushing it would have to do yet, but
it's also only enabled for x86 at the moment.
