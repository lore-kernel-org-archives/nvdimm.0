Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga02.intel.com (mga02.intel.com [134.134.136.20])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 5076E203BBB9F
 for <linux-nvdimm@lists.01.org>; Wed, 16 May 2018 22:00:33 -0700 (PDT)
From: Ross Zwisler <ross.zwisler@linux.intel.com>
Subject: [qemu PATCH v2 0/4] support NFIT platform capabilities
Date: Wed, 16 May 2018 23:00:20 -0600
Message-Id: <20180517050024.20101-1-ross.zwisler@linux.intel.com>
List-Unsubscribe: <https://lists.01.org/mailman/options/linux-nvdimm>,
 <mailto:linux-nvdimm-request@lists.01.org?subject=unsubscribe>
List-Archive: <http://lists.01.org/pipermail/linux-nvdimm/>
List-Post: <mailto:linux-nvdimm@lists.01.org>
List-Help: <mailto:linux-nvdimm-request@lists.01.org?subject=help>
List-Subscribe: <https://lists.01.org/mailman/listinfo/linux-nvdimm>,
 <mailto:linux-nvdimm-request@lists.01.org?subject=subscribe>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: linux-nvdimm-bounces@lists.01.org
Sender: "Linux-nvdimm" <linux-nvdimm-bounces@lists.01.org>
To: Igor Mammedov <imammedo@redhat.com>, qemu-devel@nongnu.org
Cc: Eduardo Habkost <ehabkost@redhat.com>, linux-nvdimm <linux-nvdimm@lists.01.org>, "Michael S . Tsirkin" <mst@redhat.com>, Stefan Hajnoczi <stefanha@redhat.com>
List-ID: <linux-nvdimm@lists.01.org>

The first 2 patches in this series clean up some things I noticed while
coding.

Patch 3 adds support for the new Platform Capabilities Structure, which
was added to the NFIT in ACPI 6.2 Errata A.  We add a machine command
line option "nvdimm-cap":

    -machine pc,accel=kvm,nvdimm,nvdimm-cap=2

which allows the user to pass in a value for this structure.  When such
a value is passed in we will generate the new NFIT subtable.

Patch 4 adds code to the "make check" self test infrastructure so that
we generate the new Platform Capabilities Structure, and adds it to the
expected NFIT output so that we test for it.

Thanks to Igor Mammedov for his feedback on v1 of this set.

Ross Zwisler (4):
  nvdimm: fix typo in label-size definition
  tests/.gitignore: add entry for generated file
  nvdimm, acpi: support NFIT platform capabilities
  ACPI testing: test NFIT platform capabilities

 docs/nvdimm.txt                       |  18 ++++++++++++++
 hw/acpi/nvdimm.c                      |  44 ++++++++++++++++++++++++++++++----
 hw/i386/pc.c                          |  31 ++++++++++++++++++++++++
 hw/mem/nvdimm.c                       |   2 +-
 include/hw/i386/pc.h                  |   1 +
 include/hw/mem/nvdimm.h               |   7 +++++-
 tests/.gitignore                      |   1 +
 tests/acpi-test-data/pc/NFIT.dimmpxm  | Bin 224 -> 240 bytes
 tests/acpi-test-data/q35/NFIT.dimmpxm | Bin 224 -> 240 bytes
 tests/bios-tables-test.c              |   2 +-
 10 files changed, 99 insertions(+), 7 deletions(-)

-- 
2.14.3

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
