Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga06.intel.com (mga06.intel.com [134.134.136.31])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 5C1C121A00AE6
 for <linux-nvdimm@lists.01.org>; Thu,  8 Nov 2018 06:45:01 -0800 (PST)
From: "Dorau, Lukasz" <lukasz.dorau@intel.com>
Subject: nfit_test.ko.xz needs unknown symbol ....
Date: Thu, 8 Nov 2018 14:44:59 +0000
Message-ID: <D9FFE20C522965449E182ACE73889AEBF4FB0B37@IRSMSX101.ger.corp.intel.com>
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
To: "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>
List-ID: <linux-nvdimm@lists.01.org>

Hi,

I am building and installing the linux kernel from the 'libnvdimm-for-next' branch at git://git.kernel.org/pub/scm/linux/kernel/git/nvdimm/nvdimm.git with the 'nfit_test' kernel module.

I have set in the .config file:

CONFIG_X86_PMEM_LEGACY=m
CONFIG_ZONE_DEVICE=y
CONFIG_LIBNVDIMM=m
CONFIG_BLK_DEV_PMEM=m
CONFIG_ND_BLK=m
CONFIG_BTT=y
CONFIG_NVDIMM_PFN=y
CONFIG_NVDIMM_DAX=y
CONFIG_DEV_DAX_PMEM=m

I ran:

$ make
$ make M=tools/testing/nvdimm
$ sudo make M=tools/testing/nvdimm modules_install
$ sudo make modules_install

and I got:

[...]
DEPMOD  4.19.0-rc4-nfit_test
depmod: WARNING: /lib/modules/4.19.0-rc4-nfit_test/extra/test/nfit_test.ko.xz needs unknown symbol libnvdimm_test
depmod: WARNING: /lib/modules/4.19.0-rc4-nfit_test/extra/test/nfit_test.ko.xz needs unknown symbol acpi_nfit_test
depmod: WARNING: /lib/modules/4.19.0-rc4-nfit_test/extra/test/nfit_test.ko.xz needs unknown symbol pmem_test
depmod: WARNING: /lib/modules/4.19.0-rc4-nfit_test/extra/test/nfit_test.ko.xz needs unknown symbol device_dax_test

Does anyone know what could be wrong here?

--
Lukasz
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
