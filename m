Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-ot0-x242.google.com (mail-ot0-x242.google.com
 [IPv6:2607:f8b0:4003:c0f::242])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 17C572097DD3D
 for <linux-nvdimm@lists.01.org>; Tue, 29 May 2018 13:26:34 -0700 (PDT)
Received: by mail-ot0-x242.google.com with SMTP id 15-v6so18501722otn.12
 for <linux-nvdimm@lists.01.org>; Tue, 29 May 2018 13:26:34 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20180523205017.0f2bc83e@thinkpad>
References: <152658753673.26786.16458605771414761966.stgit@dwillia2-desk3.amr.corp.intel.com>
 <20180518094616.GA25838@lst.de>
 <CAPcyv4iO1yss0sfBzHVDy3qja_wc+JT2Zi1zwtApDckTeuG2wQ@mail.gmail.com>
 <20180521090410.7ygosxzjfhceqrq4@quack2.suse.cz>
 <20180522062806.GD7816@lst.de> <20180523205017.0f2bc83e@thinkpad>
From: Dan Williams <dan.j.williams@intel.com>
Date: Tue, 29 May 2018 13:26:33 -0700
Message-ID: <CAPcyv4gRvG=yT==SPgF940F7v9FqGqG-dQ8Vjcm0LPch86i1RA@mail.gmail.com>
Subject: Re: [PATCH v10] mm: introduce MEMORY_DEVICE_FS_DAX and
 CONFIG_DEV_PAGEMAP_OPS
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
To: Gerald Schaefer <gerald.schaefer@de.ibm.com>
Cc: Michal Hocko <mhocko@suse.com>, Jan Kara <jack@suse.cz>, kbuild test robot <lkp@intel.com>, linux-nvdimm <linux-nvdimm@lists.01.org>, Heiko Carstens <heiko.carstens@de.ibm.com>, Linux MM <linux-mm@kvack.org>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, =?UTF-8?B?SsOpcsO0bWUgR2xpc3Nl?= <jglisse@redhat.com>, Martin Schwidefsky <schwidefsky@de.ibm.com>, Christoph Hellwig <hch@lst.de>, Thomas Meyer <thomas@m3y3r.de>
List-ID: <linux-nvdimm@lists.01.org>

On Wed, May 23, 2018 at 11:50 AM, Gerald Schaefer
<gerald.schaefer@de.ibm.com> wrote:
> On Tue, 22 May 2018 08:28:06 +0200
> Christoph Hellwig <hch@lst.de> wrote:
>
>> On Mon, May 21, 2018 at 11:04:10AM +0200, Jan Kara wrote:
>> > We definitely do have customers using "execute in place" on s390x from
>> > dcssblk. I've got about two bug reports for it when customers were updating
>> > from old kernels using original XIP to kernels using DAX. So we need to
>> > keep that working.
>>
>> That is all good an fine, but I think time has come where s390 needs
>> to migrate to provide the pmem API so that we can get rid of these
>> special cases.  Especially given that the old XIP/legacy DAX has all
>> kinds of known bugs at this point in time.
>
> I haven't yet looked at this patch series, but I can feel that this
> FS_DAX_LIMITED workaround is beginning to cause some headaches, apart
> from being quite ugly of course.
>
> Just to make sure I still understand the basic problem, which I thought
> was missing struct pages for the dcssblk memory, what exactly do you
> mean with "provide the pmem API", is there more to do?

No, just 'struct page' is needed.

What used to be the pmem API is now pushed down into to dax_operations
provided by the device driver. dcssblk is free to just redirect to the
generic implementations for copy_from_iter() and copy_to_iter(), and
be done. I.e. we've removed the "pmem API" requirement.

> I do have a prototype patch lying around that adds struct pages, but
> didn't yet have time to fully test/complete it. Of course we initially
> introduced XIP as a mechanism to reduce memory consumption, and that
> is probably the use case for the remaining customer(s). Adding struct
> pages would somehow reduce that benefit, but as long as we can still
> "execute in place", I guess it will be OK.

The pmem driver has the option to allocate the 'struct page' map out
of pmem directly. If the overhead of having the map in System RAM is
too high it could borrow the same approach, but that adds another
degree of configuration complexity freedom.
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
