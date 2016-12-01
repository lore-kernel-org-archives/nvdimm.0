Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from smtprelay.hostedemail.com (smtprelay0066.hostedemail.com
 [216.40.44.66])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 2859D81EAC
 for <linux-nvdimm@lists.01.org>; Thu,  1 Dec 2016 08:53:51 -0800 (PST)
Date: Thu, 1 Dec 2016 11:53:46 -0500
From: Steven Rostedt <rostedt@goodmis.org>
Subject: Re: [PATCH v3 1/5] tracing: add __print_flags_u64()
Message-ID: <20161201115346.1ba16485@gandalf.local.home>
In-Reply-To: <1480610271-23699-2-git-send-email-ross.zwisler@linux.intel.com>
References: <1480610271-23699-1-git-send-email-ross.zwisler@linux.intel.com>
 <1480610271-23699-2-git-send-email-ross.zwisler@linux.intel.com>
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

On Thu,  1 Dec 2016 09:37:47 -0700
Ross Zwisler <ross.zwisler@linux.intel.com> wrote:

> Add __print_flags_u64() and the helper trace_print_flags_seq_u64() in the
> same spirit as __print_symbolic_u64() and trace_print_symbols_seq_u64().
> These functions allow us to print symbols associated with flags that are 64
> bits wide even on 32 bit machines.
> 
> These will be used by the DAX code so that we can print the flags set in a
> pfn_t such as PFN_SG_CHAIN, PFN_SG_LAST, PFN_DEV and PFN_MAP.
> 
> Without this new function I was getting errors like the following when
> compiling for i386:
> 
> ./include/linux/pfn_t.h:13:22: warning: large integer implicitly truncated
> to unsigned type [-Woverflow]
>  #define PFN_SG_CHAIN (1ULL << (BITS_PER_LONG_LONG - 1))
>   ^
> 
> Signed-off-by: Ross Zwisler <ross.zwisler@linux.intel.com>

Reviewed-by: Steven Rostedt <rostedt@goodmis.org>

-- Steve
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
