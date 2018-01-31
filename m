Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga06.intel.com (mga06.intel.com [134.134.136.31])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id C68BD223648AC
 for <linux-nvdimm@lists.01.org>; Tue, 30 Jan 2018 16:08:05 -0800 (PST)
Date: Tue, 30 Jan 2018 17:13:40 -0700
From: Ross Zwisler <ross.zwisler@linux.intel.com>
Subject: Re: [PATCH v3 1/4] acpi: nfit: Add support for detect platform CPU
 cache flush on power loss
Message-ID: <20180131001340.GB27220@linux.intel.com>
References: <151735668391.34477.11820724492631561208.stgit@djiang5-desk3.ch.intel.com>
 <151735687346.34477.4956828815153494582.stgit@djiang5-desk3.ch.intel.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <151735687346.34477.4956828815153494582.stgit@djiang5-desk3.ch.intel.com>
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
To: Dave Jiang <dave.jiang@intel.com>
Cc: linux-acpi@vger.kernel.org, linux-nvdimm@lists.01.org
List-ID: <linux-nvdimm@lists.01.org>

On Tue, Jan 30, 2018 at 05:01:13PM -0700, Dave Jiang wrote:
> In ACPI 6.2a the platform capability structure has been added to the NFIT
> tables. That provides software the ability to determine whether a system
> supports the auto flushing of CPU caches on power loss. If the capability
> is supported, we do not need to do dax_flush(). Plumbing the path to set the
> property on per region from the NFTI tables.
				  NFIT
> 
> This patch depends on the ACPI NFIT 6.2a platform capabilities support code
> in include/acpi/actbl1.h.
> 
> Signed-off-by: Dave Jiang <dave.jiang@intel.com>

Looks good aside from the one nit.

Reviewed-by: Ross Zwisler <ross.zwisler@linux.intel.com>
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
