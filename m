From: Stephen Boyd <sboyd@kernel.org>
Subject: Re: [PATCH v9 04/18] kunit: test: add kunit_stream a std::stream like logger
Date: Mon, 15 Jul 2019 15:15:53 -0700
Message-ID: <20190715221554.8417320665@mail.kernel.org>
References: <20190712081744.87097-1-brendanhiggins@google.com> <20190712081744.87097-5-brendanhiggins@google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20190712081744.87097-5-brendanhiggins@google.com>
Sender: linux-kernel-owner@vger.kernel.org
To: frowand.list@gmail.com, gregkh@linuxfoundation.org, jpoimboe@redhat.com, keescook@google.com, kieran.bingham@ideasonboard.com, mcgrof@kernel.org, peterz@infradead.org, robh@kernel.org, shuah@kernel.org, tytso@mit.edu, yamada.masahiro@socionext.com
Cc: devicetree@vger.kernel.org, dri-devel@lists.freedesktop.org, kunit-dev@googlegroups.com, linux-doc@vger.kernel.org, linux-fsdevel@vger.kernel.org, linux-kbuild@vger.kernel.org, linux-kernel@vger.kernel.org, linux-kselftest@vger.kernel.org, linux-nvdimm@lists.01.org, linux-um@lists.infradead.org, Alexander.Levin@microsoft.com, Tim.Bird@sony.com, amir73il@gmail.com, dan.carpenter@oracle.com, daniel@ffwll.ch, jdike@addtoit.com, joel@jms.id.au, julia.lawall@lip6.fr, khilman@baylibre.com, knut.omang@oracle.com, logang@deltatee.com, mpe@ellerman.id.au, pmladek@suse.com, rdunlap@infradead.org, richard@nod.at, rientjes@google.com, rostedt@goodmis.org, wfg@linux.intel.com, Brendan Higgins <brendanhiggins@google.com>
List-Id: linux-nvdimm@lists.01.org

