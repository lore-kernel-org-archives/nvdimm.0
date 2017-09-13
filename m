Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mx1.suse.de (mx2.suse.de [195.135.220.15])
 (using TLSv1 with cipher ECDHE-RSA-AES256-SHA (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 55E3121E8798E
 for <linux-nvdimm@lists.01.org>; Wed, 13 Sep 2017 07:45:42 -0700 (PDT)
Date: Wed, 13 Sep 2017 16:48:38 +0200
From: Jan Kara <jack@suse.cz>
Subject: Re: Unexpected writes seen on a Read-only, DAX enabled EXT4 fs
Message-ID: <20170913144838.GA3837@quack2.suse.cz>
References: <2036030243.251059.1504977026265.ref@mail.yahoo.com>
 <2036030243.251059.1504977026265@mail.yahoo.com>
 <20170911182112.GA20005@linux.intel.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20170911182112.GA20005@linux.intel.com>
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
To: Ross Zwisler <ross.zwisler@linux.intel.com>
Cc: linux-ext4@vger.kernel.org, "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>
List-ID: <linux-nvdimm@lists.01.org>

On Mon 11-09-17 12:21:12, Ross Zwisler wrote:
> On Sat, Sep 09, 2017 at 05:10:26PM +0000, Soccer Liu wrote:
> > Hi:
> > =A0 I was surprised to see a few write operations called into
> > ext4_dax_huge_fault with FAULT_FLAG_WRITE set on vmf->flags
> > Are those writes expected at all?
> > static int ext4_dax_huge_fault(struct vm_fault *vmf,
> >  enum page_entry_size pe_size)
> > {
> > ...
> >  bool write =3D vmf->flags & FAULT_FLAG_WRITE;
> > Based on the following Mount documentation below, I did mount this ext =
fs
> > with ro and noloadAre there any other options that I could use to total=
ly
> > eliminate those unexpected writes?

Well, I expect these are actually 4KB faults into private mapping (they
would end up using ext4_dax_huge_fault() as well) and the fix Ross
references below should fix that... But please tell if it does not (along
with a reproducer). Thanks!

> Adding the ext4 list.
> =

> I'm pretty sure that this is ext4/mm behavior that is independent of DAX.=
  DAX
> doesn't really have any impact on whether or not write page faults happen=
 on a
> RO ext4 filesystem, though this fix from Randy Dodgen:
> =

> https://www.spinics.net/lists/linux-ext4/msg58075.html
> =

> shows that FAULT_FLAG_WRITE can be set on DAX read-only ext4 mounts when
> executing binaries, though in this case the write is going to a COW page.

								Honza

-- =

Jan Kara <jack@suse.com>
SUSE Labs, CR
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
