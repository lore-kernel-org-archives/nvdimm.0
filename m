Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga18.intel.com (mga18.intel.com [134.134.136.126])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 11271211A3220
 for <linux-nvdimm@lists.01.org>; Wed, 13 Jun 2018 15:33:24 -0700 (PDT)
Date: Wed, 13 Jun 2018 16:33:23 -0600
From: Ross Zwisler <ross.zwisler@linux.intel.com>
Subject: Re: [fstests PATCH] generic/223: skip when using DAX
Message-ID: <20180613223323.GA11638@linux.intel.com>
References: <20180613210742.28148-1-ross.zwisler@linux.intel.com>
 <20180613222558.GA9432@magnolia>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20180613222558.GA9432@magnolia>
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
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: Eryu Guan <eguan@redhat.com>, fstests@vger.kernel.org, linux-nvdimm@lists.01.org
List-ID: <linux-nvdimm@lists.01.org>

On Wed, Jun 13, 2018 at 03:25:58PM -0700, Darrick J. Wong wrote:
> On Wed, Jun 13, 2018 at 03:07:42PM -0600, Ross Zwisler wrote:
> > As of these upstream kernel commits:
> > 
> > commit 6e2608dfd934 ("xfs, dax: introduce xfs_dax_aops")
> > commit 5f0663bb4a64 ("ext4, dax: introduce ext4_dax_aops")
> > 
> > generic/223 fails on XFS and ext4 because filesystems mounted with DAX no
> > longer support bmap.  This is desired behavior and will not be fixed,
> > according to:
> > 
> > https://lists.01.org/pipermail/linux-nvdimm/2018-April/015383.html
> > 
> > So, just skip over generic/223 when using DAX so we don't throw false
> > positive test failures.
> 
> Just because we decided not to support FIBMAP on XFSDAX doesn't mean we
> should let this test bitrot. :)
> 
> Just out of curiosity, does the following patch fix g/223 for you?

Yep!  This makes generic/223 pass in my setup for both DAX and non-DAX, with
both XFS and ext4.
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
