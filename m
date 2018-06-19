Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga01.intel.com (mga01.intel.com [192.55.52.88])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id E073F210D1F18
 for <linux-nvdimm@lists.01.org>; Mon, 18 Jun 2018 18:56:22 -0700 (PDT)
Date: Mon, 18 Jun 2018 19:56:21 -0600
From: Ross Zwisler <ross.zwisler@linux.intel.com>
Subject: Re: [PATCH] tools/testing/nvdimm: advertise a write cache for
 nfit_test
Message-ID: <20180619015621.GA28069@linux.intel.com>
References: <20180618231702.16503-1-vishal.l.verma@intel.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20180618231702.16503-1-vishal.l.verma@intel.com>
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
To: Vishal Verma <vishal.l.verma@intel.com>
Cc: linux-nvdimm@lists.01.org
List-ID: <linux-nvdimm@lists.01.org>

On Mon, Jun 18, 2018 at 05:17:02PM -0600, Vishal Verma wrote:
> Commit 546eb0317cfa "libnvdimm, pmem: Do not flush power-fail protected CPU caches"
> fixed the write_cache detection to correctly show the lack of a write
> cache based on the platform capabilities described in the ACPI NFIT. The
> nfit_test unit tests expected a write cache to be present, so change the
> nfit test namespaces to only advertise a persistence domain limited to
> the memory controller. This allows the kernel to show a write_cache
> attribute, and the test behaviour remains unchanged.
> 
> Cc: Ross Zwisler <ross.zwisler@linux.intel.com>
> Cc: Dan Williams <dan.j.williams@intel.com>
> Signed-off-by: Vishal Verma <vishal.l.verma@intel.com>

Sure, this makes sense to me.  Thanks for the fix.

Reviewed-by: Ross Zwisler <ross.zwisler@linux.intel.com>
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
