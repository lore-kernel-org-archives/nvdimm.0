Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from imap.thunk.org (imap.thunk.org
 [IPv6:2600:3c02::f03c:91ff:fe96:be03])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 0A88E210E8D6D
 for <linux-nvdimm@lists.01.org>; Thu,  9 Aug 2018 19:53:47 -0700 (PDT)
Date: Thu, 9 Aug 2018 22:53:40 -0400
From: "Theodore Y. Ts'o" <tytso@mit.edu>
Subject: Re: Help trying to use /dev/pmem for dax debugging?
Message-ID: <20180810025339.GB21087@thunk.org>
References: <20180730235312.GA5089@thunk.org>
 <20180731193642.GA3473@linux.intel.com>
 <30247efc-88f8-3e0b-fcd8-83801be5f041@intel.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <30247efc-88f8-3e0b-fcd8-83801be5f041@intel.com>
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
Cc: linux-ext4@vger.kernel.org, Matthew Wilcox <mawilcox@microsoft.com>, linux-nvdimm@lists.01.org
List-ID: <linux-nvdimm@lists.01.org>

On Tue, Jul 31, 2018 at 01:27:15PM -0700, Dave Jiang wrote:
> 
> On 7/31/2018 12:36 PM, Ross Zwisler wrote:
> > On Mon, Jul 30, 2018 at 07:53:12PM -0400, Theodore Y. Ts'o wrote:
> > > In newer kernels, it looks like you can't use /dev/pmem0 for DAX
> > > unless it's marked as being DAX capable.  This appears to require
> > > CONFIG_NVDIMM_PFN.  But when I tried to build a kernel with that
> > > configured, I get the following BUG:
> >
> > You're using the memmap kernel command line parameter to reserve normal
> > memory to be treated as normal memory, but you've also got kernel address
> > randomization turned on in your kernel config:
> > 
> > CONFIG_RANDOMIZE_BASE=y
> > CONFIG_RANDOMIZE_MEMORY=y
> > 
> > You need to turn these off for the memmap kernel command line parameter, else
> > the memory we're using could overlap with addresses used for other things.
> 
> I believe this issue was fixed a while back. Although we probably can see if
> that is the issue or something else.

I turned off RANDOMIZE_BASE and RANDOMIZE_MEMORY, but that didn't fix
my problem.

It turns out the problem was KASAN.  It looks like using memmap to
create test /dev/pmemX devices is not compatible with CONFIG_KASAN
being enabled.

So I have a workaround for now, but it seems this to be a bug in
KASAN, or at least an unfortunate interaction between KASAN and
NVDIMM_PFN.

						- Ted
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
