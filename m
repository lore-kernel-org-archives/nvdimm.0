Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga01.intel.com (mga01.intel.com [192.55.52.88])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 0D41521DFA7BA
 for <linux-nvdimm@lists.01.org>; Tue, 28 Mar 2017 16:19:33 -0700 (PDT)
Subject: [ndctl PATCH 6/6] test: add interleave set compatibility test
From: Dan Williams <dan.j.williams@intel.com>
Date: Tue, 28 Mar 2017 16:14:23 -0700
Message-ID: <149074286304.18735.6004278612978978955.stgit@dwillia2-desk3.amr.corp.intel.com>
In-Reply-To: <149074283171.18735.16381597942269607973.stgit@dwillia2-desk3.amr.corp.intel.com>
References: <149074283171.18735.16381597942269607973.stgit@dwillia2-desk3.amr.corp.intel.com>
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
Cc: Nicholas Moulin <nicholas.w.moulin@intel.com>
List-ID: <linux-nvdimm@lists.01.org>

Per the realization that Linux was incompatible with other
implementations of the interleave-set-cookie algorithm [1], add a
regression test to check for compatibility with the original Linux
implementation.

This also serves as a unit test for the new 'write-labels' command.

[1]: commit 86ef58a4e35e ("nfit, libnvdimm: fix interleave set cookie calculation")

Reported-by: Nicholas Moulin <nicholas.w.moulin@intel.com>
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 test/Makefile.am     |    3 ++
 test/label-compat.sh |   61 ++++++++++++++++++++++++++++++++++++++++++++++++++
 test/nmem1.bin       |  Bin
 test/nmem2.bin       |  Bin
 test/nmem3.bin       |  Bin
 test/nmem4.bin       |  Bin
 6 files changed, 63 insertions(+), 1 deletion(-)
 create mode 100755 test/label-compat.sh
 create mode 100644 test/nmem1.bin
 create mode 100644 test/nmem2.bin
 create mode 100644 test/nmem3.bin
 create mode 100644 test/nmem4.bin

diff --git a/test/Makefile.am b/test/Makefile.am
index 969fe055b35e..d2a0cf9fe2ba 100644
--- a/test/Makefile.am
+++ b/test/Makefile.am
@@ -9,7 +9,8 @@ TESTS =\
 	create.sh \
 	clear.sh \
 	dax-errors.sh \
-	btt-check.sh
+	btt-check.sh \
+	label-compat.sh
 
 check_PROGRAMS =\
 	libndctl \
