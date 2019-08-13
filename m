Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from hqemgate15.nvidia.com (hqemgate15.nvidia.com [216.228.121.64])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256
 bits)) (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id BDF2321306CD8
 for <linux-nvdimm@lists.01.org>; Tue, 13 Aug 2019 10:59:04 -0700 (PDT)
Subject: Re: [RFC PATCH v2 15/19] mm/gup: Introduce vaddr_pin_pages()
References: <20190809225833.6657-1-ira.weiny@intel.com>
 <20190809225833.6657-16-ira.weiny@intel.com>
 <20190812122814.GC24457@ziepe.ca>
 <20190812214854.GF20634@iweiny-DESK2.sc.intel.com>
 <20190813114706.GA29508@ziepe.ca>
 <20190813174635.GC11882@iweiny-DESK2.sc.intel.com>
From: John Hubbard <jhubbard@nvidia.com>
Message-ID: <95b05c4f-0bd6-ac31-20a2-28ee761c6238@nvidia.com>
Date: Tue, 13 Aug 2019 10:56:51 -0700
MIME-Version: 1.0
In-Reply-To: <20190813174635.GC11882@iweiny-DESK2.sc.intel.com>
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
To: Ira Weiny <ira.weiny@intel.com>, Jason Gunthorpe <jgg@ziepe.ca>
Cc: Michal Hocko <mhocko@suse.com>, Theodore Ts'o <tytso@mit.edu>, linux-nvdimm@lists.01.org, linux-rdma@vger.kernel.org, Dave Chinner <david@fromorbit.com>, linux-kernel@vger.kernel.org, Matthew Wilcox <willy@infradead.org>, linux-xfs@vger.kernel.org, linux-mm@kvack.org, linux-fsdevel@vger.kernel.org, Jan Kara <jack@suse.cz>, Andrew Morton <akpm@linux-foundation.org>, linux-ext4@vger.kernel.org
List-ID: <linux-nvdimm@lists.01.org>

On 8/13/19 10:46 AM, Ira Weiny wrote:
> On Tue, Aug 13, 2019 at 08:47:06AM -0300, Jason Gunthorpe wrote:
>> On Mon, Aug 12, 2019 at 02:48:55PM -0700, Ira Weiny wrote:
>>> On Mon, Aug 12, 2019 at 09:28:14AM -0300, Jason Gunthorpe wrote:
>>>> On Fri, Aug 09, 2019 at 03:58:29PM -0700, ira.weiny@intel.com wrote:
>>>>> From: Ira Weiny <ira.weiny@intel.com>
...
>>> So I'm open to suggestions.  Jan gave me this one, so I figured it was safer to
>>> suggest it...
>>
>> Should have the word user in it, imho
> 
> Fair enough...
> 
> user_addr_pin_pages(void __user * addr, ...) ?
> 
> uaddr_pin_pages(void __user * addr, ...) ?
> 
> I think I like uaddr...
> 

Better to spell out "user". "u" prefixes are used for "unsigned" and it
is just too ambiguous here. Maybe:

    vaddr_pin_user_pages()

...which also sounds close enough to get_user_pages() that a bit of
history and continuity is preserved, too.



thanks,
-- 
John Hubbard
NVIDIA
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
