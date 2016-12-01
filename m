Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from smtprelay.hostedemail.com (smtprelay0188.hostedemail.com
 [216.40.44.188])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id EC31681EAC
 for <linux-nvdimm@lists.01.org>; Thu,  1 Dec 2016 08:56:12 -0800 (PST)
Date: Thu, 1 Dec 2016 11:56:08 -0500
From: Steven Rostedt <rostedt@goodmis.org>
Subject: Re: [PATCH v3 4/5] dax: add tracepoints to dax_pmd_load_hole()
Message-ID: <20161201115608.4f97630b@gandalf.local.home>
In-Reply-To: <1480610271-23699-5-git-send-email-ross.zwisler@linux.intel.com>
References: <1480610271-23699-1-git-send-email-ross.zwisler@linux.intel.com>
 <1480610271-23699-5-git-send-email-ross.zwisler@linux.intel.com>
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
To: Ross Zwisler <ross.zwisler@linux.intel.com>
Cc: Jan Kara <jack@suse.cz>, Matthew Wilcox <mawilcox@microsoft.com>, linux-nvdimm@lists.01.org, Dave Chinner <david@fromorbit.com>, linux-kernel@vger.kernel.org, linux-mm@kvack.org, Ingo Molnar <mingo@redhat.com>, Alexander Viro <viro@zeniv.linux.org.uk>, linux-fsdevel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>, Christoph Hellwig <hch@lst.de>
List-ID: <linux-nvdimm@lists.01.org>

On Thu,  1 Dec 2016 09:37:50 -0700
Ross Zwisler <ross.zwisler@linux.intel.com> wrote:

> Add tracepoints to dax_pmd_load_hole(), following the same logging
> conventions as the tracepoints in dax_iomap_pmd_fault().
> 
> Here is an example PMD fault showing the new tracepoints:
> 
> read_big-1478  [004] ....   238.242188: xfs_filemap_pmd_fault: dev 259:0
> ino 0x1003
> 
> read_big-1478  [004] ....   238.242191: dax_pmd_fault: dev 259:0 ino 0x1003
> shared ALLOW_RETRY|KILLABLE|USER address 0x10400000 vm_start 0x10200000
> vm_end 0x10600000 pgoff 0x200 max_pgoff 0x1400
> 
> read_big-1478  [004] ....   238.242390: dax_pmd_load_hole: dev 259:0 ino
> 0x1003 shared address 0x10400000 zero_page ffffea0002c20000 radix_entry
> 0x1e
> 
> read_big-1478  [004] ....   238.242392: dax_pmd_fault_done: dev 259:0 ino
> 0x1003 shared ALLOW_RETRY|KILLABLE|USER address 0x10400000 vm_start
> 0x10200000 vm_end 0x10600000 pgoff 0x200 max_pgoff 0x1400 NOPAGE
> 
> Signed-off-by: Ross Zwisler <ross.zwisler@linux.intel.com>
> Reviewed-by: Jan Kara <jack@suse.cz>
> ---

Acked-by: Steven Rostedt <rostedt@goodmis.org>

-- Steve
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
