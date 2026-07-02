Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E868A533D6
	for <nvdimm@lists.linux.dev>; Thu,  2 Jul 2026 00:34:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782952457; cv=none; b=YrA3IksRJNaNqu9HizXwroFcBNSyTQ2sqwSUwS7EZXuyCqagDQ2GhshTYTJN7W2PII4J7EwD+fYiFYQH0gxa3gZCCz/siqzYhi+WfYB2YNu8oQp0dR9W7KA2gGYed81GtC+4jM27jM4ui2hP/UTx2Zrz9nZE/+Xaest6WnI4UrI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782952457; c=relaxed/simple;
	bh=cQoIuTjVH1rKyL7jeC1wgN4OMYbRAxcrFCdl0o7/q2Y=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=FZWvSNLl9/rwilPbbmYMmhXLpcJtYRIyKwILjpvZadh9/oElf/jgsU7esDmrJl/M9pgwbX7z7q1Di8gYit4zbpWDJJ9+AnuqG6wrWBwBiNSblJF4sEuKUPwhR2+TVchxUFTw9wR/2YoIAhuzkGWH4J/ve0TyBMK3cugATAqrdiQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=YT5fTBVI; arc=none smtp.client-ip=192.198.163.18
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="YT5fTBVI"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1782952456; x=1814488456;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=cQoIuTjVH1rKyL7jeC1wgN4OMYbRAxcrFCdl0o7/q2Y=;
  b=YT5fTBVIlRt8qYJ6SDL402fTa2THsZCBqf2yMoviD2I4VG8AVCj6kq95
   oPbPwimiQgnzbAsSgjCHU4jIxckY57eGF35AuF4WZN1M84iv7gAqYdECx
   OqZCCOBRmQRQItp6ndkQf+HzE1NuafEvgZZyYcvOCfEKkCoJ+IAXmEHaE
   GR+8vPRbku0zI9xDVegn46P5GezIy8f8VCwqin+AgxPZJmr/L1uinVr2Y
   LYhMDN9am/pA8omFW7dan4J2trPgTGiRzOcKRmWy+6lDNDreeqjQo7JWE
   E1uCYAmwzit2o3nW4RLz3NNacBBKt6+X9v/LSfpUrnzsuD/Z+h6ERFiCn
   Q==;
X-CSE-ConnectionGUID: GY/lMz4KTVO8l0GlDhK7pQ==
X-CSE-MsgGUID: wnn2rRE4Toi2I2E29bUfuA==
X-IronPort-AV: E=McAfee;i="6800,10657,11834"; a="82811334"
X-IronPort-AV: E=Sophos;i="6.25,142,1779174000"; 
   d="scan'208";a="82811334"
Received: from fmviesa009.fm.intel.com ([10.60.135.149])
  by fmvoesa112.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Jul 2026 17:34:15 -0700
X-CSE-ConnectionGUID: KWQjPiGOS6WmEeFkIojHkg==
X-CSE-MsgGUID: VzbIZQlZTyu/y7aAs+XBqg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.25,142,1779174000"; 
   d="scan'208";a="246355529"
Received: from aschofie-mobl2.amr.corp.intel.com (HELO localhost) ([10.124.221.139])
  by fmviesa009-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Jul 2026 17:34:15 -0700
From: Alison Schofield <alison.schofield@intel.com>
To: nvdimm@lists.linux.dev,
	linux-cxl@vger.kernel.org
Cc: Alison Schofield <alison.schofield@intel.com>
Subject: [ndctl PATCH] test/cxl-security.sh: test dimm unlock with a large serial number
Date: Wed,  1 Jul 2026 17:34:03 -0700
Message-ID: <20260702003407.1611731-1-alison.schofield@intel.com>
X-Mailer: git-send-email 2.47.0
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The existing CXL unlock test exposed the hexadecimal-vs-decimal key
description mismatch once cxl_test mock serial numbers were extended
to 10 and above. Serials with bit 63 set expose a second formatting
problem in that the kernel formats the decimal serial as signed,
rendering it as a negative value.

Extend the existing "unlock dimm" test to repeat the unlock against a
mock memdev with a full-width serial that has bit 63 set. Refactor the
common unlock sequence into an unlock_dimm() helper so the signedness
case follows the same test flow as the original key lookup case.

Signed-off-by: Alison Schofield <alison.schofield@intel.com>
---
 test/cxl-security | 24 ++++++++++++++++++++++++
 test/security.sh  | 16 ++++++++++++++--
 2 files changed, 38 insertions(+), 2 deletions(-)

diff --git a/test/cxl-security b/test/cxl-security
index 9a28ffd82b0b..39b7e001ce08 100644
--- a/test/cxl-security
+++ b/test/cxl-security
@@ -9,6 +9,30 @@ detect()
 	[ -n "$id" ] || err "$LINENO"
 }
 
+# Select the mock memdev whose serial has bit 63 set. Match on the hex
+# spelling of 'id' because the value exceeds signed 64-bit shell arithmetic.
+# A 16-digit hex value with a leading nibble of 8-f has bit 63 set.
+detect_big_serial()
+{
+	local d i hex
+
+	dev=""
+	for d in $($NDCTL list -b "$CXL_TEST_BUS" -D | jq -r '.[].dev'); do
+		i="$($NDCTL list -b "$CXL_TEST_BUS" -D -d "$d" | \
+			jq -r '.[0].id')"
+		hex="$(printf '%x' "$i" 2>/dev/null)" || continue
+		case "${#hex}:${hex:0:1}" in
+		16:[89a-fA-F])
+			dev="$d"
+			id="$i"
+			break
+			;;
+		esac
+	done
+
+	[ -n "$dev" ] || err "$LINENO: no serial with bit 63 set found"
+}
+
 lock_dimm()
 {
 	$NDCTL disable-dimm "$dev"
diff --git a/test/security.sh b/test/security.sh
index d3a840c23276..72bb570142ed 100755
--- a/test/security.sh
+++ b/test/security.sh
@@ -144,7 +144,7 @@ test_3_security_setup_and_erase()
 	erase_security
 }
 
-test_4_security_unlock()
+unlock_dimm()
 {
 	setup_passphrase
 	lock_dimm
@@ -158,6 +158,18 @@ test_4_security_unlock()
 	remove_passphrase
 }
 
+test_4_security_unlock()
+{
+	unlock_dimm
+
+	if [ "$1" = "cxl" ] && check_min_kver "7.3"; then
+		detect_big_serial
+		unlock_dimm
+		# Restore the default device selection for later tests.
+		detect
+	fi
+}
+
 # This should always be the last nvdimm security test.
 # with security frozen, nfit_test must be removed and is no longer usable
 test_5_security_freeze()
@@ -241,7 +253,7 @@ test_2_security_setup_and_update
 echo "Test 3, security setup and erase"
 test_3_security_setup_and_erase
 echo "Test 4, unlock dimm"
-test_4_security_unlock
+test_4_security_unlock "$1"
 
 # Freeze should always be the last nvdimm security test because it locks
 # security state and require nfit_test module unload. However, this does

base-commit: 5fcbbee57319e718bf522436ea6595bd0f71296c
-- 
2.37.3

