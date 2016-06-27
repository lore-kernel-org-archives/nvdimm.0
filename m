Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-lf0-x22c.google.com (mail-lf0-x22c.google.com
 [IPv6:2a00:1450:4010:c07::22c])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 835DB1A1E00
 for <linux-nvdimm@lists.01.org>; Mon, 27 Jun 2016 04:38:23 -0700 (PDT)
Received: by mail-lf0-x22c.google.com with SMTP id l188so153289037lfe.2
 for <linux-nvdimm@lists.01.org>; Mon, 27 Jun 2016 04:37:49 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <146698346627.40541.14661847967712551305.stgit@dwillia2-desk3.amr.corp.intel.com>
References: <146698346627.40541.14661847967712551305.stgit@dwillia2-desk3.amr.corp.intel.com>
From: Yigal Korman <yigal@plexistor.com>
Date: Mon, 27 Jun 2016 14:37:28 +0300
Message-ID: <CACTTzNa=JNiDbfCshWJE4YNbKJpjpscRXha9W1QiYaM-vPjrVA@mail.gmail.com>
Subject: Re: [ndctl PATCH 0/9] updates for vmalloc-based nfit_test and
 device-dax
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
Cc: linux-nvdimm@lists.01.org
List-ID: <linux-nvdimm@lists.01.org>

On Mon, Jun 27, 2016 at 2:24 AM, Dan Williams <dan.j.williams@intel.com> wrote:
> The kernel is moving from CMA to vmalloc() backed resources to expand
> the range of kernels that the tests can be compiled against.  As a
> result some of the huge page tests need to move from nfit_test to
> memmap=ss!nn defined memory ranges.

Don't forget to update README.md, it describes how to use CMA for the testing...

>
> The new device-dax test exposed some bugs and missing capabilities in
> the 'create-namespace' and 'list' commands.
>
> ---
>
> Dan Williams (9):
>       ndctl: deprecate pcommit
>       test, libndctl: invalidate dax info blocks before reuse
>       ndctl, list: list device-dax instances beneath a namespace
>       ndctl, list: allow limiting namespace listing
>       ndctl: add libs dependency to spec file
>       ndctl, create-namespace: fix blk-namepsaces vs device-dax
>       ndctl, create-namespace: fix device-dax vs --map=
>       test, libndctl: move pfn + dax configurations to a destructive test
>       test, libndctl: kill some dead code
>
>
>  Documentation/ndctl-list.txt      |    6 +++
>  ndctl.spec.in                     |    2 +
>  ndctl/Makefile.am                 |    3 -
>  ndctl/builtin-bat.c               |    5 --
>  ndctl/builtin-list.c              |    6 +++
>  ndctl/builtin-xaction-namespace.c |   12 ++++-
>  ndctl/util/json.c                 |   40 ++++++++++++++++++
>  test.h                            |    1
>  test/Makefile.am                  |    8 +---
>  test/dax-dev.c                    |   22 +++++++---
>  test/dax.sh                       |    5 +-
>  test/device-dax.c                 |   32 ++++++++++++++
>  test/device-dax.sh                |   30 ++++++++++++++
>  test/libndctl.c                   |   82 ++++++++++++++++---------------------
>  test/mmap.sh                      |    7 +++
>  test/pcommit.c                    |   76 ----------------------------------
>  util/filter.c                     |   21 +++++++++
>  util/filter.h                     |    2 +
>  18 files changed, 211 insertions(+), 149 deletions(-)
>  create mode 100644 test/device-dax.c
>  create mode 100755 test/device-dax.sh
>  delete mode 100644 test/pcommit.c
> _______________________________________________
> Linux-nvdimm mailing list
> Linux-nvdimm@lists.01.org
> https://lists.01.org/mailman/listinfo/linux-nvdimm
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
