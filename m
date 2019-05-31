Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-it1-x141.google.com (mail-it1-x141.google.com
 [IPv6:2607:f8b0:4864:20::141])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 2DF5621281EE6
 for <linux-nvdimm@lists.01.org>; Thu, 30 May 2019 21:55:46 -0700 (PDT)
Received: by mail-it1-x141.google.com with SMTP id j17so9945077itk.0
 for <linux-nvdimm@lists.01.org>; Thu, 30 May 2019 21:55:46 -0700 (PDT)
MIME-Version: 1.0
References: <20190508061726.27631-1-tao3.xu@intel.com>
In-Reply-To: <20190508061726.27631-1-tao3.xu@intel.com>
From: Dan Williams <dan.j.williams@intel.com>
Date: Thu, 30 May 2019 21:55:34 -0700
Message-ID: <CAA9_cmefLY4ktBf4fOXPUbMGX7faiVDV+bKeUhgkUH2+yn7JuQ@mail.gmail.com>
Subject: Re: [Qemu-devel] [PATCH v4 00/11] Build ACPI Heterogeneous Memory
 Attribute Table (HMAT)
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
To: Tao Xu <tao3.xu@intel.com>
Cc: xiaoguangrong.eric@gmail.com, "Michael S. Tsirkin" <mst@redhat.com>, jingqi.liu@intel.com, linux-nvdimm <linux-nvdimm@lists.01.org>, qemu-devel@nongnu.org, Paolo Bonzini <pbonzini@redhat.com>, Igor Mammedov <imammedo@redhat.com>, rth@twiddle.net, eblake@redhat.com, ehabkost@redhat.com
List-ID: <linux-nvdimm@lists.01.org>

On Tue, May 7, 2019 at 11:32 PM Tao Xu <tao3.xu@intel.com> wrote:
>
> This series of patches will build Heterogeneous Memory Attribute Table (HMAT)
> according to the command line. The ACPI HMAT describes the memory attributes,
> such as memory side cache attributes and bandwidth and latency details,
> related to the System Physical Address (SPA) Memory Ranges.
> The software is expected to use this information as hint for optimization.
>
> OSPM evaluates HMAT only during system initialization. Any changes to the HMAT
> state at runtime or information regarding HMAT for hot plug are communicated
> using the _HMA method.
[..]

Hi,

I gave these patches a try while developing support for the new EFI
v2.8 Specific Purpose Memory attribute [1]. I have a gap / feature
request to note to make this implementation capable of emulating
current shipping platform BIOS implementations for persistent memory
platforms.

The NUMA configuration I tested was:

        -numa node,mem=4G,cpus=0-19,nodeid=0
        -numa node,mem=4G,cpus=20-39,nodeid=1
        -numa node,mem=4G,nodeid=2
        -numa node,mem=4G,nodeid=3

...and it produced an entry like the following for proximity domain 2.

[0C8h 0200   2]               Structure Type : 0000 [Memory Proximity
Domain Attributes]
[0CAh 0202   2]                     Reserved : 0000
[0CCh 0204   4]                       Length : 00000028
[0D0h 0208   2]        Flags (decoded below) : 0002
            Processor Proximity Domain Valid : 0
[0D2h 0210   2]                    Reserved1 : 0000
[0D4h 0212   4]   Processor Proximity Domain : 00000002
[0D8h 0216   4]      Memory Proximity Domain : 00000002
[0DCh 0220   4]                    Reserved2 : 00000000
[0E0h 0224   8]                    Reserved3 : 0000000240000000
[0E8h 0232   8]                    Reserved4 : 0000000100000000

Notice that the Processor "Proximity Domain Valid" bit is clear. I
understand that the implementation is keying off of whether cpus are
defined for that same node or not, but that's not how current
persistent memory platforms implement "Processor Proximity Domain". On
these platforms persistent memory indeed has its own proximity domain,
but the Processor Proximity Domain is expected to be assigned to the
domain that houses the memory controller for that persistent memory.
So to emulate that configuration it would be useful to have a way to
specify "Processor Proximity Domain" without needing to define CPUs in
that domain.

Something like:

        -numa node,mem=4G,cpus=0-19,nodeid=0
        -numa node,mem=4G,cpus=20-39,nodeid=1
        -numa node,mem=4G,nodeid=2,localnodeid=0
        -numa node,mem=4G,nodeid=3,localnodeid=1

...to specify that node2 memory is connected / local to node0 and
node3 memory is connected / local to node1. In general HMAT specifies
that all performance differentiated memory ranges have their own
proximity domain, but those are expected to still be associated with a
local/host/home-socket memory controller.

[1]: https://lists.01.org/pipermail/linux-nvdimm/2019-May/021668.html
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
