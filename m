Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-vk0-x244.google.com (mail-vk0-x244.google.com
 [IPv6:2607:f8b0:400c:c05::244])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id BDB581A1E00
 for <linux-nvdimm@lists.01.org>; Wed, 15 Jun 2016 06:58:15 -0700 (PDT)
Received: by mail-vk0-x244.google.com with SMTP id v188so3421719vkf.3
 for <linux-nvdimm@lists.01.org>; Wed, 15 Jun 2016 06:57:50 -0700 (PDT)
MIME-Version: 1.0
From: Vijairaj <vijairaj.r@gmail.com>
Date: Wed, 15 Jun 2016 19:27:48 +0530
Message-ID: <CAJZPXDLcW3KYtxzJs=27b17bvisdv6g2MCj3fcJ9cU+YnQnwcQ@mail.gmail.com>
Subject: Mapping PCIe BAR as PMEM
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
To: linux-nvdimm@lists.01.org
List-ID: <linux-nvdimm@lists.01.org>

Hi,
I am running the 4.4 kernel on AMD64 and was wondering what's a good way of
mapping the 16M of battery backed SRAM on a custom PCIe card as PMEM. Once
mapped, I will create a file system on the block device.

I am thinking about doing the following:
    - Use the kernel parameter memmap=nn!ss to reserve the PCIe BAR
    - Write a PCI driver to enable the PCI device `pci_enable_device()`
    - Load the PCI driver
    - Load the nd_pmem driver

Is this sufficient or is there anything else required to be done in the PCI
driver?

thanks,
Vijairaj
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