diff --git a/test/label-compat.sh b/test/label-compat.sh
new file mode 100755
index 000000000000..f103f64ae7ff
--- /dev/null
+++ b/test/label-compat.sh
@@ -0,0 +1,61 @@
+#!/bin/bash -x
+NDCTL="../ndctl/ndctl"
+BUS="-b nfit_test.0"
+BUS1="-b nfit_test.1"
+rc=77
+
+set -e
+
+err() {
+	echo "test/label-compat.sh: failed at line $1"
+	exit $rc
+}
+
+check_min_kver()
+{
+	local ver="$1"
+	: "${KVER:=$(uname -r)}"
+
+	[ -n "$ver" ] || return 1
+	[[ "$ver" == "$(echo -e "$ver\n$KVER" | sort -V | head -1)" ]]
+}
+
+check_min_kver "4.11" || { echo "kernel $KVER may not provide reliable isetcookie values"; exit $rc; }
+
+set -e
+trap 'err $LINENO' ERR
+
+# setup (reset nfit_test dimms)
+modprobe nfit_test
+$NDCTL disable-region $BUS all
+$NDCTL zero-labels $BUS all
+
+# grab the largest pmem region on $BUS
+query=". | sort_by(.available_size) | reverse | .[0].dev"
+region=$($NDCTL list $BUS -t pmem -Ri | jq -r "$query")
+
+# we assume that $region is comprised of 4 dimms
+query=". | .regions[0].mappings | sort_by(.dimm) | .[].dimm"
+dimms=$($NDCTL list -DRi -r $region | jq -r "$query" | xargs)
+i=1
+for d in $dimms
+do
+	$NDCTL write-labels $d -i nmem${i}.bin
+	i=$((i+1))
+done
+
+$NDCTL enable-region $BUS all
+
+len=$($NDCTL list -r 7 -N | jq -r "length")
+
+if [ -z $len ]; then
+	rc=1
+	echo "failed to find legacy isetcookie namespace"
+	exit 1
+fi
+
+$NDCTL disable-region $BUS all
+$NDCTL disable-region $BUS1 all
+modprobe -r nfit_test
+
+exit 0
diff --git a/test/nmem1.bin b/test/nmem1.bin
new file mode 100644
index 0000000000000000000000000000000000000000..1ef8dfd802e6735073230f7e6a8ec3365c555f39
GIT binary patch
literal 131072
zcmeIuF=_%)6a~;f8HFss71*ZH(nc^kg++!y8aoS{Y{4D51|i#+WC@m5B1%lY=x?Hh
z*l6IqVYs{p19MN=dnw*td;MZOEC<CXoJ@ASq<lE+>pX-kK6$tOH5*JeKewHe-@f!v
zp6MT}?aLh|<#7#v`qyLsr{QF?`=|ZiTg%S0@!XwP&5zmlqDnQd&Byp*Exy}b$Uay3
zeod1kQ>MElK!5-N0t5&UAV7cs0RjXF5FkK+009C72oNAZfB*pk1PBlyK!5-N0t5&U
zAV7cs0RjXF5FkK+009C72oNAZfB*pk1PBlyK!5-N0t5&UAV7cs0RjXF5FkK+009C7
z2oNAZfB*pk1PBlyK!5-N0t5&UAV7cs0RjXF5FkK+009C72oNAZfB*pk1PBlyK!5-N
z0t5&UAV7cs0RjXF5FkK+009C72oNAZfB*pk1PBlyK!5-N0t5&UAV7cs0RjXF5FkK+
z009C72oNAZfB*pk1PBlyK!5-N0t5&UAV7cs0RjXF5FkK+009C72oNAZfB*pk1PBly
zK!5-N0t5&UAV7cs0RjXF5FkK+009C72oNAZfB*pk1PBlyK!5-N0t5&UAV7cs0RjXF
z5FkK+009C72oNAZfB*pk1PBlyK!5-N0t5&UAV7cs0RjXF5FkK+009C72oNAZfB*pk
z1PBlyK!5-N0t5&UAV7cs0RjXF5FkK+009C72oNAZfB*pk1PBlyK!5-N0t5&UAV7cs
z0RjXF5FkK+009C72oNAZfB*pk1PBlyK!5-N0t5&UAV7cs0RjXF5FkK+009C72oNAZ
zfB*pk1PBlyK!5-N0t5&UAV7cs0RjXF5FkK+009C72oNAZfB*pk1PBlyK!5-N0t5&U
zAV7cs0RjXF5FkK+009C72oNAZfB*pk1PBlyK!5-N0t5&UAV7cs0RjXF5FkK+009C7
J2oSg<fnS9n8x8;f

literal 0
HcmV?d00001

diff --git a/test/nmem2.bin b/test/nmem2.bin
new file mode 100644
index 0000000000000000000000000000000000000000..adf45b5c586667e77f83f74b0574adc7369f0df4
GIT binary patch
literal 131072
zcmeIuF=_%)6a~;f8HFss71*ZH(nc^kg++!y8aoS{Y{4D51|i#+WC@m5B1%lY=x?Hh
z*l6IqUtHdUfw`yby%cY+y?!wsmV;sxP9{5EQa&8^bsj<%U*2th%?6Xr&u!=Aw=X@E
zXZpu#`*Md#d0fMv{`J`ZX*k*J{%QaB*0M8gJa^|+^JDhCs8Y>q^D%x{i+I~z$Uay3
zeod1kQ>MElK!5-N0t5&UAV7cs0RjXF5FkK+009C72oNAZfB*pk1PBlyK!5-N0t5&U
zAV7cs0RjXF5FkK+009C72oNAZfB*pk1PBlyK!5-N0t5&UAV7cs0RjXF5FkK+009C7
z2oNAZfB*pk1PBlyK!5-N0t5&UAV7cs0RjXF5FkK+009C72oNAZfB*pk1PBlyK!5-N
z0t5&UAV7cs0RjXF5FkK+009C72oNAZfB*pk1PBlyK!5-N0t5&UAV7cs0RjXF5FkK+
z009C72oNAZfB*pk1PBlyK!5-N0t5&UAV7cs0RjXF5FkK+009C72oNAZfB*pk1PBly
zK!5-N0t5&UAV7cs0RjXF5FkK+009C72oNAZfB*pk1PBlyK!5-N0t5&UAV7cs0RjXF
z5FkK+009C72oNAZfB*pk1PBlyK!5-N0t5&UAV7cs0RjXF5FkK+009C72oNAZfB*pk
z1PBlyK!5-N0t5&UAV7cs0RjXF5FkK+009C72oNAZfB*pk1PBlyK!5-N0t5&UAV7cs
z0RjXF5FkK+009C72oNAZfB*pk1PBlyK!5-N0t5&UAV7cs0RjXF5FkK+009C72oNAZ
zfB*pk1PBlyK!5-N0t5&UAV7cs0RjXF5FkK+009C72oNAZfB*pk1PBlyK!5-N0t5&U
zAV7cs0RjXF5FkK+009C72oNAZfB*pk1PBlyK!5-N0t5&UAV7cs0RjXF5FkK+009C7
J2oSg<fnS2?8xH^g

literal 0
HcmV?d00001

diff --git a/test/nmem3.bin b/test/nmem3.bin
new file mode 100644
index 0000000000000000000000000000000000000000..bf7334e28cbc26accbcfbb79bcedf8a8f7a9000b
GIT binary patch
literal 131072
zcmeIuF=_%)6a~;f8HFss71*ZH(nc^kg++!y8aoS{Y{4D51|i#+WC@m5B1%lY=x?Hh
z*l6IqUtHdUfw`yby%cY+y?!wsmV;sxP9{5EQa&8^bsj<%U*2th%?6Xr&u!=Aw=X@E
zXZpu#`*Md#d0fMv{`J`ZX*k*J{%QaB*0M8gJa^|+^JDhCs8Y>q^D%x{i%8pD$Uay3
zeod1kQ>MElK!5-N0t5&UAV7cs0RjXF5FkK+009C72oNAZfB*pk1PBlyK!5-N0t5&U
zAV7cs0RjXF5FkK+009C72oNAZfB*pk1PBlyK!5-N0t5&UAV7cs0RjXF5FkK+009C7
z2oNAZfB*pk1PBlyK!5-N0t5&UAV7cs0RjXF5FkK+009C72oNAZfB*pk1PBlyK!5-N
z0t5&UAV7cs0RjXF5FkK+009C72oNAZfB*pk1PBlyK!5-N0t5&UAV7cs0RjXF5FkK+
z009C72oNAZfB*pk1PBlyK!5-N0t5&UAV7cs0RjXF5FkK+009C72oNAZfB*pk1PBly
zK!5-N0t5&UAV7cs0RjXF5FkK+009C72oNAZfB*pk1PBlyK!5-N0t5&UAV7cs0RjXF
z5FkK+009C72oNAZfB*pk1PBlyK!5-N0t5&UAV7cs0RjXF5FkK+009C72oNAZfB*pk
z1PBlyK!5-N0t5&UAV7cs0RjXF5FkK+009C72oNAZfB*pk1PBlyK!5-N0t5&UAV7cs
z0RjXF5FkK+009C72oNAZfB*pk1PBlyK!5-N0t5&UAV7cs0RjXF5FkK+009C72oNAZ
zfB*pk1PBlyK!5-N0t5&UAV7cs0RjXF5FkK+009C72oNAZfB*pk1PBlyK!5-N0t5&U
zAV7cs0RjXF5FkK+009C72oNAZfB*pk1PBlyK!5-N0t5&UAV7cs0RjXF5FkK+009C7
J2oSg<fnR{I8xQ~h

literal 0
HcmV?d00001

diff --git a/test/nmem4.bin b/test/nmem4.bin
new file mode 100644
index 0000000000000000000000000000000000000000..24485122e9d8ecfc25ab6b27449c76a2b4f527bf
GIT binary patch
literal 131072
zcmeIuF=_%)6a~;fnFv`xR$yxrOB=z&DW-4`Z0u6lxCM9Q8iZ_PbP1MLAt;WH=x;Pd
zNRtTX{o?W-49q=6Z;*|Ky|?T=FZ$Uy+)Q%0#C$mKUug(Q{nBoGHSbThhrgYh-~Q>L
z_@;kd?NshOF)wSl>ffmQxAMuhy3_vCmrZB({MucV&5!whUB;Tf&8Paq$B>3y6_Vv=
zdRpT|$(Zpj2@oJafB*pk1PBlyK!5-N0t5&UAV7cs0RjXF5FkK+009C72oNAZfB*pk
z1PBlyK!5-N0t5&UAV7cs0RjXF5FkK+009C72oNAZfB*pk1PBlyK!5-N0t5&UAV7cs
z0RjXF5FkK+009C72oNAZfB*pk1PBlyK!5-N0t5&UAV7cs0RjXF5FkK+009C72oNAZ
zfB*pk1PBlyK!5-N0t5&UAV7cs0RjXF5FkK+009C72oNAZfB*pk1PBlyK!5-N0t5&U
zAV7cs0RjXF5FkK+009C72oNAZfB*pk1PBlyK!5-N0t5&UAV7cs0RjXF5FkK+009C7
z2oNAZfB*pk1PBlyK!5-N0t5&UAV7cs0RjXF5FkK+009C72oNAZfB*pk1PBlyK!5-N
z0t5&UAV7cs0RjXF5FkK+009C72oNAZfB*pk1PBlyK!5-N0t5&UAV7cs0RjXF5FkK+
z009C72oNAZfB*pk1PBlyK!5-N0t5&UAV7cs0RjXF5FkK+009C72oNAZfB*pk1PBly
zK!5-N0t5&UAV7cs0RjXF5FkK+009C72oNAZfB*pk1PBlyK!5-N0t5&UAV7cs0RjXF
z5FkK+009C72oNAZfB*pk1PBlyK!5-N0t5&UAV7cs0RjXF5FkK+009C72oNAZfB*pk
z1PBlyK!5-N0t5&UAV7cs0RjXF5FkK+009C72oNAZfB*pk1PBlyK!5-N0t5&UAV7cs
K0Rja6k-!mtcpDJ_

literal 0
HcmV?d00001


_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
