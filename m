Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mgwym03.jp.fujitsu.com (mgwym03.jp.fujitsu.com [211.128.242.42])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 6D15D21E95DFE
 for <linux-nvdimm@lists.01.org>; Wed, 30 Aug 2017 18:25:59 -0700 (PDT)
Received: from m3050.s.css.fujitsu.com (msm.b.css.fujitsu.com [10.134.21.208])
 by yt-mxq.gw.nic.fujitsu.com (Postfix) with ESMTP id 6403BAC0120
 for <linux-nvdimm@lists.01.org>; Thu, 31 Aug 2017 10:27:04 +0900 (JST)
Date: Thu, 31 Aug 2017 10:26:50 +0900
From: Yasunori Goto <y-goto@jp.fujitsu.com>
Subject: [ndctl PATCH 3/5] allow ND_CMD_CALL for bus
In-Reply-To: <20170831102101.DA2C.E1E9C6FF@jp.fujitsu.com>
References: <20170831102101.DA2C.E1E9C6FF@jp.fujitsu.com>
Message-Id: <20170831102647.DA36.E1E9C6FF@jp.fujitsu.com>
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
To: NVDIMM-ML <linux-nvdimm@lists.01.org>
List-ID: <linux-nvdimm@lists.01.org>


Currently ndctl supports ND_CMD_CALL only for DIMM,
but Translate SPA is the feature of bus.
So ND_CMD_CALL must be allowed bus's ioctl().


Signed-off-by: Yasunori Goto <y-goto@jp.fujitsu.com>
---
 ndctl/lib/libndctl.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/ndctl/lib/libndctl.c b/ndctl/lib/libndctl.c
index 803056d..e3dcb1c 100644
--- a/ndctl/lib/libndctl.c
+++ b/ndctl/lib/libndctl.c
@@ -2330,6 +2330,7 @@ static int to_ioctl_cmd(int cmd, int dimm)
 #ifdef HAVE_NDCTL_CLEAR_ERROR
 		case ND_CMD_CLEAR_ERROR:     return ND_IOCTL_CLEAR_ERROR;
 #endif
+		case ND_CMD_CALL:            return ND_IOCTL_CALL;
 		default:
 						       return 0;
 		};



_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
