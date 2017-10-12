Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from ZenIV.linux.org.uk (zeniv.linux.org.uk [195.92.253.2])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 5938C21EA15DF
 for <linux-nvdimm@lists.01.org>; Wed, 11 Oct 2017 18:18:05 -0700 (PDT)
Date: Thu, 12 Oct 2017 02:21:32 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
Subject: Re: [PATCH v9 2/6] fs, mm: pass fd to ->mmap_validate()
Message-ID: <20171012012131.GD21978@ZenIV.linux.org.uk>
References: <150776922692.9144.16963640112710410217.stgit@dwillia2-desk3.amr.corp.intel.com>
 <150776923838.9144.15727770472447035032.stgit@dwillia2-desk3.amr.corp.intel.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <150776923838.9144.15727770472447035032.stgit@dwillia2-desk3.amr.corp.intel.com>
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
Cc: Jan Kara <jack@suse.cz>, "Darrick J. Wong" <darrick.wong@oracle.com>, linux-api@vger.kernel.org, linux-nvdimm@lists.01.org, Dave Chinner <david@fromorbit.com>, linux-xfs@vger.kernel.org, linux-mm@kvack.org, linux-fsdevel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>, Christoph Hellwig <hch@lst.de>
List-ID: <linux-nvdimm@lists.01.org>

On Wed, Oct 11, 2017 at 05:47:18PM -0700, Dan Williams wrote:
> The MAP_DIRECT mechanism for mmap intends to use a file lease to prevent
> block map changes while the file is mapped. It requires the fd to setup
> an fasync_struct for signalling lease break events to the lease holder.

*UGH*

That looks like one hell of a bad API.  You are not even guaranteed that
descriptor will remain be still open by the time you pass it down to your
helper, nevermind the moment when event actually happens...
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