Quoting Brendan Higgins (2019-07-12 01:17:30)
> diff --git a/include/kunit/kunit-stream.h b/include/kunit/kunit-stream.h
> new file mode 100644
> index 0000000000000..a7b53eabf6be4
> --- /dev/null
> +++ b/include/kunit/kunit-stream.h
> @@ -0,0 +1,81 @@
> +/* SPDX-License-Identifier: GPL-2.0 */
> +/*
> + * C++ stream style string formatter and printer used in KUnit for outpu=
tting
> + * KUnit messages.
> + *
> + * Copyright (C) 2019, Google LLC.
> + * Author: Brendan Higgins <brendanhiggins@google.com>
> + */
> +
> +#ifndef _KUNIT_KUNIT_STREAM_H
> +#define _KUNIT_KUNIT_STREAM_H
> +
> +#include <linux/types.h>
> +#include <kunit/string-stream.h>
> +
> +struct kunit;
> +
> +/**
> + * struct kunit_stream - a std::stream style string builder.
> + *
> + * A std::stream style string builder. Allows messages to be built up and
> + * printed all at once.
> + */
> +struct kunit_stream {
> +       /* private: internal use only. */
> +       struct kunit *test;
> +       const char *level;

Is the level changed? See my comment below, but I wonder if this whole
struct can go away and the wrappers can just operate on 'struct
string_stream' instead.

> +       struct string_stream *internal_stream;
> +};
> diff --git a/kunit/kunit-stream.c b/kunit/kunit-stream.c
> new file mode 100644
> index 0000000000000..8bea1f22eafb5
> --- /dev/null
> +++ b/kunit/kunit-stream.c
> @@ -0,0 +1,123 @@
> +// SPDX-License-Identifier: GPL-2.0
> +/*
> + * C++ stream style string formatter and printer used in KUnit for outpu=
tting
> + * KUnit messages.
> + *
> + * Copyright (C) 2019, Google LLC.
> + * Author: Brendan Higgins <brendanhiggins@google.com>
> + */
> +
> +#include <kunit/test.h>
> +#include <kunit/kunit-stream.h>
> +#include <kunit/string-stream.h>
> +
> +void kunit_stream_add(struct kunit_stream *kstream, const char *fmt, ...)
> +{
> +       va_list args;
> +       struct string_stream *stream =3D kstream->internal_stream;
> +
> +       va_start(args, fmt);
> +
> +       if (string_stream_vadd(stream, fmt, args) < 0)
> +               kunit_err(kstream->test,
> +                         "Failed to allocate fragment: %s\n",
> +                         fmt);
> +
> +       va_end(args);
> +}
> +
> +void kunit_stream_append(struct kunit_stream *kstream,
> +                               struct kunit_stream *other)
> +{
> +       struct string_stream *other_stream =3D other->internal_stream;
> +       const char *other_content;
> +
> +       other_content =3D string_stream_get_string(other_stream);
> +
> +       if (!other_content) {
> +               kunit_err(kstream->test,
> +                         "Failed to get string from second argument for =
appending\n");
> +               return;
> +       }
> +
> +       kunit_stream_add(kstream, other_content);
> +}

Why can't this function be implemented in the string_stream API? Seems
valid to want to append one stream to another and that isn't
kunit_stream specific.

> +
> +void kunit_stream_clear(struct kunit_stream *kstream)
> +{
> +       string_stream_clear(kstream->internal_stream);
> +}
> +
> +void kunit_stream_commit(struct kunit_stream *kstream)
> +{
> +       struct string_stream *stream =3D kstream->internal_stream;
> +       struct string_stream_fragment *fragment;
> +       struct kunit *test =3D kstream->test;
> +       char *buf;
> +
> +       buf =3D string_stream_get_string(stream);
> +       if (!buf) {
> +               kunit_err(test,
> +                         "Could not allocate buffer, dumping stream:\n");
> +               list_for_each_entry(fragment, &stream->fragments, node) {
> +                       kunit_err(test, fragment->fragment);
> +               }
> +               kunit_err(test, "\n");
> +               goto cleanup;
> +       }
> +
> +       kunit_printk(kstream->level, test, buf);
> +       kfree(buf);
> +
> +cleanup:

Drop the goto and use an 'else' please.

> +       kunit_stream_clear(kstream);
> +}
> +
> +static int kunit_stream_init(struct kunit_resource *res, void *context)
> +{
> +       struct kunit *test =3D context;
> +       struct kunit_stream *stream;
> +
> +       stream =3D kzalloc(sizeof(*stream), GFP_KERNEL);
> +       if (!stream)
> +               return -ENOMEM;
> +
> +       res->allocation =3D stream;
> +       stream->test =3D test;
> +       stream->internal_stream =3D alloc_string_stream(test);
> +
> +       if (!stream->internal_stream)
> +               return -ENOMEM;
> +
> +       return 0;
> +}
> +
> +static void kunit_stream_free(struct kunit_resource *res)
> +{
> +       struct kunit_stream *stream =3D res->allocation;
> +
> +       if (!string_stream_is_empty(stream->internal_stream)) {
> +               kunit_err(stream->test,
> +                         "End of test case reached with uncommitted stre=
am entries\n");
> +               kunit_stream_commit(stream);
> +       }
> +}
> +

Nitpick: Drop this extra newline.

> diff --git a/kunit/test.c b/kunit/test.c
> index f165c9d8e10b0..29edf34a89a37 100644
> --- a/kunit/test.c
> +++ b/kunit/test.c
> @@ -120,6 +120,12 @@ static void kunit_print_test_case_ok_not_ok(struct k=
unit_case *test_case,
>                               test_case->name);
>  }
> =20
> +void kunit_fail(struct kunit *test, struct kunit_stream *stream)

Why doesn't 'struct kunit' have a 'struct kunit_stream' inside of it? It
seems that the two are highly related, to the point that it might just
make sense to have

	struct kunit {
		struct kunit_stream stream;
		...
	};

> +{
> +       kunit_set_failure(test);
> +       kunit_stream_commit(stream);

And then this function can just take a test and the stream can be
associated with the test directly. Use container_of() to get to the test
when the only pointer in hand is for the stream too.

> +}
> +
>  void kunit_init_test(struct kunit *test, const char *name)
>  {
>         mutex_init(&test->lock);
