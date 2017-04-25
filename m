Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from ZenIV.linux.org.uk (zeniv.linux.org.uk [195.92.253.2])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 249002195408B
 for <linux-nvdimm@lists.01.org>; Mon, 24 Apr 2017 18:22:50 -0700 (PDT)
Date: Tue, 25 Apr 2017 02:22:30 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
Subject: [NAK] copy_from_iter_ops()
Message-ID: <20170425012230.GX29622@ZenIV.linux.org.uk>
MIME-Version: 1.0
Content-Disposition: inline
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
To: Dan Williams <dan.j.williams@intel.com>
Cc: Jan Kara <jack@suse.cz>, Matthew Wilcox <mawilcox@microsoft.com>, linux-nvdimm@lists.01.org, Linus Torvalds <torvalds@linux-foundation.org>, Christoph Hellwig <hch@lst.de>
List-ID: <linux-nvdimm@lists.01.org>

	I should have looked and commented earlier, but I hadn't spotted
that thing until -next conflicts had shown up.  As the matter of fact,
I don't have this series in my mailbox - it had been Cc'd my way, apparently,
but it looks like it never made it there, so I'm posting from scratch instead
of replying.  Sorry.

	The following "primitive" is complete crap

+#ifdef CONFIG_COPY_FROM_ITER_OPS
+size_t copy_from_iter_ops(void *addr, size_t bytes, struct iov_iter *i,
+               int (*user)(void *, const void __user *, unsigned),
+               void (*page)(char *, struct page *, size_t, size_t),
+               void (*copy)(void *, void *, unsigned))
+{
+       char *to = addr;
+
+       if (unlikely(i->type & ITER_PIPE)) {
+               WARN_ON(1);
+               return 0;
+       }
+       iterate_and_advance(i, bytes, v,
+               user((to += v.iov_len) - v.iov_len, v.iov_base,
+                                v.iov_len),
+               page((to += v.bv_len) - v.bv_len, v.bv_page, v.bv_offset,
+                               v.bv_len),
+               copy((to += v.iov_len) - v.iov_len, v.iov_base, v.iov_len)
+       )
+
+       return bytes;
+}
+EXPORT_SYMBOL_GPL(copy_from_iter_ops);
+#endif

	1) Every time we get a new copy-from flavour of iov_iter, you will
need an extra argument and every caller will need to be updated.

	2) If it's a general-purpose primitive, it should *not* be
behind a CONFIG_<whatever> to be selected by callers.  If it isn't,
it shouldn't be there at all, period.  And no, EXPORT_SYMBOL_GPL doesn't
make it any better.

	3) The caller makes very little sense.  Is that thing meant to
be x86-only?  What are the requirements regarding writeback?  Is that thing
just go-fast stripes, or...?  Basically, all questions asked back in Decemeber
thread (memcpy_nocache()) still apply.

	I strongly object to that interface.  Let's figure out what's
really needed for your copy_from_iter_pmem() and bloody put the
iterator-related part (without the callbacks, etc.) into lib/iov_iter.c
With memcpy_to_pmem() and pmem_from_user() used by it.

	Incidentally, your fallback for memcpy_to_pmem() is... odd.
It used to be "just use memcpy()" and now it's "just do nothing".  What
the hell?  If it's really "you should not use that if you don't have
arch-specific variant", let it at least BUG(), if not fail to link.

	On the uaccess side, should pmem_from_user() zero what it had failed
to copy?  And for !@#!@# sake, comments like this
+        * On x86_64 __copy_from_user_nocache() uses non-temporal stores
+        * for the bulk of the transfer, but we need to manually flush
+        * if the transfer is unaligned. A cached memory copy is used
+        * when destination or size is not naturally aligned. That is:
+        *   - Require 8-byte alignment when size is 8 bytes or larger.
+        *   - Require 4-byte alignment when size is 4 bytes.
mean only one thing: this should live in arch/x86/lib/usercopy_64.c,
right next to the actual function that does copying.  NOT in
drivers/nvdimm/x86.c.  At the very least it needs a comment in usercopy_64.c
with dire warnings along the lines of "don't touch that code without
looking into <filename>:pmem_from_user()"...
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
