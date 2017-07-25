Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga11.intel.com (mga11.intel.com [192.55.52.93])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id BB90721B06E91
 for <linux-nvdimm@lists.01.org>; Tue, 25 Jul 2017 15:40:33 -0700 (PDT)
Subject: [PATCH 0/4] ndctl: integrate with tools/ infrastructure
From: Dan Williams <dan.j.williams@intel.com>
Date: Tue, 25 Jul 2017 15:36:10 -0700
Message-ID: <150102217021.2258.1380624380896006.stgit@dwillia2-desk3.amr.corp.intel.com>
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
To: linux-nvdimm@lists.01.org
Cc: Peter Zijlstra <peterz@infradead.org>, linux-kernel@vger.kernel.org, Arnaldo Carvalho de Melo <acme@kernel.org>, Arnaldo Carvalho de Melo <acme@redhat.com>, Alexander Shishkin <alexander.shishkin@linux.intel.com>, Ingo Molnar <mingo@redhat.com>, Namhyung Kim <namhyung@kernel.org>
List-ID: <linux-nvdimm@lists.01.org>

For 4.14 I am proposing that ndctl development move into the kernel tree
[1]. The main motivations are to get the userspace tests in the same
source tree as the kernel-space test infrastructure, and to raise the
profile of this cpu-architecture and vendor agnostic nvdimm tooling.

There are some benefits to the kernel-tree as well. For example, more
users of the tools/lib/ common code and future expansion of that code to
support endian handling and GUID parsing.

These patches jettison the custom port of the git option parsing and
sub-command handling in favor of tools/lib/subcmd/. It removes the ccan
modules that have replacement in tools/include/. It also removes a custom
port of bitmap primitives.

The main difference of this tool compared to perf that it uses
autotools for builds and a different compiler-warning regime. It is not
clear that it is worth reconciling those differences in the near term.

Comments welcome...

These patches are also available on the for-4.14/ndctl branch of
djbw/nvdimm.git [2].

[1]: https://lkml.org/lkml/2017/7/21/688
[2]: https://git.kernel.org/pub/scm/linux/kernel/git/djbw/nvdimm.git/log/?h=for-4.14/ndctl

---

Dan Williams (4):
      ndctl: switch to kernel versioning scheme
      MAINTAINERS: add ndctl files to libnvdimm
      ndctl: switch to tools/include/linux/{kernel,list,bitmap}.h
      ndctl: switch to tools/lib/subcmd/

 MAINTAINERS                                  |    1 
 tools/include/linux/hashtable.h              |    4 
 tools/include/linux/kernel.h                 |   10 
 tools/lib/subcmd/parse-options.h             |    1 
 tools/ndctl/Makefile.am                      |   18 -
 tools/ndctl/Makefile.am.in                   |    2 
 tools/ndctl/ccan/array_size/LICENSE          |    1 
 tools/ndctl/ccan/array_size/array_size.h     |   26 -
 tools/ndctl/ccan/container_of/LICENSE        |    1 
 tools/ndctl/ccan/container_of/container_of.h |  109 ----
 tools/ndctl/ccan/list/LICENSE                |    1 
 tools/ndctl/ccan/list/list.c                 |   43 --
 tools/ndctl/ccan/list/list.h                 |  656 ------------------------
 tools/ndctl/ccan/minmax/LICENSE              |    1 
 tools/ndctl/ccan/minmax/minmax.h             |   65 --
 tools/ndctl/configure.ac                     |    1 
 tools/ndctl/daxctl/daxctl.c                  |    4 
 tools/ndctl/daxctl/lib/libdaxctl-private.h   |    4 
 tools/ndctl/daxctl/lib/libdaxctl.c           |   20 -
 tools/ndctl/daxctl/list.c                    |    6 
 tools/ndctl/git-version                      |    8 
 tools/ndctl/ndctl/bat.c                      |    4 
 tools/ndctl/ndctl/check.c                    |   16 -
 tools/ndctl/ndctl/create-nfit.c              |   16 -
 tools/ndctl/ndctl/dimm.c                     |   15 -
 tools/ndctl/ndctl/lib/libndctl-private.h     |    6 
 tools/ndctl/ndctl/lib/libndctl-smart.c       |    5 
 tools/ndctl/ndctl/lib/libndctl.c             |  116 ++--
 tools/ndctl/ndctl/list.c                     |    6 
 tools/ndctl/ndctl/namespace.c                |    8 
 tools/ndctl/ndctl/ndctl.c                    |    4 
 tools/ndctl/ndctl/region.c                   |    3 
 tools/ndctl/ndctl/test.c                     |    4 
 tools/ndctl/ndctl/util/json-smart.c          |    2 
 tools/ndctl/nfit.h                           |    1 
 tools/ndctl/test/blk_namespaces.c            |    2 
 tools/ndctl/test/core.c                      |    2 
 tools/ndctl/test/daxdev-errors.c             |    2 
 tools/ndctl/test/device-dax.c                |    2 
 tools/ndctl/test/dpa-alloc.c                 |    2 
 tools/ndctl/test/dsm-fail.c                  |    2 
 tools/ndctl/test/libndctl.c                  |    3 
 tools/ndctl/test/multi-pmem.c                |    2 
 tools/ndctl/test/pmem_namespaces.c           |    3 
 tools/ndctl/util/bitmap.c                    |  131 -----
 tools/ndctl/util/bitmap.h                    |   44 --
 tools/ndctl/util/help.c                      |    4 
 tools/ndctl/util/json.c                      |    2 
 tools/ndctl/util/kernel.h                    |    9 
 tools/ndctl/util/list.h                      |   24 +
 tools/ndctl/util/parse-options.c             |  697 --------------------------
 tools/ndctl/util/parse-options.h             |  225 --------
 tools/ndctl/util/size.h                      |    1 
 tools/ndctl/util/util.h                      |    1 
 tools/perf/util/util.h                       |    2 
 55 files changed, 205 insertions(+), 2143 deletions(-)
 delete mode 120000 tools/ndctl/ccan/array_size/LICENSE
 delete mode 100644 tools/ndctl/ccan/array_size/array_size.h
 delete mode 120000 tools/ndctl/ccan/container_of/LICENSE
 delete mode 100644 tools/ndctl/ccan/container_of/container_of.h
 delete mode 120000 tools/ndctl/ccan/list/LICENSE
 delete mode 100644 tools/ndctl/ccan/list/list.c
 delete mode 100644 tools/ndctl/ccan/list/list.h
 delete mode 120000 tools/ndctl/ccan/minmax/LICENSE
 delete mode 100644 tools/ndctl/ccan/minmax/minmax.h
 delete mode 100644 tools/ndctl/util/bitmap.c
 delete mode 100644 tools/ndctl/util/bitmap.h
 create mode 100644 tools/ndctl/util/kernel.h
 create mode 100644 tools/ndctl/util/list.h
 delete mode 100644 tools/ndctl/util/parse-options.c
 delete mode 100644 tools/ndctl/util/parse-options.h
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
