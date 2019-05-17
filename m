From: Stephen Boyd <sboyd-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH v4 04/18] kunit: test: add kunit_stream a std::stream like
 logger
Date: Fri, 17 May 2019 10:58:41 -0700
Message-ID: <20190517175841.F3396216FD@mail.kernel.org>
References: <20190514221711.248228-1-brendanhiggins@google.com>
 <20190514221711.248228-5-brendanhiggins@google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-nvdimm-bounces-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
In-Reply-To: <20190514221711.248228-5-brendanhiggins-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
List-Unsubscribe: <https://lists.01.org/mailman/options/linux-nvdimm>,
 <mailto:linux-nvdimm-request-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org?subject=unsubscribe>
List-Archive: <http://lists.01.org/pipermail/linux-nvdimm/>
List-Post: <mailto:linux-nvdimm-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
List-Help: <mailto:linux-nvdimm-request-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org?subject=help>
List-Subscribe: <https://lists.01.org/mailman/listinfo/linux-nvdimm>,
 <mailto:linux-nvdimm-request-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org?subject=subscribe>
Errors-To: linux-nvdimm-bounces-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org
Sender: "Linux-nvdimm" <linux-nvdimm-bounces-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
To: frowand.list-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org, jpoimboe-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, keescook-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, kieran.bingham-ryLnwIuWjnjg/C1BVhZhaw@public.gmane.org, mcgrof-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org, robh-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, shuah-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, tytso-3s7WtUTddSA@public.gmane.org, yamada.masahiro-uWyLwvC0a2jby3iVrkZq2A@public.gmane.org
Cc: pmladek-IBi9RG/b67k@public.gmane.org, linux-doc-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, amir73il-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, Brendan Higgins <brendanhiggins-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, dri-devel-PD4FTy7X32lNgt0PjOBp9y5qC8QIuHrW@public.gmane.org, Alexander.Levin-0li6OtcxBFHby3iVrkZq2A@public.gmane.org, linux-kselftest-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-nvdimm-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org, khilman-rdvid1DuHRBWk0Htik3J/w@public.gmane.org, knut.omang-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org, wfg-VuQAYsv1563Yd54FQh9/CA@public.gmane.org, joel-U3u1mxZcP9KHXe+LvDLADg@public.gmane.org, rientjes-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, jdike-OPE4K8JWMJJBDgjK7y7TUQ@public.gmane.org, dan.carpenter-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org, devicetree-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kbuild-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Tim.Bird-7U/KSKJipcs@public.gmane.org, linux-um-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, rostedt-nx8X9YLhiw1AfugRpC6u6w@public.gmane.org, julia.lawall-L2FTfq7BK8M@public.gmane.org, kunit-dev-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org, richard-/L3Ra7n9ekc@public.gmane.org, rdunlap-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, daniel-/w4YWyX8dFk@public.gmane.org, mpe-Gsx/Oe8HsFggBc27wqDAHg@public.gmane.org, linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-nvdimm@lists.01.org

Quoting Brendan Higgins (2019-05-14 15:16:57)
> diff --git a/kunit/kunit-stream.c b/kunit/kunit-stream.c
> new file mode 100644
> index 0000000000000..1884f1b550888
> --- /dev/null
> +++ b/kunit/kunit-stream.c
> @@ -0,0 +1,152 @@
> +// SPDX-License-Identifier: GPL-2.0
> +/*
> + * C++ stream style string formatter and printer used in KUnit for outputting
> + * KUnit messages.
> + *
> + * Copyright (C) 2019, Google LLC.
> + * Author: Brendan Higgins <brendanhiggins-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
> + */
> +
> +#include <kunit/test.h>
> +#include <kunit/kunit-stream.h>
> +#include <kunit/string-stream.h>
> +
> +static const char *kunit_stream_get_level(struct kunit_stream *this)
> +{
> +       unsigned long flags;
> +       const char *level;
> +
> +       spin_lock_irqsave(&this->lock, flags);
> +       level = this->level;
> +       spin_unlock_irqrestore(&this->lock, flags);
> +
> +       return level;

Please remove this whole function and inline it to the one call-site.

> +}
> +
> +void kunit_stream_set_level(struct kunit_stream *this, const char *level)
> +{
> +       unsigned long flags;
> +
> +       spin_lock_irqsave(&this->lock, flags);
> +       this->level = level;
> +       spin_unlock_irqrestore(&this->lock, flags);

I don't get the locking here. What are we protecting against? Are tests
running in parallel using the same kunit_stream? If so, why is the level
changeable in one call and then adding strings is done in a different
function call? It would make sense to combine the level setting and
string adding so that it's one atomic operation if it's truly a parallel
operation, or remove the locking entirely.

> +}
> +
> +void kunit_stream_add(struct kunit_stream *this, const char *fmt, ...)
> +{
> +       va_list args;
> +       struct string_stream *stream = this->internal_stream;
> +
> +       va_start(args, fmt);
> +
> +       if (string_stream_vadd(stream, fmt, args) < 0)
> +               kunit_err(this->test, "Failed to allocate fragment: %s\n", fmt);
> +
> +       va_end(args);
> +}
> +
> +void kunit_stream_append(struct kunit_stream *this,
> +                               struct kunit_stream *other)
> +{
> +       struct string_stream *other_stream = other->internal_stream;
> +       const char *other_content;
> +
> +       other_content = string_stream_get_string(other_stream);
> +
> +       if (!other_content) {
> +               kunit_err(this->test,
> +                         "Failed to get string from second argument for appending.\n");
> +               return;
> +       }
> +
> +       kunit_stream_add(this, other_content);
> +}
> +
> +void kunit_stream_clear(struct kunit_stream *this)
> +{
> +       string_stream_clear(this->internal_stream);
> +}
> +
> +void kunit_stream_commit(struct kunit_stream *this)

