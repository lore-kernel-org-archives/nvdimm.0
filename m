Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9E90FC8CE
	for <nvdimm@lists.linux.dev>; Sun, 15 Dec 2024 02:58:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.12
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734231536; cv=none; b=ks4YvfvZeLIdDfccv1Y2whlon2iRt7q8QaWvMh+6sJQjJyEWAplGaZ5tUGP/bQ9dHchihSl3d5VPaJgTt+Oqy8mDetQhxDa4SqT7LlrRVXL86ImOWOdAVQrmevDADfLrIlb2geisCN31ediP2w4JNNiG9ZmEeTl78P6ye9BYgMU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734231536; c=relaxed/simple;
	bh=WVidWGTjmWjDdbIW2Fn6txJR6NX0YCqXC+P4lMmVwps=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=DaR2ZFFdIAU4GfZWSoEIDOnOwd4/1qOzR4PDdtq3S21Huwk2Q5KnNZNchh5/xewPdlA21lRm56dXo/ssJnLpp85oVcgIOMuthkhitYqhS2CunIHVimqpNQlPjRbVdq+YtWreaeVWTWKC1akC+0TWg071sAoRah+oZrGeD2CLRNE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=XaXd8RQs; arc=none smtp.client-ip=198.175.65.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="XaXd8RQs"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1734231532; x=1765767532;
  h=from:date:subject:mime-version:content-transfer-encoding:
   message-id:references:in-reply-to:to:cc;
  bh=WVidWGTjmWjDdbIW2Fn6txJR6NX0YCqXC+P4lMmVwps=;
  b=XaXd8RQsJV7Hlsf35BTqTExV3fNQGcT+ZZKNAXxp8occHw4knVvYAdYT
   5i+26KWGF3kXEUPVY8DPzUk97PFVQHwAgXsXB4O56gFC/xkUOMcXck+Z6
   yHU+1IX5uYgwLBKbXzv2QbWyrxIGHHv43F58aH0UdZsivEC0qCg1Yxs74
   xRlC3S+iUvdvpvr5DHu997UQWctnLJFjgx/AooZALdBtYIyDkNhaKGYt7
   DsUFXpWp504YMCERkt2jUb7LjohvdV9BNiO+Fd75NqcIQXD9e0+lE8qEF
   bIJyMqaU7kzdscYpxYC7E+e/OTcFJV3llG6xO+1PjKjQvTLrr7sLISW+q
   A==;
X-CSE-ConnectionGUID: cWslvhkRRqqSKgyMbXIsdw==
X-CSE-MsgGUID: p+9qIewsQNiOYZzq6La1yQ==
X-IronPort-AV: E=McAfee;i="6700,10204,11278"; a="46039328"
X-IronPort-AV: E=Sophos;i="6.12,214,1728975600"; 
   d="scan'208";a="46039328"
Received: from fmviesa010.fm.intel.com ([10.60.135.150])
  by orvoesa104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Dec 2024 18:58:52 -0800
X-CSE-ConnectionGUID: kRO854DuSVyJu9B6jxdQCw==
X-CSE-MsgGUID: gc4kb/svRgOBR3YaoFRCGQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.12,235,1728975600"; 
   d="scan'208";a="97286790"
Received: from rchatre-mobl4.amr.corp.intel.com (HELO localhost) ([10.125.111.42])
  by fmviesa010-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Dec 2024 18:58:51 -0800
From: Ira Weiny <ira.weiny@intel.com>
Date: Sat, 14 Dec 2024 20:58:36 -0600
Subject: [ndctl PATCH v4 9/9] cxl/test: Add Dynamic Capacity tests
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20241214-dcd-region2-v4-9-36550a97f8e2@intel.com>
References: <20241214-dcd-region2-v4-0-36550a97f8e2@intel.com>
In-Reply-To: <20241214-dcd-region2-v4-0-36550a97f8e2@intel.com>
To: Alison Schofield <alison.schofield@intel.com>
Cc: Vishal Verma <vishal.l.verma@intel.com>, 
 Jonathan Cameron <jonathan.cameron@Huawei.com>, Fan Ni <fan.ni@samsung.com>, 
 Sushant1 Kumar <sushant1.kumar@intel.com>, 
 Dan Williams <dan.j.williams@intel.com>, Dave Jiang <dave.jiang@intel.com>, 
 linux-cxl@vger.kernel.org, nvdimm@lists.linux.dev, 
 Ira Weiny <ira.weiny@intel.com>
