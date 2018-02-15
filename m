Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga04.intel.com (mga04.intel.com [192.55.52.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 7FB4A223230C8
 for <linux-nvdimm@lists.01.org>; Thu, 15 Feb 2018 14:38:56 -0800 (PST)
Subject: Re: [PATCH v5 3/3] xfs: reject removal of realtime flag when datadev
 doesn't support DAX
References: <151873070632.53899.3320294279108510082.stgit@djiang5-desk3.ch.intel.com>
 <151873085471.53899.4916392112937742603.stgit@djiang5-desk3.ch.intel.com>
 <20180215214708.GA10446@infradead.org>
From: Dave Jiang <dave.jiang@intel.com>
Message-ID: <7657c80b-412b-e280-f126-a7d735a0a730@intel.com>
Date: Thu, 15 Feb 2018 15:44:48 -0700
MIME-Version: 1.0
In-Reply-To: <20180215214708.GA10446@infradead.org>
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
To: Christoph Hellwig <hch@infradead.org>
Cc: linux-nvdimm@lists.01.org, darrick.wong@oracle.com, david@fromorbit.com, linux-xfs@vger.kernel.org, linux-ext4@vger.kernel.org
List-ID: <linux-nvdimm@lists.01.org>



On 02/15/2018 02:47 PM, Christoph Hellwig wrote:
>> +	if ((XFS_IS_REALTIME_INODE(ip)) &&
> 
> No need for the inner braces.

Ok I'll fix

> 
> Except for that the whole series looks fine to me.
> 

Can I add your reviewed-by? Thanks for reviewing.
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
