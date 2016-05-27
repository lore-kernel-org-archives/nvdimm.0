Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-io0-x22d.google.com (mail-io0-x22d.google.com
 [IPv6:2607:f8b0:4001:c06::22d])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id C70011A1F5C
 for <linux-nvdimm@lists.01.org>; Fri, 27 May 2016 13:15:24 -0700 (PDT)
Received: by mail-io0-x22d.google.com with SMTP id t40so78630689ioi.0
 for <linux-nvdimm@lists.01.org>; Fri, 27 May 2016 13:15:12 -0700 (PDT)
MIME-Version: 1.0
Date: Fri, 27 May 2016 13:15:12 -0700
Message-ID: <CA+55aFyi8_m0EJGcChe_SW_zzJUTJjPJjhEFbJzEL3gyhFNDLQ@mail.gmail.com>
Subject: IS_ERR_VALUE misuses
From: Linus Torvalds <torvalds@linux-foundation.org>
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
To: Dan Williams <dan.j.williams@intel.com>, "Rafael J. Wysocki" <rjw@rjwysocki.net>, Len Brown <lenb@kernel.org>
Cc: Linux ACPI <linux-acpi@vger.kernel.org>, "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>
List-ID: <linux-nvdimm@lists.01.org>

This is just a heads-up: for some reason the acpi layer and nvdimm use
the IS_ERR_VALUE() macro, and they use it incorrectly.

To see warnings about it, change the macro from

#define IS_ERR_VALUE(x) unlikely((x) >= (unsigned long)-MAX_ERRNO)

to do a cast to a pointer and back (ie make the "(x)" part be
"(unsigned long)(void *)(x)" instead, which then will cause warnings
like

  warning: cast to pointer from integer of different size
[-Wint-to-pointer-cast]

when passed an "int" argument.

The reason "int" arguments are wrong is that the macro really is
designed to test the upper range of a pointer value. It happens to
work for signed integers too, but looking at the users, pretty much
none of them are right. The ACPI and nvdimm users are all about the
perfectly standard "zero for success, negative error code for
failure", and so using

    if (IS_ERROR_VALUE(rc))
        return rc;

is just plain garbage. The code generally should just do

    if (rc)
        return rc;

which is simpler, smaller, and generates better code.

This bug seems to have been so common in the power management code
that we even have a coccinelle script for it. But for some reason
several uses remain in acpi_debug.c and now there are cases in
drivers/nvdimm/ too.

There are random various crap cases like that elsewhere too, but acpi
and nvdimm were just more dense with this bug than most other places.

The bug isn't fatal - as mentioned, IS_ERROR_VALUE() _does_ actually
work on the range of integers that are normal errors, but it's
pointless and actively misleading, and it's not meant for that use. So
it just adds complexity and worse code generation for no actual gain.

I noticed this when I was looking at similar idiocy in fs/gfs2, where
the code in question caused warnings (for other reasons, but the main
reason was "code too complex for gcc to understand it")

               Linus
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
