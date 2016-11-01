Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from ipmail06.adl2.internode.on.net (ipmail06.adl2.internode.on.net
 [150.101.137.129]) by ml01.01.org (Postfix) with ESMTP id 4167781CE2
 for <linux-nvdimm@lists.01.org>; Tue,  1 Nov 2016 15:12:38 -0700 (PDT)
Date: Wed, 2 Nov 2016 09:12:35 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 0/11] ext4: Convert ext4 DAX IO to iomap framework
Message-ID: <20161101221235.GB9920@dastard>
References: <1478034381-19037-1-git-send-email-jack@suse.cz>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1478034381-19037-1-git-send-email-jack@suse.cz>
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
To: Jan Kara <jack@suse.cz>
Cc: linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org, Ted Tso <tytso@mit.edu>, linux-nvdimm@lists.01.org
List-ID: <linux-nvdimm@lists.01.org>

On Tue, Nov 01, 2016 at 10:06:10PM +0100, Jan Kara wrote:
> Hello,
> 
> this patch set converts ext4 DAX IO paths to the new iomap framework and
> removes the old bh-based DAX functions. As a result ext4 gains PMD page
> fault support, also some other minor bugs get fixed. The patch set is based
> on Ross' DAX PMD page fault support series [1]. It passes xfstests both in
> DAX and non-DAX mode.
> 
> The question is how shall we merge this. If Dave is pulling PMD patches through
> XFS tree, then these patches could go there as well (chances for conflicts
> with other ext4 stuff are relatively low) or Dave could just export a stable
> branch with PMD series which Ted would just pull...

I plan to grab Ross's PMD series in the next couple of days and I'll
push it out as a stable topic branch once I've sanity tested it.  I
don't really want to take a big chunk of ext4 stuff through the XFS
tree if it can be avoided....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
