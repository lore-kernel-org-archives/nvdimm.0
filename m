Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-pg1-f195.google.com (mail-pg1-f195.google.com
 [209.85.215.195])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 7A32421196839
 for <linux-nvdimm@lists.01.org>; Thu, 29 Nov 2018 19:29:29 -0800 (PST)
Received: by mail-pg1-f195.google.com with SMTP id w6so1872373pgl.6
 for <linux-nvdimm@lists.01.org>; Thu, 29 Nov 2018 19:29:29 -0800 (PST)
Date: Thu, 29 Nov 2018 19:29:24 -0800
From: Luis Chamberlain <mcgrof@kernel.org>
Subject: Re: [RFC v3 03/19] kunit: test: add string_stream a std::stream like
 string builder
Message-ID: <20181130032924.GH18410@garbanzo.do-not-panic.com>
References: <20181128193636.254378-1-brendanhiggins@google.com>
 <20181128193636.254378-4-brendanhiggins@google.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20181128193636.254378-4-brendanhiggins@google.com>
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
To: Brendan Higgins <brendanhiggins@google.com>, Petr Mladek <pmladek@suse.com>
Cc: brakmo@fb.com, dri-devel@lists.freedesktop.org, linux-kselftest@vger.kernel.org, shuah@kernel.org, robh@kernel.org, frowand.list@gmail.com, linux-nvdimm@lists.01.org, richard@nod.at, knut.omang@oracle.com, kieran.bingham@ideasonboard.com, joel@jms.id.au, jdike@addtoit.com, Tim.Bird@sony.com, keescook@google.com, linux-um@lists.infradead.org, rostedt@goodmis.org, julia.lawall@lip6.fr, kunit-dev@googlegroups.com, gregkh@linuxfoundation.org, linux-kernel@vger.kernel.org, daniel@ffwll.ch, mpe@ellerman.id.au, joe@perches.com, khilman@baylibre.com
List-ID: <linux-nvdimm@lists.01.org>

On Wed, Nov 28, 2018 at 11:36:20AM -0800, Brendan Higgins wrote:
> A number of test features need to do pretty complicated string printing
> where it may not be possible to rely on a single preallocated string
> with parameters.
> 
> So provide a library for constructing the string as you go similar to
> C++'s std::string.

Hrm, what's the potential for such thing actually being eventually
generically useful for printk folks, I wonder? Petr?

  Luis

