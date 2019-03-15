Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail3-relais-sop.national.inria.fr
 (mail3-relais-sop.national.inria.fr [192.134.164.104])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 87A252194EB76
 for <linux-nvdimm@lists.01.org>; Fri, 15 Mar 2019 15:31:51 -0700 (PDT)
From: Brice Goglin <Brice.Goglin@inria.fr>
Subject: failure to setup devdax over fake nvdimm
Message-ID: <54fb48ed-f681-1420-b2d0-082ed14802a7@inria.fr>
Date: Fri, 15 Mar 2019 23:31:49 +0100
MIME-Version: 1.0
Content-Language: en-US
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
Cc: "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>
List-ID: <linux-nvdimm@lists.01.org>

Hello Dan,

On a machine emulating nvdimms over DDR using the memmap kernel parameter,
I can't enable devdax anymore with ndctl, when using your libnvdimm-pending
branch (1ffc664f9b8ca7346f2af0fb4f62b923193bf65c):

# ndctl create-namespace -f -e namespace1.0 -t pmem -m devdax
libndctl: ndctl_dax_enable: dax1.0: failed to enable
  Error: namespace1.0: failed to enable
failed to reconfigure namespace: No such device or address

In the previous version of your libnvdimm-pending branch that I used before
(8d4a7e3da68e88a6efd3acb5cc971d0c2ca219a4 from January 8th) this ndctl line
worked fine right after boot.

The difference between strace ndctl doesn't show anything obvious.
* /sys/devices/platform/e820_pmem/ndbus0/region1/namespace1.0/holder_class contains nothing instead of "dax"
* /sys/devices/platform/e820_pmem/ndbus0/region1/dax_seed contains dax1.0 instead of dax1.1

Any idea where to look?

Thanks
Brice


_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
