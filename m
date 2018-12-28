Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga11.intel.com (mga11.intel.com [192.55.52.93])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 3122F2194D3B9
 for <linux-nvdimm@lists.01.org>; Thu, 27 Dec 2018 19:42:35 -0800 (PST)
Subject: [ndctl PATCH 0/7] ndctl/monitor: Cleanups and fixes
From: Dan Williams <dan.j.williams@intel.com>
Date: Thu, 27 Dec 2018 19:29:58 -0800
Message-ID: <154596779833.164521.12632457592535372923.stgit@dwillia2-desk3.amr.corp.intel.com>
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
To: linux-nvdimm@lists.01.org
List-ID: <linux-nvdimm@lists.01.org>

Prompted by a need to add more commands to daxctl, and define a new
configuration file for daxctl to install, I took a look at the ndctl
monitor configuration file implementation and several fixes fell out.

An initial attempt to remove casts from the ndctl monitor uncovered
other cleanup opportunities. The motivation for some of the casts in
ndctl/monitor.c was due to the need to de-reference the 'ctx' parameter
passed to the log routines. That issue can be mitigated by teaching the
command harness to pass a typed version of the @ctx argument to the
builtin-command routines. However, looking closer, the monitor should
not be passing @ctx to the log routines, it should establish its own
log-context. That lead to the discovery of a few more cleanup
opportunities, like unnecessary usage of vaprintf().

More is possible. I am not comfortable with the fact that the log
facility dynamically changes the output and the output target based on
the priority. The monitor also has several occasions where it is
dynamically allocating memory unnecessarily.

---

Dan Williams (7):
      ndctl, daxctl: Split builtin.h per-command
      ndctl, daxctl: Add type-safety to command harness
      ndctl/monitor: Drop 'struct ndctl_ctx *' casts
      ndctl/monitor: Unify definition of default monitor configfile path
      ndctl/monitor: Fix / cleanup log_file()
      ndctl/monitor: Drop vasprintf usage
      ndctl/monitor: Kill usage of ndctl/lib/private.h


 builtin.h            |   51 ----------------
 configure.ac         |    8 ++
 daxctl/builtin.h     |    8 ++
 daxctl/daxctl.c      |   16 ++---
 daxctl/list.c        |    2 -
 ndctl/Makefile.am    |    6 +-
 ndctl/bat.c          |    2 -
 ndctl/builtin.h      |   35 +++++++++++
 ndctl/bus.c          |    4 +
 ndctl/create-nfit.c  |    2 -
 ndctl/dimm.c         |   18 +++---
 ndctl/inject-error.c |    3 -
 ndctl/inject-smart.c |    3 -
 ndctl/list.c         |    2 -
 ndctl/monitor.c      |  163 ++++++++++++++++++++------------------------------
 ndctl/namespace.c    |   10 ++-
 ndctl/ndctl.c        |   64 ++++++++++----------
 ndctl/region.c       |    4 +
 ndctl/test.c         |    2 -
 util/main.c          |   13 ++--
 util/main.h          |   20 ++++++
 21 files changed, 207 insertions(+), 229 deletions(-)
 delete mode 100644 builtin.h
 create mode 100644 daxctl/builtin.h
 create mode 100644 ndctl/builtin.h
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
