Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga03.intel.com (mga03.intel.com [134.134.136.65])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 570AF21D49C69
 for <linux-nvdimm@lists.01.org>; Fri, 28 Jul 2017 12:43:39 -0700 (PDT)
Date: Fri, 28 Jul 2017 13:45:43 -0600
From: Ross Zwisler <ross.zwisler@linux.intel.com>
Subject: Re: QEMU NVDIMM as type 7 in e820 table
Message-ID: <20170728194543.GA20726@linux.intel.com>
References: <20170728180446.GA31104@linux.intel.com>
 <CAPcyv4i5YWK6RHYEkH6C1oPWwhPLOD-atmkMVXDXc-qdv_0hgw@mail.gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <CAPcyv4i5YWK6RHYEkH6C1oPWwhPLOD-atmkMVXDXc-qdv_0hgw@mail.gmail.com>
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
To: Dan Williams <dan.j.williams@intel.com>
Cc: "Michael S. Tsirkin" <mst@redhat.com>, Stefan Hajnoczi <stefanha@gmail.com>, "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>, Qemu Developers <qemu-devel@nongnu.org>, Xiao Guangrong <guangrong.xiao@gmail.com>, Igor Mammedov <imammedo@redhat.com>
List-ID: <linux-nvdimm@lists.01.org>

On Fri, Jul 28, 2017 at 11:11:10AM -0700, Dan Williams wrote:
> On Fri, Jul 28, 2017 at 11:04 AM, Ross Zwisler
> <ross.zwisler@linux.intel.com> wrote:
> > I've been using the virtualized NVDIMM support in QEMU for testing, and I
> > noticed that the physical addresses used by the virtual NVDIMMs aren't present
> > in the guest's e820 table.
> >
> > Here is the e820 table on my QEMU instance where I have one 32 GiB virtual
> > NVDIMM:
> >
> > [    0.000000] e820: BIOS-provided physical RAM map:
> > [    0.000000] BIOS-e820: [mem 0x0000000000000000-0x000000000009fbff] usable
> > [    0.000000] BIOS-e820: [mem 0x000000000009fc00-0x000000000009ffff] reserved
> > [    0.000000] BIOS-e820: [mem 0x00000000000f0000-0x00000000000fffff] reserved
> > [    0.000000] BIOS-e820: [mem 0x0000000000100000-0x00000000bffdefff] usable
> > [    0.000000] BIOS-e820: [mem 0x00000000bffdf000-0x00000000bfffffff] reserved
> > [    0.000000] BIOS-e820: [mem 0x00000000feffc000-0x00000000feffffff] reserved
> > [    0.000000] BIOS-e820: [mem 0x00000000fffc0000-0x00000000ffffffff] reserved
> > [    0.000000] BIOS-e820: [mem 0x0000000100000000-0x000000023fffffff] usable
> >
> > The physical addresses used by the virtual NVDIMM are 0x240000000-0xA40000000.
> > You can see this by looking at ndctl and the values we get from the NFIT:
> >
> > # ndctl list -R
> > {
> >   "dev":"region0",
> >   "size":34359738368,
> >   "available_size":0,
> >   "type":"pmem"
> > }
> >
> > # grep . /sys/bus/nd/devices/region0/{resource,size}
> > region0/resource:0x240000000
> > region0/size:34359738368
> >
> > Or you can see the same info by using iasl to dump
> > /sys/firmware/acpi/tables/NFIT:
> >
> > [028h 0040   2]                Subtable Type : 0000 [System Physical Address Range]
> > [02Ah 0042   2]                       Length : 0038
> >
> > [02Ch 0044   2]                  Range Index : 0002
> > [02Eh 0046   2]        Flags (decoded below) : 0003
> >                    Add/Online Operation Only : 1
> >                       Proximity Domain Valid : 1
> > [030h 0048   4]                     Reserved : 00000000
> > [034h 0052   4]             Proximity Domain : 00000000
> > [038h 0056  16]           Address Range GUID : 66F0D379-B4F3-4074-AC43-0D3318B78CDB
> > [048h 0072   8]           Address Range Base : 0000000240000000
> > [050h 0080   8]         Address Range Length : 0000000800000000
> > [058h 0088   8]         Memory Map Attribute : 0000000000008008
> >
> > I expected to see a type 7 region for the NVDIMM physical address range in the
> > e820 table, so something like:
> >
> > [    0.000000] e820: BIOS-provided physical RAM map:
> > [    0.000000] BIOS-e820: [mem 0x0000000000000000-0x000000000009fbff] usable
> > [    0.000000] BIOS-e820: [mem 0x000000000009fc00-0x000000000009ffff] reserved
> > [    0.000000] BIOS-e820: [mem 0x00000000000f0000-0x00000000000fffff] reserved
> > [    0.000000] BIOS-e820: [mem 0x0000000000100000-0x00000000bffdefff] usable
> > [    0.000000] BIOS-e820: [mem 0x00000000bffdf000-0x00000000bfffffff] reserved
> > [    0.000000] BIOS-e820: [mem 0x00000000feffc000-0x00000000feffffff] reserved
> > [    0.000000] BIOS-e820: [mem 0x00000000fffc0000-0x00000000ffffffff] reserved
> > [    0.000000] BIOS-e820: [mem 0x0000000100000000-0x000000023fffffff] usable
> > [    0.000000] BIOS-e820: [mem 0x0000000240000000-0x0000000A40000000] persistent (type 7)
> >
> 
> Do you need that informationin e820? Linux effectively ignores type-7.
> As long as the range is treated as reserved it's not clear that you
> need the e820 entry. We also infect the persistent type back into the
> memory map when the NFIT driver loads. /proc/iomem should show the
> right data.

[ Adding Linda & Toshi to see if they have an opinion. ]

I guess maybe we don't need it.  Yep, /proc/iomem looks good:

  # cat /proc/iomem
  00000000-00000fff : Reserved
  00001000-0009fbff : System RAM
  ...
  100000000-23fffffff : System RAM
  240000000-a3fffffff : Persistent Memory
    240000000-a3fffffff : namespace0.0

I was just worried that this was an inconsistency between the way that virtual
NVDIMMs are presented vs the way that they will be presented on bare metal.  I
at least look at the e820 table to get my bearings of how memory is laid out -
maybe I just need to look at /proc/iomem instead?
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
