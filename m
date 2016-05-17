Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mx2.suse.de (mx2.suse.de [195.135.220.15])
 (using TLSv1 with cipher ECDHE-RSA-AES256-SHA (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id F34F01A1F20
 for <linux-nvdimm@lists.01.org>; Tue, 17 May 2016 00:19:59 -0700 (PDT)
Date: Tue, 17 May 2016 09:19:50 +0200
From: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH 3/7] ext2: Avoid DAX zeroing to corrupt data
Message-ID: <20160517071950.GA31991@quack2.suse.cz>
References: <1462960733-29634-1-git-send-email-jack@suse.cz>
 <1462960733-29634-4-git-send-email-jack@suse.cz>
 <20160512184522.GA19851@linux.intel.com>
 <20160516152206.GC21714@quack2.suse.cz>
 <1463467967.3069.3.camel@intel.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1463467967.3069.3.camel@intel.com>
List-Unsubscribe: <https://lists.01.org/mailman/options/linux-nvdimm>,
 <mailto:linux-nvdimm-request@lists.01.org?subject=unsubscribe>
List-Archive: <http://lists.01.org/pipermail/linux-nvdimm/>
List-Post: <mailto:linux-nvdimm@lists.01.org>
List-Help: <mailto:linux-nvdimm-request@lists.01.org?subject=help>
List-Subscribe: <https://lists.01.org/mailman/listinfo/linux-nvdimm>,
 <mailto:linux-nvdimm-request@lists.01.org?subject=subscribe>
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Errors-To: linux-nvdimm-bounces@lists.01.org
Sender: "Linux-nvdimm" <linux-nvdimm-bounces@lists.01.org>
To: "Verma, Vishal L" <vishal.l.verma@intel.com>
Cc: "tytso@mit.edu" <tytso@mit.edu>, "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>, "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>, "jack@suse.cz" <jack@suse.cz>, "linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>
List-ID: <linux-nvdimm@lists.01.org>

On Tue 17-05-16 06:52:47, Verma, Vishal L wrote:
> On Mon, 2016-05-16 at 17:22 +0200, Jan Kara wrote:
> > On Thu 12-05-16 12:45:22, Ross Zwisler wrote:
> > > =

> > > On Wed, May 11, 2016 at 11:58:49AM +0200, Jan Kara wrote:
> > > > =

> > > > Currently ext2 zeroes any data blocks allocated for DAX inode
> > > > however it
> > > > still returns them as BH_New. Thus DAX code zeroes them again in
> > > > dax_insert_mapping() which can possibly overwrite the data that
> > > > has been
> > > > already stored to those blocks by a racing dax_io(). Avoid
> > > > marking
> > > > pre-zeroed buffers as new.
> > > > =

> > > > Reviewed-by: Ross Zwisler <ross.zwisler@linux.intel.com>
> > > > Signed-off-by: Jan Kara <jack@suse.cz>
> > > > ---
> > > > =A0fs/ext2/inode.c | 4 ++--
> > > > =A01 file changed, 2 insertions(+), 2 deletions(-)
> > > > =

> > > > diff --git a/fs/ext2/inode.c b/fs/ext2/inode.c
> > > > index 6bd58e6ff038..1f07b758b968 100644
> > > > --- a/fs/ext2/inode.c
> > > > +++ b/fs/ext2/inode.c
> > > > @@ -745,11 +745,11 @@ static int ext2_get_blocks(struct inode
> > > > *inode,
> > > > =A0			mutex_unlock(&ei->truncate_mutex);
> > > > =A0			goto cleanup;
> > > > =A0		}
> > > > -	}
> > > > +	} else
> > > > +		set_buffer_new(bh_result);
> > > > =A0
> > > > =A0	ext2_splice_branch(inode, iblock, partial,
> > > > indirect_blks, count);
> > > > =A0	mutex_unlock(&ei->truncate_mutex);
> > > > -	set_buffer_new(bh_result);
> > > > =A0got_it:
> > > > =A0	map_bh(bh_result, inode->i_sb, le32_to_cpu(chain[depth-
> > > > 1].key));
> > > > =A0	if (count > blocks_to_boundary)
> > > > --=A0
> > > > 2.6.6
> > > Interestingly this change is causing a bunch of xfstests
> > > regressions for me
> > > with ext2 + DAX.=A0=A0All of these tests pass without this one change.
> > Good catch. Attached patch fixes this issue for me. Preferably it
> > should be
> > merged before the above ext2 change.
> > =

> > 								Honza
> =

> Hey Jan,
> =

> In my patch 3 of the error handling series, I have:
> =

> -=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0err =3D dax_clear_sectors(i=
node->i_sb->s_bdev,
> -=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0le32_to_cpu(chain[depth-1].key) <<
> -=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0(inode->i_blkbits - 9),
> -=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A01 << inode->i_blkbits);
> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0err =3D sb_issue_zeroout(in=
ode->i_sb,
> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0le32_to_cpu(chain[depth-1].key), 1, GFP_NOFS);
> =

> Does this mean I have to change to send the sb_issue_zeroout for
> 'count' blocks.. i.e.

Yes, I've noticed the conflict today as well.

> -=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0err =3D dax_clear_sectors(i=
node->i_sb->s_bdev,
> -=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0le32_to_cpu(chain[depth-1].key) <<
> -=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0(inode->i_blkbits - 9),
> -=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A01 << inode->i_blkbits);
> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0err =3D sb_issue_zeroout(in=
ode->i_sb,
> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0le32_to_cpu(chain[depth-1].key), count, GFP_NOFS);
> =

> If so, I'll update my series tomorrow to include in both of these changes.

I'd prefer these two to stay separate commits (they are really
independent).  Since you already depend on other patches from the DAX
cleanup series, just add this patch to the list of dependencies and base
your change on that... Hmm?

								Honza
-- =

Jan Kara <jack@suse.com>
SUSE Labs, CR
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
