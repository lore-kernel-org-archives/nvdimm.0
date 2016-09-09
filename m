Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-lf0-x244.google.com (mail-lf0-x244.google.com
 [IPv6:2a00:1450:4010:c07::244])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 680191A1DF8
 for <linux-nvdimm@lists.01.org>; Fri,  9 Sep 2016 11:38:01 -0700 (PDT)
Received: by mail-lf0-x244.google.com with SMTP id s64so3111562lfs.2
 for <linux-nvdimm@lists.01.org>; Fri, 09 Sep 2016 11:38:01 -0700 (PDT)
Date: Fri, 9 Sep 2016 21:37:56 +0300
From: "Kirill A. Shutemov" <kirill@shutemov.name>
Subject: Re: [PATCH v4 RESEND 0/2] Align mmap address for DAX pmd mappings
Message-ID: <20160909183756.GA30528@node>
References: <1472497881-9323-1-git-send-email-toshi.kani@hpe.com>
 <20160829204842.GA27286@node.shutemov.name>
 <1472506310.1532.47.camel@hpe.com>
 <1472508000.1532.59.camel@hpe.com> <20160908105707.GA17331@node>
 <1473342519.2092.42.camel@hpe.com>
 <1473376846.2092.69.camel@hpe.com>
 <20160909123608.GA75965@black.fi.intel.com>
 <1473441640.2092.74.camel@hpe.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1473441640.2092.74.camel@hpe.com>
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
To: "Kani, Toshimitsu" <toshi.kani@hpe.com>
Cc: "tytso@mit.edu" <tytso@mit.edu>, "mawilcox@microsoft.com" <mawilcox@microsoft.com>, "david@fromorbit.com" <david@fromorbit.com>, "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>, "hughd@google.com" <hughd@google.com>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "linux-mm@kvack.org" <linux-mm@kvack.org>, "adilger.kernel@dilger.ca" <adilger.kernel@dilger.ca>, "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>, "jack@suse.cz" <jack@suse.cz>, "akpm@linux-foundation.org" <akpm@linux-foundation.org>, "kirill.shutemov@linux.intel.com" <kirill.shutemov@linux.intel.com>, "mike.kravetz@oracle.com" <mike.kravetz@oracle.com>
List-ID: <linux-nvdimm@lists.01.org>

On Fri, Sep 09, 2016 at 05:21:40PM +0000, Kani, Toshimitsu wrote:
> On Fri, 2016-09-09 at 15:36 +0300, Kirill A. Shutemov wrote:
> > On Thu, Sep 08, 2016 at 11:21:46PM +0000, Kani, Toshimitsu wrote:
> > > =

> > > On Thu, 2016-09-08 at 07:48 -0600, Kani, Toshimitsu wrote:
> > > > =

> > > > On Thu, 2016-09-08 at 13:57 +0300, Kirill A. Shutemov wrote:
> > > > > =

> > > > > On Mon, Aug 29, 2016 at 10:00:43PM +0000, Kani, Toshimitsu
> > > > > wrote:
> > > =A0:
> > > > > > Looking further, these shmem_huge handlings only check pre-
> > > > > > conditions.=A0=A0So,=A0we=A0should=A0be=A0able=A0to=A0make=A0sh=
mem_get_unmapped
> > > > > > _are a() as a wrapper, which checks such shmem-specific
> > > > > > conitions, and then=A0call=A0__thp_get_unmapped_area() for the
> > > > > > actual work. =A0All DAX-specific checks are performed in
> > > > > > thp_get_unmapped_area() as well. =A0We can make
> > > > > > =A0__thp_get_unmapped_area() as a common
> > > > > > function.
> > > > > > =

> > > > > > I'd prefer to make such change as a separate item,
> > > > > =

> > > > > Do you have plan to submit such change?
> > > > =

> > > > Yes, I will submit the change once I finish testing.
> > > =

> > > I found a bug in the current code, and need some clarification.
> > > =A0The if-statement below is reverted.
> > =

> > <two-hands-facepalm>
> > =

> > Yeah. It was repored by Hillf[1]. The fixup got lost. :(
> > =

> > Could you post a proper patch with the fix?
> >
> > I would be nice to credit Hillf there too.
> > =

> > [1] http://lkml.kernel.org/r/054f01d1c86f$2994d5c0$7cbe8140$@alibaba-
> > inc.com
> =

> Yes, I will submit the fix as well.
> =

> I will not change the default value of sbinfo->huge in this fix. =A0So,
> user will have to specify "huge=3D" option to enable huge page mappings.
> =A0If this is not desireable, we will need a separate patch.

That's okay. I only screwed up part wich make vma aligned. Allocation of
huge page happens under right condition.

-- =

 Kirill A. Shutemov
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
