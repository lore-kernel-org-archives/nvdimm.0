Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mgwkm01.jp.fujitsu.com (mgwkm01.jp.fujitsu.com [202.219.69.168])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 3A3F522497F4E
 for <linux-nvdimm@lists.01.org>; Mon, 16 Apr 2018 23:40:13 -0700 (PDT)
Received: from m3051.s.css.fujitsu.com (m3051.s.css.fujitsu.com
 [10.134.21.209])
 by kw-mxauth.gw.nic.fujitsu.com (Postfix) with ESMTP id BB366AC01B8
 for <linux-nvdimm@lists.01.org>; Tue, 17 Apr 2018 15:40:09 +0900 (JST)
From: QI Fuli <qi.fuli@jp.fujitsu.com>
Subject: [PATCH 0/2] ndctl: change ndctl to support multiple arguments per
 option
Date: Tue, 17 Apr 2018 15:38:46 +0900
Message-Id: <20180417063848.5585-1-qi.fuli@jp.fujitsu.com>
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

This patch set is to support multiple arguments per option of ndctl.
Currently, ndctl supports only one argument per option, and only one dimm
can be filtered by dimm's name. As a result, when users want to moniotr
multiple dimms, they have to run multiple monitor processes. This feature
can let monitor support filter multiple dimms by dimms' name in one process.
Also applied in ndctl list:

 # ndclt list --dimm="nmem0 nmem1 nmem2"
  [
    {
      "dev":"nmem1",
      "id":"cdab-0a-07e0-feffffff",
      "handle":1,
      "phys_id":1
    },
    {
      "dev":"nmem0",
      "id":"cdab-0a-07e0-ffffffff",
      "handle":0,
      "phys_id":0
    },
    {
      "dev":"nmem2",
      "id":"cdab-0a-07e0-fffeffff",
      "handle":256,
      "phys_id":2
    }
  ]

QI Fuli (2):
  ndctl, util: add OPT_STRING_LIST to parse_option
  ndctl, list: change -b -d -r -n options to support multiple arguments

 ccan/list/list.h     |  6 ++++
 ndctl/list.c         | 35 ++++++++++++++-----
 util/filter.c        | 81 +++++++++++++++++++++++++++++++-------------
 util/filter.h        |  9 ++---
 util/parse-options.c | 25 ++++++++++++++
 util/parse-options.h |  3 ++
 6 files changed, 122 insertions(+), 37 deletions(-)

-- 
2.17.0.140.g0b0cc9f86


_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
