Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-wr0-x22a.google.com (mail-wr0-x22a.google.com
 [IPv6:2a00:1450:400c:c0c::22a])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 1859721E2DA64
 for <linux-nvdimm@lists.01.org>; Wed, 16 Aug 2017 04:10:22 -0700 (PDT)
Received: by mail-wr0-x22a.google.com with SMTP id m57so12537529wrm.5
 for <linux-nvdimm@lists.01.org>; Wed, 16 Aug 2017 04:12:48 -0700 (PDT)
Date: Wed, 16 Aug 2017 14:12:44 +0300
From: "Kirill A. Shutemov" <kirill@shutemov.name>
Subject: Re: [PATCH v5 4/5] fs, xfs: introduce MAP_DIRECT for creating
 block-map-atomic file ranges
Message-ID: <20170816111244.uxx6kvbi3cn5clqd@node.shutemov.name>
References: <150286944610.8837.9513410258028246174.stgit@dwillia2-desk3.amr.corp.intel.com>
 <150286946864.8837.17147962029964281564.stgit@dwillia2-desk3.amr.corp.intel.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <150286946864.8837.17147962029964281564.stgit@dwillia2-desk3.amr.corp.intel.com>
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
Cc: Jan Kara <jack@suse.cz>, linux-nvdimm@lists.01.org, linux-api@vger.kernel.org, "Darrick J. Wong" <darrick.wong@oracle.com>, Dave Chinner <david@fromorbit.com>, linux-kernel@vger.kernel.org, Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org, linux-mm@kvack.org, Alexander Viro <viro@zeniv.linux.org.uk>, luto@kernel.org, linux-fsdevel@vger.kernel.org, akpm@linux-foundation.org
List-ID: <linux-nvdimm@lists.01.org>

On Wed, Aug 16, 2017 at 12:44:28AM -0700, Dan Williams wrote:
> @@ -1411,6 +1422,9 @@ unsigned long do_mmap(struct file *file, unsigned long addr,
>  
>  			/* fall through */
>  		case MAP_PRIVATE:
> +			if ((flags & (MAP_PRIVATE|MAP_DIRECT))
> +					== (MAP_PRIVATE|MAP_DIRECT))
> +				return -EINVAL;

We've already checked for MAP_PRIVATE in this codepath. Simple (flags &
MAP_DIRECT) would be enough.

-- 
 Kirill A. Shutemov
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
