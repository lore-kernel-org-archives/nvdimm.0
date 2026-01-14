Received: from mail-ot1-f46.google.com (mail-ot1-f46.google.com [209.85.210.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E90CB3A4AB8
	for <nvdimm@lists.linux.dev>; Wed, 14 Jan 2026 21:46:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768427210; cv=none; b=P585N3PkLPjpi+tLs+f+iPePRPYiNKY7FVFxu2LeigM5od40+K8G+kPu+eQlOPY4lRoH3/lixb0aj4EAfi2HkLAqTrZ5zkkEJpuVux5x42U6X8RoIOgfxvYYjMyo+r6Mr/7Dt604EQg5RJWcYiI1NdtPsHlGWC59KTVWQyaBuE8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768427210; c=relaxed/simple;
	bh=UH7UVmm/ifZMz2a7ctzEVAj9QL1YqJfv9TEsJAmqvl0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Ob/nk7nBJAKtsFqb5Q7Ia3rs9bPMO6bWsrJ+Tn7xpMTlpGZU7C5BHdIteKNYO0aK19xKpXiVb8XMPmGPGeJZM/0Re0G6US3I9TzHth19/r8R+KN12WpTJ1tzRgXBqSdKWDCRDRgHR4jPIgHIU9bVAV/cwHBHuR9EzJc78Wg1njY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=Groves.net; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=d2+es4d0; arc=none smtp.client-ip=209.85.210.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=Groves.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="d2+es4d0"
Received: by mail-ot1-f46.google.com with SMTP id 46e09a7af769-7cdf7529bb2so174986a34.2
        for <nvdimm@lists.linux.dev>; Wed, 14 Jan 2026 13:46:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1768427188; x=1769031988; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:sender:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ezmCIUYTCpc47N9MRFviC1UdzpKfkRUPsUPtXb573Uk=;
        b=d2+es4d0Rsp2BIHHYP4IBmdziA8ox+BdeAYE3gtMOPKC4FcesE0Wit/Xp6ofhAUXdS
         WH9mhiKd/DpoT4g3jNAYwR2a558VqrmVnAkHx898KJQLlbEaClKivaPGXfSgGsxj7Vax
         LMDDC3JRlEFb7M7ZbjFlwlqcLDZOFxiv2LdqBYqGzEknH/1vKH+HUl4mXWyDMYKOig+q
         5QNCOiz1TRZ8BLN7OpcMZ1667HQqbU95KWEjHOWveQyf3z80E2hqdtLg3NXOYs4cz5HC
         IM72c0XigoQrbiJVdOuRkGVmcN2/c6djoXxgGEdRudB8BPM+/C/Jveqwz8XuX504wZB1
         Q3jw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1768427188; x=1769031988;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:sender:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=ezmCIUYTCpc47N9MRFviC1UdzpKfkRUPsUPtXb573Uk=;
        b=vPvz0bn8u6LwMpvutQHeeUWkLT6Yg5pemCALSNCIsZYF1rTAtwE+sa9xhIUbkaYE2w
         Ae1+dwf+gKU+9IfPVd4u/tXobMmgorV7+khmqgzkUpYi7Z1H4It2qvSpqbDeb7EtbiCW
         DLYXOUILj1hHQQGw8qllUG0uWmMRd5VxmuwBZboIDBQFM2y6FJSUHXPWvzFdjatg84ZB
         ejsB0brMPM81etxbW/BxePspQavCYC4Rcc9sxw3azCRa/D9CkbznvjlKfZ30fSkNviAe
         zpkxwUJI8vm/B3GSj6eSFF+anQfJndpz4k9EuecL5cHL+ETvKRXRWFWjasLuOth7Eu/g
         r2eA==
X-Forwarded-Encrypted: i=1; AJvYcCXN7Qvlj5OP0EHUGZ7eVB+A2lmYO+NseDN39MX7yKtX+kyVvrRat7S0Bm9AXwtRcIL75osjumg=@lists.linux.dev
X-Gm-Message-State: AOJu0YwazZBcWLYtN+ewaMXAs9QdjOJDxXaPtj2ZH3io9ATYtGNByhUT
	uxwV4QCPZDyHfbzVHX8iqiQia4N1V9V5NSpJUifk36JmQaw7OpP1FgZz
X-Gm-Gg: AY/fxX4TS+EE3hJYTOX53Oq0V8gC03a5k5+YnMjsih7flBhLzbAhk/CgEnKNgT4sNXt
	WudHxduv1vcUPGTT5hzlLFYB6R9bvFYjJ9oBN/Bg/Cu3rhkHjk/uiDSY0KIJGIsXOqEsJRAe1os
	dU6f7dhQSkFaDmpP1pY3WnEiaC0ToPIG+GDpI/VqSzkLrXH14rPaCTHTyHdJ4OO1pDKt3ju6M7w
	bWNqtl5SA43eeDsZJi1xGsAfae8dh9G7ONG731kO85bbcvOLB+A5EBCoQ9lByzCdr6q70JmpYoP
	2NvBiSMT39MKs69XgLqHikNpcyoYnmyBVhuIaiC3AHZL47VNvRFFnlpzEgtNCRaP01uGaE3NYQy
	uyAFfxKyj5UnjERUhp35GYWTpiuXrNY59cUQgMKPKjzuQUSNzBBG/r755XFEmOVaFh9CeFG9sbp
	iBbku6SHG30LpJq/AX09eGH312r171U2k44+M1m5CfvyYx
X-Received: by 2002:a05:6830:2541:b0:7cf:cc11:f7cc with SMTP id 46e09a7af769-7cfcc11f982mr2409830a34.36.1768427188084;
        Wed, 14 Jan 2026 13:46:28 -0800 (PST)
Received: from localhost.localdomain ([2603:8080:1500:3d89:4c85:2962:e438:72c4])
        by smtp.gmail.com with ESMTPSA id 46e09a7af769-7cfc3692f3asm3936197a34.10.2026.01.14.13.46.25
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Wed, 14 Jan 2026 13:46:27 -0800 (PST)
Sender: John Groves <grovesaustin@gmail.com>
From: John Groves <John@Groves.net>
X-Google-Original-From: John Groves <john@groves.net>
To: John Groves <John@Groves.net>,
	Miklos Szeredi <miklos@szeredi.hu>,
	Dan Williams <dan.j.williams@intel.com>,
	Bernd Schubert <bschubert@ddn.com>,
	Alison Schofield <alison.schofield@intel.com>
Cc: John Groves <jgroves@micron.com>,
	Jonathan Corbet <corbet@lwn.net>,
	Vishal Verma <vishal.l.verma@intel.com>,
	Dave Jiang <dave.jiang@intel.com>,
	Matthew Wilcox <willy@infradead.org>,
	Jan Kara <jack@suse.cz>,
	Alexander Viro <viro@zeniv.linux.org.uk>,
	David Hildenbrand <david@kernel.org>,
	Christian Brauner <brauner@kernel.org>,
	"Darrick J . Wong" <djwong@kernel.org>,
	Randy Dunlap <rdunlap@infradead.org>,
	Jeff Layton <jlayton@kernel.org>,
	Amir Goldstein <amir73il@gmail.com>,
	Jonathan Cameron <Jonathan.Cameron@huawei.com>,
	Stefan Hajnoczi <shajnocz@redhat.com>,
	Joanne Koong <joannelkoong@gmail.com>,
	Josef Bacik <josef@toxicpanda.com>,
	Bagas Sanjaya <bagasdotme@gmail.com>,
	James Morse <james.morse@arm.com>,
	Fuad Tabba <tabba@google.com>,
	Sean Christopherson <seanjc@google.com>,
	Shivank Garg <shivankg@amd.com>,
	Ackerley Tng <ackerleytng@google.com>,
	Gregory Price <gourry@gourry.net>,
	Aravind Ramesh <arramesh@micron.com>,
	Ajay Joshi <ajayjoshi@micron.com>,
	venkataravis@micron.com,
	linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	nvdimm@lists.linux.dev,
	linux-cxl@vger.kernel.org,
	linux-fsdevel@vger.kernel.org
Subject: [PATCH V2 2/2] Add test/daxctl-famfs.sh to test famfs mode transitions:
Date: Wed, 14 Jan 2026 15:45:19 -0600
Message-ID: <20260114214519.29999-3-john@groves.net>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260114214519.29999-1-john@groves.net>
References: <20260114153133.29420.compound@groves.net>
 <20260114214519.29999-1-john@groves.net>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: John Groves <John@Groves.net>

- devdax <-> famfs mode switches
- Verify famfs -> system-ram is rejected (must go via devdax)
- Test JSON output shows correct mode
- Test error handling for invalid modes

The test is added to the destructive test suite since it
modifies device modes.

Signed-off-by: John Groves <john@groves.net>
---
 test/daxctl-famfs.sh | 253 +++++++++++++++++++++++++++++++++++++++++++
 test/meson.build     |   2 +
 2 files changed, 255 insertions(+)
 create mode 100755 test/daxctl-famfs.sh

diff --git a/test/daxctl-famfs.sh b/test/daxctl-famfs.sh
new file mode 100755
index 0000000..12fbfef
--- /dev/null
+++ b/test/daxctl-famfs.sh
@@ -0,0 +1,253 @@
+#!/bin/bash -Ex
+# SPDX-License-Identifier: GPL-2.0
+# Copyright (C) 2025 Micron Technology, Inc. All rights reserved.
+#
+# Test daxctl famfs mode transitions and mode detection
+
+rc=77
+. $(dirname $0)/common
+
+trap 'cleanup $LINENO' ERR
+
+daxdev=""
+original_mode=""
+
+cleanup()
+{
+	printf "Error at line %d\n" "$1"
+	# Try to restore to original mode if we know it
+	if [[ $daxdev && $original_mode ]]; then
+		"$DAXCTL" reconfigure-device -f -m "$original_mode" "$daxdev" 2>/dev/null || true
+	fi
+	exit $rc
+}
+
+# Check if fsdev_dax module is available
+check_fsdev_dax()
+{
+	if modinfo fsdev_dax &>/dev/null; then
+		return 0
+	fi
+	if grep -qF "fsdev_dax" "/lib/modules/$(uname -r)/modules.builtin" 2>/dev/null; then
+		return 0
+	fi
+	printf "fsdev_dax module not available, skipping\n"
+	exit 77
+}
+
+# Check if kmem module is available (needed for system-ram mode tests)
+check_kmem()
+{
+	if modinfo kmem &>/dev/null; then
+		return 0
+	fi
+	if grep -qF "kmem" "/lib/modules/$(uname -r)/modules.builtin" 2>/dev/null; then
+		return 0
+	fi
+	printf "kmem module not available, skipping system-ram tests\n"
+	return 1
+}
+
+# Find an existing dax device to test with
+find_daxdev()
+{
+	# Look for any available dax device
+	daxdev=$("$DAXCTL" list | jq -er '.[0].chardev // empty' 2>/dev/null) || true
+
+	if [[ ! $daxdev ]]; then
+		printf "No dax device found, skipping\n"
+		exit 77
+	fi
+
+	# Save the original mode so we can restore it
+	original_mode=$("$DAXCTL" list -d "$daxdev" | jq -er '.[].mode')
+
+	printf "Found dax device: %s (current mode: %s)\n" "$daxdev" "$original_mode"
+}
+
+daxctl_get_mode()
+{
+	"$DAXCTL" list -d "$1" | jq -er '.[].mode'
+}
+
+# Ensure device is in devdax mode for testing
+ensure_devdax_mode()
+{
+	local mode
+	mode=$(daxctl_get_mode "$daxdev")
+
+	if [[ "$mode" == "devdax" ]]; then
+		return 0
+	fi
+
+	if [[ "$mode" == "system-ram" ]]; then
+		printf "Device is in system-ram mode, attempting to convert to devdax...\n"
+		"$DAXCTL" reconfigure-device -f -m devdax "$daxdev"
+	elif [[ "$mode" == "famfs" ]]; then
+		printf "Device is in famfs mode, converting to devdax...\n"
+		"$DAXCTL" reconfigure-device -m devdax "$daxdev"
+	else
+		printf "Device is in unknown mode: %s\n" "$mode"
+		return 1
+	fi
+
+	[[ $(daxctl_get_mode "$daxdev") == "devdax" ]]
+}
+
+#
+# Test basic mode transitions involving famfs
+#
+test_famfs_mode_transitions()
+{
+	printf "\n=== Testing famfs mode transitions ===\n"
+
+	# Ensure starting in devdax mode
+	ensure_devdax_mode
+	[[ $(daxctl_get_mode "$daxdev") == "devdax" ]]
+	printf "Initial mode: devdax - OK\n"
+
+	# Test: devdax -> famfs
+	printf "Testing devdax -> famfs... "
+	"$DAXCTL" reconfigure-device -m famfs "$daxdev"
+	[[ $(daxctl_get_mode "$daxdev") == "famfs" ]]
+	printf "OK\n"
+
+	# Test: famfs -> famfs (re-enable in same mode)
+	printf "Testing famfs -> famfs (re-enable)... "
+	"$DAXCTL" reconfigure-device -m famfs "$daxdev"
+	[[ $(daxctl_get_mode "$daxdev") == "famfs" ]]
+	printf "OK\n"
+
+	# Test: famfs -> devdax
+	printf "Testing famfs -> devdax... "
+	"$DAXCTL" reconfigure-device -m devdax "$daxdev"
+	[[ $(daxctl_get_mode "$daxdev") == "devdax" ]]
+	printf "OK\n"
+
+	# Test: devdax -> devdax (re-enable in same mode)
+	printf "Testing devdax -> devdax (re-enable)... "
+	"$DAXCTL" reconfigure-device -m devdax "$daxdev"
+	[[ $(daxctl_get_mode "$daxdev") == "devdax" ]]
+	printf "OK\n"
+}
+
+#
+# Test mode transitions with system-ram (requires kmem)
+#
+test_system_ram_transitions()
+{
+	printf "\n=== Testing system-ram transitions with famfs ===\n"
+
+	# Ensure we start in devdax mode
+	ensure_devdax_mode
+	[[ $(daxctl_get_mode "$daxdev") == "devdax" ]]
+
+	# Test: devdax -> system-ram
+	printf "Testing devdax -> system-ram... "
+	"$DAXCTL" reconfigure-device -N -m system-ram "$daxdev"
+	[[ $(daxctl_get_mode "$daxdev") == "system-ram" ]]
+	printf "OK\n"
+
+	# Test: system-ram -> famfs should fail
+	printf "Testing system-ram -> famfs (should fail)... "
+	if "$DAXCTL" reconfigure-device -m famfs "$daxdev" 2>/dev/null; then
+		printf "FAILED - should have been rejected\n"
+		return 1
+	fi
+	printf "OK (correctly rejected)\n"
+
+	# Test: system-ram -> devdax -> famfs (proper path)
+	printf "Testing system-ram -> devdax -> famfs... "
+	"$DAXCTL" reconfigure-device -f -m devdax "$daxdev"
+	[[ $(daxctl_get_mode "$daxdev") == "devdax" ]]
+	"$DAXCTL" reconfigure-device -m famfs "$daxdev"
+	[[ $(daxctl_get_mode "$daxdev") == "famfs" ]]
+	printf "OK\n"
+
+	# Restore to devdax for subsequent tests
+	"$DAXCTL" reconfigure-device -m devdax "$daxdev"
+}
+
+#
+# Test JSON output shows correct mode
+#
+test_json_output()
+{
+	printf "\n=== Testing JSON output for mode field ===\n"
+
+	# Test devdax mode in JSON
+	ensure_devdax_mode
+	printf "Testing JSON output for devdax mode... "
+	mode=$("$DAXCTL" list -d "$daxdev" | jq -er '.[].mode')
+	[[ "$mode" == "devdax" ]]
+	printf "OK\n"
+
+	# Test famfs mode in JSON
+	"$DAXCTL" reconfigure-device -m famfs "$daxdev"
+	printf "Testing JSON output for famfs mode... "
+	mode=$("$DAXCTL" list -d "$daxdev" | jq -er '.[].mode')
+	[[ "$mode" == "famfs" ]]
+	printf "OK\n"
+
+	# Restore to devdax
+	"$DAXCTL" reconfigure-device -m devdax "$daxdev"
+}
+
+#
+# Test error messages for invalid transitions
+#
+test_error_handling()
+{
+	printf "\n=== Testing error handling ===\n"
+
+	# Ensure we're in famfs mode
+	"$DAXCTL" reconfigure-device -m famfs "$daxdev"
+
+	# Test that invalid mode is rejected
+	printf "Testing invalid mode rejection... "
+	if "$DAXCTL" reconfigure-device -m invalidmode "$daxdev" 2>/dev/null; then
+		printf "FAILED - invalid mode should be rejected\n"
+		return 1
+	fi
+	printf "OK (correctly rejected)\n"
+
+	# Restore to devdax
+	"$DAXCTL" reconfigure-device -m devdax "$daxdev"
+}
+
+#
+# Main test sequence
+#
+main()
+{
+	check_fsdev_dax
+	find_daxdev
+
+	rc=1  # From here on, failures are real failures
+
+	test_famfs_mode_transitions
+	test_json_output
+	test_error_handling
+
+	# System-ram tests require kmem module
+	if check_kmem; then
+		# Save and disable online policy for system-ram tests
+		saved_policy="$(cat /sys/devices/system/memory/auto_online_blocks)"
+		echo "offline" > /sys/devices/system/memory/auto_online_blocks
+
+		test_system_ram_transitions
+
+		# Restore online policy
+		echo "$saved_policy" > /sys/devices/system/memory/auto_online_blocks
+	fi
+
+	# Restore original mode
+	printf "\nRestoring device to original mode: %s\n" "$original_mode"
+	"$DAXCTL" reconfigure-device -f -m "$original_mode" "$daxdev"
+
+	printf "\n=== All famfs tests passed ===\n"
+
+	exit 0
+}
+
+main
diff --git a/test/meson.build b/test/meson.build
index 615376e..ad1d393 100644
--- a/test/meson.build
+++ b/test/meson.build
@@ -209,6 +209,7 @@ if get_option('destructive').enabled()
   device_dax_fio = find_program('device-dax-fio.sh')
   daxctl_devices = find_program('daxctl-devices.sh')
   daxctl_create = find_program('daxctl-create.sh')
+  daxctl_famfs = find_program('daxctl-famfs.sh')
   dm = find_program('dm.sh')
   mmap_test = find_program('mmap.sh')
 
@@ -226,6 +227,7 @@ if get_option('destructive').enabled()
     [ 'device-dax-fio.sh', device_dax_fio, 'dax'   ],
     [ 'daxctl-devices.sh', daxctl_devices, 'dax'   ],
     [ 'daxctl-create.sh',  daxctl_create,  'dax'   ],
+    [ 'daxctl-famfs.sh',   daxctl_famfs,   'dax'   ],
     [ 'dm.sh',             dm,		   'dax'   ],
     [ 'mmap.sh',           mmap_test,	   'dax'   ],
   ]
-- 
2.49.0

