Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-oi0-x22f.google.com (mail-oi0-x22f.google.com
 [IPv6:2607:f8b0:4003:c06::22f])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 647221A1E03
 for <linux-nvdimm@lists.01.org>; Tue, 28 Jun 2016 09:26:46 -0700 (PDT)
Received: by mail-oi0-x22f.google.com with SMTP id r2so30241896oih.2
 for <linux-nvdimm@lists.01.org>; Tue, 28 Jun 2016 09:26:11 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20160628082257.4z6tfucszvebhzus@c203.arch.suse.de>
References: <20160628082257.4z6tfucszvebhzus@c203.arch.suse.de>
From: Dan Williams <dan.j.williams@intel.com>
Date: Tue, 28 Jun 2016 09:26:09 -0700
Message-ID: <CAPcyv4gH32tGM-YHVYwm1FuNp9GAerOKjpoPS6eAwNVZberPPQ@mail.gmail.com>
Subject: Re: test suite errors
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
To: Johannes Thumshirn <jthumshirn@suse.de>
Cc: "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>
List-ID: <linux-nvdimm@lists.01.org>

On Tue, Jun 28, 2016 at 1:22 AM, Johannes Thumshirn <jthumshirn@suse.de> wrote:
> Hi,
>
> I get the following error when running ndctl's make check:
>
> check_smart: HAVE_NDCTL_SMART disabled, skipping
> check_smart_threshold: HAVE_NDCTL_SMART disabled, skipping
> check_set_config_data: dimm: 0 read2 data miscompare: 0
> check_smart: HAVE_NDCTL_SMART disabled, skipping
> check_smart_threshold: HAVE_NDCTL_SMART disabled, skipping
> check_set_config_data: dimm: 0x1 read2 data miscompare: 0
> check_smart: HAVE_NDCTL_SMART disabled, skipping
> check_smart_threshold: HAVE_NDCTL_SMART disabled, skipping
> check_set_config_data: dimm: 0x100 read2 data miscompare: 0
> check_smart: HAVE_NDCTL_SMART disabled, skipping
> check_smart_threshold: HAVE_NDCTL_SMART disabled, skipping
> check_set_config_data: dimm: 0x101 read2 data miscompare: 0
> check_dax_create: 4
> __check_dax_create: dax13.0 align: 1
> libdaxctl: daxctl_region_unref: region13 released
> __check_dax_create: dax13.1 align: 1073741824
> libndctl: ndctl_dax_enable: dax13.1: failed to enable
> __check_dax_create: dax13.1 align: 4096
> libdaxctl: daxctl_region_unref: region13 released
> __check_dax_create: dax13.0 align: 2097152
> libndctl: ndctl_dax_enable: dax13.0: failed to enable

Do you have CONFIG_DEV_DAX_PMEM=m?

> dax13.0: expected dax enable success, region13 read-write
> namespace13.0: failed to create dax
> namespace13.0: failed to configure namespace
> ndctl-test0 failed: -6
> libkmod: kmod_module_remove_module: could not remove 'nfit_test': Resource temporarily unavailable
> libdaxctl: daxctl_unref: context 0xe1b410 released
> libndctl: ndctl_unref: context 0xe13290 released
>
> Looking at nfit_test there are indeed some holders left:
> linux-te3r:~/ndctl/test # lsmod | grep nfit_test
> nfit_test              24576  9
> nfit                   45056  9 nfit_test
> libnvdimm             135168  6 nfit,dax_pmem,nd_pmem,nfit_test,nd_blk,nd_btt
> nfit_test_iomap        16384  6 dax,nfit,libnvdimm,dax_pmem,nd_pmem,nfit_test
> linux-te3r:~/ndctl/test #

This is intentional so that we can do some forensics after a failure.
All "bus provider" modules (i.e. nfit_test, nfit, and nd_e820) are
pinned while any of their regions are active.  Disable all regions to
remove a module:

# ndctl disable-region all
# modprobe -r nfit_test
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
