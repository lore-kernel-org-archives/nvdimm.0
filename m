Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=198.175.65.13
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795055695;
	b=j7+3xxIphvnCM51xkLPYE4qj+9Bip8L4ZT5bVdwtzScikjvIkDJuigbtwS8mTk32rHRB
	 rgv5UbtZHid+YyApQiLAzyHpGMM5lxzE1OzjETqHOwEjM1UzUIk3+O4tWYu3NtozBqxPJ
	 KF3Io4Ldi0b6kUaDLS6tx2NFETAqnZLeD6f4ui2SfP6mk9PWjJ1IKcvXYuoe7DIjT4AWd
	 LRZrBFVufzSPCW2gGiNPlQNPDElm3p2xTMYa73NA1subnT8E8dA5tsDqgxPE4iCDFa+Xe
	 V0Yvmhm4aYuheEeXvJhGGCfFJT6/Ukn4S0rRRu7RIYo+b8D7YGzbuPo8xBKkGYaZp3g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795055695;
	h=DMARC-Filter:DKIM-Signature:X-CSE-ConnectionGUID:X-CSE-MsgGUID:
	 X-IronPort-AV:X-IronPort-AV:Received:X-CSE-ConnectionGUID:
	 X-CSE-MsgGUID:X-ExtLoop1:X-IronPort-AV:Received:From:To:Cc:Subject:
	 Date:Message-ID:X-Mailer:MIME-Version:Content-Transfer-Encoding;
	bh=ghnanafWrP0aDbrGWUwgZGLGsBRem5J0W1O38cQKR84=;
	b=k+MMIaqfxKM8fu8f8pr/+6v554gWLO66AsxYwt0/nwjfXo/6e9RJzt/Af4S5GOzb9xZZ
	 rOCaSHM6wg4PwIuIGcL4HrgZTMEsTIaNXbDYvwu8a8dKh6nXE23My1aLC5gB7bmQxaI09
	 ryz0fsa/2uGq4fO3uY2ioVd8OfzwNK1tHv4VoWmBrXytjkpK8y1N/T5zk/1a8UuCGYI4C
	 x7RXbs5XXPS7XVjgoCMIzhUjQ5Ox1hgWtcYfdIshknh9Bp3aABzo6dvARw5v1eVHTgLX+
	 a/Kwwo7DOYgBrbZrqUQnpq+DCQMrP2419h3Ej/KzHPnVDX69sxgVp+VIJGO6Uz96b1Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=intel.com;
	spf=pass smtp.mailfrom=intel.com;
	dkim=pass header.d=intel.com header.i=@intel.com header.a=rsa-sha256 header.s=Intel header.b=UKx+W7ip;
	arc=none smtp.remote-ip=198.175.65.13
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.13])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D504E606A32A
	for <nvdimm@lists.linux.dev>; Thu, 19 Nov 2026 02:34:54 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org D504E606A32A
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.a=rsa-sha256 header.s=Intel header.b=UKx+W7ip
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1795055695; x=1826591695;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=UA3CHpuWQPJgg5DXzlDX3J5AGTMJEaz0z8L/t9OUQFk=;
  b=UKx+W7ipV+u2elACofCB+IDmhvGV1eOJ8LQJieeLsvIv6OxkPg0BC8Ta
   tIgv++1XJqjSUVQf8Wgs16FbibILvNwrKhAHqUgcp/5UE7U2g8BSCqswM
   RNRZgnMDbSFb3e3qR+qjyhsRK9ehY8F09ESTjlv+xTTQkFCexKiHOD5M2
   AJzqx0J2gVPENAZP4ZZo2g9z6hdbKFMJmM3E4RlGoxEnQ2j99T+kH/hT+
   HIO74L2bxyUtMbU1hIwvw1cFrcA4ikj67cvyyYjIz0TCOuYMXxPovta+H
   lnkH20VlVqD+EMSKA3/+l6lsrNtOjImI/k0UFxnyd4mN8TbBWLuKS019Z
   g==;
X-CSE-ConnectionGUID: b9M8h6RtS3qOofqaX1617Q==
X-CSE-MsgGUID: U6xeXOoaSeqPbTT0RZFpeg==
X-IronPort-AV: E=McAfee;i="6800,10657,11970"; a="3779783"
X-IronPort-AV: E=Sophos;i="6.27,220,1787036400"; 
   d="scan'208";a="3779783"
