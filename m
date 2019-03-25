Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-ot1-x344.google.com (mail-ot1-x344.google.com
 [IPv6:2607:f8b0:4864:20::344])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id E0A202194EB7D
 for <linux-nvdimm@lists.01.org>; Mon, 25 Mar 2019 15:15:57 -0700 (PDT)
Received: by mail-ot1-x344.google.com with SMTP id e5so9582126otk.12
 for <linux-nvdimm@lists.01.org>; Mon, 25 Mar 2019 15:15:57 -0700 (PDT)
MIME-Version: 1.0
References: <20181128193636.254378-1-brendanhiggins@google.com>
 <20181128193636.254378-19-brendanhiggins@google.com>
 <990bfc7d-dc5e-d8d3-c151-9b321ff2ac10@gmail.com>
 <CAFd5g45tOGgf_sKGYRC=fpnTBKGaG=8frbQdgZ3ZTkQFyTfP5A@mail.gmail.com>
 <88fe0546-7850-5bb4-9673-b1aef2dccb3e@gmail.com>
 <CAFd5g444f-FBq4x3U7BL-EY+bFxP0rsJhJ14=mjOi89PhMkURg@mail.gmail.com>
 <0e311e88-c4d4-e98d-1720-53a04bd526fc@gmail.com>
 <CAFd5g44NTZoSAJPMvXP2xvJgn7m5QoV-KJu2AMrr67+eL+CKrQ@mail.gmail.com>
 <d9f7e000-4cac-a35a-3ff9-60130e12ebea@gmail.com>
 <72cd1c5b-6f68-73ad-c8fd-f3a3268a0529@gmail.com>
 <CAFd5g46UU9wk+F6A5wnKYYtYKmmtv__SaY8eg6v-T9xUjsoxhA@mail.gmail.com>
 <bb5bcd3d-a09a-cfbe-c7fa-16e5eb75b0e4@gmail.com>
 <CAFd5g448xQLOJwVYU5Zmu4+OPWuboiWZPhBvK6au8Pgm5B9haQ@mail.gmail.com>
 <bf094685-3f2a-dc7b-7291-0340136b87f3@gmail.com>
In-Reply-To: <bf094685-3f2a-dc7b-7291-0340136b87f3@gmail.com>
From: Brendan Higgins <brendanhiggins@google.com>
Date: Mon, 25 Mar 2019 15:15:45 -0700
Message-ID: <CAFd5g46tpL8KaqKnAEWNRSBWpYMcptu1Eig+nEzq9HX7DF1YUA@mail.gmail.com>
Subject: Re: [RFC v3 18/19] of: unittest: split out a couple of test cases
 from unittest
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
To: Frank Rowand <frowand.list@gmail.com>
Cc: brakmo@fb.com, dri-devel <dri-devel@lists.freedesktop.org>, linux-kselftest@vger.kernel.org, shuah@kernel.org, Rob Herring <robh@kernel.org>, linux-nvdimm <linux-nvdimm@lists.01.org>, Richard Weinberger <richard@nod.at>, Knut Omang <knut.omang@oracle.com>, Kieran Bingham <kieran.bingham@ideasonboard.com>, Joel Stanley <joel@jms.id.au>, Jeff Dike <jdike@addtoit.com>, "Bird," Timothy" <Tim.Bird@sony.com>, Kees Cook <keescook@google.com>," linux-um@lists.infradead.org, Steven Rostedt <rostedt@goodmis.org>, Julia Lawall <julia.lawall@lip6.fr>, kunit-dev@googlegroups.com, Greg KH <gregkh@linuxfoundation.org>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, Luis Chamberlain <mcgrof@kernel.org>, Daniel Vetter <daniel@ffwll.ch>, Michael Ellerman <mpe@ellerman.id.au>, Joe Perches <joe@perches.com>, Kevin Hilman <khilman@baylibre.com>
List-ID: <linux-nvdimm@lists.01.org>

On Thu, Mar 21, 2019 at 6:47 PM Frank Rowand <frowand.list@gmail.com> wrote:
>
> On 3/21/19 6:30 PM, Brendan Higgins wrote:
> > On Thu, Mar 21, 2019 at 5:22 PM Frank Rowand <frowand.list@gmail.com> wrote:
> >>
> >> On 2/27/19 7:52 PM, Brendan Higgins wrote:
>
> < snip >  but thanks for the comments in the snipped section.
>
>
> >>
> >> Thanks for leaving 18/19 and 19/19 off in v4.
> >
> > Sure, no problem. It was pretty clear that it was a waste of both of
> > our times to continue discussing those at this juncture. :-)
> >
> > Do you still want me to try to convert the DT not-exactly-unittest to
> > KUnit? I would kind of prefer (I don't feel *super* strongly about the
> > matter) we don't call it that since I was intending for it to be the
> > flagship initial example, but I certainly don't mind trying to clean
> > this patch up to get it up to snuff. It's really just a question of
> > whether it is worth it to you.
>
> In the long term, if KUnit is adopted by the kernel, then I think it
> probably makes sense for devicetree unittest to convert from using
> our own unittest() function to report an individual test pass/fail
> to instead use something like KUNIT_EXPECT_*() to provide more
> consistent test messages to test frameworks.  That is assuming
> KUNIT_EXPECT_*() provides comparable functionality.  I still have
> not looked into that question since the converted tests (patch 15/17
> in v4) still does not execute without throwing internal errors.

Sounds good.

>
> If that conversion occurred, I would also avoid the ASSERTs.

Noted.
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
