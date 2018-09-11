Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from imap.thunk.org (imap.thunk.org
 [IPv6:2600:3c02::f03c:91ff:fe96:be03])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 18BD021A00AE6
 for <linux-nvdimm@lists.01.org>; Tue, 11 Sep 2018 10:28:10 -0700 (PDT)
Date: Tue, 11 Sep 2018 13:28:06 -0400
From: "Theodore Y. Ts'o" <tytso@mit.edu>
Subject: Re: [PATCH v4 0/2] ext4: fix DAX dma vs truncate/hole-punch
Message-ID: <20180911172806.GC2225@thunk.org>
References: <20180710191031.17919-1-ross.zwisler@linux.intel.com>
 <20180711081741.lmr44sp4cmt3f6um@quack2.suse.cz>
 <20180725222839.GA28304@linux.intel.com>
 <CAOxpaSWCT+XRtGxGQT_PVMcn79csMxbqb+cf4yycbV3eqjjnkQ@mail.gmail.com>
 <20180807084545.6gzxrtrvb34hyhdq@quack2.suse.cz>
 <8c70d61a-fc5c-b928-334a-fbb2567b8dea@sandeen.net>
 <20180911151421.GD6104@quack2.suse.cz>
 <20180911152024.GE6104@quack2.suse.cz>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20180911152024.GE6104@quack2.suse.cz>
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
Cc: linux-nvdimm@lists.01.org, darrick.wong@oracle.com, Eric Sandeen <sandeen@sandeen.net>, Ross Zwisler <zwisler@kernel.org>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, lczerner@redhat.com, linux-ext4 <linux-ext4@vger.kernel.org>
List-ID: <linux-nvdimm@lists.01.org>

On Tue, Sep 11, 2018 at 05:20:24PM +0200, Jan Kara wrote:
> > Hum, it seems Ted never picked this patch up. I guess I'll gather the two
> > fixes you pointed out and resend them to Ted.
> 
> Actually only one patch when looking into it now.

I believe both are in the ext4 git tree.

  	       	      	       	   - Ted
				   

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
