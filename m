Return-Path: <linux-fsdevel-owner@vger.kernel.org>
Date: Thu, 11 Sep 2014 15:34:52 -0400
From: Matthew Wilcox <willy@linux.intel.com>
Subject: Re: [Linux-nvdimm] [PATCH 1/9] SQUASHME: pmem: Remove unused
 #include headers
Message-ID: <20140911193452.GJ27730@localhost.localdomain>
References: <1409173922-7484-1-git-send-email-ross.zwisler@linux.intel.com>
 <540F1EC6.4000504@plexistor.com>
 <540F1F6F.7090905@plexistor.com>
 <1410301783.8366.1.camel@rzwisler-mobl1.amr.corp.intel.com>
 <20140910191642.GI27730@localhost.localdomain>
 <541188ED.9090709@plexistor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <541188ED.9090709@plexistor.com>
Sender: linux-fsdevel-owner@vger.kernel.org
To: Boaz Harrosh <boaz@plexistor.com>
Cc: Matthew Wilcox <willy@linux.intel.com>, Ross Zwisler <ross.zwisler@linux.intel.com>, Jens Axboe <axboe@fb.com>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, Andrew Morton <akpm@linux-foundation.org>, Matthew Wilcox <matthew.r.wilcox@intel.com>, linux-nvdimm@lists.01.org
List-ID: <linux-nvdimm@lists.01.org>

On Thu, Sep 11, 2014 at 02:35:09PM +0300, Boaz Harrosh wrote:
> If header B has an API like
> typeA1 b_foo(typeA2 a2, typeA3 a3);
> where typeA1, typeA2, typeA3 are from an included header A
> and code in C.c needs the use of b_foo(), or even say b_foo is a vector
> that C.c needs to implement. Then typeA1, typeA2, typeA3 are explicit
> by B not implicit.
> 
> Implicit is if B has private structures with say typeXy from header X
> but my code does not need to declare or implement any X types. in order
> to use public API of B.

If I change B to no longer include A, and declare, but not define types
A1-A3, a file which relies on the inclusion of B to define types A1-A3
is now broken.

