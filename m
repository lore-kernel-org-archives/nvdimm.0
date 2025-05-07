Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.13])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 09661215197
	for <nvdimm@lists.linux.dev>; Wed,  7 May 2025 16:16:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.13
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746634583; cv=none; b=nNwavaobcOAxa5VrVR821A3UfNMMjrdj3wgPPTj1hHnukpg1pzWz1ZDSaeiKF2sLxfGk8pGzu5IUkKzBoUZtAcaSK4lo24otqaM4XA199mLXq+PEZa69xriEK/lri8vj+HrFfF0c1myDCCziWtZtWwS4UAFt+eLpSN0m2xeTvzY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746634583; c=relaxed/simple;
	bh=2MZMhW9Y8Pf1lcggUgtVHtJLiN59ZqRd+Sby9HwmQPc=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=GK3oHalkIQ+ri7Gah49AmwEEMdj9DgMmuM6VIOKocAhbyxhXJsjCT1tJdm210fu8+c/ABGi+n20p08CQjXVoTtUeowCi7a4RkcD+ozMVVvTL5RHMky7/65efF/loJOgdxHca1G8EAaCmXoomTii6DcFneddUywAVeBZ+7gAcJAw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=c1g30PLl; arc=none smtp.client-ip=198.175.65.13
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="c1g30PLl"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1746634581; x=1778170581;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=2MZMhW9Y8Pf1lcggUgtVHtJLiN59ZqRd+Sby9HwmQPc=;
  b=c1g30PLl5qo43pSfKs+aGdKMmKLAVU+L8xwo0AYXbS3S7zT38po6B11/
   pvnUZhAyRZgGaOS1/dEWBq28MWR+4t3G8vaZqYFd7iAmDmdXvyl+n/KSN
   JNhiQXWJVwm5YTrgj3kS9ovAe0/765DLfD6+JVkof3qNjg3MUhhvviENJ
   l5IwUVZa5+BdrC9l/0dJt973VjN5ZRyYktFY6z72szQ3rtUE1GIa8WX9m
   7Agugcmu1HrIYLSZlZ80hAMQ6bOoROyGpmR1aoVeRMndlHu63RqVN8XRP
   c3/fW39YbO1BM7Itw3UIgPg8nrPo9gSjFJ2Zc1NCsQxWT6+E3EPC4P0rs
   w==;
X-CSE-ConnectionGUID: gMT2HxsVSPWw9Ox7/KhevQ==
X-CSE-MsgGUID: qZ3dQMIxSSmnrlfY/l2j4g==
X-IronPort-AV: E=McAfee;i="6700,10204,11426"; a="59366115"
X-IronPort-AV: E=Sophos;i="6.15,269,1739865600"; 
   d="scan'208";a="59366115"
Received: from orviesa010.jf.intel.com ([10.64.159.150])
  by orvoesa105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 May 2025 09:16:20 -0700
X-CSE-ConnectionGUID: qx4UuqBsTWmLH4ytDtlaJQ==
X-CSE-MsgGUID: 5kAqDsvRRaaehfnb1icghg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.15,269,1739865600"; 
   d="scan'208";a="135872552"
Received: from unknown (HELO hyperion.jf.intel.com) ([10.243.61.29])
  by orviesa010-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 May 2025 09:16:21 -0700
From: marc.herbert@linux.intel.com
To: linux-cxl@vger.kernel.org,
	nvdimm@lists.linux.dev
Cc: Marc Herbert <marc.herbert@linux.intel.com>
Subject: [PATCH] test/meson.build: add missing 'CXL=@0@'.format(cxl_tool.full_path()),
Date: Wed,  7 May 2025 16:15:15 +0000
Message-ID: <20250507161547.204216-1-marc.herbert@linux.intel.com>
X-Mailer: git-send-email 2.49.0
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Marc Herbert <marc.herbert@linux.intel.com>

This fixes the ability to copy and paste the helpful meson output when a
test fails, in order to re-run a failing test directly outside meson and
from any current directory.

meson never had that problem because it always switches to a constant
directory before running the tests.

Fixes commit ef85ab79e7a4 ("cxl/test: Add topology enumeration and
hotplug test") which added the (failing) search for the cxl binary.

Signed-off-by: Marc Herbert <marc.herbert@linux.intel.com>
---
 test/meson.build | 1 +
 1 file changed, 1 insertion(+)

diff --git a/test/meson.build b/test/meson.build
index d871e28e17ce..2fd7df5211dd 100644
--- a/test/meson.build
+++ b/test/meson.build
@@ -255,6 +255,7 @@ foreach t : tests
     env : [
       'NDCTL=@0@'.format(ndctl_tool.full_path()),
       'DAXCTL=@0@'.format(daxctl_tool.full_path()),
+      'CXL=@0@'.format(cxl_tool.full_path()),
       'TEST_PATH=@0@'.format(meson.current_build_dir()),
       'DATA_PATH=@0@'.format(meson.current_source_dir()),
     ],
-- 
2.49.0

