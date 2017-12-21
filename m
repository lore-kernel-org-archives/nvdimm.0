Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga07.intel.com (mga07.intel.com [134.134.136.100])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id BEFD422198F7D
 for <linux-nvdimm@lists.01.org>; Thu, 21 Dec 2017 09:12:13 -0800 (PST)
Date: Thu, 21 Dec 2017 10:17:01 -0700
From: Ross Zwisler <ross.zwisler@linux.intel.com>
Subject: Re: [PATCH 2/2] ext4: Fix ENOSPC handling in DAX page fault handler
Message-ID: <20171221171701.GC2158@linux.intel.com>
References: <20171221163055.3943-1-jack@suse.cz>
 <20171221163055.3943-3-jack@suse.cz>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20171221163055.3943-3-jack@suse.cz>
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
To: Jan Kara <jack@suse.cz>
Cc: Ted Tso <tytso@mit.edu>, linux-nvdimm@lists.01.org, linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org
List-ID: <linux-nvdimm@lists.01.org>

On Thu, Dec 21, 2017 at 05:30:55PM +0100, Jan Kara wrote:
> When allocation of underlying block for a page fault fails, we fail the
> fault with SIGBUS. However we may well hit ENOSPC just due to lots of
> free blocks being held by the running / committing transaction. So
> propagate the error from ext4_iomap_begin() and implement do standard
> allocation retry loop in ext4_dax_huge_fault().
> 
> Signed-off-by: Jan Kara <jack@suse.cz>

Looks good.

Reviewed-by: Ross Zwisler <ross.zwisler@linux.intel.com>
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
