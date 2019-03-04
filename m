From: Brendan Higgins <brendanhiggins@google.com>
Subject: Re: [RFC v4 08/17] kunit: test: add support for test abort
Date: Mon, 4 Mar 2019 14:28:05 -0800
Message-ID: <CAFd5g46iqZ6+r9BUzPLSrEmomJQfei=Bb0CH1Tb2ZDr3f1s0jQ@mail.gmail.com>
References: <20190214213729.21702-1-brendanhiggins@google.com>
 <20190214213729.21702-9-brendanhiggins@google.com> <155121334527.260864.5324117081460979741@swboyd.mtv.corp.google.com>
 <CAFd5g46QCisA4PHQXo57-LC6sNdk=OUjBE0O1s4005uBz_Vo6Q@mail.gmail.com> <20190228135403.GD9806@kadam>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20190228135403.GD9806@kadam>
Sender: linux-kernel-owner@vger.kernel.org
To: Dan Carpenter <dan.carpenter@oracle.com>
Cc: Stephen Boyd <sboyd@kernel.org>, Frank Rowand <frowand.list@gmail.com>, Kees Cook <keescook@google.com>, Kieran Bingham <kieran.bingham@ideasonboard.com>, Luis Chamberlain <mcgrof@kernel.org>, Rob Herring <robh@kernel.org>, shuah@kernel.org, Greg KH <gregkh@linuxfoundation.org>, Joel Stanley <joel@jms.id.au>, Michael Ellerman <mpe@ellerman.id.au>, Joe Perches <joe@perches.com>, brakmo@fb.com, Steven Rostedt <rostedt@goodmis.org>, "Bird, Timothy" <Tim.Bird@sony.com>, Kevin Hilman <khilman@baylibre.com>, Julia Lawall <julia.lawall@lip6.fr>, linux-kselftest@vger.kernel.org, kunit-dev@googlegroups.com, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, Jeff Dike <jdike@addtoit.com>, Richard Weinberger <richard@nod.at>, linux-um@lists.infra
List-Id: linux-nvdimm@lists.01.org

On Thu, Feb 28, 2019 at 5:55 AM Dan Carpenter <dan.carpenter@oracle.com> wrote:
>
> On Thu, Feb 28, 2019 at 01:03:24AM -0800, Brendan Higgins wrote:
> > you could do:
> >
> > if (IS_ERR_OR_NULL(ptr)) {
> >         KUNIT_FAIL(test, "ptr is an errno or null: %ld", ptr);
> >         return;
> > }
>
> It's best to not mix error pointers and NULL but when we do mix them,
> it means that NULL is a special kind of success.  Like we try to load
> a feature and we get back:
>
>     valid pointer <-- success
>     null          <-- feature is disabled.  not an error.
>     error pointer <-- feature is broken.  fail.

Thanks for pointing that out! Will fix.
