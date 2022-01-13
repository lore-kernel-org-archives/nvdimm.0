Received: from mga03.intel.com (mga03.intel.com [134.134.136.65])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C374E2C82
	for <nvdimm@lists.linux.dev>; Thu, 13 Jan 2022 01:18:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1642036730; x=1673572730;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=b5DKdlfI/Zhu7OV/6YaFBPzZDlxIgJCOzgacJ+RMRWY=;
  b=jslCEf/Hc/uV0Y73U0T7eauSOMjJrMwI/OYjiMGBPjrRkSQB7JGQyi2U
   b4EQajOkz6U/A3cq+BaVLIwt4HmUdcOkEeGfiE2zfeQsu+dbvLG6NXJZt
   o0CS0QnthbTEmgCQufSipFdp5kDTOiG20nQvjSN815/0W6SNqqeSIQgTE
   TR9OM0ZqZtv9G0jLUVXo4pG9WKlRMk264pJtwdyHd0BHEOOwHNeM7DmOk
   0xAdQ09ktnWZZ3TJiA/+A0eRa1nLuCuZC1WkcHe6AtZuM4ARrRCFiF4JG
   AFOUWrM9BAab8Oz2BehOPl5JJ+usKaGZBl7kYGpydyJM6uYh6t/rmAq5h
   A==;
X-IronPort-AV: E=McAfee;i="6200,9189,10225"; a="243854439"
X-IronPort-AV: E=Sophos;i="5.88,284,1635231600"; 
   d="scan'208";a="243854439"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Jan 2022 17:18:50 -0800
X-IronPort-AV: E=Sophos;i="5.88,284,1635231600"; 
   d="scan'208";a="576769613"
Received: from alison-desk.jf.intel.com (HELO alison-desk) ([10.54.74.41])
  by fmsmga008-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Jan 2022 17:18:49 -0800
Date: Wed, 12 Jan 2022 17:23:49 -0800
From: Alison Schofield <alison.schofield@intel.com>
To: Dan Williams <dan.j.williams@intel.com>
Cc: vishal.l.verma@intel.com, Vaibhav Jain <vaibhav@linux.ibm.com>,
	nvdimm@lists.linux.dev, linux-cxl@vger.kernel.org
Subject: Re: [ndctl PATCH v3 00/16] ndctl: Meson support
Message-ID: <20220113012349.GA828486@alison-desk>
References: <164141829899.3990253.17547886681174580434.stgit@dwillia2-desk3.amr.corp.intel.com>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <164141829899.3990253.17547886681174580434.stgit@dwillia2-desk3.amr.corp.intel.com>

Hi Dan - I'll offer a Tested-by since I used it for v2 of the CXL Partitions:
https://lore.kernel.org/nvdimm/cover.1641965853.git.alison.schofield@intel.com/

Very FAST!

Tested-by: Alison Schofield <alison.schofield@intel.com>


