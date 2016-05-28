Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-oi0-x22e.google.com (mail-oi0-x22e.google.com
 [IPv6:2607:f8b0:4003:c06::22e])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 6B9871A1FB7
 for <linux-nvdimm@lists.01.org>; Sat, 28 May 2016 12:15:20 -0700 (PDT)
Received: by mail-oi0-x22e.google.com with SMTP id k23so219855745oih.0
 for <linux-nvdimm@lists.01.org>; Sat, 28 May 2016 12:15:07 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <7925824.43sdZ8TD9E@vostro.rjw.lan>
References: <CA+55aFyi8_m0EJGcChe_SW_zzJUTJjPJjhEFbJzEL3gyhFNDLQ@mail.gmail.com>
 <7925824.43sdZ8TD9E@vostro.rjw.lan>
Date: Sat, 28 May 2016 12:15:06 -0700
Message-ID: <CA+55aFwh79PohObOo4Y0=ZpK=Enhv+vQvQMOm+bvWnqv7-Zv=Q@mail.gmail.com>
Subject: Re: IS_ERR_VALUE misuses
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
To: "Rafael J. Wysocki" <rjw@rjwysocki.net>
Cc: Arnd Bergmann <arnd@arndb.de>, "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>, Linux ACPI <linux-acpi@vger.kernel.org>, Lv Zheng <lv.zheng@intel.com>, Len Brown <lenb@kernel.org>
List-ID: <linux-nvdimm@lists.01.org>

On Sat, May 28, 2016 at 5:13 AM, Rafael J. Wysocki <rjw@rjwysocki.net> wrote:
>
> Under drivers/acpi/ I could only find IS_ERR_VALUE() in acpi_dbg.c, but
> those instances should be removed by the Arnd's patch if I'm not mistaken.

Yes, I only saw that Arnd had a patch for this and asked him to just
send it to me after I had already looked at this and sent the email
out..

The acpi/nvdimm misuses are gone now, although other suspect uses of
that macro do remain..

           Linus
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
