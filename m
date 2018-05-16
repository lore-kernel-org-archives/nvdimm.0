Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mx142.netapp.com (mx142.netapp.com
 [IPv6:2620:10a:4005:8000:2306::b])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 0E185209603C8
 for <linux-nvdimm@lists.01.org>; Wed, 16 May 2018 00:47:41 -0700 (PDT)
From: "Korman, Yigal" <Yigal.Korman@netapp.com>
Subject: ndctl create-namespace '--map' option
Date: Wed, 16 May 2018 07:47:38 +0000
Message-ID: <MWHPR0601MB36767B701B207CC71A40AC3CEB920@MWHPR0601MB3676.namprd06.prod.outlook.com>
Content-Language: en-US
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
To: "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>, "dan.j.williams@intel.com" <dan.j.williams@intel.com>
List-ID: <linux-nvdimm@lists.01.org>

Hi Dan,
I was wandering why there's no way of checking where an existing namespace keeps its page-structs (AKA --map={mem,dev})?
'ndctl list --namespaces' doesn't seem to show this.
Is this intentional? Or just a missing feature?

Thanks,
Yigal
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
