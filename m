Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from g2t2353.austin.hpe.com (g2t2353.austin.hpe.com [15.233.44.26])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256
 bits)) (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 5CC832205B913
 for <linux-nvdimm@lists.01.org>; Fri, 12 Jan 2018 13:33:13 -0800 (PST)
From: "Kani, Toshi" <toshi.kani@hpe.com>
Subject: Re: DAX 2MB mappings for XFS
Date: Fri, 12 Jan 2018 21:38:22 +0000
Message-ID: <1515795857.16384.34.camel@hpe.com>
References: <1515788779.16384.29.camel@hpe.com>
 <20180112211915.GF27323@dastard>
In-Reply-To: <20180112211915.GF27323@dastard>
Content-Language: en-US
Content-ID: <B92D8456DC95314CB901D7F0A609A92F@NAMPRD84.PROD.OUTLOOK.COM>
MIME-Version: 1.0
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
To: "david@fromorbit.com" <david@fromorbit.com>
Cc: "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>, "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>
List-ID: <linux-nvdimm@lists.01.org>

On Sat, 2018-01-13 at 08:19 +1100, Dave Chinner wrote:
 :
> IOWs, what you are seeing is trying to do a very large allocation on
> a very small (8GB) XFS filesystem.  It's rare someone asks to
> allocate >25% of the filesystem space in one allocation, so it's not
> surprising it triggers ENOSPC-like algorithms because it doesn't fit
> into a single AG....
> 
> We can probably look to optimise this, but I'm not sure if we can
> easily differentiate this case (i.e. allocation request larger than
> continguous free space) from the same situation near ENOSPC when we
> really do have to trim to fit...
> 
> Remember: stripe unit allocation alignment is a hint in XFS that we
> can and do ignore when necessary - it's not a binding rule.

Thanks for the clarification!  Can XFS allocate smaller extents so that
each extent will fit to an AG?  ext4 creates multiple smaller extents
for the same request.

-Toshi
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
