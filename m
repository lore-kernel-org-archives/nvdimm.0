Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-oi0-x229.google.com (mail-oi0-x229.google.com
 [IPv6:2607:f8b0:4003:c06::229])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id EEB1E1A1DFF
 for <linux-nvdimm@lists.01.org>; Tue, 12 Apr 2016 22:24:25 -0700 (PDT)
Received: by mail-oi0-x229.google.com with SMTP id p188so50258876oih.2
 for <linux-nvdimm@lists.01.org>; Tue, 12 Apr 2016 22:24:25 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1460506252-8596-1-git-send-email-toshi.kani@hpe.com>
References: <1460506252-8596-1-git-send-email-toshi.kani@hpe.com>
Date: Tue, 12 Apr 2016 22:24:25 -0700
Message-ID: <CAPcyv4hDLN1F-A3bsQdBdksFP6hWnpw_KkgWwLC5UcfcmcSr-Q@mail.gmail.com>
Subject: Re: [PATCH] pmem: fix BUG() error in pmem.h:48 on X86_32
From: Dan Williams <dan.j.williams@intel.com>
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
To: Toshi Kani <toshi.kani@hpe.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>
List-ID: <linux-nvdimm@lists.01.org>

On Tue, Apr 12, 2016 at 5:10 PM, Toshi Kani <toshi.kani@hpe.com> wrote:
> After 'commit fc0c2028135c ("x86, pmem: use memcpy_mcsafe()
> for memcpy_from_pmem()")', probing a PMEM device hits the BUG()
> error below on X86_32 kernel.
>
>  kernel BUG at include/linux/pmem.h:48!
>
> memcpy_from_pmem() calls arch_memcpy_from_pmem(), which is
> unimplemented since CONFIG_ARCH_HAS_PMEM_API is undefined on
> X86_32.
>
> Fix the BUG() error by adding default_memcpy_from_pmem().
>
> Signed-off-by: Toshi Kani <toshi.kani@hpe.com>
> Cc: Dan Williams <dan.j.williams@intel.com>
> Cc: Ross Zwisler <ross.zwisler@linux.intel.com>

Whoops, I'll add a 32-bit boot test to my release criteria.  Thanks Toshi!
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
