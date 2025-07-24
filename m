Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E0920246782
	for <nvdimm@lists.linux.dev>; Thu, 24 Jul 2025 22:16:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753395373; cv=none; b=XtfkhwjRscePZtcxqDtmWqPz/I/sqdTiEh4h5z8vztgED5e9xg0rH9MoehFgld10783memZakm7X9FAjS15m77lsvg98sqY/aqvNBQtn/qFOsfG/6J1J0/uHUt0lQyb+3a7jmQrJMWZWhrnFubXgy6GtX2q+XOOxPOtyMYGMh3g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753395373; c=relaxed/simple;
	bh=yQwrgVBQA3NOFo1CbCy+cQWmg65yV2ti/DEfrI/EY6E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dcY4PwIrQIodSL67c/vOMIcg1x3TFsvfJtLKMu/A4u45wvYldB86H+1ZeM3emqPx15JvIh3+1E0/FdNlsPduBezY1qbTZ3HR0omnBiw/tZngs2EsnQ9anwLqo6rthdH8P7W1vAaLgE4yXkE6hE0mDI//qQ26LXa/pZOzBSV9OJE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=SS8XHEe7; arc=none smtp.client-ip=192.198.163.18
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="SS8XHEe7"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1753395372; x=1784931372;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=yQwrgVBQA3NOFo1CbCy+cQWmg65yV2ti/DEfrI/EY6E=;
  b=SS8XHEe7cRsGJ2vOlQc1J24AO2usIc+nHRNMPXQ2fK74mtB0Dy77yG1Z
   k26oGirq2g8gqQVolLmoUMJMVGBQpngBkoWABcpOL+UnjmR0JaephtJES
   tnedEk/YmjRiO69sKC9xv2Z40skRPP1fieRat0Cn9qtaA3JURSM6l3m7v
   /raMneHFiOf1LXWhdmTiWNrfVlBfSedxUukq89cuAmobXRrFgzQER0lEu
   Nc3B/HFalW50/aYDN2WRW6s8R08oWHOMEz/YOy2H17L8HP1OoZqDXtukG
   bYQUtfA4oTq7x/ERAHFAGuDJS43hDGO77j90FcmVA5Vb+23bVsdyG0Nfs
   w==;
X-CSE-ConnectionGUID: aUQ8Zi/lQrqibcacBYXDSg==
X-CSE-MsgGUID: MPg0JTY3TgqgUyEMujTHpw==
X-IronPort-AV: E=McAfee;i="6800,10657,11501"; a="54941698"
X-IronPort-AV: E=Sophos;i="6.16,337,1744095600"; 
   d="scan'208";a="54941698"
Received: from fmviesa006.fm.intel.com ([10.60.135.146])
  by fmvoesa112.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Jul 2025 15:16:11 -0700
X-CSE-ConnectionGUID: FPgesz45S4+4GnCuc+iyRA==
X-CSE-MsgGUID: UmZmlNZXS96BraSYcvjAVw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.16,337,1744095600"; 
   d="scan'208";a="160504474"
Received: from unknown (HELO hyperion.jf.intel.com) ([10.243.61.29])
  by fmviesa006-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Jul 2025 15:16:11 -0700
From: marc.herbert@linux.intel.com
To: linux-cxl@vger.kernel.org,
	nvdimm@lists.linux.dev,
	alison.schofield@intel.com,
	dan.j.williams@intel.com,
	dave.jiang@intel.com
Cc: Marc Herbert <marc.herbert@linux.intel.com>
Subject: [ndctl PATCH 1/3] test/common: add missing quotes
Date: Thu, 24 Jul 2025 22:00:44 +0000
Message-ID: <20250724221323.365191-2-marc.herbert@linux.intel.com>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250724221323.365191-1-marc.herbert@linux.intel.com>
References: <20250724221323.365191-1-marc.herbert@linux.intel.com>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Marc Herbert <marc.herbert@linux.intel.com>

This makes shellcheck much happier and its output readable and usable.

Signed-off-by: Marc Herbert <marc.herbert@linux.intel.com>
---
 test/common | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/test/common b/test/common
index 75ff1a6e12be..2d8422f26436 100644
--- a/test/common
+++ b/test/common
@@ -4,7 +4,7 @@
 # Global variables
 
 # NDCTL
-if [ -z $NDCTL ]; then
+if [ -z "$NDCTL" ]; then
 	if [ -f "../ndctl/ndctl" ] && [ -x "../ndctl/ndctl" ]; then
 		export NDCTL=../ndctl/ndctl
 	elif [ -f "./ndctl/ndctl" ] && [ -x "./ndctl/ndctl" ]; then
@@ -16,7 +16,7 @@ if [ -z $NDCTL ]; then
 fi
 
 # DAXCTL
-if [ -z $DAXCTL ]; then
+if [ -z "$DAXCTL" ]; then
 	if [ -f "../daxctl/daxctl" ] && [ -x "../daxctl/daxctl" ]; then
 		export DAXCTL=../daxctl/daxctl
 	elif [ -f "./daxctl/daxctl" ] && [ -x "./daxctl/daxctl" ]; then
@@ -28,7 +28,7 @@ if [ -z $DAXCTL ]; then
 fi
 
 # CXL
-if [ -z $CXL ]; then
+if [ -z "$CXL" ]; then
 	if [ -f "../cxl/cxl" ] && [ -x "../cxl/cxl" ]; then
 		export CXL=../cxl/cxl
 	elif [ -f "./cxl/cxl" ] && [ -x "./cxl/cxl" ]; then
@@ -39,7 +39,7 @@ if [ -z $CXL ]; then
 	fi
 fi
 
-if [ -z $TEST_PATH ]; then
+if [ -z "$TEST_PATH" ]; then
 	export TEST_PATH=.
 fi
 
@@ -103,7 +103,7 @@ check_min_kver()
 #
 do_skip()
 {
-	echo kernel $(uname -r): $1
+	echo kernel "$(uname -r)": "$1"
 	exit 77
 }
 
@@ -147,7 +147,7 @@ check_dmesg()
 	# validate no WARN or lockdep report during the run
 	sleep 1
 	log=$(journalctl -r -k --since "-$((SECONDS+1))s")
-	grep -q "Call Trace" <<< $log && err $1
+	grep -q "Call Trace" <<< "$log" && err "$1"
 	true
 }
 
-- 
2.50.1

