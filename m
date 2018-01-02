Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from ipmailnode02.adl6.internode.on.net
 (ipmailnode02.adl6.internode.on.net [150.101.137.148])
 by ml01.01.org (Postfix) with ESMTP id 60BE42205BE9B
 for <linux-nvdimm@lists.01.org>; Tue,  2 Jan 2018 13:39:51 -0800 (PST)
Date: Wed, 3 Jan 2018 08:44:50 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH v4 08/18] tools/testing/nvdimm: add 'bio_delay' mechanism
Message-ID: <20180102214450.GU5858@dastard>
References: <151407695916.38751.2866053440557472361.stgit@dwillia2-desk3.amr.corp.intel.com>
 <151407700353.38751.17609507477918854876.stgit@dwillia2-desk3.amr.corp.intel.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <151407700353.38751.17609507477918854876.stgit@dwillia2-desk3.amr.corp.intel.com>
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
Cc: jack@suse.cz, linux-nvdimm@lists.01.org, hch@lst.de, linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org, akpm@linux-foundation.org
List-ID: <linux-nvdimm@lists.01.org>

On Sat, Dec 23, 2017 at 04:56:43PM -0800, Dan Williams wrote:
> In support of testing truncate colliding with dma add a mechanism that
> delays the completion of block I/O requests by a programmable number of
> seconds. This allows a truncate operation to be issued while page
> references are held for direct-I/O.
> 
> Signed-off-by: Dan Williams <dan.j.williams@intel.com>

Why not put this in the generic bio layer code and then write a
generic fstest to exercise this truncate vs direct IO completion
race condition on all types of storage and filesystems?

i.e. if it sits in a nvdimm test suite, it's never going to be run
by filesystem developers....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
