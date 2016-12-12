Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga09.intel.com (mga09.intel.com [134.134.136.24])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 296548214D
 for <linux-nvdimm@lists.01.org>; Mon, 12 Dec 2016 15:14:01 -0800 (PST)
Date: Mon, 12 Dec 2016 16:13:40 -0700
From: Ross Zwisler <ross.zwisler@linux.intel.com>
Subject: Re: [ext4]  e2ae766c1b:
 BUG:sleeping_function_called_from_invalid_context_at_kernel/locking/rwsem.c
Message-ID: <20161212231340.GA23412@linux.intel.com>
References: <20161212101321.GA37214@inn.lkp.intel.com>
 <20161212163518.GA20728@quack2.suse.cz>
 <20161212221329.GB3622@linux.intel.com>
 <20161212223735.t56oui7vlqhquaks@thunk.org>
 <20161212224851.GA691@linux.intel.com>
 <20161212230020.pbl5wnbqqdgcewlg@thunk.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20161212230020.pbl5wnbqqdgcewlg@thunk.org>
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
To: Theodore Ts'o <tytso@mit.edu>, Ross Zwisler <ross.zwisler@linux.intel.com>, Jan Kara <jack@suse.cz>, kernel test robot <xiaolong.ye@intel.com>, LKML <linux-kernel@vger.kernel.org>, linux-ext4@vger.kernel.org, lkp@01.org, linux-nvdimm@lists.01.org, Dave Chinner <david@fromorbit.com>
List-ID: <linux-nvdimm@lists.01.org>

On Mon, Dec 12, 2016 at 06:00:20PM -0500, Theodore Ts'o wrote:
> On Mon, Dec 12, 2016 at 03:48:51PM -0700, Ross Zwisler wrote:
> > On Mon, Dec 12, 2016 at 05:37:36PM -0500, Theodore Ts'o wrote:
> > > Is this problem likely to happen in other file systems?  Should I take
> > > this path through the ext4 tree, or would it be better via some other
> > > git tree?
> > > 
> > > 					- Ted
> > 
> > The problem is in the generic DAX code and affects ext4 and xfs equally (ext2
> > doesn't support PMDs).
> 
> Any preferences about how to send this patch to Linus?  This issue is
> the only thing that was causing me to hold off on sending a pull
> request to Linus....

Personally I'm happy to have you send it.  Thanks!
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
