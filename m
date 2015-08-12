Return-Path: <linux-kernel-owner@vger.kernel.org>
MIME-Version: 1.0
In-Reply-To: <1439363150-8661-32-git-send-email-hch@lst.de>
References: <1439363150-8661-1-git-send-email-hch@lst.de>
	<1439363150-8661-32-git-send-email-hch@lst.de>
Date: Wed, 12 Aug 2015 09:05:15 -0700
Message-ID: <CA+55aFxfZM81HNfo2ysfhGwrhx6GX-+F--+jLFmMVv+Z0id2rw@mail.gmail.com>
Subject: Re: [PATCH 31/31] dma-mapping-common: skip kmemleak checks for
 page-less SG entries
From: Linus Torvalds <torvalds@linux-foundation.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>
Cc: Jens Axboe <axboe@kernel.dk>, Dan Williams <dan.j.williams@intel.com>, Vineet Gupta <vgupta@synopsys.com>, =?UTF-8?Q?H=C3=A5vard_Skinnemoen?= <hskinnemoen@gmail.com>, Hans-Christian Egtvedt <egtvedt@samfundet.no>, Miao Steven <realmz6@gmail.com>, David Howells <dhowells@redhat.com>, Michal Simek <monstr@monstr.eu>, the arch/x86 maintainers <x86@kernel.org>, David Woodhouse <dwmw2@infradead.org>, Alex Williamson <alex.williamson@redhat.com>, grundler@parisc-linux.org, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, "linux-arch@vger.kernel.org" <linux-arch@vger.kernel.org>, linux-alpha@vger.kernel.org, "linux-ia64@vger.kernel.org" <linux-ia64@vger.kernel.org>, linux-metag@vger.kernel.org, linux-mips <linux-mips@linux-mips.org>, Parisc List <linux-parisc@vger.kernel.org>, ppc-dev <linuxppc-dev@lists.ozlabs.org>, linux-s390 <linux-s390@vger.kernel.org>, sparclinux@vger.kernel.org, linux-xtensa@linux-xtensa.org, "linux-nvdimm@lists.01.org" <linux-nvdimm@ml01.01.org>, Linux Media Mailing List <linux-media@vger.kernel.org>
List-ID: <linux-nvdimm@lists.01.org>

On Wed, Aug 12, 2015 at 12:05 AM, Christoph Hellwig <hch@lst.de> wrote:
> +       for_each_sg(sg, s, nents, i) {
> +               if (sg_has_page(s))
> +                       kmemcheck_mark_initialized(sg_virt(s), s->length);
> +       }

[ Again, I'm responding to one random patch - this pattern was in
other patches too.  ]

A question: do we actually expect to mix page-less and pageful SG
entries in the same SG list?

How does that happen?

(I'm not saying it can't, I'm just wondering where people expect this
to happen).

IOW, maybe it would be valid to have a rule saying "a SG list is
either all pageful or pageless, never mixed", and then have the "if"
statement outside the loop rather than inside.

                      Linus
