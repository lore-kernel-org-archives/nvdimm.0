Received: from mga05.intel.com (mga05.intel.com [192.55.52.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 33A1E72
	for <nvdimm@lists.linux.dev>; Tue, 31 Aug 2021 09:06:17 +0000 (UTC)
X-IronPort-AV: E=McAfee;i="6200,9189,10092"; a="304009051"
X-IronPort-AV: E=Sophos;i="5.84,365,1620716400"; 
   d="scan'208";a="304009051"
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 31 Aug 2021 02:05:07 -0700
X-IronPort-AV: E=Sophos;i="5.84,365,1620716400"; 
   d="scan'208";a="577062985"
Received: from msgunjal-mobl.amr.corp.intel.com (HELO vverma7-desk.amr.corp.intel.com) ([10.254.30.4])
  by orsmga004-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 31 Aug 2021 02:05:06 -0700
From: Vishal Verma <vishal.l.verma@intel.com>
To: <nvdimm@lists.linux.dev>
Cc: Dan Williams <dan.j.williams@intel.com>,
	QI Fuli <qi.fuli@jp.fujitsu.com>,
	fenghua.hu@intel.com,
	Vishal Verma <vishal.l.verma@intel.com>
Subject: [ndctl PATCH 2/7] daxctl: Documentation updates for persistent reconfiguration
Date: Tue, 31 Aug 2021 03:04:54 -0600
Message-Id: <20210831090459.2306727-3-vishal.l.verma@intel.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210831090459.2306727-1-vishal.l.verma@intel.com>
References: <20210831090459.2306727-1-vishal.l.verma@intel.com>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=3612; h=from:subject; bh=RfUOYLapCL32N/uEHfAt+tPaxQZWaJ1SNP7jJGd1Ju8=; b=owGbwMvMwCHGf25diOft7jLG02pJDIm6H1ZsE5NLXR3muyub4a79Y/Ml/Ut6tgu0FrnOt07elWPB PmFGRykLgxgHg6yYIsvfPR8Zj8ltz+cJTHCEmcPKBDKEgYtTACbSVsjI0Fry1Ljl/zxV02Zraeu8T7 P+dS/WvN/2o5zlmeod7Wr9KkaG1U5bRM+8ca1m+5T0t5uJIXq/80O3TRbSPVqPQ1z8S3fxAQA=
X-Developer-Key: i=vishal.l.verma@intel.com; a=openpgp; fpr=F8682BE134C67A12332A2ED07AFA61BEA3B84DFF
Content-Transfer-Encoding: 8bit

Add a man page update describing how daxctl-reconfigure-device(1) can
be used for persistent reconfiguration of a daxctl device using a
config file.

Cc: Dan Williams <dan.j.williams@intel.com>
Signed-off-by: Vishal Verma <vishal.l.verma@intel.com>
---
 .../daxctl/daxctl-reconfigure-device.txt      | 67 +++++++++++++++++++
 1 file changed, 67 insertions(+)

diff --git a/Documentation/daxctl/daxctl-reconfigure-device.txt b/Documentation/daxctl/daxctl-reconfigure-device.txt
index f112b3c..1e2d380 100644
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
+	if the UUID of the dax device passed in on the command line matches
+	a UUID listed in the auto-online section of the config. See the
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
+is because the device itself may hold any metadata that hints at what mode it
+was set to, or is intended to be used in. The default mode for such a device
+is 'devdax', and on reboot, that is the mode devices appear in by default.
+
+The administrator may desire to configure the system in a way that certain
+dax devices are always reconfigured into a certain mode every time on boot.
+This is accomplished via a daxctl config file located at [location TBD].
+
+The config file may have multiple sections influencing different aspects of
+daxctl operation. The section of interest for persistent reconfiguration is
+'auto-online'. The format of this is as follows:
+
+----
+[auto-online <subsection_name>]
+uuid = <namespace uuid>
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
+[auto-online dax0]
+uuid = ed93e918-e165-49d8-921d-383d7b9660c5
+mode = devdax
+
+[auto-online dax1]
+uuid = f36d02ff-1d9f-4fb9-a5b9-8ceb10a00fe3
+mode = system-ram
+
+[auto-online dax2]
+uuid = f36d02ff-1d9f-4fb9-a5b9-8ceb10a00fe3
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
+	jq -r "\"[auto-online $(uuidgen)]\", \"uuid = \(.uuid)\", \"mode = system-ram\"" >> $config_path
+----
+
 include::../copyright.txt[]
 
 SEE ALSO
-- 
2.31.1

