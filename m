Return-Path: <linux-fsdevel-owner@vger.kernel.org>
Message-ID: <1435285301.11808.381.camel@misato.fc.hp.com>
Subject: Re: [PATCH v2 16/17] libnvdimm: Add sysfs numa_node to NVDIMM
 devices
From: Toshi Kani <toshi.kani@hp.com>
Date: Thu, 25 Jun 2015 20:21:41 -0600
In-Reply-To: <20150625093743.40066.92148.stgit@dwillia2-desk3.jf.intel.com>
References: <20150625090554.40066.69562.stgit@dwillia2-desk3.jf.intel.com>
	 <20150625093743.40066.92148.stgit@dwillia2-desk3.jf.intel.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-fsdevel-owner@vger.kernel.org
To: Dan Williams <dan.j.williams@intel.com>
Cc: linux-nvdimm@lists.01.org, axboe@kernel.dk, boaz@plexistor.com, linux-kernel@vger.kernel.org, hch@lst.de, linux-acpi@vger.kernel.org, linux-fsdevel@vger.kernel.org, mingo@kernel.org
List-ID: <linux-nvdimm@lists.01.org>

On Thu, 2015-06-25 at 05:37 -0400, Dan Williams wrote:
> From: Toshi Kani <toshi.kani@hp.com>
> 
> Add support of sysfs 'numa_node' to I/O-related NVDIMM devices
> under /sys/bus/nd/devices, regionN, namespaceN.0, and bttN.
> When bttN is not set up, its numa_node returns -1 (NUMA_NO_NODE).
> 
> An example of numa_node values on a 2-socket system with a single
> NVDIMM range on each socket is shown below.
>   /sys/bus/nd/devices
>   |-- btt0/numa_node:-1
>   |-- btt1/numa_node:0
>   |-- namespace0.0/numa_node:0
>   |-- namespace1.0/numa_node:1
>   |-- region0/numa_node:0
>   |-- region1/numa_node:1
> 
> These numa_node files are then linked under the block class of
> their device names.
>   /sys/class/block/pmem0/device/numa_node:0
>   /sys/class/block/pmem0s/device/numa_node:0
>   /sys/class/block/pmem1/device/numa_node:1
> 
> This enables numactl(8) to accept 'block:' and 'file:' paths of
> pmem and btt devices as shown in the examples below.
>   numactl --preferred block:pmem0 --show
>   numactl --preferred file:/dev/pmem0s --show
> 
> Signed-off-by: Toshi Kani <toshi.kani@hp.com>
> Signed-off-by: Dan Williams <dan.j.williams@intel.com>

Can you please update the commit log with the following?  It reflects
the changes in sysfs btt files.

Thanks,
-Toshi

=====
From: Toshi Kani <toshi.kani@hp.com>

Add support of sysfs 'numa_node' to I/O-related NVDIMM devices
under /sys/bus/nd/devices, regionN, namespaceN.0, and bttN.x.

An example of numa_node values on a 2-socket system with a single
NVDIMM range on each socket is shown below.
  /sys/bus/nd/devices
  |-- btt0.0/numa_node:0
  |-- btt1.0/numa_node:1
  |-- btt1.1/numa_node:1
  |-- namespace0.0/numa_node:0
  |-- namespace1.0/numa_node:1
  |-- region0/numa_node:0
  |-- region1/numa_node:1

These numa_node files are then linked under the block class of
their device names.
  /sys/class/block/pmem0/device/numa_node:0
  /sys/class/block/pmem1s/device/numa_node:1

This enables numactl(8) to accept 'block:' and 'file:' paths of
pmem and btt devices as shown in the examples below.
  numactl --preferred block:pmem0 --show
  numactl --preferred file:/dev/pmem1s --show

Signed-off-by: Toshi Kani <toshi.kani@hp.com>
Signed-off-by: Dan Williams <dan.j.williams@intel.com>

