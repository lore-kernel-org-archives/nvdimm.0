Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 4C7BD208D6133
 for <linux-nvdimm@lists.01.org>; Wed, 20 Feb 2019 14:03:54 -0800 (PST)
MIME-Version: 1.0
Subject: Re: [RFC v4 10/17] kunit: test: add test managed resource tests
Message-ID: <155070023383.77512.8827935805798619870@swboyd.mtv.corp.google.com>
References: <20190214213729.21702-1-brendanhiggins@google.com>
 <20190214213729.21702-11-brendanhiggins@google.com>
 <155026408761.115909.17855438744578437385@swboyd.mtv.corp.google.com>
 <CAFd5g44Dizk-VsFOmGn++E0d40sZmH6V+j05Eu6zUXaBj1xfcA@mail.gmail.com>
From: Stephen Boyd <sboyd@kernel.org>
In-Reply-To: <CAFd5g44Dizk-VsFOmGn++E0d40sZmH6V+j05Eu6zUXaBj1xfcA@mail.gmail.com>
Date: Wed, 20 Feb 2019 14:03:53 -0800
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
Cc: brakmo@fb.com, amir73il@gmail.com, dri-devel <dri-devel@lists.freedesktop.org>, Sasha Levin <Alexander.Levin@microsoft.com>, linux-kselftest@vger.kernel.org, Frank Rowand <frowand.list@gmail.com>, Rob Herring <robh@kernel.org>, linux-nvdimm <linux-nvdimm@lists.01.org>, Richard Weinberger <richard@nod.at>, Knut Omang <knut.omang@oracle.com>, Kieran Bingham <kieran.bingham@ideasonboard.com>, wfg@linux.intel.com, Joel Stanley <joel@jms.id.au>, Jeff Dike <jdike@addtoit.com>, dan.carpenter@oracle.com, devicetree <devicetree@vger.kernel.org>, shuah@kernel.org, "Bird, Timothy" <Tim.Bird@sony.com>, Kees Cook <keescook@google.com>, linux-um@lists.infradead.org, Steven Rostedt <rostedt@goodmis.org>, Julia Lawall <julia.lawall@lip6.fr>, kunit-dev@googlegroups.com, om@ml01.01.org, Petr Mladek <pmladek@suse.c>, Greg KH <gregkh@linuxfoundation.org>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, Luis Chamberlain <mcgrof@kernel.org>, Avinash Kondareddy <avikr@google.com>, Daniel Vetter <daniel@ffwll.ch>, Michael Ellerman <mpe@ellerman.id.au>, Joe Perches <joe@perches.com>, Kevin Hilman <khilman@baylibre.com>
List-ID: <linux-nvdimm@lists.01.org>

Quoting Brendan Higgins (2019-02-19 15:20:18)
> On Fri, Feb 15, 2019 at 12:54 PM Stephen Boyd <sboyd@kernel.org> wrote:
> >
> > Quoting Brendan Higgins (2019-02-14 13:37:22)
> > > +
> > > +static struct kunit_case kunit_resource_test_cases[] = {
> >
> > Can these arrays be const?
> 
> There is some private mutable state inside of `struct kunit_case` that
> would be kind of annoying to pull out; I don't think it would make it
> cleaner.

Fair enough. Thanks for checking.

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
