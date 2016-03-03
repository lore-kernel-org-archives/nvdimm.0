Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga09.intel.com (mga09.intel.com [134.134.136.24])
 by ml01.01.org (Postfix) with ESMTP id 7E1231A1E90
 for <linux-nvdimm@lists.01.org>; Thu,  3 Mar 2016 07:39:11 -0800 (PST)
Date: Thu, 3 Mar 2016 08:38:42 -0700
From: Ross Zwisler <ross.zwisler@linux.intel.com>
Subject: Re: [PATCH v2] dax: check return value of dax_radix_entry()
Message-ID: <20160303153842.GB23797@linux.intel.com>
References: <1456938051-14847-1-git-send-email-ross.zwisler@linux.intel.com>
 <20160303034911.GP30721@dastard>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20160303034911.GP30721@dastard>
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
To: Dave Chinner <david@fromorbit.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-nvdimm@lists.01.org, linux-kernel@vger.kernel.org
List-ID: <linux-nvdimm@lists.01.org>

On Thu, Mar 03, 2016 at 02:49:11PM +1100, Dave Chinner wrote:
> On Wed, Mar 02, 2016 at 10:00:51AM -0700, Ross Zwisler wrote:
> > dax_pfn_mkwrite() previously wasn't checking the return value of the call
> > to dax_radix_entry(), which was a mistake.
> > 
> > Instead, capture this return value and return the appropriate VM_FAULT_
> > value.
> > 
> > Signed-off-by: Ross Zwisler <ross.zwisler@linux.intel.com>
> 
> Hi Ross,
> 
> Can you please cc dax stuff to linux-fsdevel? it is way too easy to
> miss stuff like this when lkml is the only list it's sent to?

Sure, will do.
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
