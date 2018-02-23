Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga11.intel.com (mga11.intel.com [192.55.52.93])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id ECC482034D8EB
 for <linux-nvdimm@lists.01.org>; Fri, 23 Feb 2018 13:50:21 -0800 (PST)
Date: Fri, 23 Feb 2018 14:56:22 -0700
From: Ross Zwisler <ross.zwisler@linux.intel.com>
Subject: Re: [ndctl PATCH] ndctl, test: kill usage of fallocate in
 firmware-update.sh
Message-ID: <20180223215622.GA3413@linux.intel.com>
References: <151936916209.18166.8915957818264326430.stgit@dwillia2-desk3.amr.corp.intel.com>
 <20180223205851.GB7750@linux.intel.com>
 <CAPcyv4izYKJ4=qxg5rGx4KOnpyb+8TakJK-ZfoEPnNV37GBF9w@mail.gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <CAPcyv4izYKJ4=qxg5rGx4KOnpyb+8TakJK-ZfoEPnNV37GBF9w@mail.gmail.com>
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
To: Dan Williams <dan.j.williams@intel.com>
Cc: linux-nvdimm@lists.01.org
List-ID: <linux-nvdimm@lists.01.org>

On Fri, Feb 23, 2018 at 01:45:40PM -0800, Dan Williams wrote:
> On Fri, Feb 23, 2018 at 12:58 PM, Ross Zwisler
> <ross.zwisler@linux.intel.com> wrote:
> > On Thu, Feb 22, 2018 at 10:59:22PM -0800, Dan Williams wrote:
> >> The 'fallocate -l 196608 $image' step in the test fails when $image is
> >> on an NFS mount. Use dd instead to create a sparse file. We do not need
> >> to allocate anything since we are only writing zeros.
> >>
> >> Cc: Dave Jiang <dave.jiang@intel.com>
> >> Signed-off-by: Dan Williams <dan.j.williams@intel.com>
> >> ---
> >>  test/firmware-update.sh |    2 +-
> >>  1 file changed, 1 insertion(+), 1 deletion(-)
> >>
> >> diff --git a/test/firmware-update.sh b/test/firmware-update.sh
> >> index 0d5bcdb3cc42..173647218c28 100755
> >> --- a/test/firmware-update.sh
> >> +++ b/test/firmware-update.sh
> >> @@ -49,7 +49,7 @@ detect()
> >>
> >>  do_tests()
> >>  {
> >> -     fallocate -l 196608 $image
> >> +     dd if=/dev/zero of=$image bs=1 count=1 skip=196607
> >>       $ndctl update-firmware -d $dev -f $image
> >>  }
> >
> > Hmm, I'm not seeing this failure in my NFS based setup.  Out of curiosity, do
> > you know why it's failing?  Some difference in our NFS configs?
> 
> Probably, here are my mount options:
> 
> root on / type nfs4
> (rw,relatime,vers=4.0,rsize=1048576,wsize=1048576,namlen=255,hard,proto=tcp,timeo=600,retrans=2,sec=sys,clientaddr=192.168.100.127,local_lock=none,addr=192.168.100.1)
> 
> > Anyway, this seems fine, but
> >
> > fallocate -l 196608 $image
> >
> > does the same thing and seems a little simpler, IMO.
> 
> Not simpler if it randomly fails depending on the filesystem, and
> there is no need to allocate that space since we're just creating a
> file full of zeros.

sorry, I meant "truncate -s 196608 $image".

Anyway, this is fine with either dd or truncate.   I agree that not actually
reserving filesystem space is a win.

Reviewed-by: Ross Zwisler <ross.zwisler@linux.intel.com>
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
