Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga02.intel.com (mga02.intel.com [134.134.136.20])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 08CE92116DF9F
 for <linux-nvdimm@lists.01.org>; Fri, 12 Oct 2018 13:39:49 -0700 (PDT)
Subject: [PATCH v2 0/4] misc patches for nvdimm security fixes
From: Dave Jiang <dave.jiang@intel.com>
Date: Fri, 12 Oct 2018 13:39:48 -0700
Message-ID: <153937659078.70378.7857051533055879370.stgit@djiang5-desk3.ch.intel.com>
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
To: dan.j.williams@intel.com
Cc: linux-nvdimm@lists.01.org
List-ID: <linux-nvdimm@lists.01.org>

v2:
- Fix key perm flags and remove SET_ATTR. (Dan)
- Fixup comment for key_update code block (Dan)
- Use key_destroy() instead of key_invalidate+key_put (Dan)
- Fix dev_warn() output for nvdimm_security_disable() (Dan)
- Drop patch 3/5 (applied by Dan)
- Add support for self verify the requested key before giving up and freeze
  security. (Dan)

---

Dave Jiang (4):
      libnvdimm: fix updating of kernel key during nvdimm key update
      libnvdimm: fix incorrect output when nvdimm disable failed
      libnvdimm: remove code to pull user key when there's no kernel key
      libnvdimm: address state where dimm is unlocked in preOS


 drivers/nvdimm/security.c |  129 +++++++++++++++++++++++++++++----------------
 1 file changed, 82 insertions(+), 47 deletions(-)

--
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
