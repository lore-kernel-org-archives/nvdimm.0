Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mx1.suse.de (mx2.suse.de [195.135.220.15])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 1778E21B02822
 for <linux-nvdimm@lists.01.org>; Wed, 12 Sep 2018 02:31:43 -0700 (PDT)
Date: Wed, 12 Sep 2018 11:31:40 +0200
From: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH 2/2] ext4, dax: set ext4_dax_aops for dax files
Message-ID: <20180912093140.GB7782@quack2.suse.cz>
References: <20180911154246.6844-1-toshi.kani@hpe.com>
 <20180911154246.6844-3-toshi.kani@hpe.com>
 <CAPcyv4iEZ7q0MV7n-_eovrJw_U9S3=pkY_nYwtw1jSBS7vPqCQ@mail.gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <CAPcyv4iEZ7q0MV7n-_eovrJw_U9S3=pkY_nYwtw1jSBS7vPqCQ@mail.gmail.com>
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
To: Dan Williams <dan.j.williams@intel.com>
Cc: Theodore Ts'o <tytso@mit.edu>, linux-nvdimm <linux-nvdimm@lists.01.org>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, Andreas Dilger <adilger.kernel@dilger.ca>, Jan Kara <jack@suse.cz>, linux-ext4 <linux-ext4@vger.kernel.org>
List-ID: <linux-nvdimm@lists.01.org>

On Tue 11-09-18 11:15:18, Dan Williams wrote:
> On Tue, Sep 11, 2018 at 8:42 AM, Toshi Kani <toshi.kani@hpe.com> wrote:
> > Sync syscall to an existing DAX file needs to flush processor cache,
> > but it does not currently.  This is because 'ext4_da_aops' is set to
> > address_space_operations of existing DAX files, instead of 'ext4_dax_aops',
> > since S_DAX flag is set after ext4_set_aops() in the open path.
> >
> >   New file
> >   --------
> >   lookup_open
> >     ext4_create
> >       __ext4_new_inode
> >         ext4_set_inode_flags   // Set S_DAX flag
> >       ext4_set_aops            // Set aops to ext4_dax_aops
> >
> >   Existing file
> >   -------------
> >   lookup_open
> >     ext4_lookup
> >       ext4_iget
> >         ext4_set_aops          // Set aops to ext4_da_aops
> >         ext4_set_inode_flags   // Set S_DAX flag
> >
> > Change ext4_iget() to call ext4_set_inode_flags() before ext4_set_aops().
> >
> > Fixes: 5f0663bb4a64f588f0a2dd6d1be68d40f9af0086
> 
> Same format nit:
> 
> Fixes: 5f0663bb4a64 ("ext4, dax: introduce ext4_dax_aops")
> Cc: <stable@vger.kernel.org>
> 
> 
> > Signed-off-by: Toshi Kani <toshi.kani@hpe.com>
> > Cc: Jan Kara <jack@suse.cz>
> > Cc: Dan Williams <dan.j.williams@intel.com>
> > Cc: "Theodore Ts'o" <tytso@mit.edu>
> > Cc: Andreas Dilger <adilger.kernel@dilger.ca>
> > ---
> >  fs/ext4/inode.c |    3 ++-
> >  1 file changed, 2 insertions(+), 1 deletion(-)
> >
> > diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
> > index 775cd9b4af55..93cbbb859c40 100644
> > --- a/fs/ext4/inode.c
> > +++ b/fs/ext4/inode.c
> > @@ -4998,6 +4998,8 @@ struct inode *ext4_iget(struct super_block *sb, unsigned long ino)
> >         if (ret)
> >                 goto bad_inode;
> >
> > +       ext4_set_inode_flags(inode);
> > +
> 
> Hmm, does this have unintended behavior changes?
> 
> I notice that there are some checks for flags "IS_APPEND(inode) ||
> IS_IMMUTABLE(inode)" *before* the call to ext4_set_inode_flags(). I
> didn't look too much deeper at whether those checks are bogus, but it
> would seem safer to do something like this for a lower risk fix.
> 
> Thoughts?

Well, safer but it would leave the landmine around for others to hit.
Toshi, please move the ext4_set_inode_flags() call to be just after the
assignment:

	ei->i_flags = le32_to_cpu(raw_inode->i_flags);

in ext4_iget(). That way people won't introduce checks for i_flags that can
never hit... And yes, it fixes also other bugs (mostly in sanity checks
AFAICS) than the DAX issue.

								Honza

> 
> diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
> index d0dd585add6a..1e9ab445c777 100644
> --- a/fs/ext4/inode.c
> +++ b/fs/ext4/inode.c
> @@ -4999,7 +4999,6 @@ struct inode *ext4_iget(struct super_block *sb,
> unsigned long ino)
>         if (S_ISREG(inode->i_mode)) {
>                 inode->i_op = &ext4_file_inode_operations;
>                 inode->i_fop = &ext4_file_operations;
> -               ext4_set_aops(inode);
>         } else if (S_ISDIR(inode->i_mode)) {
>                 inode->i_op = &ext4_dir_inode_operations;
>                 inode->i_fop = &ext4_dir_operations;
> @@ -5042,6 +5041,12 @@ struct inode *ext4_iget(struct super_block *sb,
> unsigned long ino)
>         }
>         brelse(iloc.bh);
>         ext4_set_inode_flags(inode);
> +       /*
> +        * Now that we have determined whether DAX is enabled, set the
> +        * proper address spaces operations
> +        */
> +       if (S_ISREG(inode->i_mode))
> +               ext4_set_aops(inode);
> 
>         unlock_new_inode(inode);
>         return inode;
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
