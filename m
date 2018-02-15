Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from bombadil.infradead.org (bombadil.infradead.org
 [IPv6:2607:7c80:54:e::133])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 3AC83203564DC
 for <linux-nvdimm@lists.01.org>; Thu, 15 Feb 2018 10:00:03 -0800 (PST)
Date: Thu, 15 Feb 2018 10:05:54 -0800
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH v4 1/3] fs: allow per-device dax status checking for
 filesystems
Message-ID: <20180215180554.GA6264@infradead.org>
References: <151871644696.27617.4390718895806529377.stgit@djiang5-desk3.ch.intel.com>
 <151871655228.27617.3514495396592472682.stgit@djiang5-desk3.ch.intel.com>
 <20180215175241.GA25223@infradead.org>
 <f5f93cd1-4d9e-c794-99fb-28daa0d1669d@intel.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <f5f93cd1-4d9e-c794-99fb-28daa0d1669d@intel.com>
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
Cc: linux-xfs@vger.kernel.org, linux-nvdimm@lists.01.org, darrick.wong@oracle.com, david@fromorbit.com, Christoph Hellwig <hch@infradead.org>, linux-ext4@vger.kernel.org
List-ID: <linux-nvdimm@lists.01.org>

On Thu, Feb 15, 2018 at 10:58:54AM -0700, Dave Jiang wrote:
> I think Darrick wanted to keep the API the same for non-XFS users. I'm
> ok with dropping the passed in sb if Darrick has no objections.

But the old API is gone - everyone either uses the new
sb_dax_supported, or the updated bdev_dax_supported.
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
