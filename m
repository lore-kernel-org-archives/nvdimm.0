Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from cloudserver094114.home.net.pl (cloudserver094114.home.net.pl
 [79.96.170.134]) by ml01.01.org (Postfix) with SMTP id B64861A1F9C
 for <linux-nvdimm@lists.01.org>; Sat, 28 May 2016 05:09:35 -0700 (PDT)
From: "Rafael J. Wysocki" <rjw@rjwysocki.net>
Subject: Re: IS_ERR_VALUE misuses
Date: Sat, 28 May 2016 14:13:07 +0200
Message-ID: <7925824.43sdZ8TD9E@vostro.rjw.lan>
In-Reply-To: <CA+55aFyi8_m0EJGcChe_SW_zzJUTJjPJjhEFbJzEL3gyhFNDLQ@mail.gmail.com>
References: <CA+55aFyi8_m0EJGcChe_SW_zzJUTJjPJjhEFbJzEL3gyhFNDLQ@mail.gmail.com>
MIME-Version: 1.0
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
Cc: Arnd Bergmann <arnd@arndb.de>, "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>, Linux ACPI <linux-acpi@vger.kernel.org>, Lv Zheng <lv.zheng@intel.com>, Len Brown <lenb@kernel.org>
List-ID: <linux-nvdimm@lists.01.org>

On Friday, May 27, 2016 01:15:12 PM Linus Torvalds wrote:
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

Under drivers/acpi/ I could only find IS_ERR_VALUE() in acpi_dbg.c, but
those instances should be removed by the Arnd's patch if I'm not mistaken.

Thanks,
Rafael

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
