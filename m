Received: from mga07.intel.com (mga07.intel.com [134.134.136.100])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9C5C46D13
	for <nvdimm@lists.linux.dev>; Fri, 10 Dec 2021 22:34:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1639175694; x=1670711694;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=YSoC2bGm1LJDwQpJkOvcethn9VSSWSsiqBzjQ/r+K/Q=;
  b=jhrmil0IypUjvSCavCzhFfJYhX6Pz+vYVQ6x0xkQblcKcxukigj58kEo
   qjeK5Y/XWuvm+CEiwnmdw6TFGIPOWFnEyDdXrjXq88Bgr26MD5PtHrbSM
   iKtlCF6klES7ksFwJ3Yp6epZuoi4PxkyhnGUORgQA7yOFeQ4RNP4UOsIQ
   V+hX+5sn8bxiIrlNadBMKBqNxB+b3TkCS+XCd6C36P50Ul1YfYZAvn6E5
   v+1IWu4p+PHv4G52l7lCWAZ25ZfBo/W1LsFD4GifbyCiP4acWMwE5ap75
   Siip2j8ud5x2k/8MokZiHqynZxCsEvv8viYPtgCd3XvTHeW3NXoySXNQj
   A==;
X-IronPort-AV: E=McAfee;i="6200,9189,10194"; a="301843363"
X-IronPort-AV: E=Sophos;i="5.88,196,1635231600"; 
   d="scan'208";a="301843363"
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Dec 2021 14:34:46 -0800
X-IronPort-AV: E=Sophos;i="5.88,196,1635231600"; 
   d="scan'208";a="504113672"
Received: from fpchan-mobl1.amr.corp.intel.com (HELO vverma7-desk.amr.corp.intel.com) ([10.254.0.94])
  by orsmga007-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Dec 2021 14:34:46 -0800
From: Vishal Verma <vishal.l.verma@intel.com>
To: <nvdimm@lists.linux.dev>
Cc: Dan Williams <dan.j.williams@intel.com>,
	QI Fuli <qi.fuli@jp.fujitsu.com>,
	fenghua.hu@intel.com,
	Vishal Verma <vishal.l.verma@intel.com>
Subject: [ndctl PATCH v3 06/11] daxctl: Documentation updates for persistent reconfiguration
Date: Fri, 10 Dec 2021 15:34:35 -0700
Message-Id: <20211210223440.3946603-7-vishal.l.verma@intel.com>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211210223440.3946603-1-vishal.l.verma@intel.com>
References: <20211210223440.3946603-1-vishal.l.verma@intel.com>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=3655; h=from:subject; bh=YSoC2bGm1LJDwQpJkOvcethn9VSSWSsiqBzjQ/r+K/Q=; b=owGbwMvMwCXGf25diOft7jLG02pJDImbr/7/6bPG98uFkj/lF6dKnHKw4eHPaJq1JeLunUtu/FPn mZ9b11HKwiDGxSArpsjyd89HxmNy2/N5AhMcYeawMoEMYeDiFICJ+Fsy/M9dYfV1rn/75k8v5upu/W 0t9HdTvMDc/Mft/9xXz0x/b76TkaH5+7QXZ/j+OHWFLfE9+vHZhrp9C3/fNNn4a0qYsDZjxzR2AA==
X-Developer-Key: i=vishal.l.verma@intel.com; a=openpgp; fpr=F8682BE134C67A12332A2ED07AFA61BEA3B84DFF
Content-Transfer-Encoding: 8bit

Add a man page update describing how daxctl-reconfigure-device(1) can
be used for persistent reconfiguration of a daxctl device using a
config file.

Cc: Dan Williams <dan.j.williams@intel.com>
Reviewed-by: Dan Williams <dan.j.williams@intel.com>
Signed-off-by: Vishal Verma <vishal.l.verma@intel.com>
---
 .../daxctl/daxctl-reconfigure-device.txt      | 67 +++++++++++++++++++
 1 file changed, 67 insertions(+)

diff --git a/Documentation/daxctl/daxctl-reconfigure-device.txt b/Documentation/daxctl/daxctl-reconfigure-device.txt
index f112b3c..aa87d45 100644
--- a/Documentation/daxctl/daxctl-reconfigure-device.txt
+++ b/Documentation/daxctl/daxctl-reconfigure-device.txt
@@ -162,6 +162,15 @@ include::region-option.txt[]
 	brought online automatically and immediately with the 'online_movable'
 	policy. Use this option to disable the automatic onlining behavior.
 
+-C::
+--check-config::
+	Get reconfiguration parameters from the global daxctl config file.
+	This is typically used when daxctl-reconfigure-device is called from
+	a systemd-udevd device unit file. The reconfiguration proceeds only
+	if the match parameters in a 'reconfigure-device' section of the
+	config match the dax device specified on the command line. See the
+	'PERSISTENT RECONFIGURATION' section for more details.
+
 include::movable-options.txt[]
 
 -f::
@@ -183,6 +192,64 @@ include::human-option.txt[]
 
 include::verbose-option.txt[]
 
+PERSISTENT RECONFIGURATION
+--------------------------
+
+The 'mode' of a daxctl device is not persistent across reboots by default. This
+is because the device itself does not hold any metadata that hints at what mode
+it was set to, or is intended to be used. The default mode for such a device
+on boot is 'devdax'.
+
+The administrator may set policy such that certain dax devices are always
+reconfigured into a target configuration every boot. This is accomplished via a
+daxctl config file.
+
+The config file may have multiple sections influencing different aspects of
+daxctl operation. The section of interest for persistent reconfiguration is
+'reconfigure-device'. The format of this is as follows:
+
+----
+[reconfigure-device <unique_subsection_name>]
+nvdimm.uuid = <NVDIMM namespace uuid>
+mode = <desired reconfiguration mode> (default: system-ram)
+online = <true|false> (default: true)
+movable = <true|false> (default: true)
+----
+
+Here is an example of a config snippet for managing three devdax namespaces,
+one is left in devdax mode, the second is changed to system-ram mode with
+default options (online, movable), and the third is set to system-ram mode,
+the memory is onlined, but not movable.
+
+Note that the 'subsection name' can be arbitrary, and is only used to
+identify a specific config section. It does not have to match the 'device
+name' (e.g. 'dax0.0' etc).
+
+----
+[reconfigure-device dax0]
+nvdimm.uuid = ed93e918-e165-49d8-921d-383d7b9660c5
+mode = devdax
+
+[reconfigure-device dax1]
+nvdimm.uuid = f36d02ff-1d9f-4fb9-a5b9-8ceb10a00fe3
+mode = system-ram
+
+[reconfigure-device dax2]
+nvdimm.uuid = f36d02ff-1d9f-4fb9-a5b9-8ceb10a00fe3
+mode = system-ram
+online = true
+movable = false
+----
+
+The following example can be used to create a devdax mode namespace, and
+simultaneously add the newly created namespace to the config file for
+system-ram conversion.
+
+----
+ndctl create-namespace --mode=devdax | \
+	jq -r "\"[reconfigure-device $(uuidgen)]\", \"nvdimm.uuid = \(.uuid)\", \"mode = system-ram\"" >> $config_path
+----
+
 include::../copyright.txt[]
 
 SEE ALSO
-- 
2.33.1

