Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-ua0-x235.google.com (mail-ua0-x235.google.com
 [IPv6:2607:f8b0:400c:c08::235])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 6CCED21C9125D
 for <linux-nvdimm@lists.01.org>; Fri, 28 Jul 2017 11:09:07 -0700 (PDT)
Received: by mail-ua0-x235.google.com with SMTP id f9so169683937uaf.4
 for <linux-nvdimm@lists.01.org>; Fri, 28 Jul 2017 11:11:12 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20170728180446.GA31104@linux.intel.com>
References: <20170728180446.GA31104@linux.intel.com>
From: Dan Williams <dan.j.williams@intel.com>
Date: Fri, 28 Jul 2017 11:11:10 -0700
Message-ID: <CAPcyv4i5YWK6RHYEkH6C1oPWwhPLOD-atmkMVXDXc-qdv_0hgw@mail.gmail.com>
Subject: Re: QEMU NVDIMM as type 7 in e820 table
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
To: Ross Zwisler <ross.zwisler@linux.intel.com>
Cc: "Michael S. Tsirkin" <mst@redhat.com>, Stefan Hajnoczi <stefanha@gmail.com>, "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>, Qemu Developers <qemu-devel@nongnu.org>, Xiao Guangrong <guangrong.xiao@gmail.com>, Igor Mammedov <imammedo@redhat.com>
List-ID: <linux-nvdimm@lists.01.org>

On Fri, Jul 28, 2017 at 11:04 AM, Ross Zwisler
<ross.zwisler@linux.intel.com> wrote:
> I've been using the virtualized NVDIMM support in QEMU for testing, and I
> noticed that the physical addresses used by the virtual NVDIMMs aren't present
> in the guest's e820 table.
>
> Here is the e820 table on my QEMU instance where I have one 32 GiB virtual
> NVDIMM:
>
> [    0.000000] e820: BIOS-provided physical RAM map:
> [    0.000000] BIOS-e820: [mem 0x0000000000000000-0x000000000009fbff] usable
> [    0.000000] BIOS-e820: [mem 0x000000000009fc00-0x000000000009ffff] reserved
> [    0.000000] BIOS-e820: [mem 0x00000000000f0000-0x00000000000fffff] reserved
> [    0.000000] BIOS-e820: [mem 0x0000000000100000-0x00000000bffdefff] usable
> [    0.000000] BIOS-e820: [mem 0x00000000bffdf000-0x00000000bfffffff] reserved
> [    0.000000] BIOS-e820: [mem 0x00000000feffc000-0x00000000feffffff] reserved
> [    0.000000] BIOS-e820: [mem 0x00000000fffc0000-0x00000000ffffffff] reserved
> [    0.000000] BIOS-e820: [mem 0x0000000100000000-0x000000023fffffff] usable
>
> The physical addresses used by the virtual NVDIMM are 0x240000000-0xA40000000.
> You can see this by looking at ndctl and the values we get from the NFIT:
>
> # ndctl list -R
> {
>   "dev":"region0",
>   "size":34359738368,
>   "available_size":0,
>   "type":"pmem"
> }
>
> # grep . /sys/bus/nd/devices/region0/{resource,size}
> region0/resource:0x240000000
> region0/size:34359738368
>
> Or you can see the same info by using iasl to dump
> /sys/firmware/acpi/tables/NFIT:
>
> [028h 0040   2]                Subtable Type : 0000 [System Physical Address Range]
> [02Ah 0042   2]                       Length : 0038
>
> [02Ch 0044   2]                  Range Index : 0002
> [02Eh 0046   2]        Flags (decoded below) : 0003
>                    Add/Online Operation Only : 1
>                       Proximity Domain Valid : 1
> [030h 0048   4]                     Reserved : 00000000
> [034h 0052   4]             Proximity Domain : 00000000
> [038h 0056  16]           Address Range GUID : 66F0D379-B4F3-4074-AC43-0D3318B78CDB
> [048h 0072   8]           Address Range Base : 0000000240000000
> [050h 0080   8]         Address Range Length : 0000000800000000
> [058h 0088   8]         Memory Map Attribute : 0000000000008008
>
> I expected to see a type 7 region for the NVDIMM physical address range in the
> e820 table, so something like:
>
> [    0.000000] e820: BIOS-provided physical RAM map:
> [    0.000000] BIOS-e820: [mem 0x0000000000000000-0x000000000009fbff] usable
> [    0.000000] BIOS-e820: [mem 0x000000000009fc00-0x000000000009ffff] reserved
> [    0.000000] BIOS-e820: [mem 0x00000000000f0000-0x00000000000fffff] reserved
> [    0.000000] BIOS-e820: [mem 0x0000000000100000-0x00000000bffdefff] usable
> [    0.000000] BIOS-e820: [mem 0x00000000bffdf000-0x00000000bfffffff] reserved
> [    0.000000] BIOS-e820: [mem 0x00000000feffc000-0x00000000feffffff] reserved
> [    0.000000] BIOS-e820: [mem 0x00000000fffc0000-0x00000000ffffffff] reserved
> [    0.000000] BIOS-e820: [mem 0x0000000100000000-0x000000023fffffff] usable
> [    0.000000] BIOS-e820: [mem 0x0000000240000000-0x0000000A40000000] persistent (type 7)
>

Do you need that informationin e820? Linux effectively ignores type-7.
As long as the range is treated as reserved it's not clear that you
need the e820 entry. We also infect the persistent type back into the
memory map when the NFIT driver loads. /proc/iomem should show the
right data.
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
