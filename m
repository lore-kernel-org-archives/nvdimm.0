Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id D084A2194EB78
 for <linux-nvdimm@lists.01.org>; Thu, 14 Feb 2019 11:10:17 -0800 (PST)
Date: Thu, 14 Feb 2019 14:10:14 -0500
From: Jerome Glisse <jglisse@redhat.com>
Subject: Re: [Lsf-pc] [LSF/MM TOPIC] The end of the DAX experiment
Message-ID: <20190214191013.GA3420@redhat.com>
References: <CAPcyv4jyCDJTpGZB6qVX7_FiaxJfDzWA1cw8dfPjHM2j3j3yqQ@mail.gmail.com>
 <20190214134622.GG4525@dhcp22.suse.cz>
 <CAPcyv4gxFKBQ9eVdn+pNEzBXRfw6Qwfmu21H2i5uj-PyFmRAGQ@mail.gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <CAPcyv4gxFKBQ9eVdn+pNEzBXRfw6Qwfmu21H2i5uj-PyFmRAGQ@mail.gmail.com>
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
Cc: lsf-pc@lists.linux-foundation.org, linux-nvdimm <linux-nvdimm@lists.01.org>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, Michal Hocko <mhocko@kernel.org>, linux-xfs <linux-xfs@vger.kernel.org>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, linux-ext4 <linux-ext4@vger.kernel.org>
List-ID: <linux-nvdimm@lists.01.org>

On Thu, Feb 14, 2019 at 10:25:07AM -0800, Dan Williams wrote:
> On Thu, Feb 14, 2019 at 5:46 AM Michal Hocko <mhocko@kernel.org> wrote:
> >
> > On Wed 06-02-19 13:12:59, Dan Williams wrote:
> > [...]
> > > * Userfaultfd for file-backed mappings and DAX
> >
> > I assume that other topics are meant to be FS track but this one is MM,
> > right?
> =

> Yes, but I think it is the lowest priority of all the noted sub-topics
> in this proposal. The DAX-reflink discussion, where a given
> physical-page may need to be mapped into multiple inodes at different
> offsets, might be more fruitful to have as a joint discussion with MM.

Note that my generic page write protection work can be use for that ie
having a single page correspond to multiple different mapping with also
different offset within each mapping. While in my patchset i only solve
the mapping aliasing issue, the index can be solve in much the same way
because same thinking apply. Namely that when you work on a file you
know the mapping and file offset and thus the index and when you work on
the vma you know the mapping and offset within the vma which translate
to offset within the file. They are only few places that do not have the
informations available and those do not care about it.

I am just again working on my struct page mapping patchset as well as
the generic page write protection that sits on top. I hope to be able
to post the v2 in couple weeks. You can always look at my posting last
year to see more details.

Cheers,
J=E9r=F4me
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
