Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga18.intel.com (mga18.intel.com [134.134.136.126])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id A7A84210EE4E9
 for <linux-nvdimm@lists.01.org>; Mon, 13 Aug 2018 17:44:02 -0700 (PDT)
From: "Verma, Vishal L" <vishal.l.verma@intel.com>
Subject: [ANNOUNCE] ndctl v62
Date: Tue, 14 Aug 2018 00:43:53 +0000
Message-ID: <1534207431.3606.19.camel@intel.com>
Content-Language: en-US
Content-ID: <50ED4DA801C887429BF7B36E21F6376C@intel.com>
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

https://github.com/pmem/ndctl/releases/tag/v62

This release incorporates functionality up to the 4.19 kernel, and a
number of bug fixes and improvements.

Highlights include addition of the 'ndctl monitor' command to monitor
for SMART health events, use of the new max_available_extent sysfs
attribute for namespace creation, verbosity levels for ndctl-list, a
udev rule for enabling the LSS latch when supported, a bypass route
for making the unsafe shutdown count available for non-privileged users,
improvements to ndctl-inject-smart that include an 'uninject' option
for all fields, and a new unit test, a number of static analysis fixes,
and unit test improvements and fixes.

Shortlog:
Dan Williams (2):
      ndctl, test: check availability of MAP_SYNC for poison test
      ndctl: Remove dependency on linker garbage collection

Keith Busch (5):
      ndctl: Use max_available_extent for namespace
      ndctl: Create ndctl udev rules for dirty shutdown
      ndctl, intel: Fallback to smart cached shutdown_count
      ndctl: Add 'list' verbose options
      ndctl: Work around kernel memory corruption

Masayoshi Mizuma (3):
      ndctl, test: remove the firmware image file before the test end
      ndctl, documentation: Clarify the dimm id for ndctl list d option
      ndctl, test: add a new unit test for max_available_extent namespace

Maxwell William (1):
      util/strbuf.h: include sys/types.h for ssize_t definition.

QI Fuli (14):
      ndctl, monitor: add a new command - monitor
      ndctl, monitor: add main ndctl monitor configuration file
      ndctl, monitor: add the unit file of systemd for ndctl-monitor service
      ndctl, documentation: add man page for monitor
      ndctl, test: add a new unit test for monitor
      ndctl, monitor: fix the lack of detection of invalid dimm-events
      ndctl, inject-smart: add an interface to inject ctrl-temperature
      ndctl, monitor: Fix duplicate prefix in monitor.log
      ndctl, monitor: add [--verbose] option to emit extra debug messages
      ndctl, list: add alarm_enable_<field> to list
      ndctl, monitor: fix the lack of detection of invalid path of log file
      ndctl, monitor: set default log destination to syslog if "--daemon" is specified
      ndctl, monitor: add timestamp and pid to log messages in log_file()
      ndctl, monitor: add [Install] Section to systemd unit file of ndctl-monitor

Ross Zwisler (2):
      ndctl: simplify JSON print flag handling
      ndctl list: always output array without --human

Vishal Verma (33):
      Documentation: add a newline in namespace Theory of Operations
      ndctl: Add CONTRIBUTING.md
      ndctl, test: add start/wait scrub to injection tests
      libndctl: fix the uninject-error API actually injecting errors
      ndctl, test: Fix dax.sh return code
      ndctl, test: fix timeouts in device-dax
      contrib/do_abidiff: make the build more robust
      ndctl: add an API to check support for smart injection
      ndctl, test: fix tests for the array vs object listing fix
      ndctl, test: convert remaining tests to use test/common
      ndctl, bash-completion: add completion for ndctl-monitor
      ndctl, monitor: Add a config-file section to the man page
      ndctl, monitor: fix memory leak in read_config_file
      ndctl, monitor: Fix memory leak in monitor_event
      ndctl, monitor: improve error reporting throughout monitor.c
      Documentation, create-namespace: clarify fsdax wording
      ndctl, monitor: fix a resource leak in parse_monitor_event
      ndctl, documentation: document the label-version option for init-labels
      ndctl: deprecate undocumented short-options
      ndctl, inject-smart: Fix man page to match the current behavior
      ndctl inject-smart: add an option to uninject smart fields
      ndctl, test/monitor: fix inject-smart field in test_filter_dimmevent
      ndctl, inject-smart: continue in spite of errors for uninject-all
      ndctl, tests: add a new unit test for inject-smart
      ndctl, inject: fix a resource leak in ndctl_namespace_get_clear_unit
      ndctl: fix a resource leak in submit_get_firmware_info
      libndctl: fix a resource leak in ndctl_dimm_get_{{event_}flags, health}
      ndctl, test: fix a potential null pointer dereference in 'ndctl test'
      ndctl, test: fix a resource leak in check_smart_threshold
      ndctl, prepare-release.sh: fix revision update checks
      ndctl: fix potential null dereference in the smart error handler
      ndctl, udev: fix a resource leak in save_unsafe_shutdown_count
      ndctl: release v62
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
