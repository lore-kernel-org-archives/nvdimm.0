From: Brendan Higgins <brendanhiggins@google.com>
Subject: Re: [PATCH v2 04/17] kunit: test: add kunit_stream a std::stream like logger
Date: Thu, 2 May 2019 22:48:16 -0700
Message-ID: <CAFd5g463PQGn3618Vo2Spu81zzL40jM6Skr1gSWtJqMx7Faj5A@mail.gmail.com>
References: <20190501230126.229218-1-brendanhiggins@google.com>
 <20190501230126.229218-5-brendanhiggins@google.com> <ead23600-eecd-cf74-bdd1-94a6964e29b2@kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <ead23600-eecd-cf74-bdd1-94a6964e29b2@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: shuah <shuah@kernel.org>
Cc: Frank Rowand <frowand.list@gmail.com>, Greg KH <gregkh@linuxfoundation.org>, Kees Cook <keescook@google.com>, Kieran Bingham <kieran.bingham@ideasonboard.com>, Luis Chamberlain <mcgrof@kernel.org>, Rob Herring <robh@kernel.org>, Stephen Boyd <sboyd@kernel.org>, devicetree <devicetree@vger.kernel.org>, dri-devel <dri-devel@lists.freedesktop.org>, kunit-dev@googlegroups.com, linux-doc@vger.kernel.org, linux-fsdevel@vger.kernel.org, linux-kbuild@vger.kernel.org, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, linux-kselftest@vger.kernel.org, linux-nvdimm <linux-nvdimm@lists.01.org>, linux-um@lists.infradead.org, Sasha Levin <Alexander.Levin@microsoft.com>, "Bird, Timothy" <Tim.Bird@sony.com>, Amir Goldstein <amir73il@gmail.com>, Dan
List-Id: linux-nvdimm@lists.01.org

On Thu, May 2, 2019 at 6:50 PM shuah <shuah@kernel.org> wrote:
>
> On 5/1/19 5:01 PM, Brendan Higgins wrote:

< snip >

> > diff --git a/kunit/kunit-stream.c b/kunit/kunit-stream.c
> > new file mode 100644
> > index 0000000000000..93c14eec03844
> > --- /dev/null
> > +++ b/kunit/kunit-stream.c
> > @@ -0,0 +1,149 @@

< snip >

> > +static int kunit_stream_init(struct kunit_resource *res, void *context)
> > +{
> > +     struct kunit *test = context;
> > +     struct kunit_stream *stream;
> > +
> > +     stream = kzalloc(sizeof(*stream), GFP_KERNEL);
> > +     if (!stream)
> > +             return -ENOMEM;
> > +     res->allocation = stream;
> > +     stream->test = test;
> > +     spin_lock_init(&stream->lock);
> > +     stream->internal_stream = new_string_stream();
> > +
> > +     if (!stream->internal_stream)
> > +             return -ENOMEM;
>
> What happens to stream? Don't you want to free that?

Good catch. Will fix in next revision.

< snip >

Cheers
