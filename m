Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mgwkm03.jp.fujitsu.com (mgwkm03.jp.fujitsu.com [202.219.69.170])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 2FC072118A5AD
 for <linux-nvdimm@lists.01.org>; Thu, 14 Jun 2018 05:34:25 -0700 (PDT)
Received: from m3050.s.css.fujitsu.com (msm.b.css.fujitsu.com [10.134.21.208])
 by kw-mxauth.gw.nic.fujitsu.com (Postfix) with ESMTP id 61F5EAC015A
 for <linux-nvdimm@lists.01.org>;
 Thu, 14 Jun 2018 21:34:16 +0900 (JST)
From: QI Fuli <qi.fuli@jp.fujitsu.com>
Subject: Question about how to emulate the dimm-controller-temperature event
Date: Thu, 14 Jun 2018 21:34:08 +0900
Message-Id: <20180614123408.12162-1-qi.fuli@jp.fujitsu.com>
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

I want to make an emulation of dimm-controller-temperature event to test if ndctl monitor could catch this dimm event.
I tried to use ndctl inject-smart command, but I found the controller temperature smart attribute of dimm cannot be injected by command like
	# ndctl inject-smart nmem2 --ctrl-temperature 40.

I checked smart_inject() in ndctl/inject-smart.c and NVDIMM DMS Interface-v1.7,
and could not find any interface which can set the controller-temperature of dimm.

Does anyone know how to emulate the dimm-controller-temperature event?

Thank you very much.

-- 
2.17.1

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
