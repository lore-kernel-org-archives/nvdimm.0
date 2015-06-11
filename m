Return-Path: <linux-kernel-owner@vger.kernel.org>
Message-ID: <1434037550.11808.10.camel@misato.fc.hp.com>
Subject: Re: [PATCH v2 0/3] Add NUMA support for NVDIMM devices
From: Toshi Kani <toshi.kani@hp.com>
Date: Thu, 11 Jun 2015 09:45:50 -0600
In-Reply-To: <CAPcyv4jJv1df39W9YjP3FCeZDzZKOsV70xK9gbteykEUJVyDwQ@mail.gmail.com>
References: <1433891440-3515-1-git-send-email-toshi.kani@hp.com>
	 <CAPcyv4jJv1df39W9YjP3FCeZDzZKOsV70xK9gbteykEUJVyDwQ@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
To: Dan Williams <dan.j.williams@intel.com>
Cc: "Rafael J. Wysocki" <rjw@rjwysocki.net>, Linux ACPI <linux-acpi@vger.kernel.org>, "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, Rafael J Wysocki <rafael.j.wysocki@intel.com>
List-ID: <linux-nvdimm@lists.01.org>

On Thu, 2015-06-11 at 08:38 -0700, Dan Williams wrote:
> On Tue, Jun 9, 2015 at 4:10 PM, Toshi Kani <toshi.kani@hp.com> wrote:
> > Since NVDIMMs are installed on memory slots, they expose the NUMA
> > topology of a platform.  This patchset adds support of sysfs
> > 'numa_node' to I/O-related NVDIMM devices under /sys/bus/nd/devices.
> > This enables numactl(8) to accept 'block:' and 'file:' paths of
> > pmem and btt devices as shown in the examples below.
> >   numactl --preferred block:pmem0 --show
> >   numactl --preferred file:/dev/pmem0s --show
> >
> > numactl can be used to bind an application to the locality of
> > a target NVDIMM for better performance.  Here is a result of fio
> > benchmark to ext4/dax on an HP DL380 with 2 sockets for local and
> > remote settings.
> >
> >   Local [1] :  4098.3MB/s
> >   Remote [2]:  3718.4MB/s
> >
> > [1] numactl --preferred block:pmem0 --cpunodebind block:pmem0 fio <fs-on-pmem0>
> > [2] numactl --preferred block:pmem1 --cpunodebind block:pmem1 fio <fs-on-pmem0>
> >
> > Patch 1/3 applies on top of the acpica branch of the pm tree.
> > Patch 2/3-3/3 apply on top of Dan Williams's v5 patch series of
> > "libnvdimm: non-volatile memory devices".
> >
> > ---
> > v2:
> >  - Add acpi_map_pxm_to_online_node(), which returns an online node.
> >  - Manage visibility of sysfs numa_node with is_visible. (Dan Williams)
> >  - Check ACPI_NFIT_PROXIMITY_VALID in spa->flags.
> >
> > ---
> > Toshi Kani (3):
> >   1/3 acpi: Add acpi_map_pxm_to_online_node()
> >   2/3 libnvdimm: Set numa_node to NVDIMM devices
> >   3/3 libnvdimm: Add sysfs numa_node to NVDIMM devices
> 
> Looks good to me.  Once Rafael acks the ACPI core changes I'll pull it
> in to libnvdimm-for-next.

Great!  Thanks Dan,
-Toshi

