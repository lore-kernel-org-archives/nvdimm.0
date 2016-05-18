Return-Path: <linux-fsdevel-owner@vger.kernel.org>
Date: Wed, 18 May 2016 13:34:22 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
Subject: Re: dax-misc branch for linux-next
Message-ID: <20160518133422.6dfbad0b@canb.auug.org.au>
In-Reply-To: <1463510194.29294.77.camel@intel.com>
References: <1463510194.29294.77.camel@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-fsdevel-owner@vger.kernel.org
To: "Verma, Vishal L" <vishal.l.verma@intel.com>
Cc: "Williams, Dan J" <dan.j.williams@intel.com>, hch@infradead.org, jack@suse.cz, linux-nvdimm@lists.01.org, tytso@mit.edu, linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org
List-ID: <linux-nvdimm@lists.01.org>

Hi Vishal,

On Tue, 17 May 2016 18:36:47 +0000 "Verma, Vishal L" <vishal.l.verma@intel.com> wrote:
>
> I understand this is a bit out of the norm, but:
> 
> Could you please merge
> 
> 	https://git.kernel.org/cgit/linux/kernel/git/nvdimm/nvdimm.git dax-misc
> 
> into linux-next for some coverage.
> 
> It is a bit late to the ready-before-merge-window deadline, due to
> having to coordinate dependencies between trees/patchsets. I'm hoping to
> send a pull request for this later in the merge window (once ext4 is
> merged).

Added from today.

Thanks for adding your subsystem tree as a participant of linux-next.  As
you may know, this is not a judgement of your code.  The purpose of
linux-next is for integration testing and to lower the impact of
conflicts between subsystems in the next merge window. 

You will need to ensure that the patches/commits in your tree/series have
been:
     * submitted under GPL v2 (or later) and include the Contributor's
        Signed-off-by,
     * posted to the relevant mailing list,
     * reviewed by you (or another maintainer of your subsystem tree),
     * successfully unit tested, and 
     * destined for the current or next Linux merge window.

Basically, this should be just what you would send to Linus (or ask him
to fetch).  It is allowed to be rebased if you deem it necessary.

-- 
Cheers,
Stephen Rothwell 
sfr@canb.auug.org.au
