Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-ob0-x22b.google.com (mail-ob0-x22b.google.com
 [IPv6:2607:f8b0:4003:c01::22b])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 0360B1A1E00
 for <linux-nvdimm@lists.01.org>; Wed, 15 Jun 2016 07:33:33 -0700 (PDT)
Received: by mail-ob0-x22b.google.com with SMTP id wj2so296011obc.0
 for <linux-nvdimm@lists.01.org>; Wed, 15 Jun 2016 07:33:08 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAJZPXDLcW3KYtxzJs=27b17bvisdv6g2MCj3fcJ9cU+YnQnwcQ@mail.gmail.com>
References: <CAJZPXDLcW3KYtxzJs=27b17bvisdv6g2MCj3fcJ9cU+YnQnwcQ@mail.gmail.com>
Date: Wed, 15 Jun 2016 07:33:06 -0700
Message-ID: <CAPcyv4i4yb_A_fTBCM=aX+3YaE6me0gk4vX8++WJeTm+tHHOng@mail.gmail.com>
Subject: Re: Mapping PCIe BAR as PMEM
From: Dan Williams <dan.j.williams@intel.com>
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
To: Vijairaj <vijairaj.r@gmail.com>
Cc: "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>
List-ID: <linux-nvdimm@lists.01.org>

On Wed, Jun 15, 2016 at 6:57 AM, Vijairaj <vijairaj.r@gmail.com> wrote:
> Hi,
> I am running the 4.4 kernel on AMD64 and was wondering what's a good way of
> mapping the 16M of battery backed SRAM on a custom PCIe card as PMEM. Once
> mapped, I will create a file system on the block device.
>
> I am thinking about doing the following:
>     - Use the kernel parameter memmap=nn!ss to reserve the PCIe BAR

You don't need memmap= because the kernel can discover the PCIe BAR
like any other pci device (i.e. with a struct pci_device_id table).

>     - Write a PCI driver to enable the PCI device `pci_enable_device()`
>     - Load the PCI driver
>     - Load the nd_pmem driver

The pmem driver will load automatically if you register a pmem region
with nvdimm_pmem_region_create().

> Is this sufficient or is there anything else required to be done in the PCI
> driver?

Take a look at drivers/nvdimm/e820.c and copy/convert it into
drivers/nvdimm/pci.c.

One thing to note is that a PCIe card is not I/O cache coherent
meaning it can't be used in the same scenarios a host
memory-controller based persistent memory.  One change you should
probably make compared to the e820 driver is to not set the
ND_REGION_PAGEMAP bit.
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
