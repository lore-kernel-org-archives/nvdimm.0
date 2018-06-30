Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mgwkm02.jp.fujitsu.com (mgwkm02.jp.fujitsu.com [202.219.69.169])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 8257B203369E1
 for <linux-nvdimm@lists.01.org>; Sat, 30 Jun 2018 01:07:49 -0700 (PDT)
Received: from g01jpfmpwkw02.exch.g01.fujitsu.local
 (g01jpfmpwkw02.exch.g01.fujitsu.local [10.0.193.56])
 by kw-mxauth.gw.nic.fujitsu.com (Postfix) with ESMTP id 85201AC00C1
 for <linux-nvdimm@lists.01.org>; Sat, 30 Jun 2018 17:07:41 +0900 (JST)
From: "Qi, Fuli" <qi.fuli@jp.fujitsu.com>
Subject: Question about ndctl unit tests
Date: Sat, 30 Jun 2018 08:07:40 +0000
Message-ID: <0DEDF3B159719A448A49EF0E7B11E32237E966C2@g01jpexmbkw01>
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
Cc: "Mizuma, Masayoshi" <m.mizuma@jp.fujitsu.com>, Gotou,
List-ID: <linux-nvdimm@lists.01.org>

Hi,

When I ran the unit tests, I found "libndctl" and "dsm-fail" cannot pass the test.
Here is the test log.

# less test/libndctl.log
libkmod: kmod_module_remove_module: could not remove 'nfit_test': No such file or directory
check_set_config_data: dimm: 0 read2 data miscompare: 0
check_set_config_data: dimm: 0x1 read2 data miscompare: 0
check_set_config_data: dimm: 0x100 read2 data miscompare: 0
check_set_config_data: dimm: 0x101 read2 data miscompare: 0
check_dax_autodetect: dax_ndns: 0x1049f10 ndns: 0x1049f10
namespace1.0: expected write_cache enabled
check_namespaces: namespace1.0 validate_write_cache failed
ndctl-test0 failed: -6
libkmod: kmod_module_remove_module: could not remove 'nfit_test': Resource temporarily unavailable
libdaxctl: daxctl_unref: context 0x1038170 released
libndctl: ndctl_unref: context 0x1039290 released
FAIL libndctl (exit status: 1)

# less test/dsm-fail.log
victim: nmem0
validate_namespace_options:571: region1: falling back to a 4K alignment
validate_namespace_options:571: region1: falling back to a 4K alignment
do_test:294
libndctl: ndctl_dimm_enable: nmem0: failed to enable
fail expected nmem0 enable success victim: nmem0 rc: -6
libkmod: kmod_module_remove_module: could not remove 'nfit_test': Resource temporarily unavailable
libdaxctl: daxctl_unref: context 0x89f170 released
libndctl: ndctl_unref: context 0x8a0290 released
{
  "dev":"namespace1.0",
  "mode":"raw",
  "size":4194304,
  "uuid":"9a07ca1d-54cd-4252-b87e-475b24af8a1c",
  "sector_size":512,
  "blockdev":"pmem1"
}
{
  "dev":"namespace1.1",
  "mode":"raw",
  "size":4194304,
  "uuid":"2eb40a75-5c5f-4ed9-b36e-4fd0abba7783",
  "sector_size":512,
  "blockdev":"pmem1.1"
}
FAIL dsm-fail (exit status: 250)

And my kernel version:
$ uname -a
Linux 4.18.0-rc2+ #25 SMP

I guess the reason is that the nfit_test module cannot be removed.
# modprobe -r nfit_test
modprobe: FATAL: Module nfit_test is in use.
# lsmod | grep nfit_test
nfit_test              40960  8
nd_pmem                20480  1 nfit_test
nfit                   65536  1 nfit_test
device_dax             20480  2 dax_pmem,nfit_test
libnvdimm             163840  7 dax_pmem,nfit_test,nd_btt,nd_pmem,nd_e820,nd_blk,nfit
nfit_test_iomap        20480  6 dax_pmem,nfit_test,device_dax,nd_pmem,libnvdimm,nfit

Does anyone know how to fix it?

Thank you very much.
QI
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
