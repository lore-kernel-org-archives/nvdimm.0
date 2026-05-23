Received: from mail-dy1-f176.google.com (mail-dy1-f176.google.com [74.125.82.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CE9873876A7
	for <nvdimm@lists.linux.dev>; Sat, 23 May 2026 09:51:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.82.176
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779529869; cv=none; b=fX41FDjKqXv4+gD4qvaungyMsjYzBOqBfFqXCV0UuYcvJMh06ZVOMbKhZlX7GGGIp7HSSEMEg2PSOaoRWnHUtIUgEbAiZan8itQK5ut9tBhjHznU4tA3+XDHXuc98GqNsqYNDGAH5u4CtOU3jyGWLJbQ0HWKCGwnITHi63M2Bm8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779529869; c=relaxed/simple;
	bh=sdRkaHCB03vaOA2sJnI91pG8lTEcl/5DxhW92R2t1kQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=rDw34VfHYOWdkFfItvQjf4Ie3M22QEUFNQYRgXxQwVnQe+ImrTIsiU172EjK8/Weskv6vJV/FvCxXEmKM0YWD1rkZP34g/1OWR2bpQx6086fI/9M5ZDGfIlpM6EImjz1Tv/PgGtW0BIw3BBce7Hj8hHib4FLHmfe2gGJ+B2/UlA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=cF1RAnl2; arc=none smtp.client-ip=74.125.82.176
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="cF1RAnl2"
Received: by mail-dy1-f176.google.com with SMTP id 5a478bee46e88-2f0ad52830cso10490884eec.1
        for <nvdimm@lists.linux.dev>; Sat, 23 May 2026 02:51:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1779529866; x=1780134666; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=7VLaluY8scEiXnZdd1JX4/Ij7yj9hQ+djAZAcaJnqlw=;
        b=cF1RAnl2nsgiCBgM5dfmtF1dS0DqMNZErM2KP0BYXTOX9YkE92gdo8AYvfJTGiAQl7
         syU03h/xprZVH5YfJBxAj4x26+zSn54fCw46ZS2Icx/x8VyDiDM6hjcba7jhZaa2x6Ge
         iWWwAiX0H9/1g65AxAvEcyPQ+nsCqbeuO+01siIw0mwNEhh+2m5NiXzLwKkx/s3FFQ1m
         k4y3if+483t5nk7pcD5MxfAwCvUkyj2NcuFdf0ZzXwtpDkOcApyg4C8cVsusfcmrUsbP
         YCPnWHQG+YUcyStUp21EIyu7ymyHq/ZWE2OuVAsDFuWOWix2HgveMZqko968Vs85UYW5
         06Gg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1779529866; x=1780134666;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=7VLaluY8scEiXnZdd1JX4/Ij7yj9hQ+djAZAcaJnqlw=;
        b=jUDZnkYsktWW8brpW1KV+Ae/Bd9lFZTvI9g4wAG8cXmkqfVKzC1td2QJ0MZKxP26XO
         NTxpTlMIWPxWgZTYIlTdoajG8IXrM4j0ZuoTnt+/6Wh1B9kMI6nJhJbMukjBw4WoxAno
         hq3Mse9chkMfarbRezws7TEqzsdnDm1wAU7A46nyvN/TESutQw60Kk6kPciPLYPKhEIy
         /Rfovb/ExvISgo40xGEucse5CG25Sqp2Jg8jUQQZpxIeRNN8i3goTjYUiNCAJmIKqKQk
         HtZL+17cyn16hFKUs2xSyiSbgDz2JVw/jhck46WAK3TAmAapuR0+A+gDzqh0Zt5wo5j8
         eW1g==
X-Gm-Message-State: AOJu0YzOqR27k+1Y6waEff7Bb2RmL+ELjuQWUmot/OW8/3Z7ZmD2+M0L
	JzQUy4+nbTrfixGJoe7E7rB7swt78TW3Vhatmph7FLnCfp5M+S/hUGJP
X-Gm-Gg: Acq92OFBfJWXiow3jGhShuXN8rmX2PmvnyboGRkiv72T3a6apAext9hzK4QAbp0eM00
	OVgsWq08VeqVi7+C8S/wl+vCeZ3xDC0z3hw4puYZT8AQ8y+T51/7oB6PUxVs1b6vHktHSypsnZJ
	AL3PuRKvBgQVDmbGYeVmnJ99BBRgHXoB8ozw+tGhK5VQwLZG+d5uDYWJNZHCpayBp0lrGnzrIK1
	pukZxDOKuHSckcT325D5BcjXnx2lsUb7ZdtVzojj60Ay8h9bq0xPhZLkJar3dLRPYVzBuvhe272
	66CZbTzeohI6Yh2dJWFBNoDacwp1EwD5mSsj4AMMWa1KV20GUAj8P9eGmKo3l26u6J3tN2ef+2S
	RuqaS5ghORheorQliSXgyRE117XfFN2dta2OzW9foeUTwAPrt7EejJI4sxFSYfNpn/6ILlggboh
	eH6RfXxdtqhJfjWzFWkiyflKvmoH7vQSiQNDCL323s/QVEFHwxt11Yp2sJy7ci29x06VkhwijF3
	LRwwUscZfhGa/6e/w==
X-Received: by 2002:a05:7300:cd99:b0:2e2:4979:ec7 with SMTP id 5a478bee46e88-3044908e3demr3423323eec.10.1779529865795;
        Sat, 23 May 2026 02:51:05 -0700 (PDT)
Received: from AnisaLaptop.localdomain (c-73-170-217-179.hsd1.ca.comcast.net. [73.170.217.179])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-3045225b7b6sm4595756eec.25.2026.05.23.02.51.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 23 May 2026 02:51:03 -0700 (PDT)
From: Anisa Su <anisa.su887@gmail.com>
X-Google-Original-From: Anisa Su <anisa.su@samsung.com>
To: linux-cxl@vger.kernel.org,
	linux-kernel@vger.kernel.org
Cc: nvdimm@lists.linux.dev,
	Dan Williams <djbw@kernel.org>,
	Jonathan Cameron <jic23@kernel.org>,
	Davidlohr Bueso <dave@stgolabs.net>,
	Dave Jiang <dave.jiang@intel.com>,
	Ira Weiny <iweiny@kernel.org>,
	Alison Schofield <alison.schofield@intel.com>,
	John Groves <John@Groves.net>,
	Gregory Price <gourry@gourry.net>,
	Ira Weiny <ira.weiny@intel.com>,
	Anisa Su <anisa.su887@gmail.com>
Subject: [PATCH v6 7/7] cxl/test: Add Dynamic Capacity tests
Date: Sat, 23 May 2026 02:50:42 -0700
Message-ID: <20260523095043.471098-8-anisa.su@samsung.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260523095043.471098-1-anisa.su@samsung.com>
References: <20260523095043.471098-1-anisa.su@samsung.com>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Ira Weiny <ira.weiny@intel.com>

cxl_test provides a good way to ensure quick smoke and regression
testing.  The complexity of DCD and the new sparse DAX regions
required to use them benefits greatly with a series of smoke tests.

The only part of the kernel stack which must be bypassed is the actual
irq of DCD events.  However, the event processing itself can be tested
via cxl_test calling directly into the event processing.

In this way the rest of the stack; management of sparse regions, the
extent device lifetimes, and the dax device operations can be tested.

Add Dynamic Capacity Device tests for kernels which have DCD support.

Signed-off-by: Ira Weiny <ira.weiny@intel.com>
Signed-off-by: Anisa Su <anisa.su887@gmail.com>

---
Changes:
[anisa: align tests with kernel DCD redesign + add sharable coverage]

Rewrite tests against the post-redesign kernel (uuid sysfs claim,
sparse size-grow rejection, tag-group atomic release, cross-More
uniqueness):

  - Use real UUID strings; route untagged claims via --uuid "0" so
    daxctl exercises the kernel uuid_store path end to end.
  - Pre-existing-extent test handles the tagged pre2_ext (deadbeef)
    separately from the untagged pre_ext.
  - Spanning / aggregation tests drive both extents in one More-chain:
    cross-event tagged adds are dropped by the cross-More uniqueness
    gate, and untagged events become independent dax_resources so
    only one is claimed per --uuid "0".
  - test_dax_device_ops asserts that sparse size grow returns
    -EOPNOTSUPP after a shrink (real grow path is --uuid only).
  - test_reject_overlapping math now produces an actual overlap
    inside the DC region (the prior arithmetic landed past the end).

Add coverage for new validators:
  - test_uuid_no_match / test_uuid_no_match_seed_intact
  - test_uuid_show (reads back the dax-dev uuid sysfs attribute)
  - test_cross_more_uniqueness (rejects tag reuse across More-chains)
  - test_alignment_rejection (rejects misaligned extents)

Sharable-partition coverage (test_shared_extent_inject,
test_seq_integrity_gap) is routed at runtime to a dedicated mock
memdev that tools/testing/cxl stamps with serial 0xDCDC; the script
enumerates both regimes from one cxl_test module load.

Localize positional-arg assignments in every helper so functions
no longer clobber caller globals (the previous behavior leaked
the sharable memdev into later tests).

Update inject_extent to optionally pass shared_extn_seq (5th arg)
and remove_extent to carry the tag (now required by the mock's
delete sysfs).  Add inject_shared_extent for dc_inject_shared_extent.
---
 test/cxl-dcd.sh  | 1267 ++++++++++++++++++++++++++++++++++++++++++++++
 test/meson.build |    2 +
 2 files changed, 1269 insertions(+)
 create mode 100644 test/cxl-dcd.sh

diff --git a/test/cxl-dcd.sh b/test/cxl-dcd.sh
new file mode 100644
index 0000000..3194b00
--- /dev/null
+++ b/test/cxl-dcd.sh
@@ -0,0 +1,1267 @@
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
+	region=$($CXL create-region -t dynamic_ram_a -d "$decoder" -m "$mem" ${reg_size_string} | jq -r ".region")
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
+# Read /sys/bus/dax/devices/<dax>/uuid and compare to $expected.  "0"
+# matches the null UUID (kernel emits "0\n" when the resource is empty,
+# untagged, or non-DCD).
+check_dax_uuid()
+{
+	local dax_dev="$1"
+	local expected="$2"
+	local uuid_path got want
+
+	uuid_path="/sys/bus/dax/devices/${dax_dev}/uuid"
+	if [ ! -e "$uuid_path" ]; then
+		echo "FAIL no uuid attribute at $uuid_path"
+		err "$LINENO"
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
+# device-stamped seq 1..2.  Uses the sharable memdev (serial 0xDCDC).
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
+		"$test_tag_b" 1 1
+	check_extent_cnt ${region} 0
+	inject_shared_extent ${sharable_device} $pre_ext_dpa $pre_ext_length \
+		"$test_tag_b" "" 2
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
+# Sharable extents must arrive with a dense 1..n shared_extn_seq.  A gap
+# (1, 3) lets the cxl side accept the extents but uuid_claim_tagged
+# refuses the group on its density check.  Uses the sharable memdev.
+test_seq_integrity_gap()
+{
+	echo ""
+	echo "Test: sharable extents with seq gap (1,3) refused on claim"
+	echo ""
+
+	region=$(create_dcd_region ${sharable_mem} ${sharable_decoder})
+	check_region ${region} ${sharable_dra_size}
+
+	inject_shared_extent ${sharable_device} $base_ext_dpa $base_ext_length \
+		"$test_tag_b" 1 1
+	check_extent_cnt ${region} 0
+	inject_shared_extent ${sharable_device} $pre_ext_dpa $pre_ext_length \
+		"$test_tag_b" "" 3
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
+	cand_dra=$($CXL list -m $cand | jq -r '.[].dynamic_ram_a_size')
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
index e0e2193..cd06bf8 100644
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

