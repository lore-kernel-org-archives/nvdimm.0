Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mgwkm04.jp.fujitsu.com (mgwkm04.jp.fujitsu.com [202.219.69.171])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id F05662097DD11
 for <linux-nvdimm@lists.01.org>; Wed, 30 May 2018 19:29:27 -0700 (PDT)
Received: from m3050.s.css.fujitsu.com (msm.b.css.fujitsu.com [10.134.21.208])
 by kw-mxauth.gw.nic.fujitsu.com (Postfix) with ESMTP id DC2F3AC00FD
 for <linux-nvdimm@lists.01.org>;
 Thu, 31 May 2018 11:29:17 +0900 (JST)
Date: Thu, 31 May 2018 11:27:33 +0900
From: Yasunori Goto <y-goto@jp.fujitsu.com>
Subject: Question about Experimental of Filesystem DAX.
Message-Id: <20180531112731.0CAC.E1E9C6FF@jp.fujitsu.com>
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

Hello,


I would like to know about the Experimental message of Filesystem DAX.
--------------------------------------------------------
DAX enabled. Warning: EXPERIMENTAL, use at your own risk
--------------------------------------------------------

AFAIK, the final issue of Filesystem DAX is metadata update problem, 
and it is(will be?) solved by great effort of MAP_SYNC and
"fix dma vs truncate/hole-punch" patch set. 
So, I suppose that the Experimental message can be removed,
but I'm not sure.

Is it possible?
Otherwise, are there any other issues in Filesystem DAX yet?

If this is silly question, sorry for noise....

Thanks,
---
Yasunori Goto



_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
