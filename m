Received: from mga12.intel.com (mga12.intel.com [192.55.52.136])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3DBC12FB2
	for <nvdimm@lists.linux.dev>; Thu,  2 Sep 2021 20:43:24 +0000 (UTC)
X-IronPort-AV: E=McAfee;i="6200,9189,10095"; a="198789616"
X-IronPort-AV: E=Sophos;i="5.85,263,1624345200"; 
   d="scan'208";a="198789616"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Sep 2021 13:43:00 -0700
X-IronPort-AV: E=Sophos;i="5.85,263,1624345200"; 
   d="scan'208";a="499983053"
Received: from dwillia2-desk3.jf.intel.com (HELO dwillia2-desk3.amr.corp.intel.com) ([10.54.39.25])
  by fmsmga008-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Sep 2021 13:42:59 -0700
Subject: [ndctl PATCH v2 0/6] Convert to the Meson build system
From: Dan Williams <dan.j.williams@intel.com>
To: nvdimm@lists.linux.dev
Cc: Vaibhav Jain <vaibhav@linux.ibm.com>, vishal.l.verma@intel.com,
 linux-cxl@vger.kernel.org
Date: Thu, 02 Sep 2021 13:42:58 -0700
Message-ID: <163061537869.1943957.8491829881215255815.stgit@dwillia2-desk3.amr.corp.intel.com>
User-Agent: StGit/0.18-3-g996c
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

Changes since v1 [1]:
- Drop the version.h changes since that was breaking autotools builds.
  version.h is now an implicit include from the build system
- Add support for building an rpm with meson. This lead to many fixes:
  - Fix missing build of libcxl section 3 man pages
  - Fix installation of monitor.service, nvdimm-security.conf,
    keys.readme, and daxctl.conf
  - Fix installation of libcxl to include versioned library
  - Fix a couple autotools build regressions

[1]: https://lore.kernel.org/r/162586035908.1431180.14991721381432827647.stgit@dwillia2-desk3.amr.corp.intel.com

---

Autotools is slow. It is so slow that it takes some of the joy out of
hacking on the ndctl project. A fellow developer points out that QEMU
has moved to meson, and systemd has moved as well. An initial conversion
of ndctl to meson shows speed gains as large as an order of magnitude
improvement, and that result motivates the formal patches below to
complete the conversion.

Given that this change will break scripts built for automating the
autotools style build, the old autotools environment is kept working for
now, but the plan is to remove autotools support in a future release.

Other immediate benefits beside build speed is a unit test execution
harness with more capability and flexibility. It allows tests to be
organized by category and has a framework to support timeout as a test
failure.

---

