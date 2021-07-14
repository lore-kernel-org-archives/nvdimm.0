Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5EA96168
	for <nvdimm@lists.linux.dev>; Wed, 14 Jul 2021 18:46:37 +0000 (UTC)
Received: from pps.filterd (m0098393.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 16EIZTS7039026;
	Wed, 14 Jul 2021 14:46:34 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : in-reply-to : references : date : message-id : mime-version :
 content-type; s=pp1; bh=43LZH0nIqiuyHmFqwO55Jl0U0CX4TX1LMUp/H2zqGmg=;
 b=JpTH3TTpodw1bzFFRH1rSVcrxF9WfatL0vtx/ixGdhZaJtdDGSoa197tFJ37x81x6Z7s
 3zZJjRdJeX+3MVW17vXaR34HyjnWFD+ird+25/VeMaPEycpY+3xneW9vOcC2zE3E8m5J
 adXxTsxuBbO0iYqUS/hNKndSvqmJS13xznS9AS5p8jNOey9o47Oj6CUpuu0Poo7RJk6D
 6Cpoq9BLl76Md2Dg+njcjNJgXWv44RcrSRZMcdw6RiSjhDXblHpRYpy7B0X4fGd/2YNz
 lpTvdwEAYDN3KHz1r2SJMdJ0TK1xCR8xl7uwIXzjczHtDbaY985aKJ+id7CJW1BNd2Ry 3Q== 
Received: from ppma02fra.de.ibm.com (47.49.7a9f.ip4.static.sl-reverse.com [159.122.73.71])
	by mx0a-001b2d01.pphosted.com with ESMTP id 39ssjxwcdp-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 14 Jul 2021 14:46:34 -0400
Received: from pps.filterd (ppma02fra.de.ibm.com [127.0.0.1])
	by ppma02fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 16EIiDAh006655;
	Wed, 14 Jul 2021 18:46:32 GMT
Received: from b06cxnps3075.portsmouth.uk.ibm.com (d06relay10.portsmouth.uk.ibm.com [9.149.109.195])
	by ppma02fra.de.ibm.com with ESMTP id 39s3p78ef0-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 14 Jul 2021 18:46:32 +0000
Received: from d06av26.portsmouth.uk.ibm.com (d06av26.portsmouth.uk.ibm.com [9.149.105.62])
	by b06cxnps3075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 16EIkTqm32833860
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 14 Jul 2021 18:46:29 GMT
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 99F0FAE057;
	Wed, 14 Jul 2021 18:46:29 +0000 (GMT)
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id DA746AE055;
	Wed, 14 Jul 2021 18:46:27 +0000 (GMT)
Received: from vajain21.in.ibm.com (unknown [9.85.71.114])
	by d06av26.portsmouth.uk.ibm.com (Postfix) with SMTP;
	Wed, 14 Jul 2021 18:46:27 +0000 (GMT)
Received: by vajain21.in.ibm.com (sSMTP sendmail emulation); Thu, 15 Jul 2021 00:16:27 +0530
From: Vaibhav Jain <vaibhav@linux.ibm.com>
To: Dan Williams <dan.j.williams@intel.com>, nvdimm@lists.linux.dev
Cc: linux-cxl@vger.kernel.org
Subject: Re: [ndctl PATCH 0/6] Convert to the Meson build system
In-Reply-To: <162586035908.1431180.14991721381432827647.stgit@dwillia2-desk3.amr.corp.intel.com>
References: <162586035908.1431180.14991721381432827647.stgit@dwillia2-desk3.amr.corp.intel.com>
Date: Thu, 15 Jul 2021 00:16:27 +0530
Message-ID: <87mtqo68e4.fsf@vajain21.in.ibm.com>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: itOvuAmYMJ6bQSyScV6JUidUzjcZ4_Lf
X-Proofpoint-ORIG-GUID: itOvuAmYMJ6bQSyScV6JUidUzjcZ4_Lf
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.790
 definitions=2021-07-14_10:2021-07-14,2021-07-14 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 suspectscore=0 bulkscore=0
 malwarescore=0 adultscore=0 spamscore=0 impostorscore=0 clxscore=1011
 lowpriorityscore=0 priorityscore=1501 mlxscore=0 phishscore=0
 mlxlogscore=999 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2104190000 definitions=main-2107140110

Dan Williams <dan.j.williams@intel.com> writes:

> Autotools is slow. It is so slow that it takes some of the joy out of
> hacking on the ndctl project. A fellow developer points out that QEMU
> has moved to meson, and systemd has moved as well. An initial conversion
> of ndctl to meson shows speed gains as large as an order of magnitude
> improvement, and that result motivates the formal patches below to
> complete the conversion.
>
> Given that this change breaks scripts built for automating the autotools
> style build, the old autotools environment is kept working until all the
> meson conversion bugs have been worked out, and downstream users have
> had a chance to adjust.
>
> Other immediate benefits beside build speed is a unit test execution
> harness with more capability and flexibility. It allows tests to be
> organized by category and has a framework to support timeout as a test
> failure.
>
> ---
>
> Dan Williams (6):
>       util: Distribute 'filter' and 'json' helpers to per-tool objects
>       Documentation: Drop attrs.adoc include
>       build: Drop unnecessary $tool/config.h includes
>       build: Explicitly include version.h
>       test: Prepare out of line builds
>       build: Add meson build infrastructure
>

With the patch-series got working builds for ndctl/daxctl on ppc64le using meson/ninja
Hence,

Tested-by: Vaibhav Jain <vaibhav@linux.ibm.com>

>
>  .gitignore                                      |    5 
>  Documentation/cxl/meson.build                   |   82 +
>  Documentation/daxctl/meson.build                |   88 +
>  Documentation/ndctl/Makefile.am                 |   11 
>  Documentation/ndctl/intel-nvdimm-security.txt   |    2 
>  Documentation/ndctl/meson.build                 |  124 ++
>  Documentation/ndctl/ndctl-load-keys.txt         |    2 
>  Documentation/ndctl/ndctl-monitor.txt           |    5 
>  Documentation/ndctl/ndctl-sanitize-dimm.txt     |    2 
>  Documentation/ndctl/ndctl-setup-passphrase.txt  |    2 
>  Documentation/ndctl/ndctl-update-passphrase.txt |    2 
>  Makefile.am                                     |    1 
>  Makefile.am.in                                  |    3 
>  clean_config.sh                                 |    2 
>  config.h.meson                                  |  149 +++
>  cxl/Makefile.am                                 |    3 
>  cxl/cxl.c                                       |    1 
>  cxl/filter.c                                    |   25 
>  cxl/filter.h                                    |    7 
>  cxl/json.c                                      |   34 +
>  cxl/json.h                                      |    8 
>  cxl/lib/meson.build                             |   24 
>  cxl/list.c                                      |    5 
>  cxl/memdev.c                                    |    3 
>  cxl/meson.build                                 |   23 
>  daxctl/Makefile.am                              |    5 
>  daxctl/daxctl.c                                 |    1 
>  daxctl/device.c                                 |    4 
>  daxctl/filter.c                                 |   43 +
>  daxctl/filter.h                                 |   12 
>  daxctl/json.c                                   |  251 ++++
>  daxctl/json.h                                   |   18 
>  daxctl/lib/meson.build                          |   32 +
>  daxctl/list.c                                   |    5 
>  daxctl/meson.build                              |   25 
>  daxctl/migrate.c                                |    1 
>  meson.build                                     |  237 ++++
>  meson_options.txt                               |   17 
>  ndctl/Makefile.am                               |   16 
>  ndctl/bus.c                                     |    4 
>  ndctl/dimm.c                                    |    6 
>  ndctl/filter.c                                  |   60 -
>  ndctl/filter.h                                  |   12 
>  ndctl/inject-error.c                            |    4 
>  ndctl/inject-smart.c                            |    4 
>  ndctl/json-smart.c                              |    3 
>  ndctl/json.c                                    | 1114 +++++++++++++++++++
>  ndctl/json.h                                    |   24 
>  ndctl/keys.c                                    |    4 
>  ndctl/keys.h                                    |    0 
>  ndctl/lib/libndctl.c                            |    2 
>  ndctl/lib/meson.build                           |   38 +
>  ndctl/lib/papr.c                                |    4 
>  ndctl/lib/private.h                             |    4 
>  ndctl/list.c                                    |    6 
>  ndctl/load-keys.c                               |    5 
>  ndctl/meson.build                               |   70 +
>  ndctl/monitor.c                                 |    6 
>  ndctl/namespace.c                               |    4 
>  ndctl/ndctl.c                                   |    1 
>  ndctl/region.c                                  |    3 
>  test/Makefile.am                                |   27 
>  test/ack-shutdown-count-set.c                   |    2 
>  test/btt-errors.sh                              |    4 
>  test/common                                     |   37 -
>  test/dax-pmd.c                                  |    7 
>  test/dax.sh                                     |    6 
>  test/daxdev-errors.c                            |    2 
>  test/daxdev-errors.sh                           |    4 
>  test/device-dax-fio.sh                          |    2 
>  test/device-dax.c                               |    2 
>  test/dm.sh                                      |    4 
>  test/dpa-alloc.c                                |    2 
>  test/dsm-fail.c                                 |    4 
>  test/inject-smart.sh                            |    2 
>  test/libndctl.c                                 |    2 
>  test/list-smart-dimm.c                          |    7 
>  test/meson.build                                |  267 +++++
>  test/mmap.sh                                    |    6 
>  test/monitor.sh                                 |    6 
>  test/multi-pmem.c                               |    4 
>  test/pmem-errors.sh                             |    8 
>  test/revoke-devmem.c                            |    2 
>  test/sub-section.sh                             |    4 
>  test/track-uuid.sh                              |    2 
>  tools/meson-vcs-tag.sh                          |   17 
>  util/help.c                                     |    2 
>  util/json.c                                     | 1363 -----------------------
>  util/json.h                                     |   39 -
>  util/meson.build                                |   15 
>  version.h.in                                    |    2 
>  91 files changed, 2919 insertions(+), 1590 deletions(-)
>  create mode 100644 Documentation/cxl/meson.build
>  create mode 100644 Documentation/daxctl/meson.build
>  create mode 100644 Documentation/ndctl/meson.build
>  create mode 100755 clean_config.sh
>  create mode 100644 config.h.meson
>  create mode 100644 cxl/filter.c
>  create mode 100644 cxl/filter.h
>  create mode 100644 cxl/json.c
>  create mode 100644 cxl/json.h
>  create mode 100644 cxl/lib/meson.build
>  create mode 100644 cxl/meson.build
>  create mode 100644 daxctl/filter.c
>  create mode 100644 daxctl/filter.h
>  create mode 100644 daxctl/json.c
>  create mode 100644 daxctl/json.h
>  create mode 100644 daxctl/lib/meson.build
>  create mode 100644 daxctl/meson.build
>  create mode 100644 meson.build
>  create mode 100644 meson_options.txt
>  rename util/filter.c => ndctl/filter.c (88%)
>  rename util/filter.h => ndctl/filter.h (89%)
>  rename ndctl/{util/json-smart.c => json-smart.c} (99%)
>  create mode 100644 ndctl/json.c
>  create mode 100644 ndctl/json.h
>  rename ndctl/{util/keys.c => keys.c} (99%)
>  rename ndctl/{util/keys.h => keys.h} (100%)
>  create mode 100644 ndctl/lib/meson.build
>  create mode 100644 ndctl/meson.build
>  create mode 100644 test/meson.build
>  create mode 100755 tools/meson-vcs-tag.sh
>  create mode 100644 util/meson.build
>  create mode 100644 version.h.in
>
> base-commit: 5884f09e488748dad8fea660fd80044b06609f26
>

-- 
Cheers
~ Vaibhav
