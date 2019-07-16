Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id EE790212BC475
 for <linux-nvdimm@lists.01.org>; Tue, 16 Jul 2019 08:36:28 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAFd5g47y4vDB2P=EsGN8305LGeQPCTveNs-Jd5-=6K-XKY==CA@mail.gmail.com>
References: <20190712081744.87097-1-brendanhiggins@google.com>
 <20190712081744.87097-4-brendanhiggins@google.com>
 <20190715204356.4E3F92145D@mail.kernel.org>
 <CAFd5g47481sRaez=yEJN4_ghiXZbxayk1Y04tAZpuzPLsmnhKg@mail.gmail.com>
 <20190715220407.0030420665@mail.kernel.org>
 <CAFd5g44bE0F=wq_fOAnxFTtoOyx1dUshhDAkKWr5hX9ipJ4Sxw@mail.gmail.com>
 <CAFd5g47y4vDB2P=EsGN8305LGeQPCTveNs-Jd5-=6K-XKY==CA@mail.gmail.com>
From: Stephen Boyd <sboyd@kernel.org>
Subject: Re: [PATCH v9 03/18] kunit: test: add string_stream a std::stream
 like string builder
Date: Tue, 16 Jul 2019 08:33:59 -0700
Message-Id: <20190716153400.5CB182054F@mail.kernel.org>
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

Quoting Brendan Higgins (2019-07-15 15:43:20)
> On Mon, Jul 15, 2019 at 3:11 PM Brendan Higgins
> <brendanhiggins@google.com> wrote:
> >
> > On Mon, Jul 15, 2019 at 3:04 PM Stephen Boyd <sboyd@kernel.org> wrote:
> > >
> > > Quoting Brendan Higgins (2019-07-15 14:11:50)
> > > > On Mon, Jul 15, 2019 at 1:43 PM Stephen Boyd <sboyd@kernel.org> wrote:
> > > > >
> > > > > I also wonder if it would be better to just have a big slop buffer of a
> > > > > 4K page or something so that we almost never have to allocate anything
> > > > > with a string_stream and we can just rely on a reader consuming data
> > > > > while writers are writing. That might work out better, but I don't quite
> > > > > understand the use case for the string stream.
> > > >
> > > > That makes sense, but might that also waste memory since we will
> > > > almost never need that much memory?
> > >
> > > Why do we care? These are unit tests.
> >
> > Agreed.
> >
> > > Having allocations in here makes
> > > things more complicated, whereas it would be simpler to have a pointer
> > > and a spinlock operating on a chunk of memory that gets flushed out
> > > periodically.
> >
> > I am not so sure. I have to have the logic to allocate memory in some
> > case no matter what (what if I need more memory that my preallocated
> > chuck?). I think it is simpler to always request an allocation than to
> > only sometimes request an allocation.
> 
> Another even simpler alternative might be to just allocate memory
> using kunit_kmalloc as we need it and just let the kunit_resource code
> handle cleaning it all up when the test case finishes.

Sure, sounds like a nice way to avoid duplicating similar logic to
maintain a list of things to free later.

> 
> What do you think?

If you go the allocation route then you'll need to have the flags to
know what context you're in to allocate appropriately. Does that mean
all the string operations will now take GFP flags?

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
