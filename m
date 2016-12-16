Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from NAM01-SN1-obe.outbound.protection.outlook.com
 (mail-sn1nam01on071e.outbound.protection.outlook.com
 [IPv6:2a01:111:f400:fe40::71e])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 3CCE381FFF
 for <linux-nvdimm@lists.01.org>; Thu, 15 Dec 2016 17:53:00 -0800 (PST)
From: "Elliott, Robert (Persistent Memory)" <elliott@hpe.com>
Subject: RE: [PATCH 1/3] dev-dax: add support to display badblocks in sysfs
 for dev-dax
Date: Fri, 16 Dec 2016 01:52:57 +0000
Message-ID: <DF4PR84MB0169815E607E12A0B343B9FDAB9C0@DF4PR84MB0169.NAMPRD84.PROD.OUTLOOK.COM>
References: <148158809239.159590.16102609849408268953.stgit@djiang5-desk3.ch.intel.com>
In-Reply-To: <148158809239.159590.16102609849408268953.stgit@djiang5-desk3.ch.intel.com>
Content-Language: en-US
MIME-Version: 1.0
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
To: Dave Jiang <dave.jiang@intel.com>, "dan.j.williams@intel.com" <dan.j.williams@intel.com>
Cc: "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>
List-ID: <linux-nvdimm@lists.01.org>

> -----Original Message-----
> From: Linux-nvdimm [mailto:linux-nvdimm-bounces@lists.01.org] On
> Behalf Of Dave Jiang
> Sent: Monday, December 12, 2016 6:15 PM
> Subject: [PATCH 1/3] dev-dax: add support to display badblocks in
> sysfs for dev-dax
> 
> Adding support to show badblocks in the pmem region that's provided
> by the poison_list. This should show up in
> /sys/class/dax/daxN.N/badblocks as read only. Currently we only
> support
> a single resource and we do not support badblocks for seeds.
> Additional
> support code will be implemented to support.
> 
...
> diff --git a/drivers/dax/pmem.c b/drivers/dax/pmem.c
...
> +static ssize_t dax_pmem_badblocks_show(struct device *dev,
> +		struct device_attribute *attr, char *page)
> +{
> +	struct dax_pmem *dax_pmem =
> +		(struct dax_pmem *)dax_dev_get_private(dev);
> +
> +	return badblocks_show(&dax_pmem->bb, page, 0);
> +}

Do /dev/dax devices have a "block size" to explain the units used in
the sysfs files?  If so, where is it reported?

This directory has the total size in bytes (here, 8 GiB - 2 MiB):
/sys/class/dax/dax0.0/dev:242:0
/sys/class/dax/dax0.0/size:8587837440
/sys/class/dax/dax0.0/uevent:MAJOR=242
/sys/class/dax/dax0.0/uevent:MINOR=0
/sys/class/dax/dax0.0/uevent:DEVNAME=dax0.0

In contrast, /dev/pmem devices have a full "queue" directory,
including logical_block_size.

/sys/class/block/pmem0/device/devtype:nd_namespace_io
/sys/class/block/pmem0/device/force_raw:0
/sys/class/block/pmem0/device/modalias:nd:t4
/sys/class/block/pmem0/device/mode:raw
/sys/class/block/pmem0/device/nstype:4
/sys/class/block/pmem0/device/numa_node:0
/sys/class/block/pmem0/device/resource:0x880000000
/sys/class/block/pmem0/device/size:8589934592
/sys/class/block/pmem0/device/uevent:DEVTYPE=nd_namespace_io
/sys/class/block/pmem0/device/uevent:DRIVER=nd_pmem
/sys/class/block/pmem0/device/uevent:MODALIAS=nd:t4
/sys/class/block/pmem0/queue/add_random:0
/sys/class/block/pmem0/queue/dax:1
/sys/class/block/pmem0/queue/discard_granularity:0
/sys/class/block/pmem0/queue/discard_max_bytes:0
/sys/class/block/pmem0/queue/discard_max_hw_bytes:0
/sys/class/block/pmem0/queue/discard_zeroes_data:0
/sys/class/block/pmem0/queue/hw_sector_size:512
/sys/class/block/pmem0/queue/io_poll:0
/sys/class/block/pmem0/queue/iostats:0
/sys/class/block/pmem0/queue/logical_block_size:512
/sys/class/block/pmem0/queue/max_hw_sectors_kb:2147483647
/sys/class/block/pmem0/queue/max_integrity_segments:0
/sys/class/block/pmem0/queue/max_sectors_kb:1280
/sys/class/block/pmem0/queue/max_segments:128
/sys/class/block/pmem0/queue/max_segment_size:65536
/sys/class/block/pmem0/queue/minimum_io_size:4096
/sys/class/block/pmem0/queue/nomerges:0
/sys/class/block/pmem0/queue/nr_requests:128
/sys/class/block/pmem0/queue/optimal_io_size:0
/sys/class/block/pmem0/queue/physical_block_size:4096
/sys/class/block/pmem0/queue/read_ahead_kb:128
/sys/class/block/pmem0/queue/rotational:0
/sys/class/block/pmem0/queue/rq_affinity:0
/sys/class/block/pmem0/queue/scheduler:none
/sys/class/block/pmem0/queue/write_cache:write back
/sys/class/block/pmem0/queue/write_same_max_bytes:0


---
Robert Elliott, HPE Persistent Memory


_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
