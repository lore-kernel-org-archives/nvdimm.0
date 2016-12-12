From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [ext4]  e2ae766c1b:
 BUG:sleeping_function_called_from_invalid_context_at_kernel/locking/rwsem.c
Date: Mon, 12 Dec 2016 18:00:20 -0500
Message-ID: <20161212230020.pbl5wnbqqdgcewlg@thunk.org>
References: <20161212101321.GA37214@inn.lkp.intel.com>
 <20161212163518.GA20728@quack2.suse.cz>
 <20161212221329.GB3622@linux.intel.com>
 <20161212223735.t56oui7vlqhquaks@thunk.org>
 <20161212224851.GA691@linux.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20161212224851.GA691@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Ross Zwisler <ross.zwisler@linux.intel.com>
Cc: Jan Kara <jack@suse.cz>, kernel test robot <xiaolong.ye@intel.com>, LKML <linux-kernel@vger.kernel.org>, linux-ext4@vger.kernel.org, lkp@01.org, linux-nvdimm@ml01.01.org, Dave Chinner <david@fromorbit.com>
List-Id: linux-nvdimm@lists.01.org

On Mon, Dec 12, 2016 at 03:48:51PM -0700, Ross Zwisler wrote:
> On Mon, Dec 12, 2016 at 05:37:36PM -0500, Theodore Ts'o wrote:
> > Is this problem likely to happen in other file systems?  Should I take
> > this path through the ext4 tree, or would it be better via some other
> > git tree?
> > 
> > 					- Ted
> 
> The problem is in the generic DAX code and affects ext4 and xfs equally (ext2
> doesn't support PMDs).

Any preferences about how to send this patch to Linus?  This issue is
the only thing that was causing me to hold off on sending a pull
request to Linus....

						- Ted
