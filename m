Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-oi0-x234.google.com (mail-oi0-x234.google.com
 [IPv6:2607:f8b0:4003:c06::234])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 975511A1E05
 for <linux-nvdimm@lists.01.org>; Tue, 11 Oct 2016 18:14:02 -0700 (PDT)
Received: by mail-oi0-x234.google.com with SMTP id y2so44992151oie.0
 for <linux-nvdimm@lists.01.org>; Tue, 11 Oct 2016 18:14:02 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20161011233151.GK23194@dastard>
References: <20161011233151.GK23194@dastard>
From: Dan Williams <dan.j.williams@intel.com>
Date: Tue, 11 Oct 2016 18:14:01 -0700
Message-ID: <CAPcyv4hoOUj4iLz1Ci8y_BNG5d8+wzgssTdvmOzU9A19GtbhPw@mail.gmail.com>
Subject: Re: [regression, 4.9, pmem] memmap= command line, pmem device
 creation behaviour changed
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
To: Dave Chinner <david@fromorbit.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>
List-ID: <linux-nvdimm@lists.01.org>

On Tue, Oct 11, 2016 at 4:31 PM, Dave Chinner <david@fromorbit.com> wrote:
> Hi Dan,
>
> I boot my DAX test machine with "memmap=8G!16G,8G!24G" on the kernel
> command line to give me two 8GB pmem devices. This has worked fine
> on all kernels including 4.8. I just updated that test machine to a
> TOT linus kernel (4.9), and now I get a single 16GB pmem device.
> i.e.  the memory map the kernel generates is different.  This is
> what I get on boot from a 4.9 kernel:
>
> [    0.000000] e820: BIOS-provided physical RAM map:
> [    0.000000] BIOS-e820: [mem 0x0000000000000000-0x000000000009fbff] usable
> [    0.000000] BIOS-e820: [mem 0x000000000009fc00-0x000000000009ffff] reserved
> [    0.000000] BIOS-e820: [mem 0x00000000000f0000-0x00000000000fffff] reserved
> [    0.000000] BIOS-e820: [mem 0x0000000000100000-0x00000000bffdefff] usable
> [    0.000000] BIOS-e820: [mem 0x00000000bffdf000-0x00000000bfffffff] reserved
> [    0.000000] BIOS-e820: [mem 0x00000000feffc000-0x00000000feffffff] reserved
> [    0.000000] BIOS-e820: [mem 0x00000000fffc0000-0x00000000ffffffff] reserved
> [    0.000000] BIOS-e820: [mem 0x0000000100000000-0x000000083fffffff] usable
> [    0.000000] NX (Execute Disable) protection: active
> [    0.000000] e820: user-defined physical RAM map:
> [    0.000000] user: [mem 0x0000000000000000-0x000000000009fbff] usable
> [    0.000000] user: [mem 0x000000000009fc00-0x000000000009ffff] reserved
> [    0.000000] user: [mem 0x00000000000f0000-0x00000000000fffff] reserved
> [    0.000000] user: [mem 0x0000000000100000-0x00000000bffdefff] usable
> [    0.000000] user: [mem 0x00000000bffdf000-0x00000000bfffffff] reserved
> [    0.000000] user: [mem 0x00000000feffc000-0x00000000feffffff] reserved
> [    0.000000] user: [mem 0x00000000fffc0000-0x00000000ffffffff] reserved
> [    0.000000] user: [mem 0x0000000100000000-0x00000003ffffffff] usable
> [    0.000000] user: [mem 0x0000000400000000-0x00000007ffffffff] persistent (type 12)
> [    0.000000] user: [mem 0x0000000800000000-0x000000083fffffff] usable
>
>
> On 4.8, I get two persistent (type 12) sections, each of 8GB. 4.9 is
> giving me a single 16GB region. This needs to behave like a 4.8
> kernel and return two persistent regions - persistent memory device
> setup cannot be allowed to change from kernel to kernel. Change in
> mapping and device setup like this will cause the corruption of
> and/or loss of data in the persistent memory devices that have
> changed shape, size or disappeared....
>

I wonder if this is a side effect of:

917db484dc6a x86/boot: Fix kdump, cleanup aborted E820_PRAM max_pfn manipulation

Can you retry reverting that?  If that does not fix it I'll take a
look at bisecting this.
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
