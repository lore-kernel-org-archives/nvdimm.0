Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga07.intel.com (mga07.intel.com [134.134.136.100])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 1D2CF2194EB65
 for <linux-nvdimm@lists.01.org>; Fri, 14 Apr 2017 13:32:00 -0700 (PDT)
From: "Rudoff, Andy" <andy.rudoff@intel.com>
Subject: Re: [ndctl PATCH] ndctl, check: Add a sigbus handler to detect
 metadata corruption
Date: Fri, 14 Apr 2017 20:31:57 +0000
Message-ID: <AA5E9ABD-5FD4-4AB0-9E70-6EA2A1D7EA61@intel.com>
References: <20170414000251.23904-1-vishal.l.verma@intel.com>
 <F7CF62AA-B1F5-486D-AA87-F61674B86AC5@intel.com>
 <1492196446.1657.1.camel@intel.com>
 <CAPcyv4hc8d15yUs133ZG5V4+7R+CfdPaDA0661JX95ZcnLK0sw@mail.gmail.com>
 <D56299A3-A5A4-4B49-AFC6-5F03118F1F85@intel.com>
 <1492198820.1657.3.camel@intel.com>
 <01C2D860-110D-407F-A8FA-2892AF38EB88@intel.com>
 <1492201682.1657.6.camel@intel.com>
In-Reply-To: <1492201682.1657.6.camel@intel.com>
Content-Language: en-US
Content-ID: <EA04E2BBB9FF284C94D0CD28BF9E14E8@intel.com>
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
To: "Verma, Vishal L" <vishal.l.verma@intel.com>, "Williams, Dan J" <dan.j.williams@intel.com>
Cc: "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>
List-ID: <linux-nvdimm@lists.01.org>

>Maybe what we need here is during BTT creation, check for at least
>known badblocks, and initialize them so that we know at least new BTTs
>are clean.

I totally agree with this one.  Sounds like a must-have to me.  The
idea of poison in a location that sticks around even after you recreate
the BTT makes me shudder.

Thanks,

-andy
 

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
