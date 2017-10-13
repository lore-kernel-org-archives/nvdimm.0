Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 20CE821F7D4F2
 for <linux-nvdimm@lists.01.org>; Thu, 12 Oct 2017 19:05:00 -0700 (PDT)
Date: Fri, 13 Oct 2017 10:08:29 +0800
From: Xiong Zhou <xzhou@redhat.com>
Subject: Re: ffsb job does not exit on xfs 4.14-rc1+
Message-ID: <20171013020829.2bqzj5d3ny66opgz@XZHOUW.usersys.redhat.com>
References: <20170925014006.5tvdkjszrbj6uhgc@XZHOUW.usersys.redhat.com>
 <20170925084903.fsjgrn7rfernou5j@hades.localdomain>
 <20171011135415.6omvzcdflflqghbo@XZHOUW.usersys.redhat.com>
 <20171011211010.GA3666@dastard>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20171011211010.GA3666@dastard>
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
Cc: linux-xfs@vger.kernel.org, linux-nvdimm@lists.01.org
List-ID: <linux-nvdimm@lists.01.org>

On Thu, Oct 12, 2017 at 08:10:10AM +1100, Dave Chinner wrote:
> On Wed, Oct 11, 2017 at 09:54:15PM +0800, Xiong Zhou wrote:
> > On Mon, Sep 25, 2017 at 10:49:03AM +0200, Carlos Maiolino wrote:
> > > On Mon, Sep 25, 2017 at 01:40:06AM +0000, Xiong Zhou wrote:
> > > > Hi,
> > > > 
> > > > ffsb test won't exit like this on Linus tree 4.14-rc1+.
> > > > Latest commit cd4175b11685

Hi all,

This is a false alarm because I've messed up the kernel config.
After making .config right, test does not hang.

My fault. Very Sorry for the noise.

> > > 
> > > Can you provide more information? Do you have any kernel log from this issue?
> > > dmesg, Oopses, traces, etc.
> > > Storage configuration might also be required here.
> > 
> > Turns out this only repreduces on nvdimm devices, xfs without dax
> > mount option. More logs are attached.
> 
> It's a hang, so what's the output of sysrq-w once it's hung?
> 
> > > have you also tried to reproduce it with another filesystem? If so, is the same
> > > problem reproducible with another filesystem or only with XFS?
> > 
> > Only xfs. Test on ext4 ends shortly.
> > 
> > > 
> > > P.S. please avoid sending it to all lists (mainly LKML).
> > 
> > Why?  I thought LKML was better archived.
> 
> The lists are all archived, but that's irrelevant. The list you
> should report problems to is based on the scope of the problem, not
> whether the lists are archived or not.
> 
> Because the scope of the problem at this point is XFS, it's
> inappropriate to report it to lists that are for general kernel or
> VFS issues. There's enough noise on those lists without everyone
> bombarding them with subsystem specific issues - that's why we have
> subsystem specific lists in the first place.
> 
> If it turns out to be a problem in some other subsystem, we'll add
> cc's to other subsystem or general lists as appropriate.

Fair enough. Thanks very much for your time!

Xiong

> 
> Cheers,
> 
> Dave.
> -- 
> Dave Chinner
> david@fromorbit.com
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
