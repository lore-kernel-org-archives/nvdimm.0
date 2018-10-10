Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-pl1-x634.google.com (mail-pl1-x634.google.com
 [IPv6:2607:f8b0:4864:20::634])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id AA8D92194D3B3
 for <linux-nvdimm@lists.01.org>; Tue,  9 Oct 2018 23:08:33 -0700 (PDT)
Received: by mail-pl1-x634.google.com with SMTP id y11-v6so1984739plt.3
 for <linux-nvdimm@lists.01.org>; Tue, 09 Oct 2018 23:08:33 -0700 (PDT)
From: Oliver O'Halloran <oohall@gmail.com>
Subject: PAPR SCM support
Date: Wed, 10 Oct 2018 17:08:10 +1100
Message-Id: <20181010060812.20068-1-oohall@gmail.com>
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
To: linuxppc-dev@lists.ozlabs.org
Cc: nfont@linux.vnet.ibm.com, linux-nvdimm@lists.01.org
List-ID: <linux-nvdimm@lists.01.org>

This series adds support for the para-virtualised storage class memory
interface defined by the Power Architecture Platform Reference.

Patch 1 implements the pseries device discovery (via DT) and hotplug
support (via RTAS hotplug interrupt).

Patch 2 implements a driver that binds to the platform devices, does the
necessary H-calls to activate the region and configures the libnvdimm
interface. It also adds an NDCTL implementation to allow the "metadata"
space associated with an SCM region to be used as label space.

This should go in via the ppc tree, but an ack from Dan for patch two
would be appreciated.

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
