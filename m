Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 85953339AD;
	Tue, 30 Jan 2024 23:35:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706657742; cv=none; b=DJzJvpoPcKRvoPCCvyogOhMN1EzF3yUVrC4I++nbf1IFMUrhUXc0elsR0P5X+nD7TulogzIPOV4pMnKwO1N7HyF3iKYY4n7PaS9uiGmn5wFvUZ2h14HUuiUUDctaO8aK1vcTXtM+p7JutiU3Xl8w5tmp4kbogvb8SmlD5XFTUJQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706657742; c=relaxed/simple;
	bh=mDKYXgp0s7UWza1h6uvX4k5stSsl1KZZYHlG//D05NY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XfWnR/HArmdx2Tv4ZMoo5MMY0+KrOij762GUzbZ68gPQPCjb+1MdeHotuQipoPGWWODqjeQkPUiHR2mA4rjcZ/ZCzpQE88I7afzl8wvs5cQ37ilWEeObfDTSvuVTq8YruuNtc6Qpc0YTPAfp9ScYvqJz7bXAFum3AUCKuGm6TNU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C58DCC433C7;
	Tue, 30 Jan 2024 23:35:41 +0000 (UTC)
From: Dave Jiang <dave.jiang@intel.com>
To: linux-cxl@vger.kernel.org,
	nvdimm@lists.linux.dev
Cc: vishal.l.verma@intel.com
Subject: [NDCTL PATCH v4 4/4] ndctl: add test for qos_class in cxl-topology.sh
Date: Tue, 30 Jan 2024 16:32:44 -0700
Message-ID: <20240130233526.1031801-5-dave.jiang@intel.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240130233526.1031801-1-dave.jiang@intel.com>
References: <20240130233526.1031801-1-dave.jiang@intel.com>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Add tests in cxl-topology.sh to verify qos_class are set with the fake
qos_class create by the kernel.  Root decoders should have qos_class
attribute set. Memory devices should have ram_qos_class or pmem_qos_class
set depending on which partitions are valid.

Signed-off-by: Dave Jiang <dave.jiang@intel.com>
---
 test/common          |  4 ++++
 test/cxl-topology.sh | 42 ++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 46 insertions(+)

diff --git a/test/common b/test/common
index f1023ef20f7e..5694820c7adc 100644
--- a/test/common
+++ b/test/common
@@ -150,3 +150,7 @@ check_dmesg()
 	grep -q "Call Trace" <<< $log && err $1
 	true
 }
+
+
+# CXL COMMON
+TEST_QOS_CLASS=42
diff --git a/test/cxl-topology.sh b/test/cxl-topology.sh
index e8b9f56543b5..d11a8cf11965 100644
--- a/test/cxl-topology.sh
+++ b/test/cxl-topology.sh
@@ -2,6 +2,45 @@
 # SPDX-License-Identifier: GPL-2.0
 # Copyright (C) 2022 Intel Corporation. All rights reserved.
 
+check_qos_decoders () {
+	# check root decoders have expected fake qos_class
+	# also make sure the number of root decoders equal to the number
+	# with qos_class found
+	json=$($CXL list -b cxl_test -D -d root)
+	decoders=$(echo "$json" | jq length)
+	count=0
+	while read -r qos_class
+	do
+		((qos_class == TEST_QOS_CLASS)) || err "$LINENO"
+		count=$((count+1))
+	done <<< "$(echo "$json" | jq -r '.[] | .qos_class')"
+
+	((count == decoders)) || err "$LINENO";
+}
+
+check_qos_memdevs () {
+	# Check that memdevs that expose ram_qos_class or pmem_qos_class have
+	# expected fake value programmed.
+	json=$(cxl list -b cxl_test -M)
+	readarray -t lines < <(jq ".[] | .ram_size, .pmem_size, .ram_qos_class, .pmem_qos_class" <<<"$json")
+	for (( i = 0; i < ${#lines[@]}; i += 4 ))
+	do
+		ram_size=${lines[i]}
+		pmem_size=${lines[i+1]}
+		ram_qos_class=${lines[i+2]}
+		pmem_qos_class=${lines[i+3]}
+
+		if [[ "$ram_size" != null ]]
+		then
+			((ram_qos_class == TEST_QOS_CLASS)) || err "$LINENO"
+		fi
+		if [[ "$pmem_size" != null ]]
+		then
+			((pmem_qos_class == TEST_QOS_CLASS)) || err "$LINENO"
+		fi
+	done
+}
+
 . $(dirname $0)/common
 
 rc=77
@@ -121,6 +160,8 @@ if (( bridges == 3 )); then
 	((count == 1)) || err "$LINENO"
 fi
 
+check_min_kver "6.9" && check_qos_decoders
+
 # check that all 8 or 10 cxl_test memdevs are enabled by default and have a
 # pmem size of 256M, or 1G
 json=$($CXL list -b cxl_test -M)
@@ -128,6 +169,7 @@ count=$(jq "map(select(.pmem_size == $pmem_size)) | length" <<< $json)
 ((bridges == 2 && count == 8 || bridges == 3 && count == 10 ||
   bridges == 4 && count == 11)) || err "$LINENO"
 
+check_min_kver "6.9" && check_qos_memdevs
 
 # check that switch ports disappear after all of their memdevs have been
 # disabled, and return when the memdevs are enabled.
-- 
2.43.0

