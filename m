Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga02.intel.com (mga02.intel.com [134.134.136.20])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id C6D17210DC1A0
 for <linux-nvdimm@lists.01.org>; Wed,  8 Aug 2018 08:47:49 -0700 (PDT)
Subject: Re: [PATCH 2/2] [PATCH] xfs: Close race between direct IO and
 xfs_break_layouts()
References: <153367989755.37314.6889218648604435494.stgit@djiang5-desk3.ch.intel.com>
 <153367990333.37314.16218849614019392916.stgit@djiang5-desk3.ch.intel.com>
 <20180808085339.GD15413@quack2.suse.cz>
From: Dave Jiang <dave.jiang@intel.com>
Message-ID: <97fcc79a-2d2e-b2ba-562a-76533fe3696f@intel.com>
Date: Wed, 8 Aug 2018 08:47:39 -0700
MIME-Version: 1.0
In-Reply-To: <20180808085339.GD15413@quack2.suse.cz>
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
To: Jan Kara <jack@suse.cz>
Cc: tytso@mit.edu, linux-nvdimm@lists.01.org, darrick.wong@oracle.com, david@fromorbit.com, linux-xfs@vger.kernel.org, zwisler@kernel.org, linux-fsdevel@vger.kernel.org, lczerner@redhat.com, linux-ext4@vger.kernel.org, hch@lst.de
List-ID: <linux-nvdimm@lists.01.org>



On 08/08/2018 01:53 AM, Jan Kara wrote:
> On Tue 07-08-18 15:11:43, Dave Jiang wrote:
>> This patch is the duplicate of ross's fix for ext4 for xfs.
>>
>> If the refcount of a page is lowered between the time that it is returned
>> by dax_busy_page() and when the refcount is again checked in
>> xfs_break_layouts() => ___wait_var_event(), the waiting function
>> xfs_wait_dax_page() will never be called.  This means that
>> xfs_break_layouts() will still have 'retry' set to false, so we'll stop
>> looping and never check the refcount of other pages in this inode.
>>
>> Instead, always continue looping as long as dax_layout_busy_page() gives us
>> a page which it found with an elevated refcount.
>>
>> Signed-off-by: Dave Jiang <dave.jiang@intel.com>
> 
> The patch looks good to me. You can add:
> 
> Reviewed-by: Jan Kara <jack@suse.cz>
> 
> Just one minor nit below:
> 
>> @@ -746,9 +744,10 @@ xfs_break_dax_layouts(
>>  	if (!page)
>>  		return 0;
>>  
>> +	*did_unlock = true;
> 
> I think it would be more understandable to name the argument of
> xfs_break_dax_layouts() as 'retry' instead of 'did_unlock' as it's not
> about unlocking anymore.

Thanks for the review Jan! I will change. I was trying to decide between
less code change vs more clear definition. :)

> 
> 							Honza
> 
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
