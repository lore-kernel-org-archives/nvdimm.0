Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mx2.suse.de (mx2.suse.de [195.135.220.15])
 (using TLSv1 with cipher ECDHE-RSA-AES256-SHA (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 76DF61A1DF7
 for <linux-nvdimm@lists.01.org>; Fri, 20 May 2016 01:01:45 -0700 (PDT)
Date: Fri, 20 May 2016 10:01:36 +0200
From: Johannes Thumshirn <jthumshirn@suse.de>
Subject: Re: [PATCH v3 2/5] /dev/dax, pmem: direct access to persistent memory
Message-ID: <20160520080136.GG4413@c203.arch.suse.de>
References: <146360496572.37439.6497663679891935585.stgit@dwillia2-desk3.amr.corp.intel.com>
 <146360497642.37439.12866290214925858506.stgit@dwillia2-desk3.amr.corp.intel.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <146360497642.37439.12866290214925858506.stgit@dwillia2-desk3.amr.corp.intel.com>
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
To: Dan Williams <dan.j.williams@intel.com>
Cc: linux-nvdimm@lists.01.org, Dave Hansen <dave.hansen@linux.intel.com>, linux-kernel@vger.kernel.org, linux-block@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>, hch@lst.de
List-ID: <linux-nvdimm@lists.01.org>

On Wed, May 18, 2016 at 01:56:16PM -0700, Dan Williams wrote:
> Device DAX is the device-centric analogue of Filesystem DAX
> (CONFIG_FS_DAX).  It allows memory ranges to be allocated and mapped
> without need of an intervening file system.  Device DAX is strict,
> precise and predictable.  Specifically this interface:
> =

> 1/ Guarantees fault granularity with respect to a given page size (pte,
> pmd, or pud) set at configuration time.
> =

> 2/ Enforces deterministic behavior by being strict about what fault
> scenarios are supported.
> =

> For example, by forcing MADV_DONTFORK semantics and omitting MAP_PRIVATE
> support device-dax guarantees that a mapping always behaves/performs the
> same once established.  It is the "what you see is what you get" access
> mechanism to differentiated memory vs filesystem DAX which has
> filesystem specific implementation semantics.
> =

> Persistent memory is the first target, but the mechanism is also
> targeted for exclusive allocations of performance differentiated memory
> ranges.
> =

> This commit is limited to the base device driver infrastructure to
> associate a dax device with pmem range.
> =

> Cc: Jeff Moyer <jmoyer@redhat.com>
> Cc: Christoph Hellwig <hch@lst.de>
> Cc: Andrew Morton <akpm@linux-foundation.org>
> Cc: Dave Hansen <dave.hansen@linux.intel.com>
> Cc: Ross Zwisler <ross.zwisler@linux.intel.com>
> Signed-off-by: Dan Williams <dan.j.williams@intel.com>

Reviewed-by: Johannes Thumshirn <jthumshirn@suse.de>

-- =

Johannes Thumshirn                                          Storage
jthumshirn@suse.de                                +49 911 74053 689
SUSE LINUX GmbH, Maxfeldstr. 5, 90409 N=FCrnberg
GF: Felix Imend=F6rffer, Jane Smithard, Graham Norton
HRB 21284 (AG N=FCrnberg)
Key fingerprint =3D EC38 9CAB C2C4 F25D 8600 D0D0 0393 969D 2D76 0850
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
