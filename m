Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-yw0-x22c.google.com (mail-yw0-x22c.google.com
 [IPv6:2607:f8b0:4002:c05::22c])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 0D3C121CB031D
 for <linux-nvdimm@lists.01.org>; Thu, 20 Jul 2017 06:01:00 -0700 (PDT)
Received: by mail-yw0-x22c.google.com with SMTP id x125so12630075ywa.0
 for <linux-nvdimm@lists.01.org>; Thu, 20 Jul 2017 06:02:56 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <840966580.1026784.1500509061384@mail.yahoo.com>
References: <840966580.1026784.1500509061384.ref@mail.yahoo.com>
 <840966580.1026784.1500509061384@mail.yahoo.com>
From: Dan Williams <dan.j.williams@intel.com>
Date: Thu, 20 Jul 2017 06:02:54 -0700
Message-ID: <CAPcyv4juhhxZN9b1yVnFjboJUNMXJzLL8k5yf-+GXNE+aj86kw@mail.gmail.com>
Subject: Re: Persistent Memory type vs Reserved Memory type
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

On Wed, Jul 19, 2017 at 5:04 PM, Soccer Liu <soccer_liu@yahoo.com> wrote:
> Hi:
>    I am trying to debug an issue related to  my private built kernel's (4.11 from upstream with ACPI/NFIT/NVDIMM enabled) interaction with a persistent memory device's type.
> We have a way to emulate a software based NVDIMM device into a guest, which is running my private built kernel. When the host set this emulated NVDIMM device as Reserved type, I was able to see a pmem0 block device exposed and everything seems to function correctly.however, when it's exposed as a Persistent Memory type, the kernel does not boot and it has a black screen and no usefully logging could help root cause this.
>   My questions are:
>  1. Is this a known issue for 4.11? 2. Is there any patches NIFT/NVDIMM beyond 4.11 that's needed to get Persistent Memory type supported? 3. In this case, is there anyway to debug this further?

When you say Persistent Memory Type, which type are you referring. The
spec compliant one is E820-type-7 or EFI- type-15. Linux also
understands E820-type-12 which went upstream before the official types
were defined.

E820-Type-12 is the problematic one, the others are equivalent to
Reserved (E820-Type-2).

All that said we have had functional support for all these types since
the 4.2 kernel, no kernel changes should be needed.
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
