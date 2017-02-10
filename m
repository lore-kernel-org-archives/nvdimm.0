Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-ot0-x231.google.com (mail-ot0-x231.google.com
 [IPv6:2607:f8b0:4003:c0f::231])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id C5AE681F68
 for <linux-nvdimm@lists.01.org>; Thu,  9 Feb 2017 18:02:02 -0800 (PST)
Received: by mail-ot0-x231.google.com with SMTP id 65so17942297otq.2
 for <linux-nvdimm@lists.01.org>; Thu, 09 Feb 2017 18:02:02 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <2062963119.1995548.1486669514254@mail.yahoo.com>
References: <2062963119.1995548.1486669514254.ref@mail.yahoo.com>
 <2062963119.1995548.1486669514254@mail.yahoo.com>
From: Dan Williams <dan.j.williams@intel.com>
Date: Thu, 9 Feb 2017 18:02:01 -0800
Message-ID: <CAPcyv4h37bX0yE8Ns921HLT0CJcW28EOf3hVVVtwwZHickgiQw@mail.gmail.com>
Subject: Re: How is a Region format interface codec used in NFIT/PEME/BLK/BTT
 driver?
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
To: Soccer Liu <soccer_liu@yahoo.com>
Cc: "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>
List-ID: <linux-nvdimm@lists.01.org>

On Thu, Feb 9, 2017 at 11:45 AM, Soccer Liu <soccer_liu@yahoo.com> wrote:
> Hi:
>
>   I am trying to figure out what changes might be needed in the NVDIMM driver set for adding a new  Region format interface code.
> After some researching, I found the following constants were defined in the NFIT header file but never really got referenced in the driver code. (It's used in the test code)
> 64 #define NFIT_FIC_BYTE cpu_to_le16(0x101) /* byte-addressable energy backed */
>  65 #define NFIT_FIC_BLK cpu_to_le16(0x201) /* block-addressable non-energy backed */
>  66 #define NFIT_FIC_BYTEN cpu_to_le16(0x301) /* byte-addressable non-energy backed */
>
> Am I missing anything?

No, you're not missing anything. Linux simply doesn't care about the
format interface code and instead relies on the "Address Range Type
GUID" from the "System Physical Address (SPA) Range Structure" in the
NFIT. In other words Linux does not differentiate support for 0x101
and 0x301 because in both cases we end up with a "Byte Addressable
Persistent Memory (PM) Region" in the NFIT. We also don't care about
NFIT_FIC_BLK because that code is redundant with the definition of
block windows in the NFIT.
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
