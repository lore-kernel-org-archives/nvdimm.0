From: shuah <shuah-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH v2 03/17] kunit: test: add string_stream a std::stream
 like string builder
Date: Thu, 2 May 2019 19:26:35 -0600
Message-ID: <1befe456-d981-d726-44f9-ebe3702ee51d@kernel.org>
References: <20190501230126.229218-1-brendanhiggins@google.com>
 <20190501230126.229218-4-brendanhiggins@google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Content-Transfer-Encoding: 7bit
Return-path: <linux-nvdimm-bounces-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
In-Reply-To: <20190501230126.229218-4-brendanhiggins-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Content-Language: en-US
List-Unsubscribe: <https://lists.01.org/mailman/options/linux-nvdimm>,
 <mailto:linux-nvdimm-request-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org?subject=unsubscribe>
List-Archive: <http://lists.01.org/pipermail/linux-nvdimm/>
List-Post: <mailto:linux-nvdimm-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
List-Help: <mailto:linux-nvdimm-request-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org?subject=help>
List-Subscribe: <https://lists.01.org/mailman/listinfo/linux-nvdimm>,
 <mailto:linux-nvdimm-request-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org?subject=subscribe>
Errors-To: linux-nvdimm-bounces-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org
Sender: "Linux-nvdimm" <linux-nvdimm-bounces-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
To: Brendan Higgins <brendanhiggins-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, frowand.list-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org, keescook-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, kieran.bingham-ryLnwIuWjnjg/C1BVhZhaw@public.gmane.org, mcgrof-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, robh-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, sboyd-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org
Cc: pmladek-IBi9RG/b67k@public.gmane.org, linux-doc-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, amir73il-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, dri-devel-PD4FTy7X32lNgt0PjOBp9y5qC8QIuHrW@public.gmane.org, Alexander.Levin-0li6OtcxBFHby3iVrkZq2A@public.gmane.org, linux-kselftest-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-nvdimm-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org, khilman-rdvid1DuHRBWk0Htik3J/w@public.gmane.org, knut.omang-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org, wfg-VuQAYsv1563Yd54FQh9/CA@public.gmane.org, joel-U3u1mxZcP9KHXe+LvDLADg@public.gmane.org, rientjes-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, jdike-OPE4K8JWMJJBDgjK7y7TUQ@public.gmane.org, dan.carpenter-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org, devicetree-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kbuild-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Tim.Bird-7U/KSKJipcs@public.gmane.org, linux-um-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, rostedt-nx8X9YLhiw1AfugRpC6u6w@public.gmane.org, julia.lawall-L2FTfq7BK8M@public.gmane.org, skhan-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org, kunit-dev-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org, richard-/L3Ra7n9ekc@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, daniel-/w4YWyX8dFk@public.gmane.org, mpe-Gsx/Oe8HsFggBc27wqDAHg@public.gmane.org, linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-nvdimm@lists.01.org

On 5/1/19 5:01 PM, Brendan Higgins wrote:
> A number of test features need to do pretty complicated string printing
> where it may not be possible to rely on a single preallocated string
> with parameters.
> 
> So provide a library for constructing the string as you go similar to
> C++'s std::string.
> 
> Signed-off-by: Brendan Higgins <brendanhiggins-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
> ---
>   include/kunit/string-stream.h |  51 ++++++++++++
>   kunit/Makefile                |   3 +-
>   kunit/string-stream.c         | 144 ++++++++++++++++++++++++++++++++++
>   3 files changed, 197 insertions(+), 1 deletion(-)
>   create mode 100644 include/kunit/string-stream.h
>   create mode 100644 kunit/string-stream.c
> 
> diff --git a/include/kunit/string-stream.h b/include/kunit/string-stream.h
> new file mode 100644
> index 0000000000000..567a4629406da
> --- /dev/null
> +++ b/include/kunit/string-stream.h
> @@ -0,0 +1,51 @@
> +/* SPDX-License-Identifier: GPL-2.0 */
> +/*
> + * C++ stream style string builder used in KUnit for building messages.
> + *
> + * Copyright (C) 2019, Google LLC.
> + * Author: Brendan Higgins <brendanhiggins-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
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
> +int string_stream_add(struct string_stream *this, const char *fmt, ...);
> +
> +int string_stream_vadd(struct string_stream *this,
> +		       const char *fmt,
> +		       va_list args);
> +
> +char *string_stream_get_string(struct string_stream *this);
> +
> +void string_stream_clear(struct string_stream *this);
> +
> +bool string_stream_is_empty(struct string_stream *this);
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
> index 0000000000000..7018194ecf2fa
> --- /dev/null
> +++ b/kunit/string-stream.c
> @@ -0,0 +1,144 @@
> +// SPDX-License-Identifier: GPL-2.0
> +/*
> + * C++ stream style string builder used in KUnit for building messages.
> + *
> + * Copyright (C) 2019, Google LLC.
> + * Author: Brendan Higgins <brendanhiggins-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
> + */
> +
> +#include <linux/list.h>
> +#include <linux/slab.h>
> +#include <kunit/string-stream.h>
> +
> +int string_stream_vadd(struct string_stream *this,
> +		       const char *fmt,
> +		       va_list args)
> +{
> +	struct string_stream_fragment *fragment;

Since there is field with the same name, please use a different
name. Using the same name for the struct which contains a field
of the same name get very confusing and will hard to maintain
the code.

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

This is confusing. See above comment.


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
> +int string_stream_add(struct string_stream *this, const char *fmt, ...)
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
> +void string_stream_clear(struct string_stream *this)
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

This is what git me down the road of checking the structure
name to begin with. :)

> +	}
> +	this->length = 0;
> +	spin_unlock_irqrestore(&this->lock, flags);
> +}
> +
> +char *string_stream_get_string(struct string_stream *this)
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
> +bool string_stream_is_empty(struct string_stream *this)
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
> +	string_stream_clear(stream);
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
> 

thanks,
-- Shuah
