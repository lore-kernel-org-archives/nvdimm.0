Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from newverein.lst.de (verein.lst.de [213.95.11.211])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 626D021A09124
 for <linux-nvdimm@lists.01.org>; Wed, 31 May 2017 12:38:50 -0700 (PDT)
Date: Wed, 31 May 2017 21:39:48 +0200
From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH 15/24] block: remove blk_part_pack_uuid
Message-ID: <20170531193948.GB6906@lst.de>
References: <20170531161826.23243-1-hch@lst.de>
 <20170531161826.23243-16-hch@lst.de>
 <1496254594.28981.37.camel@linux.intel.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1496254594.28981.37.camel@linux.intel.com>
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

On Wed, May 31, 2017 at 09:16:34PM +0300, Andy Shevchenko wrote:
> On Wed, 2017-05-31 at 18:18 +0200, Christoph Hellwig wrote:
> > This helper was only used by IMA of all things, which would get
> > spurious
> > errors if CONFIG_BLOCK is disabled.=A0=A0Just opencode the call there.
> =

> > -			result =3D blk_part_pack_uuid(args[0].from,
> > -						=A0=A0=A0=A0entry->fsuuid);
> > +			result =3D uuid_to_bin(args[0].from, (uuid_t
> > *)&entry->fsuuid);
> > =

> =

> uuid_parse() ?

Yes.  I fixed this up, but it seems like I didn't squash it into
the right patch..
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
