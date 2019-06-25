Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-pl1-f194.google.com (mail-pl1-f194.google.com
 [209.85.214.194])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 5387E2129F11B
 for <linux-nvdimm@lists.01.org>; Tue, 25 Jun 2019 16:03:49 -0700 (PDT)
Received: by mail-pl1-f194.google.com with SMTP id g4so253659plb.5
 for <linux-nvdimm@lists.01.org>; Tue, 25 Jun 2019 16:03:49 -0700 (PDT)
Date: Tue, 25 Jun 2019 23:03:46 +0000
From: Luis Chamberlain <mcgrof@kernel.org>
Subject: Re: [PATCH v5 06/18] kbuild: enable building KUnit
Message-ID: <20190625230346.GR19023@42.do-not-panic.com>
References: <20190617082613.109131-1-brendanhiggins@google.com>
 <20190617082613.109131-7-brendanhiggins@google.com>
 <20190625221318.GO19023@42.do-not-panic.com>
 <CAFd5g448rYqr3PHg0cfoddr70nktkWXcRfJoZHmuPJjTW53YYg@mail.gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <CAFd5g448rYqr3PHg0cfoddr70nktkWXcRfJoZHmuPJjTW53YYg@mail.gmail.com>
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
Cc: Petr Mladek <pmladek@suse.com>, "open list:DOCUMENTATION" <linux-doc@vger.kernel.org>, Peter Zijlstra <peterz@infradead.org>, Amir Goldstein <amir73il@gmail.com>, dri-devel <dri-devel@lists.freedesktop.org>, Sasha Levin <Alexander.Levin@microsoft.com>, Masahiro Yamada <yamada.masahiro@socionext.com>, Michael Ellerman <mpe@ellerman.id.au>, "open list:KERNEL SELFTEST FRAMEWORK" <linux-kselftest@vger.kernel.org>, shuah <shuah@kernel.org>, Rob Herring <robh@kernel.org>, linux-nvdimm <linux-nvdimm@lists.01.org>, Frank Rowand <frowand.list@gmail.com>, Knut Omang <knut.omang@oracle.com>, Kieran Bingham <kieran.bingham@ideasonboard.com>, wfg@linux.intel.com, Joel Stanley <joel@jms.id.au>, David Rientjes <rientjes@google.com>, Jeff Dike <jdike@addtoit.com>, Dan Carpenter <dan.carpenter@oracle.com>, devicetree <devicetree@vger.kernel.org>, linux-kbuild <linux-kbuild@vger.kernel.org>, "Bird, Timothy  <Tim.Bird@sony.com>, linux-um@lists.infradead.org, Steven Rostedt" <rostedt@goodmis.org>, Julia Lawall <julia.lawall@lip6.fr>, Josh Poimboeuf <jpoimboe@redhat.com>, kunit-dev@googlegroups.com, Theodore Ts'o <tytso@mit.edu>, Richard Weinberger <richard@nod.at>, Stephen Boyd <sboyd@kernel.org>, Greg KH <gregkh@linuxfoundation.org>, Randy Dunlap <rdunlap@infradead.org>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, Daniel Vetter <daniel@ffwll.ch>, Kees Cook <keescook@google.com>, linux-fsdevel@vger.kernel.org, Kevin Hilman <khilman@baylibre.com>
List-ID: <linux-nvdimm@lists.01.org>

On Tue, Jun 25, 2019 at 03:41:29PM -0700, Brendan Higgins wrote:
> On Tue, Jun 25, 2019 at 3:13 PM Luis Chamberlain <mcgrof@kernel.org> wrote:
> >
> > On Mon, Jun 17, 2019 at 01:26:01AM -0700, Brendan Higgins wrote:
> > > diff --git a/Kconfig b/Kconfig
> > > index 48a80beab6853..10428501edb78 100644
> > > --- a/Kconfig
> > > +++ b/Kconfig
> > > @@ -30,3 +30,5 @@ source "crypto/Kconfig"
> > >  source "lib/Kconfig"
> > >
> > >  source "lib/Kconfig.debug"
> > > +
> > > +source "kunit/Kconfig"
> >
> > This patch would break compilation as kunit/Kconfig is not introduced. This
> > would would also break bisectability on this commit. This change should
> > either be folded in to the next patch, or just be a separate patch after
> > the next one.
> 
> Maybe my brain isn't working right now, but I am pretty darn sure that
> I introduce kunit/Kconfig in the very first patch of this series.
> Quoting from the change summary from the first commit:

Indeed, my mistake, thanks!

  Luis
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
