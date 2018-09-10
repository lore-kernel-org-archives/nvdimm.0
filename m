Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from g2t2352.austin.hpe.com (g2t2352.austin.hpe.com [15.233.44.25])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256
 bits)) (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 5A8F821B02822
 for <linux-nvdimm@lists.01.org>; Mon, 10 Sep 2018 07:51:43 -0700 (PDT)
From: "Kani, Toshi" <toshi.kani@hpe.com>
Subject: Re: open sets ext4_da_aops for DAX existing files
Date: Mon, 10 Sep 2018 14:51:34 +0000
Message-ID: <0768c59f2d5391ff7678370fbc72cb664fca25fd.camel@hpe.com>
References: <76e07643e9c36e4273588bd3e7f29d1393de4c3d.camel@hpe.com>
 <20180910142902.GA30197@quack2.suse.cz>
In-Reply-To: <20180910142902.GA30197@quack2.suse.cz>
Content-Language: en-US
Content-ID: <4EEE8232CE301F45BBC117ED525D4A39@NAMPRD84.PROD.OUTLOOK.COM>
MIME-Version: 1.0
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
To: "jack@suse.cz" <jack@suse.cz>
Cc: "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>, "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>
List-ID: <linux-nvdimm@lists.01.org>

On Mon, 2018-09-10 at 16:29 +0200, Jan Kara wrote:
> On Fri 07-09-18 21:23:19, Kani, Toshi wrote:
> > I noticed that both ext4_da_aops and ext4_dax_aops are used on DAX
> > mounted ext4 files.  Looking at open() path:
> > 
> > New file
> > --------
> >   lookup_open
> >     ext4_create
> >       __ext4_new_inode
> >         ext4_set_inode_flags   // Set S_DAX flag
> >       ext4_set_aops            // Set aops to ext4_dax_aops
> > 
> > Existing file
> > -------------
> >   lookup_open
> >     ext4_lookup
> >       ext4_iget
> >         ext4_set_aops          // Set aops to ext4_da_aops
> >         ext4_set_inode_flags   // Set S_DAX flag
> > 
> > So, we set ext4_da_aops for existing files since S_DAX flag is set after
> > ext4_set_aops().
> 
> Good catch. Will you send a fix? I.e., call ext4_set_inode_flags() earlier
> in the ext4_iget()? Did this bug have any user visible manifestations?

Yes, sync did not flush processor cache.

> Please also add:
> 
> Fixes: 5f0663bb4a64f588f0a2dd6d1be68d40f9af0086
> 
> so that stable automation picks this up. Thanks!
> 

Will do.

Thanks,
-Toshi
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
