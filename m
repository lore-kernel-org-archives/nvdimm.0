Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-pg1-f194.google.com (mail-pg1-f194.google.com
 [209.85.215.194])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 713F821962301
 for <linux-nvdimm@lists.01.org>; Fri, 30 Nov 2018 10:22:09 -0800 (PST)
Received: by mail-pg1-f194.google.com with SMTP id 17so2855661pgg.1
 for <linux-nvdimm@lists.01.org>; Fri, 30 Nov 2018 10:22:09 -0800 (PST)
Date: Fri, 30 Nov 2018 10:22:03 -0800
From: Luis Chamberlain <mcgrof@kernel.org>
Subject: Re: [RFC v3 06/19] arch: um: enable running kunit from User Mode Linux
Message-ID: <20181130182203.GS18410@garbanzo.do-not-panic.com>
References: <20181128193636.254378-1-brendanhiggins@google.com>
 <20181128193636.254378-7-brendanhiggins@google.com>
 <CAL_JsqJLNSg-38hej8LV+Oh-YXBM2hRGomie3b_psa9LvzoRYg@mail.gmail.com>
 <20181130033704.GL18410@garbanzo.do-not-panic.com>
 <CAL_Jsq+jxHHmT5bLnABnF7S0fSBZvH72nDPyY5LHTn9Zm9hCUw@mail.gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <CAL_Jsq+jxHHmT5bLnABnF7S0fSBZvH72nDPyY5LHTn9Zm9hCUw@mail.gmail.com>
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
To: Rob Herring <robh@kernel.org>, Arnd Bergmann <arnd@arndb.de>
Cc: brakmo@fb.com, Brendan Higgins <brendanhiggins@google.com>, dri-devel <dri-devel@lists.freedesktop.org>, linux-kselftest@vger.kernel.org, shuah@kernel.org, Frank Rowand <frowand.list@gmail.com>, linux-nvdimm <linux-nvdimm@lists.01.org>, Richard Weinberger <richard@nod.at>, knut.omang@oracle.com, Kieran Bingham <kieran.bingham@ideasonboard.com>, Joel Stanley <joel@jms.id.au>, "Bird, Timothy" <Tim.Bird@sony.com>, Jeff Dike <jdike@addtoit.com>, Kees Cook <keescook@google.com>, linux-um@lists.infradead.org, Steven Rostedt <rostedt@goodmis.org>, Julia Lawall <julia.lawall@lip6.fr>, kunit-dev@googlegroups.com, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, Daniel Vetter <daniel@ffwll.ch>, Michael Ellerman <mpe@ellerman.id.au>, Joe Perches <joe@perches.com>, Kevin Hilman <khilman@baylibre.com>
List-ID: <linux-nvdimm@lists.01.org>

On Fri, Nov 30, 2018 at 08:05:34AM -0600, Rob Herring wrote:
> On Thu, Nov 29, 2018 at 9:37 PM Luis Chamberlain <mcgrof@kernel.org> wrote:
> >
> > On Wed, Nov 28, 2018 at 03:26:03PM -0600, Rob Herring wrote:
> > > On Wed, Nov 28, 2018 at 1:37 PM Brendan Higgins
> > > <brendanhiggins@google.com> wrote:
> > > >
> > > > Make minimum number of changes outside of the KUnit directories for
> > > > KUnit to build and run using UML.
> > >
> > > There's nothing in this patch limiting this to UML.
> >
> > Not that one, but the abort thing segv thing is, eventually.
> > To support other architectures we'd need to make a wrapper to that
> > hack which Brendan added, and then allow each os to implement
> > its own call, and add an asm-generic helper.
> 
> I've not looked into why this is needed, but can't you make the abort
> support optional and arches can select it when they support it.

Its why I have asked for it to be properly documented. The patches in no
way illustrate *why* such thing is done. And if we are going to
potentially have other archs do something similar best to make it
explicit.

> At
> least before, the DT unittests didn't need this to run and shouldn't
> depend on it after converting to kunit.

  Luis
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
