From: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH 1/2] dax: some small updates to dax.txt documentation
Date: Wed, 20 Jul 2016 16:18:57 -0700
Message-ID: <20160720161857.a60913d6fae98c4c594e2e51@linux-foundation.org>
References: <20160714214049.20075-1-ross.zwisler@linux.intel.com>
	<20160720171302.13e14a0d@lwn.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20160720171302.13e14a0d@lwn.net>
Sender: linux-kernel-owner@vger.kernel.org
To: Jonathan Corbet <corbet@lwn.net>
Cc: Ross Zwisler <ross.zwisler@linux.intel.com>, linux-kernel@vger.kernel.org, Theodore Ts'o <tytso@mit.edu>, Alexander Viro <viro@zeniv.linux.org.uk>, Andreas Dilger <adilger.kernel@dilger.ca>, Dan Williams <dan.j.williams@intel.com>, Dave Chinner <david@fromorbit.com>, Jan Kara <jack@suse.com>, Matthew Wilcox <willy@linux.intel.com>, linux-doc@vger.kernel.org, linux-ext4@vger.kernel.org, linux-fsdevel@vger.kernel.org, linux-nvdimm@ml01.01.org, xfs@oss.sgi.com
List-Id: linux-nvdimm@lists.01.org

On Wed, 20 Jul 2016 17:13:02 -0600 Jonathan Corbet <corbet@lwn.net> wrote:

> On Thu, 14 Jul 2016 15:40:48 -0600
> Ross Zwisler <ross.zwisler@linux.intel.com> wrote:
> 
> > These are originally from Matthew Wilcox and were part of his huge
> > "mm,fs,dax: Change ->pmd_fault to ->huge_fault" patch that was part of PUD
> > support.
> > 
> > I'm breaking these small changes out as they stand on their own and add
> > useful information to Documentation/filesystems/dax.txt.
> 
> So how were you thinking of routing these?  I can take the docs fix, of
> course, but part 2 is a bit out of my turf.  If you want to route them
> together via another tree that's fine, just let me know.

I have them queued.  You were cc'ed on the commit!
