Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 435E321A02937
 for <linux-nvdimm@lists.01.org>; Tue, 11 Sep 2018 11:21:22 -0700 (PDT)
Subject: Re: [PATCH v4 0/2] ext4: fix DAX dma vs truncate/hole-punch
References: <20180710191031.17919-1-ross.zwisler@linux.intel.com>
 <20180711081741.lmr44sp4cmt3f6um@quack2.suse.cz>
 <20180725222839.GA28304@linux.intel.com>
 <CAOxpaSWCT+XRtGxGQT_PVMcn79csMxbqb+cf4yycbV3eqjjnkQ@mail.gmail.com>
 <20180807084545.6gzxrtrvb34hyhdq@quack2.suse.cz>
 <8c70d61a-fc5c-b928-334a-fbb2567b8dea@sandeen.net>
 <20180911151421.GD6104@quack2.suse.cz> <20180911152024.GE6104@quack2.suse.cz>
 <20180911172806.GC2225@thunk.org>
From: Eric Sandeen <esandeen@redhat.com>
Message-ID: <c026e902-c0e8-a8f3-1108-b8079321843b@redhat.com>
Date: Tue, 11 Sep 2018 13:21:19 -0500
MIME-Version: 1.0
In-Reply-To: <20180911172806.GC2225@thunk.org>
Content-Language: en-US
List-Unsubscribe: <https://lists.01.org/mailman/options/linux-nvdimm>,
 <mailto:linux-nvdimm-request@lists.01.org?subject=unsubscribe>
List-Archive: <http://lists.01.org/pipermail/linux-nvdimm/>
List-Post: <mailto:linux-nvdimm@lists.01.org>
List-Help: <mailto:linux-nvdimm-request@lists.01.org?subject=help>
List-Subscribe: <https://lists.01.org/mailman/listinfo/linux-nvdimm>,
 <mailto:linux-nvdimm-request@lists.01.org?subject=subscribe>
Reply-To: sandeen@redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: linux-nvdimm-bounces@lists.01.org
Sender: "Linux-nvdimm" <linux-nvdimm-bounces@lists.01.org>
To: "Theodore Y. Ts'o" <tytso@mit.edu>, Jan Kara <jack@suse.cz>
Cc: linux-nvdimm@lists.01.org, darrick.wong@oracle.com, Eric Sandeen <sandeen@sandeen.net>, Ross Zwisler <zwisler@kernel.org>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, lczerner@redhat.com, linux-ext4 <linux-ext4@vger.kernel.org>
List-ID: <linux-nvdimm@lists.01.org>

On 9/11/18 12:28 PM, Theodore Y. Ts'o wrote:
> On Tue, Sep 11, 2018 at 05:20:24PM +0200, Jan Kara wrote:
>>> Hum, it seems Ted never picked this patch up. I guess I'll gather the two
>>> fixes you pointed out and resend them to Ted.
>>
>> Actually only one patch when looking into it now.
> 
> I believe both are in the ext4 git tree.
> 
>   	       	      	       	   - Ted

Ok, right:

dax: dax_layout_busy_page() warn on !exceptional
https://git.kernel.org/pub/scm/linux/kernel/git/tytso/ext4.git/commit/?h=dev&id=cdbf8897cb09b7baf2b8a7e78051a35a872b01d5

ext4: handle layout changes to pinned DAX mappings
https://git.kernel.org/pub/scm/linux/kernel/git/tytso/ext4.git/commit/?h=dev&id=430657b6be896db57d974375cc499ca212c7f01d

I think the one I meant to ask about was:

[PATCH v2 1/2] ext4: Close race between direct IO and ext4_break_layouts()

https://patchwork.kernel.org/patch/10560393/

Sorry for the confusion.

-Eric
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
