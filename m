Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-oi0-x244.google.com (mail-oi0-x244.google.com
 [IPv6:2607:f8b0:4003:c06::244])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id E76712097E26F
 for <linux-nvdimm@lists.01.org>; Tue, 26 Jun 2018 09:33:00 -0700 (PDT)
Received: by mail-oi0-x244.google.com with SMTP id f79-v6so16596896oib.7
 for <linux-nvdimm@lists.01.org>; Tue, 26 Jun 2018 09:33:00 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1530030454.27147.23.camel@intel.com>
References: <20180626153736.6770-1-keith.busch@intel.com>
 <20180626153736.6770-3-keith.busch@intel.com>
 <1530029963.27147.21.camel@intel.com>
 <20180626162924.GB6754@localhost.localdomain>
 <1530030454.27147.23.camel@intel.com>
From: Dan Williams <dan.j.williams@intel.com>
Date: Tue, 26 Jun 2018 09:32:59 -0700
Message-ID: <CAPcyv4hzER7RpeHnsEAJdsnb8CzruZdoK2m3hKVeAsJXkC_ryg@mail.gmail.com>
Subject: Re: [PATCH] ndctl: Use max_available_extent for creating namespaces
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
To: "Verma, Vishal L" <vishal.l.verma@intel.com>
Cc: "y-goto@jp.fujitsu.com" <y-goto@jp.fujitsu.com>, "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>
List-ID: <linux-nvdimm@lists.01.org>

On Tue, Jun 26, 2018 at 9:27 AM, Verma, Vishal L
<vishal.l.verma@intel.com> wrote:
> On Tue, 2018-06-26 at 10:29 -0600, Keith Busch wrote:
>> On Tue, Jun 26, 2018 at 09:19:28AM -0700, Verma, Vishal L wrote:
>> > On Tue, 2018-06-26 at 09:37 -0600, Keith Busch wrote:
>> > > The available_size attribute returns all the unused regions, but a
>> > > namespace has to use contiguous free regions. This patch uses the
>> > > attribute returning the largest capacity that can be created for
>> > > determining if the namespace can be created.
>> > >
>> > > Signed-off-by: Keith Busch <keith.busch@intel.com>
>> > > ---
>> > >  ndctl/lib/libndctl.c   | 30 ++++++++++++++++++++++++++++++
>> > >  ndctl/lib/libndctl.sym |  1 +
>> > >  ndctl/libndctl.h       |  2 ++
>> > >  ndctl/namespace.c      |  2 +-
>> > >  4 files changed, 34 insertions(+), 1 deletion(-)
>> >
>> > Hi Keith,
>> >
>> > The patch looks good, but just a couple of 'meta' comments.
>> > 1. We typically send ndctl patches separately from kernel patches (i.e.
>> > not
>> > thraded together).
>> > 2. for ndctl patches, an 'ndctl PATCH' prefix is recommended. You can
>> > set a
>> > repo local config parameter for doing this automatically on git format-
>> > patch.
>> >     git config format.subjectprefix "ndctl PATCH"
>> >
>> > I'm thinking the kernel changes will be queued for 4.19, which means
>> > the
>> > ndctl changes will go into v62.
>>
>> Thanks for the info. I'll make those changes for next time.
>>
>> I think I may need to send a v2 for this. Should we have this fall back
>> to
>> the available_size for the older kernels where the max_available_extents
>> attribute is not provided? I actually had that in my repo and used a
>> slightly older patch here, but I'm not sure if its okay to strongly
>> couple an ndctl release to a kernel version.
>
> I was thinking that too. Typically we don't guarantee ndctl to work with
> old kernels, but this does seem like a bit of an invasive change.
>
> Dan, thoughts?

It should fall back if the attribute is not available. Our *tests*
aren't guaranteed to pass on older kernels, but ndctl proper should
try it's best to accommodate old kernels.
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
