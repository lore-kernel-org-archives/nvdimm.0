From: Masahiro Yamada <yamada.masahiro@socionext.com>
Subject: Re: [PATCH v2 06/17] kbuild: enable building KUnit
Date: Fri, 10 May 2019 19:30:24 +0900
Message-ID: <CAK7LNAR3DW5UxtsTNtW6mtQic8cukJwJ18=KitC2HX+jO5eo4g@mail.gmail.com>
References: <20190501230126.229218-1-brendanhiggins@google.com>
 <20190501230126.229218-7-brendanhiggins@google.com> <CAK7LNAQ+SRMn8UFjW1dZv_TrL0qjD2v2S=rXgtUpiA-urr1DDA@mail.gmail.com>
 <CAFd5g47BNZ0gRz4SXb37XjyXF_LyNZrSmoqDbzaaCUrTg3O7Yg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <CAFd5g47BNZ0gRz4SXb37XjyXF_LyNZrSmoqDbzaaCUrTg3O7Yg@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Brendan Higgins <brendanhiggins@google.com>
Cc: Frank Rowand <frowand.list@gmail.com>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Kees Cook <keescook@google.com>, Kieran Bingham <kieran.bingham@ideasonboard.com>, "Luis R. Rodriguez" <mcgrof@kernel.org>, Rob Herring <robh@kernel.org>, Stephen Boyd <sboyd@kernel.org>, "Cc: Shuah Khan" <shuah@kernel.org>, DTML <devicetree@vger.kernel.org>, dri-devel <dri-devel@lists.freedesktop.org>, kunit-dev@googlegroups.com, "open list:DOCUMENTATION" <linux-doc@vger.kernel.org>, linux-fsdevel@vger.kernel.org, Linux Kbuild mailing list <linux-kbuild@vger.kernel.org>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, "open list:KERNEL SELFTEST FRAMEWORK" <linux-kselftest@vger.kernel.org>, linux-nvdimm <linux-nvdimm@lists.01.org>, linux-um@lists.infrad
List-Id: linux-nvdimm@lists.01.org

On Fri, May 10, 2019 at 7:27 PM Brendan Higgins
<brendanhiggins@google.com> wrote:
>
> > On Thu, May 2, 2019 at 8:03 AM Brendan Higgins
> > <brendanhiggins@google.com> wrote:
> > >
> > > Add KUnit to root Kconfig and Makefile allowing it to actually be built.
> > >
> > > Signed-off-by: Brendan Higgins <brendanhiggins@google.com>
> >
> > You need to make sure
> > to not break git-bisect'abililty.
> >
> >
> > With this commit, I see build error.
> >
> >   CC      kunit/test.o
> > kunit/test.c:11:10: fatal error: os.h: No such file or directory
> >  #include <os.h>
> >           ^~~~~~
> > compilation terminated.
> > make[1]: *** [scripts/Makefile.build;279: kunit/test.o] Error 1
> > make: *** [Makefile;1763: kunit/] Error 2
>
> Nice catch! That header shouldn't even be in there.
>
> Sorry about that. I will have it fixed in the next revision.


BTW, I applied whole of this series
to my kernel.org repository.

0day bot started to report issues.
I hope several reports reached you,
and they are useful to fix your code.


-- 
Best Regards
Masahiro Yamada
