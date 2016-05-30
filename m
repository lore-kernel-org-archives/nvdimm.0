Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga14.intel.com (mga14.intel.com [192.55.52.115])
 by ml01.01.org (Postfix) with ESMTP id 1F2CD1A1E8F
 for <linux-nvdimm@lists.01.org>; Sun, 29 May 2016 18:01:44 -0700 (PDT)
From: "Zheng, Lv" <lv.zheng@intel.com>
Subject: RE: IS_ERR_VALUE misuses
Date: Mon, 30 May 2016 01:01:27 +0000
Message-ID: <1AE640813FDE7649BE1B193DEA596E883BBB48BB@SHSMSX101.ccr.corp.intel.com>
References: <CA+55aFyi8_m0EJGcChe_SW_zzJUTJjPJjhEFbJzEL3gyhFNDLQ@mail.gmail.com>
 <7925824.43sdZ8TD9E@vostro.rjw.lan>
 <CA+55aFwh79PohObOo4Y0=ZpK=Enhv+vQvQMOm+bvWnqv7-Zv=Q@mail.gmail.com>
In-Reply-To: <CA+55aFwh79PohObOo4Y0=ZpK=Enhv+vQvQMOm+bvWnqv7-Zv=Q@mail.gmail.com>
Content-Language: en-US
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
To: Linus Torvalds <torvalds@linux-foundation.org>, "Rafael J. Wysocki" <rjw@rjwysocki.net>, Arnd Bergmann <arnd@arndb.de>
Cc: Linux ACPI <linux-acpi@vger.kernel.org>, "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>, Len Brown <lenb@kernel.org>
List-ID: <linux-nvdimm@lists.01.org>

Hi, Rafael, Linus, Arnd

The instances in drivers/acpi/acpi_dbg.c were made by me.
Sorry for the issue and thanks for fixing it for me.

Best regards
-Lv

> From: linus971@gmail.com [mailto:linus971@gmail.com] On Behalf Of
> Linus Torvalds
> Subject: Re: IS_ERR_VALUE misuses
> 
> On Sat, May 28, 2016 at 5:13 AM, Rafael J. Wysocki <rjw@rjwysocki.net>
> wrote:
> >
> > Under drivers/acpi/ I could only find IS_ERR_VALUE() in acpi_dbg.c, but
> > those instances should be removed by the Arnd's patch if I'm not
> mistaken.
> 
> Yes, I only saw that Arnd had a patch for this and asked him to just
> send it to me after I had already looked at this and sent the email
> out..
> 
> The acpi/nvdimm misuses are gone now, although other suspect uses of
> that macro do remain..
> 
>            Linus
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
