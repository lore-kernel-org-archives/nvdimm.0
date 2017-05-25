Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from newverein.lst.de (verein.lst.de [213.95.11.211])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 9A62421A08D84
 for <linux-nvdimm@lists.01.org>; Thu, 25 May 2017 06:00:29 -0700 (PDT)
Date: Thu, 25 May 2017 15:00:27 +0200
From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH 10/23] afs: switch to use uuid_t and uuid_gen
Message-ID: <20170525130027.GA30194@lst.de>
References: <20170518062705.25902-1-hch@lst.de>
 <20170518062705.25902-11-hch@lst.de>
 <1495478957.6967.69.camel@linux.intel.com> <20170523084956.GB20121@lst.de>
 <1495545099.6967.81.camel@linux.intel.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1495545099.6967.81.camel@linux.intel.com>
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
To: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Cc: linux-xfs@vger.kernel.org, linux-raid@vger.kernel.org, linux-nvdimm@lists.01.org, Mimi Zohar <zohar@linux.vnet.ibm.com>, Amir Goldstein <amir73il@gmail.com>, linux-kernel@vger.kernel.org, Steven Whitehouse <swhiteho@redhat.com>, David Howells <dhowells@redhat.com>, linux-fsdevel@vger.kernel.org, Shaohua Li <shli@kernel.org>, Christoph Hellwig <hch@lst.de>
List-ID: <linux-nvdimm@lists.01.org>

On Tue, May 23, 2017 at 04:11:39PM +0300, Andy Shevchenko wrote:
> Since we introduced a union it's possible that we might access the
> member which wasn't last modified one. So, my comment is to give an
> attention on such possibility and avoid if there is an aliasing
> happened.

We do for AFS (and XFS for fs fsid).  My preference would be to
not have the v1 struct defintion but instead provide a few
helpers in uuid.h that use get_unaligned_be* if needed:

	uuid_v1_time_low()
	uuid_v1_time_mid()
	uuid_v1_time_time_hi_and_version()..

>From his previously reply it seems like Dave doesn't like that idea
too much, in which case I suspect moving struct uuid_v1 back into
afs and living with cast in it is the way to go.
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
