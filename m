Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id D55722194D3B3
 for <linux-nvdimm@lists.01.org>; Thu,  6 Dec 2018 16:41:59 -0800 (PST)
Received: from mail-qk1-f175.google.com (mail-qk1-f175.google.com
 [209.85.222.175])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by mail.kernel.org (Postfix) with ESMTPSA id 71CA22146F
 for <linux-nvdimm@lists.01.org>; Fri,  7 Dec 2018 00:41:59 +0000 (UTC)
Received: by mail-qk1-f175.google.com with SMTP id a132so1545023qkg.1
 for <linux-nvdimm@lists.01.org>; Thu, 06 Dec 2018 16:41:59 -0800 (PST)
MIME-Version: 1.0
References: <20181128193636.254378-1-brendanhiggins@google.com>
 <20181128193636.254378-18-brendanhiggins@google.com>
 <CAL_Jsq+09Kx7yMBC_Jw45QGmk6U_fp4N6HOZDwYrM4tWw+_dOA@mail.gmail.com>
 <18814973-8f0a-4647-a097-fcc3dc0b3cd3@infradead.org>
 <CAFd5g475RK9v9X4qxmXwuHiPMOs05WrZAw6EJWNdVoAHQWguFQ@mail.gmail.com>
 <CAL_JsqL_PivQbrJFEusdKAy-2EQtKL3OHbmyYSK9bzuTOQegqA@mail.gmail.com>
 <CAFd5g45-HGytAPTx7OQD8B0oAdLncDGSMMTyHCTtyobeUJ15AQ@mail.gmail.com>
In-Reply-To: <CAFd5g45-HGytAPTx7OQD8B0oAdLncDGSMMTyHCTtyobeUJ15AQ@mail.gmail.com>
From: Rob Herring <robh@kernel.org>
Date: Thu, 6 Dec 2018 18:41:46 -0600
Message-ID: <CAL_JsqKvsCNk5oz-f9-G2TsKbfvO=9HO+-+QfOMz_xEAN8TJJg@mail.gmail.com>
Subject: Re: [RFC v3 17/19] of: unittest: migrate tests to run on KUnit
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
Cc: brakmo@fb.com, dri-devel <dri-devel@lists.freedesktop.org>, linux-kselftest@vger.kernel.org, shuah@kernel.org, Frank Rowand <frowand.list@gmail.com>, linux-nvdimm <linux-nvdimm@lists.01.org>, Richard Weinberger <richard@nod.at>, knut.omang@oracle.com, Kieran Bingham <kieran.bingham@ideasonboard.com>, Joel Stanley <joel@jms.id.au>, Jeff Dike <jdike@addtoit.com>, "Bird," Timothy" <Tim.Bird@sony.com>, Kees Cook <keescook@google.com>," linux-um@lists.infradead.org, Steven Rostedt <rostedt@goodmis.org>, Julia Lawall <julia.lawall@lip6.fr>, kunit-dev@googlegroups.com, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Randy Dunlap <rdunlap@infradead.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "Luis R. Rodriguez" <mcgrof@kernel.org>, Daniel Vetter <daniel@ffwll.ch>, Michael Ellerman <mpe@ellerman.id.au>, Joe Perches <joe@perches.com>, Kevin Hilman <khilman@baylibre.com>
List-ID: <linux-nvdimm@lists.01.org>

On Wed, Dec 5, 2018 at 5:43 PM Brendan Higgins
<brendanhiggins@google.com> wrote:
>
> On Tue, Dec 4, 2018 at 5:41 AM Rob Herring <robh@kernel.org> wrote:
> >
> > On Mon, Dec 3, 2018 at 6:14 PM Brendan Higgins
> > <brendanhiggins@google.com> wrote:
> > >
> > > On Thu, Nov 29, 2018 at 4:40 PM Randy Dunlap <rdunlap@infradead.org> wrote:
> > > >
> > > > On 11/28/18 12:56 PM, Rob Herring wrote:
> > > > >> diff --git a/drivers/of/Kconfig b/drivers/of/Kconfig
> > > > >> index ad3fcad4d75b8..f309399deac20 100644
> > > > >> --- a/drivers/of/Kconfig
> > > > >> +++ b/drivers/of/Kconfig
> > > > >> @@ -15,6 +15,7 @@ if OF
> > > > >>  config OF_UNITTEST
> > > > >>         bool "Device Tree runtime unit tests"
> > > > >>         depends on !SPARC
> > > > >> +       depends on KUNIT
> > > > > Unless KUNIT has depends, better to be a select here.
> > > >
> > > > That's just style or taste.  I would prefer to use depends
> > > > instead of select, but that's also just my preference.
> > >
> > > I prefer depends too, but Rob is the maintainer here.
> >
> > Well, we should be consistent, not the follow the whims of each maintainer.
>
> Sorry, I don't think that came out the way I meant it. I don't really
> think we are consistent on this point across the kernel, and I don't
> feel very strongly about the point, so I was just looking to follow
> the path of least resistance. (I also just assumed Rob would keep us
> consistent within drivers/of/.)

I meant across unittests, we should be consistent. All unittests do
either "depends on KUNIT" or "select KUNIT". The question I would ask
is does KUNIT need to be user visible or is useful to enable without
any unittests enabled? With depends, a user has 2 options to go enable
vs. 1 with select.

But if you want a global kill switch to turn off all unittests, then
depends works better.

> I figure if we are running unit tests from the test runner script or
> from an automated system, you won't be hunting for dependencies for a
> single test every time you want to run a test, so select doesn't make
> it easier to configure in most imagined use cases.
>
> KUNIT hypothetically should not depend on anything, so select should
> be safe to use.
>
> On the other hand, if we end up being wrong on this point and KUnit
> gains widespread adoption, I would prefer not to be in a position
> where I have to change a bunch of configs all over the kernel because
> this example got copied and pasted.

You'll be so happy that 100s of tests have been created using kunit,
it won't be a big deal. :)

In any case, I wouldn't spend more time on this.

Rob
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