Should this be rather called kunit_stream_flush()?

> +{
> +       struct string_stream *stream = this->internal_stream;
> +       struct string_stream_fragment *fragment;
> +       const char *level;
> +       char *buf;
> +
> +       level = kunit_stream_get_level(this);
> +       if (!level) {
> +               kunit_err(this->test,
> +                         "Stream was committed without a specified log level.\n");

Drop the full-stop?

> +               level = KERN_ERR;
> +               kunit_stream_set_level(this, level);
> +       }
> +
> +       buf = string_stream_get_string(stream);
> +       if (!buf) {
> +               kunit_err(this->test,

Can you grow a local variable for 'this->test'? It's used many times.

Also, 'this' is not very kernel idiomatic. We usually name variables by
their type instead of 'this' which is a keyword in other languages.
Perhaps it could be named 'kstream'?

> +                        "Could not allocate buffer, dumping stream:\n");
> +               list_for_each_entry(fragment, &stream->fragments, node) {
> +                       kunit_err(this->test, fragment->fragment);
> +               }
> +               kunit_err(this->test, "\n");
> +               goto cleanup;
> +       }
> +
> +       kunit_printk(level, this->test, buf);
> +       kfree(buf);
> +
> +cleanup:
> +       kunit_stream_clear(this);
> +}
> +
> +static int kunit_stream_init(struct kunit_resource *res, void *context)
> +{
> +       struct kunit *test = context;
> +       struct kunit_stream *stream;
> +
> +       stream = kzalloc(sizeof(*stream), GFP_KERNEL);

Of course, here it's called 'stream', so maybe it should be 'kstream'
here too.

> +       if (!stream)
> +               return -ENOMEM;
> +
> +       res->allocation = stream;
> +       stream->test = test;
> +       spin_lock_init(&stream->lock);
> +       stream->internal_stream = new_string_stream();

Can new_string_stream() be renamed to alloc_string_stream()? Sorry, I
just see so much C++ isms in here it's hard to read from the kernel
developer perspective.

> +
> +       if (!stream->internal_stream) {

Nitpick: Please join this to the "allocation" event above instead of
keeping it separated.

> +               kfree(stream);
> +               return -ENOMEM;
> +       }
> +
> +       return 0;
> +}
> +
> +static void kunit_stream_free(struct kunit_resource *res)
> +{
> +       struct kunit_stream *stream = res->allocation;
> +
> +       if (!string_stream_is_empty(stream->internal_stream)) {
> +               kunit_err(stream->test,
> +                        "End of test case reached with uncommitted stream entries.\n");
> +               kunit_stream_commit(stream);
> +       }
> +
> +       destroy_string_stream(stream->internal_stream);
> +       kfree(stream);
> +}
> +
> +struct kunit_stream *kunit_new_stream(struct kunit *test)
> +{
> +       struct kunit_resource *res;
> +
> +       res = kunit_alloc_resource(test,
> +                                  kunit_stream_init,
> +                                  kunit_stream_free,
> +                                  test);
> +
> +       if (res)
> +               return res->allocation;
> +       else
> +               return NULL;

Don't have if (...) return ...; else return ..., just return instead of
else.
