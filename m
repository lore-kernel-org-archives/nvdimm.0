Received: from mga07.intel.com (mga07.intel.com [134.134.136.100])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 08D942CBE
	for <nvdimm@lists.linux.dev>; Fri, 10 Dec 2021 22:34:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1639175691; x=1670711691;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=hqvUumvPcO2SeQee+se9e7O8v+KD7zGMuuPVpnA1fKo=;
  b=CcWZgnOUFi5AyReJ0Y3ZJhutH48EHs388H4J3WyQBHET6MNZcuZXaAhz
   vA4XoBWCoPtMXGoj3aF3uUW3PVYWWVkNLXwrPuY+SKtjmdx8M2U7qvyof
   +fVZ4l3EEOzXTVI2Vo/qRZ6QmbWvE13tf94g6jhshSiI3cxJew6LGDkeY
   RavZWK5o03HLjFknCpP9jmPYz0OWDiY22yDTERo1oVoxnGvA2WJlpoYEq
   FJhDAzxBqI0hFDTl7NZk37UmJ04RMN1typqmn5dVq6XFzZF7L6HudJ627
   Kgg7mzctrsrETAIg0+pl4f1l7G6BbYcM8LHsf+h335CBv1UufjsLGDai/
   w==;
X-IronPort-AV: E=McAfee;i="6200,9189,10194"; a="301843338"
X-IronPort-AV: E=Sophos;i="5.88,196,1635231600"; 
   d="scan'208";a="301843338"
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Dec 2021 14:34:43 -0800
X-IronPort-AV: E=Sophos;i="5.88,196,1635231600"; 
   d="scan'208";a="504113640"
Received: from fpchan-mobl1.amr.corp.intel.com (HELO vverma7-desk.amr.corp.intel.com) ([10.254.0.94])
  by orsmga007-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Dec 2021 14:34:43 -0800
From: Vishal Verma <vishal.l.verma@intel.com>
To: <nvdimm@lists.linux.dev>
Cc: Dan Williams <dan.j.williams@intel.com>,
	QI Fuli <qi.fuli@jp.fujitsu.com>,
	fenghua.hu@intel.com,
	Vishal Verma <vishal.l.verma@intel.com>
Subject: [ndctl PATCH v3 00/11] Policy based reconfiguration for daxctl
Date: Fri, 10 Dec 2021 15:34:29 -0700
Message-Id: <20211210223440.3946603-1-vishal.l.verma@intel.com>
X-Mailer: git-send-email 2.33.1
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=5224; h=from:subject; bh=hqvUumvPcO2SeQee+se9e7O8v+KD7zGMuuPVpnA1fKo=; b=owGbwMvMwCXGf25diOft7jLG02pJDImbr759c7Skn9vmtH+W7NF/L1UyQ2/pLZ90cnrkTiMR7/0v l1RHdZSyMIhxMciKKbL83fOR8Zjc9nyewARHmDmsTCBDGLg4BWAilT4M/+wdjnJ6n9SL6RPvOurcdc jTUU8w8LrLZ6s57Bn5q/N+f2b4K5ig/GfKY2XhFU+lWOJeG+n4iiTrt38RChZ1vbj1/wp1TgA=
X-Developer-Key: i=vishal.l.verma@intel.com; a=openpgp; fpr=F8682BE134C67A12332A2ED07AFA61BEA3B84DFF
Content-Transfer-Encoding: 8bit

Changes since v2[1]:
- Remove stale Link: trailers from commit messages (Dan)
- Link to the iniparser library already packaged by distros instead of
  forking it (Dan).
- Improve commit message for "ndctl, util: add parse-configs helper"
  (Dan)
- Squash "util/parse-config: refactor filter_conf_files into util/" into
  the original patch it modifies since I'm modifying Qi's original
  patchset anyway
- Rename {ndctl,daxctl}_{get,set}_configs_dir to
  {ndctl,daxctl}_{get,set}_config_path (Dan)
- Replace {ndctl,daxctl}_ctx ** ctx with *ctx respectively, as the
  former is unnecessary. (Dan)
