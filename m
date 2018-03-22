Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from g4t3426.houston.hpe.com (g4t3426.houston.hpe.com
 [15.241.140.75])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id D541622468004
 for <linux-nvdimm@lists.01.org>; Thu, 22 Mar 2018 12:52:13 -0700 (PDT)
From: "Kani, Toshi" <toshi.kani@hpe.com>
Subject: Re: [PATCH] nfit: skip region registration for incomplete control
 regions
Date: Thu, 22 Mar 2018 19:58:42 +0000
Message-ID: <1521748710.2693.233.camel@hpe.com>
References: <152169374458.19742.14326187212131249042.stgit@dwillia2-desk3.amr.corp.intel.com>
In-Reply-To: <152169374458.19742.14326187212131249042.stgit@dwillia2-desk3.amr.corp.intel.com>
Content-Language: en-US
Content-ID: <BD9FBE9C81AA15478E37727130F579CC@NAMPRD84.PROD.OUTLOOK.COM>
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
To: "dan.j.williams@intel.com" <dan.j.williams@intel.com>, "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>
Cc: "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
List-ID: <linux-nvdimm@lists.01.org>

On Wed, 2018-03-21 at 21:42 -0700, Dan Williams wrote:
> Per the ACPI specification the only functional purpose for a DIMM
> Control Region to be mapped into the system physical address space, from
> an OSPM perspective, is to support block-apertures. However, there are
> some BIOSen that publish DIMM Control Region SPA entries for pre-boot
> environment consumption.  Undo the kernel policy of generating disabled
> 'ndblk' regions when this configuration is detected.
> 
> Signed-off-by: Dan Williams <dan.j.williams@intel.com>

The change looks good.

Reviewed-by: Toshi Kani <toshi.kani@hpe.com>

Thanks!
-Toshi
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
