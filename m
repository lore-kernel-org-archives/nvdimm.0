Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga04.intel.com (mga04.intel.com [192.55.52.120])
 by ml01.01.org (Postfix) with ESMTP id 25FE61A202B
 for <linux-nvdimm@lists.01.org>; Wed, 13 Apr 2016 10:20:34 -0700 (PDT)
Date: Wed, 13 Apr 2016 11:19:33 -0600
From: Ross Zwisler <ross.zwisler@linux.intel.com>
Subject: Re: [PATCH] pmem: fix BUG() error in pmem.h:48 on X86_32
Message-ID: <20160413171933.GA24879@linux.intel.com>
References: <1460506252-8596-1-git-send-email-toshi.kani@hpe.com>
 <CAPcyv4hDLN1F-A3bsQdBdksFP6hWnpw_KkgWwLC5UcfcmcSr-Q@mail.gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <CAPcyv4hDLN1F-A3bsQdBdksFP6hWnpw_KkgWwLC5UcfcmcSr-Q@mail.gmail.com>
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
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>
List-ID: <linux-nvdimm@lists.01.org>

On Tue, Apr 12, 2016 at 10:24:25PM -0700, Dan Williams wrote:
> On Tue, Apr 12, 2016 at 5:10 PM, Toshi Kani <toshi.kani@hpe.com> wrote:
> > After 'commit fc0c2028135c ("x86, pmem: use memcpy_mcsafe()
> > for memcpy_from_pmem()")', probing a PMEM device hits the BUG()
> > error below on X86_32 kernel.
> >
> >  kernel BUG at include/linux/pmem.h:48!
> >
> > memcpy_from_pmem() calls arch_memcpy_from_pmem(), which is
> > unimplemented since CONFIG_ARCH_HAS_PMEM_API is undefined on
> > X86_32.
> >
> > Fix the BUG() error by adding default_memcpy_from_pmem().
> >
> > Signed-off-by: Toshi Kani <toshi.kani@hpe.com>
> > Cc: Dan Williams <dan.j.williams@intel.com>
> > Cc: Ross Zwisler <ross.zwisler@linux.intel.com>
> 
> Whoops, I'll add a 32-bit boot test to my release criteria.  Thanks Toshi!

Yep, this patch looks correct to me.

Reviewed-by: Ross Zwisler <ross.zwisler@linux.intel.com>
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
