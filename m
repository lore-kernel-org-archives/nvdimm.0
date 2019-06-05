From: Brendan Higgins <brendanhiggins-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH v4 04/18] kunit: test: add kunit_stream a std::stream like
 logger
Date: Tue, 4 Jun 2019 17:47:48 -0700
Message-ID: <CAFd5g456V4aQUSxxTAizun8ak4zogcAt4-YGgebX2L55Kb-xEg@mail.gmail.com>
References: <20190514221711.248228-1-brendanhiggins@google.com>
 <20190514221711.248228-5-brendanhiggins@google.com>
 <20190517175841.F3396216FD@mail.kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-nvdimm-bounces-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
In-Reply-To: <20190517175841.F3396216FD-+nuXSHJNwjE76Z2rM5mHXA@public.gmane.org>
List-Unsubscribe: <https://lists.01.org/mailman/options/linux-nvdimm>,
 <mailto:linux-nvdimm-request-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org?subject=unsubscribe>
List-Archive: <http://lists.01.org/pipermail/linux-nvdimm/>
List-Post: <mailto:linux-nvdimm-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
List-Help: <mailto:linux-nvdimm-request-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org?subject=help>
List-Subscribe: <https://lists.01.org/mailman/listinfo/linux-nvdimm>,
 <mailto:linux-nvdimm-request-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org?subject=subscribe>
Errors-To: linux-nvdimm-bounces-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org
Sender: "Linux-nvdimm" <linux-nvdimm-bounces-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
To: Stephen Boyd <sboyd-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Petr Mladek <pmladek-IBi9RG/b67k@public.gmane.org>, "open list:DOCUMENTATION" <linux-doc-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Amir Goldstein <amir73il-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, dri-devel <dri-devel-PD4FTy7X32lNgt0PjOBp9y5qC8QIuHrW@public.gmane.org>, Sasha Levin <Alexander.Levin-0li6OtcxBFHby3iVrkZq2A@public.gmane.org>, Masahiro Yamada <yamada.masahiro-uWyLwvC0a2jby3iVrkZq2A@public.gmane.org>, Michael Ellerman <mpe-Gsx/Oe8HsFggBc27wqDAHg@public.gmane.org>, "open list:KERNEL SELFTEST FRAMEWORK" <linux-kselftest-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, shuah <shuah-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Rob Herring <robh-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, linux-nvdimm <linux-nvdimm-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>, Frank Rowand <frowand.list-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Knut Omang <knut.omang-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, Kieran Bingham <kieran.bingham-ryLnwIuWjnjg/C1BVhZhaw@public.gmane.org>, wfg-VuQAYsv1563Yd54FQh9/CA@public.gmane.org, Joel Stanley <joel-U3u1mxZcP9KHXe+LvDLADg@public.gmane.org>, David Rientjes <rientjes-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Jeff Dike <jdike-OPE4K8JWMJJBDgjK7y7TUQ@public.gmane.org>, Dan Carpenter <dan.carpenter-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, devicetree <devicetree-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, linux-kbuild <linux-kbuild-u79uwXL29TasMV2rI37PzA@public.gmane.org>
List-Id: linux-nvdimm@lists.01.org

On Fri, May 17, 2019 at 10:58 AM Stephen Boyd <sboyd-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org> wrote:
>
> Quoting Brendan Higgins (2019-05-14 15:16:57)
> > diff --git a/kunit/kunit-stream.c b/kunit/kunit-stream.c
> > new file mode 100644
> > index 0000000000000..1884f1b550888
> > --- /dev/null
> > +++ b/kunit/kunit-stream.c
> > @@ -0,0 +1,152 @@
> > +// SPDX-License-Identifier: GPL-2.0
> > +/*
> > + * C++ stream style string formatter and printer used in KUnit for outputting
> > + * KUnit messages.
> > + *
> > + * Copyright (C) 2019, Google LLC.
> > + * Author: Brendan Higgins <brendanhiggins-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
> > + */
> > +
> > +#include <kunit/test.h>
> > +#include <kunit/kunit-stream.h>
> > +#include <kunit/string-stream.h>
> > +
> > +static const char *kunit_stream_get_level(struct kunit_stream *this)
> > +{
> > +       unsigned long flags;
> > +       const char *level;
> > +
> > +       spin_lock_irqsave(&this->lock, flags);
> > +       level = this->level;
> > +       spin_unlock_irqrestore(&this->lock, flags);
> > +
> > +       return level;
>
> Please remove this whole function and inline it to the one call-site.
>
> > +}
> > +
> > +void kunit_stream_set_level(struct kunit_stream *this, const char *level)
> > +{
> > +       unsigned long flags;
> > +
> > +       spin_lock_irqsave(&this->lock, flags);
> > +       this->level = level;
> > +       spin_unlock_irqrestore(&this->lock, flags);
>
> I don't get the locking here. What are we protecting against? Are tests
> running in parallel using the same kunit_stream? If so, why is the level
> changeable in one call and then adding strings is done in a different
> function call? It would make sense to combine the level setting and
> string adding so that it's one atomic operation if it's truly a parallel
> operation, or remove the locking entirely.

I think you are right. I am not sure it makes sense for two separate
threads to share a kunit_stream; even if locked properly, it would end
up printing out corrupted text.

In anycase, I think it makes sense to decide the level when the stream
is allocated which would sidestep this issue entirely.

> > +}
> > +
> > +void kunit_stream_add(struct kunit_stream *this, const char *fmt, ...)
> > +{
> > +       va_list args;
> > +       struct string_stream *stream = this->internal_stream;
> > +
> > +       va_start(args, fmt);
> > +
> > +       if (string_stream_vadd(stream, fmt, args) < 0)
> > +               kunit_err(this->test, "Failed to allocate fragment: %s\n", fmt);
> > +
> > +       va_end(args);
> > +}
> > +
> > +void kunit_stream_append(struct kunit_stream *this,
> > +                               struct kunit_stream *other)
> > +{
> > +       struct string_stream *other_stream = other->internal_stream;
> > +       const char *other_content;
> > +
> > +       other_content = string_stream_get_string(other_stream);
> > +
> > +       if (!other_content) {
> > +               kunit_err(this->test,
> > +                         "Failed to get string from second argument for appending.\n");
> > +               return;
> > +       }
> > +
> > +       kunit_stream_add(this, other_content);
> > +}
> > +
> > +void kunit_stream_clear(struct kunit_stream *this)
> > +{
> > +       string_stream_clear(this->internal_stream);
> > +}
> > +
> > +void kunit_stream_commit(struct kunit_stream *this)
>
> Should this be rather called kunit_stream_flush()?

