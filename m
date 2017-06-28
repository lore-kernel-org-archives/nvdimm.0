Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from muon.cran.org.uk (muon.bluestop.org [74.50.51.35])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id B60B121A00AC9
 for <linux-nvdimm@lists.01.org>; Wed, 28 Jun 2017 11:45:23 -0700 (PDT)
Date: Wed, 28 Jun 2017 12:46:53 -0600
From: Rebecca Cran <rebecca@bluestop.org>
Subject: Re: Standardization of ACPI NVDIMM DSMs
Message-ID: <20170628124653.00006283@bluestop.org>
In-Reply-To: <9f16559d-fc0f-ad0d-2c13-1fc0b38aa733@hpe.com>
References: <20170628094025.00001fc0@bluestop.org>
 <9f16559d-fc0f-ad0d-2c13-1fc0b38aa733@hpe.com>
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

On Wed, 28 Jun 2017 11:59:04 -0400
Linda Knippers <linda.knippers@hpe.com> wrote:

> There is more standardization that will likely happen.  The most
> interesting is probably standard health status information.  Today
> the Linux ndctl command can display health status for the NVDIMMs
> and it hides some of the differences by calling the appropriate
> DSM for the platform/NVDIMM combination but we need to do more
> work there.
> 
> Does this help?

Thanks, that's perfect! I will continue working on the proposal to add
SMART/Health data into ACPI in that case, since it _does_ look like
there's sufficient commonality that standardization should be
relatively easy. I'm really working on an NVDIMM-P product, but it will
be applicable to NVDIMM-N modules too.

-- 
Rebecca Cran
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