X-Mailer: b4 0.15-dev-2a633
X-Developer-Signature: v=1; a=ed25519-sha256; t=1734231510; l=29791;
 i=ira.weiny@intel.com; s=20221211; h=from:subject:message-id;
 bh=WVidWGTjmWjDdbIW2Fn6txJR6NX0YCqXC+P4lMmVwps=;
 b=LJMf4bl2CqT0WE9XQfzeSoKH25MA745HKLeQxiN3Og3R/t88ZAMWv1fB4pe0eWR/i4swzj0Al
 whquZI0Wno3B3U6MR1Ld1VB9oWaSZx+gEgc22vMXheHKv9KDy0lDij+
X-Developer-Key: i=ira.weiny@intel.com; a=ed25519;
 pk=noldbkG+Wp1qXRrrkfY1QJpDf7QsOEthbOT7vm0PqsE=

cxl_test provides a good way to ensure quick smoke and regression
testing.  The complexity of DCD and the new sparse DAX regions required
to use them benefits greatly with a series of smoke tests.

The only part of the kernel stack which must be bypassed is the actual
irq of DCD events.  However, the event processing itself can be tested
via cxl_test calling directly into the event processing.

In this way the rest of the stack; management of sparse regions, the
extent device lifetimes, and the dax device operations can be tested.

Add Dynamic Capacity Device tests for kernels which have DCD support.

Signed-off-by: Ira Weiny <ira.weiny@intel.com>

---
Changes:
[iweiny: Fix checks for dax devices]
[iweiny: Fix documentation on tests]
---
 test/cxl-dcd.sh  | 879 +++++++++++++++++++++++++++++++++++++++++++++++++++++++
 test/meson.build |   2 +
 2 files changed, 881 insertions(+)

