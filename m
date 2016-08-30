Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga02.intel.com (mga02.intel.com [134.134.136.20])
 (using TLSv1 with cipher CAMELLIA256-SHA (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 719961A1DF7
 for <linux-nvdimm@lists.01.org>; Mon, 29 Aug 2016 23:58:32 -0700 (PDT)
Subject: Re: DAX can not work on virtual nvdimm device
References: <436d7526-bf06-633d-afce-4333552d9e31@linux.intel.com>
 <CAPcyv4hVgi6Hw8Beg=Nt78+U0QNJN9mBGWEp3V6bg86NaM3Q6Q@mail.gmail.com>
 <20160819183047.GA7216@linux.intel.com>
 <600ac51c-0f61-6e53-9bfa-669c85494d1f@linux.intel.com>
 <20160829193014.GB16738@linux.intel.com>
From: Xiao Guangrong <guangrong.xiao@linux.intel.com>
Message-ID: <61d5c470-a8bf-86d5-d1fe-b4b577a85967@linux.intel.com>
Date: Tue, 30 Aug 2016 14:53:10 +0800
MIME-Version: 1.0
In-Reply-To: <20160829193014.GB16738@linux.intel.com>
List-Unsubscribe: <https://lists.01.org/mailman/options/linux-nvdimm>,
 <mailto:linux-nvdimm-request@lists.01.org?subject=unsubscribe>
List-Archive: <http://lists.01.org/pipermail/linux-nvdimm/>
List-Post: <mailto:linux-nvdimm@lists.01.org>
List-Help: <mailto:linux-nvdimm-request@lists.01.org?subject=help>
List-Subscribe: <https://lists.01.org/mailman/listinfo/linux-nvdimm>,
 <mailto:linux-nvdimm-request@lists.01.org?subject=subscribe>
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Errors-To: linux-nvdimm-bounces@lists.01.org
Sender: "Linux-nvdimm" <linux-nvdimm-bounces@lists.01.org>
To: Ross Zwisler <ross.zwisler@linux.intel.com>
Cc: Yumei Huang <yuhuang@redhat.com>, KVM <kvm@vger.kernel.org>, "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>, LKML <linux-kernel@vger.kernel.org>, "qemu-devel@nongnu.org" <qemu-devel@nongnu.org>, Linux ACPI <linux-acpi@vger.kernel.org>, Stefan Hajnoczi <stefanha@redhat.com>
List-ID: <linux-nvdimm@lists.01.org>



On 08/30/2016 03:30 AM, Ross Zwisler wrote:

>
> Can you please verify that you are using "usable" memory for your memmap?  All
> the details are here:
>
> https://nvdimm.wiki.kernel.org/how_to_choose_the_correct_memmap_kernel_parameter_for_pmem_on_your_system

Sure.

This is the BIOS E820 info in the guest:

e820: BIOS-provided physical RAM map:
BIOS-e820: [mem 0x0000000000000000-0x000000000009fbff] usable
BIOS-e820: [mem 0x000000000009fc00-0x000000000009ffff] reserved
BIOS-e820: [mem 0x00000000000f0000-0x00000000000fffff] reserved
BIOS-e820: [mem 0x0000000000100000-0x00000000bffdefff] usable
BIOS-e820: [mem 0x00000000bffdf000-0x00000000bfffffff] reserved
BIOS-e820: [mem 0x00000000feffc000-0x00000000feffffff] reserved
BIOS-e820: [mem 0x00000000fffc0000-0x00000000ffffffff] reserved
BIOS-e820: [mem 0x0000000100000000-0x000000083fffffff] usable
NX (Execute Disable) protection: active
e820: user-defined physical RAM map:
user: [mem 0x0000000000000000-0x000000000009fbff] usable
user: [mem 0x000000000009fc00-0x000000000009ffff] reserved
user: [mem 0x00000000000f0000-0x00000000000fffff] reserved
user: [mem 0x0000000000100000-0x00000000bffdefff] usable
user: [mem 0x00000000bffdf000-0x00000000bfffffff] reserved
user: [mem 0x00000000feffc000-0x00000000feffffff] reserved
user: [mem 0x00000000fffc0000-0x00000000ffffffff] reserved
user: [mem 0x0000000100000000-0x000000027fffffff] usable
user: [mem 0x0000000280000000-0x00000003ffffffff] persistent (type 12)
user: [mem 0x0000000400000000-0x000000083fffffff] usable

So that the memory we used to emulate PMEM split the 'usable' region.

>
> My guess is that Boaz was correct, and that your memmap is off using addresses
> that don't actually map to memory.

I do not think so. :(

I did mmap-write and mmap-read test, the data written by mmap-write can be
correctly read out, so that the backend memory is really existing.

Thanks!
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
