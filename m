Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga18.intel.com (mga18.intel.com [134.134.136.126])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id ECF672215BD88
 for <linux-nvdimm@lists.01.org>; Mon, 29 Jan 2018 13:20:01 -0800 (PST)
Date: Mon, 29 Jan 2018 14:25:35 -0700
From: Ross Zwisler <ross.zwisler@linux.intel.com>
Subject: Re: [ndctl PATCH] ndctl: fix the default BTT sector size for reconfig
Message-ID: <20180129212535.GA5343@linux.intel.com>
References: <20180129202236.9744-1-vishal.l.verma@intel.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20180129202236.9744-1-vishal.l.verma@intel.com>
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

On Mon, Jan 29, 2018 at 01:22:36PM -0700, Vishal Verma wrote:
> reconfig attempted to reuse the 'previous' value for sector-size when
> reconfiguring to a BTT mode or blk type namespace, but this may not
> always be valid (for example when coming from a memory mode namespace).
> Instead, when reconfiguring to BTT or blk, always default to 4096
> unless a sector size is explicitly provided.
> 
> Cc: Dan Williams <dan.j.williams@intel.com>
> Reported-by: Ross Zwisler <ross.zwisler@linux.intel.com>
> Tested-by: Dave Jiang <dave.jiang@intel.com>
> Reviewed-by: Dave Jiang <dave.jiang@intel.com>
> Signed-off-by: Vishal Verma <vishal.l.verma@intel.com>

Yep, this both allows the btt namespace creation to continue and, if the user
does actually specify a bogus sector size, i.e.: 

# ./ndctl/ndctl create-namespace -f -e namespace0.0 --mode=sector -l0
failed to reconfigure namespace: Invalid argument

It prevents us from leaving our namespace in a zombie state where it is still
there but doesn't show up in 'ndctl list'.

Tested-by: Ross Zwisler <ross.zwisler@linux.intel.com>
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
