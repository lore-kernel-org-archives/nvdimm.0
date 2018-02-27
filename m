Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from ipmail03.adl2.internode.on.net (ipmail03.adl2.internode.on.net
 [150.101.137.141])
 by ml01.01.org (Postfix) with ESMTP id 208EA20954CB8
 for <linux-nvdimm@lists.01.org>; Tue, 27 Feb 2018 14:17:42 -0800 (PST)
Date: Wed, 28 Feb 2018 09:23:45 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH v4 00/12] vfio, dax: prevent long term filesystem-dax
 pins and other fixes
Message-ID: <20180227222345.GK30854@dastard>
References: <151970519370.26729.1011551137381425076.stgit@dwillia2-desk3.amr.corp.intel.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <151970519370.26729.1011551137381425076.stgit@dwillia2-desk3.amr.corp.intel.com>
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
Cc: Jane Chu <jane.chu@oracle.com>, Michal Hocko <mhocko@suse.com>, Jan Kara <jack@suse.cz>, kvm@vger.kernel.org, linux-nvdimm@lists.01.org, Matthew Wilcox <mawilcox@microsoft.com>, linux-kernel@vger.kernel.org, stable@vger.kernel.org, Christoph Hellwig <hch@lst.de>, "supporter:XFS FILESYSTEM" <linux-xfs@vger.kernel.org>, linux-mm@kvack.org, Alex Williamson <alex.williamson@redhat.com>, Gerd Rausch <gerd.rausch@oracle.com>, Andreas Dilger <adilger.kernel@dilger.ca>, Alexander Viro <viro@zeniv.linux.org.uk>, Jan Kara <jack@suse.com>, linux-fsdevel@vger.kernel.org, Theodore Ts'o <tytso@mit.edu>, "Darrick J. Wong" <darrick.wong@oracle.com>
List-ID: <linux-nvdimm@lists.01.org>

On Mon, Feb 26, 2018 at 08:19:54PM -0800, Dan Williams wrote:
> The following series implements...
> Changes since v3 [1]:
> 
> * Kill IS_DAX() in favor of explicit IS_FSDAX() and IS_DEVDAX() helpers.
>   Jan noted, "having IS_DAX() and IS_FSDAX() doing almost the same, just
>   not exactly the same, is IMHO a recipe for confusion", and I agree. A
>   nice side effect of this elimination is a cleanup to remove occasions of
>   "#ifdef CONFIG_FS_DAX" in C files, it is all moved to header files
>   now. (Jan)

Dan, can you please stop sending random patches in a patch set to
random lists?  Your patchsets are hitting 4 or 5 different procmail
filters here and so it gets split across several different mailing
list buckets. It's really annoying to have to go reconstruct every
patch set you send back into a single series in a single bucket....

Can you please fix up your patch set sending again?

-Dave.
-- 
Dave Chinner
david@fromorbit.com
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
