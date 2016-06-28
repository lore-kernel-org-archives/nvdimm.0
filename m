Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mx2.suse.de (mx2.suse.de [195.135.220.15])
 (using TLSv1 with cipher ECDHE-RSA-AES256-SHA (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 8FE051A1E03
 for <linux-nvdimm@lists.01.org>; Tue, 28 Jun 2016 01:23:33 -0700 (PDT)
Received: from relay1.suse.de (charybdis-ext.suse.de [195.135.220.254])
 by mx2.suse.de (Postfix) with ESMTP id 6F437AD00
 for <linux-nvdimm@lists.01.org>; Tue, 28 Jun 2016 08:22:57 +0000 (UTC)
Date: Tue, 28 Jun 2016 10:22:57 +0200
From: Johannes Thumshirn <jthumshirn@suse.de>
Subject: test suite errors
Message-ID: <20160628082257.4z6tfucszvebhzus@c203.arch.suse.de>
MIME-Version: 1.0
Content-Disposition: inline
List-Unsubscribe: <https://lists.01.org/mailman/options/linux-nvdimm>,
 <mailto:linux-nvdimm-request@lists.01.org?subject=unsubscribe>
List-Archive: <http://lists.01.org/pipermail/linux-nvdimm/>
List-Post: <mailto:linux-nvdimm@lists.01.org>
List-Help: <mailto:linux-nvdimm-request@lists.01.org?subject=help>
List-Subscribe: <https://lists.01.org/mailman/listinfo/linux-nvdimm>,
 <mailto:linux-nvdimm-request@lists.01.org?subject=subscribe>
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Errors-To: linux-nvdimm-bounces@lists.01.org
Sender: "Linux-nvdimm" <linux-nvdimm-bounces@lists.01.org>
To: linux-nvdimm@lists.01.org
List-ID: <linux-nvdimm@lists.01.org>

Hi,

I get the following error when running ndctl's make check:

check_smart: HAVE_NDCTL_SMART disabled, skipping
check_smart_threshold: HAVE_NDCTL_SMART disabled, skipping
check_set_config_data: dimm: 0 read2 data miscompare: 0
check_smart: HAVE_NDCTL_SMART disabled, skipping
check_smart_threshold: HAVE_NDCTL_SMART disabled, skipping
check_set_config_data: dimm: 0x1 read2 data miscompare: 0
check_smart: HAVE_NDCTL_SMART disabled, skipping
check_smart_threshold: HAVE_NDCTL_SMART disabled, skipping
check_set_config_data: dimm: 0x100 read2 data miscompare: 0
check_smart: HAVE_NDCTL_SMART disabled, skipping
check_smart_threshold: HAVE_NDCTL_SMART disabled, skipping
check_set_config_data: dimm: 0x101 read2 data miscompare: 0
check_dax_create: 4
__check_dax_create: dax13.0 align: 1
libdaxctl: daxctl_region_unref: region13 released
__check_dax_create: dax13.1 align: 1073741824
libndctl: ndctl_dax_enable: dax13.1: failed to enable
__check_dax_create: dax13.1 align: 4096
libdaxctl: daxctl_region_unref: region13 released
__check_dax_create: dax13.0 align: 2097152
libndctl: ndctl_dax_enable: dax13.0: failed to enable
dax13.0: expected dax enable success, region13 read-write
namespace13.0: failed to create dax
namespace13.0: failed to configure namespace
ndctl-test0 failed: -6
libkmod: kmod_module_remove_module: could not remove 'nfit_test': Resource =
temporarily unavailable
libdaxctl: daxctl_unref: context 0xe1b410 released
libndctl: ndctl_unref: context 0xe13290 released

Looking at nfit_test there are indeed some holders left:
linux-te3r:~/ndctl/test # lsmod | grep nfit_test
nfit_test              24576  9
nfit                   45056  9 nfit_test
libnvdimm             135168  6 nfit,dax_pmem,nd_pmem,nfit_test,nd_blk,nd_b=
tt
nfit_test_iomap        16384  6 dax,nfit,libnvdimm,dax_pmem,nd_pmem,nfit_te=
st
linux-te3r:~/ndctl/test #

This is with 4.7-rc4

The other tests of the suite are all PASS.

Has anyone else seen this problems?

Thanks,
	Johannes

-- =

Johannes Thumshirn                                          Storage
jthumshirn@suse.de                                +49 911 74053 689
SUSE LINUX GmbH, Maxfeldstr. 5, 90409 N=FCrnberg
GF: Felix Imend=F6rffer, Jane Smithard, Graham Norton
HRB 21284 (AG N=FCrnberg)
Key fingerprint =3D EC38 9CAB C2C4 F25D 8600 D0D0 0393 969D 2D76 0850
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
