Received: from camel.birch.relay.mailchannels.net (camel.birch.relay.mailchannels.net [23.83.209.29])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 691566AC0
	for <nvdimm@lists.linux.dev>; Wed, 13 Jul 2022 23:11:45 +0000 (UTC)
X-Sender-Id: dreamhost|x-authsender|dave@stgolabs.net
Received: from relay.mailchannels.net (localhost [127.0.0.1])
	by relay.mailchannels.net (Postfix) with ESMTP id 6CBE780288C;
	Wed, 13 Jul 2022 19:45:07 +0000 (UTC)
Received: from pdx1-sub0-mail-a228.dreamhost.com (unknown [127.0.0.6])
	(Authenticated sender: dreamhost)
	by relay.mailchannels.net (Postfix) with ESMTPA id 9E74080287F;
	Wed, 13 Jul 2022 19:45:06 +0000 (UTC)
ARC-Seal: i=1; s=arc-2022; d=mailchannels.net; t=1657741506; a=rsa-sha256;
	cv=none;
	b=oonhxDV/XBMU0ojUnPyUj4KotO0VeAnL6uj6bEbBdIDScbKzewWNzaXd6+w9gT1WHoCdzA
	0NFP9/++oXKwkCb6sY9wPd4+CuykWfOumB8S7AygI0M+qhMuABVRavMbZ5YRSw6DqrbJRU
	kNipMADNqDpzB7nj/3SALEXFud1cQWv11xACcbtd6UVMShdsBuINIhc9/usewvntxztWKC
	ErX3UKd5kSfSBgVjC2SkqeqdlFjXPOm7AlVNzVVjgxJh5cb/Rf8fM+bkLF/RXzQnotmwFS
	23MFCxQt2Uei5UD1PWBIbTRmQLpaPErlh9aP+Qe0pwWyJiPEO/wrO3afGo1soQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed;
 d=mailchannels.net;
	s=arc-2022; t=1657741506;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=BKJcAKAYgFFVR6R7YJ7Ru2So7qdtScj5Iynl6u8/l74=;
	b=UdF9ww+3oZgJe3Dy/yQuauf1L1nzQo1ejZvemByE1pFKVj4pCK7XBJIvX0z62+klArcsZ2
	+QHHSa0j9+NxwayLam8vs8cthsOYnsIJLZO9GC/Ho7SMpStHHHXmCcmbfH9jjUzWzFFmH/
	3WXEEXbp84UYJ6D2qI8OiLN8RCZGpC1JK7UzruFvduf3qLGx+SMs/EQ1ctNbMuo1jxfF9h
	px42XNqkZHzfU/uIZv2E8/MqHzDGdycSNQEsUhn7NNMCgKm8EbiNc/ppU/IEurSkkbGhhp
	/HahXZZXHqNKbx0tp52KXJ+oxD9msTuDZhdXIvYBswGaUw/ob3U+PW7bMs2DGA==
ARC-Authentication-Results: i=1;
	rspamd-674ffb986c-8f98r;
	auth=pass smtp.auth=dreamhost smtp.mailfrom=dave@stgolabs.net
X-Sender-Id: dreamhost|x-authsender|dave@stgolabs.net
X-MC-Relay: Neutral
X-MailChannels-SenderId: dreamhost|x-authsender|dave@stgolabs.net
X-MailChannels-Auth-Id: dreamhost
X-Little-Scare: 7b9626277bcd6936_1657741507064_527217136
X-MC-Loop-Signature: 1657741507064:692732304
X-MC-Ingress-Time: 1657741507063
Received: from pdx1-sub0-mail-a228.dreamhost.com (pop.dreamhost.com
 [64.90.62.162])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384)
	by 100.124.238.78 (trex/6.7.1);
	Wed, 13 Jul 2022 19:45:07 +0000
Received: from offworld (unknown [104.36.25.13])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: dave@stgolabs.net)
	by pdx1-sub0-mail-a228.dreamhost.com (Postfix) with ESMTPSA id 4Ljp4K6tdLz7v;
	Wed, 13 Jul 2022 12:45:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=stgolabs.net;
	s=dreamhost; t=1657741506;
	bh=BKJcAKAYgFFVR6R7YJ7Ru2So7qdtScj5Iynl6u8/l74=;
	h=Date:From:To:Cc:Subject:Content-Type;
	b=DNNVpLAQXeUiB04foAifoOjPeXersukz3c7ACyy/NP025SmnBo95rm20rvrPY7F7x
	 +Pk5gd72KX4YnpSomWGrW/XwPz2ILfXabgE2p/5VbNY1DL6nqNakerD+dSIx2ko7EP
	 +1UhS+9V39dh1/9wThTGIwFkxsZ1QFmNlJAoqIt/gvlkox8R5nfV1MHDspOF33F0M1
	 yCAEsvwyXSAiCmItuo9qSlvDGHdUJohcbOQXOpVLg5dRO/bqS6scttwPqk3Z64PQMB
	 g9W6WwalEFVb1gDjPAVDS3Ra2MrotOjlzjqIE0Jnej/giWr9gxtGb8USimrg7mNZhu
	 cXgiOwfIngtsA==
Date: Wed, 13 Jul 2022 12:45:02 -0700
From: Davidlohr Bueso <dave@stgolabs.net>
To: Dan Williams <dan.j.williams@intel.com>
Cc: vishal.l.verma@intel.com, alison.schofield@intel.com,
	nvdimm@lists.linux.dev, linux-cxl@vger.kernel.org,
	a.manzanares@samsung.com
