Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 0DA642119175F
 for <linux-nvdimm@lists.01.org>; Tue,  4 Dec 2018 05:41:11 -0800 (PST)
Received: from mail-qt1-f179.google.com (mail-qt1-f179.google.com
 [209.85.160.179])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by mail.kernel.org (Postfix) with ESMTPSA id 61D872081B
 for <linux-nvdimm@lists.01.org>; Tue,  4 Dec 2018 13:41:11 +0000 (UTC)
Received: by mail-qt1-f179.google.com with SMTP id y20so17971000qtm.13
 for <linux-nvdimm@lists.01.org>; Tue, 04 Dec 2018 05:41:11 -0800 (PST)
MIME-Version: 1.0
References: <20181128193636.254378-1-brendanhiggins@google.com>
 <20181128193636.254378-18-brendanhiggins@google.com>
 <CAL_Jsq+09Kx7yMBC_Jw45QGmk6U_fp4N6HOZDwYrM4tWw+_dOA@mail.gmail.com>
 <18814973-8f0a-4647-a097-fcc3dc0b3cd3@infradead.org>
 <CAFd5g475RK9v9X4qxmXwuHiPMOs05WrZAw6EJWNdVoAHQWguFQ@mail.gmail.com>
In-Reply-To: <CAFd5g475RK9v9X4qxmXwuHiPMOs05WrZAw6EJWNdVoAHQWguFQ@mail.gmail.com>
From: Rob Herring <robh@kernel.org>
Date: Tue, 4 Dec 2018 07:40:57 -0600
Message-ID: <CAL_JsqL_PivQbrJFEusdKAy-2EQtKL3OHbmyYSK9bzuTOQegqA@mail.gmail.com>
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

On Mon, Dec 3, 2018 at 6:14 PM Brendan Higgins
<brendanhiggins@google.com> wrote:
>
> On Thu, Nov 29, 2018 at 4:40 PM Randy Dunlap <rdunlap@infradead.org> wrote:
> >
> > On 11/28/18 12:56 PM, Rob Herring wrote:
> > >> diff --git a/drivers/of/Kconfig b/drivers/of/Kconfig
> > >> index ad3fcad4d75b8..f309399deac20 100644
> > >> --- a/drivers/of/Kconfig
> > >> +++ b/drivers/of/Kconfig
> > >> @@ -15,6 +15,7 @@ if OF
> > >>  config OF_UNITTEST
> > >>         bool "Device Tree runtime unit tests"
> > >>         depends on !SPARC
> > >> +       depends on KUNIT
> > > Unless KUNIT has depends, better to be a select here.
> >
> > That's just style or taste.  I would prefer to use depends
> > instead of select, but that's also just my preference.
>
> I prefer depends too, but Rob is the maintainer here.

Well, we should be consistent, not the follow the whims of each maintainer.

Rob
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
