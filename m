Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mx2.suse.de (mx2.suse.de [195.135.220.15])
 (using TLSv1 with cipher ECDHE-RSA-AES256-SHA (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 1FD96821AB
 for <linux-nvdimm@lists.01.org>; Tue, 13 Dec 2016 03:52:14 -0800 (PST)
Date: Tue, 13 Dec 2016 12:52:09 +0100
From: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH 0/6 v3] dax: Page invalidation fixes
Message-ID: <20161213115209.GG15362@quack2.suse.cz>
References: <20161212164708.23244-1-jack@suse.cz>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20161212164708.23244-1-jack@suse.cz>
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
To: linux-fsdevel@vger.kernel.org
Cc: Jan Kara <jack@suse.cz>, linux-nvdimm@lists.01.org, linux-mm@kvack.org, Johannes Weiner <hannes@cmpxchg.org>, linux-ext4@vger.kernel.org
List-ID: <linux-nvdimm@lists.01.org>

On Mon 12-12-16 17:47:02, Jan Kara wrote:
> Hello,
> 
> this is the third revision of my fixes of races when invalidating hole pages in
> DAX mappings. See changelogs for details. The series is based on my patches to
> write-protect DAX PTEs which are currently carried in mm tree. This is a hard
> dependency because we really need to closely track dirtiness (and cleanness!)
> of radix tree entries in DAX mappings in order to avoid discarding valid dirty
> bits leading to missed cache flushes on fsync(2).
> 
> The tests have passed xfstests for xfs and ext4 in DAX and non-DAX mode.
> 
> Johannes, are you OK with patch 2/6 in its current form? I'd like to push these
> patches to some tree once DAX write-protection patches are merged.  I'm hoping
> to get at least first three patches merged for 4.10-rc2... Thanks!

OK, with the final ack from Johannes and since this is mostly DAX stuff,
can we take this through NVDIMM tree and push to Linus either late in the
merge window or for -rc2? These patches require my DAX patches sitting in mm
tree so they can be included in any git tree only once those patches land
in Linus' tree (which may happen only once Dave and Ted push out their
stuff - this is the most convoluted merge window I'd ever to deal with ;-)...
Dan?

								Honza

> 
> Changes since v2:
> * Added Reviewed-by tags
> * Fixed commit message of patch 3
> * Slightly simplified dax_iomap_pmd_fault()
> * Renamed truncation functions to express better what they do
> 
> Changes since v1:
> * Rebased on top of patches in mm tree
> * Added some Reviewed-by tags
> * renamed some functions based on review feedback
> 
> 								Honza
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
