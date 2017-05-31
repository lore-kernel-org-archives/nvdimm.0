Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from newverein.lst.de (verein.lst.de [213.95.11.211])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id C5EE121A09124
 for <linux-nvdimm@lists.01.org>; Wed, 31 May 2017 12:39:13 -0700 (PDT)
Date: Wed, 31 May 2017 21:40:12 +0200
From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH 08/24] uuid: rename uuid_to_bin to uuid_parse
Message-ID: <20170531194012.GC6906@lst.de>
References: <20170531161826.23243-1-hch@lst.de>
 <20170531161826.23243-9-hch@lst.de>
 <1496254475.28981.36.camel@linux.intel.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1496254475.28981.36.camel@linux.intel.com>
List-Unsubscribe: <https://lists.01.org/mailman/options/linux-nvdimm>,
 <mailto:linux-nvdimm-request@lists.01.org?subject=unsubscribe>
List-Archive: <http://lists.01.org/pipermail/linux-nvdimm/>
List-Post: <mailto:linux-nvdimm@lists.01.org>
List-Help: <mailto:linux-nvdimm-request@lists.01.org?subject=help>
List-Subscribe: <https://lists.01.org/mailman/listinfo/linux-nvdimm>,
 <mailto:linux-nvdimm-request@lists.01.org?subject=subscribe>
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Errors-To: linux-nvdimm-bounces@lists.01.org
Sender: "Linux-nvdimm" <linux-nvdimm-bounces@lists.01.org>
To: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Cc: linux-xfs@vger.kernel.org, linux-raid@vger.kernel.org, linux-nvdimm@lists.01.org, Mimi Zohar <zohar@linux.vnet.ibm.com>, Amir Goldstein <amir73il@gmail.com>, linux-kernel@vger.kernel.org, Steven Whitehouse <swhiteho@redhat.com>, David Howells <dhowells@redhat.com>, linux-block@vger.kernel.org, linux-fsdevel@vger.kernel.org, Shaohua Li <shli@kernel.org>, Christoph Hellwig <hch@lst.de>
List-ID: <linux-nvdimm@lists.01.org>

On Wed, May 31, 2017 at 09:14:35PM +0300, Andy Shevchenko wrote:
> On Wed, 2017-05-31 at 18:18 +0200, Christoph Hellwig wrote:
> > This matches the userspace version of it, and describes the
> > functionality
> > much better.=A0=A0Also do the same for the guid version.
> > =

> =

> No objections for renaming, though I'm pretty sure it should be squashed
> to patch 6.

Fine with me, it just seemed like a unrelated enough change to justify
keeping it separate.
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
