Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga04.intel.com (mga04.intel.com [192.55.52.120])
 by ml01.01.org (Postfix) with ESMTP id AEF131A1E15
 for <linux-nvdimm@lists.01.org>; Mon, 15 Aug 2016 14:11:07 -0700 (PDT)
Date: Mon, 15 Aug 2016 15:11:06 -0600
From: Ross Zwisler <ross.zwisler@linux.intel.com>
Subject: Re: [PATCH 0/7] re-enable DAX PMD support
Message-ID: <20160815211106.GA31566@linux.intel.com>
References: <20160815190918.20672-1-ross.zwisler@linux.intel.com>
 <CAPcyv4j_eh8Rcozb40JeiPwvbPoMY2sCt+yTewZ-MZzUkBbj-Q@mail.gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <CAPcyv4j_eh8Rcozb40JeiPwvbPoMY2sCt+yTewZ-MZzUkBbj-Q@mail.gmail.com>
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
Cc: Theodore Ts'o <tytso@mit.edu>, "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>, Dave Chinner <david@fromorbit.com>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, Linux MM <linux-mm@kvack.org>, Andreas Dilger <adilger.kernel@dilger.ca>, Alexander Viro <viro@zeniv.linux.org.uk>, Jan Kara <jack@suse.com>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, linux-ext4 <linux-ext4@vger.kernel.org>, Andrew Morton <akpm@linux-foundation.org>
List-ID: <linux-nvdimm@lists.01.org>

On Mon, Aug 15, 2016 at 01:21:47PM -0700, Dan Williams wrote:
> On Mon, Aug 15, 2016 at 12:09 PM, Ross Zwisler
> <ross.zwisler@linux.intel.com> wrote:
> > DAX PMDs have been disabled since Jan Kara introduced DAX radix tree based
> > locking.  This series allows DAX PMDs to participate in the DAX radix tree
> > based locking scheme so that they can be re-enabled.
> 
> Looks good to me.
> 
> > This series restores DAX PMD functionality back to what it was before it
> > was disabled.  There is still a known issue between DAX PMDs and hole
> > punch, which I am currently working on and which I plan to address with a
> > separate series.
> 
> Perhaps we should hold off on applying patch 6 and 7 until after the
> hole-punch fix is ready?

Sure, I'm cool with holding off on patch 7 (the Kconfig change) until after
the hole punch fix is ready.

I don't see a reason to hold off on patch 6, though?  It stands on it's own,
implements the correct locking, and doesn't break anything.
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
