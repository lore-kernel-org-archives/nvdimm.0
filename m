Received: from mail-dl1-f44.google.com (mail-dl1-f44.google.com [74.125.82.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 16D1A3DFC8F
	for <nvdimm@lists.linux.dev>; Thu, 25 Jun 2026 12:13:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.82.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782389609; cv=none; b=M5znDoHjycxTOZVEeNl2V7i/5J8Qqe5gQn78lmKNGFCMSWJ/EOeX198FV0s1D6GPulInWJxlmuwdESY2tT1HPsFyVEB0vmeYGo7g82KBnFG02v642xcYWo9EaWsZOH3Qvy18cQW7dCnREuJuyBZZhwCP9DTyJjfHLRKWEZ9t+G4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782389609; c=relaxed/simple;
	bh=+hmDjAQ8OZ28kAo7Eodzj5AipjsV6tlJEnFEkAQNo8Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Gcx/oeOesCRDg0SZx/WdruIOrmjFLHXB7SzbD0mdGiiN5bONV6v6zjHFUC1G1FimjJkRM88Eoi/Nr+ms8jpGNtmuDPXyesJ1nU5wP4HeBWN1u0QjnrhZxiN1L9cQ/NhH66ZdiW7WtqvUVE0rFKkTR+JqgF5BysSNVLvdPrvAxWw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=lZ1ojpLo; arc=none smtp.client-ip=74.125.82.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="lZ1ojpLo"
Received: by mail-dl1-f44.google.com with SMTP id a92af1059eb24-139d5c9a495so3206516c88.0
        for <nvdimm@lists.linux.dev>; Thu, 25 Jun 2026 05:13:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1782389605; x=1782994405; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=+NnxoQdvnuDHscCJor8mA+n9igJ3CTQHa+EenHPQ1PM=;
        b=lZ1ojpLoguRQDB9S/IRfPmsP6Mo1FFIL1ydtZuH7BdbyZmKDkRmPKHgp8O7OB2faaJ
         2so9E/8VTpAuIou6yA3DzTSbqdPba8pmPAQr4+Q3AC9n9I5cd+Qs1F59Kq5QDGe7y/XF
         P0uLFg8L4ziD+ss5pSYS+35Rn/m41wNOXCnGhQbIuQ18s0u0Ogzpakh3ixyiL3JwGBJI
         UNrNA+13lBF3GFMjaMT65MINLstK3GyMYib8zUMsvk/YEQdIgV/H5HBaLo8OQcttXB2Z
         phqaa841F/n5X+bLALCeocPGnbNaawOkujZyELcWxer7nEb2VE9XF+i3RaYGBmCdszX1
         uDVQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1782389605; x=1782994405;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=+NnxoQdvnuDHscCJor8mA+n9igJ3CTQHa+EenHPQ1PM=;
        b=DGeQOLIVmmxfItljlei8TF5QHqt6zggYaUFsVhvtBv9vtAYEL9h8HuYnOEu8a11GnS
         Yb3aS9UPD0TqqII/e6araq1GJueBj/v9yYf4eapMr/OqxPruQi/T6v4ER2OCSEIulIIW
         /P5f+GwoRThMLCPxuuswUmhygNzIjn3lszerflI9Ttj6LDOiS9AsAxs+Uzl4/LV1qjhZ
         FYEC1RlUsKR8LoqO5RG8RVARwNwf0PJ1CBYt//zMX/hrJY1VIry3z2AbCmK65uJ70NXU
         T/Q0jddv4UivNQ120X/MSdhOe0NgSENc4GDloY7yJaRndxECW+PxIX+WzpBX+o9zCinE
         u2lg==
X-Gm-Message-State: AOJu0YwM5sLJtHndJBiBEf93l2Vg0H5lnOx2lSu2sCUK0vHkjZWiZ4Op
	D7HWCnq6397cNzzeA0xDJJoakqw0/hKXhSyj7P50ZNojZVC0jsRPQFj2
X-Gm-Gg: AfdE7cmF1BH2u+jW57UGwWP145K8teSvYY2NRx2ZVH+v+DmQSISLMdCXQaHqE4HKWp3
	+OM+7ZOCWVgXw7dYD62Ep6Axe4khr5HHQW3HY84ybFWVO2T0YRCypi1Hz1FyT1nckUkPkiRpUDy
	f4BO9JN7MsRk/L9ma5NTkNJEjzZ7bwxFmsRQpCRf8P6KqWYGyTTwSaWsYKhZ2+OBk5AQi283Toq
	qWeKYirscVhZ6SA411CqjDmwHX5T27Sc7GLAsd3hC3hJs5FRZg0xjXDGb44wqB6wXI3HbW4OYEB
	pND9AukRLPqijCtNLxcYGoXJ4njzFuGAkm6gQVNukhdL9J1p8pglVg7C4jvsv3BdNh9/jsmnBWT
	FzpoaEqy8PAx5ezQbMEbj+8y+Sin1TuoCM1Tj9Q3KZi+45gbMGLUODmVNI2QaGQjeUHbnICi7cQ
	U1MQqCfUbn3rmF3L/dO0JT9vFYYKcZVS3yg3PlIB0e4bukUBAQbTF0Jh5e5fAyrWsdpyHf
X-Received: by 2002:a05:7022:481:b0:133:1ba6:f42d with SMTP id a92af1059eb24-139dbaa6f11mr2370368c88.3.1782389604651;
        Thu, 25 Jun 2026 05:13:24 -0700 (PDT)
Received: from AnisaLaptop.localdomain (c-73-170-217-179.hsd1.ca.comcast.net. [73.170.217.179])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-139d8f77602sm7422206c88.8.2026.06.25.05.13.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 25 Jun 2026 05:13:24 -0700 (PDT)
From: Anisa Su <anisa.su887@gmail.com>
X-Google-Original-From: Anisa Su <anisa.su@samsung.com>
To: linux-cxl@vger.kernel.org,
	linux-kernel@vger.kernel.org
Cc: nvdimm@lists.linux.dev,
	Dan Williams <djbw@kernel.org>,
	Jonathan Cameron <jic23@kernel.org>,
	Davidlohr Bueso <dave@stgolabs.net>,
	Dave Jiang <dave.jiang@intel.com>,
	Vishal Verma <vishal.l.verma@intel.com>,
	Ira Weiny <iweiny@kernel.org>,
	Alison Schofield <alison.schofield@intel.com>,
	John Groves <John@Groves.net>,
	Gregory Price <gourry@gourry.net>,
	Anisa Su <anisa.su@samsung.com>
Subject: [NDCTL PATCH v7 5/5] cxl/test: Add Dynamic Capacity tests
Date: Thu, 25 Jun 2026 05:09:39 -0700
Message-ID: <20260625121242.603807-6-anisa.su@samsung.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260625121242.603807-1-anisa.su@samsung.com>
References: <20260625121242.603807-1-anisa.su@samsung.com>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Ira Weiny <iweiny@kernel.org>

cxl_test provides a good way to ensure quick smoke and regression
testing.  The complexity of DCD and the new sparse DAX regions
required to use them benefits greatly with a series of smoke tests.

The only part of the kernel stack which must be bypassed is the actual
irq of DCD events.  However, the event processing itself can be tested
via cxl_test calling directly into the event processing.

In this way the rest of the stack; management of sparse regions, the
extent device lifetimes, and the dax device operations can be tested.

Add Dynamic Capacity Device tests for kernels which have DCD support.

Signed-off-by: Ira Weiny <iweiny@kernel.org>
Signed-off-by: Anisa Su <anisa.su@samsung.com>
Reviewed-by: Dave Jiang <dave.jiang@intel.com>
---
 test/cxl-dcd.sh  | 1275 ++++++++++++++++++++++++++++++++++++++++++++++
 test/meson.build |    2 +
 2 files changed, 1277 insertions(+)
 create mode 100644 test/cxl-dcd.sh

diff --git a/test/cxl-dcd.sh b/test/cxl-dcd.sh
new file mode 100644
index 0000000..0d50724
--- /dev/null
+++ b/test/cxl-dcd.sh
@@ -0,0 +1,1275 @@
+#!/bin/bash
+# SPDX-License-Identifier: GPL-2.0
+# Copyright (C) 2024 Intel Corporation. All rights reserved.
+
+. "$(dirname "$0")/common"
+
+rc=77
+set -ex
+
+trap 'err $LINENO' ERR
+
+check_prereq "jq"
+
+rc=1
+
+dev_path="/sys/bus/platform/devices"
+cxl_path="/sys/bus/cxl/devices"
+
+# test extent tags (UUIDs).  pre_ext_tag matches the second pre-injected
+# extent tag in the kernel mock (tools/testing/cxl/test/mem.c).
+pre_ext_tag="deadbeef-cafe-baad-f00d-fedcba987654"
+test_tag_a="11111111-1111-1111-1111-111111111111"
+test_tag_b="22222222-2222-2222-2222-222222222222"
+unknown_tag="33333333-3333-3333-3333-333333333333"
+
+#
+# The test devices have 2G of non DC capacity.  A single DC reagion of 1G is
+# added beyond that.
+#
+# The testing centers around 3 extents.  Two are "pre-existing" on test load
+# called pre-ext and pre2-ext.  The other is created within this script alone
+# called base.
+
+#
+# | 2G non- |      DC region (1G)                                   |
+# |  DC cap |                                                       |
+# |  ...    |-------------------------------------------------------|
+# |         |--------|       |----------|      |----------|         |
+# |         | (base) |       |(pre-ext) |      |(pre2-ext)|         |
+
+dra_size=""
+
+base_dpa=0x80000000
+
+# base extent at dpa 2G - 64M long
+base_ext_offset=0x0
+base_ext_dpa=$(($base_dpa + $base_ext_offset))
+base_ext_length=0x4000000
+
+# pre existing extent base + 128M, 64M length
+# 0x00000088000000-0x0000008bffffff
+pre_ext_offset=0x8000000
+pre_ext_dpa=$(($base_dpa + $pre_ext_offset))
+pre_ext_length=0x4000000
+
+# pre2 existing extent base + 256M, 64M length
+# 0x00000090000000-0x00000093ffffff
+pre2_ext_offset=0x10000000
+pre2_ext_dpa=$(($base_dpa + $pre2_ext_offset))
+pre2_ext_length=0x4000000
+
+mem=""
+bus=""
+device=""
+decoder=""
+
+# ========================================================================
+# Support functions
+# ========================================================================
+
+create_dcd_region()
+{
+	local mem="$1"
+	local decoder="$2"
+	local reg_size_string=""
+	local region
+	if [ "$3" != "" ]; then
+		reg_size_string="-s $3"
+	fi
+
+	# create region
+	region=$($CXL create-region -t dynamic_ram_1 -d "$decoder" -m "$mem" ${reg_size_string} | jq -r ".region")
+
+	if [[ ! $region ]]; then
+		echo "create-region failed for $decoder / $mem"
+		err "$LINENO"
+	fi
+
+	echo ${region}
+}
+
+check_region()
+{
+	local search=$1
+	local region_size=$2
+	local result
+
+	result=$($CXL list -r "$search" | jq -r ".[].region")
+	if [ "$result" != "$search" ]; then
+		echo "check region failed to find $search"
+		err "$LINENO"
+	fi
+
+	result=$($CXL list -r "$search" | jq -r ".[].size")
+	if [ "$result" != "$region_size" ]; then
+		echo "check region failed invalid size $result != $region_size"
+		err "$LINENO"
+	fi
+}
+
+check_not_region()
+{
+	local search=$1
+	local result
+
+	result=$($CXL list -r "$search" | jq -r ".[].region")
+	if [ "$result" == "$search" ]; then
+		echo "check not region failed; $search found"
+		err "$LINENO"
+	fi
+}
+
+destroy_region()
+{
+	local region=$1
+	$CXL disable-region $region
+	$CXL destroy-region $region
+}
+
+inject_extent()
+{
+	local device="$1"
+	local dpa="$2"
+	local length="$3"
+	local tag="$4"
+	local seq="$6"
+	local more="0"
+	local cmd
+
+	if [ "$5" != "" ]; then
+		more="1"
+	fi
+
+	cmd="${dpa}:${length}:${tag}:${more}"
+	if [ -n "$seq" ]; then
+		cmd="${cmd}:${seq}"
+	fi
+	echo ${cmd} > "${dev_path}/${device}/dc_inject_extent"
+}
+
+# Shared-extent inject targets a *sharable* DC partition.  The mock
+# stamps the sentinel serial onto a single cxl_mem instance, and the
+# script routes shared-extent tests to that memdev via $sharable_device.
+inject_shared_extent()
+{
+	local device="$1"
+	local dpa="$2"
+	local length="$3"
+	local tag="$4"
+	local seq="$6"
+	local more="0"
+	local cmd
+
+	if [ "$5" != "" ]; then
+		more="1"
+	fi
+
+	cmd="${dpa}:${length}:${tag}:${more}"
+	if [ -n "$seq" ]; then
+		cmd="${cmd}:${seq}"
+	fi
+	echo ${cmd} > "${dev_path}/${device}/dc_inject_shared_extent"
+}
+
+remove_extent()
+{
+	local device="$1"
+	local dpa="$2"
+	local length="$3"
+	local tag="$4"
+
+	echo ${dpa}:${length}:${tag} > "${dev_path}/${device}/dc_del_extent"
+}
+
+create_dax_dev()
+{
+	local reg="$1"
+	local dax_dev
+
+	dax_dev=$($DAXCTL create-device -r $reg | jq -er '.[].chardev')
+
+	echo ${dax_dev}
+}
+
+create_dax_dev_with_uuid()
+{
+	local reg="$1"
+	local uuid="$2"
+	local dax_dev
+
+	dax_dev=$($DAXCTL create-device -r $reg --uuid "$uuid" \
+			| jq -er '.[].chardev')
+
+	echo ${dax_dev}
+}
+
+fail_create_dax_dev_with_uuid()
+{
+	local reg="$1"
+	local uuid="$2"
+	local create_rc
+
+	set +e
+	$DAXCTL create-device -r $reg --uuid "$uuid"
+	create_rc=$?
+	set -e
+	if [ $create_rc -eq 0 ]; then
+		echo "FAIL create-device with uuid $uuid unexpectedly succeeded"
+		err "$LINENO"
+	fi
+}
+
+fail_create_dax_dev()
+{
+	local reg="$1"
+	local result
+
+	set +e
+	result=$($DAXCTL create-device -r $reg)
+	set -e
+	if [ "$result" == "0" ]; then
+		echo "FAIL device created"
+		err "$LINENO"
+	fi
+}
+
+# Try to resize a sparse dax device via reconfigure -s; must fail because
+# the kernel rejects any non-zero size_store on a dynamic dax region with
+# -EOPNOTSUPP (drivers/dax/bus.c:dev_dax_resize).  The only valid resize is
+# to size 0, which is the path `daxctl destroy-device` takes.
+fail_resize_dax_dev()
+{
+	local dev="$1"
+	local new_size="$2"
+	local resize_rc
+
+	$DAXCTL disable-device $dev
+	set +e
+	$DAXCTL reconfigure-device $dev -s $new_size
+	resize_rc=$?
+	set -e
+	# Re-enable regardless so subsequent checks/cleanup work.
+	$DAXCTL enable-device $dev
+	if [ $resize_rc -eq 0 ]; then
+		echo "FAIL resize of $dev to $new_size unexpectedly succeeded"
+		err "$LINENO"
+	fi
+}
+
+# Read /sys/bus/dax/devices/<dax>/uuid and compare to $expected.  "0" is
+# shorthand for the null UUID, which the kernel emits (as the full
+# 00000000-0000-0000-0000-000000000000 form) when the resource is empty,
+# untagged, or non-DCD.
+check_dax_uuid()
+{
+	local dax_dev="$1"
+	local expected="$2"
+	local uuid_path got want
+	local null_uuid="00000000-0000-0000-0000-000000000000"
+
+	uuid_path="/sys/bus/dax/devices/${dax_dev}/uuid"
+	if [ ! -e "$uuid_path" ]; then
+		echo "FAIL no uuid attribute at $uuid_path"
+		err "$LINENO"
+	fi
+	if [ "$expected" = "0" ]; then
+		expected="$null_uuid"
+	fi
+	got=$(cat "$uuid_path" | tr -d '[:space:]')
+	want=$(echo "$expected" | tr -d '[:space:]')
+	if [ "$got" != "$want" ]; then
+		echo "FAIL uuid show on $dax_dev: got '$got' want '$want'"
+		err "$LINENO"
+	fi
+}
+
+destroy_dax_dev()
+{
+	local dev="$1"
+
+	$DAXCTL disable-device $dev
+	$DAXCTL destroy-device $dev
+}
+
+check_dax_dev()
+{
+	local search="$1"
+	local size=$(($2))
+	local result
+
+	result=$($DAXCTL list -d $search | jq -er '.[].chardev')
+	if [ "$result" != "$search" ]; then
+		echo "check dax device failed to find $search"
+		err "$LINENO"
+	fi
+	result=$($DAXCTL list -d $search | jq -er '.[].size')
+	if [ "$result" -ne "$size" ]; then
+		echo "check dax device failed incorrect size $result; exp $size"
+		err "$LINENO"
+	fi
+}
+
+# check that the dax device is not there.
+check_not_dax_dev()
+{
+	local reg="$1"
+	local search="$2"
+	local result
+	result=$($DAXCTL list -r $reg -D | jq -r '.[].chardev')
+	if [ "$result" == "$search" ]; then
+		echo "FAIL found $search"
+		err "$LINENO"
+	fi
+}
+
+check_extent()
+{
+	local region=$1
+	local offset=$(($2))
+	local length=$(($3))
+	local result
+
+	result=$($CXL list -r "$region" -N | jq -r ".[].extents[] | select(.offset == ${offset}) | .length")
+	if [[ $result != $length ]]; then
+		echo "FAIL region $1 could not find extent @ $offset ($length)"
+		err "$LINENO"
+	fi
+}
+
+check_extent_cnt()
+{
+	local region=$1
+	local count=$(($2))
+	local result
+
+	result=$($CXL list -r $region -N | jq -r '.[].extents[].offset' | wc -l)
+	if [[ $result != $count ]]; then
+		echo "FAIL region $1: found wrong number of extents $result; expect $count"
+		err "$LINENO"
+	fi
+}
+
+
+# ========================================================================
+# Tests
+# ========================================================================
+
+# testing pre existing extents must be called first as the extents were created
+# by cxl-test being loaded.  The mock fixture is one untagged extent at
+# pre_ext_dpa and one tagged (pre_ext_tag) extent at pre2_ext_dpa, so the
+# untagged extent is claimed via --uuid "0" and the tagged one via its UUID.
+test_pre_existing_extents()
+{
+	echo ""
+	echo "Test: pre-existing extents (untagged + tagged)"
+	echo ""
+	region=$(create_dcd_region ${mem} ${decoder})
+
+	# | 2G non- |      DC region                                        |
+	# |  DC cap |                                                       |
+	# |  ...    |-------------------------------------------------------|
+	# |         |                   |----------|         |----------|   |
+	# |         |                   |(pre-ext) |         |(pre2-ext)|   |
+	# |         |                   | untagged |         | tagged   |   |
+	check_region ${region} ${dra_size}
+	check_extent ${region} ${pre_ext_offset} ${pre_ext_length}
+	check_extent ${region} ${pre2_ext_offset} ${pre2_ext_length}
+
+	# Untagged claim picks up the untagged pre-extent only
+	dax_dev_u=$(create_dax_dev_with_uuid ${region} "0")
+	check_dax_dev ${dax_dev_u} $pre_ext_length
+
+	# Tagged claim picks up the tagged pre2-extent
+	dax_dev_t=$(create_dax_dev_with_uuid ${region} "$pre_ext_tag")
+	check_dax_dev ${dax_dev_t} $pre2_ext_length
+
+	destroy_dax_dev ${dax_dev_u}
+	destroy_dax_dev ${dax_dev_t}
+
+	# Release events must carry the tag identity so cxl_rm_extent's
+	# uuid_equal lookup matches the right region_extent.
+	remove_extent ${device} $pre_ext_dpa $pre_ext_length ""
+	remove_extent ${device} $pre2_ext_dpa $pre2_ext_length "$pre_ext_tag"
+	check_extent_cnt ${region} 0
+	destroy_region ${region}
+	check_not_region ${region}
+}
+
+test_remove_extent_under_dax_device()
+{
+	# Remove the pre-created test extent out from under dax device
+	# stack should hold ref until dax device deleted
+	echo ""
+	echo "Test: Remove extent from under DAX dev"
+	echo ""
+
+	region=$(create_dcd_region ${mem} ${decoder})
+	check_region ${region} ${dra_size}
+	# | 2G non- |      DC region                                        |
+	# |  DC cap |                                                       |
+	# |  ...    |-------------------------------------------------------|
+	# |         |                                                       |
+	# |         |                                                       |
+
+	
+	inject_extent ${device} $pre_ext_dpa $pre_ext_length ""
+	# |         |                   |----------|                        |
+	# |         |                   |(pre-ext) |                        |
+	check_extent ${region} ${pre_ext_offset} ${pre_ext_length}
+
+	# Sparse seed starts at size 0; --uuid "0" is the only sizing path.
+	dax_dev=$(create_dax_dev_with_uuid ${region} "0")
+	# |         |                   |----------|                        |
+	# |         |                   |(pre-ext) |                        |
+	# |         |                   | daxX.1   |                        |
+	check_extent_cnt ${region} 1
+	remove_extent ${device} $pre_ext_dpa $pre_ext_length ""
+	# In-use extents are not released (dax-layer EBUSY defers release).
+	check_dax_dev ${dax_dev} $pre_ext_length
+
+	check_extent_cnt ${region} 1
+	destroy_dax_dev ${dax_dev}
+	# |         |                   |----------|                        |
+	# |         |                   |(pre-ext) |                        |
+	check_not_dax_dev ${region} ${dax_dev}
+
+	check_extent_cnt ${region} 1
+	# Re-issuing the release after the dax device dropped its hold
+	# completes the deferred release.
+	remove_extent ${device} $pre_ext_dpa $pre_ext_length ""
+	# |         |                                                       |
+	# |         |                                                       |
+	check_extent_cnt ${region} 0
+	destroy_region ${region}
+	check_not_region ${region}
+}
+
+test_remove_extents_in_use()
+{
+	echo ""
+	echo "Test: Remove extents under sparse dax device"
+	echo ""
+	# Tagged release events are deferred while a dax device pins the
+	# tag group; extent count stays at 2.
+	remove_extent ${device} $base_ext_dpa $base_ext_length "$test_tag_a"
+	check_extent_cnt ${region} 2
+	remove_extent ${device} $pre_ext_dpa $pre_ext_length "$test_tag_a"
+	check_extent_cnt ${region} 2
+}
+
+test_create_dax_dev_spanning_two_extents()
+{
+	echo ""
+	echo "Test: Create dax device spanning 2 extents in a tagged group"
+	echo ""
+
+	region=$(create_dcd_region ${mem} ${decoder})
+	check_region ${region} ${dra_size}
+	# | 2G non- |      DC region                                        |
+	# |  DC cap |                                                       |
+	# |  ...    |-------------------------------------------------------|
+	#
+	# A single dax device spanning two extents is only possible when
+	# both extents belong to the same tagged More-chain.  Cross-event
+	# tagged adds are rejected by the cross-More uniqueness gate;
+	# untagged adds become independent dax_resources and only one is
+	# claimed per --uuid "0".  Drive both extents in one More-chain:
+	inject_extent ${device} $pre_ext_dpa $pre_ext_length "$test_tag_a" 1
+	check_extent_cnt ${region} 0   # held off until More=0 closes chain
+	inject_extent ${device} $base_ext_dpa $base_ext_length "$test_tag_a"
+	check_extent ${region} ${pre_ext_offset} ${pre_ext_length}
+	check_extent ${region} ${base_ext_offset} ${base_ext_length}
+	# |         |--------|          |----------|                        |
+	# |         | (base) |          |(pre-ext) |     tag_a              |
+
+	check_extent_cnt ${region} 2
+	dax_dev=$(create_dax_dev_with_uuid ${region} "$test_tag_a")
+	# |         |--------|          |----------|                        |
+	# |         | (base) |          |(pre-ext) |                        |
+	# |         | daxX.1 |          | daxX.1   |                        |
+
+	echo "Checking if dev dax is spanning sparse extents"
+	ext_sum_length="$(($base_ext_length + $pre_ext_length))"
+	check_dax_dev ${dax_dev} $ext_sum_length
+
+	test_remove_extents_in_use
+
+	destroy_dax_dev ${dax_dev}
+	check_not_dax_dev ${region} ${dax_dev}
+
+	# In-use extents were not released.  Check they can be removed after
+	# the dax device is removed.
+	check_extent_cnt ${region} 2
+	remove_extent ${device} $base_ext_dpa $base_ext_length "$test_tag_a"
+	remove_extent ${device} $pre_ext_dpa $pre_ext_length "$test_tag_a"
+	check_extent_cnt ${region} 0
+	destroy_region ${region}
+	check_not_region ${region}
+}
+
+test_inject_tag_support()
+{
+	echo ""
+	echo "Test: inject untagged + tagged extents, claim each via --uuid"
+	echo ""
+
+	region=$(create_dcd_region ${mem} ${decoder})
+	check_region ${region} ${dra_size}
+
+	# untagged extent
+	inject_extent ${device} $pre_ext_dpa $pre_ext_length ""
+	check_extent ${region} ${pre_ext_offset} ${pre_ext_length}
+	# tagged extent (different DPA so both can land)
+	inject_extent ${device} $base_ext_dpa $base_ext_length "$test_tag_a"
+
+	# both extents should be accepted
+	check_extent_cnt ${region} 2
+
+	# claim the tagged extent into one dax device
+	dax_dev_a=$(create_dax_dev_with_uuid ${region} "$test_tag_a")
+	check_dax_dev ${dax_dev_a} $base_ext_length
+
+	# claim the untagged extent into a second dax device via "0"
+	dax_dev_0=$(create_dax_dev_with_uuid ${region} "0")
+	check_dax_dev ${dax_dev_0} $pre_ext_length
+
+	destroy_dax_dev ${dax_dev_a}
+	destroy_dax_dev ${dax_dev_0}
+	remove_extent ${device} $pre_ext_dpa $pre_ext_length ""
+	remove_extent ${device} $base_ext_dpa $base_ext_length "$test_tag_a"
+	check_extent_cnt ${region} 0
+
+	destroy_region ${region}
+	check_not_region ${region}
+}
+
+test_uuid_no_match()
+{
+	echo ""
+	echo "Test: daxctl create-device --uuid with no matching extent fails"
+	echo ""
+
+	region=$(create_dcd_region ${mem} ${decoder})
+	check_region ${region} ${dra_size}
+
+	# inject only one tagged extent; ask daxctl to claim a different uuid
+	inject_extent ${device} $pre_ext_dpa $pre_ext_length "$test_tag_a"
+	check_extent_cnt ${region} 1
+
+	fail_create_dax_dev_with_uuid ${region} "$unknown_tag"
+
+	# the extent should still be claimable via its real tag
+	dax_dev=$(create_dax_dev_with_uuid ${region} "$test_tag_a")
+	check_dax_dev ${dax_dev} $pre_ext_length
+	destroy_dax_dev ${dax_dev}
+
+	remove_extent ${device} $pre_ext_dpa $pre_ext_length "$test_tag_a"
+	check_extent_cnt ${region} 0
+	destroy_region ${region}
+	check_not_region ${region}
+}
+
+test_uuid_aggregation()
+{
+	echo ""
+	echo "Test: multiple extents in a single More-chain aggregate under one tag"
+	echo ""
+
+	region=$(create_dcd_region ${mem} ${decoder})
+	check_region ${region} ${dra_size}
+
+	# Both extents must arrive in the same More-chain to land in the
+	# same tag group.  Re-using a tag across More-chains hits the
+	# cross-More uniqueness gate and the second event would be dropped.
+	inject_extent ${device} $base_ext_dpa $base_ext_length "$test_tag_a" 1
+	check_extent_cnt ${region} 0
+	inject_extent ${device} $pre_ext_dpa $pre_ext_length "$test_tag_a"
+	check_extent_cnt ${region} 2
+
+	# a single --uuid claim should pick up both extents
+	dax_dev=$(create_dax_dev_with_uuid ${region} "$test_tag_a")
+	expected=$(($base_ext_length + $pre_ext_length))
+	check_dax_dev ${dax_dev} $expected
+
+	destroy_dax_dev ${dax_dev}
+	remove_extent ${device} $base_ext_dpa $base_ext_length "$test_tag_a"
+	remove_extent ${device} $pre_ext_dpa $pre_ext_length "$test_tag_a"
+	destroy_region ${region}
+	check_not_region ${region}
+}
+
+
+test_partial_extent_remove ()
+{
+	echo ""
+	echo "Test: partial extent remove"
+	echo ""
+
+	region=$(create_dcd_region ${mem} ${decoder})
+	check_region ${region} ${dra_size}
+
+	# | 2G non- |      DC region                                        |
+	# |  DC cap |                                                       |
+	# |  ...    |-------------------------------------------------------|
+
+	inject_extent ${device} $base_ext_dpa $base_ext_length ""
+	# |  ...    |-------------------------------------------------------|
+	# |         |--------|                                              |
+	# |         | (base) |                                              |
+
+	dax_dev=$(create_dax_dev_with_uuid ${region} "0")
+
+	# |  ...    |-------------------------------------------------------|
+	# |         |--------|                                              |
+	# |         | (base) |                                              |
+	# |         | daxX.1 |                                              |
+
+	partial_ext_dpa="$(($base_ext_dpa + ($base_ext_length / 2)))"
+	partial_ext_length="$(($base_ext_length / 2))"
+	echo "Removing Partial : $partial_ext_dpa $partial_ext_length"
+
+	# |         |    |---|                                              |
+	#                  Partial
+
+	remove_extent ${device} $partial_ext_dpa $partial_ext_length ""
+	# In-use extents are not released.
+	check_extent_cnt ${region} 1
+
+	# |  ...    |-------------------------------------------------------|
+	# |         |--------|                                              |
+	# |         | (base) |                                              |
+	# |         | daxX.1 |                                              |
+
+	destroy_dax_dev ${dax_dev}
+	check_not_dax_dev ${region} ${dax_dev}
+
+	# |  ...    |-------------------------------------------------------|
+	# |         |--------|                                              |
+	# |         | (base) |                                              |
+
+	# Partial release event re-targets the whole containing region_extent.
+	check_extent_cnt ${region} 1
+	remove_extent ${device} $partial_ext_dpa $partial_ext_length ""
+	# |         |    |---|                                              |
+	#                  Partial
+	check_extent_cnt ${region} 0
+
+	# |  ...    |-------------------------------------------------------|
+	destroy_region ${region}
+	check_not_region ${region}
+}
+
+test_multiple_extent_remove ()
+{
+	# Per-tag-group release: a release event whose DPA range straddles
+	# multiple region_extents in the same tag group should target them
+	# atomically.  Set up two extents in one tagged More-chain.
+	echo ""
+	echo "Test: per-group release event covering two extents"
+	echo ""
+
+	region=$(create_dcd_region ${mem} ${decoder})
+	check_region ${region} ${dra_size}
+
+	# | 2G non- |      DC region                                        |
+	# |  DC cap |                                                       |
+	# |  ...    |-------------------------------------------------------|
+
+	inject_extent ${device} $base_ext_dpa $base_ext_length "$test_tag_a" 1
+	inject_extent ${device} $pre_ext_dpa $pre_ext_length "$test_tag_a"
+	# |  ...    |-------------------------------------------------------|
+	# |         |--------|          |-------------------|               |
+	# |         | (base) |          | (pre)-existing    |   tag_a       |
+
+	check_extent_cnt ${region} 2
+	dax_dev=$(create_dax_dev_with_uuid ${region} "$test_tag_a")
+
+	# |         | daxX.1 |          | daxX.1            |   tag_a       |
+
+	# A release event addressed at any DPA inside the tag group releases
+	# the whole group atomically.  Use base_ext_dpa so the kernel finds
+	# the tag group's region_extent on that DPA.
+	echo "Issuing tag-group release at $base_ext_dpa"
+	remove_extent ${device} $base_ext_dpa $base_ext_length "$test_tag_a"
+
+	# In-use extents are not released (dax-layer EBUSY defer).
+	check_extent_cnt ${region} 2
+
+	destroy_dax_dev ${dax_dev}
+	check_not_dax_dev ${region} ${dax_dev}
+
+	# |  ...    |-------------------------------------------------------|
+	# |         |--------|          |-------------------|               |
+	# |         | (base) |          | (pre)-existing    |               |
+
+	# Now that the dax dev is gone, re-issue the release(s) for each
+	# extent.  Each release event targets the containing region_extent.
+	remove_extent ${device} $base_ext_dpa $base_ext_length "$test_tag_a"
+	remove_extent ${device} $pre_ext_dpa $pre_ext_length "$test_tag_a"
+	check_extent_cnt ${region} 0
+
+	destroy_region ${region}
+	check_not_region ${region}
+}
+
+test_destroy_region_without_extent_removal ()
+{
+	echo ""
+	echo "Test: Destroy region without extent removal"
+	echo ""
+	
+	region=$(create_dcd_region ${mem} ${decoder})
+	check_region ${region} ${dra_size}
+	inject_extent ${device} $pre_ext_dpa $pre_ext_length ""
+	inject_extent ${device} $base_ext_dpa $base_ext_length ""
+	check_extent_cnt ${region} 2
+	destroy_region ${region}
+	check_not_region ${region}
+}
+
+test_destroy_with_extent_and_dax ()
+{
+	echo ""
+	echo "Test: Destroy region with extents and dax devices"
+	echo ""
+	region=$(create_dcd_region ${mem} ${decoder})
+	check_region ${region} ${dra_size}
+	check_extent_cnt ${region} 0
+	inject_extent ${device} $pre_ext_dpa $pre_ext_length ""
+	
+	# | 2G non- |      DC region                                        |
+	# |  DC cap |                                                       |
+	# |  ...    |-------------------------------------------------------|
+	# |         |                   |----------|                        |
+	# |         |                   |(pre-ext) |                        |
+
+	check_extent_cnt ${region} 1
+	dax_dev=$(create_dax_dev_with_uuid ${region} "0")
+	# |         |                   |<dax_dev> |                        |
+	check_dax_dev ${dax_dev} ${pre_ext_length}
+	destroy_region ${region}
+	check_not_region ${region}
+
+	# | 2G non- |      DC region                                        |
+	# |  DC cap |                                                       |
+	# |  ...    |-------------------------------------------------------|
+	# |         |                                                       |
+
+	region=$(create_dcd_region ${mem} ${decoder})
+	check_region ${region} ${dra_size}
+	check_extent_cnt ${region} 0
+	destroy_region ${region}
+	check_not_region ${region}
+}
+
+test_dax_device_ops ()
+{
+	echo ""
+	echo "Test: Fail sparse dax dev creation without space"
+	echo ""
+	region=$(create_dcd_region ${mem} ${decoder})
+	check_region ${region} ${dra_size}
+	inject_extent ${device} $pre_ext_dpa $pre_ext_length ""
+
+	# | 2G non- |      DC region                                        |
+	# |  DC cap |                                                       |
+	# |  ...    |-------------------------------------------------------|
+	# |         |                   |-------------------|               |
+	# |         |                   | (pre)-existing    |               |
+
+	check_extent_cnt ${region} 1
+
+	# |         |                   | daxX.1            |               |
+
+	dax_dev=$(create_dax_dev_with_uuid ${region} "0")
+	check_dax_dev ${dax_dev} $pre_ext_length
+	# No more untagged dax_resource avail: untagged claim returns -ENOENT
+	fail_create_dax_dev_with_uuid ${region} "0"
+	# Plain create-device on sparse: size grow is -EOPNOTSUPP
+	fail_create_dax_dev ${region}
+
+	# DC dax devices cannot be resized to a non-zero size.  The
+	# kernel rejects any size_store with -EOPNOTSUPP unless size == 0,
+	# in which case dev_dax_shrink releases every range -- the same path
+	# `daxctl destroy-device` takes.
+	echo ""
+	echo "Test: Resize of sparse dax device to non-zero is rejected"
+	echo ""
+	half=$(($pre_ext_length / 2))
+	fail_resize_dax_dev ${dax_dev} $half
+	check_dax_dev ${dax_dev} $pre_ext_length
+
+	# Destroy (size=0) is the only valid resize.  After it the
+	# dax_resource has avail again, so --uuid "0" can claim it back
+	# into a new dax device.
+	# |         |                   | daxX.2            |               |
+	echo ""
+	echo "Test: Destroy (size=0) of sparse dax device releases the resource"
+	echo ""
+	destroy_dax_dev ${dax_dev}
+	check_not_dax_dev ${region} ${dax_dev}
+	dax_dev2=$(create_dax_dev_with_uuid ${region} "0")
+	check_dax_dev ${dax_dev2} $pre_ext_length
+
+	destroy_region ${region}
+	check_not_region ${region}
+
+	# Multi-extent device must come from a single tagged group; cross-
+	# event untagged adds land in independent dax_resources and cannot
+	# be claimed as one dax device.  The no-resize rule applies equally
+	# across the tagged group.
+	echo ""
+	echo "Test: Resize of tagged multi-extent dax device is rejected"
+	echo ""
+	region=$(create_dcd_region ${mem} ${decoder})
+	check_region ${region} ${dra_size}
+	inject_extent ${device} $pre_ext_dpa $pre_ext_length "$test_tag_a" 1
+	inject_extent ${device} $base_ext_dpa $base_ext_length "$test_tag_a"
+
+	# | 2G non- |      DC region                                        |
+	# |  DC cap |                                                       |
+	# |  ...    |-------------------------------------------------------|
+	# |         |--------|          |-------------------|               |
+	# |         | (base) |          | (pre)-existing    |    tag_a      |
+
+	check_extent_cnt ${region} 2
+	dax_dev=$(create_dax_dev_with_uuid ${region} "$test_tag_a")
+	ext_sum_length="$(($base_ext_length + $pre_ext_length))"
+	check_dax_dev ${dax_dev} $ext_sum_length
+
+	# Any non-zero resize (here a shrink to 32M, which would sit inside
+	# the first extent of the group) is rejected.
+	fail_resize_dax_dev ${dax_dev} 33554432 # 32MB
+	check_dax_dev ${dax_dev} $ext_sum_length
+
+	# Only size=0 / destroy is valid for the tagged group too.
+	destroy_dax_dev ${dax_dev}
+	check_not_dax_dev ${region} ${dax_dev}
+
+	destroy_region ${region}
+	check_not_region ${region}
+}
+
+test_reject_overlapping ()
+{
+	echo ""
+	echo "Test: Rejecting overlapping extents"
+	echo ""
+
+	region=$(create_dcd_region ${mem} ${decoder})
+	check_region ${region} ${dra_size}
+	inject_extent ${device} $pre_ext_dpa $pre_ext_length ""
+
+	# | 2G non- |      DC region                                        |
+	# |  DC cap |                                                       |
+	# |  ...    |-------------------------------------------------------|
+	# |         |                   |-------------------|               |
+	# |         |                   | (pre)-existing    |               |
+
+	check_extent_cnt ${region} 1
+
+	# Attempt overlapping extent: start halfway through pre_ext, same
+	# length so it straddles the end of pre_ext.
+	#
+	# |         |                   |---------|---------|               |
+	# |         |                   |(pre-ext)| overlap |               |
+
+	partial_ext_dpa="$(($pre_ext_dpa + ($pre_ext_length / 2)))"
+	partial_ext_length=$pre_ext_length
+	inject_extent ${device} $partial_ext_dpa $partial_ext_length ""
+
+	# Should only see the original ext
+	check_extent_cnt ${region} 1
+	destroy_region ${region}
+	check_not_region ${region}
+}
+
+test_two_regions()
+{
+	echo ""
+	echo "Test: create 2 regions in the same DC partition"
+	echo ""
+	region_size=$(($dra_size / 2))
+	region=$(create_dcd_region ${mem} ${decoder} ${region_size})
+	check_region ${region} ${region_size}
+	
+	region_two=$(create_dcd_region ${mem} ${decoder} ${region_size})
+	check_region ${region_two} ${region_size}
+	
+	destroy_region ${region_two}
+	check_not_region ${region_two}
+	destroy_region ${region}
+	check_not_region ${region}
+}
+
+test_more_bit()
+{
+	echo ""
+	echo "Test: More bit"
+	echo ""
+	region=$(create_dcd_region ${mem} ${decoder})
+	check_region ${region} ${dra_size}
+	inject_extent ${device} $pre_ext_dpa $pre_ext_length "" 1
+	# More bit should hold off surfacing extent until the more bit is 0
+	check_extent_cnt ${region} 0
+	inject_extent ${device} $base_ext_dpa $base_ext_length ""
+	check_extent_cnt ${region} 2
+	destroy_region ${region}
+	check_not_region ${region}
+}
+
+test_driver_tear_down()
+{
+	echo ""
+	echo "Test: driver remove tear down"
+	echo ""
+	region=$(create_dcd_region ${mem} ${decoder})
+	check_region ${region} ${dra_size}
+	inject_extent ${device} $pre_ext_dpa $pre_ext_length ""
+	check_extent ${region} ${pre_ext_offset} ${pre_ext_length}
+	dax_dev=$(create_dax_dev_with_uuid ${region} "0")
+	# remove driver releases extents
+	modprobe -r dax_cxl
+	check_extent_cnt ${region} 0
+}
+
+test_driver_bring_up()
+{
+	# leave region up, driver removed.
+	echo ""
+	echo "Test: no driver inject ok"
+	echo ""
+	check_region ${region} ${dra_size}
+	inject_extent ${device} $pre_ext_dpa $pre_ext_length ""
+	check_extent_cnt ${region} 1
+
+	modprobe dax_cxl
+	check_extent_cnt ${region} 1
+
+	destroy_region ${region}
+	check_not_region ${region}
+}
+
+test_driver_reload()
+{
+	test_driver_tear_down
+	test_driver_bring_up
+}
+
+# Verify the dax dev's uuid sysfs attribute reflects the claim source:
+# "0" for untagged seed/claim, the tag string for tagged claims.
+test_uuid_show()
+{
+	echo ""
+	echo "Test: dax dev uuid attribute reflects the claim source"
+	echo ""
+
+	region=$(create_dcd_region ${mem} ${decoder})
+	check_region ${region} ${dra_size}
+
+	# Pre-claim the seed device's uuid (before any extent injected)
+	# must read back as "0".  -i includes the idle seed at size 0.
+	seed=$($DAXCTL list -r ${region} -D -i | jq -r '.[].chardev')
+	check_dax_uuid ${seed} "0"
+
+	# Untagged extent + claim: uuid stays "0"
+	inject_extent ${device} $pre_ext_dpa $pre_ext_length ""
+	dax_u=$(create_dax_dev_with_uuid ${region} "0")
+	check_dax_uuid ${dax_u} "0"
+
+	# Tagged extent + claim: uuid reads back as the tag
+	inject_extent ${device} $base_ext_dpa $base_ext_length "$test_tag_a"
+	dax_t=$(create_dax_dev_with_uuid ${region} "$test_tag_a")
+	check_dax_uuid ${dax_t} "$test_tag_a"
+
+	destroy_dax_dev ${dax_u}
+	destroy_dax_dev ${dax_t}
+	remove_extent ${device} $pre_ext_dpa $pre_ext_length ""
+	remove_extent ${device} $base_ext_dpa $base_ext_length "$test_tag_a"
+	destroy_region ${region}
+	check_not_region ${region}
+}
+
+# --uuid <unknown> on a sparse region must return -ENOENT before any
+# size is committed.  The region's available_size must be unchanged and
+# the underlying extent must still be claimable via its real tag.
+test_uuid_no_match_seed_intact()
+{
+	echo ""
+	echo "Test: --uuid mismatch does not consume any extent space"
+	echo ""
+
+	region=$(create_dcd_region ${mem} ${decoder})
+	check_region ${region} ${dra_size}
+
+	inject_extent ${device} $pre_ext_dpa $pre_ext_length "$test_tag_a"
+	check_extent_cnt ${region} 1
+
+	# Capture region available size before the failed claim
+	avail_before=$($DAXCTL list -r ${region} | jq -r '.[].available_size')
+
+	fail_create_dax_dev_with_uuid ${region} "$unknown_tag"
+
+	avail_after=$($DAXCTL list -r ${region} | jq -r '.[].available_size')
+	if [ "$avail_before" != "$avail_after" ]; then
+		echo "FAIL avail size changed by unmatched --uuid: $avail_before -> $avail_after"
+		err "$LINENO"
+	fi
+
+	# The real tag still claims successfully
+	dax_dev=$(create_dax_dev_with_uuid ${region} "$test_tag_a")
+	check_dax_dev ${dax_dev} $pre_ext_length
+
+	destroy_dax_dev ${dax_dev}
+	remove_extent ${device} $pre_ext_dpa $pre_ext_length "$test_tag_a"
+	destroy_region ${region}
+	check_not_region ${region}
+}
+
+# A second tagged Add-event reusing a previously committed tag must be
+# dropped by the cross-More uniqueness gate (firmware-bug path).  Skipped
+# for the null UUID.
+test_cross_more_uniqueness()
+{
+	echo ""
+	echo "Test: cross-More uniqueness drops second event with same tag"
+	echo ""
+
+	region=$(create_dcd_region ${mem} ${decoder})
+	check_region ${region} ${dra_size}
+
+	# First Add-event (single extent) commits tag_a at base_ext_dpa.
+	inject_extent ${device} $base_ext_dpa $base_ext_length "$test_tag_a"
+	check_extent_cnt ${region} 1
+
+	# Second Add-event reuses tag_a at a different DPA: must be dropped.
+	inject_extent ${device} $pre_ext_dpa $pre_ext_length "$test_tag_a"
+	check_extent_cnt ${region} 1
+
+	# The original tag_a allocation is still usable.
+	dax_dev=$(create_dax_dev_with_uuid ${region} "$test_tag_a")
+	check_dax_dev ${dax_dev} $base_ext_length
+
+	destroy_dax_dev ${dax_dev}
+	remove_extent ${device} $base_ext_dpa $base_ext_length "$test_tag_a"
+	destroy_region ${region}
+	check_not_region ${region}
+}
+
+# Sharable-partition test: two extents in one tagged More-chain with
+# device-stamped seq 0..1.  Per CXL r4.0 Table 8-230 a sharable n-extent
+# allocation is numbered 0..n-1.  Uses the sharable memdev (serial 0xDCDC).
+test_shared_extent_inject()
+{
+	echo ""
+	echo "Test: shared extent inject on sharable partition"
+	echo ""
+
+	region=$(create_dcd_region ${sharable_mem} ${sharable_decoder})
+	check_region ${region} ${sharable_dra_size}
+
+	inject_shared_extent ${sharable_device} $base_ext_dpa $base_ext_length \
+		"$test_tag_b" 1 0
+	check_extent_cnt ${region} 0
+	inject_shared_extent ${sharable_device} $pre_ext_dpa $pre_ext_length \
+		"$test_tag_b" "" 1
+	check_extent_cnt ${region} 2
+
+	dax_dev=$(create_dax_dev_with_uuid ${region} "$test_tag_b")
+	expected=$(($base_ext_length + $pre_ext_length))
+	check_dax_dev ${dax_dev} $expected
+
+	destroy_dax_dev ${dax_dev}
+	remove_extent ${sharable_device} $base_ext_dpa $base_ext_length "$test_tag_b"
+	remove_extent ${sharable_device} $pre_ext_dpa $pre_ext_length "$test_tag_b"
+	destroy_region ${region}
+	check_not_region ${region}
+}
+
+# Sharable extents must arrive with a dense 0..n-1 shared_extn_seq (CXL
+# r4.0 Table 8-230).  A gap (0, 2) is refused by the cxl-side density
+# check in cxl_check_group_seq() so the group never materializes; the
+# dax-side uuid_claim_tagged invariant is a further backstop.  Uses the
+# sharable memdev.
+test_seq_integrity_gap()
+{
+	echo ""
+	echo "Test: sharable extents with seq gap (0,2) refused on claim"
+	echo ""
+
+	region=$(create_dcd_region ${sharable_mem} ${sharable_decoder})
+	check_region ${region} ${sharable_dra_size}
+
+	inject_shared_extent ${sharable_device} $base_ext_dpa $base_ext_length \
+		"$test_tag_b" 1 0
+	check_extent_cnt ${region} 0
+	inject_shared_extent ${sharable_device} $pre_ext_dpa $pre_ext_length \
+		"$test_tag_b" "" 2
+
+	if [ "$(jq -r '.[].extents | length' <($CXL list -r ${region} -N))" = "2" ]; then
+		fail_create_dax_dev_with_uuid ${region} "$test_tag_b"
+		remove_extent ${sharable_device} $base_ext_dpa $base_ext_length "$test_tag_b"
+		remove_extent ${sharable_device} $pre_ext_dpa $pre_ext_length "$test_tag_b"
+	fi
+	check_extent_cnt ${region} 0
+	destroy_region ${region}
+	check_not_region ${region}
+}
+
+# CXL_DCD_EXTENT_ALIGN is 2M; an extent that is not 2M-aligned must drop
+# the whole group.  Inject a 64M extent at a 1M-offset DPA.
+test_alignment_rejection()
+{
+	echo ""
+	echo "Test: misaligned extent drops the group"
+	echo ""
+
+	region=$(create_dcd_region ${mem} ${decoder})
+	check_region ${region} ${dra_size}
+
+	# 1M past base — not 2M aligned
+	mis_dpa=$(($base_ext_dpa + 0x100000))
+	inject_extent ${device} $mis_dpa $base_ext_length ""
+	check_extent_cnt ${region} 0
+
+	destroy_region ${region}
+	check_not_region ${region}
+}
+
+test_event_reporting()
+{
+	# Test event reporting
+	# results expected
+	num_dcd_events_expected=2
+
+	echo "Test: Prep event trace"
+	echo "" > /sys/kernel/tracing/trace
+	echo 1 > /sys/kernel/tracing/events/cxl/enable
+	echo 1 > /sys/kernel/tracing/tracing_on
+
+	inject_extent ${device} $base_ext_dpa $base_ext_length ""
+	remove_extent ${device} $base_ext_dpa $base_ext_length ""
+
+	echo 0 > /sys/kernel/tracing/tracing_on
+
+	echo "Test: Events seen"
+	trace_out=$(cat /sys/kernel/tracing/trace)
+
+	# Look for DCD events
+	num_dcd_events=$(grep -c "cxl_dynamic_capacity" <<< "${trace_out}")
+	echo "     LOG     (Expected) : (Found)"
+	echo "     DCD events    ($num_dcd_events_expected) : $num_dcd_events"
+
+	if [ "$num_dcd_events" -ne $num_dcd_events_expected ]; then
+		err "$LINENO"
+	fi
+}
+
+
+# ========================================================================
+# main()
+# ========================================================================
+
+modprobe -r cxl_test
+modprobe cxl_test
+
+# The mock stamps a single cxl_mem instance with this serial (0xDCDC).
+# That memdev's DC partition is advertised as sharable in CDAT and is
+# the only one that can host the shared-extent tests.  All other DCD
+# memdevs stay non-sharable and host the rest of the suite.
+MOCK_DC_SHARABLE_SERIAL=56540
+
+readarray -t memdevs < <("$CXL" list -b cxl_test -Mi | jq -r '.[].memdev')
+
+sharable_mem=""
+sharable_decoder=""
+sharable_bus=""
+sharable_device=""
+sharable_dra_size=""
+
+for cand in ${memdevs[@]}; do
+	cand_dra=$($CXL list -m $cand | jq -r '.[].dynamic_ram_1_size')
+	if [ "$cand_dra" == "null" ]; then
+		continue
+	fi
+	cand_decoder=$($CXL list -b cxl_test -D -d root -m "$cand" |
+		  jq -r ".[] |
+		  select(.volatile_capable == true) |
+		  select(.nr_targets == 1) |
+		  select(.max_available_extent >= ${cand_dra}) |
+		  .decoder")
+	if [[ -z "$cand_decoder" ]]; then
+		continue
+	fi
+	cand_serial=$($CXL list -m $cand | jq -r '.[].serial')
+	cand_bus=`"$CXL" list -b cxl_test -m ${cand} | jq -r '.[].bus'`
+	cand_device=$($CXL list -m $cand | jq -r '.[].host')
+
+	if [ "$cand_serial" == "$MOCK_DC_SHARABLE_SERIAL" ]; then
+		if [ -z "$sharable_mem" ]; then
+			sharable_mem="$cand"
+			sharable_decoder="$cand_decoder"
+			sharable_bus="$cand_bus"
+			sharable_device="$cand_device"
+			sharable_dra_size="$cand_dra"
+		fi
+	else
+		if [ -z "$mem" ]; then
+			mem="$cand"
+			decoder="$cand_decoder"
+			bus="$cand_bus"
+			device="$cand_device"
+			dra_size="$cand_dra"
+		fi
+	fi
+
+	if [ -n "$mem" ] && [ -n "$sharable_mem" ]; then
+		break
+	fi
+done
+
+echo "TEST: non-sharable bus:${bus} decoder:${decoder} mem:${mem} device:${device} size:${dra_size}"
+echo "TEST: sharable     bus:${sharable_bus} decoder:${sharable_decoder} mem:${sharable_mem} device:${sharable_device} size:${sharable_dra_size}"
+
+if [ "$decoder" == "" ] || [ "$device" == "" ] || [ "$dra_size" == "" ]; then
+	echo "No non-sharable mem device/decoder found with DCD support"
+	exit 77
+fi
+
+if [ "$sharable_mem" == "" ]; then
+	echo "No sharable mem device found (mock did not stamp MOCK_DC_SHARABLE_SERIAL)"
+	exit 77
+fi
+
+# testing pre existing extents must be called first as the extents were created
+# by cxl-test being loaded
+test_pre_existing_extents
+test_remove_extent_under_dax_device
+test_create_dax_dev_spanning_two_extents
+test_inject_tag_support
+test_uuid_no_match
+test_uuid_no_match_seed_intact
+test_uuid_aggregation
+test_uuid_show
+# These two run on the sharable memdev (serial $MOCK_DC_SHARABLE_SERIAL).
+test_shared_extent_inject
+test_seq_integrity_gap
+test_cross_more_uniqueness
+test_alignment_rejection
+test_partial_extent_remove
+test_multiple_extent_remove
+test_destroy_region_without_extent_removal
+test_destroy_with_extent_and_dax
+test_dax_device_ops
+test_reject_overlapping
+test_two_regions
+test_more_bit
+test_driver_reload
+test_event_reporting
+
+modprobe -r cxl_test
+
+check_dmesg "$LINENO"
+
+exit 0
diff --git a/test/meson.build b/test/meson.build
index 56aed9c..2db7106 100644
--- a/test/meson.build
+++ b/test/meson.build
@@ -171,6 +171,7 @@ cxl_translate = find_program('cxl-translate.sh')
 cxl_elc = find_program('cxl-elc.sh')
 cxl_dax_hmem = find_program('cxl-dax-hmem.sh')
 cxl_region_replay = find_program('cxl-region-replay.sh')
+cxl_dcd = find_program('cxl-dcd.sh')
 
 tests = [
   [ 'libndctl',               libndctl,		  'ndctl' ],
@@ -207,6 +208,7 @@ tests = [
   [ 'cxl-elc.sh',             cxl_elc,            'cxl'   ],
   [ 'cxl-dax-hmem.sh',        cxl_dax_hmem,       'cxl'   ],
   [ 'cxl-region-replay.sh',   cxl_region_replay,  'cxl'   ],
+  [ 'cxl-dcd.sh',             cxl_dcd,            'cxl'   ],
 ]
 
 if get_option('destructive').enabled()
-- 
2.43.0

