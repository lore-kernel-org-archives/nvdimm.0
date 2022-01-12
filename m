Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B678F29CA
	for <nvdimm@lists.linux.dev>; Wed, 12 Jan 2022 13:54:16 +0000 (UTC)
Received: from pps.filterd (m0098394.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 20CDr2ew004317;
	Wed, 12 Jan 2022 13:54:09 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : in-reply-to : references : date : message-id : content-type :
 mime-version; s=pp1; bh=taa8Jtd+y2RD1LzoQPD/MRaaDF2cwIoo2hgn+7FCDsU=;
 b=PaAp9hAylrxBpVGBcwk/yEO6q3x0FAZ9/D1xsUfwIhxGRqVrKkWkUMHZxBuBqDkBZE1h
 X8vfG6+okVR5ZvB6jQk/OhLcV+LQdM0G4r82s1KAt+8I6dK8YVR5ptgsv8fzaC20QQ23
 9KErjsSmKx+7Vq3pnwcgyQoPzXuNY3Q1iEJc4w87+obd1k5k9p2yJzUQn5IJTluGw0Di
 LSUiGJ/9RReMdQV5Cam5UoJHRocYBIQOBzjNCo2FeKZDGwffquM2dvZ45BkTriqkqZQx
 0GqC2GfgtM7/77ITFlnvRcMjDui1rx74C42MMxS7CEBwTA67pqxAvWiqkeml4+ETjNar rw== 
Received: from ppma02fra.de.ibm.com (47.49.7a9f.ip4.static.sl-reverse.com [159.122.73.71])
	by mx0a-001b2d01.pphosted.com with ESMTP id 3dhv9qybh5-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 12 Jan 2022 13:54:09 +0000
Received: from pps.filterd (ppma02fra.de.ibm.com [127.0.0.1])
	by ppma02fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 20CDs7N4029068;
	Wed, 12 Jan 2022 13:54:07 GMT
Received: from b06avi18878370.portsmouth.uk.ibm.com (b06avi18878370.portsmouth.uk.ibm.com [9.149.26.194])
	by ppma02fra.de.ibm.com with ESMTP id 3df28aameg-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 12 Jan 2022 13:54:07 +0000
Received: from d06av26.portsmouth.uk.ibm.com (d06av26.portsmouth.uk.ibm.com [9.149.105.62])
	by b06avi18878370.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 20CDs4f843909618
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 12 Jan 2022 13:54:04 GMT
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 94C1BAE057;
	Wed, 12 Jan 2022 13:54:04 +0000 (GMT)
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 5B216AE045;
	Wed, 12 Jan 2022 13:54:02 +0000 (GMT)
Received: from vajain21.in.ibm.com (unknown [9.43.120.190])
	by d06av26.portsmouth.uk.ibm.com (Postfix) with SMTP;
	Wed, 12 Jan 2022 13:54:02 +0000 (GMT)
Received: by vajain21.in.ibm.com (sSMTP sendmail emulation); Wed, 12 Jan 2022 19:24:01 +0530
From: Vaibhav Jain <vaibhav@linux.ibm.com>
To: Dan Williams <dan.j.williams@intel.com>, vishal.l.verma@intel.com
Cc: nvdimm@lists.linux.dev, linux-cxl@vger.kernel.org,
        Shivaprasad G Bhat
 <sbhat@linux.ibm.com>
Subject: Re: [ndctl PATCH v3 00/16] ndctl: Meson support
In-Reply-To: <164141829899.3990253.17547886681174580434.stgit@dwillia2-desk3.amr.corp.intel.com>
References: <164141829899.3990253.17547886681174580434.stgit@dwillia2-desk3.amr.corp.intel.com>
Date: Wed, 12 Jan 2022 19:24:01 +0530
Message-ID: <877db53vra.fsf@vajain21.in.ibm.com>
Content-Type: text/plain
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: sq_SzcWDVhMhrpjnNCitdNckS3phgfN6
X-Proofpoint-ORIG-GUID: sq_SzcWDVhMhrpjnNCitdNckS3phgfN6
X-Proofpoint-UnRewURL: 0 URL was un-rewritten
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.790,Hydra:6.0.425,FMLib:17.11.62.513
 definitions=2022-01-12_04,2022-01-11_01,2021-12-02_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 spamscore=0 bulkscore=0
 phishscore=0 clxscore=1011 suspectscore=0 malwarescore=0
 priorityscore=1501 mlxlogscore=999 mlxscore=0 adultscore=0
 lowpriorityscore=0 impostorscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2110150000 definitions=main-2201120088


Tested this series on a PPC64-LE guest with a vPMEM device. Generated
binaries for ndctl/daxctl passed the test suite located at
https://github.com/avocado-framework-tests/avocado-misc-tests/blob/master/memory/ndctl.py

Hence,

Tested-by: Vaibhav Jain <vaibhav@linux.ibm.com>

Dan Williams <dan.j.williams@intel.com> writes:
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

-- 
Cheers
~ Vaibhav
