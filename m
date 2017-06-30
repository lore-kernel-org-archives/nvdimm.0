Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mgwym01.jp.fujitsu.com (mgwym01.jp.fujitsu.com [211.128.242.40])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 8B19121B02B8F
 for <linux-nvdimm@lists.01.org>; Thu, 29 Jun 2017 18:17:40 -0700 (PDT)
Received: from m3051.s.css.fujitsu.com (m3051.s.css.fujitsu.com
 [10.134.21.209])
 by yt-mxoi1.gw.nic.fujitsu.com (Postfix) with ESMTP id 56400AC00F2
 for <linux-nvdimm@lists.01.org>; Fri, 30 Jun 2017 10:19:04 +0900 (JST)
Date: Fri, 30 Jun 2017 10:18:58 +0900
From: Yasunori Goto <y-goto@jp.fujitsu.com>
Subject: Re: Standardization of ACPI NVDIMM DSMs
In-Reply-To: <9f16559d-fc0f-ad0d-2c13-1fc0b38aa733@hpe.com>
References: <20170628094025.00001fc0@bluestop.org>
 <9f16559d-fc0f-ad0d-2c13-1fc0b38aa733@hpe.com>
Message-Id: <20170630101854.B36F.E1E9C6FF@jp.fujitsu.com>
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
To: Linda Knippers <linda.knippers@hpe.com>
Cc: linux-nvdimm@lists.01.org
List-ID: <linux-nvdimm@lists.01.org>

Hello, Linda-san,

> There is more standardization that will likely happen.  The most
> interesting is probably standard health status information.  Today
> the Linux ndctl command can display health status for the NVDIMMs
> and it hides some of the differences by calling the appropriate
> DSM for the platform/NVDIMM combination but we need to do more
> work there.

Could you tell me what works are necessary?

I also have concern around here, and I'm investgating source code of 
ndctl and NVDIMM drivers to check what works are still needed.
So, your opinion will be very helpful for me.

Thanks.


_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
