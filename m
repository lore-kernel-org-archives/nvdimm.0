Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mx1.suse.de (mx2.suse.de [195.135.220.15])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id E248C208D613B
 for <linux-nvdimm@lists.01.org>; Tue, 19 Feb 2019 04:35:40 -0800 (PST)
Date: Tue, 19 Feb 2019 13:35:36 +0100
From: Jan Kara <jack@suse.cz>
Subject: Re: [LSF/MM TOPIC] Standardizing semantics around the per-file DAX
 flag
Message-ID: <20190219123536.GA27420@quack2.suse.cz>
References: <20190213164039.GA16285@mit.edu>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20190213164039.GA16285@mit.edu>
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
To: "Theodore Y. Ts'o" <tytso@mit.edu>
Cc: linux-fsdevel@vger.kernel.org, lsf-pc@lists.linux-foundation.org, linux-nvdimm@lists.01.org
List-ID: <linux-nvdimm@lists.01.org>

On Wed 13-02-19 11:40:39, Theodore Y. Ts'o wrote:
> There's been a long-term disagreement about how the per-file DAX flag
> should work.
> 
>        * Should it exist at all?
>        * What happens when the DAX flag is cleared?
>            * Should it be not allowed and return an error?
> 	       (Or maybe only if the file is otherwise opened anywhere in the system?)
> 	   * Should it only takes effect when the file system is unmounted,
> 	     or when the inode drops out of the inode cache?
> 	* Should we remove the flag entirely and make it be something the
> 	  system automagically infers?
> 
> I had hoped consensus would be achieved before the ext4 per-file DAX
> flag lands, but it hasn't for a *long* time.  Technically the DAX flag
> is "experimental", which technically means it could be removed ---
> although I suspect at this point, it would break some userspace, so
> our options about how to adjust the semantics of the flag are probably
> constrained.

Well, there's no filesystem that would really support the DAX flag
currently (XFS accepts it, stores it, but does nothing with it). So I think
we are reasonably free in defining the semantics. Also I think this is
closely related to Dan's topic "What should be done to remove experimental
tag from DAX" (or however it was called).

							Honza
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
