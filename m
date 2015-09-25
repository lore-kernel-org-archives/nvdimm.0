Return-Path: <linux-fsdevel-owner@vger.kernel.org>
Date: Fri, 25 Sep 2015 12:23:34 -0600
From: Ross Zwisler <ross.zwisler@linux.intel.com>
Subject: Re: [PATCH] dax: fix deadlock in __dax_fault
Message-ID: <20150925182334.GA26544@linux.intel.com>
References: <1443040800-5460-1-git-send-email-ross.zwisler@linux.intel.com>
 <20150924025225.GT3902@dastard>
 <20150924155029.GA6008@linux.intel.com>
 <20150925025357.GU3902@dastard>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20150925025357.GU3902@dastard>
Sender: linux-fsdevel-owner@vger.kernel.org
To: Dave Chinner <david@fromorbit.com>
Cc: Ross Zwisler <ross.zwisler@linux.intel.com>, linux-kernel@vger.kernel.org, Alexander Viro <viro@zeniv.linux.org.uk>, Matthew Wilcox <willy@linux.intel.com>, linux-fsdevel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>, Dan Williams <dan.j.williams@intel.com>, "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>, linux-nvdimm@lists.01.org
List-ID: <linux-nvdimm@lists.01.org>

On Fri, Sep 25, 2015 at 12:53:57PM +1000, Dave Chinner wrote:
<>
> We've already got block allocation serialisation at the filesystem
> level, and the issue is the unserialised block zeroing being done by
> the dax code. That can be fixed by moving the zeroing into the
> filesystem code when it runs "complete_unwritten" and checks whether
> the mapping has already been marked as written or not...
> 
> I've recently pointed out in a different thread that this is the
> solution to whatever that problem was (can't recall which
> thread/problem is was now :/ ) and it the same solution here. We
> already have the serialisation we need, we just need to move the
> block zeroing operation into the appropriate places to make it work
> correctly.

I think perhaps this is the thread that you're remembering:
https://lkml.org/lkml/2015/8/11/731
