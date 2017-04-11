Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-pg0-x244.google.com (mail-pg0-x244.google.com
 [IPv6:2607:f8b0:400e:c05::244])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 485BE21939224
 for <linux-nvdimm@lists.01.org>; Tue, 11 Apr 2017 10:42:51 -0700 (PDT)
Received: by mail-pg0-x244.google.com with SMTP id 79so694082pgf.0
 for <linux-nvdimm@lists.01.org>; Tue, 11 Apr 2017 10:42:51 -0700 (PDT)
From: Oliver O'Halloran <oohall@gmail.com>
Subject: ZONE_DEVICE and pmem API support for powerpc
Date: Wed, 12 Apr 2017 03:42:24 +1000
Message-Id: <20170411174233.21902-1-oohall@gmail.com>
List-Unsubscribe: <https://lists.01.org/mailman/options/linux-nvdimm>,
 <mailto:linux-nvdimm-request@lists.01.org?subject=unsubscribe>
List-Archive: <http://lists.01.org/pipermail/linux-nvdimm/>
List-Post: <mailto:linux-nvdimm@lists.01.org>
List-Help: <mailto:linux-nvdimm-request@lists.01.org?subject=help>
List-Subscribe: <https://lists.01.org/mailman/listinfo/linux-nvdimm>,
 <mailto:linux-nvdimm-request@lists.01.org?subject=subscribe>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: linux-nvdimm-bounces@lists.01.org
Sender: "Linux-nvdimm" <linux-nvdimm-bounces@lists.01.org>
To: linuxppc-dev@lists.ozlabs.org
Cc: bsingharora@gmail.com, arbab@linux.vnet.ibm.com, linux-nvdimm@lists.01.org
List-ID: <linux-nvdimm@lists.01.org>

Hi all,

This series adds support for ZONE_DEVICE and the pmem api on powerpc. Namely,
support for altmaps and the various bits and pieces required for DAX PMD faults.
The first two patches touch generic mm/ code, but otherwise this is fairly well
contained in arch/powerpc.

If the nvdimm folks could sanity check this series I'd appreciate it.

Series is based on next-20170411, but it should apply elsewhere with minor
fixups to arch_{add|remove}_memory due to conflicts with HMM.  For those
interested in testing this, there is a driver and matching firmware that carves
out some system memory for use as an emulated Con Tutto memory card.

Driver: https://github.com/oohal/linux/tree/contutto-next
Firmware: https://github.com/oohal/skiboot/tree/fake-contutto

Edit core/init.c:686 to control the amount of memory borrowed for the emulated
device.  I'm keeping the driver out of tree for a until 4.13 since I plan on
reworking the firmware interface anyway and There's at least one showstopper
bug.


Thanks,
Oliver

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