Subject: Re: [PATCH 5/11] cxl/lib: Maintain decoders in id order
Message-ID: <20220713194502.5hxf5jxpwzvsukx7@offworld>
References: <165765284365.435671.13173937566404931163.stgit@dwillia2-xfh>
 <165765287277.435671.14320322485572083484.stgit@dwillia2-xfh>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <165765287277.435671.14320322485572083484.stgit@dwillia2-xfh>
User-Agent: NeoMutt/20220429

On Tue, 12 Jul 2022, Dan Williams wrote:

>Given that decoder instance order is fundamental to the DPA translation
>sequence for endpoint decoders, enforce that cxl_decoder_for_each() returns
>decoders in instance order. Otherwise, they show up in readddir() order
>which is not predictable.
>
>Add a list_add_sorted() to generically handle inserting into a sorted list.

With the already available list_add_before ccan code nit already pointed out
by Ira.

Reviewed-by: Davidlohr Bueso <dave@stgolabs.net>

>
>Signed-off-by: Dan Williams <dan.j.williams@intel.com>
>---
> cxl/lib/libcxl.c |    8 ++++++-
> util/list.h      |   61 ++++++++++++++++++++++++++++++++++++++++++++++++++++++
> 2 files changed, 68 insertions(+), 1 deletion(-)
>
>diff --git a/cxl/lib/libcxl.c b/cxl/lib/libcxl.c
>index f36edcfc735a..e4c5d3819e88 100644
>--- a/cxl/lib/libcxl.c
>+++ b/cxl/lib/libcxl.c
>@@ -19,6 +19,7 @@
> #include <ccan/short_types/short_types.h>
>
> #include <util/log.h>
>+#include <util/list.h>
> #include <util/size.h>
> #include <util/sysfs.h>
> #include <util/bitmap.h>
>@@ -908,6 +909,11 @@ cxl_endpoint_get_memdev(struct cxl_endpoint *endpoint)
> 	return NULL;
> }
>
>+static int decoder_id_cmp(struct cxl_decoder *d1, struct cxl_decoder *d2)
>+{
>+	return d1->id - d2->id;
>+}
>+
> static void *add_cxl_decoder(void *parent, int id, const char *cxldecoder_base)
> {
> 	const char *devname = devpath_to_devname(cxldecoder_base);
>@@ -1049,7 +1055,7 @@ static void *add_cxl_decoder(void *parent, int id, const char *cxldecoder_base)
> 			return decoder_dup;
> 		}
>
>-	list_add(&port->decoders, &decoder->list);
>+	list_add_sorted(&port->decoders, decoder, list, decoder_id_cmp);
>
> 	free(path);
> 	return decoder;
>diff --git a/util/list.h b/util/list.h
>index 1ea9c59b9f0c..c6584e3ec725 100644
>--- a/util/list.h
>+++ b/util/list.h
>@@ -37,4 +37,65 @@ static inline void list_add_after_(struct list_head *h,
> 	(void)list_debug(h, abortstr);
> }
>
>+/**
>+ * list_add_before - add an entry before the given node in the linked list.
>+ * @h: the list_head to add the node to
>+ * @l: the list_node before which to add to
>+ * @n: the list_node to add to the list.
>+ *
>+ * The list_node does not need to be initialized; it will be overwritten.
>+ * Example:
>+ *	struct child *child = malloc(sizeof(*child));
>+ *
>+ *	child->name = "geoffrey";
>+ *	list_add_before(&parent->children, &child1->list, &child->list);
>+ *	parent->num_children++;
>+ */
>+#define list_add_before(h, l, n) list_add_before_(h, l, n, LIST_LOC)
>+static inline void list_add_before_(struct list_head *h, struct list_node *l,
>+				    struct list_node *n, const char *abortstr)
>+{
>+	if (l->prev == &h->n) {
>+		/* l is the first element, this becomes a list_add */
>+		list_add(h, n);
>+		return;
>+	}
>+
>+	n->next = l;
>+	n->prev = l->prev;
>+	l->prev->next = n;
>+	l->prev = n;
>+}
>+
>+#define list_add_sorted(head, n, node, cmp)                                    \
>+	do {                                                                   \
>+		struct list_head *__head = (head);                             \
>+		typeof(n) __iter, __next;                                      \
>+		typeof(n) __new = (n);                                         \
>+                                                                               \
>+		if (list_empty(__head)) {                                      \
>+			list_add(__head, &__new->node);                        \
>+			break;                                                 \
>+		}                                                              \
>+                                                                               \
>+		list_for_each (__head, __iter, node) {                         \
>+			if (cmp(__new, __iter) < 0) {                          \
>+				list_add_before(__head, &__iter->node,         \
>+						&__new->node);                 \
>+				break;                                         \
>+			}                                                      \
>+			__next = list_next(__head, __iter, node);              \
>+			if (!__next) {                                         \
>+				list_add_after(__head, &__iter->node,          \
>+					       &__new->node);                  \
>+				break;                                         \
>+			}                                                      \
>+			if (cmp(__new, __next) < 0) {                          \
>+				list_add_before(__head, &__next->node,         \
>+						&__new->node);                 \
>+				break;                                         \
>+			}                                                      \
>+		}                                                              \
>+	} while (0)
>+
> #endif /* _NDCTL_LIST_H_ */
>
