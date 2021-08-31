Received: from mga05.intel.com (mga05.intel.com [192.55.52.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D821772
	for <nvdimm@lists.linux.dev>; Tue, 31 Aug 2021 09:06:21 +0000 (UTC)
X-IronPort-AV: E=McAfee;i="6200,9189,10092"; a="304009046"
X-IronPort-AV: E=Sophos;i="5.84,365,1620716400"; 
   d="scan'208";a="304009046"
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 31 Aug 2021 02:05:06 -0700
X-IronPort-AV: E=Sophos;i="5.84,365,1620716400"; 
   d="scan'208";a="577062967"
Received: from msgunjal-mobl.amr.corp.intel.com (HELO vverma7-desk.amr.corp.intel.com) ([10.254.30.4])
  by orsmga004-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 31 Aug 2021 02:05:05 -0700
From: Vishal Verma <vishal.l.verma@intel.com>
To: <nvdimm@lists.linux.dev>
Cc: Dan Williams <dan.j.williams@intel.com>,
	QI Fuli <qi.fuli@jp.fujitsu.com>,
	fenghua.hu@intel.com,
	Vishal Verma <vishal.l.verma@intel.com>
Subject: [ndctl PATCH 0/7] Policy based reconfiguration for daxctl
Date: Tue, 31 Aug 2021 03:04:52 -0600
Message-Id: <20210831090459.2306727-1-vishal.l.verma@intel.com>
X-Mailer: git-send-email 2.31.1
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=3075; h=from:subject; bh=h4FdBIfv572DELcb8KK3U0j/kemNo4oPFV/wHN30UII=; b=owGbwMvMwCHGf25diOft7jLG02pJDIm6HzojDKZF3Tguonzg1IXy9HrPI7kvOGWW8VoEPzyt7+It fX5lRykLgxgHg6yYIsvfPR8Zj8ltz+cJTHCEmcPKBDKEgYtTACYiaMbIsN+XsSt/ZmB0tWUWj7ln6L MPNyILlyrrm6a7qDDzTuJUZGRYtVJeL5Df72WGfGqF7BGFQ7HdnvcED74JKLq74N7tuH52AA==
X-Developer-Key: i=vishal.l.verma@intel.com; a=openpgp; fpr=F8682BE134C67A12332A2ED07AFA61BEA3B84DFF
Content-Transfer-Encoding: 8bit

These patches add policy (config file) support to daxctl. The
introductory user is daxctl-reconfigure-device. Sysadmins may wish to
use daxctl devices as system-ram, but it may be cumbersome to automate
the reconfiguration step for every device upon boot.

Introduce a new option for daxctl-reconfigure-device, --check-config.
This is at the heart of policy based reconfiguration, as it allows
daxctl to look up reconfiguration parameters for a given device from the
config system instead of the command line.

Some systemd and udev glue then automates this for every new dax device
that shows up, providing a way for the administrator to simply list all
the 'system-ram' UUIDs in a config file, and not have to worry about
anything else.

An example config file can be:

  # cat /etc/ndctl/daxctl.conf

  [auto-online unique_identifier_foo]
  uuid = 48d8e42c-a2f0-4312-9e70-a837faafe862
  mode = system-ram
  online = true
  movable = false

Any file under '/etc/ndctl/' can be used - all files with a '.conf' suffix
will be considered when looking for matches.

These patches depend on the initial config file support from Qi Fuli[1].
A branch containing these patches is available at [2].

[1]: https://lore.kernel.org/nvdimm/20210824095106.104808-1-qi.fuli@fujitsu.com/
[2]: https://github.com/pmem/ndctl/tree/vv/daxctl_config

Vishal Verma (7):
  ndctl: Update ndctl.spec.in for 'ndctl.conf'
  daxctl: Documentation updates for persistent reconfiguration
  util/parse-config: refactor filter_conf_files into util/
  daxctl: add basic config parsing support
  util/parse-configs: add a key/value search helper
  daxctl/device.c: add an option for getting params from a config file
  daxctl: add systemd service and udev rule for auto-onlining

 .../daxctl/daxctl-reconfigure-device.txt      |  67 +++++++++
 configure.ac                                  |   9 +-
 daxctl/lib/libdaxctl.c                        |  37 +++++
 ndctl/lib/libndctl.c                          |  19 +--
 daxctl/libdaxctl.h                            |   2 +
 util/parse-configs.h                          |  19 +++
 daxctl/daxctl.c                               |   1 +
 daxctl/device.c                               | 141 +++++++++++++++++-
 util/parse-configs.c                          |  67 +++++++++
 daxctl/90-daxctl-device.rules                 |   1 +
 daxctl/Makefile.am                            |  12 ++
 daxctl/daxdev-auto-reconfigure.sh             |   3 +
 daxctl/daxdev-reconfigure@.service            |   8 +
 daxctl/lib/Makefile.am                        |   6 +
 daxctl/lib/libdaxctl.sym                      |   2 +
 ndctl.spec.in                                 |   4 +
 ndctl/lib/Makefile.am                         |   2 +
 17 files changed, 381 insertions(+), 19 deletions(-)
 create mode 100644 daxctl/90-daxctl-device.rules
 create mode 100755 daxctl/daxdev-auto-reconfigure.sh
 create mode 100644 daxctl/daxdev-reconfigure@.service


base-commit: 5f1026ef3ad108f3f5aa889ef15edae92cb5de43
-- 
2.31.1