Dan Williams (6):
      util: Distribute 'filter' and 'json' helpers to per-tool objects
      Documentation: Drop attrs.adoc include
      build: Drop unnecessary $tool/config.h includes
      test: Prepare out of line builds
      build: Add meson build infrastructure
      build: Add meson rpmbuild support


 .gitignore                                      |    7 
 Documentation/cxl/lib/meson.build               |   79 +
 Documentation/cxl/meson.build                   |   84 +
 Documentation/daxctl/meson.build                |   88 +
 Documentation/ndctl/Makefile.am                 |   14 
 Documentation/ndctl/intel-nvdimm-security.txt   |    2 
 Documentation/ndctl/meson.build                 |  124 ++
 Documentation/ndctl/ndctl-load-keys.txt         |    2 
 Documentation/ndctl/ndctl-monitor.txt           |    5 
 Documentation/ndctl/ndctl-sanitize-dimm.txt     |    2 
 Documentation/ndctl/ndctl-setup-passphrase.txt  |    2 
 Documentation/ndctl/ndctl-update-passphrase.txt |    2 
 Makefile.am                                     |    3 
 Makefile.am.in                                  |    3 
 clean_config.sh                                 |    2 
 config.h.meson                                  |  149 +++
 contrib/meson.build                             |   16 
 cxl/Makefile.am                                 |    3 
 cxl/filter.c                                    |   25 
 cxl/filter.h                                    |    7 
 cxl/json.c                                      |   34 +
 cxl/json.h                                      |    8 
 cxl/lib/meson.build                             |   35 +
 cxl/list.c                                      |    4 
 cxl/memdev.c                                    |    3 
 cxl/meson.build                                 |   25 
 daxctl/Makefile.am                              |    5 
 daxctl/device.c                                 |    4 
 daxctl/filter.c                                 |   43 +
 daxctl/filter.h                                 |   12 
 daxctl/json.c                                   |  251 ++++
 daxctl/json.h                                   |   18 
 daxctl/lib/meson.build                          |   44 +
 daxctl/list.c                                   |    4 
 daxctl/meson.build                              |   27 
 daxctl/migrate.c                                |    1 
 meson.build                                     |  275 +++++
 meson_options.txt                               |   23 
 ndctl.spec.in                                   |   22 
 ndctl/Makefile.am                               |   16 
 ndctl/bus.c                                     |    4 
 ndctl/check.c                                   |    2 
 ndctl/dimm.c                                    |    6 
 ndctl/filter.c                                  |   60 -
 ndctl/filter.h                                  |   12 
 ndctl/inject-error.c                            |    6 
 ndctl/inject-smart.c                            |    6 
 ndctl/json-smart.c                              |    5 
 ndctl/json.c                                    | 1114 +++++++++++++++++++
 ndctl/json.h                                    |   24 
 ndctl/keys.c                                    |    6 
 ndctl/keys.h                                    |    0 
 ndctl/lib/libndctl.c                            |    2 
 ndctl/lib/meson.build                           |   48 +
 ndctl/lib/papr.c                                |    4 
 ndctl/lib/private.h                             |    4 
 ndctl/list.c                                    |    5 
 ndctl/load-keys.c                               |    7 
 ndctl/meson.build                               |   85 +
 ndctl/monitor.c                                 |    5 
 ndctl/namespace.c                               |    6 
 ndctl/region.c                                  |    3 
 rhel/meson.build                                |   23 
 rpmbuild.sh                                     |    5 
 sles/meson.build                                |   36 +
 test/Makefile.am                                |   27 
 test/ack-shutdown-count-set.c                   |    2 
 test/blk_namespaces.c                           |    2 
 test/btt-errors.sh                              |    4 
 test/common                                     |   37 -
 test/dax-pmd.c                                  |    7 
 test/dax.sh                                     |    6 
 test/daxdev-errors.c                            |    2 
 test/daxdev-errors.sh                           |    4 
 test/device-dax-fio.sh                          |    2 
 test/device-dax.c                               |    2 
 test/dm.sh                                      |    4 
 test/dpa-alloc.c                                |    2 
 test/dsm-fail.c                                 |    4 
 test/inject-smart.sh                            |    2 
 test/libndctl.c                                 |    2 
 test/list-smart-dimm.c                          |    6 
 test/meson.build                                |  262 ++++
 test/mmap.sh                                    |    6 
 test/monitor.sh                                 |    6 
 test/multi-pmem.c                               |    4 
 test/pmem-errors.sh                             |    8 
 test/pmem_namespaces.c                          |    2 
 test/revoke-devmem.c                            |    2 
 test/sub-section.sh                             |    4 
 test/track-uuid.sh                              |    2 
 tools/meson-vcs-tag.sh                          |   18 
 util/help.c                                     |    2 
 util/json.c                                     | 1363 -----------------------
 util/json.h                                     |   39 -
 util/meson.build                                |   15 
 version.h.in                                    |    2 
 97 files changed, 3198 insertions(+), 1603 deletions(-)
 create mode 100644 Documentation/cxl/lib/meson.build
 create mode 100644 Documentation/cxl/meson.build
 create mode 100644 Documentation/daxctl/meson.build
 create mode 100644 Documentation/ndctl/meson.build
 create mode 100755 clean_config.sh
 create mode 100644 config.h.meson
 create mode 100644 contrib/meson.build
 create mode 100644 cxl/filter.c
 create mode 100644 cxl/filter.h
 create mode 100644 cxl/json.c
 create mode 100644 cxl/json.h
 create mode 100644 cxl/lib/meson.build
 create mode 100644 cxl/meson.build
 create mode 100644 daxctl/filter.c
 create mode 100644 daxctl/filter.h
 create mode 100644 daxctl/json.c
 create mode 100644 daxctl/json.h
 create mode 100644 daxctl/lib/meson.build
 create mode 100644 daxctl/meson.build
 create mode 100644 meson.build
 create mode 100644 meson_options.txt
 rename util/filter.c => ndctl/filter.c (88%)
 rename util/filter.h => ndctl/filter.h (89%)
 rename ndctl/{util/json-smart.c => json-smart.c} (99%)
 create mode 100644 ndctl/json.c
 create mode 100644 ndctl/json.h
 rename ndctl/{util/keys.c => keys.c} (99%)
 rename ndctl/{util/keys.h => keys.h} (100%)
 create mode 100644 ndctl/lib/meson.build
 create mode 100644 ndctl/meson.build
 create mode 100644 rhel/meson.build
 create mode 100644 sles/meson.build
 create mode 100644 test/meson.build
 create mode 100755 tools/meson-vcs-tag.sh
 create mode 100644 util/meson.build
 create mode 100644 version.h.in
