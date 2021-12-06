Received: from mga04.intel.com (mga04.intel.com [192.55.52.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E8B372CA6
	for <nvdimm@lists.linux.dev>; Mon,  6 Dec 2021 22:29:00 +0000 (UTC)
X-IronPort-AV: E=McAfee;i="6200,9189,10190"; a="236159408"
X-IronPort-AV: E=Sophos;i="5.87,292,1631602800"; 
   d="scan'208";a="236159408"
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Dec 2021 14:28:40 -0800
X-IronPort-AV: E=Sophos;i="5.87,292,1631602800"; 
   d="scan'208";a="502310409"
Received: from ponufryk-mobl1.amr.corp.intel.com (HELO vverma7-desk.amr.corp.intel.com) ([10.251.133.29])
  by orsmga007-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Dec 2021 14:28:40 -0800
From: Vishal Verma <vishal.l.verma@intel.com>
To: <nvdimm@lists.linux.dev>
Cc: Dan Williams <dan.j.williams@intel.com>,
	QI Fuli <qi.fuli@jp.fujitsu.com>,
	fenghua.hu@intel.com,
	Vishal Verma <vishal.l.verma@intel.com>
Subject: [ndctl PATCH v2 00/12] Policy based reconfiguration for daxctl
Date: Mon,  6 Dec 2021 15:28:18 -0700
Message-Id: <20211206222830.2266018-1-vishal.l.verma@intel.com>
X-Mailer: git-send-email 2.33.1
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=5652; h=from:subject; bh=LYaTqzktrAuHEtLLKqhl1gtf5ZGTDAQhawV7fbedByM=; b=owGbwMvMwCXGf25diOft7jLG02pJDInr+tqZ5FkWZxU9nhKwJq01LXtXQ/9uxpqLMkzKFz/+3VR8 0edpRykLgxgXg6yYIsvfPR8Zj8ltz+cJTHCEmcPKBDKEgYtTACai8IiR4ed/uXvMZ0/Y8H31Smp5nH FaeXfpywwdthzm0PMGv5/qtzD8L42xn+kgcyLle0ZXX1lyR0fr84tevT6LnjYJ7OzvuJXPBgA=
X-Developer-Key: i=vishal.l.verma@intel.com; a=openpgp; fpr=F8682BE134C67A12332A2ED07AFA61BEA3B84DFF
Content-Transfer-Encoding: 8bit

Changes since v1[1]:
- Collect review tags
- Fix 'make clean' removing the reconfigure script from the source tree
  (Fenghua, Qi)
- Documentation wordsmithing (Dan)
- Fix line break after declarations in parse-configs.c (Dan)
- Move daxctl config files to its own directory, /etc/daxctl/ (Dan)
- Improve failure mode in the absence of a configs directory
- Rename {nd,dax}ctl_{get|set}_configs to
  {nd,dax}ctl_{get|set}_configs_dir
- Exit with success if -C is specified, but no matching config section
  is found.
- Refuse to proceed if CLI options are passed in along with -C (Dan)
- In the config file, rename: s/[auto-online foo]/[reconfigure-device foo/
  and s/uuid/nvdimm.uuid/ (Dan)
- Teach device.c to accept /dev/daxX.Y instead of only daxX.Y and thus
  remove the need for a wrapper script that systemd invokes (Dan)

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

  [reconfigure-device unique_identifier_foo]
  nvdimm.uuid = 48d8e42c-a2f0-4312-9e70-a837faafe862
  mode = system-ram
  online = true
  movable = false

Any file under '/etc/ndctl/' can be used - all files with a '.conf' suffix
will be considered when looking for matches.

These patches depend on the initial config file support from Qi Fuli[2].

I've re-rolled Qi's original patches as the first five patches in this
series because of a change I made for graceful handling in the case of a
missing configs directory, and also to incorporate review feedback that
applied to the dependant patches. Patch 6 onwards is the actual v2 of
the daxctl policy work.

A branch containing these patches is available at [3].

[1]: https://lore.kernel.org/nvdimm/20210831090459.2306727-1-vishal.l.verma@intel.com/
[2]: https://lore.kernel.org/nvdimm/20210824095106.104808-1-qi.fuli@fujitsu.com/
[3]: https://github.com/pmem/ndctl/tree/vv/daxctl_config_v2

QI Fuli (5):
  ndctl, util: add iniparser helper
  ndctl, util: add parse-configs helper
  ndctl: make ndctl support configuration files
  ndctl, config: add the default ndctl configuration file
  ndctl, monitor: refator monitor for supporting multiple config files

Vishal Verma (7):
  ndctl: Update ndctl.spec.in for 'ndctl.conf'
  daxctl: Documentation updates for persistent reconfiguration
  util/parse-config: refactor filter_conf_files into util/
  daxctl: add basic config parsing support
  util/parse-configs: add a key/value search helper
  daxctl/device.c: add an option for getting params from a config file
  daxctl: add systemd service and udev rule for automatic
    reconfiguration

 .../daxctl/daxctl-reconfigure-device.txt      |  75 ++
 Documentation/ndctl/ndctl-monitor.txt         |   8 +-
 configure.ac                                  |  18 +-
 Makefile.am                                   |   8 +-
 ndctl/lib/private.h                           |   1 +
 daxctl/lib/libdaxctl.c                        |  39 +
 ndctl/lib/libndctl.c                          |  39 +
 daxctl/libdaxctl.h                            |   2 +
 ndctl/libndctl.h                              |   2 +
 util/dictionary.h                             | 175 ++++
 util/iniparser.h                              | 360 ++++++++
 util/parse-configs.h                          |  53 ++
 daxctl/daxctl.c                               |   1 +
 daxctl/device.c                               | 174 +++-
 ndctl/monitor.c                               |  73 +-
 ndctl/ndctl.c                                 |   1 +
 util/dictionary.c                             | 383 ++++++++
 util/iniparser.c                              | 838 ++++++++++++++++++
 util/parse-configs.c                          | 150 ++++
 Documentation/daxctl/Makefile.am              |  11 +-
 Documentation/ndctl/Makefile.am               |   2 +-
 daxctl/90-daxctl-device.rules                 |   1 +
 daxctl/Makefile.am                            |   9 +
 daxctl/daxdev-reconfigure@.service            |   8 +
 daxctl/lib/Makefile.am                        |   6 +
 daxctl/lib/libdaxctl.sym                      |   2 +
 ndctl.spec.in                                 |   4 +
 ndctl/Makefile.am                             |   9 +-
 ndctl/lib/Makefile.am                         |   6 +
 ndctl/lib/libndctl.sym                        |   2 +
 ndctl/ndctl.conf                              |  56 ++
 31 files changed, 2467 insertions(+), 49 deletions(-)
 create mode 100644 util/dictionary.h
 create mode 100644 util/iniparser.h
 create mode 100644 util/parse-configs.h
 create mode 100644 util/dictionary.c
 create mode 100644 util/iniparser.c
 create mode 100644 util/parse-configs.c
 create mode 100644 daxctl/90-daxctl-device.rules
 create mode 100644 daxctl/daxdev-reconfigure@.service
 create mode 100644 ndctl/ndctl.conf


base-commit: 4e646fa490ba4b782afa188dd8818b94c419924e
-- 
2.33.1

