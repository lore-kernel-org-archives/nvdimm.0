Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from smtprelay.hostedemail.com (smtprelay0012.hostedemail.com
 [216.40.44.12])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id DA10581D5D
 for <linux-nvdimm@lists.01.org>; Thu,  1 Dec 2016 08:11:13 -0800 (PST)
Date: Thu, 1 Dec 2016 11:11:06 -0500
From: Steven Rostedt <rostedt@goodmis.org>
Subject: Re: [PATCH v2 6/6] dax: add tracepoints to dax_pmd_insert_mapping()
Message-ID: <20161201111106.47510605@gandalf.local.home>
In-Reply-To: <20161201154432.GD5160@linux.intel.com>
References: <1480549533-29038-1-git-send-email-ross.zwisler@linux.intel.com>
 <1480549533-29038-7-git-send-email-ross.zwisler@linux.intel.com>
 <20161201091930.2084d32c@gandalf.local.home>
 <20161201154432.GD5160@linux.intel.com>
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

On Thu, 1 Dec 2016 08:44:32 -0700
Ross Zwisler <ross.zwisler@linux.intel.com> wrote:


> Actually I think it may be ideal to stick it as the 2nd entry after 'dev'.
> dev_t is:
> 
> typedef __u32 __kernel_dev_t;
> typedef __kernel_dev_t		dev_t;
> 
> So those two 32 bit values should combine into a single 64 bit space.

Yeah that should work too.

-- Steve

> 
> Thanks for the help, I obviously wasn't considering packing when ordering the
> elements.
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
