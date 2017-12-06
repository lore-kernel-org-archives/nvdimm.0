Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from sandeen.net (sandeen.net [63.231.237.45])
 by ml01.01.org (Postfix) with ESMTP id 201562217CE30
 for <linux-nvdimm@lists.01.org>; Wed,  6 Dec 2017 05:55:27 -0800 (PST)
Subject: Re: [xfsprogs PATCH v2 1/3] xfs_io: fix compiler warnings in getfsmap
 code
References: <20171205235651.17102-1-ross.zwisler@linux.intel.com>
 <20171205235651.17102-2-ross.zwisler@linux.intel.com>
 <20171206002743.GC5858@dastard>
From: Eric Sandeen <sandeen@sandeen.net>
Message-ID: <863e00bb-107a-7469-b573-0545ede8e2bd@sandeen.net>
Date: Wed, 6 Dec 2017 07:59:58 -0600
MIME-Version: 1.0
In-Reply-To: <20171206002743.GC5858@dastard>
Content-Language: en-US
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
To: Dave Chinner <david@fromorbit.com>, Ross Zwisler <ross.zwisler@linux.intel.com>
Cc: Jan Kara <jack@suse.cz>, "Darrick J . Wong" <darrick.wong@oracle.com>, linux-nvdimm <linux-nvdimm@lists.01.org>, fstests <fstests@vger.kernel.org>, linux-xfs <linux-xfs@vger.kernel.org>
List-ID: <linux-nvdimm@lists.01.org>

On 12/5/17 6:27 PM, Dave Chinner wrote:

> FYI, I posted a fix for this weeks ago. I think Eric has already
> picked it up, but it hasn't been pushed out into the for-next branch
> yet.

Yes, sorry for the delay.  Will be pushed out soon.
 
> Cheers,
> 
> Dave.
> 
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
