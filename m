Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-oi0-x235.google.com (mail-oi0-x235.google.com
 [IPv6:2607:f8b0:4003:c06::235])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 105FA1A1F75
 for <linux-nvdimm@lists.01.org>; Fri, 27 May 2016 13:41:14 -0700 (PDT)
Received: by mail-oi0-x235.google.com with SMTP id k23so191530262oih.0
 for <linux-nvdimm@lists.01.org>; Fri, 27 May 2016 13:41:02 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CA+55aFyi8_m0EJGcChe_SW_zzJUTJjPJjhEFbJzEL3gyhFNDLQ@mail.gmail.com>
References: <CA+55aFyi8_m0EJGcChe_SW_zzJUTJjPJjhEFbJzEL3gyhFNDLQ@mail.gmail.com>
Date: Fri, 27 May 2016 13:41:01 -0700
Message-ID: <CAPcyv4hpZENy-bh_4a_fAar3Ufe4g6Fxd2mpazCYn_xQJAwxKg@mail.gmail.com>
Subject: Re: IS_ERR_VALUE misuses
From: Dan Williams <dan.j.williams@intel.com>
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
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Linux ACPI <linux-acpi@vger.kernel.org>, "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>, "Rafael J. Wysocki" <rjw@rjwysocki.net>, Len Brown <lenb@kernel.org>
List-ID: <linux-nvdimm@lists.01.org>

On Fri, May 27, 2016 at 1:15 PM, Linus Torvalds
<torvalds@linux-foundation.org> wrote:
> This is just a heads-up: for some reason the acpi layer and nvdimm use
> the IS_ERR_VALUE() macro, and they use it incorrectly.
>
> To see warnings about it, change the macro from
>
> #define IS_ERR_VALUE(x) unlikely((x) >= (unsigned long)-MAX_ERRNO)
>
> to do a cast to a pointer and back (ie make the "(x)" part be
> "(unsigned long)(void *)(x)" instead, which then will cause warnings
> like
>
>   warning: cast to pointer from integer of different size
> [-Wint-to-pointer-cast]
>
> when passed an "int" argument.
>
> The reason "int" arguments are wrong is that the macro really is
> designed to test the upper range of a pointer value. It happens to
> work for signed integers too, but looking at the users, pretty much
> none of them are right. The ACPI and nvdimm users are all about the
> perfectly standard "zero for success, negative error code for
> failure", and so using
>
>     if (IS_ERROR_VALUE(rc))
>         return rc;
>
> is just plain garbage. The code generally should just do
>
>     if (rc)
>         return rc;
>
> which is simpler, smaller, and generates better code.
>
> This bug seems to have been so common in the power management code
> that we even have a coccinelle script for it. But for some reason
> several uses remain in acpi_debug.c and now there are cases in
> drivers/nvdimm/ too.
>
> There are random various crap cases like that elsewhere too, but acpi
> and nvdimm were just more dense with this bug than most other places.
>
> The bug isn't fatal - as mentioned, IS_ERROR_VALUE() _does_ actually
> work on the range of integers that are normal errors, but it's
> pointless and actively misleading, and it's not meant for that use. So
> it just adds complexity and worse code generation for no actual gain.
>
> I noticed this when I was looking at similar idiocy in fs/gfs2, where
> the code in question caused warnings (for other reasons, but the main
> reason was "code too complex for gcc to understand it")
>

So, I recompiled with that change and didn't see any new warnings.
While "make coccicheck" did point out the following clean up, I did
not see where drivers/nvdimm/ passes anything but a pointer to IS_ERR,
what am I missing?

diff --git a/drivers/nvdimm/claim.c b/drivers/nvdimm/claim.c
index 8b2e3c4fb0ad..9997ff94a132 100644
--- a/drivers/nvdimm/claim.c
+++ b/drivers/nvdimm/claim.c
@@ -266,9 +266,8 @@ int devm_nsio_enable(struct device *dev, struct
nd_namespace_io *nsio)

        nsio->addr = devm_memremap(dev, res->start, resource_size(res),
                        ARCH_MEMREMAP_PMEM);
-       if (IS_ERR(nsio->addr))
-               return PTR_ERR(nsio->addr);
-       return 0;
+
+       return PTR_ERR_OR_ZERO(nsio->addr);
 }
 EXPORT_SYMBOL_GPL(devm_nsio_enable);

diff --git a/include/linux/err.h b/include/linux/err.h
index 56762ab41713..1e3558845e4c 100644
--- a/include/linux/err.h
+++ b/include/linux/err.h
@@ -18,7 +18,7 @@

 #ifndef __ASSEMBLY__

-#define IS_ERR_VALUE(x) unlikely((x) >= (unsigned long)-MAX_ERRNO)
+#define IS_ERR_VALUE(x) unlikely((unsigned long)(void *)(x) >=
(unsigned long)-MAX_ERRNO)

 static inline void * __must_check ERR_PTR(long error)
 {

$ git grep -n IS_ERR drivers/nvdimm/
drivers/nvdimm/blk.c:317:       if (IS_ERR(ndns))
drivers/nvdimm/btt.c:209:       if (IS_ERR_OR_NULL(d))
drivers/nvdimm/btt.c:241:       if (IS_ERR_OR_NULL(btt->debugfs_dir))
drivers/nvdimm/btt.c:1424:      if (IS_ERR_OR_NULL(debugfs_root))
drivers/nvdimm/bus.c:398:       if (IS_ERR(dev)) {
drivers/nvdimm/bus.c:848:       if (IS_ERR(nd_class)) {
drivers/nvdimm/pmem.c:223:              if (IS_ERR(altmap))
drivers/nvdimm/pmem.c:277:      if (IS_ERR(addr))
drivers/nvdimm/pmem.c:318:      if (IS_ERR(ndns))
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