diff --git a/test/cxl-dcd.sh b/test/cxl-dcd.sh
new file mode 100644
index 0000000000000000000000000000000000000000..193b71923b2f44142ab258e1d74b88361f6b7a5e
--- /dev/null
+++ b/test/cxl-dcd.sh
@@ -0,0 +1,879 @@
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
+# a test extent tag
+test_tag=dc-test-tag
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
+dc0_size=""
+dc1_size=""
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
+	mem="$1"
+	decoder="$2"
+	reg_size_string=""
+	if [ "$3" != "" ]; then
+		reg_size_string="-s $3"
+	fi
+
+	dcd_partition="dc0"
+	if [ "$4" != "" ]; then
+		dcd_partition="$4"
+	fi
+
+	# create region
+	rc=$($CXL create-region -t dc -M ${dcd_partition} -d "$decoder" -m "$mem" ${reg_size_string} | jq -r ".region")
+
+	if [[ ! $rc ]]; then
+		echo "create-region failed for $decoder / $mem"
+		err "$LINENO"
+	fi
+
+	echo ${rc}
+}
+
+check_region()
+{
+	search=$1
+	region_size=$2
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
+	search=$1
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
+	device="$1"
+	dpa="$2"
+	length="$3"
+	tag="$4"
+
+	more="0"
+	if [ "$5" != "" ]; then
+		more="1"
+	fi
+
+	echo ${dpa}:${length}:${tag}:${more} > "${dev_path}/${device}/dc_inject_extent"
+}
+
+remove_extent()
+{
+	device="$1"
+	dpa="$2"
+	length="$3"
+
+	echo ${dpa}:${length} > "${dev_path}/${device}/dc_del_extent"
+}
+
+create_dax_dev()
+{
+	reg="$1"
+
+	dax_dev=$($DAXCTL create-device -r $reg | jq -er '.[].chardev')
+
+	echo ${dax_dev}
+}
+
+fail_create_dax_dev()
+{
+	reg="$1"
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
+shrink_dax_dev()
+{
+	dev="$1"
+	new_size="$2"
+
+	$DAXCTL disable-device $dev
+	$DAXCTL reconfigure-device $dev -s $new_size
+	$DAXCTL enable-device $dev
+}
+
+destroy_dax_dev()
+{
+	dev="$1"
+
+	$DAXCTL disable-device $dev
+	$DAXCTL destroy-device $dev
+}
+
+check_dax_dev()
+{
+	search="$1"
+	size=$(($2))
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
+	reg="$1"
+	search="$2"
+	result=$($DAXCTL list -r $reg -D | jq -r '.[].chardev')
+	if [ "$result" == "$search" ]; then
+		echo "FAIL found $search"
+		err "$LINENO"
+	fi
+}
+
+check_extent()
+{
+	region=$1
+	offset=$(($2))
+	length=$(($3))
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
+	region=$1
+	count=$(($2))
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
+# by cxl-test being loaded
+test_pre_existing_extents()
+{
+	echo ""
+	echo "Test: pre-existing extent"
+	echo ""
+	region=$(create_dcd_region ${mem} ${decoder})
+
+	# | 2G non- |      DC region                                        |
+	# |  DC cap |                                                       |
+	# |  ...    |-------------------------------------------------------|
+	# |         |                   |----------|         |----------|   |
+	# |         |                   |(pre-ext) |         |(pre2-ext)|   |
+	check_region ${region} ${dc0_size}
+	# should contain pre-created extents
+	check_extent ${region} ${pre_ext_offset} ${pre_ext_length}
+	check_extent ${region} ${pre2_ext_offset} ${pre2_ext_length}
+
+	remove_extent ${device} $pre_ext_dpa $pre_ext_length
+	# |         |                                        |----------|   |
+	# |         |                                        |(pre2-ext)|   |
+	remove_extent ${device} $pre2_ext_dpa $pre2_ext_length
+	# |         |                                                       |
+	# |         |                                                       |
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
+	check_region ${region} ${dc0_size}
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
+	dax_dev=$(create_dax_dev ${region})
+	# |         |                   |----------|                        |
+	# |         |                   |(pre-ext) |                        |
+	# |         |                   | daxX.1   |                        |
+	check_extent_cnt ${region} 1
+	remove_extent ${device} $pre_ext_dpa $pre_ext_length
+	# In-use extents are not released.
+	check_dax_dev ${dax_dev} $pre_ext_length
+
+	check_extent_cnt ${region} 1
+	destroy_dax_dev ${dax_dev}
+	# |         |                   |----------|                        |
+	# |         |                   |(pre-ext) |                        |
+	check_not_dax_dev ${region} ${dax_dev}
+
+	check_extent_cnt ${region} 1
+	# Remove after use
+	remove_extent ${device} $pre_ext_dpa $pre_ext_length
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
+	remove_extent ${device} $base_ext_dpa $base_ext_length
+	check_extent_cnt ${region} 2
+	remove_extent ${device} $pre_ext_dpa $pre_ext_length
+	check_extent_cnt ${region} 2
+}
+
+test_create_dax_dev_spanning_two_extents()
+{
+	echo ""
+	echo "Test: Create dax device spanning 2 extents"
+	echo ""
+
+	region=$(create_dcd_region ${mem} ${decoder})
+	check_region ${region} ${dc0_size}
+	# | 2G non- |      DC region                                        |
+	# |  DC cap |                                                       |
+	# |  ...    |-------------------------------------------------------|
+	inject_extent ${device} $pre_ext_dpa $pre_ext_length ""
+	check_extent ${region} ${pre_ext_offset} ${pre_ext_length}
+	# |         |                   |----------|                        |
+	# |         |                   |(pre-ext) |                        |
+	inject_extent ${device} $base_ext_dpa $base_ext_length ""
+	check_extent ${region} ${base_ext_offset} ${base_ext_length}
+	# |         |--------|          |----------|                        |
+	# |         | (base) |          |(pre-ext) |                        |
+
+	check_extent_cnt ${region} 2
+	dax_dev=$(create_dax_dev ${region})
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
+	# In-use extents were not released.  Check they can be removed after the
+	# dax device is removed.
+	check_extent_cnt ${region} 2
+	remove_extent ${device} $base_ext_dpa $base_ext_length
+	remove_extent ${device} $pre_ext_dpa $pre_ext_length
+	check_extent_cnt ${region} 0
+	destroy_region ${region}
+	check_not_region ${region}
+}
+
+test_inject_tag_support()
+{
+	echo ""
+	echo "Test: inject without/with tag"
+	echo ""
+
+	region=$(create_dcd_region ${mem} ${decoder})
+	check_region ${region} ${dc0_size}
+
+	inject_extent ${device} $pre_ext_dpa $pre_ext_length ""
+	check_extent ${region} ${pre_ext_offset} ${pre_ext_length}
+	inject_extent ${device} $base_ext_dpa $base_ext_length "ira"
+
+	# extent with tag should be rejected
+	check_extent_cnt ${region} 1
+	remove_extent ${device} $pre_ext_dpa $pre_ext_length
+	check_extent_cnt ${region} 0
+
+	destroy_region ${region}
+	check_not_region ${region}
+}
+
+test_partial_extent_remove ()
+{
+	echo ""
+	echo "Test: partial extent remove"
+	echo ""
+
+	region=$(create_dcd_region ${mem} ${decoder})
+	check_region ${region} ${dc0_size}
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
+	dax_dev=$(create_dax_dev ${region})
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
+	remove_extent ${device} $partial_ext_dpa $partial_ext_length
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
+	# Partial results in whole extent removal
+	check_extent_cnt ${region} 1
+	remove_extent ${device} $partial_ext_dpa $partial_ext_length
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
+	# Test multiple extent remove
+	echo ""
+	echo "Test: multiple extent remove with single extent remove command"
+	echo ""
+
+	region=$(create_dcd_region ${mem} ${decoder})
+	check_region ${region} ${dc0_size}
+
+	# | 2G non- |      DC region                                        |
+	# |  DC cap |                                                       |
+	# |  ...    |-------------------------------------------------------|
+
+	inject_extent ${device} $pre_ext_dpa $pre_ext_length ""
+	inject_extent ${device} $base_ext_dpa $base_ext_length ""
+	# |  ...    |-------------------------------------------------------|
+	# |         |--------|          |-------------------|               |
+	# |         | (base) |          | (pre)-existing    |               |
+
+	check_extent_cnt ${region} 2
+	dax_dev=$(create_dax_dev ${region})
+
+	# |  ...    |-------------------------------------------------------|
+	# |         |--------|          |-------------------|               |
+	# |         | (base) |          | (pre)-existing    |               |
+	# |         | daxX.1 |          | daxX.1            |               |
+
+	partial_ext_dpa="$(($base_ext_dpa + ($base_ext_length / 2)))"
+	partial_ext_length="$(($pre_ext_dpa - $base_ext_dpa))"
+	echo "Removing multiple in span : $partial_ext_dpa $partial_ext_length"
+	#                |------------------|
+	#                  Partial
+	remove_extent ${device} $partial_ext_dpa $partial_ext_length
+
+	# |  ...    |-------------------------------------------------------|
+	# |         |--------|          |-------------------|               |
+	# |         | (base) |          | (pre)-existing    |               |
+	# |         | daxX.1 |          | daxX.1            |               |
+
+	# In-use extents are not released.
+	check_extent_cnt ${region} 2
+
+	destroy_dax_dev ${dax_dev}
+	check_not_dax_dev ${region} ${dax_dev}
+
+	# |  ...    |-------------------------------------------------------|
+	# |         |--------|          |-------------------|               |
+	# |         | (base) |          | (pre)-existing    |               |
+
+	# Remove both extents
+	check_extent_cnt ${region} 2
+	#                |------------------|
+	#                  Partial
+	remove_extent ${device} $partial_ext_dpa $partial_ext_length
+	# |  ...    |-------------------------------------------------------|
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
+	check_region ${region} ${dc0_size}
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
+	check_region ${region} ${dc0_size}
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
+	dax_dev=$(create_dax_dev ${region})
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
+	check_region ${region} ${dc0_size}
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
+	check_region ${region} ${dc0_size}
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
+	dax_dev=$(create_dax_dev ${region})
+	check_dax_dev ${dax_dev} $pre_ext_length
+	fail_create_dax_dev ${region}
+
+	echo ""
+	echo "Test: Resize sparse dax device"
+	echo ""
+
+	# Shrink
+	# |         |                   | daxX.1  |                         |
+	resize_ext_length=$(($pre_ext_length / 2))
+	shrink_dax_dev ${dax_dev} $resize_ext_length
+	check_dax_dev ${dax_dev} $resize_ext_length
+
+	# Fill
+	# |         |                   | daxX.1  | daxX.2  |               |
+	dax_dev=$(create_dax_dev ${region})
+	check_dax_dev ${dax_dev} $resize_ext_length
+	destroy_region ${region}
+	check_not_region ${region}
+
+
+	# 2 extent
+	# create dax dev
+	# resize into 1st extent
+	# create dev on rest of 1st and all of second
+	# Ensure both devices are correct
+
+	echo ""
+	echo "Test: Resize sparse dax device across extents"
+	echo ""
+	region=$(create_dcd_region ${mem} ${decoder})
+	check_region ${region} ${dc0_size}
+	inject_extent ${device} $pre_ext_dpa $pre_ext_length ""
+	inject_extent ${device} $base_ext_dpa $base_ext_length ""
+
+	# | 2G non- |      DC region                                        |
+	# |  DC cap |                                                       |
+	# |  ...    |-------------------------------------------------------|
+	# |         |--------|          |-------------------|               |
+	# |         | (base) |          | (pre)-existing    |               |
+
+	check_extent_cnt ${region} 2
+	dax_dev=$(create_dax_dev ${region})
+	ext_sum_length="$(($base_ext_length + $pre_ext_length))"
+
+	# |         | daxX.1 |          |  daxX.1           |               |
+
+	check_dax_dev ${dax_dev} $ext_sum_length
+	resize_ext_length=33554432 # 32MB
+
+	# |         | D1 |                                                  |
+
+	shrink_dax_dev ${dax_dev} $resize_ext_length
+	check_dax_dev ${dax_dev} $resize_ext_length
+
+	# |         | D1 | D2|          | daxX.2            |               |
+
+	dax_dev=$(create_dax_dev ${region})
+	remainder_length=$((ext_sum_length - $resize_ext_length))
+	check_dax_dev ${dax_dev} $remainder_length
+
+	# |         | D1 | D2|          | daxX.2 |                          |
+
+	remainder_length=$((remainder_length / 2))
+	shrink_dax_dev ${dax_dev} $remainder_length
+	check_dax_dev ${dax_dev} $remainder_length
+
+	# |         | D1 | D2|          | daxX.2 |  daxX.3  |               |
+
+	dax_dev=$(create_dax_dev ${region})
+	check_dax_dev ${dax_dev} $remainder_length
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
+	check_region ${region} ${dc0_size}
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
+	# Attempt overlapping extent
+	#
+	# |         |          |-----------------|                          |
+	# |         |          | overlapping     |                          |
+
+	partial_ext_dpa="$(($base_ext_dpa + ($pre_ext_dpa / 2)))"
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
+	region_size=$(($dc1_size / 2))
+	region=$(create_dcd_region ${mem} ${decoder_dc1} ${region_size} dc1)
+	check_region ${region} ${region_size}
+	
+	region_two=$(create_dcd_region ${mem} ${decoder_dc1} ${region_size} dc1)
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
+	check_region ${region} ${dc0_size}
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
+	check_region ${region} ${dc0_size}
+	inject_extent ${device} $pre_ext_dpa $pre_ext_length ""
+	check_extent ${region} ${pre_ext_offset} ${pre_ext_length}
+	dax_dev=$(create_dax_dev ${region})
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
+	check_region ${region} ${dc0_size}
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
+	remove_extent ${device} $base_ext_dpa $base_ext_length
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
+readarray -t memdevs < <("$CXL" list -b cxl_test -Mi | jq -r '.[].memdev')
+
+for mem in ${memdevs[@]}; do
+	dc0_size=$($CXL list -m $mem | jq -r '.[].dc0_size')
+	if [ "$dc0_size" == "null" ]; then
+		continue
+	fi
+	dc1_size=$($CXL list -m $mem | jq -r '.[].dc1_size')
+	if [ "$dc1_size" == "null" ]; then
+		continue
+	fi
+	decoder=$($CXL list -b cxl_test -D -d root -m "$mem" |
+		  jq -r ".[] |
+		  select(.dc0_capable == true) |
+		  select(.nr_targets == 1) |
+		  select(.max_available_extent >= ${dc0_size}) |
+		  .decoder")
+	decoder_dc1=$($CXL list -b cxl_test -D -d root -m "$mem" |
+		  jq -r ".[] |
+		  select(.dc1_capable == true) |
+		  select(.nr_targets == 1) |
+		  select(.max_available_extent >= ${dc1_size}) |
+		  .decoder")
+	if [[ $decoder ]]; then
+		bus=`"$CXL" list -b cxl_test -m ${mem} | jq -r '.[].bus'`
+		device=$($CXL list -m $mem | jq -r '.[].host')
+		break
+	fi
+done
+
+echo "TEST: DCD test device bus:${bus} decoder:${decoder} mem:${mem} device:${device} size:${dc0_size}"
+
+if [ "$decoder" == "" ] || [ "$device" == "" ] || [ "$dc0_size" == "" ]; then
+	echo "No mem device/decoder found with DCD support"
+	exit 77
+fi
+
+if [ "$decoder_dc1" == "" ]; then
+	echo "insufficient DC capability for ${mem}/${device}"
+	exit 77
+fi              
+
+# testing pre existing extents must be called first as the extents were created
+# by cxl-test being loaded
+test_pre_existing_extents
+test_remove_extent_under_dax_device
+test_create_dax_dev_spanning_two_extents
+test_inject_tag_support
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
index d871e28e17ce512cd1e7b43f3ec081729fe5e03a..1cfcb60d16e05272893ae1c67820aa8614281505 100644
--- a/test/meson.build
+++ b/test/meson.build
@@ -161,6 +161,7 @@ cxl_sanitize = find_program('cxl-sanitize.sh')
 cxl_destroy_region = find_program('cxl-destroy-region.sh')
 cxl_qos_class = find_program('cxl-qos-class.sh')
 cxl_poison = find_program('cxl-poison.sh')
+cxl_dcd = find_program('cxl-dcd.sh')
 
 tests = [
   [ 'libndctl',               libndctl,		  'ndctl' ],
@@ -194,6 +195,7 @@ tests = [
   [ 'cxl-destroy-region.sh',  cxl_destroy_region, 'cxl'   ],
   [ 'cxl-qos-class.sh',       cxl_qos_class,      'cxl'   ],
   [ 'cxl-poison.sh',          cxl_poison,         'cxl'   ],
+  [ 'cxl-dcd.sh',             cxl_dcd,            'cxl'   ],
 ]
 
 if get_option('destructive').enabled()

-- 
2.47.1

