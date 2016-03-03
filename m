Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from ipmail06.adl2.internode.on.net (ipmail06.adl2.internode.on.net
 [150.101.137.129]) by ml01.01.org (Postfix) with ESMTP id 4167C1A1E5B
 for <linux-nvdimm@lists.01.org>; Wed,  2 Mar 2016 19:49:23 -0800 (PST)
Date: Thu, 3 Mar 2016 14:49:11 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH v2] dax: check return value of dax_radix_entry()
Message-ID: <20160303034911.GP30721@dastard>
References: <1456938051-14847-1-git-send-email-ross.zwisler@linux.intel.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1456938051-14847-1-git-send-email-ross.zwisler@linux.intel.com>
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
To: Ross Zwisler <ross.zwisler@linux.intel.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org, linux-nvdimm@lists.01.org
List-ID: <linux-nvdimm@lists.01.org>

On Wed, Mar 02, 2016 at 10:00:51AM -0700, Ross Zwisler wrote:
> dax_pfn_mkwrite() previously wasn't checking the return value of the call
> to dax_radix_entry(), which was a mistake.
> 
> Instead, capture this return value and return the appropriate VM_FAULT_
> value.
> 
> Signed-off-by: Ross Zwisler <ross.zwisler@linux.intel.com>

Hi Ross,

Can you please cc dax stuff to linux-fsdevel? it is way too easy to
miss stuff like this when lkml is the only list it's sent to?

That said, the change looks good.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
