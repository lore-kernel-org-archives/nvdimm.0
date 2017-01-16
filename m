From: Stephen Rothwell <sfr@canb.auug.org.au>
Subject: Re: linux-next 0112 tree breaks fs DAX
Date: Mon, 16 Jan 2017 21:45:43 +1100
Message-ID: <20170116214543.1388c2e9@canb.auug.org.au>
References: <20170113101641.3jecr5qx2pgajc2k@XZHOUW.usersys.redhat.com>
        <20170116092916.lltpfa24gzlj3hkr@XZHOUW.usersys.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <20170116092916.lltpfa24gzlj3hkr@XZHOUW.usersys.redhat.com>
Sender: linux-fsdevel-owner@vger.kernel.org
To: Xiong Zhou <xzhou@redhat.com>
Cc: linux-nvdimm@ml01.01.org, dave.jiang@intel.com, linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, linux-next@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>
List-Id: linux-nvdimm@lists.01.org

Hi Xiong,

Just cc'ing Andrew.

On Mon, 16 Jan 2017 17:29:16 +0800 Xiong Zhou <xzhou@redhat.com> wrote:
>
> On Fri, Jan 13, 2017 at 06:16:41PM +0800, Xiong Zhou wrote:
> > Hi,
> > 
> > These cases "hang" when testing with -o dax mount option:
> > xfstests generic/030 generic/34{0,4,5,6} generic/198
> > (maybe more)
> > 
> > The test programme holetest or aiodio keep running for a
> > long time. It's killable, but it seems never return.
> > 
> > With both ext4 and xfs as fs.
> > 
> > Without -o dax mount option, cases pass in seconds.
> > 
> > 0111 tree passed the tests.
> > 
> > sh-4.2# git log --oneline next-20170111..next-20170112 fs/dax.c
> > 0c9a7909dd13 mm, dax: change pmd_fault() to take only vmf parameter
> > f8dbc198d4ea mm, dax: make pmd_fault() and friends be the same as fault()  
> 
> 0112 tree with above 2 commits reverted pass the tests.

-- 
Cheers,
Stephen Rothwell
