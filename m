Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 13AFA212BF9AF
 for <linux-nvdimm@lists.01.org>; Mon, 22 Jul 2019 16:56:37 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAFd5g45hdCxEavSxirr0un_uLzo5Z-J4gHRA06qjzcQrTzmjVg@mail.gmail.com>
References: <20190712081744.87097-1-brendanhiggins@google.com>
 <CAFd5g47ikJmA0uGoavAFsh+hQvDmgsOi26tyii0612R=rt7iiw@mail.gmail.com>
 <CAFd5g44_axVHNMBzxSURQB_-R+Rif7cZcg7PyZ_SS+5hcy5jZA@mail.gmail.com>
 <20190716175021.9CA412173C@mail.kernel.org>
 <CAFd5g453vXeSUCZenCk_CzJ-8a1ym9RaPo0NVF=FujF9ac-5Ag@mail.gmail.com>
 <20190718175024.C3EC421019@mail.kernel.org>
 <CAFd5g46a7C1+R6ZcE_SkqaYqgrH5Rx3M=X7orFyaMgFLDbeYYA@mail.gmail.com>
 <20190719000834.GA3228@google.com>
 <20190722200347.261D3218C9@mail.kernel.org>
 <CAFd5g45hdCxEavSxirr0un_uLzo5Z-J4gHRA06qjzcQrTzmjVg@mail.gmail.com>
Subject: Re: [PATCH v9 04/18] kunit: test: add kunit_stream a std::stream like
 logger
From: Stephen Boyd <sboyd@kernel.org>
Date: Mon, 22 Jul 2019 16:54:10 -0700
Message-Id: <20190722235411.06C1320840@mail.kernel.org>
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
To: Brendan Higgins <brendanhiggins@google.com>
Cc: Petr Mladek <pmladek@suse.com>, "open list:DOCUMENTATION" <linux-doc@vger.kernel.org>, Peter Zijlstra <peterz@infradead.org>, Amir Goldstein <amir73il@gmail.com>, dri-devel <dri-devel@lists.freedesktop.org>, Sasha Levin <Alexander.Levin@microsoft.com>, Masahiro Yamada <yamada.masahiro@socionext.com>, Michael Ellerman <mpe@ellerman.id.au>, "open list:KERNEL SELFTEST FRAMEWORK" <linux-kselftest@vger.kernel.org>, shuah <shuah@kernel.org>, Rob Herring <robh@kernel.org>, linux-nvdimm <linux-nvdimm@lists.01.org>, Frank Rowand <frowand.list@gmail.com>, Knut Omang <knut.omang@oracle.com>, Kieran Bingham <kieran.bingham@ideasonboard.com>, wfg@linux.intel.com, Joel Stanley <joel@jms.id.au>, David Rientjes <rientjes@google.com>, Jeff Dike <jdike@addtoit.com>, Dan Carpenter <dan.carpenter@oracle.com>, devicetree <devicetree@vger.kernel.org>, linux-kbuild <linux-kbuild@vger.kernel.org>, "Bird, Timothy  <Tim.Bird@sony.com>, linux-um@lists.infradead.org, Steven Rostedt" <rostedt@goodmis.org>, Julia Lawall <julia.lawall@lip6.fr>, Josh Poimboeuf <jpoimboe@redhat.com>, kunit-dev@googlegroups.com, Theodore Ts'o <tytso@mit.edu>, Richard Weinberger <richard@nod.at>, Greg KH <gregkh@linuxfoundation.org>, Randy Dunlap <rdunlap@infradead.org>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, Luis Chamberlain <mcgrof@kernel.org>, Daniel Vetter <daniel@ffwll.ch>, Kees Cook <keescook@google.com>, linux-fsdevel@vger.kernel.org, Kevin Hilman <khilman@baylibre.com>
List-ID: <linux-nvdimm@lists.01.org>

Quoting Brendan Higgins (2019-07-22 15:30:49)
> On Mon, Jul 22, 2019 at 1:03 PM Stephen Boyd <sboyd@kernel.org> wrote:
> >
> >
> > What's the calling context of the assertions and expectations? I still
> > don't like the fact that string stream needs to allocate buffers and
> > throw them into a list somewhere because the calling context matters
> > there.
> 
> The calling context is the same as before, which is anywhere.

Ok. That's concerning then.

> 
> > I'd prefer we just wrote directly to the console/log via printk
> > instead. That way things are simple because we use the existing
> > buffering path of printk, but maybe there's some benefit to the string
> > stream that I don't see? Right now it looks like it builds a string and
> > then dumps it to printk so I'm sort of lost what the benefit is over
> > just writing directly with printk.
> 
> It's just buffering it so the whole string gets printed uninterrupted.
> If we were to print out piecemeal to printk, couldn't we have another
> call to printk come in causing it to garble the KUnit message we are
> in the middle of printing?

Yes, printing piecemeal by calling printk many times could lead to
interleaving of messages if something else comes in such as an interrupt
printing something. Printk has some support to hold "records" but I'm
not sure how that would work here because KERN_CONT talks about only
being used early on in boot code. I haven't looked at printk in detail
though so maybe I'm all wrong and KERN_CONT just works?

Can printk be called once with whatever is in the struct? Otherwise if
this is about making printk into a structured log then maybe printk
isn't the proper solution anyway. Maybe a dev interface should be used
instead that can handle starting and stopping tests (via ioctl) in
addition to reading test results, records, etc. with read() and a
clearing of the records. Then the seqfile API works naturally. All of
this is a bit premature, but it looks like you're going down the path of
making something akin to ftrace that stores binary formatted
assertion/expectation records in a lockless ring buffer that then
formats those records when the user asks for them.

I can imagine someone wanting to write unit tests that check conditions
from a simulated hardirq context via irq works (a driver mock
framework?), so this doesn't seem far off.

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
