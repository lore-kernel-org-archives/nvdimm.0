Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga09.intel.com (mga09.intel.com [134.134.136.24])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 3F21921A07A80
 for <linux-nvdimm@lists.01.org>; Fri,  5 Oct 2018 16:10:01 -0700 (PDT)
From: "Verma, Vishal L" <vishal.l.verma@intel.com>
Subject: [ANNOUNCE] ndctl v63
Date: Fri, 5 Oct 2018 23:09:45 +0000
Message-ID: <55334f1e9b9f7fb99bd2a4c88126ce4991ca9a4b.camel@intel.com>
Content-Language: en-US
Content-ID: <0A40338CE2165A4DA7D477407F00F10A@intel.com>
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

https://github.com/pmem/ndctl/releases/tag/v63

This release incorporates functionality up to the 4.20 kernel, and a
number of bug fixes and improvements.

Highlights include switching the documentation build to asciidoctor by
default, fixes to destroy-namespace for reporting the number of
namespaces acted upon, using the namespace badblocks listings exported
by the kernel, and making them available to non-root users, a new helper
for retrieving the dirty-shutdown-count, reverting the udev rule to set
the shutdown count latch and cache the dirty-shutdown-count, and fixing
the ndctl-monitor daemon to exit successfully in the absence of NVDIMMs.

Shortlog:
Dan Williams (7):
      ndctl, build: Introduce --with-{bash,systemd}
      ndctl, spec: Use pkgconfig for systemd
      ndctl, lib: refactor badblocks retrieval routines
      ndctl, lib: add APIs for retrieving namespace badblocks
      ndctl, lib: Add dirty-shutdown-count retrieval helper
      ndctl: Revert "ndctl, intel: Fallback to smart cached shutdown_count"
      ndctl: Revert "ndctl: Create ndctl udev rules for dirty shutdown"

Keith Busch (1):
      ndctl: Suppress command errors if fallback exists

QI Fuli (1):
      ndctl, monitor: fix the severity of "daemon started" message

Robert Elliott (1):
      ndctl, check-labels: correct check-labels message wording

Vishal Verma (14):
      ndctl, autoconf: include sys/mman.h for MAP_SYNC
      ndctl, monitor: Fix formatting for --log in the man page
      ndctl, list: fix the verbosity level formatting in the man page
      ndctl, docs: Use asciidoctor by default
      ndctl, test: add UUID_LIBS for list_smart_dimm
      ndctl, destroy-namespace: check for an already-zeroed info block
      ndctl, namespace: rework namespace action accounting
      ndctl, test: add a new unit test pfn metadata error clearing
      util/json: fix an error check for region resource
      util/json: Add comments around re-checking the UTIL_JSON_MEDIA_ERRORS flag
      util/json: add a util_namespace_badblocks_to_json() helper
      libndctl: set errno for routines that don't return an error status
      ndctl, monitor: in daemon mode, exit successfully if no DIMMs are found
      ndctl: release v63
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
