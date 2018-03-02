Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from newverein.lst.de (verein.lst.de [213.95.11.211])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id CF33622492727
 for <linux-nvdimm@lists.01.org>; Fri,  2 Mar 2018 14:47:07 -0800 (PST)
Date: Fri, 2 Mar 2018 23:53:16 +0100
From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH v5 02/12] dax: introduce IS_DEVDAX() and IS_FSDAX()
Message-ID: <20180302225316.GC31240@lst.de>
References: <151996281307.28483.12343847096989509127.stgit@dwillia2-desk3.amr.corp.intel.com>
 <151996282448.28483.10415125852182473579.stgit@dwillia2-desk3.amr.corp.intel.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <151996282448.28483.10415125852182473579.stgit@dwillia2-desk3.amr.corp.intel.com>
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
Cc: Theodore Ts'o <tytso@mit.edu>, Matthew Wilcox <mawilcox@microsoft.com>, "Darrick J. Wong" <darrick.wong@oracle.com>, linux-nvdimm@lists.01.org, linux-kernel@vger.kernel.org, stable@vger.kernel.org, linux-xfs@vger.kernel.org, linux-mm@kvack.org, Andreas Dilger <adilger.kernel@dilger.ca>, Alexander Viro <viro@zeniv.linux.org.uk>, linux-fsdevel@vger.kernel.org, Jan Kara <jack@suse.cz>, hch@lst.de
List-ID: <linux-nvdimm@lists.01.org>

> +static inline bool IS_DEVDAX(struct inode *inode)
> +{
> +	if (!IS_ENABLED(CONFIG_DEV_DAX))
> +		return false;
> +	if ((inode->i_flags & S_DAX) == 0)
> +		return false;
> +	if (!S_ISCHR(inode->i_mode))
> +		return false;
> +	return true;
> +}
> +
> +static inline bool IS_FSDAX(struct inode *inode)
> +{
> +	if (!IS_ENABLED(CONFIG_FS_DAX))
> +		return false;
> +	if ((inode->i_flags & S_DAX) == 0)
> +		return false;
> +	if (S_ISCHR(inode->i_mode))
> +		return false;
> +	return true;

Encoding the is char device or not thing here is just nasty.  I think
this is going entirely in the wrong direction.
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
