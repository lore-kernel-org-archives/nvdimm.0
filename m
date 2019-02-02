Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga04.intel.com (mga04.intel.com [192.55.52.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id B850C2194D3B8
 for <linux-nvdimm@lists.01.org>; Fri,  1 Feb 2019 18:32:31 -0800 (PST)
From: "Verma, Vishal L" <vishal.l.verma@intel.com>
Subject: [ANNOUNCE] ndctl v64
Date: Sat, 2 Feb 2019 02:32:30 +0000
Message-ID: <82a5e3d490025fb3852e6c7d9eeff78af98e2c23.camel@intel.com>
Content-Language: en-US
Content-ID: <749873B7C6DB6C499623D54350729925@intel.com>
MIME-Version: 1.0
List-Unsubscribe: <https://lists.01.org/mailman/options/linux-nvdimm>,
 <mailto:linux-nvdimm-request@lists.01.org?subject=unsubscribe>
List-Archive: <http://lists.01.org/pipermail/linux-nvdimm/>
List-Post: <mailto:linux-nvdimm@lists.01.org>
List-Help: <mailto:linux-nvdimm-request@lists.01.org?subject=help>
List-Subscribe: <https://lists.01.org/mailman/listinfo/linux-nvdimm>,
 <mailto:linux-nvdimm-request@lists.01.org?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: linux-nvdimm-bounces@lists.01.org
Sender: "Linux-nvdimm" <linux-nvdimm-bounces@lists.01.org>
To: "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>
List-ID: <linux-nvdimm@lists.01.org>

This release incorporates functionality up to the 5.0 kernel, and adds a
number of bug fixes and improvements.

Highlights include a migration path for the new dax-bus ABI, several
cleanups to ndctl-monitor, support for firmware status translation,
displaying the supported_alignments attribute, and using it in the
namespace creation process, and support for security operations as
defined in the Intel DSM specification.

shortlog of the commits that went into this release:

Dan Williams (17):
      test, device-dax: Fix intermittent poison handling failures
      test, dsm-fail: Cleanup leftover debug
      ndctl, build: Define HAVE_UUID
      ndctl, daxctl: Split builtin.h per-command
      ndctl, daxctl: Add type-safety to command harness
      ndctl/monitor: Drop 'struct ndctl_ctx *' casts
      ndctl/monitor: Unify definition of default monitor configfile path
      ndctl/monitor: Fix / cleanup log_file()
      ndctl/monitor: Drop vasprintf usage
      ndctl/monitor: Kill usage of ndctl/lib/private.h
      ndctl/init-labels: Fix label slot accounting per UEFI 2.7
      ndctl: Introduce ndctl/config.h
      ndctl, rpm: Mark monitor.conf as a configuration file
      ndctl/build: Fix config.h dependency
      daxctl: Support the /sys/bus/dax ABI
      daxctl: Opt-in to /sys/bus/dax ABI
      Documentation: Update copyright

Dave Jiang (11):
      ndctl: add support for displaying the security state
      ndctl: add a Theory of Operation document for security commands
      ndctl: add passphrase management commands
      ndctl: add a freeze-security command
      ndctl: add a sanitize-dimm command
      ndctl: add a unit test to exercise security operations
      ndctl: add a load-keys command and a modprobe config
      ndctl: add an overwrite option to 'sanitize-dimm'
      ndctl: add a wait-overwrite command
      ndctl: master phassphrase management support
      ndctl: allow for a 'secure erase' using the master passphrase

Igor Gnatenko (2):
      ndctl.spec.in: remove obsolete ldconfig scriptlets
      ndctl.spec.in: remove obsolete Group tag

Johannes Thumshirn (1):
      ndctl, monitor: use type=simple instead of type=forking

Ocean He (1):
      ndctl: recover from failed namespace creation

Oliver O'Halloran (7):
      libndctl: Use the supported_alignment attribute
      ndctl/namespace: Check for seed namespaces earlier
      ndctl/namespace: Use seed alignment as the default
      ndctl/namespace: Validate alignment from the {pfn|dax} seed
      ndctl: Add alignment to the namespace JSON output
      ndctl/namespace: Make the create-namespace JSON output non-verbose
      ndctl: Add supported_alignments to the JSON output

Piotr Balcer (1):
      libndctl: fix bb iterator leak in namespaces

Toshi Kani (1):
      ndctl: fix zero-labels to handle firmware error properly

Vishal Verma (11):
      libndctl: ignore ENXIO in ndctl_namespace_delete
      libndctl, intel: Add infrastructure for firmware_status translation
      ndctl, inject-smart: switch to ndctl_cmd_submit_xlat
      ndctl, monitor: switch to ndctl_cmd_submit_xlat
      ndctl: clean up usage of ndctl_cmd_submit
      ndctl, Documentation: Allow for Makefile variables in Documentation
      daxctl: Add bash-completion
      libndctl: Fix the failure interpretation for status translations
      ndctl, bash-completion: add helpers for security commands
      ndctl, rpmbuild: Add a dummy readme file to ndctl_keysdir
      WIP: ndctl: release v64
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