- Allow *_set_config_path() to return errors (Dan)
- Move {ndctl,daxctl}_set_config_path into {ndctl,daxctl}_new (Dan)
- Update config paths to {sysconfdir}/{ndctl,daxctl}.conf.d/  (Dan)
- Move the config_path scandir() call deeper in the stack so we don't
  have to store scandir results anywhere, and so that it is run just
  before the config parsing happens. This way the only thing that's
  stored in 'ctx' is the config_path itself, and lib{nd,dax}ctl are
  freed of having to link to GPL utils such as util/strbuf.  (Dan)


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

  # cat /etc/daxctl.conf.d/daxctl.conf

  [reconfigure-device unique_identifier_foo]
  nvdimm.uuid = 48d8e42c-a2f0-4312-9e70-a837faafe862
  mode = system-ram
  online = true
  movable = false

Any file under '/etc/daxctl.conf.d/' can be used - all files with a
'.conf' suffix will be considered when looking for matches.

These patches depend on the initial config file support from Qi Fuli,
which is included here after some modifications from review feedback.

A branch containing these patches is available at [2].

[1]: https://lore.kernel.org/nvdimm/20211206222830.2266018-1-vishal.l.verma@intel.com/
[2]: https://github.com/pmem/ndctl/tree/vv/daxctl_config_v3


QI Fuli (4):
  ndctl, util: add parse-configs helper
  ndctl: make ndctl support configuration files
  ndctl, config: add the default ndctl configuration file
  ndctl, monitor: refator monitor for supporting multiple config files

Vishal Verma (7):
  ndctl: Update ndctl.spec.in for 'ndctl.conf'
  daxctl: Documentation updates for persistent reconfiguration
  daxctl: add basic config parsing support
  util/parse-configs: add a key/value search helper
  daxctl/device.c: add an option for getting params from a config file
  daxctl: add systemd service and udev rule for automatic
    reconfiguration
  daxctl: add and install an example config file

 .../daxctl/daxctl-reconfigure-device.txt      |  75 ++++++++
 Documentation/ndctl/ndctl-monitor.txt         |   8 +-
 configure.ac                                  |  22 ++-
 Makefile.am                                   |   2 +
 ndctl/lib/private.h                           |   1 +
 daxctl/lib/libdaxctl.c                        |  20 ++
 ndctl/lib/libndctl.c                          |  20 ++
 daxctl/libdaxctl.h                            |   2 +
 ndctl/libndctl.h                              |   2 +
 util/parse-configs.h                          |  53 ++++++
 daxctl/device.c                               | 174 +++++++++++++++++-
 ndctl/monitor.c                               |  73 ++++----
 util/parse-configs.c                          | 156 ++++++++++++++++
 Documentation/daxctl/Makefile.am              |  11 +-
 Documentation/ndctl/Makefile.am               |   2 +-
 daxctl/90-daxctl-device.rules                 |   1 +
 daxctl/Makefile.am                            |  14 +-
 daxctl/daxctl.example.conf                    |  27 +++
 daxctl/daxdev-reconfigure@.service            |   8 +
 daxctl/lib/Makefile.am                        |   6 +
 daxctl/lib/libdaxctl.sym                      |   2 +
 ndctl.spec.in                                 |   7 +-
 ndctl/Makefile.am                             |  11 +-
 ndctl/lib/Makefile.am                         |   6 +
 ndctl/lib/libndctl.sym                        |   2 +
 ndctl/ndctl.conf                              |  56 ++++++
 26 files changed, 710 insertions(+), 51 deletions(-)
 create mode 100644 util/parse-configs.h
 create mode 100644 util/parse-configs.c
 create mode 100644 daxctl/90-daxctl-device.rules
 create mode 100644 daxctl/daxctl.example.conf
 create mode 100644 daxctl/daxdev-reconfigure@.service
 create mode 100644 ndctl/ndctl.conf


base-commit: 4e646fa490ba4b782afa188dd8818b94c419924e
-- 
2.33.1