> 
> Signed-off-by: Brendan Higgins <brendanhiggins@google.com>
> ---
>  include/kunit/string-stream.h |  44 ++++++++++
>  kunit/Makefile                |   3 +-
>  kunit/string-stream.c         | 149 ++++++++++++++++++++++++++++++++++
>  3 files changed, 195 insertions(+), 1 deletion(-)
>  create mode 100644 include/kunit/string-stream.h
>  create mode 100644 kunit/string-stream.c
> 
> diff --git a/include/kunit/string-stream.h b/include/kunit/string-stream.h
> new file mode 100644
> index 0000000000000..933ed5740cf07
> --- /dev/null
> +++ b/include/kunit/string-stream.h
> @@ -0,0 +1,44 @@
> +/* SPDX-License-Identifier: GPL-2.0 */
> +/*
> + * C++ stream style string builder used in KUnit for building messages.
> + *
> + * Copyright (C) 2018, Google LLC.
> + * Author: Brendan Higgins <brendanhiggins@google.com>
> + */
> +
> +#ifndef _KUNIT_STRING_STREAM_H
> +#define _KUNIT_STRING_STREAM_H
> +
> +#include <linux/types.h>
> +#include <linux/spinlock.h>
> +#include <linux/kref.h>
> +#include <stdarg.h>
> +
> +struct string_stream_fragment {
> +	struct list_head node;
> +	char *fragment;
> +};
> +
> +struct string_stream {
> +	size_t length;
> +	struct list_head fragments;
> +
> +	/* length and fragments are protected by this lock */
> +	spinlock_t lock;
> +	struct kref refcount;
> +	int (*add)(struct string_stream *this, const char *fmt, ...);
> +	int (*vadd)(struct string_stream *this, const char *fmt, va_list args);
> +	char *(*get_string)(struct string_stream *this);
> +	void (*clear)(struct string_stream *this);
> +	bool (*is_empty)(struct string_stream *this);
> +};
> +
> +struct string_stream *new_string_stream(void);
> +
> +void destroy_string_stream(struct string_stream *stream);
> +
> +void string_stream_get(struct string_stream *stream);
> +
> +int string_stream_put(struct string_stream *stream);
> +
> +#endif /* _KUNIT_STRING_STREAM_H */
> diff --git a/kunit/Makefile b/kunit/Makefile
> index 5efdc4dea2c08..275b565a0e81f 100644
> --- a/kunit/Makefile
> +++ b/kunit/Makefile
> @@ -1 +1,2 @@
> -obj-$(CONFIG_KUNIT) +=			test.o
> +obj-$(CONFIG_KUNIT) +=			test.o \
> +					string-stream.o
> diff --git a/kunit/string-stream.c b/kunit/string-stream.c
> new file mode 100644
> index 0000000000000..1e7efa630cc35
> --- /dev/null
> +++ b/kunit/string-stream.c
> @@ -0,0 +1,149 @@
> +// SPDX-License-Identifier: GPL-2.0
> +/*
> + * C++ stream style string builder used in KUnit for building messages.
> + *
> + * Copyright (C) 2018, Google LLC.
> + * Author: Brendan Higgins <brendanhiggins@google.com>
> + */
> +
> +#include <linux/list.h>
> +#include <linux/slab.h>
> +#include <kunit/string-stream.h>
> +
> +static int string_stream_vadd(struct string_stream *this,
> +			       const char *fmt,
> +			       va_list args)
> +{
> +	struct string_stream_fragment *fragment;
> +	int len;
> +	va_list args_for_counting;
> +	unsigned long flags;
> +
> +	/* Make a copy because `vsnprintf` could change it */
> +	va_copy(args_for_counting, args);
> +
> +	/* Need space for null byte. */
> +	len = vsnprintf(NULL, 0, fmt, args_for_counting) + 1;
> +
> +	va_end(args_for_counting);
> +
> +	fragment = kmalloc(sizeof(*fragment), GFP_KERNEL);
> +	if (!fragment)
> +		return -ENOMEM;
> +
> +	fragment->fragment = kmalloc(len, GFP_KERNEL);
> +	if (!fragment->fragment) {
> +		kfree(fragment);
> +		return -ENOMEM;
> +	}
> +
> +	len = vsnprintf(fragment->fragment, len, fmt, args);
> +	spin_lock_irqsave(&this->lock, flags);
> +	this->length += len;
> +	list_add_tail(&fragment->node, &this->fragments);
> +	spin_unlock_irqrestore(&this->lock, flags);
> +	return 0;
> +}
> +
> +static int string_stream_add(struct string_stream *this, const char *fmt, ...)
> +{
> +	va_list args;
> +	int result;
> +
> +	va_start(args, fmt);
> +	result = string_stream_vadd(this, fmt, args);
> +	va_end(args);
> +	return result;
> +}
> +
> +static void string_stream_clear(struct string_stream *this)
> +{
> +	struct string_stream_fragment *fragment, *fragment_safe;
> +	unsigned long flags;
> +
> +	spin_lock_irqsave(&this->lock, flags);
> +	list_for_each_entry_safe(fragment,
> +				 fragment_safe,
> +				 &this->fragments,
> +				 node) {
> +		list_del(&fragment->node);
> +		kfree(fragment->fragment);
> +		kfree(fragment);
> +	}
> +	this->length = 0;
> +	spin_unlock_irqrestore(&this->lock, flags);
> +}
> +
> +static char *string_stream_get_string(struct string_stream *this)
> +{
> +	struct string_stream_fragment *fragment;
> +	size_t buf_len = this->length + 1; /* +1 for null byte. */
> +	char *buf;
> +	unsigned long flags;
> +
> +	buf = kzalloc(buf_len, GFP_KERNEL);
> +	if (!buf)
> +		return NULL;
> +
> +	spin_lock_irqsave(&this->lock, flags);
> +	list_for_each_entry(fragment, &this->fragments, node)
> +		strlcat(buf, fragment->fragment, buf_len);
> +	spin_unlock_irqrestore(&this->lock, flags);
> +
> +	return buf;
> +}
> +
> +static bool string_stream_is_empty(struct string_stream *this)
> +{
> +	bool is_empty;
> +	unsigned long flags;
> +
> +	spin_lock_irqsave(&this->lock, flags);
> +	is_empty = list_empty(&this->fragments);
> +	spin_unlock_irqrestore(&this->lock, flags);
> +
> +	return is_empty;
> +}
> +
> +void destroy_string_stream(struct string_stream *stream)
> +{
> +	stream->clear(stream);
> +	kfree(stream);
> +}
> +
> +static void string_stream_destroy(struct kref *kref)
> +{
> +	struct string_stream *stream = container_of(kref,
> +						    struct string_stream,
> +						    refcount);
> +	destroy_string_stream(stream);
> +}
> +
> +struct string_stream *new_string_stream(void)
> +{
> +	struct string_stream *stream = kzalloc(sizeof(*stream), GFP_KERNEL);
> +
> +	if (!stream)
> +		return NULL;
> +
> +	INIT_LIST_HEAD(&stream->fragments);
> +	spin_lock_init(&stream->lock);
> +	kref_init(&stream->refcount);
> +	stream->add = string_stream_add;
> +	stream->vadd = string_stream_vadd;
> +	stream->get_string = string_stream_get_string;
> +	stream->clear = string_stream_clear;
> +	stream->is_empty = string_stream_is_empty;
> +	return stream;
> +}
> +
> +void string_stream_get(struct string_stream *stream)
> +{
> +	kref_get(&stream->refcount);
> +}
> +
> +int string_stream_put(struct string_stream *stream)
> +{
> +	return kref_put(&stream->refcount, &string_stream_destroy);
> +}
> +
> -- 
> 2.20.0.rc0.387.gc7a69e6b6c-goog
> 
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
