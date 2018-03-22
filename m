Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mx2.suse.de (mx2.suse.de [195.135.220.15])
 (using TLSv1 with cipher ECDHE-RSA-AES256-SHA (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id B95E52252CBB3
 for <linux-nvdimm@lists.01.org>; Thu, 22 Mar 2018 07:56:32 -0700 (PDT)
Date: Thu, 22 Mar 2018 16:00:37 +0100
From: David Sterba <dsterba@suse.cz>
Subject: Re: [RFC v2 83/83] Sysfs support.
Message-ID: <20180322150037.GD6955@twin.jikos.cz>
References: <1520705944-6723-1-git-send-email-jix024@eng.ucsd.edu>
 <1520705944-6723-84-git-send-email-jix024@eng.ucsd.edu>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1520705944-6723-84-git-send-email-jix024@eng.ucsd.edu>
List-Unsubscribe: <https://lists.01.org/mailman/options/linux-nvdimm>,
 <mailto:linux-nvdimm-request@lists.01.org?subject=unsubscribe>
List-Archive: <http://lists.01.org/pipermail/linux-nvdimm/>
List-Post: <mailto:linux-nvdimm@lists.01.org>
List-Help: <mailto:linux-nvdimm-request@lists.01.org?subject=help>
List-Subscribe: <https://lists.01.org/mailman/listinfo/linux-nvdimm>,
 <mailto:linux-nvdimm-request@lists.01.org?subject=subscribe>
Reply-To: dsterba@suse.cz
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: linux-nvdimm-bounces@lists.01.org
Sender: "Linux-nvdimm" <linux-nvdimm-bounces@lists.01.org>
To: Andiry Xu <jix024@eng.ucsd.edu>
Cc: coughlan@redhat.com, linux-nvdimm@lists.01.org, Andiry Xu <jix024@cs.ucsd.edu>, miklos@szeredi.hu, david@fromorbit.com, linux-kernel@vger.kernel.org, jack@suse.com, linux-fsdevel@vger.kernel.org, swanson@cs.ucsd.edu, swhiteho@redhat.com, andiry.xu@gmail.com
List-ID: <linux-nvdimm@lists.01.org>

On Sat, Mar 10, 2018 at 10:19:04AM -0800, Andiry Xu wrote:
> From: Andiry Xu <jix024@cs.ucsd.edu>
> 
> Sysfs support allows user to get/post information of running NOVA instance.
> After mount, NOVA creates four entries under proc directory
> /proc/fs/nova/pmem#/:
> 
> timing_stats	IO_stats	allocator	gc
> 
> Show NOVA file operation timing statistics:
> cat /proc/fs/NOVA/pmem#/timing_stats
> 
> Clear timing statistics:
> echo 1 > /proc/fs/NOVA/pmem#/timing_stats
> 
> Show NOVA I/O statistics:
> cat /proc/fs/NOVA/pmem#/IO_stats
> 
> Clear I/O statistics:
> echo 1 > /proc/fs/NOVA/pmem#/IO_stats
> 
> Show NOVA allocator information:
> cat /proc/fs/NOVA/pmem#/allocator
> 
> Manual garbage collection:
> echo #inode_number > /proc/fs/NOVA/pmem#/gc

IIRC no new entries should be added to /proc, /sys is supposed to be
used. I can't find it documented though, so you'd better check with
sysfs people.
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
