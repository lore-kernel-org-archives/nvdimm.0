Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from bombadil.infradead.org (bombadil.infradead.org
 [IPv6:2607:7c80:54:e::133])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 7C498210DBE63
 for <linux-nvdimm@lists.01.org>; Fri, 15 Jun 2018 12:51:35 -0700 (PDT)
Date: Fri, 15 Jun 2018 12:51:33 -0700
From: Matthew Wilcox <willy@infradead.org>
Subject: [RFC] ktest: add pmem support
Message-ID: <20180615195133.GB16350@bombadil.infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
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
To: Kent Overstreet <kent.overstreet@gmail.com>, Ross Zwisler <ross.zwisler@linux.intel.com>, linux-fsdevel@vger.kernel.org, linux-nvdimm@lists.01.org
List-ID: <linux-nvdimm@lists.01.org>


I haven't got a filesystem mounted using DAX yet, but I thought I might
as well send out the current patch against ktest for enabling persistent
memory.  It's clearly *wrong*, but I do get a /dev/pmem0 device under
Linux once I add all the right config options.  So it's a start, and
people who are deeper into this than I am can suggest things to do to
make it better.

diff --git a/boot.ktest b/boot.ktest
index 8b22e1d..7e7d252 100644
--- a/boot.ktest
+++ b/boot.ktest
@@ -5,6 +5,7 @@ require-lib tests/prelude.sh
 config-mem 2G
 config-scratch-devs 4G
 config-scratch-devs 4G
+config-pmem-devs 4G
 config-timeout 600000
 
 main()
diff --git a/lib/libktest.sh b/lib/libktest.sh
index 7843088..ad1ea62 100644
--- a/lib/libktest.sh
+++ b/lib/libktest.sh
@@ -271,7 +271,7 @@ start_vm()
 
     case $ktest_arch in
 	x86|x86_64)
-	    qemu_cmd+=(-cpu host -machine accel=kvm)
+	    qemu_cmd+=(-cpu host -machine accel=kvm,nvdimm)
 	    ;;
 	mips)
 	    qemu_cmd+=(-cpu 24Kf -machine malta)
@@ -283,7 +283,7 @@ start_vm()
     esac
 
     qemu_cmd+=(								\
-	-m		"$ktest_mem"					\
+	-m		"$ktest_mem,slots=8,maxmem=1T"			\
 	-smp		"$ktest_cpus"					\
 	-kernel		"$ktest_kernel_binary/vmlinuz"			\
 	-append		"$(join_by " " ${kernelargs[@]})"		\
@@ -316,6 +316,13 @@ start_vm()
 	disknr=$((disknr + 1))
     }
 
+    qemu_pmem()
+    {
+	qemu_cmd+=(-object memory-backend-file,id=mem$disknr,share,"$1",align=128M)
+	qemu_cmd+=(-device nvdimm,memdev=mem$disknr,id=nv$disknr,label-size=2M)
+	disknr=$((disknr + 1))
+    }
+
     qemu_disk file="$ktest_root_image",snapshot=on
 
     for size in "${ktest_scratch_devs[@]}"; do
@@ -325,6 +332,13 @@ start_vm()
 	qemu_disk file="$file",cache=unsafe
     done
 
+    for size in "${ktest_pmem_devs[@]}"; do
+	local file="$ktest_tmp/dev-$disknr"
+
+	fallocate -l "$size" "$file"
+	qemu_pmem mem-path="$file",size=$size
+    done
+
     set|grep -vE '^[A-Z]' > "$ktest_tmp/env"
 
     set +o errexit
diff --git a/lib/parse-test.sh b/lib/parse-test.sh
index 30b23ad..353d713 100644
--- a/lib/parse-test.sh
+++ b/lib/parse-test.sh
@@ -90,6 +90,11 @@ parse_test_deps()
 	ktest_scratch_devs+=("$1")
     }
 
+    config-pmem-devs()
+    {
+	ktest_pmem_devs+=("$1")
+    }
+
     config-image()
     {
 	ktest_root_image=$1
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
