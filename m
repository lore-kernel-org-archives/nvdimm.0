Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga18.intel.com (mga18.intel.com [134.134.136.126])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id A90D82110396D
 for <linux-nvdimm@lists.01.org>; Thu,  7 Jun 2018 15:31:24 -0700 (PDT)
From: Ross Zwisler <ross.zwisler@linux.intel.com>
Subject: [qemu PATCH 3/5] hw/i386: Update SSDT table used by "make check"
Date: Thu,  7 Jun 2018 16:31:09 -0600
Message-Id: <20180607223111.27792-3-ross.zwisler@linux.intel.com>
In-Reply-To: <20180607223111.27792-1-ross.zwisler@linux.intel.com>
References: <20180607223111.27792-1-ross.zwisler@linux.intel.com>
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
To: "Michael S. Tsirkin" <mst@redhat.com>
Cc: Peter Maydell <peter.maydell@linaro.org>, Thomas Huth <thuth@redhat.com>, Eduardo Habkost <ehabkost@redhat.com>, linux-nvdimm <linux-nvdimm@lists.01.org>, Cornelia Huck <cohuck@redhat.com>, Qemu Developers <qemu-devel@nongnu.org>, Stefan Hajnoczi <stefanha@redhat.com>, Igor Mammedov <imammedo@redhat.com>
List-ID: <linux-nvdimm@lists.01.org>

This commit:

commit aa78a16d8645 ("hw/i386: Rename 2.13 machine types to 3.0")

updated the name used to create the q35 machine, which in turn changed the
SSDT table which is generated when we run "make check":

  acpi-test: Warning! SSDT mismatch. Actual [asl:/tmp/asl-QZDWJZ.dsl,
  aml:/tmp/aml-T8JYJZ], Expected [asl:/tmp/asl-DTWVJZ.dsl,
  aml:tests/acpi-test-data/q35/SSDT.dimmpxm].

Here's the only difference, aside from the checksum:

  <     Name (MEMA, 0x07FFF000)
  ---
  >     Name (MEMA, 0x07FFE000)

Update the binary table that we compare against so it reflects this name
change.

Signed-off-by: Ross Zwisler <ross.zwisler@linux.intel.com>
Cc: Peter Maydell <peter.maydell@linaro.org>
Cc: Cornelia Huck <cohuck@redhat.com>
Cc: Thomas Huth <thuth@redhat.com>
Cc: Eduardo Habkost <ehabkost@redhat.com>
Fixes: commit aa78a16d8645 ("hw/i386: Rename 2.13 machine types to 3.0")
---
 tests/acpi-test-data/q35/SSDT.dimmpxm | Bin 685 -> 685 bytes
 1 file changed, 0 insertions(+), 0 deletions(-)

diff --git a/tests/acpi-test-data/q35/SSDT.dimmpxm b/tests/acpi-test-data/q35/SSDT.dimmpxm
index 8ba0e67cb72daa81a65da4906d37a5e0f4af1fd4..2d5b721bcf9c398feb6d005761f898015042e8a4 100644
GIT binary patch
delta 23
fcmZ3>x|WqIIM^j*EfWI+qr*n71x(Bz{<8xBPCEwk

delta 23
fcmZ3>x|WqIIM^j*EfWI+W57nP1x(Bj{<8xBPMZev

-- 
2.14.4

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
