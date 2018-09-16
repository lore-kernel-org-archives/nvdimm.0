Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from imap.thunk.org (imap.thunk.org
 [IPv6:2600:3c02::f03c:91ff:fe96:be03])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id BCF1421135FEF
 for <linux-nvdimm@lists.01.org>; Sat, 15 Sep 2018 18:56:51 -0700 (PDT)
Date: Sat, 15 Sep 2018 21:56:46 -0400
From: "Theodore Y. Ts'o" <tytso@mit.edu>
Subject: Re: [PATCH v2 2/3] ext4, dax: set ext4_dax_aops for dax files
Message-ID: <20180916015646.GE8652@thunk.org>
References: <20180914145114.11122-1-toshi.kani@hpe.com>
 <20180914145114.11122-3-toshi.kani@hpe.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20180914145114.11122-3-toshi.kani@hpe.com>
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
To: Toshi Kani <toshi.kani@hpe.com>
Cc: jack@suse.cz, linux-nvdimm@lists.01.org, linux-kernel@vger.kernel.org, stable@vger.kernel.org, adilger.kernel@dilger.ca, linux-ext4@vger.kernel.org
List-ID: <linux-nvdimm@lists.01.org>

On Fri, Sep 14, 2018 at 08:51:13AM -0600, Toshi Kani wrote:
> Sync syscall to DAX file needs to flush processor cache, but it
> currently does not flush to existing DAX files.  This is because
> 'ext4_da_aops' is set to address_space_operations of existing DAX
> files, instead of 'ext4_dax_aops', since S_DAX flag is set after
> ext4_set_aops() in the open path.
> 
>   New file
>   --------
>   lookup_open
>     ext4_create
>       __ext4_new_inode
>         ext4_set_inode_flags   // Set S_DAX flag
>       ext4_set_aops            // Set aops to ext4_dax_aops
> 
>   Existing file
>   -------------
>   lookup_open
>     ext4_lookup
>       ext4_iget
>         ext4_set_aops          // Set aops to ext4_da_aops
>         ext4_set_inode_flags   // Set S_DAX flag
> 
> Change ext4_iget() to initialize i_flags before ext4_set_aops().
> 
> Fixes: 5f0663bb4a64 ("ext4, dax: introduce ext4_dax_aops")
> Signed-off-by: Toshi Kani <toshi.kani@hpe.com>
> Suggested-by: Jan Kara <jack@suse.cz>
> Cc: Jan Kara <jack@suse.cz>
> Cc: Dan Williams <dan.j.williams@intel.com>
> Cc: "Theodore Ts'o" <tytso@mit.edu>
> Cc: Andreas Dilger <adilger.kernel@dilger.ca>
> Cc: <stable@vger.kernel.org>

Thanks, applied.

					- Ted
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
