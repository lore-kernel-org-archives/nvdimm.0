Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mx1.suse.de (mx2.suse.de [195.135.220.15])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 3BE3121123E08
 for <linux-nvdimm@lists.01.org>; Mon, 10 Sep 2018 07:29:04 -0700 (PDT)
Date: Mon, 10 Sep 2018 16:29:02 +0200
From: Jan Kara <jack@suse.cz>
Subject: Re: open sets ext4_da_aops for DAX existing files
Message-ID: <20180910142902.GA30197@quack2.suse.cz>
References: <76e07643e9c36e4273588bd3e7f29d1393de4c3d.camel@hpe.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <76e07643e9c36e4273588bd3e7f29d1393de4c3d.camel@hpe.com>
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
To: "Kani, Toshi" <toshi.kani@hpe.com>
Cc: "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>, "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>
List-ID: <linux-nvdimm@lists.01.org>

On Fri 07-09-18 21:23:19, Kani, Toshi wrote:
> I noticed that both ext4_da_aops and ext4_dax_aops are used on DAX
> mounted ext4 files.  Looking at open() path:
> 
> New file
> --------
>   lookup_open
>     ext4_create
>       __ext4_new_inode
>         ext4_set_inode_flags   // Set S_DAX flag
>       ext4_set_aops            // Set aops to ext4_dax_aops
> 
> Existing file
> -------------
>   lookup_open
>     ext4_lookup
>       ext4_iget
>         ext4_set_aops          // Set aops to ext4_da_aops
>         ext4_set_inode_flags   // Set S_DAX flag
> 
> So, we set ext4_da_aops for existing files since S_DAX flag is set after
> ext4_set_aops().

Good catch. Will you send a fix? I.e., call ext4_set_inode_flags() earlier
in the ext4_iget()? Did this bug have any user visible manifestations?
Please also add:

Fixes: 5f0663bb4a64f588f0a2dd6d1be68d40f9af0086

so that stable automation picks this up. Thanks!

								Honza
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
