Received: from mail-qt1-f175.google.com (mail-qt1-f175.google.com [209.85.160.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A5DDB3DA7F6
	for <nvdimm@lists.linux.dev>; Wed, 24 Jun 2026 14:58:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.175
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782313098; cv=none; b=AT/jbqy7lRyy4l+eV+xTPlmNalY6UnfFhE3IcI2H24yIo/bDnDmTOLQ9/DNlDz6j/T1F8fTWYHxzehtpxB0X/b64m3tyQYU+o7bghK6HYCQrWNjlPwK5hxl4taRR0HuCZ6Fucy9Y6PFgk5gi+9ExdKxYnypjHEQQ/WE+OPyewIE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782313098; c=relaxed/simple;
	bh=ii43xFy0tDyBF59C9FOLmKxiCEoKpj3fiU5W0+y+0f4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FIpOx6kgp2OT38Z5rUh0BN1EXROimz8rLFR4LuXtZ2M7X8pU9a+diCjJdt3zDUaSuzvAE357G9NqFPNPtsMIpSjh3LHIdlhV66us/pvsfAjyhDAhQfPV2+HabT4Yu3jFGf+0o3wMSmgN+quk9xknRtpXKqkosdffLNgZ4PrEalc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=gourry.net; spf=pass smtp.mailfrom=gourry.net; dkim=pass (2048-bit key) header.d=gourry.net header.i=@gourry.net header.b=Bk7miesh; arc=none smtp.client-ip=209.85.160.175
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=gourry.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gourry.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gourry.net header.i=@gourry.net header.b="Bk7miesh"
Received: by mail-qt1-f175.google.com with SMTP id d75a77b69052e-517583cb07aso10011051cf.2
        for <nvdimm@lists.linux.dev>; Wed, 24 Jun 2026 07:58:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gourry.net; s=google; t=1782313095; x=1782917895; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Ccu6+dOqqZdEpVufOt6x4Cg2c1A1kw030+HXK8hkrU0=;
        b=Bk7mieshAx+9wamrqfeJTZSno6opf91R5YLoSe+azgS9IoVt+tWLMjp1gN5z9JZdjn
         6XVkzNUambl4PD7iPUALVCAWrFn2mD8bfSOlheLe9Pison4PXETtXm0pm//J/nXl7uMF
         P7tIQVeHuiLm0jCk9GHDk5dU9/4jZrBv+W3IIGid3U5jqpBiTzUIwfvyFPLFsunJWe5X
         RPdP1QXAXZOifev+zLO8sKQOwPIzN1xsfKnYMFXrvjl/Rl3pb8pf48F0tOlOvTOAR9oV
         5sKjLGqD2kzqG1urqnoL5y1BjXRuVpVBumXQSI3SfRmVs6oFgfaIWvZ4ZgSolSNFwTdY
         rLcg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1782313095; x=1782917895;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=Ccu6+dOqqZdEpVufOt6x4Cg2c1A1kw030+HXK8hkrU0=;
        b=f6ktxTkePZSFVfF1GKyGG81zIeGzv6JZxGAltlUQxBcXcSES29PxExUBF5RxfMfRCd
         viDCWGRJUPphPDWwh4d6Szn2kbDpfxJdhA4JL1MOSYnjBpFZHAw+nzQRdUjgU3fB6XRV
         RGfoEOfWh0KGeTzsiMCeyQLIHq0lSWIurtBZEdgqZXlqztCOdmatieWj8zgpnOUjGd0S
         xbaqgycci0Co4DMBwO7/AFxc4b7Gn+QH/Vk87hv3xAQgRoOJzJ2eNh4Oo1uCaHlITzDh
         5geAnp195i4Z+NH+1C4w379oBUSMvvAoRAeDYkh5IG+gXxnHZ8Fpkk1Vc7JMJwm3eeqA
         rJ3w==
X-Forwarded-Encrypted: i=1; AFNElJ+q6KyhIox1bIrTWM/tJoHvqnS8Owwewo8O6ZN+o/2EW+/dYOaCjTFOhlu8n95htWQPrH9zmxk=@lists.linux.dev
X-Gm-Message-State: AOJu0YzSHDCnuOAOgCignS/rBYjx1sbsy89h7WZD8qzIDZzxEDCTudcY
	SVG1XXE8tNy2aPR2f8EQNqN76/Lz30MVHT7k4+g7QU2whd1iN/vH/u6MWyWrtH6xlqw=
X-Gm-Gg: AfdE7cmhNY1bKkxUeLLWJTFpWDE9p2XZqyrT32TttjtzoSN6sbhLazk8Nc8wHpEMJjE
	QHEmfGs3CRtSwNKEX4seD7OotX6TQbvRuxFZyW7pdInsjw2gMmY5mDQNqjhh5PYU+8n9s87yERO
	LGJl9e5OYo+Xb+nnwwujvI+SIr2op5RpQyptkz7Py6RWgF4dkXySHkqCCIEs81TcdbW4ZIeXQMq
	rqm1/iWxMC0P+2u2UUOCofG/BztX5w9++onqy6zsvfLQnGa05EtJ/9LkSXXOJK+pmcXA05wjXUN
	rxcxNP9e/3ckxcNk8dWOM4QYK0du6LeSjPtc8U5hd+ZA9rCWqSzplWnVOTfwA6j5wWO+5tgG6aA
	6XyL/1jjwefK8FPNNHQ0dw/QEkoq7b3Hg0q5Fk0LJpLW0wI3VkIc7l/CmE8J46u5cRvQOi3TJgw
	+YCVVxM310MPNRH/sSunUpqoCm40uBgauCpNftDzZ4blpPuQI7DeSn8PauwlbW5KpxCwXthVszm
	w==
X-Received: by 2002:ac8:5f4d:0:b0:50f:c1d4:d9e1 with SMTP id d75a77b69052e-51a61bf7488mr58332751cf.38.1782313094317;
        Wed, 24 Jun 2026 07:58:14 -0700 (PDT)
Received: from gourry-fedora-PF4VCD3F.lan (pool-173-79-60-52.washdc.fios.verizon.net. [173.79.60.52])
        by smtp.gmail.com with ESMTPSA id d75a77b69052e-51a51ae8ee7sm49502301cf.24.2026.06.24.07.58.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 24 Jun 2026 07:58:13 -0700 (PDT)
From: Gregory Price <gourry@gourry.net>
To: linux-mm@kvack.org,
	nvdimm@lists.linux.dev
Cc: linux-kernel@vger.kernel.org,
	linux-cxl@vger.kernel.org,
	driver-core@lists.linux.dev,
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
	akpm@linux-foundation.org,
	ljs@kernel.org,
	liam@infradead.org,
	vbabka@kernel.org,
	rppt@kernel.org,
	surenb@google.com,
	mhocko@suse.com,
	shuah@kernel.org,
	gourry@gourry.net,
	alison.schofield@intel.com,
	Smita.KoralahalliChannabasappa@amd.com,
	ira.weiny@intel.com,
	apopple@nvidia.com
Subject: [PATCH v5 9/9] selftests/dax: add dax/kmem hotplug sysfs regression test
Date: Wed, 24 Jun 2026 10:57:44 -0400
Message-ID: <20260624145744.3532049-10-gourry@gourry.net>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260624145744.3532049-1-gourry@gourry.net>
References: <20260624145744.3532049-1-gourry@gourry.net>
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
does not deadlock - but this is a destructive test.  The dax device
can never be rebound after doing this.

Provisioning a devdax device and binding it to kmem needs daxctl/ndctl
out of scope for an in-tree selftest, so the test discovers an already
kmem-bound dax device and SKIPs when none are present or the memory
cannot be freed to reach a known baseline.

When a device is available it validates the interface contract:
  - online / online_movable actually add memory (MemTotal grows),
  - online is idempotent,
  - switching between online types without unplug is rejected,
  - unplug removes memory and the reported state is "unplugged"
  - invalid input is rejected.

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
 .../testing/selftests/dax/dax-kmem-hotplug.sh | 207 ++++++++++++++++++
 tools/testing/selftests/dax/settings          |   1 +
 5 files changed, 219 insertions(+)
 create mode 100644 tools/testing/selftests/dax/Makefile
 create mode 100644 tools/testing/selftests/dax/config
 create mode 100755 tools/testing/selftests/dax/dax-kmem-hotplug.sh
 create mode 100644 tools/testing/selftests/dax/settings

diff --git a/tools/testing/selftests/Makefile b/tools/testing/selftests/Makefile
index 6e59b8f63e41..8c2b4f97619c 100644
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
index 000000000000..25a4f3d73a5b
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
index 000000000000..4c9aaeb6ceb4
--- /dev/null
+++ b/tools/testing/selftests/dax/config
@@ -0,0 +1,4 @@
+CONFIG_DEV_DAX=m
+CONFIG_DEV_DAX_KMEM=m
+CONFIG_MEMORY_HOTPLUG=y
+CONFIG_MEMORY_HOTREMOVE=y
diff --git a/tools/testing/selftests/dax/dax-kmem-hotplug.sh b/tools/testing/selftests/dax/dax-kmem-hotplug.sh
new file mode 100755
index 000000000000..803bbd5a6409
--- /dev/null
+++ b/tools/testing/selftests/dax/dax-kmem-hotplug.sh
@@ -0,0 +1,207 @@
+#!/bin/bash
+# SPDX-License-Identifier: GPL-2.0
+#
+# Exercise the dax/kmem "state" sysfs attribute:
+#   /sys/bus/dax/devices/daxX.Y/state  ->  unplugged | online | online_movable
+#
+# The test needs a dax device already bound to the kmem driver.
+# If no suitable device is found the tests SKIP.
+#
+# A dax device can be provisioned with the memmap= boot param, e.g.:
+#   memmap=2G!4G
+#
+# then, in the booted system:
+#
+#   ndctl create-namespace -m devdax -e namespace0.0 -f
+#   daxctl reconfigure-device -N -m system-ram dax0.0   # bind kmem
+#   ./dax-kmem-hotplug.sh
+
+# shellcheck disable=SC1091
+DIR="$(dirname "$(readlink -f "$0")")"
+. "$DIR"/../kselftest/ktap_helpers.sh
+
+DAX_BASE=/sys/bus/dax/devices
+
+memtotal_kb() { awk '/^MemTotal:/ {print $2}' /proc/meminfo; }
+get_state() { cat "$HP" 2>/dev/null; }
+# set_state STATE -- write a state to the state attribute; returns the
+# write's exit status (0 = accepted by the kernel)
+set_state() { echo "$1" > "$HP" 2>/dev/null; }
+
+find_kmem_dax() {
+	local d drv
+	for d in "$DAX_BASE"/dax*; do
+		[ -e "$d/state" ] || continue
+		drv=$(readlink "$d/driver" 2>/dev/null)
+		[ "$(basename "${drv:-}")" = kmem ] || continue
+		basename "$d"
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
+DAX=$(find_kmem_dax)
+if [ -z "$DAX" ]; then
+	ktap_skip_all "no kmem-bound dax device with a state attribute"
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
+AOB=/sys/devices/system/memory/auto_online_blocks
+
+ktap_print_msg "using $DAX (initial state was: $ORIG)"
+ktap_set_plan 11
+
+set_state online; rc=$?
+mt_online=$(memtotal_kb)
+if [ "$rc" = 0 ] && [ "$(get_state)" = online ] && [ "$mt_online" -gt "$mt_unplugged" ]; then
+	ktap_test_pass "online: state=online, MemTotal $mt_unplugged -> $mt_online kB"
+else
+	ktap_test_fail "online: rc=$rc state=$(get_state) MemTotal $mt_unplugged -> $mt_online"
+fi
+
+set_state online; rc=$?
+if [ "$rc" = 0 ] && [ "$(get_state)" = online ]; then
+	ktap_test_pass "online idempotent"
+else
+	ktap_test_fail "online idempotent: rc=$rc state=$(get_state)"
+fi
+
+set_state online_movable; rc=$?
+if [ "$rc" != 0 ] && [ "$(get_state)" = online ]; then
+	ktap_test_pass "reject online_movable without intervening unplug"
+else
+	ktap_test_fail "online->online_movable not rejected: rc=$rc state=$(get_state)"
+fi
+
+set_state unplugged; rc=$?
+mt=$(memtotal_kb)
+if [ "$rc" = 0 ] && [ "$(get_state)" = unplugged ] && [ "$mt" -lt "$mt_online" ]; then
+	ktap_test_pass "unplug from online: MemTotal $mt_online -> $mt kB"
+else
+	ktap_test_fail "unplug from online: rc=$rc state=$(get_state) MemTotal $mt_online -> $mt"
+fi
+
+set_state online_movable; rc=$?
+mt_movable=$(memtotal_kb)
+if [ "$rc" = 0 ] && [ "$(get_state)" = online_movable ] && [ "$mt_movable" -gt "$mt_unplugged" ]; then
+	ktap_test_pass "online_movable after unplug: MemTotal $mt_unplugged -> $mt_movable kB"
+else
+	ktap_test_fail "online_movable after unplug: rc=$rc state=$(get_state) MemTotal=$mt_movable"
+fi
+
+# The online -> unplug -> online_movable -> unplug cycle once regressed:
+# a re-online failed to re-reserve the per-range resources, so the final unplug
+# reported success while leaving the memory online.  Assert it is really freed.
+set_state unplugged; rc=$?
+mt=$(memtotal_kb)
+if [ "$rc" != 0 ]; then
+	ktap_test_skip "unplug from movable not accepted (memory in use?) rc=$rc"
+elif [ "$(get_state)" = unplugged ] && [ "$mt" -lt "$mt_movable" ]; then
+	ktap_test_pass "unplug from online_movable removed memory: $mt_movable -> $mt kB"
+else
+	ktap_test_fail "unplug from movable reported success but memory remained: state=$(get_state) MemTotal $mt_movable -> $mt"
+fi
+
+set_state online_kernel; rc=$?
+mt=$(memtotal_kb)
+if [ "$rc" = 0 ] && [ "$(get_state)" = online_kernel ] && [ "$mt" -gt "$mt_unplugged" ]; then
+	ktap_test_pass "online_kernel: MemTotal $mt_unplugged -> $mt kB"
+else
+	ktap_test_fail "online_kernel: rc=$rc state=$(get_state) MemTotal=$mt"
+fi
+set_state unplugged
+
+before=$(get_state)
+set_state bogus_state; rc=$?
+if [ "$rc" != 0 ] && [ "$(get_state)" = "$before" ]; then
+	ktap_test_pass "reject invalid state string"
+else
+	ktap_test_fail "invalid state not rejected: rc=$rc state=$(get_state)"
+fi
+
+# Run several online/unplug cycles and require that each one adds/removes memory
+set_state unplugged
+cycle_ok=1; fail_i=0
+for i in 1 2 3; do
+	if ! set_state online; then cycle_ok=0; fail_i=$i; break; fi
+	on=$(memtotal_kb)
+	if ! set_state unplugged; then cycle_ok=0; fail_i=$i; break; fi
+	off=$(memtotal_kb)
+	if [ "$on" -le "$mt_unplugged" ] || [ "$off" -ge "$on" ]; then
+		cycle_ok=0; fail_i=$i; break
+	fi
+done
+if [ "$cycle_ok" = 1 ]; then
+	ktap_test_pass "online/unplug cycle re-acquires resources (3x: memory added and freed each time)"
+else
+	ktap_test_fail "online/unplug cycle regressed at iteration $fail_i (on=$on off=$off baseline=$mt_unplugged)"
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
+[ -n "$ORIG" ] && set_state "$ORIG"
+
+# DESTRUCTIVE: unbinding the driver while memory is online causes the resources
+# to leak - but the unbind should not deadlock.  Instead the driver leaks it
+# with a single "suck online" warning. This leaves the memory online and the
+# device unbound until reboot, so it runs last.
+set_state unplugged; set_state online
+if [ "$(get_state)" = online ] && [ -w "$DRV/unbind" ]; then
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
+	ktap_test_skip "could not online device for unbind-while-online test"
+fi
+
+ktap_finished
diff --git a/tools/testing/selftests/dax/settings b/tools/testing/selftests/dax/settings
new file mode 100644
index 000000000000..ba4d85f74cd6
--- /dev/null
+++ b/tools/testing/selftests/dax/settings
@@ -0,0 +1 @@
+timeout=90
-- 
2.54.0

