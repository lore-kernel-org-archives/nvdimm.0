Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mx2.suse.de (mx2.suse.de [195.135.220.15])
 (using TLSv1 with cipher ECDHE-RSA-AES256-SHA (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id C2C608200D
 for <linux-nvdimm@lists.01.org>; Mon,  6 Feb 2017 00:51:45 -0800 (PST)
Date: Mon, 6 Feb 2017 09:51:33 +0100
From: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH] mm: replace FAULT_FLAG_SIZE with parameter to huge_fault
Message-ID: <20170206085133.GB4004@quack2.suse.cz>
References: <148615748258.43180.1690152053774975329.stgit@djiang5-desk3.ch.intel.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <148615748258.43180.1690152053774975329.stgit@djiang5-desk3.ch.intel.com>
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
Cc: mawilcox@microsoft.com, linux-nvdimm@lists.01.org, dave.hansen@linux.intel.com, linux-xfs@vger.kernel.org, linux-mm@kvack.org, vbabka@suse.cz, jack@suse.com, akpm@linux-foundation.org, linux-ext4@vger.kernel.org, kirill.shutemov@linux.intel.com
List-ID: <linux-nvdimm@lists.01.org>

On Fri 03-02-17 14:31:22, Dave Jiang wrote:
> Since the introduction of FAULT_FLAG_SIZE to the vm_fault flag, it has
> been somewhat painful with getting the flags set and removed at the
> correct locations. More than one kernel oops was introduced due to
> difficulties of getting the placement correctly. Removing the flag
> values and introducing an input parameter to huge_fault that indicates
> the size of the page entry. This makes the code easier to trace and
> should avoid the issues we see with the fault flags where removal of the
> flag was necessary in the fallback paths.
> 
> Signed-off-by: Dave Jiang <dave.jiang@intel.com>

Yeah, the code looks less error-prone this way. I like it. You can add:

Reviewed-by: Jan Kara <jack@suse.cz>


								Honza
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
