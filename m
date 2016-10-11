Return-Path: <linux-kernel-owner@vger.kernel.org>
Date: Wed, 12 Oct 2016 10:31:51 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: [regression, 4.9, pmem] memmap= command line, pmem device creation
 behaviour changed
Message-ID: <20161011233151.GK23194@dastard>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
To: linux-kernel@vger.kernel.org
Cc: Dan Williams <dan.j.williams@intel.com>, linux-nvdimm@lists.01.org
List-ID: <linux-nvdimm@lists.01.org>

Hi Dan,

I boot my DAX test machine with "memmap=8G!16G,8G!24G" on the kernel
command line to give me two 8GB pmem devices. This has worked fine
on all kernels including 4.8. I just updated that test machine to a
TOT linus kernel (4.9), and now I get a single 16GB pmem device.
i.e.  the memory map the kernel generates is different.  This is
what I get on boot from a 4.9 kernel:

[    0.000000] e820: BIOS-provided physical RAM map:
[    0.000000] BIOS-e820: [mem 0x0000000000000000-0x000000000009fbff] usable
[    0.000000] BIOS-e820: [mem 0x000000000009fc00-0x000000000009ffff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000000f0000-0x00000000000fffff] reserved
[    0.000000] BIOS-e820: [mem 0x0000000000100000-0x00000000bffdefff] usable
[    0.000000] BIOS-e820: [mem 0x00000000bffdf000-0x00000000bfffffff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000feffc000-0x00000000feffffff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000fffc0000-0x00000000ffffffff] reserved
[    0.000000] BIOS-e820: [mem 0x0000000100000000-0x000000083fffffff] usable
[    0.000000] NX (Execute Disable) protection: active
[    0.000000] e820: user-defined physical RAM map:
[    0.000000] user: [mem 0x0000000000000000-0x000000000009fbff] usable
[    0.000000] user: [mem 0x000000000009fc00-0x000000000009ffff] reserved
[    0.000000] user: [mem 0x00000000000f0000-0x00000000000fffff] reserved
[    0.000000] user: [mem 0x0000000000100000-0x00000000bffdefff] usable
[    0.000000] user: [mem 0x00000000bffdf000-0x00000000bfffffff] reserved
[    0.000000] user: [mem 0x00000000feffc000-0x00000000feffffff] reserved
[    0.000000] user: [mem 0x00000000fffc0000-0x00000000ffffffff] reserved
[    0.000000] user: [mem 0x0000000100000000-0x00000003ffffffff] usable
[    0.000000] user: [mem 0x0000000400000000-0x00000007ffffffff] persistent (type 12)
[    0.000000] user: [mem 0x0000000800000000-0x000000083fffffff] usable


On 4.8, I get two persistent (type 12) sections, each of 8GB. 4.9 is
giving me a single 16GB region. This needs to behave like a 4.8
kernel and return two persistent regions - persistent memory device
setup cannot be allowed to change from kernel to kernel. Change in
mapping and device setup like this will cause the corruption of
and/or loss of data in the persistent memory devices that have
changed shape, size or disappeared....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
