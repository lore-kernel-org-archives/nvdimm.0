Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mx2.suse.de (mx2.suse.de [195.135.220.15])
 (using TLSv1 with cipher ECDHE-RSA-AES256-SHA (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 575621A1F6C
 for <linux-nvdimm@lists.01.org>; Mon, 16 May 2016 08:22:15 -0700 (PDT)
Date: Mon, 16 May 2016 17:22:06 +0200
From: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH 3/7] ext2: Avoid DAX zeroing to corrupt data
Message-ID: <20160516152206.GC21714@quack2.suse.cz>
References: <1462960733-29634-1-git-send-email-jack@suse.cz>
 <1462960733-29634-4-git-send-email-jack@suse.cz>
 <20160512184522.GA19851@linux.intel.com>
MIME-Version: 1.0
In-Reply-To: <20160512184522.GA19851@linux.intel.com>
Content-Disposition: inline
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
To: Ross Zwisler <ross.zwisler@linux.intel.com>
Cc: Ted Tso <tytso@mit.edu>, linux-nvdimm@lists.01.org, linux-fsdevel@vger.kernel.org, Jan Kara <jack@suse.cz>, linux-ext4@vger.kernel.org
List-ID: <linux-nvdimm@lists.01.org>

On Thu 12-05-16 12:45:22, Ross Zwisler wrote:
> On Wed, May 11, 2016 at 11:58:49AM +0200, Jan Kara wrote:
> > Currently ext2 zeroes any data blocks allocated for DAX inode however it
> > still returns them as BH_New. Thus DAX code zeroes them again in
> > dax_insert_mapping() which can possibly overwrite the data that has been
> > already stored to those blocks by a racing dax_io(). Avoid marking
> > pre-zeroed buffers as new.
> > 
> > Reviewed-by: Ross Zwisler <ross.zwisler@linux.intel.com>
> > Signed-off-by: Jan Kara <jack@suse.cz>
> > ---
> >  fs/ext2/inode.c | 4 ++--
> >  1 file changed, 2 insertions(+), 2 deletions(-)
> > 
> > diff --git a/fs/ext2/inode.c b/fs/ext2/inode.c
> > index 6bd58e6ff038..1f07b758b968 100644
> > --- a/fs/ext2/inode.c
> > +++ b/fs/ext2/inode.c
> > @@ -745,11 +745,11 @@ static int ext2_get_blocks(struct inode *inode,
> >  			mutex_unlock(&ei->truncate_mutex);
> >  			goto cleanup;
> >  		}
> > -	}
> > +	} else
> > +		set_buffer_new(bh_result);
> >  
> >  	ext2_splice_branch(inode, iblock, partial, indirect_blks, count);
> >  	mutex_unlock(&ei->truncate_mutex);
> > -	set_buffer_new(bh_result);
> >  got_it:
> >  	map_bh(bh_result, inode->i_sb, le32_to_cpu(chain[depth-1].key));
> >  	if (count > blocks_to_boundary)
> > -- 
> > 2.6.6
> 
> Interestingly this change is causing a bunch of xfstests regressions for me
> with ext2 + DAX.  All of these tests pass without this one change.

Good catch. Attached patch fixes this issue for me. Preferably it should be
merged before the above ext2 change.

								Honza
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
