Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga04.intel.com (mga04.intel.com [192.55.52.120])
 by ml01.01.org (Postfix) with ESMTP id 4D9E41A1DFA
 for <linux-nvdimm@lists.01.org>; Mon, 23 May 2016 14:08:45 -0700 (PDT)
From: Vishal Verma <vishal.l.verma@intel.com>
Subject: [ndctl PATCH v2 0/2] bash completion for ndctl
Date: Mon, 23 May 2016 15:07:54 -0600
Message-Id: <1464037676-5776-1-git-send-email-vishal.l.verma@intel.com>
List-Unsubscribe: <https://lists.01.org/mailman/options/linux-nvdimm>,
 <mailto:linux-nvdimm-request@lists.01.org?subject=unsubscribe>
List-Archive: <http://lists.01.org/pipermail/linux-nvdimm/>
List-Post: <mailto:linux-nvdimm@lists.01.org>
List-Help: <mailto:linux-nvdimm-request@lists.01.org?subject=help>
List-Subscribe: <https://lists.01.org/mailman/listinfo/linux-nvdimm>,
 <mailto:linux-nvdimm-request@lists.01.org?subject=subscribe>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: linux-nvdimm-bounces@lists.01.org
Sender: "Linux-nvdimm" <linux-nvdimm-bounces@lists.01.org>
To: linux-nvdimm@lists.01.org
List-ID: <linux-nvdimm@lists.01.org>

Changes in v2:
- Fix '-' not appearing after --refconfig (Dan)
- Complete --refconfig with namespaces (Dan)
- For all completions of regions and dimms, if a --bus= has been
  provided, use it to filter and show only the regions/dimms on
  that bus
- Similarly, for all completions of namespaces, filter using both,
  prior --bus= or --region= options.
- Distinguish between idle and active namespaces and regions, and
  complete with one or the other set depending on the command
  (e.g. enable-* will list all regions/namespaces including idle).
- For options that don't need an additional parameter, add a space
  after a full completion (i.e. any option that doesn't end in
  a '=').
- In patch 1 (segfault fix), fix a typo in the commit log and add
  Reveiwed-by tags.

Vishal Verma (2):
  ndctl: fix a segfault in parse-options.c
  ndctl: add bash completion

 Makefile.am          |   5 +
 configure.ac         |  17 +++
 contrib/ndctl        | 330 +++++++++++++++++++++++++++++++++++++++++++++++++++
 util/parse-options.c |   5 +-
 4 files changed, 355 insertions(+), 2 deletions(-)
 create mode 100755 contrib/ndctl

-- 
2.5.5

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
