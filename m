Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from NAM01-BN3-obe.outbound.protection.outlook.com
 (mail-bn3nam01on070c.outbound.protection.outlook.com
 [IPv6:2a01:111:f400:fe41::70c])
 (using TLSv1 with cipher ECDHE-RSA-AES256-SHA (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id C43971A1DFE
 for <linux-nvdimm@lists.01.org>; Thu,  4 Aug 2016 06:14:23 -0700 (PDT)
Subject: Re: [ndctl PATCH 0/4] misc updates for v54
References: <147026658649.11162.4510254495491443980.stgit@dwillia2-desk3.amr.corp.intel.com>
From: Linda Knippers <linda.knippers@hpe.com>
Message-ID: <92b2d689-a0c8-2848-2b99-67c3a3cf5de5@hpe.com>
Date: Thu, 4 Aug 2016 09:14:09 -0400
MIME-Version: 1.0
In-Reply-To: <147026658649.11162.4510254495491443980.stgit@dwillia2-desk3.amr.corp.intel.com>
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
To: Dan Williams <dan.j.williams@intel.com>, linux-nvdimm@lists.01.org
List-ID: <linux-nvdimm@lists.01.org>



On 8/3/2016 7:23 PM, Dan Williams wrote:
> Some test and output tidy-ups for the next release.
> 
> Speaking of ndctl-v54, there's still the pending "btt-size" patch from
> Vishal that is awaiting the kernel enabling to land before the release
> goes out.

I ran his patched ndctl with an old kernel and it ran fine, just didn't
display the size, so it should be safe.

-- ljk

> 
> ---
> 
> Dan Williams (4):
>       util: require --idle to list 0-sized device-dax instances
>       test: ensure create.sh always picks a suitable BTT-host namespace
>       test: skip pmem/blk-ns tests on KVM
>       test: skip 4.7+ tests on older kernels
> 
> 
>  ndctl/Makefile.am                 |    2 +
>  ndctl/builtin-list.c              |    2 +
>  ndctl/builtin-xaction-namespace.c |    2 +
>  ndctl/util/json.c                 |   14 +++++--
>  ndctl/util/json.h                 |    3 +-
>  test/blk_namespaces.c             |   17 +++++++++
>  test/create.sh                    |    2 +
>  test/dax-errors.sh                |    9 +++++
>  test/device-dax.sh                |   10 +++++
>  test/libndctl.c                   |   70 +++++++++++++++++++++++--------------
>  test/pmem_namespaces.c            |   18 ++++++++++
>  11 files changed, 113 insertions(+), 36 deletions(-)
> _______________________________________________
> Linux-nvdimm mailing list
> Linux-nvdimm@lists.01.org
> https://lists.01.org/mailman/listinfo/linux-nvdimm
> 
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
