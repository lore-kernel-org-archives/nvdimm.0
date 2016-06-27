Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mx2.suse.de (mx2.suse.de [195.135.220.15])
 (using TLSv1 with cipher ECDHE-RSA-AES256-SHA (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 105641A1E01
 for <linux-nvdimm@lists.01.org>; Sun, 26 Jun 2016 23:01:28 -0700 (PDT)
Date: Mon, 27 Jun 2016 08:00:43 +0200
From: Johannes Thumshirn <jthumshirn@suse.de>
Subject: Re: [PATCH 0/2] nfit_test: convert to vmalloc()
Message-ID: <20160627060043.5ldljarh3hg6htj3@c203.arch.suse.de>
References: <146698272810.40036.6685354433183952465.stgit@dwillia2-desk3.amr.corp.intel.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <146698272810.40036.6685354433183952465.stgit@dwillia2-desk3.amr.corp.intel.com>
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
To: Dan Williams <dan.j.williams@intel.com>
Cc: linux-kernel@vger.kernel.org, linux-nvdimm@lists.01.org
List-ID: <linux-nvdimm@lists.01.org>

On Sun, Jun 26, 2016 at 04:12:08PM -0700, Dan Williams wrote:
> While backporting nfit_test to distro kernels a conflict between CMA and
> SWIOTLB was discovered. CMA requirements have also been a stumbling
> point for others trying to execute the tests.
> =


Oh this is more than welcome, thanks for changing this.
Consider this series =

Acked-by: Johannes Thumshirn <jthumshirn@suse.de>


> ---
> =

> Dan Williams (2):
>       libnvdimm, pmem: allow nfit_test to override pmem_direct_access()
>       tools/testing/nvdimm: replace CONFIG_DMA_CMA dependency with vmallo=
c()
> =

> =

>  drivers/nvdimm/pmem.c                 |   18 ++---------
>  drivers/nvdimm/pmem.h                 |   24 +++++++++++++++
>  include/linux/pfn_t.h                 |    5 ++-
>  kernel/memremap.c                     |    6 ----
>  tools/testing/nvdimm/Kbuild           |    5 ++-
>  tools/testing/nvdimm/pmem-dax.c       |   54 +++++++++++++++++++++++++++=
++++++
>  tools/testing/nvdimm/test/iomap.c     |   19 +++++++++++-
>  tools/testing/nvdimm/test/nfit.c      |   48 ++++-----------------------=
--
>  tools/testing/nvdimm/test/nfit_test.h |    2 +
>  9 files changed, 115 insertions(+), 66 deletions(-)
>  create mode 100644 drivers/nvdimm/pmem.h
>  create mode 100644 tools/testing/nvdimm/pmem-dax.c
> _______________________________________________
> Linux-nvdimm mailing list
> Linux-nvdimm@lists.01.org
> https://lists.01.org/mailman/listinfo/linux-nvdimm

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
