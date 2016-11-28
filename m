Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga07.intel.com (mga07.intel.com [134.134.136.100])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id E4B7781D3E
 for <linux-nvdimm@lists.01.org>; Mon, 28 Nov 2016 11:20:36 -0800 (PST)
Date: Mon, 28 Nov 2016 12:20:35 -0700
From: Ross Zwisler <ross.zwisler@linux.intel.com>
Subject: Re: [PATCH 2/6] dax: remove leading space from labels
Message-ID: <20161128192035.GC6637@linux.intel.com>
References: <1479926662-21718-1-git-send-email-ross.zwisler@linux.intel.com>
 <1479926662-21718-3-git-send-email-ross.zwisler@linux.intel.com>
 <20161124091140.GB24138@quack2.suse.cz>
 <CAPcyv4g=4OAskS3x31H5yx0T+suDbpwQpSyDtb+36rwmKCGMng@mail.gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <CAPcyv4g=4OAskS3x31H5yx0T+suDbpwQpSyDtb+36rwmKCGMng@mail.gmail.com>
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
To: Dan Williams <dan.j.williams@intel.com>
Cc: Jan Kara <jack@suse.cz>, Andrew Morton <akpm@linux-foundation.org>, Matthew Wilcox <mawilcox@microsoft.com>, "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>, Dave Chinner <david@fromorbit.com>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, Steven Rostedt <rostedt@goodmis.org>, Linux MM <linux-mm@kvack.org>, Ingo Molnar <mingo@redhat.com>, Alexander Viro <viro@zeniv.linux.org.uk>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, linux-ext4 <linux-ext4@vger.kernel.org>, Christoph Hellwig <hch@lst.de>
List-ID: <linux-nvdimm@lists.01.org>

On Thu, Nov 24, 2016 at 11:42:38AM -0800, Dan Williams wrote:
> On Thu, Nov 24, 2016 at 1:11 AM, Jan Kara <jack@suse.cz> wrote:
> > On Wed 23-11-16 11:44:18, Ross Zwisler wrote:
> >> No functional change.
> >>
> >> As of this commit:
> >>
> >> commit 218dd85887da (".gitattributes: set git diff driver for C source code
> >> files")
> >>
> >> git-diff and git-format-patch both generate diffs whose hunks are correctly
> >> prefixed by function names instead of labels, even if those labels aren't
> >> indented with spaces.
> >
> > Fine by me. I just have some 4 remaining DAX patches (will send them out
> > today) and they will clash with this. So I'd prefer if this happened after
> > they are merged...
> 
> Let's just leave them alone, it's not like this thrash buys us
> anything at this point.  We can just stop including spaces in new
> code.

Honestly I'm not sure which is better.  I understand your argument about not
introducing "thrash" for cleanup like this, but at the same time knowingly
leaving inconsistencies in the code style just because seems...gross?

In any case, sure Jan, if this patch happens lets do it after your remaining
DAX patches.
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
