Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-pg1-x543.google.com (mail-pg1-x543.google.com
 [IPv6:2607:f8b0:4864:20::543])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id EE7BD212AD5A0
 for <linux-nvdimm@lists.01.org>; Mon, 29 Jul 2019 01:31:20 -0700 (PDT)
Received: by mail-pg1-x543.google.com with SMTP id l21so27861712pgm.3
 for <linux-nvdimm@lists.01.org>; Mon, 29 Jul 2019 01:28:50 -0700 (PDT)
Date: Mon, 29 Jul 2019 16:28:41 +0800
From: Murphy Zhou <jencce.kernel@gmail.com>
Subject: Re: xfs quota test xfs/050 fails with dax mount option and "-d
 su=2m,sw=1" mkfs option
Message-ID: <20190729082841.6uiroqyygnb3ngls@XZHOUW.usersys.redhat.com>
References: <20190724094317.4yjm4smk2z47cwmv@XZHOUW.usersys.redhat.com>
 <20190729001308.GX7689@dread.disaster.area>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20190729001308.GX7689@dread.disaster.area>
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

On Mon, Jul 29, 2019 at 10:13:08AM +1000, Dave Chinner wrote:
> On Wed, Jul 24, 2019 at 05:43:17PM +0800, Murphy Zhou wrote:
> > Hi,
> > 
> > As subject.
> > 
> > -d su=2m,sw=1     && -o dax  fail
> > -d su=2m,sw=1     && NO dax  pass
> > no su mkfs option && -o dax  pass
> > no su mkfs option && NO dax  pass
> > 
> > On latest Linus tree. Reproduce every time.
> > 
> > Testing on older kernels are going on to see if it's a regression.
> > 
> > Is this failure expected ?
> 
> I'm not sure it's actually a failure at all. DAX does not do delayed
> allocation, so if the write is aligned to sunit and at EOF it will
> round the allocation up to a full stripe unit. IOWs, for this test
> once the file size gets beyond sunit on DAX, writes will allocate in
> sunit chunks.
> 
> And, well, xfs/050 has checks in it for extent size hints, and
> notruns if:
> 
>         [ $extsize -ge 512000 ] && \
>                 _notrun "Extent size hint is too large ($extsize bytes)"
> 
> Because EDQUOT occurs when:
> 
> >     + URK 99: 2097152 is out of range! [3481600,4096000]
> 
> the file has less than 3.5MB or > 4MB allocated to it, and for a
> stripe unit of > 512k, EDQUOT will occur at  <3.5MB. That's what
> we are seeing here - a 2MB allocation at offset 2MB is > 4096000
> bytes, and so it gets EDQUOT at that point....
> 
> IOWs, this looks like a test problem, not a code failure...

Got it. Thanks Dave!

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