On Wed, Jan 05, 2022 at 01:31:39PM -0800, Dan Williams wrote:
> Changes since v2 [1]:
> 
> - Rebase on v72
>   - Add Meson support for the new config file directory definitions.
>   - Add Meson support for landing the daxctl udev rule
>     daxdev-reconfigure service in the right directories
> - Include the deprecation of BLK Aperture test infrastructure
> - Include a miscellaneous doc clarification for 'ndctl update-firmware'
> - Fix the tests support for moving the build directory out-of-line
> - Include a fix for the deprectation of the dax_pmem_compat module
>   pending in the libnvdimm-for-next tree.
> 
> [1]: https://lore.kernel.org/r/163061537869.1943957.8491829881215255815.stgit@dwillia2-desk3.amr.corp.intel.com
> 
> ---
> 
> As mentioned in patch 14 the motiviation for converting to Meson is
> primarily driven by speed (an order of magnitude in some scenarios), but
> Meson also includes better test and debug-build support. The build
> language is easier to read, write, and debug. Meson is all around better
> suited to the next phase of the ndctl project that will include all
> things "device memory" related (ndctl, daxctl, and cxl).
> 
> In order to simplify the conversion the old BLK-aperture test
> infrastructure is jettisoned and it will also be removed upstream. Some
> other refactorings and fixups are included as well to better organize
> the utilty infrastructure between truly common and sub-tool specific.
> 
> Vishal,
> 
> In preparation for ndctl-v73 please consider pulling in this series
> early mainly for my own sanity of not needing to forward port more
> updates to the autotools infrastructure.
> 
> ---
> 
> Dan Williams (16):
>       ndctl/docs: Clarify update-firwmware activation 'overflow' conditions
>       ndctl/test: Prepare for BLK-aperture support removal
>       ndctl/test: Move 'reset()' to function in 'common'
>       ndctl/test: Initialize the label area by default
>       ndctl/test: Skip BLK flags checks
>       ndctl/test: Move sector-mode to a different region
>       ndctl: Deprecate BLK aperture support
>       ndctl/test: Fix support for missing dax_pmem_compat module
>       util: Distribute 'filter' and 'json' helpers to per-tool objects
>       Documentation: Drop attrs.adoc include
>       build: Drop unnecessary $tool/config.h includes
>       test: Prepare out of line builds
>       ndctl: Drop executable bit for bash-completion script
>       build: Add meson build infrastructure
>       build: Add meson rpmbuild support
>       ndctl: Jettison autotools
> 
> 
>  .gitignore                                         |   64 -
>  Documentation/cxl/Makefile.am                      |   61 -
>  Documentation/cxl/lib/Makefile.am                  |   58 -
>  Documentation/cxl/lib/meson.build                  |   79 +
>  Documentation/cxl/meson.build                      |   84 +
>  Documentation/daxctl/Makefile.am                   |   75 -
>  Documentation/daxctl/daxctl-reconfigure-device.txt |    2 
>  Documentation/daxctl/meson.build                   |   94 +
>  Documentation/ndctl/Makefile.am                    |  106 -
>  Documentation/ndctl/intel-nvdimm-security.txt      |    2 
>  Documentation/ndctl/labels-description.txt         |    5 
>  Documentation/ndctl/meson.build                    |  124 ++
>  Documentation/ndctl/ndctl-create-namespace.txt     |   29 
>  Documentation/ndctl/ndctl-init-labels.txt          |    7 
>  Documentation/ndctl/ndctl-list.txt                 |    4 
>  Documentation/ndctl/ndctl-load-keys.txt            |    2 
>  Documentation/ndctl/ndctl-monitor.txt              |    2 
>  Documentation/ndctl/ndctl-sanitize-dimm.txt        |    2 
>  Documentation/ndctl/ndctl-setup-passphrase.txt     |    2 
>  Documentation/ndctl/ndctl-update-firmware.txt      |   64 +
>  Documentation/ndctl/ndctl-update-passphrase.txt    |    2 
>  Documentation/ndctl/region-description.txt         |   10 
>  Makefile.am                                        |  103 -
>  Makefile.am.in                                     |   49 -
>  README.md                                          |    1 
>  autogen.sh                                         |   28 
>  clean_config.sh                                    |    2 
>  config.h.meson                                     |  151 ++
>  configure.ac                                       |  270 ----
>  contrib/meson.build                                |   28 
>  contrib/ndctl                                      |    0 
>  contrib/nfit_test_depmod.conf                      |    1 
>  cxl/Makefile.am                                    |   22 
>  cxl/filter.c                                       |   25 
>  cxl/filter.h                                       |    7 
>  cxl/json.c                                         |  214 +++
>  cxl/json.h                                         |    8 
>  cxl/lib/Makefile.am                                |   32 
>  cxl/lib/meson.build                                |   35 
>  cxl/list.c                                         |    4 
>  cxl/memdev.c                                       |    3 
>  cxl/meson.build                                    |   25 
>  daxctl/Makefile.am                                 |   40 -
>  daxctl/device.c                                    |    5 
>  daxctl/filter.c                                    |   43 +
>  daxctl/filter.h                                    |   12 
>  daxctl/json.c                                      |  245 +++
>  daxctl/json.h                                      |   18 
>  daxctl/lib/Makefile.am                             |   42 -
>  daxctl/lib/meson.build                             |   44 +
>  daxctl/list.c                                      |    4 
>  daxctl/meson.build                                 |   35 
>  daxctl/migrate.c                                   |    1 
>  meson.build                                        |  286 ++++
>  meson_options.txt                                  |   25 
>  ndctl.spec.in                                      |   15 
>  ndctl/Makefile.am                                  |   84 -
>  ndctl/bat.c                                        |    5 
>  ndctl/bus.c                                        |    4 
>  ndctl/check.c                                      |    2 
>  ndctl/dimm.c                                       |    6 
>  ndctl/filter.c                                     |   60 -
>  ndctl/filter.h                                     |   12 
>  ndctl/inject-error.c                               |    6 
>  ndctl/inject-smart.c                               |    6 
>  ndctl/json-smart.c                                 |    5 
>  ndctl/json.c                                       | 1114 ++++++++++++++
>  ndctl/json.h                                       |   24 
>  ndctl/keys.c                                       |    6 
>  ndctl/keys.h                                       |    0 
>  ndctl/lib/Makefile.am                              |   58 -
>  ndctl/lib/libndctl.c                               |    2 
>  ndctl/lib/meson.build                              |   48 +
>  ndctl/lib/papr.c                                   |    4 
>  ndctl/lib/private.h                                |    4 
>  ndctl/list.c                                       |    5 
>  ndctl/load-keys.c                                  |    7 
>  ndctl/meson.build                                  |   82 +
>  ndctl/monitor.c                                    |    5 
>  ndctl/namespace.c                                  |    6 
>  ndctl/region.c                                     |    3 
>  ndctl/test.c                                       |   11 
>  rhel/meson.build                                   |   22 
>  rpmbuild.sh                                        |    5 
>  sles/meson.build                                   |   35 
>  test.h                                             |    3 
>  test/Makefile.am                                   |  192 --
>  test/ack-shutdown-count-set.c                      |    2 
>  test/blk-exhaust.sh                                |   32 
>  test/blk_namespaces.c                              |  357 -----
>  test/btt-check.sh                                  |    7 
>  test/btt-errors.sh                                 |   16 
>  test/btt-pad-compat.sh                             |    9 
>  test/clear.sh                                      |    4 
>  test/common                                        |   59 +
>  test/core.c                                        |   57 +
>  test/create.sh                                     |   17 
>  test/dax-pmd.c                                     |   11 
>  test/dax.sh                                        |    6 
>  test/daxctl-create.sh                              |    4 
>  test/daxdev-errors.c                               |    2 
>  test/daxdev-errors.sh                              |    8 
>  test/device-dax-fio.sh                             |    2 
>  test/device-dax.c                                  |    2 
>  test/dm.sh                                         |    4 
>  test/dpa-alloc.c                                   |  326 ----
>  test/dsm-fail.c                                    |    4 
>  test/firmware-update.sh                            |    8 
>  test/inject-error.sh                               |    7 
>  test/inject-smart.sh                               |    2 
>  test/label-compat.sh                               |    2 
>  test/libndctl.c                                    |  253 +--
>  test/list-smart-dimm.c                             |    6 
>  test/max_available_extent_ns.sh                    |    9 
>  test/meson.build                                   |  237 +++
>  test/mmap.sh                                       |    6 
>  test/monitor.sh                                    |   17 
>  test/multi-dax.sh                                  |    4 
>  test/multi-pmem.c                                  |  285 ----
>  test/parent-uuid.c                                 |  254 ---
>  test/pfn-meta-errors.sh                            |    4 
>  test/pmem-errors.sh                                |   12 
>  test/pmem_namespaces.c                             |    2 
>  test/rescan-partitions.sh                          |    7 
>  test/revoke-devmem.c                               |    2 
>  test/sector-mode.sh                                |   17 
>  test/sub-section.sh                                |    4 
>  test/track-uuid.sh                                 |    6 
>  tools/meson-vcs-tag.sh                             |   18 
>  util/help.c                                        |    2 
>  util/json.c                                        | 1542 --------------------
>  util/json.h                                        |   39 -
>  util/meson.build                                   |   16 
>  version.h.in                                       |    2 
>  134 files changed, 3561 insertions(+), 4658 deletions(-)
>  delete mode 100644 Documentation/cxl/Makefile.am
>  delete mode 100644 Documentation/cxl/lib/Makefile.am
>  create mode 100644 Documentation/cxl/lib/meson.build
>  create mode 100644 Documentation/cxl/meson.build
>  delete mode 100644 Documentation/daxctl/Makefile.am
>  create mode 100644 Documentation/daxctl/meson.build
>  delete mode 100644 Documentation/ndctl/Makefile.am
>  create mode 100644 Documentation/ndctl/meson.build
>  delete mode 100644 Makefile.am
>  delete mode 100644 Makefile.am.in
>  delete mode 100755 autogen.sh
>  create mode 100755 clean_config.sh
>  create mode 100644 config.h.meson
>  delete mode 100644 configure.ac
>  create mode 100644 contrib/meson.build
>  mode change 100755 => 100644 contrib/ndctl
>  delete mode 100644 cxl/Makefile.am
>  create mode 100644 cxl/filter.c
>  create mode 100644 cxl/filter.h
>  create mode 100644 cxl/json.c
>  create mode 100644 cxl/json.h
>  delete mode 100644 cxl/lib/Makefile.am
>  create mode 100644 cxl/lib/meson.build
>  create mode 100644 cxl/meson.build
>  delete mode 100644 daxctl/Makefile.am
>  create mode 100644 daxctl/filter.c
>  create mode 100644 daxctl/filter.h
>  create mode 100644 daxctl/json.c
>  create mode 100644 daxctl/json.h
>  delete mode 100644 daxctl/lib/Makefile.am
>  create mode 100644 daxctl/lib/meson.build
>  create mode 100644 daxctl/meson.build
>  create mode 100644 meson.build
>  create mode 100644 meson_options.txt
>  delete mode 100644 ndctl/Makefile.am
>  rename util/filter.c => ndctl/filter.c (88%)
>  rename util/filter.h => ndctl/filter.h (89%)
>  rename ndctl/{util/json-smart.c => json-smart.c} (99%)
>  create mode 100644 ndctl/json.c
>  create mode 100644 ndctl/json.h
>  rename ndctl/{util/keys.c => keys.c} (99%)
>  rename ndctl/{util/keys.h => keys.h} (100%)
>  delete mode 100644 ndctl/lib/Makefile.am
>  create mode 100644 ndctl/lib/meson.build
>  create mode 100644 ndctl/meson.build
>  create mode 100644 rhel/meson.build
>  create mode 100644 sles/meson.build
>  delete mode 100644 test/Makefile.am
>  delete mode 100755 test/blk-exhaust.sh
>  delete mode 100644 test/blk_namespaces.c
>  delete mode 100644 test/dpa-alloc.c
>  create mode 100644 test/meson.build
>  delete mode 100644 test/multi-pmem.c
>  delete mode 100644 test/parent-uuid.c
>  create mode 100755 tools/meson-vcs-tag.sh
>  create mode 100644 util/meson.build
>  create mode 100644 version.h.in
> 
> base-commit: 25062cf34c70012f5d42ce1fef7e2dc129807c10
> 
