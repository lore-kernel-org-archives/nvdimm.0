Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mailrelay112.isp.belgacom.be (mailrelay112.isp.belgacom.be
 [195.238.20.139])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id BDE2A81F5C
 for <linux-nvdimm@lists.01.org>; Fri,  2 Dec 2016 11:19:17 -0800 (PST)
From: Fabian Frederick <fabf@skynet.be>
Subject: [PATCH 0/8 linux-next] libnvdimm: code clean-up
Date: Fri,  2 Dec 2016 20:19:08 +0100
Message-Id: <1480706348-20874-1-git-send-email-fabf@skynet.be>
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
To: Dan Williams <dan.j.williams@intel.com>
Cc: fabf@skynet.be, linux-kernel@vger.kernel.org, linux-nvdimm@lists.01.org
List-ID: <linux-nvdimm@lists.01.org>

This small patchset does some clean-up and tries to add some tips when
memmap does not work.

Fabian Frederick (8):
  libnvdimm, namespace: update message level on smaller reservations
  libnvdimm, namespace: add verbosity to persistence warning
  libnvdimm, namespace: move persistence warning
  libnvdimm, namespace: avoid multiple sector calculations
  libnvdimm: remove else after return in nsio_rw_bytes()
  libnvdimm, namespace: use octal for permissions
  mm: warn about possible alignment problem
  mm: use SECTION_MASK where possible

 drivers/nvdimm/claim.c          |  5 ++---
 drivers/nvdimm/namespace_devs.c |  8 ++++----
 drivers/nvdimm/pmem.c           | 18 +++++++++---------
 kernel/memremap.c               | 10 +++++-----
 4 files changed, 20 insertions(+), 21 deletions(-)

-- 
2.7.4

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
