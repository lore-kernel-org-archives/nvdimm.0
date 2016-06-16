Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from ale.deltatee.com (ale.deltatee.com [207.54.116.67])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id D22621A1E04
 for <linux-nvdimm@lists.01.org>; Wed, 15 Jun 2016 17:31:33 -0700 (PDT)
References: <CAJZPXDLcW3KYtxzJs=27b17bvisdv6g2MCj3fcJ9cU+YnQnwcQ@mail.gmail.com>
From: Logan Gunthorpe <logang@deltatee.com>
Message-ID: <5761F344.5060901@deltatee.com>
Date: Wed, 15 Jun 2016 18:31:00 -0600
MIME-Version: 1.0
In-Reply-To: <CAJZPXDLcW3KYtxzJs=27b17bvisdv6g2MCj3fcJ9cU+YnQnwcQ@mail.gmail.com>
Subject: Re: Mapping PCIe BAR as PMEM
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
To: Vijairaj <vijairaj.r@gmail.com>, linux-nvdimm@lists.01.org
Cc: Stephen Bates <Stephen.Bates@pmcs.com>
List-ID: <linux-nvdimm@lists.01.org>

Hey Vijairaj,

This is essentially what we did with our iopmem work [1].

We wrote a PCI driver (see [2] for an example) and had a small patch to 
the kernel to enable mappings with write combining.

Logan

[1] http://www.spinics.net/lists/linux-mm/msg103990.html
[2] https://github.com/sbates130272/iopmem

On 15/06/16 07:57 AM, Vijairaj wrote:
> Hi,
> I am running the 4.4 kernel on AMD64 and was wondering what's a good way of
> mapping the 16M of battery backed SRAM on a custom PCIe card as PMEM. Once
> mapped, I will create a file system on the block device.
>
> I am thinking about doing the following:
>      - Use the kernel parameter memmap=nn!ss to reserve the PCIe BAR
>      - Write a PCI driver to enable the PCI device `pci_enable_device()`
>      - Load the PCI driver
>      - Load the nd_pmem driver
>
> Is this sufficient or is there anything else required to be done in the PCI
> driver?
>
> thanks,
> Vijairaj
> _______________________________________________
> Linux-nvdimm mailing list
> Linux-nvdimm@lists.01.org
> https://lists.01.org/mailman/listinfo/linux-nvdimm
>
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
