Received: from mga18.intel.com (mga18.intel.com [134.134.136.126])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D31072CA6
	for <nvdimm@lists.linux.dev>; Wed,  5 Jan 2022 21:31:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1641418305; x=1672954305;
  h=subject:from:to:cc:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=1jf6mjMkVfAxzHE5koXGaHq5xLDtB1enGeGWwlLvxlI=;
  b=l1e9aowOhmziE2REkN361U73DCdn8QdbigPmDW582LY0BVem6dRviEK7
   E8cp5q6oRk+aHL78qvyIJugo5Kwf0Z+sSwfH0X5mc6SdZV9kcwNcVh2Wb
   J9DDPHMjmKp1e+cLsgn9jeEuRPGh3DZ98QT1KsI/HJZRaoJN77dvpgNBt
   MAB+B5uA2rhur2Zc7Ig2OixAmOv3SSThJqFCbKnPRhTUzF1JOPR42HujY
   7FcALpRe/+6hYnNUkAXnrwWtC0urvZNQX7/VL9t4KHvP/VIOkLnKBNoIo
   3/yAE0ElyaA4Iq3ScCUcgdj4ykqLSuc091AY1BSsbcA2iOCZz3K4WmZel
   A==;
X-IronPort-AV: E=McAfee;i="6200,9189,10217"; a="229353906"
X-IronPort-AV: E=Sophos;i="5.88,264,1635231600"; 
   d="scan'208";a="229353906"
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Jan 2022 13:31:45 -0800
X-IronPort-AV: E=Sophos;i="5.88,264,1635231600"; 
   d="scan'208";a="488727214"
Received: from dwillia2-desk3.jf.intel.com (HELO dwillia2-desk3.amr.corp.intel.com) ([10.54.39.25])
  by orsmga002-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Jan 2022 13:31:44 -0800
Subject: [ndctl PATCH v3 01/16] ndctl/docs: Clarify update-firwmware
 activation 'overflow' conditions
From: Dan Williams <dan.j.williams@intel.com>
To: vishal.l.verma@intel.com
Cc: nvdimm@lists.linux.dev, linux-cxl@vger.kernel.org
Date: Wed, 05 Jan 2022 13:31:44 -0800
Message-ID: <164141830490.3990253.6263569501446070716.stgit@dwillia2-desk3.amr.corp.intel.com>
In-Reply-To: <164141829899.3990253.17547886681174580434.stgit@dwillia2-desk3.amr.corp.intel.com>
References: <164141829899.3990253.17547886681174580434.stgit@dwillia2-desk3.amr.corp.intel.com>
User-Agent: StGit/0.18-3-g996c
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

Give examples and remediation for "overflow" events, i.e. where the
estimated time to complete activation exceeds the platform advertised
maximum. When that happens forced activation can lead to undefined results.

Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 Documentation/ndctl/ndctl-update-firmware.txt |   64 +++++++++++++++++++++++++
 1 file changed, 63 insertions(+), 1 deletion(-)

diff --git a/Documentation/ndctl/ndctl-update-firmware.txt b/Documentation/ndctl/ndctl-update-firmware.txt
index 1080d62a20b9..61664575f5b1 100644
--- a/Documentation/ndctl/ndctl-update-firmware.txt
+++ b/Documentation/ndctl/ndctl-update-firmware.txt
@@ -58,7 +58,69 @@ include::xable-bus-options.txt[]
 	Arm a device for firmware activation. This is enabled by default
 	when a firmware image is specified. Specify --no-arm to disable
 	this default. Otherwise, without a firmware image, this option can be
-	used to manually arm a device for firmware activate.
+	used to manually arm a device for firmware activate. When a
+	device transitions from unarmed to armed the platform recalculates the
+	firmware activation time and compares it against the maximum platform
+	supported time. If the activation time would exceed the platform maximum the
+	arm attempt is aborted:
+
+[verse]
+ndctl update-firmware --arm --bus=nfit_test.0 all
+  Error: update firmware: nmem4: arm aborted, tripped overflow
+[
+  {
+    "dev":"nmem1",
+    "id":"cdab-0a-07e0-ffffffff",
+    "handle":"0",
+    "phys_id":"0",
+    "security":"disabled",
+    "firmware":{
+      "current_version":"0",
+      "can_update":true
+    }
+  },
+  {
+    "dev":"nmem3",
+    "id":"cdab-0a-07e0-fffeffff",
+    "handle":"0x100",
+    "phys_id":"0x2",
+    "security":"disabled",
+    "firmware":{
+      "current_version":"0",
+      "can_update":true
+    }
+  },
+  {
+    "dev":"nmem2",
+    "id":"cdab-0a-07e0-feffffff",
+    "handle":"0x1",
+    "phys_id":"0x1",
+    "security":"disabled",
+    "firmware":{
+      "current_version":"0",
+      "can_update":true
+    }
+  }
+]
+updated 3 nmems.
+
+	It is possible, but not recommended, to ignore timeout overflows
+	with the --force option. At any point to view the 'armed' state of the
+	bus do:
+
+[verse]
+ndctl list -BF -b nfit_test.0
+[
+  {
+    "provider":"nfit_test.0",
+    "dev":"ndbus2",
+    "scrub_state":"idle",
+    "firmware":{
+      "activate_method":"suspend",
+      "activate_state":"overflow"
+    }
+  }
+]
 
 -D::
 --disarm::

