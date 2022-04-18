Received: from mga09.intel.com (mga09.intel.com [134.134.136.24])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 00F3AA41
	for <nvdimm@lists.linux.dev>; Mon, 18 Apr 2022 18:53:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1650308033; x=1681844033;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=+W7n8lP/UyKuGWEM4NvsiKWSYCXVmGmB9Yo8YrN3x0Y=;
  b=ad4mAxz6EB3XplhIKnG/OA1oBATDZ84g9cs36xB/bONQ9VOvHLFWDD9G
   ZG3dPNu9UlW32iJvTXP7J5T0HYB+MKQO0Rm4F+tVnJBGAT7h9DKYs1Fjv
   PRUviOawZcw+xzLxuGkuaOyOZ/+FzIeJvzsxzffBofikNxONP8dCzUolu
   wqO/PTM804vjJV+Tc2crYoLVyDzlPIAVyop50wcfDSOByGdntfMdxqoca
   uGrCKMcynzS3nhLv3FgXem2IBH+yYYuL1FdH1JnOzaZpQyf9B7b8OTtl1
   KSu8y3Kl3yBPmeQQkzrgrJeW+pfxv42bsA4Td+IOOrym0zGjl5ipcUeR/
   g==;
X-IronPort-AV: E=McAfee;i="6400,9594,10321"; a="263051586"
X-IronPort-AV: E=Sophos;i="5.90,270,1643702400"; 
   d="scan'208";a="263051586"
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Apr 2022 11:53:52 -0700
X-IronPort-AV: E=Sophos;i="5.90,270,1643702400"; 
   d="scan'208";a="665391915"
Received: from prajbhan-mobl.amr.corp.intel.com (HELO vverma7-desk1.intel.com) ([10.209.19.41])
  by orsmga004-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Apr 2022 11:53:52 -0700
From: Vishal Verma <vishal.l.verma@intel.com>
To: <nvdimm@lists.linux.dev>
Cc: Vishal Verma <vishal.l.verma@intel.com>,
	Dan Williams <dan.j.williams@intel.com>,
	Chunhong Mao <chunhong.mao@intel.com>
Subject: [ndctl PATCH] daxctl: fix systemd escaping for 90-daxctl-device.rules
Date: Mon, 18 Apr 2022 12:53:36 -0600
Message-Id: <20220418185336.1192330-1-vishal.l.verma@intel.com>
X-Mailer: git-send-email 2.35.1
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=1325; h=from:subject; bh=+W7n8lP/UyKuGWEM4NvsiKWSYCXVmGmB9Yo8YrN3x0Y=; b=owGbwMvMwCXGf25diOft7jLG02pJDEmxmxffW6MYFvhfJulehm78zXnhpfd3bo+a/XjlAYmJX/8k yX1I7ShlYRDjYpAVU2T5u+cj4zG57fk8gQmOMHNYmUCGMHBxCsBEPmxg+KfM++2YXYbY1VP1feKLmQ uaz1rflEpx8fldv7jkod/VFg6G/xnhNmW/J1Xx1LaWJ1Ztnel9wOFVYMD7K18szu1e53b0KScA
X-Developer-Key: i=vishal.l.verma@intel.com; a=openpgp; fpr=F8682BE134C67A12332A2ED07AFA61BEA3B84DFF
Content-Transfer-Encoding: 8bit

Older systemd was more tolerant of how unit names are passed in for
instantiated services via a udev rule, but of late, systemd flags
unescaped unit names, with an error such as:

  fedora systemd[1]: Invalid unit name "daxdev-reconfigure@/dev/dax0.0.service"
  escaped as "daxdev-reconfigure@-dev-dax0.0.service" (maybe you should use
  systemd-escape?).

Update the udev rule to pass the 'DEVNAME' from env through an
appropriate systemd-escape template so that it generates the correctly
escaped string.

Cc: Dan Williams <dan.j.williams@intel.com>
Reported-by: Chunhong Mao <chunhong.mao@intel.com>
Signed-off-by: Vishal Verma <vishal.l.verma@intel.com>
---
 daxctl/90-daxctl-device.rules | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/daxctl/90-daxctl-device.rules b/daxctl/90-daxctl-device.rules
index ee0670f..e02e7ec 100644
--- a/daxctl/90-daxctl-device.rules
+++ b/daxctl/90-daxctl-device.rules
@@ -1 +1,3 @@
-ACTION=="add", SUBSYSTEM=="dax", TAG+="systemd", ENV{SYSTEMD_WANTS}="daxdev-reconfigure@$env{DEVNAME}.service"
+ACTION=="add", SUBSYSTEM=="dax", TAG+="systemd",\
+  PROGRAM="/usr/bin/systemd-escape -p --template=daxdev-reconfigure@.service $env{DEVNAME}",\
+  ENV{SYSTEMD_WANTS}="%c"

base-commit: 97031db9300654260bc2afb45b3600ac01beaeba
-- 
2.35.1

