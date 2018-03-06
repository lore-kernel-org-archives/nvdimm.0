Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga14.intel.com (mga14.intel.com [192.55.52.115])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 4E42821E082AE
 for <linux-nvdimm@lists.01.org>; Mon,  5 Mar 2018 16:49:36 -0800 (PST)
Date: Mon, 5 Mar 2018 17:55:48 -0700
From: Ross Zwisler <ross.zwisler@linux.intel.com>
Subject: Re: [PATCH] acpi, nfit: remove redundant __func__ in dev_dbg
Message-ID: <20180306005548.GB15227@linux.intel.com>
References: <20180302122049.13900-1-jthumshirn@suse.de>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20180302122049.13900-1-jthumshirn@suse.de>
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
To: Johannes Thumshirn <jthumshirn@suse.de>
Cc: Linux Kernel Mailinglist <linux-kernel@vger.kernel.org>, Linux NV-DIMM Mailing List <linux-nvdimm@lists.01.org>
List-ID: <linux-nvdimm@lists.01.org>

On Fri, Mar 02, 2018 at 01:20:49PM +0100, Johannes Thumshirn wrote:
> Dynamic debug can be instructed to add the function name to the debug
> output using the +f switch, so there is no need for the nfit module to
> do it again. If a user decides to add the +f switch for nfit's dynamic
> debug this results in double prints of the function name like the
> following:
> 
> [ 2391.935383] acpi_nfit_ctl: nfit ACPI0012:00: acpi_nfit_ctl:nmem8 cmd: 10: func: 1 input length: 0
> 
> Thus remove the stray __func__ printing.
> 
> Signed-off-by: Johannes Thumshirn <jthumshirn@suse.de>

I looked through this and this all looked right to me.

Reviewed-by: Ross Zwisler <ross.zwisler@linux.intel.com>
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