Received: from orviesa006.jf.intel.com ([10.64.159.146])
  by orvoesa105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Nov 2026 18:34:55 -0800
X-CSE-ConnectionGUID: HmDnW+b9Rb+Y52OIRjJZ+A==
X-CSE-MsgGUID: KQi6GbSVRVuqTpiFjXb8QA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.27,220,1787036400"; 
   d="scan'208";a="10303076"
Received: from aschofie-mobl2.amr.corp.intel.com (HELO localhost) ([10.125.109.20])
  by smtpauth.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Nov 2026 18:34:55 -0800
From: Alison Schofield <alison.schofield@intel.com>
To: nvdimm@lists.linux.dev
Cc: Alison Schofield <alison.schofield@intel.com>
Subject: [ndctl PATCH] test/common: make kernel version checks RC-aware
Date: Wed, 18 Nov 2026 18:34:48 -0800
Message-ID: <20261119023451.165214-1-alison.schofield@intel.com>
X-Mailer: git-send-email 2.47.0
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Post: <mailto:nvdimm@lists.linux.dev>
List-Help: <mailto:nvdimm+help@lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
List-Owner: <mailto:nvdimm+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

check_min_kver() ignores RC numbers. When a kernel fix lands during an RC
cycle, tests that depend on it use the next kernel release as their
minimum. This avoids failures on earlier RCs but delays CI coverage after
the fix is available.

Honor explicit X.Y-rcN minimums so CI can run a test starting with the
first RC that contains the fix. A bare X.Y minimum continues to accept all
RCs in that cycle.

Signed-off-by: Alison Schofield <alison.schofield@intel.com>
---

This came up recently as we have a test case for a kernel fix that is
expected to be in 7.4-rc4. This change supports exercising that test
case asap, rather than waiting for 7.5-rc1.


 test/common | 40 ++++++++++++++++++++++++++++++++++++----
 1 file changed, 36 insertions(+), 4 deletions(-)

diff --git a/test/common b/test/common
index d60d9e046445..ed533cd92a42 100644
--- a/test/common
+++ b/test/common
@@ -89,16 +89,48 @@ reset1()
 }
 
 
+# __kver_key
+# $1: Kernel version in X.Y[.Z][-rcN] format, trailing text is ignored
+# $2: RC number to use when $1 has no -rc suffix
+#
+# Print a fixed-width key with four digits per field and a missing Z
+# treated as 0. Reserve RC value 9999 for final releases so they sort
+# after their RCs. A minimum without -rcN uses 0 so it accepts every
+# RC of that version.
+#
+__kver_key()
+{
+	local re='^([0-9]+)\.([0-9]+)(\.([0-9]+))?(-rc([0-9]+))?'
+	local i
+
+	[[ "$1" =~ $re ]] || return 1
+	for i in 1 2 4 6; do
+		(( ${#BASH_REMATCH[i]} <= 4 )) || return 1
+	done
+	(( 10#${BASH_REMATCH[6]:-0} < 9999 )) || return 1
+	printf "%04d%04d%04d%04d" \
+		"$((10#${BASH_REMATCH[1]}))" "$((10#${BASH_REMATCH[2]}))" \
+		"$((10#${BASH_REMATCH[4]:-0}))" "$((10#${BASH_REMATCH[6]:-$2}))"
+}
+
 # check_min_kver
-# $1: Supported kernel version. format: X.Y
+# $1: Minimum kernel version in X.Y[.Z][-rcN] format
+#
+# X.Y passes from X.Y-rc1 on. Use X.Y-rcN to set a specific RC as
+# the minimum. The argument must match the full version format above.
 #
 check_min_kver()
 {
-	local ver="$1"
+	local want have
 	: "${KVER:=$(uname -r)}"
 
-	[ -n "$ver" ] || return 1
-	[[ "$ver" == "$(echo -e "$ver\n$KVER" | sort -V | head -1)" ]]
+	if [[ ! "$1" =~ ^[0-9]+\.[0-9]+(\.[0-9]+)?(-rc[0-9]+)?$ ]]; then
+		echo "test/$test_basename: invalid kernel version '$1'" >&2
+		return 1
+	fi
+	want=$(__kver_key "$1" 0) || return 1
+	have=$(__kver_key "$KVER" 9999) || return 1
+	(( 10#$have >= 10#$want ))
 }
 
 # check_eq_kver
-- 
2.37.3

