Received: from mail-qk1-f171.google.com (mail-qk1-f171.google.com [209.85.222.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 98F82340409
	for <nvdimm@lists.linux.dev>; Sun, 12 Jul 2026 15:45:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.222.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783871142; cv=none; b=tlAFZYFJpjtaW6o8LnwdbfR6HyYqiUjXwoMvnT/DxMUyH3KhOxMMydQzTcw8GdGoIY70OzPkuJIsmhaF75mxfq2JWoyiYVjzgNBkWUw50lEw6oRUixpP33P9Uza+WPFD1C/j/2IV9C1V6x8c4g6wgF+dRs+RF9trFCNc/rtiIAM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783871142; c=relaxed/simple;
	bh=bvQ4EvDbEBqAAEtU5XYus1Sl58WVn2Gk3au/GBtyWWc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cycGPRdV/k/VoQjSzOWp7q/jJXx4SxlkSSJq62XUSuYGtANaQFI1JOJgA/q8CFH4oV+kMSxF6gNG4Pn+THPi6jCvK2dHx23CjnkY4XVrVhjXhGnVq8SvFlgXwdW3VuBifJDp0j3ihzzDmDM0YgGW/gdGB+2wdJUgtLSOwpKeTtw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=gourry.net; spf=pass smtp.mailfrom=gourry.net; dkim=pass (2048-bit key) header.d=gourry.net header.i=@gourry.net header.b=AzsF3woq; arc=none smtp.client-ip=209.85.222.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=gourry.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gourry.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gourry.net header.i=@gourry.net header.b="AzsF3woq"
Received: by mail-qk1-f171.google.com with SMTP id af79cd13be357-92e533aacf2so116717785a.2
        for <nvdimm@lists.linux.dev>; Sun, 12 Jul 2026 08:45:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gourry.net; s=google; t=1783871133; x=1784475933; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=GWF9xBC1APjhYOxCXyaTAZR/yxpjvhh1p47cJ5nUxEw=;
        b=AzsF3woqlMWrpjnwQZnJvwjKcAVtIWCsjOsTHFRN30R94rinCCQTUcre6J7O307Fgo
         TCi+d1+Fa56uaLqEhziZWTisZSbhZvq4o7hHwtT695z4udGtm6LLbw3FJMmdmMdM5kIM
         WTorfLH7I9+DL3W4p/484K0TeeMPRoe3A5i443vrErK5wcdyZuM+SU7KOnlDLy8mNbQu
         nAp14uwkshUtz6s8VH9SI3/I5AfcqV6WWqPuhkLFUL4p09PByR+fM0EM1Z1Y7wrBmEc1
         Tr+vTL9shKKj/xJv5RlO1FFSgxg83Vu8gscRPxQWdKfr85deCBdfvVN5DCWrdNWoHh6d
         d69g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1783871133; x=1784475933;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=GWF9xBC1APjhYOxCXyaTAZR/yxpjvhh1p47cJ5nUxEw=;
        b=YArq6TwBBlaY36VP8XGTZ5HhKf4ZnwaWDoQHntp7nQTcKg0UWQuU4ogcnryOdHEFj3
         lCSS5kgekoxMYdJLr+Vtjmn3Mz5a+2MpZ8N8sptTjspJmUBj/dpPPGNkR7AqI5PRMzf7
         Q8O9y1JREG8UHDafsFunJyz3kOhpSRsVHqm0tnpeAonNXIdGvpwT2h5dEexEWZvY5BWd
         VmKnR5l8BmII6nxRIkJq8XkCl9Cap3hDsw4inr6oc9DDg1D37zkLKRJlAIiOsqkUpiWh
         FoWaCckG9os7bvgA8qbfjk8c3ecyzNVtjPauG2PeT4JvQW0ASuAWJAWEqWmtxdweeGWW
         B5DA==
X-Forwarded-Encrypted: i=1; AHgh+Rrw1lTxbtIso4SofnnD9IyoHgZGSkx9FmiC1Qspxm2GbrLhwsnXgzIXy6zu/bBcBN7JQTnKht8=@lists.linux.dev
X-Gm-Message-State: AOJu0YwdejeNiGHbmGoB+vrbV3Rw8WjLwEN8X/RVSu+5VcK+ujOtIyay
	Rc99ZICzroupf1OQ72wBe9kg0ZVCGD/u+WZHChwocP3JKxqqSn7vulMlb0Zep2dFBfo=
X-Gm-Gg: AfdE7cmPMlD42s66H0n/pPHBB8Lh0I/XdcmuwCM+IGrZqMLusmnJBCqD3oXV2S8ie/K
	LtBeKftL5qFjeX0CRW6hGRmSVPb0S8WiqLEH8wzzqZCxDZgza/8aSfAgbyQ92R7iM5h4nJzgI3B
	wVntBnhf9iEp6+92Bvl9NRZGjujDhNGgXrMr0q4JEQYZiu+CsJ9uWcJ1E5KTxqUl9GmL3HkINmr
	K42o556Xrn51BErLdImqHi99vwTlTHseXy/yqNNRsKLVdSgaLqT9f0zK4+KUvj02HUSh2CbTIOd
	lQXpxX3tnNWwM+KN/+Kcu5uOwZbl4bkcw3UBqRl2KwjT9bR8qaDZwJZ7uC80ZmsMoMVqbQzqT/n
	Mz8dz+lJjsI86sD0ODc1obgxfLi2tMmdO5PD7Tk4dHAqHRu2ICh6ipfqI0SXn4jfKhLnoTKOGZP
	IojhNJ3FGBy1Q9iroaktCAUyBrnx2REQpqgOXdXNu9POmZ1wlva3FHdQUBRPR7c0DLNT1e7nIGU
	w==
X-Received: by 2002:a05:620a:469f:b0:92e:6a8d:38aa with SMTP id af79cd13be357-92ef2d1dedfmr623795785a.63.1783871133247;
        Sun, 12 Jul 2026 08:45:33 -0700 (PDT)
Received: from gourry-fedora-PF4VCD3F.lan (pool-173-79-60-52.washdc.fios.verizon.net. [173.79.60.52])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-92ee5d61facsm862186485a.42.2026.07.12.08.45.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 12 Jul 2026 08:45:32 -0700 (PDT)
From: Gregory Price <gourry@gourry.net>
To: linux-mm@kvack.org
Cc: linux-kernel@vger.kernel.org,
	linux-cxl@vger.kernel.org,
	driver-core@lists.linux.dev,
	nvdimm@lists.linux.dev,
	linux-kselftest@vger.kernel.org,
	kernel-team@meta.com,
	david@kernel.org,
	osalvador@suse.de,
	gregkh@linuxfoundation.org,
	rafael@kernel.org,
	dakr@kernel.org,
	djbw@kernel.org,
	vishal.l.verma@intel.com,
	dave.jiang@intel.com,
	alison.schofield@intel.com,
	akpm@linux-foundation.org,
	ljs@kernel.org,
	liam@infradead.org,
	vbabka@kernel.org,
	rppt@kernel.org,
	surenb@google.com,
	mhocko@suse.com,
	shuah@kernel.org,
	gourry@gourry.net
Subject: [PATCH v7 10/10] selftests/dax: add dax/kmem hotplug sysfs regression test
Date: Sun, 12 Jul 2026 11:45:04 -0400
Message-ID: <20260712154505.3564379-11-gourry@gourry.net>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260712154505.3564379-1-gourry@gourry.net>
References: <20260712154505.3564379-1-gourry@gourry.net>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Add a kselftest for the dax/kmem whole-device "state" sysfs attribute
(/sys/bus/dax/devices/daxX.Y/state), which transitions a kmem-backed
dax device between "unplugged", "online" and "online_movable".

The kselftest also includes a test to demonstrate the force-unbind
does not deadlock - but this is destructive (the dax device can never
be rebound), so it only runs when DAX_KMEM_TEST_UNBIND=1 is set.

Provisioning a devdax device and binding it to kmem needs daxctl/ndctl
out of scope for an in-tree selftest.  As the test mutates a device's
memory, the operator opts in by naming it in DAX_KMEM_TEST_DEV (or
"auto" to pick the first kmem-bound device); it SKIPs when unset, when
no device is present, or when the memory cannot be freed to a baseline.

When a device is available it validates the interface contract:
  - online / online_movable actually add memory (MemTotal grows),
  - online is idempotent,
  - switching between online types without unplug is rejected,
  - unplug removes memory and the reported state is "unplugged"
  - invalid input is rejected,
  - unplug and unbind tolerate blocks toggled out-of-band through the
    per-block memoryX/state interface.

One specific regression test:
    online -> unplug -> online_movable -> unplug

Re-online must re-reserve per-range resources so subsequent unplug
actually offlines and removes instead of silently reporting success
while the memory stays online.

Signed-off-by: Gregory Price <gourry@gourry.net>
---
 tools/testing/selftests/Makefile              |   1 +
 tools/testing/selftests/dax/Makefile          |   6 +
 tools/testing/selftests/dax/config            |   4 +
 .../testing/selftests/dax/dax-kmem-hotplug.sh | 317 ++++++++++++++++++
 tools/testing/selftests/dax/settings          |   1 +
 5 files changed, 329 insertions(+)
 create mode 100644 tools/testing/selftests/dax/Makefile
 create mode 100644 tools/testing/selftests/dax/config
 create mode 100755 tools/testing/selftests/dax/dax-kmem-hotplug.sh
 create mode 100644 tools/testing/selftests/dax/settings

diff --git a/tools/testing/selftests/Makefile b/tools/testing/selftests/Makefile
index 8d4db2241cc2a..5528682a3a912 100644
--- a/tools/testing/selftests/Makefile
+++ b/tools/testing/selftests/Makefile
@@ -14,6 +14,7 @@ TARGETS += core
 TARGETS += cpufreq
 TARGETS += cpu-hotplug
 TARGETS += damon
+TARGETS += dax
 TARGETS += devices/error_logs
 TARGETS += devices/probe
 TARGETS += dmabuf-heaps
diff --git a/tools/testing/selftests/dax/Makefile b/tools/testing/selftests/dax/Makefile
new file mode 100644
index 0000000000000..25a4f3d73a5ba
--- /dev/null
+++ b/tools/testing/selftests/dax/Makefile
@@ -0,0 +1,6 @@
+# SPDX-License-Identifier: GPL-2.0
+all:
+
+TEST_PROGS := dax-kmem-hotplug.sh
+
+include ../lib.mk
diff --git a/tools/testing/selftests/dax/config b/tools/testing/selftests/dax/config
new file mode 100644
index 0000000000000..4c9aaeb6ceb41
--- /dev/null
+++ b/tools/testing/selftests/dax/config
@@ -0,0 +1,4 @@
+CONFIG_DEV_DAX=m
+CONFIG_DEV_DAX_KMEM=m
+CONFIG_MEMORY_HOTPLUG=y
+CONFIG_MEMORY_HOTREMOVE=y
diff --git a/tools/testing/selftests/dax/dax-kmem-hotplug.sh b/tools/testing/selftests/dax/dax-kmem-hotplug.sh
new file mode 100755
index 0000000000000..9299120ee509c
--- /dev/null
+++ b/tools/testing/selftests/dax/dax-kmem-hotplug.sh
@@ -0,0 +1,317 @@
+#!/bin/bash
+# SPDX-License-Identifier: GPL-2.0
+#
+# Exercise the dax/kmem "state" sysfs attribute:
+#   /sys/bus/dax/devices/daxX.Y/state  ->  unplugged | online | online_kernel | online_movable
+#
+# The test needs a dax device already bound to the kmem driver.
+#
+# This test mutates a device's memory: online/offline cycles migrate any
+# in-use pages, and the optional unbind subtest wedges the device until
+# reboot. The tester must identify the target device and opt into the
+# destructive unbind tests.
+#
+#   DAX_KMEM_TEST_DEV=daxX.Y   test this specific device
+#   DAX_KMEM_TEST_DEV=auto     auto-discover the first kmem-bound dax device
+#                              (best-effort: it may be a device in use!)
+#   DAX_KMEM_TEST_UNBIND=1     also run the destructive unbind-while-online test
+#
+# If DAX_KMEM_TEST_DEV is unset the whole test SKIPs.
+#
+# A dax device can be provisioned with the memmap= boot param, e.g.:
+#   memmap=2G!4G
+#
+# then, in the booted system:
+#
+#   ndctl create-namespace -m devdax -e namespace0.0 -f
+#   daxctl reconfigure-device -N -m system-ram dax0.0   # bind kmem
+#   DAX_KMEM_TEST_DEV=auto ./dax-kmem-hotplug.sh
+
+# shellcheck disable=SC1091
+DIR="$(dirname "$(readlink -f "$0")")"
+. "$DIR"/../kselftest/ktap_helpers.sh
+
+DAX_BASE=/sys/bus/dax/devices
+MEM_BASE=/sys/devices/system/memory
+
+memtotal_kb() { awk '/^MemTotal:/ {print $2}' /proc/meminfo; }
+get_state() { cat "$HP" 2>/dev/null; }
+# set_state STATE -- write a state to the state attribute; returns the
+# write's exit status (0 = accepted by the kernel)
+set_state() { echo "$1" > "$HP" 2>/dev/null; }
+
+is_kmem_dax() {
+	local drv
+	[ -e "$DAX_BASE/$1/state" ] || return 1
+	drv=$(readlink "$DAX_BASE/$1/driver" 2>/dev/null)
+	[ "$(basename "${drv:-}")" = kmem ]
+}
+
+find_kmem_dax() {
+	local d
+	for d in "$DAX_BASE"/dax*; do
+		is_kmem_dax "$(basename "$d")" || continue
+		basename "$d"
+		return 0
+	done
+	return 1
+}
+
+# find_device_blocks -- print every memoryN block backing this dax device.
+# The blocks are derived from the device's own range(s) in /proc/iomem (the
+# reserved resource is named after the device), so we act on *its* blocks
+# rather than guessing by NUMA node - the target node may also hold unrelated
+# (and non-offlineable) memory.
+find_device_blocks() {
+	local bs
+	bs=$(cat "$MEM_BASE/block_size_bytes" 2>/dev/null)	# hex, no leading 0x
+	[ -n "$bs" ] || return 1
+	grep -E " : ${DAX}\$" /proc/iomem | while read -r line; do
+		local range s e i
+		range=${line%% :*}; range=${range// /}
+		s=${range%-*}; e=${range#*-}
+		for (( i = 0x$s / 0x$bs; i <= 0x$e / 0x$bs; i++ )); do
+			echo "memory$i"
+		done
+	done
+}
+
+# find_device_block -- print the first online block backing this dax device.
+find_device_block() {
+	local b
+	for b in $(find_device_blocks); do
+		[ -f "$MEM_BASE/$b/state" ] || continue
+		[ "$(cat "$MEM_BASE/$b/state")" = online ] || continue
+		echo "$b"
+		return 0
+	done
+	return 1
+}
+
+ktap_print_header
+
+if [ "$UID" != 0 ]; then
+	ktap_skip_all "must be run as root"
+	exit "$KSFT_SKIP"
+fi
+
+# Device selection is opt-in - see the header for why.
+DEV_SEL=${DAX_KMEM_TEST_DEV:-}
+if [ -z "$DEV_SEL" ]; then
+	ktap_skip_all "set DAX_KMEM_TEST_DEV=<daxX.Y|auto> to opt in (mutates device memory)"
+	exit "$KSFT_SKIP"
+fi
+if [ "$DEV_SEL" = auto ]; then
+	DAX=$(find_kmem_dax)
+else
+	DAX=$DEV_SEL
+fi
+if [ -z "$DAX" ] || ! is_kmem_dax "$DAX"; then
+	ktap_skip_all "no kmem-bound dax device with a state attribute (${DEV_SEL})"
+	exit "$KSFT_SKIP"
+fi
+HP=$DAX_BASE/$DAX/state
+ORIG=$(get_state)
+
+# A failure to reach the baseline is environmental (memory in use), not an
+# interface failure, so skip rather than fail.
+set_state unplugged; rc=$?
+if [ "$rc" != 0 ] || [ "$(get_state)" != unplugged ]; then
+	ktap_skip_all "$DAX: cannot reach 'unplugged' baseline (memory in use?)"
+	[ -n "$ORIG" ] && set_state "$ORIG"
+	exit "$KSFT_SKIP"
+fi
+mt_unplugged=$(memtotal_kb)
+
+DRV=/sys/bus/dax/drivers/kmem
+AOB=$MEM_BASE/auto_online_blocks
+
+ktap_print_msg "using $DAX (initial state was: $ORIG)"
+ktap_set_plan 10
+
+# A public (N_MEMORY) kmem node onlined into a kernel zone (online/online_kernel)
+# collects unmovable allocations and can then never be offlined, which would
+# wedge the device for the rest of this test.  So this test only ever
+# successfully onlines online_movable, the one mode that is reliably unpluggable.
+
+set_state online_movable; rc=$?
+mt_online=$(memtotal_kb)
+if [ "$rc" = 0 ] && [ "$(get_state)" = online_movable ] && [ "$mt_online" -gt "$mt_unplugged" ]; then
+	ktap_test_pass "online_movable: state=online_movable, MemTotal $mt_unplugged -> $mt_online kB"
+else
+	ktap_test_fail "online_movable: rc=$rc state=$(get_state) MemTotal $mt_unplugged -> $mt_online"
+fi
+
+set_state online_movable; rc=$?
+if [ "$rc" = 0 ] && [ "$(get_state)" = online_movable ]; then
+	ktap_test_pass "online_movable idempotent"
+else
+	ktap_test_fail "online_movable idempotent: rc=$rc state=$(get_state)"
+fi
+
+# A different online type is rejected without an intervening unplug.  The write
+# is refused before any hotplug, so this never actually onlines a kernel zone.
+set_state online_kernel; rc=$?
+if [ "$rc" != 0 ] && [ "$(get_state)" = online_movable ]; then
+	ktap_test_pass "reject online_kernel without intervening unplug (no kernel-zone online)"
+else
+	ktap_test_fail "online_movable->online_kernel not rejected: rc=$rc state=$(get_state)"
+fi
+
+set_state unplugged; rc=$?
+mt=$(memtotal_kb)
+if [ "$rc" = 0 ] && [ "$(get_state)" = unplugged ] && [ "$mt" -lt "$mt_online" ]; then
+	ktap_test_pass "unplug from online_movable: MemTotal $mt_online -> $mt kB"
+else
+	ktap_test_fail "unplug from online_movable: rc=$rc state=$(get_state) MemTotal $mt_online -> $mt"
+fi
+
+before=$(get_state)
+set_state bogus_state; rc=$?
+if [ "$rc" != 0 ] && [ "$(get_state)" = "$before" ]; then
+	ktap_test_pass "reject invalid state string"
+else
+	ktap_test_fail "invalid state not rejected: rc=$rc state=$(get_state)"
+fi
+
+# An online_movable -> unplug cycle must re-acquire the per-range resources on
+# each online and release them on each unplug.  Assert every iteration grows
+# MemTotal past the baseline and returns exactly to it; memory left online after
+# unplug (off > baseline) is a partial-free failure.
+set_state unplugged
+cycle_ok=1; fail_i=0; on=0; off=0
+for i in 1 2 3; do
+	if ! set_state online_movable; then cycle_ok=0; fail_i=$i; break; fi
+	on=$(memtotal_kb)
+	if ! set_state unplugged; then cycle_ok=0; fail_i=$i; break; fi
+	off=$(memtotal_kb)
+	# online must grow past baseline, and unplug must return to it - a
+	# partial free (memory left online) is a failure, not just off == on.
+	if [ "$on" -le "$mt_unplugged" ] || [ "$off" -gt "$mt_unplugged" ]; then
+		cycle_ok=0; fail_i=$i; break
+	fi
+done
+if [ "$cycle_ok" = 1 ]; then
+	ktap_test_pass "online_movable/unplug cycle re-acquires resources (3x: added and freed each time)"
+else
+	ktap_test_fail "online_movable/unplug cycle regressed at iteration $fail_i (on=$on off=$off baseline=$mt_unplugged)"
+fi
+
+# Desync: toggle a block through the legacy per-block memoryN/state interface
+# behind the driver's back, then unplug the whole device via daxX.Y/state.
+#
+# The driver only updates daxX.Y/state on its own writes, so it still reports
+# online_movable while a block underneath is already offline.
+#
+# Whole-device unplug must still succeed (within reason, an actor changing a
+# device from online_movable to online_kernel can no longer guarantee unplug).
+# At the very least, an already-offline block should not produce an error.
+set_state unplugged
+set_state online_movable
+blk=$(find_device_block)
+if [ -n "$blk" ] && echo offline > "$MEM_BASE/$blk/state" 2>/dev/null; then
+	# daxX.Y/state is now stale (still online_movable); unplug the device.
+	set_state unplugged; rc=$?
+	mt=$(memtotal_kb)
+	if [ "$rc" = 0 ] && [ "$(get_state)" = unplugged ] && [ "$mt" -le "$mt_unplugged" ]; then
+		ktap_test_pass "unplug tolerates a block pre-offlined via memoryN/state ($blk)"
+	else
+		ktap_test_fail "desync unplug: rc=$rc state=$(get_state) MemTotal=$mt baseline=$mt_unplugged"
+	fi
+else
+	set_state unplugged 2>/dev/null
+	ktap_test_skip "could not locate a device block to offline for desync test"
+fi
+
+# change system default online policy while the device is unbound, and show
+# the new system default policy is utilized across bindings.
+set_state unplugged
+if [ -w "$AOB" ] && [ -w "$DRV/unbind" ] && [ -w "$DRV/bind" ]; then
+	orig_aob=$(cat "$AOB")
+	echo "$DAX" > "$DRV/unbind" 2>/dev/null
+	echo offline > "$AOB" 2>/dev/null
+	echo "$DAX" > "$DRV/bind" 2>/dev/null
+	sleep 1
+	st=$(get_state)
+	echo "$orig_aob" > "$AOB" 2>/dev/null		# restore system policy
+	if [ "$st" = offline ]; then
+		ktap_test_pass "online policy resolved at bind: auto_online_blocks=offline -> state=offline"
+	else
+		ktap_test_fail "bind-time policy not honored: state=$st (expected offline)"
+	fi
+	set_state unplugged 2>/dev/null
+else
+	ktap_test_skip "auto_online_blocks or driver bind/unbind not writable"
+fi
+
+# Blocks offlined out-of-band (via memoryN/state) leave daxX.Y/state stale
+# (still online_movable) while every block is actually offline.  A driver unbind
+# must still hot-remove the offline memory and free its resources rather than
+# trust the stale state and leak until reboot.  Unbind uses remove_memory(),
+# which never offlines, so removing already-offline blocks is non-destructive and
+# the device rebinds cleanly afterwards.
+if [ -w "$DRV/unbind" ] && [ -w "$DRV/bind" ]; then
+	set_state unplugged
+	set_state online_movable
+	offl_ok=1
+	for b in $(find_device_blocks); do
+		[ -f "$MEM_BASE/$b/state" ] || continue
+		[ "$(cat "$MEM_BASE/$b/state")" = online ] || continue
+		echo offline > "$MEM_BASE/$b/state" 2>/dev/null || offl_ok=0
+	done
+	# daxX.Y/state is now stale (still online_movable) while all blocks are
+	# offline; the unbind must hot-remove them anyway.
+	if [ "$offl_ok" = 1 ] && [ "$(get_state)" = online_movable ]; then
+		echo "$DAX" > "$DRV/unbind" 2>/dev/null
+		mt_after=$(memtotal_kb)
+		leaked=$(grep -cE " : ${DAX}\$" /proc/iomem)	# before rebind
+		echo "$DAX" > "$DRV/bind" 2>/dev/null		# restore for later steps
+		sleep 1
+		if [ "$mt_after" -le "$mt_unplugged" ] && [ "$leaked" = 0 ]; then
+			ktap_test_pass "unbind with stale online state hot-removes offlined blocks (no leak)"
+		else
+			ktap_test_fail "desync unbind leaked: MemTotal=$mt_after baseline=$mt_unplugged iomem_left=$leaked"
+		fi
+		set_state unplugged 2>/dev/null
+	else
+		ktap_test_skip "could not offline all device blocks for desync-unbind test"
+	fi
+else
+	ktap_test_skip "driver bind/unbind not writable for desync-unbind test"
+fi
+
+[ -n "$ORIG" ] && set_state "$ORIG"
+
+# DESTRUCTIVE and opt-in only (DAX_KMEM_TEST_UNBIND=1):
+#
+# unbinding the driver while memory is online causes the resources to leak - but
+# the unbind should not deadlock.  Instead the driver leaks it with a warning.
+
+# This leaves the memory online and the device unbound until reboot, so it runs
+# last and only when explicitly requested.  online_movable only: this test
+# never onlines a public node into a kernel zone.
+
+if [ "${DAX_KMEM_TEST_UNBIND:-}" = 1 ] && [ -w "$DRV/unbind" ]; then
+	set_state unplugged; set_state online_movable
+fi
+if [ "${DAX_KMEM_TEST_UNBIND:-}" = 1 ] && [ "$(get_state)" = online_movable ] &&
+   [ -w "$DRV/unbind" ]; then
+	mt_on=$(memtotal_kb)
+	dmesg -C 2>/dev/null
+	echo "$DAX" > "$DRV/unbind" 2>/dev/null
+	mt_after=$(memtotal_kb)
+	# The leaked "System RAM (kmem)" regions stay in the iomem tree; reading
+	# their names dereferences res_name, which a buggy unbind already freed.
+	# Walk /proc/iomem to provoke that use-after-free (caught by KASAN).
+	cat /proc/iomem > /dev/null 2>&1
+	splat=$(dmesg 2>/dev/null | grep -ciE "KASAN|BUG:|use-after-free|general protection|Oops|refcount_t")
+	if [ "$splat" = 0 ] && [ "$mt_after" -ge "$mt_on" ]; then
+		ktap_test_pass "unbind while online: memory left online, no UAF/oops (MemTotal $mt_on -> $mt_after kB)"
+	else
+		ktap_test_fail "unbind while online regressed: splat=$splat MemTotal $mt_on -> $mt_after kB"
+	fi
+else
+	ktap_test_skip "destructive unbind-while-online test (set DAX_KMEM_TEST_UNBIND=1)"
+fi
+
+ktap_finished
diff --git a/tools/testing/selftests/dax/settings b/tools/testing/selftests/dax/settings
new file mode 100644
index 0000000000000..ba4d85f74cd6b
--- /dev/null
+++ b/tools/testing/selftests/dax/settings
@@ -0,0 +1 @@
+timeout=90
-- 
2.53.0-Meta

