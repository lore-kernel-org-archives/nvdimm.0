Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mx1.suse.de (mx2.suse.de [195.135.220.15])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id D374B21A07A80
 for <linux-nvdimm@lists.01.org>; Tue, 11 Sep 2018 08:20:25 -0700 (PDT)
Date: Tue, 11 Sep 2018 17:20:24 +0200
From: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH v4 0/2] ext4: fix DAX dma vs truncate/hole-punch
Message-ID: <20180911152024.GE6104@quack2.suse.cz>
References: <20180710191031.17919-1-ross.zwisler@linux.intel.com>
 <20180711081741.lmr44sp4cmt3f6um@quack2.suse.cz>
 <20180725222839.GA28304@linux.intel.com>
 <CAOxpaSWCT+XRtGxGQT_PVMcn79csMxbqb+cf4yycbV3eqjjnkQ@mail.gmail.com>
 <20180807084545.6gzxrtrvb34hyhdq@quack2.suse.cz>
 <8c70d61a-fc5c-b928-334a-fbb2567b8dea@sandeen.net>
 <20180911151421.GD6104@quack2.suse.cz>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20180911151421.GD6104@quack2.suse.cz>
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
To: Eric Sandeen <sandeen@sandeen.net>
Cc: Jan Kara <jack@suse.cz>, linux-nvdimm@lists.01.org, darrick.wong@oracle.com, Theodore Ts'o <tytso@mit.edu>, Ross Zwisler <zwisler@kernel.org>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, lczerner@redhat.com, linux-ext4 <linux-ext4@vger.kernel.org>
List-ID: <linux-nvdimm@lists.01.org>

On Tue 11-09-18 17:14:21, Jan Kara wrote:
> On Mon 10-09-18 17:18:49, Eric Sandeen wrote:
> > On 8/7/18 3:45 AM, Jan Kara wrote:
> > > 
> > > OK, this is a good catch and the patch looks good. You can add:
> > > 
> > > Reviewed-by: Jan Kara <jack@suse.cz>
> > > 
> > > Also please post this fix officially to Ted to include it in his tree (I
> > > can see that he has all your other patches queued for the merge window).
> > 
> > Did these ever get on Ted's radar?  I don't see it upstream yet.
> 
> Hum, it seems Ted never picked this patch up. I guess I'll gather the two
> fixes you pointed out and resend them to Ted.

Actually only one patch when looking into it now.

								Honza
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
