Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-yw0-x22b.google.com (mail-yw0-x22b.google.com
 [IPv6:2607:f8b0:4002:c05::22b])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id CD3142095D2C1
 for <linux-nvdimm@lists.01.org>; Mon, 10 Jul 2017 16:58:36 -0700 (PDT)
Received: by mail-yw0-x22b.google.com with SMTP id x125so42660111ywa.0
 for <linux-nvdimm@lists.01.org>; Mon, 10 Jul 2017 17:00:22 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20170627102851.15484-3-oohall@gmail.com>
References: <20170627102851.15484-1-oohall@gmail.com>
 <20170627102851.15484-3-oohall@gmail.com>
From: Dan Williams <dan.j.williams@intel.com>
Date: Mon, 10 Jul 2017 17:00:20 -0700
Message-ID: <CAPcyv4j_gJy5xVwF3fAYeKTUQwSVGRu_6um5xvjbVs7nEp1J2w@mail.gmail.com>
Subject: Re: [RFC 3/4] powerpc: Add pmem API support
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
To: Oliver O'Halloran <oohall@gmail.com>
Cc: linuxppc-dev <linuxppc-dev@lists.ozlabs.org>, "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>
List-ID: <linux-nvdimm@lists.01.org>

On Tue, Jun 27, 2017 at 3:28 AM, Oliver O'Halloran <oohall@gmail.com> wrote:
> Adds powerpc64 implementations of:
>
>         memcpy_flushcache()
>         arch_wb_cache_pmem()
>         arch_invalidate_pmem()
>
> Which form the architecture-specific portition of the persistent memory
> API. These functions provide cache-management primitives for the DAX
> drivers and libNVDIMM.
>

Ok, now that we have commit 0aed55af8834 "x86, uaccess: introduce
copy_from_iter_flushcache for pmem / cache-bypass operations" upstream
that changes the model for how an architecture advertises
pmem-specific cache management routines. CONFIG_ARCH_HAS_PMEM_API
causes the pmem driver to try to link to these helpers rather than
dummy fallbacks:

    arch_wb_cache_pmem
    arch_invalidate_pmem

....and CONFIG_ARCH_HAS_UACCESS_FLUSHCACHE indicates that the arch has
all the needed "flushcache" apis:

    __copy_from_user_flushcache
    memcpy_page_flushcache
    memcpy_flushcache
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