So the intention is that the string in the buffer will not get printed
out until commit is called. In this way, you can build up a message
and then decide not to print it. This is useful when you are parsing
through a lot of data that would be useful in debugging a failing or
broken test, but are not yet sure if it is going to pass or not.

I think flush has the connotation, that you are just forcing the
buffer to get written out now, but that it will happen regardless
eventually, where commit has the correct connotation that you *must*
call it in order to write out the data stored in the buffer.

Seems as though I should probably add this distinction to the
kernel-doc comment.

> > +{
> > +       struct string_stream *stream = this->internal_stream;
> > +       struct string_stream_fragment *fragment;
> > +       const char *level;
> > +       char *buf;
> > +
> > +       level = kunit_stream_get_level(this);
> > +       if (!level) {
> > +               kunit_err(this->test,
> > +                         "Stream was committed without a specified log level.\n");
>
> Drop the full-stop?

Whoops, nice catch. Will fix in next revision.

> > +               level = KERN_ERR;
> > +               kunit_stream_set_level(this, level);
> > +       }
> > +
> > +       buf = string_stream_get_string(stream);
> > +       if (!buf) {
> > +               kunit_err(this->test,
>
> Can you grow a local variable for 'this->test'? It's used many times.

Sure, will fix in next revision.

> Also, 'this' is not very kernel idiomatic. We usually name variables by
> their type instead of 'this' which is a keyword in other languages.
> Perhaps it could be named 'kstream'?

Seems reasonable. Will fix in next revision.

> > +                        "Could not allocate buffer, dumping stream:\n");
> > +               list_for_each_entry(fragment, &stream->fragments, node) {
> > +                       kunit_err(this->test, fragment->fragment);
> > +               }
> > +               kunit_err(this->test, "\n");
> > +               goto cleanup;
> > +       }
> > +
> > +       kunit_printk(level, this->test, buf);
> > +       kfree(buf);
> > +
> > +cleanup:
> > +       kunit_stream_clear(this);
> > +}
> > +
> > +static int kunit_stream_init(struct kunit_resource *res, void *context)
> > +{
> > +       struct kunit *test = context;
> > +       struct kunit_stream *stream;
> > +
> > +       stream = kzalloc(sizeof(*stream), GFP_KERNEL);
>
> Of course, here it's called 'stream', so maybe it should be 'kstream'
> here too.

Will do.

>
> > +       if (!stream)
> > +               return -ENOMEM;
> > +
> > +       res->allocation = stream;
> > +       stream->test = test;
> > +       spin_lock_init(&stream->lock);
> > +       stream->internal_stream = new_string_stream();
>
> Can new_string_stream() be renamed to alloc_string_stream()? Sorry, I
> just see so much C++ isms in here it's hard to read from the kernel
> developer perspective.

No problem. WIll fix in next revision.

> > +
> > +       if (!stream->internal_stream) {
>
> Nitpick: Please join this to the "allocation" event above instead of
> keeping it separated.

Yeah, that's a lot cleaner. Will do.

> > +               kfree(stream);
> > +               return -ENOMEM;
> > +       }
> > +
> > +       return 0;
> > +}
> > +
> > +static void kunit_stream_free(struct kunit_resource *res)
> > +{
> > +       struct kunit_stream *stream = res->allocation;
> > +
> > +       if (!string_stream_is_empty(stream->internal_stream)) {
> > +               kunit_err(stream->test,
> > +                        "End of test case reached with uncommitted stream entries.\n");
> > +               kunit_stream_commit(stream);
> > +       }
> > +
> > +       destroy_string_stream(stream->internal_stream);
> > +       kfree(stream);
> > +}
> > +
> > +struct kunit_stream *kunit_new_stream(struct kunit *test)
> > +{
> > +       struct kunit_resource *res;
> > +
> > +       res = kunit_alloc_resource(test,
> > +                                  kunit_stream_init,
> > +                                  kunit_stream_free,
> > +                                  test);
> > +
> > +       if (res)
> > +               return res->allocation;
> > +       else
> > +               return NULL;
>
> Don't have if (...) return ...; else return ..., just return instead of
> else.

Sorry. Will fix.

Thanks!
