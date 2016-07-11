Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga04.intel.com (mga04.intel.com [192.55.52.120])
 by ml01.01.org (Postfix) with ESMTP id D676D1A1E43
 for <linux-nvdimm@lists.01.org>; Sun, 10 Jul 2016 20:50:29 -0700 (PDT)
From: "Li, Philip" <philip.li@intel.com>
Subject: RE: [PATCH v2 08/17] libnvdimm: introduce nvdimm_flush() and
 nvdimm_has_flush()
Date: Mon, 11 Jul 2016 03:48:23 +0000
Message-ID: <831EE4E5E37DCC428EB295A351E6624914449271@shsmsx102.ccr.corp.intel.com>
References: <146812111205.32932.3785207412939078453.stgit@dwillia2-desk3.amr.corp.intel.com>
 <201607101237.dmgprEIr%fengguang.wu@intel.com>
 <CAPcyv4i2BVr-7A2VLot9HahbQ2=_tc6A0kX-Dt+Mm5EsoWGGQQ@mail.gmail.com>
In-Reply-To: <CAPcyv4i2BVr-7A2VLot9HahbQ2=_tc6A0kX-Dt+Mm5EsoWGGQQ@mail.gmail.com>
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
To: "Williams, Dan J" <dan.j.williams@intel.com>, lkp <lkp@intel.com>
Cc: "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, Linux ACPI <linux-acpi@vger.kernel.org>, "kbuild-all@01.org" <kbuild-all@01.org>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, Christoph Hellwig <hch@lst.de>
List-ID: <linux-nvdimm@lists.01.org>



> -----Original Message-----
> From: Williams, Dan J
> Sent: Sunday, July 10, 2016 1:01 PM
> To: lkp <lkp@intel.com>
> Cc: kbuild-all@01.org; linux-nvdimm@lists.01.org; linux-fsdevel <linux-
> fsdevel@vger.kernel.org>; Linux ACPI <linux-acpi@vger.kernel.org>; Ross
> Zwisler <ross.zwisler@linux.intel.com>; Christoph Hellwig <hch@lst.de>; linux-
> kernel@vger.kernel.org
> Subject: Re: [PATCH v2 08/17] libnvdimm: introduce nvdimm_flush() and
> nvdimm_has_flush()
> 
> On Sat, Jul 9, 2016 at 9:47 PM, kbuild test robot <lkp@intel.com> wrote:
> > Hi,
> >
> > [auto build test ERROR on linux-nvdimm/libnvdimm-for-next]
> > [also build test ERROR on next-20160708]
> > [cannot apply to v4.7-rc6]
> > [if your patch is applied to the wrong git tree, please drop us a note to help
> improve the system]
> >
> > url:    https://github.com/0day-ci/linux/commits/Dan-Williams/replace-
> pcommit-with-ADR-or-directed-flushing/20160710-113558
> > base:   https://git.kernel.org/pub/scm/linux/kernel/git/nvdimm/nvdimm.git
> libnvdimm-for-next
> > config: i386-randconfig-r0-201628 (attached as .config)
> > compiler: gcc-6 (Debian 6.1.1-1) 6.1.1 20160430
> > reproduce:
> >         # save the attached .config to linux build tree
> >         make ARCH=i386
> 
> Hi kbuild team,
> 
> Can we add an "i386 allmodconfig" build to the standard "BUILD
> SUCCESS" notification runs?  I had two positive build results on a

Thanks, yes, currently i386 allmodconfig has been covered for all kinds of test including
kbiuld on registered repo or LKML patches. If the test is running on a repo for its new commits,
a BUILD SUCCESS mail, it will list the current coverage by the time the mail is sent out like

m32r                       m32104ut_defconfig
m32r                     mappi3.smp_defconfig
m32r                         opsput_defconfig
m32r                           usrv_defconfig
xtensa                       common_defconfig
xtensa                          iss_defconfig
i386                             allmodconfig
mips                                   jz4740
mips                              allnoconfig

> private branch prior to posting this series, but the i386 runs did not
> build the nvdimm sub-system.
> 
> In any event this report is valid, so thank you for that!
> 
> 
> >
> > All errors (new ones prefixed by >>):
> >
> >    drivers/nvdimm/region_devs.c: In function 'nvdimm_flush':
> >>> drivers/nvdimm/region_devs.c:887:4: error: implicit declaration of function
> 'writeq' [-Werror=implicit-function-declaration]
> >        writeq(1, ndrd->flush_wpq[i][0]);
> >        ^~~~~~
> >    cc1: some warnings being treated as errors
> >
> > vim +/writeq +887 drivers/nvdimm/region_devs.c
> >
> >    881           * writes to avoid the cache via arch_memcpy_to_pmem().  The
> >    882           * final wmb() ensures ordering for the NVDIMM flush write.
> >    883           */
> >    884          wmb();
> >    885          for (i = 0; i < nd_region->ndr_mappings; i++)
> >    886                  if (ndrd->flush_wpq[i][0])
> >  > 887                          writeq(1, ndrd->flush_wpq[i][0]);
> >    888          wmb();
> >    889  }
> >    890  EXPORT_SYMBOL_GPL(nvdimm_flush);
> >
> > ---
> > 0-DAY kernel test infrastructure                Open Source Technology Center
> > https://lists.01.org/pipermail/kbuild-all                   Intel Corporation

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
